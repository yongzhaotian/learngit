package com.amarsoft.app.accounting.businessobject;

import com.amarsoft.awe.util.Transaction;
import com.amarsoft.are.util.ASValuePool;

/**
 * @author dxu
 * 在通用场景初始化中，某些配置在OBJECT_ATTRITUE表中的预计算用类必须实现本接口。
 */
public interface IBusinessObjectExtLoader {
	/**
	 * @param sKey 属性名
	 * @return 属性值
	 * @throws Exception
	 */
	public ASValuePool generateData(Transaction Sqlca,ASValuePool parameters) throws Exception;
}
