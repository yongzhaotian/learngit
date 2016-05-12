package com.amarsoft.app.als.customer.group.action;

import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOFactory;

/**
 * 家谱处理相关
 * @author als6
 *
 */
public class Version {
	
	private String groupID;
	private String versionSeq;
	
	public String getGroupID() {
		return groupID;
	}

	public void setGroupID(String groupID) {
		this.groupID = groupID;
	}

	public String getVersionSeq() {
		return versionSeq;
	}

	public void setVersionSeq(String versionSeq) {
		this.versionSeq = versionSeq;
	}

	/**
	 * 判断是否家谱<ol>
	 * <li>家谱是否存在
	 * <li>主体成员校验
	 * @param sVersionSeq
	 * @return
	 * @throws Exception
	 */
	public static boolean isVersion(String sGroupID,String sVersionSeq) throws Exception {
		JBOFactory factory = JBOFactory.getFactory();
		
		// 家谱是否存在
		BizObjectManager versionManager = factory.getManager("jbo.app.GROUP_FAMILY_VERSION");
		BizObjectQuery versionQuery = versionManager.createQuery("GroupID=:GroupID and VersionSeq=:VersionSeq");
		versionQuery.setParameter("GroupID",sGroupID).setParameter("VersionSeq",sVersionSeq);
		BizObject version = versionQuery.getSingleResult();
		if(version == null) return false;
		
		// 主体成员校验
		BizObjectManager memberManager = factory.getManager("jbo.app.GROUP_FAMILY_MEMBER");
		BizObjectQuery memberQuery = memberManager.createQuery("GroupID=:GroupID and VersionSeq=:VersionSeq and ParentMemberID=:ParentMemberID");
		memberQuery.setParameter("GroupID",sGroupID).setParameter("VersionSeq",sVersionSeq).setParameter("ParentMemberID","None");
		version=memberQuery.getSingleResult();
		if(version == null) return false;
		
		return true;
	}
	
	/**
	 * 校验家谱版本编号是否有效
	 * @return 有效返回"true",无效返回"false"
	 * @throws Exception
	 */
	public String checkVersionLegality() throws Exception {
		BizObjectManager versionManager = JBOFactory.getFactory().getManager("jbo.app.GROUP_FAMILY_VERSION");
		BizObjectQuery versionQuery = versionManager.createQuery("GroupID=:GroupID and VersionSeq=:VersionSeq");
		versionQuery.setParameter("GroupID",groupID).setParameter("VersionSeq",versionSeq);
		BizObject version = versionQuery.getSingleResult();
		if(version == null) return "false";
		
		// 主体成员校验
		BizObjectManager memberManager = JBOFactory.getFactory().getManager("jbo.app.GROUP_FAMILY_MEMBER");
		BizObjectQuery memberQuery = memberManager.createQuery("GroupID=:GroupID and VersionSeq=:VersionSeq and ParentMemberID=:ParentMemberID");
		memberQuery.setParameter("GroupID",groupID).setParameter("VersionSeq",versionSeq).setParameter("ParentMemberID","None");
		version=memberQuery.getSingleResult();
		if(version == null) return "false";
		return "true";
	}
}
