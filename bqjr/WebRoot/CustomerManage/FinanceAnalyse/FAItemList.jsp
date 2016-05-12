<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%
	String sCustomerID = CurPage.getParameter("CustomerID");
	session.setAttribute("faEntIDs",sCustomerID);

	/*
	String[][] sStatItems	= {
					{"item1Value","期初值"},{"item1Value/item1baseValue","期初构成"},
					{"item2Value","期末值"},{"item2Value/item2baseValue","期末构成"},
					{"standardValue","行业值"},{"item2Value - standardValue","行业差异值"}
				  };
	*/	
	String[][] sStatItems	= {
					{"item2Value","期末值"},
					{"item1Value","期初值"}
				  };		  

	String sSql = "";
	String fiDate="";
	int fiDateLength=0;
	String sEntNames="";
	ASResultSet rsEnts=Sqlca.getASResultSet(new SqlObject("select CustomerName from CUSTOMER_INFO where CustomerID = :CustomerID").setParameter("CustomerID",sCustomerID));
	if (rsEnts.next()) 
		sEntNames = rsEnts.getString(1);
	rsEnts.getStatement().close();
	session.setAttribute("faEntNames",sEntNames);

%>	
<script type="text/javascript">
selectedCaptionList = new Array;
selectedNameList = new Array;
availableCaptionList = new Array;
availableNameList = new Array;

<%
	sSql = " select FM.ReportNo,FC.ReportName,FI.ItemNo,FI.ItemName "+
			" from FINANCE_MODEL FM,FINANCE_ITEM FI,FINANCE_CATALOG FC " +
			" where FM.FinanceItemNo = FI.ItemNo "+
			" and FM.ReportNo = FC.ReportNo " +
			" and FM.ReportNo in ( select distinct ReportNo from FINANCE_RECORD where CustomerID = :CustomerID) "+
			" and FI.ItemNo <>'1000' and FI.ItemNo is not null " +
			" order by FM.ReportNo";
	ASResultSet rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("CustomerID",sCustomerID));
	int num=0;
	while(rs.next()){
		out.println("selectedNameList["+num+"]='"+rs.getString(3)+"';"+"\r");	
		out.println("selectedCaptionList["+num+"]='"+rs.getString(2)+":"+rs.getString(4)+"';"+"\r");	
		num++;
	}
	rs.getStatement().close();
	
	rs = Sqlca.getASResultSet(new SqlObject("select Accountmonth from FINANCE_RECORD where Customerid=:Customerid order by Accountmonth").setParameter("Customerid",sCustomerID));
	num=0;
	while(rs.next()) fiDate +=rs.getString(1);
	rs.getStatement().close();
	fiDateLength=fiDate.length()/7;
%>
</script>

<html>
<head>
<meta http-equiv='Expires' content='-10'>
<meta http-equiv='Pragma'  content='No-cache'>
<meta http-equiv='Cache-Control', 'private'>
<meta http-equiv="Expires" content="-10">
<meta http-equiv="Pragma" content="No-cache">
<meta http-equiv="Cache-Control", "private">
<title>财务科目选择器</title>
</head>

<body leftmargin="0" topmargin="0" class="pagebackground">
<table border='0'  cellpadding='1' cellspacing='4' width='100%' align='center'>
<tr>
<td>
	<table><tr>
		<td>
			<%=HTMLControls.generateButton("结构分析","结构分析","javascript:structureInfo()",sResourcesPath)%>
		</td>
		<td>
			<%=HTMLControls.generateButton("指标分析","指标分析","javascript:itemInfo()",sResourcesPath)%>
		</td>
		<td>
			<%=HTMLControls.generateButton("趋势分析","趋势分析","javascript:trendInfo()",sResourcesPath)%>
		</td>
		<td>
			<%=HTMLControls.generateButton(" 行业数据库分析","行业数据库分析","javascript:indAnaInfo()",sResourcesPath)%>
		</td>
		<td>
			<%=HTMLControls.generateButton("现金流预测","现金流预测","javascript:cashFlowInfo()",sResourcesPath)%>
		</td>
	</tr></table>
</td>	
</tr>
</table>

<table border='0'  cellpadding='0' cellspacing='4' width='100%' align='center'>
<tr>
<td width='100%' colspan='2'>
	<form  action=<%= "FAFinished.jsp?rand="+java.lang.Math.random()%> method="post" target="_self"  name='customize'>
	<input type=hidden name=CompClientID value="<%=CurComp.getClientID()%>">
	<input type="hidden" name="initialString" value="">
	<input type="hidden" name="Items" value="">
	<table cellspacing=1 cellpadding=1>
	<tr>
		<td colspan=2>
		当前客户：<%=sEntNames%>
		&nbsp;&nbsp;
		</td>
		</tr>
		<tr>
		
		<td align="left">  
		图表类型：<select name=chartType>
		<option value="VBAR" selected>垂直柱状图
		<option value="HBAR">水平柱状图
		<option value="LINE">直线图
		</select>
		&nbsp;&nbsp;
		</td>
		
		<td>
		<input type=hidden name=chartType>
		统计日期：<input name=startTime type=text size=10 value="1999/12" onclick="javascript:selectStartMonth(this.name)"  readonly style="cursor: pointer;">
		至&nbsp;<input name=endTime type=text size=10 value="2000/03" onclick="javascript:selectEndMonth(this.name)" readonly style="cursor: pointer;">
		</td>
		<td>分析类型：<select name="chkStat">
		<%
		int i=0;
		for (i=0;i<sStatItems.length;i++) {
			out.println("<option value="+sStatItems[i][0]+">"+sStatItems[i][1]+"</option>");
		}
		
		%></select>
		</td>
	</tr></table>
	<br>
	<table width='100%' border='1' cellpadding='0' cellspacing='8' bgcolor='#DDDDDD'>
	<tr>
		<td bgcolor='#DDDDDD'>
			<span class='dialog-label'>&nbsp;可选取财务科目列表</span>
		</td>
		<td bordercolor='#DDDDDD'>
		</td>
		<td bgcolor='#DDDDDD'>
			<span class='dialog-label'>&nbsp;已选取财务科目列表</span>
		</td>
		<td>
		</td>
	</tr>
		<tr><td align='center'>
		<select name='available_column_selection' onchange='selectionChanged(document.forms["customize"].elements["available_column_selection"],document.forms["customize"].elements["chosen_column_selection"]); ' size='17'  style='width:100%;' width='100%' multiple='true'> 
		
		</select>
		</td>
		<td align='center' valign='middle'  bordercolor='#DDDDDD'>
		<img border='0' src='<%=sResourcesPath%>/chooser_orange/arrowRight_disabled.gif'alt='Add selected items' onmousedown='pushButton("movefrom_available_column_selection",true);'  onmouseup='pushButton("movefrom_available_column_selection",false);'  onmouseout='pushButton("movefrom_available_column_selection",false);'  onclick='moveSelected(document.forms["customize"].elements["available_column_selection"],document.forms["customize"].elements["chosen_column_selection"]); updateHiddenChooserField(document.forms["customize"].elements["chosen_column_selection"],document.forms["customize"].elements["column_selection"]); ' name='movefrom_available_column_selection' /><br><br><img border='0' src='<%=sResourcesPath%>/chooser_orange/arrowLeft_disabled.gif'alt='Remove selected items' onmousedown='pushButton("movefrom_chosen_column_selection",true);'  onmouseup='pushButton("movefrom_chosen_column_selection",false);'  onmouseout='pushButton("movefrom_chosen_column_selection",false);'  onclick='moveSelected(document.forms["customize"].elements["chosen_column_selection"],document.forms["customize"].elements["available_column_selection"]); updateHiddenChooserField(document.forms["customize"].elements["chosen_column_selection"],document.forms["customize"].elements["column_selection"]); ' name='movefrom_chosen_column_selection' /></td>
		<td align='center'>
		<select name='chosen_column_selection' onchange='selectionChanged(document.forms["customize"].elements["chosen_column_selection"],document.forms["customize"].elements["available_column_selection"]); ' size='17'  style='width:100%;' width='100%' multiple='true' >
		</select>
		<input type='hidden' name='column_selection' value=''>
		</td>
		<td  width='1' align='center' valign='middle' bordercolor='#DDDDDD'><img border='0' src='<%=sResourcesPath%>/chooser_orange/arrowUp_disabled.gif' alt='Shift selected items down' name='shiftup_chosen_column_selection' onmousedown='pushButton("shiftup_chosen_column_selection",true);'  onmouseup='pushButton("shiftup_chosen_column_selection",false);'  onmouseout='pushButton("shiftup_chosen_column_selection",false);'  onclick='shiftSelected(document.forms["customize"].elements["chosen_column_selection"],-1); updateHiddenChooserField(document.forms["customize"].elements["chosen_column_selection"],document.forms["customize"].elements["column_selection"]);' /><br><br><img border='0' src='<%=sResourcesPath%>/chooser_orange/arrowDown_disabled.gif' alt='Shift selected items up' name='shiftdown_chosen_column_selection' onmousedown='pushButton("shiftdown_chosen_column_selection",true);'  onmouseup='pushButton("shiftdown_chosen_column_selection",false);'  onmouseout='pushButton("shiftdown_chosen_column_selection",false);'  onclick='shiftSelected(document.forms["customize"].elements["chosen_column_selection"],1); updateHiddenChooserField(document.forms["customize"].elements["chosen_column_selection"],document.forms["customize"].elements["column_selection"]);' /></td></tr></table>
		</td></tr>
	
	  <tr>
	    <td align='left'>
	      
	    </td>
	    <td align='right'>
	      <input type="button" style="width:70px"  value="恢 复" onclick="javascript:doDefault();">
	       <input type="button" style="width:70px"  value="确 定" onclick="javascript:doQuery();">		   
	    </td>
	  </tr>
	</table>

</form>

</body>

</html>

<script>
var startTime="1900/01";
var endTime="2006/01";

function cloneOption(option) {
  var out = new Option(option.text,option.value);
  out.selected = option.selected;
  out.defaultSelected = option.defaultSelected;
  return out;
}
 function shiftSelected(chosen,howFar) {
  var opts = chosen.options;
  var newopts = new Array(opts.length);
  var start; var end; var incr;
  if (howFar > 0) {
    start = 0; end = newopts.length; incr = 1; 
  } else {
    start = newopts.length - 1; end = -1; incr = -1; 
  }
  for(var sel=start; sel != end; sel+=incr) {
    if (opts[sel].selected) {
      setAtFirstAvailable(newopts,cloneOption(opts[sel]),sel+howFar,-incr);
    }
  }
  for(var uns=start; uns != end; uns+=incr) {
    if (!opts[uns].selected) {
      setAtFirstAvailable(newopts,cloneOption(opts[uns]),start,incr);
    }
  }
   opts.length = 0;   for(i=0; i<newopts.length; i++) {
    opts[opts.length] = newopts[i]; 
  }
}
function setAtFirstAvailable(array,obj,startIndex,incr) {
  if (startIndex < 0) startIndex = 0;
  if (startIndex >= array.length) startIndex = array.length -1;
  for(var xxx=startIndex; xxx>= 0 && xxx<array.length; xxx += incr) {
    if (array[xxx] == null) {
      array[xxx] = obj; 
      return; 
    }
  }
}
function moveSelected(from,to) {
  newTo = new Array();
  for(i=0; i<to.options.length; i++) {
    newTo[newTo.length] = cloneOption(to.options[i]);
    newTo[newTo.length-1].selected = false;
  }
  
  for(i=0; i<from.options.length; i++) {
    if (from.options[i].selected) {
      newTo[newTo.length] = cloneOption(from.options[i]);
      from.options[i] = null;
      i--;
    }
  }
  
  to.options.length = 0;
  for(i=0; i<newTo.length; i++) {
    
    to.options[to.options.length] = newTo[i];
  }
  selectionChanged(to,from);
}


function updateHiddenChooserField(chosen,hidden) {
  hidden.value='';
  var opts = chosen.options;
  for(var i=0; i<opts.length; i++) {
    hidden.value = hidden.value + opts[i].value+'\n';
  }
  
}


function selectionChanged(selectedElement,unselectedElement) {
  for(i=0; i<unselectedElement.options.length; i++) {
    unselectedElement.options[i].selected=false;
  }
  form = selectedElement.form; 
  enableButton("movefrom_"+selectedElement.name,
               (selectedElement.selectedIndex != -1));
  enableButton("movefrom_"+unselectedElement.name,
               (unselectedElement.selectedIndex != -1));
  enableButton("shiftdown_"+selectedElement.name,
               (selectedElement.selectedIndex != -1));
  enableButton("shiftup_"+selectedElement.name,
               (selectedElement.selectedIndex != -1));
  enableButton("shiftdown_"+unselectedElement.name,
               (unselectedElement.selectedIndex != -1));
  enableButton("shiftup_"+unselectedElement.name,
               (unselectedElement.selectedIndex != -1));
}
function enableButton(buttonName,enable) {
  var img = document.images[buttonName]; 
  if (img == null) return; 
  var src = img.src; 
  var und = src.lastIndexOf("_disabled.gif"); 
  if (und != -1) { 
    if (enable) img.src = src.substring(0,und)+".gif"; 
  } else { 
    if (!enable) {
      var gif = src.lastIndexOf("_clicked.gif"); 
      if (gif == -1) gif = src.lastIndexOf(".gif"); 
      img.src = src.substring(0,gif)+"_disabled.gif";
    }
  }
}
function pushButton(buttonName,push) {
  var img = document.images[buttonName]; 
  if (img == null) return; 
  var src = img.src; 
  var und = src.lastIndexOf("_disabled.gif"); 
  if (und != -1) return false; 
  und = src.lastIndexOf("_clicked.gif"); 
  if (und == -1) { 
    var gif = src.lastIndexOf(".gif");
    if (push) img.src = src.substring(0,gif)+"_clicked.gif"; 
  } else { 
      if (!push) img.src = src.substring(0,und)+".gif"; 
  }
}

function selectStartMonth(sName)
{
	sMonth = PopPage("/Common/ToolsA/SelectMonth.jsp?rand="+randomNumber(),"","dialogWidth=16;dialogHeight=11;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no");
	if(typeof(sMonth)!="undefined"&&sMonth.lengh!=0)
	{
		document.customize.elements(sName).value=sMonth;
	}
	startTime=sMonth;
}
			
function selectEndMonth(sName)
{
	sMonth = PopPage("/Common/ToolsA/SelectMonth.jsp?rand="+randomNumber(),"","dialogWidth=16;dialogHeight=11;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no");
	if(typeof(sMonth)!="undefined"&&sMonth.lengh!=0)
	{
		document.customize.elements(sName).value=sMonth;
	}
	endTime=sMonth;
}

function doQuery(){
	text="";
	value="";
	date="";
	count=0;
	fiDate="<%=fiDate%>";
	leng=<%=fiDateLength%>;
	exist=false;
	for (i=0; i < customize.chosen_column_selection.length; i++){
		id = count = i+1;
		if (i==0){
			value= "'"+customize.chosen_column_selection.options[i].value+"'";
		}else{
			value= value+",'"+customize.chosen_column_selection.options[i].value+"'";
		}
	}
    	document.customize.Items.value=value;
	for(i=0;i<leng;i++){
		date=fiDate.substring(i*7,(i+1)*7);
		if((date>=startTime)&&(date<=endTime)){exist=true;continue;}
	}	
    	if(count==0) alert("请先选择财务科目!");
	else if(exist) document.customize.submit();
	else alert("所选期限内无财务报表!");
}


function doDefault(){
	customize.chosen_column_selection.length = 0;
	customize.available_column_selection.options.length = 0;
	
	j=0;
	for (i = 0; i < availableNameList.length; i++)
	{
		eval("customize.chosen_column_selection.options[" + (j) + "] = new Option(availableCaptionList[" + i + "], availableNameList[" + i + "])");
		j=j+1;
	}
	
	j=0;
	for (i = 0; i < selectedNameList.length; i++)
	{
		eval("customize.available_column_selection.options[" + (j) + "] = new Option(selectedCaptionList[" + i + "], selectedNameList[" + i + "])");
		j=j+1;
	}
	
}

doDefault();
</script>

<script type="text/javascript">
	/*~[Describe=结构分析;InputParam=客户代码;OutPutParam=无;]~*/
	function structureInfo()
	{
		//返回值，报表的期数、报表的年月、报表范围
		sReturnValue = PopPage("/CustomerManage/FinanceAnalyse/AnalyseTerm.jsp?CustomerID=<%=sCustomerID%>","","width=160,height=20,left=20,top=20,status=yes,center=yes ");
		if(typeof(sReturnValue)=="undefined" || sReturnValue=="_none_")
		return;
		PopPage("/CustomerManage/FinanceAnalyse/StructureView.jsp?CustomerID=<%=sCustomerID%>&Term=" + sReturnValue + "","width=480,height=400,left=180,top=150,status=yes,center=yes ");
	}
	
	/*~[Describe=指标分析;InputParam=客户代码;OutPutParam=无;]~*/
	function itemInfo()
	{
		//返回值，报表的期数、报表的年月、报表范围
		sReturnValue = PopPage("/CustomerManage/FinanceAnalyse/AnalyseTerm.jsp?CustomerID=<%=sCustomerID%>","","width=200,height=20,left=20,top=20,status=yes,center=yes ");
		if(typeof(sReturnValue)=="undefined" || sReturnValue=="_none_")
		 return;
		PopPage("/CustomerManage/FinanceAnalyse/ItemView.jsp?CustomerID=<%=sCustomerID%>&Term="+sReturnValue+"","_blank","");
	}
	
	/*~[Describe=趋势分析;InputParam=客户代码;OutPutParam=无;]~*/
	function trendInfo()
	{
		//返回值，报表的期数、报表的年月、报表范围
		sReturnValue = PopPage("/CustomerManage/FinanceAnalyse/AnalyseTerm_Trend.jsp?CustomerID=<%=sCustomerID%>","","width=200,height=20,left=20,top=20,status=yes,center=yes ");
		
		if(typeof(sReturnValue)=="undefined" || sReturnValue=="_none_")
			return;
		PopPage("/CustomerManage/FinanceAnalyse/TrendView.jsp?CustomerID=<%=sCustomerID%>&Term=" + sReturnValue + "","_blank","");
	}
	
	function indAnaInfo()
	{
	
	}
	
	function cashFlowInfo()
	{
		OpenComp("CashFlowList","/CustomerManage/FinanceAnalyse/CashFlowList.jsp","ComponentName=现金流预测&CustomerID=<%=sCustomerID%>","right");
	}
</script>	


<%@ include file="/IncludeEnd.jsp"%>