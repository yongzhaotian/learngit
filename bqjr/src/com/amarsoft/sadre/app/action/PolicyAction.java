/*
 * This software is the confidential and proprietary information
 * of Amarsoft, Inc. You shall not disclose such Confidential
 * Information and shall use it only in accordance with the terms
 * of the license agreement you entered into with Amarsoft.
 * 
 * Copyright (c) 1999-2011 Amarsoft, Inc.
 * 23F Building A Fudan University Technology Center,
 * No.11 Guotai Road YangPu District, Shanghai,P.R. China 200433
 * All Rights Reserved.
 * 
 */
package com.amarsoft.sadre.app.action;

import java.util.ArrayList;
import java.util.List;

import com.amarsoft.are.ARE;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.log.Log;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.awe.util.json.JSONArray;
import com.amarsoft.awe.util.json.JSONObject;
import com.amarsoft.awe.util.json.JSONValue;
import com.amarsoft.context.ASUser;
import com.amarsoft.sadre.SADREException;

 /**
 * <p>Title: PolicyAction.java </p>
 * <p>Description:  </p>
 * <p>Copyright: Copyright (C) 2006-2011 Amarsoft Ltd. Co.</p> 
 *     
 * @author zllin@amarsoft.com
 * @version 
 * @date 2012-2-16 下午7:21:30
 *
 * logs: 1. 
 */
public abstract class PolicyAction extends BasicWebAction {
	
	/*流程编号*/
	private String flowNo = "";
	/*业务申请编号*/
	private String applyNo = "";
	/*被授权人角色*/
//	private String[] roleId;
	/*被授权人编号(可选)*/
	private String userId = "";
	/*被授权人所属机构(可选)*/
	private String belongOrg = "";
	/*申请类型*/
	private String applyType = "";
	
	protected Log log = ARE.getLog("com.amarsoft.sadre.app.action.PolicyAction");
	
	protected BizObject task;
	
	public PolicyAction(BizObject applyTask) throws SADREException, JBOException{
		if(applyTask==null) throw new SADREException("业务流程信息为空,不能进行授权判断!");
		
		this.task = applyTask;

		setFlowNo(task.getAttribute("FLOWNO").getString());
		setApplyNo(task.getAttribute("APPLYNO").getString());
		setApplyType(task.getAttribute("APPLYTYPE").getString());
		setBelongOrg(task.getAttribute("ORGID").getString());
		setUserId(task.getAttribute("USERID").getString());

	}

	/*getter/setter兼容ALS7中的RunJavaMethod参数调用设置*/
	public String getFlowNo() {
		return flowNo;
	}

	public void setFlowNo(String flowNo) {
		this.flowNo = flowNo;
	}

	public String getApplyNo() {
		return applyNo;
	}

	public void setApplyNo(String applyNo) {
		this.applyNo = applyNo;
	}
	
	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	public String getBelongOrg() {
		return belongOrg;
	}

	public void setBelongOrg(String belongOrg) {
		this.belongOrg = belongOrg;
	}
	
	public String getApplyType() {
		return applyType;
	}

	public void setApplyType(String applyType) {
		this.applyType = applyType;
	}

	/* (non-Javadoc)
	 * @see com.amarsoft.sadre.app.action.BasicWebAction#execute(com.amarsoft.awe.util.Transaction)
	 */
	
	abstract public int execute(Transaction Sqlca) throws SADREException ;
	
	
	/**
	 * 从FLOW_TASK.GroupId中获取当前业务的待处理审批人员的相应角色,并根据当前审批人员是否拥有待处理角色中的某一个角色,以其为授权判断点。<br>
	 * 如果当前的用户拥有待处理角色中的多个角色时,逐个角色遍历其授权配置。
	 * @return
	 * @throws JBOException
	 */
	protected String[] getAuthorizeeRole(Transaction Sqlca) throws SADREException{
		if(getUserId()==null || getUserId().length()==0){
			throw new SADREException("授权方案判断缺少审批人信息!");
		}
		
		String[] approverRole = null;
		String groupId 		 = "";
		String taskSerialNo  = "";
		String taskPhaseNo 	 = "";
		String taskPhaseName = "";
		try {
			/*初始化审批人对象*/
			ASUser asuser = ASUser.getUser(getUserId(), Sqlca);
			
			/*流程信息*/
			taskSerialNo  = task.getAttribute("SERIALNO").getString();
			taskPhaseNo	  = task.getAttribute("PHASENO").getString();
			taskPhaseName = task.getAttribute("PHASENAME").getString();
			groupId 	  = task.getAttribute("GROUPID").getString();
			
			List<String> availableRole = new ArrayList<String>();
			if(groupId!=null && groupId.length()>0){
				/* {"ALS":[{"ROLEID":"4400"},{"ROLEID":"2045"}]} */
				JSONObject appTask = (JSONObject)JSONValue.parse(groupId);
				JSONArray approver = (JSONArray)appTask.get("ALS");
				for(int i=0; i<approver.size(); i++){
					JSONObject ao = (JSONObject)approver.get(i);
					if(ao != null){
						String tmpRole = (String)ao.get("ROLEID");
						/*当前用户具有该角色,则视之为该角色对应的授权方案可用*/
						if(asuser.hasRole(tmpRole)){
							availableRole.add(tmpRole);
						}else{
							log.info("审查审批人员[USERID:"+getUserId()+"/ORGID:"+getBelongOrg()+"] 在业务["+getApplyNo()+"]的当前阶段("+taskPhaseNo+"/"+taskPhaseName+")无可用的被授权审批角色[ROLE:"+tmpRole+"] (TASK.SERIALNO="+taskSerialNo+")");
						}
					}
				}
			}
			
			if(availableRole.size()>0){
				approverRole = new String[availableRole.size()];
				availableRole.toArray(approverRole);		//转换为数组形式
			}
			
		} catch (Exception e) {
			throw new SADREException(e);
		}
		
		return approverRole;
	} 

}
