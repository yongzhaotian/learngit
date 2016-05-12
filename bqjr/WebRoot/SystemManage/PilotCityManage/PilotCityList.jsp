<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author:
		Tester:
		Describe: 
		
		Input Param:
		SerialNo:流水号
		
		Output Param:
			
		HistoryLog:
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "试点城市列表 "; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info02;Describe=定义变量，获取参数;]~*/%>
<%
	//获得页面参数
//	String sSerialNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("LoanNo"));
//	if(sSerialNo == null) sSerialNo = "";
%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info03;Describe=定义数据对象;]~*/%>
	<%
		
	
	 ASDataObject doTemp = null;
	 String sTempletNo = "LoanPilotCityList";
	 doTemp = new ASDataObject(sTempletNo,Sqlca);//新增模型：2013-5-9
	
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	doTemp.multiSelectionEnabled=true;
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
		
	 
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置为只读
	dwTemp.setPageSize(100);  //服务器分页
	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");//新增参数传递：2013-5-9
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

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
		{"true","","Button","配置试点城市","新增","newRecord()",sResourcesPath},
		{"true","","Button","删除","删除所选中的城市","deleteRecord()",sResourcesPath}
	};
	%>
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script type="text/javascript">

	//---------------------定义按钮事件------------------------------------
	/*~[Describe=新增记录;InputParam=无;OutPutParam=无;]~*/
	function newRecord(){
		
		var sParaString = "CodeNo"+","+"SubProductType";
		var sSubProductType =setObjectValue("SelectCode",sParaString,"",0,0,"");//SelectCode_Grad  SelectCode
		sSubProductType = sSubProductType.split("@")[0];
		
		sParaString = "CodeNo"+","+"PilotType";
		var vPilotType =setObjectValue("SelectCode",sParaString,"",0,0,"");//SelectCode_Grad  SelectCode
		vPilotType = vPilotType.split("@")[0];
		
 		var sReturn = RunMethod("SystemManage", "selectPilotCityIsNotNull", vPilotType+","+sSubProductType);
 		if(sReturn==0){
 			alert("该产品类型下已经没有可关联的城市了！");
 			return;
 		}
 		
	    var sCityName = PopPage("/SystemManage/PilotCityManage/AddPilotCity.jsp?SubProductType="+sSubProductType+"&PilotType="+vPilotType,"","400px;dialogHeight=540px;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;");
	    if(typeof(sCityName)=="undefined" || sCityName.length==0 || sCityName=="_none_"){
	    	return;
	    }
	    reloadSelf();
	}
	
	
	function deleteRecord(){

		var sCitys = getItemValueArray(0,"city");
		var sSubProductTypes = getItemValueArray(0,"SUBPRODUCTTYPE");
		var sVerifyTypes = getItemValueArray(0,"VERIFYTYPE");
		var sCity = sCitys[0];
		var sSubProductType = sSubProductTypes[0];
		var sVerifyType = sVerifyTypes[0];
		
		if(typeof(sCity)=="undefined" || sCity.length==0 || typeof(sSubProductType)=="undefined" || sSubProductType.length==0 ||typeof(sVerifyType)=="undefined" || sVerifyType.length==0){
			alert("请至少选择一条记录！");
			return;
		}
		
		if(confirm("您真的想删除该信息吗？")){
			for(var i=0;i<sCitys.length;i++){
				RunMethod("SystemManage", "deletePilotCity", sVerifyTypes[i]+","+sCitys[i]+","+sSubProductTypes[i]);
			}
			as_save("myiframe0");  //如果单个删除，则要调用此语句
			reloadSelf();
		}
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

<%@	include file="/IncludeEnd.jsp"%>

