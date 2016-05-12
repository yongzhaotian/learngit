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
 * <p>Title: CustomerTotalImpl.java </p>
 * <p>Description: �ͻ�����ҵ��ĵ�������DEMO: ��Ч���ȡ���+��Чҵ�񣨺�����+���£���� </p>
 * <p>Copyright: Copyright (C) 1999-2011 Amarsoft Ltd. Co.</p> 
 *     
 * @author zllin@amarsoft.com</p>
 * @version </p>
 * @date 2011-6-24 ����9:42:10</p>
 *
 * logs: 1. </p>
 */
public class CustomerTotalImpl extends OccupiedBasicUnit {
	
	public CustomerTotalImpl(DefaultSynonymnImpl synonymn){
		this.synonymn = synonymn;
	}

	@Override
	public boolean filterContract(BusinessContract contract)
			throws SADREException {
		
		return true;		//������Чҵ������ͳ�Ʒ�Χ
	}
	
	/**
	 * ���Ǹ���ֻͳ�Ƴ��ڵļ��㣬��Ϊͳ�����н��
	 */
	@Override
	protected double calcIndependence(BusinessContract bc) throws SADREException{
		if(!bc.getBusinessType().startsWith("3")){	//�������
			return bc.getBusinessSum();
		}
		return 0.0D;
	}

}
