package com.amarsoft.app.accounting.util;
/**
 * ����������������
 */
public class PRODUCT_CONSTANTS {
	//���ʽ����
	public static final String Payment_Type_PayAllAmt = "01"; //������Ϣ
	public static final String Payment_Type_PayPrincipalAmt = "02";//��������Ϣ
	public static final String Payment_Type_PayInteAmt = "03";//������ֻ��Ϣ
	
	//����Ƶ��PaymentFrequencyType
	public final static String PAYMENTFREQUENCY_MONTHLY = "1";  //��
	public final static String PAYMENTFREQUENCY_QUARTERLY = "2";//��
	public final static String PAYMENTFREQUENCY_ONCE = "3";     //һ��
	public final static String PAYMENTFREQUENCY_SEMIANNUALLY = "4";//����
	public final static String PAYMENTFREQUENCY_ANNUALLY = "5"; //��
	public final static String PAYMENTFREQUENCY_BIWEEKLY = "7"; //˫��
	public final static String PAYMENTFREQUENCY_BIMONTHLY = "8";//˫��
	
	//�������ޱ�ʶSEGTermFlag
	public final static String SEGTERM_LOAN = "1";     //��������
	public final static String SEGTERM_SEGMENT = "2";  //��������
	public final static String SEGTERM_SPECIFIED = "3";//ָ������
	
	//���ڻ����ʶFirstInstalmentFlag
	public final static String FIRSTINSTALMENT_CurrentMonth_Yes = "01";//�ſ�»���
	public final static String FIRSTINSTALMENT_CurrentMonth_No = "02";//�ſ�²�����
	public final static String FIRSTINSTALMENT_CurrentMonth_Yes_Fixed = "03";//�ſ�»����׼���ڣ�
	public final static String FIRSTINSTALMENT_NextMonth_No_Fixed = "04";//�ſ�²������׼���ڣ�
	
	//ĩ�ڻ����ʶFinalInstalmentFlag
	public final static String FINALINSTALMENTFLAG_01 = "01";//�������ںϲ�����������
	public final static String FINALINSTALMENTFLAG_02 = "02";//������������һ��
	public final static String FINALINSTALMENTFLAG_03 = "03";//�Զ�˳��ֱ�������
	
	//�������
	public final static String TERMSETFLAG_BASIC = "BAS";//�������
	public final static String TERMSETFLAG_SET = "SET";//������
	public final static String TERMSETFLAG_SEGMENT = "SEG";//�����
	
	//���ν���ʶ
	public final static String SEGRPTAMOUNT_LOAN_BALANCE = "1"; //�������
	public final static String SEGRPTAMOUNT_SEG_AMT = "2";      //ָ�����
	public final static String SEGRPTAMOUNT_SEG_INSTALMENTAMT = "3";//ָ��ÿ�ڻ����
	public final static String SEGRPTAMOUNT_FINAL_PAYMENT = "4";//β����
	
	//���ڹ�����
	public final static String NEWPMTTYPE_OLDPRINCIPAL = "0";   //�ɱ�+������Ϣ
	public final static String NEWPMTTYPE_NEWPRINCIPAL = "1";   //�±�+������Ϣ
	public final static String NEWPMTTYPE_NEWINSTALMENTAMT = "2";//���ڹ�
	public final static String NEWPMTTYPE_OLDINSTALMENTAMT = "3";//ԭ�ڹ�
	
	//�����ռ����ʶ
	public final static String MATURITYCALFLAG_MATURITY = "01";//��¼�뵽����Ϊ׼
	public final static String MATURITYCALFLAG_TERM = "02";//�Է����ռ�����Ϊ׼
	
	//��ƿ�Ŀ����
	public final static String BALANCE_DIRECTION_DEBIT = "D";//��
	public final static String BALANCE_DIRECTION_CREDIT = "C";//��
	public final static String BALANCE_DIRECTION_RECIEVE = "R";//��
	public final static String BALANCE_DIRECTION_PAY = "P";//��
	public final static String BALANCE_DIRECTION_BOTH = "B";//˫��
	
	//����ҵ������
	public final static String OFFBSFLAG_DEBIT = "1";//�跽
	public final static String OFFBSFLAG_CREDIT = "2";//����
	
	//��Ŀ����
	public final static String ACCOUNTCODENO_ACCRUE_INTE = "LAS10301";//����-����Ӧ����Ϣ
	public final static String ACCOUNTCODENO_OVER_INTE = "LAS10302";//����-Ӧ��δ����Ϣ
	public final static String ACCOUNTCODENO_INTE_AMT = "LAS50101";//������Ϣ����
	public final static String ACCOUNTCODENO_INTE_ADVANCED = "LAS50102";//����Ԥ����Ϣ
	//�����ո�ʱ��
	public final static String FEEPAY_RELATRANS_ONCE = "01";//���������һ������ȡ
	public final static String FEEPAY_BEFORE_RELATRANS_ONCE = "02";//��������ǰ�ֹ�һ������ȡ
	public final static String FEEPAY_ONCE = "03";//�ֹ�һ������ȡ
	public final static String FEEPAY_PERIOD = "04";//��ָ��������ȡ
	public final static String FEEPAY_SCHEDULE = "05";//������ƻ���ȡ
	public final static String FEEPAY_FIRSTPAYDATE = "06";//�״λ�������ȡ
	
	//���˻�����ʾ
	public final static String FEEACCOUNTINGORG_ACCOUNTING = "01";//�������˻���
	public final static String FEEACCOUNTINGORG_OPERATOR = "02";//��������
	
	//��Ϣ����
	public final static String SPT_TYPE_WAIVE = "10";//ֱ�Ӽ���
	public final static String SPT_TYPE_REFUND = "20";//�ȿۺ�
	
	//��׼��������
	public final static String BASERATE_PBOC = "010";//���л�׼����
	public final static String BASERATE_PHF = "020";//�������׼����
	public final static String BASERATE_DISCOUNT = "030";//��������
	public final static String BASERATE_LIBOR = "040";//�׶�����ͬҵ�������
	public final static String BASERATE_HIBOR = "050";//�������ͬҵ�������
	public final static String BASERATE_FIXED = "060";//�̶�����
	public final static String BASERATE_SIBOR = "070";//�¼�������ͬҵ�������
	public final static String BASERATE_NORMAL = "100";//����ִ������
}
