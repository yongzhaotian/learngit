package com.amarsoft.app.creditline.model;

import java.util.Map;

public class ErrorTypeTable {
	private Map<String,ErrorType> mTable;

	/**
	 * 初始化对象list
	 * @param mTable
	 */
	public ErrorTypeTable(Map<String,ErrorType> mTable) {
		this.mTable = mTable;
	}
	
	/**
	 * 增加ErrorType到Table中
	 * @param errorType
	 * @return
	 */
	public ErrorTypeTable addErrorType(ErrorType errorType) {
		mTable.put(errorType.getId(), errorType);
		return this;
	}

	/**
	 * 获取ErrorType对象
	 * @param sErrorTypeID
	 * @return
	 */
	public ErrorType getErrorType(String sErrorTypeID) {
		return (ErrorType) mTable.get(sErrorTypeID);
	}
	
	/**
	 * 获取对象列表
	 * @return
	 */
	public Map<String,ErrorType> getErrorTypeMap() {
		return mTable;
	}

	/**
	 * 获取对象列表Map
	 * @return
	 */
	public ErrorTypeTable[] getErrorType() {
		return (ErrorTypeTable[])mTable.values().toArray(new ErrorTypeTable[0]);
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
