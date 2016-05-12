package com.amarsoft.app.als.customer.group.tree.component;

import java.io.Serializable;

/**
 * @author syang
 * @date 2011-7-23
 * @describe ���ſͻ��������ڵ���� 
 */
public class FamilyTreeNode extends TreeNode implements Serializable{

	private static final long serialVersionUID = 2387285040267959266L;
	protected String memberType = "";
	protected String memberName = "";
	protected String memberCertType = "";
	protected String memberCertID = "";
	protected String AddReason ="";
	protected String parentRelationType ="";
	protected double shareValue = 0.0;
	protected String state = "NEW";
	public static long getSerialversionuid() {
		return serialVersionUID;
	}

	public String getAddReason() {
		return AddReason;
	}
	public void setAddReason(String addReason) {
		AddReason = addReason;
	}
	public String getMemberName() {
		return memberName;
	}
	public void setMemberName(String memberName) {
		this.memberName = memberName;
	}
	public String getMemberCertType() {
		return memberCertType;
	}
	public void setMemberCertType(String memberCertType) {
		this.memberCertType = memberCertType;
	}
	public String getMemberCertID() {
		return memberCertID;
	}
	public void setMemberCertID(String memberCertID) {
		this.memberCertID = memberCertID;
	}
	/***
	 * ��ȡ��Ա���
	 * @return
	 */
	public String getMemberType() {
		return memberType;
	}
	/**
	 * ���ó�Ա���
	 * @param memberType
	 */
	public void setMemberType(String memberType) {
		this.memberType = memberType;
	}
	/**
	 * ��ȡ�ֹɱ���
	 * @return
	 */
	public double getShareValue() {
		return shareValue;
	}
	/**
	 * ���óֹɱ���
	 * @param shareValue
	 */
	public void setShareValue(String shareValue) {
		this.shareValue = Double.parseDouble(shareValue);
	}
	/**
	 * ��ȡ�ڵ�״̬
	 * @return �ڵ�״̬
	 */
	public String getState() {
		return state;
	}
	/***
	 * ���ýڵ�״̬
	 * @param state �ڵ�״̬
	 */
	public void setState(String state) {
		this.state = state;
	}
	/**
	 * ��ȡ�ڵ��븸�ڵ��ϵ 
	 * @return �븸�ڵ��ϵ 
	 */
	public String getParentRelationType() {
		return parentRelationType;
	}
	/***
	 * �����븸�ڵ��ϵ 
	 * @param state �븸�ڵ��ϵ 
	 */
	public void setParentRelationType(String parentRelationType) {
		this.parentRelationType = parentRelationType;
	}
	/*** ���뼯��ԭ�� 
	 *  @return 
	 * */


	@Override
	public String toString() {
		return "FamilyTreeNode [memberType=" + memberType + ", parentRelationType=" + parentRelationType + ", shareValue="
				+ shareValue + ", state=" + state +",MemberName="+memberName+", MemberCertType="+memberCertType+", MemberCertID="+memberCertID
				+ ", parentId=" + parentId + ", AddReason="+AddReason+", id=" + id + ", visiable="
				+ visiable + "]";
	}


}
