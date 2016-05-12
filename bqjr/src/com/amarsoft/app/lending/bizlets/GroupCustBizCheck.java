package com.amarsoft.app.lending.bizlets;

import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;


/**
 * ���ſͻ���;ҵ���飬�ڼ��ſͻ�ת�ƹ���Ȩʱ����Ҫ�Լ��ſͻ���Ӧҵ�������<br/>
 * ϵͳ�У�Ŀǰֻ���м��ſͻ���������룬���������룬���ֻҪ��������������<br/>
 * 1.����Ƿ������;����<br/>
 * 2.����Ƿ����δ����ͨ���������������<br/>
 * 3.����ѵǼ��˺�ͬ������ͬ�Ƿ񡰵Ǽ���ɡ�<br/>
 * @author syang 2009/11/04
 *
 */
public class GroupCustBizCheck extends Bizlet {

	/**
	 * ���ſͻ�ID
	 */
	private String sCustomerID = "";
	private Transaction Sqlca = null;
	SqlObject so=null;//��������
	/**
	 * @return 
	 * 0 δ�����ҵ�����Ϊ0(ͨ��)<br/>
	 * 1 ����;�������<br/>
	 * 2 ��δ����ͨ���������������<br/>
	 * 3 ��δ�Ǽ���ɵĺ�ͬ<br/>
	 */
	public Object run(Transaction Sqlca) throws Exception{
		/*
		 * ��ȡ����
		 */
		this.sCustomerID = (String)this.getAttribute("CustomerID");
		this.Sqlca = Sqlca;
		
		/*
		 * ��������
		 */
		String sReturn = "0";
		
		if(businessApplyCount() > 0){
			sReturn = "1";
			return sReturn;
		}
		if(businessApproveCount() > 0){
			sReturn = "2";
			return sReturn;
		}
		if(businessContractCount() > 0){
			sReturn = "3";
			return sReturn;
		}
		return sReturn;
	}
	
	/**
	 * �ͻ���;����ͳ��
	 * @return
	 * ������;�������
	 * @throws Exception 
	 */
	private int businessApplyCount() throws Exception{
		int iResult = 0;
		//�����ҵ������δ�鵵������Ϊ��δ����
		String sSql = " select count(SerialNo) from BUSINESS_APPLY where CustomerID =:CustomerID and PigeonholeDate is null ";
		so = new SqlObject(sSql).setParameter("CustomerID", sCustomerID);
		String sCount = Sqlca.getString(so);
		if(sCount == null) sCount = "0";
		iResult = Integer.parseInt(sCount);
		return iResult;
	}
	
	/**
	 * �ͻ�δ������ɵ�����ͳ��
	 * @return��δ������ɵ�����
	 * @throws Exception 
	 */
	private int businessApproveCount() throws Exception{
		int iResult = 0;
		//���������δ�鵵������Ϊ��δ����
		String sSql = " select count(*) from BUSINESS_APPROVE where CustomerID =:CustomerID and PigeonholeDate is null ";
		so = new SqlObject(sSql).setParameter("CustomerID", sCustomerID);
		String sCount = Sqlca.getString(so);
		if(sCount == null) sCount = "0";
		iResult = Integer.parseInt(sCount);
		return iResult;
	}
	
	/**
	 * ���ſͻ�δ���Ǽ���ɡ��ĺ�ͬͳ��
	 * @return�����Ǽ���ɡ��ĺ�ͬ����
	 * @throws Exception 
	 */
	private int businessContractCount() throws Exception{
		int iResult = 0;
		String sSql = " select count(*) from BUSINESS_CONTRACT where CustomerID =:CustomerID and FinishDate is null ";
		so = new SqlObject(sSql).setParameter("CustomerID", sCustomerID);
		String sCount = Sqlca.getString(so);
		if(sCount == null) sCount = "0";
		iResult = Integer.parseInt(sCount);
		return iResult;
	}
	
}
