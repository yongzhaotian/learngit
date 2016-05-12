package com.amarsoft.app.als.customer.group.tree;

import java.util.ArrayList;
import java.util.List;

import com.amarsoft.app.als.customer.group.tree.component.FacesContext;
import com.amarsoft.app.als.customer.group.tree.component.FacesException;
import com.amarsoft.app.als.customer.group.tree.component.FamilyTreeNode;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.lang.DataElement;
import com.amarsoft.context.ASUser;


/**
 * @author syang
 * @date 2011-7-27
 * @describe 集团客户家谱树数据及容器加载器
 */
public class DefaultContextLoader {
	private FacesContext context = null;
	private ASUser curUser ;
	private String groupId;
	private String versionSeq;
	public DefaultContextLoader(ASUser curUser,String groupId,String versionSeq){
		this.curUser = curUser;
		this.groupId = groupId;
		this.versionSeq = versionSeq;
	}
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
		context.addListener(new GroupCustomerContextListener(curUser,groupId,versionSeq));
		try {
			genFamilyTreeNode();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}	
	/**
	 * 生成树图节点
	 * @param context
	 * @return
	 * @throws Exception 
	 */
	private FamilyTreeNode genFamilyTreeNode() throws Exception{
		//根节点
		List<BizObject> jList = getMemberList();
		BizObject rootBizObject = findRootMember(jList);
		
		FamilyTreeNode root = createTreeNode(rootBizObject);//生成根节点对象
		//从列表中移除根节点
		jList.remove(rootBizObject);
		genChildNode(root,jList);
		context.setRootComponent(root);
		return root;
	}
	/**
	 * 递归生成树图模型
	 * @param node 当前节点
	 * @param jList 节点列表
	 * @throws FacesException
	 * @throws JBOException
	 */
	private void genChildNode(FamilyTreeNode node,List<BizObject> jList) throws FacesException, JBOException{
		String id = node.getId();
		//找到子节点
		List<BizObject> fList = new ArrayList<BizObject>();
		for(int i=0;i<jList.size();i++){
			BizObject bo = jList.get(i);
			String parentId = bo.getAttribute("PARENTMEMBERID").getString();
			if(id.equals(parentId)){
				fList.add(bo);
			}
		}
		if(fList.size()==0)return;	//如果没有的，则返回
		for(int i=0;i<fList.size();i++){
			FamilyTreeNode childNode = createTreeNode(fList.get(i));
			genChildNode(childNode,jList);					//递归子节点
			context.appendChildComponent(node, childNode,false);//作为node的子节点添加,不监听，监听会出错
		}
	}

	/**
	 * 获取根节点对应的记录
	 * @param jList
	 * @return
	 * @throws JBOException 
	 */
	private BizObject findRootMember(List<BizObject> jList) throws Exception{
		int count = 0;
		BizObject rootObject = null;
		for(BizObject bo: jList){
			DataElement element = bo.getAttribute("PARENTMEMBERID");
			if(element.isNull()||element.getString().length()==0||"None".equals(element.getString())){
				count ++;
				rootObject = bo;
			}
		}
		if(count>1)throw new Exception("数据异常，集团客户[编号:"+this.groupId+",版本号:"+this.versionSeq+"存在多个根节点");
		if(count==0)throw new Exception("数据异常，集团客户[编号:"+this.groupId+",版本号:"+this.versionSeq+"没有根节点");
		return rootObject;
	}
	/**
	 * 获取集团客户指定版本下集团成员列表
	 * @param groupId 集团客户号
	 * @param versionSeq 版本号
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public List<BizObject> getMemberList(){
        BizObjectManager mamager;
        List<BizObject> jList = null;
		try {
			mamager = JBOFactory.getFactory().getManager("jbo.app.GROUP_FAMILY_MEMBER");
			BizObjectQuery query = mamager.createQuery("GroupID=:GroupID and VersionSeq=:VersionSeq and REVISEFLAG <> 'REMOVED' order by MemberID asc");
			query.setParameter("GroupID", groupId);
			query.setParameter("VersionSeq", versionSeq);
			jList = query.getResultList();
		} catch (JBOException e) {
			e.printStackTrace();
		}
		return jList;
	}
	/**
	 * 从JBO对象中生成一个树图节点对象
	 * @param bo
	 * @return
	 * @throws JBOException
	 * @throws FacesException
	 */
	public FamilyTreeNode createTreeNode(BizObject bo) throws JBOException, FacesException{
		//读取JBO数据
		String id = bo.getAttribute("MEMBERCUSTOMERID").getString();
		String memberName = bo.getAttribute("MEMBERNAME").getString();
		String parentId = bo.getAttribute("PARENTMEMBERID").getString();
		String parentRelationType = bo.getAttribute("PARENTRELATIONTYPE").getString();
		String memberType = bo.getAttribute("MEMBERTYPE").getString();
		String addReason = bo.getAttribute("ATT01").getString();
		String state = bo.getAttribute("REVISEFLAG").getString();
		DataElement shareValue = bo.getAttribute("SHAREVALUE");
		//生成bean
		FamilyTreeNode node = (FamilyTreeNode)context.createComponent(id, FamilyTreeNode.class);
		node.setMemberName(memberName);
		node.setParentId(parentId);
		node.setAddReason(addReason);
		node.setParentRelationType(parentRelationType);
		node.setMemberType(memberType);
		node.setState(state);
		if(shareValue !=null && !shareValue.isNull())node.setShareValue(shareValue.toString());
		return node;
	}
}

