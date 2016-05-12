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
package com.amarsoft.sadre.services;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.ObjectInputStream;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Iterator;

import javax.rules.RuleExecutionSetNotFoundException;
import javax.rules.RuleRuntime;
import javax.rules.RuleServiceProvider;
import javax.rules.RuleServiceProviderManager;
import javax.rules.StatelessRuleSession;
import javax.rules.admin.LocalRuleExecutionSetProvider;
import javax.rules.admin.RuleAdministrator;
import javax.rules.admin.RuleExecutionSet;

import com.amarsoft.are.ARE;
import com.amarsoft.are.io.FileTool;
import com.amarsoft.sadre.SADREException;
import com.amarsoft.sadre.cache.Dimensions;
import com.amarsoft.sadre.cache.RuleScenes;
import com.amarsoft.sadre.cache.ScenePackages;
import com.amarsoft.sadre.cache.Synonymns;
import com.amarsoft.sadre.lic.NoLicense;
import com.amarsoft.sadre.lic.SADRELicense;
import com.amarsoft.sadre.rules.aco.RuleScene;

 /**
 * <p>Title: SADREService.java </p>
 * <p>Description:  </p>
 * <p>Copyright: Copyright (C) 1999-2011 Amarsoft Ltd. Co.</p> 
 *     
 * @author zllin@amarsoft.com
 * @version 
 * @date 2011-4-15 上午10:08:48
 *
 * logs: 1. 
 */
public final class SADREService {
	
	private static boolean initialized = false;
	private static boolean initOK = false;
	private static String database = "als";
	private static RuleRuntime ruleRuntime = null;
	private static SADRELicense license = null;
	
	/**
	 * 通过ARE的系统属性完成初始化工作,如果ARE全局属性中未配置sadre.database属性,则以als为默认als数据库连接名称
	 */
	public static void init() {
		//避免多次初始化，设置标志性变量
		if(initialized){
			System.out.println("SADRE has initialized,can't do it again!");
			return;
		}
		
		//---------------增加license授权初始化 at 20111009
		File licFile = FileTool.findFile(ARE.getProperty("APP_HOME")+"/etc/sadre.lic");
		if(licFile==null){
			ARE.getLog().trace("License file 'etc/sadre.lic' not found! <<<SADRE will run in unlicensed mode!>>>");
			license = new NoLicense();
		}else{
			license = (SADRELicense)loadLicense(licFile);
			ARE.getLog().trace("<<<SADRE licensed to "+license.getLicensedClient()+">>>");
		}
		ARE.getLog().trace(license.getProductName()+", Version "+license.getProductVersion());
//		System.out.println("(C)Copyright 2006-2011 Amarsoft Technology Co., Ltd.. All rights reserved.");
//		System.out.println();
		
		try {
			Synonymns.getInstance().load();
			
		} catch (SADREException e) {
			ARE.getLog().error("加载参数载体对象定义失败!",e);
			return;
		}
		ARE.getLog().debug("loading... "+Synonymns.getSynonymns().size()+" Synonymns done!");
		
		try {
			Dimensions.getInstance().load();
		} catch (SADREException e) {
			ARE.getLog().error("加载授权参数定义失败!",e);
			return;
		}
		ARE.getLog().debug("loading... "+Dimensions.getDimensions().size()+" Dimensions done!");
		
		try {
			RuleScenes.getInstance().load();
		} catch (SADREException e) {
			ARE.getLog().error("加载授权方案定义失败!",e);
			return;
		}
		ARE.getLog().debug("loading... "+RuleScenes.getRuleScenes().size()+" RuleScenes done! ");
		
		try {
			ScenePackages.getInstance().load();
		} catch (SADREException e1) {
			e1.printStackTrace();
			ARE.getLog().error("加载授权适用流程失败!",e1);
			return;
		}
		ARE.getLog().debug("loading... "+ScenePackages.getScenePackages().size()+" ScenePackages done! ");
		
		try {
			loadRuleEngine();
		} catch (SADREException e) {
			ARE.getLog().error("初始化授权规则引擎失败!",e);
			return;
		}
		ARE.getLog().info("loading... SADRE's RuleRuntime done!");
		
		initOK = true;
		
	}
	
	/**
	 * 初始化授权规则引擎
	 * @throws SADREException
	 */
	private static void loadRuleEngine() throws SADREException{

		try {
			// Load the rule service provider of the reference
	        // implementation.
	        // Loading this class will automatically register this
	        // provider with the provider manager.
			Class.forName( "com.amarsoft.sadre.jsr94.RuleServiceProviderImpl" );
			
			// Get the rule service provider from the provider manager.
	        RuleServiceProvider serviceProvider = RuleServiceProviderManager.getRuleServiceProvider( "com.amarsoft.sadre.jsr94" );

	        // get the RuleAdministrator
	        RuleAdministrator ruleAdministrator = serviceProvider.getRuleAdministrator();
	        
	        LocalRuleExecutionSetProvider executionSetProvider = ruleAdministrator.getLocalRuleExecutionSetProvider( null );
	        
	        Iterator<String> tk = RuleScenes.getRuleScenes().keySet().iterator();
	        while(tk.hasNext()){
	        	RuleScene ruleScene = RuleScenes.getRuleScenes().get(tk.next());
	        	
	        	 // parse the ruleset from the ruleScence
	            RuleExecutionSet res = executionSetProvider.createRuleExecutionSet(ruleScene , null );
	            res.setDefaultObjectFilter("com.amarsoft.sadre.jsr94.DecisionFilterImpl");
//	            System.out.println( "Loaded RuleExecutionSet: " + res);
	            
	            //register the RuleExecutionSet
	            String uri = res.getName();
	            ruleAdministrator.registerRuleExecutionSet(uri, res, null );
//	            System.out.println( "Bound RuleExecutionSet to URI: " + uri);
	            
	        }
	        
	        //Get a RuleRuntime and invoke the rule engine.
            ruleRuntime = serviceProvider.getRuleRuntime();
//            System.out.println( "Acquired RuleRuntime: " + ruleRuntime );
	        
		} catch (Exception e){
			ARE.getLog().error(e);
			throw new SADREException(e);
		}

        
	}
	
	/**
	 * 从一个逻辑的名称得到一个数据库连接
	 * 
	 * @param connName  逻辑名称
	 */
	public static Connection getDBConnection()
			throws SQLException {
		return ARE.getDBConnection(database);
	}
	
	public static void setDatabase(String db){
		database = db;
	}
	
	public static boolean isInitOk(){
		return initOK;
	}
	
	/**
	 * 根据授权场景生成规则引擎的执行Session
	 * @param scene
	 * @return
	 * @throws SADREException
	 */
	public static StatelessRuleSession getRuleSession(RuleScene scene) throws SADREException{
		return getRuleSession(scene.getRuleSceneId());
	}
	
	public static StatelessRuleSession getRuleSession(String uri) throws SADREException{
		
        // create a StatelessRuleSession
        StatelessRuleSession statelessRuleSession;
		try {
			
			statelessRuleSession = (StatelessRuleSession) ruleRuntime.createRuleSession(uri, new HashMap(), RuleRuntime.STATELESS_SESSION_TYPE);
//			System.out.println( "Got Stateless Rule Session: " + statelessRuleSession );
			 
		} catch (RuleExecutionSetNotFoundException e) {
			ARE.getLog().error("RuleExecutionSet Not Found!",e);
			return null;
		} catch (Exception e){
			ARE.getLog().error(e);
			throw new SADREException(e);
		}

		return statelessRuleSession;
       
	}
	
	private static Object loadLicense(File licFile){
		Object lic = null;
		ObjectInputStream objIn = null;
		try {
			objIn = new ObjectInputStream(new FileInputStream(licFile));	// 创建对象读取流对象
			try {
				lic = objIn.readObject();// 从对象读取流对象中获得对象
			} catch (ClassNotFoundException e) {
				ARE.getLog().debug("loadLicense faild!",e);
			}
			
		} catch (Exception e1) {
			ARE.getLog().debug("loadLicense faild!",e1);
		}finally {	
			try {
				objIn.close();		// 关闭流
			} catch (IOException e) {
				ARE.getLog().debug("loadLicense faild!",e);
			}
		}
		
		return lic;
	}
	
	public static int getLicenseType(){
		return license.getLicenseType();
	}
	
	public static String getLicenseClient(){
		return license.getLicensedClient();
	}
}
