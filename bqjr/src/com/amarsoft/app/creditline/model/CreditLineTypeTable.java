package com.amarsoft.app.creditline.model;

import java.util.Map;

public class CreditLineTypeTable {
	private Map<String, CreditLineType> mTable;

	/**
	 * ��ʼ������list
	 * @param mTable
	 */
	public CreditLineTypeTable(Map<String,CreditLineType> mTable) {
		this.mTable = mTable;
	}
	
	/**
	 * ����CreditLineType��Table��
	 * @param clType
	 * @return
	 */
	public CreditLineTypeTable addCreditLineType(CreditLineType clType) {
		mTable.put(clType.getClTypeID(), clType);
		return this;
	}

	/**
	 * ��ȡCreditLineType����
	 * @param clTypeID
	 * @return
	 */
	public CreditLineType getCreditLineType(String clTypeID) {
		return (CreditLineType) mTable.get(clTypeID);
	}
	
	/**
	 * ��ȡ�����б�
	 * @return
	 */
	public Map<String,CreditLineType> getCreditLineTypeMap() {
		return mTable;
	}

	/**
	 * ��ȡ�����б�Map
	 * @return
	 */
	public CreditLineTypeTable[] getCreditLineType() {
		return (CreditLineTypeTable[])mTable.values().toArray(new CreditLineTypeTable[0]);
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
