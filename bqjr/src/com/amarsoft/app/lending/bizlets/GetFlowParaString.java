/*
		Author: --ccxie 2010/03/15
		Tester:
		Describe: --返回打开具体流程的详情或意见页面所需要的参数信息
		Input Param:
					ObjectNo  	业务对象编号
					ObjectType  流程类型
					ParaType    返回具体参数的识别标志
		Output Param:
					
		HistoryLog:
 */
package com.amarsoft.app.lending.bizlets;

import com.amarsoft.are.util.StringFunction;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

public class GetFlowParaString extends Bizlet {

	public Object run(Transaction Sqlca) throws Exception {

		// 获得业务对象编号
		String sObjectNo = (String) this.getAttribute("ObjectNo");
		// 获得流程类型
		String sObjectType = (String) this.getAttribute("ObjectType");
		// 获取需要返回的参数类型
		// ParaType=FlowDetailPara返回打开详情页面所需参数
		// ParaType=FlowOpinionPara返回打开意见页面所需参数
		String sParaType = (String) this.getAttribute("ParaType");
		// 将空值转化成空字符串
		if (sObjectNo == null)  sObjectNo = "";
		if (sObjectType == null) sObjectType = "";
		if (sParaType == null) sParaType = "";
		// 定义变量：Sql语句
		String sSql = "", sItemDescribe = "", sItemAttribute = "";
		// 定义变量：查询结果集
		ASResultSet rs = null;
		// 定义返回变量
		String paraString = "";
		//获取打开具体流程页面的URL：ItemDescribe是流程详情页面的URL ItemAttribute是流程意见页面的URL
		sSql = "select ItemDescribe,ItemAttribute from CODE_lIBRARY where CodeNo = 'FlowObject' and ItemNo = :sObjectType";
		rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("sObjectType", sObjectType));
		if (rs.next()) {
			sItemDescribe = rs.getString("ItemDescribe");
			sItemAttribute = rs.getString("ItemAttribute");
		}
		rs.getStatement().close();
		//流程详情页面URL的参数替换操作
		if (sParaType.equals("FlowDetailPara")) {
			if (sObjectType.equals("Customer")) {
				String customerID = Sqlca
						.getString(new SqlObject(" select ObjectNo from EVALUATE_RECORD where ObjectType =:sObjectType"
								+ "' and SerialNo= :sObjectNo").setParameter("sObjectType", sObjectType).setParameter("sObjectNo", sObjectNo));
				sItemDescribe = StringFunction.replace(sItemDescribe,
						"#CustomerID", customerID);
				sItemDescribe = StringFunction.replace(sItemDescribe,
						"#ObjectNo", customerID);
				sItemDescribe = StringFunction.replace(sItemDescribe,
						"#SerialNo", sObjectNo);
			} else if (sObjectType.equals("Classify")) {
				sSql = "select ObjectType as ResultType,ObjectNo as DuebillNo,ClassifyDate as AccountMonth,ModelNo from CLASSIFY_RECORD where SerialNo = :sObjectNo";
				rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("sObjectNo", sObjectNo));
				if (rs.next()) {
					sItemDescribe = StringFunction.replace(sItemDescribe,
							"#ResultType", rs.getString("ResultType"));
					sItemDescribe = StringFunction.replace(sItemDescribe,
							"#DuebillNo", rs.getString("DuebillNo"));
					sItemDescribe = StringFunction.replace(sItemDescribe,
							"#AccountMonth", rs.getString("AccountMonth"));
					sItemDescribe = StringFunction.replace(sItemDescribe,
							"#ModelNo", rs.getString("ModelNo"));
					sItemDescribe = StringFunction.replace(sItemDescribe,
							"#ObjectNo", sObjectNo);
				}
				rs.getStatement().close();
			} else {
				sItemDescribe = StringFunction.replace(sItemDescribe,
						"#ObjectNo", sObjectNo);
			}
			paraString = sItemDescribe;
		//流程意见页面URL的参数替换操作
		} else if (sParaType.equals("FlowOpinionPara")) {
			rs = Sqlca
					.getASResultSet(new SqlObject(" select FlowNo,PhaseNo from FLOW_OBJECT where ObjectType = :sObjectType"
							+ " and ObjectNo = :sObjectNo").setParameter("sObjectType", sObjectType).setParameter("sObjectNo", sObjectNo));
			if (rs.next()) {
				sItemAttribute = StringFunction.replace(sItemAttribute,
						"#FlowNo", rs.getString("FlowNo"));
				sItemAttribute = StringFunction.replace(sItemAttribute,
						"#PhaseNo", rs.getString("PhaseNo"));
				sItemAttribute = StringFunction.replace(sItemAttribute,
						"#ObjectNo", sObjectNo);
			}
			paraString = sItemAttribute;
		}
		return paraString;
	}

}
