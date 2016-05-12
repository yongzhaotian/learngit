package com.amarsoft.app.util;

public /**
 * ���Ļ�ʹ�ô���ͳ�Ʊ�
 * 
 * @author kailh
 */
class BOMTRUseCountVO {

	/** OBJECTNO -- ��ͬ��/�ͻ����� **/
	private String objectNO;

	/** OBJECTTYPE -- 1-��ͬ��,2-�ͻ����� **/
	private String objectType;

	/** CUSTOMERID -- �ͻ�ID **/
	private String customerId;

	/** CUSTOMERNAME -- �ͻ����� **/
	private String customerName;

	/** TOTAL_USE_CNT -- �ܹ���ʹ�ô��� **/
	private int totalUseCnt;

	/** DR_USE_CNT -- ���ڻ����ʹ�ô��� **/
	private int drUseCnt;

	/** AP_USE_CNT -- ��������տ�ʹ�ô��� **/
	private int apUseCnt;

	/** FR_USE_CNT -- �Ż���ǰ�����ʹ�ô��� **/
	private int frUseCnt;

	/** TOTAL_USED_CNT -- �ܹ���ʹ�ô��� **/
	private int totalUsedCnt;

	/** DR_USED_CNT -- ���ڻ�����ʹ�ô��� **/
	private int drUsedCnt;

	/** AP_USED_CNT -- �����������ʹ�ô��� **/
	private int apUsedCnt;

	/** FR_USED_CNT -- �Ż���ǰ������ʹ�ô��� **/
	private int frUsedCnt;

	/** DR_PRE_APPLYDAYS -- ���ڻ�����ǰ�������� **/
	private int drPreApplyDays;

	/** AP_PRE_APPLYDAYS -- �����������ǰ�������� **/
	private int apPreApplyDays;

	/** FR_PRE_APPLYDAYS -- �Ż���ǰ������ǰ�������� **/
	private int frPreApplyDays;

	/** MAX_DELSEQS -- ����������� **/
	private int maxDelSeqs;

	/** DR_FIRST_SERPSEQS -- ���ڻ����״�ʹ�������������� **/
	private int drFirstSeRPSeqs;

	/** DR_SEC_SERPSEQS -- ���ڻ���ڶ���ʹ��ʱ������������ **/
	private int drSecSeRPSeqs;

	/** AP_FIRST_SERPSEQS -- ����������״�ʹ�������������� **/
	private int apFirstSeRPSeqs;

	/** AP_SEC_SERPSEQS -- ��������յڶ���ʹ��ʱ������������ **/
	private int apSecSeRPSeqs;

	/** FR_FIRST_SERPSEQS -- �Ż���ǰ�����״�ʹ�������������� **/
	private int frFirstSeRPSeqs;

	public BOMTRUseCountVO() {

	}

	public String getObjectNO() {
		return objectNO;
	}

	public void setObjectNO(String objectNO) {
		this.objectNO = objectNO;
	}

	public String getObjectType() {
		return objectType;
	}

	public void setObjectType(String objectType) {
		this.objectType = objectType;
	}

	public String getCustomerId() {
		return customerId;
	}

	public void setCustomerId(String customerId) {
		this.customerId = customerId;
	}

	public String getCustomerName() {
		return customerName;
	}

	public void setCustomerName(String customerName) {
		this.customerName = customerName;
	}

	public int getTotalUseCnt() {
		return totalUseCnt;
	}

	public void setTotalUseCnt(int totalUseCnt) {
		this.totalUseCnt = totalUseCnt;
	}

	public int getDrUseCnt() {
		return drUseCnt;
	}

	public void setDrUseCnt(int drUseCnt) {
		this.drUseCnt = drUseCnt;
	}

	public int getApUseCnt() {
		return apUseCnt;
	}

	public void setApUseCnt(int apUseCnt) {
		this.apUseCnt = apUseCnt;
	}

	public int getFrUseCnt() {
		return frUseCnt;
	}

	public void setFrUseCnt(int frUseCnt) {
		this.frUseCnt = frUseCnt;
	}

	public int getTotalUsedCnt() {
		return totalUsedCnt;
	}

	public void setTotalUsedCnt(int totalUsedCnt) {
		this.totalUsedCnt = totalUsedCnt;
	}

	public int getDrUsedCnt() {
		return drUsedCnt;
	}

	public void setDrUsedCnt(int drUsedCnt) {
		this.drUsedCnt = drUsedCnt;
	}

	public int getApUsedCnt() {
		return apUsedCnt;
	}

	public void setApUsedCnt(int apUsedCnt) {
		this.apUsedCnt = apUsedCnt;
	}

	public int getFrUsedCnt() {
		return frUsedCnt;
	}

	public void setFrUsedCnt(int frUsedCnt) {
		this.frUsedCnt = frUsedCnt;
	}

	public int getDrPreApplyDays() {
		return drPreApplyDays;
	}

	public void setDrPreApplyDays(int drPreApplyDays) {
		this.drPreApplyDays = drPreApplyDays;
	}

	public int getApPreApplyDays() {
		return apPreApplyDays;
	}

	public void setApPreApplyDays(int apPreApplyDays) {
		this.apPreApplyDays = apPreApplyDays;
	}

	public int getFrPreApplyDays() {
		return frPreApplyDays;
	}

	public void setFrPreApplyDays(int frPreApplyDays) {
		this.frPreApplyDays = frPreApplyDays;
	}

	public int getMaxDelSeqs() {
		return maxDelSeqs;
	}

	public void setMaxDelSeqs(int maxDelSeqs) {
		this.maxDelSeqs = maxDelSeqs;
	}

	public int getDrFirstSeRPSeqs() {
		return drFirstSeRPSeqs;
	}

	public void setDrFirstSeRPSeqs(int drFirstSeRPSeqs) {
		this.drFirstSeRPSeqs = drFirstSeRPSeqs;
	}

	public int getDrSecSeRPSeqs() {
		return drSecSeRPSeqs;
	}

	public void setDrSecSeRPSeqs(int drSecSeRPSeqs) {
		this.drSecSeRPSeqs = drSecSeRPSeqs;
	}

	public int getApFirstSeRPSeqs() {
		return apFirstSeRPSeqs;
	}

	public void setApFirstSeRPSeqs(int apFirstSeRPSeqs) {
		this.apFirstSeRPSeqs = apFirstSeRPSeqs;
	}

	public int getApSecSeRPSeqs() {
		return apSecSeRPSeqs;
	}

	public void setApSecSeRPSeqs(int apSecSeRPSeqs) {
		this.apSecSeRPSeqs = apSecSeRPSeqs;
	}

	public int getFrFirstSeRPSeqs() {
		return frFirstSeRPSeqs;
	}

	public void setFrFirstSeRPSeqs(int frFirstSeRPSeqs) {
		this.frFirstSeRPSeqs = frFirstSeRPSeqs;
	}
}
