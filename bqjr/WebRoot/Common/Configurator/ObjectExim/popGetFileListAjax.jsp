<%@page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBeginMDAJAX.jsp"%><%@
 page import="com.amarsoft.app.util.ASLocator"%><%
	/*
		Content: 获取文件列表
	 */
	StringBuffer sbReturn = new StringBuffer("");
	String sReturn;
	String sReturnValue="";
	
	//获得组件参数	
	String sRealPath =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("FilePath"));
	if(sRealPath==null) sRealPath="";

	try{
		System.out.println("Get Real Path File List--"+sRealPath);
		String[] saFileList = ASLocator.getFileList(sRealPath,".xml");
		for( int i=0; i < saFileList.length; i++ ){
			if( i > 0 ) sbReturn.append("$");
			sbReturn.append(saFileList[i]);
		}
		sReturn = sbReturn.toString();
		//oe.importFromXml(Sqlca,sObjectType+"_"+sObjectNo+".xml");
	}catch(Exception ex){
		//out.println("生成失败!错误:"+ex.toString());
		sReturn = "failed";
	}
 
	ArgTool args = new ArgTool();
	args.addArg(sReturn);
	sReturnValue = args.getArgString();

	out.println(sReturnValue);
%>
<%@ include file="/IncludeEndAJAX.jsp"%>