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

import java.io.Serializable;

 /**
 * <p>Title: SADRELicense.java </p>
 * <p>Description:  </p>
 * <p>Copyright: Copyright (C) 2006-2011 Amarsoft Ltd. Co.</p> 
 *     
 * @author zllin@amarsoft.com
 * @version 
 * @date 2011-10-9 上午10:01:32
 *
 * logs: 1. 
 */
public interface SADRELicense extends Serializable {
	public static final int 授权类型_无授权 	 = -1;
	public static final int 授权类型_完整授权 = 1;
	
	/**
	 * 产品名称
	 * @return
	 */
	public String getProductName();
	/**
	 * license类型
	 * @return
	 */
	public int getLicenseType();
	/**
	 * 产品标识
	 * @return
	 */
	public String getProductIdentifier();
	/**
	 * 产品版本
	 * @return
	 */
	public String getProductVersion();
	/**
	 * 产品提供厂商
	 * @return
	 */
	public String getVendorName();
	/**
	 * 授权客户名称
	 * @return
	 */
	public String getLicensedClient();
}
