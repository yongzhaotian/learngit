/*
 *	Author: jgao1 2009-10-26
 *	Tester:
 *	Describe: �����弶���������PARA_CONFIGUREȡ���弶����Ļ��ַ�ʽ
 *	Input Param:
 *	Output Param:
 *			sClassifyType���弶���໮�ַ�ʽ
 *	HistoryLog:
 *
 */
package com.amarsoft.app.lending.bizlets;

import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

public class GetClassifyType extends Bizlet {
	public Object run(Transaction Sqlca) throws Exception {
		String sSql = "";
		String sClassifyType = "";
		//��ѯ���ñ������õ��弶�������ý�ݻ��Ǻ�ͬ��Ĭ�����ý�ݡ�
		sSql = " select para1 from PARA_CONFIGURE where ObjectType='Classify' and ObjectNo='100'"; 
		sClassifyType = Sqlca.getString(sSql);
		if(!sClassifyType.equals("BusinessDueBill") && !sClassifyType.equals("BusinessContract")){
			sClassifyType = "BusinessDueBill";
        }	
		return sClassifyType;
	}
}