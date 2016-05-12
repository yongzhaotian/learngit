package com.amarsoft.app.lending.bizlets;


import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

/**
 * ��С��ҵ�ͻ��϶�ģ��ƥ�Լ��,���������ְ�����������۶�ʲ��ܶ��Զ�����ͻ���ģ
 * <p>
 * <h1>�����߼�</h1>
 * <ol>
 * </ol>
 * </p>
 * Time: 2009/10/15
 * 
 * @author pwang
 * @history jgao 2009/11/02 �޸��䴫��������жϷ�ʽ
 */
public class CheckSMECustomer extends Bizlet {
	/**
	 * �������
	 * @return 	<li>true ����ģ��</li>
	 * 			<li>false ������ģ��</li>
	 */
	public Object run(Transaction Sqlca) throws Exception {
		/*
		 * ��ȡ����
		 */
		String sCustomerID = (String) this.getAttribute("CustomerID");
		if (sCustomerID == null)
			sCustomerID = "";

		/*
		 * �������
		 */
		String sReturn = "";
		String Flag = "false";
		String sSql = "";
		ASResultSet rs = null;
		int iEmployeeNum = 0; // ְ������
		double dSaleSum = 0.0; // ���۶�
		double dAssetSum = 0.0; // �ʲ��ܶ�
		String sScope = "";// ��ҵ����
		String sSMEIndustryType = "";// ��С��ҵ��ҵ����   
		// ���ݿͻ���Ų�ѯ������С��ҵ�϶���׼
		sSql = " select Scope,SMEIndustryType,EmployeeNumber,SellSum,TotalAssets "
				+ " from ENT_INFO  where CustomerID=:sCustomerID";
		rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("sCustomerID", sCustomerID));
		if (rs.next()) {
			iEmployeeNum = rs.getInt("EmployeeNumber");
			dSaleSum = rs.getDouble("SellSum");
			dAssetSum = rs.getDouble("TotalAssets");
			sScope = rs.getString("Scope");
			sSMEIndustryType = rs.getString("SMEIndustryType");
		}
		rs.getStatement().close();
		if (sScope == null)
			sScope = "";
		if (sSMEIndustryType == null)
			sSMEIndustryType = "";
		String sEmployeeNum = String.valueOf(iEmployeeNum);
		String sSaleSum = String.valueOf(dSaleSum);
		String sAssetSum = String.valueOf(dAssetSum);

		/*
		 * �����ж���С��ҵ��ģ���෽��
		 */
		Bizlet bzCheckSMEAction = new CheckSMECustomerAction();
		bzCheckSMEAction.setAttribute("IndustryType", sSMEIndustryType);
		bzCheckSMEAction.setAttribute("EmployeeNum", sEmployeeNum);
		bzCheckSMEAction.setAttribute("SaleSum", sSaleSum);
		bzCheckSMEAction.setAttribute("AssetSum", sAssetSum);
		sReturn = String.valueOf(bzCheckSMEAction.run(Sqlca));
		//9 ��ʾ��������ƥ���κ�ģ�͵�
		if (!sReturn.equals("9")&&sReturn.equals(sScope)) {
			Flag = "true";
		}
		return Flag;
	}
}
