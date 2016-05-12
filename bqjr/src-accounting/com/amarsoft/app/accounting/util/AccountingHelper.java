package com.amarsoft.app.accounting.util;

import java.util.Collection;
import java.util.Map;

import com.amarsoft.app.accounting.businessobject.BusinessObject;
import com.amarsoft.are.util.ASValuePool;
import com.amarsoft.dict.als.cache.CodeCache;
import com.amarsoft.dict.als.object.Code;

/**
 * 核算相关帮助类
 * 
 * @author xyqu 2014年6月11日
 * 
 */
public final class AccountingHelper {


	/**
	 * 当聚合对象为null或不包含元素时，就认定为空
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
	 * 当map为null或不包含元素时，认定为空
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
	 * 根据币种返回金额字段的精度。金额字段的精度设置在Currencycode的attribute1字段上。
	 * 
	 * @param currency
	 * @return
	 * @throws Exception
	 */
	public final static int getMoneyPrecision(String currency) throws Exception {
		//Assertion.notEmpty("币种", currency);
		Code ccy = CodeCache.getCode("Currency");
		String precision = ccy.getItem(currency).getAttribute1();
		if (isEmpty(precision)) {
			return 2;
		}
		return Integer.parseInt(precision);
	}

	/**
	 * 根据业务对象获取对应的金额字段精度
	 * 
	 * @param bo
	 * @return
	 * @throws Exception
	 */
	public final static int getMoneyPrecision(BusinessObject bo) throws Exception {
		return getMoneyPrecision(bo.getString("Currency"));
	}

	/**
	 * 判断字符串是否为空，为空返回true,否则返回false
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
	 * 判断两个字符串是否相同，null和空字符在本系统中被认为是同效
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
	 * 判断源字符串是否包含目标字符串：
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
