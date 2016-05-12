package com.amarsoft.app.accounting.trans;

import com.amarsoft.app.accounting.businessobject.AbstractBusinessObjectManager;
import com.amarsoft.app.accounting.businessobject.BusinessObject;


/**
 * @author yegang
 * 通用交易接口定义文件
 */

public interface ITransactionScript{
	
	/**
	 * 设定对象管理器
	 * @param 
	 * @return TODO
	 * @throws Exception
	 */
	public void setBOManager(AbstractBusinessObjectManager bom) throws Exception;
	
	/**
	 * 获取对象管理器
	 * @param 
	 * @return TODO
	 * @throws Exception
	 */
	public AbstractBusinessObjectManager getBOManager() throws Exception;

	/**
	 * 设定交易对象 
	 * @param 
	 * @return TODO
	 * @throws Exception
	 */
	public void setTransaction(BusinessObject transaction) throws Exception;
	
	
	/**
	 * 获取交易 
	 * @param 
	 * @return TODO
	 * @throws Exception
	 */
	public BusinessObject getTransaction() throws Exception;
	
	/**
	 * 执行交易逻辑
	 * @param 
	 * @return TODO
	 * @throws Exception
	 */
	public BusinessObject init() throws Exception;
	
	/**
	 * 执行交易逻辑
	 * @param 
	 * @return TODO
	 * @throws Exception
	 */
	public BusinessObject load(BusinessObject transaction,AbstractBusinessObjectManager boManager) throws Exception;
	
	
	/**
	 * 执行交易逻辑
	 * @param 
	 * @return TODO
	 * @throws Exception
	 */
	public int run() throws Exception;
	
	/**
	 * 执行交易逻辑
	 * @param 
	 * @return TODO
	 * @throws Exception
	 */
	public int check() throws Exception;
	
	
	/**
	 * 执行交易逻辑
	 * @param 
	 * @return TODO
	 * @throws Exception
	 */
	public int runOnlineInterface() throws Exception;
	
}
