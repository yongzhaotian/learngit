package com.amarsoft.app.accounting.businessobject;

import com.amarsoft.awe.util.Transaction;
import com.amarsoft.are.util.ASValuePool;

/**
 * @author dxu
 * ��ͨ�ó�����ʼ���У�ĳЩ������OBJECT_ATTRITUE���е�Ԥ�����������ʵ�ֱ��ӿڡ�
 */
public interface IBusinessObjectExtLoader {
	/**
	 * @param sKey ������
	 * @return ����ֵ
	 * @throws Exception
	 */
	public ASValuePool generateData(Transaction Sqlca,ASValuePool parameters) throws Exception;
}
