<%@page import="com.amarsoft.awe.control.SessionListener"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%Runtime runtime = Runtime.getRuntime();%>
<body class="ListPage" leftmargin="0" topmargin="0" >
<div id="Layer1" style="position:absolute;width:100%; height:100%; z-index:1; overflow: auto">
<%
int i=0;
%>
<table align='center' width='99%'  cellspacing="4" cellpadding="0">
  <tr > 
    <td colspan="4"> 
      <table border=1 cellspacing=0 cellpadding=0 bordercolordark="#FFFFFF" bordercolorlight="#666666" style='cursor: pointer;' width='100%'>
		<tr>
		<td>
		  <table border=0 cellpadding=0  cellspacing=0 width='100%'>
			<tr bgcolor='#EEEEEE' id=ConditonMap<%=i%>Tab valign=center height='20'> 
			  <td align=right valign='middle'> <img alt='' border=0 id=ConditonMap<%=i%>Tab3 onClick="showHideContent(event,'ConditonMap<%=i%>','<%=i%>');"  src='<%=sResourcesPath%>/expand.gif' style='cursor: pointer;' width='15' height='15'> 
			  </td>
			  <td align=left width='100%' valign='middle' onClick="javascript:document.getElementById('ConditonMap<%=i%>Tab3').click();"> 
				<table>
				  <tr> 
					<td> <font color=#000000 id=ConditonMap<%=i%>Tab2 >运行参数</font> 
					</td>
				  </tr>
				</table>
			  </td>
			  <td align=right valign='top'> <img alt='' border=0 id=ConditonMap<%=i%>Tab1 src='<%=sResourcesPath%>/curve1.gif' width='0' height='0'> 
			  </td>
			</tr>
		  </table>
		</td>
	  </tr>
      </table>
    </td>
  </tr>
  <tr> 
    <td colspan="4"> 
      <div id=ConditonMap<%=i%>Content style=' WIDTH: 100%;display:none'> 
	<table class='conditionmap' width='100%' align='left' border='1' cellspacing='0' cellpadding='4' bordercolordark="#FFFFFF" bordercolorlight="#666666">
	<tr>
		<td>
			<table width="100%" border="0" cellspacing="0" cellpadding="4">
			  <ul>
        <tr>
          <td width="100%" >
              <li><strong>CPU:</strong> <%="availableProcessors="+runtime.availableProcessors()%></li>
          </td>
        </tr>
        <tr>          
          <td width="100%" >
              <li><strong>MEM: </strong><%="maxMemory=["+runtime.maxMemory()/1024/1024+"M] freeMemory=[" + runtime.freeMemory()/1024/1024 +"M] totalMemory=[" + runtime.totalMemory()/1024/1024+"M]"%></li>
          </td>
        </tr>
        <tr>
          <td width="100%" >
              <li><strong>AppServer: </strong><%="ServerInfo=[" + application.getServerInfo() + "] WebAppVersion=[" + application.getMajorVersion() + "." + application.getMinorVersion()+"]"%></li>
          </td>
        </tr>
        <tr>
          <td width="100%" >
              <li><strong>Context: </strong><%="ContextPath= [" + request.getContextPath() + "] WebRealPath= [" + application.getRealPath("") + "] ContextName = ["+application.getServletContextName()+"]"%></li>
          </td>
        </tr>
        <tr>
          <td width="100%" >
              <li><strong>Context: </strong><%="ServerName= [" + request.getServerName() + "] ServerPort= [" + request.getServerPort()+ "] RemoteAddr= [" + request.getRemoteAddr()+ "] LocalAddr= [" + request.getLocalAddr()+"] LocalPort= [" + request.getLocalPort()+"]"%></li>
          </td>
        </tr>
        <tr>
          <td width="100%" >
              <li><strong>Online User: </strong><%="Count = [" + SessionListener.getCount() + "]"%>
          		<a href="#" onclick="javascript:AsDebug.showOnlineUserList();">查看</a>
              </li>
          </td>
        </tr>
        <%HashSet sessions = (HashSet) application.getAttribute("sessions");
        if (sessions != null) { %> 
        <tr>
          <td width="100%" >
              <li><strong>SessionTotal: </strong><%="Count = [" + sessions.size() + "]"%></li>
          </td>
        </tr>
        <%} %>
        </ul>
		</table>
		</td>
	</tr>
	</table>
      </div>
    </td>
  </tr>
<%
i++;
%>
  <tr> 
    <td colspan="4"> 
      <table border=1 cellspacing=0 cellpadding=0 bordercolordark="#FFFFFF" bordercolorlight="#666666" width='100%'>
		<tr>
		<td>
		  <table border=0 cellpadding=0  cellspacing=0 style='cursor: pointer;' width='100%'>
			<tr bgcolor='#EEEEEE' id=ConditonMap<%=i%>Tab valign=center height='20'> 
			  <td align=right valign='middle'> <img alt='' border=0 id=ConditonMap<%=i%>Tab3 onClick="showHideContent(event,'ConditonMap<%=i%>','<%=i%>');"  src='<%=sResourcesPath%>/expand.gif' style='cursor: pointer;' width='15' height='15'> 
			  </td>
			  <td align=left width='100%' valign='middle' onClick="javascript:document.getElementById('ConditonMap<%=i%>Tab3').click();"> 
				<table>
				  <tr> 
					<td> <font color=#000000 id=ConditonMap<%=i%>Tab2 >应用参数</font> 
					</td>
				  </tr>
				</table>
			  </td>
			  <td align=right valign='top'> <img alt=''' border='0' id=ConditonMap<%=i%>Tab1 src='<%=sResourcesPath%>/curve1.gif' width='0' height='0'> 
			  </td>
			</tr>
		  </table>
		</td>
	  </tr>
      </table>
    </td>
  </tr>
  <tr> 
    <td colspan="4"> 
      <div id=ConditonMap<%=i%>Content style=' WIDTH: 100%;display:none'> 
	<table class='conditionmap' width='100%' align='left' border='1' cellspacing='0' cellpadding='4' bordercolordark="#FFFFFF" bordercolorlight="#666666">
	<tr>
		<td>
			<table width="100%" border="0" cellspacing="0" cellpadding="4">
			  <ul>
			  <tr> 
			    <td width="50%" >
			        <li>RunMode:<strong><%=CurConfig.getConfigure("RunMode")%></strong></li>
			    </td>
			    <td width="50%" >
			        <li>FileSaveMode:<strong><%=CurConfig.getConfigure("FileSaveMode")%></strong> FileNameType:<strong><%=CurConfig.getConfigure("FileNameType")%></strong></li>
			    </td>
			  </tr>
			  <tr> 
			    <td width="50%" >
			        <li>FileSavePath:<strong><%=CurConfig.getConfigure("FileSavePath")%></strong></li>
			    </td>
			    <td width="50%" >
			        <li>WorkDocSavePath:<strong><%=CurConfig.getConfigure("WorkDocSavePath")%></strong></li>
			    </td>
			  </tr>
			  <tr> 
			    <td width="50%" colspan="2">
			        <li>基础产品版本:<strong><%=CurConfig.getConfigure("ProductName")%> <%=CurConfig.getConfigure("ProductID")%> <%=CurConfig.getConfigure("ProductVersion")%><strong></li>
			    </td>
			  </tr>
			  <tr> 
			    <td width="50%" colspan="2">
			        <li>客户增值版本:<strong><%=CurConfig.getConfigure("ImplementationName")%> <%=CurConfig.getConfigure("ImplementationID")%> <%=CurConfig.getConfigure("ImplementationVersion")%><strong></li>
			    </td>
			  </tr>
			  <tr> 
			    <td width="50%" colspan="2">
			        <li>客户:<strong><%=CurConfig.getConfigure("BankName")%><strong></li>
			    </td>
			  </tr>
		      </ul>
			</table>
		</td>
	</tr>
	</table>
      </div>
    </td>
  </tr>
</table>

</body>
</html>
<script type="text/javascript">
	//用以控制几个条件区的显示或隐藏
	function showHideContent(event,id,iStrip){
		var bMO = false;
		var bOn = false;
		var oTab    = document.getElementById(id+"Tab");
		var oTab2   = document.getElementById(id+"Tab2");
		var oImage   = document.getElementById(id+"Tab3");
		var oContent = document.getElementById(id+"Content");
		var oEmptyTag = document.getElementById(id+"EmptyTag");

		if (!oTab || !oTab2 || !oImage || !oContent) 
		return;
	
		var obj = event.srcElement || event.target;
		if (obj){
			bMO = (obj.src.toLowerCase().indexOf("_mo.gif") != -1);
			bOn = (oContent.style.display.toLowerCase() == "none");
		}

		if (bOn == false){
			oTab.bgColor = "#EEEEEE";
			oTab2.color  = "#000000";
			oContent.style.display = "none";
			if(oEmptyTag){
				oEmptyTag.style.display = "";
			}
			oImage.src = "<%=sResourcesPath%>/expand" + (bMO? ".gif" : ".gif");
		}else{
			oTab2.color  = "#ffffff";
			oTab.bgColor = "#00659C";
			oContent.style.display = "";
			if(oEmptyTag){
				oEmptyTag.style.display = "none";
			}
			oImage.src = "<%=sResourcesPath%>/collapse" + (bMO? "_mo.gif" : "_mo.gif");
		}
	}

	document.getElementById("ConditonMap0Tab3").click();
	document.getElementById("ConditonMap1Tab3").click();
</script>
<%@ include file="/IncludeEnd.jsp"%>