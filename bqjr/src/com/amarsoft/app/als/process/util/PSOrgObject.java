package com.amarsoft.app.als.process.util;

import com.amarsoft.are.ARE;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOFactory;

/**
 * ��������
 * <p>
 * ��������ʹ��,������;������ʹ�á�
 * </p>
 * 
 * @author zszhang
 * 
 */
public class PSOrgObject {
	private static final long serialVersionUID = 1L;
	private String orgID; // �������
	private String orgName; // ��������
	private String orgLevel; // ��������
	private String parentOrgID; // �ϼ��������
	private String status; // ����״̬
	private String sortNo; // ���������

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

	public String getParentOrgID() {
		return parentOrgID;
	}

	public void setParentOrgID(String parentOrgID) {
		this.parentOrgID = parentOrgID;
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

	/**
	 * ����OrgID�򵥹�������������ڳ�����ȡ�û����������� ������������û��������ڣ����׳�����
	 */
	public PSOrgObject(String sOrgID) throws Exception {
		try {
			BizObjectQuery q = JBOFactory.getFactory().getManager("jbo.sys.ORG_INFO").createQuery("OrgID=:OrgID");
			q.setParameter("OrgID", sOrgID);
			BizObject bo = q.getSingleResult(false);
			if (bo != null) {
				setOrgID(sOrgID);
				setOrgName(bo.getAttribute("OrgName").getString());
				setOrgLevel(bo.getAttribute("OrgLevel").getString());
				setParentOrgID(bo.getAttribute("belongOrgID").getString());
				setStatus(bo.getAttribute("Status").getString());
				setSortNo(bo.getAttribute("SortNo").getString());
			} else {
				ARE.getLog().warn("����[" + sOrgID + "]�����ݿ��в����ڣ�");
			}
		} catch (Exception e) {
			ARE.getLog().error("ʵ������������[" + sOrgID + "]�쳣��", e);
		}
	}

	public PSOrgObject() {
	}
}
