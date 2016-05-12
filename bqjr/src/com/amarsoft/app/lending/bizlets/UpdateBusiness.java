/**
 * content:������Ӧ�׶ε�ҵ�����,��������Ϣ
 * Author:fhuang
 * Time:2006.10.23
 * Input Param:ObjectType---��������
 * 			   ObjectNo-----������
 * 
 */

package com.amarsoft.app.lending.bizlets;

import com.amarsoft.are.util.StringFunction;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;


public class UpdateBusiness extends Bizlet {
	private String sObjectTable = "";
	private String sRelativeTable ="";
	private String sUserID = "";
	private String sOrgID = "";
	private String sUpdateDate = "";
	private String sUpdateTime = "";
	SqlObject so; 
	public Object run(Transaction Sqlca) throws Exception
	{
		String sObjectType = (String)this.getAttribute("ObjectType");
		String sObjectNo = (String)this.getAttribute("ObjectNo");
		String sToUserID = (String)this.getAttribute("ToUserID");
		String sToOrgID = (String)this.getAttribute("ToOrgID");
		//����ֵת��Ϊ���ַ���
		if(sObjectType == null) sObjectType = "";
		if(sObjectNo == null) sObjectNo = "";
		if(sToUserID == null) sToUserID = "";
		if(sToOrgID == null) sToOrgID = "";
		
		//��ȫ��˽�б�����ֵ
		this.sUserID = sToUserID;
		this.sOrgID = sToOrgID;
        this.sUpdateDate = StringFunction.getToday();
        this.sUpdateTime = StringFunction.getTodayNow();
        
		//��ȡ������
		getRelativeTable(sObjectType,Sqlca);
		//���¹�ͬ��������Ϣ
		updateBusinessApplicant(sObjectType,sObjectNo,Sqlca);
		//���µ��鱨����Ϣ
		if(sObjectType.equals("CreditApply"))
		{
			updateFormatDoc(sObjectType,sObjectNo,Sqlca);
		}
		//����Ʊ����Ϣ
		updateBillInfo(sObjectType,sObjectNo,Sqlca);
		//��������֤��Ϣ
		updateLCInfo(sObjectType,sObjectNo,Sqlca);
		//����ó�׺�ͬ��Ϣ
		updateContractInfo(sObjectType,sObjectNo,Sqlca);
		//������ֵ˰��Ʊ��Ϣ
		updateInvoiceInfo(sObjectType,sObjectNo,Sqlca);
		//���������ṩ��������Ϣ
		updateBusinessProvider(sObjectType,sObjectNo,Sqlca);
		//�����н���Ϣ
		if(!(sObjectType.equals("PutOutApply") || sObjectType.equals("BusinessDueBill")))
			updateAgencyInfo(this.sRelativeTable,sObjectNo,Sqlca);
		//�����ᵥ��Ϣ
		updateBolInfo(sObjectType,sObjectNo,Sqlca);
		//���·�������װ����Ϣ
		updateBuildingDeal(sObjectType,sObjectNo,Sqlca);
		//���µ�������Ϣ
		updateGuarantyInfo(sObjectType,sObjectNo,Sqlca);
		//���µ�����ͬ��Ϣ
		updateGuarantyContract(sObjectType,sObjectNo,Sqlca);
		//���·��ն�������Ϣ
		updateEvaluateRecord(sObjectType,sObjectNo,Sqlca);
		//���¸�ʽ�����鱨����Ϣ		
		updateDocInfo(sObjectType,sObjectNo,Sqlca);			
		//�������ŷ�����ϸ��Ϣ
		if(!(sObjectType.equals("PutOutApply") || sObjectType.equals("BusinessDueBill")))
			updateCLInfo(sObjectType,sObjectNo,Sqlca);	
		
		//�������������Ϣ
		updateObjectInfo(sObjectType,sObjectNo,Sqlca);
		return "SUCCESS";
	}
	//��ȡ������
	 private void getRelativeTable(String sObjectType,Transaction Sqlca)
		throws Exception
	 {
		 String sSql = "";	 
		 ASResultSet rs = null;
		 //����sObjectType�Ĳ�ͬ���õ���ͬ�Ĺ�������
		 sSql = " select ObjectTable,RelativeTable "+
		 		" from OBJECTTYPE_CATALOG "+
		 		" where ObjectType =:ObjectType ";	
		 so = new SqlObject(sSql).setParameter("ObjectType", sObjectType);
		 rs = Sqlca.getASResultSet(so);
		 if(rs.next())
		 {
			 this.sObjectTable = rs.getString("ObjectTable");
			 this.sRelativeTable = rs.getString("RelativeTable");
		 }
		 rs.getStatement().close();	 	 
	 }
	 
	 //���¹�ͬ�����˵Ļ���
	 private void updateBusinessApplicant(String sObjectType,String sObjectNo,Transaction Sqlca)
	 	throws Exception
	 {
		 String sSql = "";
		 sSql = " update BUSINESS_APPLICANT set "+
		 		" InputOrgID =:InputOrgID, "+
		 		" InputUserID =:InputUserID, "+
		 		" UpdateDate =:UpdateDate "+
		 		" where ObjectType =:ObjectType "+
		 		" and ObjectNo =:ObjectNo ";
		 so = new SqlObject(sSql).setParameter("InputOrgID", sOrgID).setParameter("InputUserID", sUserID).setParameter("UpdateDate", sUpdateDate)
		 .setParameter("ObjectType", sObjectType).setParameter("ObjectNo", sObjectNo);
		 //ִ�и������
		 Sqlca.executeSQL(so);
	 }
	 
	 //���¸�ʽ���ĵ���Ϣ
	 private void updateFormatDoc(String sObjectType,String sObjectNo,Transaction Sqlca)
	 	throws Exception
	 {
		 String sSql = "";
		 sSql = " update FORMATDOC_DATA set "+
		 		" OrgID =:OrgID, "+
		 		" UserID =:UserID, "+
		 		" UpdateDate =:UpdateDate "+
		 		" where ObjectType =:ObjectType "+
		 		" and ObjectNo =:ObjectNo ";
		 so = new SqlObject(sSql).setParameter("OrgID", sOrgID).setParameter("UserID", sUserID)
		 .setParameter("UpdateDate", sUpdateDate).setParameter("ObjectType", sObjectType).setParameter("ObjectNo", sObjectNo);
		 //ִ�и������
		 Sqlca.executeSQL(so);
	 }
	 
	 //����Ʊ��
	 private void updateBillInfo(String sObjectType,String sObjectNo,Transaction Sqlca)
		throws Exception
	 {
		 String sSql = "";
		 sSql = " update BILL_INFO  set "+
		 		" InputOrgID =:InputOrgID, "+
		 		" InputUserID =:InputUserID, "+
		 		" UpdateDate =:UpdateDate "+
		 		" where ObjectType =:ObjectType "+
		 		" and ObjectNo =:ObjectNo ";
		 //ִ�и������
		 so = new SqlObject(sSql).setParameter("InputOrgID", sOrgID).setParameter("InputUserID", sUserID)
		 .setParameter("UpdateDate", sUpdateDate).setParameter("ObjectType", sObjectType).setParameter("ObjectNo", sObjectNo);
		 Sqlca.executeSQL(so);
	 }
	 
	 //��������֤��Ϣ
	 private void updateLCInfo(String sObjectType,String sObjectNo,Transaction Sqlca)
		throws Exception
	 {
		 String sSql = "";
		 sSql = " update LC_INFO set "+
		 		" InputOrgID =:InputOrgID, "+
		 		" InputUserID =:InputUserID, "+
		 		" UpdateDate =:UpdateDate "+
		 		" where ObjectType =:ObjectType "+
		 		" and ObjectNo =:ObjectNo ";
			 //ִ�и������
		 so = new SqlObject(sSql).setParameter("InputOrgID", sOrgID).setParameter("InputUserID", sUserID).setParameter("UpdateDate", sUpdateDate)
		 .setParameter("ObjectType", sObjectType).setParameter("ObjectNo", sObjectNo);
			 Sqlca.executeSQL(so);
	 }
	 
	 //����ó�׺�ͬ��Ϣ
	 private void updateContractInfo(String sObjectType,String sObjectNo,Transaction Sqlca)
		throws Exception
	 {
		 String sSql = "";
		 sSql = " update CONTRACT_INFO set "+
		 		" InputOrgID =:InputOrgID, "+
		 		" InputUserID =:InputUserID, "+
		 		" UpdateDate =:UpdateDate "+
		 		" where ObjectType =:ObjectType "+
		 		" and ObjectNo =:ObjectNo ";
	 //ִ�и������
		 so = new SqlObject(sSql).setParameter("InputOrgID", sOrgID).setParameter("InputUserID", sUserID).setParameter("UpdateDate", sUpdateDate)
		 .setParameter("ObjectType", sObjectType).setParameter("ObjectNo", sObjectNo);
			 Sqlca.executeSQL(so);
	 }
	 
	 //������ֵ˰��Ʊ��Ϣ
	 private void updateInvoiceInfo(String sObjectType,String sObjectNo,Transaction Sqlca)
		throws Exception
	 {
		 String sSql = "";
		 sSql = " update INVOICE_INFO set "+
		 		" InputOrgID =:InputOrgID, "+
		 		" InputUserID =:InputUserID, "+
		 		" UpdateDate =:UpdateDate "+
		 		" where ObjectType =:ObjectType "+
				" and ObjectNo =:ObjectNo ";
	 //ִ�и������
		 so = new SqlObject(sSql).setParameter("InputOrgID", sOrgID).setParameter("InputUserID", sUserID).setParameter("UpdateDate", sUpdateDate)
		 .setParameter("ObjectType", sObjectType).setParameter("ObjectNo", sObjectNo);
		 Sqlca.executeSQL(so);
	 }
	 
	 //���������ṩ��������Ϣ
	 private void updateBusinessProvider(String sObjectType,String sObjectNo,Transaction Sqlca)
		throws Exception
	 {
		 String sSql = "";
		 sSql = " update BUSINESS_PROVIDER set "+
		 		" InputOrgID =:InputOrgID, "+
		 		" InputUserID =:InputUserID, "+
		 		" UpdateDate =:UpdateDate "+
		 		" where ObjectType =:ObjectType "+
				" and ObjectNo =:ObjectNo ";
		 //ִ�и������
		 so = new SqlObject(sSql).setParameter("InputOrgID", sOrgID).setParameter("InputUserID", sUserID).setParameter("UpdateDate", sUpdateDate)
		 .setParameter("ObjectType", sObjectType).setParameter("ObjectNo", sObjectNo);
		 Sqlca.executeSQL(so);
	 }
	
	 
	 //�����н���Ϣ
	 private void updateAgencyInfo(String sRelativeTable,String sObjectNo,Transaction Sqlca)
		throws Exception
	 {
		 String sSql = "";
		 sSql = " update AGENCY_INFO set "+
		 		" InputOrgID =:InputOrgID, "+
		 		" InputUserID =:InputUserID, "+
		 		" UpdateDate =:UpdateDate "+
		 		" where SerialNo in "+
		 		" (select ObjectNo from "+sRelativeTable+" "+
		 		" where SerialNo =:SerialNo "+
		 		" and ObjectType = 'AgencyInfo') ";
		 so = new SqlObject(sSql).setParameter("InputOrgID", sOrgID).setParameter("InputUserID", sUserID).setParameter("UpdateDate", sUpdateDate)
		 .setParameter("SerialNo", sObjectNo);
		 //ִ�и������
		 Sqlca.executeSQL(so);
	 }
	 
	 //�����ᵥ��Ϣ
	 private void updateBolInfo(String sObjectType,String sObjectNo,Transaction Sqlca)
		throws Exception
	 {
		 String sSql = "";
		 sSql = " update BOL_INFO set "+
		 		" InputOrgID =:InputOrgID, "+
		 		" InputUserID =:InputUserID, "+
		 		" UpdateDate =:UpdateDate "+
		 		" where ObjectType =:ObjectType "+
				" and ObjectNo =:ObjectNo ";
	 //ִ�и������
		 so = new SqlObject(sSql).setParameter("InputOrgID", sOrgID).setParameter("InputUserID", sUserID).setParameter("UpdateDate", sUpdateDate)
		 .setParameter("ObjectType", sObjectType).setParameter("ObjectNo", sObjectNo);
		 Sqlca.executeSQL(so);
	 }
	 
	 //���·�������װ����Ϣ
	 private void updateBuildingDeal(String sObjectType,String sObjectNo,Transaction Sqlca)
		throws Exception
	 {
		 String sSql = "";
		 sSql = " update BUILDING_DEAL set "+
		 		" InputOrgID =:InputOrgID, "+
		 		" InputUserID =:InputUserID, "+
		 		" UpdateDate =:UpdateDate "+
		 		" where ObjectType =:ObjectType "+
			    " and ObjectNo =:ObjectNo ";
	 //ִ�и������
	 so = new SqlObject(sSql).setParameter("InputOrgID", sOrgID).setParameter("InputUserID", sUserID).setParameter("UpdateDate", sUpdateDate)
	 .setParameter("ObjectType", sObjectType).setParameter("ObjectNo", sObjectNo);
	 Sqlca.executeSQL(so);
		 
	 }
	 
	 
	 //���µ�������Ϣ
	 private void updateGuarantyInfo(String sObjectType,String sObjectNo,Transaction Sqlca)
		throws Exception
	 {
		 String sSql = "";
		 sSql = " update GUARANTY_INFO set "+
		 		" InputOrgID =:InputOrgID, "+
		 		" InputUserID =:InputUserID, "+
		 		" UpdateUserID =:UpdateUserID, "+
		 		" UpdateDate =:UpdateDate "+
		 		" where GuarantyID in "+
		 		" (select GuarantyID from GUARANTY_RELATIVE "+
		 		" where ObjectType =:ObjectType "+
		 		" and ObjectNo =:ObjectNo) ";
		 //ִ�и������
		 so = new SqlObject(sSql).setParameter("InputOrgID", sOrgID).setParameter("InputUserID", sUserID).setParameter("UpdateUserID", sUserID)
		 .setParameter("UpdateDate", sUpdateDate).setParameter("ObjectType", sObjectType).setParameter("ObjectNo", sObjectNo);
		 Sqlca.executeSQL(so);
	 }
	 
	 //���µ�����ͬ��Ϣ
	 private void updateGuarantyContract(String sObjectType,String sObjectNo,Transaction Sqlca)
		throws Exception
	 {
		 String sSql = "";
		 sSql = " update GUARANTY_CONTRACT  set "+
		 		" InputOrgID =:InputOrgID, "+
		 		" InputUserID =:InputUserID, "+
		 		" UpdateUserID =:UpdateUserID, "+
		 		" UpdateDate =:UpdateDate "+
		 		" where SerialNo in "+
		 		" (select ContractNo from GUARANTY_RELATIVE "+
		 		" where ObjectType =:ObjectType "+
		 		" and ObjectNo =:ObjectNo') ";
		 //ִ�и������
		 so = new SqlObject(sSql).setParameter("InputOrgID", sOrgID).setParameter("InputUserID", sUserID).setParameter("UpdateUserID", sUserID)
		 .setParameter("UpdateDate", sUpdateDate).setParameter("ObjectType", sObjectType).setParameter("ObjectNo", sObjectNo);
		 Sqlca.executeSQL(so);
	 }
	 
	 //���·��ն�������¼��Ϣ
	 private void updateEvaluateRecord(String sObjectType,String sObjectNo,Transaction Sqlca)
		throws Exception
	 {
		 String sSql = "";
		 sSql = " update EVALUATE_RECORD set "+
		 		" OrgID =:OrgID, "+
		 		" UserID =:UserID, "+
		 		" CognOrgID =:CognOrgID, "+
		 		" CognUserID =:CognUserID "+
		 		" where ObjectType =:ObjectType "+
		 		" and ObjectNo =:ObjectNo "+
		 		" and ModelNo = 'RiskEvaluate'";
		 //ִ�и������
		 so = new SqlObject(sSql).setParameter("OrgID", sOrgID).setParameter("UserID", sUserID).setParameter("CognOrgID", sOrgID)
		 .setParameter("CognUserID", sUserID).setParameter("ObjectType", sObjectType).setParameter("ObjectNo", sObjectNo);
		 Sqlca.executeSQL(so);
	 }
	 
	 //�����ĵ���Ϣ
	 private void updateDocInfo(String sObjectType,String sObjectNo,Transaction Sqlca)
		throws Exception
	 {
		 String sSql = "";
		 //�����ĵ��ĸ�����Ϣ
		 sSql = " update DOC_ATTACHMENT set "+
		 		" InputOrg =:InputOrg, "+
		 		" InputUser =:InputUser, "+
		 		" UpdateUser =:UpdateUser, "+
		 		" UpdateTime =:UpdateTime "+
		 		" where DocNo in "+
		 		" (select DocNo from DOC_RELATIVE "+
		 		" where ObjectType =:ObjectType "+
		 		" and ObjectNo =:ObjectNo) ";
		 so = new SqlObject(sSql).setParameter("InputOrg", sOrgID).setParameter("InputUser", sUserID).setParameter("UpdateUser", sUserID)
		 .setParameter("UpdateTime", sUpdateTime).setParameter("ObjectType", sObjectType).setParameter("ObjectNo", sObjectNo);
		 	Sqlca.executeSQL(so);
		 //�����ĵ�����
		 	sSql=  " update DOC_LIBRARY set "+
			 		" OrgID =:OrgID, "+		 		
			 		" UserID=:UserID, "+
			 		" InputOrg =:InputOrg, "+
			 		" InputUser =:InputUser, "+
			 		" UpdateUser =:UpdateUser, "+
			 		" UpdateTime =:UpdateTime "+
			 		" where DocNo in "+
			 		" (select DocNo from DOC_RELATIVE "+
			 		" where ObjectType =:ObjectType "+
			 		" and ObjectNo =:ObjectNo) ";
		 //ִ�и������
		 	so = new SqlObject(sSql).setParameter("OrgID", sOrgID).setParameter("UserID", sUserID).setParameter("InputOrg", sOrgID)
		 	.setParameter("InputUser", sUserID).setParameter("UpdateUser", sUserID).setParameter("UpdateTime", sUpdateTime)
		 	.setParameter("ObjectType", sObjectType).setParameter("ObjectNo", sObjectNo);
		 Sqlca.executeSQL(so);
		 
		 sSql=  " update DOC_LIBRARY set "+
		 		" OrgName = getOrgName(OrgID),"+
		 		" UserName = getUserName(UserID) "+
		 		" where DocNo in "+
		 		" (select DocNo from DOC_RELATIVE "+
		 		" where ObjectType =:ObjectType "+
		    	" and ObjectNo =:ObjectNo) ";
		 //ִ�и������
		 so = new SqlObject(sSql).setParameter("ObjectType", sObjectType).setParameter("ObjectNo", sObjectNo);
		 Sqlca.executeSQL(so);	
	 }
	 
	 //�������Ŷ����Ϣ
	 private void updateCLInfo(String sObjectType,String sObjectNo,Transaction Sqlca)
		throws Exception
	 {
		 String sSql = "";
		 String sSql1 = "";
		 //���ݶ������ͽ��и��²�������
		 if(sObjectType.equals("CreditApply"))
		 {
			 sSql = " select LineID "+
		 			" from CL_INFO "+
		 			" where ApplySerialNo =:ApplySerialNo ";
			 so = new SqlObject(sSql).setParameter("ApplySerialNo", sObjectNo);

			 sSql1 = " update CL_INFO set "+
			 		 " InputOrg =:InputOrg, "+
			 		 " InputUser =:InputUser, "+
			 		 " UpdateTime =:UpdateTime "+
			 		 " where ApplySerialNo =:ApplySerialNo ";
			 so = new SqlObject(sSql1).setParameter("InputOrg", sOrgID).setParameter("InputUser", sUserID)
			 .setParameter("UpdateTime", sUpdateTime).setParameter("ApplySerialNo", sObjectNo);
			 Sqlca.executeSQL(so);
		 }else if(sObjectType.equals("ApproveApply"))
		 {
	
			 sSql = " select LineID "+
			 		" from CL_INFO "+
			 		" where ApproveSerialNo =:ApproveSerialNo ";
			 so = new SqlObject(sSql).setParameter("ApproveSerialNo", sObjectNo);
			 
			 sSql1 = " update CL_INFO set "+
			 		 " InputOrg =:InputOrg, "+
			 		 " InputUser =:InputUser, "+
			 		 " UpdateTime =:UpdateTime "+
			 		 " where ApproveSerialNo =:ApproveSerialNo ";
			 so = new SqlObject(sSql1).setParameter("InputOrg", sOrgID).setParameter("InputUser", sUserID)
			 .setParameter("UpdateTime", sUpdateTime).setParameter("ApproveSerialNo", sObjectNo);
			 Sqlca.executeSQL(so);
		 }else if(sObjectType.equals("BusinessContract"))
		 {
			 sSql = " select LineID "+
		 			" from CL_INFO "+
		 			" where BCSerialNo =:BCSerialNo ";	
			 so = new SqlObject(sSql).setParameter("BCSerialNo", sObjectNo);

			 sSql1 = " update CL_INFO set "+
	 		 " InputOrg =:InputOrg, "+
	 		 " InputUser =:InputUser, "+
	 		 " UpdateTime =:UpdateTime "+
	 		 " where BCSerialNo =:BCSerialNo ";
			 so = new SqlObject(sSql1).setParameter("InputOrg", sOrgID).setParameter("InputUser", sUserID)
			 .setParameter("UpdateTime", sUpdateTime).setParameter("BCSerialNo", sObjectNo);
			 Sqlca.executeSQL(so);
		 }
		 
		 String sLineID = Sqlca.getString(sSql);

			 sSql = " update CL_LIMITATION_SET set "+
			 		" InputOrg =:InputOrg, "+
			 		" InputUser =:InputUser, "+
			 		" UpdateTime =:UpdateTime "+
			 		" where LineID =:LineID ";
			 so = new SqlObject(sSql).setParameter("InputOrg", sOrgID).setParameter("InputUser", sUserID)
			 .setParameter("UpdateTime", sUpdateTime).setParameter("LineID", sLineID);
			 //ִ�и������
			 Sqlca.executeSQL(so);

			 sSql = " update CL_LIMITATION set "+
			 		" InputOrg =:InputOrg, "+
			 		" InputUser =:InputUser, "+
			 		" UpdateTime =:UpdateTime "+
			 		" where LineID =:LineID ";
			 //ִ�и������
			 so = new SqlObject(sSql).setParameter("InputOrg", sOrgID).setParameter("InputUser", sUserID)
			 .setParameter("UpdateTime", sUpdateTime).setParameter("LineID", sLineID);
			 Sqlca.executeSQL(so);
	 }
	 
	 //�������������Ϣ
	 private void updateObjectInfo(String sObjectType,String sObjectNo,Transaction Sqlca)
		throws Exception
	 {
		 String sSql = "";
		 if(sObjectType.equals("CreditApply")) //����
		 {
			 //����������Ϣ
			 sSql = " update "+sObjectTable+" set "+
			 		" InputOrgID =:InputOrgID , "+
			 		" InputUserID =:InputUserID , "+
			 		" OperateOrgID =:OperateOrgID , "+
			 		" OperateUserID =:OperateUserID , "+
			 		" UpdateDate =:UpdateDate "+
			 		" where SerialNo =:SerialNo ";
			 so = new SqlObject(sSql).setParameter("InputOrgID", sOrgID).setParameter("InputUserID", sUserID).setParameter("OperateOrgID", sOrgID)
			 .setParameter("OperateUserID", sUserID).setParameter("UpdateDate", sUpdateDate).setParameter("SerialNo", sObjectNo);
			 Sqlca.executeSQL(so);	 
			 //�������̶������Ϣ
			 sSql = " update FLOW_OBJECT set "+
			 		" OrgID =:OrgID, "+
			 		" UserID =:UserID "+
			 		" where ObjectType =:ObjectType "+
			    	" and ObjectNo =:ObjectNo ";
			 so = new SqlObject(sSql).setParameter("OrgID", sOrgID).setParameter("UserID", sUserID).setParameter("ObjectType", sObjectType)
			 .setParameter("ObjectNo", sObjectNo);
			 Sqlca.executeSQL(so);
			 
			 sSql = " update FLOW_OBJECT set "+
			 		" OrgName = getOrgName(OrgID), "+
			 		" UserName = getUserName(UserID) "+
			 		" where ObjectType =:ObjectType "+
			    	" and ObjectNo =:ObjectNo ";
			 so = new SqlObject(sSql).setParameter("ObjectType", sObjectType).setParameter("ObjectNo", sObjectNo);
			 Sqlca.executeSQL(so);
			 //��ȡ����ĳ�ʼ�׶�
			 sSql = "select min(PhaseNo) from FLOW_TASK where ObjectType =:ObjectType and ObjectNo =:ObjectNo ";
			 so = new SqlObject(sSql).setParameter("ObjectType", sObjectType).setParameter("ObjectNo", sObjectNo);
			 String sPhaseNo = Sqlca.getString(so);
			 //��������������Ϣ
			 sSql = " update FLOW_TASK set "+
			 		" OrgID =:OrgID, "+
			 		" UserID =:UserID "+
			 		" where ObjectType =:ObjectType "+
			    	" and ObjectNo =:ObjectNo " +
			 		" and PhaseNo =:PhaseNo ";
			 so = new SqlObject(sSql).setParameter("OrgID", sOrgID).setParameter("UserID", sUserID).setParameter("ObjectType", sObjectType)
			 .setParameter("ObjectNo", sObjectNo).setParameter("PhaseNo", sPhaseNo);
			 Sqlca.executeSQL(so);

			 sSql = " update FLOW_TASK set "+
			 		" OrgName = getOrgName(OrgID), "+
			 		" UserName = getUserName(UserID) "+
			 		" where ObjectType =:ObjectType "+
			    	" and ObjectNo =:ObjectNo " +
			    	" and PhaseNo =:PhaseNo ";
			 so = new SqlObject(sSql).setParameter("ObjectType", sObjectType).setParameter("ObjectNo", sObjectNo).setParameter("PhaseNo", sPhaseNo);
			 Sqlca.executeSQL(so);
			 
		 }
		 
		 //������������������������������¼��Ա¼��ģ���˲���������������Ϣ
		 if(sObjectType.equals("ApproveApply")) //�����������
		 {
			 sSql = " update "+sObjectTable+" set "+			 		
			 		" OperateOrgID =:OperateOrgID, "+
			 		" OperateUserID =:OperateUserID, "+
			 		" UpdateDate =:UpdateDate "+
			 		" where SerialNo =:SerialNo ";
			 so = new SqlObject(sSql).setParameter("OperateOrgID", sOrgID).setParameter("OperateUserID", sUserID)
			 .setParameter("UpdateDate", sUpdateDate).setParameter("SerialNo", sObjectNo);
		 Sqlca.executeSQL(so);
		 }
		 
		 if(sObjectType.equals("BusinessContract")) //��ͬ
		 {
			 //���º�ͬ����Ϣ
			 sSql = " update "+sObjectTable+" set "+
			 		" InputOrgID =:InputOrgID, "+
			 		" InputUserID =:InputUserID, "+
			 		" OperateOrgID =:OperateOrgID, "+
			 		" OperateUserID =:OperateUserID, "+
			 		" ManageOrgID =:ManageOrgID, "+
			 		" ManageUserID =:ManageUserID, "+
			 		" UpdateDate =:UpdateDate "+
			 		" where SerialNo =:SerialNo ";
			 so = new SqlObject(sSql);
			 so.setParameter("InputOrgID", sOrgID).setParameter("InputUserID", sUserID).setParameter("OperateOrgID", sOrgID)
			 .setParameter("OperateUserID", sUserID).setParameter("ManageOrgID", sOrgID).setParameter("ManageUserID", sUserID)
			 .setParameter("UpdateDate", sUpdateDate).setParameter("SerialNo", sObjectNo);
		 Sqlca.executeSQL(so);
			 //���·��ռ�鱨����Ϣ
			 sSql = " update INSPECT_INFO set "+
			 		" InputOrgID =:InputOrgID, "+
			 		" InputUserID =:InputUserID, "+
			 		" UpdateDate =:UpdateDate "+
			 		" where ObjectType =:ObjectType "+
			 		" and ObjectNo =:ObjectNo ";
			 so = new SqlObject(sSql).setParameter("InputOrgID", sOrgID).setParameter("InputUserID", sUserID).setParameter("UpdateDate", sUpdateDate)
			 .setParameter("ObjectType", sObjectType).setParameter("ObjectNo", sObjectNo);
			 Sqlca.executeSQL(so);
			 //���´��պ���Ϣ
			 sSql = " update DUN_INFO set "+
			 		" OperateOrgID =:OperateOrgID, "+
			 		" OperateUserID =:OperateUserID, "+
			 		" InputOrgID =:InputOrgID, "+
			 		" InputUserID =:InputUserID, "+
			 		" UpdateDate =:UpdateDate "+
			 		" where ObjectType =:ObjectType "+
			 		" and ObjectNo =:ObjectNo ";
			 so = new SqlObject(sSql).setParameter("OperateOrgID", sOrgID).setParameter("OperateUserID", sUserID)
			 .setParameter("InputOrgID", sOrgID).setParameter("InputUserID", sUserID).setParameter("UpdateDate", sUpdateDate)
			 .setParameter("ObjectType", sObjectType).setParameter("ObjectNo", sObjectNo);
			 Sqlca.executeSQL(so);
		 }
		 
		 if(sObjectType.equals("PutOutApply")) //����
		 {
			 //���³�����Ϣ
			 sSql = " update "+sObjectTable+" set "+
			 		" InputOrgID =:InputOrgID, "+
			 		" InputUserID =:InputUserID, "+
			 		" OperateOrgID =:OperateOrgID, "+
			 		" OperateUserID =:OperateUserID, "+
			 		" UpdateDate =:UpdateDate "+
			 		" where SerialNo =:SerialNo ";
			 so = new SqlObject(sSql).setParameter("InputOrgID", sOrgID).setParameter("InputUserID", sUserID).setParameter("OperateOrgID", sOrgID)
			 .setParameter("OperateUserID", sUserID).setParameter("UpdateDate", sUpdateDate).setParameter("SerialNo", sObjectNo);
			 Sqlca.executeSQL(so);
			 //�������̶������Ϣ
			 sSql = " update FLOW_OBJECT set "+
			 		" OrgID =:OrgID, "+
			 		" UserID =:UserID "+
			 		" where ObjectType =:ObjectType "+
			    	" and ObjectNo =:ObjectNo ";
			 so = new SqlObject(sSql).setParameter("OrgID", sOrgID).setParameter("UserID", sUserID).setParameter("ObjectType", sObjectType)
			 .setParameter("ObjectNo", sObjectNo);
			 Sqlca.executeSQL(so);
			 sSql = " update FLOW_OBJECT set "+
			 		" OrgName = getOrgName(OrgID), "+
			 		" UserName = getUserName(UserID) "+
			 		" where ObjectType =:ObjectType "+
			    	" and ObjectNo =:ObjectNo ";
			 so = new SqlObject(sSql).setParameter("ObjectType", sObjectType).setParameter("ObjectNo", sObjectNo);
			 Sqlca.executeSQL(so);
			 //��ȡ����ĳ�ʼ�׶�
			 sSql = "select min(PhaseNo) from FLOW_TASK where ObjectType =:ObjectType and ObjectNo =:ObjectNo ";
			 so = new SqlObject(sSql).setParameter("ObjectType", sObjectType).setParameter("ObjectNo", sObjectNo);
			 String sPhaseNo = Sqlca.getString(so);
			 //��������������Ϣ
			 sSql = " update FLOW_TASK set "+
			 		" OrgID =:OrgID, "+
			 		" UserID =:UserID "+
			 		" where ObjectType =:ObjectType "+
			    	" and ObjectNo =:ObjectNo " +
			    	" and PhaseNo =:PhaseNo ";
			 so = new SqlObject(sSql).setParameter("OrgID", sOrgID).setParameter("UserID", sUserID).setParameter("ObjectType", sObjectType)
			 .setParameter("ObjectNo", sObjectNo).setParameter("PhaseNo", sPhaseNo);
			 Sqlca.executeSQL(so);
			 sSql = " update FLOW_TASK set "+
			 		" OrgName = getOrgName(OrgID), "+
			 		" UserName = getUserName(UserID) "+
			 		" where ObjectType =:ObjectType "+
			    	" and ObjectNo =:ObjectNo " +
			    	" and PhaseNo =:PhaseNo ";
			 so = new SqlObject(sSql).setParameter("ObjectType", sObjectType).setParameter("ObjectNo", sObjectNo).setParameter("PhaseNo", sPhaseNo);
			 Sqlca.executeSQL(so);
		 }
		 
		 if(sObjectType.equals("BusinessDueBill")) //���
		 {
			 sSql = " update "+sObjectTable+" set "+
			 		" InputOrgID =:InputOrgID, "+
			 		" InputUserID =:InputUserID, "+
			 		" OperateOrgID =:OperateOrgID, "+
			 		" OperateUserID =:OperateUserID, "+
			 		" UpdateDate =:UpdateDate "+
			 		" where SerialNo =:SerialNo ";
			 so = new SqlObject(sSql).setParameter("InputOrgID", sOrgID).setParameter("InputUserID", sUserID).setParameter("OperateOrgID", sOrgID)
			 .setParameter("OperateUserID", sUserID).setParameter("UpdateDate", sUpdateDate).setParameter("SerialNo", sObjectNo);
			 Sqlca.executeSQL(so);
		 }
		 		 
		 if(sObjectType.equals("BusinessContract") || sObjectType.equals("BusinessDueBill")) //��ͬ�ͽ��
		 {
			 //���·��շ������Ϣ
			 sSql = " update CLASSIFY_RECORD set "+
			 		" OrgID =:OrgID ', "+
			 		" UserID =:UserID, "+
			 		" ClassifyOrgID =:ClassifyOrgID, "+
			 		" ClassifyUserID =:ClassifyUserID, "+
			 		" UpdateDate =:UpdateDate "+
			 		" where ObjectType =:ObjectType "+
			    	" and ObjectNo =:ObjectNo ";
			 so = new SqlObject(sSql).setParameter("OrgID", sOrgID).setParameter("UserID", sUserID).setParameter("ClassifyOrgID", sOrgID)
			 .setParameter("ClassifyUserID", sUserID).setParameter("UpdateDate", sUpdateDate).setParameter("ObjectType", sObjectType)
			 .setParameter("ObjectNo", sObjectNo);
			 Sqlca.executeSQL(so);
		 }
	 }
}
