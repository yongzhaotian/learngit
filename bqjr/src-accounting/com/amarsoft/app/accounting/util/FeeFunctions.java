package com.amarsoft.app.accounting.util;

import java.util.ArrayList;
import java.util.List;

import com.amarsoft.amarscript.Expression;
import com.amarsoft.app.accounting.businessobject.BUSINESSOBJECT_CONSTATNTS;
import com.amarsoft.app.accounting.businessobject.BusinessObject;
import com.amarsoft.app.accounting.businessobject.AbstractBusinessObjectManager;
import com.amarsoft.app.accounting.businessobject.DefaultBusinessObjectManager;
import com.amarsoft.app.accounting.config.loader.DateFunctions;
import com.amarsoft.app.accounting.config.loader.PaymentFrequencyConfig;
import com.amarsoft.app.accounting.config.loader.ProductConfig;
import com.amarsoft.app.accounting.config.SystemConfig;
import com.amarsoft.app.accounting.interest.InterestFunctions;
import com.amarsoft.app.accounting.util.ExtendedFunctions;
import com.amarsoft.are.util.ASValuePool;
import com.amarsoft.are.util.Arith;
import com.amarsoft.are.util.DataConvert;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.dict.als.cache.CodeCache;
import com.amarsoft.dict.als.object.Item;

public class FeeFunctions {

	/**
	 * ����ϵͳ����ķ��ü��㷽ʽ���㵥�ڷ��ý��
	 * @param fee
	 * @param bom
	 * @return
	 * @throws Exception
	 */
	public static double calFeeAmount(BusinessObject fee,BusinessObject relativeObject,AbstractBusinessObjectManager bom) throws Exception{
		String feeCalType = fee.getString("FeeCalType");
		if(feeCalType==null||feeCalType.length()==0) throw new Exception("���õļ��㷽ʽΪ�գ�����!");
		String script = CodeCache.getItem("FeeCalType", feeCalType).getItemAttribute();
		if(script==null||script.length()==0) throw new Exception("���ü��㷽ʽ{"+feeCalType+"}û�ж�Ӧ����ű�������!");
		BusinessObject objectTemp = null;
		
		if(relativeObject.getObjectType().equals(BUSINESSOBJECT_CONSTATNTS.business_apply)){
			objectTemp=new BusinessObject(BUSINESSOBJECT_CONSTATNTS.business_approve);
			objectTemp.setValue(relativeObject);
			script=ExtendedFunctions.replaceAllIgnoreCase(script, objectTemp);
			
			objectTemp=new BusinessObject(BUSINESSOBJECT_CONSTATNTS.business_contract);
			objectTemp.setValue(relativeObject);
			script=ExtendedFunctions.replaceAllIgnoreCase(script, objectTemp);
			
			objectTemp=new BusinessObject(BUSINESSOBJECT_CONSTATNTS.business_putout);
			objectTemp.setValue(relativeObject);
			script=ExtendedFunctions.replaceAllIgnoreCase(script, objectTemp);
			
			objectTemp=new BusinessObject(BUSINESSOBJECT_CONSTATNTS.loan);
			objectTemp.setValue(relativeObject);
			script=ExtendedFunctions.replaceAllIgnoreCase(script, objectTemp);
		}
		else if(relativeObject.getObjectType().equals(BUSINESSOBJECT_CONSTATNTS.flow_opinion)){
			objectTemp=new BusinessObject(BUSINESSOBJECT_CONSTATNTS.business_approve);
			objectTemp.setValue(relativeObject);
			script=ExtendedFunctions.replaceAllIgnoreCase(script, objectTemp);
			
			objectTemp=new BusinessObject(BUSINESSOBJECT_CONSTATNTS.business_contract);
			objectTemp.setValue(relativeObject);
			script=ExtendedFunctions.replaceAllIgnoreCase(script, objectTemp);
			
			objectTemp=new BusinessObject(BUSINESSOBJECT_CONSTATNTS.business_putout);
			objectTemp.setValue(relativeObject);
			script=ExtendedFunctions.replaceAllIgnoreCase(script, objectTemp);
			
			objectTemp=new BusinessObject(BUSINESSOBJECT_CONSTATNTS.loan);
			objectTemp.setValue(relativeObject);
			script=ExtendedFunctions.replaceAllIgnoreCase(script, objectTemp);
		}
		else if(relativeObject.getObjectType().equals(BUSINESSOBJECT_CONSTATNTS.business_approve)){
			objectTemp=new BusinessObject(BUSINESSOBJECT_CONSTATNTS.business_contract);
			objectTemp.setValue(relativeObject);
			script=ExtendedFunctions.replaceAllIgnoreCase(script, objectTemp);
			
			objectTemp=new BusinessObject(BUSINESSOBJECT_CONSTATNTS.business_putout);
			objectTemp.setValue(relativeObject);
			script=ExtendedFunctions.replaceAllIgnoreCase(script, objectTemp);
			
			objectTemp=new BusinessObject(BUSINESSOBJECT_CONSTATNTS.loan);
			objectTemp.setValue(relativeObject);
			script=ExtendedFunctions.replaceAllIgnoreCase(script, objectTemp);
		}
		else if(relativeObject.getObjectType().equals(BUSINESSOBJECT_CONSTATNTS.business_contract)){
			objectTemp=new BusinessObject(BUSINESSOBJECT_CONSTATNTS.business_putout);
			objectTemp.setValue(relativeObject);
			script=ExtendedFunctions.replaceAllIgnoreCase(script, objectTemp);
			
			objectTemp=new BusinessObject(BUSINESSOBJECT_CONSTATNTS.loan);
			objectTemp.setValue(relativeObject);
			script=ExtendedFunctions.replaceAllIgnoreCase(script, objectTemp);
		}
		else if(relativeObject.getObjectType().equals(BUSINESSOBJECT_CONSTATNTS.business_putout) || relativeObject.getObjectType().equals(BUSINESSOBJECT_CONSTATNTS.business_duebill)){
			//������ͬ�շѵ����շѶ����Ǻ�ͬ���������ӡ��˰
			if(fee.getString("BusinessObjectType").equals(BUSINESSOBJECT_CONSTATNTS.business_contract)){
				BusinessObject contract = relativeObject.getRelativeObject(BUSINESSOBJECT_CONSTATNTS.business_contract, relativeObject.getString("ContractSerialNo"));
				if(contract == null)
					contract = bom.loadObjectWithKey(BUSINESSOBJECT_CONSTATNTS.business_contract,relativeObject.getString("ContractSerialNo"));
				if(contract != null){
					relativeObject.setRelativeObject(contract);
					objectTemp=new BusinessObject(BUSINESSOBJECT_CONSTATNTS.business_contract);
					objectTemp.setValue(relativeObject);
					script=ExtendedFunctions.replaceAllIgnoreCase(script, objectTemp);
				}
			}
			
			objectTemp=new BusinessObject(BUSINESSOBJECT_CONSTATNTS.loan);
			objectTemp.setValue(relativeObject);
			script=ExtendedFunctions.replaceAllIgnoreCase(script, objectTemp);
			
			objectTemp=new BusinessObject(BUSINESSOBJECT_CONSTATNTS.business_contract);
			objectTemp.setValue(relativeObject);
			script=ExtendedFunctions.replaceAllIgnoreCase(script, objectTemp);
		}
		else if(relativeObject.getObjectType().equals(BUSINESSOBJECT_CONSTATNTS.loan)){
			//������ͬ�շѵ����շѶ����Ǻ�ͬ���������ӡ��˰
			if(fee.getString("BusinessObjectType").equals(BUSINESSOBJECT_CONSTATNTS.business_contract)){
				BusinessObject contract = relativeObject.getRelativeObject(BUSINESSOBJECT_CONSTATNTS.business_contract, relativeObject.getString("ContractSerialNo"));
				if(contract == null)
					contract = bom.loadObjectWithKey(BUSINESSOBJECT_CONSTATNTS.business_contract,relativeObject.getString("ContractSerialNo"));
				if(contract != null){
					relativeObject.setRelativeObject(contract);
					objectTemp=new BusinessObject(BUSINESSOBJECT_CONSTATNTS.business_contract);
					objectTemp.setValue(relativeObject);
					script=ExtendedFunctions.replaceAllIgnoreCase(script, objectTemp);
				}
			}

			List<BusinessObject> rateList = InterestFunctions.getRateSegmentList(relativeObject, ACCOUNT_CONSTANTS.RateType_Normal+","+ACCOUNT_CONSTANTS.RateType_Discount);
			if(rateList == null || rateList.isEmpty())
			{
				ASValuePool as = new ASValuePool();
				as.setAttribute("ObjectType", relativeObject.getObjectType());
				as.setAttribute("ObjectNo", relativeObject.getObjectNo());
				as.setAttribute("RateType1", ACCOUNT_CONSTANTS.RateType_Normal);
				as.setAttribute("RateType2", ACCOUNT_CONSTANTS.RateType_Discount);
				as.setAttribute("Status", "1");
				rateList = bom.loadBusinessObjects(BUSINESSOBJECT_CONSTATNTS.loan_rate_segment, " ObjectType=:ObjectType and ObjectNo=:ObjectNo and RateType in (:RateType1,:RateType2)  and Status=:Status and (SegToDate is null or SegToDate = '')", as);
			}
			if(rateList != null && !rateList.isEmpty())
			{
				for(BusinessObject rate:rateList)
				{
					relativeObject.setAttributeValue("BusinessYearRate",RateFunctions.getRate(RateFunctions.getBaseDays(relativeObject), rate.getString("RateUnit"), rate.getDouble("BusinessRate"), ACCOUNT_CONSTANTS.RateUnit_Year)/100.0);
					relativeObject.setAttributeValue("BusinessMonthRate",RateFunctions.getRate(RateFunctions.getBaseDays(relativeObject), rate.getString("RateUnit"), rate.getDouble("BusinessRate"), ACCOUNT_CONSTANTS.RateUnit_Month)/1000.0);
					relativeObject.setAttributeValue("BusinessDayRate",RateFunctions.getRate(RateFunctions.getBaseDays(relativeObject), rate.getString("RateUnit"), rate.getDouble("BusinessRate"), ACCOUNT_CONSTANTS.RateUnit_Day)/10000.0);
				}
			}
			script=ExtendedFunctions.replaceAllIgnoreCase(script, fee);
			objectTemp=new BusinessObject(BUSINESSOBJECT_CONSTATNTS.business_contract);
			objectTemp.setValue(relativeObject);
			script=ExtendedFunctions.replaceAllIgnoreCase(script, objectTemp);
			
		}
		//�����׹��������ѣ�����ǰ����
		else if(relativeObject.getObjectType().equals(BUSINESSOBJECT_CONSTATNTS.back_bill)){			
			
			BusinessObject loan = relativeObject.getRelativeObject(BUSINESSOBJECT_CONSTATNTS.loan, relativeObject.getString("objectno"));
			if(loan == null)
				loan = bom.loadObjectWithKey(BUSINESSOBJECT_CONSTATNTS.loan,relativeObject.getString("objectno"));
			if(loan != null){
				relativeObject.setRelativeObject(loan);
				List<BusinessObject> rateList = InterestFunctions.getRateSegmentList(loan, ACCOUNT_CONSTANTS.RateType_Normal+","+ACCOUNT_CONSTANTS.RateType_Discount);
				if(rateList == null || rateList.isEmpty())
				{
					ASValuePool as = new ASValuePool();
					as.setAttribute("ObjectType", loan.getObjectType());
					as.setAttribute("ObjectNo", loan.getObjectNo());
					as.setAttribute("RateType1", ACCOUNT_CONSTANTS.RateType_Normal);
					as.setAttribute("RateType2", ACCOUNT_CONSTANTS.RateType_Discount);
					as.setAttribute("Status", "1");
					rateList = bom.loadBusinessObjects(BUSINESSOBJECT_CONSTATNTS.loan_rate_segment, " ObjectType=:ObjectType and ObjectNo=:ObjectNo and RateType in (:RateType1,:RateType2)  and Status=:Status and (SegToDate is null or SegToDate = '')", as);
				}
				if(rateList != null && !rateList.isEmpty())
				{
					for(BusinessObject rate:rateList)
					{
						loan.setAttributeValue("BusinessYearRate",RateFunctions.getRate(RateFunctions.getBaseDays(loan), rate.getString("RateUnit"), rate.getDouble("BusinessRate"), ACCOUNT_CONSTANTS.RateUnit_Year)/100.0);
						loan.setAttributeValue("BusinessMonthRate",RateFunctions.getRate(RateFunctions.getBaseDays(loan), rate.getString("RateUnit"), rate.getDouble("BusinessRate"), ACCOUNT_CONSTANTS.RateUnit_Month)/1000.0);
						loan.setAttributeValue("BusinessDayRate",RateFunctions.getRate(RateFunctions.getBaseDays(loan), rate.getString("RateUnit"), rate.getDouble("BusinessRate"), ACCOUNT_CONSTANTS.RateUnit_Day)/10000.0);
						
					}
				}
				script=ExtendedFunctions.replaceAllIgnoreCase(script, loan);
			}
			
			objectTemp=new BusinessObject(BUSINESSOBJECT_CONSTATNTS.loan);
			objectTemp.setValue(relativeObject);
			script=ExtendedFunctions.replaceAllIgnoreCase(script, objectTemp);
		}
		script=ExtendedFunctions.replaceAllIgnoreCase(script, fee);
		script=ExtendedFunctions.replaceAllIgnoreCase(script, relativeObject);
		if(script.indexOf("${jbo")>=0){
			return 0d;
		}
		if(script==null||script.length()==0) throw new Exception("���ü��㷽ʽ{"+feeCalType+"}û�ж�Ӧ����ű�������!");
		double feeAmount=Arith.round(ExtendedFunctions.getScriptDoubleValue(script, relativeObject, bom.getSqlca()),2);
		return feeAmount;
	}
	
	
	public static BusinessObject createFee(String feeTermID,BusinessObject relativeObject,AbstractBusinessObjectManager bom) throws Exception{
		String productID=relativeObject.getString("BusinessType");
		String versionID=relativeObject.getString("ProductVersion");
		ASValuePool term=null;
		if(productID!=null&&productID.length()>0){
			term=ProductConfig.getProductTerm(productID, versionID, feeTermID);
		}
		if(term==null){
			term=ProductConfig.getTerm(feeTermID);
		}
		if(term==null) throw new Exception("��������ʧ�ܣ�δ�ҵ�����������壡");
		BusinessObject fee = new BusinessObject(BUSINESSOBJECT_CONSTATNTS.fee,bom);
		fee.setAttributeValue("ObjectType", relativeObject.getObjectType());
		fee.setAttributeValue("ObjectNo", relativeObject.getObjectNo());
		fee.setAttributeValue("FeeTermID", feeTermID);
		fee.setAttributeValue("Status", "0");
		if(relativeObject.getObjectType().equals(BUSINESSOBJECT_CONSTATNTS.loan))
		{
			fee.setAttributeValue("Currency", relativeObject.getString("Currency"));
			fee.setAttributeValue("AccountingOrgID", relativeObject.getString("AccountingOrgID"));//add by Lambert 20131121
		}
		else
		{
			fee.setAttributeValue("Currency", relativeObject.getString("BusinessCurrency"));
			fee.setAttributeValue("AccountingOrgID", relativeObject.getString("PutOutOrgID"));//add by Lambert 20131121
		}
		
		String feeOrgID=FeeFunctions.getFeeOrgID(fee,relativeObject,bom);
		fee.setAttributeValue("OrgID", feeOrgID);
		
		fee = FeeFunctions.importTermParameter(fee, relativeObject, bom);
		if("".equals(fee.getString("FeeType")))
		{
			throw new Exception("��Ʒ��δ���á��������͡���");
		}
		return fee;
	}
	
	/**
	 *������üƻ�����������ܶ�ͼ����ܶ�
	 *����һ�����ո����ã��˴�ֻ��������ܶ�ͼ����ܶ�
	 * @throws Exception 
	 */
	public static ArrayList<BusinessObject> createFeeScheduleList(BusinessObject fee,BusinessObject relativeObject,AbstractBusinessObjectManager bom) throws Exception{
		ArrayList<BusinessObject> feeScheduleList = new ArrayList<BusinessObject>();
		
		String feePayDateFlag=fee.getString("FeePayDateFlag");
		if("06".equals(feePayDateFlag)){//�״λ�������ȡ
			if(!relativeObject.getObjectType().equals(BUSINESSOBJECT_CONSTATNTS.loan)) return null;
			
			fee.setRelativeObject(relativeObject);//loan
			ArrayList<BusinessObject> pslist = relativeObject.getRelativeObjects(BUSINESSOBJECT_CONSTATNTS.payment_schedule);
			if(pslist == null || pslist.isEmpty()) return null;
			BusinessObject ps=pslist.get(0);//ȡ�׸�����ƻ�
			String firstDueDate = ps.getString("PayDate");
			fee.setAttributeValue("TotalAmount", 0.0d);//���ܽ���������¼���
			fee.setAttributeValue("WaiveAmount", 0.0d);
			List<BusinessObject> feeSchedules = createFeeSchedule(fee,relativeObject,ps, firstDueDate, bom);
			feeScheduleList.addAll(feeSchedules);
			return feeScheduleList;
		}
		else if("05".equals(feePayDateFlag)){//�滹��ƻ���ȡ
			if(!relativeObject.getObjectType().equals(BUSINESSOBJECT_CONSTATNTS.loan)) return null;
			ArrayList<BusinessObject> pslist = relativeObject.getRelativeObjects(BUSINESSOBJECT_CONSTATNTS.payment_schedule);
			if(pslist == null || pslist.isEmpty()) return null;
			fee.setAttributeValue("TotalAmount", 0.0d);
			fee.setAttributeValue("WaiveAmount", 0.0d);
			for(BusinessObject a:pslist){
				List<BusinessObject> feeSchedules = createFeeSchedule(fee,relativeObject, a, a.getString("PayDate"), bom);
				feeScheduleList.addAll(feeSchedules);
			}
			return feeScheduleList;
		}
		else if("04".equals(feePayDateFlag)){//��������ȡ
			if(!relativeObject.getObjectType().equals(BUSINESSOBJECT_CONSTATNTS.loan))
			{
				return null;
			}
			fee.setAttributeValue("TotalAmount", 0.0d);
			fee.setAttributeValue("WaiveAmount", 0.0d);
			return FeeFunctions.getFeeSchedule(fee,relativeObject,bom);
		}
		else {//һ������ȡ
			double feeAmount = FeeFunctions.calFeeAmount(fee,relativeObject, bom);
			
			double waiveAmount=0d;
			String businessDate = SystemConfig.getBusinessDate();
			if(fee.getRelativeObjects(BUSINESSOBJECT_CONSTATNTS.fee_waive) != null)
			{
				for(BusinessObject fw:fee.getRelativeObjects(BUSINESSOBJECT_CONSTATNTS.fee_waive))
				{
					String waiveFromDate = fw.getString("WaiveFromDate");
					String waiveToDate = fw.getString("WaiveToDate");
					if((waiveFromDate == null || "".equals(waiveFromDate) || waiveFromDate.compareTo(businessDate) <= 0)
						&& (waiveToDate.compareTo(businessDate) >= 0 || waiveToDate == null || "".equals(waiveToDate)))
					{
						String waiveType = fw.getString("WaiveType");
						double waivePecent=fw.getDouble("WaivePercent");
						double waiveAmt = fw.getDouble("WaiveAmount");
						if("0".equals(waiveType))//���ս�����
							waiveAmount += waiveAmt;
						else if("1".equals(waiveType))
							waiveAmount += feeAmount*waivePecent/100.0;
					}
				}
			}
			fee.setAttributeValue("Amount", feeAmount);
			fee.setAttributeValue("TotalAmount", feeAmount+waiveAmount);
			fee.setAttributeValue("WaiveAmount", waiveAmount);
			
			return null;
		}
	}
	
	
	public static ArrayList<BusinessObject> getFeeSchedule(BusinessObject fee,BusinessObject loan,AbstractBusinessObjectManager bom) throws Exception
	{
		ArrayList<BusinessObject> feeScheduleList = new ArrayList<BusinessObject>();
		
		//��ȡ�ո�Ƶ��
		String feeFrequency = fee.getString("FeeFrequency");
		if(feeFrequency == null || "".equals(feeFrequency))
		{
			throw new Exception("���á�"+fee.getString("SerialNo")+"���쳣�������ո�Ƶ��Ϊ�գ�");
		}
		//��ȡƵ�ʲ���
		BusinessObject bo = (BusinessObject)PaymentFrequencyConfig.getPaymentFrequencySet().getAttribute(feeFrequency);
		int term = bo.getInt("Term");
		String units = bo.getString("TermUnit");
		if(term == 0 || units == null || "".equals(units))
			throw new Exception("δ����÷��õĻ������ڣ����飡");
		
		String segFromDate = fee.getString("SEGFromDate");//������ʼ����
		int segFromStage   = fee.getInt("SEGFromStage");//������ʼ�ڴ�
		int segStages       = fee.getInt("SEGStages");//�����ڴ�
		String segToDate   = fee.getString("SEGToDate");//���ν�������
		int segToStage     = fee.getInt("SEGToStage");//���ν����ڴ�
		//�����ʼ����Ϊ����ȡ�ſ�����
		if(segFromDate == null || "".equals(segFromDate))
		{
			segFromDate = loan.getString("PutoutDate");
		}
		//�����ʼ�ڴδ���0,����ݿ�ʼ�ڴ���ȡ��ʼ����
		if(segFromStage > 0)
		{
			segFromDate = DateFunctions.getRelativeDate(segFromDate,DateFunctions.TERM_UNIT_MONTH,segFromStage-1);
		}
		//�����ʼ����Ϊ����ȡ�������
		if(segToDate == null || "".equals(segToDate))
		{
			segToDate = loan.getString("MaturityDate");
		}
		if(segToStage > 0)
		{
			segToDate = DateFunctions.getRelativeDate(segFromDate,DateFunctions.TERM_UNIT_MONTH,segToStage);
		}
		else if(segStages > 0)
		{
			segToDate = DateFunctions.getRelativeDate(segFromDate,DateFunctions.TERM_UNIT_MONTH,segStages);
		}
		
		double feeAmount = FeeFunctions.calFeeAmount(fee,loan, bom);
		fee.setAttributeValue("Amount", feeAmount);
		
		//��ֹ��ѭ��
		int count = 0;
		while(true && feeAmount > 0)
		{
			count++;
			segFromDate = DateFunctions.getRelativeDate(segFromDate,units,term);
			
			while(segFromDate.compareTo(loan.getString("BusinessDate")) < 0)
			{
				segFromDate = DateFunctions.getRelativeDate(segFromDate,units,term);
			}
			
			double waiveAmount=0d;
			if(fee.getRelativeObjects(BUSINESSOBJECT_CONSTATNTS.fee_waive) != null)
			{
				for(BusinessObject fw:fee.getRelativeObjects(BUSINESSOBJECT_CONSTATNTS.fee_waive))
				{
					String waiveFromDate = fw.getString("WaiveFromDate");
					String waiveToDate = fw.getString("WaiveToDate");
					if(waiveFromDate.compareTo(segFromDate) <= 0 && waiveToDate.compareTo(segFromDate) >= 0)
					{
						String waiveType = fw.getString("WaiveType");
						double waivePecent=fw.getDouble("WaivePercent");
						double waiveAmt = fw.getDouble("WaiveAmount");
						if("0".equals(waiveType))//���ս�����
							waiveAmount += waiveAmt;
						else if("1".equals(waiveType))
							waiveAmount += feeAmount*waivePecent/100.0;
					}
				}
			}
			
			if(ACCOUNT_CONSTANTS.FEEFLAG_RP.equals(fee.getString("FeeFlag")))//���մ���
			{
				//��
				BusinessObject feeSchedule = new BusinessObject(BUSINESSOBJECT_CONSTATNTS.fee_schedule,bom);
				feeSchedule.setAttributeValue("ObjectType", fee.getString("ObjectType"));
				feeSchedule.setAttributeValue("ObjectNo", fee.getString("ObjectNo"));
				feeSchedule.setAttributeValue("FeeType", fee.getString("FeeType"));
				feeSchedule.setAttributeValue("FeeFlag", ACCOUNT_CONSTANTS.FEEFLAG_RECIEVE);
				feeSchedule.setAttributeValue("PayDate", segFromDate);
				feeSchedule.setAttributeValue("Currency", fee.getString("Currency"));
				feeSchedule.setAttributeValue("Amount", feeAmount+waiveAmount);
				feeSchedule.setAttributeValue("FeeSerialNo", fee.getString("SerialNo"));
				feeSchedule.setAttributeValue("WaiveAmount", waiveAmount);
				feeScheduleList.add(feeSchedule);
				//��
				BusinessObject feeSchedule1 = new BusinessObject(BUSINESSOBJECT_CONSTATNTS.fee_schedule,bom);
				feeSchedule1.setAttributeValue("ObjectType", fee.getString("ObjectType"));
				feeSchedule1.setAttributeValue("ObjectNo", fee.getString("ObjectNo"));
				feeSchedule1.setAttributeValue("FeeType", fee.getString("FeeType"));
				feeSchedule1.setAttributeValue("FeeFlag", ACCOUNT_CONSTANTS.FEEFLAG_PAY);
				feeSchedule1.setAttributeValue("PayDate", segFromDate);
				feeSchedule1.setAttributeValue("Currency", fee.getString("Currency"));
				feeSchedule1.setAttributeValue("Amount", feeAmount+waiveAmount);
				feeSchedule1.setAttributeValue("FeeSerialNo", fee.getString("SerialNo"));
				feeSchedule1.setAttributeValue("WaiveAmount", waiveAmount);
				feeScheduleList.add(feeSchedule1);
				//���÷����ܽ��\���ü����ܽ��
				fee.setAttributeValue("TotalAmount",Arith.round((fee.getDouble("TotalAmount")+feeSchedule.getDouble("Amount")),2));
				fee.setAttributeValue("WaiveAmount",Arith.round((fee.getDouble("WaiveAmount")+feeSchedule.getDouble("WaiveAmount")),2));
			}
			else
			{
				BusinessObject feeSchedule = new BusinessObject(BUSINESSOBJECT_CONSTATNTS.fee_schedule,bom);
				feeSchedule.setAttributeValue("ObjectType", fee.getString("ObjectType"));
				feeSchedule.setAttributeValue("ObjectNo", fee.getString("ObjectNo"));
				feeSchedule.setAttributeValue("FeeType", fee.getString("FeeType"));
				feeSchedule.setAttributeValue("FeeFlag", fee.getString("FeeFlag"));
				feeSchedule.setAttributeValue("PayDate", segFromDate);
				feeSchedule.setAttributeValue("Currency", fee.getString("Currency"));
				feeSchedule.setAttributeValue("Amount", feeAmount+waiveAmount);
				feeSchedule.setAttributeValue("FeeSerialNo", fee.getString("SerialNo"));
				feeSchedule.setAttributeValue("WaiveAmount", waiveAmount);
				feeScheduleList.add(feeSchedule);
				//���÷����ܽ��
				fee.setAttributeValue("TotalAmount",Arith.round((fee.getDouble("TotalAmount")+feeSchedule.getDouble("Amount")),2));
				fee.setAttributeValue("WaiveAmount",Arith.round((fee.getDouble("WaiveAmount")+feeSchedule.getDouble("WaiveAmount")),2));
			}
			
			if(segFromDate.compareTo(segToDate) >= 0 || count>2000)
			{
				break;
			}
		}
		return feeScheduleList;
	}
	
	/**
	 * ���ݷ��ö���˷����Ǹ������˻������Ǿ��������ȡ
	 * @param fee2
	 * @throws Exception 
	 */
	public static String getFeeOrgID(BusinessObject fee,BusinessObject feeObject,AbstractBusinessObjectManager bom) throws Exception {
		fee=FeeFunctions.importTermParameter(fee, feeObject, bom);
		String feeOrgIDFlag = fee.getString("AccountingOrgFlag");
		
		String feeOrgID = "";
		if("01".equals(feeOrgIDFlag)){
			if(feeObject.getObjectType().equals(BUSINESSOBJECT_CONSTATNTS.loan)){
				feeOrgID =feeObject.getString("OrgID");
			}
			else
				feeOrgID =feeObject.getString("DrawdownOrg");
		}
		else
			feeOrgID = feeObject.getString("OperateOrgID");
		return  feeOrgID;
	}
	
	
	public static List<BusinessObject> createFeeSchedule(BusinessObject fee,BusinessObject relativeObject,BusinessObject extobject
			,String businessDate,AbstractBusinessObjectManager bom) throws Exception{
		
		String feeCalType = fee.getString("FeeCalType");
		if(feeCalType==null||feeCalType.length()==0) throw new Exception("���õļ��㷽ʽΪ�գ�����!");
		String script = CodeCache.getItem("FeeCalType", feeCalType).getItemAttribute();
		if(script==null||script.length()==0) throw new Exception("���ü��㷽ʽ{"+feeCalType+"}û�ж�Ӧ����ű�������!");
		script=ExtendedFunctions.replaceAllIgnoreCase(script, fee);
		script=ExtendedFunctions.replaceAllIgnoreCase(script, relativeObject);
		if(relativeObject.getObjectType().equals(BUSINESSOBJECT_CONSTATNTS.business_apply)){
			BusinessObject contract=new BusinessObject(BUSINESSOBJECT_CONSTATNTS.business_contract);
			contract.setValue(relativeObject);
			script=ExtendedFunctions.replaceAllIgnoreCase(script, contract);
			BusinessObject loan=new BusinessObject(BUSINESSOBJECT_CONSTATNTS.loan);
			loan.setValue(relativeObject);
			script=ExtendedFunctions.replaceAllIgnoreCase(script, loan);
		}
		if(extobject!=null)
			script=ExtendedFunctions.replaceAllIgnoreCase(script, extobject);
		
		if(script.indexOf("${")>=0){
			throw new Exception("���ü��㷽ʽ{"+feeCalType+"}����ű�����δ�滻����{"+script+"}������!");
		}
		if(script==null||script.length()==0) throw new Exception("���ü��㷽ʽ{"+feeCalType+"}û�ж�Ӧ����ű�������!");
		double feeAmount=Arith.round(Expression.getExpressionValue(script, bom.getSqlca()).doubleValue(),2);
		fee.setAttributeValue("Amount", feeAmount);
		if(feeAmount <= 0) return null;
		
		double waiveAmount=0d;
		if(fee.getRelativeObjects(BUSINESSOBJECT_CONSTATNTS.fee_waive) != null)
		{
			for(BusinessObject fw:fee.getRelativeObjects(BUSINESSOBJECT_CONSTATNTS.fee_waive))
			{
				String waiveFromDate = fw.getString("WaiveFromDate");
				String waiveToDate = fw.getString("WaiveToDate");
				if(waiveFromDate.compareTo(businessDate) <= 0 && waiveToDate.compareTo(businessDate) >= 0)
				{
					String waiveType = fw.getString("WaiveType");
					double waivePecent=fw.getDouble("WaivePercent");
					double waiveAmt = fw.getDouble("WaiveAmount");
					if("0".equals(waiveType))//���ս�����
						waiveAmount += waiveAmt;
					else if("1".equals(waiveType))
						waiveAmount += feeAmount*waivePecent/100.0;
				}
			}
		}
		
		List<BusinessObject> feeScheduleList = new ArrayList<BusinessObject>();
		
		if(ACCOUNT_CONSTANTS.FEEFLAG_RP.equals(fee.getString("FeeFlag")))//���մ���
		{
			//��
			BusinessObject feeSchedule = new BusinessObject(BUSINESSOBJECT_CONSTATNTS.fee_schedule,bom);
			feeSchedule.setAttributeValue("ObjectType", fee.getString("ObjectType"));
			feeSchedule.setAttributeValue("ObjectNo", fee.getString("ObjectNo"));
			feeSchedule.setAttributeValue("FeeType", fee.getString("FeeType"));
			feeSchedule.setAttributeValue("FeeFlag", ACCOUNT_CONSTANTS.FEEFLAG_RECIEVE);
			feeSchedule.setAttributeValue("PayDate", businessDate);
			feeSchedule.setAttributeValue("Currency", fee.getString("Currency"));
			feeSchedule.setAttributeValue("Amount", feeAmount+waiveAmount);
			feeSchedule.setAttributeValue("FeeSerialNo", fee.getString("SerialNo"));
			feeSchedule.setAttributeValue("WaiveAmount", waiveAmount);
			feeScheduleList.add(feeSchedule);
			//��
			BusinessObject feeSchedule1 = new BusinessObject(BUSINESSOBJECT_CONSTATNTS.fee_schedule,bom);
			feeSchedule1.setAttributeValue("ObjectType", fee.getString("ObjectType"));
			feeSchedule1.setAttributeValue("ObjectNo", fee.getString("ObjectNo"));
			feeSchedule1.setAttributeValue("FeeType", fee.getString("FeeType"));
			feeSchedule1.setAttributeValue("FeeFlag", ACCOUNT_CONSTANTS.FEEFLAG_PAY);
			feeSchedule1.setAttributeValue("PayDate", businessDate);
			feeSchedule1.setAttributeValue("Currency", fee.getString("Currency"));
			feeSchedule1.setAttributeValue("Amount", feeAmount+waiveAmount);
			feeSchedule1.setAttributeValue("FeeSerialNo", fee.getString("SerialNo"));
			feeSchedule1.setAttributeValue("WaiveAmount", waiveAmount);
			feeScheduleList.add(feeSchedule1);
			//���÷����ܽ��\��������ܽ��
			fee.setAttributeValue("TotalAmount",Arith.round((fee.getDouble("TotalAmount")+feeSchedule.getDouble("Amount")),2));
			fee.setAttributeValue("WaiveAmount",Arith.round((fee.getDouble("WaiveAmount")+feeSchedule.getDouble("WaiveAmount")),2));
		}
		else
		{
			BusinessObject feeSchedule = new BusinessObject(BUSINESSOBJECT_CONSTATNTS.fee_schedule,bom);
			feeSchedule.setAttributeValue("ObjectType", fee.getString("ObjectType"));
			feeSchedule.setAttributeValue("ObjectNo", fee.getString("ObjectNo"));
			feeSchedule.setAttributeValue("FeeType", fee.getString("FeeType"));
			feeSchedule.setAttributeValue("FeeFlag", fee.getString("FeeFlag"));
			feeSchedule.setAttributeValue("PayDate", businessDate);
			feeSchedule.setAttributeValue("Currency", fee.getString("Currency"));
			feeSchedule.setAttributeValue("Amount", feeAmount+waiveAmount);
			feeSchedule.setAttributeValue("FeeSerialNo", fee.getString("SerialNo"));
			feeSchedule.setAttributeValue("WaiveAmount", waiveAmount);
			feeScheduleList.add(feeSchedule);
			//���÷����ܽ��\��������ܽ��
			fee.setAttributeValue("TotalAmount",Arith.round((fee.getDouble("TotalAmount")+feeSchedule.getDouble("Amount")),2));
			fee.setAttributeValue("WaiveAmount",Arith.round((fee.getDouble("WaiveAmount")+feeSchedule.getDouble("WaiveAmount")),2));
		}
		
		return feeScheduleList;
	}
	
	/**
	 * ���ز�Ʒ������fee������
	 * @param fee
	 * @param relativeBusinessObject
	 * @param bomanager
	 * @return
	 * @throws NumberFormatException
	 * @throws Exception
	 */
	public static BusinessObject importTermParameter(BusinessObject fee,BusinessObject relativeBusinessObject,AbstractBusinessObjectManager bomanager) throws NumberFormatException, Exception{
		String feeTermID = fee.getString("FeeTermID");
		String productID=relativeBusinessObject.getString("BusinessType");
		String versionID=relativeBusinessObject.getString("ProductVersion");
		ASValuePool term=null;
		if(productID!=null&&productID.length()>0){
			term=ProductConfig.getProductTerm(productID, versionID, feeTermID);
		}
		if(term==null){
			term=ProductConfig.getTerm(feeTermID);
		}
		if(term==null) return fee;
		ASValuePool termPara = (ASValuePool)term.getAttribute("TermParameters");//�õ��������
		
		Object[] para_keys=termPara.getKeys();
		for(int k=0;k<para_keys.length;k++){
			String paraID = (String)para_keys[k];//term_para��ParaID
			ASValuePool paramter = (ASValuePool)termPara.getAttribute(paraID);
			String defaultValue = paramter.getString("DefaultValue");
			if(defaultValue == null || "".equals(defaultValue)){
				defaultValue = paramter.getString("ValueList");
				if(defaultValue == null || "".equals(defaultValue)){
					continue;
				}
				if(paraID.equals("FeeTransactionCode"))//���ɷ���ʱ��û�����ù��������룬ACCT_FEE����TransCode��������FeeTransactionCode
				{
					fee.setAttributeValue("TransCode", defaultValue);
				}
			}
			Item itemAttributes = CodeCache.getItem("TermAttribute",paraID);
			if(itemAttributes == null) {
				continue;
			}
			String attribute3 = itemAttributes.getAttribute3();//�ֶι�����������
			if(attribute3 == null) attribute3 = "";
			String[] ars = attribute3.split(",");
			for(int n=0;n<ars.length;n++){
				if(ars[n]==null || "".equals(ars[n])) {
					fee.setAttributeValue(paraID, defaultValue);
				}
				else if(ars[n].startsWith(fee.getObjectType())){//������������ڵ�ǰҵ�����ʱ
					String objectAttributeID = ars[n].substring(ars[n].lastIndexOf(".")+1);
					String objectAttributeValue = DataConvert.toString(fee.getString(objectAttributeID));//���ԭֵΪ�ղ���������ֵ
					if(objectAttributeValue==null||objectAttributeValue.length()==0){
						fee.setAttributeValue(objectAttributeID, defaultValue);
					}
				}
				else{
					fee.setAttributeValue(paraID, defaultValue);
				}
			}
		}
		return fee;
	}

	/**
	 * ��������̯����¼��������
	 * @throws Exception 
	 */
	public static BusinessObject createFeeAmortizeSchedule(BusinessObject fee,String businessDate,AbstractBusinessObjectManager bom) throws Exception{
		String amortizeType = fee.getString("FeeAmortizeType");
		if(ACCOUNT_CONSTANTS.AMORTIZE_NO.equals(amortizeType)) return null;
		
		double balance = fee.getDouble("AMORTIZEBALANCE");
		if(Arith.round(balance, 2)<=0) return null;
		String amortizeEndDate = fee.getString("AMORTIZEENDDATE");
		if("".equals(amortizeEndDate)) throw new Exception("����{"+fee.getString("SerialNo")+"}��̯����ֹ����Ϊ�գ�");
		
		BusinessObject amortizeFrequency=(BusinessObject)PaymentFrequencyConfig.getFeeAmortizeTypeSet().getAttribute(amortizeType);
		if(amortizeFrequency == null) throw new Exception("���õ�̯����ʽ��"+amortizeType+"��δ��ϵͳ�ж��壡");
		String termUnit=amortizeFrequency.getString("TermUnit");
		int term=amortizeFrequency.getInt("Term");
		
		int amortizeTerm = DateFunctions.getUpTermPeriod(businessDate,amortizeEndDate,termUnit,term);
		double avAmount = 0d;
		if(amortizeTerm<=1) avAmount=balance;
		else avAmount=Arith.round(balance/amortizeTerm, 2);
		if(avAmount > 0){
			BusinessObject feeSchedule = new BusinessObject(BUSINESSOBJECT_CONSTATNTS.feeAmortize_schedule,bom);
			feeSchedule.setAttributeValue("ObjectType", fee.getString("ObjectType"));
			feeSchedule.setAttributeValue("ObjectNo", fee.getString("ObjectNo"));
			feeSchedule.setAttributeValue("FEESERIALNO", fee.getString("SerialNo"));
			feeSchedule.setAttributeValue("AMORTIZEAMOUNT", Arith.round(avAmount,2));
			feeSchedule.setAttributeValue("AMORTIZEDATE", businessDate);
			feeSchedule.setAttributeValue("STATUS", "0");//δ̯��
			feeSchedule.setAttributeValue("REMARK", "ϵͳ�Զ����㣨ƽ��̯����");
			return feeSchedule;
		}
		return null;
	}
	
	
	//�������׸��·��ý��
	public static void updateFeeAmount(String parentTransSerialNo,Transaction sqlca) throws Exception{
		AbstractBusinessObjectManager bom =new DefaultBusinessObjectManager(sqlca);
		BusinessObject parentTransaction = bom.loadObjectWithKey(BUSINESSOBJECT_CONSTATNTS.transaction, parentTransSerialNo);
		BusinessObject document = bom.loadObjectWithKey(parentTransaction.getString("DocumentType"), parentTransaction.getString("DocumentSerialNo"));
		BusinessObject relativeObject = bom.loadObjectWithKey(parentTransaction.getString("RelativeObjectType"), parentTransaction.getString("RelativeObjectNo"));
		document.setRelativeObject(relativeObject);
		
		
		String whereClauseSql =" ParentTransSerialNo=:TransactionSerialNo and TransStatus='0'" ;
		ASValuePool as = new ASValuePool();
		as.setAttribute("TransactionSerialNo", parentTransaction.getString("SerialNo"));
		List<BusinessObject> transList = bom.loadBusinessObjects(BUSINESSOBJECT_CONSTATNTS.transaction, whereClauseSql,as);
		if(transList != null && !transList.isEmpty())
		{
			for(BusinessObject trans:transList)
			{
				BusinessObject fee = bom.loadObjectWithKey(trans.getString("RelativeObjectType"),trans.getString("RelativeObjectNo"));
				BusinessObject feelog = bom.loadObjectWithKey(trans.getString("DocumentType"),trans.getString("DocumentSerialNo"));
				double feeAmount = com.amarsoft.app.accounting.util.FeeFunctions.calFeeAmount(fee,document,bom);
				if(Math.abs(feelog.getDouble("FeeAmount")-feeAmount) <= 0.0000001) continue;
				String feeFlag = fee.getString("FeeFlag");
				if("R".equals(feeFlag)){
					if(feeAmount >(fee.getDouble("TotalAmount")-fee.getDouble("ActualRecieveAmount")) && fee.getDouble("TotalAmount") > 0)
					{
						feeAmount = fee.getDouble("TotalAmount")-fee.getDouble("ActualRecieveAmount");
					}
				}
				else if(feeFlag.equals("P")){
					if(feeAmount >(fee.getDouble("TotalAmount")-fee.getDouble("ActualPayAmount")) && fee.getDouble("TotalAmount") > 0)
					{
						feeAmount = fee.getDouble("TotalAmount")-fee.getDouble("ActualPayAmount");
					}	
				}
				
				feelog.setAttributeValue("FeeAmount", feeAmount);
				feelog.setAttributeValue("ActualFeeAmount", feeAmount);
				bom.setBusinessObject(AbstractBusinessObjectManager.operateflag_update, feelog);
			}
			bom.updateDB();
		}
	}
}
