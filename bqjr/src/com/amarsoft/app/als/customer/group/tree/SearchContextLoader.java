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
 * @describe ���ſͻ����׹�����ϵ����
 */
public class SearchContextLoader {
    private String groupID = ""; //���ſͻ����
    private String groupName = ""; //���ſͻ�����
    private String customerID = ""; //�������ͻ����
    private String customerName = ""; //�������ͻ�����
    private String fundRela = ""; //�ʽ������ϵ
    private String personRela = ""; //��Ա������ϵ
    private String personNode = ""; //��Ա�ڵ�
    private String otherRela = ""; //����������ϵ
    private String assureRela = ""; //����������ϵ
    private int searchlevel = 5; //�������,Ĭ������5��
    private double lowerLimit = 0; //�ʽ��������
    private String versionSeq = "";	
    protected Transaction Sqlca;
	
	private FacesContext context = null;
	private String groupId;

	/**
	 * ��ȡһ������������
	 * @return
	 */
	public FacesContext getContext() {
		if(context==null)init();
		return context;
	}
	/**
	 * ִ�г�ʼ��
	 */
	private void init(){
		context = new FacesContext();
		try {
		
			FamilyTreeNode rootNode = null;
        	if(customerID.equals(groupID)){ //�������Ϊ����ĸ��˾
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
			ARE.getLog().error("��ȡ���ݳ���",e);
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
	 * ��ȡ�ͻ�������ϵ�б�
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
     * ȡ��query����
     * @return
     */
    private String getQuery(){
    	String queryIn = " 1=2 ", queryNotIn = " 1=1 ";
    	boolean in1 = true, in2 = true, in3 = true;
    	String query1 = "",query2 = "",query3 = "";
    	if(fundRela.equals("holder")){ //�ɶ��ʽ����
    		query1 = " RelationShip like '52%' ";
    	}else if(fundRela.equals("investor")){ //����Ͷ���ʽ����
    		query1 = " RelationShip like '02%' ";
    	}else if(fundRela.equals("allFundRela")){ //ȫ���ʽ����
    		query1 = " (RelationShip like '52%' or RelationShip like '02%')  ";
    	}else if(fundRela.equals("noFundRela")){ //�������ʽ����
    		query1 = " (RelationShip not like '52%' and RelationShip not like '02%') ";
    		in1 = false;
    	}
    	
    	if(lowerLimit >0 && !"".equals(query1)){ //�����˱�������
			query1 = "("+query1+" and InvestmentProp >= "+lowerLimit+")" ;
		}
    	
    	if(personRela.equals("keyMan")){ //�߹�
    		query2 = " RelationShip like '01%' ";
    	}else if(personRela.equals("corpFamily")){ //���˴�������Ա
    		query2 = " RelationShip like '06%' ";
    	}else if(personRela.equals("allPersonRela")){ //ȫ����Ա����
    		query2 = " (RelationShip like '01%' or RelationShip like '06%') ";
    	}else if(personRela.equals("noPersonRela")){ //��������Ա����
    		query2 = " (RelationShip not like '01%' and RelationShip not like '06%')  ";
    		in2 = false;
	    }
    	
    	//������ϵѡ��
    	if(otherRela.equals("affiliated")){ //�����ι�ϵ
    		query3 = " RelationShip like '99%' ";
	    }else if(otherRela.equals("otherRela")){ //����
	    	query3 = " ( RelationShip like '03%' or RelationShip like '05%' or RelationShip like '54%' or RelationShip like '55%' or RelationShip like '88%' ) ";
	    }else if(otherRela.equals("allOtherRela")){ //ȫ����������
	    	query3 = " ( RelationShip like '03%' or RelationShip like '05%' or RelationShip like '54%' or RelationShip like '55%' or RelationShip like '88%' or RelationShip like '99%' ) ";
	    }else if(otherRela.equals("noOtherRela")){ //��������������
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
	 * ȡ�����ͻ�
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
		//�ṩ�����ͻ��б�
		query1 = manager.createQuery("select distinct O.CustomerID as v.RelativeID,CI.CustomerName,'�ṩ����' as v.RelationShip,O.CertType from O,jbo.app.CUSTOMER_INFO CI" +
				" where O.CustomerID = CI.CustomerID and O.GuarantorID=:CustomerID");
		query1.setParameter("CustomerID", customerId);
		
		//�������б�
		query2 = manager.createQuery("select distinct O.GuarantorID as v.RelativeID,O.GuarantorName as v.CustomerName,'������' as v.RelationShip,O.CertType from O where CustomerID=:CustomerID");
		query2.setParameter("CustomerID", customerId);
		
		//��������ѡ��
		if("noAssureRela".equals(assureRela)){ 			//�����뵣������
			
		}else if("offerAssure".equals(assureRela)){ 	//�ṩ����
			jList = query1.getResultList();
		}else if("acceptAssure".equals(assureRela)){ 	//������
			jList = query2.getResultList();
		}else if("allAssureRela".equals(assureRela)){ 	//ȫ����������
			jList = query1.getResultList();
			jList.addAll(query2.getResultList());
		}
		return jList;
	}
	/**
	 * �ݹ��ʼ���ӽڵ�
	 * @param currentNode ��ǰ�ڵ�
	 * @param depth ��ǰ���
	 * @throws Exception
	 */
    private void initChildren(FamilyTreeNode currentNode,int depth) throws Exception {
    	boolean notShowPersonNode = "PersonNodeNo".equals(personNode);	// ��Ա�Ƿ���Ϊ�ڵ���ʾ
    	String currentCustomerId = currentNode.getId();
    	
		List<BizObject> jList = getCustomerRelativeList(currentCustomerId);
        List<BizObject> assureList = getAssureCustomerList(currentCustomerId);
        if(assureList!=null&&!assureList.isEmpty())jList.addAll(assureList);
        
        if(jList.size()==0)return;
        //��װΪ�ڵ����
        for(int i=0;i<jList.size();i++){
            BizObject bo = (BizObject)jList.get(i);
            
            String relativeId = bo.getAttribute("RelativeID").getString();
            String certType = bo.getAttribute("CertType").getString();
            String certID = bo.getAttribute("CertID").getString();
            if(relativeId==null)relativeId="";
            if(certType==null)certType="";
            
            //�Ѳ�����һ�����ͻ����򷵻�Ϊ�����ڵ�ͻ�����Ա�ڵ㲻��ʾ�����������
            if("".equals(relativeId)
            		||customerID.equals(relativeId) 
            		|| currentCustomerId.equals(relativeId) 
            		|| (certType.startsWith("Ind") && notShowPersonNode)) continue;
            //����ӽڵ�
            FamilyTreeNode node = createTreeNode(bo);
            if(node==null)continue;
            node.setParentId(currentCustomerId);
            node.setMemberCertType(certType);
            node.setMemberCertID(certID);
            context.appendChildComponent(currentNode, node, false);
            
            if(depth<searchlevel-1){//�ݹ�����
            	initChildren(node,depth+1);
            }
        }
    }	

	/**
	 * ��JBO����������һ����ͼ�ڵ����
	 * @param bo
	 * @return
	 * @throws Exception 
	 */
	public FamilyTreeNode createTreeNode(BizObject bo) throws Exception{
		
		//��ȡJBO����
		String id = bo.getAttribute("RelativeID").getString();
		String label = bo.getAttribute("CustomerName").getString();
		String memberType = bo.getAttribute("RelationShip").getString();
		//�������޸�Ϊ����
		if(memberType.equals("�ṩ����")||memberType.equals("������")){
			
		}else{
			 memberType=getItemName("RelationShip",memberType);
		}
		
		//����bean
		FamilyTreeNode node = null;
		UIComponent component = (FamilyTreeNode)context.findComponent(id);
		//����Ѿ����ڣ�����Ҫ�ٴ����� 
		if(component==null){
			node = (FamilyTreeNode)context.createComponent(id, FamilyTreeNode.class);
			node.setLabel(label);
			node.setMemberName(label); 
			node.setMemberType(memberType);
		}
		return node;
	}
	
	/**
	 * ���ݴ����źʹ������Ż�ȡ����������
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

