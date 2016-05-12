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
package com.amarsoft.app.als.sadre.model.impl;

import com.amarsoft.app.als.sadre.DefaultSynonymnImpl;
import com.amarsoft.app.als.sadre.model.OccupiedBasicUnit;
import com.amarsoft.app.als.sadre.simplebo.BusinessContract;
import com.amarsoft.sadre.SADREException;

/**
 * <p>Title: CustomerRiskGapImpl.java </p>
 * <p>Description: �ͻ�����ҵ��ĵ�������DEMO: ����ҵ��+����ҵ��ĳ������������ </p>
 * <p>Copyright: Copyright (C) 1999-2011 Amarsoft Ltd. Co.</p> 
 *     
 * @author zllin@amarsoft.com</p>
 * @version </p>
 * @date 2011-6-24 ����9:42:10</p>
 *
 * logs: 1. </p>
 */
public class CustomerRiskGapImpl extends OccupiedBasicUnit {
	
	public CustomerRiskGapImpl(DefaultSynonymnImpl synonymn){
		this.synonymn = synonymn;
	}
	
	/* (non-Javadoc)
	 * @see mybank.app.fudian.dimensions.OccupiedBasicUnit#filterContract(mybank.app.fudian.sbo.BusinessContract)
	 */
	@Override
	public boolean filterContract(BusinessContract contract) throws SADREException {
//		����ÿͻ���ҵ��Χ���������
		if(contract.getBusinessType().startsWith("3")){
			return false;
		}	
		
		return true;
	}
	
	/**
	 * ��������Ȳ��ֵļ���
	 */
	protected double occurValidCreditLine() throws SADREException{
		return 0.0D;
	}

}
