<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBeginMD.jsp"%><%
	//���ҳ�����
	String sType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("Type"));
	if (sType == null) sType = "";
	String sStartWithId = CurComp.getParameter("StartWithId");
	if (sStartWithId == null) sStartWithId = "";
%>

<%
	HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,"��Ʒ����Ԥ��","right");
	tviTemp.ImageDirectory = sResourcesPath; //������Դ�ļ�Ŀ¼��ͼƬ��CSS��
	tviTemp.TriggerClickEvent=true;
	
	String sFilter = "";
	/* if( sType.equals( "Customer" ) ) sFilter = "10";
	else if( sType.equals( "Business" ) ) sFilter = "20"; */
	
	//��ѯ��Ʒ��������ͼ
	String sSqlTreeView = "from product_ctype "; //and IsInUse = '1'
	tviTemp.initWithSql("distinct PRODUCTCTYPEID","PRODUCTCTYPENAME"," PRODUCTCTYPENAME ","","",sSqlTreeView,"Order By PRODUCTCTYPEID",Sqlca);
%>
<html>
<head>
<title>��Ʒ����Ԥ��</title>
<style type="text/css">
	.no_select {
		-moz-user-select:none;
	}
</style>
</head>
<body leftmargin="0" topmargin="0" style="overflow: hidden;">
	<div style="positition:absolute;align:left;height:430px;overflow-y: hide;">
		<iframe name="left" src="<%=sWebRootPath%>/Blank.jsp" width=100% height=100% frameborder=0 scrolling=no ></iframe>
	</div>
</body>
</html>

<script type="text/javascript">

	function TreeViewOnClick() {
		var sCurItemID = getCurTVItem().id;
		var sCurItemName = getCurTVItem().name;
		AsControl.OpenView( "/ImageManage/ImageAfterLoanFrame.jsp", "productTypeId="+sCurItemID, "frameright","" );
		setTitle( "��Ʒ����Ԥ��" ); 
	}
	
	function expandAll(){
		for( var i = 0; i < nodes.length; i++ ){
			if( !hasChild(nodes[i].id) ) expandNode( nodes[i].id );
		}
	}

	<%out.println(tviTemp.generateHTMLTreeView());%>
	setDialogTitle("��Ʒ����Ԥ��");
	expandAll();
</script>
<%@ include file="/IncludeEnd.jsp"%>