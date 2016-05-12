package com.amarsoft.app.accounting.config.loader;

import com.amarsoft.app.accounting.businessobject.BusinessObject;
import com.amarsoft.are.util.ASValuePool;
import com.amarsoft.are.util.DataConvert;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.dict.als.cache.AbstractCache;
import com.amarsoft.dict.als.cache.CodeCache;
import com.amarsoft.dict.als.object.Item;
/**
 * ������Ϣ
 * @author ygwang 2010.12.10
 *
 */
public class OrgConfig extends AbstractCache {
	private static final long serialVersionUID = 1L;
	private static  ASValuePool orgSet;
	
	public static ASValuePool getOrgSet() {
		return orgSet;
	}

	/**
	 * ͨ����ϵͳ�����Ż�ȡ���Ļ�����
	 * @param OrgID
	 * @return
	 * @throws Exception
	 */
	public static String getMFOrgID(String OrgID) throws Exception
	{
		ASValuePool  orgInfo = (ASValuePool)orgSet.getAttribute(OrgID);
		if(orgInfo == null) return OrgID;//���δ�ҵ�������Ϣ����ֱ�ӷ��ش��������
		return orgInfo.getString("MAINFRAMEORGID");
	}
	
	
	/**
	 * ͨ�������ŵõ���������
	 * @param OrgID
	 * @return
	 * @throws Exception
	 */
	public static BusinessObject getOrg(String OrgID) throws Exception
	{
		BusinessObject orgInfo = new BusinessObject((ASValuePool)orgSet.getAttribute(OrgID));
		return orgInfo;
	}
	
	/**
	 * ȡ��Ӧ�������˻����͡����ֵ��ڲ��˺���Ϣ
	 * @param orgID
	 * @param accountType
	 * @param currency
	 * @return �˺�@�˻���@�˻�����@�˻�����@�˻�����@�˻���ʾ$�˺�@�˻���@�˻�����@�˻�����@�˻�����@�˻���ʾ$����
	 * @throws Exception
	 */
	public static String getOrgAccount(String orgID,String accountType,String currency) throws Exception
	{
		ASValuePool orgInfo = (ASValuePool)orgSet.getAttribute(orgID);
		if(orgInfo == null) throw new Exception("δ�ҵ�������Ϊ��"+orgID+"���Ļ�����Ϣ��");
		ASValuePool orgAccount = (ASValuePool)orgInfo.getAttribute("OrgAccount");
		
		BusinessObject coreAccount = (BusinessObject)orgAccount.getAttribute(accountType+"@"+currency);
		if(coreAccount == null) 
			throw new Exception("δ�ҵ������ţ���"+orgID+"���˻����ͣ���"+accountType+"�����֣���"+currency+"�����ڲ��˻���Ϣ��");
		
		Item accountTypeItem = CodeCache.getItem("OrgAccountType", accountType);
		if(accountTypeItem == null)
			throw new Exception("���롾OrgAccountType��������δ�ҵ��˻����ͣ���"+accountType+"��");
		return coreAccount.getString("CoreAccountNo")+"@"+coreAccount.getString("CoreAccountName")
			+"@"+coreAccount.getString("OrgID")+"@"+coreAccount.getString("Currency")+"@"+accountTypeItem.getItemDescribe();
	}
	
	/**
	 * ȡ��Ӧ�������˻����͡����ֵ��ڲ��˺���Ϣ������˺Ų��������Ҹû������ϼ�������Ϣ
	 * @param orgID
	 * @param accountType
	 * @param currency
	 * @return
	 * @throws Exception
	 */
	public static BusinessObject getOrgAccountUp(String orgID,String accountType,String currency) throws Exception
	{
		ASValuePool orgInfo = null;
		ASValuePool orgAccount = null;
		BusinessObject coreAccount = null;
		while(true)
		{
			orgInfo = (ASValuePool)orgSet.getAttribute(orgID);
			if(orgInfo == null) throw new Exception("δ�ҵ�������Ϊ��"+orgID+"���Ļ�����Ϣ��");
			orgAccount = (ASValuePool)orgInfo.getAttribute("OrgAccount");
			coreAccount = (BusinessObject)orgAccount.getAttribute(accountType+"@"+currency);
			if(coreAccount == null)
			{
				String relativeOrgID = orgInfo.getString("RelativeOrgID");
				if(relativeOrgID == null || relativeOrgID.equals(orgID))
				{
					break;
				}
				else
					orgID = relativeOrgID;
			}
		}
		
		if(coreAccount == null) 
			throw new Exception("δ�ҵ������ţ���"+orgID+"���˻����ͣ���"+CodeCache.getItemName("OrgAccountType",accountType)+"�����֣���"+CodeCache.getItemName("Currency",currency)+"�����ڲ��˻���Ϣ��");
		
		return coreAccount;
	}

	/*
	 * ��ջ������
	 * @see com.amarsoft.dict.als.cache.AbstractCache#clear()
	 */
	public void clear() throws Exception {
		
	}

	/*
	 * ���ػ���������Ϣ
	 * @see com.amarsoft.dict.als.cache.AbstractCache#load(com.amarsoft.awe.util.Transaction)
	 */
	public synchronized boolean load(Transaction transaction) throws Exception {
		try
		{
			ASValuePool orgSet =  new ASValuePool();
			
			String sql = " select o.* from ORG_INFO o ";
			ASResultSet rs = transaction.getASResultSet(sql);
	        int columnCount = rs.getMetaData().getColumnCount();
	        while(rs.next()){
	        	ASValuePool orginfo = new ASValuePool();
	        	String orgID = DataConvert.toString(rs.getString("OrgID"));
	        	for(int i=1;i<=columnCount;i++){
	        		orginfo.setAttribute(rs.getMetaData().getColumnName(i), rs.getString(i));
	        	}
	        	orginfo.setAttribute("BelongOrgList",new ASValuePool());
	        	orginfo.setAttribute("OrgAccount", new ASValuePool());
	        	
	        	orgSet.setAttribute(orgID, orginfo);
	        }
	        rs.close();
	        
	        rs = transaction.getASResultSet(" select * from ORG_BELONG order by OrgID ");
			while(rs.next()){
				String orgID=rs.getString("OrgID");
				String belongOrgID=rs.getString("BelongOrgID");
				ASValuePool orgInfo =(ASValuePool) orgSet.getAttribute(orgID);
				if(orgInfo==null) continue;
				ASValuePool belongOrgList=(ASValuePool) orgInfo.getAttribute("BelongOrgList");
				belongOrgList.setAttribute(belongOrgID,orgSet.getAttribute(belongOrgID));
			}
			rs.close();
			//ȡ���������Ĵ���ڲ��˻���Ϣ
			rs = transaction.getASResultSet(" select * from ACCT_CORE_ACCOUNT order by OrgID,AccountType,Currency ");
			while(rs.next()){
				String orgID = rs.getString("OrgID");
				String accountType = rs.getString("AccountType");
				String currency = rs.getString("Currency");
				ASValuePool orgInfo =(ASValuePool) orgSet.getAttribute(orgID);
				if(orgInfo==null) continue;
				ASValuePool orgAccount=(ASValuePool) orgInfo.getAttribute("OrgAccount");
				
				BusinessObject abo = new BusinessObject("jbo.app.ACCT_CORE_ACCOUNT",rs.rs);
				orgAccount.setAttribute(accountType+"@"+currency,abo);
			}
			rs.close();
			OrgConfig.orgSet = orgSet;
			return true;
		}catch(Exception ex)
		{
			ex.printStackTrace();
			throw ex;
		}
	}
}
