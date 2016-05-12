<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
<%
/*
*	Author: XWu 2004-12-04
*	Tester:
*	Describe: 未分发不良资产信息列表
*	Input Param:
*	Output Param:  
*		RecoveryUserID  :保全部管理员ID
*   	SerialNo	:合同流水号
*		sShiftType	:移交类型
*	
	HistoryLog:slliu 2004.12.17
*/
%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "未分发不良资产信息列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%
	//定义变量	    
	String sSql = "";
	
	//获得组件参数
	
	//获得页面参数
			
%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%
	
	
	String sTempletNo = "UnDistributeList";
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	String OrgID=CurOrg.getOrgID();

	//生成查询条件
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));

	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	dwTemp.setPageSize(20);//20条一分页

	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(OrgID);//传入显示模板参数
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
		{"true","","Button","合同详情","查看信贷合同的主从信息、借款人信息及保证人信息等等","viewAndEdit()",sResourcesPath},
		{"true","","Button","指定管理人","指定合同管户人或者跟踪人，转为已分发","my_Distribute()",sResourcesPath},
		{"true","","Button","逆移交","将合同退回给原管户人","my_ReverseHandover()",sResourcesPath}
		};

/*added by FSGong 2005-03-30
	根据高科长要求，增加指定跟踪人功能
	原指定管理人不变：如果是客户移交，则指定管户人，同时移交；如果是审批移交，则指定跟踪人，同时移交。
	新增指定跟踪人：	  如果是客户移交，则指定跟踪人，不移交；如果是审批移交，则指定跟踪人，同时移交。
*/
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
	/*~[Describe=指定保全部管理人;InputParam=无;OutPutParam=无;]~*/   
	function my_Distribute(){
		//获得合同流水号、移交类型
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		var sShiftType = getItemValue(0,getRow(),"ShiftType");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert(getHtmlMessage('1'));//请选择一条信息！
		}else{
			//弹出对话选择框
			var sRecovery = PopPage("/RecoveryManage/NPAManage/NPADistributeManage/RecoveryUserChoice.jsp","","dialogWidth=25;dialogHeight=10;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no");
			if(typeof(sRecovery)!="undefined" && sRecovery.length!=0){
				sRecovery = sRecovery.split("@");
				var sRecoveryUserID = sRecovery[0];
				var sRecoveryUserName = sRecovery[1];
				var sRecoveryOrgID = sRecovery[2];
				var sReturn = PopPageAjax("/RecoveryManage/NPAManage/NPADistributeManage/RecoveryUserActionAjax.jsp?"+
					 "RecoveryUserID="+sRecoveryUserID+"&RecoveryOrgID="+sRecoveryOrgID+"&SerialNo="+sSerialNo+"&ShiftType="+sShiftType+"","","");
				if(sReturn == "true"){ //刷新页面
					if(sShiftType=="02"){
						alert("该不良资产成功分发给『"+sRecoveryUserName+"』管户！");
						self.location.reload();
					}else{
						alert("该不良资产成功分发给『"+sRecoveryUserName+"』跟踪！");
						self.location.reload();
					}
				}else{
					if(sShiftType=="02"){
						alert("该不良资产分发给『"+sRecoveryUserName+"』管户失败！");
						self.location.reload();
					}else{
						alert("该不良资产分发给『"+sRecoveryUserName+"』跟踪失败！");
						self.location.reload();
					}
				}
			}
		}
	}
		
	/*~[Describe=逆向移交记录;InputParam=无;OutPutParam=无;]~*/	
	function my_ReverseHandover(){
		//获得合同流水号
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert(getHtmlMessage('1'));//请选择一条信息！
		}else{
			if(confirm(getBusinessMessage('785'))){ //您真的想将此不良资产退回给原管户人吗？
				var sReturn = PopPageAjax("/RecoveryManage/Public/NPAShiftActionAjax.jsp?SerialNo="+sSerialNo+"&Type=2","","");
				if(sReturn == "true"){ //刷新页面
					alert(getBusinessMessage('784')); //该不良资产已成功退回给原管户人！
					self.location.reload();
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
	var bHighlightFirst = true;//自动选中第一条记录
	my_load(2,0,'myiframe0');
</script>
<%/*~END~*/%>

<%@include file="/IncludeEnd.jsp"%>