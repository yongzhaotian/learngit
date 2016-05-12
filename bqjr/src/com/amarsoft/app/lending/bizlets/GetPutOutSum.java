package com.amarsoft.app.lending.bizlets;

import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

public class GetPutOutSum extends Bizlet {

	public Object run(Transaction Sqlca) throws Exception {
		// 合同流水号
		String sContractSerialNo = (String) this
				.getAttribute("ContractSerialNo");
		// 出帐流水号
		String sSerialNo = (String) this.getAttribute("SerialNo");
		// 将空值转化为空字符串
		if (sContractSerialNo == null)
			sContractSerialNo = "";
		if (sSerialNo == null)
			sSerialNo = "";

		// 合同金额、合同余额、合同项下出帐总额 、借据非存量金额 、 借据存量金额
		double dBCBusinessSum = 0.0, dBCBalance = 0.0, dPutOutSum = 0.0, dBDBusinessSum = 0.0, dHisBusinessSum = 0.0;
		// Sql语句、合同项下出帐总额、循环标志
		String sSql = null, sPutOutSum = "", sCycleFlag = "", sReinforceFlag = "";
		// 查询结果集
		ASResultSet rs = null;

		// 根据合同流水号获取循环标志
		sSql = " select BusinessSum*GetErate(BusinessCurrency,'01','') as BusinessSum,Balance,CycleFlag,ReinforceFlag "
				+ " from BUSINESS_CONTRACT " + " where SerialNo = :sContractSerialNo";
		rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("sContractSerialNo", sContractSerialNo));
		if (rs.next()) {
			dBCBusinessSum = rs.getDouble("BusinessSum");
			dBCBalance = rs.getDouble("Balance");
			sCycleFlag = rs.getString("CycleFlag");
			sReinforceFlag = rs.getString("ReinforceFlag");
			if (sCycleFlag == null)
				sCycleFlag = "";
			if (sReinforceFlag == null)
				sReinforceFlag = "";
		}
		rs.getStatement().close();

		// 查询存量借据金额，按照借据表里有记录而出账表里无记录的条件标识存量借据。add by djia 20100722
		//存量借据定义：借据表里有记录而出账表里无记录的借据  
		//非存量借据定义：借据表里记录出帐表中也有记录的借据
		
		    //查询非存量借据金额
			sSql = " select sum(BD.BusinessSum*GetErate(BD.BusinessCurrency,'01','')) as BusinessSum "
					+ " from BUSINESS_DUEBILL BD, BUSINESS_PUTOUT BP"
					+ " where BD.RelativeSerialno1 = BP.Serialno"
					+ " and RelativeSerialno2 = :sContractSerialNo";
			rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("sContractSerialNo", sContractSerialNo));
			if (rs.next()) {
				//BusinessSum:非存量借据金额
				dBDBusinessSum = rs.getDouble("BusinessSum");
			}
			rs.getStatement().close();

		    //计算存量借据总金额
			sSql = " select sum(BusinessSum*GetErate(BusinessCurrency,'01','')) as BusinessSum"
					+ " from BUSINESS_DUEBILL "
					+ " where RelativeSerialno2 = :sContractSerialNo ";
			rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("sContractSerialNo", sContractSerialNo));
			if (rs.next()) {
				//HisBusinessSum:存量借据金额 = 借据总金额 - 非存量借据金额
				dHisBusinessSum = rs.getDouble("BusinessSum") - dBDBusinessSum;
			}
			rs.getStatement().close();
			
		// 查询合同项下的出帐金额
		if (sSerialNo.equals("")) {
			sSql = " select sum(BusinessSum*GetErate(BusinessCurrency,'01','')) as BusinessSum "
					+ " from BUSINESS_PUTOUT " + " where ContractSerialNo = :sContractSerialNo";
			rs=Sqlca.getASResultSet(new SqlObject(sSql).setParameter("sContractSerialNo", sContractSerialNo));
		} else {
			sSql = " select sum(BusinessSum*GetErate(BusinessCurrency,'01','')) as BusinessSum "
					+ " from BUSINESS_PUTOUT " + " where SerialNo <> :sSerialNo"
					+ " and ContractSerialNo = :sContractSerialNo";
			rs=Sqlca.getASResultSet(new SqlObject(sSql).setParameter("sSerialNo", sSerialNo).setParameter("sContractSerialNo", sContractSerialNo));
		}

		if (rs.next()) {
			dPutOutSum = rs.getDouble("BusinessSum");
		}
		rs.getStatement().close();

		if (sCycleFlag.equals("1")) // 循环标志（1：是；2：否）
			// 可循环合同的可出账金额 = （合同金额 - 出账表已出帐无借据的金额 - 合同余额
			//出账表已出帐无借据的金额 = (合同项下出帐总金额 - 非存量借据金额)
			dPutOutSum = (dBCBusinessSum - (dPutOutSum - dBDBusinessSum) - dBCBalance);
		else
			// 不可循环合同的可出账金额 = 合同金额 - 出账表已出帐金额 - 借据表存量金额
			dPutOutSum = dBCBusinessSum - dPutOutSum - dHisBusinessSum;

		sPutOutSum = String.valueOf(dPutOutSum);
		return sPutOutSum;
	}

}
