<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   fsgong  2004.12.05
		Content: 抵债资产处置台帐详情PDADisposalBookInfo.jsp
		Input Param:
			        ObjectType:对象类型Asset_Info
			        ObjectNo:抵债资产流水号
			        SerialNo:处置纪录流水号					
			        DispositonType：处置方式
		Output param:		
		History Log: zywei 2005/09/07 重检代码
	 */
	%>
<%/*~END~*/%>

 
<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "抵债资产处置台帐详情"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量
	String sTempletNo = "";
	
	//获得组件参数
	
	//获得页面参数（处置流水号、处置类型、对象编号、对象类型）
	String sAssetStatus = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("AssetStatus"));
	String sSerialNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
	String sDispositionType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("DispositionType"));//否则无法定位模板
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectNo"));
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectType"));
	//将空值转化为空字符串
	if(sSerialNo == null ) sSerialNo = "";//新增记录
	if(sDispositionType == null ) sDispositionType = "";
	if(sObjectNo == null ) sObjectNo = "";
	if(sObjectType == null ) sObjectType = "";
	if(sAssetStatus == null ) sAssetStatus = "";	
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info03;Describe=定义数据对象;]~*/%>
	<%
	//通过显示模版产生ASDataObject对象doTemp
	if(sDispositionType.equals("01"))
		sTempletNo="PDALeaseInfo"; //出租
	if(sDispositionType.equals("02"))
		sTempletNo="PDASaleInfo"; //出售 
	if(sDispositionType.equals("03"))
		sTempletNo="PDATransferInfo"; //转让
	if(sDispositionType.equals("04"))
		sTempletNo="PDAReplaceInfo"; //互换
	if(sDispositionType.equals("05"))
		sTempletNo="PDASelfOwnInfo"; //自用
	if(sDispositionType.equals("06"))
		sTempletNo="PDAOtherDispositionInfo"; //其他处置

	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
	//定义自动 计算字段：除自用之外！因为自用不存在处置净收入的问题。
	if (sTempletNo.equals("PDALeaseInfo") || sTempletNo.equals("PDASaleInfo") || sTempletNo.equals("PDATransferInfo") || sTempletNo.equals("PDAReplaceInfo") || sTempletNo.equals("PDAOtherDispositionInfo"))	
		doTemp.appendHTMLStyle("DispositionSum,DispositionCharge"," onChange=\"javascript:parent.getCashNetSum()\" ");
	if (sTempletNo.equals("PDAOtherDispositionInfo"))
		doTemp.appendHTMLStyle("DispositionPrice,DispositionAmount"," onChange=\"javascript:parent.getAssetSum()\" ");

	//下面根据处置方式,决定是否显示出售方式
	if (sDispositionType.equals("02") ) //出售
	{//设置出售方式,拍卖机构可见
		doTemp.setVisible("SaleStyle,AuctionOrg",true);		
	}

	//得到该资产的表外/内/未抵入标志,已决定显示风格	
	String mySql = " select Flag from ASSET_INFO where  SerialNo =:SerialNo ";
	String myFlag = Sqlca.getString(new SqlObject(mySql).setParameter("SerialNo",sObjectNo));
	if(myFlag == null) myFlag = ""; 
	if(myFlag.equals("")) myFlag = "010";  //缺省表内
	
	//根据表内/表外/未抵入标志,决定如何显示AssetSumInTable,AssetSumOutTable字段.
	doTemp.setUpdateable("AssetSumInTable,AssetSumOutTable",false); 
	doTemp.setVisible("AssetSumInTable,AssetSumOutTable",false);		

	if (myFlag.equals("010")) //表内
	{
		doTemp.setVisible("AssetSumInTable",true);		
		doTemp.setUpdateable("AssetSumInTable",true); 
	}
	if (myFlag.equals("020"))  //表外
	{
		doTemp.setVisible("AssetSumOutTable",true);		
		doTemp.setUpdateable("AssetSumOutTable",true); 
	}

	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style = "2";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写
	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sObjectType+','+sObjectNo+','+sSerialNo);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
 
	%>

<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info04;Describe=定义按钮;]~*/%>
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
				{sAssetStatus.equals("04")?"false":"true","","Button","保存","保存所有修改","saveRecord()",sResourcesPath},
				{"true","","Button","返回","保存所有修改","goBack()",sResourcesPath}
			};
	%> 
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=Info05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/Info05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info06;Describe=定义按钮事件;]~*/%>
	<script type="text/javascript">
	var bIsInsert = false; //标记DW是否处于“新增状态”

	//---------------------定义按钮事件------------------------------------

	/*~[Describe=保存;InputParam=后续事件;OutPutParam=无;]~*/
	function saveRecord()
	{
		sDispositionType = "<%=sDispositionType%>";
	
		//如果是出售且为拍卖,那么拍卖机构不能为空!由于架构的限制,无法在模板中设置.
		if 	(sDispositionType=="02")
		{
			var sSaleStyle=getItemValue(0,0,"SaleStyle");		
			if ((sSaleStyle.trim()=="")||(sSaleStyle==null))
			{
				alert("如果处置方式为资产出售，那么出售方式为必输项!");
				return;
			}else
			{
				if (sSaleStyle=="01")
				{
					var sAuctionOrg=getItemValue(0,0,"AuctionOrg");
					if ((sAuctionOrg==null)||(sAuctionOrg.trim()==""))
					{
						alert("如果出售方式为拍卖，那么拍卖机构为必输项!");
						return;
					}
				}
			}
		}
	
		if(bIsInsert)
		{
			beforeInsert();
			bIsInsert = false;
		}

		beforeUpdate();
		as_save("myiframe0");		
	}
	
</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info07;Describe=自定义函数;]~*/%>
	<script type="text/javascript">

	/*~[Describe=执行插入操作前执行的代码;InputParam=无;OutPutParam=无;]~*/
	function beforeInsert()
	{
		initSerialNo();//初始化流水号字段
		bIsInsert = false;
	}
	
	/*~[Describe=执行更新操作前执行的代码;InputParam=无;OutPutParam=无;]~*/
	function beforeUpdate()
	{
		setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
	}

	/*~[Describe=处置净收入（处置收入-处置费用）;InputParam=无;OutPutParam=无;]~*/
    function getCashNetSum()
	{
		sDispositionSum = getItemValue(0,getRow(),"DispositionSum");
		sDispositionCharge = getItemValue(0,getRow(),"DispositionCharge");
	
		if(typeof(sDispositionSum) == "undefined" || sDispositionSum.length == 0) sDispositionSum = 0; 
		if(typeof(sDispositionCharge) == "undefined" || sDispositionCharge.length == 0) sDispositionCharge = 0; 
	
		sCashNetSum = sDispositionSum - sDispositionCharge;
	    setItemValue(0,getRow(),"CashNetSum",sCashNetSum);
	}
	
	/*~[Describe=实际成交金额（实际成交单价*实际成交数量）;InputParam=无;OutPutParam=无;]~*/
	function getAssetSum()
     { 
		sDispositionPrice = getItemValue(0,getRow(),"DispositionPrice");
		sDispositionAmount = getItemValue(0,getRow(),"DispositionAmount");
	       
		if(typeof(sDispositionPrice) == "undefined" || sDispositionPrice.length == 0) sDispositionPrice = 0; 
		if(typeof(sDispositionAmount) == "undefined" || sDispositionAmount.length == 0) sDispositionAmount = 0;
		sDispositonSum = sDispositionPrice * sDispositionAmount;

		setItemValue(0,getRow(),"AssetSum",sDispositonSum);
     }
	
	/*~[Describe=页面装载时，对DW进行初始化;InputParam=无;OutPutParam=无;]~*/
	function initRow()
	{
		if (getRowCount(0)==0) //如果没有找到对应记录，则新增一条，并设置字段默认值
		{
			as_add("myiframe0");//新增记录
			bIsInsert = true;	
				
			setItemValue(0,0,"ObjectNo","<%=sObjectNo%>");
			setItemValue(0,0,"ObjectType","<%=sObjectType%>");
			setItemValue(0,0,"DispositionType","<%=sDispositionType%>");
			setItemValue(0,0,"OperateUserID","<%=CurUser.getUserID()%>");			
			setItemValue(0,0,"OperateUserName","<%=CurUser.getUserName()%>");			
			setItemValue(0,0,"OperateOrgID","<%=CurOrg.getOrgID()%>");
			setItemValue(0,0,"OperateOrgName","<%=CurOrg.getOrgName()%>");
			setItemValue(0,0,"ManageUserID","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"ManageUserName","<%=CurUser.getUserName()%>");
			setItemValue(0,0,"ManageOrgID","<%=CurOrg.getOrgID()%>");
			setItemValue(0,0,"ManageOrgName","<%=CurOrg.getOrgName()%>");
			setItemValue(0,0,"InputUserID","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"InputUserName","<%=CurUser.getUserName()%>");
			setItemValue(0,0,"InputOrgID","<%=CurOrg.getOrgID()%>");		
			setItemValue(0,0,"InputOrgName","<%=CurOrg.getOrgName()%>");	
			setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"DispositionSum","0");
			setItemValue(0,0,"DispositionAmount","0");
			setItemValue(0,0,"DispositionPrice","0");
			setItemValue(0,0,"DispositionCharge","0");
			setItemValue(0,0,"CashNetSum","0");
		}
		
		var sColName = "AssetName"+"~";
		var sTableName = "ASSET_INFO"+"~";
		var sWhereClause = "String@ObjectNo@"+"<%=sObjectNo%>"+"@String@ObjectType@AssetInfo"+"~";
		
		sReturn=RunMethod("PublicMethod","GetColValue",sColName + "," + sTableName + "," + sWhereClause);
		if(typeof(sReturn) != "undefined" && sReturn != "") 
		{			
			sReturn = sReturn.split('~');
			var my_array1 = new Array();
			for(i = 0;i < sReturn.length;i++)
			{
				my_array1[i] = sReturn[i];
			}
			
			for(j = 0;j < my_array1.length;j++)
			{
				sReturnInfo = my_array1[j].split('@');	
				var my_array2 = new Array();
				for(m = 0;m < sReturnInfo.length;m++)
				{
					my_array2[m] = sReturnInfo[m];
				}
				
				for(n = 0;n < my_array2.length;n++)
				{									
					//设置资产名称
					if(my_array2[n] == "assetname")
						setItemValue(0,getRow(),"AssetName",sReturnInfo[n+1]);										
				}
			}			
		}		
    }

	/*~[Describe=返回;InputParam=无;OutPutParam=无;]~*/
	function goBack()
	{
		var sDispositionType = "<%=sDispositionType%>";
		if(sDispositionType == "01") //抵债资产出租台帐列表
			OpenPage("/RecoveryManage/PDAManage/PDADailyManage/PDALeaseBookList.jsp","right","");
		else //抵债资产处置台帐列表
			OpenPage("/RecoveryManage/PDAManage/PDADailyManage/PDADisposalBookList.jsp","right","");
	}

	/*~[Describe=初始化流水号字段;InputParam=无;OutPutParam=无;]~*/
	function initSerialNo() 
	{
		var sTableName = "ASSET_DISPOSITION";//表名
		var sColumnName = "SerialNo";//字段名
		var sPrefix = "";//前缀

		//获取流水号
		var sSerialNo = getSerialNo(sTableName,sColumnName,sPrefix);
		//将流水号置入对应字段
		setItemValue(0,getRow(),sColumnName,sSerialNo);
	}
	
</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info08;Describe=页面装载时，进行初始化;]~*/%>
<script type="text/javascript">	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	initRow(); //页面装载时，对DW当前记录进行初始化
</script>	
<%/*~END~*/%>


<%@ include file="/IncludeEnd.jsp"%>