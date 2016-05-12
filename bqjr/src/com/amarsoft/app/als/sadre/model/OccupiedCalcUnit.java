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
package com.amarsoft.app.als.sadre.model;

import com.amarsoft.sadre.SADREException;

 /**
 * <p>Title: OccupiedCalcUnit.java </p>
 * <p>Description: ����Ϊ���㵥���ܶ�Ĺ��ܽӿ�,����Ϊ�����Ļ���ռ�ý�� </p>
 * <p>Copyright: Copyright (C) 2006-2011 Amarsoft Ltd. Co.</p> 
 *     
 * @author zllin@amarsoft.com
 * @version 
 * @date 2012-2-20 ����1:46:04
 *
 * logs: 1. 
 */
public interface OccupiedCalcUnit {
	public double calculate() throws SADREException;
}
