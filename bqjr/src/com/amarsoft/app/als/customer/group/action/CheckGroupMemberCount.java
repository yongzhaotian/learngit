package com.amarsoft.app.als.customer.group.action;

import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOFactory;

/**
 *提交复核时，判断集团成员数量（如果不存在2名成员，则不能提交复核）
 *
 */
public class CheckGroupMemberCount {

	private String groupId;	// 集团编号
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

	public String getVersionSeq() {
		return versionSeq;
	}

	public void setVersionSeq(String versionSeq) {
		this.versionSeq = versionSeq;
	}

	/**
	 * 验证一个企业客户下是否有其他子成员
	 * @return
	 * @throws Exception
	 */
	public String checkGroupMemberCount() throws Exception {
		m = f.getManager("jbo.app.GROUP_FAMILY_MEMBER");
		String query = " GroupID = :GroupID and VersionSeq = :VersionSeq ";
		q = m.createQuery(query);
		q.setParameter("GroupID",groupId);
		q.setParameter("VersionSeq",versionSeq);
		int count = q.getTotalCount();
		if(count >= 2){
			return "Yes";
		}else{
			return "No";
		}
	}
	
}
