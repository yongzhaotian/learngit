<!DOCTYPE html>
<%@page import="java.net.InetAddress"%>
<%@page import="com.amarsoft.app.als.image.ImageAuthManage"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>

<%
	//����������	,Ӱ�����ţ��ͻ��Ż�����ţ���Ӱ�����ͺ�
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	String sTypeNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("TypeNo"));
	String sRightType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("RightType"));
	if( sObjectType == null ) sObjectType = "";
	if( sObjectNo == null ) sObjectNo = "";
	if( sTypeNo == null ) sTypeNo = "";
	if( sRightType == null ) sRightType = "";
	
	ARE.getLog().info("****************"+sObjectType +"  " + sObjectNo+" "+sTypeNo+"------"+sRightType);
	
	//��ȡȨ��
	String sAuthCode = "";
	/* if( sRightType.equals( "ReadOnly" ) ) sAuthCode = "100";	//���ҳ��ֻ������ֻ�в鿴Ȩ
	else sAuthCode = ImageAuthManage.getAuthCode( sObjectType, sObjectNo, CurUser.getUserID() ); */
	sAuthCode = sRightType;
	
	//���Ҷ�Ӧ��docId
	ASResultSet resultSet= Sqlca.getResultSet(
			new SqlObject("select  documentId  from  ECM_PAGE where objectType=:objectType and objectNo=:objectNo and typeNo=:typeNo and documentId is not null order by pageNum")
				.setParameter("objectType", sObjectType).setParameter("objectNo", sObjectNo).setParameter("typeNo", sTypeNo)
	);
	StringBuffer sbuf = new StringBuffer();
	while(resultSet.next()){
		sbuf.append(resultSet.getString("documentId")+"|");
	}
	
	resultSet.getStatement().close();
	
	//���Ҫ���ʵ�servlet��ַ
	String ip = request.getLocalAddr();
	if(StringX.isEmpty(ip)){
		ip = InetAddress.getByName(request.getServerName()).getHostAddress();
	} else if("0.0.0.0".equals(ip)){
		ip = "127.0.0.1";
	}
	String servletPath = "http://"+ip+":"+request.getLocalPort()+application.getContextPath()+"/servlet/ActiveX";
	
%>

<html>
<head>
<title>Ӱ������</title>
</head>
<body>
	<object id="amarsoftECMObject" classid="clsid:FED91F2B-DDF8-42E7-9CBF-6FA56B80EDF3" codebase="AmarECM_ActiveXSetup.CAB#version=1,0,0" width="100%" border="0" style="margin:0px;border-width: 0;padding-top: 0px;"></object>
	<script type="text/javascript" >
           function initActiveX() {
               var obj = document.getElementById("amarsoftECMObject");
               obj.height = document.documentElement.clientHeight-58;
               	/* �������������ͣ������ţ�Ӱ�����ͣ�Ȩ�޿��ƴ��룬����ͼƬ�ļ���·��(����ͼƬʱ��|Ϊ�ָ�)�������ˣ���������������Ӱ���servlet��ַ */
               obj.InitECM( "<%=sObjectType%>", "<%=sObjectNo%>",  "<%=sTypeNo%>", "<%=sAuthCode%>", "<%=sbuf.length()>0?sbuf.substring(0, sbuf.length()-1):""%>", "<%=CurUser.getUserID()%>", "<%=CurUser.getOrgID()%>",
               	"<%=servletPath%>" );
           }
           
       	$(document).ready(function(){
       		initActiveX();
    	});
      </script>
</body>
</html>



<%@ include file="/IncludeEnd.jsp"%>