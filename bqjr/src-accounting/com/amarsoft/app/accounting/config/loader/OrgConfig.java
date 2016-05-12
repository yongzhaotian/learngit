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
 * 机构信息
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
	 * 通过本系统机构号获取核心机构号
	 * @param OrgID
	 * @return
	 * @throws Exception
	 */
	public static String getMFOrgID(String OrgID) throws Exception
	{
		ASValuePool  orgInfo = (ASValuePool)orgSet.getAttribute(OrgID);
		if(orgInfo == null) return OrgID;//如果未找到机构信息，则直接返回传入机构号
		return orgInfo.getString("MAINFRAMEORGID");
	}
	
	
	/**
	 * 通过机构号得到机构对象
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
	 * 取对应机构、账户类型、币种的内部账号信息
	 * @param orgID
	 * @param accountType
	 * @param currency
	 * @return 账号@账户名@账户机构@账户币种@账户类型@账户标示$账号@账户名@账户机构@账户币种@账户类型@账户标示$……
	 * @throws Exception
	 */
	public static String getOrgAccount(String orgID,String accountType,String currency) throws Exception
	{
		ASValuePool orgInfo = (ASValuePool)orgSet.getAttribute(orgID);
		if(orgInfo == null) throw new Exception("未找到机构号为【"+orgID+"】的机构信息！");
		ASValuePool orgAccount = (ASValuePool)orgInfo.getAttribute("OrgAccount");
		
		BusinessObject coreAccount = (BusinessObject)orgAccount.getAttribute(accountType+"@"+currency);
		if(coreAccount == null) 
			throw new Exception("未找到机构号：【"+orgID+"】账户类型：【"+accountType+"】币种：【"+currency+"】的内部账户信息！");
		
		Item accountTypeItem = CodeCache.getItem("OrgAccountType", accountType);
		if(accountTypeItem == null)
			throw new Exception("代码【OrgAccountType】定义中未找到账户类型：【"+accountType+"】");
		return coreAccount.getString("CoreAccountNo")+"@"+coreAccount.getString("CoreAccountName")
			+"@"+coreAccount.getString("OrgID")+"@"+coreAccount.getString("Currency")+"@"+accountTypeItem.getItemDescribe();
	}
	
	/**
	 * 取对应机构、账户类型、币种的内部账号信息，如果账号不存在则找该机构的上级机构信息
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
			if(orgInfo == null) throw new Exception("未找到机构号为【"+orgID+"】的机构信息！");
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
			throw new Exception("未找到机构号：【"+orgID+"】账户类型：【"+CodeCache.getItemName("OrgAccountType",accountType)+"】币种：【"+CodeCache.getItemName("Currency",currency)+"】的内部账户信息！");
		
		return coreAccount;
	}

	/*
	 * 清空缓存对象
	 * @see com.amarsoft.dict.als.cache.AbstractCache#clear()
	 */
	public void clear() throws Exception {
		
	}

	/*
	 * 加载机构定义信息
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
			//取机构所属的存款内部账户信息
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
