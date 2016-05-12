<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>

<%
	String serialNo = DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo")));
	
	DefaultBusinessObjectManager boManager=new DefaultBusinessObjectManager(Sqlca);
	BusinessObject loan = boManager.loadObjectWithKey(BUSINESSOBJECT_CONSTATNTS.loan, serialNo);
	//加载Loan利率信息
	ASValuePool as = new ASValuePool();
	as.setAttribute("ObjectType", loan.getObjectType());
	as.setAttribute("ObjectNo", loan.getObjectNo());
	as.setAttribute("Status", "1");
	List<BusinessObject> rateList = boManager.loadBusinessObjects(BUSINESSOBJECT_CONSTATNTS.loan_rate_segment, "ObjectType=:ObjectType and ObjectNo=:ObjectNo and Status=:Status",as);
	loan.setRelativeObjects(rateList);
	//加载Loan还款信息
	List<BusinessObject> rptList = boManager.loadBusinessObjects(BUSINESSOBJECT_CONSTATNTS.loan_rpt_segment, "ObjectType=:ObjectType and ObjectNo=:ObjectNo and Status=:Status",as);
	loan.setRelativeObjects(rptList);
	//加载Loan贴息信息
	List<BusinessObject> sptList = boManager.loadBusinessObjects(BUSINESSOBJECT_CONSTATNTS.loan_spt_segment, "ObjectType=:ObjectType and ObjectNo=:ObjectNo and Status=:Status",as);
	loan.setRelativeObjects(sptList);
	//加载Loan还款计划
	List<BusinessObject> paymentScheduleList = boManager.loadBusinessObjects(BUSINESSOBJECT_CONSTATNTS.payment_schedule," ObjectType=:ObjectType and ObjectNo=:ObjectNo and FinishDate is null order by paydate",as);
	loan.setRelativeObjects(paymentScheduleList);
	//加载Loan的余额信息
	List<BusinessObject> subLedgerList = boManager.loadBusinessObjects(BUSINESSOBJECT_CONSTATNTS.subsidiary_ledger, " ObjectType=:ObjectType and ObjectNo=:ObjectNo ",as);
	loan.setRelativeObjects(subLedgerList);
	//加载费用方案
	List<BusinessObject> feeList = boManager.loadBusinessObjects(BUSINESSOBJECT_CONSTATNTS.fee, " ObjectType=:ObjectType and ObjectNo=:ObjectNo and Status=:Status ",as);
	loan.setRelativeObjects(feeList);
	
	as = new ASValuePool();
	as.setAttribute("RelativeObjectType", loan.getObjectType());
	as.setAttribute("RelativeObjectNo", loan.getObjectNo());
	//取计息信息
	List<BusinessObject> interestLogList = boManager.loadBusinessObjects(BUSINESSOBJECT_CONSTATNTS.interest_log,"RelativeObjectType=:RelativeObjectType and RelativeObjectNo=:RelativeObjectNo and SettleDate is null",as);
	loan.setRelativeObjects(interestLogList);

	for(BusinessObject interestLog:interestLogList){
		String interestObjectType=interestLog.getString("ObjectType");
		String interestObjectNo=interestLog.getString("ObjectNo");
		if(!interestObjectType.equals(BUSINESSOBJECT_CONSTATNTS.payment_schedule)) continue;
		
		BusinessObject paymentSchedule = loan.getRelativeObject(interestObjectType, interestObjectNo);
		if(paymentSchedule==null) continue;
		if(interestLog.getString("PSSerialNo").equals(paymentSchedule.getString("SerialNo"))) 
			paymentSchedule.setRelativeObject(interestLog);
	}
	
	as = new ASValuePool();
	as.setAttribute("TransDate", SystemConfig.getBusinessDate());
	as.setAttribute("RelativeObjectNo", loan.getObjectNo());
	//加载变更
	List<BusinessObject> transactionList = boManager.loadBusinessObjects(BUSINESSOBJECT_CONSTATNTS.transaction
			, " TransStatus in ('3') and TransDate >:TransDate  and TransCode not in ('9090','9091','9092') and relativeobjectno = :RelativeObjectNo",as);//预置交易
	loan.setRelativeObjects(transactionList);
	
	session.setAttribute("SimulationObject_Loan",loan);
	
%>
<script language=javascript>
	//返回检查状态值和客户号
	self.returnValue = "true";
	self.close();
</script>


<%@ include file="/IncludeEnd.jsp"%>