/*
		Author: --ccxie 2010/03/15
		Tester:
		Describe: --���ش򿪾������̵���������ҳ������Ҫ�Ĳ�����Ϣ
		Input Param:
					ObjectNo  	ҵ�������
					ObjectType  ��������
					ParaType    ���ؾ��������ʶ���־
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

		// ���ҵ�������
		String sObjectNo = (String) this.getAttribute("ObjectNo");
		// �����������
		String sObjectType = (String) this.getAttribute("ObjectType");
		// ��ȡ��Ҫ���صĲ�������
		// ParaType=FlowDetailPara���ش�����ҳ���������
		// ParaType=FlowOpinionPara���ش����ҳ���������
		String sParaType = (String) this.getAttribute("ParaType");
		// ����ֵת���ɿ��ַ���
		if (sObjectNo == null)  sObjectNo = "";
		if (sObjectType == null) sObjectType = "";
		if (sParaType == null) sParaType = "";
		// ���������Sql���
		String sSql = "", sItemDescribe = "", sItemAttribute = "";
		// �����������ѯ�����
		ASResultSet rs = null;
		// ���巵�ر���
		String paraString = "";
		//��ȡ�򿪾�������ҳ���URL��ItemDescribe����������ҳ���URL ItemAttribute���������ҳ���URL
		sSql = "select ItemDescribe,ItemAttribute from CODE_lIBRARY where CodeNo = 'FlowObject' and ItemNo = :sObjectType";
		rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("sObjectType", sObjectType));
		if (rs.next()) {
			sItemDescribe = rs.getString("ItemDescribe");
			sItemAttribute = rs.getString("ItemAttribute");
		}
		rs.getStatement().close();
		//��������ҳ��URL�Ĳ����滻����
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
		//�������ҳ��URL�Ĳ����滻����
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
