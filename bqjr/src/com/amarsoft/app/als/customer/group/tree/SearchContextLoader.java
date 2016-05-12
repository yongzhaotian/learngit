package com.amarsoft.app.als.customer.group.tree;

import java.util.List;

import com.amarsoft.app.als.customer.group.tree.component.FacesContext;
import com.amarsoft.app.als.customer.group.tree.component.FamilyTreeNode;
import com.amarsoft.app.als.customer.group.tree.component.UIComponent;
import com.amarsoft.are.ARE;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.ql.Parser;
import com.amarsoft.awe.util.Transaction;

/**
 * @author syang
 * @date 2011-08-16
 * @describe 集团客户家谱关联关系搜索
 */
public class SearchContextLoader {
    private String groupID = ""; //集团客户编号
    private String groupName = ""; //集团客户名称
    private String customerID = ""; //搜索起点客户编号
    private String customerName = ""; //搜索起点客户名称
    private String fundRela = ""; //资金关联关系
    private String personRela = ""; //人员关联关系
    private String personNode = ""; //人员节点
    private String otherRela = ""; //其他关联关系
    private String assureRela = ""; //担保关联关系
    private int searchlevel = 5; //搜索层次,默认搜索5层
    private double lowerLimit = 0; //资金比例下限
    private String versionSeq = "";	
    protected Transaction Sqlca;
	
	private FacesContext context = null;
	private String groupId;

	/**
	 * 获取一个上下文容器
	 * @return
	 */
	public FacesContext getContext() {
		if(context==null)init();
		return context;
	}
	/**
	 * 执行初始化
	 */
	private void init(){
		context = new FacesContext();
		try {
		
			FamilyTreeNode rootNode = null;
        	if(customerID.equals(groupID)){ //搜索起点为集团母公司
        		initGroupCustomer();
        		rootNode = (FamilyTreeNode)context.createComponent(groupID, FamilyTreeNode.class);
        		rootNode.setMemberName(groupName);
        	}else{
        		rootNode = (FamilyTreeNode)context.createComponent(customerID, FamilyTreeNode.class);
        		rootNode.setMemberName(customerName);
        	}
        	initChildren(rootNode,0);
        	context.setRootComponent(rootNode);
		} catch (Exception e) {
			ARE.getLog().error("读取数据出错",e);
			e.printStackTrace();
		}
	}
	private void initGroupCustomer() throws JBOException{
    	JBOFactory f = JBOFactory.getFactory();
    	BizObject bo = null;
		BizObjectQuery q = f.getManager("jbo.app.GROUP_INFO").createQuery("GroupID=:GroupID").setParameter("GroupID", groupID);
		bo = q.getSingleResult();
		groupName = bo.getAttribute("GroupName").toString();
		versionSeq = bo.getAttribute("CurrentVersionSeq").toString();
	}
	/**
	 * 获取客户关联关系列表
	 * @param customerId
	 * @return
	 * @throws JBOException 
	 */
	@SuppressWarnings("unchecked")
	private List<BizObject> getCustomerRelativeList(String customerId) throws JBOException{
		JBOFactory f = JBOFactory.getFactory();
		BizObjectManager bom = f.getManager("jbo.app.CUSTOMER_RELATIVE");
		BizObjectQuery q = bom.createQuery("select RelativeID,CustomerName,RelationShip,CertID,CertType from o where CustomerID=:CustomerID and ("+getQuery()+") order by RelationShip ");
		q.setParameter("CustomerID",customerId);
		return q.getResultList();
	}
    /**
     * 取得query条件
     * @return
     */
    private String getQuery(){
    	String queryIn = " 1=2 ", queryNotIn = " 1=1 ";
    	boolean in1 = true, in2 = true, in3 = true;
    	String query1 = "",query2 = "",query3 = "";
    	if(fundRela.equals("holder")){ //股东资金关联
    		query1 = " RelationShip like '52%' ";
    	}else if(fundRela.equals("investor")){ //对外投资资金关联
    		query1 = " RelationShip like '02%' ";
    	}else if(fundRela.equals("allFundRela")){ //全部资金关联
    		query1 = " (RelationShip like '52%' or RelationShip like '02%')  ";
    	}else if(fundRela.equals("noFundRela")){ //不加入资金关联
    		query1 = " (RelationShip not like '52%' and RelationShip not like '02%') ";
    		in1 = false;
    	}
    	
    	if(lowerLimit >0 && !"".equals(query1)){ //设置了比例下限
			query1 = "("+query1+" and InvestmentProp >= "+lowerLimit+")" ;
		}
    	
    	if(personRela.equals("keyMan")){ //高管
    		query2 = " RelationShip like '01%' ";
    	}else if(personRela.equals("corpFamily")){ //法人代表家族成员
    		query2 = " RelationShip like '06%' ";
    	}else if(personRela.equals("allPersonRela")){ //全部人员关联
    		query2 = " (RelationShip like '01%' or RelationShip like '06%') ";
    	}else if(personRela.equals("noPersonRela")){ //不加入人员关联
    		query2 = " (RelationShip not like '01%' and RelationShip not like '06%')  ";
    		in2 = false;
	    }
    	
    	//其他关系选择
    	if(otherRela.equals("affiliated")){ //上下游关系
    		query3 = " RelationShip like '99%' ";
	    }else if(otherRela.equals("otherRela")){ //其它
	    	query3 = " ( RelationShip like '03%' or RelationShip like '05%' or RelationShip like '54%' or RelationShip like '55%' or RelationShip like '88%' ) ";
	    }else if(otherRela.equals("allOtherRela")){ //全部其他关联
	    	query3 = " ( RelationShip like '03%' or RelationShip like '05%' or RelationShip like '54%' or RelationShip like '55%' or RelationShip like '88%' or RelationShip like '99%' ) ";
	    }else if(otherRela.equals("noOtherRela")){ //不加入其他关联
	    	query3 = " ( RelationShip not like '03%' and RelationShip not like '05%' and RelationShip not like '54%' and RelationShip not like '55%' and RelationShip not like '88%' and RelationShip not like '99%' ) ";
	    	in3 = false;
	    }
    	
    	if(in1) queryIn += " or " + query1;
    	else queryNotIn += " and " + query1;
    	
		if(in2) queryIn += " or " + query2;
		else queryNotIn += " and " + query2;
    	
    	if(in3) queryIn += " or " + query3;
    	else queryNotIn += " and " + query3;
    	
    	return "(" + queryIn + ") and (" + queryNotIn + ")";
    }	
	/**
	 * 取担保客户
	 * @param customerId
	 * @return
	 * @throws JBOException
	 */
	@SuppressWarnings("unchecked")
	private List<BizObject> getAssureCustomerList(String customerId) throws JBOException{
		JBOFactory f = JBOFactory.getFactory();
		BizObjectQuery query1 = null;
		BizObjectQuery query2 = null;

		List<BizObject> jList = null;
		Parser.registerKeyWord("DISTINCT");
		BizObjectManager manager = f.getManager("jbo.app.GUARANTY_CONTRACT");
		//提供担保客户列表
		query1 = manager.createQuery("select distinct O.CustomerID as v.RelativeID,CI.CustomerName,'提供担保' as v.RelationShip,O.CertType from O,jbo.app.CUSTOMER_INFO CI" +
				" where O.CustomerID = CI.CustomerID and O.GuarantorID=:CustomerID");
		query1.setParameter("CustomerID", customerId);
		
		//被担保列表
		query2 = manager.createQuery("select distinct O.GuarantorID as v.RelativeID,O.GuarantorName as v.CustomerName,'被担保' as v.RelationShip,O.CertType from O where CustomerID=:CustomerID");
		query2.setParameter("CustomerID", customerId);
		
		//担保关联选择
		if("noAssureRela".equals(assureRela)){ 			//不加入担保关联
			
		}else if("offerAssure".equals(assureRela)){ 	//提供担保
			jList = query1.getResultList();
		}else if("acceptAssure".equals(assureRela)){ 	//被担保
			jList = query2.getResultList();
		}else if("allAssureRela".equals(assureRela)){ 	//全部担保关联
			jList = query1.getResultList();
			jList.addAll(query2.getResultList());
		}
		return jList;
	}
	/**
	 * 递归初始化子节点
	 * @param currentNode 当前节点
	 * @param depth 当前深度
	 * @throws Exception
	 */
    private void initChildren(FamilyTreeNode currentNode,int depth) throws Exception {
    	boolean notShowPersonNode = "PersonNodeNo".equals(personNode);	// 人员是否作为节点显示
    	String currentCustomerId = currentNode.getId();
    	
		List<BizObject> jList = getCustomerRelativeList(currentCustomerId);
        List<BizObject> assureList = getAssureCustomerList(currentCustomerId);
        if(assureList!=null&&!assureList.isEmpty())jList.addAll(assureList);
        
        if(jList.size()==0)return;
        //封装为节点对象
        for(int i=0;i<jList.size();i++){
            BizObject bo = (BizObject)jList.get(i);
            
            String relativeId = bo.getAttribute("RelativeID").getString();
            String certType = bo.getAttribute("CertType").getString();
            String certID = bo.getAttribute("CertID").getString();
            if(relativeId==null)relativeId="";
            if(certType==null)certType="";
            
            //搜不到下一关联客户、或返回为搜索节点客户、人员节点不显示，则结束搜索
            if("".equals(relativeId)
            		||customerID.equals(relativeId) 
            		|| currentCustomerId.equals(relativeId) 
            		|| (certType.startsWith("Ind") && notShowPersonNode)) continue;
            //添加子节点
            FamilyTreeNode node = createTreeNode(bo);
            if(node==null)continue;
            node.setParentId(currentCustomerId);
            node.setMemberCertType(certType);
            node.setMemberCertID(certID);
            context.appendChildComponent(currentNode, node, false);
            
            if(depth<searchlevel-1){//递归搜索
            	initChildren(node,depth+1);
            }
        }
    }	

	/**
	 * 从JBO对象中生成一个树图节点对象
	 * @param bo
	 * @return
	 * @throws Exception 
	 */
	public FamilyTreeNode createTreeNode(BizObject bo) throws Exception{
		
		//读取JBO数据
		String id = bo.getAttribute("RelativeID").getString();
		String label = bo.getAttribute("CustomerName").getString();
		String memberType = bo.getAttribute("RelationShip").getString();
		//将代码修改为名称
		if(memberType.equals("提供担保")||memberType.equals("被担保")){
			
		}else{
			 memberType=getItemName("RelationShip",memberType);
		}
		
		//生成bean
		FamilyTreeNode node = null;
		UIComponent component = (FamilyTreeNode)context.findComponent(id);
		//如果已经存在，则不需要再创建了 
		if(component==null){
			node = (FamilyTreeNode)context.createComponent(id, FamilyTreeNode.class);
			node.setLabel(label);
			node.setMemberName(label); 
			node.setMemberType(memberType);
		}
		return node;
	}
	
	/**
	 * 根据代码编号和代码项编号获取代码项名称
	 * @param codeNo,ItemNo
	 * @return
	 * @throws Exception 
	 */
	private String getItemName(String codeNo,String ItemNo) throws JBOException{
		JBOFactory f = JBOFactory.getFactory();
		BizObjectManager bom = f.getManager("jbo.sys.CODE_LIBRARY");
		BizObjectQuery q = bom.createQuery("select ItemName from o where CodeNo=:CodeNo and ItemNo=:ItemNo");
		q.setParameter("CodeNo",codeNo).setParameter("ItemNo",ItemNo);
		BizObject bo = q.getSingleResult();
		String sItemName="";
		if(bo != null){
			sItemName = bo.getAttribute("ItemName").getString();
		}
		return sItemName;
	}
	
	//-------------------------------------
	//getter and setter
	//-------------------------------------
	public String getGroupID() {
		return groupID;
	}
	public void setGroupID(String groupID) {
		this.groupID = groupID;
	}
	public String getGroupName() {
		return groupName;
	}
	public void setGroupName(String groupName) {
		this.groupName = groupName;
	}
	public String getCustomerID() {
		return customerID;
	}
	public void setCustomerID(String customerID) {
		this.customerID = customerID;
	}
	public String getCustomerName() {
		return customerName;
	}
	public void setCustomerName(String customerName) {
		this.customerName = customerName;
	}
	public String getFundRela() {
		return fundRela;
	}
	public void setFundRela(String fundRela) {
		this.fundRela = fundRela;
	}
	public String getPersonRela() {
		return personRela;
	}
	public void setPersonRela(String personRela) {
		this.personRela = personRela;
	}
	public String getPersonNode() {
		return personNode;
	}
	public void setPersonNode(String personNode) {
		this.personNode = personNode;
	}
	public String getOtherRela() {
		return otherRela;
	}
	public void setOtherRela(String otherRela) {
		this.otherRela = otherRela;
	}
	public String getAssureRela() {
		return assureRela;
	}
	public void setAssureRela(String assureRela) {
		this.assureRela = assureRela;
	}
	public int getSearchlevel() {
		return searchlevel;
	}
	public void setSearchlevel(int searchlevel) {
		this.searchlevel = searchlevel;
	}
	public double getLowerLimit() {
		return lowerLimit;
	}
	public void setLowerLimit(double lowerLimit) {
		this.lowerLimit = lowerLimit;
	}
	public String getVersionSeq() {
		return versionSeq;
	}
	public void setVersionSeq(String versionSeq) {
		this.versionSeq = versionSeq;
	}
	public String getGroupId() {
		return groupId;
	}
	public void setGroupId(String groupId) {
		this.groupId = groupId;
	}
	
}

