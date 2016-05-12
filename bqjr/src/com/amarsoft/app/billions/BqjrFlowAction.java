package com.amarsoft.app.billions;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import com.amarsoft.app.util.DBKeyUtils;
import com.amarsoft.are.ARE;
import com.amarsoft.are.lang.DateX;
import com.amarsoft.are.util.StringFunction;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.DBKeyHelp;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.awe.util.json.JSONObject;

public class BqjrFlowAction {

	private String serialNo;
	private String flowNo;
	private String objectNo;
	private String phaseNo;
	private String objectType;
	private String userId;
	private String poolMode="2";

	public String getSerialNo() {
		return serialNo;
	}

	public void setSerialNo(String serialNo) {
		this.serialNo = serialNo;
	}

	public String getFlowNo() {
		return flowNo;
	}

	public void setFlowNo(String flowNo) {
		this.flowNo = flowNo;
	}

	public String getObjectNo() {
		return objectNo;
	}

	public void setObjectNo(String objectNo) {
		this.objectNo = objectNo;
	}

	public String getPhaseNo() {
		return phaseNo;
	}

	public void setPhaseNo(String phaseNo) {
		this.phaseNo = phaseNo;
	}

	public String getObjectType() {
		return objectType;
	}

	public void setObjectType(String objectType) {
		this.objectType = objectType;
	}

	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	/**
	 * ��ȡ����
	 * 
	 * @param Sqlca
	 * @return
	 * @throws Exception
	 */
	public String getTask(Transaction Sqlca) throws Exception {

		String sSql = "update FLOW_TASK set TaskState = '0' where ObjectNo =:ObjectNo and ObjectType=:ObjectType and PhaseNo=:PhaseNo";
		Sqlca.executeSQL(new SqlObject(sSql).setParameter("ObjectNo", objectNo)
				.setParameter("ObjectType", objectType)
				.setParameter("PhaseNo", phaseNo));
		sSql = "update FLOW_TASK set TaskState = '1'" + ", phaseOpinion3=:Now " // �������ȡʱ�����õ�phaseOpinion3��
				+ "where SerialNo = :SerialNo";
		Sqlca.executeSQL(new SqlObject(sSql).setParameter("SerialNo", serialNo)
				.setParameter("Now", StringFunction.getTodayNow()));

		return "Success";
	}

	public String getTaskPoolCount(Transaction Sqlca) throws Exception {

		String sql = "Select Count(FLOW_TASK.SerialNo) from FLOW_TASK,RetailStoreApply where FLOW_TASK.ObjectType='RetailStoreApply'  and  FLOW_TASK.ObjectNo = RetailStoreApply.SerialNo and FLOW_Task.FlowNo=:FlowNo  and FLOW_TASK.PhaseNo=:PhaseNo and FLOW_TASK.UserID=:UserID"
				+ "  and (FLOW_TASK.EndTime is  null  or  FLOW_TASK.EndTime = '')  and (FLOW_TASK.TaskState is null or FLOW_TASK.TaskState='')";
		double dCnt = Sqlca.getDouble(new SqlObject(sql)
				.setParameter("FlowNo", flowNo)
				.setParameter("PhaseNo", phaseNo)
				.setParameter("UserID", userId));
		if (dCnt <= 0.0)
			return "Failure";
		return "Success";
	}

	/**
	 * �������,����ǰ�����������Ȩ����ȥִ��
	 * 
	 * @param Sqlca
	 * @return
	 */
	public String adjustTask(Transaction Sqlca) throws Exception{
		ARE.getLog().info("����"+objectNo+"����������������ʼ");
		ASResultSet rs = null;
		String sFLUserID = "";
		String orgUserSql = "select UserName, BelongOrg, getOrgName(BelongOrg) as OrgName from user_info where UserId=:UserId";
		//String ftSql = "update Flow_Task set UserId=:UserId, UserName=:UserName, TaskState=null,OrgId=:OrgId, OrgName=:OrgName where SerialNo=(select max(SerialNo) from Flow_Task where ObjectNo=:ObjectNo)";
		String sSql = "update Flow_Task set UserID = :UserID,UserName = :UserName,OrgID = :OrgID,OrgName = :OrgName, "+
					" PhaseOpinion3 = :PhaseOpinion3,GroupID = 'Y',TaskState = '1'"+
					" where ObjectType = 'BusinessContract' and ObjectNo = :ObjectNo and PhaseNo = :PhaseNo";
		//String foSql = "update Flow_Object set UserId=:UserId, UserName=:UserName, OrgId=:OrgId, OrgName=:OrgName where ObjectNo=:ObjectNo";
		try {
			//��ѯ��ǰ�û��Ƿ�Ϊ�����û�
			sFLUserID = Sqlca.getString(new SqlObject("select UserID from Flow_Task where ObjectType = 'BusinessContract' and ObjectNo = :ObjectNo and PhaseNo = :PhaseNo")
					.setParameter("ObjectNo", objectNo).setParameter("PhaseNo", phaseNo));
			
			if(sFLUserID.equals(userId)) return "FailError";
			
			rs = Sqlca.getASResultSet(new SqlObject(orgUserSql)
					.setParameter("UserId", userId));
			
			String sUserName = "";
			String sOrgId = "";
			String sOrgName = "";
			
			if (rs.next()) {
				sUserName = rs.getString("UserName");
				sOrgId = rs.getString("BelongOrg");
				sOrgName = rs.getString("OrgName");
			}
		
			 // add by tbzeng 2014/09/11 ���µ�ǰ��������
			Sqlca.executeSQL(new SqlObject("UPDATE FLOW_OBJECT SET OBJATTRIBUTE4=:DEALUSER WHERE OBJECTNO=:OBJECTNO AND OBJECTTYPE=:OBJECTTYPE")
				.setParameter("DEALUSER", userId).setParameter("OBJECTNO", objectNo).setParameter("OBJECTTYPE", "BusinessContract"));

			int i = Sqlca.executeSQL(new SqlObject(sSql)
					.setParameter("UserId", userId)
					.setParameter("UserName", sUserName)
					.setParameter("OrgId", sOrgId)
					.setParameter("OrgName", sOrgName).setParameter("PhaseOpinion3", StringFunction.getTodayNow())
					.setParameter("ObjectNo", objectNo).setParameter("PhaseNo", phaseNo));
			if(i <= 0) throw new Exception("Working");
			//�޸Ĵ����������
			/*Sqlca.executeSQL(new SqlObject(foSql)
					.setParameter("UserId", userId)
					.setParameter("UserName", sUserName)
					.setParameter("OrgId", sOrgId)
					.setParameter("OrgName", sOrgName)
					.setParameter("ObjectNo", objectNo));*/

		} catch (Exception e) {
			Sqlca.rollback();
			ARE.getLog().info("����"+objectNo+"������������������");
			e.printStackTrace();
			return "Failure";
		}finally{
			if (rs != null) rs.getStatement().close();
		}
		ARE.getLog().info("����"+objectNo+"������������������");
		return "Success";
	}

	/**
	 * �������˻�����أ����¿�ʼ��ȡ����
	 * @param Sqlca
	 * @return
	 */
	public String returnToPool(Transaction Sqlca) {
		
		try {
		
			// ��ȡ�������һ�׶�
			String sPhaseNo = Sqlca.getString(new SqlObject("SELECT PHASENO FROM FLOW_OBJECT WHERE OBJECTNO=:OBJECTNO").setParameter("OBJECTNO", objectNo));
			if (Arrays.asList("1000","2000","8000","9000").contains(sPhaseNo)) {
				throw new RuntimeException("�������Ѿ������������˻������");
			}
			
			// ɾ���������֮��ļ�¼
			String sSql = "DELETE FROM FLOW_TASK WHERE OBJECTNO=:OBJECTNO AND SERIALNO NOT IN (SELECT T.SERIALNO FROM (SELECT SERIALNO FROM FLOW_TASK WHERE OBJECTNO=:OBJECTNO AND ROWNUM<=2 ORDER BY SERIALNO) T)";
			Sqlca.executeSQL(new SqlObject(sSql).setParameter("OBJECTNO", objectNo));
			
			String userIds = Sqlca.getString(new SqlObject("SELECT PHASEACTION FROM FLOW_TASK WHERE SERIALNO=(SELECT MIN(SERIALNO) FROM FLOW_TASK WHERE OBJECTNO=:OBJECTNO)").setParameter("OBJECTNO", objectNo));
			
			List<String> userList = new ArrayList();
			if("2".equals(poolMode)){
				
			}else{
			// userIdΪ�գ���ʾ�����������
				if (userIds == null) throw new RuntimeException("�����������");
				userList = Arrays.asList(userIds.split(","));	// ˵ȥ�������������
			}

			// ��ʼ�������
			sSql = "UPDATE FLOW_TASK SET PHASEOPINION3=NULL, PHASEOPINION4=NULL, ENDTIME=NULL, TASKSTATE=NULL WHERE SERIALNO=(SELECT MAX(SERIALNO) FROM FLOW_TASK WHERE OBJECTNO=:OBJECTNO)";
			Sqlca.executeSQL(new SqlObject(sSql).setParameter("OBJECTNO", objectNo));
			
			sSql = "SELECT OBJECTTYPE, RELATIVESERIALNO, FLOWNO, FLOWNAME, PHASENO, PHASENAME, PHASETYPE, APPLYTYPE, USERID, USERNAME, ORGID, ORGNAME, BEGINTIME FROM FLOW_TASK WHERE SERIALNO=(SELECT max(SERIALNO) FROM FLOW_TASK WHERE OBJECTNO=:OBJECTNO)";
			ASResultSet rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("OBJECTNO", objectNo));
			
			String sObjectType = "",sRelativeSerialNo = "",sFlowNo="", sFlowName="",sPhaseName="",sPhaseType="",sApplyType="",sUserId="",sUserName="",sOrgId="",sOrgName="", sBeginTime=DateX.format(new java.util.Date(),"yyyy/MM/dd hh:mm:ss");
			if (rs.next()) {
				sObjectType = rs.getString("OBJECTTYPE");
				sRelativeSerialNo = rs.getString("RELATIVESERIALNO");
				sFlowNo = rs.getString("FLOWNO");
				sFlowName = rs.getString("FLOWNAME");
				sPhaseNo = rs.getString("PHASENO");
				sPhaseName = rs.getString("PHASENAME");
				sPhaseType = rs.getString("PHASETYPE");
				sApplyType = rs.getString("APPLYTYPE");
				sUserId = rs.getString("USERID");
				sUserName = rs.getString("USERNAME");
				sOrgId = rs.getString("ORGID");
				sOrgName = rs.getString("ORGNAME");
				// �����������ȡΪnull
				if (sOrgName == null) sOrgName = Sqlca.getString(new SqlObject("SELECT ORGNAME FROM ORG_INFO WHERE ORGID=:ORGID").setParameter("ORGID", sOrgId));
				// �Ƿ�ͬ���ύʱ��
			}
			if (rs != null) 
			rs.getStatement().close();
			
			// ����FLOW_OBJECT��
			Sqlca.executeSQL(new SqlObject("UPDATE FLOW_OBJECT SET PHASENO=:PHASENO,PHASENAME=:PHASENAME,PHASETYPE=:PHASETYPE, USERID=:USERID, USERNAME=:USERNAME, ORGID=:ORGID, ORGNAME=:ORGNAME WHERE OBJECTNO=:OBJECTNO")
					.setParameter("PHASENO", sPhaseNo).setParameter("PHASENAME", sPhaseName).setParameter("PHASETYPE", sPhaseType).setParameter("USERID", sUserId).setParameter("USERNAME", sUserName)
					.setParameter("ORGID", sOrgId).setParameter("ORGNAME", sOrgName).setParameter("OBJECTNO", objectNo));
			
			if("2".equals(poolMode)){
				Sqlca.executeSQL(new SqlObject("UPDATE FLOW_TASK SET USERID=null,USERNAME=null,ORGID=null,ORGNAME=null WHERE OBJECTNO=:OBJECTNO and ObjectType=:ObjectType and PhaseNo=:PhaseNo")
				.setParameter("PHASENO", sPhaseNo).setParameter("ObjectType", sObjectType).setParameter("OBJECTNO", objectNo));
			}else{
				// ���������
				sSql = "INSERT INTO FLOW_TASK(SERIALNO, OBJECTNO,OBJECTTYPE, RELATIVESERIALNO, FLOWNO, FLOWNAME, PHASENO, PHASENAME, PHASETYPE, APPLYTYPE, USERID, USERNAME, ORGID, ORGNAME, BEGINTIME) VALUES (:SERIALNO, :OBJECTNO,:OBJECTTYPE, :RELATIVESERIALNO, :FLOWNO, :FLOWNAME, :PHASENO, :PHASENAME, :PHASETYPE, :APPLYTYPE, :USERID, :USERNAME, :ORGID, :ORGNAME, :BEGINTIME)";
				for (String userID: userList) {
					if (userID.equals(sUserId)) continue;
					/** --update Object_Maxsnȡ���Ż� tangyb 20150817 start-- 
					SqlObject aSql = new SqlObject(sSql).setParameter("SERIALNO", DBKeyHelp.getSerialNo("FLOW_TASK", "SERIALNO"))
							.setParameter("OBJECTNO", objectNo).setParameter("OBJECTTYPE", sObjectType).setParameter("RELATIVESERIALNO", sRelativeSerialNo)
							.setParameter("FLOWNO", sFlowNo).setParameter("FLOWNAME", sFlowName).setParameter("PHASENO", sPhaseNo).setParameter("PHASENAME", sPhaseName)
							.setParameter("PHASETYPE", sPhaseType).setParameter("APPLYTYPE", sApplyType).setParameter("USERID", sUserId).setParameter("USERNAME", sUserName)
							.setParameter("ORGID", sOrgId).setParameter("ORGNAME", sOrgName).setParameter("BEGINTIME", sBeginTime);*/
					
					SqlObject aSql = new SqlObject(sSql).setParameter("SERIALNO", DBKeyHelp.getWorkNo())
							.setParameter("OBJECTNO", objectNo).setParameter("OBJECTTYPE", sObjectType).setParameter("RELATIVESERIALNO", sRelativeSerialNo)
							.setParameter("FLOWNO", sFlowNo).setParameter("FLOWNAME", sFlowName).setParameter("PHASENO", sPhaseNo).setParameter("PHASENAME", sPhaseName)
							.setParameter("PHASETYPE", sPhaseType).setParameter("APPLYTYPE", sApplyType).setParameter("USERID", sUserId).setParameter("USERNAME", sUserName)
							.setParameter("ORGID", sOrgId).setParameter("ORGNAME", sOrgName).setParameter("BEGINTIME", sBeginTime);
					/** --end --*/
					Sqlca.executeSQL(aSql);
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
			return "Failure";
		}
		
		return "Success";
	}
	
	/**
	 * 
	 * @return
	 */
	public String backFlowPool(Transaction Sqlca) throws Exception{
		//���������SQLȡ�����������ţ���ǰ�û�
		String sSql = "",sUserID = "";
		try{
			ARE.getLog().info("��ʼ����"+objectNo+"��������˻������");
			//��ȡ��ǰ�׶��û�
			sSql = "select UserID from Flow_Task where ObjectNo = :ObjectNo and ObjectType = 'BusinessContract' and PhaseNo = :PhaseNo";
			sUserID = Sqlca.getString(new SqlObject(sSql).setParameter("ObjectNo", objectNo).setParameter("PhaseNo", phaseNo));
			if(sUserID == null) sUserID = "";
			//�жϸñ������Ƿ����������
			if("".equals(sUserID)){
				return "FailPool";
			}
			//��������µ���ǰ�׶��������
			sSql = "update Flow_Task set UserId = '',UserName = null,OrgId = null,OrgName = null,PhaseOpinion1 = '',PhaseOpinion3 = '',PhaseOpinion4 = '',GroupId = '',TaskState = '' "+
					" where ObjectNo = :ObjectNo and ObjectType = 'BusinessContract' and PhaseNo = :PhaseNo";
			int i = Sqlca.executeSQL(new SqlObject(sSql).setParameter("ObjectNo", objectNo).setParameter("PhaseNo", phaseNo));
			if(i <= 0) throw new Exception("Working");
		}catch(Exception e){
			Sqlca.rollback();
			ARE.getLog().info("����"+objectNo+"��������˻�����س���");
			e.printStackTrace();
			return "Failure";
		}
		ARE.getLog().info("����"+objectNo+"��������˻�����ؽ���");
		return "Success";
	}

}
