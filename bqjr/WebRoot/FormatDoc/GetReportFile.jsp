<%@ page contentType="text/html; charset=GBK"%><%@ include file="/IncludeBeginMDAJAX.jsp"%><%
	/*
		Author:   xdhou  2005.02.17
		Content: 检查生成的格式化报告文件是否存在
		Input Param:
			DocID: 文档类别（ FORMATDOC_CATALOG中的调查报告，贷后检查报告，...)
			ObjectNo：对象编号
			ObjectType：对象类型
	 */
	String sFlag = "",sSerialNoNew = "",sFileName = "";	
	//获得页面参数	
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectNo")); 		//业务流水号
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectType")); 	//对象类型
	String sDocID = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("DocID")); 	//对象类型
	//将空值转化为空字符串
	if(sObjectNo == null) sObjectNo = "";
	if(sObjectType == null) sObjectType = "";
	if(sDocID == null) sDocID = "";
	//cdeng 2009-02-12 获取文档存储路径方式
	ASResultSet rs = null;
	String sSql1="";
	String sSerialNo = "";
	sSql1=" select SerialNo,SavePath from Formatdoc_Record where ObjectType='"+sObjectType+"' and  ObjectNo='"+sObjectNo+"' ";
// 	if(!sObjectType.equals("PutOutApply"))
// 		sSql1=sSql1+" and DocID='"+sDocID+"'";
	rs = Sqlca.getASResultSet(sSql1);
	if(rs.next()){
		sSerialNo = rs.getString("SerialNo");
		sFileName = rs.getString("SavePath");
	}
	rs.getStatement().close();
	if(sSerialNo==null) sSerialNo="";
	if(sFileName==null) sFileName="";
	
	if(!sFileName.equals("")){
		java.io.File file = new java.io.File(sFileName);
		if(file.exists()){
			sFlag = sSerialNo;
		}else{
			sFlag = "move";
		}
	}else{
		sFlag = "false";
	}
	
	out.print(sFlag); 
%><%@ include file="/IncludeEndAJAX.jsp"%>