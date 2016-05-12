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
package com.amarsoft.sadre.rules.aco;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import com.amarsoft.are.ARE;
import com.amarsoft.sadre.cache.RuleScenes;

/**
 * <p>Title: ScenePackage.java </p>
 * <p>Description:  </p>
 * <p>Copyright: Copyright (C) 1999-2011 Amarsoft Ltd. Co.</p> 
 *     
 * @author zllin@amarsoft.com</p>
 * @version </p>
 * @date 2011-5-13 下午04:49:51</p>
 *
 * logs: 1. </p>
 */
public class ScenePackage {
	
	private String packageNo 		= "";
	private String packageName 		= "";
	/*包含的场景集合*/
	private Map<String,RuleScene> packagedScenes = new HashMap<String,RuleScene>();
	
	public ScenePackage(String id){
		this.packageNo = id;
	}

	public String getPackageNo() {
		return packageNo;
	}

	public String getPackageName() {
		return packageName;
	}

	public void setPackageName(String packageName) {
		this.packageName = packageName;
	}
	
	public void setIncludeScenes(String[] includeScenes) {
		packagedScenes.clear();
		for(int i=0;i<includeScenes.length;i++){
			if(RuleScenes.containsRuleScene(includeScenes[i])){
				RuleScene rctmp = RuleScenes.getRuleScene(includeScenes[i]);
				packagedScenes.put(rctmp.getRuleSceneId(), rctmp);
			}else{
				ARE.getLog().debug("方案组中的授权方案["+includeScenes[i]+"]不存在或者无效!");
			}
		}
	}
	
	public void setIncludeScenes(String includeScenes) {
		if(includeScenes!=null && includeScenes.trim().length()>0){
			setIncludeScenes(includeScenes.split(","));
		}
	}
	
	/**
	 * 在授权场景中移除指定的授权场景
	 * @param sceneID
	 */
	public void removeRuleScene(String sceneId){
		if(containsRuleScene(sceneId)){
			packagedScenes.remove(sceneId);
			ARE.getLog().trace("缓存清理完成!授权方案编号:"+sceneId);
		}else{
			ARE.getLog().debug("删除目标方案["+sceneId+"]不存在!");
		}
	}
	
	public void addRuleScene(RuleScene scene){
		if(containsRuleScene(scene.getRuleSceneId())){
			ARE.getLog().debug("授权方案新增失败!原因:["+scene.getRuleSceneId()+"]已经存在!");
			
		}else{
			packagedScenes.put(scene.getRuleSceneId(), scene);
			ARE.getLog().trace("授权方案缓存新增成功!方案编号:"+scene.getRuleSceneId()+"("+getPackageNo()+")");
		}
		
	}
	
	public void addRuleScene(String sceneId){
		RuleScene rctmp = RuleScenes.getRuleScene(sceneId);
		if(rctmp==null){
			ARE.getLog().debug("授权方案["+sceneId+"]不存在!");
			return;
		}
		addRuleScene(rctmp);
	}
	
	/**
	 * 判断是否存在指定的授权场景
	 * @param sceneID
	 * @return
	 */
	public boolean containsRuleScene(String sceneID){
		return packagedScenes.containsKey(sceneID);
	}
	
	/**
	 * 1.根据被授权人角色、被授权人编号和被授权人所属机构,查找获取匹配"该类型下的包含该对象编号的授权方案";<br>
	 * 2.如果没有严格匹配3个参数的授权方案，则检索被授权人角色、被授权人所属机构相匹配的授权方案；<br>
	 * 3.如果没有严格匹配2个参数的授权方案，则检索仅针对被授权人角色的授权方案；<br>
	 * 4.所有条件都不匹配,则返回空列表<p>
	 * 
	 * @param roleId	被授权人角色
	 * @param userId	被授权人编号
	 * @param authOrgId	被授权人所属机构
	 * @return
	 */
	public List<RuleScene> lookupRuleScene(String roleNo, String userId, String authOrgId){
		/*3参检索：角色+人员+机构*/
		List<RuleScene> rs = lookup(roleNo, userId, authOrgId);
		if(rs.size()==0){
			/*2参检索：角色+机构*/
			rs = lookup(roleNo, authOrgId);
			if(rs.size()==0){
				/*1参检索*/
				rs = lookup(roleNo);
			}
		}
		
		return rs;
	}
	
	private List<RuleScene> lookup(String roleNo, String userId, String authOrgId){
		List<RuleScene> satisfiedScene = new ArrayList<RuleScene>();
		Iterator<RuleScene> tk = packagedScenes.values().iterator();
		while(tk.hasNext()){
			RuleScene rsTmp = tk.next();
			
			if(rsTmp.lookupScenceRole(roleNo)){		//当前规则场景中包含有指定角色
				if(userId != null && userId.length()>0
						&& authOrgId != null && authOrgId.length()>0){
					if(!rsTmp.lookupScenceUser(userId) 
							|| !rsTmp.lookupScenceOrg(authOrgId)){
						continue;
					}
					
				}else {
					if(userId==null || userId.length()==0){			//条件中UserId为空,则授权中亦不针对授权人特定授权
						if(!rsTmp.unspecificAuthorizee()){			//仅针对被授权人的方案，不指定所属机构
							continue;
						}
					}else{
						if(!rsTmp.lookupScenceUser(userId)){
							continue;
						}
					}
					
					if(authOrgId==null || authOrgId.length()==0){	//条件中OrgId为空,则授权中亦不针对授权人机构特定授权
						if(!rsTmp.unspecificBelongOrg()){			//仅针对被授权人所属机构,不指定被授权人
							continue;
						}
					}else{
						if(!rsTmp.lookupScenceOrg(authOrgId)){
							continue;
						}
					}
				}
				
				satisfiedScene.add(rsTmp);
			}
			
		}
		return satisfiedScene;

	}
	
	/**
	 * 根据被授权人角色和被授权人所属机构检索授权方案
	 * 
	 * @param roleNo
	 * @param authOrgId
	 * @return
	 */
	private List<RuleScene> lookup(String roleNo,String authOrgId){
		return lookup(roleNo, "", authOrgId);
	}
	
	/**
	 * 根据被授权人角色检索授权方案
	 * 
	 * @param roleNo
	 * @return
	 */
	private List<RuleScene> lookup(String roleNo){
		return lookup(roleNo, "", "");
	}
	
	public String toString(){
		return "Package:{"+packageNo+"|"+packageName+"|Scenes="+packagedScenes.keySet()+"}";
		
	}
}
