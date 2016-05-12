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
 * ���ڼ�����������FacesContext�У���˱���Ҫ���л�Serializable
 * @author syang
 * @date 2011-7-27
 * @describe ���ฺ�������ݿ�ʵ�ֳ־û�
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
	 * ����³�Աʱ�����ô˷���
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
			ARE.getLog().error("�����³�Աʱ����",e);
			throw new FacesException("�����³�Աʱ����");
		}
	}
	/**
	 * �޸ĳ�Աʱ�����ô˷���
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
			ARE.getLog().error("���³�Աʱ����",e);
			throw new FacesException("���³�Աʱ����");
		}
	}
	/**
	 * ɾ����Աʱ�����ô˷���
	 */
	public void removeComponent(FacesContext context,
			UIComponent sourceComponent)  throws FacesException{
		FamilyTreeNode treeNode = (FamilyTreeNode)sourceComponent;
		JBOTransaction tx = null;
		String jql="";
		//��ѯ����ǰ���ų�Ա�Ƿ��ڼ��ŵ�ǰ��Ա����
		if("NOTEXIST".equals(isGroupMember(context,sourceComponent)))
		{
			//ɾ���ļ��ų�Ա������ڼ�Ⱥ��ǰ��Ա���У���ֱ��ɾ��������ɾ����־��
			jql = "delete from o where o.GROUPID=:GROUPID and o.VERSIONSEQ=:VERSIONSEQ and o.MEMBERCUSTOMERID=:MEMBERCUSTOMERID";
		}else{
		    //Ϊ�˺������׸���ͨ����ͳһ��¼ɾ����־�������޸�Ϊ���־ɾ����
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
			
			//����ENT_INFO  GroupFlag,BelongGroupName
			GroupCustomer groupCustomer = new GroupCustomer();
			groupCustomer.setKeyMemberCustomerID(treeNode.getId());
			//OperCustomer.updateEntCustomer("2", groupCustomer, tx);
			tx.commit();
		} catch (JBOException e) {
			if(tx!=null){
				try {tx.rollback();} catch (JBOException e1) {}
			}
			ARE.getLog().error("ɾ����Աʱ����",e);
			throw new FacesException("ɾ����Աʱ����");
		}
		
	}
	
	//��ѯ����ǰ���ų�Ա�Ƿ��ڼ�Ⱥ��ǰ��Ա����
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
			ARE.getLog().error("��ѯ��Աʱ����",e);
		}
		
		return message;
	}
	
	private BizObjectManager getManager() throws JBOException{
		return JBOFactory.getFactory().getManager("jbo.app.GROUP_FAMILY_MEMBER");
	}
	/**
	 * ʹ��Bean���JBO����
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
