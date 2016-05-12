package com.amarsoft.app.creditline;

import com.amarsoft.app.creditline.cache.CLErrorTypeCache;
import com.amarsoft.app.creditline.cache.CreditLineTypeCache;
import com.amarsoft.app.creditline.cache.LimitationTypeCache;
import com.amarsoft.app.creditline.model.CreditLineType;
import com.amarsoft.app.creditline.model.ErrorType;
import com.amarsoft.app.creditline.model.LimitationType;

public class CreditLineManager {

	/**
	 * 根据sCLTypeID获取CreditLineType额度类型对象
	 * @param sErrorTypeID
	 * @return
	 * @throws Exception
	 */
	public static CreditLineType getCreditLineType(String sCLTypeID) throws Exception {
		return CreditLineTypeCache.getCreditLineType(sCLTypeID);
	}
	
	/**
	 * 根据sTypeID获取LimitationType额度限制类型对象
	 * @param sErrorTypeID
	 * @return
	 * @throws Exception
	 */
	public static LimitationType getLimitationType(String sTypeID) throws Exception {
		return LimitationTypeCache.getLimitationType(sTypeID);
	}
	
	/**
	 * 根据sErrorTypeID获取CLErrorType额度异常点类型对象
	 * @param sErrorTypeID
	 * @return
	 * @throws Exception
	 */
	public static ErrorType getCLErrorType(String sErrorTypeID) throws Exception {
		return CLErrorTypeCache.getErrorType(sErrorTypeID);
	}
}
