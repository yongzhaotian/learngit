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
 * @date 2012-2-16 ����7:21:30
 *
 * logs: 1. 
 */
public abstract class PolicyAction extends BasicWebAction {
	
	/*���̱��*/
	private String flowNo = "";
	/*ҵ��������*/
	private String applyNo = "";
	/*����Ȩ�˽�ɫ*/
//	private String[] roleId;
	/*����Ȩ�˱��(��ѡ)*/
	private String userId = "";
	/*����Ȩ����������(��ѡ)*/
	private String belongOrg = "";
	/*��������*/
	private String applyType = "";
	
	protected Log log = ARE.getLog("com.amarsoft.sadre.app.action.PolicyAction");
	
	protected BizObject task;
	
	public PolicyAction(BizObject applyTask) throws SADREException, JBOException{
		if(applyTask==null) throw new SADREException("ҵ��������ϢΪ��,���ܽ�����Ȩ�ж�!");
		
		this.task = applyTask;

		setFlowNo(task.getAttribute("FLOWNO").getString());
		setApplyNo(task.getAttribute("APPLYNO").getString());
		setApplyType(task.getAttribute("APPLYTYPE").getString());
		setBelongOrg(task.getAttribute("ORGID").getString());
		setUserId(task.getAttribute("USERID").getString());

	}

	/*getter/setter����ALS7�е�RunJavaMethod������������*/
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
	 * ��FLOW_TASK.GroupId�л�ȡ��ǰҵ��Ĵ�����������Ա����Ӧ��ɫ,�����ݵ�ǰ������Ա�Ƿ�ӵ�д������ɫ�е�ĳһ����ɫ,����Ϊ��Ȩ�жϵ㡣<br>
	 * �����ǰ���û�ӵ�д������ɫ�еĶ����ɫʱ,�����ɫ��������Ȩ���á�
	 * @return
	 * @throws JBOException
	 */
	protected String[] getAuthorizeeRole(Transaction Sqlca) throws SADREException{
		if(getUserId()==null || getUserId().length()==0){
			throw new SADREException("��Ȩ�����ж�ȱ����������Ϣ!");
		}
		
		String[] approverRole = null;
		String groupId 		 = "";
		String taskSerialNo  = "";
		String taskPhaseNo 	 = "";
		String taskPhaseName = "";
		try {
			/*��ʼ�������˶���*/
			ASUser asuser = ASUser.getUser(getUserId(), Sqlca);
			
			/*������Ϣ*/
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
						/*��ǰ�û����иý�ɫ,����֮Ϊ�ý�ɫ��Ӧ����Ȩ��������*/
						if(asuser.hasRole(tmpRole)){
							availableRole.add(tmpRole);
						}else{
							log.info("���������Ա[USERID:"+getUserId()+"/ORGID:"+getBelongOrg()+"] ��ҵ��["+getApplyNo()+"]�ĵ�ǰ�׶�("+taskPhaseNo+"/"+taskPhaseName+")�޿��õı���Ȩ������ɫ[ROLE:"+tmpRole+"] (TASK.SERIALNO="+taskSerialNo+")");
						}
					}
				}
			}
			
			if(availableRole.size()>0){
				approverRole = new String[availableRole.size()];
				availableRole.toArray(approverRole);		//ת��Ϊ������ʽ
			}
			
		} catch (Exception e) {
			throw new SADREException(e);
		}
		
		return approverRole;
	} 

}
