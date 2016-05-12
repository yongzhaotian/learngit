<!DOCTYPE html>
<%@page import="java.net.InetAddress"%>
<%@page import="com.amarsoft.app.als.image.ImageAuthManage"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>

<%
	//获得组件参数	,影像对象号（客户号或申请号）、影像类型号
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	String sTypeNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("TypeNo"));
	String sRightType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("RightType"));
	if( sObjectType == null ) sObjectType = "";
	if( sObjectNo == null ) sObjectNo = "";
	if( sTypeNo == null ) sTypeNo = "";
	if( sRightType == null ) sRightType = "";
	
	ARE.getLog().info("****************"+sObjectType +"  " + sObjectNo+" "+sTypeNo+"------"+sRightType);
	
	//获取权限
	String sAuthCode = "";
	/* if( sRightType.equals( "ReadOnly" ) ) sAuthCode = "100";	//如果页面只读，则只有查看权
	else sAuthCode = ImageAuthManage.getAuthCode( sObjectType, sObjectNo, CurUser.getUserID() ); */
	sAuthCode = sRightType;
	
	//查找对应的docId
	ASResultSet resultSet= Sqlca.getResultSet(
			new SqlObject("select  documentId  from  ECM_PAGE where objectType=:objectType and objectNo=:objectNo and typeNo=:typeNo and documentId is not null order by pageNum")
				.setParameter("objectType", sObjectType).setParameter("objectNo", sObjectNo).setParameter("typeNo", sTypeNo)
	);
	StringBuffer sbuf = new StringBuffer();
	while(resultSet.next()){
		sbuf.append(resultSet.getString("documentId")+"|");
	}
	
	resultSet.getStatement().close();
	
	//插件要访问的servlet地址
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
<title>影像资料</title>
</head>
<body>
	<object id="amarsoftECMObject" classid="clsid:FED91F2B-DDF8-42E7-9CBF-6FA56B80EDF3" codebase="AmarECM_ActiveXSetup.CAB#version=1,0,0" width="100%" border="0" style="margin:0px;border-width: 0;padding-top: 0px;"></object>
	<script type="text/javascript" >
           function initActiveX() {
               var obj = document.getElementById("amarsoftECMObject");
               obj.height = document.documentElement.clientHeight-58;
               	/* 参数：对象类型，对象编号，影像类型，权限控制代码，各个图片文件的路径(多张图片时以|为分割)，操作人，操作机构，处理影像的servlet地址 */
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