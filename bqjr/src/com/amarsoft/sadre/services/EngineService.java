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
package com.amarsoft.sadre.services;

import java.io.Writer;
import java.util.List;

import javax.rules.StatelessRuleSession;

import com.amarsoft.are.ARE;
import com.amarsoft.sadre.SADREException;
import com.amarsoft.sadre.cache.RuleScenes;
import com.amarsoft.sadre.cache.ScenePackages;
import com.amarsoft.sadre.jsr94.StatelessRuleSessionImpl;
import com.amarsoft.sadre.rules.aco.Decision;
import com.amarsoft.sadre.rules.aco.RuleScene;
import com.amarsoft.sadre.rules.aco.ScenePackage;
import com.amarsoft.sadre.rules.aco.WorkingObject;

/**
 * <p>Title: EngineService.java </p>
 * <p>Description:  </p>
 * <p>Copyright: Copyright (C) 1999-2011 Amarsoft Ltd. Co.</p> 
 *     
 * @author zllin@amarsoft.com</p>
 * @version </p>
 * @date 2011-5-13 ����10:08:40</p>
 *
 * logs: 1. </p>
 */
public class EngineService {
	
	public static final int ��Ȩ�жϽ��_�쳣 	 	= -1;
	public static final int ��Ȩ�жϽ��_�����Ƿ� 	= 9;
	public static final int ��Ȩ�жϽ��_��Ȩ���� 	= Decision.����У��_��Ȩ����;		//0
	public static final int ��Ȩ�жϽ��_��Ȩ���� 	= Decision.����У��_��Ȩ����;		//1
	public static final int ��Ȩ�жϽ��_��Ȩ�� 		= Decision.����У��_δ�趨����;		//3
	
	/**
	 * 
	 * @param flowNo
	 * @param authorizeeRole
	 * @param workingMemory
	 * @return
	 * @throws SADREException
	 */
	public static Decision validateInSceneFlow(String flowNo,
			String authorizeeRole, 
			List<WorkingObject> workingMemory) throws SADREException{
		return validateInSceneFlow(flowNo,authorizeeRole,"",workingMemory);
	}
	
	/**
	 * 
	 * @param flowNo
	 * @param authorizeeRole
	 * @param authorizeeId
	 * @param workingMemory
	 * @return
	 * @throws SADREException
	 */
	public static Decision validateInSceneFlow(String flowNo,
			String authorizeeRole,
			String authorizeeId,
			List<WorkingObject> workingMemory) throws SADREException{
		return validateInSceneFlow(flowNo,authorizeeRole,authorizeeId,"",workingMemory);
	}
	
	/**
	 * �������̱�ż�ָ����ɫ,�û�,������ȡ��Ȩ�жϽ��
	 * @param flowNo			��ǰ���̱��
	 * @param authorizeeRole	��ǰ���̽ڵ��ɫ/��λ���
	 * @param authorizeeId		��ǰ�û����
	 * @param authorizeeOrg		��ǰ�û���������
	 * @param workingMemory     ��Ȩ��������ʵ�����б�
	 * @return ����ִ�н��
	 * @throws SADREException
	 */
	public static Decision validateInSceneFlow(String flowNo,
			String authorizeeRole, 
			String authorizeeId,
			String authorizeeOrg,
			List<WorkingObject> workingMemory) throws SADREException{
		
		Decision decision = null;
		if(ScenePackages.containsScenePackage(flowNo)){
			ScenePackage packages = ScenePackages.getScenePackage(flowNo);
			
			//-----���ݳ����������ͺ���Ȩ������,��ȡ"�������µİ����ö����ŵ���Ȩ����";
			//-----1.����Ȩ��������Ϊ��,��ȡ���������ĵ�һ����Ȩ����
			List<RuleScene> scenes = packages.lookupRuleScene(authorizeeRole, authorizeeId, authorizeeOrg);
			
			if(scenes.size()==0){
				ARE.getLog().warn("�������������[role="+authorizeeRole+"|org="+authorizeeOrg+"|userId="+authorizeeId+"]����Ȩ����!");
				decision = new Decision();
				decision.setDecision(��Ȩ�жϽ��_��Ȩ��);
				
			}else{
				RuleScene exeScene = scenes.get(0);
				ARE.getLog().trace("��������[flowNo="+flowNo+"|role="+authorizeeRole+"|org="+authorizeeOrg+"|userId="+authorizeeId+"]�µ���Ȩ����Ϊ:"+exeScene.getRuleSceneName());
				decision = validateScene(exeScene, workingMemory);
			}
			
		}else{
			ARE.getLog().warn("�������["+flowNo+"]�޿���������Ȩ�������Ϊ��Ч״̬!");
			decision = new Decision();
			decision.setDecision(��Ȩ�жϽ��_�����Ƿ�);
		}
		
		return decision;
	}
	
	/**
	 * 
	 * @param flowNo			�������̱��
	 * @param authorizeeRole	����Ȩ�˽�ɫ
	 * @param authorizeeId		����Ȩ�˱��ID
	 * @param authorizeeOrg		����Ȩ����������
	 * @param workingMemory
	 * @param out               jsp�������
	 * @return ����ִ�н��
	 * @throws SADREException
	 */
	public static Decision validateInSceneFlow(String flowNo,
			String authorizeeRole, 
			String authorizeeId,
			String authorizeeOrg,
			List<WorkingObject> workingMemory,Writer out) throws SADREException{
		
		Decision decision = null;
		if(ScenePackages.containsScenePackage(flowNo)){
			ScenePackage packages = ScenePackages.getScenePackage(flowNo);
			
			//-----���ݳ����������ͺ���Ȩ������,��ȡ"�������µİ����ö����ŵ���Ȩ����";
			//-----1.����Ȩ��������Ϊ��,��ȡ���������ĵ�һ����Ȩ����
			List<RuleScene> scenes = packages.lookupRuleScene(authorizeeRole, authorizeeId, authorizeeOrg);
			
			if(scenes.size()==0){
				ARE.getLog().warn("�������������[role="+authorizeeRole+"|org="+authorizeeOrg+"|userId="+authorizeeId+"]����Ȩ����!");
				decision = new Decision();
				decision.setDecision(��Ȩ�жϽ��_��Ȩ��);
				
			}else{
				RuleScene exeScene = scenes.get(0);
				ARE.getLog().trace("��������[flowNo="+flowNo+"|role="+authorizeeRole+"|org="+authorizeeOrg+"|userId="+authorizeeId+"]�µ���Ȩ����Ϊ:"+exeScene.getRuleSceneName());
				decision = validateScene(exeScene, workingMemory, out);
			}
			
		}else{
			ARE.getLog().warn("�������["+flowNo+"]�޿���������Ȩ�������Ϊ��Ч״̬!");
			decision = new Decision();
			decision.setDecision(��Ȩ�жϽ��_�����Ƿ�);
		}
		
		return decision;
	}
	
	
	/**
	 * 
	 * @param scene
	 * @param workingMemory
	 * @param out
	 * @return
	 * @throws SADREException
	 */
	public static Decision validateScene(RuleScene scene,
			List<WorkingObject> workingMemory, Writer out) throws SADREException {
		
		StatelessRuleSessionImpl statelessRuleSession = (StatelessRuleSessionImpl)SADREService.getRuleSession(scene);
		
		// Execute the rules with decision-filter.
        List<Decision> results = null;
		try {
			results = statelessRuleSession.executeRules(workingMemory, out);
			
		} catch (Exception e) {
			ARE.getLog().error(e);
			throw new SADREException("��Ȩ����["+scene.getRuleSceneName()+"]У��ִ��ʧ��!",e);
		}finally{
			try {
				// Release the session.
				statelessRuleSession.release();
			} catch (Exception e) {
				ARE.getLog().debug("RuleSession.release()",e);
			}
		}
        
		Decision decision = (Decision)results.get(0);
		
//		return decision.getDecision();
		return decision;
	}
	
	/**
	 * ͨ��ά��ʵ��У��ָ����Ȩ����
	 * @param scene  ��Ȩ����
	 * @param workingMemory ά��ʵ��
	 * @return
	 * @throws SADREException 
	 */
	public static Decision validateScene(RuleScene scene,
			List<WorkingObject> workingMemory) throws SADREException {
		
		StatelessRuleSession statelessRuleSession = SADREService.getRuleSession(scene);
		
		// Execute the rules with decision-filter.
        List<Decision> results = null;
		try {
			results = statelessRuleSession.executeRules(workingMemory);
			
			// Release the session.
			statelessRuleSession.release();
		} catch (Exception e) {
			ARE.getLog().error(e);
			throw new SADREException("��Ȩ����["+scene.getRuleSceneName()+"]У��ִ��ʧ��!",e);
		}
        
		Decision decision = (Decision)results.get(0);
//        
//		return decision.getDecision();
		return decision;
	}
	
	/**
	 * 
	 * @param sceneId
	 * @param workingMemory
	 * @return
	 * @throws SADREException
	 */
	public static Decision validateScene(String sceneId,
			List<WorkingObject> workingMemory) throws SADREException {

		return validateScene(sceneId, workingMemory, null);
	}
	
	public static Decision validateScene(String sceneId,
			List<WorkingObject> workingMemory, Writer out) throws SADREException {
		if(!RuleScenes.containsRuleScene(sceneId)){
			throw new SADREException("��Ȩ����["+sceneId+"]�����ڻ���Ϊ��Ч!");
		}
		
		RuleScene rs = RuleScenes.getRuleScene(sceneId);
		
		return validateScene(rs, workingMemory, out);
	}
}
