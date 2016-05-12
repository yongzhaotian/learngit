/**
 * content:更新相应阶段的业务机构,经办人信息
 * Author:fhuang
 * Time:2006.10.23
 * Input Param:ObjectType---对象类型
 * 			   ObjectNo-----对象编号
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
		//将空值转化为空字符串
		if(sObjectType == null) sObjectType = "";
		if(sObjectNo == null) sObjectNo = "";
		if(sToUserID == null) sToUserID = "";
		if(sToOrgID == null) sToOrgID = "";
		
		//给全局私有变量赋值
		this.sUserID = sToUserID;
		this.sOrgID = sToOrgID;
        this.sUpdateDate = StringFunction.getToday();
        this.sUpdateTime = StringFunction.getTodayNow();
        
		//获取关联表
		getRelativeTable(sObjectType,Sqlca);
		//更新共同申请人信息
		updateBusinessApplicant(sObjectType,sObjectNo,Sqlca);
		//更新调查报告信息
		if(sObjectType.equals("CreditApply"))
		{
			updateFormatDoc(sObjectType,sObjectNo,Sqlca);
		}
		//更新票据信息
		updateBillInfo(sObjectType,sObjectNo,Sqlca);
		//更新信用证信息
		updateLCInfo(sObjectType,sObjectNo,Sqlca);
		//更新贸易合同信息
		updateContractInfo(sObjectType,sObjectNo,Sqlca);
		//更新增值税发票信息
		updateInvoiceInfo(sObjectType,sObjectNo,Sqlca);
		//更新其它提供贷款人信息
		updateBusinessProvider(sObjectType,sObjectNo,Sqlca);
		//更新中介信息
		if(!(sObjectType.equals("PutOutApply") || sObjectType.equals("BusinessDueBill")))
			updateAgencyInfo(this.sRelativeTable,sObjectNo,Sqlca);
		//更新提单信息
		updateBolInfo(sObjectType,sObjectNo,Sqlca);
		//更新房屋买卖装修信息
		updateBuildingDeal(sObjectType,sObjectNo,Sqlca);
		//更新担保物信息
		updateGuarantyInfo(sObjectType,sObjectNo,Sqlca);
		//更新担保合同信息
		updateGuarantyContract(sObjectType,sObjectNo,Sqlca);
		//更新风险度评估信息
		updateEvaluateRecord(sObjectType,sObjectNo,Sqlca);
		//更新格式化调查报告信息		
		updateDocInfo(sObjectType,sObjectNo,Sqlca);			
		//更新授信方案明细信息
		if(!(sObjectType.equals("PutOutApply") || sObjectType.equals("BusinessDueBill")))
			updateCLInfo(sObjectType,sObjectNo,Sqlca);	
		
		//更新主体对象信息
		updateObjectInfo(sObjectType,sObjectNo,Sqlca);
		return "SUCCESS";
	}
	//获取关联表
	 private void getRelativeTable(String sObjectType,Transaction Sqlca)
		throws Exception
	 {
		 String sSql = "";	 
		 ASResultSet rs = null;
		 //根据sObjectType的不同，得到不同的关联表名
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
	 
	 //更新共同申请人的机构
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
		 //执行更新语句
		 Sqlca.executeSQL(so);
	 }
	 
	 //更新格式化文档信息
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
		 //执行更新语句
		 Sqlca.executeSQL(so);
	 }
	 
	 //更新票据
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
		 //执行更新语句
		 so = new SqlObject(sSql).setParameter("InputOrgID", sOrgID).setParameter("InputUserID", sUserID)
		 .setParameter("UpdateDate", sUpdateDate).setParameter("ObjectType", sObjectType).setParameter("ObjectNo", sObjectNo);
		 Sqlca.executeSQL(so);
	 }
	 
	 //更新信用证信息
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
			 //执行更新语句
		 so = new SqlObject(sSql).setParameter("InputOrgID", sOrgID).setParameter("InputUserID", sUserID).setParameter("UpdateDate", sUpdateDate)
		 .setParameter("ObjectType", sObjectType).setParameter("ObjectNo", sObjectNo);
			 Sqlca.executeSQL(so);
	 }
	 
	 //更新贸易合同信息
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
	 //执行更新语句
		 so = new SqlObject(sSql).setParameter("InputOrgID", sOrgID).setParameter("InputUserID", sUserID).setParameter("UpdateDate", sUpdateDate)
		 .setParameter("ObjectType", sObjectType).setParameter("ObjectNo", sObjectNo);
			 Sqlca.executeSQL(so);
	 }
	 
	 //更新增值税发票信息
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
	 //执行更新语句
		 so = new SqlObject(sSql).setParameter("InputOrgID", sOrgID).setParameter("InputUserID", sUserID).setParameter("UpdateDate", sUpdateDate)
		 .setParameter("ObjectType", sObjectType).setParameter("ObjectNo", sObjectNo);
		 Sqlca.executeSQL(so);
	 }
	 
	 //更新其它提供贷款人信息
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
		 //执行更新语句
		 so = new SqlObject(sSql).setParameter("InputOrgID", sOrgID).setParameter("InputUserID", sUserID).setParameter("UpdateDate", sUpdateDate)
		 .setParameter("ObjectType", sObjectType).setParameter("ObjectNo", sObjectNo);
		 Sqlca.executeSQL(so);
	 }
	
	 
	 //更新中介信息
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
		 //执行更新语句
		 Sqlca.executeSQL(so);
	 }
	 
	 //更新提单信息
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
	 //执行更新语句
		 so = new SqlObject(sSql).setParameter("InputOrgID", sOrgID).setParameter("InputUserID", sUserID).setParameter("UpdateDate", sUpdateDate)
		 .setParameter("ObjectType", sObjectType).setParameter("ObjectNo", sObjectNo);
		 Sqlca.executeSQL(so);
	 }
	 
	 //更新房屋买卖装修信息
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
	 //执行更新语句
	 so = new SqlObject(sSql).setParameter("InputOrgID", sOrgID).setParameter("InputUserID", sUserID).setParameter("UpdateDate", sUpdateDate)
	 .setParameter("ObjectType", sObjectType).setParameter("ObjectNo", sObjectNo);
	 Sqlca.executeSQL(so);
		 
	 }
	 
	 
	 //更新担保物信息
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
		 //执行更新语句
		 so = new SqlObject(sSql).setParameter("InputOrgID", sOrgID).setParameter("InputUserID", sUserID).setParameter("UpdateUserID", sUserID)
		 .setParameter("UpdateDate", sUpdateDate).setParameter("ObjectType", sObjectType).setParameter("ObjectNo", sObjectNo);
		 Sqlca.executeSQL(so);
	 }
	 
	 //更新担保合同信息
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
		 //执行更新语句
		 so = new SqlObject(sSql).setParameter("InputOrgID", sOrgID).setParameter("InputUserID", sUserID).setParameter("UpdateUserID", sUserID)
		 .setParameter("UpdateDate", sUpdateDate).setParameter("ObjectType", sObjectType).setParameter("ObjectNo", sObjectNo);
		 Sqlca.executeSQL(so);
	 }
	 
	 //更新风险度评估记录信息
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
		 //执行更新语句
		 so = new SqlObject(sSql).setParameter("OrgID", sOrgID).setParameter("UserID", sUserID).setParameter("CognOrgID", sOrgID)
		 .setParameter("CognUserID", sUserID).setParameter("ObjectType", sObjectType).setParameter("ObjectNo", sObjectNo);
		 Sqlca.executeSQL(so);
	 }
	 
	 //更新文档信息
	 private void updateDocInfo(String sObjectType,String sObjectNo,Transaction Sqlca)
		throws Exception
	 {
		 String sSql = "";
		 //更新文档的附件信息
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
		 //更新文档详情
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
		 //执行更新语句
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
		 //执行更新语句
		 so = new SqlObject(sSql).setParameter("ObjectType", sObjectType).setParameter("ObjectNo", sObjectNo);
		 Sqlca.executeSQL(so);	
	 }
	 
	 //更新授信额度信息
	 private void updateCLInfo(String sObjectType,String sObjectNo,Transaction Sqlca)
		throws Exception
	 {
		 String sSql = "";
		 String sSql1 = "";
		 //根据对象类型进行更新操作处理
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
			 //执行更新语句
			 Sqlca.executeSQL(so);

			 sSql = " update CL_LIMITATION set "+
			 		" InputOrg =:InputOrg, "+
			 		" InputUser =:InputUser, "+
			 		" UpdateTime =:UpdateTime "+
			 		" where LineID =:LineID ";
			 //执行更新语句
			 so = new SqlObject(sSql).setParameter("InputOrg", sOrgID).setParameter("InputUser", sUserID)
			 .setParameter("UpdateTime", sUpdateTime).setParameter("LineID", sLineID);
			 Sqlca.executeSQL(so);
	 }
	 
	 //更新主体对象信息
	 private void updateObjectInfo(String sObjectType,String sObjectNo,Transaction Sqlca)
		throws Exception
	 {
		 String sSql = "";
		 if(sObjectType.equals("CreditApply")) //申请
		 {
			 //更新申请信息
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
			 //更新流程对象表信息
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
			 //获取申请的初始阶段
			 sSql = "select min(PhaseNo) from FLOW_TASK where ObjectType =:ObjectType and ObjectNo =:ObjectNo ";
			 so = new SqlObject(sSql).setParameter("ObjectType", sObjectType).setParameter("ObjectNo", sObjectNo);
			 String sPhaseNo = Sqlca.getString(so);
			 //更新流程任务信息
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
		 
		 //由于最终审批意见是由最终审批意见录入员录入的，因此不需更新流程相关信息
		 if(sObjectType.equals("ApproveApply")) //最终审批意见
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
		 
		 if(sObjectType.equals("BusinessContract")) //合同
		 {
			 //更新合同表信息
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
			 //更新风险检查报告信息
			 sSql = " update INSPECT_INFO set "+
			 		" InputOrgID =:InputOrgID, "+
			 		" InputUserID =:InputUserID, "+
			 		" UpdateDate =:UpdateDate "+
			 		" where ObjectType =:ObjectType "+
			 		" and ObjectNo =:ObjectNo ";
			 so = new SqlObject(sSql).setParameter("InputOrgID", sOrgID).setParameter("InputUserID", sUserID).setParameter("UpdateDate", sUpdateDate)
			 .setParameter("ObjectType", sObjectType).setParameter("ObjectNo", sObjectNo);
			 Sqlca.executeSQL(so);
			 //更新催收函信息
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
		 
		 if(sObjectType.equals("PutOutApply")) //出帐
		 {
			 //更新出帐信息
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
			 //更新流程对象表信息
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
			 //获取申请的初始阶段
			 sSql = "select min(PhaseNo) from FLOW_TASK where ObjectType =:ObjectType and ObjectNo =:ObjectNo ";
			 so = new SqlObject(sSql).setParameter("ObjectType", sObjectType).setParameter("ObjectNo", sObjectNo);
			 String sPhaseNo = Sqlca.getString(so);
			 //更新流程任务信息
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
		 
		 if(sObjectType.equals("BusinessDueBill")) //借据
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
		 		 
		 if(sObjectType.equals("BusinessContract") || sObjectType.equals("BusinessDueBill")) //合同和借据
		 {
			 //更新风险分类表信息
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
