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
 * @ EntInfo.java
 * DESCRIPT: 对公概况对象实现类
 *     
 * @author zllin@amarsoft.com
 * 
 * @date 2011-3-29 下午03:37:31
 *
 * logs: 1. 
 */
public class EntInfo extends CustomerInfo{
	
	/**
	 * 是否集团成员
	 */
	private boolean isGroupMember = false;
	
	private String belongGroup = "";
	
//	private String customerId = "";
	
	private List<RelativeMember> groupMembers = new ArrayList<RelativeMember>();

	public EntInfo(String Id,Transaction Sqlca){
		super(Id,Sqlca);
	}
	
	public void fullfill() throws SADREException {
		super.fullfill();
		
		try {
			ASResultSet resultset = Sqlca.getASResultSet("select SCOPE,REGIONCODE " +
					"from ENT_INFO where CUSTOMERID='"+getId()+"'");
			if(resultset.next()){
				String scope = StringUtil.getString(resultset.getString("SCOPE"));
				String regionCode = StringUtil.getString(resultset.getString("REGIONCODE"));
				setAttribute("SCOPE", scope);						//企业规模
				setAttribute("REGIONCODE", regionCode);				//所属区域
			}
			resultset.getStatement().close();
			
			//04 关联集团
			resultset = Sqlca.getASResultSet("select CUSTOMERID " +
					"from CUSTOMER_RELATIVE where RELATIVEID='"+getId()+"' and RELATIONSHIP like '04%'");
			if(resultset.next()){
				if(!isGroupMember) isGroupMember = true;
				belongGroup = StringUtil.getString(resultset.getString("CUSTOMERID"));
				setAttribute("BELONGGROUP", belongGroup);		//所属集团
			}
			resultset.getStatement().close();
			
			//---------罗列所有的集团成员
			if(isGroupMember){
				String sRelativeID 	 = "";
				String sRelationShip = "";
				String sRelativeName = "";
				
				resultset = Sqlca.getASResultSet("select SCOPE,REGIONCODE " +
						"from CUSTOMER_RELATIVE where CUSTOMERID='"+belongGroup+"' and RELATIVEID not in ('"+getId()+"')");
				if(resultset.next()){
					sRelativeID = StringUtil.getString(resultset.getString("RelativeID"));
					sRelativeName = StringUtil.getString(resultset.getString("CUSTOMERNAME"));
					sRelationShip = StringUtil.getString(resultset.getString("RelationShip"));
					
					RelativeMember rmtmp = new RelativeMember(sRelativeID, sRelativeName);
					rmtmp.setRelationShip(sRelationShip);
					
					groupMembers.add(rmtmp);
				}
				resultset.getStatement().close();
			}
			
			
		} catch (Exception e) {
			throw new SADREException(e);
		}
		
	}
	
	public List<RelativeMember> getRelativeMembers() {
		return groupMembers;
	}
	
	public int getSimpleType() {
		return ICustomer.客户类型_公司客户;
	}

	public boolean belongRelativeUnit() throws SADREException {
		return isGroupMember;
	}

	
	
}
