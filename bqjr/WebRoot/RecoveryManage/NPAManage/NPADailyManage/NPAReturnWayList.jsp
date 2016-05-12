<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   hxli 2005-8-2
		Tester:   
		Content: 不良资产还款方式补登列表
		Input Param:
			 ItemMenuNo：菜单编号（00510待补登、00520补登完成	） 
			 SerialNo：合同流水号     
		Output param:
				 
		History Log: zywei 2005/09/03 重检代码
		                  
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "不良资产还款方式补登列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%
	//定义变量
	String sWhereClause = ""; //Where条件
	
	//获得页面参数

	//获得组件参数
	String sItemMenuNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ItemMenuNo")); 
	String sSerialNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("SerialNo")); 
	if(sItemMenuNo == null) sItemMenuNo = "";
	if(sSerialNo == null) sSerialNo = "";
	String sTempletNo = "";
	
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%

	
	if(sItemMenuNo.equals("00510")){
		sTempletNo = "NPAReturnWayList01";
	}else if(sItemMenuNo.equals("00520")){
		sTempletNo = "NPAReturnWayList02";
	}

	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);

	//生成查询条件
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));

	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	dwTemp.setPageSize(20);//20条一分页

	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sSerialNo);//传入显示模板参数
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
		{"true","","Button","合同详情","查看不良资产详情","viewAndEdit()",sResourcesPath},
		{"true","","Button","查看详情","查看还款流水详情","my_Detail()",sResourcesPath},
		{"true","","Button","补登还款方式","补登还款方式","my_register()",sResourcesPath},
		{"true","","Button","修改还款方式","修改还款方式","my_register()",sResourcesPath}
		
		};
	if(sItemMenuNo.equals("00510")){
		sButtons[3][0] = "false";
	}	
	if(sItemMenuNo.equals("00520")){
		sButtons[2][0] = "false";
	}

%>
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>

<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=ContractInfo;Describe=查看合同详情;]~*/%>
	<%@include file="/RecoveryManage/Public/ContractInfo.jsp"%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script type="text/javascript">
		
	//---------------------定义按钮事件------------------------------------
	/*~[Describe=查看还款流水详情;InputParam=无;OutPutParam=无;]~*/
	function my_Detail(){ 
		//核销流水号
		var sSerialNo = getItemValue(0,getRow(),"BWSerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}else{
			OpenPage("/RecoveryManage/NPAManage/NPADailyManage/NPABadDebtWasteBookInfo.jsp?SerialNo="+sSerialNo+"&Flag=Y", "_self","");
		}
	}

	/*~[Describe=补登还款方式;InputParam=无;OutPutParam=无;]~*/
	function my_register(){
		//记录流水号
		var sSerialNo = getItemValue(0,getRow(),"BWSerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}else{
			sParaString = "CodeNo"+",ReclaimType";
			sReturn = selectObjectValue("SelectCode",sParaString,"@BackType@0",0,0,"");
			if(typeof(sReturn) != "undefined" && sReturn != "" && sReturn != "_NONE_" && sReturn != "_CLEAR_" && sReturn != "_CANCEL_"){
				sReturn = sReturn.split('@');
				sBackType = sReturn[0];
				sReturnValue = RunMethod("PublicMethod","UpdateColValue","String@BackType@"+sBackType+",BUSINESS_WASTEBOOK,String@SerialNo@"+sSerialNo);
				if(sReturnValue == "TRUE"){
					alert(getBusinessMessage('676')); //还款方式补登成功！
					reloadSelf();
				}else{
					alert(getBusinessMessage('677')); //还款方式补登失败！
					return;
				}
			}
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

<%@include file="/IncludeEnd.jsp"%>
