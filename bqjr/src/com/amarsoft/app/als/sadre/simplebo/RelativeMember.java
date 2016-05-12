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

/**
 * <p>Title: RelativeMember.java </p>
 * <p>Description: 客户的关联客户信息(集团成员/家庭成员) </p>
 * <p>Copyright: Copyright (C) 1999-2011 Amarsoft Ltd. Co.</p> 
 *     
 * @author zllin@amarsoft.com</p>
 * @version </p>
 * @date 2011-6-23 下午04:01:21</p>
 *
 * logs: 1. </p>
 */
public class RelativeMember {
	
	private String id;
	
	private String name;
	
	private String relationShip;
	
//	private boolean relaInited = false;
//	private List<BusinessContract> relaContracts = null;
	
	public RelativeMember(String memberId,String memberName){
		this.id = memberId;
		this.name = memberName;
	}
//	
//	public List<BusinessContract> getMenberContracts(Transaction sqlca) throws Exception{
//		if(relaInited) return relaContracts;
//		
//		relaContracts = CustomerImpl.getContracts(this.getId(),sqlca);
//		relaInited = true;
//		
//		return relaContracts;
//	}

	public String getRelationShip() {
		return relationShip;
	}

	public void setRelationShip(String relationShip) {
		this.relationShip = relationShip;
	}

	public String getId() {
		return id;
	}

	public String getName() {
		return name;
	}
	
	
}
