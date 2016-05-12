/*
 * This software is the confidential and proprietary information
 * of Amarsoft, Inc. You shall not disclose such Confidential
 * Information and shall use it only in accordance with the terms
 * of the license agreement you entered into with Amarsoft.
 * 
 * Copyright (c) 1999-2007 Amarsoft, Inc.
 * 23F Building A Fudan University Technology Center,
 * No.11 Guotai Road YangPu District, Shanghai,P.R. China 200433
 * All Rights Reserved.
 * 
 */
package com.amarsoft.sadre.cache;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import com.amarsoft.app.als.sadre.util.StringUtil;
import com.amarsoft.are.ARE;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.sadre.SADREException;
import com.amarsoft.sadre.cache.loader.BasicConfigLoader;
import com.amarsoft.sadre.cache.loader.ConfigLoader;
import com.amarsoft.sadre.rules.aco.RuleScene;

/**
 * <p>Titile: RuleScenes.java</p>
 * <p>Description: 本类为规则场景的常驻缓存对象. </p>
 * 
 * <p>Copyright: Copyright (C) 2006-2011 Amarsoft Ltd. Co.</p> 
 *     
 * @author zllin@amarsoft.com
 * 
 * @date 2011-4-24 下午12:23:47
 *
 * logs: 1. add at 2011-06-22 增加了场景复制功能
 */
public class RuleScenes extends BasicConfigLoader {
	
	public static final int 授权方案_不存在 = -1;
	
	/*包含的维度集合*/
	private static Map<String,RuleScene> ruleScenes = new HashMap<String,RuleScene>();
	
	private PreparedStatement psmt = null;
	
	private volatile static RuleScenes rss = null;
	
	private RuleScenes(){}
	
	public static ConfigLoader getInstance(){
		if(rss == null){
			synchronized (RuleScenes.class){
				if(rss == null){
					rss = new RuleScenes();
				}
			}
		}
		return rss;
	}

	/* (non-Javadoc)
	 * @see com.amarsoft.sadre.rules.common.RuleDataHandler#loadData()
	 */
	
	public boolean load(Connection conn) throws SADREException {
		ruleScenes.clear();		//赋值前先清空rulescene
		
		String sSceneId 		= "";
		String sSceneName  		= "";
		String sIncludes 		= "";
		String sAuthorizeeRole	= "";
		String sAuthorizeeId	= "";
		String sAuthorizeeOrg	= "";
		String sGrantorRole		= "";
		String sGrantorId		= "";
		String sGrantorOrg		= "";
		String sEffectiveDate	= "";
		String sMaturity		= "";
		String sFlows			= "";
		String sql = "select SCENEID,SCENENAME,AUTHORIZEEROLE,AUTHORIZEEID,AUTHORIZEEORG,GRANTORROLE,GRANTORID,GRANTORORG,EFFECTIVEDATE,MATURITY,INCLUDES,FLOWS " +
				"from SADRE_RULESCENE where STATUS=? ";
		try {
			psmt = conn.prepareStatement(sql);
			psmt.setString(1, "1");		//1为有效
			ResultSet resultset = psmt.executeQuery();
			while(resultset.next()){
				sSceneId 		= StringUtil.getString(resultset.getString("SCENEID"));
				sSceneName 		= StringUtil.getString(resultset.getString("SCENENAME"));
				sAuthorizeeRole	= StringUtil.getString(resultset.getString("AUTHORIZEEROLE"));
				sAuthorizeeId	= StringUtil.getString(resultset.getString("AUTHORIZEEID"));
				sAuthorizeeOrg	= StringUtil.getString(resultset.getString("AUTHORIZEEORG"));
				sGrantorRole	= StringUtil.getString(resultset.getString("GRANTORROLE"));
				sGrantorId		= StringUtil.getString(resultset.getString("GRANTORID"));
				sGrantorOrg		= StringUtil.getString(resultset.getString("GRANTORORG"));
				sEffectiveDate	= StringUtil.getString(resultset.getString("EFFECTIVEDATE"));
				sMaturity		= StringUtil.getString(resultset.getString("MATURITY"));
				sIncludes		= StringUtil.getString(resultset.getString("INCLUDES"));
				sFlows			= StringUtil.getString(resultset.getString("FLOWS"));
				
				RuleScene rs = new RuleScene(sSceneId,sSceneName);
				rs.setAuthorizeeRoles(sAuthorizeeRole);
				rs.setAuthorizeeOrgs(sAuthorizeeOrg);
				rs.setAuthorizees(sAuthorizeeId);
				rs.setIncludeDimensions(sIncludes);
				rs.setGrantorOrgs(sGrantorOrg);
				rs.setGrantorRoles(sGrantorRole);
				rs.setGrantors(sGrantorId);
				rs.setEffectiveDate(sEffectiveDate);
				rs.setMaturity(sMaturity);
				rs.setFlows(sFlows);
				
				ruleScenes.put(sSceneId, rs);
			}
			resultset.close();
			
		} catch (SQLException e) {
			e.printStackTrace();
			ARE.getLog().error(e);
			throw new SADREException(e);
		}

		return true;
	}
	
	/**
	 * 在授权场景中移除指定的授权场景
	 * @param sceneID
	 */
	public static void removeRuleScene(String sceneId){
		if(containsRuleScene(sceneId)){
			ruleScenes.remove(sceneId);
			ARE.getLog().info("缓存清理完成!授权方案编号:"+sceneId);
		}else{
			ARE.getLog().warn("删除目标方案["+sceneId+"]不存在!");
		}
	}
	
	public static void addRuleScene(RuleScene scene){
		if(containsRuleScene(scene.getRuleSceneId())){
			ARE.getLog().warn("授权方案新增失败!原因:["+scene.getRuleSceneId()+"]已经存在!");
//			return false;
			
		}else{
			ruleScenes.put(scene.getRuleSceneId(), scene);
			ARE.getLog().info("授权方案缓存新增成功!场景编号:"+scene.getRuleSceneId());
		}
		
//		return true;
	}
	
	/**
	 * 判断是否存在指定的授权场景
	 * @param sceneID
	 * @return
	 */
	public static boolean containsRuleScene(String sceneID){
		return ruleScenes.containsKey(sceneID);
	}
	
	/**
	 * 重新加载指定的授权场景
	 * @param sceneId
	 * @return 如果指定的场景不存在,返回false
	 */
	public static boolean reloadRuleScene(String sceneId){
		if(containsRuleScene(sceneId)){
			getRuleScene(sceneId).reloadRules();
		}
		return false;
	}
	
	/**
	 * 根据场景对象类型查找获取匹配授权场景
	 * @return
	 */
	public static List<RuleScene> lookupRuleScene(String objNo){
		List<RuleScene> satisfiedScene = new ArrayList<RuleScene>();
		Iterator<RuleScene> tk = ruleScenes.values().iterator();
		while(tk.hasNext()){
			RuleScene rsTmp = tk.next();
			String[] sceneRoles = rsTmp.getAuthorizeeRoles();
			for(int i=0; i<sceneRoles.length; i++){
				if(sceneRoles[i].equals(objNo)){
					satisfiedScene.add(rsTmp);
				}
			}
		}
		return satisfiedScene;

	}
	
	/**
	 * 根据场景编号获取授权场景对象
	 * @param sceneId
	 * @return 不存在是返回null
	 */
	public static RuleScene getRuleScene(String sceneId){
		return containsRuleScene(sceneId)?ruleScenes.get(sceneId):null;
	}

	/* (non-Javadoc)
	 * @see com.amarsoft.sadre.rules.common.RuleDataHandler#releaseResource()
	 */
	
	protected void releaseResource() {
		if(psmt!=null){
			try {
				psmt.close();
			} catch (SQLException e) {
				e.printStackTrace();
				ARE.getLog().warn("数据库连接关闭失败!",e);
			}
		}

	}
	
	public static Map<String,RuleScene> getRuleScenes(){
		return ruleScenes;
	}
	
	/**
	 * 复制指定的授权场景
	 * @param sceneId
	 * @param to
	 * @return  19 场景复制失败;<br>
	 *          11 场景复制成功
	 */
	public static int replicateScene(String sceneId,Transaction to) throws SADREException{
		
		if(!RuleScenes.containsRuleScene(sceneId)){
			return 授权方案_不存在;
		}
		
		RuleScene rs = RuleScenes.getRuleScene(sceneId);
		int processStatus = rs.replicate(to);
		if(processStatus==RuleScene.授权方案_复制成功){
			//-------场景复制成功后,重新记载授权场景
			
		}
		
		return processStatus;
	}
	
	
	public void clear() throws SADREException {
		ruleScenes.clear();
	}

}
