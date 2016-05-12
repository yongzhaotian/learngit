package com.amarsoft.app.als.customer.group.action;

import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOFactory;
//import com.amarsoft.dict.als.manage.CodeManager;

/**
 * ���ſͻ����쾭��������������<br>
 * 
 * 1.��鼯����������Ƿ�������ͻ��������ڻ���һ��<br>
 * 2.���¼��ſͻ�����ͻ�������������<br>
 * 
 * 
 */
public class GroupAddressManage {
	private String groupID;	  //���ſͻ�ID
	private String userID;
	private String groupType1;
	private String oldGroupType1;
	
	public String getGroupID() {
		return groupID;
	}

	public void setGroupID(String groupID) {
		this.groupID = groupID;
	}

	
	/**
	 * ���¼��ſͻ�����ͻ�������������
	 * 
	 * @param <b>GroupID</b>:���ſͻ�ID<br>
	 * 		  <b>MgtUserID</b>:���ſͻ�����ͻ�����ID<br>
	 * 		  <b>MgtOrgID</b>:���ſͻ��������ID<br>
	 * @return ִ�гɹ�����"SUCCESS"
	 * @throws Exception 
	 */
	/*
	public String updateAddressInfo(JBOTransaction tx) throws Exception{
		BizObjectManager m = JBOFactory.getFactory().getManager("jbo.app.GROUP_INFO");
		tx.join(m);
		BizObjectQuery q = m.createQuery("update o set GroupType1=:GroupType1 where GroupID=:GroupID");
		q.setParameter("GroupType1",groupType1).setParameter("GroupID",groupID);
		q.executeUpdate();
		m = null;
		q = null;
		BizObject bo = null;
		// 2. ��¼�������ͱ仯�¼�
		String sToday = StringFunction.getToday();
		ASUserObject curUser = ASUserObject.getUser(userID);
		
		m = JBOFactory.getFactory().getManager("jbo.app.GROUP_EVENT");
		bo = m.newObject();
		String sChangeContext="��������������"+CodeManager.getItemName("GroupAddressType", oldGroupType1)+"���ű��Ϊ"+CodeManager.getItemName("GroupAddressType", groupType1)+"����";
		
		bo.setAttributeValue("GroupID", groupID);	// ���ſͻ����
		bo.setAttributeValue("RefMemberID", groupID);	// ���ſͻ����
		
		bo.setAttributeValue("EventType", "05");	// �¼����� �������������ͣ�
		bo.setAttributeValue("OccurDate", sToday);	// ��������
		bo.setAttributeValue("EventValue", groupType1);	// ����ֵ�������������ͣ�
		bo.setAttributeValue("OldEventValue", oldGroupType1); //�޸�֮ǰ�ļ�����������
		bo.setAttributeValue("ChangeContext", sChangeContext); //�������
		
		bo.setAttributeValue("InputOrgID", curUser.getOrgID());	// �Ǽǻ���
		bo.setAttributeValue("InputUserID", curUser.getUserID());	// �Ǽ���
		bo.setAttributeValue("InputDate", sToday);	// �Ǽ�����
		bo.setAttributeValue("UpdateDate", sToday);	// �޸�����
		tx.join(m);
		m.saveObject(bo);
		return RunJavaMethodAssistant.SUCCESS_MESSAGE;
	}
*/
	/**
	 * ����Ƿ�����;���Ŷ������
	 * 2011-11-29 15:04:49
	 * cjyu 
	 * @return
	 */
	public String checkOnLineApply() throws Exception
	{
		BizObjectManager m = JBOFactory.getFactory().getManager("jbo.app.BUSINESS_APPLY");
		BizObjectQuery q = m.createQuery("select SerialNo from o where   o.CustomerID =:CustomerID" +
				" and   o.BusinessType = '3020'"+
				" and exists (select 1 from jbo.app.FLOW_OBJECT FO where FO.ObjectNo=o.SerialNo" +
				" and FO.ApplyType =o.ApplyType and  FO.PhaseType  in ('1010','1020'))");// δ����ͨ��������
		q.setParameter("CustomerID",groupID);
		if(q.getTotalCount()>0) return "ReadOnly";
		return "All"; 
	}
	
	public void setGroupType1(String groupType1) {
		this.groupType1 = groupType1;
	}

	public String getGroupType1() {
		return groupType1;
	}

	public void setUserID(String userID) {
		this.userID = userID;
	}

	public String getUserID() {
		return userID;
	}

	public void setOldGroupType1(String oldGroupType1) {
		this.oldGroupType1 = oldGroupType1;
	}

	public String getOldGroupType1() {
		return oldGroupType1;
	}


}
