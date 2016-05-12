package com.amarsoft.app.als.process.util;

import com.amarsoft.are.ARE;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOFactory;

/**
 * 机构对象
 * <p>
 * 流程引擎使用,其他用途不建议使用。
 * </p>
 * 
 * @author zszhang
 * 
 */
public class PSOrgObject {
	private static final long serialVersionUID = 1L;
	private String orgID; // 机构编号
	private String orgName; // 机构名称
	private String orgLevel; // 机构级别
	private String parentOrgID; // 上级机构编号
	private String status; // 机构状态
	private String sortNo; // 机构排序号

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
	 * 根据OrgID简单构造机构对象，用于程序中取得机构关联属性 建立机构，如该机构不存在，则抛出意外
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
				ARE.getLog().warn("机构[" + sOrgID + "]在数据库中不存在！");
			}
		} catch (Exception e) {
			ARE.getLog().error("实例化机构对象[" + sOrgID + "]异常！", e);
		}
	}

	public PSOrgObject() {
	}
}
