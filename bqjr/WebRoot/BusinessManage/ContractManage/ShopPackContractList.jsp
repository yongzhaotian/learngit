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
		ObjectType:对象类型
		ObjectNo：对象编号
		
		Output Param:
			
		HistoryLog:
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "新增关联合同"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info02;Describe=定义变量，获取参数;]~*/%>
<%
	//获得页面参数
    String sPackNo    = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("PackNo"));

    System.out.println("----------------"+sPackNo);

    if(sPackNo==null) sPackNo="";
%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info03;Describe=定义数据对象;]~*/%>
	<%
	String sHeaders[][] = { 							
			{"SerialNo","合同编号"},
			{"Stores","门店号"},
			{"SalesExecutive","销售代表ID"},
			{"SignedDate","签署日期"},
			{"LandMarkStatus","地标"},
			{"QualityGrade","合同质量等级"}
		   }; 
     //合同状态是：已签署、已注册
	 String sSql = "select bc.SerialNo as SerialNo,bc.stores as Stores,bc.salesexecutive as SalesExecutive,bc.SignedDate as SignedDate,getItemName('LandMarkStatus',bc.landmarkstatus) as LandMarkStatus,getItemName('QualityGrade',bc.QualityGrade) as QualityGrade from business_contract bc where bc.landmarkstatus in ('1','6') and bc.contractstatus in ('020','050') ";
		
	 ASDataObject doTemp = null;
	 doTemp = new ASDataObject(sSql);
	 doTemp.setHeader(sHeaders);	
	 doTemp.multiSelectionEnabled=true;
	 doTemp.setKey("SerialNo", true);
	 
	 //doTemp.setHTMLStyle("modelsID", "style={width:50px}");
	 //doTemp.setHTMLStyle("modelsBrand,modelsSeries,carModel,carModelCode", "style={width:100px}");
	 //doTemp.setHTMLStyle("bodyType,manufacturers,salesStartTime,engineSize,color", "style={width:100px}");
// 	 doTemp.setColumnAttribute("SerialNo,Stores,LandMarkStatus","IsFilter","1");
	 doTemp.setFilter(Sqlca, "0020", "SerialNo", "Operators=EqualsString,BeginsWith;");
	 doTemp.setFilter(Sqlca, "0030", "Stores", "Operators=EqualsString,BeginsWith;");
	 doTemp.setFilter(Sqlca, "0040", "SalesExecutive", "Operators=EqualsString");
// 	 doTemp.setFilter(Sqlca, "0050", "LandMarkStatus", "Operators=EqualsString,BeginsWith;");
	 doTemp.generateFilters(Sqlca);
	 doTemp.parseFilterData(request,iPostChange);
// 	 if(CurUser.hasRole("1006")){
// 		 doTemp.WhereClause += " and bc.salesexecutive ='"+ CurUser.getUserID() +"'";
// 	 }
	boolean flag = true;
	for(int k=0;k<doTemp.Filters.size();k++){
		if(doTemp.Filters.get(k).sFilterInputs[0][1] != null && (("0020").equals(doTemp.getFilter(k).sFilterID)||("0030").equals(doTemp.getFilter(k).sFilterID)||("0030").equals(doTemp.getFilter(k).sFilterID)||("0040").equals(doTemp.getFilter(k).sFilterID))){
			flag = false;
			break;
		}
	}
	if(doTemp.haveReceivedFilterCriteria()&& flag)
	{
		%>
		<script type="text/javascript">
			alert("合同编号,门店号,销售代表ID至少输入一项！");
		</script>
		<%
		doTemp.WhereClause+=" and 1=2";
	}	
	 for(int k=0;k<doTemp.Filters.size();k++){
			//输入的条件都不能含有%符号
			if(doTemp.Filters.get(k).sFilterInputs[0][1] != null && doTemp.Filters.get(k).sFilterInputs[0][1].contains("%")){
				%>
				<script type="text/javascript">
					alert("输入的条件不能含有\"%\"符号!");
				</script>
				<%
				doTemp.WhereClause+=" and 1=2";
				break;
			}
			if(("0020").equals(doTemp.getFilter(k).sFilterID) && doTemp.Filters.get(k).sFilterInputs[0][1] != null && doTemp.Filters.get(k).sFilterInputs[0][1].trim().length() < 8){
				%>
				<script type="text/javascript">
					alert("输入的合同号长度必须要大于等于8位!");
				</script>
				<%
				doTemp.WhereClause+=" and 1=2";
				break; 
			}
			if(("0030").equals(doTemp.getFilter(k).sFilterID) &&  doTemp.Filters.get(k).sFilterInputs[0][1] != null && doTemp.Filters.get(k).sFilterInputs[0][1].trim().length() < 6){
				%>
				<script type="text/javascript">
					alert("输入的门店号长度必须要大于等于6位!");
				</script>
				<%
				doTemp.WhereClause+=" and 1=2";
				break; 
			}
	 }
	  if(!doTemp.haveReceivedFilterCriteria()) doTemp.WhereClause+=" and 1=2";
	 
	 CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置为只读
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
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
			{"true","","Button","确认","确认","doCreation()",sResourcesPath},
			{"true","","Button","取消","取消","doCancel()",sResourcesPath}	
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
	function doCreation() {
		saveRecord("doReturn()");
	}
	
	function saveRecord(sPostEvents)
	{		
		var sArtificialNo = getItemValueArray(0,"SerialNo");
		var temp="";
		var flag=true;
		var isFlag=true;
		
		for(var i=0;i<sArtificialNo.length;i++){
			var count= RunMethod("Unique","uniques","Shop_Contract,count(1),ContractNo='"+sArtificialNo[i]+"' and PackNo='"+<%=sPackNo%>+"' and packtype='01' ");

			if(count >= "1.0"){
				 temp=temp+sArtificialNo[i]+",";
				 flag=false;
			 }
			//判断合同是否被其他包裹关联了
			var sum= RunMethod("Unique","uniques","Shop_Contract,count(1),ContractNo='"+sArtificialNo[i]+"' and packtype='01' ");

			if(sum >= "1.0"){
				 temp=temp+sArtificialNo[i]+",";
				 isFlag=false;
			 }
		}
		
		if(isFlag==true && flag==true && sArtificialNo != ""){
			for(var i=0;i<sArtificialNo.length;i++){
				 RunMethod("BusinessManage","addPackRelative",getSerialNo("Shop_Contract","SerialNo"," ")+",<%=sPackNo%>,"+sArtificialNo[i]+","+"01");
			}
			alert("导入成功！！！");
			top.close();
		}else if(flag==false && sArtificialNo != ""){
			alert("你选择中的合同有已存在记录！请重新选择！谢谢！");
		}else if (isFlag == false && sArtificialNo != ""){
			alert("你选择中的合同有已被其他包裹关联，请检查！");
		}else{
			alert("你没有选择记录，不能导入！请选择！");
		}	
	}
	
	function doReturn(){
		top.close();
	}
	
	function doCancel()
	{	
		top.returnValue = "_CANCEL_";
		top.close();
	}

	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List07;Describe=页面装载时，进行初始化;]~*/%>
<script type="text/javascript">
	AsOne.AsInit();
	showFilterArea();
	init();
	my_load(2,0,'myiframe0');
</script>
<%/*~END~*/%>

<%@	include file="/IncludeEnd.jsp"%>