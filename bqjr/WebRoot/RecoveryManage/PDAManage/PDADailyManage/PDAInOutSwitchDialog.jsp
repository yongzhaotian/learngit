<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   FSGong  2005.01.28
		Content: 抵债资产表内外互换时,必须修改入账价值/科目余额或者抵债时贷款余额/当前贷款余额.
					  目前只考虑上述两个参数的修改,并不考虑变更人与变更时间等.
		Input Param:
			        SerialNo：抵债资产流水号
					InOut：转入表内外标志.
		Output param:		
		History Log: 
	 */
	%>
<%/*~END~*/%>

 
<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "抵债资产基本信息"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量
	
	//获得组件参数（资产流水号、转入表内外标志）
	String sSerialNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("SerialNo"));
	String sInOut = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("InOut"));
	//将空值转化为空字符串
	if(sSerialNo == null ) sSerialNo = "";	
	if(sInOut == null ) sInOut = "";	
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info03;Describe=定义数据对象;]~*/%>
	<%
	//通过显示模版产生ASDataObject对象doTemp
	String sTempletNo = "PDAInOutSwitchDialog";
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	//根据表内/表外/未抵入标志,决定如何显示AssetBalance,EnterValue,OutInitBalance,OutNowBalance,InAccontDate字段.
	if (sInOut.equals("In"))  
		doTemp.setVisible("AssetBalance,EnterValue,InAccontDate",true);		
	else
		doTemp.setVisible("OutInitBalance,OutNowBalance",true);		

	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style = "2";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写	
	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sSerialNo);	
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
 	//out.println(sSerialNo);
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
			{"false","","Button","转入表内","确认转入表内","InTable()",sResourcesPath},
			{"false","","Button","转入表外","确认转入表外","OutTable()",sResourcesPath}
		};
	if (sInOut.equals("In")) 
		sButtons[0][0]="true";
	else
		sButtons[1][0]="true";
	%> 
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=Info05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/Info05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info06;Describe=定义按钮事件;]~*/%>
	<script type="text/javascript">
	
	//---------------------定义按钮事件------------------------------------
	
	/*~[Describe=转表内;InputParam=后续事件;OutPutParam=无;]~*/
	function InTable()
	{
		if(confirm(getBusinessMessage("766"))) //您确认该抵债资产转表内吗？
		{
			//立即变更表内标志
			var sSerialNo="<%=sSerialNo%>";
			var sFlag = "010";
			var sAssetStatus = "03";
			sReturnValue = RunMethod("PublicMethod","UpdateColValue","String@Flag@"+sFlag+"@String@AssetStatus@"+sAssetStatus+",ASSET_INFO,String@SerialNo@"+sSerialNo);
			if(sReturnValue == "TRUE")
			{
				alert(getBusinessMessage("767"));//该抵债资产转表内成功！
				saveRecord();
				self.close();
			}else
			{
				alert(getBusinessMessage("768")); //该抵债资产转表内失败，请重新操作！
				return;
			}			
		}
	}
	
	/*~[Describe=转表外;InputParam=后续事件;OutPutParam=无;]~*/
	function OutTable()
	{
		if(confirm(getBusinessMessage("769"))) //您确认该抵债资产转表外吗？
		{
			//立即变更表外标志
			var sSerialNo="<%=sSerialNo%>";
			var sFlag = "020";
			var sAssetStatus = "03";
			sReturnValue = RunMethod("PublicMethod","UpdateColValue","String@Flag@"+sFlag+"@String@AssetStatus@"+sAssetStatus+",ASSET_INFO,String@SerialNo@"+sSerialNo);
			if(sReturnValue == "TRUE")
			{
				alert(getBusinessMessage("770"));//该抵债资产转表外成功！
				saveRecord();
				self.close();
			}else
			{
				alert(getBusinessMessage("771")); //该抵债资产转表外失败，请重新操作！
				return;
			}
		}
	}
	
	/*~[Describe=保存;InputParam=后续事件;OutPutParam=无;]~*/
	function saveRecord()
	{
		beforeUpdate();
		as_save("myiframe0");		
	}
	
	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info07;Describe=自定义函数;]~*/%>

	<script type="text/javascript">

	/*~[Describe=执行更新操作前执行的代码;InputParam=无;OutPutParam=无;]~*/
	function beforeUpdate()
	{
	}

	/*~[Describe=页面装载时，对DW进行初始化;InputParam=无;OutPutParam=无;]~*/
	function initRow()
	{
		setItemValue(0,0,"InputUserID","<%=CurUser.getUserID()%>");
		setItemValue(0,0,"InputOrgID","<%=CurOrg.getOrgID()%>");		
		setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");
		setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
    }
		
	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info08;Describe=页面装载时，进行初始化;]~*/%>
<script type="text/javascript">	
	top.returnValue = "false";
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	initRow(); //页面装载时，对DW当前记录进行初始化
</script>	
<%/*~END~*/%>


<%@ include file="/IncludeEnd.jsp"%>