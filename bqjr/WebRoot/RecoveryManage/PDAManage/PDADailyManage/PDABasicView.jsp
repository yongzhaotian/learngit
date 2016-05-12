<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=View00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   hxli 2005-8-3
		Tester:
		Content: 抵债资产基本详情PDABasicView.jsp
		Input Param:
				ObjectNo：抵债资产流水号				
		Output param:
		            
		History Log: 
		              
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=View01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "抵债资产详情"; // 浏览器窗口标题 <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;抵债资产详情&nbsp;&nbsp;"; //默认的内容区标题
	String PG_CONTNET_TEXT = "请点击左侧列表";//默认的内容区文字
	String PG_LEFT_WIDTH = "200";//默认的treeview宽度
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=View02;Describe=定义变量，获取参数;]~*/%>
	<%
		//定义变量
		String  sSerialNo = "";//资产流水号		
		String  sObjectType = "AssetInfo";
		String  sAssetType = "10";//房产
		String  sFlag = "010";//表内.
		String  sAssetStatus = "02";//01/02:未抵入进入;03/04:已抵入/处置完进入.决定能够看到处置台帐.

		//获得组件参数
		sSerialNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
		if (sSerialNo == null)  sSerialNo = "";
		
		String sSql = "";
		ASResultSet rsTemp = null;
		//根据抵债资产流水号获取资产类型AssetType/AssetStatus/sFlag
		sSql = " select AssetType,AssetStatus,Flag from ASSET_INFO where SerialNo = :SerialNo ";
		rsTemp = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("SerialNo",sSerialNo));
		if (rsTemp.next()){
			sAssetType  = DataConvert.toString(rsTemp.getString("AssetType"));
			if (sAssetType == null) sAssetType = "10"; 
			sAssetStatus  = DataConvert.toString(rsTemp.getString("AssetStatus"));
			if (sAssetStatus == null) sAssetStatus = "02"; //待处置
			sFlag  = DataConvert.toString(rsTemp.getString("Flag"));
			if (sFlag == null) sFlag = "010"; 
		}
		rsTemp.getStatement().close();		
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=View03;Describe=定义树图;]~*/%>
	<%
	HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,"抵债资产基本详情列表","right");
	tviTemp.ImageDirectory = sResourcesPath; //设置资源文件目录（图片、CSS）
	tviTemp.toRegister = false; //设置是否需要将所有的节点注册为功能点及权限点
	tviTemp.TriggerClickEvent = true; //是否自动触发选中事件


	//定义树图结构:根据sEnterPath的不同,决定是否显示处置台帐.
	String sSqlTreeView  = "";
	if((sAssetStatus.equals("02")) || (sAssetStatus.equals("01")))  //未抵入/已批准拟抵入,不显示处置台帐,申请中也一样.
	{
		sSqlTreeView = " from CODE_LIBRARY where CodeNo= 'PDAInfoList'  and ItemNo in ('01','02','03','06','08','19')";
	}else  //"03/04":显示所有项目,但是变动余额有表内外显示名称的不同.
	{	//对已抵入资产中,根据抵入表内/表外的不同,余额变动台帐的显示名称也不同,但是调用同一个页面		
		if (sFlag.equals("010"))  //抵入表内
		{
			sSqlTreeView = " from CODE_LIBRARY where CodeNo= 'PDAInfoList' and ItemNo<>'18' ";
		}else  //抵入表外
		{
			sSqlTreeView = " from CODE_LIBRARY where CodeNo= 'PDAInfoList' and ItemNo<>'16' ";
		}
	}

	tviTemp.initWithSql("SortNo","ItemName","ItemDescribe","","",sSqlTreeView,"Order By SortNo",Sqlca);
	//参数从左至右依次为：
	//ID字段(必须),Name字段(必须),Value字段,Script字段,Picture字段,From子句(必须),OrderBy子句,Sqlca
	%>
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区[Editable=false;CodeAreaID=View04;Describe=主体页面]~*/%>
	<%@include file="/Resources/CodeParts/View04.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区[Editable=true;CodeAreaID=View05;]~*/%>
	<script type="text/javascript"> 
	function OpenChildComp(sCompID,sURL,sParameterString)
	{
		sParaStringTmp = "";
		sLastChar=sParameterString.substring(sParameterString.length-1);
		if(sLastChar=="&") sParaStringTmp=sParameterString;
		else sParaStringTmp=sParameterString+"&";

		sParaStringTmp += "ToInheritObj=y&OpenerFunctionName="+getCurTVItem().name;
		OpenComp(sCompID,sURL,sParaStringTmp,"right");
	}	

	/*~[Describe=treeview单击选中事件;InputParam=无;OutPutParam=无;]~*/
	function TreeViewOnClick()
	{
		var sCurItemID = getCurTVItem().id;
		var sCurItemName = getCurTVItem().name;
		var sCurItemDescribe = getCurTVItem().value;

		sCurItemDescribe = sCurItemDescribe.split("@");
		sCurItemDescribe1=sCurItemDescribe[0];  //代码表描述字段中用@分隔的第1个串
		sCurItemDescribe2=sCurItemDescribe[1]; //代码表描述字段中用@分隔的第2个串
		sCurItemDescribe3=sCurItemDescribe[2]; //代码表描述字段中用@分隔的第3个串，根据情况，还可以很多。
		//返回
		if (sCurItemDescribe2=="goBack") 
		{
			self.close();
		}else if (sCurItemDescribe2=="PDABasicInfo") //基本信息
		{
			var sSerialNo="<%=sSerialNo%>";
			var sAssetType="<%=sAssetType%>";			
			var sObjectType="<%=sObjectType%>";
			var sAssetStatus="<%=sAssetStatus%>";
			OpenChildComp(sCurItemDescribe2,sCurItemDescribe1,"ComponentName="+sCurItemName+"&SerialNo="+sSerialNo+"&AssetType="+sAssetType+"&ObjectType="+sObjectType+"&AssetStatus="+sAssetStatus);		
			setTitle(sCurItemName);
		}else if (sCurItemDescribe2=="PDARelativeContractList") //相关合同信息
		{
			var sSerialNo="<%=sSerialNo%>";
			var sAssetStatus="<%=sAssetStatus%>";
			OpenChildComp(sCurItemDescribe2,sCurItemDescribe1,"ComponentName="+sCurItemName+"&SerialNo="+sSerialNo+"&AssetStatus="+sAssetStatus);
			setTitle(sCurItemName);
		}else if(sCurItemDescribe1 != "null" && sCurItemDescribe1 != "root")
		{
			var sSerialNo="<%=sSerialNo%>"; //资产编号
			var sObjectType="<%=sObjectType%>";//AssetInfo	
			var sAssetStatus="<%=sAssetStatus%>";
			OpenChildComp(sCurItemDescribe2,sCurItemDescribe1,"ComponentName="+sCurItemName+"&ObjectType="+sObjectType+"&ObjectNo="+sSerialNo+"&AssetStatus="+sAssetStatus);
			if (sCurItemDescribe2=="PDABalanceChangeList")
				setTitle(sCurItemName+"(***该数据从会计系统获取***)")
			else
				setTitle(sCurItemName);
		}
	}
	
	/*~[Describe=生成treeview;InputParam=无;OutPutParam=无;]~*/
	function startMenu() 
	{
		<%=tviTemp.generateHTMLTreeView()%>
	}
		
	</script> 
<%/*~END~*/%>


<%/*~BEGIN~可编辑区[Editable=true;CodeAreaID=View06;Describe=在页面装载时执行,初始化]~*/%>
	<script type="text/javascript">
	startMenu();
	expandNode('root');
	</script>
<%/*~END~*/%>


<%@ include file="/IncludeEnd.jsp"%>