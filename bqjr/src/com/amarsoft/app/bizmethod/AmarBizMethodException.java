package com.amarsoft.app.bizmethod;

import com.amarsoft.are.ASException;

/**
 * �׳�ҵ���쳣
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
