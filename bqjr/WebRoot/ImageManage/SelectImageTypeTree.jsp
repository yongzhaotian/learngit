<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBeginMD.jsp"%><%
	//���ҳ�����
	String sProductID = CurPage.getParameter("ProductID"); //�˵����
	String sProductName = CurPage.getParameter("ProductName"); //�˵����
	if (sProductID == null) sProductID = "";
	if (sProductName == null) sProductName = "";
%>
<body leftmargin="0" topmargin="0" style="overflow: hidden;">
	<p> <%=HTMLControls.generateButton("����","����","javascript:saveConfig()",sResourcesPath)%></p>
	<iframe name="left" src="<%=sWebRootPath%>/Blank.jsp" width=100% height=100% frameborder=0 scrolling=no ></iframe>

</body>

<script type="text/javascript">
	setDialogTitle("��Ʒ<font color=#6666cc>(<%=sProductName%>)</font>����Ӱ������");
	function saveConfig(){
		var nodes = getCheckedTVItems(); //��ͼѡ��Ľڵ�
		var typeNos ="";
		for(var i=0;i<nodes.length;i++){
			typeNos += nodes[i].id + "@";
		}
		var sReturn = RunJavaMethodSqlca("com.amarsoft.app.als.image.ManagePRDImageRela","addRelation",
				"productID=<%=sProductID%>,relaValues="+typeNos );
		if(sReturn=="true"){
			alert("����ɹ���");
			top.close();
		}
	}
	
	function startMenu(){
	<%
		HTMLTreeView tviTemp = new HTMLTreeView("���ò�Ʒ���õ�Ӱ������","right");
		tviTemp.ImageDirectory = sResourcesPath; //������Դ�ļ�Ŀ¼��ͼƬ��CSS��
		tviTemp.TriggerClickEvent=false;
		tviTemp.MultiSelect = true;
		tviTemp.initWithSql("TypeNo","TypeName||'('||TypeNo||')' as ShowText","TypeNo","",
				"from ECM_IMAGE_TYPE where TypeNo Like '20%' and IsInUse ='1'",Sqlca);
		out.println(tviTemp.generateHTMLTreeView());
		
		ASResultSet rs = Sqlca.getASResultSet(new SqlObject("select ImageTypeNo from ECM_PRDIMAGE_RELA "+
				" where ProductID=:ProductID").setParameter("ProductID", sProductID));
		//ȡ��Ʒ��Ӱ�����͹������Ա㹴ѡ����ѡ����
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