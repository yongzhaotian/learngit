package com.amarsoft.app.als.customer.group.action;

import java.util.ArrayList;
import java.util.List;

import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOFactory;

/**
 * <p>查询在银行授信业务情况
 * @author xdzhu
 * @since 2010/09/16
 *
 */
public class GetBusinessMessage {

	private String customerID;		// 客户编号
	private String[] orgLevels;		// 总分支行代码，以@分隔
	
	// jbo变量
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
	 * 			<p>CustomerID: 客户编号
	 * @return 在途授信额度业务信息
	 * @throws Exception
	 */
	public String getBusinessMessage() throws Exception {
		String sReturn = "";
		// 申请条数、批复条数、已授信条数、授信业务总条数
		int iApply = 0, iApprove = 0, iContract = 0, iNum = 0;
		
		// 在途的集团授信额度申请
		m = f.getManager("jbo.app.BUSINESS_APPLY");
		q = m.createQuery("CustomerID=:CustomerID and (status='01' or PigeonholeDate is null)");
		q.setParameter("CustomerID",customerID);
		iApply = q.getResultList().size();	// 未通过审批或未归档的申请数
		
		// 在有效期内的授信批复
		m = f.getManager("jbo.app.BUSINESS_APPROVE");
		q = m.createQuery("CustomerID=:CustomerID and (status in ('00','01') or PigeonholeDate is null)");
		q.setParameter("CustomerID",customerID);
		iApprove = q.getResultList().size();	// 待签合同或未归档的审批数

		// 在有效期内的授信额度
		m = f.getManager("jbo.app.BUSINESS_CONTRACT");
		q = m.createQuery("CustomerID=:CustomerID and status in ('320','330','340','350')"); 
		q.setParameter("CustomerID",customerID);
		iContract = q.getResultList().size();	// 未归档的合同数
		
		iNum = iApply + iApprove + iContract;
		if(iNum > 0){
			sReturn = "该集团客户";
			if(iApply > 0){
				sReturn += "有在途的集团授信额度申请，";
			}
			if(iApprove > 0){
				sReturn += "有在有效期内的授信额度批复，";
			}
			if(iContract > 0){
				sReturn += "有在有效期内的授信额度，";
			}
			sReturn += "不能执行此操作！";
		}else{
			sReturn = "NO";
		}

		return sReturn;
	}
	
	/**
	 * @InputParam
	 * 			<p>CustomerID: 客户编号
	 * 			<p>OrgLevels: 总分支行代码，以@分隔
	 * @return 在分行的业务情况
	 * @throws Exception
	 */
	public int getOrgCount() throws Exception {
		List orgIDs = new ArrayList();
		// 获得与客户CustomerID相关授信业务银行机构号
		orgIDs = addList(orgIDs, getOrgIDs("jbo.app.BUSINESS_APPLY"));
		orgIDs = addList(orgIDs, getOrgIDs("jbo.app.BUSINESS_APPROVE"));
		orgIDs = addList(orgIDs, getOrgIDs("jbo.app.BUSINESS_CONTRACT"));
		String[] sOrgIDs = getOrgIDs(orgIDs);
		
		m = f.getManager("jbo.sys.ORG_INFO");
		query = "";

		// 总分支行代码
		String query1 = "";
		for(int i = 0; i < orgLevels.length; i++){
			if(i != 0) query1 += ", ";
			query1 += ":OrgLevel" + i;
		}
		if(!"".equals(query1)){
			query += " OrgLevel in (" + query1 + ")";
		}
		
		// 银行机构号
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
		
		// 置入参数
		for(int i = 0; i < orgLevels.length; i++){
			q.setParameter("OrgLevel" + i,orgLevels[i]);
		}
		for(int i = 0; i < sOrgIDs.length; i++){
			q.setParameter("OrgID" + i,sOrgIDs[i]);
		}
		
		// 查询并返回指定总分支行代码的银行数
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
	 * 获取与客户CustomerID相关clazz表业务的机构号
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
