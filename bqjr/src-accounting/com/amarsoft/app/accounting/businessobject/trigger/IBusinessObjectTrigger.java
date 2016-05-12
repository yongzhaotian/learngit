/**
 * Interface <code>IBusinessObjectTriggers</code> 是所有对象的触发器
 * 它用来管理对象发生变更时，触发其关联对象数据进行变更，具体参见<code>AbstractBusinessObjectManager.updateDB</code>方法
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
