package com.amarsoft.app.als.customer.group.action;

import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOFactory;
//import com.amarsoft.dict.als.manage.CodeManager;

/**
 * 集团客户主办经理和主办机构处理：<br>
 * 
 * 1.检查集团主办机构是否与主办客户经理所在机构一致<br>
 * 2.更新集团客户主办客户经理和主办机构<br>
 * 
 * 
 */
public class GroupAddressManage {
	private String groupID;	  //集团客户ID
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
	 * 更新集团客户主办客户经理和主办机构
	 * 
	 * @param <b>GroupID</b>:集团客户ID<br>
	 * 		  <b>MgtUserID</b>:集团客户主办客户经理ID<br>
	 * 		  <b>MgtOrgID</b>:集团客户主办机构ID<br>
	 * @return 执行成功返回"SUCCESS"
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
		// 2. 记录集团类型变化事件
		String sToday = StringFunction.getToday();
		ASUserObject curUser = ASUserObject.getUser(userID);
		
		m = JBOFactory.getFactory().getManager("jbo.app.GROUP_EVENT");
		bo = m.newObject();
		String sChangeContext="集团区域属性由"+CodeManager.getItemName("GroupAddressType", oldGroupType1)+"集团变更为"+CodeManager.getItemName("GroupAddressType", groupType1)+"集团";
		
		bo.setAttributeValue("GroupID", groupID);	// 集团客户编号
		bo.setAttributeValue("RefMemberID", groupID);	// 集团客户编号
		
		bo.setAttributeValue("EventType", "05");	// 事件类型 （集团授信类型）
		bo.setAttributeValue("OccurDate", sToday);	// 发生日期
		bo.setAttributeValue("EventValue", groupType1);	// 发生值（集团授信类型）
		bo.setAttributeValue("OldEventValue", oldGroupType1); //修改之前的集团授信类型
		bo.setAttributeValue("ChangeContext", sChangeContext); //变更内容
		
		bo.setAttributeValue("InputOrgID", curUser.getOrgID());	// 登记机构
		bo.setAttributeValue("InputUserID", curUser.getUserID());	// 登记人
		bo.setAttributeValue("InputDate", sToday);	// 登记日期
		bo.setAttributeValue("UpdateDate", sToday);	// 修改日期
		tx.join(m);
		m.saveObject(bo);
		return RunJavaMethodAssistant.SUCCESS_MESSAGE;
	}
*/
	/**
	 * 检查是否有在途集团额度申请
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
				" and FO.ApplyType =o.ApplyType and  FO.PhaseType  in ('1010','1020'))");// 未审批通过额申请
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
