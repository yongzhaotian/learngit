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
package com.amarsoft.app.als.sadre.simplebo;

import java.util.ArrayList;
import java.util.List;

import com.amarsoft.app.als.sadre.util.StringUtil;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.sadre.SADREException;

 /**
 * @ IndInfo.java
 * DESCRIPT: 个人概况对象实现类
 *     
 * @author zllin@amarsoft.com
 * 
 * @date 2011-3-29 下午03:37:44
 *
 * logs: 1. 
 */
public class IndInfo extends CustomerInfo{
	
	/**
	 * 是否家庭成员
	 */
	private boolean isFamilyMember = false;
	
	private List<RelativeMember> familyMembers = new ArrayList<RelativeMember>();
	
	public IndInfo(String Id,Transaction Sqlca){
		super(Id,Sqlca);
	}
	
	@Override
	public void fullfill() throws SADREException {
		super.fullfill();
		
		//03 家庭关系 
		String sRelativeID 	 = "";
		String sRelationShip = "";
		String sRelativeName = "";
		try {
			ASResultSet resultset = Sqlca.getASResultSet("select REGIONALISM " +
					"from IND_INFO where CUSTOMERID='"+getId()+"'");
			if(resultset.next()){
				String regionCode = StringUtil.getString(resultset.getString("REGIONALISM"));
				setAttribute("REGIONCODE", regionCode);				//所属区域
			}
			resultset.getStatement().close();
			
			//家庭关系
			resultset = Sqlca.getASResultSet("select RelativeID,CUSTOMERNAME,RelationShip " +
					"from CUSTOMER_RELATIVE where CUSTOMERID='"+getId()+"' and RELATIONSHIP like '03%'");
			if(resultset.next()){
				if(!isFamilyMember) isFamilyMember = true;
				
				sRelativeID = StringUtil.getString(resultset.getString("RelativeID"));
				sRelativeName = StringUtil.getString(resultset.getString("CUSTOMERNAME"));
				sRelationShip = StringUtil.getString(resultset.getString("RelationShip"));
				
				RelativeMember rmtmp = new RelativeMember(sRelativeID, sRelativeName);
				rmtmp.setRelationShip(sRelationShip);
				
				familyMembers.add(rmtmp);
			}
			resultset.getStatement().close();
		} catch (Exception e) {
			throw new SADREException(e);
		}
		
	}

	public int getSimpleType() {
		return 客户类型_个人客户;
	}

	public boolean belongRelativeUnit() throws SADREException {
		return isFamilyMember;
	}
	
	public List<RelativeMember> getRelativeMembers() {
		return familyMembers;
	}
}
