package com.amarsoft.app.accounting.trans;

import com.amarsoft.app.accounting.businessobject.AbstractBusinessObjectManager;
import com.amarsoft.app.accounting.businessobject.BusinessObject;


/**
 * @author yegang
 * ͨ�ý��׽ӿڶ����ļ�
 */

public interface ITransactionScript{
	
	/**
	 * �趨���������
	 * @param 
	 * @return TODO
	 * @throws Exception
	 */
	public void setBOManager(AbstractBusinessObjectManager bom) throws Exception;
	
	/**
	 * ��ȡ���������
	 * @param 
	 * @return TODO
	 * @throws Exception
	 */
	public AbstractBusinessObjectManager getBOManager() throws Exception;

	/**
	 * �趨���׶��� 
	 * @param 
	 * @return TODO
	 * @throws Exception
	 */
	public void setTransaction(BusinessObject transaction) throws Exception;
	
	
	/**
	 * ��ȡ���� 
	 * @param 
	 * @return TODO
	 * @throws Exception
	 */
	public BusinessObject getTransaction() throws Exception;
	
	/**
	 * ִ�н����߼�
	 * @param 
	 * @return TODO
	 * @throws Exception
	 */
	public BusinessObject init() throws Exception;
	
	/**
	 * ִ�н����߼�
	 * @param 
	 * @return TODO
	 * @throws Exception
	 */
	public BusinessObject load(BusinessObject transaction,AbstractBusinessObjectManager boManager) throws Exception;
	
	
	/**
	 * ִ�н����߼�
	 * @param 
	 * @return TODO
	 * @throws Exception
	 */
	public int run() throws Exception;
	
	/**
	 * ִ�н����߼�
	 * @param 
	 * @return TODO
	 * @throws Exception
	 */
	public int check() throws Exception;
	
	
	/**
	 * ִ�н����߼�
	 * @param 
	 * @return TODO
	 * @throws Exception
	 */
	public int runOnlineInterface() throws Exception;
	
}
