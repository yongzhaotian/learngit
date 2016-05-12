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
import java.util.HashMap;
import java.util.Map;

import com.amarsoft.app.als.sadre.util.StringUtil;
import com.amarsoft.are.ARE;
import com.amarsoft.sadre.SADREException;
import com.amarsoft.sadre.cache.loader.BasicConfigLoader;
import com.amarsoft.sadre.cache.loader.ConfigLoader;
import com.amarsoft.sadre.rules.aco.ScenePackage;

/**
 * <p>Title: ScenePackages.java </p>
 * <p>Description:  </p>
 * <p>Copyright: Copyright (C) 1999-2011 Amarsoft Ltd. Co.</p> 
 *     
 * @author zllin@amarsoft.com</p>
 * @version </p>
 * @date 2011-5-13 下午04:45:36</p>
 *
 * logs: 1. </p>
 */
public class ScenePackages extends BasicConfigLoader {
	
	/*包含的维度集合*/
	private static Map<String,ScenePackage> packages = new HashMap<String,ScenePackage>();
	
	private PreparedStatement psmt = null;
	
	private volatile static ScenePackages sps = null;
	
	private ScenePackages(){}
	
	public static ConfigLoader getInstance(){
		if(sps == null){
			synchronized (ScenePackages.class){
				if(sps == null){
					sps = new ScenePackages();
				}
			}
		}
		return sps;
	}

	/* (non-Javadoc)
	 * @see com.amarsoft.sadre.rules.common.RuleDataHandler#execute()
	 */
	
	public boolean load(Connection conn) throws SADREException {
		packages.clear();		//赋值前先清空Packages
		
		String sSceneId 	= "";
//		String sSceneName 	= "";
		String sFlows 		= "";
		String sql = "select O.SCENEID,O.SCENENAME,O.FLOWS from SADRE_RULESCENE O,SADRE_SCENERELATIVE R WHERE O.SCENEID=R.SCENEID AND O.STATUS=?";
		try {
			psmt = conn.prepareStatement(sql);
			psmt.setString(1, "1");		//1为有效
			ResultSet resultset = psmt.executeQuery();
			while(resultset.next()){
				sSceneId 	= StringUtil.getString(resultset.getString("SCENEID"));
//				sSceneName 	= StringUtil.getString(resultset.getString("SCENENAME"));
				sFlows 		= StringUtil.getString(resultset.getString("FLOWS"));
				
				if(sFlows==null || sFlows.trim().length()==0) continue;
				
				String[] arFlows = sFlows.split(",");
				for(int f=0; f<arFlows.length; f++){
					ScenePackage pkg = getPackage(arFlows[f]);
					pkg.addRuleScene(sSceneId);
				}
				
			}
			resultset.close();
			
		} catch (SQLException e) {
			e.printStackTrace();
			ARE.getLog().error(e);
			throw new SADREException(e);
		}

		return true;
	}
	
	private ScenePackage getPackage(String pkgId){
		if(packages.containsKey(pkgId)){
			
		}else{
			ScenePackage pkg = new ScenePackage(pkgId);
			packages.put(pkg.getPackageNo(), pkg);
		}
		
		return packages.get(pkgId);
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
	
	public static Map<String,ScenePackage> getScenePackages(){
		return packages;
	}
	
	public static void removeScenePackage(String packageId){
		if(containsScenePackage(packageId)){
			packages.remove(packageId);
			ARE.getLog().info("缓存清理完成!授权方案组编号:"+packageId);
		}else{
			ARE.getLog().warn("删除方案组["+packageId+"]不存在!");
		}
	}
	
	public static void addScenePackage(ScenePackage scenePackage){
		if(containsScenePackage(scenePackage.getPackageNo())){
			ARE.getLog().warn("授权方案组新增失败!原因:["+scenePackage.getPackageNo()+"]已经存在!");
			
		}else{
			packages.put(scenePackage.getPackageNo(), scenePackage);
			ARE.getLog().info("授权方案组缓存新增成功!方案组编号:"+scenePackage.getPackageNo());
		}
		
	}
	
	public static boolean containsScenePackage(String packageId){
		return packages.containsKey(packageId);
	}
	
	public static ScenePackage getScenePackage(String packageId){
		if(containsScenePackage(packageId)){
			return (ScenePackage)packages.get(packageId);
		}
		return null;
	}
	
	
	public void clear() throws SADREException {
		packages.clear();
	}

}
