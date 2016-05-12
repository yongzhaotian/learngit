package com.amarsoft.app.util;

import java.io.Serializable;

import com.amarsoft.are.ARE;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOFactory;

/** �������� */
public class ASOrgObject implements Serializable{
	private static final long serialVersionUID = 1L;
	private String orgID;
	private String orgName;
	private String orgLevel;

	/**
	 * BelongOrgID  ��ǰ��������������
	 */
	private String BelongOrgID;
	private String mainFrameOrgID;//���Ļ�����
	private String relativeOrgID;
	private String orgProperty;
	private String status;
	private String sortNo;
	
	public String getOrgID() {
		return orgID;
	}

	public void setOrgID(String orgID) {
		this.orgID = orgID;
	}

	public String getOrgName() {
		return orgName;
	}

	public void setOrgName(String orgName) {
		this.orgName = orgName;
	}

	public String getOrgLevel() {
		return orgLevel;
	}

	public void setOrgLevel(String orgLevel) {
		this.orgLevel = orgLevel;
	}

	public String getRelativeOrgID() {
		return relativeOrgID;
	}

	public void setRelativeOrgID(String relativeOrgID) {
		this.relativeOrgID = relativeOrgID;
	}

	public String getOrgProperty() {
		return orgProperty;
	}

	public void setOrgProperty(String orgProperty) {
		this.orgProperty = orgProperty;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public String getSortNo() {
		return sortNo;
	}

	public void setSortNo(String sortNo) {
		this.sortNo = sortNo;
	}

	public String getBelongOrgID() {
		return BelongOrgID;
	}

	public void setBelongOrgID(String BelongOrgID) {
		this.BelongOrgID = BelongOrgID;
	}
	
	public String getMainFrameOrgID() {
		return mainFrameOrgID;
	}

	public void setMainFrameOrgID(String mainFrameOrgID) {
		this.mainFrameOrgID = mainFrameOrgID;
	}

	/**
	 * ����OrgID�򵥹�������������ڳ�����ȡ�û�����������
	 * ������������û��������ڣ����׳����� 
	 */
	public ASOrgObject(String sOrgID) throws Exception {
		try {
			BizObjectQuery q = JBOFactory.getFactory().getManager("jbo.sys.ORG_INFO").createQuery("OrgID=:OrgID");
			q.setParameter("OrgID", sOrgID);
			BizObject bo = q.getSingleResult();
			if(bo != null){
				setOrgID(sOrgID);
				setOrgName(bo.getAttribute("OrgName").getString());
				setOrgLevel(bo.getAttribute("OrgLevel").getString());
				setBelongOrgID(bo.getAttribute("BelongOrgID").getString());
				setRelativeOrgID(bo.getAttribute("RelativeOrgID").getString());
				setMainFrameOrgID(bo.getAttribute("MainFrameOrgID").getString());//���Ļ�����
				setOrgProperty(bo.getAttribute("OrgProperty").getString());
				setStatus(bo.getAttribute("Status").getString());
				setSortNo(bo.getAttribute("SortNo").getString());
			}else{
				ARE.getLog().warn("����["+sOrgID+"]�����ݿ��в����ڣ�");
			}
		} catch (Exception e) {
			ARE.getLog().error("ʵ������������["+sOrgID+"]�쳣��",e);
		}
	}
}