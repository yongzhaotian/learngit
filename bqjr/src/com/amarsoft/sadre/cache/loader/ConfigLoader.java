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
package com.amarsoft.sadre.cache.loader;

import com.amarsoft.sadre.SADREException;

 /**
 * <p>Title: ConfigLoader.java </p>
 * <p>Description: 接口ConfigLoader定义了SADRE针对授权配置参数/规则进行缓存的抽象接口定义。 </p>
 * <p>Copyright: Copyright (C) 2006-2011 Amarsoft Ltd. Co.</p> 
 *     
 * @author zllin@amarsoft.com
 * @version 
 * @date 2012-1-17 下午5:48:41
 *
 * logs: 1. 
 */
public interface ConfigLoader extends DataLoader{

	public boolean reload() throws SADREException;

	public void unload() throws SADREException;

	public void clear() throws SADREException;
	
}
