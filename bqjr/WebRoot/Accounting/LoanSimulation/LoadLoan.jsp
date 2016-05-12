<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>

<%
	String serialNo = DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo")));
	
	DefaultBusinessObjectManager boManager=new DefaultBusinessObjectManager(Sqlca);
	BusinessObject loan = boManager.loadObjectWithKey(BUSINESSOBJECT_CONSTATNTS.loan, serialNo);
	//����Loan������Ϣ
	ASValuePool as = new ASValuePool();
	as.setAttribute("ObjectType", loan.getObjectType());
	as.setAttribute("ObjectNo", loan.getObjectNo());
	as.setAttribute("Status", "1");
	List<BusinessObject> rateList = boManager.loadBusinessObjects(BUSINESSOBJECT_CONSTATNTS.loan_rate_segment, "ObjectType=:ObjectType and ObjectNo=:ObjectNo and Status=:Status",as);
	loan.setRelativeObjects(rateList);
	//����Loan������Ϣ
	List<BusinessObject> rptList = boManager.loadBusinessObjects(BUSINESSOBJECT_CONSTATNTS.loan_rpt_segment, "ObjectType=:ObjectType and ObjectNo=:ObjectNo and Status=:Status",as);
	loan.setRelativeObjects(rptList);
	//����Loan��Ϣ��Ϣ
	List<BusinessObject> sptList = boManager.loadBusinessObjects(BUSINESSOBJECT_CONSTATNTS.loan_spt_segment, "ObjectType=:ObjectType and ObjectNo=:ObjectNo and Status=:Status",as);
	loan.setRelativeObjects(sptList);
	//����Loan����ƻ�
	List<BusinessObject> paymentScheduleList = boManager.loadBusinessObjects(BUSINESSOBJECT_CONSTATNTS.payment_schedule," ObjectType=:ObjectType and ObjectNo=:ObjectNo and FinishDate is null order by paydate",as);
	loan.setRelativeObjects(paymentScheduleList);
	//����Loan�������Ϣ
	List<BusinessObject> subLedgerList = boManager.loadBusinessObjects(BUSINESSOBJECT_CONSTATNTS.subsidiary_ledger, " ObjectType=:ObjectType and ObjectNo=:ObjectNo ",as);
	loan.setRelativeObjects(subLedgerList);
	//���ط��÷���
	List<BusinessObject> feeList = boManager.loadBusinessObjects(BUSINESSOBJECT_CONSTATNTS.fee, " ObjectType=:ObjectType and ObjectNo=:ObjectNo and Status=:Status ",as);
	loan.setRelativeObjects(feeList);
	
	as = new ASValuePool();
	as.setAttribute("RelativeObjectType", loan.getObjectType());
	as.setAttribute("RelativeObjectNo", loan.getObjectNo());
	//ȡ��Ϣ��Ϣ
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
	//���ر��
	List<BusinessObject> transactionList = boManager.loadBusinessObjects(BUSINESSOBJECT_CONSTATNTS.transaction
			, " TransStatus in ('3') and TransDate >:TransDate  and TransCode not in ('9090','9091','9092') and relativeobjectno = :RelativeObjectNo",as);//Ԥ�ý���
	loan.setRelativeObjects(transactionList);
	
	session.setAttribute("SimulationObject_Loan",loan);
	
%>
<script language=javascript>
	//���ؼ��״ֵ̬�Ϳͻ���
	self.returnValue = "true";
	self.close();
</script>


<%@ include file="/IncludeEnd.jsp"%>