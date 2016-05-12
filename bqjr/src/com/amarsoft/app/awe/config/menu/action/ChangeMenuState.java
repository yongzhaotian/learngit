package com.amarsoft.app.awe.config.menu.action;

import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;

/**
 * 启用或停用主菜单项目
 * 			MenuID: 项目编号
 * 			Flag：启用还是停用标志  启用 1;停用 2;
 */
public class ChangeMenuState{

	private String menuID; //项目编号
	private String sortNo; //排序号
	private String flag; //标志
	private String includeSubs; //是否包括项下菜单
	
	public String getMenuID() {
		return menuID;
	}

	public void setMenuID(String menuID) {
		this.menuID = menuID;
	}

	public String getSortNo() {
		return sortNo;
	}

	public void setSortNo(String sortNo) {
		this.sortNo = sortNo;
	}

	public String getFlag() {
		return flag;
	}

	public void setFlag(String flag) {
		this.flag = flag;
	}

	public String getIncludeSubs() {
		return includeSubs;
	}

	public void setIncludeSubs(String includeSubs) {
		this.includeSubs = includeSubs;
	}

	/**
	 * 启用或停用主菜单项目
	 * @param 
	 * @return	sReturn：返回提示
	 * @throws Exception
	 */
	public String changeMenuState(Transaction Sqlca) throws Exception {
		String isInUse = "";
		if("1".equals(flag)){
			isInUse = "1";
		}else if("2".equals(flag)){
			isInUse = "2";
		}else{ // 状态不是停用和启用，那么锁定
			isInUse = "0";
		}
		
		//同时更新项下菜单
		if("true".equals(includeSubs)){
			Sqlca.executeSQL(new SqlObject("update AWE_MENU_INFO set IsInUse=:IsInUse where SortNo like :SortNo").setParameter("IsInUse",isInUse).setParameter("SortNo",sortNo+"%"));
		}else{
			Sqlca.executeSQL(new SqlObject("update AWE_MENU_INFO set IsInUse=:IsInUse where MenuID = :MenuID").setParameter("IsInUse",isInUse).setParameter("MenuID",menuID));
		}
		
		return "SUCCEEDED";
	}
}
