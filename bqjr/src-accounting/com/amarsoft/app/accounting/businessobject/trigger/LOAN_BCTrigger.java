/**
 * Class <code>LOAN_BCTrigger</code> 是贷款对象jbo.app.ACCT_LOAN发生变更时，触发其关联对象jbo.app.BUSINESS_CONTRACT数据进行变更
 * 具体数据更新参见<code>AbstractBusinessObjectManager.updateDB</code>方法
 *
 * @author  ygwang xjzhao
 * @version 1.0, 13/09/23
 * @see com.amarsoft.app.accounting.businessobject.AbstractBusinessObjectManager
 * @see com.amarsoft.app.accounting.businessobject.BusinessObject
 * @since  JDK1.6
 */

package com.amarsoft.app.accounting.businessobject.trigger;

import java.util.List;

import com.amarsoft.app.accounting.businessobject.BusinessObject;
import com.amarsoft.app.accounting.businessobject.AbstractBusinessObjectManager;
import com.amarsoft.app.accounting.config.SystemConfig;
import com.amarsoft.app.accounting.config.loader.DateFunctions;
import com.amarsoft.are.jbo.impl.StateBizObject;
import com.amarsoft.are.lang.DataElement;
import com.amarsoft.awe.util.SqlObject;

public class LOAN_BCTrigger implements IBusinessObjectTrigger {

	public void trigger(AbstractBusinessObjectManager boManager,BusinessObject bo,String objectType) throws Exception {
		//获取主对象是否存在变更
		StateBizObject sbo = (StateBizObject)bo.getBo();
		DataElement[] changedAttributes = sbo.getChangedAttributes();
		if(changedAttributes==null || changedAttributes.length == 0) return;
		//获取对象BC
		BusinessObject bc = null;
		List<BusinessObject> bcList = bo.getRelativeObjects(objectType);
		if(bcList == null || bcList.isEmpty()) //关联BC对象不存在，则从数据库中加载
		{
			if(bo.getString("ContractSerialNo") == null || "".equals(bo.getString("ContractSerialNo"))) return; 
			bc = boManager.loadObjectWithKey(objectType, bo.getString("ContractSerialNo"));
			bo.setRelativeObject(bc);
		}
		else//存在则直接获取
		{
			bc = bcList.get(0);
		}
		if(bc == null) return;
		
		double normalBalance=0.0;
		double overdueBalance=0.0;
		double OdInteBalance = 0.0;//逾期利息  @add by Lambert
		double FineInteBalance = 0.0;//罚息  @add by Lambert
		double CompdInteBalance = 0.0;//复息  @add by Lambert
		
		StateBizObject sbc = (StateBizObject)bc.getBo();
		if(sbo.getState() == StateBizObject.STATE_NEW)//对象如果是新增的，则直接获取余额
		{
			normalBalance = bo.getDouble("NormalBalance");
			overdueBalance = bo.getDouble("OverDueBalance");
		}
		else//非新增获取差额余额
		{
			normalBalance = bo.getDouble("NormalBalance")-Double.valueOf(sbo.getOriginalValue("NormalBalance").toString());
			overdueBalance = bo.getDouble("OverDueBalance")-Double.valueOf(sbo.getOriginalValue("OverDueBalance").toString());
			//  @add by Lambert
			OdInteBalance = bo.getDouble("OdInteBalance")-Double.valueOf(sbo.getOriginalValue("OdInteBalance").toString());			
			CompdInteBalance = bo.getDouble("CompdInteBalance")-Double.valueOf(sbo.getOriginalValue("CompdInteBalance").toString());
			FineInteBalance = bo.getDouble("FineInteBalance")-Double.valueOf(sbo.getOriginalValue("FineInteBalance").toString());
		}
		double balance = normalBalance+overdueBalance;
		Object obcBalance = sbc.getOriginalValue("Balance");
		Object obcNormalBalance = sbc.getOriginalValue("NormalBalance");
		Object obcOverdueBalance = sbc.getOriginalValue("OverDueBalance");
		Object obcInterestBalance1 = sbc.getOriginalValue("interestbalance1");
		Object obcInterestBalance2 = sbc.getOriginalValue("interestbalance2");
		if(obcBalance == null) obcBalance = "0.0";
		if(obcNormalBalance == null) obcNormalBalance = "0.0";
		if(obcOverdueBalance == null) obcOverdueBalance = "0.0";
		//  @add by Lambert
		if(obcInterestBalance1 == null) obcInterestBalance1 = "0.0";
		if(obcInterestBalance2 == null) obcInterestBalance2 = "0.0";
		
		bc.setAttributeValue("Balance", Double.valueOf(obcBalance.toString())+balance);
		bc.setAttributeValue("NormalBalance", Double.valueOf(obcNormalBalance.toString())+normalBalance);
		bc.setAttributeValue("OverDueBalance", Double.valueOf(obcOverdueBalance.toString())+overdueBalance);
		//更新BC表内外欠息  @add by Lambert
		bc.setAttributeValue("interestbalance1", Double.valueOf(obcInterestBalance1.toString())+OdInteBalance);
		bc.setAttributeValue("interestbalance2", Double.valueOf(obcInterestBalance2.toString())+CompdInteBalance+FineInteBalance);
		
		String bcCycleflag = bc.getString("cycleflag");//合同循环标志
		double totalBalance = bc.getDouble("balance")+bc.getDouble("obcInterestBalance1")+bc.getDouble("obcInterestBalance2");
		if("1".equals(bcCycleflag)){//循环
			//到期且余额为零
			if(!DateFunctions.getDate(bc.getString("MATURITY")).after(DateFunctions.getDate(SystemConfig.getBusinessDate())) 
					&& totalBalance <= 0.0 && !"6".equals(bo.getString("LoanStatus")) && !"5".equals(bo.getString("LoanStatus")) && !"0".equals(bo.getString("LoanStatus")) && !"1".equals(bo.getString("LoanStatus"))){
				bc.setAttributeValue("FinishDate", SystemConfig.getBusinessDate());
			}
		}else{//非循环
			double dTotalPutoutSum = bc.getMoney("ActualPutoutSum");
			
			if(totalBalance <= 0.0 && !"6".equals(bo.getString("LoanStatus")) && !"5".equals(bo.getString("LoanStatus")) && !"0".equals(bo.getString("LoanStatus")) && !"1".equals(bo.getString("LoanStatus"))){
				if(!DateFunctions.getDate(bc.getString("MATURITY")).after(DateFunctions.getDate(SystemConfig.getBusinessDate()))){//余额为零且到期
					bc.setAttributeValue("FinishDate", SystemConfig.getBusinessDate());
				}else if(bc.getDouble("BusinessSum") - dTotalPutoutSum <= 0.0){//余额为零且全部出账
					bc.setAttributeValue("FinishDate", SystemConfig.getBusinessDate());
				}
			}
		}
		bc.setAttributeValue("UpdateDate", SystemConfig.getBusinessDate());//new added on 20131015
		bc.setAttributeValue("OverdueDays", bo.getString("OverdueDays"));
		boManager.setBusinessObject(AbstractBusinessObjectManager.operateflag_update, bc);
	}

}
