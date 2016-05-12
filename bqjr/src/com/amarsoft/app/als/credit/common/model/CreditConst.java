/**
 * ����������
 * @author jschen
 */
package com.amarsoft.app.als.credit.common.model;

public class CreditConst {
	
	/**
	 * ������ݾ��ȣ��ݶ���С�����2λ
	 */
	public static final double LINE_PRECISION = 0.01;
	
	/**
	 * ����ҵ���������
	 */
	/**��������**/
	public static final String CREDITOBJECT_APPLY_REAL = "CreditApply"; 
	/**��������**/
	public static final String CREDITOBJECT_APPROVE_REAL = "ApproveApply"; 
	/**���ź�ͬ**/
	public static final String CREDITOBJECT_CONTRACT_REAL = "BusinessContract"; 
	
	public static final String CREDITOBJECT_CONTRACT_QUERY = "QueryBusinessContract";
	
	/**�����ͬ--���ź�ͬ������׶η����һ��**/
	public static final String CREDITOBJECT_AFTERLOANCONTRACT_VIRTUAL = "AfterLoan"; 
	/**���ǵ����ź�ͬ--���ź�ͬ�����ɷ�ʽ�����һ��**/
	public static final String CREDITOBJECT_REINFORCECONTRACT_VIRTUAL = "ReinforceContract"; 
	
	/**
	 * �������ͷ���
	 */
	/**���Ŷ�����룬�����Ҫϸ�ָ����ͣ���Ҫ���Ӻ�׺��ʽCreditLineApplyXxxx������С��ҵ�ۺ���������---CreditLineApplySmall,�������뷽ʽͬ��**/
	public static final String APPLYTYPE_CREDITLINE = "CreditLineApply"; 
	/**�����������**/
	public static final String APPLYTYPE_DEPENDENT = "DependentApply"; 
	/**���ʵ�������**/
	public static final String APPLYTYPE_INDEPENDENT = "IndependentApply";
	
	/**
	 * �����jbo��
	 */
	public static final String BA_JBOCLASS = "jbo.app.BUSINESS_APPLY"; 
	/**
	 * ������jbo��
	 */
	public static final String BAP_JBOCLASS = "jbo.app.BUSINESS_APPROVE"; 
	/**
	 * ��ͬ��jbo��
	 */
	public static final String BC_JBOCLASS = "jbo.app.BUSINESS_CONTRACT"; 
	/**
	 * ���ʱ�jbo��
	 */
	public static final String BP_JBOCLASS = "jbo.app.BUSINESS_PUTOUT"; 
	/**
	 * ��ݱ�jbo��
	 */
	public static final String BD_JBOCLASS = "jbo.app.BUSINESS_DUEBILL"; 
	
	
	
	
	/**
	 * �����־ ��
	 * 1	�ݴ�
	 * 2	����
	 */
	public static final String SAVE_FLAG_TEMP = "1";
	public static final String SAVE_FLAG_SAVE = "2";
	
	/**
	 * BUSINESS_APPLY Flag5��
	 * 010 	δ�Ǽ�����
	 * 020 	�ѵǼ�����
	 */
	public static final String BA_FLAG5_UNAPPROVE = "010";
	public static final String BA_FLAG5_APPROVED = "020";
	
	/**
	 * BUSINESS_APPROVE Flag5��
	 * 010 	δ�ǼǺ�ͬ
	 * 020 	�ѵǼǺ�ͬ
	 */
	public static final String BAP_FLAG5_UNREGISTER = "010";
	public static final String BAP_FLAG5_REGISTERED = "020";
	
	/**
	 * BUSINESS_APPROVE ApproveType:
	 * 01	ͬ��
	 * 02	���
	 */
	public static final String APPROVETYPE_AGREE = "01";
	public static final String APPROVETYPE_DISAGREE = "02";
	
	/**
	 * BUSINESS_CONTRACT ReinforceFlag<br>
	 * 000 �ǲ���<br>
	 * 010 δ������ɵ��Ŵ�ҵ��<br>
	 * 020 ��������Ŵ�ҵ��<br>
	 * 110 δ������ɵ����Ŷ��<br>
	 * 120 �Ѳ�����ɵ����Ŷ��<br>
	 * 
	 */
	/**�ǲ���**/
	public static final String REINFORCEFLAG_NORMAL = "000";
	/**δ������ɵ��Ŵ�ҵ��**/
	public static final String REINFORCEFLAG_UNDOCONTRACT = "010";
	/**��������Ŵ�ҵ��**/
	public static final String REINFORCEFLAG_DONECONTRACT = "020";
	/**δ������ɵ����Ŷ��**/
	public static final String REINFORCEFLAG_UNDODEAL = "110";
	/**�Ѳ�����ɵ����Ŷ��**/
	public static final String REINFORCEFLAG_DONEDEAL = "120";
	
	/**
	 * ����ҵ���������Ϣ
	 */
	/**��ȸ����з���Ϣ**/
	public static final String APPENDTYPE_DIVIDELINE = "DivideLine"; 
	
	
	
}
