package com.amarsoft.app.als.customer.group.action;

import com.amarsoft.app.util.ASOrgObject;
import com.amarsoft.app.util.ASUserObject;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.ql.Parser;

/**
 * ��֤һ����ҵ�ͻ��Ƿ�����Ϊһ�����ſͻ���ĸ��˾
 * @author xdzhu
 * @since 2010/09/19
 *
 */
public class CheckKeyMemberCustomer {

	private String customerID;	// �ͻ����
	private String corpID;	// �ͻ���֯��������
	// jbo����
	private JBOFactory f = JBOFactory.getFactory();
	private BizObjectManager m = null;
	private BizObjectQuery q = null;
	private BizObject bo = null;
	
	public String getCustomerID() {
		return customerID;
	}
	
	public void setCustomerID(String customerID) {
		this.customerID = customerID;
	}
	
	public String getCorpID() {
		return corpID;
	}

	public void setCorpID(String corpID) {
		this.corpID = corpID;
	}

	/**
	 * ������ҵ�ͻ��Ƿ�Ϊ�������ſͻ��ĳ�Ա��ҵ
	 * @return
	 * @throws Exception
	 */
	public String groupMemberExist() throws Exception {
		 Parser.registerKeyWord("DISTINCT");
		// ��ѯ��ҵ�ͻ��Ƿ�Ϊ�������ſͻ��ĳ�Ա��ҵ
		m = f.getManager("jbo.app.GROUP_FAMILY_MEMBER");
		String query = " MemberCustomerID=:MemberCustomerID and MemberType<>'01' and ( " +
					   " VersionSeq in (select distinct GI.RefVersionSeq from jbo.app.GROUP_INFO GI) " +
					   " or VersionSeq in (select distinct GI.CurrentVersionSeq from jbo.app.GROUP_INFO GI) " +
					   " ) ";
		q = m.createQuery(query);
		q.setParameter("MemberCustomerID",customerID);
		bo = q.getSingleResult();
		if(bo != null){
			return "EXIST";
		}else{
			return "NOTEXIST";
		}
	}
	
	/**
	 * ������ҵ�ͻ��Ƿ��Ѵ��ڼ�����ҵ
	 * @return
	 * @throws Exception
	 */
	public String groupExist() throws Exception {
		m = f.getManager("jbo.app.GROUP_INFO");
		q = m.createQuery("GroupCorpID=:GroupCorpID").setParameter("GroupCorpID",corpID);
		bo = q.getSingleResult();
		if(bo != null){
			String sGroupName = bo.getAttribute("GroupName").getString();
			String sGroupType = bo.getAttribute("GroupType1").getString();
			String sMgtUser = bo.getAttribute("MgtUserID").getString();
			String sMgtOrg = bo.getAttribute("MgtOrgID").getString();
			
			if("01".equals(sGroupType)){
				sGroupType = "����м��ſͻ�";
			}else if("02".equals(sGroupType)){
				sGroupType = "�����Լ��ſͻ�";
			}
			
			sMgtUser = ASUserObject.getUser(sMgtUser).getUserName();
			sMgtOrg = new ASOrgObject(sMgtOrg).getOrgName();
			
			return "EXIST@"+sGroupName+"@"+sGroupType+"@"+sMgtOrg+"@"+sMgtUser+"@";
		}else{
			return "NOTEXIST";
		}
	}
}
