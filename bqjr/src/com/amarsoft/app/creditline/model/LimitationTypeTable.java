package com.amarsoft.app.creditline.model;

import java.util.Map;

public class LimitationTypeTable {
	private Map<String, LimitationType> mTable;

	/**
	 * ��ʼ������list
	 * @param mTable
	 */
	public LimitationTypeTable(Map<String,LimitationType> mTable) {
		this.mTable = mTable;
	}
	
	/**
	 * ����LimitationType��Table��
	 * @param limitationType
	 * @return
	 */
	public LimitationTypeTable addLimitationType(LimitationType limitationType) {
		mTable.put(limitationType.getTypeID(), limitationType);
		return this;
	}

	/**
	 * ��ȡLimitationType����
	 * @param typeID
	 * @return
	 */
	public LimitationType getLimitationType(String typeID) {
		return (LimitationType) mTable.get(typeID);
	}
	
	/**
	 * ��ȡ�����б�
	 * @return
	 */
	public Map<String,LimitationType> getLimitationTypeMap() {
		return mTable;
	}

	/**
	 * ��ȡ�����б�Map
	 * @return
	 */
	public LimitationTypeTable[] getLimitationType() {
		return (LimitationTypeTable[])mTable.values().toArray(new LimitationTypeTable[0]);
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
