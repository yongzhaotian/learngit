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
 * @date 2011-4-20 上午11:09:14
 *
 * logs: 1. 
 */
public abstract class WorkingRuleObject extends RuntimeHandler implements WorkingObject{
	private Connection connection = null;
	/**
	 * 对象的唯一标识
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
			ARE.getLog().error(this.getClass().getName()+" 处理准备失败!",e);
			releaseResource();
			throw e;
		}
		try{
			process();
		}catch(SADREException e){
			ARE.getLog().error(this.getClass().getName()+" 数据处理失败!",e);
			releaseResource();
			throw e;
		}
		try{
			finalPost();
		}catch(SADREException e){
			ARE.getLog().error(this.getClass().getName()+" 处理提交失败!",e);
			releaseResource();
			throw e;
		}
		
		releaseResource();
	}
	
	/**
	 * 由子类完成对自身资源占用的释放实现
	 */
	abstract protected void releaseResource();
	
	/**
	 * pojo对象的初始化准备
	 * @throws SADREException
	 */
	abstract protected void prepare() throws SADREException;
	/**
	 * pojo对象的实现处理过程
	 * @throws SADREException
	 */
	abstract protected void process() throws SADREException;
	/**
	 * pojo对象的收尾处理
	 * @throws SADREException
	 */
	abstract protected void finalPost() throws SADREException;
	
	/**
	 * WorkingObject的唯一标识
	 * @return
	 */
	public String uniqeCode(){
//		ARE.getLog().trace("uniqeCode="+uniqeCode);
		return uniqeCode;
	}
}
