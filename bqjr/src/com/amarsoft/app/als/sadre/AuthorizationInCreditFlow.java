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
 * <p>Description:  ������Ϊ��Ȩ�ж�У����ýӿ�ʾ����,<p>
 * 	ʵ�ֵ�������������������е���Ȩʵ��(�ٶ�ǰ��Ϊ��ɫ��Ȩ).</p>
 *  �Ե��ýӿڵ�ϸ����Ŀ����,���������������еĲ���¼�롣
 * <p>Copyright: Copyright (C) 1999-2011 Amarsoft Ltd. Co.</p> 
 *     
 * @author zllin@amarsoft.com</p>
 * @version </p>
 * @date 2011-5-13 ����10:46:08</p>
 *
 * logs: 1. </p>
 */
public class AuthorizationInCreditFlow extends Bizlet {

	/* (non-Javadoc)
	 * @see com.amarsoft.biz.bizlet.Bizlet#run(com.amarsoft.are.sql.Transaction)
	 */
	@Override
	public Object run(Transaction Sqlca) throws Exception {
		//���̱��
		String flowNo = DataConvert.toString((String)this.getAttribute("FlowNo"));
		//����ҵ����:BUSINESS_APPLY.SerialNo
		String applySerialNo = DataConvert.toString((String)this.getAttribute("ObjectNo"));
		//����Ȩ�˽�ɫ���
		String authorizeeRole = DataConvert.toString((String)this.getAttribute("RoleID"));
		//����Ȩ��
		String authorizeeId = DataConvert.toString((String)this.getAttribute("UserID"));
		//����Ȩ����������
		String authorizeeOrg = DataConvert.toString((String)this.getAttribute("OrgID"));
		//System.out.println(flowNo+","+applySerialNo+","+authorizeeRole+","+authorizeeId+","+authorizeeOrg);
		
		//-------ά��ʵ��������--------
		DefaultSynonymnImpl synonymn = new DefaultSynonymnImpl(applySerialNo,"CreditApply", Sqlca);
		
		//---------------WorkingMemory-------------------
		List<WorkingObject> oWorkingMemory = new ArrayList<WorkingObject>();
		oWorkingMemory.add(synonymn);
		
		Decision decision = EngineService.validateInSceneFlow(flowNo, authorizeeRole, authorizeeId, authorizeeOrg,
					oWorkingMemory);

		ARE.getLog().info("-----------------------"+decision.getDecisionId());
		ARE.getLog().info("-----------------------"+decision.getType());
		switch(decision.getDecision()){
    	case Decision.����У��_��Ȩ����:
    		ARE.getLog().info("ִ�н��:ͨ��***********"+decision.getSatisfiedRule());
    		break;
    	case Decision.����У��_��Ȩ����:
    		ARE.getLog().info("ִ�н��:�ܾ�###########");
    		break;
    	default:
    		ARE.getLog().info("ִ�н��:Ȩ����~~~~~~~~~");
    }
    // Release the session.
	
    System.out.println( "Released Stateless Rule Session." );
		
		//.....
    System.out.println( "String.valueOf(decision.getDecision());="+String.valueOf(decision.getDecision()) );
		return String.valueOf(decision.getDecision());
	}

}
