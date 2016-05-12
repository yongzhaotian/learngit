package com.amarsoft.app.creditline;

import com.amarsoft.app.creditline.cache.CLErrorTypeCache;
import com.amarsoft.app.creditline.cache.CreditLineTypeCache;
import com.amarsoft.app.creditline.cache.LimitationTypeCache;
import com.amarsoft.app.creditline.model.CreditLineType;
import com.amarsoft.app.creditline.model.ErrorType;
import com.amarsoft.app.creditline.model.LimitationType;

public class CreditLineManager {

	/**
	 * ����sCLTypeID��ȡCreditLineType������Ͷ���
	 * @param sErrorTypeID
	 * @return
	 * @throws Exception
	 */
	public static CreditLineType getCreditLineType(String sCLTypeID) throws Exception {
		return CreditLineTypeCache.getCreditLineType(sCLTypeID);
	}
	
	/**
	 * ����sTypeID��ȡLimitationType����������Ͷ���
	 * @param sErrorTypeID
	 * @return
	 * @throws Exception
	 */
	public static LimitationType getLimitationType(String sTypeID) throws Exception {
		return LimitationTypeCache.getLimitationType(sTypeID);
	}
	
	/**
	 * ����sErrorTypeID��ȡCLErrorType����쳣�����Ͷ���
	 * @param sErrorTypeID
	 * @return
	 * @throws Exception
	 */
	public static ErrorType getCLErrorType(String sErrorTypeID) throws Exception {
		return CLErrorTypeCache.getErrorType(sErrorTypeID);
	}
}
