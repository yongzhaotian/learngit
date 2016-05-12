package com.amarsoft.app.lending.bizlets;


import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

/**
 * 中小企业客户认定模型匹对检查,根据输入的职工人数，销售额，资产总额自动计算客户规模
 * <p>
 * <h1>处理逻辑</h1>
 * <ol>
 * </ol>
 * </p>
 * Time: 2009/10/15
 * 
 * @author pwang
 * @history jgao 2009/11/02 修改其传入参数，判断方式
 */
public class CheckSMECustomer extends Bizlet {
	/**
	 * 调用入口
	 * @return 	<li>true 符合模型</li>
	 * 			<li>false 不符合模型</li>
	 */
	public Object run(Transaction Sqlca) throws Exception {
		/*
		 * 获取参数
		 */
		String sCustomerID = (String) this.getAttribute("CustomerID");
		if (sCustomerID == null)
			sCustomerID = "";

		/*
		 * 定义变量
		 */
		String sReturn = "";
		String Flag = "false";
		String sSql = "";
		ASResultSet rs = null;
		int iEmployeeNum = 0; // 职工人数
		double dSaleSum = 0.0; // 销售额
		double dAssetSum = 0.0; // 资产总额
		String sScope = "";// 企业类型
		String sSMEIndustryType = "";// 中小企业行业类型   
		// 根据客户编号查询出其中小企业认定标准
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
		 * 调用判断中小企业规模的类方法
		 */
		Bizlet bzCheckSMEAction = new CheckSMECustomerAction();
		bzCheckSMEAction.setAttribute("IndustryType", sSMEIndustryType);
		bzCheckSMEAction.setAttribute("EmployeeNum", sEmployeeNum);
		bzCheckSMEAction.setAttribute("SaleSum", sSaleSum);
		bzCheckSMEAction.setAttribute("AssetSum", sAssetSum);
		sReturn = String.valueOf(bzCheckSMEAction.run(Sqlca));
		//9 表示其它，不匹配任何模型的
		if (!sReturn.equals("9")&&sReturn.equals(sScope)) {
			Flag = "true";
		}
		return Flag;
	}
}
