/**
 * Interface <code>IBusinessObjectTriggers</code> �����ж���Ĵ�����
 * ������������������ʱ������������������ݽ��б��������μ�<code>AbstractBusinessObjectManager.updateDB</code>����
 *
 * @author  ygwang xjzhao
 * @version 1.0, 13/03/13
 * @see com.amarsoft.app.accounting.businessobject.AbstractBusinessObjectManager
 * @see com.amarsoft.app.accounting.businessobject.BusinessObject
 * @since  JDK1.6
 */

package com.amarsoft.app.accounting.businessobject.trigger;

import com.amarsoft.app.accounting.businessobject.BusinessObject;
import com.amarsoft.app.accounting.businessobject.AbstractBusinessObjectManager;

public interface IBusinessObjectTrigger {
	/**
	 * 
	 * @param Sqlca
	 * @param boList
	 * @return
	 * @throws Exception
	 */
	public void trigger(AbstractBusinessObjectManager boManager,BusinessObject bo,String objectType) throws Exception;
}
