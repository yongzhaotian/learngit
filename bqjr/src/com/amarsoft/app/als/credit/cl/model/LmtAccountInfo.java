package com.amarsoft.app.als.credit.cl.model;

import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.JBOException;


/**
 * �����ռ�ö���
 * @author jschen
 *
 */
public abstract class LmtAccountInfo {
	
	/**
	 * ���峣��ռ�ö�������
	 * ���롢��������ͬ������
	 */
	public static final String LMTACCOUNTTYPE_BA = "CreditApply"; 
	public static final String LMTACCOUNTTYPE_BAP = "ApproveApply";
	public static final String LMTACCOUNTTYPE_BC = "BusinessContract";
	public static final String LMTACCOUNTTYPE_BP = "PutOutApply";
	public static final String LMTACCOUNTTYPE_BD = "BusinessDuebill";
	
	/**
	 * ��ȡռ��������
	 * @return
	 */
	public abstract double getUseBusinessSum(); 
	
	/**
	 * ��ȡռ�ó��ڽ��
	 * @return
	 */
	public abstract double getUseExposureSum();
	
	/**
	 * ��ȡռ�ö�����
	 * @return
	 */
	public abstract String getAccountNo();
	
	/**
	 * ��ȡռ�ö�������
	 * @return
	 */
	public abstract String getAccountType();
	
	/**
	 * ��ȡѭ����־
	 * @return
	 * @throws JBOException
	 */
	public abstract boolean getCycleflag();
	
	/**
	 * ��ȡռ�ö���ʵ��
	 * @return
	 */
	public abstract BizObject getCreditObject();
	
}
