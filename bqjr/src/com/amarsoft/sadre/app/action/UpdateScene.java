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
package com.amarsoft.sadre.app.action;

import com.amarsoft.app.als.sadre.util.StringUtil;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.sadre.SADREException;
import com.amarsoft.sadre.cache.RuleScenes;
import com.amarsoft.sadre.rules.aco.RuleScene;

/**
 * <p>Titile: SADREUpdateScene.java</p>
 * <p>Description: 本类为规则场景新增/更新操作时对常驻内存对象的刷新. </p>
 * 
 * <p>Copyright: Copyright (C) 2006-2011 Amarsoft Ltd. Co.</p> 
 *     
 * @author zllin@amarsoft.com
 * 
 * @date 2011-5-12 下午12:23:47
 *
 * logs: 1. 
 */
public class UpdateScene extends BasicWebAction {
	private String sceneId = "";

	public String getSceneId() {
		return sceneId==null?"":sceneId;
	}

	public void setSceneId(String sceneId) {
		this.sceneId = sceneId;
	}

	/* (non-Javadoc)
	 * @see com.amarsoft.biz.bizlet.Bizlet#run(com.amarsoft.are.sql.Transaction)
	 */
	
	public int execute(Transaction Sqlca) throws SADREException {
		/**
		 * 场景编号
		 */
		String sSceneId 		= getSceneId();
		String sSceneName  		= "";
		String sAuthorizeeRole 	= "";
		String sAuthorizeeId 	= "";
		String sAuthorizeeOrg 	= "";
		String sGrantorRole 	= "";
		String sGrantorId 		= "";
		String sGrantorOrg 		= "";
		String sEffectiveDate 	= "";
		String sMaturity 		= "";
		String sFlows 			= "";
		String sIncludes 		= "";
		String sStatus			= "";
		
		if(sSceneId==null||sSceneId.length()==0) throw new SADREException("授权场景更新失败!原因:场景编号为空");
		/**/
		try {
			String sql = "select SCENEID,SCENENAME,AUTHORIZEEROLE,AUTHORIZEEID,AUTHORIZEEORG,GRANTORROLE,GRANTORID,GRANTORORG,EFFECTIVEDATE,MATURITY,INCLUDES,STATUS,FLOWS " +
					"from SADRE_RULESCENE where SCENEID='"+sSceneId+"' ";
			ASResultSet resultset = Sqlca.getASResultSet(sql);
			if(resultset.next()){
				sSceneName 		 = StringUtil.getString(resultset.getString("SCENENAME"));
				sAuthorizeeRole  = StringUtil.getString(resultset.getString("AUTHORIZEEROLE"));
				sAuthorizeeId 	 = StringUtil.getString(resultset.getString("AUTHORIZEEID"));
				sAuthorizeeOrg 	 = StringUtil.getString(resultset.getString("AUTHORIZEEORG"));
				sGrantorRole 	 = StringUtil.getString(resultset.getString("GRANTORROLE"));
				sGrantorId 		 = StringUtil.getString(resultset.getString("GRANTORID"));
				sGrantorOrg 	 = StringUtil.getString(resultset.getString("GRANTORORG"));
				sEffectiveDate 	 = StringUtil.getString(resultset.getString("EFFECTIVEDATE"));
				sMaturity 	 	 = StringUtil.getString(resultset.getString("MATURITY"));
				sIncludes		 = StringUtil.getString(resultset.getString("INCLUDES"));
				sStatus			 = StringUtil.getString(resultset.getString("STATUS"));
				sFlows			 = StringUtil.getString(resultset.getString("FLOWS"));
			}
			resultset.getStatement().close();
		} catch (Exception e) {
			throw new SADREException(e);
		}
		
		/*JBO等价实现
		try {
			BizObjectManager bom = JBOFactory.getBizObjectManager("jbo.app.sadre.RULESCENE");
			tx.join(bom);			//必须加入事务,否则取出的是更新前的数据
			
			BizObjectQuery bq = bom.createQuery("SCENEID=:SCENEID");
			bq.setParameter("SCENEID", sSceneId);
			BizObject bo = bq.getSingleResult(false);
			if(bo != null){
				sSceneName 		 = StringUtil.getString(bo.getAttribute("SCENENAME").getString());
				sAuthorizeeRole  = StringUtil.getString(bo.getAttribute("AUTHORIZEEROLE").getString());
				sAuthorizeeId 	 = StringUtil.getString(bo.getAttribute("AUTHORIZEEID").getString());
				sAuthorizeeOrg 	 = StringUtil.getString(bo.getAttribute("AUTHORIZEEORG").getString());
				sGrantorRole 	 = StringUtil.getString(bo.getAttribute("GRANTORROLE").getString());
				sGrantorId 		 = StringUtil.getString(bo.getAttribute("GRANTORID").getString());
				sGrantorOrg 	 = StringUtil.getString(bo.getAttribute("GRANTORORG").getString());
				sEffectiveDate 	 = StringUtil.getString(bo.getAttribute("EFFECTIVEDATE").getString());
				sMaturity 	 	 = StringUtil.getString(bo.getAttribute("MATURITY").getString());
				sIncludes		 = StringUtil.getString(bo.getAttribute("INCLUDES").getString());
				sStatus			 = StringUtil.getString(bo.getAttribute("STATUS").getString());
				sFlows			 = StringUtil.getString(bo.getAttribute("FLOWS").getString());
			}
		} catch (JBOException e) {
			throw new SADREException(e);
		}
		*/
		log.trace("SceneId		="+sSceneId);
		log.trace("SceneName		="+sSceneName);
		log.trace("AuthorizeeRole	="+sAuthorizeeRole);
		log.trace("AuthorizeeId	="+sAuthorizeeId);
		log.trace("AuthorizeeOrg	="+sAuthorizeeOrg);
		log.trace("GrantorRole		="+sGrantorRole);
		log.trace("GrantorId		="+sGrantorId);
		log.trace("sGrantorOrg		="+sGrantorOrg);
		log.trace("EffectiveDate	="+sEffectiveDate);
		log.trace("Maturity		="+sMaturity);
		log.trace("Includes		="+sIncludes);
		log.trace("Status		="+sStatus);
		log.trace("Flows		="+sFlows);
		
		if(RuleScenes.containsRuleScene(sSceneId)){		//更新操作 
			if(sStatus.equalsIgnoreCase("2")){		//1为有效
				log.info("授权场景更新为'无效'!场景编号:"+sSceneId);
				RuleScenes.removeRuleScene(sSceneId);
				
			}else{
				
				RuleScene ruleScene = RuleScenes.getRuleScene(sSceneId);
				ruleScene.setAuthorizeeRoles(sAuthorizeeRole);
				ruleScene.setAuthorizees(sAuthorizeeId);
				ruleScene.setAuthorizeeOrgs(sAuthorizeeOrg);
				ruleScene.setGrantorRoles(sGrantorRole);
				ruleScene.setGrantors(sGrantorId);
				ruleScene.setGrantorOrgs(sGrantorOrg);
				ruleScene.setEffectiveDate(sEffectiveDate);
				ruleScene.setMaturity(sMaturity);
				ruleScene.setIncludeDimensions(sIncludes);
				ruleScene.setFlows(sFlows);
				
			}
//			
			
		}else{		//新增操作
			RuleScene rs = new RuleScene(sSceneId, sSceneName);
			rs.setAuthorizeeRoles(sAuthorizeeRole);
			rs.setAuthorizees(sAuthorizeeId);
			rs.setAuthorizeeOrgs(sAuthorizeeOrg);
			rs.setGrantorRoles(sGrantorRole);
			rs.setGrantors(sGrantorId);
			rs.setGrantorOrgs(sGrantorOrg);
			rs.setEffectiveDate(sEffectiveDate);
			rs.setMaturity(sMaturity);
			rs.setIncludeDimensions(sIncludes);
			rs.setFlows(sFlows);
			
			RuleScenes.addRuleScene(rs);
			
		}
		
		return WEB_ACTION_成功;
	}
}
