<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   FSGong 2004.12.07
		Tester:
		Content: 已抵入/处置中的资产列表AppDisposingList.jsp
		Input Param:
				下列参数作为组件参数输入
				--ObjectType			对象类型：ASSET_INFO
									上述参数的目的是保持扩展性,将来可能还会考虑查封资产。
				--sObjectNo         对象编号
			          
		Output param:
				--SerialNo   : 抵债资产编号
				--AssetType: 抵债资产类型 
		History Log: 		                  
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "已抵入/处置中的资产列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;已抵入/处置中的资产列表&nbsp;&nbsp;";
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%
	//定义变量
	String sSql;//--存放sql语句

	String sObjectType;//--对象类型	
	String sObjectNo;//--对象编号
	
	//获得组件参数	
	sObjectType	=DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));

	//从抵债资产信息表ASSET_INFO中选出已抵入/处置中的资产
	//定义表头文件
	String sHeaders[][] = { 							
										{"SerialNo","资产编号"},
										{"AssetNo","资产编号"},
										{"AssetName","资产名称"},
										{"Flag","抵入表内/表外"},
										{"FlagName","抵入表内/表外"},
										{"AssetType","资产类别"},	
										{"AssetTypeName","资产类别"},	
										{"AssetSum","抵债金额(元)"},
										{"AssetBalance","资产余额(元)"},
										{"ManageUserID","管理人"},
										{"ManageOrgID","管理机构"}
									}; 
	

	    sSql =  "  select SerialNo,AssetNo,"+
				" AssetName,AssetType,"+
				" getItemName('PDAType',rtrim(ltrim(AssetType))) as AssetTypeName,"+
				" Flag ,"+
				" getItemName('Flag',Flag) as FlagName,"+
				" AssetSum, " +	
				" AssetBalance, " +	
				" getUserName(ManageUserID) as ManageUserID, " +	
				" getOrgName(ManageOrgID) as ManageOrgID"+			
	       		" from ASSET_INFO" +
				" where ManageUserID='"+CurUser.getUserID()+
				"' and AssetStatus='03'  and AssetAttribute='01' and PigeonholeDate is null  and  ObjectType='"+sObjectType+"' order by AssetName desc";
				//管户人为当前用户
				//抵债资产处置现状：03－已抵入
				//AssetAttribute：01－抵债资产、02－查封资产
				//归档日期为空
	

%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%	
	
	//利用sSql生成数据对象
	ASDataObject doTemp = new ASDataObject(sSql);

	//设置表头
	doTemp.setHeader(sHeaders);
	doTemp.UpdateTable = "ASSET_INFO";
	
	//设置关键字
	doTemp.setKey("SerialNo",true);	 

	//设置不可见项
	doTemp.setVisible("SerialNo,AssetType,Flag",false);

	//设置显示文本框的长度及事件属性
	doTemp.setHTMLStyle("SerialNo","style={width:100px} ");  
	doTemp.setHTMLStyle("AssetTypeName,FlagName","style={width:85px} ");  
	doTemp.setHTMLStyle("AssetName,ManageUserID,ManageOrgID,AssetSum,AssetBalance,AssetNo"," style={width:80px} ");
	doTemp.setUpdateable("AssetTypeName",false); 
	
	//设置对齐方式
	doTemp.setAlign("AssetSum,AssetBalance","3");
	doTemp.setType("AssetSum,AssetBalance","Number");
	//小数为2，整数为5
	doTemp.setCheckFormat("AssetSum,AssetBalance","2");
	
	//指定双击事件
//	doTemp.setHTMLStyle("DunLetterNo,DunObjectName,DunDate,DunForm,ServiceMode,DunCurrency,DunSum,Corpus,InterestInSheet,InterestOutSheet"," style={width:100px} ondblclick=\"javascript:parent.onDBLClick()\" ");  	
	//生成查询框
	doTemp.setColumnAttribute("AssetName","IsFilter","1");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	

	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	dwTemp.setPageSize(20);  //服务器分页

	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));


	String sCriteriaAreaHTML = ""; //查询区的页面代码
	
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List04;Describe=定义按钮;]~*/%>
	<%
	//依次为：
		//0.是否显示
		//1.注册目标组件号(为空则自动取当前组件)
		//2.类型(Button/ButtonWithNoAction/HyperLinkText/TreeviewItem/PlainText/Blank)
		//3.按钮文字
		//4.说明文字
		//5.事件
		//6.资源图片路径
	String sButtons[][] = {
		{"true","","Button","详细信息","详细信息","viewAndEdit()",sResourcesPath}
	};
	%> 
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script type="text/javascript">
	//---------------------定义按钮事件------------------------------------

	/*~[Describe=查看及修改详情;InputParam=无;OutPutParam=SerialNo;]~*/
	function viewAndEdit()
	{
		//获得抵债资产流水号、抵债资产类型
		sSerialNo=getItemValue(0,getRow(),"SerialNo");	
		sAssetType=getItemValue(0,getRow(),"AssetType");
		sObjectType="<%=sObjectType%>";
		var sAssetName=getItemValue(0,getRow(),"AssetName");
		var sAssetNo=getItemValue(0,getRow(),"AssetNo");
	
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage(1));  //请选择一条记录！
			return;
		}
		OpenComp("PDABasicView",
			"/RecoveryManage/PDAManage/PDADailyManage/PDABasicView.jsp",
			"ComponentName=抵债资产详细信息&ComponentType=MainWindow&SerialNo="+
			sSerialNo+"&AssetType="+sAssetType+"&ObjectType="+sObjectType+
			"&ObjectNo="+"&AssetName="+sAssetName+"&AssetNo="+sAssetNo+"&EnterPath=2","_blank",OpenStyle);
			//EnterPath=1意味着从已批准拟抵入进入,这样无法看到处置台帐;此处为2可以看见处置台帐
		reloadSelf();
	}	
	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List07;Describe=页面装载时，进行初始化;]~*/%>
<script type="text/javascript">	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>	
<%/*~END~*/%>


<%@ include file="/IncludeEnd.jsp"%>
