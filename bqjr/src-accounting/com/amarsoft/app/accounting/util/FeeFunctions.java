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
	 * 根据系统定义的费用计算方式计算单期费用金额
	 * @param fee
	 * @param bom
	 * @return
	 * @throws Exception
	 */
	public static double calFeeAmount(BusinessObject fee,BusinessObject relativeObject,AbstractBusinessObjectManager bom) throws Exception{
		String feeCalType = fee.getString("FeeCalType");
		if(feeCalType==null||feeCalType.length()==0) throw new Exception("费用的计算方式为空，请检查!");
		String script = CodeCache.getItem("FeeCalType", feeCalType).getItemAttribute();
		if(script==null||script.length()==0) throw new Exception("费用计算方式{"+feeCalType+"}没有对应计算脚本，请检查!");
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
			//处理按合同收费但是收费对象不是合同的情况，如印花税
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
			//处理按合同收费但是收费对象不是合同的情况，如印花税
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
		//处理交易关联手续费，如提前还款
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
		if(script==null||script.length()==0) throw new Exception("费用计算方式{"+feeCalType+"}没有对应计算脚本，请检查!");
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
		if(term==null) throw new Exception("创建费用失败，未找到费用组件定义！");
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
			throw new Exception("产品中未配置【费用类型】！");
		}
		return fee;
	}
	
	/**
	 *测算费用计划，计算费用总额和减免总额
	 *对于一次性收付费用，此处只计算费用总额和减免总额
	 * @throws Exception 
	 */
	public static ArrayList<BusinessObject> createFeeScheduleList(BusinessObject fee,BusinessObject relativeObject,AbstractBusinessObjectManager bom) throws Exception{
		ArrayList<BusinessObject> feeScheduleList = new ArrayList<BusinessObject>();
		
		String feePayDateFlag=fee.getString("FeePayDateFlag");
		if("06".equals(feePayDateFlag)){//首次还款日收取
			if(!relativeObject.getObjectType().equals(BUSINESSOBJECT_CONSTATNTS.loan)) return null;
			
			fee.setRelativeObject(relativeObject);//loan
			ArrayList<BusinessObject> pslist = relativeObject.getRelativeObjects(BUSINESSOBJECT_CONSTATNTS.payment_schedule);
			if(pslist == null || pslist.isEmpty()) return null;
			BusinessObject ps=pslist.get(0);//取首个还款计划
			String firstDueDate = ps.getString("PayDate");
			fee.setAttributeValue("TotalAmount", 0.0d);//将总金额清零重新计算
			fee.setAttributeValue("WaiveAmount", 0.0d);
			List<BusinessObject> feeSchedules = createFeeSchedule(fee,relativeObject,ps, firstDueDate, bom);
			feeScheduleList.addAll(feeSchedules);
			return feeScheduleList;
		}
		else if("05".equals(feePayDateFlag)){//随还款计划收取
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
		else if("04".equals(feePayDateFlag)){//按周期收取
			if(!relativeObject.getObjectType().equals(BUSINESSOBJECT_CONSTATNTS.loan))
			{
				return null;
			}
			fee.setAttributeValue("TotalAmount", 0.0d);
			fee.setAttributeValue("WaiveAmount", 0.0d);
			return FeeFunctions.getFeeSchedule(fee,relativeObject,bom);
		}
		else {//一次性收取
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
						if("0".equals(waiveType))//按照金额减免
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
		
		//获取收付频率
		String feeFrequency = fee.getString("FeeFrequency");
		if(feeFrequency == null || "".equals(feeFrequency))
		{
			throw new Exception("费用【"+fee.getString("SerialNo")+"】异常！费用收付频率为空！");
		}
		//获取频率参数
		BusinessObject bo = (BusinessObject)PaymentFrequencyConfig.getPaymentFrequencySet().getAttribute(feeFrequency);
		int term = bo.getInt("Term");
		String units = bo.getString("TermUnit");
		if(term == 0 || units == null || "".equals(units))
			throw new Exception("未定义该费用的还款周期，请检查！");
		
		String segFromDate = fee.getString("SEGFromDate");//区段起始日期
		int segFromStage   = fee.getInt("SEGFromStage");//区段起始期次
		int segStages       = fee.getInt("SEGStages");//持续期次
		String segToDate   = fee.getString("SEGToDate");//区段结束日期
		int segToStage     = fee.getInt("SEGToStage");//区段结束期次
		//如果开始日期为空则取放款日期
		if(segFromDate == null || "".equals(segFromDate))
		{
			segFromDate = loan.getString("PutoutDate");
		}
		//如果开始期次大于0,则根据开始期次求取开始日期
		if(segFromStage > 0)
		{
			segFromDate = DateFunctions.getRelativeDate(segFromDate,DateFunctions.TERM_UNIT_MONTH,segFromStage-1);
		}
		//如果开始日期为空则取贷款到期日
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
		
		//防止死循环
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
						if("0".equals(waiveType))//按照金额减免
							waiveAmount += waiveAmt;
						else if("1".equals(waiveType))
							waiveAmount += feeAmount*waivePecent/100.0;
					}
				}
			}
			
			if(ACCOUNT_CONSTANTS.FEEFLAG_RP.equals(fee.getString("FeeFlag")))//代收代付
			{
				//收
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
				//付
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
				//设置费用总金额\费用减免总金额
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
				//设置费用总金额
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
	 * 根据费用定义此费用是根据入账机构还是经办机构收取
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
		if(feeCalType==null||feeCalType.length()==0) throw new Exception("费用的计算方式为空，请检查!");
		String script = CodeCache.getItem("FeeCalType", feeCalType).getItemAttribute();
		if(script==null||script.length()==0) throw new Exception("费用计算方式{"+feeCalType+"}没有对应计算脚本，请检查!");
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
			throw new Exception("费用计算方式{"+feeCalType+"}计算脚本参数未替换完整{"+script+"}，请检查!");
		}
		if(script==null||script.length()==0) throw new Exception("费用计算方式{"+feeCalType+"}没有对应计算脚本，请检查!");
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
					if("0".equals(waiveType))//按照金额减免
						waiveAmount += waiveAmt;
					else if("1".equals(waiveType))
						waiveAmount += feeAmount*waivePecent/100.0;
				}
			}
		}
		
		List<BusinessObject> feeScheduleList = new ArrayList<BusinessObject>();
		
		if(ACCOUNT_CONSTANTS.FEEFLAG_RP.equals(fee.getString("FeeFlag")))//代收代付
		{
			//收
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
			//付
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
			//设置费用总金额\减免费用总金额
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
			//设置费用总金额\减免费用总金额
			fee.setAttributeValue("TotalAmount",Arith.round((fee.getDouble("TotalAmount")+feeSchedule.getDouble("Amount")),2));
			fee.setAttributeValue("WaiveAmount",Arith.round((fee.getDouble("WaiveAmount")+feeSchedule.getDouble("WaiveAmount")),2));
		}
		
		return feeScheduleList;
	}
	
	/**
	 * 加载产品参数到fee对象中
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
		ASValuePool termPara = (ASValuePool)term.getAttribute("TermParameters");//得到组件参数
		
		Object[] para_keys=termPara.getKeys();
		for(int k=0;k<para_keys.length;k++){
			String paraID = (String)para_keys[k];//term_para的ParaID
			ASValuePool paramter = (ASValuePool)termPara.getAttribute(paraID);
			String defaultValue = paramter.getString("DefaultValue");
			if(defaultValue == null || "".equals(defaultValue)){
				defaultValue = paramter.getString("ValueList");
				if(defaultValue == null || "".equals(defaultValue)){
					continue;
				}
				if(paraID.equals("FeeTransactionCode"))//生成费用时，没有设置关联交易码，ACCT_FEE中是TransCode，而不是FeeTransactionCode
				{
					fee.setAttributeValue("TransCode", defaultValue);
				}
			}
			Item itemAttributes = CodeCache.getItem("TermAttribute",paraID);
			if(itemAttributes == null) {
				continue;
			}
			String attribute3 = itemAttributes.getAttribute3();//字段关联对象属性
			if(attribute3 == null) attribute3 = "";
			String[] ars = attribute3.split(",");
			for(int n=0;n<ars.length;n++){
				if(ars[n]==null || "".equals(ars[n])) {
					fee.setAttributeValue(paraID, defaultValue);
				}
				else if(ars[n].startsWith(fee.getObjectType())){//这个属性是属于当前业务对象时
					String objectAttributeID = ars[n].substring(ars[n].lastIndexOf(".")+1);
					String objectAttributeValue = DataConvert.toString(fee.getString(objectAttributeID));//如果原值为空才设置条款值
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
	 * 创建费用摊销记录，不入账
	 * @throws Exception 
	 */
	public static BusinessObject createFeeAmortizeSchedule(BusinessObject fee,String businessDate,AbstractBusinessObjectManager bom) throws Exception{
		String amortizeType = fee.getString("FeeAmortizeType");
		if(ACCOUNT_CONSTANTS.AMORTIZE_NO.equals(amortizeType)) return null;
		
		double balance = fee.getDouble("AMORTIZEBALANCE");
		if(Arith.round(balance, 2)<=0) return null;
		String amortizeEndDate = fee.getString("AMORTIZEENDDATE");
		if("".equals(amortizeEndDate)) throw new Exception("费用{"+fee.getString("SerialNo")+"}的摊销截止日期为空！");
		
		BusinessObject amortizeFrequency=(BusinessObject)PaymentFrequencyConfig.getFeeAmortizeTypeSet().getAttribute(amortizeType);
		if(amortizeFrequency == null) throw new Exception("费用的摊销方式【"+amortizeType+"】未在系统中定义！");
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
			feeSchedule.setAttributeValue("STATUS", "0");//未摊销
			feeSchedule.setAttributeValue("REMARK", "系统自动计算（平均摊销）");
			return feeSchedule;
		}
		return null;
	}
	
	
	//随主交易更新费用金额
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
