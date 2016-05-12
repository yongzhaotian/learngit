<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author: 
		Tester:
		Describe: 集团客户认定意见表;
		Input Param:
			CustomerID：当前客户编号
		Output Param:
			

		HistoryLog:
	 */
	%>
<%/*~END~*/%>



<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "集团成员列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量
	ASResultSet rs = null;
	String sSql="";
	String sReportData = "";
	String sCustomerName="",sAggregateNo="",sAttribute2="";
	//获得页面参数
	//获得组件参数
	String sCustomerID 	= DataConvert.toRealString(iPostChange,(String)request.getParameter("CustomerID"));
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%
	sSql =      " select CustomerID,CustomerName,Describe "+
	            " from CUSTOMER_RELATIVE"+
    	        " where  RelativeID = :RelativeID ";
	rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("RelativeID",sCustomerID));
	if(rs.next()){
		sCustomerName=rs.getString("CustomerName");
		if(sCustomerName==null)sCustomerName="";
		sAggregateNo=rs.getString("CustomerID");
		if(sAggregateNo==null)sAggregateNo="";
		sAttribute2=rs.getString("Describe");
		if(sAttribute2==null)sAttribute2="";
	}
	rs.getStatement().close(); 
%>
<%/*~END~*/%>
<HEAD>
	<title>集团客户认定申请书</title>
</HEAD>
<%

    sReportData = sReportData + "	<STYLE>";
    sReportData = sReportData + "	.table1{border: solid; border-width: 1px 1px 2px 2px; border-color: #000000 black #000000 #000000;} ";
    sReportData = sReportData + "	.table2{border: solid; border-width: 0px 1px 2px 2px; border-color: #000000 black #000000 #000000;} ";
    sReportData = sReportData + "	.table3{border: solid; border-width: 1px 1px 0px 2px; border-color: #000000 black #000000 #000000;}";
    sReportData = sReportData + "	.td1{border-color: #000000 #000000 black black; height:25px;border-style: solid; border-top-width: 1px; border-right-width: 1px; border-bottom-width: 0px; border-left-width: 0px;font-size: 10pt; color: #000000}";
    sReportData = sReportData + "	</STYLE>	";
    sReportData = sReportData + "<body class=ReportPage leftmargin=0 topmargin=0  style=overflow-x:scroll;overflow-y:scroll >";
    %>
	<form name=my_div font-size:9pt;>
	<input type="button" value="导入Word" onClick="exportToWord();" style="padding-top:3;padding-left:5;padding-right:5;background-image:url(/money/Resources/functionbg.gif); border: #DEDFCE;  border-style: outset; border-top-width: 1px; border-right-width: 1px;  border-bottom-width: 1px; border-left-width: 1px" border='1'>
	<input type="button" value="打印预览" onClick="my_printPreview()" style="padding-top:3;padding-left:5;padding-right:5;background-image:url(/money/Resources/functionbg.gif); border: #DEDFCE;  border-style: outset; border-top-width: 1px; border-right-width: 1px;  border-bottom-width: 1px; border-left-width: 1px" border='1'>
	<input type="button" value="打印" onClick="spreadsheetPrint()" style="padding-top:3;padding-left:5;padding-right:5;background-image:url(/money/Resources/functionbg.gif); border: #DEDFCE;  border-style: outset; border-top-width: 1px; border-right-width: 1px;  border-bottom-width: 1px; border-left-width: 1px" border='1'>
	</form>
	<%
    sReportData = sReportData + "<table align='center' cellspacing=0 cellpadding=0 width='100%' style='display=none;'>";
    sReportData = sReportData + "	<tr>";
    sReportData = sReportData + "		<td height=30 valign='middle' style='BORDER-bottom: #000000 0px solid;'></td>";
    sReportData = sReportData + "	</tr>";
    sReportData = sReportData + "</table>";
    sReportData = sReportData + "<table border=0 width=100% height=100% cellspacing=0 cellpadding=0 >";
    sReportData = sReportData + "	<tr id=DetailTitle class=DetailTitle >";
    sReportData = sReportData + "	    <td colspan=2>";
    sReportData = sReportData + "	    </td>";
    sReportData = sReportData + "	</tr>";
    sReportData = sReportData + "	<tr height=1 valign=top id=buttonback >";
    sReportData = sReportData + "		<td colspan=2>";
    sReportData = sReportData + "			<table>";
    sReportData = sReportData + "	    	</table>";
    sReportData = sReportData + "		</td>";
    sReportData = sReportData + "	</tr>";
    sReportData = sReportData + "	<tr height=1 >";
    sReportData = sReportData + "	    <td colspan=2>&nbsp;</td>";
    sReportData = sReportData + "	</tr>	";
    sReportData = sReportData + "	<tr valign=top >";
    sReportData = sReportData + "		 <td>&nbsp;</td>";
    sReportData = sReportData + "	    <td style='BORDER-bottom: #000000 1px solid;' > ";
    sReportData = sReportData + "	    	   <div id=reporttable>";
    sReportData = sReportData + "					<table width=640 border=0 cellspacing=0 cellpadding=0 bgcolor=#FFFFFF> ";
    sReportData = sReportData + "						<tr>";
    sReportData = sReportData + "						    <td align=center  height=60px>";
    sReportData = sReportData + "<font style=font-size: 18pt;FONT-FAMILY:'宋体';FONT-WEIGHT: bold;color:black;background-color:#FFFFFF><B>一类集团客户认定申请书</B></font>";
    sReportData = sReportData + "						    </td>";
    sReportData = sReportData + "						</tr>";
    sReportData = sReportData + "						<tr>";
    sReportData = sReportData + "<td>___________________________:<br><br>&nbsp;&nbsp;&nbsp;&nbsp;我行/部在对&nbsp;&nbsp;<B>"+sCustomerName+"</B>&nbsp;&nbsp;进行授信前期调查时，根据收集到的信息，确定该客户具有集团关系特征。现按照《法人客户信贷政策手册》的规定，特向贵部上报此名单，请认定是否按照集团客户进行授信管理。<br><br></td>";
    sReportData = sReportData + "						  </tr>";
    sReportData = sReportData + "				 	</table>";
    sReportData = sReportData + "				 	<table class=table1 width=640  border=1 cellspacing=0 cellpadding=0 ";
    sReportData = sReportData + "						bgcolor=white bordercolor=black bordercolordark=black >";
    
	
    StringBuffer temp=new StringBuffer();	
	
	temp.append("<tr> ");
    temp.append("<td class=td1 nowrap align=middle colspan=1>集团名称</td>");
    temp.append("<td class=td1 colspan=5>&nbsp;</td>");
    temp.append("</tr>");
    	
    temp.append("<tr> ");
    temp.append("<td class=td1 align=middle colspan=1>集团简称</td>");
    temp.append("<td class=td1 colspan=2>&nbsp;</td>");
    temp.append("<td class=td1 align=left colspan=1>集团总部（母公司）所在地</td>");
    temp.append("<td class=td1 colspan=2>&nbsp;</td>");
    temp.append("</tr>");	
    
    temp.append("<tr> ");
    temp.append("<td class=td1 align=middle  colspan=9 bgcolor=#aaaaaa height='40px'><font style=\" font-size: 14pt;FONT-FAMILY:'宋体';FONT-WEIGHT: bold;color:black;background-color:#aaaaaa\";>成员公司名单</font></td>");
    temp.append("</tr>");			  

	String sCustomerName2="",sOtherCustomerID="",sMemberDescribleName="";
	String sCorporationName="",sIsBusiness="",sManageOrg="";
	
	//集团成员
	temp.append("<tr> ");
    temp.append("<td class=td1 align=middle colspan=1><B>成员公司名称</B></td>");
    temp.append("<td class=td1 align=middle colspan=1><B>组织机构代码</B></td>");
    temp.append("<td class=td1 align=middle colspan=1><B>法定代表人</B></td>");
    temp.append("<td class=td1 align=middle colspan=1><B>与借款人关系</B></td>");
    temp.append("<td class=td1 align=middle colspan=1><B>是否存在授信申请或未结清业务(不含低风险业务)</B></td>");
    temp.append("<td class=td1 align=middle colspan=1><B>管户机构</B></td>");
    temp.append("</tr>");
	/*sSql =      " select getCustomerName(CustomerID) as CustomerName,"+
	            " GETOTHERCUSTOMERID(CustomerID) as OtherCustomerID, "+
	            " GETCORPORATIONNAME(CustomerID) as CorporationName,"+
	            " GetItemName('RelativeType',MemberDescrible) as MemberDescribleName,"+
	            " getAMCreditInfo(customerid) as IsBusiness,"+
	            " getManageOrgName(CustomerID) as ManageOrg from AGGREGATE_MEMBER"+
    	        " where  AggregateNo='"+sAggregateNo+"' and Attribute1='0'  and Attribute2='"+sAttribute2+"' order by MemberDescrible";
    */

    sSql = " select EI.EnterpriseName as CustomerName,"+
	       " EI.CorpID as OtherCustomerID,"+
	       " FictitiousPerson as CorporationName,"+
	       " getItemName('RelativeType',A.RelativeType) as MemberDescribleName,"+
	       " getItemName('YesNo','2') as IsBusiness,"+
		   " getOrgName(CB.OrgID) as ManageOrg "+
		   " from AGGREGATE_SEARCH A,ENT_INFO EI,CUSTOMER_BELONG CB "+
		   " where  "+
		   "  A.RelativeID=EI.CustomerID and EI.CustomerID = CB.CustomerID and A.CustomerID=:CustomerID "+
		   " order by A.RelativeType ";
	rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("CustomerID",sCustomerID));
	while(rs.next()){
		sCustomerName2=rs.getString("CustomerName");
		sOtherCustomerID=rs.getString("OtherCustomerID");
		sCorporationName=rs.getString("CorporationName");
		sMemberDescribleName=rs.getString("MemberDescribleName");
		sIsBusiness=rs.getString("IsBusiness");
		sManageOrg=rs.getString("ManageOrg");
		
		if(sManageOrg==null)sManageOrg="&nbsp;";
		if(sCustomerName2==null)sCustomerName2="&nbsp;";
		if(sOtherCustomerID==null)sOtherCustomerID="&nbsp;";
		if(sCorporationName==null)sCorporationName="&nbsp;";
		if(sMemberDescribleName==null)sMemberDescribleName="&nbsp;";
		if(sMemberDescribleName.equals("源公司自身")) sMemberDescribleName="借款人自身";
		if(sIsBusiness==null)sIsBusiness="&nbsp;";
		
		
        
        temp.append("<tr> ");
        temp.append("<td class=td1 align=left colspan=1>"+sCustomerName2+"&nbsp;</td>");
        temp.append("<td class=td1 align=left colspan=1>"+sOtherCustomerID+"&nbsp;</td>");
        temp.append("<td class=td1 align=left colspan=1>"+sCorporationName+"&nbsp;</td>");
        temp.append("<td class=td1 align=left colspan=1>"+sMemberDescribleName+"&nbsp;</td>");
        temp.append("<td class=td1 align=left colspan=1>"+sIsBusiness+"&nbsp;</td>");
        temp.append("<td class=td1 align=left colspan=1>"+sManageOrg+"&nbsp;</td>");
        temp.append("</tr>");
		
	}
	rs.getStatement().close(); 
					  
        
        temp.append("<tr> ");
        temp.append("<td class=td1  colspan=8 height='30px' align=right><br><br><br><B>填报单位：&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</B><br><br><br><B>日期：&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</B><br><br><br></td>");
        temp.append("</tr>");
    String result=temp.toString();
        
    //result = StringFunction.replace(result,"<TABLE ","<TABLE align=center ");
    //result = StringFunction.replace(result,"\\r\\n","<br>");    				    
    sReportData = sReportData + result;
    sReportData = sReportData + "</body>";
    
    sReportData = sReportData + "                    </table>";
    sReportData = sReportData + "			</div>";
    sReportData = sReportData + "		</td>";
    sReportData = sReportData + "	</tr>";
    			
    sReportData = sReportData + "</table>";
    
    
    
    //sReportData = StringFunction.replace(sReportData,"&quot;","\"");
    out.println(sReportData);

%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
<script type="text/javascript">
/*~[Describe=导入Word;InputParam=无;OutPutParam=无;]~*/
function createWord()
{
	try
	{
		var sFileName = "c:\\protocol.doc";
		var fso = new ActiveXObject("Scripting.FileSystemObject");
		var a = fso.CreateTextFile(sFileName, true);
		a.WriteLine(document.body.outerHTML);
		a.Close();	
	}
	catch(e) 
	{
		alert(e.name+" "+e.number+" :"+e.message);
	}
}
/*~[Describe=导入Word;InputParam=无;OutPutParam=无;]~*/
function exportToWord()
{
	var sFileName = "c:\\protocol.doc";
	createWord();
	OpenDoc(sFileName);
}
</script>

<SCRIPT LANGUAGE=VBScript> 
Sub OpenDoc(strLocation) 
	Dim objWord 
	Set objWord = CreateObject("Word.Application") 
	objWord.Visible = true 
	objWord.Documents.Open strLocation 
End Sub 

</SCRIPT> 
<script type="text/javascript">
document.write("<object ID='WebBrowser' WIDTH=0 HEIGHT=0 CLASSID='CLSID:8856F961-340A-11D0-A96B-00C04FD705A2'></object>"); 
/*~[Describe=打印;InputParam=无;OutPutParam=无;]~*/
function spreadsheetPrint()
{ 
　　if (confirm("确定打印吗？")) {
　　var tmp1 = document.my_div.outerHTML;
	document.my_div.outerHTML="<form name=my_div font-size:9pt;></form>";
	WebBrowser.ExecWB(6,1);
	document.my_div.outerHTML=tmp1;

　　} 
} 
/*~[Describe=预览Word;InputParam=无;OutPutParam=无;]~*/
function my_printPreview(){
var tmp = document.my_div.outerHTML;
document.my_div.outerHTML='<form name=my_div font-size:9pt;></form>';
WebBrowser.ExecWB(7,1);
document.my_div.outerHTML=tmp;
}
</SCRIPT>
<%/*~END~*/%>
<%@ include file="/IncludeEnd.jsp"%>

