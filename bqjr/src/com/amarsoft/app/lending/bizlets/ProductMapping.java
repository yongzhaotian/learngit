package com.amarsoft.app.lending.bizlets;


import com.amarsoft.app.util.DataConvertTools;
import com.amarsoft.are.ARE;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;
import com.amarsoft.proj.action.SubProductMapping;



public class ProductMapping extends Bizlet{
	public Object run(Transaction Sqlca) throws Exception {
		//获取参数：合同编号若参数值为null,则转成空字符串
		String businessContractSerialNo = DataConvertTools.nullToEmptyString((String)this.getAttribute("SerialNo"));
		String flag = "";
		String ruleReturnSql ="select PostWorkflowCode from cashpost_data where serialno = (select Max(SerialNo) from cashpost_data where applyno = :ObjectNo)";
		String ruleReturn=Sqlca.getString(new SqlObject(ruleReturnSql).setParameter("ObjectNo", businessContractSerialNo));
		ARE.getLog().info("20150524------------------ybpan-----1----"+ruleReturn);
		if("APPROVE".equals(ruleReturn)||"CreditExpert".equals(ruleReturn)){
			ARE.getLog().info("20150524------------------ybpan-----2----"+ruleReturn);
			//检查该合同申请类型是否是无预约现金贷,若不是现金贷不走附条件审批
			String subProductTypeSql = "select subproducttype from business_contract where serialno = :ObjectNo";
			String subProductType=Sqlca.getString(new SqlObject(subProductTypeSql).setParameter("ObjectNo", businessContractSerialNo));
			if(!"2".equals(subProductType)){
				return flag="";
			}

			//ProductMapping prd = new ProductMapping();
			SubProductMapping prd = new SubProductMapping();
			//规则引擎是否返回期数跟金额
			String existPrincipalPeriodOrNot = prd.existPrincipalPeriodOrNot(Sqlca, businessContractSerialNo);
			if("false".equals(existPrincipalPeriodOrNot)){
				return "";
			}
			//
			String subConditionCapitalPeriod[] = prd.subConditionCapitalPeriod(Sqlca, businessContractSerialNo).split("@");
			int sPostCapital = Integer.parseInt(subConditionCapitalPeriod[0]);//规则引擎返回金额
			int sPostPeriod = Integer.parseInt(subConditionCapitalPeriod[1]);//规则引擎返回的期数
			int sBCCapital = Integer.parseInt(subConditionCapitalPeriod[2]);//合同标准的金额
			int sBCPeriod = Integer.parseInt(subConditionCapitalPeriod[3]);//合同表中的期数
			String sBCBusinessType = subConditionCapitalPeriod[4];//合同表中的产品编号
			String sProductSerialNO = "";//产品系列
			int sCprincipalNew = sBCCapital+sPostCapital;//附条件审批的金额
			int sPeriodNew = sBCPeriod+sPostPeriod;//附条件审批的金额
			String cprincipalMapping = prd.cprincipalMapping(Sqlca, sBCBusinessType, sCprincipalNew);
			if("FAIL".equals(cprincipalMapping)){
				flag = "REJECT";
				return flag;
			}else{
				sProductSerialNO=cprincipalMapping.split("@")[2];
			}
			String sPostBusinessType = prd.checkBusinessType(Sqlca, sCprincipalNew, sPeriodNew, sProductSerialNO);
			ARE.getLog().info("20150524------------------ybpan----3-----"+ruleReturn);
			if("".equals(sPostBusinessType)){
				flag = "REJECT";
				return flag;
			}else{
				ARE.getLog().info("20150524------------------ybpan----4-----"+ruleReturn);
				if("APPROVE".equals(ruleReturn)){
					flag="SUBEXAMINE";
				}else if("CreditExpert".equals(ruleReturn)){
					flag="";
				}
				return flag;
			}
		}
		return flag;
		
	}
}
