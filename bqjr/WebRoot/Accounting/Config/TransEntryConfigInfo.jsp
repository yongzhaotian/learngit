<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

	<%
	String PG_TITLE = "会计分录定义详情"; // 浏览器窗口标题 <title> PG_TITLE </title>
	
	//定义变量
	String sSortID =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("SortID"));//分录序号
	String sTransID =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("TransID"));//交易编号
	String inputparatemplete =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("Inputparatemplete"));//该分录模板
    if(sSortID==null) sSortID="";
    if(sTransID==null) sTransID="";
    if(inputparatemplete==null) inputparatemplete="";
    
	ASDataObject doTemp = new ASDataObject("TransEntryConfigInfo",Sqlca);//分录模板设置
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写
	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sTransID+","+sSortID);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{"true","","Button","保存","保存记录","saveRecord()",sResourcesPath},
	};
	%> 
	
	<%@include file="/Resources/CodeParts/List05.jsp"%>


	<script language=javascript>

	function saveRecord(){
		as_save("myiframe0","parent.reloadSelf(1)");
	}
	
	function getSumScript(){
		//selectMore("SumScriptEnable","SelectSumScript");
		var inputparatemplete = "<%=inputparatemplete%>";
		if(inputparatemplete=="" || inputparatemplete.length==0){
			//alert("请先定义该交易所用模板！");
			inputparatemplete = "DefaultDoNo";
		}
		var sReturn = AsControl.OpenView("/Accounting/Config/SelectDoNoList.jsp","Inputparatemplete="+inputparatemplete,"_blank","dialogWidth=700px;dialogHeight=600px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		if(typeof(sReturn) == "undefined" || sReturn.length == 0 || sReturn == '_CANCEL_' || sReturn == '_CLEAR_') return;
		setItemValue(0,0,"SumScript",sReturn);
		
	}

	
	function initRow(){
		if (getRowCount(0)==0){
			as_add("myiframe0");//新增记录
			setItemValue(0,0,"TransID","<%=sTransID%>");	
		}
    }

	</script>

<script language=javascript>	
	AsOne.AsInit();
	init();
	var bFreeFormMultiCol = true;
	my_load(2,0,'myiframe0');
	initRow();
</script>	

<%@ include file="/IncludeEnd.jsp"%>