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
package com.amarsoft.sadre.cache;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import com.amarsoft.are.ARE;
import com.amarsoft.sadre.SADREException;
import com.amarsoft.sadre.cache.loader.BasicConfigLoader;
import com.amarsoft.sadre.cache.loader.ConfigLoader;
import com.amarsoft.sadre.rules.aco.Synonymn;

 /**
 * <p>Title: Synonymns.java </p>
 * <p>Description:  </p>
 * <p>Copyright: Copyright (C) 2006-2011 Amarsoft Ltd. Co.</p> 
 *     
 * @author zllin@amarsoft.com
 * @version 
 * @date 2011-4-15 上午10:37:41
 *
 * logs: 1. 
 */
public final class Synonymns extends BasicConfigLoader{
	
	/*包含的BOM对象映射关系*/
	private static Map<String,Synonymn> synonymns = new HashMap<String,Synonymn>();
	
	private PreparedStatement psmt = null;
	
	private volatile static Synonymns sms = null;
	
	private Synonymns(){}
	
	public static ConfigLoader getInstance(){
		if(sms == null){
			synchronized (Synonymns.class){
				if(sms == null){
					sms = new Synonymns();
				}
			}
		}
		return sms;
	}
	
	public boolean load(Connection conn) throws SADREException {
		synonymns.clear();		//赋值前先清空synonymns
		
		String sSynonymnId 	 = "";
		String sSynonymnName = "";
		String sSynonymnImpl = "";
		String sql = "select SYNONYMNID,SYNONYMNNAME,SYNONYMNIMPL from SADRE_SYNONYMN";
		try {
			psmt = conn.prepareStatement(sql);
			ResultSet resultset = psmt.executeQuery();
			while(resultset.next()){
				sSynonymnId   = resultset.getString("SynonymnId");
				sSynonymnName = resultset.getString("SynonymnName");
				sSynonymnImpl = resultset.getString("SynonymnImpl");
				
				Synonymn snm = new Synonymn(sSynonymnId,sSynonymnName);
				snm.setImpl(sSynonymnImpl);
				//----------put it into cache
				synonymns.put(sSynonymnId, snm);
			}
			resultset.close();
			
		} catch (SQLException e) {
			e.printStackTrace();
			ARE.getLog().error(e);
			throw new SADREException(e);
		}
		
		return true;
	}
	
	public static void removeSynonymn(String synonymnId){
		if(containsSynonymn(synonymnId)){
			synonymns.remove(synonymnId);
			ARE.getLog().info("缓存清理完成!授权BOM编号:"+synonymnId);
		}else{
			ARE.getLog().warn("删除目标BOM["+synonymnId+"]不存在!");
		}
	}
	
	public static void addSynonymn(Synonymn synonymn){
		if(containsSynonymn(synonymn.getId())){
			ARE.getLog().warn("授权BOM新增失败!原因:["+synonymn.getId()+"]已经存在!");
			
		}else{
			synonymns.put(synonymn.getId(), synonymn);
			ARE.getLog().info("授权BOM缓存新增成功!BOM编号:"+synonymn.getId());
		}
		
	}

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
	
	public static boolean containsSynonymn(String synonymnID){
		return synonymns.containsKey(synonymnID);
	}
	
	public static Synonymn getSynonymn(String key){
		if(containsSynonymn(key)){
			return (Synonymn)synonymns.get(key);
		}
		return null;
	}
	
	public static Map<String,Synonymn> getSynonymns(){
		return synonymns;
	}
	
	
	public void clear() throws SADREException {
		synonymns.clear();
	}
		
}
