package com.amarsoft.app.accounting.interest.settle;

import java.util.ArrayList;
import java.util.List;

import com.amarsoft.app.accounting.businessobject.AbstractBusinessObjectManager;
import com.amarsoft.app.accounting.businessobject.BUSINESSOBJECT_CONSTATNTS;
import com.amarsoft.app.accounting.businessobject.BusinessObject;
import com.amarsoft.app.accounting.config.loader.RateConfig;
import com.amarsoft.app.accounting.interest.InterestFunctions;
import com.amarsoft.app.accounting.product.ProductFunctions;
import com.amarsoft.app.accounting.util.ACCOUNT_CONSTANTS;
import com.amarsoft.app.accounting.util.ExtendedFunctions;

public class InterestLogFunctions {
	
	public static BusinessObject createInterestLog(BusinessObject loan
			,BusinessObject interestObject,BusinessObject rateSegment,String interestDate,String interestType,AbstractBusinessObjectManager bomanager) throws NumberFormatException, Exception{
		BusinessObject interestLog=new BusinessObject(BUSINESSOBJECT_CONSTATNTS.interest_log,bomanager);
		bomanager.setBusinessObject(AbstractBusinessObjectManager.operateflag_new, interestLog);
		loan.setRelativeObject(interestLog);
		interestObject.setRelativeObject(interestLog);
		
		String segFromDate = rateSegment.getString("SegFromDate");
		if(segFromDate!=null&&segFromDate.length()>0){
			if(interestDate.compareTo(segFromDate)<0) interestDate=segFromDate;
		}
		
		interestLog.setAttributeValue("RelativeObjectType", loan.getObjectType());
		interestLog.setAttributeValue("RelativeObjectNo", loan.getObjectNo());
		interestLog.setAttributeValue("ObjectType", interestObject.getObjectType());
		interestLog.setAttributeValue("ObjectNo", interestObject.getObjectNo());
		interestLog.setAttributeValue("RateSegmentNo", rateSegment.getObjectNo());
		interestLog.setAttributeValue("InterestDate", interestDate);
		interestLog.setAttributeValue("LastInteDate", interestDate);
		interestLog.setAttributeValue("BaseAmountFlag", interestType);
		
		
		String compoundInterestFlag = ProductFunctions.getObjectExAttributeValue(loan, rateSegment, rateSegment.getString("RateTermID"), "CompoundInterestFlag");//计复利标示
		
		if(compoundInterestFlag!=null&&compoundInterestFlag.length()>0){
			interestLog.setAttributeValue("CompoundInterestFlag", compoundInterestFlag);
		}
		else{
			interestLog.setAttributeValue("CompoundInterestFlag", ACCOUNT_CONSTANTS.COMPOUNDINTERESTFLAG_SINGLE);
		}
		return interestLog;
	}
	
	public static BusinessObject settleInterestLog(BusinessObject loan,BusinessObject interestLog,String settleDate,AbstractBusinessObjectManager bomanager) throws Exception{
		BusinessObject rateSegment = loan.getRelativeObject(BUSINESSOBJECT_CONSTATNTS.loan_rate_segment,interestLog.getString("RateSegmentNo"));
		String segToDate = rateSegment.getString("SegToDate");
		if(segToDate!=null&&segToDate.length()>0){
			if(settleDate.compareTo(segToDate)>0)settleDate=segToDate;
		}
		String interestType =interestLog.getString("BaseAmountFlag");
		
		BusinessObject interestObject=null;
		if(loan.getObjectType().equals(interestLog.getString("ObjectType"))) interestObject = loan;
		else interestObject = loan.getRelativeObject(interestLog.getString("ObjectType"), interestLog.getString("ObjectNo"));
		if(interestObject==null) throw new Exception("未找到计息对象，"+interestLog.getString("ObjectType")+ interestLog.getString("ObjectNo")+"！");
		
		
		
		InterestLogFunctions.accrueInterestLog(loan, interestLog, settleDate, bomanager);
		interestLog.setAttributeValue("InterestAmt",interestLog.getDouble("InterestAmt")+interestLog.getDouble("InterestBase"));
		interestLog.setAttributeValue("SettleDate", settleDate);
		bomanager.setBusinessObject(AbstractBusinessObjectManager.operateflag_update, interestLog);

		String interestEffectScript =RateConfig.getInterestConfig(interestType, "InterestEffectScript");
		if(interestEffectScript!=null&&interestEffectScript.length()>0) {
			interestEffectScript = ExtendedFunctions.getScript(interestEffectScript, interestObject, null);
			boolean b = ExtendedFunctions.getScriptBooleanValue(interestEffectScript, loan,null);
			if(!b) return null;
		}

		String baseAmountScript=ExtendedFunctions.getScript(RateConfig.getInterestConfig(interestType,"InterestBaseAmountScript"), interestObject, null);
		double baseAmount = ExtendedFunctions.getScriptDoubleValue(baseAmountScript, loan,null);
		if(baseAmount+interestLog.getMoney("InterestBalance")<0.00001) return null;
		
		BusinessObject newInterestLog = InterestLogFunctions.createInterestLog(loan, interestObject, rateSegment, settleDate, interestLog.getString("BaseAmountFlag"), bomanager);
		if(newInterestLog!=null){
			newInterestLog.setAttributeValue("InterestBalance", interestLog.getMoney("InterestBalance"));
			newInterestLog.setAttributeValue("InterestTotal", interestLog.getMoney("InterestTotal"));
			newInterestLog.setAttributeValue("InterestSuspense", interestLog.getMoney("InterestSuspense"));
		}
		bomanager.setBusinessObject(AbstractBusinessObjectManager.operateflag_update, newInterestLog);
		return newInterestLog;
	}
	
	public static void updateBalance(BusinessObject loan,BusinessObject interestLog,double amount,AbstractBusinessObjectManager bomanager) throws Exception{
		double interestBalance = interestLog.getMoney("InterestBalance");
		interestBalance-=amount;
		interestLog.setAttributeValue("InterestBalance", interestBalance);
		bomanager.setBusinessObject(AbstractBusinessObjectManager.operateflag_update, interestLog);
	}
	
	public static void updateBalance(BusinessObject loan,BusinessObject interestObject,String interestType,double actualPayAmt,AbstractBusinessObjectManager bomanager) throws Exception{
		List<BusinessObject> interestLogList = getActiveInterestLog(loan,interestObject,interestType);
		if(interestLogList==null||interestLogList.isEmpty()) return;
		for(BusinessObject interestLog:interestLogList){
			if(actualPayAmt<0d) break;
			double amount = 0d;
			double interestBalance = interestLog.getMoney("InterestBalance");
			if(actualPayAmt>interestBalance){
				amount=interestBalance;
			}
			else{
				amount=actualPayAmt;
			}
			InterestLogFunctions.updateBalance(loan, interestLog, amount, bomanager);
			actualPayAmt=actualPayAmt-amount;
			if(actualPayAmt<=0d){
				actualPayAmt = -1;
				break;
			}
		}
	}
	
	public static void accrueInterestLog(BusinessObject loan,BusinessObject interestLog,String accrueDate,AbstractBusinessObjectManager bomanager) throws Exception{
		BusinessObject rateSegment = loan.getRelativeObject(BUSINESSOBJECT_CONSTATNTS.loan_rate_segment,interestLog.getString("RateSegmentNo"));
		String segToDate = rateSegment.getString("SegToDate");
		if(segToDate!=null&&segToDate.length()>0){
			if(accrueDate.compareTo(segToDate)>0)accrueDate=segToDate;
		}
		double oldInterestBase = interestLog.getMoney("InterestBase");
		double interestBalance = interestLog.getMoney("InterestBalance");
		double interestTotal = interestLog.getMoney("InterestTotal");
		
		double interestBaseAmount = interestLog.getDouble("BaseAmount");
		if(interestBaseAmount<=0d){
			String interestType = interestLog.getString("BaseAmountFlag");
			BusinessObject interestObject=null;
			if(loan.getObjectType().equals(interestLog.getString("ObjectType"))) interestObject = loan;
			else interestObject = loan.getRelativeObject(interestLog.getString("ObjectType"), interestLog.getString("ObjectNo"));
			if(interestObject==null) throw new Exception("未找到计息对象，"+interestLog.getString("ObjectType")+ interestLog.getString("ObjectNo")+"！");
			String baseAmountScript=ExtendedFunctions.getScript(RateConfig.getInterestConfig(interestType,"InterestBaseAmountScript"), interestObject, null);
			double baseAmount = ExtendedFunctions.getScriptDoubleValue(baseAmountScript, loan,null);
			if(baseAmount<0.00001) return;
			interestLog.setAttributeValue("BaseAmount", baseAmount);
			interestBaseAmount = baseAmount;
		}
		
		if(ACCOUNT_CONSTANTS.COMPOUNDINTERESTFLAG_COMP.equals(interestLog.getString("CompoundInterestFlag"))){
			interestBaseAmount += interestLog.getDouble("InterestBalance")-interestLog.getDouble("InterestBase");
		}
		
		double interest = InterestFunctions.getInterest(interestBaseAmount,rateSegment,loan, interestLog.getString("InterestDate"), accrueDate);
		
		interestLog.setAttributeValue("InterestBase", interest);
		interestLog.setAttributeValue("InterestBalance", interestBalance-oldInterestBase+interest);
		interestLog.setAttributeValue("InterestTotal", interestTotal-oldInterestBase+interest);
		
		interestLog.setAttributeValue("LastInteDate", accrueDate);
		bomanager.setBusinessObject(AbstractBusinessObjectManager.operateflag_update, interestLog);
	}
	
	//取有效的利息日志
	public static List<BusinessObject> getActiveInterestLog(BusinessObject loan) throws Exception{
		List<BusinessObject> a = new ArrayList<BusinessObject>();
		List<BusinessObject> interestLogList = loan.getRelativeObjects(BUSINESSOBJECT_CONSTATNTS.interest_log);
		if(interestLogList==null) return null;
		for(BusinessObject interestLog:interestLogList){
			String settleDate = interestLog.getString("SettleDate");
			if(settleDate != null && !"".equals(settleDate)) continue;//如果已结息，跳过
			a.add(interestLog);
		}
		return a;
	}
	
	//取有效的利息日志
	public static List<BusinessObject> getActiveInterestLog(BusinessObject loan,BusinessObject interestObject) throws Exception{
		List<BusinessObject> a = new ArrayList<BusinessObject>();
		List<BusinessObject> interestLogList = getActiveInterestLog(loan);
		if(interestLogList==null||interestLogList.isEmpty()) return null;
		for(BusinessObject interestLog:interestLogList){
			String objectType = interestLog.getString("ObjectType");
			String objectNo = interestLog.getString("ObjectNo");
			if(objectType.equals(interestObject.getObjectType())&&objectNo.equals(interestObject.getObjectNo()))
				a.add(interestLog);
		}
		return a;
	}
	
	//取有效的利息日志
	public static List<BusinessObject> getActiveInterestLog(BusinessObject loan,String interestType) throws Exception{
		List<BusinessObject> a = new ArrayList<BusinessObject>();
		List<BusinessObject> interestLogList = loan.getRelativeObjects(BUSINESSOBJECT_CONSTATNTS.interest_log);
		if(interestLogList==null) return null;
		for(BusinessObject interestLog:interestLogList){
			String settleDate = interestLog.getString("SettleDate");
			if(settleDate != null && !"".equals(settleDate)) continue;//如果已结息，跳过
			if(interestType.equals(interestLog.getString("BaseAmountFlag"))) a.add(interestLog);
		}
		return a;
	}
			
	//取有效的利息日志
	public static List<BusinessObject> getActiveInterestLog(BusinessObject loan,BusinessObject interestObject,String interestType) throws Exception{
		List<BusinessObject> a = new ArrayList<BusinessObject>();
		String interestObjectType = interestObject.getObjectType();
		String interestObjectNo = interestObject.getObjectNo();
		
		List<BusinessObject> interestLogList = InterestLogFunctions.getActiveInterestLog(loan, interestType);
		if(interestLogList==null) return null;
		for(BusinessObject interestLog:interestLogList){
			if(!interestObjectType.equals(interestLog.getString("ObjectType"))) continue;//不是当前计息对象的，跳过
			if(!interestObjectNo.equals(interestLog.getString("ObjectNo"))) continue;//不是当前计息对象的，跳过
			
			a.add(interestLog);
		}
		return a;
	}
	
	//取有效的利息日志
	public static BusinessObject getActiveInterestLog(BusinessObject loan,BusinessObject interestObject,String interestType,BusinessObject rateSegment) throws Exception{
		List<BusinessObject> a = new ArrayList<BusinessObject>();
		
		String segmentSerialNo = rateSegment.getString("SerialNo");
		List<BusinessObject> interestLogList = InterestLogFunctions.getActiveInterestLog(loan, interestObject, interestType);
		if(interestLogList==null||interestLogList.isEmpty()) return null;
		for(BusinessObject interestLog:interestLogList){
			if(segmentSerialNo.equals(interestLog.getString("RateSegmentNo"))) a.add(interestLog);
		}
		if(a.size()>1) throw new Exception("同一利率对应的有效的InterestLog超过了一个！");
		else if(a.size()==1) return a.get(0);
		else return null;
	}
	
}
