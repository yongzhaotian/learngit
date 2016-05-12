<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info00;Describe=注释区;]~*/%>
	<%
	/*
		Author: lwang 20140220 
		Tester:
		Describe:费率详情页面
		Input Param:
			SerialNo:
		Output Param:

		HistoryLog:
			
	 */
	%>
<%/*~END~*/%>



<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "新增费用减免配置"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>



<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info02;Describe=定义变量，获取参数;]~*/%>
<%

	//获得页面参数
	String sTypeNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("typeNo"));
	String sSerialNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("serialNo"));
	String sTemp = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("temp"));
	if(sTemp==null) sTemp=""; 
	if(sSerialNo==null) sSerialNo=""; 
    if(sTypeNo==null) sTypeNo=""; 
    System.out.println(sSerialNo+","+sTypeNo);
%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info03;Describe=定义数据对象;]~*/%>
	<%
	//通过显示模版产生ASDataObject对象doTemp
	String sTempletNo = "BusinessTypeCReductionInfo";

	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	//out.print(doTemp.SourceSql);
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写
	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sSerialNo);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	
	String sterm = Sqlca.getString(new SqlObject("SELECT term FROM  business_type  where typeno='"+sTypeNo+"' "));//产品期次

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
		{"true","","Button","保存","保存页面","saveRecord()",sResourcesPath},
		{"true","","Button","返回","返回","saveRecordAndBack()",sResourcesPath}
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
		var sterm = "<%=sterm%>";
		var swaiveFromStage = getItemValue(0, 0, "waiveFromStage");//减免开始期次
		var swaiveToStage = getItemValue(0, 0, "waiveToStage");//减免到期期次
		if(sterm=="0"){
			alert("产品基本信息期次配置是否正确！！");
			return;
		}
		if(parseInt(sterm, 10)<parseInt(swaiveToStage, 10)){
			alert("费用减免到期期次不能大于产品基本信息的期数(月)的值！！");
			return;
		}
		if(parseInt(swaiveFromStage, 10)>parseInt(swaiveToStage, 10)){
			alert("费用减免到期期次不能小于费用减免开始期期次！！");
			return;
		}
		if(swaiveFromStage=="0"){
			alert("减免开始期次不能为0！！");
			return;
		}
		
		var costReductionType = getItemValue(0,0,"costReductionType");
		var costType=costReductionType.split(",");
		var costTypes = "";
		var costTypes1 = "";
		for(var i=0;i<costType.length;i++){
			if(costType[i]=="3"){
				costTypes1="印花税";
			}else if(costType[i]=="4"){
				costTypes1="保险费";
			}else if(costType[i]=="5"){
				costTypes1="月利息";
			}else if(costType[i]=="6"){
				costTypes1="月财务管理费";
			}else if(costType[i]=="7"){
				costTypes1="月客户服务费";
			}
			costTypes += costTypes1 + ", ";
			
		}
		
		setItemValue(0, 0, "remark", costTypes);
		
		
		bIsInsert = false;
	    as_save("myiframe0");
	}

    /*~[Describe=返回;InputParam=后续事件;OutPutParam=无;]~*/
	function saveRecordAndBack()
	{
		OpenPage("/BusinessManage/BusinessType/BusinessTypeCReductionList.jsp","_self","");

	}
    
    
	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script type="text/javascript">	
	function initRow(){
		if (getRowCount(0)==0) //如果没有找到对应记录，则新增一条，并设置字段默认值
		{
			as_add("myiframe0");//新增记录
			bIsInsert = true;
		}
		if("<%=sTemp%>"=="add"){
			setItemValue(0,0,"serialNo", getSerialNo("acct_fee_waive", "serialNo", ""));
		}
		setItemValue(0,0,"typeNo", "<%=sTypeNo%>");
		setItemValue(0,0,"inputOrg", "<%=CurOrg.getOrgName()%>");
		setItemValue(0,0,"inputUser", "<%=CurUser.getUserName()%>");
		setItemValue(0,0,"inputTime", "<%=StringFunction.getToday()%>");
		setItemValue(0,0,"updateOrg", "<%=CurOrg.getOrgName()%>");
		setItemValue(0,0,"updateUser", "<%=CurUser.getUserName()%>");
		setItemValue(0,0,"updateTime", "<%=StringFunction.getToday()%>");
	}
	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List07;Describe=页面装载时，进行初始化;]~*/%>
<script type="text/javascript">	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	initRow();
</script>	
<%/*~END~*/%>


<%@ include file="/IncludeEnd.jsp"%>
