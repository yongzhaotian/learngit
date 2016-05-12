package com.amarsoft.app.bizobject;

/**
 * 
 * @author qfang
 * 
 */
public class BusinessApply {
	
	/**
	 * 新增申请时，Flag5默认为010
	 * 登记最终意见或者登记合同时，Flag5设置为020
	 */
	public final static String PHASEFLAG_NEWAPPLY = "010";
	public final static String PHASEFLAG_NEWAPPROVEORCONTRACT = "020";
	
	
	/**
	 *业务申请信息暂存标志：
	 *	1 是 
	 * 	2 否
	 */
	public final static String TEMPSAVE_YES = "1";
	public final static String TEMPSAVE_NO = "2";
	
	/**
	 *业务品种分类标志位： 
	 * 1是
	 * 2否
	 */
	public final static String FLAGS_YES = "1";
	public final static String FLAGS_NO = "2";
}
