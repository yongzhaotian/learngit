package com.amarsoft.app.accounting.trans.script.olinterface;

import com.amarsoft.app.accounting.businessobject.AbstractBusinessObjectManager;
import com.amarsoft.app.accounting.businessobject.BusinessObject;



/**
 * @author yegang
 * ͨ�ý��׽ӿڶ����ļ�
 */

public interface OnlineInterfaceScript{
	
	/**������״��󣬴洢�������Ϣ
	 * @return
	 */
	public String getErrorMsg();
	
	/**
	 * ִ�н����߼�
	 * @param 
	 * @return TODO
	 * @throws Exception
	 */
	public boolean run(BusinessObject transaction,AbstractBusinessObjectManager boManager) throws Exception;
	
}
