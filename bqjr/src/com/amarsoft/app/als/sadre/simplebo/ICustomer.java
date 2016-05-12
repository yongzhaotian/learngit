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

import java.util.List;

import com.amarsoft.sadre.SADREException;

 /**
 * <p>Title: ICustomer.java </p>
 * <p>Description:  </p>
 * <p>Copyright: Copyright (C) 2006-2011 Amarsoft Ltd. Co.</p> 
 *     
 * @author zllin@amarsoft.com
 * @version 
 * @date 2012-2-20 下午2:01:34
 *
 * logs: 1. 
 */
public interface ICustomer {
	public static final int 客户类型_公司客户 = 1;
	public static final int 客户类型_个人客户 = 9;
	
	/**
	 * 当前信用等级
	 * @return
	 * @throws SADREException
	 */
	public String getCreditLevel();
	
	/**
	 * 客户名称
	 * @return
	 */
	public String getName();
	
	/**
	 * 客户编号
	 * @return
	 */
	public String getId();
	
	/**
	 * 客户类型 
	 * @return
	 */
	public String getType();
	
	/**
	 * 证件类型
	 * @return
	 */
	public String getCertType();
	
	/**
	 * 证件编号
	 * @return
	 */
	public String getCertId();
	
	/**
	 * 简要客户类型：公司/个人
	 */
	public int getSimpleType();
	
	/**
	 * 是否属于集团成员/家庭成员
	 * @return
	 * @throws Exception
	 */
	public boolean belongRelativeUnit() throws SADREException;
	
	/**
	 * 关联客户列表：1.公司客户为关联客户/集团客户；2.个人客户为家庭成员
	 * @return
	 * @throws SADREException
	 */
	public List<RelativeMember> getRelativeMembers() throws SADREException;
	
	/**
	 * 获取客户扩展属性
	 * @param attrName
	 * @return
	 */
	public String getAttribute(String attrName);
	
	public void setAttribute(String attrName,String attrValue);
	
}
