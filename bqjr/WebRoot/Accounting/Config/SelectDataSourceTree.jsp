<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBeginMD.jsp"%><%
	//获得页面参数
	String colSource = CurPage.getParameter("ColSource"); //数据源类型
	if (colSource == null) colSource = "";
	String colValue = CurPage.getParameter("ColValue");//数据原值
	if(colValue == null) colValue = "";
%>
<body leftmargin="0" topmargin="0" style="overflow: hidden;">
<table border="0" width="100%" height="100%" cellspacing="0" cellpadding="0" >
<tr height=1 valign=top >
    <td>
    	<table>
	    	<tr>
	    		<td><%=HTMLControls.generateButton("确定","确定","javascript:saveConfig()",sResourcesPath)%></td>
	    		<td><%=HTMLControls.generateButton("清空","清空","javascript:clearConfig()",sResourcesPath)%></td>
	    		<td><%=HTMLControls.generateButton("取消","取消","javascript:self.close()",sResourcesPath)%></td>
    		</tr>
    	</table>
    </td>
</tr>
<tr>
    <td valign="top" >
    	<table width='100%' cellpadding='0' cellspacing='0'>
			<tr>
				<td id="myleft" colspan='3' align=center width=100%>
					<div style="positition:absolute;align:left;height:430px;overflow-y: hide;">
						<iframe name="left" src="<%=sWebRootPath%>/Blank.jsp" width=100% height=100% frameborder=0 scrolling=no ></iframe>
					</div>
				</td>
			</tr>
		</table>
    </td>
</tr>
</table>
</body>

<script type="text/javascript">
	setDialogTitle("多选信息如下：");
	function saveConfig(){
		var nodes = getCheckedTVItems(); //树图选择的节点
		var id ="";
		var name = "";
		for(var i=0;i<nodes.length;i++){
			id += nodes[i].id + ",";
			name += nodes[i].name + ",";
		}
		self.returnValue=id+"@"+name;
		self.close();
	}

	function clearConfig(){
		
		self.returnValue="_CLEAR_";
		self.close();
	}
	
	
	function startMenu(){
	<%
		HTMLTreeView tviTemp = new HTMLTreeView("配置菜单可见角色","right");
		tviTemp.ImageDirectory = sResourcesPath; //设置资源文件目录（图片、CSS）
		tviTemp.TriggerClickEvent=false;
		tviTemp.MultiSelect = true;
		if(colSource.toUpperCase().startsWith("CODE:"))
			tviTemp.initWithCode(colSource.substring(5),Sqlca);
		else
		{
			String fromCaluse = colSource.substring(colSource.toUpperCase().indexOf("FROM"));
			colSource = colSource.substring(colSource.toUpperCase().indexOf("SELECT")+6,colSource.toUpperCase().indexOf("FROM"));
			String id = colSource.split(",")[0].trim();
			String name = colSource.split(",")[1].trim();
			tviTemp.initWithSql(id,name,id,"",fromCaluse,Sqlca);
		}
		out.println(tviTemp.generateHTMLTreeView());
		
		for(String col:colValue.split(",")){
	%>
			try
			{
				setCheckTVItem('<%=col%>', true);
			}catch(e){}
	<%  
		}
	%>
	}
	
	startMenu();
	expandNode('root');
</script>
<%@ include file="/IncludeEnd.jsp"%>