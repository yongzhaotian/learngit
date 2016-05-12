/**
 * 
 */
package com.amarsoft.app.accounting.rpt;

import com.amarsoft.app.accounting.businessobject.BusinessObject;
import com.amarsoft.app.accounting.exception.LoanException;

/**
 * @author yegang
 * �ڹ���������
 */
public interface IRepaymentScript {
	/**
	 * @param repaymentType
	 * @return ����Ӧ���ڹ����
	 * @throws AccountingException
	 * @throws Exception
	 */
	public double getInstalmentAmount(BusinessObject rptSegment) throws LoanException, Exception;
	
	
	/**
	 * @param repaymentType
	 * @return ����Ӧ���ڹ�����
	 * @throws AccountingException
	 * @throws Exception
	 */
	public double getInstalOSAmount(BusinessObject rptSegment) throws LoanException, Exception;
	
	/**
	 * @param repaymentType
	 * @return ����Ӧ���ڹ�����
	 * @throws AccountingException
	 * @throws Exception
	 */
	public String getInstalmentAmountType(BusinessObject rptSegment) throws LoanException, Exception;

	/**
	 *  �������ʡ��������ޡ��ڹ��õ�������ܽ��
	 * @param pmtAmount�¹�
	 * @param rate	������������
	 * @param loanTerm ����������
	 * @return �����ܽ��
	 */
	public double getLoanOSAmount(double instalmentAmount,double instalmentInterestRate,int totalPeriod);
	
	/**
	 * �������ޣ�LOG��ÿ�ڻ��Ϣ��/��ÿ�ڻ��Ϣ������ܽ��*���ʣ���/LOG��1�����ʣ�
	 * @return ��������
	 */
	
	public int getLoanPeriod(BusinessObject rptSegment) throws NumberFormatException, Exception;	
	
	
	/**
	 * ��������ڴ�
	 * @param rptTerm �������
	 * @return �����ڴ�
	 */
	public int getTotalPeriod(BusinessObject rptSegment) throws Exception;
	
	public void setLoan(BusinessObject loan) throws Exception;
	
	public BusinessObject getLoan() throws Exception;
	
	public double getOutStandingBalance(BusinessObject rptSegment) throws Exception;
	
	public String getNextPayDate(BusinessObject rptSegment) throws Exception;
	
	public void nextInstalment(BusinessObject rptSegment) throws Exception;
}
