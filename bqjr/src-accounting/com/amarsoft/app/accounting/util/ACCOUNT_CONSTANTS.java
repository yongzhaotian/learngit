/**
 * 
 */
package com.amarsoft.app.accounting.util;

/**
 * 核算常量类
 */
public class ACCOUNT_CONSTANTS {
	
	public static int Number_Precision_BaseRate = 8;//基准利率小数位数
	public static int Number_Precision_Rate = 7;//利率小数位数
	public static final int Number_Precision_Money = 2;//金额小数位
	
	public static final String RateFloatType_PRECISION = "0";//百分比浮动
	public static final String RateFloatType_POINTS = "1";//基点浮动
	
	public static final String InterestType_Monthly = "1";//按月计息
	public static final String InterestType_Daily = "0";//按日计息
	public static final String Odd_InterestType_Daily = "0";//零头天按日计息
	public static final String Odd_InterestType_Percent = "1";//零头天按比例计息
	
	public static final String Maturity_Date_Flag_LastPayDate = "02";//贷款到期日=最后一个还款日
	public static final String Maturity_Date_Flag_PutoutDate = "01";//贷款到期日=发放日+贷款期限

	public static final String RateMode_Fix="2";//固定利率
	public static final String RateMode_Float="1";//浮动利率
	
	public static final String RateType_Normal="01";//正常利率
	public static final String RateType_Discount="02";//贴现利率
	public static final String RateType_Overdue="03";//罚息利率
	public static final String RateType_SPT="04";//贴息利率
	public static final String RateType_EIR="06";//实际利率
	public static final String RateType_Upper = "07";//上限利率
	public static final String RateType_Lower = "08";//下限利率
	
	public static final String RateUnit_Year="01";//年利率
	public static final String RateUnit_Month="02";//月利率
	public static final String RateUnit_Day="03";//日利率
	
	public static final String Balance_Flag_LastYear="4";
	public static final String Balance_Flag_LastMonth="3";
	public static final String Balance_Flag_LastDay="2";
	public static final String Balance_Flag_CurrentDay="1";
	
	public static final String PS_SEG_TYPE_TERM = "1";//还款期次优先
	public static final String PS_SEG_TYPE_AMTTYPE = "2";//还款金额类型优先
	public static final String PS_SEG_TYPE_FIXAMT = "3";//指定金额还款
	//扣款顺序预定
	public static final String PS_SEQ_FLAG_OVERDUE = "01";//扣款顺序约定-不良贷款扣款顺序
	public static final String PS_SEQ_FLAG_NORMAL = "02";//扣款顺序约定-正常贷款扣款顺序
	public static final String PS_SEQ_FLAG_FIXAMT = "03";//扣款顺序约定-指定还款金额还款
	
	//还款计划-还款类型
	public static final String PS_PAY_TYPE_Normal = "1";//正常还款
	public static final String PS_PAY_TYPE_SPT = "2";//贴息还款
	public static final String PS_PAY_TYPE_Prepay = "3";//提前还款(部分)
	public static final String PS_PAY_TYPE_Prepay_All = "5";//提前还款(全部)
	public static final String PS_PAY_TYPE_DRPT = "4";//约定还款
	public static final String PS_PAY_TYPE_AccrueInterest = "6";//还计提利息
	public static final String PS_PAY_TYPE_Fee = "7";//费用计划
	
	public static final String PS_AMOUNT_BASE_Principal_Interest = "9";//期供剩余本金+期供利息
	
	//客户账套账号
	public static final String LOAN_BalanceGroup_Customer_Normal_Principal = "Customer01";//未到期本金
	public static final String LOAN_BalanceGroup_Customer_Overdue_Principal = "Customer02";//逾期本金
	public static final String LOAN_BalanceGroup_Customer_Normal_Interest = "Customer11";//正常利息
	public static final String LOAN_BalanceGroup_Customer_Overdue_Interest = "Customer12";//逾期期供利息
	public static final String LOAN_BalanceGroup_Customer_Fine_Interest = "Customer13";//逾期罚息
	public static final String LOAN_BalanceGroup_Customer_Compound_Interest = "Customer14";//复利
	public static final String LOAN_BalanceGroup_Customer_PrePay_Principal = "Customer03";//提前还款本金或已结本金未结息部分本金，账务科目上不体现只是系统挂息处理
	public static final String LOAN_BalanceGroup_Customer_Balance = "Customer21";//客户账-暂收款
	
	//提前还款类型 
	public static final String PrepaymentType_All = "10"; //全部提前还款
	public static final String PrepaymentType_Part_FixTerm = "11"; //部分提前还款-期限不变
	public static final String PrepaymentType_Part_FixInstalment = "12"; //部分提前还款-期供不变
	
	public static final String Prepayment_InterestFlag_NextDueDate = "01"; //计算到下次还款日
	public static final String Prepayment_InterestFlag_TransDate = "02"; //计算到提前还款日
	public static final String Prepayment_InterestFlag_NetNextInstalment = "03"; //合并下次期供
	public static final String Prepayment_InterestFlag_NoneInterest = "04"; //不还利息
	
	
	public static final String Prepayment_InterestBaseFlag_PayPrincipal = "01";//提前还款本金
	public static final String Prepayment_InterestBaseFlag_NormalBalance = "02";//贷款余额

	//提前还款金额类型
	public static final String PREPAY_AMOUNT_TYPE_Principal = "1";//本金
	public static final String PREPAY_AMOUNT_TYPE_Principal_Interest = "2";//本金+利息
	
	
	//期供利息计算
	public static final String Instalment_Change_Flag_New = "1";//新期供
	public static final String Instalment_Change_Flag_Old = "2";//原期供
	
	//交易码
	public static final String TRANSCODE_AHEAD_REPAYMENT = "0055";//提前还款
	public static final String TRANSCODE_EOD_DAILY = "9091";//日终交易
	public static final String TRANSCODE_BOD_DAILY = "9092";//日初交易
	public static final String TRANSCODE_RECIEVE_FEE = "3508";//收费
	public static final String TRANSCODE_PAY_FEE = "3520";//付费
	
	//记账标志
	public static final String TRANSSTATUS_NOT_CHARGE_UP = "0";// 未记账
	public static final String TRANSSTATUS_ALREADY_CHARGE_UP = "1";// 已记账
	public static final String TRANSSTATUS_ALREADY_CHARGE_DOWN = "2";// 已冲账
	public static final String TRANSSTATUS_ALREADY_CHARGE_WAIT = "3";// 待记账
	public static final String TRANSSTATUS_ALREADY_CANCEL = "4";// 已取消
	
	//费用摊销方式
	public  static final String AMORTIZE_NO = "01";// 不摊销
	public  static final String AMORTIZE_LINE_MONTH_AMOUNT = "02";//直线按月摊销（以费用金额）
	public  static final String AMORTIZE_LINE_DAY_AMOUNT = "03";//直线按日摊销（以费用金额）
	public  static final String AMORTIZE_LINE_MONTH_RAMOUNT = "04";//直线按月摊销（以收取金额）
	public  static final String AMORTIZE_LINE_DAY_RAMOUNT = "05";//直线按日摊销（以收取金额）
	
	//贷款关联账户
	public static final String AccountIndicator_00 = "00";//放款账户
	public static final String AccountIndicator_01 = "01";//还款账户
	public static final String AccountIndicator_02 = "02";//委托人存款账号（发放和回收本息）
	public static final String AccountIndicator_03 = "03";//委托人委托存款账号
	public static final String AccountIndicator_04 = "04";//第三方收款账户
	
	//费用收付标示
	public static final String FEEFLAG_RECIEVE = "R";//费用收付标示 收
	public static final String FEEFLAG_PAY = "P";//费用收付标示 付
	public static final String FEEFLAG_RP = "B";//费用收付标示 代收代付
	
	//批量扣款标示
	public static final String AUTOPAYFLAG_YES = "1"; //参与批量扣款
	public static final String AUTOPAYFLAG_NO = "2";//不参与批量扣款
	public static final String AUTOPAYFLAG_PayDayAndMaturity = "3";//到期日及扣款日批量扣款
	public static final String AUTOPAYFLAG_Maturity = "4";//只到期日批量扣款
	public static final String AUTOPAYFLAG_PayDay = "5";//只扣款日批量扣款
	
	//计息模式
	public static final String COMPOUNDINTERESTFLAG_COMP = "1";//计息模式-复利
	public static final String COMPOUNDINTERESTFLAG_SINGLE = "2";//计息模式-单利
	
	//存款账户类型
	public static final String DEPOSIT_CARD = "01";//卡
	public static final String DEPOSIT_BOOK = "02";//存折
	
	//存款账户标示
	public static final String ACCOUNT_FLAG_DEPOSIT_SELF = "1";//本行存款账户
	public static final String ACCOUNT_FLAG_DEPOSIT_OTHER = "2";//他行账户
	public static final String ACCOUNT_FLAG_CREDIT_CARD = "3";//本行信用卡账户
	public static final String ACCOUNT_FLAG_INNER = "8";//本行内部账户
	
	//扣款方式
	public static final String DEDUCTTYPE_ENOUGH = "1";//足额扣款方式
	public static final String DEDUCTTYPE_DEFICIT = "2";//不足额扣款方式
	
	//批量交易方式
	public static final String BATCHTRANSTYPE_PAYMENT = "01";//批量一般还款
	public static final String BATCHTRANSTYPE_PREPAYMENT = "02";//批量提前还款
	public static final String BATCHTRANSTYPE_PAYMENTFEE = "03";//批量费用收取
	
	//还款类型
	public static final String PAYTYPE_NOMAL = "1";//一般还款
	
	//还款7顺延标志
	public static final String POSTPONE_PAYMENT_FLAG_Max="1";//宽限期和节假日顺延日取大
	public static final String POSTPONE_PAYMENT_FLAG_Min="2";//宽限期和节假日顺延日取小
	public static final String POSTPONE_PAYMENT_FLAG_GRACE_HOLIDAY="3";//宽限期后遇节假日继续顺延
	public static final String POSTPONE_PAYMENT_FLAG_HOLIDAY_GRACE="4";//节假日顺延后继续享受宽限期
	public static final String POSTPONE_PAYMENT_FLAG_ANY="5";//任意叠加
	//宽限期计算利息标识
	public static final String POSTPONE_INTEREST_FLAG_NONE="1";//不计算利息
	public static final String POSTPONE_INTEREST_FLAG_LOANRATE="2";//按照罚息利率计算利息
	public static final String POSTPONE_INTEREST_FLAG_FINERATE="3";//按照罚息利率计算利息
	
	//利息金额记录方式
	public static final String INTEREST_LOG_AMT_FLAG_Balance="1";//余额记录
	public static final String INTEREST_LOG_AMT_FLAG_Total="2";//累计金额记录
	public static final String INTEREST_LOG_AMT_FLAG_Amt="3";//当期金额记录
	
	//InterestType
	public static final String INTEREST_TYPE_NormalInterest="0";
	public static final String INTEREST_TYPE_FineInterest="1";
	public static final String INTEREST_TYPE_CompdInterest="2";
	public static final String INTEREST_TYPE_GraceInterest="4";
	
	public static final String IMPAIRMENTFLAG_Impairment = "1";//减值贷款
	public static final String IMPAIRMENTFLAG_Normal = "2";//非减值贷款
	
	//红蓝字标识
	public final static String TRANS_FLAG_RED = "R";
	public final static String TRANS_FLAG_BLUE = "B";
	
	//贷款逾期起点标识
	public final static String LOANOVERDATEFLAG_PAYDATE = "010"; //超过应还日期开始计算逾期
	public final static String LOANOVERDATEFLAG_INTEDATE = "020";//超过节假日和宽限期顺延之后日期开始计算逾期
	
	//放款状态	
	public final static String PUTOUTSTATUS_UNTRADED = "0";//待放款	
	public final static String PUTOUTSTATUS_TRADED = "1";//已放款	
	public final static String PUTOUTSTATUS_FLUSHED = "2";//已冲销
		
	//贷款状态
	public final static String LOANSTATUS_NORMAL = "0";//正常
	public final static String LOANSTATUS_OVERDUE = "1";//逾期
	public final static String LOANSTATUS_NORMAL_FINISHED = "2";//正常结清	
	public final static String LOANSTATUS_ADVANCE_FINISHED = "3";//提前结清	
	public final static String LOANSTATUS_OVERDUE_FINISHED = "4";//逾期结清	
	public final static String LOANSTATUS_SELLOUT="5";//卖出或核销	
	public final static String LOANSTATUS_FLUSHED = "6";//已冲销	
	public final static String LOANSTATUS_SELLOUT_FINISH = "7";//卖断结清
	
	//有效状态位,与Code:FeeStatus对应	
	public final static String STATUS_NOT_EFFECTIVE = "0";	//未生效
	public final static String STATUS_EFFECTIVE = "1";//生效
	public final static String STATUS_UNEFFECTIVE = "2";//失效
	public final static String STATUS_LOCKED = "3";//锁定
	
	//是否标识
	public final static String FLAG_YES = "1";//是
	public final static String FLAG_NO = "2";//否
	
	//表内表外标识
	public final static String ON_BALANCESHEET = "1"; //表内标识
	public final static String OFF_BALANCESHEET = "2";//表外标识
	
	//贷款状态
	public final static String LOCK_EOD = "1";   //日终锁定
	public final static String LOCK_UNLOCKED = "2";//未锁定
	public final static String LOCK_BOD = "3";   //日初锁定
	
	//币种
	public final static String CURRENCY_CNY = "01";//人民币
	public final static String CURRENCY_GBP = "02";//英镑
	public final static String CURRENCY_HKD = "03";//港币
	
	//工作日期标识
	public final static String DAY_WORKDAY = "1";//工作日
	public final static String DAY_HOLIDAY = "2";//节假日
	public final static String DAY_OFFICIAL_HOLIDAY = "3";//法定假
	
	//减值类型
	public final static String WAIVE_AMT = "0";//金额
	public final static String WAIVE_PER = "1";//比例
	
	//余额内转类型
	public final static String CHANGEPRINCIPAL_OVER = "010";//正常转逾期
	public final static String CHANGEPRINCIPAL_NORMAL = "020";//逾期转正常
	
	//发生类型
	public final static String OccurType_010 = "010";//新发生
	public final static String OccurType_015 = "015";//展期
	public final static String OccurType_020 = "020";//借新还旧
	public final static String OccurType_030 = "030";//资产重组
	public final static String OccurType_040 = "040";//买入
	public final static String OccurType_050 = "050";//回购
	public final static String OccurType_060 = "060";//还旧借新
	public final static String OccurType_070 = "070";//垫款
	
	//基准利率调整类型
	public final static String RepriceType_NextDay = "1";//立即(随基准利率次日调整)
	public final static String RepriceType_BeginningOfYear = "2";//固定日(年初调整)
	public final static String RepriceType_NextYear = "3";//按年调(放款日次年对月对日)
	public final static String RepriceType_NextMonth = "4";//按月调((放款日次月对日))
	public final static String RepriceType_NextDueDate = "5";//下一还款日
	public final static String RepriceType_FirstDueDateOfYear = "6";//次年首个还款日
	public final static String RepriceType_Never = "7";//不调整
	public final static String RepriceType_Defined = "8";//手工指定调整日
}