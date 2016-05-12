/*
 * This software is the confidential and proprietary information
 * of Amarsoft, Inc. You shall not disclose such Confidential
 * Information and shall use it only in accordance with the terms
 * of the license agreement you entered into with Amarsoft.
 * 
 * Copyright (c) 1999-2011 Amarsoft, Inc.
 * 23F Building A Fudan University Technology Center,
 * No.11 Guotai Road YangPu District, Shanghai,P.R. China 200433
 * All Rights Reserved.
 * 
 */
package com.amarsoft.sadre.lic;

 /**
 * <p>Title: AbstractLicense.java </p>
 * <p>Description:  </p>
 * <p>Copyright: Copyright (C) 2006-2011 Amarsoft Ltd. Co.</p> 
 *     
 * @author zllin@amarsoft.com
 * @version 
 * @date 2011-10-9 上午10:05:46
 *
 * logs: 1. 
 */
public abstract class AbstractLicense implements SADRELicense {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	/* (non-Javadoc)
	 * @see com.amarsoft.sadre.lic.SADRELicense#getProductName()
	 */
	public String getProductName() {
		return "Amarsoft Simply Authorization Decision Rule Engine";
	}

	/* (non-Javadoc)
	 * @see com.amarsoft.sadre.lic.SADRELicense#getLicenseType()
	 */
	public int getLicenseType() {
		return 授权类型_无授权;
	}

	/* (non-Javadoc)
	 * @see com.amarsoft.sadre.lic.SADRELicense#getProductIdentifier()
	 */
	public String getProductIdentifier() {
		return "sadre";
	}

	/* (non-Javadoc)
	 * @see com.amarsoft.sadre.lic.SADRELicense#getProductVersion()
	 */
	public String getProductVersion() {
		return "0.3a09";
	}
	
	public String getVendorName(){
		return "上海安硕信息股份有限公司";
	}
}
