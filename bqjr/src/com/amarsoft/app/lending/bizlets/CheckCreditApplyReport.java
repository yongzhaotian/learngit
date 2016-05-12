/**
 * Author: ��ҵ� 2005-08-03
 * Tester:
 * Describe: �����鱨���Ƿ�����
 * Input Param:
 * 		sObjectType����������
 * 		sObjectNo��������
 * Output Param:
 * HistoryLog:
 */
package com.amarsoft.app.lending.bizlets;

import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;


public class CheckCreditApplyReport extends Bizlet 
{
	public Object  run(Transaction Sqlca) throws Exception
	{
		//�Զ���ô���Ĳ���ֵ
		String sObjectType   = (String)this.getAttribute("ObjectType");
		String sObjectNo   = (String)this.getAttribute("ObjectNo");
		if(sObjectType==null)sObjectType="";
		if(sObjectNo==null)sObjectNo="";

		String sFileName = "",sDocID = "",sFlag = "";
		//��Ϊ�Ӹ�ʽ�������¼����ȡ�ļ���
	    String sSql=" select SavePath,DocID from FORMATDOC_RECORD where ObjectType=:ObjectType and  ObjectNo=:ObjectNo";
	    ASResultSet rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("ObjectType", sObjectType).setParameter("ObjectNo", sObjectNo));
		if(rs.next()){
			sFileName = rs.getString("SavePath");
			sDocID = rs.getString("DocID");
		}
		rs.getStatement().close();
		if(sFileName==null) sFileName="";
		if(sDocID==null) sDocID="";
		
	    java.io.File file = new java.io.File(sFileName);
	    if(file.exists()){
			sFlag = "true";
		}else{
			sFlag = "false";
		}
	    if (sFlag == "false") return "alert('���鱨�滹δ����,�޵��鱨����ϸ��Ϣ��')";
	    return "OpenPage('/FormatDoc/PreviewFile.jsp?DocID="+sDocID+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType+"&FrameName=TabContentFrame','TabContentFrame','')";
	 }
}
