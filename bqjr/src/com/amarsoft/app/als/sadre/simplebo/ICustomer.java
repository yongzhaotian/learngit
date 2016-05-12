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
 * @date 2012-2-20 ����2:01:34
 *
 * logs: 1. 
 */
public interface ICustomer {
	public static final int �ͻ�����_��˾�ͻ� = 1;
	public static final int �ͻ�����_���˿ͻ� = 9;
	
	/**
	 * ��ǰ���õȼ�
	 * @return
	 * @throws SADREException
	 */
	public String getCreditLevel();
	
	/**
	 * �ͻ�����
	 * @return
	 */
	public String getName();
	
	/**
	 * �ͻ����
	 * @return
	 */
	public String getId();
	
	/**
	 * �ͻ����� 
	 * @return
	 */
	public String getType();
	
	/**
	 * ֤������
	 * @return
	 */
	public String getCertType();
	
	/**
	 * ֤�����
	 * @return
	 */
	public String getCertId();
	
	/**
	 * ��Ҫ�ͻ����ͣ���˾/����
	 */
	public int getSimpleType();
	
	/**
	 * �Ƿ����ڼ��ų�Ա/��ͥ��Ա
	 * @return
	 * @throws Exception
	 */
	public boolean belongRelativeUnit() throws SADREException;
	
	/**
	 * �����ͻ��б�1.��˾�ͻ�Ϊ�����ͻ�/���ſͻ���2.���˿ͻ�Ϊ��ͥ��Ա
	 * @return
	 * @throws SADREException
	 */
	public List<RelativeMember> getRelativeMembers() throws SADREException;
	
	/**
	 * ��ȡ�ͻ���չ����
	 * @param attrName
	 * @return
	 */
	public String getAttribute(String attrName);
	
	public void setAttribute(String attrName,String attrValue);
	
}
