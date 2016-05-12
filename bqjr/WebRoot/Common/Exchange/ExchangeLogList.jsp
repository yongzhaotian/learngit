<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   fxie  2005.03.21
		Tester:
		Content: 出帐交易日志列表
		Input Param:
			                SerialNo: 出帐流水号
			         
		Output param:
		History Log: 
	 */
	%>
<%/*~END~*/%>
<%
	String sSerialNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
	String sCondition="";
	
	if (sSerialNo==null) sSerialNo="";
	if (!sSerialNo.equals("")) sCondition = " and SerialNo='"+sSerialNo+"'";
%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "出帐日志主界面"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%
	String sHeaders[][] = {	{"SerialNo","出帐流水号"},
							{"Date","发生时间"},
							{"TradeCode","交易代码"},
							{"OperateFlag","交易状态"},
							{"OperateOrgName","操作机构"},
							{"OperateUserName","操作人"},
							{"SendMsg","发送信息"},
							{"BackMsg","返回信息"}
						  };

	String sSql =	" select SerialNo,Date,TradeCode,OperateFlag,OperateOrgID,OperateUserID,"+
	                " getOrgName(OperateOrgID) as OperateOrgName,getUserName(OperateUserID) as OperateUserName,"+
	                " ltrim(rtrim(SendMsg)) as SendMsg,ltrim(rtrim(BackMsg)) as BackMsg" +	                
					" from Trade_Log " +
					//" where TradeCode<>'O6001' " + sCondition+
					" where 1=1 " + sCondition+
					" Order by Date Desc ";

	//用sSql生成数据窗体对象
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders);
	doTemp.UpdateTable = "Trade_Log";

	doTemp.setKey("SerialNo,Date",true);
	doTemp.setVisible("OperateOrgID,OperateUserID,BackMsg",false);
	
		
	doTemp.setHTMLStyle("TradeCode,OperateFlag"," style={width:60px} ");
	doTemp.setHTMLStyle("OperateOrgName,OperateUserName"," style={width:100px} ");
	doTemp.setHTMLStyle("Date"," style={width:120px} ");
	
	//设置多选项   
	doTemp.multiSelectionEnabled = true;
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));	

	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置为Grid风格
	dwTemp.ReadOnly = "1"; //设置为只读


	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List04;Describe=定义按钮;]~*/%>
	<%
		
		String sButtons[][] = {
								{"true","","Button","全选","全选","SelectedAll()",sResourcesPath},
								{"true","","Button","反选","反选","SelectedBack()",sResourcesPath},
								{"true","","Button","取消全选","取消全选","SelectedCancel()",sResourcesPath},
								{"true","","Button","详情","查看日志详情","viewDetail()",sResourcesPath},
								{"false","","Button","删除","删除日志","deleteSelected()",sResourcesPath}
							  };
	   
	   if(CurUser.hasRole("000")){
	       sButtons[4][0] = "true";
	   }
	%> 
<%/*~END~*/%>



<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>



<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
<script type="text/javascript">
	
	/*~[Describe=全选ObjectViewer无;InputParam=无;OutPutParam=无;]~*/
	function SelectedAll(){
		
		for(var iMSR = 0 ; iMSR < getRowCount(0) ; iMSR++)
		{
			var a = getItemValue(0,iMSR,"MultiSelectionFlag");
			if(a != "√"){
				setItemValue(0,iMSR,"MultiSelectionFlag","√");
			}
		}
	}
	
	
	/*~[Describe=反选ObjectViewer无;InputParam=无;OutPutParam=无;]~*/
	function SelectedBack(){
		
		for(var iMSR = 0 ; iMSR < getRowCount(0) ; iMSR++)
		{
			var a = getItemValue(0,iMSR,"MultiSelectionFlag");
			if(a != "√"){
				setItemValue(0,iMSR,"MultiSelectionFlag","√");
			}else{
				setItemValue(0,iMSR,"MultiSelectionFlag","");
			}
		}
	}
	
	/*~[Describe=取消全选ObjectViewer无;InputParam=无;OutPutParam=无;]~*/
	function SelectedCancel(){
		for(var iMSR = 0 ; iMSR < getRowCount(0) ; iMSR++)
		{
			var a = getItemValue(0,iMSR,"MultiSelectionFlag");
			if(a != ""){
				setItemValue(0,iMSR,"MultiSelectionFlag","");
			}
		}
	}
	
	/*~[Describe=使用ObjectViewer打开;InputParam=无;OutPutParam=无;]~*/
	function viewDetail()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");	
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));
			return;
		}else{
		
		}
		sSendMsg = getItemValue(0,getRow(),"SendMsg");
		sBackMsg = getItemValue(0,getRow(),"BackMsg");
		alert("发送信息:\r\n"+ sSendMsg + "\r\n 返回信息:\r\n"+sBackMsg);
	}
	
	/*~[Describe=;InputParam=无;OutPutParam=无;]~*/

	function deleteSelected()
	{
		var sSerialNoList = getItemValueArray(0,"SerialNo");
		if (sSerialNoList.length==0){
			alert(getHtmlMessage('1'));
			return;
		}
		
		sReturn = PopPageAjax("/Common/Exchange/ExchangeLogDeleteActionAjax.jsp?SerialNoArray="+sSerialNoList,"","resizable=yes;dialogWidth=60;dialogHeight=30;center:yes;status:no;statusbar:no");
        if (typeof(sReturn)!="undefined"){
        	if (sReturn == "SUC"){
        		alert("删除成功！");
        	}else{
        		alert("删除失败！");
        	}
        }else{
        	alert("删除失败！");
        }
		
		reloadSelf();
	}
		
</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List07;Describe=页面装载时，进行初始化;]~*/%>

<script type="text/javascript">
	AsOne.AsInit();
	init();
	my_load(2,0,"myiframe0");
</script>
<%/*~END~*/%>


<%@ include file="/IncludeEnd.jsp"%>