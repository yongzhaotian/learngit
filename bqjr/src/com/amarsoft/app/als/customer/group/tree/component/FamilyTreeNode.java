package com.amarsoft.app.als.customer.group.tree.component;

import java.io.Serializable;

/**
 * @author syang
 * @date 2011-7-23
 * @describe 集团客户家谱树节点对象 
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
	 * 获取成员类别
	 * @return
	 */
	public String getMemberType() {
		return memberType;
	}
	/**
	 * 设置成员类别
	 * @param memberType
	 */
	public void setMemberType(String memberType) {
		this.memberType = memberType;
	}
	/**
	 * 获取持股比例
	 * @return
	 */
	public double getShareValue() {
		return shareValue;
	}
	/**
	 * 设置持股比例
	 * @param shareValue
	 */
	public void setShareValue(String shareValue) {
		this.shareValue = Double.parseDouble(shareValue);
	}
	/**
	 * 获取节点状态
	 * @return 节点状态
	 */
	public String getState() {
		return state;
	}
	/***
	 * 设置节点状态
	 * @param state 节点状态
	 */
	public void setState(String state) {
		this.state = state;
	}
	/**
	 * 获取节点与父节点关系 
	 * @return 与父节点关系 
	 */
	public String getParentRelationType() {
		return parentRelationType;
	}
	/***
	 * 设置与父节点关系 
	 * @param state 与父节点关系 
	 */
	public void setParentRelationType(String parentRelationType) {
		this.parentRelationType = parentRelationType;
	}
	/*** 加入集团原因 
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
