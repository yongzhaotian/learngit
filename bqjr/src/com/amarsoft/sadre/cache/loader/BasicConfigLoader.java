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
 * <p>Title: BasicConfigLoader.java </p>
 * <p>Description: 抽象类BasicConfigLoader借鉴了com.amarsoft.dict.als.cache.AbstractCache，接口定义基本一致;<br>
 * 		由于考虑到在ALS6环境上的应用,不便直接继承ALS7的接口. </p>
 * <p>Copyright: Copyright (C) 2006-2011 Amarsoft Ltd. Co.</p> 
 *     
 * @author zllin@amarsoft.com
 * @version 
 * @date 2012-1-17 下午5:56:37
 *
 * logs: 1. 
 */
public abstract class BasicConfigLoader extends AbstractDataLoader implements ConfigLoader {
	
	/* (non-Javadoc)
	 * @see com.amarsoft.sadre.cache.ConfigLoader#reload()
	 */
	
	public boolean reload() throws SADREException {
		this.clear();
		return load();
	}
	
	/* (non-Javadoc)
	 * @see com.amarsoft.sadre.cache.ConfigLoader#unload()
	 */
	
	public void unload() throws SADREException {
		this.clear();

	}
	
	

}
