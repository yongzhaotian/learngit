/**
 * 常量管理类
 * @author jschen
 */
package com.amarsoft.app.als.credit.common.model;

public class CreditConst {
	
	/**
	 * 额度数据精度：暂定到小数点后2位
	 */
	public static final double LINE_PRECISION = 0.01;
	
	/**
	 * 授信业务对象类型
	 */
	/**授信申请**/
	public static final String CREDITOBJECT_APPLY_REAL = "CreditApply"; 
	/**授信批复**/
	public static final String CREDITOBJECT_APPROVE_REAL = "ApproveApply"; 
	/**授信合同**/
	public static final String CREDITOBJECT_CONTRACT_REAL = "BusinessContract"; 
	
	public static final String CREDITOBJECT_CONTRACT_QUERY = "QueryBusinessContract";
	
	/**贷后合同--授信合同按贷款阶段分类的一种**/
	public static final String CREDITOBJECT_AFTERLOANCONTRACT_VIRTUAL = "AfterLoan"; 
	/**补登的授信合同--授信合同按生成方式分类的一种**/
	public static final String CREDITOBJECT_REINFORCECONTRACT_VIRTUAL = "ReinforceContract"; 
	
	/**
	 * 申请类型分类
	 */
	/**授信额度申请，如果需要细分该类型，需要增加后缀方式CreditLineApplyXxxx，比如小企业综合授信申请---CreditLineApplySmall,其他申请方式同理**/
	public static final String APPLYTYPE_CREDITLINE = "CreditLineApply"; 
	/**额度项下申请**/
	public static final String APPLYTYPE_DEPENDENT = "DependentApply"; 
	/**单笔单批申请**/
	public static final String APPLYTYPE_INDEPENDENT = "IndependentApply";
	
	/**
	 * 申请表jbo名
	 */
	public static final String BA_JBOCLASS = "jbo.app.BUSINESS_APPLY"; 
	/**
	 * 批复表jbo名
	 */
	public static final String BAP_JBOCLASS = "jbo.app.BUSINESS_APPROVE"; 
	/**
	 * 合同表jbo名
	 */
	public static final String BC_JBOCLASS = "jbo.app.BUSINESS_CONTRACT"; 
	/**
	 * 出帐表jbo名
	 */
	public static final String BP_JBOCLASS = "jbo.app.BUSINESS_PUTOUT"; 
	/**
	 * 借据表jbo名
	 */
	public static final String BD_JBOCLASS = "jbo.app.BUSINESS_DUEBILL"; 
	
	
	
	
	/**
	 * 保存标志 ：
	 * 1	暂存
	 * 2	保存
	 */
	public static final String SAVE_FLAG_TEMP = "1";
	public static final String SAVE_FLAG_SAVE = "2";
	
	/**
	 * BUSINESS_APPLY Flag5：
	 * 010 	未登记批复
	 * 020 	已登记批复
	 */
	public static final String BA_FLAG5_UNAPPROVE = "010";
	public static final String BA_FLAG5_APPROVED = "020";
	
	/**
	 * BUSINESS_APPROVE Flag5：
	 * 010 	未登记合同
	 * 020 	已登记合同
	 */
	public static final String BAP_FLAG5_UNREGISTER = "010";
	public static final String BAP_FLAG5_REGISTERED = "020";
	
	/**
	 * BUSINESS_APPROVE ApproveType:
	 * 01	同意
	 * 02	否决
	 */
	public static final String APPROVETYPE_AGREE = "01";
	public static final String APPROVETYPE_DISAGREE = "02";
	
	/**
	 * BUSINESS_CONTRACT ReinforceFlag<br>
	 * 000 非补登<br>
	 * 010 未补登完成的信贷业务<br>
	 * 020 补登完成信贷业务<br>
	 * 110 未补登完成的授信额度<br>
	 * 120 已补登完成的授信额度<br>
	 * 
	 */
	/**非补登**/
	public static final String REINFORCEFLAG_NORMAL = "000";
	/**未补登完成的信贷业务**/
	public static final String REINFORCEFLAG_UNDOCONTRACT = "010";
	/**补登完成信贷业务**/
	public static final String REINFORCEFLAG_DONECONTRACT = "020";
	/**未补登完成的授信额度**/
	public static final String REINFORCEFLAG_UNDODEAL = "110";
	/**已补登完成的授信额度**/
	public static final String REINFORCEFLAG_DONEDEAL = "120";
	
	/**
	 * 授信业务对象附属信息
	 */
	/**额度附属切分信息**/
	public static final String APPENDTYPE_DIVIDELINE = "DivideLine"; 
	
	
	
}
