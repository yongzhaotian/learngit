package com.amarsoft.app.accounting.util;
/**
 * 核算基础组件常量类
 */
public class PRODUCT_CONSTANTS {
	//还款方式类型
	public static final String Payment_Type_PayAllAmt = "01"; //还本还息
	public static final String Payment_Type_PayPrincipalAmt = "02";//还本不还息
	public static final String Payment_Type_PayInteAmt = "03";//不还本只还息
	
	//还款频率PaymentFrequencyType
	public final static String PAYMENTFREQUENCY_MONTHLY = "1";  //月
	public final static String PAYMENTFREQUENCY_QUARTERLY = "2";//季
	public final static String PAYMENTFREQUENCY_ONCE = "3";     //一次
	public final static String PAYMENTFREQUENCY_SEMIANNUALLY = "4";//半年
	public final static String PAYMENTFREQUENCY_ANNUALLY = "5"; //年
	public final static String PAYMENTFREQUENCY_BIWEEKLY = "7"; //双周
	public final static String PAYMENTFREQUENCY_BIMONTHLY = "8";//双月
	
	//区段期限标识SEGTermFlag
	public final static String SEGTERM_LOAN = "1";     //贷款期限
	public final static String SEGTERM_SEGMENT = "2";  //区段期限
	public final static String SEGTERM_SPECIFIED = "3";//指定期限
	
	//首期还款标识FirstInstalmentFlag
	public final static String FIRSTINSTALMENT_CurrentMonth_Yes = "01";//放款当月还款
	public final static String FIRSTINSTALMENT_CurrentMonth_No = "02";//放款当月不还款
	public final static String FIRSTINSTALMENT_CurrentMonth_Yes_Fixed = "03";//放款当月还款（标准周期）
	public final static String FIRSTINSTALMENT_NextMonth_No_Fixed = "04";//放款当月不还款（标准周期）
	
	//末期还款标识FinalInstalmentFlag
	public final static String FINALINSTALMENTFLAG_01 = "01";//不足整期合并至最终日期
	public final static String FINALINSTALMENTFLAG_02 = "02";//不足整期算作一期
	public final static String FINALINSTALMENTFLAG_03 = "03";//自动顺延直至贷款偿清
	
	//组件类型
	public final static String TERMSETFLAG_BASIC = "BAS";//基础组件
	public final static String TERMSETFLAG_SET = "SET";//组合组件
	public final static String TERMSETFLAG_SEGMENT = "SEG";//子组件
	
	//区段金额标识
	public final static String SEGRPTAMOUNT_LOAN_BALANCE = "1"; //贷款余额
	public final static String SEGRPTAMOUNT_SEG_AMT = "2";      //指定金额
	public final static String SEGRPTAMOUNT_SEG_INSTALMENTAMT = "3";//指定每期还款额
	public final static String SEGRPTAMOUNT_FINAL_PAYMENT = "4";//尾款金额
	
	//新期供类型
	public final static String NEWPMTTYPE_OLDPRINCIPAL = "0";   //旧本+当期利息
	public final static String NEWPMTTYPE_NEWPRINCIPAL = "1";   //新本+当期利息
	public final static String NEWPMTTYPE_NEWINSTALMENTAMT = "2";//新期供
	public final static String NEWPMTTYPE_OLDINSTALMENTAMT = "3";//原期供
	
	//到期日计算标识
	public final static String MATURITYCALFLAG_MATURITY = "01";//以录入到期日为准
	public final static String MATURITYCALFLAG_TERM = "02";//以发放日加期限为准
	
	//会计科目余额方向
	public final static String BALANCE_DIRECTION_DEBIT = "D";//借
	public final static String BALANCE_DIRECTION_CREDIT = "C";//贷
	public final static String BALANCE_DIRECTION_RECIEVE = "R";//收
	public final static String BALANCE_DIRECTION_PAY = "P";//付
	public final static String BALANCE_DIRECTION_BOTH = "B";//双向
	
	//表外业务余额方向
	public final static String OFFBSFLAG_DEBIT = "1";//借方
	public final static String OFFBSFLAG_CREDIT = "2";//贷方
	
	//科目代码
	public final static String ACCOUNTCODENO_ACCRUE_INTE = "LAS10301";//贷款-正常应收利息
	public final static String ACCOUNTCODENO_OVER_INTE = "LAS10302";//贷款-应收未收利息
	public final static String ACCOUNTCODENO_INTE_AMT = "LAS50101";//贷款利息收入
	public final static String ACCOUNTCODENO_INTE_ADVANCED = "LAS50102";//贷款预收利息
	//费用收付时点
	public final static String FEEPAY_RELATRANS_ONCE = "01";//随关联交易一次性收取
	public final static String FEEPAY_BEFORE_RELATRANS_ONCE = "02";//关联交易前手工一次性收取
	public final static String FEEPAY_ONCE = "03";//手工一次性收取
	public final static String FEEPAY_PERIOD = "04";//按指定周期收取
	public final static String FEEPAY_SCHEDULE = "05";//按还款计划收取
	public final static String FEEPAY_FIRSTPAYDATE = "06";//首次还款日收取
	
	//入账机构标示
	public final static String FEEACCOUNTINGORG_ACCOUNTING = "01";//贷款入账机构
	public final static String FEEACCOUNTINGORG_OPERATOR = "02";//贷款经办机构
	
	//贴息类型
	public final static String SPT_TYPE_WAIVE = "10";//直接减免
	public final static String SPT_TYPE_REFUND = "20";//先扣后返
	
	//基准利率类型
	public final static String BASERATE_PBOC = "010";//人行基准利率
	public final static String BASERATE_PHF = "020";//公积金基准利率
	public final static String BASERATE_DISCOUNT = "030";//贴现利率
	public final static String BASERATE_LIBOR = "040";//伦敦银行同业拆放利率
	public final static String BASERATE_HIBOR = "050";//香港银行同业拆放利率
	public final static String BASERATE_FIXED = "060";//固定利率
	public final static String BASERATE_SIBOR = "070";//新加坡银行同业拆放利率
	public final static String BASERATE_NORMAL = "100";//贷款执行利率
}
