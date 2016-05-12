<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author: sjchuan 2009-10-20
		Tester:
		Describe: 出账信息中的票据信息列表
		Input Param:
		Output Param:		
		HistoryLog:
	 */
	%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "票据信息"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量

	//获得页面参数

	//获得组件参数
	String sPutoutSerialNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	String sContractSerialNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ContractSerialNo"));
	String sBusinessType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("BusinessType"));
    if(sPutoutSerialNo == null) sPutoutSerialNo = ""; 
    if(sContractSerialNo == null) sContractSerialNo = "";
    if(sBusinessType == null) sBusinessType = ""; 
%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%
	String sHeaders[][] = {	{"BillNo","票据号码"},
							{"BillType","票据类型"},
							{"BillSum","票面金额"},
							{"WriteDate","票据签发日"},
							{"Maturity","票据到期日"},
							{"UserName","登记人"},
	                        {"OrgName","登记机构"},
	                        {"SerialNo","票据流水号"}
	                       }; 
	String sSql = " select BI.ObjectNo,BI.ObjectType,BI.SerialNo,BI.BillNo,BI.BillSum,"+
				  " BI.WriteDate,BI.Maturity,"+
				  " getUserName(BI.InputUserID) as UserName,getOrgName(BI.InputOrgID) as OrgName "+
				  " from BILL_INFO BI,PUTOUT_RELATIVE PR "+
				  " where BI.ObjectNo = '"+sContractSerialNo+"' and BI.ObjectType='BusinessContract' "+
				  " and BI.SerialNo=PR.SerialNo and PR.PutOutNo='"+sPutoutSerialNo+"'";

	//由SQL语句生成窗体对象。
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders);
	doTemp.UpdateTable = "PUTOUT_RELATIVE";
	doTemp.setKey("SerialNo,PutoutNo",true);	 //为后面的删除
	
	//设置不可见项
	doTemp.setVisible("SerialNo,ObjectNo,ObjectType",false);
	
	//设置不可见项
	doTemp.setVisible("InputOrgID,InputUserID",false);
	doTemp.setUpdateable("UserName,OrgName",false);
	doTemp.setHTMLStyle("UserName,WriteDate,Maturity"," style={width:80px} ");
	
	//设置金额为三位一逗数字
	doTemp.setType("BillSum","Number");

	//设置数字型，对应设置模版"值类型 2为小数，5为整型"
	doTemp.setCheckFormat("BillSum","2");
	
	//设置字段对齐格式，对齐方式 1 左、2 中、3 右
	doTemp.setAlign("BillSum","3");
	
	//生成datawindow
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置为Grid风格
	dwTemp.ReadOnly = "1"; //设置为只读
    
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
		{"true","All","Button","新增票据","新增票据信息","newRecord()",sResourcesPath},
		{"true","","Button","票据详情","查看票据详情","viewAndEdit()",sResourcesPath},
		{"true","All","Button","删除票据","删除票据信息","deleteRecord()",sResourcesPath},		
		{(!"2010".equals(sBusinessType)?"true":"false"),"All","Button","引入票据","引入合同下已存在的票据","importBill()",sResourcesPath}
		};
	%>
<%/*~END~*/%>




<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script type="text/javascript">
	/*~[Describe=新增记录;InputParam=无;OutPutParam=无;]~*/
	function newRecord()
	{
		OpenPage("/CreditManage/CreditApply/BillInfo.jsp","_self","");
	}


	/*~[Describe=删除记录;InputParam=无;OutPutParam=无;]~*/
	function deleteRecord()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
		}
		else if(confirm(getHtmlMessage('2')))//您真的想删除该信息吗？
		{
			as_del('myiframe0');
			as_save('myiframe0');  //如果单个删除，则要调用此语句
		}

		//当业务品种为"银行承兑汇票"时，还需要从BILL_INFO表中删除记录。add by cbsu 2009-11-11
	    sBusinessType = "<%=sBusinessType%>";
	    if (sBusinessType == "2010") {
	    	RunMethod("BusinessManage","DeleteBillInfo",sSerialNo);
		}
	}
	/*~[Describe=查看及修改详情;InputParam=无;OutPutParam=无;]~*/
	function viewAndEdit()
	{
		sBusinessType = "<%=sBusinessType%>";
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if(typeof(sSerialNo)=="undefined" || sSerialNo.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
		}
		else 
		{
			OpenPage("/CreditManage/CreditApply/BillInfo.jsp?SerialNo="+sSerialNo,"_self","");				
		}
	}

	/*~[Describe=引入与合同关联的票据信息;InputParam=无;OutPutParam=无;]~*/
	// add by cbsu 2009-11-03
	function importBill()
	{
		var sContarctSerialNo = "<%=sContractSerialNo%>";
		var sPutOutNo = "<%=sPutoutSerialNo%>";
		var sParaString = "ObjectNo" + "," + sContarctSerialNo + ",PutOutNo" + "," + sPutOutNo;
		sReturn = setObjectValue("selectContractBillInfo",sParaString,"",0,0,"");
		if (typeof(sReturn) == "undefined" || sReturn.length == 0) {
		    return false;
		} else {
			var sSerialNo = sReturn.split("@")[0];
			sParaString = sPutOutNo + "," + sSerialNo + "," + 
			              "<%=StringFunction.getToday()%>" + "," + "<%=CurUser.getUserID()%>" + "," + "<%=sBusinessType%>";
		    RunMethod("BusinessManage","InsertPutoutRelative",sParaString);
		    reloadSelf();
		}
	}

	</script>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script type="text/javascript">
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
