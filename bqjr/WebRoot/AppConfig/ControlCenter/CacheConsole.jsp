<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%@page import="com.amarsoft.awe.res.model.SkinItem"%>
<%@ page import="com.amarsoft.dict.als.cache.CacheLoaderFactory"%>
<%@ page import="com.amarsoft.dict.als.cache.CacheDefine"%>
<body class="ListPage" leftmargin="0" topmargin="0" >
<div id="Layer1" style="position:absolute;width:100%; height:100%; z-index:1; overflow: auto">
<div class="strip_tit" >
	<table border=1 cellspacing=0 cellpadding=0 bordercolordark="#FFFFFF" bordercolorlight="#666666" style='cursor: pointer;' width='100%'>
		<tr bgcolor="#00659C" valign=center height="20"> 
			<td><font color="#FFFFFF">缓存控制台</font></td>
		</tr>
	</table>
</div>
<div class="strip_doc" style="height: 90%;display: block">
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
	  	<ul>
	  	<tr>
		    <td>
		        <li><a href="javascript:AsDebug.reloadFixSkins()">重载定制皮肤【<%=SkinItem.getFixSkinFolder()%>】</a></li>
		    </td>
		</tr>
	  	<tr>
		    <td>
		        <li><a href="javascript:AsDebug.reloadConfigFile()">重载配置文件【<%=CurConfig.getConfigFile()%>】</a></li>
		    </td>
		</tr>
		<tr>
		    <td>
		        <li><a href="javascript:AsDebug.reloadCacheAll()">重新载入【所有参数】缓存</a></li>
		    </td>
	  	</tr>
	  	<%
	  	Map<String,CacheDefine> cachesList = CacheLoaderFactory.getCachesList();
	  	String [] keys = (String [])cachesList.keySet().toArray(new String[0]);
		for (int iKey=0; iKey < keys.length; iKey ++) {
			CacheDefine cache = cachesList.get(keys[iKey]);
		%>				
	  	<tr>
		    <td>
		        <li><a href="javascript:AsDebug.reloadCache('<%=keys[iKey]%>')">刷新【<%=keys[iKey]%>】缓存</a><%="  说明：装载类【"+cache.getLoadClass()+"】大小【"+cache.getSize()+"】有效期【"+cache.getExpireTime()/1000+"】秒"%></li>
		    </td>
	  	</tr>
		<%}%>
	     </ul>
	</table>
</div>	
</div>
</body>
<%@ include file="/IncludeEnd.jsp"%>