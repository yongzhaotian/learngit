/**
 * Class <code>LOAN_BDTrigger</code> �Ǵ������jbo.app.ACCT_LOAN�������ʱ���������������jbo.app.BUSINESS_DUEBILL���ݽ��б��
 * �������ݸ��²μ�<code>AbstractBusinessObjectManager.updateDB</code>����
 *
 * @author  xjzhao
 * @version 1.0, 13/09/23
 * @see com.amarsoft.app.accounting.businessobject.AbstractBusinessObjectManager
 * @see com.amarsoft.app.accounting.businessobject.BusinessObject
 * @since  JDK1.6
 */
package com.amarsoft.app.accounting.businessobject.trigger;

import java.util.List;

import com.amarsoft.app.accounting.businessobject.BUSINESSOBJECT_CONSTATNTS;
import com.amarsoft.app.accounting.businessobject.BusinessObject;
import com.amarsoft.app.accounting.businessobject.AbstractBusinessObjectManager;
import com.amarsoft.app.accounting.config.loader.DateFunctions;
import com.amarsoft.app.accounting.interest.InterestFunctions;
import com.amarsoft.app.accounting.util.ACCOUNT_CONSTANTS;
import com.amarsoft.are.jbo.impl.StateBizObject;
import com.amarsoft.are.lang.DataElement;
import com.amarsoft.are.util.ASValuePool;

public class LOAN_BDTrigger implements IBusinessObjectTrigger {

	public void trigger(AbstractBusinessObjectManager boManager,BusinessObject bo,String objectType) throws Exception {
		//��ȡ�������Ƿ���ڱ��
		StateBizObject sbo = (StateBizObject)bo.getBo();
		DataElement[] changedAttributes = sbo.getChangedAttributes();
		if(changedAttributes==null || changedAttributes.length == 0) return;
		//��ȡ����BD
		BusinessObject bd = null;
		List<BusinessObject> bdList = bo.getRelativeObjects(objectType);
		if(bdList == null || bdList.isEmpty()) //����BD���󲻴��ڣ�������ݿ��м���
		{
			ASValuePool as = new ASValuePool();
			as.setAttribute("PutOutNo", bo.getString("PutOutNo"));
			bdList = boManager.loadBusinessObjects(objectType, " RELATIVESERIALNO1=:PutOutNo", as);
			if(bdList == null || bdList.isEmpty()) return;
			else bd = bdList.get(0);
			bo.setRelativeObject(bd);
		}
		else//������ֱ�ӻ�ȡ
		{
			bd = bdList.get(0);
		}
		if(bd == null) return;
		
		double normalBalance=0.0;
		double overdueBalance=0.0;
		double odInteBalance = 0.0;
		double accrueInteBalance = 0.0;
		double compdInteBalance = 0.0;
		double fineInteBalance = 0.0;
		StateBizObject sbd = (StateBizObject)bd.getBo();
		if(sbo.getState() == StateBizObject.STATE_NEW)//��������������ģ���ֱ�ӻ�ȡ���
		{
			normalBalance = bo.getDouble("NormalBalance");
			overdueBalance = bo.getDouble("OverDueBalance");
		}
		else//��������ȡ������
		{
			normalBalance = bo.getDouble("NormalBalance")-Double.valueOf(sbo.getOriginalValue("NormalBalance").toString());
			overdueBalance = bo.getDouble("OverDueBalance")-Double.valueOf(sbo.getOriginalValue("OverDueBalance").toString());
			odInteBalance = bo.getDouble("OdInteBalance")-Double.valueOf(sbo.getOriginalValue("OdInteBalance").toString());
			accrueInteBalance = bo.getDouble("AccrueInteBalance")-Double.valueOf(sbo.getOriginalValue("AccrueInteBalance").toString());
			fineInteBalance = bo.getDouble("FineInteBalance")-Double.valueOf(sbo.getOriginalValue("FineInteBalance").toString());
			compdInteBalance = bo.getDouble("CompdInteBalance")-Double.valueOf(sbo.getOriginalValue("CompdInteBalance").toString());
		}
		double balance = normalBalance+overdueBalance;
		
		double bdBalance = (sbd.getOriginalValue("Balance") == null || "".equals(sbd.getOriginalValue("Balance"))) ? 0.0:Double.valueOf(sbd.getOriginalValue("Balance").toString());
		bd.setAttributeValue("Balance", bdBalance+balance);
		double bdNormalBalance = (sbd.getOriginalValue("NormalBalance") == null || "".equals(sbd.getOriginalValue("NormalBalance"))) ? 0.0:Double.valueOf(sbd.getOriginalValue("NormalBalance").toString());
		bd.setAttributeValue("NormalBalance", bdNormalBalance+normalBalance);
		double bdOverdueBalance = (sbd.getOriginalValue("OverDueBalance") == null || "".equals(sbd.getOriginalValue("OverDueBalance"))) ? 0.0:Double.valueOf(sbd.getOriginalValue("OverDueBalance").toString());
		bd.setAttributeValue("OverDueBalance", bdOverdueBalance+overdueBalance);//new added on 20131015
		if(bd.getDouble("Balance") <= 0.0d)
		{
			bd.setAttributeValue("Maturity",bo.getString("MaturityDate"));
			bd.setAttributeValue("ActualMaturity", bo.getString("MaturityDate"));
			bd.setAttributeValue("FINISHDATE", bo.getString("FinishDate"));
		}
		bd.setAttributeValue("ACTUALTERMMONTH", DateFunctions.getMonths(bo.getString("PutOutDate"), bo.getString("MaturityDate")));
		bd.setAttributeValue("ACTUALTERMDAY", DateFunctions.getDays(DateFunctions.getRelativeDate(bo.getString("PutOutDate"), DateFunctions.TERM_UNIT_MONTH, DateFunctions.getMonths(bo.getString("PutOutDate"), bo.getString("MaturityDate"))), bo.getString("MaturityDate")));
		
		//������Ϣ
		List<BusinessObject> rateList = InterestFunctions.getActiveRateSegment(bo, ACCOUNT_CONSTANTS.RateType_Normal);
		if(rateList == null || rateList.isEmpty())
		{
			ASValuePool asRate = new ASValuePool();
			asRate.setAttribute("ObjectType",bo.getObjectType());
			asRate.setAttribute("ObjectNo",bo.getObjectNo());
			asRate.setAttribute("Status", "1");
			rateList = boManager.loadBusinessObjects(BUSINESSOBJECT_CONSTATNTS.loan_rate_segment," ObjectType=:ObjectType and ObjectNo=:ObjectNo and Status=:Status",asRate);
			bo.setRelativeObjects(rateList);
			rateList = InterestFunctions.getActiveRateSegment(bo, ACCOUNT_CONSTANTS.RateType_Normal);
		}
		if(rateList != null && !rateList.isEmpty()){
			BusinessObject rate = rateList.get(0);
			bd.setAttributeValue("BusinessRate",rate.getDouble("BusinessRate"));
			bd.setAttributeValue("ActualBusinessRate",rate.getDouble("BusinessRate"));
		}
		
		//��Ϣ
		double fineBalance1 = (sbd.getOriginalValue("FineBalance1") == null || "".equals(sbd.getOriginalValue("FineBalance1"))) ? 0.0:Double.valueOf(sbd.getOriginalValue("FineBalance1").toString());
		bd.setAttributeValue("FineBalance1",fineBalance1+fineInteBalance);
		
		//����
		double fineBalance2 = (sbd.getOriginalValue("FineBalance2") == null || "".equals(sbd.getOriginalValue("FineBalance2"))) ? 0.0:Double.valueOf(sbd.getOriginalValue("FineBalance2").toString());
		bd.setAttributeValue("FineBalance2",fineBalance2+compdInteBalance);
		
		//���ڡ�����
		double interestBalance1 = (sbd.getOriginalValue("InterestBalance1") == null || "".equals(sbd.getOriginalValue("InterestBalance1"))) ? 0.0:Double.valueOf(sbd.getOriginalValue("InterestBalance1").toString());
		double interestBalance2 = (sbd.getOriginalValue("InterestBalance2") == null || "".equals(sbd.getOriginalValue("InterestBalance2"))) ? 0.0:Double.valueOf(sbd.getOriginalValue("InterestBalance2").toString());
	
		
		//����ͨ�����������޸�  @modify by Lambert
		bd.setAttributeValue("InterestBalance1", interestBalance1);
		bd.setAttributeValue("InterestBalance2", interestBalance2+odInteBalance);
		
		bd.setAttributeValue("OverDueDays",bo.getInt("OverDueDays"));//new add on 20131015
		bd.setAttributeValue("BUSINESSSTATUS", bo.getString("LoanStatus"));
		
		boManager.setBusinessObject(AbstractBusinessObjectManager.operateflag_update, bd);
	}

}
