<%@page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBeginMDAJAX.jsp"%><%@
 page import="com.amarsoft.app.util.ASLocator"%><%
	/*
		Content: ��ȡ�ļ��б�
	 */
	StringBuffer sbReturn = new StringBuffer("");
	String sReturn;
	String sReturnValue="";
	
	//����������	
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
		//out.println("����ʧ��!����:"+ex.toString());
		sReturn = "failed";
	}
 
	ArgTool args = new ArgTool();
	args.addArg(sReturn);
	sReturnValue = args.getArgString();

	out.println(sReturnValue);
%>
<%@ include file="/IncludeEndAJAX.jsp"%>