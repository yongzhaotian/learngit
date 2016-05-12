<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
	Author:   CChang 2003.8.25
	Tester:
	Content: 签署意见
	Input Param:
		TaskNo：任务流水号
		ObjectNo：对象编号
		ObjectType：对象类型
	Output param:
	History Log: zywei 2005/07/31 重检页面
	*/
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "新增费用事件";
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%	
	//获取组件参数：任务流水号
	String sObjectNo = DataConvert.toRealString(iPostChange,CurComp.getParameter("SerialNo"));
	//将空值转化为空字符串
	if(sObjectNo == null) sObjectNo = "";
%>
<%/*~END~*/%>

	<%
	// 通过DW模型产生ASDataObject对象doTemp
		String sTempletNo = "BusinessFeeEvent";//模型编号
		ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
		
		ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
		dwTemp.Style="2";      // 设置DW风格 1:Grid 2:Freeform
		dwTemp.ReadOnly = "0"; // 设置是否只读 1:只读 0:可写
		
		//生成HTMLDataWindow
		Vector vTemp = dwTemp.genHTMLDataWindow(sObjectNo);//传入参数,逗号分割
		for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	
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
			{"true","","Button","保存","保存所有修改","saveRecord()",sResourcesPath},
			{"false","","Button","返回","返回列表页面","saveRecordAndBack()",sResourcesPath},
		};
	%> 
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=Info05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/Info05.jsp"%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script type="text/javascript">
	//var bIsInsert = false;
	
	/*~[Describe=保存;InputParam=后续事件;OutPutParam=无;]~*/
	function saveRecord()
	{	
		if(!vI_all("myiframe0")) return;
		if(confirm("您确认要新增该笔费用吗？")){
			var sLoanSerialno=getItemValue(0,getRow(),"LoanSerialno");
			var sEventType=getItemValue(0,getRow(),"AcctFeeType");
			var sEventFee=getItemValue(0,getRow(),"EventFee");
			var sEventExplain=getItemValue(0,getRow(),"EventExplain");
			
			sParaString = sEventType+",jbo.app.ACCT_LOAN,"+sLoanSerialno+","+"<%=CurUser.getUserID()%>";
			var sFeeSerialNo=RunMethod("LoanAccount","CreateFee",sParaString);
			sParaString =sFeeSerialNo+","+sEventFee+","+sLoanSerialno+","+sEventExplain+","+"<%=CurUser.getUserID()%>"+","+"<%=CurUser.getOrgID()%>";
		    sReturn=RunMethod("BusinessManage","BusinessFeeEvent",sParaString);
			if (sReturn=="success"){
				alert("新增成功");
			}else{
				alert("保存失败");
			}
		}
	}
	
	/*~[Describe=查询选中事件设置的费用金额;InputParam=无;OutPutParam=无;]~*/
	function selEventFeeAmount()
	{
			var sFeeTermID=getItemValue(0,getRow(),"AcctFeeType");
			var dFeeAmount=RunMethod("BusinessManage","SelEventFeeAmount",sFeeTermID);
			if(dFeeAmount=="Null" || dFeeAmount=="") dFeeAmount=0.0;
			setItemValue(0,getRow(),"EventFee",dFeeAmount);
	}
	
	/*~[Describe=对DW当前记录进行初始化;InputParam=无;OutPutParam=无;]~*/
	function initRow()
	{
		setItemValue(0,getRow(),"InputUserName","<%=CurUser.getUserName()%>");
		setItemValue(0,getRow(),"InputOrgName","<%=CurOrg.getOrgName()%>");
		setItemValue(0,getRow(),"InputTime","<%=StringFunction.getToday()%>");			      
	}
	</script>
<%/*~END~*/%>


<script type="text/javascript">	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	initRow(); //页面装载时，对DW当前记录进行初始化
</script>	
<%@ include file="/IncludeEnd.jsp"%>