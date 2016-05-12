package com.amarsoft.app.awe.config.menu.action;

import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;

/**
 * ���û�ͣ�����˵���Ŀ
 * 			MenuID: ��Ŀ���
 * 			Flag�����û���ͣ�ñ�־  ���� 1;ͣ�� 2;
 */
public class ChangeMenuState{

	private String menuID; //��Ŀ���
	private String sortNo; //�����
	private String flag; //��־
	private String includeSubs; //�Ƿ�������²˵�
	
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
	 * ���û�ͣ�����˵���Ŀ
	 * @param 
	 * @return	sReturn��������ʾ
	 * @throws Exception
	 */
	public String changeMenuState(Transaction Sqlca) throws Exception {
		String isInUse = "";
		if("1".equals(flag)){
			isInUse = "1";
		}else if("2".equals(flag)){
			isInUse = "2";
		}else{ // ״̬����ͣ�ú����ã���ô����
			isInUse = "0";
		}
		
		//ͬʱ�������²˵�
		if("true".equals(includeSubs)){
			Sqlca.executeSQL(new SqlObject("update AWE_MENU_INFO set IsInUse=:IsInUse where SortNo like :SortNo").setParameter("IsInUse",isInUse).setParameter("SortNo",sortNo+"%"));
		}else{
			Sqlca.executeSQL(new SqlObject("update AWE_MENU_INFO set IsInUse=:IsInUse where MenuID = :MenuID").setParameter("IsInUse",isInUse).setParameter("MenuID",menuID));
		}
		
		return "SUCCEEDED";
	}
}
