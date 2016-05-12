<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   FSGong  2004.12.16
		Tester:
		Content: 抵债资产余额变动台帐
		余额变动类型：出租和出售，BalanceChangeType
		资产表中资产余额y=资产表中抵入金额a-变动表中变动金额b.
		当资金流入b>0;otherwise b<0.
		Input Param:
			  ObjectNo：对象编号（抵债资产流水号）
			  ObjectType：对象类型（ASSET_INFO）
			  SerialNo:	变动记录号
		Output param:
		
		History Log: zywei 2005/09/07 重检代码
	 */
	%>
<%/*~END~*/%>

 
<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "抵债资产余额变动详情"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info02;Describe=定义变量，获取参数;]~*/%>
<%
	//定义变量
	
	//获得组件参数
	String sAssetStatus = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("AssetStatus"));
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));  //资产流水号
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));//asset_info
	if(sObjectNo == null ) sObjectNo = "";
	if(sObjectType == null ) sObjectType = "";
	if(sAssetStatus == null ) sAssetStatus = "";
	//获得页面参数
	String sSerialNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));			//变动记录流水号
	if(sSerialNo == null ) sSerialNo = "";//表示新增
	
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info03;Describe=定义数据对象;]~*/%>
	<%
	//通过显示模版产生ASDataObject对象doTemp
	String sTempletNo ="PDABalanceChangeInfo";
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style = "2";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写
	
	//得到该资产的表外/内/未抵入标志,已决定显示风格	
	String mySql = " select Flag from ASSET_INFO where  SerialNo =:SerialNo ";
	String myFlag = Sqlca.getString(new SqlObject(mySql).setParameter("SerialNo",sObjectNo));
	if(myFlag == null) myFlag = ""; 
	if(myFlag.equals("")) myFlag = "010";  //缺省表内 		

	//根据表内/表外/未抵入标志,决定如何显示AssetBalance,EnterValue字段.伪字段,不可更新,显示用.

	if (myFlag.equals("010")) //表内
	{
		doTemp.setVisible("AssetBalanceOutTable,EnterValueOutTable",false);		
		doTemp.setVisible("AssetBalanceInTable,EnterValueInTable",true);		
	}
	if (myFlag.equals("020"))  //表外
	{
		doTemp.setVisible("AssetBalanceOutTable,EnterValueOutTable",true);		
		doTemp.setVisible("AssetBalanceInTable,EnterValueInTable",false);		
	}

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
			{"true","","Button","返回","返回到上级页面","goBack()",sResourcesPath}
		};
	%> 
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=Info05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/Info05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info06;Describe=定义按钮事件;]~*/%>
	<script type="text/javascript">
	var bIsInsert = false; //标记DW是否处于“新增状态”
	var OldValue = "0.00";//缺省原来的变动值为0:新增的情况.
	var OldChangeType = "000";//缺省原变动方向既非减少也非增加:新增的情况.
	var NewValue = "0.00";
	var NewChangeType = "000";

	//---------------------定义按钮事件------------------------------------
	/*~[Describe=保存后续事件;InputParam=无;OutPutParam=无;]~*/
	function myafterSave()
	{
		OldValue = NewValue;
		OldChangeType = NewChangeType;	
	}
	
	/*~[Describe=保存;InputParam=后续事件;OutPutParam=无;]~*/
	function saveRecord()
	{
		var TempValue;
		if(bIsInsert)
		{
			beforeInsert();
			bIsInsert = false;
		}	
		beforeUpdate();

		NewValue = getItemValue(0,getRow(),"ChangeSum");  //得到修改之后的值.
		NewChangeType = getItemValue(0,getRow(),"ChangeType");//得到修改之后变动方向

		//下面计算需要变动的值:有符号!!!
		if ((OldChangeType == NewChangeType) || (OldChangeType == "000"))  //如果是新增或者方向没有变化.
		{
			TempValue = parseFloat(NewValue)-parseFloat(OldValue);
		}else  //察看详情作修改,而且变动方向发生变化.
		{
			TempValue=parseFloat(NewValue)+parseFloat(OldValue);
		}

		//修改抵债资产表的抵债余额.
		var sObjectNo = "<%=sObjectNo%>";//抵债资产编号
		var sReturn = PopPageAjax("/RecoveryManage/PDAManage/PDADailyManage/PDABalanceChangeActionAjax.jsp?SerialNo="+sObjectNo+"&Interval_Value="+TempValue+"&ChangeType="+NewChangeType,"","");

		//返回变动之后的余额，立即修改界面的显示内容
		var myFlag = "<%=myFlag%>";
		if (myFlag == "010") 
			setItemValue(0,0,"AssetBalanceInTable",sReturn)
		else
			setItemValue(0,0,"AssetBalanceOutTable",sReturn);

		//在数据保存之后,必须把目前的变动类型和变动值作为保留值,以防再次保存!!!
		//如果在保存之前作作这件事情,那么如果保存失败,再次保存便会发生计算上的错误.		
		as_save("myiframe0","myafterSave()");	
	}
	
	</script>
	
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info07;Describe=自定义函数;]~*/%>

	<script type="text/javascript">

	/*~[Describe=返回;InputParam=无;OutPutParam=无;]~*/
	function goBack()
	{
		OpenPage("/RecoveryManage/PDAManage/PDADailyManage/PDABalanceChangeList.jsp","right");
	}

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

	
	/*~[Describe=页面装载时，对DW进行初始化;InputParam=无;OutPutParam=无;]~*/
	function initRow()
	{
		if (getRowCount(0)==0) //如果没有找到对应记录，则新增一条，并设置字段默认值
		{
			as_add("myiframe0");//新增记录
			bIsInsert = true;			

			setItemValue(0,0,"ObjectNo","<%=sObjectNo%>");
			setItemValue(0,0,"ObjectType","<%=sObjectType%>");
			setItemValue(0,0,"InputUserID","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"InputUserName","<%=CurUser.getUserName()%>");
			setItemValue(0,0,"InputOrgID","<%=CurOrg.getOrgID()%>");		
			setItemValue(0,0,"InputOrgName","<%=CurOrg.getOrgName()%>");	
			setItemValue(0,0,"ChangeSum","0.00");	
			setItemValue(0,0,"ChangeType","010");	
			setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");
			OldValue = "0.00";//缺省原来的变动值为0:新增的情况.
			OldChangeType = "000";//缺省原变动方向既非减少也非增加:新增的情况.
		}else
		{//如果是察看详情,则必须保存原有的变动值,以便计算修改之后的实际变动值.
			OldValue = getItemValue(0,getRow(),"ChangeSum");  
			OldChangeType = getItemValue(0,getRow(),"ChangeType");  
		}
		
		var myFlag = "<%=myFlag%>";
		var sColName = "AssetName@AssetNo@EnterValue@AssetBalance@OutInitBalance@OutNowBalance"+"~";
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
					//设置资产编号
					if(sReturnInfo[n] == "assetno")
						setItemValue(0,getRow(),"AssetNo",sReturnInfo[n+1]);
					if(myFlag == "010")
					{
						if(sReturnInfo[n] == "entervalue")
							setItemValue(0,getRow(),"EnterValueInTable",sReturnInfo[n+1]);
						if(sReturnInfo[n] == "assetbalance")
							setItemValue(0,getRow(),"AssetBalanceInTable",sReturnInfo[n+1]);
					}else	
					{
						if(sReturnInfo[n] == "outinitbalance")
							setItemValue(0,getRow(),"EnterValueOutTable",sReturnInfo[n+1]);
						if(sReturnInfo[n] == "outnowbalance")
							setItemValue(0,getRow(),"AssetBalanceOutTable",sReturnInfo[n+1]);
					}				
				}
			}			
		}
	}
	
	/*~[Describe=初始化流水号字段;InputParam=无;OutPutParam=无;]~*/
	function initSerialNo() 
	{
		var sTableName = "ASSET_BALANCE";//表名
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