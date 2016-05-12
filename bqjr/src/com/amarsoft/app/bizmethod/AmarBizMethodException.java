package com.amarsoft.app.bizmethod;

import com.amarsoft.are.ASException;

/**
 * 抛出业务级异常
 * @author jschen 20110609
 *
 */
public class AmarBizMethodException extends ASException{
	private static final long serialVersionUID = -3951484770921204837L;
	public AmarBizMethodException(String sMessage)
	{
		super(sMessage);		
	}
	public AmarBizMethodException(String sMessage,int iErrorLevel)
	{
		super(sMessage,iErrorLevel);		
	}

}
