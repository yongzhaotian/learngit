package com.amarsoft.biz.workflow.action;

import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Random;

import com.amarsoft.amarscript.ASMethod;
import com.amarsoft.app.als.rule.impl.DefaultService;
import com.amarsoft.app.als.rule.impl.RuleConnectionService;
import com.amarsoft.are.ARE;
import com.amarsoft.are.lang.StringX;
import com.amarsoft.are.util.DataConvert;
import com.amarsoft.are.util.StringFunction;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.DBKeyHelp;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.workflow.FlowPhase;
import com.amarsoft.biz.workflow.FlowTask;
import com.amarsoft.biz.workflow.FlowUtil;
import com.amarsoft.core.json.JSONObject;
import com.amarsoft.proj.action.CheckBusinessContractInfo;
import com.amarsoft.proj.action.P2PCreditCommon;
import com.amarsoft.amarscript.*;


/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/
/*
	Author:
	Tester:
	Content: 
	Input Param:
	Output param:
	History Log: xswang 20150427 CCS-173 ��������ͣ��ͬ���͡��ָ���ͬ������
 */
/*~END~*/

public class FlowAction {

	private String serialNo = null;
	private String oldPhaseNo = null;
	private String objectType = null;
	private String objectNo = null;
	private String userID = null;
	private String orgID = null;
	private String orgName = null;
	private String userName = null;
	private String flowNo = null;
	private String flowName = null;
	private String applyType = null;
	private String poolMode = "2"; //�����ģʽ 1:�������ģʽ��2:�������ģʽ
	private static SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
	
	public String getOrgID() {
		return orgID;
	}

	public void setOrgID(String orgID) {
		this.orgID = orgID;
	}

	public String getOrgName() {
		return orgName;
	}

	public void setOrgName(String orgName) {
		this.orgName = orgName;
	}

	public String getUserName() {
		return userName;
	}

	public void setUserName(String userName) {
		this.userName = userName;
	}

	public String getFlowName() {
		return flowName;
	}

	public void setFlowName(String flowName) {
		this.flowName = flowName;
	}

	public String getApplyType() {
		return applyType;
	}

	public void setApplyType(String applyType) {
		this.applyType = applyType;
	}


	//���ù��������õ��µ����̺ź��ύ����һ��
	public String AutoCommitWithRule(Transaction Sqlca) throws Exception {
		String sRet = "Success";

		ARE.getLog().info("����ִ�п�ʼ��ObjectNo="+objectNo+",ObjectType="+objectType);
		
		//���߳�
		DefaultService ruleService = new DefaultService();
		ruleService.setObjectNo(objectNo);
		ruleService.setObjectType(objectType);
		
		// �Ƿ��Ѿ������˹�������
		String  flowCode =ruleService.getResultJs(Sqlca);
		
//		String flowCode = "WF_MEDIUM";//WF_HARD02  WF_MEDIUM02 WF_EASY02  WF_MEDIUM02
		ARE.getLog().info("�������̱�ţ�"+flowCode);
		// ������������̱�š��׶α�š�������
		String sFlowNo = "", sPhaseNo = "", sFlowName = "",sObjectNo ="",sObjectType="";
				
		String sFlowNo1 = "";

		// ��������������������б��׶ε����͡�������ʾ���׶ε�����
		String sSql = "";
		ASResultSet rsTemp = null;

		sSql = "select FlowNo,PhaseNo,ObjectNo,ObjectType from FLOW_TASK where SerialNo = :SerialNo ";
		rsTemp = Sqlca.getASResultSet(new SqlObject(sSql).setParameter( "SerialNo", serialNo));
		if (rsTemp.next()) {
			sFlowNo = DataConvert.toString(rsTemp.getString("FlowNo"));
			sPhaseNo = DataConvert.toString(rsTemp.getString("PhaseNo"));
			sObjectNo = DataConvert.toString(rsTemp.getString("ObjectNo"));
			sObjectType = DataConvert.toString(rsTemp.getString("ObjectType"));
			sFlowNo1 = DataConvert.toString(rsTemp.getString("FlowNo"));

			// ����ֵת���ɿ��ַ���
			if (sFlowNo == null) sFlowNo = "";
			if (sPhaseNo == null) sPhaseNo = "";
		}
		rsTemp.getStatement().close();
		
		sFlowNo = flowCode;
		
		//�������淵�ط��
		if(flowCode.equals("REJECT15")){
			sFlowNo = sFlowNo1;
		}
		//�������淵����׼
		if(flowCode.equals("APPROVE15")){
			sFlowNo = sFlowNo1;
		}
		if(flowCode == null || flowCode.trim().length() <= 0){
			
			return "RuleError";
			
			//sFlowNo = "WF_MEDIUM";
		}
		
		sSql = "select FlowName from FLOW_Catalog where FlowNo = :FlowNo ";
		rsTemp = Sqlca.getASResultSet(new SqlObject(sSql).setParameter( "FlowNo", sFlowNo));
		if (rsTemp.next()) {
			sFlowName = DataConvert.toString(rsTemp.getString("FlowName"));
			// ����ֵת���ɿ��ַ���
			if (sFlowName == null) sFlowName = "";
		}
		rsTemp.getStatement().close();
		
		sSql = "update FLOW_TASK set FlowNo=:FlowNo,FlowName=:FlowName  where SerialNo = :SerialNo ";
		Sqlca.executeSQL(new SqlObject(sSql).setParameter(
				"FlowNo", sFlowNo).setParameter("FlowName", sFlowName).setParameter("SerialNo", serialNo));
		sSql = "update FLOW_OBJECT set FlowNo=:FlowNo,FlowName=:FlowName  where ObjectNo = :ObjectNo and ObjectType=:ObjectType";
		Sqlca.executeSQL(new SqlObject(sSql).setParameter(
				"FlowNo", sFlowNo).setParameter("FlowName", sFlowName).setParameter("ObjectNo", sObjectNo).setParameter("ObjectType", sObjectType));
		//�Ƿ��Զ��ύ
		boolean isAuto = false;
		try{
			FlowPhase flowPhase = _commit(sFlowNo, sPhaseNo, Sqlca);
			if( ! StringX.isEmpty(flowPhase.PhaseDescribe)){
				String[] strArr = StringX.parseArray(flowPhase.PhaseDescribe);
				if(strArr!=null && strArr.length>0){
					for(String str : strArr){
						String tempStr = str.replace(" ", "");
						if(tempStr.substring(0, 4).equalsIgnoreCase("AUTO")){
							isAuto = StringX.parseBoolean(tempStr.substring(5));
							break;
						}
						continue;
					}
					while(isAuto){
						//�����µ�flow_task��ˮ��
						serialNo = Sqlca.getString(new SqlObject("select serialNo from flow_task ft where ft.objectType=:objectType and ft.objectNo=:objectNo order by serialNo desc")
							.setParameter("objectType", objectType).setParameter("objectNo", objectNo));
						userID = "system";
						rsTemp = Sqlca.getASResultSet(new SqlObject(sSql).setParameter( "SerialNo", serialNo));
						if (rsTemp.next()) {
							sFlowNo = DataConvert.toString(rsTemp.getString("FlowNo"));
							sPhaseNo = DataConvert.toString(rsTemp.getString("PhaseNo"));
							// ����ֵת���ɿ��ַ���
							if (sFlowNo == null) sFlowNo = "";
							if (sPhaseNo == null) sPhaseNo = "";
						}
						flowPhase = _commit(sFlowNo, sPhaseNo, Sqlca);
						if(! StringX.isEmpty(flowPhase.PhaseDescribe) ){
							strArr = StringX.parseArray(flowPhase.PhaseDescribe);
							if(strArr!=null && strArr.length>0){
								for(String str : strArr){
									String tempStr = str.replace(" ", "");
									if(tempStr.substring(0, 4).equalsIgnoreCase("AUTO")){
										isAuto = StringX.parseBoolean(tempStr.substring(5));
										break;
									}
									continue;
								}
							}else{
								isAuto = false;
							}
						}else{
							isAuto = false;
						}
					}
				}else{
					isAuto = false;
				}
			}else{
				isAuto = false;
			}
			ARE.getLog().info("����ִ�н�����ObjectNo="+objectNo+",ObjectType="+objectType);
		}catch(Exception e){
			Sqlca.rollback();
			
			String msg = e.getMessage();
			if("Working".equals(msg)) 
				sRet = "Working";
			else
				sRet = "Failure";
			ARE.getLog().error("�����ύ����!", e);
		}

		//Sqlca.executeSQL(new SqlObject("update business_contract set contractStatus='070' where serialno=:serialno").setParameter("serialno", sObjectNo));
		
		//�ж�P2Pռ��
		P2PCreditCommon p2p = new P2PCreditCommon(objectNo, Sqlca);
		boolean b = p2p.isUseP2P();
		ARE.getLog().debug("P2P�жϽ���,��ͬ"+objectNo+"�Ƿ�ΪP2P��ͬ"+b+"������ʱ��Ϊ��"+StringFunction.getNow());
		
		//�жϺ�ͬ�����۾������о����Ƿ�Ϊ�ա�
		CheckBusinessContractInfo checkBC = new CheckBusinessContractInfo();
		checkBC.checkBCManager(Sqlca, objectNo);
		
		return sRet;
	}
	
	/**
	 * ר������ύ
	 * @param sFlowNo
	 * @param sPhaseNo
	 * @param Sqlca
	 * @return
	 * @throws Exception
	 */
	public String AutoCommitWithRuleEnd(Transaction Sqlca) throws Exception {
		//���߳�
		DefaultService ruleService = new DefaultService();
		ruleService.setObjectNo(objectNo);
		ruleService.setObjectType(objectType);
		String flowCode = ruleService.getResultHq(Sqlca);
		//String flowCode = "WF_MEDIUM02";//WF_HARD02  WF_MEDIUM02 WF_EASY02
		System.out.println("�������̱�ţ�"+flowCode);

		System.out.println("===================================================��ͬ��ţ�"+objectNo);
		
		//add CCS-488 PRM-185 ���Ѵ����ھ��������޷�����������post_data���������� by rqiao 20150415
		//���ݲ�Ʒ���Ͳ�ѯ���ڹ��򷵻ؽ���洢�����
		ASResultSet rs = null;
		String sProductID = "";//��Ʒ����
		String sAfterCallRulesNumber = "0";//���ڵ��ù����������
		String sColumnName = "Attribute1";//���򷵻ؽ���洢����ά���ֶΣ�Ĭ���ֶ���ΪAttribute1
		rs = Sqlca.getASResultSet(new SqlObject("select ProductID,AfterCallRulesNumber from Business_Contract where SerialNo = :objectNo").setParameter("objectNo", objectNo));
		if(rs.next())
		{
			sProductID = rs.getString("ProductID");
			if(null == sProductID) sProductID = "";
			sAfterCallRulesNumber = rs.getString("AfterCallRulesNumber");
			if(null == sAfterCallRulesNumber) sAfterCallRulesNumber = "0";
		}
		rs.getStatement().close();
		//���Ϊ�ֽ������ȡֵ�ֶ�ΪAttribute2
		if("020".equals(sProductID))
		{
			sColumnName = "Attribute2";
		}
		//���򷵻ؽ���洢�����
		String sResultTable = Sqlca.getString(new SqlObject("select "+sColumnName+" from Code_Library where CodeNo = 'RuleDataType' and ItemNo = '03'").setParameter("objectNo", objectNo));
		if(null == sResultTable) sResultTable = "";
		//��ѯ���ڹ��򷵻ؽ���洢�������޼�¼
		String sCount = Sqlca.getString(new SqlObject("select count(*) from "+sResultTable+" where ApplyNo = :objectNo").setParameter("objectNo", objectNo));
		//û�гɹ�������򷵻���Ϣ���ظ����ù���
		if(Integer.parseInt(sCount)<1 && Integer.parseInt(sAfterCallRulesNumber)<3) 
		{
			Sqlca.executeSQL(new SqlObject("Update Business_Contract set AfterCallRulesNumber = "+sAfterCallRulesNumber+"+1 where SerialNo = :ObjectNo").setParameter("ObjectNo", objectNo));
			return "Failure";
		}
		//end

		return this.AutoCommit(Sqlca);
	}
	
	private FlowPhase _commit(String sFlowNo, String sPhaseNo, Transaction Sqlca) throws Exception{
		String sSelectStyle = "", sPhaseAttribute = "", sPhaseOpinion1[], 
				minTime = null, maxTime = null, sPhaseAction = null,returnValue;
		
		int uNum = Sqlca.executeSQL(new SqlObject("update FLOW_TASK set EndTime=EndTime where SerialNo=:SerialNo and (EndTime is null or EndTime = '') ").setParameter("SerialNo", serialNo));
		if(uNum<=0) throw new Exception("Working");
		
		FlowPhase flowphase = null;
		ASResultSet rsTemp = null;
		// ������ģ�ͱ�FLOW_MODEL�в�ѯ���׶����ԡ��׶�����
				String sSql = "select PhaseAttribute,ActionDescribe,StandardTime1,StandardTime2 from FLOW_MODEL where FlowNo = :FlowNo and PhaseNo = :PhaseNo";
				rsTemp = Sqlca.getASResultSet(new SqlObject(sSql).setParameter(
						"FlowNo", sFlowNo).setParameter("PhaseNo", sPhaseNo));
				if (rsTemp.next()) {
					sPhaseAttribute = DataConvert.toString(rsTemp.getString("PhaseAttribute"));
					// ����ֵת���ɿ��ַ���
					if (sPhaseAttribute == null) sPhaseAttribute = "";
					
					sSelectStyle = StringFunction.getProfileString(sPhaseAttribute,"ActionStyle");
					if (sSelectStyle == null) sSelectStyle = "";
					
					minTime = DataConvert.toString(rsTemp.getString("StandardTime1"));
					maxTime = DataConvert.toString(rsTemp.getString("StandardTime2"));
				}
				rsTemp.getStatement().close();
				rsTemp = null;

				// ��ʼ���������
				FlowTask ftBusiness = new FlowTask(serialNo, Sqlca);
				
				sPhaseOpinion1 = ftBusiness.getChoiceList();
				if (sPhaseOpinion1 == null) {
					sPhaseOpinion1 = new String[1];
					sPhaseOpinion1[0] = "";
				}

				String sPhaseInfo = "", sNextPhaseName = "", sNextPhaseNo = "", sNextPhaseNameStr = "";

				// ����ҵ���Ƿ��Ѿ��ύ�ˣ�����û��򿪶����������ظ������������Ĵ��󣩡�
				ASMethod asm = new ASMethod("WorkFlowEngine", "GetEndTime", Sqlca);
				Any anyValue = asm.execute(serialNo);
				String endTime = anyValue.toString();

				/*FlowUtil fu = new FlowUtil();
				fu.setSerialNo(serialNo);
				fu.setPhaseOpinion(sPhaseOpinion1[0]);
				fu.setFlowNo(sFlowNo);
				fu.setPhaseNo(sPhaseNo);
				String roleSubmit = fu.isRoleSubmit(Sqlca);
				String roleUsers = fu.getRoleSubmitUsers(Sqlca);*/
				String roleUsers = "";
				String[] actionArr = ftBusiness.getActionList(sPhaseOpinion1[0]);
				for(String action : actionArr){
					roleUsers = roleUsers + action.split(" ")[0]+",";
				}
				if(roleUsers.length()>0){
					roleUsers = roleUsers.substring(0, roleUsers.length()-1);
				}
				ARE.getLog().info("��ɫ�û�roleUsers: "+roleUsers);
				if(roleUsers.contains(userID)){
					sPhaseAction = userID;
				}else{
					sPhaseAction = roleUsers;
					if("2".equals(poolMode)){
						sPhaseAction = "";
					}
				}
				/*if ("1".equals(roleSubmit)) {
					sPhaseAction = roleUsers;
				} else {
					sPhaseAction = roleUsers.split(",")[0];
				}*/

				if (endTime.length() > 0) {
					throw new Exception("Working");// �÷Ŵ������Ѿ��ύ�ˣ������ٴ��ύ��
				} else {
					// ִ���ύ����
					FlowPhase[] fpFlow = ftBusiness.commitAction(sPhaseAction, sPhaseOpinion1[0]);

					for (int i = 0; i < fpFlow.length; i++) {
						flowphase = fpFlow[i];
						// ��ȡ��һ�׶εĽ׶�����
						sNextPhaseName = flowphase.PhaseName;
						sNextPhaseNo = flowphase.PhaseNo;
						sNextPhaseNameStr += sNextPhaseName + ";";
					}

					// ƴ����ʾ��Ϣ
					sPhaseInfo = "��һ�׶�:";
					sPhaseInfo = sPhaseInfo + " " + sNextPhaseNameStr;
					if (sPhaseInfo != null && sPhaseInfo.trim().length() > 0) {
						returnValue = "Success";
					} else {
						throw new Exception("Failure");
					}
				}
				String now = StringFunction.getTodayNow();
				String EndTime = now;
				
				if(!StringX.isEmpty(maxTime) && !StringX.isEmpty(minTime) && !userID.equals(roleUsers)){
					Random rand = new Random();
					int maxInt = Integer.valueOf(maxTime);
					int minInt = Integer.valueOf(minTime);
					if(maxInt>0 && minInt>=0 && maxInt>minInt){
						int a = maxInt-minInt+1;
						int x = rand.nextInt(a)+Integer.valueOf(minTime);
						Date cDate = new Date();
						int minutes=cDate.getMinutes();
						minutes=minutes+x;
						cDate.setMinutes(minutes);
						EndTime = sdf.format(cDate);
					}
				}
				
				EndTime = now;
				//�����ύ֮ǰ����������endTime(��������ʱ�Ľ���ʱ��), phaseOpinion4(�����Ľ���ʱ��)
				sSql = "update FLOW_TASK set EndTime = :EndTime, phaseOpinion4=:now where SerialNo =:SerialNo";
				Sqlca.executeSQL(new SqlObject(sSql)
					.setParameter("EndTime", EndTime)
					.setParameter("Now", now)
					.setParameter("SerialNo", serialNo));
				//�������µ���������beginTime(��������ʱ��),
				sSql = "update FLOW_TASK set BeginTime = :BeginTime where ObjectNo =:ObjectNo and ObjectType=:ObjectType and PhaseNo=:PhaseNo";
				Sqlca.executeSQL(new SqlObject(sSql)
						.setParameter("BeginTime", EndTime)
						.setParameter("ObjectNo", objectNo)
						.setParameter("ObjectType", objectType)
						.setParameter("PhaseNo", sNextPhaseNo));
	
				if("2".equals(poolMode)){
					sSql = "update FLOW_TASK set GroupInfo=:GroupInfo where ObjectNo =:ObjectNo and ObjectType=:ObjectType and PhaseNo=:PhaseNo";
					Sqlca.executeSQL(new SqlObject(sSql)
							.setParameter("GroupInfo", roleUsers)
							.setParameter("ObjectNo", objectNo)
							.setParameter("ObjectType", objectType)
							.setParameter("PhaseNo", sNextPhaseNo));
				}
				//
				//����ύ������Ա������ǰ�û������������䵽��ǰ�û�, ���������Ŀ�ʼʱ�����õ�phaseOpinion3
				//��������������һ�׶β�����TaskState
				if(sFlowNo.startsWith("CarFlow") &&"0010".equals(oldPhaseNo) && "0020".equals(sNextPhaseNo)){
					sSql = "update FLOW_TASK set  phaseOpinion3=:now where ObjectNo =:ObjectNo and ObjectType=:ObjectType and PhaseNo=:PhaseNo and UserID=:UserID";
				}else{
					if(sFlowNo.startsWith("NCIIC_AUTO15") && sNextPhaseNo.equals("0077") ){
						System.out.println("------------------------------");
					     sSql="update FLOW_TASK set TaskState = '1', phaseOpinion3=:now where ObjectNo =:ObjectNo and ObjectType=:ObjectType and PhaseNo=:PhaseNo";
					}else{
						sSql="update FLOW_TASK set TaskState = '1', phaseOpinion3=:now where ObjectNo =:ObjectNo and ObjectType=:ObjectType and PhaseNo=:PhaseNo and UserID=:UserID";	

					}
				}
				Sqlca.executeSQL(new SqlObject(sSql)
						.setParameter("now", now)
						.setParameter("ObjectNo", objectNo)
						.setParameter("ObjectType", objectType)
						.setParameter("UserID", userID)
						.setParameter("PhaseNo", sNextPhaseNo));
			    
				/*if (userID != null && roleUsers.contains(userID)) {
					sSql = "update FLOW_TASK set TaskState = '0' where ObjectNo =:ObjectNo and ObjectType=:ObjectType and PhaseNo=:PhaseNo";
					Sqlca.executeSQL(new SqlObject(sSql)
							.setParameter("ObjectNo", objectNo)
							.setParameter("ObjectType", objectType)
							.setParameter("PhaseNo", sNextPhaseNo));
					sSql = "update FLOW_TASK set TaskState = '1' where ObjectNo =:ObjectNo and ObjectType=:ObjectType and PhaseNo=:PhaseNo and UserID=:UserID";
					Sqlca.executeSQL(new SqlObject(sSql)
							.setParameter("ObjectNo", objectNo)
							.setParameter("ObjectType", objectType)
							.setParameter("UserID", userID)
							.setParameter("PhaseNo", sNextPhaseNo));
				}*/
				
				
				//�½׶�Ϊ��׼����������׼�����º�ͬ״̬
				//if(sNextPhaseNo.equals("1000") || sNextPhaseNo.equals("2000")){//����׼ 080
				//	sSql = "update business_contract set contractstatus = '080' where SerialNo = :Serialno";
				//}else if(sNextPhaseNo.equals("8000")){//�ѷ�� 010
				//	sSql = "update business_contract set contractstatus = '010' where SerialNo = :Serialno";
				//}else if(sNextPhaseNo.equals("9000")){//��ȡ��
				//	sSql = "update business_contract set contractstatus = '100' where SerialNo = :Serialno";
				//}else{//�·���
				//	if (!sNextPhaseNo.equals("0010")) {
				//		sSql = "update business_contract set contractstatus = '070' where SerialNo = :Serialno";
				//	} else {
				//		sSql = "update business_contract set contractstatus = '060' where SerialNo = :Serialno";
				//	}
				//}
				//Sqlca.executeSQL(new SqlObject(sSql).setParameter("Serialno", objectNo));
			
				
				
				
				return flowphase;
	}
	
	//�жϵ�ǰ�����Ƿ�Ϊ���������ж�
	public String AutoFlagCommint(Transaction Sqlca){
		String sSql = "";
		String sFlowNo = "",sPhaseNo = "",sPhaseName = "";
		String sRet = "";
		ASResultSet rsTemp = null;
		try {
			sSql = "select FlowNO,PhaseNo,PhaseName from Flow_Task where SerialNo =:SerialNo";
			rsTemp = Sqlca.getASResultSet(new SqlObject(sSql).setParameter( "SerialNo", serialNo));
			if(rsTemp.next()){
				sFlowNo = DataConvert.toString(rsTemp.getString("FlowNo"));
				sPhaseNo = DataConvert.toString(rsTemp.getString("PhaseNo"));
				sPhaseName = DataConvert.toString(rsTemp.getString("PhaseName"));
				
				// ����ֵת���ɿ��ַ���
				if (sFlowNo == null) sFlowNo = "";
				if (sPhaseNo == null) sPhaseNo = "";
				if (sPhaseName == null) sPhaseName = "";
			}
			rsTemp.getStatement().close();
			//��ȡ�׶�������
			//update CCS-749 PRM-368 ���Ѵ�NCIIC_AUTO15���̲��ֺ�ͬ���ھ��������޷�����������post_data����������  by rqiao 20150507
			//if((sPhaseName.startsWith("����") || sPhaseName.startsWith("�����ж�")) && !sFlowNo.startsWith("NCIIC_AUTO15")){
			if((sPhaseName.startsWith("����") || sPhaseName.startsWith("�����ж�"))){
			//end
				try { 
					//sRet = this.AutoCommitWithRuleEnd(Sqlca);
					InsertAutoRuleAction insertAutoRuleAction=new InsertAutoRuleAction();
					sRet=insertAutoRuleAction.addData(serialNo,objectType,objectNo,oldPhaseNo,userID,Sqlca);
					//������������ ˢ�º󿴲�����ǰ����
 				    sSql = "update FLOW_TASK set subFlag = '1'  where SerialNo =:SerialNo ";
 					    Sqlca.executeSQL(new SqlObject(sSql)
 							.setParameter("SerialNo", serialNo));
 					    
				} catch (Exception e) {
					e.printStackTrace();
				}
			}else{
				sRet = this.AutoCommit(Sqlca);
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		
		return sRet;
	}

	// �Զ��ύ���� Ĭ���ύ����һ��ѡ��ĵ�һ����
	public String AutoCommit(Transaction Sqlca)   {
		
		ARE.getLog().info("����ִ�п�ʼ��ObjectNo="+objectNo+",ObjectType="+objectType);
		// ������������̱�š��׶α�š�������
		String sFlowNo = "", sPhaseNo = "", sRet = "Success";

		// ��������������������б��׶ε����͡�������ʾ���׶ε�����
		String sSql = "";
		ASResultSet rsTemp = null;

		sSql = "select FlowNo,PhaseNo from FLOW_TASK where SerialNo = :SerialNo ";
		try{
			rsTemp = Sqlca.getASResultSet(new SqlObject(sSql).setParameter( "SerialNo", serialNo));
			if (rsTemp.next()) {
				sFlowNo = DataConvert.toString(rsTemp.getString("FlowNo"));
				sPhaseNo = DataConvert.toString(rsTemp.getString("PhaseNo"));
				// ����ֵת���ɿ��ַ���
				if (sFlowNo == null) sFlowNo = "";
				if (sPhaseNo == null) sPhaseNo = "";
			}
			rsTemp.getStatement().close();
		}catch(Exception e){
			ARE.getLog().error("��ȡflowno,phaseno ����!", e);
		}

		boolean isAuto = false;
		try{
			FlowPhase flowPhase = _commit(sFlowNo, sPhaseNo, Sqlca);
			
			if( ! StringX.isEmpty(flowPhase.PhaseDescribe)){
				String[] strArr = StringX.parseArray(flowPhase.PhaseDescribe);
				if(strArr!=null && strArr.length>0){
					for(String str : strArr){
						String tempStr = str.replace(" ", "");
						if(tempStr.substring(0, 4).equalsIgnoreCase("AUTO")){
							isAuto = StringX.parseBoolean(tempStr.substring(5));
							break;
						}
						continue;
					}
					while(isAuto){
						//�����µ�flow_task��ˮ��
						serialNo = Sqlca.getString(new SqlObject("select serialNo from flow_task ft where ft.objectType=:objectType and ft.objectNo=:objectNo order by serialNo desc")
							.setParameter("objectType", objectType).setParameter("objectNo", objectNo));
						userID = "system";
						rsTemp = Sqlca.getASResultSet(new SqlObject(sSql).setParameter( "SerialNo", serialNo));
						if (rsTemp.next()) {
							sFlowNo = DataConvert.toString(rsTemp.getString("FlowNo"));
							sPhaseNo = DataConvert.toString(rsTemp.getString("PhaseNo"));
							// ����ֵת���ɿ��ַ���
							if (sFlowNo == null) sFlowNo = "";
							if (sPhaseNo == null) sPhaseNo = "";
						}
						rsTemp.getStatement().close();
						flowPhase = _commit(sFlowNo, sPhaseNo, Sqlca);
						if(! StringX.isEmpty(flowPhase.PhaseDescribe) ){
							strArr = StringX.parseArray(flowPhase.PhaseDescribe);
							if(strArr!=null && strArr.length>0){
								for(String str : strArr){
									String tempStr = str.replace(" ", "");
									if(tempStr.substring(0, 4).equalsIgnoreCase("AUTO")){
										isAuto = StringX.parseBoolean(tempStr.substring(5));
										break;
									}
									continue;
								}
							}else{
								isAuto = false;
							}
						}else{
							isAuto = false;
						}
					}
				}else{
					isAuto = false;
				}
			}else{
				isAuto = false;
			}
			ARE.getLog().info("����ִ�н�����ObjectNo="+objectNo+",ObjectType="+objectType);
		}catch(Exception e){
			try{
				Sqlca.rollback();
			}catch(Exception ex)
			{
				ex.printStackTrace();
			}
			sRet = "Failure";
			ARE.getLog().error("�����ύ����!", e);
		}
		return sRet;
	}
	
	// ���"�������"��ť�������׶� PRM-477 ���۾�����Է������е����� add by huanghui 20150722
	@SuppressWarnings("deprecation")
	public String vetoApply(Transaction Sqlca) throws Exception {
		String returnValue;
		try{
			// ����ҵ���Ƿ��Ѿ��ύ�ˣ�����û��򿪶����������ظ������������Ĵ��󣩡�
			ASMethod asm = new ASMethod("WorkFlowEngine", "GetEndTime", Sqlca);
			Any anyValue = asm.execute(serialNo);
			String endTime = anyValue.toString();
			
			String sSql="delete from  FLOW_TASK where ObjectType = :ObjectType and ObjectNo= :ObjectNo and FlowNo = :FlowNo and PhaseNo = :PhaseNo and UserID <> :UserID and (EndTime is null or EndTime = '') ";						  
			Sqlca.executeSQL(new SqlObject(sSql)
			.setParameter("ObjectNo", objectNo)
			.setParameter("ObjectType", objectType)
			.setParameter("PhaseNo", oldPhaseNo)
			.setParameter("FlowNo", flowNo)
			.setParameter("UserID", userID)
					);
			
			if (endTime.length() > 0) {
				returnValue = "Working";// �÷Ŵ������Ѿ��ύ�ˣ������ٴ��ύ��
			} else {
				// ִ���ύ����
				SqlObject so;
				//��ÿ�ʼ���ڡ���������
				String sBeginTime = StringFunction.getToday()+" "+StringFunction.getNow();
				String sEndTime = StringFunction.getToday()+" "+StringFunction.getNow();
				//�����������FLOW_TASK�и�����һ���׶εĽ���ʱ�伴���ʱ��
				String sSql3 =  " update FLOW_TASK set EndTime=:EndTime  " +
						" where SerialNo = :SerialNo ";
				SqlObject so2 = new SqlObject(sSql3);
				so2.setParameter("EndTime", sEndTime).setParameter("SerialNo", serialNo);
				
				//�����̶����FLOW_OBJECT������һ�ʷ����Ϣ
				String sSql1 =  " update FLOW_OBJECT set PhaseNo=:PhaseNo ,PhaseType =:PhaseType ,PhaseName=:PhaseName " +
		        " where ObjectNo = :ObjectNo and ObjectType=:ObjectType ";
			    so = new SqlObject(sSql1);
			    so.setParameter("ObjectType", objectType).setParameter("ObjectNo", objectNo).setParameter("PhaseType", "1050")
			    .setParameter("PhaseNo", "8000").setParameter("PhaseName", "�ѷ��");
			    //�����������FLOW_TASK������һ�ʷ����Ϣ
			    String sSerialNo = DBKeyHelp.getWorkNo();
			    String sSql2 =  " insert into FLOW_TASK(SerialNo,ObjectType,ObjectNo,PhaseType,ApplyType,FlowNo,FlowName, " +
					" PhaseNo,PhaseName,OrgID,UserID,UserName,OrgName,BegInTime,EndTime,RELATIVESERIALNO,PHASEOPINION1) "+
					" values (:SerialNo,:ObjectType,:ObjectNo,:PhaseType,:ApplyType, " + 
					" :FlowNo,:FlowName,:PhaseNo,:PhaseName,:OrgID,:UserID, " +
					" :UserName,:OrgName,:BeginTime,:EndTime,:RELATIVESERIALNO,:PHASEOPINION1 )";
			    SqlObject so1 = new SqlObject(sSql2);
			    so1.setParameter("SerialNo", sSerialNo).setParameter("ObjectType", objectType).setParameter("ObjectNo", objectNo).setParameter("PhaseType", "1050")
			    .setParameter("ApplyType", applyType).setParameter("FlowNo", flowNo).setParameter("FlowName", flowName).setParameter("PhaseNo", "8000")
			    .setParameter("PhaseName", "�ѷ��").setParameter("OrgID", orgID).setParameter("UserID", userID).setParameter("UserName", userName)
			    .setParameter("OrgName", orgName).setParameter("BeginTime", sBeginTime).setParameter("EndTime", sEndTime).setParameter("RELATIVESERIALNO", serialNo).setParameter("PHASEOPINION1", "���");
			   
			    //ִ�в������
			    Sqlca.executeSQL(so);
			    Sqlca.executeSQL(so1);
			    Sqlca.executeSQL(so2);
			    
				returnValue = "Success";
			}
		
//		 ���º�ͬ'�ܷ�ԭ�ظ��� ֵΪ2��1=���ԣ�2=������';
		sSql = "update business_contract set AllowReconsider = '2' where SerialNo = :Serialno";
		Sqlca.executeSQL(new SqlObject(sSql).setParameter("Serialno", objectNo));
		}catch(Exception e){
			returnValue = "Failure";
		}
		return returnValue;
	}
	
	// ���"ȡ��"��ť����ȡ���׶�
	public String CancelTask(Transaction Sqlca) throws Exception {

		String returnValue;

		// ��ʼ���������
		FlowTask ftBusiness = new FlowTask(serialNo, Sqlca);

		String sPhaseInfo = "", sNextPhaseName = "", sNextPhaseNameStr = "";

		// ����ҵ���Ƿ��Ѿ��ύ�ˣ�����û��򿪶����������ظ������������Ĵ��󣩡�
		ASMethod asm = new ASMethod("WorkFlowEngine", "GetEndTime", Sqlca);
		Any anyValue = asm.execute(serialNo);
		String endTime = anyValue.toString();

		String sSql="delete from  FLOW_TASK where ObjectType = :ObjectType and ObjectNo= :ObjectNo and FlowNo = :FlowNo and PhaseNo = :PhaseNo and UserID <> :UserID and (EndTime is null or EndTime = '') ";						  
		Sqlca.executeSQL(new SqlObject(sSql)
						.setParameter("ObjectNo", objectNo)
						.setParameter("ObjectType", objectType)
						.setParameter("PhaseNo", oldPhaseNo)
						.setParameter("FlowNo", flowNo)
						.setParameter("UserID", userID)
						);


		if (endTime.length() > 0) {
			returnValue = "Working";// �÷Ŵ������Ѿ��ύ�ˣ������ٴ��ύ��
		} else {
			// ִ���ύ����
			FlowPhase flowphase = null;
			FlowPhase[] fpFlow = ftBusiness.commitAction("","ȡ��");

			for (int i = 0; i < fpFlow.length; i++) {
				flowphase = fpFlow[i];
				// ��ȡ��һ�׶εĽ׶�����
				sNextPhaseName = flowphase.PhaseName;
				sNextPhaseNameStr += sNextPhaseName + ";";
			}

			// ƴ����ʾ��Ϣ
			sPhaseInfo = "��һ�׶�:";
			sPhaseInfo = sPhaseInfo + " " + sNextPhaseNameStr;
			if (sPhaseInfo != null && sPhaseInfo.trim().length() > 0) {
				returnValue = "Success";
			} else {
				returnValue = "Failure";
			}
		}
		// ���º�ͬ״̬ȡ��100 add by tbzeng 2014/06/26
		//sSql = "update business_contract set contractstatus = '100' where SerialNo = :Serialno";
		//Sqlca.executeSQL(new SqlObject(sSql).setParameter("Serialno", objectNo));
		
		return returnValue;
	}
	
	

	// ����ػ�ȡ����
	public String getTask(Transaction Sqlca) throws Exception {
		String serialNo = "",objectNo = "",objectType = "", beginTime ="",sSql = "";
		ASResultSet rsTemp;
		flowNo = flowNo.replace("@", ",");
		if("2".equals(poolMode)){
			// edit by xswang 20150519 CCS-173 ��������ͣ��ͬ���͡��ָ���ͬ������
			// ����һ���ж�����������ͣ�ĺ�ͬ���ڻ�ȡ��Χ��
			sSql = " select ft.SerialNo,ft.ObjectNo,ft.ObjectType,ft.BeginTime,FTOld.PriBeginTime from FLOW_TASK ft,BUSINESS_CONTRACT bc,Flow_Task FTOld where "+
					" ft.objectno=bc.serialno "+
					" and (bc.cancelstatus is null or bc.cancelstatus <> '1') "+
					" and ft.flowNo in"+flowNo+" and ft.GroupInfo like :UserID "+
					//"and (ft.EndTime is null or ft.EndTime = '') and  (ft.TaskState is null or ft.TaskState = '') order by ft.beginTime ";
					// add by xswang 20150722 CCS-811 �������ʱ������:�����ֶ������ȡ����
					" and (ft.EndTime is null or ft.EndTime = '') and  (ft.TaskState is null or ft.TaskState = '') " +
					" and FTOld.ObjectNo = ft.objectno and FTOld.ObjectType =ft.ObjectType and FTOld.PhaseName = 'NCIIC��Ϣ�Զ����' "+
					"  order by FTOld.PriBeginTime ";
					// end 
			rsTemp = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("UserID", "%"+userID+"%"));
		}else{
			sSql = " select ft.SerialNo,ft.ObjectNo,ft.ObjectType,ft.BeginTime,FTOld.PriBeginTime from FLOW_TASK ft,BUSINESS_CONTRACT bc,Flow_Task FTOld where "+
					" ft.objectno=bc.serialno "+
					" and (bc.cancelstatus is null or bc.cancelstatus <> '1') "+
					" and ft.flowNo in"+flowNo+" and ft.UserID =:UserID "+
					//"and (ft.EndTime is null or ft.EndTime = '') and  (ft.TaskState is null or ft.TaskState = '') order by ft.beginTime ";
					// add by xswang 20150722 CCS-811 �������ʱ������:�����ֶ������ȡ����
					" and (ft.EndTime is null or ft.EndTime = '') and  (ft.TaskState is null or ft.TaskState = '') " +
					" and FTOld.ObjectNo = ft.objectno and FTOld.ObjectType =ft.ObjectType and FTOld.PhaseName = 'NCIIC��Ϣ�Զ����' "+
					" order by ft.PriBeginTime ";
					// end
			// end by xswang 20150519
			rsTemp = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("UserID", userID));
		}
		if (rsTemp.next()) {
			serialNo = rsTemp.getString("SerialNo");
			objectNo = rsTemp.getString("objectNo");
			objectType = rsTemp.getString("objectType");
			beginTime = rsTemp.getString("BeginTime");
			long lBeginTime = Long.valueOf(beginTime.replace("/", "").replace(" ", "").replace(":", ""));
			long cTime = Long.valueOf(StringFunction.getTodayNow().replace("/", "").replace(" ", "").replace(":", ""));
			ARE.getLog().trace("beginTime:"+lBeginTime+"; ��ǰʱ�䣺"+cTime);
			/*if(lBeginTime>=cTime){
				continue;
			}*/
			
			//�жϵ�ǰ�û��Ƿ��д�������
			ASResultSet rsuser = null;
			sSql = "select count(1) as iCount from Flow_Task where UserId = :UserID and (EndTime is null or EndTime = '') and TaskState = '1' and (subFlag is null or subFlag ='') ";
			rsuser = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("UserID", userID));
			if(rsuser.next()){
				int icount = rsuser.getInt("iCount");
				if(icount > 0) return "FailError";
			}
			rsuser.getStatement().close();
			
			// add by xswang 20150427 CCS-173 ��������ͣ��ͬ���͡��ָ���ͬ������
			ASResultSet rs1 = null;
			//�Ӻ�ͬ����ȡ��ǰ��ͬ�ġ�cancelstatus����ʶ
			sSql = "select cancelstatus from business_contract where serialno = :ObjectNo ";
			rs1 = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("ObjectNo", objectNo));
			if(rs1.next()){
				String Cancel = rs1.getString("cancelstatus");
				if("1".equals(Cancel)){// Ϊ��1����ʾ�ú�ͬ�Ѿ�����ͣ
					return "CancelError";
				}
			}
			rs1.getStatement().close();
			// end by xswang 20150427
			
			sSql = "update FLOW_TASK set TaskState = '0' where ObjectNo =:ObjectNo and ObjectType=:ObjectType and PhaseNo=:PhaseNo";
			Sqlca.executeSQL(new SqlObject(sSql)
					.setParameter("ObjectNo", objectNo)
					.setParameter("ObjectType", objectType)
					.setParameter("PhaseNo", oldPhaseNo));
			
			sSql = "update FLOW_TASK set TaskState = TaskState where ObjectNo =:ObjectNo and ObjectType=:ObjectType";
			Sqlca.executeSQL(new SqlObject(sSql)
			.setParameter("ObjectNo", objectNo)
			.setParameter("ObjectType", objectType));
			
			sSql = "update FLOW_TASK set TaskState = '1'"
					+ ", phaseOpinion3=:Now " //�������ȡʱ�����õ�phaseOpinion3��
					+ "where SerialNo = :SerialNo";
			int i = Sqlca.executeSQL(new SqlObject(sSql).setParameter("SerialNo",serialNo)
					.setParameter("Now", StringFunction.getTodayNow()));
			if(i <= 0) {
				rsTemp.getStatement().close();
				rsTemp = null;
				return "Failure";
			}
			String UserName = "",OrgID="",OrgName="";
			if("2".equals(poolMode)){
				sSql = "select ui.userName,oi.orgid,oi.orgname from user_info ui ,org_info oi where UserID = :UserID and ui.belongorg = oi.orgid";
				rsTemp = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("UserID", userID));
				while (rsTemp.next()) {
					UserName = rsTemp.getString("UserName");
					OrgID = rsTemp.getString("OrgID");
					OrgName = rsTemp.getString("OrgName");
				}
				
				sSql = "update FLOW_TASK set UserID = :UserID ,UserName=:UserName,OrgID=:OrgID,OrgName=:OrgName "
						+ "where SerialNo = :SerialNo";
				Sqlca.executeSQL(new SqlObject(sSql).setParameter("SerialNo",serialNo)
						.setParameter("UserID", userID)
						.setParameter("UserName", UserName)
						.setParameter("OrgID", OrgID)
						.setParameter("OrgName", OrgName));
			}
			
			String sPhaseNo = Sqlca.getString(new SqlObject("select phaseno from flow_task where serialno =:serialno").setParameter("serialno", serialNo));
			
			Sqlca.executeSQL(new SqlObject("delete from FLOW_TASK where ObjectNo =:ObjectNo and ObjectType=:ObjectType and PhaseNo=:PhaseNo and serialno <> '"+serialNo+"'")
							.setParameter("ObjectNo", objectNo)
							.setParameter("ObjectType", objectType)
							.setParameter("PhaseNo", sPhaseNo));
			rsTemp.getStatement().close();
			rsTemp = null;
			return objectNo+"@"+objectType;
		} 
		rsTemp.getStatement().close();
		rsTemp = null;
		return "Failure";
	}
	
	
	// ����ػ�ȡ����
		public String getTaskCar(Transaction Sqlca) throws Exception {
			String serialNo = "",objectNo = "",objectType = "", beginTime ="",sSql="";
			ASResultSet rsTemp;
			
			if("2".equals(poolMode)){
				sSql = "select SerialNo,ObjectNo,ObjectType,BeginTime from FLOW_TASK where flowNo=:flowNo and  PhaseNo = :PhaseNo and " +
						"GroupInfo like :UserID and (EndTime is null or EndTime = '') and  (TaskState is null or TaskState = '') order by beginTime ";
				rsTemp = Sqlca.getASResultSet(new SqlObject(sSql)
								.setParameter("flowNo", flowNo).setParameter("PhaseNo", oldPhaseNo)
								.setParameter("UserID", "%"+userID+"%"));
			}else{
				sSql = "select SerialNo,ObjectNo,ObjectType,BeginTime from FLOW_TASK where flowNo=:flowNo and  PhaseNo = :PhaseNo and " +
						"UserID = :UserID and (EndTime is null or EndTime = '') and  (TaskState is null or TaskState = '') order by beginTime ";
				rsTemp = Sqlca.getASResultSet(new SqlObject(sSql)
						.setParameter("flowNo", flowNo).setParameter("PhaseNo", oldPhaseNo)
						.setParameter("UserID", userID));
			}
			while (rsTemp.next()) {
				serialNo = rsTemp.getString("SerialNo");
				objectNo = rsTemp.getString("objectNo");
				objectType = rsTemp.getString("objectType");
				beginTime = rsTemp.getString("BeginTime");
				long lBeginTime = Long.valueOf(beginTime.replace("/", "").replace(" ", "").replace(":", ""));
				long cTime = Long.valueOf(StringFunction.getTodayNow().replace("/", "").replace(" ", "").replace(":", ""));
				ARE.getLog().trace("beginTime:"+lBeginTime+"; ��ǰʱ�䣺"+cTime);
				if(lBeginTime>=cTime){
					continue;
				}
				sSql = "update FLOW_TASK set TaskState = '0' where ObjectNo =:ObjectNo and ObjectType=:ObjectType and PhaseNo=:PhaseNo";
				Sqlca.executeSQL(new SqlObject(sSql)
						.setParameter("ObjectNo", objectNo)
						.setParameter("ObjectType", objectType)
						.setParameter("PhaseNo", oldPhaseNo));
				sSql = "update FLOW_TASK set TaskState = '1'"
						+ ", phaseOpinion3=:Now " //�������ȡʱ�����õ�phaseOpinion3��
						+ "where SerialNo = :SerialNo";
				Sqlca.executeSQL(new SqlObject(sSql).setParameter("SerialNo",serialNo)
						.setParameter("Now", StringFunction.getTodayNow()));
				
				String UserName = "",OrgID="",OrgName="";
				if("2".equals(poolMode)){
					sSql = "select ui.userName,oi.orgid,oi.orgname from user_info ui ,org_info oi where UserID = :UserID and ui.belongorg = oi.orgid";
					rsTemp = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("UserID", userID));
					while (rsTemp.next()) {
						UserName = rsTemp.getString("UserName");
						OrgID = rsTemp.getString("OrgID");
						OrgName = rsTemp.getString("OrgName");
					}
					sSql = "update FLOW_TASK set UserID = :UserID ,UserName=:UserName,OrgID=:OrgID,OrgName=:OrgName "
							+ "where SerialNo = :SerialNo";
					Sqlca.executeSQL(new SqlObject(sSql).setParameter("SerialNo",serialNo)
							.setParameter("UserID", userID)
							.setParameter("UserName", UserName)
							.setParameter("OrgID", OrgID)
							.setParameter("OrgName", OrgName));
				}
				return "Success";
			} 
			rsTemp.getStatement().close();
			rsTemp = null;
			return "Failure";
		}
	
	//��ȡ������֮�󣬵����˰�ť�������ñ�־----�����õ�groupId��(Y:��ʾ�������˰�ť)
	public String setClicked(Transaction Sqlca){
		String sRet = "Success";
		try {
			Sqlca.executeSQL(new SqlObject("update FLOW_TASK set groupId =:clicked where ObjectNo=:ObjectNo and ObjectType=:ObjectType and SerialNo=:SerialNo ")
				.setParameter("clicked", "Y").setParameter("ObjectNo", objectNo)
				.setParameter("ObjectType", objectType).setParameter("SerialNo", serialNo));
		} catch (Exception e) {
			try{
				Sqlca.rollback();
			}catch(Exception ex)
			{
				ex.printStackTrace();
			}
			ARE.getLog().error("���û�ȡ��������״̬Ϊ'�����'ʱ,����!", e);
			sRet = "Failure";
		}
		return sRet;
	}

	// �������˻������
	public String returnToPool(Transaction Sqlca) throws Exception {
		String sSql ="",sPhaseno="";
		//��ѯ
		sSql = "select ft.phaseno from flow_task ft where  ft.serialno=(select min(serialno) from flow_task where phasetype='1020' and objectno=:ObjectNo)";
		ASResultSet rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("ObjectNo", objectNo));
		if (rs.next()) {
			sPhaseno = DataConvert.toString(rs.getString("phaseno"));
		}
		rs.getStatement().close();
		//ɾ������
		sSql ="delete from flow_task  where serialno not in (select serialno from flow_task ft where ft.serialno=(select min(serialno) from flow_task where phasetype='1020' and objectno=:ObjectNo) or (ft.serialno=(select serialno from flow_task where phasetype='1010' and objectno=:ObjectNo))) and objectno=:ObjectNo";
		Sqlca.executeSQL(new SqlObject(sSql).setParameter("ObjectNo", objectNo));
		//����
		sSql = "update FLOW_TASK set TaskState = null, endTime=null, phaseOpinion3=null,phaseOpinion4=null where ObjectNo =:ObjectNo and ObjectType=:ObjectType and PhaseNo=:PhaseNo";
		Sqlca.executeSQL(new SqlObject(sSql).setParameter("ObjectNo", objectNo)
				.setParameter("ObjectType", objectType)
				.setParameter("PhaseNo", sPhaseno));
		if("2".equals(poolMode)){
			sSql = "update FLOW_TASK set userID = null, userName=null, orgID=null,orgName=null where ObjectNo =:ObjectNo and ObjectType=:ObjectType and PhaseNo=:PhaseNo";
			Sqlca.executeSQL(new SqlObject(sSql).setParameter("ObjectNo", objectNo)
					.setParameter("ObjectType", objectType)
					.setParameter("PhaseNo", sPhaseno));
		}
		return "Success";
	}

	// �����˻ؼ��
	public String cancelCheck(Transaction Sqlca) throws Exception {
		String relativeSerialno = "";
		String lastUserId = "";
		String sSql = "select relativeSerialno from  FLOW_TASK where SerialNo =:SerialNo";
		ASResultSet rsTemp = Sqlca.getASResultSet(new SqlObject(sSql)
				.setParameter("SerialNo", serialNo));
		if (rsTemp.next()) {
			relativeSerialno = DataConvert.toString(rsTemp.getString("relativeSerialno"));
		}
		if(rsTemp!=null) rsTemp.getStatement().close();
		sSql = "select userId from  FLOW_TASK where SerialNo =:SerialNo";
		rsTemp = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("SerialNo", relativeSerialno));
		if (rsTemp.next()) {
			lastUserId = DataConvert.toString(rsTemp.getString("userID"));
		}

		if(rsTemp!=null) rsTemp.getStatement().close();
		rsTemp = null;
		if (lastUserId.equals(userID)) {
			return "Success";
		} else {
			return "Failure";
		}
	}
	//�˻���һ��
	public String goBack(Transaction Sqlca) {
		String sRet = "Success";
		String objectNo = "", objectType = "", phaseNo = "", relativeSerialno="";
		String sSql = "select relativeSerialno,objectNo,objectType,phaseNo,userID from flow_task where SerialNo =:SerialNo ";
		ASResultSet rsTemp = null;
		try{
			rsTemp = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("SerialNo", serialNo));
			if(rsTemp.next()){
				relativeSerialno = rsTemp.getString("relativeSerialno");
				objectNo = rsTemp.getString("objectNo");
				objectType = rsTemp.getString("objectType");
				phaseNo = rsTemp.getString("phaseNo");
			}
			rsTemp.getStatement().close();
			//ɾ����ǰ�׶ε�����
			sSql = "delete from  Flow_Task where ObjectNo=:ObjectNo and ObjectType=:ObjectType and PhaseNo=:PhaseNo and (EndTime is null or EndTime = '')";
			int i = Sqlca.executeSQL(new SqlObject(sSql)
			.setParameter("ObjectNo", objectNo)
			.setParameter("ObjectType", objectType)
			.setParameter("PhaseNo", phaseNo));
			if(i <= 0){
				return "Failure";
			}
			//����ǰһ�������endTime��phaseOpinion4Ϊnull
			sSql = "update FLOW_TASK set endTime=null,phaseOpinion4=null where SerialNo=:SerialNo";
			Sqlca.executeSQL(new SqlObject(sSql).setParameter("SerialNo", relativeSerialno));
		}catch(Exception e){
			try{
			Sqlca.rollback();}
			catch(Exception ex)
			{
				ex.printStackTrace();
			}
			sRet = "Failure";
		}
		return sRet;
	}

	// �˻���һ�����⴦��ֻ����һ��Ҳ�ǵ�ǰ�û������Ĳ����˻�
	public void preCancel(Transaction Sqlca) throws Exception {
		String objectNo = "";
		String objectType = "";
		String phaseNo = "";
		String userID = "";
		String sSql = "select objectNo,objectType,phaseNo,userID from  FLOW_TASK where SerialNo =:SerialNo";
		ASResultSet rsTemp = Sqlca.getASResultSet(new SqlObject(sSql)
				.setParameter("SerialNo", serialNo));
		if (rsTemp.next()) {
			objectNo = DataConvert.toString(rsTemp.getString("objectNo"));
			objectType = DataConvert.toString(rsTemp.getString("objectType"));
			phaseNo = DataConvert.toString(rsTemp.getString("phaseNo"));
			userID = DataConvert.toString(rsTemp.getString("userID"));
		}
		rsTemp.getStatement().close();
		sSql = "delete from  Flow_Task where ObjectNo=:ObjectNo and ObjectType=:ObjectType and PhaseNo=:PhaseNo and UserID<>:UserID";
		Sqlca.executeSQL(new SqlObject(sSql)
				.setParameter("ObjectNo", objectNo)
				.setParameter("ObjectType", objectType)
				.setParameter("PhaseNo", phaseNo)
				.setParameter("UserID", userID));
	}
	
	public String getSerialNo(Transaction Sqlca) throws Exception {
		String serialNo="";
		String sSql = "select serialNo from  FLOW_TASK where ObjectNo =:ObjectNo and ObjectType=:ObjectType order by serialNo desc";
		ASResultSet rsTemp = Sqlca.getASResultSet(new SqlObject(sSql)
				.setParameter("ObjectNo", objectNo)
				.setParameter("ObjectType", objectType));
		if (rsTemp.next()) {
			serialNo = DataConvert.toString(rsTemp.getString("serialNo"));
		}
		rsTemp.getStatement().close();
		return serialNo;
	}

	public String getPhaseNo(Transaction Sqlca) throws Exception {
		String phaseNo="";
		String sSql = "select phaseNo from  FLOW_TASK where ObjectNo =:ObjectNo and ObjectType=:ObjectType order by serialNo desc";
		ASResultSet rsTemp = Sqlca.getASResultSet(new SqlObject(sSql)
				.setParameter("ObjectNo", objectNo)
				.setParameter("ObjectType", objectType));
		if (rsTemp.next()) {
			phaseNo = DataConvert.toString(rsTemp.getString("phaseNo"));
		}
		rsTemp.getStatement().close();
		return phaseNo;
	}
	
	public String getPhaseName(Transaction Sqlca) throws Exception {
		String phaseName="";
		String sSql = "select phaseName from  FLOW_TASK where SerialNo =:SerialNo";
		ASResultSet rsTemp = Sqlca.getASResultSet(new SqlObject(sSql)
				.setParameter("SerialNo", serialNo));
		if (rsTemp.next()) {
			phaseName = DataConvert.toString(rsTemp.getString("phaseName"));
		}
		rsTemp.getStatement().close();
		return phaseName;
	}
	
	//�Ƿ����Լ��ύ���Լ�
	public String sameUser(Transaction Sqlca) {
		String str = "No";
		String sql = "select ft.serialNo from FLOW_TASK ft where ft.objectType=:objectType and ft.objectNo=:objectNo and ft.userID=:userID "
				+ " and ft.serialNo=(select max(ft2.serialNo) from FLOW_TASK ft2 where ft2.objectType=:objectType and ft2.objectNo=:objectNo ) ";
		try{
			ASResultSet rs = Sqlca.getASResultSet(new SqlObject(sql)
			.setParameter("objectType", objectType).setParameter("objectNo", objectNo)
			.setParameter("userID", userID));
			if(rs.next()){
				str = "Yes";
			}
			rs.getStatement().close();
		}catch(Exception e){
			ARE.getLog().error("�ж�'�Ƿ��Լ��ύ�Լ�'ʱ����!",e);
		}
		ARE.getLog().trace("***********************"+str);
		return str;
	}
	
	//���ù����������ȼ��������õ���Ӧ�ֶ�
	public String getGrade(Transaction Sqlca){
		String sRet = "Success";
		String sql = "update BUSINESS_CONTRACT set Flag5=:grade where serialNo =:serialNo ";
		try{
			//��ʱĬ��Ϊ1
			String grade = "1";
			//TODO ���ù����������ȼ�
			/*JSONObject jObject = null;
			String calcResult = RuleConnectionService.callRule("CFSS_JCMAIN", "RuleFlow", "RF001", jObject.toString(), "{}");*/
			
			Sqlca.executeSQL(new SqlObject(sql).setParameter("serialNo", objectNo)
					.setParameter("grade", grade));
		}catch(Exception e){
			try{
				Sqlca.rollback();
			}catch(Exception ex)
			{
				ex.printStackTrace();
			}
			sRet = "Failure";
			ARE.getLog().error("��������ȼ����������ֶγ���!",e);
		}
		return sRet;
	}

	public String getSerialNo() {
		return serialNo;
	}

	public void setSerialNo(String serialNo) {
		this.serialNo = serialNo;
	}

	public String getOldPhaseNo() {
		return oldPhaseNo;
	}

	public void setOldPhaseNo(String oldPhaseNo) {
		this.oldPhaseNo = oldPhaseNo;
	}

	public String getObjectType() {
		return objectType;
	}

	public void setObjectType(String objectType) {
		this.objectType = objectType;
	}

	public String getObjectNo() {
		return objectNo;
	}

	public void setObjectNo(String objectNo) {
		this.objectNo = objectNo;
	}

	public String getUserID() {
		return userID;
	}

	public void setUserID(String userID) {
		this.userID = userID;
	}

	public String getFlowNo() {
		return flowNo;
	}

	public void setFlowNo(String flowNo) {
		this.flowNo = flowNo;
	}

}
