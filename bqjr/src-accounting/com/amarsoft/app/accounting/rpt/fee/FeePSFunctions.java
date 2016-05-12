package com.amarsoft.app.accounting.rpt.fee;

import java.util.ArrayList;
import com.amarsoft.app.accounting.businessobject.AbstractBusinessObjectManager;
import com.amarsoft.app.accounting.businessobject.BUSINESSOBJECT_CONSTATNTS;
import com.amarsoft.app.accounting.businessobject.BusinessObject;
import com.amarsoft.app.accounting.util.ExtendedFunctions;
import com.amarsoft.app.accounting.util.FeeFunctions;
import com.amarsoft.are.util.Arith;
import com.amarsoft.dict.als.cache.CodeCache;

public class FeePSFunctions extends FeeFunctions {
	
	//���������򻹿�ƻ������Ӱ�����ƻ���ȡ���õĽ��
		public static double calFeePSAmount(int x,BusinessObject fee,BusinessObject relativeObject,AbstractBusinessObjectManager bom) throws Exception{
			String feeCalType = fee.getString("FeeCalType");
			double feeAmount = 0d;
			if(feeCalType==null||feeCalType.length()==0) throw new Exception("���õļ��㷽ʽΪ�գ�����!");
			if("03".equals(feeCalType)){//�Ʒѻ���Ϊ�������ӻ���ƻ�����һ��ȡ��������
				double baseAmount = 0d; 
				double feerate = fee.getDouble("FeeRate");
				if(x == 1)//����ֱ��ȡ������
					baseAmount = relativeObject.getDouble("BusinessSum");
				else{//������ȡ���ڴ������
					ArrayList<BusinessObject> feePSList = relativeObject.getRelativeObjects(BUSINESSOBJECT_CONSTATNTS.payment_schedule);
					for(BusinessObject feePS:feePSList){
						if(feePS.getInt("SeqID")==(x - 1)&&BUSINESSOBJECT_CONSTATNTS.loan.equals(feePS.getString("ObjectType")))
						{	
							baseAmount = feePS.getDouble("PrincipalBalance");
							break;
						}
					}
				}
				feeAmount = Arith.round(baseAmount * feerate * 0.01,2);
			}
			else{//�Ʒѻ������Ǵ������
				
				String script = CodeCache.getItem("FeeCalType", feeCalType).getItemAttribute();
				if(script==null||script.length()==0) throw new Exception("���ü��㷽ʽ{"+feeCalType+"}û�ж�Ӧ����ű�������!");
				
				script=ExtendedFunctions.replaceAllIgnoreCase(script, fee);
				script=ExtendedFunctions.replaceAllIgnoreCase(script, relativeObject);
				if(script.indexOf("${jbo")>=0){
					return 0d;
				}
				if(script==null||script.length()==0) throw new Exception("���ü��㷽ʽ{"+feeCalType+"}û�ж�Ӧ����ű�������!");
				feeAmount=Arith.round(ExtendedFunctions.getScriptDoubleValue(script, relativeObject, bom.getSqlca()),2);
			}
			return feeAmount;
		}
		
		/**
		 * ��õ�ǰ��Ч�Ļ���������Ϣ
		 * @param loan
		 * @return
		 * @throws Exception
		 */
		public static ArrayList<BusinessObject> getActiveRPTSegment(BusinessObject loan) throws Exception {	
			ArrayList<BusinessObject> rptSegmentList = loan.getRelativeObjects(BUSINESSOBJECT_CONSTATNTS.loan_rpt_segment);
			ArrayList<BusinessObject> validRPTSegmentList= new ArrayList<BusinessObject>();
			if(rptSegmentList==null) return validRPTSegmentList;
			
			String businessDate=loan.getString("BusinessDate");
			for(BusinessObject a:rptSegmentList){
				String status = a.getString("Status");
				if(!status.equals("1")) continue;
				String SegFromDate = a.getString("SegFromDate");
				String SegToDate = a.getString("SegToDate");
				if(SegFromDate!=null&&SegFromDate.length()>0&&SegFromDate.compareTo(businessDate)>0)
					continue;
				if(SegToDate!=null&&SegToDate.length()>0&&SegToDate.compareTo(businessDate)<0)
					continue;
				
				validRPTSegmentList.add(a);
			}
			return validRPTSegmentList;
		}

}
