package com.amarsoft.app.als.credit.cl.model;

import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.JBOException;


/**
 * 额度下占用对象
 * @author jschen
 *
 */
public abstract class LmtAccountInfo {
	
	/**
	 * 定义常用占用对象类型
	 * 申请、批复、合同、出账
	 */
	public static final String LMTACCOUNTTYPE_BA = "CreditApply"; 
	public static final String LMTACCOUNTTYPE_BAP = "ApproveApply";
	public static final String LMTACCOUNTTYPE_BC = "BusinessContract";
	public static final String LMTACCOUNTTYPE_BP = "PutOutApply";
	public static final String LMTACCOUNTTYPE_BD = "BusinessDuebill";
	
	/**
	 * 获取占用名义金额
	 * @return
	 */
	public abstract double getUseBusinessSum(); 
	
	/**
	 * 获取占用敞口金额
	 * @return
	 */
	public abstract double getUseExposureSum();
	
	/**
	 * 获取占用对象编号
	 * @return
	 */
	public abstract String getAccountNo();
	
	/**
	 * 获取占用对象类型
	 * @return
	 */
	public abstract String getAccountType();
	
	/**
	 * 获取循环标志
	 * @return
	 * @throws JBOException
	 */
	public abstract boolean getCycleflag();
	
	/**
	 * 获取占用对象实体
	 * @return
	 */
	public abstract BizObject getCreditObject();
	
}
