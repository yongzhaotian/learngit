package com.amarsoft.app.als.credit.cl.model;

import com.amarsoft.app.als.dict.ALSConst;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.util.Arith;

public class BusinessApproveAccount extends LmtAccountInfo {
	
	private String accountType = LmtAccountInfo.LMTACCOUNTTYPE_BA;
	private String accountNo = "";
	public BizObject approveObject = null; //占用对象-申请
	private GuarantyManager guarantyManager = null; //占用对象的担保信息管理类
	
	public BusinessApproveAccount(String serialNo) throws JBOException{
		this.approveObject=JBOFactory.getBizObject("jbo.app.BUSINESS_APPROVE", serialNo);
	}
	
	public BusinessApproveAccount(BizObject biz) throws JBOException{
		this.approveObject = biz;
	}
	
	@Override
	public String getAccountNo() {
		
		try {
			accountNo = approveObject.getAttribute("SerialNo").getString();
		} catch (JBOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return accountNo;
	}

	@Override
	public String getAccountType() {
		return this.accountType;
	}

	@Override
	public double getUseBusinessSum() {
		double useBusinessSum = 0.0;
		try {
			useBusinessSum = approveObject.getAttribute("BusinessSum").getDouble();
		} catch (JBOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return useBusinessSum;
	}

	@Override
	public double getUseExposureSum() {
		double useExposureSum = 0.0;
		try {
			if(guarantyManager == null) guarantyManager = new GuarantyManager(this);
			useExposureSum = Arith.sub(approveObject.getAttribute("BusinessSum").getDouble(), guarantyManager.getBailSum()); //扣除保证金
			useExposureSum = Arith.sub(useExposureSum, guarantyManager.getGCExposureSum()); //扣除最高额担保合同的准现金分配金额
			useExposureSum = Math.max(useExposureSum, 0.0);
			useExposureSum = approveObject.getAttribute("ExposureSum").getDouble();
		} catch (JBOException e) {
			e.printStackTrace();
		}
		return useExposureSum;
	}

	@Override
	public boolean getCycleflag() {
		boolean cycleFlag = false;
		try {
			if(approveObject.getAttribute("CycleFlag").getString()==null) cycleFlag = false;
			else cycleFlag = approveObject.getAttribute("CycleFlag").getString().equals(ALSConst.CYCLEFLAG_CYCLE);
		} catch (JBOException e) {
			e.printStackTrace();
		}
		return cycleFlag;
	}

	@Override
	public BizObject getCreditObject() {
		return this.approveObject;
	}

}
