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
package com.amarsoft.app.als.sadre.simplebo;

import com.amarsoft.sadre.SADREException;

 /**
 * <p>Title: ISimpleBO.java </p>
 * <p>Description:  </p>
 * <p>Copyright: Copyright (C) 2006-2011 Amarsoft Ltd. Co.</p> 
 *     
 * @author zllin@amarsoft.com
 * @version 
 * @date 2012-2-20 ����1:58:22
 *
 * logs: 1. 
 */
public interface ISimpleBO {
	/**
	 * �����Ȩ������ʹ�õļ�ҵ���������������
	 * 
	 * @throws SADREException
	 */
	public void fullfill() throws SADREException;
	
}
