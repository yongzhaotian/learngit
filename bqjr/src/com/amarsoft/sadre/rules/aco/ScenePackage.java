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
 * @date 2011-5-13 ����04:49:51</p>
 *
 * logs: 1. </p>
 */
public class ScenePackage {
	
	private String packageNo 		= "";
	private String packageName 		= "";
	/*�����ĳ�������*/
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
				ARE.getLog().debug("�������е���Ȩ����["+includeScenes[i]+"]�����ڻ�����Ч!");
			}
		}
	}
	
	public void setIncludeScenes(String includeScenes) {
		if(includeScenes!=null && includeScenes.trim().length()>0){
			setIncludeScenes(includeScenes.split(","));
		}
	}
	
	/**
	 * ����Ȩ�������Ƴ�ָ������Ȩ����
	 * @param sceneID
	 */
	public void removeRuleScene(String sceneId){
		if(containsRuleScene(sceneId)){
			packagedScenes.remove(sceneId);
			ARE.getLog().trace("�����������!��Ȩ�������:"+sceneId);
		}else{
			ARE.getLog().debug("ɾ��Ŀ�귽��["+sceneId+"]������!");
		}
	}
	
	public void addRuleScene(RuleScene scene){
		if(containsRuleScene(scene.getRuleSceneId())){
			ARE.getLog().debug("��Ȩ��������ʧ��!ԭ��:["+scene.getRuleSceneId()+"]�Ѿ�����!");
			
		}else{
			packagedScenes.put(scene.getRuleSceneId(), scene);
			ARE.getLog().trace("��Ȩ�������������ɹ�!�������:"+scene.getRuleSceneId()+"("+getPackageNo()+")");
		}
		
	}
	
	public void addRuleScene(String sceneId){
		RuleScene rctmp = RuleScenes.getRuleScene(sceneId);
		if(rctmp==null){
			ARE.getLog().debug("��Ȩ����["+sceneId+"]������!");
			return;
		}
		addRuleScene(rctmp);
	}
	
	/**
	 * �ж��Ƿ����ָ������Ȩ����
	 * @param sceneID
	 * @return
	 */
	public boolean containsRuleScene(String sceneID){
		return packagedScenes.containsKey(sceneID);
	}
	
	/**
	 * 1.���ݱ���Ȩ�˽�ɫ������Ȩ�˱�źͱ���Ȩ����������,���һ�ȡƥ��"�������µİ����ö����ŵ���Ȩ����";<br>
	 * 2.���û���ϸ�ƥ��3����������Ȩ���������������Ȩ�˽�ɫ������Ȩ������������ƥ�����Ȩ������<br>
	 * 3.���û���ϸ�ƥ��2����������Ȩ���������������Ա���Ȩ�˽�ɫ����Ȩ������<br>
	 * 4.������������ƥ��,�򷵻ؿ��б�<p>
	 * 
	 * @param roleId	����Ȩ�˽�ɫ
	 * @param userId	����Ȩ�˱��
	 * @param authOrgId	����Ȩ����������
	 * @return
	 */
	public List<RuleScene> lookupRuleScene(String roleNo, String userId, String authOrgId){
		/*3�μ�������ɫ+��Ա+����*/
		List<RuleScene> rs = lookup(roleNo, userId, authOrgId);
		if(rs.size()==0){
			/*2�μ�������ɫ+����*/
			rs = lookup(roleNo, authOrgId);
			if(rs.size()==0){
				/*1�μ���*/
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
			
			if(rsTmp.lookupScenceRole(roleNo)){		//��ǰ���򳡾��а�����ָ����ɫ
				if(userId != null && userId.length()>0
						&& authOrgId != null && authOrgId.length()>0){
					if(!rsTmp.lookupScenceUser(userId) 
							|| !rsTmp.lookupScenceOrg(authOrgId)){
						continue;
					}
					
				}else {
					if(userId==null || userId.length()==0){			//������UserIdΪ��,����Ȩ���಻�����Ȩ���ض���Ȩ
						if(!rsTmp.unspecificAuthorizee()){			//����Ա���Ȩ�˵ķ�������ָ����������
							continue;
						}
					}else{
						if(!rsTmp.lookupScenceUser(userId)){
							continue;
						}
					}
					
					if(authOrgId==null || authOrgId.length()==0){	//������OrgIdΪ��,����Ȩ���಻�����Ȩ�˻����ض���Ȩ
						if(!rsTmp.unspecificBelongOrg()){			//����Ա���Ȩ����������,��ָ������Ȩ��
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
	 * ���ݱ���Ȩ�˽�ɫ�ͱ���Ȩ����������������Ȩ����
	 * 
	 * @param roleNo
	 * @param authOrgId
	 * @return
	 */
	private List<RuleScene> lookup(String roleNo,String authOrgId){
		return lookup(roleNo, "", authOrgId);
	}
	
	/**
	 * ���ݱ���Ȩ�˽�ɫ������Ȩ����
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
