<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>



<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author:  jschen 2010/03/25
		Tester:	
		Content: --补登统计
		Input Param:
		Output param:
		History Log: 
			
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "补登统计"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%
   //定义变量
    String sAccountMonths = "";//--报表年月 
	
   //获得页面参数，报表数、客户数、客户代码
	String sReportCount = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ReportCount"));
	//获得组件参数
	
%>
<%/*~END~*/%>
<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=获取变量值;]~*/%>

<%

%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List04;Describe=主页面编写;]~*/%>
<HEAD>
	<title>补登统计</title>
</HEAD>
<body class="ReportPage" leftmargin="0" topmargin="0" onLoad="" style="overflow:auto" oncontextmenu="return false">
<form name="form0">
<table border="0" width="80%" height="100%" cellspacing="0" cellpadding="0" >
	<tr height=1 valign=top id="buttonback" >
		<td>
			<table width="100%" >
			<tr>
			  <td width="20%">&nbsp;</td>
  <td width="39%">
					<span >
<table width="100%" >
<tr>
							<td width="77%" align="right" valign="middle">
								查询机构： 
			    <input name="OrgName" type='text' value="" size="20" ReadOnly=true></td>
			    <input type=hidden name="OrgID" value="" >
							<td width="23%" align="center" valign="middle">
								<%=HTMLControls.generateButton("选择机构","选择机构","javascript:selectOrg();",sResourcesPath)%>							</td>
			  </tr></table>
			</span>				</td>
  <td width="25%" align=left>
					<span >
					<table width="96%" >
					  <tr><td align="left" valign="middle">
						选取图形展现方式：
						    <select name="GraphType">
                              <option value=0 >列表</option>
                              <option value=6 >柱状图</option>
                            </select>
					</td>
					  </tr></table>
		    </span>				</td>
			</tr>
            <tr>
            <td>&nbsp;</td>
            <td><table width="200" align="right">
              <tr>
                <td><%=HTMLControls.generateButton("实时查询","实时查询","javascript:graphShow();",sResourcesPath)%></td>
                <td><%=HTMLControls.generateButton("历史查询","历史查询","javascript:graphShow();",sResourcesPath)%></td>
              </tr>
            </table></td>
			  </tr>	
			</table>
	</tr>

</table>
</font>
</body>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List05;Describe=自定义函数;]~*/%>

<script>

	//---------------------定义按钮事件------------------------------------
	/*~[Describe=导出excel;InputParam=无;OutPutParam=无;]~*/
	function excelShow()
	{
		var mystr = document.all('reporttable').innerHTML;
		spreadsheetTransfer(mystr.replace(/type=checkbox/g,"type=hidden"));
	}
	
	/*~[Describe=生成图像;InputParam=无;OutPutParam=无;]~*/
	function graphShow()
	{
		var sChecked = "",iChecked = 0,sItemNames="",sItemValues="";
		
		sChecked = sChecked.substr(0,sChecked.length-1);
		sItemNames = sItemNames.substr(0,sItemNames.length-1);
		sItemValues = sItemValues.substr(0,sItemValues.length-1);
		sGraphType = document.all("GraphType").value;
		sScreenWidth = screen.availWidth-40;
		sScreenHeight = screen.availHeight-40;
	    PopPage("/InfoManage/DataInput/ReinforceStatisticGraphic.jsp?GraphType="+sGraphType+"&rand="+randomNumber(),"_blank",sDefaultDialogStyle);
	}

	/*~[Describe=选择机构;InputParam=无;OutPutParam=无;]~*/
	function selectOrg()
	{
		var sParaString = "OrgID,"+"<%=CurOrg.getOrgID()%>";
		//将选择机构设置为所有机构
		var sReturn= selectObjectValue("SelectBelongOrg",sParaString,0,0,"");	
		
		if (!(sReturn=='_CANCEL_' || typeof(sReturn)=="undefined" || sReturn.length==0 || sReturn=='_CLEAR_'))
		{
			sReturn=sReturn.split("@");
			sTraceOrgID=sReturn[0];
		
			document.all("OrgID").value=sReturn[0];
			document.all("OrgName").value=sReturn[1];
			
		}
		else if (sReturn=='_CLEAR_')
		{
			sTraceOrgID="";
		
			document.all("OrgID").value="";
			document.all("OrgName").value="";
		}
		else 
		{
			return;
		}
		
	}
</script>
<%/*~END~*/%>


<%@ include file="/IncludeEnd.jsp"%>
