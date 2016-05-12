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
package com.amarsoft.sadre.rules.aco;

 /**
 * <p>Title: WorkingObject.java </p>
 * <p>Description:  本接口描述所有放入WorkingMemory的对象,定义其基本属性</p>
 * <p>Copyright: Copyright (C) 2006-2011 Amarsoft Ltd. Co.</p> 
 *     
 * @author zllin@amarsoft.com
 * @version 
 * @date 2011-4-22 下午03:32:03
 *
 * logs: 1. 
 */
public interface WorkingObject {
	/**
	 * 描述对象的类型,用以区分WorkingMemory中的不同类型对象
	 * @return
	 */
	public String getType();
	
	/**
	 * WorkingObject的唯一标识
	 * @return
	 */
	public String uniqeCode();
}
