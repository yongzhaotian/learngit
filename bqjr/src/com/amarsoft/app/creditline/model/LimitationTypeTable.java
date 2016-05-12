package com.amarsoft.app.creditline.model;

import java.util.Map;

public class LimitationTypeTable {
	private Map<String, LimitationType> mTable;

	/**
	 * 初始化对象list
	 * @param mTable
	 */
	public LimitationTypeTable(Map<String,LimitationType> mTable) {
		this.mTable = mTable;
	}
	
	/**
	 * 增加LimitationType到Table中
	 * @param limitationType
	 * @return
	 */
	public LimitationTypeTable addLimitationType(LimitationType limitationType) {
		mTable.put(limitationType.getTypeID(), limitationType);
		return this;
	}

	/**
	 * 获取LimitationType对象
	 * @param typeID
	 * @return
	 */
	public LimitationType getLimitationType(String typeID) {
		return (LimitationType) mTable.get(typeID);
	}
	
	/**
	 * 获取对象列表
	 * @return
	 */
	public Map<String,LimitationType> getLimitationTypeMap() {
		return mTable;
	}

	/**
	 * 获取对象列表Map
	 * @return
	 */
	public LimitationTypeTable[] getLimitationType() {
		return (LimitationTypeTable[])mTable.values().toArray(new LimitationTypeTable[0]);
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
