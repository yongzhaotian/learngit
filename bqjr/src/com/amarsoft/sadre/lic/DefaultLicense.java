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
 * <p>Title: DefaultLicense.java </p>
 * <p>Description:  </p>
 * <p>Copyright: Copyright (C) 2006-2011 Amarsoft Ltd. Co.</p> 
 *     
 * @author zllin@amarsoft.com
 * @version 
 * @date 2011-10-9 上午10:29:16
 *
 * logs: 1. 
 */
public class DefaultLicense extends AbstractLicense {
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	private String licensedClient = "";
	
	public DefaultLicense(String client){
		this.licensedClient = client;
	}

	/* (non-Javadoc)
	 * @see com.amarsoft.sadre.lic.SADRELicense#getLicensedClient()
	 */
	public String getLicensedClient() {
		return licensedClient;
	}
	
	public int getLicenseType() {
		return 授权类型_完整授权;
	}
}
