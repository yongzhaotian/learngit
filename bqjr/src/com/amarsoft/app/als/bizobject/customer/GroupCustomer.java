package com.amarsoft.app.als.bizobject.customer;

import java.io.Serializable;

/**
 * @author qchen
 * @since 2011-7-04
 * @describe ���ſͻ�
 */
public class GroupCustomer extends Customer implements Serializable{
	private static final long serialVersionUID = -6483075448652357828L;
	private String groupID = null;					//���ű��
	private String groupName = null;				//��������
	private String groupAbbName = null;				//���ż��
	private String keyMemberCustomerID = null;		//����ĸ��˾�ͻ����
	private String keyMemberCustomerName = null;		//����ĸ��˾�ͻ�����
	private String groupType1 = null;				//���ſͻ�����
	private String mgtUserID = null;				//������
	private String mgtOrgID = null;					//�������
	private String refVersionSeq = null;			//��ǰά���ļ��װ汾��
	private String currentVersionSeq = null; 		//��ǰʹ�õļ��װ汾��
	private String groupCorpID = null;				//���ſͻ���֯����������
	private String familyMapStatus = null;			//���ż��װ汾״̬
	private String createReason =null;				//����ԭ�� 
	/**	
	 * @return ���ű��
	 */
	public String getGroupID() {
		return groupID;
	}
	/**
	 * @param sex ���ű��
	 */
	public void setGroupID(String groupID) {
		this.groupID = groupID;
	}
	/**
	 * @return ��������
	 */
	public String getGroupName() {
		return groupName;
	}
	/**
	 * @param birthDay ��������
	 */
	public void setGroupName(String groupName) {
		this.groupName = groupName;
	}
	/**
	 * @return ����
	 */
	public String getGroupAbbName() {
		return groupAbbName;
	}
	/**
	 * @param marriage ����״������
	 */
	public void setGroupAbbName(String groupAbbName) {
		this.groupAbbName = groupAbbName;
	}
	/**
	 * @return ����ĸ��˾�ͻ����
	 */
	public String getKeyMemberCustomerID() {
		return keyMemberCustomerID;
	}
	/**
	 * @param  ����ĸ��˾�ͻ����
	 */
	public void setKeyMemberCustomerID(String keyMemberCustomerID) {
		this.keyMemberCustomerID = keyMemberCustomerID;
	}
	/**
	 * @param  ����ĸ��˾�ͻ�����
	 */
	public String getKeyMemberCustomerName() {
		return keyMemberCustomerName;
	}
	/**
	 * @param  ����ĸ��˾�ͻ�����
	 */
	public void setKeyMemberCustomerName(String keyMemberCustomerName) {
		this.keyMemberCustomerName = keyMemberCustomerName;
	}
	/**
	 * @return ���ſͻ�����
	 */
	public String getGroupType1() {
		return groupType1;
	}
	/**
	 * @param groupType1 ���ſͻ�����
	 */
	public void setGroupType1(String groupType1) {
		this.groupType1 = groupType1;
	}
	/**
	 * @param mgtUserID ������
	 */
	public void setMgtUserID(String mgtUserID) {
		this.mgtUserID = mgtUserID;
	}
	/**
	 * @return ������
	 */
	public String getMgtUserID() {
		return mgtUserID;
	}
	/**
	 * @param mgtOrgID �������
	 */
	public void setMgtOrgID(String mgtOrgID) {
		this.mgtOrgID = mgtOrgID;
	}
	/**
	 * @return �������
	 */
	public String getMgtOrgID() {
		return mgtOrgID;
	}
	/**
	 * @param currentVersionSeq ��ǰʹ�õļ��װ汾��
	 */
	public void setCurrentVersionSeq(String currentVersionSeq) {
		this.currentVersionSeq = currentVersionSeq;
	}
	/**
	 * @return ��ǰʹ�õļ��װ汾��
	 */
	public String getCurrentVersionSeq() {
		return currentVersionSeq;
	}
	/**
	 * @param groupCorpID ���ſͻ���֯��������
	 */
	public void setGroupCorpID(String groupCorpID) {
		this.groupCorpID = groupCorpID;
	}
	/**
	 * @return ���ſͻ���֯��������s
	 */
	public String getGroupCorpID() {
		return groupCorpID;
	}
	/**
	 * @param familyMapStatus ���ż���״̬
	 */
	public void setFamilyMapStatus(String familyMapStatus) {
		this.familyMapStatus = familyMapStatus;
	}
	/**
	 * @return ���ż���״̬
	 */
	public String getFamilyMapStatus() {
		return familyMapStatus;
	}
	/**
	 * @param refVersionSeq ��ǰά���ļ��װ汾��
	 */
	public void setRefVersionSeq(String refVersionSeq) {
		this.refVersionSeq = refVersionSeq;
	}
	/**
	 * @return ��ǰά���ļ��װ汾��
	 */
	public String getRefVersionSeq() {
		return refVersionSeq;
	}
	public void setCreateReason(String createReason) {
		this.createReason = createReason;
	}
	public String getCreateReason() {
		return createReason;
	}

}
