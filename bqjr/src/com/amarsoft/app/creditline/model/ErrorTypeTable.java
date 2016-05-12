package com.amarsoft.app.creditline.model;

import java.util.Map;

public class ErrorTypeTable {
	private Map<String,ErrorType> mTable;

	/**
	 * ��ʼ������list
	 * @param mTable
	 */
	public ErrorTypeTable(Map<String,ErrorType> mTable) {
		this.mTable = mTable;
	}
	
	/**
	 * ����ErrorType��Table��
	 * @param errorType
	 * @return
	 */
	public ErrorTypeTable addErrorType(ErrorType errorType) {
		mTable.put(errorType.getId(), errorType);
		return this;
	}

	/**
	 * ��ȡErrorType����
	 * @param sErrorTypeID
	 * @return
	 */
	public ErrorType getErrorType(String sErrorTypeID) {
		return (ErrorType) mTable.get(sErrorTypeID);
	}
	
	/**
	 * ��ȡ�����б�
	 * @return
	 */
	public Map<String,ErrorType> getErrorTypeMap() {
		return mTable;
	}

	/**
	 * ��ȡ�����б�Map
	 * @return
	 */
	public ErrorTypeTable[] getErrorType() {
		return (ErrorTypeTable[])mTable.values().toArray(new ErrorTypeTable[0]);
	}
	
	/**
	 * ���ȫ��
	 */
	public void clear() {
		mTable.clear();
	}

	/**
	 * ���Size
	 * @return
	 */
	public int getSize() {
		return mTable.size();
	}
}
