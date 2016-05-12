<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%@page import="com.amarsoft.dict.als.cache.CodeCache"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author: daihuafeng 2015-9-30
		Tester:
		Describe: 合同质量管理
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "合同质量管理"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info02;Describe=定义变量，获取参数;]~*/%>

<%

	//获得页面参数
	//String sProductID  = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("productID"));	
    //if(sProductID==null) sProductID="";
   
%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info03;Describe=定义数据对象;]~*/%>
	<%
		
	
	 ASDataObject doTemp = null;
	 String sTempletNo = "ContractQualityManageList";
	 doTemp = new ASDataObject(sTempletNo,Sqlca);
	 //where条件
	/*  doTemp.WhereClause += " AND Check_Contract.CheckDocStatus in ('3','5') "
	 	+ " and BUSINESS_CONTRACT.ContractStatus in ('020','050','080') "
		+ " and BUSINESS_CONTRACT.PigeonholeDate is null "
		+ " and BUSINESS_CONTRACT.suretype = 'APP' "; */
	 doTemp.WhereClause += " and BUSINESS_CONTRACT.ContractStatus in ('050','160') "
		+ " and BUSINESS_CONTRACT.PigeonholeDate is null "
		+ " and (BUSINESS_CONTRACT.suretype = 'APP' or BUSINESS_CONTRACT.suretype = 'FC')";
	 
	doTemp.setFilter(Sqlca, "0010", "SerialNo", "Operators=EqualsString,BeginsWith;");
	doTemp.setFilter(Sqlca, "0020", "CustomerName", "Operators=EqualsString,BeginsWith;");
	doTemp.setFilter(Sqlca, "0030", "CheckBeginDate", "Operators=EqualsString,BeginsWith;");
	doTemp.setFilter(Sqlca, "0040", "GetTaskUserName1", "Operators=EqualsString,BeginsWith;");
	doTemp.setFilter(Sqlca, "0050", "CheckAgainBeginDate", "Operators=EqualsString,BeginsWith;");
	doTemp.setFilter(Sqlca, "0060", "GetTaskUserName2", "Operators=EqualsString,BeginsWith;");
	doTemp.parseFilterData(request,iPostChange);
	
	//添加查询限制，以防查询结果集太大
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
		
		if(doTemp.Filters.get(k).sFilterInputs[0][1] != null  && "BeginsWith".equals(doTemp.Filters.get(k).sOperator)){
			if((("0020").equals(doTemp.getFilter(k).sFilterID) || ("0040").equals(doTemp.getFilter(k).sFilterID) || ("0060").equals(doTemp.getFilter(k).sFilterID)) 
					&& doTemp.Filters.get(k).sFilterInputs[0][1].trim().length() < 2){
				%>
				<script type="text/javascript">
					alert("输入的字符长度必须要大于等于2位!");
				</script>
				<%
				doTemp.WhereClause+=" and 1=2";
				break;
			}else if(("0010").equals(doTemp.getFilter(k).sFilterID) && doTemp.Filters.get(k).sFilterInputs[0][1].trim().length() < 8){
				%>
				<script type="text/javascript">
					alert("输入的合同号长度必须要大于等于8位!");
				</script>
				<%
				doTemp.WhereClause+=" and 1=2";
				break; 
			}
			
		} else if(k==doTemp.Filters.size()-1){
		
			if(!doTemp.haveReceivedFilterCriteria()) doTemp.WhereClause+=" and 1=2";
		
		}
	}
	
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	 
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置为只读
	dwTemp.setPageSize(20);
	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");//新增参数传递：2013-5-9
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	
	//调用电子合同地址需保存到配置文件中使用
	String sAPPUrl4pdf = CodeCache.getItem("PrintAppUrl","0010").getItemAttribute();
	String sAPPUrl4Sxhpdf = CodeCache.getItem("PrintAppUrl","0014").getItemAttribute();
	System.out.println("sAPPUrl4pdf====================="+sAPPUrl4pdf);

	//蜂巢电子合同以及随心还电子合同地址
	String sFCUrl4pdf = CodeCache.getItem("PrintAppUrl","0015").getItemAttribute();
	String sFCUrl4Sxhpdf = CodeCache.getItem("PrintAppUrl","0016").getItemAttribute();


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
			{"true","","Button","电子合同","电子合同","createPDF()",sResourcesPath},
			{"true","","Button","随心还电子合同","随心还电子合同","createSxhPDF()",sResourcesPath},
			{"true","","Button","影像合同调阅","影像合同调阅","imageManage()",sResourcesPath},
			{"true","","Button","贷后文件调阅","贷后文件调阅","checkImage()",sResourcesPath},
		};
	
	%>
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script type="text/javascript">

	//---------------------定义按钮事件------------------------------------
	 function createPDF(){
        var sObjectNo = getItemValue(0,getRow(),"SerialNo");
	    //alert(sObjectNo);
	    var ssuretype = getItemValue(0,getRow(),"SureType");
	    //alert(ssuretype);
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert("请选择一条记录！");
			return;
		}
	    if (ssuretype != 'APP' && ssuretype != 'FC') {
	        alert("该合同非电子合同!");
	        return;
	    }
	    //通过　serverlet 打开页面
	    var CurOpenStyle = "width=720,height=540,top=20,left=20,toolbar=no,scrollbars=yes,resizable=yes,status=yes,menubar=no,";  
	    if(ssuretype == 'APP'){
		    window.open("<%=sAPPUrl4pdf%>"+sObjectNo,"_blank",CurOpenStyle);
	    }else if(ssuretype == 'FC'){
	    	window.open("<%=sFCUrl4pdf%>"+sObjectNo,"_blank",CurOpenStyle);
	    }
	}
	
	 function createSxhPDF(){
        var sObjectNo = getItemValue(0,getRow(),"SerialNo");
	    var ssuretype = getItemValue(0,getRow(),"SureType");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert("请选择一条记录！");
			return;
		}
	    if (ssuretype.indexOf("PC", 0) >= 0) {
	        alert("该合同非电子合同!");
	        return;
	    }
	    var bugpaypkgind = RunMethod("公用方法", "GetColValue", "business_contract,bugpaypkgind,serialno='"+sObjectNo+"'");
		if(typeof(bugpaypkgind)=="undefined" || bugpaypkgind.length==0 || bugpaypkgind == "0"){
	        alert("该合同没有购买随心还服务包!");
	        return;
		}
	    //通过　serverlet 打开页面
	    var CurOpenStyle = "width=720,height=540,top=20,left=20,toolbar=no,scrollbars=yes,resizable=yes,status=yes,menubar=no,";  
	    if(ssuretype == 'APP'){
	   		window.open("<%=sAPPUrl4Sxhpdf%>"+sObjectNo,"_blank",CurOpenStyle);
	    }else if(ssuretype == 'FC'){
	    	window.open("<%=sFCUrl4Sxhpdf%>"+sObjectNo,"_blank",CurOpenStyle);
	    }
	}
	
	/*~[Describe=影像操作;InputParam=无;OutPutParam=无;]~*/
	function imageManage(){
		var sObjectNo = getItemValue(0,getRow(),"SerialNo"); //合同流水号
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert("请选择一条记录！");
			return;
		}
		var param = "ObjectType=Business&ObjectNo="+sObjectNo;
		AsControl.OpenView("/ContractManage/ContractQualityImageCheckList.jsp",param,"_blank","");
	}
	
	//贷后资料审查
	function checkImage(){
		var sObjectNo = getItemValue(0,getRow(),"SerialNo"); //合同流水号
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert("请选择一条记录！");
			return;
		}
		//更新状态为已检查
		var param = "ObjectType=BusinessLoan&ObjectNo="+sObjectNo;
		AsControl.OpenView("/ContractManage/ContractQualityLoanCheckList.jsp",param,"_blank","");
//	     parent.reloadSelf();
	}
	
	/*~[Describe=新增记录;InputParam=无;OutPutParam=无;]~*/
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
	init();
	my_load(2,0,'myiframe0');
</script>
<%/*~END~*/%>

<%@	include file="/IncludeEnd.jsp"%>

