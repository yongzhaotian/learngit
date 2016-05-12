package com.amarsoft.app.creditline.model;

import java.util.Map;

public class CreditLineTypeTable {
	private Map<String, CreditLineType> mTable;

	/**
	 * 初始化对象list
	 * @param mTable
	 */
	public CreditLineTypeTable(Map<String,CreditLineType> mTable) {
		this.mTable = mTable;
	}
	
	/**
	 * 增加CreditLineType到Table中
	 * @param clType
	 * @return
	 */
	public CreditLineTypeTable addCreditLineType(CreditLineType clType) {
		mTable.put(clType.getClTypeID(), clType);
		return this;
	}

	/**
	 * 获取CreditLineType对象
	 * @param clTypeID
	 * @return
	 */
	public CreditLineType getCreditLineType(String clTypeID) {
		return (CreditLineType) mTable.get(clTypeID);
	}
	
	/**
	 * 获取对象列表
	 * @return
	 */
	public Map<String,CreditLineType> getCreditLineTypeMap() {
		return mTable;
	}

	/**
	 * 获取对象列表Map
	 * @return
	 */
	public CreditLineTypeTable[] getCreditLineType() {
		return (CreditLineTypeTable[])mTable.values().toArray(new CreditLineTypeTable[0]);
	}
	
	/**
	 * 清除全部
	 */
	public void clear() {
		mTable.clear();
	}

	/**
	 * 获得Size
	 * @return
	 */
	public int getSize() {
		return mTable.size();
	}
}
