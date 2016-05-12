package com.amarsoft.app.als.customer.group.action;

import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOFactory;

/**
 * ���״������
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
	 * �ж��Ƿ����<ol>
	 * <li>�����Ƿ����
	 * <li>�����ԱУ��
	 * @param sVersionSeq
	 * @return
	 * @throws Exception
	 */
	public static boolean isVersion(String sGroupID,String sVersionSeq) throws Exception {
		JBOFactory factory = JBOFactory.getFactory();
		
		// �����Ƿ����
		BizObjectManager versionManager = factory.getManager("jbo.app.GROUP_FAMILY_VERSION");
		BizObjectQuery versionQuery = versionManager.createQuery("GroupID=:GroupID and VersionSeq=:VersionSeq");
		versionQuery.setParameter("GroupID",sGroupID).setParameter("VersionSeq",sVersionSeq);
		BizObject version = versionQuery.getSingleResult();
		if(version == null) return false;
		
		// �����ԱУ��
		BizObjectManager memberManager = factory.getManager("jbo.app.GROUP_FAMILY_MEMBER");
		BizObjectQuery memberQuery = memberManager.createQuery("GroupID=:GroupID and VersionSeq=:VersionSeq and ParentMemberID=:ParentMemberID");
		memberQuery.setParameter("GroupID",sGroupID).setParameter("VersionSeq",sVersionSeq).setParameter("ParentMemberID","None");
		version=memberQuery.getSingleResult();
		if(version == null) return false;
		
		return true;
	}
	
	/**
	 * У����װ汾����Ƿ���Ч
	 * @return ��Ч����"true",��Ч����"false"
	 * @throws Exception
	 */
	public String checkVersionLegality() throws Exception {
		BizObjectManager versionManager = JBOFactory.getFactory().getManager("jbo.app.GROUP_FAMILY_VERSION");
		BizObjectQuery versionQuery = versionManager.createQuery("GroupID=:GroupID and VersionSeq=:VersionSeq");
		versionQuery.setParameter("GroupID",groupID).setParameter("VersionSeq",versionSeq);
		BizObject version = versionQuery.getSingleResult();
		if(version == null) return "false";
		
		// �����ԱУ��
		BizObjectManager memberManager = JBOFactory.getFactory().getManager("jbo.app.GROUP_FAMILY_MEMBER");
		BizObjectQuery memberQuery = memberManager.createQuery("GroupID=:GroupID and VersionSeq=:VersionSeq and ParentMemberID=:ParentMemberID");
		memberQuery.setParameter("GroupID",groupID).setParameter("VersionSeq",versionSeq).setParameter("ParentMemberID","None");
		version=memberQuery.getSingleResult();
		if(version == null) return "false";
		return "true";
	}
}
