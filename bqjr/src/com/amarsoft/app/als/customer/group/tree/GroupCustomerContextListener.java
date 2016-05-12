package com.amarsoft.app.als.customer.group.tree;

import java.io.Serializable;

import com.amarsoft.app.als.bizobject.customer.GroupCustomer;
import com.amarsoft.app.als.customer.group.tree.component.FacesContext;
import com.amarsoft.app.als.customer.group.tree.component.FacesContextListener;
import com.amarsoft.app.als.customer.group.tree.component.FacesException;
import com.amarsoft.app.als.customer.group.tree.component.FamilyTreeNode;
import com.amarsoft.app.als.customer.group.tree.component.UIComponent;
import com.amarsoft.are.ARE;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.util.StringFunction;
import com.amarsoft.context.ASUser;

/**
 * 由于监听器存在于FacesContext中，因此必需要序列化Serializable
 * @author syang
 * @date 2011-7-27
 * @describe 该类负责与数据库实现持久化
 */
public class GroupCustomerContextListener implements FacesContextListener,Serializable{
	private static final long serialVersionUID = 8315475770181028814L;
	private String groupId;
	private String versionSeq;
	private ASUser curUser ;

	public GroupCustomerContextListener(ASUser curUser,String groupId, String versionSeq) {
		this.curUser = curUser;
		this.groupId = groupId;
		this.versionSeq = versionSeq;
	}
	/**
	 * 添加新成员时，调用此方法
	 */
	public void addComponent(FacesContext context, UIComponent sourceComponent)  throws FacesException{
		FamilyTreeNode treeNode = (FamilyTreeNode)sourceComponent;
		JBOTransaction tx = null; 
		try {
			tx = JBOFactory.createJBOTransaction(); 
			BizObjectManager manager = getManager();
			tx.join(manager);
			BizObject bo = manager.newObject();
			bo = fillBizObject(bo,treeNode);
			manager.saveObject(bo);
			tx.commit();
		} catch (JBOException e) {
			if(tx!=null){
				try {tx.rollback();} catch (JBOException e1) {}
			}
			ARE.getLog().error("插入新成员时出错",e);
			throw new FacesException("插入新成员时出错");
		}
	}
	/**
	 * 修改成员时，调用此方法
	 */
	public void editComponent(FacesContext context, UIComponent oldComponent,
			UIComponent newComponent)  throws FacesException{
		FamilyTreeNode treeNode = (FamilyTreeNode)newComponent;
		JBOTransaction tx = null; 
		try {
			tx = JBOFactory.createJBOTransaction(); 
			BizObjectManager manager = getManager();
			tx.join(manager);
			String jql = "o.GROUPID=:GROUPID and o.VERSIONSEQ=:VERSIONSEQ and o.MEMBERCUSTOMERID=:MEMBERCUSTOMERID";
			BizObject bo = manager.createQuery(jql)
			.setParameter("GROUPID",this.groupId)
			.setParameter("VERSIONSEQ",this.versionSeq)
			.setParameter("MEMBERCUSTOMERID",treeNode.getId())
			.getSingleResult();
			if(bo!=null){
				bo = fillBizObject(bo,treeNode);
			}
			manager.saveObject(bo);
			tx.commit();
		} catch (JBOException e) {
			if(tx!=null){
				try {tx.rollback();} catch (JBOException e1) {}
			}
			ARE.getLog().error("更新成员时出错",e);
			throw new FacesException("更新成员时出错");
		}
	}
	/**
	 * 删除成员时，调用此方法
	 */
	public void removeComponent(FacesContext context,
			UIComponent sourceComponent)  throws FacesException{
		FamilyTreeNode treeNode = (FamilyTreeNode)sourceComponent;
		JBOTransaction tx = null;
		String jql="";
		//查询出当前集团成员是否在集团当前成员表中
		if("NOTEXIST".equals(isGroupMember(context,sourceComponent)))
		{
			//删除的集团成员如果不在集群当前成员表中，则直接删除，不打删除标志。
			jql = "delete from o where o.GROUPID=:GROUPID and o.VERSIONSEQ=:VERSIONSEQ and o.MEMBERCUSTOMERID=:MEMBERCUSTOMERID";
		}else{
		    //为了后续家谱复核通过后统一记录删除日志，所以修改为打标志删除。
		    jql = " update o set ReviseFlag = 'REMOVED' where GroupID = :GroupID and MEMBERCUSTOMERID=:MemberCustomerID and VersionSeq = :VersionSeq ";
		}
		try {
			tx = JBOFactory.createJBOTransaction(); 
			BizObjectManager manager = getManager();
			tx.join(manager);
			manager.createQuery(jql)
			.setParameter("GroupID",this.groupId)
			.setParameter("VersionSeq",this.versionSeq)
			.setParameter("MemberCustomerID",treeNode.getId())
			.executeUpdate();
			
			//更新ENT_INFO  GroupFlag,BelongGroupName
			GroupCustomer groupCustomer = new GroupCustomer();
			groupCustomer.setKeyMemberCustomerID(treeNode.getId());
			//OperCustomer.updateEntCustomer("2", groupCustomer, tx);
			tx.commit();
		} catch (JBOException e) {
			if(tx!=null){
				try {tx.rollback();} catch (JBOException e1) {}
			}
			ARE.getLog().error("删除成员时出错",e);
			throw new FacesException("删除成员时出错");
		}
		
	}
	
	//查询出当前集团成员是否在集群当前成员表中
	private String isGroupMember(FacesContext context,
			UIComponent sourceComponent)  throws FacesException{
		FamilyTreeNode treeNode = (FamilyTreeNode)sourceComponent;
		String message = "";
		try {
		BizObjectManager m=JBOFactory.getBizObjectManager("jbo.app.GROUP_MEMBER_RELATIVE");
		int count=m.createQuery("O.GroupID = :GroupID and O.MEMBERCUSTOMERID=:MemberCustomerID")
		                .setParameter("GroupID", this.groupId)
		                .setParameter("MemberCustomerID", treeNode.getId())
		                .getTotalCount();
		if(count >= 1){
			message = "ISEXIST";
			}else{
			message="NOTEXIST";
			}
		}catch(JBOException e){
			ARE.getLog().error("查询成员时出错",e);
		}
		
		return message;
	}
	
	private BizObjectManager getManager() throws JBOException{
		return JBOFactory.getFactory().getManager("jbo.app.GROUP_FAMILY_MEMBER");
	}
	/**
	 * 使用Bean填充JBO数据
	 * @param bo
	 * @param treeNode
	 * @return
	 * @throws JBOException
	 */
	private BizObject fillBizObject(BizObject bo,FamilyTreeNode treeNode) throws JBOException{
		bo.getAttribute("GROUPID").setValue(groupId);
		bo.getAttribute("VERSIONSEQ").setValue(versionSeq);
		bo.getAttribute("MEMBERCUSTOMERID").setValue(treeNode.getId());
		bo.getAttribute("MEMBERTYPE").setValue(treeNode.getMemberType());
		bo.getAttribute("MEMBERNAME").setValue(treeNode.getMemberName());
		bo.getAttribute("MEMBERCERTTYPE").setValue(treeNode.getMemberCertType());
		bo.getAttribute("MEMBERCERTID").setValue(treeNode.getMemberCertID());
		bo.getAttribute("PARENTMEMBERID").setValue(treeNode.getParentId());
		bo.getAttribute("ATT01").setValue(treeNode.getAddReason());
		bo.getAttribute("PARENTRELATIONTYPE").setValue(treeNode.getParentRelationType());
		bo.getAttribute("SHAREVALUE").setValue(treeNode.getShareValue());
		bo.getAttribute("REVISEFLAG").setValue(treeNode.getState());
		bo.getAttribute("INPUTORGID").setValue(curUser.getOrgID());
		bo.getAttribute("INPUTUSERID").setValue(curUser.getUserID());
		bo.getAttribute("INPUTDATE").setValue(StringFunction.getToday());
		bo.getAttribute("UPDATEDATE").setValue(StringFunction.getToday());
		return bo;
	}
}
