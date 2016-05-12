package com.amarsoft.app.als.bizobject.customer;

import java.io.Serializable;

/**
 * @author qchen
 * @since 2011-7-04
 * @describe 集团客户
 */
public class GroupCustomer extends Customer implements Serializable{
	private static final long serialVersionUID = -6483075448652357828L;
	private String groupID = null;					//集团编号
	private String groupName = null;				//集团名称
	private String groupAbbName = null;				//集团简称
	private String keyMemberCustomerID = null;		//集团母公司客户编号
	private String keyMemberCustomerName = null;		//集团母公司客户名称
	private String groupType1 = null;				//集团客户类型
	private String mgtUserID = null;				//主办人
	private String mgtOrgID = null;					//主办机构
	private String refVersionSeq = null;			//当前维护的家谱版本号
	private String currentVersionSeq = null; 		//当前使用的家谱版本号
	private String groupCorpID = null;				//集团客户组织机构代码编号
	private String familyMapStatus = null;			//集团家谱版本状态
	private String createReason =null;				//创建原因 
	/**	
	 * @return 集团编号
	 */
	public String getGroupID() {
		return groupID;
	}
	/**
	 * @param sex 集团编号
	 */
	public void setGroupID(String groupID) {
		this.groupID = groupID;
	}
	/**
	 * @return 集团名称
	 */
	public String getGroupName() {
		return groupName;
	}
	/**
	 * @param birthDay 集团名称
	 */
	public void setGroupName(String groupName) {
		this.groupName = groupName;
	}
	/**
	 * @return 集团
	 */
	public String getGroupAbbName() {
		return groupAbbName;
	}
	/**
	 * @param marriage 婚姻状况代码
	 */
	public void setGroupAbbName(String groupAbbName) {
		this.groupAbbName = groupAbbName;
	}
	/**
	 * @return 集团母公司客户编号
	 */
	public String getKeyMemberCustomerID() {
		return keyMemberCustomerID;
	}
	/**
	 * @param  集团母公司客户编号
	 */
	public void setKeyMemberCustomerID(String keyMemberCustomerID) {
		this.keyMemberCustomerID = keyMemberCustomerID;
	}
	/**
	 * @param  集团母公司客户名称
	 */
	public String getKeyMemberCustomerName() {
		return keyMemberCustomerName;
	}
	/**
	 * @param  集团母公司客户名称
	 */
	public void setKeyMemberCustomerName(String keyMemberCustomerName) {
		this.keyMemberCustomerName = keyMemberCustomerName;
	}
	/**
	 * @return 集团客户类型
	 */
	public String getGroupType1() {
		return groupType1;
	}
	/**
	 * @param groupType1 集团客户类型
	 */
	public void setGroupType1(String groupType1) {
		this.groupType1 = groupType1;
	}
	/**
	 * @param mgtUserID 主办人
	 */
	public void setMgtUserID(String mgtUserID) {
		this.mgtUserID = mgtUserID;
	}
	/**
	 * @return 主办人
	 */
	public String getMgtUserID() {
		return mgtUserID;
	}
	/**
	 * @param mgtOrgID 主办机构
	 */
	public void setMgtOrgID(String mgtOrgID) {
		this.mgtOrgID = mgtOrgID;
	}
	/**
	 * @return 主办机构
	 */
	public String getMgtOrgID() {
		return mgtOrgID;
	}
	/**
	 * @param currentVersionSeq 当前使用的家谱版本号
	 */
	public void setCurrentVersionSeq(String currentVersionSeq) {
		this.currentVersionSeq = currentVersionSeq;
	}
	/**
	 * @return 当前使用的家谱版本号
	 */
	public String getCurrentVersionSeq() {
		return currentVersionSeq;
	}
	/**
	 * @param groupCorpID 集团客户组织机构代码
	 */
	public void setGroupCorpID(String groupCorpID) {
		this.groupCorpID = groupCorpID;
	}
	/**
	 * @return 集团客户组织机构代码s
	 */
	public String getGroupCorpID() {
		return groupCorpID;
	}
	/**
	 * @param familyMapStatus 集团家谱状态
	 */
	public void setFamilyMapStatus(String familyMapStatus) {
		this.familyMapStatus = familyMapStatus;
	}
	/**
	 * @return 集团家谱状态
	 */
	public String getFamilyMapStatus() {
		return familyMapStatus;
	}
	/**
	 * @param refVersionSeq 当前维护的家谱版本号
	 */
	public void setRefVersionSeq(String refVersionSeq) {
		this.refVersionSeq = refVersionSeq;
	}
	/**
	 * @return 当前维护的家谱版本号
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
