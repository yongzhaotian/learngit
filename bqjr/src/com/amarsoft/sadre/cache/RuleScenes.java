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
 * <p>Description: ����Ϊ���򳡾��ĳ�פ�������. </p>
 * 
 * <p>Copyright: Copyright (C) 2006-2011 Amarsoft Ltd. Co.</p> 
 *     
 * @author zllin@amarsoft.com
 * 
 * @date 2011-4-24 ����12:23:47
 *
 * logs: 1. add at 2011-06-22 �����˳������ƹ���
 */
public class RuleScenes extends BasicConfigLoader {
	
	public static final int ��Ȩ����_������ = -1;
	
	/*������ά�ȼ���*/
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
		ruleScenes.clear();		//��ֵǰ�����rulescene
		
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
			psmt.setString(1, "1");		//1Ϊ��Ч
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
	 * ����Ȩ�������Ƴ�ָ������Ȩ����
	 * @param sceneID
	 */
	public static void removeRuleScene(String sceneId){
		if(containsRuleScene(sceneId)){
			ruleScenes.remove(sceneId);
			ARE.getLog().info("�����������!��Ȩ�������:"+sceneId);
		}else{
			ARE.getLog().warn("ɾ��Ŀ�귽��["+sceneId+"]������!");
		}
	}
	
	public static void addRuleScene(RuleScene scene){
		if(containsRuleScene(scene.getRuleSceneId())){
			ARE.getLog().warn("��Ȩ��������ʧ��!ԭ��:["+scene.getRuleSceneId()+"]�Ѿ�����!");
//			return false;
			
		}else{
			ruleScenes.put(scene.getRuleSceneId(), scene);
			ARE.getLog().info("��Ȩ�������������ɹ�!�������:"+scene.getRuleSceneId());
		}
		
//		return true;
	}
	
	/**
	 * �ж��Ƿ����ָ������Ȩ����
	 * @param sceneID
	 * @return
	 */
	public static boolean containsRuleScene(String sceneID){
		return ruleScenes.containsKey(sceneID);
	}
	
	/**
	 * ���¼���ָ������Ȩ����
	 * @param sceneId
	 * @return ���ָ���ĳ���������,����false
	 */
	public static boolean reloadRuleScene(String sceneId){
		if(containsRuleScene(sceneId)){
			getRuleScene(sceneId).reloadRules();
		}
		return false;
	}
	
	/**
	 * ���ݳ����������Ͳ��һ�ȡƥ����Ȩ����
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
	 * ���ݳ�����Ż�ȡ��Ȩ��������
	 * @param sceneId
	 * @return �������Ƿ���null
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
				ARE.getLog().warn("���ݿ����ӹر�ʧ��!",e);
			}
		}

	}
	
	public static Map<String,RuleScene> getRuleScenes(){
		return ruleScenes;
	}
	
	/**
	 * ����ָ������Ȩ����
	 * @param sceneId
	 * @param to
	 * @return  19 ��������ʧ��;<br>
	 *          11 �������Ƴɹ�
	 */
	public static int replicateScene(String sceneId,Transaction to) throws SADREException{
		
		if(!RuleScenes.containsRuleScene(sceneId)){
			return ��Ȩ����_������;
		}
		
		RuleScene rs = RuleScenes.getRuleScene(sceneId);
		int processStatus = rs.replicate(to);
		if(processStatus==RuleScene.��Ȩ����_���Ƴɹ�){
			//-------�������Ƴɹ���,���¼�����Ȩ����
			
		}
		
		return processStatus;
	}
	
	
	public void clear() throws SADREException {
		ruleScenes.clear();
	}

}
