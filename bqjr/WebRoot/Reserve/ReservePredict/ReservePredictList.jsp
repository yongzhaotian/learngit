<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>  
	<%
	/*
		Author:   pwang 20091019   
		Tester:	
		Content: 预测现金流List
		Input Param:
			DuebillNo:借据标号
			AccountMonth:会计月份
			CustomerID：客户编号
			AbleToSee：控制按钮显示
			PageType：控制返回页面
				Single：返回发起页面
				Cognize：返回审查审批页面
		Output param:
		History Log: 
			
	*/
	%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "未来现金流预测"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>
<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%
	//获页面参数
	
	//获得页面参数	
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));	
	String sObjectNo =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	String sPhaseNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("PhaseNo"));
	String sPhaseType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("PhaseType"));
	//其中sPhaseNo,sType,sItemMenuNo参数获取不到
	//将空值转化成空字符串
	if(sObjectType == null) sObjectType = "";
	if(sObjectNo == null) sObjectNo = "";
	if(sPhaseNo == null) sPhaseNo = "" ;
	if(sPhaseType == null) sPhaseType = ""; 

%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%
	String sTempletNo = "ReservePredictList";
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
	//doTemp.setFilter(Sqlca,"1","ReturnDate","Operators=EqualsString;"); 
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));	
    
	//生成ASDataWindow对象
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";//设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1";//设置是否只读 1:只读 0:可写
	dwTemp.setPageSize(20);//设置分页
	//删除时，需及时更新Reserve_Total.Reserve_apply
	dwTemp.setEvent("AfterInsert","!ReserveManage.FinishPredictData(#AccountMonth,#DuebillNo,#ObjectNo)");

	//生成HTMLDataWindow	
	Vector vTemp = dwTemp.genHTMLDataWindow(sObjectNo);
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
		//6.资源图片路径{"true","","Button","管户权转移","管户权转移","ManageUserIdChange()",sResourcesPath}
	String sButtons[][] = {
			{"true","","Button","新增现金流","新增记录","my_Add()",sResourcesPath},
			{"true","","Button","查看现金流详情","查看/修改详情","my_ViewEdit()",sResourcesPath},
			{"true","","Button","删除","删除记录","my_Del()",sResourcesPath},
			{"true","","Button",(sPhaseType.equals("1010")||sPhaseType.equals("1030"))?"上传附件":"查看附件","查看附件","my_View()",sResourcesPath},
		};	
	%> 
<%/*~END~*/%>

<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>
<script type="text/javascript">
	
	/*~[Describe=新增未来现金流信息;InputParam=无;OutPutParam=无;]~*/
	function my_Add(){
		PopComp("ReservePredictInfo","/Reserve/ReservePredict/ReservePredictInfo.jsp","ToInheritObj=y&ObjectNo=<%=sObjectNo%>","");
		reloadSelf();
	}
	
	/*~[Describe=查看未来现金流详情;InputParam=无;OutPutParam=无;]~*/
    function my_ViewEdit(){
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0 ){
			alert("请选择一条记录！");
			return;
		}
		
		PopComp("ReservePredictInfo","/Reserve/ReservePredict/ReservePredictInfo.jsp","ToInheritObj=y&SerialNo="+sSerialNo+"&ObjectNo=<%=sObjectNo%>","");
		reloadSelf();
	}
	
    /*~[Describe=删除;InputParam=无;OutPutParam=无;]~*/
 	function my_Del(){
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0 ){
			alert("请选择一条记录！");
			return;
		}		
		if(confirm("您真的想删除该信息吗？")){
			as_del("myiframe0");			
			as_save("myiframe0");  //如果单个删除，则要调用此语句	
		}
 	}

 	/*~[Describe=上传附件;InputParam=无;OutPutParam=无;]~*/
	function my_View(){
		PopComp("DocumentList","/AppConfig/Document/DocumentFrame.jsp","ToInheritObj=y&ObjectNo=<%=sObjectNo%>&ObjectType=Reserve","");
   	}

</script>

<script type="text/javascript">
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>

<%@ include file="/IncludeEnd.jsp"%>
