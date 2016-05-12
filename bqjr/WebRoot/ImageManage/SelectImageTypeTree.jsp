<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBeginMD.jsp"%><%
	//获得页面参数
	String sProductID = CurPage.getParameter("ProductID"); //菜单编号
	String sProductName = CurPage.getParameter("ProductName"); //菜单编号
	if (sProductID == null) sProductID = "";
	if (sProductName == null) sProductName = "";
%>
<body leftmargin="0" topmargin="0" style="overflow: hidden;">
	<p> <%=HTMLControls.generateButton("保存","保存","javascript:saveConfig()",sResourcesPath)%></p>
	<iframe name="left" src="<%=sWebRootPath%>/Blank.jsp" width=100% height=100% frameborder=0 scrolling=no ></iframe>

</body>

<script type="text/javascript">
	setDialogTitle("产品<font color=#6666cc>(<%=sProductName%>)</font>适用影像类型");
	function saveConfig(){
		var nodes = getCheckedTVItems(); //树图选择的节点
		var typeNos ="";
		for(var i=0;i<nodes.length;i++){
			typeNos += nodes[i].id + "@";
		}
		var sReturn = RunJavaMethodSqlca("com.amarsoft.app.als.image.ManagePRDImageRela","addRelation",
				"productID=<%=sProductID%>,relaValues="+typeNos );
		if(sReturn=="true"){
			alert("保存成功！");
			top.close();
		}
	}
	
	function startMenu(){
	<%
		HTMLTreeView tviTemp = new HTMLTreeView("配置产品适用的影像类型","right");
		tviTemp.ImageDirectory = sResourcesPath; //设置资源文件目录（图片、CSS）
		tviTemp.TriggerClickEvent=false;
		tviTemp.MultiSelect = true;
		tviTemp.initWithSql("TypeNo","TypeName||'('||TypeNo||')' as ShowText","TypeNo","",
				"from ECM_IMAGE_TYPE where TypeNo Like '20%' and IsInUse ='1'",Sqlca);
		out.println(tviTemp.generateHTMLTreeView());
		
		ASResultSet rs = Sqlca.getASResultSet(new SqlObject("select ImageTypeNo from ECM_PRDIMAGE_RELA "+
				" where ProductID=:ProductID").setParameter("ProductID", sProductID));
		//取产品与影响类型关联，以便勾选上已选择项
		while(rs.next()){
	%>
		setCheckTVItem('<%=rs.getString("ImageTypeNo")%>', true);
	<%  }
		rs.getStatement().close();%>
	}
	
	startMenu();
	expandNode('root');
</script>
<%@ include file="/IncludeEnd.jsp"%>