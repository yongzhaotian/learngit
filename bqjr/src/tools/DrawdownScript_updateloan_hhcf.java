package tools;

import java.util.ArrayList;
import java.util.List;

import com.amarsoft.amarscript.Expression;
import com.amarsoft.app.accounting.businessobject.AbstractBusinessObjectManager;
import com.amarsoft.app.accounting.businessobject.BUSINESSOBJECT_CONSTATNTS;
import com.amarsoft.app.accounting.businessobject.BusinessObject;
import com.amarsoft.app.accounting.config.SystemConfig;
import com.amarsoft.app.accounting.trans.ITransactionScript;
import com.amarsoft.app.accounting.trans.script.ITransactionExecutor;
import com.amarsoft.app.accounting.util.ACCOUNT_CONSTANTS;
import com.amarsoft.app.accounting.util.ExtendedFunctions;
import com.amarsoft.app.accounting.util.FeeFunctions;
import com.amarsoft.are.util.ASValuePool;
import com.amarsoft.are.util.Arith;
import com.amarsoft.dict.als.cache.CodeCache;

/**
 * �����
 */
public class DrawdownScript_updateloan_hhcf implements ITransactionExecutor{

	/**
	 * �������ݴ���
	 * ̎���M�Üp��
	 */
	public int execute(String scriptID,ITransactionScript transactionScript) throws Exception {
		BusinessObject transaction = transactionScript.getTransaction();
		AbstractBusinessObjectManager boManager = transactionScript.getBOManager();
		BusinessObject businessPutout=transaction.getRelativeObject(transaction.getString("DocumentType"), transaction.getString("DocumentSerialNo"));
		BusinessObject loan = transaction.getRelativeObject(transaction.getString("RelativeObjectType"), transaction.getString("RelativeObjectNo"));
		//�����滹��ƻ�����
		ArrayList<BusinessObject> feeList = loan.getRelativeObjects(BUSINESSOBJECT_CONSTATNTS.fee);
		if(feeList !=null)
		{
			for(BusinessObject fee:feeList)
			{
				if(fee.getRelativeObjects(BUSINESSOBJECT_CONSTATNTS.fee_schedule)==null || fee.getRelativeObjects(BUSINESSOBJECT_CONSTATNTS.fee_schedule).isEmpty())
				{
					ArrayList<BusinessObject> feeScheduleList_T = createFeeScheduleList(fee,loan, boManager);
					fee.setRelativeObjects(feeScheduleList_T);
					loan.setRelativeObjects(feeScheduleList_T);
					boManager.setBusinessObjects(AbstractBusinessObjectManager.operateflag_new, feeScheduleList_T);
				}
			}
		}
		
		//��bc��ʵ�ʷſ������
		BusinessObject bc = businessPutout.getRelativeObject(BUSINESSOBJECT_CONSTATNTS.business_contract, businessPutout.getString("ContractSerialNo"));
		if(bc!=null){
			bc.setAttributeValue("ActualputoutSum", bc.getDouble("ActualputoutSum")+loan.getDouble("BusinessSum"));
			boManager.setBusinessObject(AbstractBusinessObjectManager.operateflag_update,bc);
		}
		
		
		
		return 1;
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
			//ArrayList<BusinessObject> pslist = relativeObject.getRelativeObjects(BUSINESSOBJECT_CONSTATNTS.payment_schedule);
			
			ASValuePool aspayment = new ASValuePool();
			aspayment.setAttribute("ObjectNo", relativeObject.getObjectNo());
			aspayment.setAttribute("ObjectType", relativeObject.getObjectType());
			BusinessObject paymentFilter = new BusinessObject(aspayment);
			
			List<BusinessObject> pslist = relativeObject.getRelativeObjects(BUSINESSOBJECT_CONSTATNTS.payment_schedule, paymentFilter);
			
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
		if(fee.getDouble("Amount")<=0.0){
			fee.setAttributeValue("Amount", feeAmount);
		}
		
		if(feeAmount <= 0) return null;
		String waiveFromStage = "";
		String waiveToStage = "";
		double waiveAmount=0d;
		
		ASValuePool asr = new ASValuePool();
		asr.setAttribute("ObjectNo", relativeObject.getObjectNo());
		asr.setAttribute("ObjectType", relativeObject.getObjectType());
		BusinessObject rptFilter = new BusinessObject(asr);
		
		BusinessObject RPTSegment = null;
		List<BusinessObject> RPTSegments = relativeObject.getRelativeObjects(BUSINESSOBJECT_CONSTATNTS.loan_rpt_segment, rptFilter);
		if(RPTSegments != null){
			RPTSegment = RPTSegments.get(0);
		}
		int period = RPTSegment.getInt("TotalPeriod");
		
		if(fee.getRelativeObjects(BUSINESSOBJECT_CONSTATNTS.fee_waive) != null)
		{
			for(BusinessObject fw:fee.getRelativeObjects(BUSINESSOBJECT_CONSTATNTS.fee_waive))
			{
				 waiveFromStage = fw.getString("waiveFromStage");
				 waiveToStage = fw.getString("waiveToStage");
				String waiveFromDate = fw.getString("WaiveFromDate");
				String waiveToDate = fw.getString("WaiveToDate");
				
				if(Integer.parseInt(waiveFromStage) > 0 && Integer.parseInt(waiveToStage) >= Integer.parseInt(waiveFromStage)){
					String waiveType = fw.getString("WaiveType");
					double waivePecent=fw.getDouble("WaivePercent");
					double waiveAmt = fw.getDouble("WaiveAmount");
					
					ASValuePool as = new ASValuePool();
					as.setAttribute("PayDate", businessDate);
					as.setAttribute("PayType", fee.getString("FeeType"));
					BusinessObject attributesFilter = new BusinessObject(as);
					
					List<BusinessObject> feePaymentScheduleList = relativeObject.getRelativeObjects(BUSINESSOBJECT_CONSTATNTS.payment_schedule, attributesFilter);
					if(feePaymentScheduleList != null){
						for(BusinessObject feePaymentSchedule:feePaymentScheduleList){
							int wiaveFromStages = Integer.parseInt(waiveFromStage);
							int waiveToStages = Integer.parseInt(waiveToStage);
							int SeqID = Integer.parseInt(feePaymentSchedule.getString("SeqID"));
							if( SeqID >= wiaveFromStages && SeqID <= waiveToStages){
								feePaymentSchedule.setAttributeValue("ActualPayPrincipalAmt",feePaymentSchedule.getString("PayPrincipalAmt"));
								if("0".equals(waiveType))//���ս�����
									//waiveAmount += waiveAmt;
									waiveAmount += feePaymentSchedule.getDouble("PayPrincipalAmt");
								else if("1".equals(waiveType))
									waiveAmount += feePaymentSchedule.getDouble("PayPrincipalAmt")*waivePecent/100.0;
							}
							
						}
					}
					
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
			//feeSchedule.setAttributeValue("Amount", feeAmount+waiveAmount);
			feeSchedule.setAttributeValue("Amount", Arith.round(feeAmount/period, 2));
			feeSchedule.setAttributeValue("FeeSerialNo", fee.getString("SerialNo"));
			feeSchedule.setAttributeValue("WaiveAmount", waiveAmount);			
			feeScheduleList.add(feeSchedule);
			//���÷����ܽ��\��������ܽ��
			/*fee.setAttributeValue("TotalAmount",Arith.round((fee.getDouble("TotalAmount")+feeSchedule.getDouble("Amount")),2));
			fee.setAttributeValue("WaiveAmount",Arith.round((fee.getDouble("WaiveAmount")+feeSchedule.getDouble("WaiveAmount")),2));*/
			fee.setAttributeValue("TotalAmount",feeAmount);
			fee.setAttributeValue("Amount",Arith.round(fee.getDouble("Amount")-waiveAmount, 2));
			fee.setAttributeValue("WaiveAmount",Arith.round((fee.getDouble("WaiveAmount")+waiveAmount),2));
		}
		
		return feeScheduleList;
	}

}

