package com.amarsoft.app.accounting.util;

import java.util.ArrayList;
import java.util.List;

import com.amarsoft.amarscript.Expression;
import com.amarsoft.app.accounting.businessobject.BUSINESSOBJECT_CONSTATNTS;
import com.amarsoft.app.accounting.businessobject.BusinessObject;
import com.amarsoft.app.accounting.businessobject.AbstractBusinessObjectManager;
import com.amarsoft.app.accounting.interest.InterestFunctions;
import com.amarsoft.app.accounting.util.ExtendedFunctions;
import com.amarsoft.are.util.ASValuePool;
import com.amarsoft.are.util.Arith;
import com.amarsoft.dict.als.cache.CodeCache;

public class SPTFunctions {
	//计算还款计划对应的贴息金额
	public static ArrayList<Double> calSPTAmount(BusinessObject spt, BusinessObject relativeObject, List<BusinessObject> paymentSchedule, AbstractBusinessObjectManager bom) throws Exception{
		String sptCalType = spt.getString("SPTCalType");
		
		if(sptCalType == null || sptCalType.length() == 0) throw new Exception("贴息的计算方式为空，请检查!");
		String script = CodeCache.getItem("SPTCalType", sptCalType).getItemAttribute();
		if(script == null || script.length() == 0) throw new Exception("贴息计算方式{"+sptCalType+"}没有对应计算脚本，请检查!");
		
		script = ExtendedFunctions.replaceAllIgnoreCase(script, spt);
		script = ExtendedFunctions.replaceAllIgnoreCase(script, relativeObject);
		
		BusinessObject rate = InterestFunctions.getActiveRateSegment(relativeObject, ACCOUNT_CONSTANTS.RateType_Normal).get(0);
		script = ExtendedFunctions.replaceAllIgnoreCase(script, rate);
			
		ArrayList<Double> sptAmount = new ArrayList<Double>();
 		for(int i=0 ; i< paymentSchedule.size(); i++)
		{
 			double temp = 0d;
 			script = ExtendedFunctions.replaceAllIgnoreCase(script, paymentSchedule.get(i));
			if(script == null || script.length() == 0) throw new Exception("贴息计算方式{"+sptCalType+"}没有对应计算脚本，请检查!");
		
			if(script.indexOf("${") >= 0){
				temp = 0d;
			}
			temp = Arith.round(Expression.getExpressionValue(script, bom.getSqlca()).doubleValue(), 2);
			sptAmount.add(temp);
		}
		return sptAmount;
	}
	
	//加载贷款的贴息信息
	public static List<BusinessObject> loadSPTList(BusinessObject relativeObject,AbstractBusinessObjectManager bom) throws Exception{

		List<BusinessObject> spt = new ArrayList<BusinessObject>();
		ASValuePool as = new ASValuePool();
		
		as.setAttribute("ObjectType", relativeObject.getObjectType());
		as.setAttribute("ObjectNo", relativeObject.getObjectNo());
		
		spt = bom.loadBusinessObjects(BUSINESSOBJECT_CONSTATNTS.loan_spt_segment, " ObjectType=:ObjectType and ObjectNo=:ObjectNo", as);
			
		return spt;
	}
	
	//创建贴息计划
	public static List<BusinessObject> createSPTScheduleList(List<BusinessObject>  sptList, BusinessObject relativeObject, AbstractBusinessObjectManager bom) throws Exception{
		List<BusinessObject> sptScheduleList = new ArrayList<BusinessObject>();
		if(sptList==null || sptList.size() == 0) 
			return sptScheduleList;
		
		ASValuePool as = new ASValuePool();		
		as.setAttribute("ObjectType", relativeObject.getObjectType());
		as.setAttribute("ObjectNo", relativeObject.getObjectNo());	
		
		List<BusinessObject> paymentSchedule =  bom.loadBusinessObjects(BUSINESSOBJECT_CONSTATNTS.payment_schedule, " ObjectNo=:ObjectNo and ObjectType=:ObjectType", as);
		
		for(BusinessObject spt : sptList) {
			ArrayList<Double> sptAmount = SPTFunctions.calSPTAmount(spt, relativeObject, paymentSchedule, bom);
	 		for(int i = 0; i < paymentSchedule.size(); i ++) {
	 			ASValuePool sptSchedule = new ASValuePool();
	 			sptSchedule.setAttribute("SEQID", paymentSchedule.get(i).getInt("SEQID"));
	 			sptSchedule.setAttribute("PAYDATE", paymentSchedule.get(i).getString("PAYDATE"));
	 			sptSchedule.setAttribute("SPTAMOUNT", sptAmount.get(i));
	 			sptSchedule.setAttribute("SPTTERMID", spt.getString("SPTTERMID"));
	 			
	 			sptScheduleList.add(new BusinessObject(sptSchedule));
	 		}
 		}
		return sptScheduleList;
	}
	
	//更新贴息区段表
	public static void updateSPTSegment(BusinessObject spt, BusinessObject relativeObject, AbstractBusinessObjectManager bom) throws Exception{
		spt.setAttributeValue("STATUS", "1");
		spt.setAttributeValue("ObjectNo", relativeObject.getObjectNo());
		spt.setAttributeValue("ObjectType", relativeObject.getObjectType());
		spt.setAttributeValue("SPTACCOUNTCCY", relativeObject.getString("Currency"));
		if(bom != null)
			bom.setBusinessObject(AbstractBusinessObjectManager.operateflag_update, spt);
	}
}
