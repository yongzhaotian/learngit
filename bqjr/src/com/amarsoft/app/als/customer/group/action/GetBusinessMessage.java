package com.amarsoft.app.als.customer.group.action;

import java.util.ArrayList;
import java.util.List;

import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOFactory;

/**
 * <p>��ѯ����������ҵ�����
 * @author xdzhu
 * @since 2010/09/16
 *
 */
public class GetBusinessMessage {

	private String customerID;		// �ͻ����
	private String[] orgLevels;		// �ܷ�֧�д��룬��@�ָ�
	
	// jbo����
	private JBOFactory f = JBOFactory.getFactory();
	private BizObjectManager m = null;
	private BizObjectQuery q = null;
	private BizObject bo = null;
	private String query = null;
	private List bos = null;
	
	public String getCustomerID() {
		return customerID;
	}

	public void setCustomerID(String customerID) {
		this.customerID = customerID;
	}

	public String[] getOrgLevels() {
		return orgLevels;
	}

	public void setOrgLevels(String orgLevels) {
		this.orgLevels = orgLevels.split("@");
	}
	
	/**
	 * @InputParam
	 * 			<p>CustomerID: �ͻ����
	 * @return ��;���Ŷ��ҵ����Ϣ
	 * @throws Exception
	 */
	public String getBusinessMessage() throws Exception {
		String sReturn = "";
		// ������������������������������������ҵ��������
		int iApply = 0, iApprove = 0, iContract = 0, iNum = 0;
		
		// ��;�ļ������Ŷ������
		m = f.getManager("jbo.app.BUSINESS_APPLY");
		q = m.createQuery("CustomerID=:CustomerID and (status='01' or PigeonholeDate is null)");
		q.setParameter("CustomerID",customerID);
		iApply = q.getResultList().size();	// δͨ��������δ�鵵��������
		
		// ����Ч���ڵ���������
		m = f.getManager("jbo.app.BUSINESS_APPROVE");
		q = m.createQuery("CustomerID=:CustomerID and (status in ('00','01') or PigeonholeDate is null)");
		q.setParameter("CustomerID",customerID);
		iApprove = q.getResultList().size();	// ��ǩ��ͬ��δ�鵵��������

		// ����Ч���ڵ����Ŷ��
		m = f.getManager("jbo.app.BUSINESS_CONTRACT");
		q = m.createQuery("CustomerID=:CustomerID and status in ('320','330','340','350')"); 
		q.setParameter("CustomerID",customerID);
		iContract = q.getResultList().size();	// δ�鵵�ĺ�ͬ��
		
		iNum = iApply + iApprove + iContract;
		if(iNum > 0){
			sReturn = "�ü��ſͻ�";
			if(iApply > 0){
				sReturn += "����;�ļ������Ŷ�����룬";
			}
			if(iApprove > 0){
				sReturn += "������Ч���ڵ����Ŷ��������";
			}
			if(iContract > 0){
				sReturn += "������Ч���ڵ����Ŷ�ȣ�";
			}
			sReturn += "����ִ�д˲�����";
		}else{
			sReturn = "NO";
		}

		return sReturn;
	}
	
	/**
	 * @InputParam
	 * 			<p>CustomerID: �ͻ����
	 * 			<p>OrgLevels: �ܷ�֧�д��룬��@�ָ�
	 * @return �ڷ��е�ҵ�����
	 * @throws Exception
	 */
	public int getOrgCount() throws Exception {
		List orgIDs = new ArrayList();
		// �����ͻ�CustomerID�������ҵ�����л�����
		orgIDs = addList(orgIDs, getOrgIDs("jbo.app.BUSINESS_APPLY"));
		orgIDs = addList(orgIDs, getOrgIDs("jbo.app.BUSINESS_APPROVE"));
		orgIDs = addList(orgIDs, getOrgIDs("jbo.app.BUSINESS_CONTRACT"));
		String[] sOrgIDs = getOrgIDs(orgIDs);
		
		m = f.getManager("jbo.sys.ORG_INFO");
		query = "";

		// �ܷ�֧�д���
		String query1 = "";
		for(int i = 0; i < orgLevels.length; i++){
			if(i != 0) query1 += ", ";
			query1 += ":OrgLevel" + i;
		}
		if(!"".equals(query1)){
			query += " OrgLevel in (" + query1 + ")";
		}
		
		// ���л�����
		String query2 = "";
		for(int i = 0; i < sOrgIDs.length; i++){
			if(i != 0) query2 += ", ";
			query2 += ":OrgID" + i;
		}
		if(!"".equals(query2)){
			query += " and OrgID in (" + query2 + ")";
		}
		
		// Query
		q = m.createQuery(query);
		
		// �������
		for(int i = 0; i < orgLevels.length; i++){
			q.setParameter("OrgLevel" + i,orgLevels[i]);
		}
		for(int i = 0; i < sOrgIDs.length; i++){
			q.setParameter("OrgID" + i,sOrgIDs[i]);
		}
		
		// ��ѯ������ָ���ܷ�֧�д����������
		return q.getResultList().size();
	}
	
	private String[] getOrgIDs(List orgIDs) {
		String[] sOrgIDs = new String[orgIDs.size()];
		for(int i = 0; i < orgIDs.size(); i++){
			sOrgIDs[i] = (String) orgIDs.get(i);
		}
		return sOrgIDs;
	}

	/**
	 * ��ȡ��ͻ�CustomerID���clazz��ҵ��Ļ�����
	 * @param clazz
	 * @return
	 * @throws Exception
	 */
	private List getOrgIDs(String clazz) throws Exception {
		List orgIDs = new ArrayList();
		m = f.getManager(clazz);
		q = m.createQuery("CustomerID=:CustomerID");
		q.setParameter("CustomerID",customerID);
		bos = q.getResultList();
		for(int i = 0; i < bos.size(); i++){
			bo = (BizObject) bos.get(i);
			orgIDs.add(bo.getAttribute("InputOrgID").getString());
		}
		
		return orgIDs;
	}
	
	private List addList(List l1, List l2){
		for(int i = 0; i < l2.size(); i++){
			l1.add(l2.get(i));
		}
		return l1;
	}
}
