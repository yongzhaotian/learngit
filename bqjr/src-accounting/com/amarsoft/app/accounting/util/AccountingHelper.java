package com.amarsoft.app.accounting.util;

import java.util.Collection;
import java.util.Map;

import com.amarsoft.app.accounting.businessobject.BusinessObject;
import com.amarsoft.are.util.ASValuePool;
import com.amarsoft.dict.als.cache.CodeCache;
import com.amarsoft.dict.als.object.Code;

/**
 * ������ذ�����
 * 
 * @author xyqu 2014��6��11��
 * 
 */
public final class AccountingHelper {


	/**
	 * ���ۺ϶���Ϊnull�򲻰���Ԫ��ʱ�����϶�Ϊ��
	 * 
	 * @param collection
	 * @return
	 */
	public final static boolean isEmpty(Collection<?> collection) {
		return collection == null || collection.isEmpty();
	}

	public final static boolean isEmpty(ASValuePool pool) {
		return pool == null || pool.isEmpty();
	}

	/**
	 * ��mapΪnull�򲻰���Ԫ��ʱ���϶�Ϊ��
	 * 
	 * @param map
	 * @return
	 */
	public final static boolean isEmpty(Map<?, ?> map) {
		return map == null || map.isEmpty();
	}

	public final static boolean notEmpty(Map<?, ?> map) {
		return map != null && !map.isEmpty();
	}

	public final static boolean notEmpty(Collection<?> collection) {
		return collection != null && !collection.isEmpty();
	}

	/**
	 * ���ݱ��ַ��ؽ���ֶεľ��ȡ�����ֶεľ���������Currencycode��attribute1�ֶ��ϡ�
	 * 
	 * @param currency
	 * @return
	 * @throws Exception
	 */
	public final static int getMoneyPrecision(String currency) throws Exception {
		//Assertion.notEmpty("����", currency);
		Code ccy = CodeCache.getCode("Currency");
		String precision = ccy.getItem(currency).getAttribute1();
		if (isEmpty(precision)) {
			return 2;
		}
		return Integer.parseInt(precision);
	}

	/**
	 * ����ҵ������ȡ��Ӧ�Ľ���ֶξ���
	 * 
	 * @param bo
	 * @return
	 * @throws Exception
	 */
	public final static int getMoneyPrecision(BusinessObject bo) throws Exception {
		return getMoneyPrecision(bo.getString("Currency"));
	}

	/**
	 * �ж��ַ����Ƿ�Ϊ�գ�Ϊ�շ���true,���򷵻�false
	 * 
	 * @param str
	 * @return
	 */
	public final static boolean isEmpty(String str) {
		return str == null || str.equals("");
	}

	public final static boolean notEmpty(String str) {
		return str != null && !str.trim().equals("");
	}

	/**
	 * �ж������ַ����Ƿ���ͬ��null�Ϳ��ַ��ڱ�ϵͳ�б���Ϊ��ͬЧ
	 * 
	 * @param source
	 * @param target
	 * @return
	 */
	public final static boolean equals(String source, String target) {
		if (isEmpty(source)) {
			if (isEmpty(target)) {
				return true;
			} else {
				return false;
			}
		} else {
			if (isEmpty(target)) {
				return false;
			}
		}
		return source.equals(target);
	}

	/**
	 * �ж�Դ�ַ����Ƿ����Ŀ���ַ�����
	 * 
	 * @param source
	 * @param target
	 * @return
	 */
	public final static boolean contains(String source, String target) {
		if (equals(source, target)) {
			return true;
		}
		if (isEmpty(source) || isEmpty(target)) {
			return false;
		}
		return source.contains(target);
	}

	public final static boolean isNull(Object obj) {
		return obj == null;
	}

	public final static boolean isEmtpy(Object[] array) {
		return array == null || array.length == 0;
	}

}
