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

import java.sql.Connection;
import java.sql.SQLException;

import com.amarsoft.are.ARE;
import com.amarsoft.sadre.SADREException;
import com.amarsoft.sadre.services.SADREService;

 /**
 * <p>Title: AbstractDataLoader.java </p>
 * <p>Description:  </p>
 * <p>Copyright: Copyright (C) 2006-2011 Amarsoft Ltd. Co.</p> 
 *     
 * @author zllin@amarsoft.com
 * @version 
 * @date 2012-1-18 ÉÏÎç11:57:46
 *
 * logs: 1. 
 */
public abstract class AbstractDataLoader implements DataLoader {

	private Connection connection = null;
	
	abstract protected boolean load(Connection conn) throws SADREException;
	
	abstract protected void releaseResource();

	/* (non-Javadoc)
	 * @see com.amarsoft.sadre.cache.loader.DataLoader#load()
	 */
	
	public boolean load() throws SADREException {
		
		try {
			connection = SADREService.getDBConnection();
			return load(connection);
		}
		catch (Exception e) {
			throw new SADREException(e);
		}
		finally {
			releaseResource();
			
			if (connection != null)
				try {
					connection.close();
				} catch (SQLException e) {
					ARE.getLog().debug(e);
				}
		}
	}
}
