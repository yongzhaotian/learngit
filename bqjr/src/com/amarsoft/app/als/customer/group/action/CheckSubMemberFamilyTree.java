package com.amarsoft.app.als.customer.group.action;

import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOFactory;

/**
 *集团家谱：验证一个企业客户下是否有其他子成员
 *
 */
public class CheckSubMemberFamilyTree {

	private String groupId;	// 集团编号
	private String parentMemberID; //父成员客户编号
	private String memberID;	//当前成员客户编号
	private String versionSeq;	//当前版本号
	
	// jbo变量
	private JBOFactory f = JBOFactory.getFactory();
	private BizObjectManager m = null;
	private BizObjectQuery q = null;
	private BizObject bo = null;
	
	
	
	public String getGroupId() {
		return groupId;
	}

	public void setGroupId(String groupId) {
		this.groupId = groupId;
	}

	public String getParentMemberID() {
		return parentMemberID;
	}

	public void setParentMemberID(String parentMemberID) {
		this.parentMemberID = parentMemberID;
	}

	public String getVersionSeq() {
		return versionSeq;
	}

	public void setVersionSeq(String versionSeq) {
		this.versionSeq = versionSeq;
	}
    
	public String getMemberID() {
		return memberID;
	}

	public void setMemberID(String memberID) {
		this.memberID = memberID;
	}

	/**
	 * 验证一个企业客户下是否有其他子成员
	 * @return
	 * @throws Exception
	 */
	public String subMemberExist() throws Exception {
		m = f.getManager("jbo.app.GROUP_FAMILY_MEMBER");
		String query = " GroupID = :GroupID and ParentMemberID=:ParentMemberID and VersionSeq = :VersionSeq  and ReviseFlag <> 'REMOVED'";
		q = m.createQuery(query);
		q.setParameter("GroupID",groupId);
		q.setParameter("ParentMemberID",parentMemberID);
		q.setParameter("VersionSeq",versionSeq);
		int count = q.getTotalCount();
		if(count > 0){
			return "EXIST";
		}else{
			return "NOTEXIST";
		}
	}
	
	/**
	 * 将要删除的集团成员的ReviseFlag字段设置为REMOVED
	 * @return
	 * @throws Exception
	 */
	public String deleteSubMemberExist() throws Exception {
		m = f.getManager("jbo.app.GROUP_FAMILY_MEMBER");
		q = m.createQuery(" update o set ReviseFlag = 'REMOVED' where GroupID = :GroupID and MEMBERCUSTOMERID=:MemberID and VersionSeq = :VersionSeq ");
		q.setParameter("GroupID",groupId);
		q.setParameter("MemberID",memberID);
		q.setParameter("VersionSeq",versionSeq);
		q.executeUpdate();
		return "succes";
	}
	
}

