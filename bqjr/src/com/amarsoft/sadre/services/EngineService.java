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
 * @date 2011-5-13 下午10:08:40</p>
 *
 * logs: 1. </p>
 */
public class EngineService {
	
	public static final int 授权判断结果_异常 	 	= -1;
	public static final int 授权判断结果_参数非法 	= 9;
	public static final int 授权判断结果_无权规则 	= Decision.规则校验_无权规则;		//0
	public static final int 授权判断结果_有权规则 	= Decision.规则校验_有权规则;		//1
	public static final int 授权判断结果_授权外 		= Decision.规则校验_未设定规则;		//3
	
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
	 * 根据流程编号及指定角色,用户,机构获取授权判断结果
	 * @param flowNo			当前流程编号
	 * @param authorizeeRole	当前流程节点角色/岗位编号
	 * @param authorizeeId		当前用户编号
	 * @param authorizeeOrg		当前用户所属机构
	 * @param workingMemory     授权参数载体实现类列表
	 * @return 规则执行结果
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
			
			//-----根据场景对象类型和授权对象编号,获取"该类型下的包含该对象编号的授权场景";
			//-----1.当授权所属机构为空,则取满足条件的第一个授权场景
			List<RuleScene> scenes = packages.lookupRuleScene(authorizeeRole, authorizeeId, authorizeeOrg);
			
			if(scenes.size()==0){
				ARE.getLog().warn("无满足该条件下[role="+authorizeeRole+"|org="+authorizeeOrg+"|userId="+authorizeeId+"]的授权方案!");
				decision = new Decision();
				decision.setDecision(授权判断结果_授权外);
				
			}else{
				RuleScene exeScene = scenes.get(0);
				ARE.getLog().trace("满足条件[flowNo="+flowNo+"|role="+authorizeeRole+"|org="+authorizeeOrg+"|userId="+authorizeeId+"]下的授权方案为:"+exeScene.getRuleSceneName());
				decision = validateScene(exeScene, workingMemory);
			}
			
		}else{
			ARE.getLog().warn("针对流程["+flowNo+"]无可用配置授权规则或者为无效状态!");
			decision = new Decision();
			decision.setDecision(授权判断结果_参数非法);
		}
		
		return decision;
	}
	
	/**
	 * 
	 * @param flowNo			适用流程编号
	 * @param authorizeeRole	被授权人角色
	 * @param authorizeeId		被授权人编号ID
	 * @param authorizeeOrg		被授权人所属机构
	 * @param workingMemory
	 * @param out               jsp输出控制
	 * @return 规则执行结果
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
			
			//-----根据场景对象类型和授权对象编号,获取"该类型下的包含该对象编号的授权场景";
			//-----1.当授权所属机构为空,则取满足条件的第一个授权场景
			List<RuleScene> scenes = packages.lookupRuleScene(authorizeeRole, authorizeeId, authorizeeOrg);
			
			if(scenes.size()==0){
				ARE.getLog().warn("无满足该条件下[role="+authorizeeRole+"|org="+authorizeeOrg+"|userId="+authorizeeId+"]的授权方案!");
				decision = new Decision();
				decision.setDecision(授权判断结果_授权外);
				
			}else{
				RuleScene exeScene = scenes.get(0);
				ARE.getLog().trace("满足条件[flowNo="+flowNo+"|role="+authorizeeRole+"|org="+authorizeeOrg+"|userId="+authorizeeId+"]下的授权方案为:"+exeScene.getRuleSceneName());
				decision = validateScene(exeScene, workingMemory, out);
			}
			
		}else{
			ARE.getLog().warn("针对流程["+flowNo+"]无可用配置授权规则或者为无效状态!");
			decision = new Decision();
			decision.setDecision(授权判断结果_参数非法);
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
			throw new SADREException("授权场景["+scene.getRuleSceneName()+"]校验执行失败!",e);
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
	 * 通过维度实例校验指定授权场景
	 * @param scene  授权场景
	 * @param workingMemory 维度实例
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
			throw new SADREException("授权场景["+scene.getRuleSceneName()+"]校验执行失败!",e);
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
			throw new SADREException("授权场景["+sceneId+"]不存在或者为无效!");
		}
		
		RuleScene rs = RuleScenes.getRuleScene(sceneId);
		
		return validateScene(rs, workingMemory, out);
	}
}
