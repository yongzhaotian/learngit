<%@page import="com.amarsoft.are.io.FileFilterByName"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<% 
	String dataHome = "/xdgl/als7/log";
	java.io.File logDir = new java.io.File(dataHome);
	if(logDir==null) {
		out.println("<font color='red'>No Directory Define</font>");
		return;
	}
%>
<script type="text/javascript">
	function viewFile(file){
		AsControl.OpenView("/AppConfig/ControlCenter/LogManage/FileView.jsp", "file="+file+"&ViewType=view", "_blank", OpenStyle);
	}
	
	function deleteFile(file,filename){
		if(confirm("确定删除文件\""+filename+"\"吗？")){
			var sReturn = PopPageAjax("/AppConfig/ControlCenter/LogManage/DeleteFile.jsp?file="+file, "");
			alert(sReturn); //将返回信息提示出来
			reloadSelf();
		}
	}
	
	function downloadFile(file){
		AsControl.OpenView("/AppConfig/ControlCenter/LogManage/FileView.jsp", "file="+file+"&ViewType=save", "_blank", OpenStyle);
	}
</script>
<body leftmargin="0" topmargin="0" >
<div style="position:absolute;width:100%; height:100%; z-index:1; overflow: auto" align="center">
    <table width="100%" border="1" cellspacing="0" cellpadding="0">
    <tr>
    	<th nowrap bgcolor=#F0F0F0>日志文件</th>
    	<th nowrap bgcolor=#F0F0F0>最后修改时间</th>
    	<th nowrap bgcolor=#F0F0F0>大小</th>
    	<th nowrap bgcolor=#F0F0F0 colspan="2">操作</th>
   	</tr>
    <% 
		if(logDir.exists() && logDir.isDirectory()){
			FileFilterByName ff = new FileFilterByName("",".*\\.log");
			ff.setDirectoryInclude(false);
			java.io.File lf[] = logDir.listFiles((java.io.FileFilter)ff);
			for(int j=0;j<lf.length;j++){
				String sFile = java.net.URLEncoder.encode(lf[j].getPath().replaceAll("\\\\","/"),"UTF-8");
			%>
			<tr align="center">
				<td nowrap>
					<a href="javascript:void()" onClick="viewFile('<%=sFile%>')">
				 	<%=lf[j].getName()%></a>
				</td>
				<td nowrap><%=new java.util.Date(lf[j].lastModified()).toLocaleString()%></td>
				<td nowrap><%=lf[j].length()/1024+1%>K</td>
				<td nowrap>
					<a href="javascript:void()" 
						onClick="downloadFile('<%=sFile%>')">[查看、下载文件...]</a>
				</td>
				<td nowrap>
					<a href="javascript:void()" 
						onClick="deleteFile('<%=sFile%>','<%=lf[j].getName()%>')">[删除文件...]</a>
				</td>
			</tr>
			<%}
		}else{%>
			<tr>
				<td colspan="4">定义的日志路径"<%=logDir.getPath()%>"不存在</td>
			</tr>
		<%}%>
    </table>
</div>
</body>
<%@ include file="/IncludeEnd.jsp"%>