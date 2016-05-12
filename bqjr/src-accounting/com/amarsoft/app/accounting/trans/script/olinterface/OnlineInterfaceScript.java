package com.amarsoft.app.accounting.trans.script.olinterface;

import com.amarsoft.app.accounting.businessobject.AbstractBusinessObjectManager;
import com.amarsoft.app.accounting.businessobject.BusinessObject;



/**
 * @author yegang
 * 通用交易接口定义文件
 */

public interface OnlineInterfaceScript{
	
	/**如果交易错误，存储其错误信息
	 * @return
	 */
	public String getErrorMsg();
	
	/**
	 * 执行交易逻辑
	 * @param 
	 * @return TODO
	 * @throws Exception
	 */
	public boolean run(BusinessObject transaction,AbstractBusinessObjectManager boManager) throws Exception;
	
}
