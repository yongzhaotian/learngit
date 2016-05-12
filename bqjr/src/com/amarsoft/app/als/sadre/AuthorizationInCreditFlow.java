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
package com.amarsoft.app.als.sadre;

import java.util.ArrayList;
import java.util.List;

import com.amarsoft.are.ARE;
import com.amarsoft.are.util.DataConvert;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;
import com.amarsoft.sadre.rules.aco.Decision;
import com.amarsoft.sadre.rules.aco.WorkingObject;
import com.amarsoft.sadre.services.EngineService;

/**
 * <p>Title: AuthorizationInCreditFlow.java </p>
 * <p>Description:  本类作为授权判断校验调用接口示范类,<p>
 * 	实现的是针对授信审批流程中的授权实现(假定前提为角色授权).</p>
 *  对调用接口的细化的目的是,减少在流程引擎中的参数录入。
 * <p>Copyright: Copyright (C) 1999-2011 Amarsoft Ltd. Co.</p> 
 *     
 * @author zllin@amarsoft.com</p>
 * @version </p>
 * @date 2011-5-13 下午10:46:08</p>
 *
 * logs: 1. </p>
 */
public class AuthorizationInCreditFlow extends Bizlet {

	/* (non-Javadoc)
	 * @see com.amarsoft.biz.bizlet.Bizlet#run(com.amarsoft.are.sql.Transaction)
	 */
	@Override
	public Object run(Transaction Sqlca) throws Exception {
		//流程编号
		String flowNo = DataConvert.toString((String)this.getAttribute("FlowNo"));
		//申请业务编号:BUSINESS_APPLY.SerialNo
		String applySerialNo = DataConvert.toString((String)this.getAttribute("ObjectNo"));
		//被授权人角色编号
		String authorizeeRole = DataConvert.toString((String)this.getAttribute("RoleID"));
		//被授权人
		String authorizeeId = DataConvert.toString((String)this.getAttribute("UserID"));
		//被授权人所属机构
		String authorizeeOrg = DataConvert.toString((String)this.getAttribute("OrgID"));
		//System.out.println(flowNo+","+applySerialNo+","+authorizeeRole+","+authorizeeId+","+authorizeeOrg);
		
		//-------维度实例化对象--------
		DefaultSynonymnImpl synonymn = new DefaultSynonymnImpl(applySerialNo,"CreditApply", Sqlca);
		
		//---------------WorkingMemory-------------------
		List<WorkingObject> oWorkingMemory = new ArrayList<WorkingObject>();
		oWorkingMemory.add(synonymn);
		
		Decision decision = EngineService.validateInSceneFlow(flowNo, authorizeeRole, authorizeeId, authorizeeOrg,
					oWorkingMemory);

		ARE.getLog().info("-----------------------"+decision.getDecisionId());
		ARE.getLog().info("-----------------------"+decision.getType());
		switch(decision.getDecision()){
    	case Decision.规则校验_有权规则:
    		ARE.getLog().info("执行结果:通过***********"+decision.getSatisfiedRule());
    		break;
    	case Decision.规则校验_无权规则:
    		ARE.getLog().info("执行结果:拒绝###########");
    		break;
    	default:
    		ARE.getLog().info("执行结果:权限外~~~~~~~~~");
    }
    // Release the session.
	
    System.out.println( "Released Stateless Rule Session." );
		
		//.....
    System.out.println( "String.valueOf(decision.getDecision());="+String.valueOf(decision.getDecision()) );
		return String.valueOf(decision.getDecision());
	}

}
