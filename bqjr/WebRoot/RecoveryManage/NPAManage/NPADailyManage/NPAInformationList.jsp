<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
<%
/*
*	Author: hxli 2005-8-2
				
*	Tester:
*	Describe: 不良资产信息管理列表;
*		  从合同表BUSINESS_CONTRACT 中获取数据，其中：保全管理人＝CurUser and 清偿日期FinishDate为空 and 业务品种BusinessType Like （信贷类产品）中的数据。
*		  业务品种业务品种BusinessType 是80的为其他类不良资产。其他为信贷类不良资产
*	Input Param:
*		ItemMenuNo :菜单编号
*		      01010：未清偿的信贷类不良资产		      
*		      01030：已核销的信贷类不良资产
*		      01040：已清偿的信贷类不良资产		    
*	Output Param:     
*	HistoryLog:
*/
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "不良资产信息管理列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%
	//定义变量
	String sSerialNo = "" ; //合同编号
	String sWhereCondition = "";
	String sUserID = CurUser.getUserID();
	String sTempletNo = "";
		
	//获得组件参数
	String sItemMenuNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ItemMenuNo")); //CodeLibrary 中定义describe编号
%>                    
<%/*~END~*/%>         

                      
<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%

	
	if(sItemMenuNo.equals("01010")){ //未终结的信贷类不良资产
		sTempletNo = "NPAInformationList01";	
	}else if(sItemMenuNo.equals("01040")){ //已终结的信贷类不良资产
		sTempletNo = "NPAInformationList02";	
	}else if(sItemMenuNo.equals("01030")){ //已核销的信贷类不良资产
		sTempletNo = "NPAInformationList03";
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
	 Vector vTemp = dwTemp.genHTMLDataWindow(sUserID);//传入显示模板参数
	 for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
				

	String sCriteriaAreaHTML = ""; //查询区的页面代码
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
				{"true","","Button","合同详情","查看信贷合同的主从信息、借款人信息及保证人信息等等","viewAndEdit()",sResourcesPath},
				{"true","","Button","日常工作","日常工作信息","my_ManageView()",sResourcesPath},
				{"true","","Button","终结","合同归档终结操作","my_FinishPigeonhole()",sResourcesPath},
				{"true","","Button","转未终结","合同转未终结操作","my_ExitPigeonhole()",sResourcesPath},
				{"true","","Button","还款方式补登","还款方式补登","my_ReturnWay()",sResourcesPath},
		};

	if (sItemMenuNo.equals("01010")) {
		sButtons[3][0] = "false";
	}
	if (sItemMenuNo.equals("01030")) {
		sButtons[2][0] = "false";
		sButtons[4][0] = "false";
	}
	if (sItemMenuNo.equals("01040")) {
		sButtons[2][0] = "false";
		sButtons[4][0] = "false";
	}
%>
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>

<%/*查看合同详情代码文件*/%>
<%@include file="/RecoveryManage/Public/ContractInfo.jsp"%>

<script type="text/javascript">

	//---------------------定义按钮事件------------------------------------
	/*~[Describe=合同台帐信息;InputParam=无;OutPutParam=无;]~*/
	function my_ManageView(){ 
		//合同流水号、合同编号、客户名称,币种
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		var sItemMenuNo = "<%=sItemMenuNo%>";
		if (typeof(sSerialNo) == "undefined" || sSerialNo.length == 0){
			alert(getHtmlMessage('1'));  //请选择一条信息！
			return;
		}else{
			sObjectType = "NPABook";
			sObjectNo = sSerialNo;
			if(sItemMenuNo == "01030" || sItemMenuNo == "01040" ) 
				sViewID = "002";
			else
				sViewID = "001";
			
			openObject(sObjectType,sObjectNo,sViewID);
		}
	}
	
    /*~[Describe=清偿归档;InputParam=无;OutPutParam=无;]~*/
	function my_FinishPigeonhole(){
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo) == "undefined" || sSerialNo.length == 0){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}else{
			//获取合同余额、表内欠息、表外欠息
			var sBalance = getItemValue(0,getRow(),"Balance");
			var sInterestBalance1 = getItemValue(0,getRow(),"InterestBalance1");
			var sInterestBalance2 = getItemValue(0,getRow(),"InterestBalance2");
			if((parseFloat(sBalance)+parseFloat(sInterestBalance1)+parseFloat(sInterestBalance2)) > 0){
				alert(getBusinessMessage('649'));//该合同【余额＋表内欠息金额＋表外欠息金额>0】不能进行终结操作！
				return;
			}else{
				//弹出对话选择框
				sReturn = PopPage("/RecoveryManage/NPAManage/NPADailyManage/NPAFinishedTypeDialog.jsp","","dialogWidth:22;dialogHeight:10;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no;");
				if(typeof(sReturn) != "undefined" && sReturn.length != 0){
					ss = sReturn.split('@');
					sFinishedType = ss[0];
					sFinishedDate = ss[1];
					//终结操作
					sReturn = RunMethod("PublicMethod","UpdateColValue","String@FinishType@"+sFinishedType+"@String@FinishDate@"+sFinishedDate+",BUSINESS_CONTRACT,String@SerialNo@"+sSerialNo);
					if(typeof(sReturn) == "undefined" || sReturn.length == 0) {				
						alert(getHtmlMessage('62'));//终结失败！
						return;			
					}else{
						reloadSelf();	
						alert(getHtmlMessage('43'));//终结成功！
					}
				}
			}
		}
	}
	
    /*~[Describe=转到未清偿;InputParam=无;OutPutParam=无;]~*/
	function my_ExitPigeonhole(){
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");		
		if (typeof(sSerialNo) == "undefined" || sSerialNo.length == 0){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}else{
			if(confirm(getHtmlMessage('63'))){ //您真的想将该信息终结取消吗？
				//取消归档操作
				sReturn = RunMethod("PublicMethod","UpdateColValue","String@FinishType@None@String@FinishDate@None,BUSINESS_CONTRACT,String@SerialNo@"+sSerialNo);
				if(typeof(sReturn) == "undefined" || sReturn.length == 0) {					
					alert(getHtmlMessage('65'));//取消终结失败！
					return;
				}else{
					reloadSelf();
					alert(getHtmlMessage('64'));//取消终结成功！
				}				
		   	}
		}
	}
	
	/*~[Describe=不良资产还款方式补登;InputParam=无;OutPutParam=无;]~*/
	function my_ReturnWay(){
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");		
		if (typeof(sSerialNo) == "undefined" || sSerialNo.length == 0){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}else{
			OpenComp("NPAReturnWayMain","/RecoveryManage/NPAManage/NPADailyManage/NPAReturnWayView.jsp","ComponentName=不良资产还款方式&ComponentType=MainWindow&DefaultTVItemName=待补登工作&SerialNo="+sSerialNo,"_blank",OpenStyle)
		}
	}
	
</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List07;Describe=页面装载时，进行初始化;]~*/%>
<script type="text/javascript">
	AsOne.AsInit();
	init();
	var bHighlightFirst = true;//自动选中第一条记录
	my_load(2,0,'myiframe0');
</script>
<%/*~END~*/%>


<%@include file="/IncludeEnd.jsp"%>
