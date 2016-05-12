/**
 * 
 */
package com.amarsoft.app.accounting.rpt;

import com.amarsoft.app.accounting.businessobject.BusinessObject;
import com.amarsoft.app.accounting.exception.LoanException;

/**
 * @author yegang
 * 期供计算引擎
 */
public interface IRepaymentScript {
	/**
	 * @param repaymentType
	 * @return 计算应还期供金额
	 * @throws AccountingException
	 * @throws Exception
	 */
	public double getInstalmentAmount(BusinessObject rptSegment) throws LoanException, Exception;
	
	
	/**
	 * @param repaymentType
	 * @return 计算应还期供类型
	 * @throws AccountingException
	 * @throws Exception
	 */
	public double getInstalOSAmount(BusinessObject rptSegment) throws LoanException, Exception;
	
	/**
	 * @param repaymentType
	 * @return 计算应还期供类型
	 * @throws AccountingException
	 * @throws Exception
	 */
	public String getInstalmentAmountType(BusinessObject rptSegment) throws LoanException, Exception;

	/**
	 *  根据利率、贷款期限、期供得到贷款的总金额
	 * @param pmtAmount月供
	 * @param rate	贷款周期利率
	 * @param loanTerm 贷款总期限
	 * @return 贷款总金额
	 */
	public double getLoanOSAmount(double instalmentAmount,double instalmentInterestRate,int totalPeriod);
	
	/**
	 * 贷款期限＝LOG（每期还款本息额/（每期还款本息额－贷款总金额*利率））/LOG（1＋利率）
	 * @return 贷款期限
	 */
	
	public int getLoanPeriod(BusinessObject rptSegment) throws NumberFormatException, Exception;	
	
	
	/**
	 * 计算贷款期次
	 * @param rptTerm 还款组件
	 * @return 贷款期次
	 */
	public int getTotalPeriod(BusinessObject rptSegment) throws Exception;
	
	public void setLoan(BusinessObject loan) throws Exception;
	
	public BusinessObject getLoan() throws Exception;
	
	public double getOutStandingBalance(BusinessObject rptSegment) throws Exception;
	
	public String getNextPayDate(BusinessObject rptSegment) throws Exception;
	
	public void nextInstalment(BusinessObject rptSegment) throws Exception;
}
