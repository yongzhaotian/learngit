/*
		Author: rqiao
		describe:CCS-574 PRM-256 ԭ�ظ���ƻ���˶ϵͳ����
		modify:20150401
 */
package com.amarsoft.app.lending.bizlets;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;


import com.amarsoft.app.billions.GenerateSerialNo;
import com.amarsoft.are.util.StringFunction;

import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.DBKeyHelp;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;

public class AddReconsiderInfo {

	String serialNo ;
	String nextFlowNo ;
	String flowName ;
	String userName ;
	String orgName ;
	String ObjectType;//��ͬ����
	String ObjectNo;//��ͬ���
	String ApplyType;//Apply����
	String FlowNo;//���̱��
	String PhaseNo;//���̽׶α��
	String UserID;//�û�ID
	String OrgID;//�û���������
	String InputTime;//����ʱ��
	String sReturn = "Faile";//������Ϣ
	String ResurrectionReason ;//��ӦCode: ResurrectionReason  
	String ResurrectionReasonRemark ;//������ѡ��'����'ʱ  ��д��������ע 
	
	public String getResurrectionReason() {
		return ResurrectionReason;
	}

	public void setResurrectionReason(String resurrectionReason) {
		ResurrectionReason = resurrectionReason;
	}

	public String getResurrectionReasonRemark() {
		return ResurrectionReasonRemark;
	}

	public void setResurrectionReasonRemark(String resurrectionReasonRemark) {
		ResurrectionReasonRemark = resurrectionReasonRemark;
	}

	public String getSerialNo() {
		return serialNo;
	}

	public void setSerialNo(String serialNo) {
		this.serialNo = serialNo;
	}

	public String getNextFlowNo() {
		return nextFlowNo;
	}

	public void setNextFlowNo(String nextFlowNo) {
		this.nextFlowNo = nextFlowNo;
	}

	public String getFlowName() {
		return flowName;
	}

	public void setFlowName(String flowName) {
		this.flowName = flowName;
	}

	public String getUserName() {
		return userName;
	}

	public void setUserName(String userName) {
		this.userName = userName;
	}

	public String getOrgName() {
		return orgName;
	}

	public void setOrgName(String orgName) {
		this.orgName = orgName;
	}

	public String getApplyType() {
		return ApplyType;
	}

	public void setApplyType(String applyType) {
		ApplyType = applyType;
	}

	public String getFlowNo() {
		return FlowNo;
	}

	public void setFlowNo(String flowNo) {
		FlowNo = flowNo;
	}

	public String getPhaseNo() {
		return PhaseNo;
	}

	public void setPhaseNo(String phaseNo) {
		PhaseNo = phaseNo;
	}
	
	public String getOrgID() {
		return OrgID;
	}

	public void setOrgID(String orgID) {
		OrgID = orgID;
	}
	
	public String getObjectType() {
		return ObjectType;
	}

	public void setObjectType(String objectType) {
		ObjectType = objectType;
	}

	public String getObjectNo() {
		return ObjectNo;
	}
	
	public void setObjectNo(String objectNo) {
		ObjectNo = objectNo;
	}

	public String getUserID() {
		return UserID;
	}

	public void setUserID(String userID) {
		UserID = userID;
	}

	public String getInputTime() {
		return InputTime;
	}

	public void setInputTime(String inputTime) {
		InputTime = inputTime;
	}
	
	public String getsReturn() {
		return sReturn;
	}

	public void setsReturn(String sReturn) {
		this.sReturn = sReturn;
	}

	/*  1)	��72Сʱ֮�ھܾ��ĺ�ͬ����ϵͳ�ܾ�ʱ��Ϊ׼����
		2)	����ԭ�ظ���Ȩ�޵����۴���
		3)	�涨ʱ����ڣ����£���Ȼ���и������� 
		4)	ֻ�����Լ������Լ��ĺ�ͬ��
		����������Ϊ���ҡ��Ĺ�ϵ������ͬʱ���㷽�ɸ������롣
	*/
	//���������ĸ��������¼��ˮ��
	private String Record_SerialNo = "";
	public String CheckReconsiderRule(Transaction Sqlca) throws Exception
	{
		try {
			//�Ƿ�Ϊ�Լ�����ĺ�ͬ
			String sCount = Sqlca.getString(new SqlObject("select count(*) from Business_Contract Where SerialNo = :ObjectNo and InputUserID = :UserID").setParameter("ObjectNo", this.ObjectNo).setParameter("UserID", UserID));
			if(Integer.parseInt(sCount)>0)//���Ϊ�ǣ�����У��
			{
				//���ʱ��
				String sVetoTime = Sqlca.getString(new SqlObject("select BeginTime from Flow_Task where ObjectNo = :ObjectNo and SerialNo = (select Max(SerialNo) from Flow_Task where ObjectNo = :ObjectNo)").setParameter("ObjectNo", this.ObjectNo));
				if(null == sVetoTime) sVetoTime = "";
				//���������ĸ��������¼
				Record_SerialNo = Sqlca.getString("select min(serialno) from Reconsider_Quota_Record where SaleID = '"+UserID+"' and RemainingQuota >=1 and to_date(substr('"+sVetoTime+"',0,10),'yyyy/mm/dd') between to_date(BeginTime,'yyyy/mm/dd') and to_date(EndTime,'yyyy/mm/dd') and ROUND(TO_NUMBER(sysdate - to_date('"+sVetoTime+"','yyyy/mm/dd hh24:mi:ss'))*24*60*60) <= 72*60*60");
				if(null == Record_SerialNo) Record_SerialNo = "";
				if(!"".equals(Record_SerialNo))//�������������ĸ��������¼���������������ʾ��Ȩ��
				{
					sReturn = "Success";
				}else
				{
					sReturn = "Faile";
				}
			}else//���Ϊ�񣬷���У�鲻ͨ��
			{
				sReturn = "Faile";
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return sReturn;
	}
	
	//��װ���ֶ�
	private static ArrayList<String> ColNameList = new ArrayList<String>();
	public static ArrayList<String> InitColumns(String TableName,Transaction Sqlca) throws Exception
	{
		ASResultSet RS_COLUMNS = Sqlca.getResultSet(new SqlObject("SELECT COLUMN_NAME FROM USER_COL_COMMENTS WHERE TABLE_NAME = :TABLENAME").setParameter("TABLENAME", TableName));
		while(RS_COLUMNS.next())
		{
			ColNameList.add(RS_COLUMNS.getString("COLUMN_NAME"));
		}
		RS_COLUMNS.getStatement().close();
		
		return ColNameList;
	}
	
	//��װ��Ҫ���¸�ֵ���ֶμ��ֶ�ֵ
	private static HashMap<String,String> ChangeColNameList = new HashMap<String, String>();
	public static void setValue(String name,String value) throws Exception
	{
		ChangeColNameList.put(name, value);
	}
	
	//��װSQL���
	private static HashMap<String,String> ColumnsList = new HashMap<String,String>();
	public static void MatchColumns(String TableName,String SerialNo,Transaction Sqlca) throws Exception
	{
			ASResultSet RS_COLNAME = Sqlca.getASResultSet(new SqlObject("SELECT * FROM "+TableName+" WHERE SERIALNO = :SERIALNO").setParameter("SERIALNO", SerialNo)) ;
			if(RS_COLNAME.next())
			{
				for(int i = 0;i<ColNameList.size();i++)
				{
				  String ColValues = RS_COLNAME.getString(ColNameList.get(i));
				  if(null == ColValues) ColValues = "";
				  ColumnsList.put(ColNameList.get(i),ColValues);
				  for(Iterator itervalue = ChangeColNameList.keySet().iterator();itervalue.hasNext();)
				  {
					  String key_column = (String) itervalue.next();
					  if(key_column.equals(ColNameList.get(i)))
					  {
						  ColumnsList.remove(ColNameList.get(i)) ;
						  ColumnsList.put(key_column,ChangeColNameList.get(key_column));
					  }
				  }
				  
			    }
			}
			RS_COLNAME.getStatement().close();
			
			String InsertSQL = "INSERT INTO "+TableName+"";
			String columnClause = "";
			String valueClause = "";
			for (Iterator iter = ColumnsList.keySet().iterator(); iter.hasNext();) {
				String key = (String) iter.next();
				if(ColumnsList.get(key).length()>0)
				{
					columnClause += ","+key;
					valueClause +=  ",'"+ColumnsList.get(key)+"'";
				}
			}
			if(columnClause.length()>0) columnClause = columnClause.substring(1);
			if(valueClause.length()>0) valueClause = valueClause.substring(1);
			InsertSQL += " ( "+columnClause+") values ("+valueClause+")";
			System.out.println("InsertSQL================"+InsertSQL);
			
			Sqlca.executeSQL(InsertSQL);
	}
	
	
	//Copyԭ��ͬ��Ϣ
	public String CopyContractInfo(Transaction Sqlca) throws Exception
	{
		sReturn = CheckReconsiderRule(Sqlca);
		if("Success".equals(sReturn))
		{
			try {
				//�ͻ����
				String sCustomerID = Sqlca.getString(new SqlObject("select CustomerID from Business_Contract Where SerialNo = :ObjectNo").setParameter("ObjectNo", this.ObjectNo));
				if(null == sCustomerID) sCustomerID = "";
				GenerateSerialNo GS = new GenerateSerialNo();
				GS.setSerialNo(sCustomerID);
				//�²����ĺ�ͬ��ţ������ĺ�ͬ���
				String bc_SerialNo = GS.getContractId(Sqlca);
				//�²�����������
				String ba_SerialNo = DBKeyHelp.getSerialNo("Business_Contract", "SerialNo");
				setValue("SERIALNO",bc_SerialNo);//�����ĺ�ͬ���
				setValue("APPLYSERIALNO",ba_SerialNo);//������
				setValue("RELATIVESERIALNO",this.ObjectNo);//ԭ��ͬ���
				setValue("ISRECONSIDER","1");//�Ƿ񸴻��ͬ��ʶ��1���ǣ�
				setValue("OCCUPYPLACESSERIALNO",Record_SerialNo);//��ռ�õĸ���������ˮ��
				setValue("CONTRACTSTATUS","060");//��ͬ״̬
				setValue("INPUTUSERID",UserID);
				setValue("INPUTDATE",StringFunction.getTodayNow());
				setValue("UPDATEDATE",InputTime.substring(0, 10));
				setValue("OPERATEDATE",InputTime.substring(0, 10));
				setValue("UPLOADFLAG","");//�ϴ���ʶ
				setValue("UPLOADTIME","");//�ϴ�ʱ��
				setValue("DAYRANGE","");//�ϴμ��ʱ��
				setValue("FIRSTDRAWINGDATE","");
				setValue("PUTOUTDATE","");
				setValue("MATURITY","");
				setValue("LOANRATETERMID","");
				setValue("RPTTERMID","");
				setValue("MONTHREPAYMENT","");
				setValue("ORIGINALPUTOUTDATE","");

				//��װ���ֶ�
				InitColumns("BUSINESS_CONTRACT",Sqlca);
				//��װSQL���
				MatchColumns("BUSINESS_CONTRACT",this.ObjectNo,Sqlca);
				
				//��ʼ����������
				InitializeFlow initFlow = new InitializeFlow();
				initFlow.setAttribute("ObjectType",this.ObjectType);
				initFlow.setAttribute("ObjectNo", bc_SerialNo);
				initFlow.setAttribute("ApplyType", this.ApplyType);
				initFlow.setAttribute("FlowNo", this.FlowNo);
				initFlow.setAttribute("PhaseNo", this.PhaseNo);
				initFlow.setAttribute("UserID", this.UserID);
				initFlow.setAttribute("OrgID", this.OrgID);
				initFlow.run(Sqlca);
				
				//copy��ͬ����
				CopyCustomerRecord ccr = new CopyCustomerRecord();
				ccr.setAttribute("SerialNo", bc_SerialNo);
				ccr.setAttribute("CustomerID", sCustomerID);
				ccr.run(Sqlca);
				
				//���¸��������¼�е�ʣ������
				Sqlca.executeSQL(new SqlObject("update Reconsider_Quota_Record set RemainingQuota = (RemainingQuota-1) where serialno = :SerialNo").setParameter("SerialNo", Record_SerialNo));
				
				sReturn = sReturn+"@"+bc_SerialNo;//������ݴ���ɹ����򷵻��²����ĺ�ͬ��ˮ���������������ݵĴ���
				
			} catch (Exception e) {
				Sqlca.rollback();
				// TODO Auto-generated catch block
				e.printStackTrace();
			};
			
		}
		return sReturn;
	}
	
	//����ԭ�ظ����ͬ��Ϣ
	public String GenerateReconsiderContractInfo(Transaction Sqlca) throws Exception
	{
		sReturn = CheckReconsiderRule(Sqlca);
		if("Success".equals(sReturn))
		{
			try {
				// ִ���ύ����
				SqlObject so;
				//��ÿ�ʼ���ڡ���������
				String sBeginTime = StringFunction.getToday()+" "+StringFunction.getNow();
				
				//�����̶����FLOW_OBJECT�и��³�һ�ʡ��·������ļ�¼
				String sSql1 =  " update FLOW_OBJECT set PhaseNo=:PhaseNo ,PhaseType =:PhaseType ,PhaseName=:PhaseName,FlowNo=:FlowNo,FlowName=:FlowName " +
		        " where ObjectNo = :ObjectNo and ObjectType=:ObjectType ";
			    so = new SqlObject(sSql1);
			    so.setParameter("ObjectType", ObjectType).setParameter("ObjectNo", ObjectNo).setParameter("PhaseType", "1010")
			    .setParameter("PhaseNo", "0010").setParameter("PhaseName", "����׶�").setParameter("FlowNo", "CreditFlow").setParameter("FlowName", "����ҵ������");
			    
			    //�����������FLOW_TASK������һ�ʡ��·������ļ�¼
			    //String sSerialNo = DBKeyHelp.getSerialNo("FLOW_TASK","SerialNo",Sqlca);
			    String sSerialNo = DBKeyHelp.getWorkNo();
			    String sSql2 =  " insert into FLOW_TASK(SerialNo,ObjectType,ObjectNo,PhaseType,ApplyType,FlowNo,FlowName, " +
					" PhaseNo,PhaseName,OrgID,UserID,UserName,OrgName,BegInTime,RELATIVESERIALNO,PHASEOPINION1) "+
					" values (:SerialNo,:ObjectType,:ObjectNo,:PhaseType,:ApplyType, " + 
					" :FlowNo,:FlowName,:PhaseNo,:PhaseName,:OrgID,:UserID, " +
					" :UserName,:OrgName,:BeginTime,:RELATIVESERIALNO,:PHASEOPINION1 )";
			    SqlObject so1 = new SqlObject(sSql2);
			    so1.setParameter("SerialNo", sSerialNo).setParameter("ObjectType", ObjectType).setParameter("ObjectNo", ObjectNo).setParameter("PhaseType", "1010")
			    .setParameter("ApplyType", ApplyType).setParameter("FlowNo", "CreditFlow").setParameter("FlowName", "����ҵ������").setParameter("PhaseNo", "0010")
			    .setParameter("PhaseName", "����׶�").setParameter("OrgID", OrgID).setParameter("UserID", UserID).setParameter("UserName", userName)
			    .setParameter("OrgName", orgName).setParameter("BeginTime", sBeginTime).setParameter("RELATIVESERIALNO", serialNo).setParameter("PHASEOPINION1", "ԭ�ظ���");
			   
//				        ֻ�޸�ԭ�к�ͬBusiness_Contract�������Ϣ������ȥCOPYһ�ݣ�����º�ͬ״̬�ȱ�Ҫ�ֶ�Ϊ���·�������
			    String sSql = "update BUSINESS_CONTRACT set RELATIVESERIALNO=:RELATIVESERIALNO ,ISRECONSIDER ='1' ,CONTRACTSTATUS='060',UPDATEDATE=:UPDATEDATE,OPERATEDATE=:OPERATEDATE,ResurrectionReason=:ResurrectionReason,ResurrectionReasonRemark=:ResurrectionReasonRemark " +
		        " where SerialNo = :SerialNo ";
			    SqlObject so3 = new SqlObject(sSql);
			    so3.setParameter("SerialNo", ObjectNo).setParameter("RELATIVESERIALNO", ObjectNo)
			    .setParameter("UPDATEDATE", InputTime.substring(0, 10)).setParameter("OPERATEDATE", InputTime.substring(0, 10))
			    .setParameter("ResurrectionReason", ResurrectionReason).setParameter("ResurrectionReasonRemark", ResurrectionReasonRemark);
			    
			    //ִ�в���͸������
			    Sqlca.executeSQL(so);
			    Sqlca.executeSQL(so1);
			    Sqlca.executeSQL(so3);
			    
			    //���¸��������¼�е�ʣ������
			    Sqlca.executeSQL(new SqlObject("update Reconsider_Quota_Record set RemainingQuota = (RemainingQuota-1) where serialno = :SerialNo").setParameter("SerialNo", Record_SerialNo));
				
			    //ɾ���˸����ͬ�������ᵥ����׼������ԭ�е�һ����¼����Ϊ�������ĺ�ͬ��һ���ύʱ�����һ����¼
			    Sqlca.executeSQL(new SqlObject("DELETE FROM batch_bc_engine where CONTRACTNO = :SerialNo ").setParameter("SerialNo", ObjectNo));
			    
			    //ɾ���ɺ�ͬģ������
			    Sqlca.executeSQL(new SqlObject("DELETE FROM formatdoc_record where ObjectNo = :SerialNo ").setParameter("SerialNo", ObjectNo));
				
				sReturn = "Success";
				sReturn = sReturn+"@";//������ݴ���ɹ����򷵻سɹ�
				
			} catch (Exception e) {
				Sqlca.rollback();
				// TODO Auto-generated catch block
				e.printStackTrace();
			};
			
		}
		return sReturn;
	}
	
	//�ع����ݣ��������ݴ����ɹ���ɾ���Ѿ����ɵ���Ҫ���ݣ�
	public String RollbackContractInfo(Transaction Sqlca) throws Exception 
	{
		//����-��ϻ������α�
		Sqlca.executeSQL(new SqlObject("delete from acct_rpt_segment where objectno = :ObjectNo").setParameter("ObjectNo", this.ObjectNo));
		
		//����-�������α�
		Sqlca.executeSQL(new SqlObject("delete from acct_rate_segment where objectno = :ObjectNo").setParameter("ObjectNo", this.ObjectNo));
		
		//����˺ű������ã�һ�Զ��ϵ
		Sqlca.executeSQL(new SqlObject("delete from acct_deposit_accounts where objectno = :ObjectNo").setParameter("ObjectNo", this.ObjectNo));
		
		//���������¼��
		Sqlca.executeSQL(new SqlObject("update Reconsider_Quota_Record set RemainingQuota = (RemainingQuota+1) where serialno = (select OccupyPlacesSerialNo from Business_Contract where SerialNo = :ObjectNo)").setParameter("ObjectNo", this.ObjectNo));

		//��ͬ��
		Sqlca.executeSQL(new SqlObject("delete from business_contract where serialno = :ObjectNo").setParameter("ObjectNo", this.ObjectNo));
		
		//���̼�¼��
		Sqlca.executeSQL(new SqlObject("delete from flow_task where objectno = :ObjectNo and ObjectType = :ObjectType").setParameter("ObjectNo", this.ObjectNo).setParameter("ObjectType", this.ObjectType));
		Sqlca.executeSQL(new SqlObject("delete from flow_object where objectno = :ObjectNo and ObjectType = :ObjectType").setParameter("ObjectNo", this.ObjectNo).setParameter("ObjectType", this.ObjectType));
		
		//���ü�����Ϣ��
		Sqlca.executeSQL(new SqlObject("delete from acct_fee_waive where objectno in(select serialno from acct_fee where objectno = :ObjectNo)").setParameter("ObjectNo", this.ObjectNo));
		
		//���÷�����
		Sqlca.executeSQL(new SqlObject("delete from acct_fee where objectno = :ObjectNo").setParameter("ObjectNo", this.ObjectNo));
		
		return "Success";
	}
}
