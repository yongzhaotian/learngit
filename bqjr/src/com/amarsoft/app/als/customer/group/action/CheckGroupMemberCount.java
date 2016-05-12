package com.amarsoft.app.als.customer.group.action;

import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOFactory;

/**
 *�ύ����ʱ���жϼ��ų�Ա���������������2����Ա�������ύ���ˣ�
 *
 */
public class CheckGroupMemberCount {

	private String groupId;	// ���ű��
	private String versionSeq;	//��ǰ�汾��
	// jbo����
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
	 * ��֤һ����ҵ�ͻ����Ƿ��������ӳ�Ա
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
