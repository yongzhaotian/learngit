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
    String sCreditID  = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CreditID"));
    
    System.out.println("--------贷款人编号--------"+sCreditID);

    if(sPackNo==null) sPackNo="";
    if(sCreditID==null) sCreditID="";
%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info03;Describe=定义数据对象;]~*/%>
	<%
	String sHeaders[][] = { 							
			{"SerialNo","合同编号"},
			{"CertID","身份证号码"},
			{"CustomerName","客户姓名"},
			{"Stores","门店号"},
			{"ContractStatus","合同状态"},
			{"ContractEffectiveDate","合同生效日"},
			{"SalesExecutive","销售代表"},
			{"LandMarkStatus","地标状态"},
			{"QualityGrade","质量等级"}
		   }; 
     //地标状态是：总部5，销售要关联“贷款人”，包裹关联标识：packstatus，才能查询到数据
	 String sSql = "select bc.serialno as SerialNo,bc.CertID as CertID,bc.CustomerName as CustomerName,bc.stores as Stores,getItemName('ContractStatus',bc.ContractStatus) as ContractStatus,bc.ContractEffectiveDate as ContractEffectiveDate,bc.salesexecutive as SalesExecutive,getItemName('LandMarkStatus',bc.landmarkstatus) as LandMarkStatus,getItemName('QualityGrade',bc.QualityGrade) as QualityGrade from business_contract bc,Service_Providers sp where bc.creditid=sp.serialno and bc.landmarkstatus='5' and bc.CreditAttribute ='0002' and bc.ContractStatus in('020','080','050') and bc.packstatus is null and bc.creditid='"+sCreditID+"' ";
		
	 ASDataObject doTemp = null;
	 doTemp = new ASDataObject(sSql);
	 doTemp.setHeader(sHeaders);	
	 doTemp.multiSelectionEnabled=true;//显示多选框
	 doTemp.setKey("SerialNo", true);
	 
	 //doTemp.setHTMLStyle("modelsID", "style={width:50px}");
	 //doTemp.setHTMLStyle("modelsBrand,modelsSeries,carModel,carModelCode", "style={width:100px}");
	 //doTemp.setHTMLStyle("bodyType,manufacturers,salesStartTime,engineSize,color", "style={width:100px}");
	 doTemp.setColumnAttribute("SerialNo,Stores,LandMarkStatus","IsFilter","1");
	 
	 doTemp.generateFilters(Sqlca);
	 doTemp.parseFilterData(request,iPostChange);
	 CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置为只读
	dwTemp.setPageSize(10);
	
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
		var temps="";
		var flag=true;
		var isFlag=true;
		
		for(var i=0;i<sArtificialNo.length;i++){
			var count= RunMethod("Unique","uniques","Shop_Contract,count(1),ContractNo='"+sArtificialNo[i]+"' and PackNo='"+<%=sPackNo%>+"' and packtype='02' ");
			if(count >= "1.0"){
				 temp=temp+sArtificialNo[i]+",";
				 flag=false;
			 }
			//判断合同是否被其他包裹关联了
			var sum= RunMethod("Unique","uniques","Shop_Contract,count(1),ContractNo='"+sArtificialNo[i]+"' and packtype='02' ");

			if(sum >= "1.0"){
				 temps=temp+sArtificialNo[i]+",";
				 isFlag=false;
			 }
		}
		
		if(isFlag==true && flag==true && sArtificialNo != ""){
			for(var i=0;i<sArtificialNo.length;i++){
				 RunMethod("BusinessManage","addPackRelative",getSerialNo("Shop_Contract","SerialNo"," ")+",<%=sPackNo%>,"+sArtificialNo[i]+","+"02");
				 //更新合同中包裹关联状态：2
				 RunMethod("BusinessManage","UpdatePackStatus",sArtificialNo[i]+","+"2");
			}
			alert("导入成功！！！");
			top.close();
		}else if(flag==false && sArtificialNo != ""){
			alert("你选择中的["+temp+"]合同已存在记录！请重新选择！");
		}else if (isFlag == false && sArtificialNo != ""){
			alert("你选择中的["+temps+"]合同已被其他包裹关联，请检查！");
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
    showFilterArea();
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>
<%/*~END~*/%>

<%@	include file="/IncludeEnd.jsp"%>