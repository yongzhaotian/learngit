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
package com.amarsoft.sadre.integration;

import java.sql.Connection;
import java.sql.SQLException;
import java.util.Random;

import com.amarsoft.are.ARE;
import com.amarsoft.sadre.SADREException;
import com.amarsoft.sadre.rules.aco.WorkingObject;
import com.amarsoft.sadre.services.SADREService;

 /**
 * <p>Title: WorkingRuleObject.java </p>
 * <p>Description:  </p>
 * <p>Copyright: Copyright (C) 2006-2011 Amarsoft Ltd. Co.</p> 
 *     
 * @author zllin@amarsoft.com
 * @version 
 * @date 2011-4-20 ����11:09:14
 *
 * logs: 1. 
 */
public abstract class WorkingRuleObject extends RuntimeHandler implements WorkingObject{
	private Connection connection = null;
	/**
	 * �����Ψһ��ʶ
	 */
	private String uniqeCode = this.getClass().getName()+"@"+Integer.toHexString(this.hashCode())+(new Random()).nextFloat();
	
	protected Connection getConnection() throws SADREException{
		if(connection==null){
			try {
				connection = SADREService.getDBConnection();
			} catch (SQLException e) {
				e.printStackTrace();
				throw new SADREException(e);
			} catch (Exception e) {
				e.printStackTrace();
				throw new SADREException(e);
			}
		}
		return connection;
	}
	
	/* (non-Javadoc)
	 * @see com.amarsoft.sadre.integration.RuleDataObject#loadData()
	 */
	
	public final void loadData() throws SADREException{
		try{
			prepare();
		}catch(SADREException e){
			ARE.getLog().error(this.getClass().getName()+" ����׼��ʧ��!",e);
			releaseResource();
			throw e;
		}
		try{
			process();
		}catch(SADREException e){
			ARE.getLog().error(this.getClass().getName()+" ���ݴ���ʧ��!",e);
			releaseResource();
			throw e;
		}
		try{
			finalPost();
		}catch(SADREException e){
			ARE.getLog().error(this.getClass().getName()+" �����ύʧ��!",e);
			releaseResource();
			throw e;
		}
		
		releaseResource();
	}
	
	/**
	 * ��������ɶ�������Դռ�õ��ͷ�ʵ��
	 */
	abstract protected void releaseResource();
	
	/**
	 * pojo����ĳ�ʼ��׼��
	 * @throws SADREException
	 */
	abstract protected void prepare() throws SADREException;
	/**
	 * pojo�����ʵ�ִ������
	 * @throws SADREException
	 */
	abstract protected void process() throws SADREException;
	/**
	 * pojo�������β����
	 * @throws SADREException
	 */
	abstract protected void finalPost() throws SADREException;
	
	/**
	 * WorkingObject��Ψһ��ʶ
	 * @return
	 */
	public String uniqeCode(){
//		ARE.getLog().trace("uniqeCode="+uniqeCode);
		return uniqeCode;
	}
}
