/**
 * Author: 王业罡 2005-08-03
 * Tester:
 * Describe: 检查调查报告是否生成
 * Input Param:
 * 		sObjectType：对象类型
 * 		sObjectNo：对象编号
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
		//自动获得传入的参数值
		String sObjectType   = (String)this.getAttribute("ObjectType");
		String sObjectNo   = (String)this.getAttribute("ObjectNo");
		if(sObjectType==null)sObjectType="";
		if(sObjectNo==null)sObjectNo="";

		String sFileName = "",sDocID = "",sFlag = "";
		//改为从格式化报告记录表中取文件名
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
	    if (sFlag == "false") return "alert('调查报告还未生成,无调查报告详细信息！')";
	    return "OpenPage('/FormatDoc/PreviewFile.jsp?DocID="+sDocID+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType+"&FrameName=TabContentFrame','TabContentFrame','')";
	 }
}
