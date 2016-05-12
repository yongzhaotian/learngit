package com.amarsoft.app.util;

public /**
 * 随心还使用次数统计表
 * 
 * @author kailh
 */
class BOMTRUseCountVO {

	/** OBJECTNO -- 合同号/客户编码 **/
	private String objectNO;

	/** OBJECTTYPE -- 1-合同号,2-客户编码 **/
	private String objectType;

	/** CUSTOMERID -- 客户ID **/
	private String customerId;

	/** CUSTOMERNAME -- 客户姓名 **/
	private String customerName;

	/** TOTAL_USE_CNT -- 总共可使用次数 **/
	private int totalUseCnt;

	/** DR_USE_CNT -- 延期还款可使用次数 **/
	private int drUseCnt;

	/** AP_USE_CNT -- 变更还款日可使用次数 **/
	private int apUseCnt;

	/** FR_USE_CNT -- 优惠提前还款可使用次数 **/
	private int frUseCnt;

	/** TOTAL_USED_CNT -- 总共已使用次数 **/
	private int totalUsedCnt;

	/** DR_USED_CNT -- 延期还款已使用次数 **/
	private int drUsedCnt;

	/** AP_USED_CNT -- 变更还款日已使用次数 **/
	private int apUsedCnt;

	/** FR_USED_CNT -- 优惠提前还款已使用次数 **/
	private int frUsedCnt;

	/** DR_PRE_APPLYDAYS -- 延期还款提前几天申请 **/
	private int drPreApplyDays;

	/** AP_PRE_APPLYDAYS -- 变更还款日提前几天申请 **/
	private int apPreApplyDays;

	/** FR_PRE_APPLYDAYS -- 优惠提前还款提前几天申请 **/
	private int frPreApplyDays;

	/** MAX_DELSEQS -- 最多延期期数 **/
	private int maxDelSeqs;

	/** DR_FIRST_SERPSEQS -- 延期还款首次使用连续还款期数 **/
	private int drFirstSeRPSeqs;

	/** DR_SEC_SERPSEQS -- 延期还款第二次使用时连续还款期数 **/
	private int drSecSeRPSeqs;

	/** AP_FIRST_SERPSEQS -- 变更还款日首次使用连续还款期数 **/
	private int apFirstSeRPSeqs;

	/** AP_SEC_SERPSEQS -- 变更还款日第二次使用时连续还款期数 **/
	private int apSecSeRPSeqs;

	/** FR_FIRST_SERPSEQS -- 优惠提前还款首次使用连续还款期数 **/
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
