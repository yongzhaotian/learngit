/**
 * 
 */
package com.amarsoft.app.accounting.util;

/**
 * ���㳣����
 */
public class ACCOUNT_CONSTANTS {
	
	public static int Number_Precision_BaseRate = 8;//��׼����С��λ��
	public static int Number_Precision_Rate = 7;//����С��λ��
	public static final int Number_Precision_Money = 2;//���С��λ
	
	public static final String RateFloatType_PRECISION = "0";//�ٷֱȸ���
	public static final String RateFloatType_POINTS = "1";//���㸡��
	
	public static final String InterestType_Monthly = "1";//���¼�Ϣ
	public static final String InterestType_Daily = "0";//���ռ�Ϣ
	public static final String Odd_InterestType_Daily = "0";//��ͷ�찴�ռ�Ϣ
	public static final String Odd_InterestType_Percent = "1";//��ͷ�찴������Ϣ
	
	public static final String Maturity_Date_Flag_LastPayDate = "02";//�������=���һ��������
	public static final String Maturity_Date_Flag_PutoutDate = "01";//�������=������+��������

	public static final String RateMode_Fix="2";//�̶�����
	public static final String RateMode_Float="1";//��������
	
	public static final String RateType_Normal="01";//��������
	public static final String RateType_Discount="02";//��������
	public static final String RateType_Overdue="03";//��Ϣ����
	public static final String RateType_SPT="04";//��Ϣ����
	public static final String RateType_EIR="06";//ʵ������
	public static final String RateType_Upper = "07";//��������
	public static final String RateType_Lower = "08";//��������
	
	public static final String RateUnit_Year="01";//������
	public static final String RateUnit_Month="02";//������
	public static final String RateUnit_Day="03";//������
	
	public static final String Balance_Flag_LastYear="4";
	public static final String Balance_Flag_LastMonth="3";
	public static final String Balance_Flag_LastDay="2";
	public static final String Balance_Flag_CurrentDay="1";
	
	public static final String PS_SEG_TYPE_TERM = "1";//�����ڴ�����
	public static final String PS_SEG_TYPE_AMTTYPE = "2";//��������������
	public static final String PS_SEG_TYPE_FIXAMT = "3";//ָ������
	//�ۿ�˳��Ԥ��
	public static final String PS_SEQ_FLAG_OVERDUE = "01";//�ۿ�˳��Լ��-��������ۿ�˳��
	public static final String PS_SEQ_FLAG_NORMAL = "02";//�ۿ�˳��Լ��-��������ۿ�˳��
	public static final String PS_SEQ_FLAG_FIXAMT = "03";//�ۿ�˳��Լ��-ָ���������
	
	//����ƻ�-��������
	public static final String PS_PAY_TYPE_Normal = "1";//��������
	public static final String PS_PAY_TYPE_SPT = "2";//��Ϣ����
	public static final String PS_PAY_TYPE_Prepay = "3";//��ǰ����(����)
	public static final String PS_PAY_TYPE_Prepay_All = "5";//��ǰ����(ȫ��)
	public static final String PS_PAY_TYPE_DRPT = "4";//Լ������
	public static final String PS_PAY_TYPE_AccrueInterest = "6";//��������Ϣ
	public static final String PS_PAY_TYPE_Fee = "7";//���üƻ�
	
	public static final String PS_AMOUNT_BASE_Principal_Interest = "9";//�ڹ�ʣ�౾��+�ڹ���Ϣ
	
	//�ͻ������˺�
	public static final String LOAN_BalanceGroup_Customer_Normal_Principal = "Customer01";//δ���ڱ���
	public static final String LOAN_BalanceGroup_Customer_Overdue_Principal = "Customer02";//���ڱ���
	public static final String LOAN_BalanceGroup_Customer_Normal_Interest = "Customer11";//������Ϣ
	public static final String LOAN_BalanceGroup_Customer_Overdue_Interest = "Customer12";//�����ڹ���Ϣ
	public static final String LOAN_BalanceGroup_Customer_Fine_Interest = "Customer13";//���ڷ�Ϣ
	public static final String LOAN_BalanceGroup_Customer_Compound_Interest = "Customer14";//����
	public static final String LOAN_BalanceGroup_Customer_PrePay_Principal = "Customer03";//��ǰ�������ѽ᱾��δ��Ϣ���ֱ��������Ŀ�ϲ�����ֻ��ϵͳ��Ϣ����
	public static final String LOAN_BalanceGroup_Customer_Balance = "Customer21";//�ͻ���-���տ�
	
	//��ǰ�������� 
	public static final String PrepaymentType_All = "10"; //ȫ����ǰ����
	public static final String PrepaymentType_Part_FixTerm = "11"; //������ǰ����-���޲���
	public static final String PrepaymentType_Part_FixInstalment = "12"; //������ǰ����-�ڹ�����
	
	public static final String Prepayment_InterestFlag_NextDueDate = "01"; //���㵽�´λ�����
	public static final String Prepayment_InterestFlag_TransDate = "02"; //���㵽��ǰ������
	public static final String Prepayment_InterestFlag_NetNextInstalment = "03"; //�ϲ��´��ڹ�
	public static final String Prepayment_InterestFlag_NoneInterest = "04"; //������Ϣ
	
	
	public static final String Prepayment_InterestBaseFlag_PayPrincipal = "01";//��ǰ�����
	public static final String Prepayment_InterestBaseFlag_NormalBalance = "02";//�������

	//��ǰ����������
	public static final String PREPAY_AMOUNT_TYPE_Principal = "1";//����
	public static final String PREPAY_AMOUNT_TYPE_Principal_Interest = "2";//����+��Ϣ
	
	
	//�ڹ���Ϣ����
	public static final String Instalment_Change_Flag_New = "1";//���ڹ�
	public static final String Instalment_Change_Flag_Old = "2";//ԭ�ڹ�
	
	//������
	public static final String TRANSCODE_AHEAD_REPAYMENT = "0055";//��ǰ����
	public static final String TRANSCODE_EOD_DAILY = "9091";//���ս���
	public static final String TRANSCODE_BOD_DAILY = "9092";//�ճ�����
	public static final String TRANSCODE_RECIEVE_FEE = "3508";//�շ�
	public static final String TRANSCODE_PAY_FEE = "3520";//����
	
	//���˱�־
	public static final String TRANSSTATUS_NOT_CHARGE_UP = "0";// δ����
	public static final String TRANSSTATUS_ALREADY_CHARGE_UP = "1";// �Ѽ���
	public static final String TRANSSTATUS_ALREADY_CHARGE_DOWN = "2";// �ѳ���
	public static final String TRANSSTATUS_ALREADY_CHARGE_WAIT = "3";// ������
	public static final String TRANSSTATUS_ALREADY_CANCEL = "4";// ��ȡ��
	
	//����̯����ʽ
	public  static final String AMORTIZE_NO = "01";// ��̯��
	public  static final String AMORTIZE_LINE_MONTH_AMOUNT = "02";//ֱ�߰���̯�����Է��ý�
	public  static final String AMORTIZE_LINE_DAY_AMOUNT = "03";//ֱ�߰���̯�����Է��ý�
	public  static final String AMORTIZE_LINE_MONTH_RAMOUNT = "04";//ֱ�߰���̯��������ȡ��
	public  static final String AMORTIZE_LINE_DAY_RAMOUNT = "05";//ֱ�߰���̯��������ȡ��
	
	//��������˻�
	public static final String AccountIndicator_00 = "00";//�ſ��˻�
	public static final String AccountIndicator_01 = "01";//�����˻�
	public static final String AccountIndicator_02 = "02";//ί���˴���˺ţ����źͻ��ձ�Ϣ��
	public static final String AccountIndicator_03 = "03";//ί����ί�д���˺�
	public static final String AccountIndicator_04 = "04";//�������տ��˻�
	
	//�����ո���ʾ
	public static final String FEEFLAG_RECIEVE = "R";//�����ո���ʾ ��
	public static final String FEEFLAG_PAY = "P";//�����ո���ʾ ��
	public static final String FEEFLAG_RP = "B";//�����ո���ʾ ���մ���
	
	//�����ۿ��ʾ
	public static final String AUTOPAYFLAG_YES = "1"; //���������ۿ�
	public static final String AUTOPAYFLAG_NO = "2";//�����������ۿ�
	public static final String AUTOPAYFLAG_PayDayAndMaturity = "3";//�����ռ��ۿ��������ۿ�
	public static final String AUTOPAYFLAG_Maturity = "4";//ֻ�����������ۿ�
	public static final String AUTOPAYFLAG_PayDay = "5";//ֻ�ۿ��������ۿ�
	
	//��Ϣģʽ
	public static final String COMPOUNDINTERESTFLAG_COMP = "1";//��Ϣģʽ-����
	public static final String COMPOUNDINTERESTFLAG_SINGLE = "2";//��Ϣģʽ-����
	
	//����˻�����
	public static final String DEPOSIT_CARD = "01";//��
	public static final String DEPOSIT_BOOK = "02";//����
	
	//����˻���ʾ
	public static final String ACCOUNT_FLAG_DEPOSIT_SELF = "1";//���д���˻�
	public static final String ACCOUNT_FLAG_DEPOSIT_OTHER = "2";//�����˻�
	public static final String ACCOUNT_FLAG_CREDIT_CARD = "3";//�������ÿ��˻�
	public static final String ACCOUNT_FLAG_INNER = "8";//�����ڲ��˻�
	
	//�ۿʽ
	public static final String DEDUCTTYPE_ENOUGH = "1";//���ۿʽ
	public static final String DEDUCTTYPE_DEFICIT = "2";//�����ۿʽ
	
	//�������׷�ʽ
	public static final String BATCHTRANSTYPE_PAYMENT = "01";//����һ�㻹��
	public static final String BATCHTRANSTYPE_PREPAYMENT = "02";//������ǰ����
	public static final String BATCHTRANSTYPE_PAYMENTFEE = "03";//����������ȡ
	
	//��������
	public static final String PAYTYPE_NOMAL = "1";//һ�㻹��
	
	//����7˳�ӱ�־
	public static final String POSTPONE_PAYMENT_FLAG_Max="1";//�����ںͽڼ���˳����ȡ��
	public static final String POSTPONE_PAYMENT_FLAG_Min="2";//�����ںͽڼ���˳����ȡС
	public static final String POSTPONE_PAYMENT_FLAG_GRACE_HOLIDAY="3";//�����ں����ڼ��ռ���˳��
	public static final String POSTPONE_PAYMENT_FLAG_HOLIDAY_GRACE="4";//�ڼ���˳�Ӻ�������ܿ�����
	public static final String POSTPONE_PAYMENT_FLAG_ANY="5";//�������
	//�����ڼ�����Ϣ��ʶ
	public static final String POSTPONE_INTEREST_FLAG_NONE="1";//��������Ϣ
	public static final String POSTPONE_INTEREST_FLAG_LOANRATE="2";//���շ�Ϣ���ʼ�����Ϣ
	public static final String POSTPONE_INTEREST_FLAG_FINERATE="3";//���շ�Ϣ���ʼ�����Ϣ
	
	//��Ϣ����¼��ʽ
	public static final String INTEREST_LOG_AMT_FLAG_Balance="1";//����¼
	public static final String INTEREST_LOG_AMT_FLAG_Total="2";//�ۼƽ���¼
	public static final String INTEREST_LOG_AMT_FLAG_Amt="3";//���ڽ���¼
	
	//InterestType
	public static final String INTEREST_TYPE_NormalInterest="0";
	public static final String INTEREST_TYPE_FineInterest="1";
	public static final String INTEREST_TYPE_CompdInterest="2";
	public static final String INTEREST_TYPE_GraceInterest="4";
	
	public static final String IMPAIRMENTFLAG_Impairment = "1";//��ֵ����
	public static final String IMPAIRMENTFLAG_Normal = "2";//�Ǽ�ֵ����
	
	//�����ֱ�ʶ
	public final static String TRANS_FLAG_RED = "R";
	public final static String TRANS_FLAG_BLUE = "B";
	
	//������������ʶ
	public final static String LOANOVERDATEFLAG_PAYDATE = "010"; //����Ӧ�����ڿ�ʼ��������
	public final static String LOANOVERDATEFLAG_INTEDATE = "020";//�����ڼ��պͿ�����˳��֮�����ڿ�ʼ��������
	
	//�ſ�״̬	
	public final static String PUTOUTSTATUS_UNTRADED = "0";//���ſ�	
	public final static String PUTOUTSTATUS_TRADED = "1";//�ѷſ�	
	public final static String PUTOUTSTATUS_FLUSHED = "2";//�ѳ���
		
	//����״̬
	public final static String LOANSTATUS_NORMAL = "0";//����
	public final static String LOANSTATUS_OVERDUE = "1";//����
	public final static String LOANSTATUS_NORMAL_FINISHED = "2";//��������	
	public final static String LOANSTATUS_ADVANCE_FINISHED = "3";//��ǰ����	
	public final static String LOANSTATUS_OVERDUE_FINISHED = "4";//���ڽ���	
	public final static String LOANSTATUS_SELLOUT="5";//���������	
	public final static String LOANSTATUS_FLUSHED = "6";//�ѳ���	
	public final static String LOANSTATUS_SELLOUT_FINISH = "7";//���Ͻ���
	
	//��Ч״̬λ,��Code:FeeStatus��Ӧ	
	public final static String STATUS_NOT_EFFECTIVE = "0";	//δ��Ч
	public final static String STATUS_EFFECTIVE = "1";//��Ч
	public final static String STATUS_UNEFFECTIVE = "2";//ʧЧ
	public final static String STATUS_LOCKED = "3";//����
	
	//�Ƿ��ʶ
	public final static String FLAG_YES = "1";//��
	public final static String FLAG_NO = "2";//��
	
	//���ڱ����ʶ
	public final static String ON_BALANCESHEET = "1"; //���ڱ�ʶ
	public final static String OFF_BALANCESHEET = "2";//�����ʶ
	
	//����״̬
	public final static String LOCK_EOD = "1";   //��������
	public final static String LOCK_UNLOCKED = "2";//δ����
	public final static String LOCK_BOD = "3";   //�ճ�����
	
	//����
	public final static String CURRENCY_CNY = "01";//�����
	public final static String CURRENCY_GBP = "02";//Ӣ��
	public final static String CURRENCY_HKD = "03";//�۱�
	
	//�������ڱ�ʶ
	public final static String DAY_WORKDAY = "1";//������
	public final static String DAY_HOLIDAY = "2";//�ڼ���
	public final static String DAY_OFFICIAL_HOLIDAY = "3";//������
	
	//��ֵ����
	public final static String WAIVE_AMT = "0";//���
	public final static String WAIVE_PER = "1";//����
	
	//�����ת����
	public final static String CHANGEPRINCIPAL_OVER = "010";//����ת����
	public final static String CHANGEPRINCIPAL_NORMAL = "020";//����ת����
	
	//��������
	public final static String OccurType_010 = "010";//�·���
	public final static String OccurType_015 = "015";//չ��
	public final static String OccurType_020 = "020";//���»���
	public final static String OccurType_030 = "030";//�ʲ�����
	public final static String OccurType_040 = "040";//����
	public final static String OccurType_050 = "050";//�ع�
	public final static String OccurType_060 = "060";//���ɽ���
	public final static String OccurType_070 = "070";//���
	
	//��׼���ʵ�������
	public final static String RepriceType_NextDay = "1";//����(���׼���ʴ��յ���)
	public final static String RepriceType_BeginningOfYear = "2";//�̶���(�������)
	public final static String RepriceType_NextYear = "3";//�����(�ſ��մ�����¶���)
	public final static String RepriceType_NextMonth = "4";//���µ�((�ſ��մ��¶���))
	public final static String RepriceType_NextDueDate = "5";//��һ������
	public final static String RepriceType_FirstDueDateOfYear = "6";//�����׸�������
	public final static String RepriceType_Never = "7";//������
	public final static String RepriceType_Defined = "8";//�ֹ�ָ��������
}