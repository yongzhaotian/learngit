<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author: 
		Tester:
		Describe: ���ſͻ��϶������;
		Input Param:
			CustomerID����ǰ�ͻ����
		Output Param:
			

		HistoryLog:
	 */
	%>
<%/*~END~*/%>



<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "���ų�Ա�б�"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
	ASResultSet rs = null;
	String sSql = "";
	String sCustomerName="",sOtherCustomerID="";
	String sReportData = "",sManageUser="",sManageUser2="",sRegionName="",s1="",sAttribute2="";
	String sGroupNo="",sSimpleName="",sEnterpriseName="",sManageOrg="",sManageOrg2="";
	//���ҳ�����
	//����������
	sGroupNo  = DataConvert.toRealString(iPostChange,(String)request.getParameter("CustomerID"));
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%
	sSql =      " select CustomerName,Describe "+
	            " from CUSTOMER_RELATIVE"+
    	        " where  RelativeID = :RelativeID ";
	rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("RelativeID",sGroupNo));
	if(rs.next()){
		sCustomerName=rs.getString("CustomerName");
		if(sCustomerName==null)sCustomerName="";
		sAttribute2=rs.getString("Describe");
		if(sAttribute2==null)sAttribute2="";
	}
	rs.getStatement().close(); 
	
	if(sAttribute2.equals("1")){
	    s1="һ�༯�ſͻ�";
	}else{
	    s1="���༯�ſͻ�";
	}
%>
<%/*~END~*/%>
<HEAD>
	<title>���ſͻ��϶������</title>
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
	<input type="button" value="����Word" onClick="exportToWord();" style="padding-top:3;padding-left:5;padding-right:5;background-image:url(/money/Resources/functionbg.gif); border: #DEDFCE;  border-style: outset; border-top-width: 1px; border-right-width: 1px;  border-bottom-width: 1px; border-left-width: 1px" border='1'>
	<input type="button" value="��ӡԤ��" onClick="my_printPreview()" style="padding-top:3;padding-left:5;padding-right:5;background-image:url(/money/Resources/functionbg.gif); border: #DEDFCE;  border-style: outset; border-top-width: 1px; border-right-width: 1px;  border-bottom-width: 1px; border-left-width: 1px" border='1'>
	<input type="button" value="��ӡ" onClick="spreadsheetPrint()" style="padding-top:3;padding-left:5;padding-right:5;background-image:url(/money/Resources/functionbg.gif); border: #DEDFCE;  border-style: outset; border-top-width: 1px; border-right-width: 1px;  border-bottom-width: 1px; border-left-width: 1px" border='1'>
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
    sReportData = sReportData + "					<table width=640 border=0 cellspacing=0 cellpadding=0 bgcolor=#FFFFFF>";
    sReportData = sReportData + "						<tr>";
    sReportData = sReportData + "						    <td align=center  height=60px>";
    sReportData = sReportData + "<font style=font-size: 18pt;FONT-FAMILY:'����';FONT-WEIGHT: bold;color:black;background-color:#FFFFFF><B>���ſͻ��϶������</B></font>";
    sReportData = sReportData + "						    </td>";
    sReportData = sReportData + "						</tr>";
    sReportData = sReportData + "						<tr>";
    sReportData = sReportData + "<td><br><br>&nbsp;&nbsp;&nbsp;&nbsp;���Ҳ��϶������¿ͻ�Ϊ&nbsp;<B>"+s1+"</B>:<br><br></td>";
    sReportData = sReportData + "						  </tr>";
    sReportData = sReportData + "				 	</table>";
    sReportData = sReportData + "				 	<table class=table1 width=640  border=1 cellspacing=0 cellpadding=0 ";
    sReportData = sReportData + "						bgcolor=white bordercolor=black bordercolordark=black >";
    
	
    StringBuffer temp=new StringBuffer();	
	
	sSql = 	" select EI.EnglishName,EI.EnterpriseName,getOrgName(CB.OrgID) as ManageOrg,"+
	        " getUserName(CB.UserID) as ManageUser,getItemName('AreaCode',EI.RegionCode) as RegionName from ENT_INFO EI, CUSTOMER_BELONG CB"+
			" where EI.CustomerID = CB.CustomerID and EI.CustomerID=:CustomerID";
	rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("CustomerID",sGroupNo));
	if(rs.next()){
		sSimpleName = rs.getString("EnglishName");
		sEnterpriseName = rs.getString("EnterpriseName");
		sManageOrg = rs.getString("ManageOrg");
		sManageUser = rs.getString("ManageUser");
		sRegionName = rs.getString("RegionName");
		if(sSimpleName == null) sSimpleName="";
		if(sEnterpriseName == null) sEnterpriseName="";
		if(sManageOrg == null) sManageOrg="";
		if(sManageUser== null) sManageUser="";
		if(sRegionName== null) sRegionName="";
	}
	rs.getStatement().close();		
	
	temp.append("<tr> ");
    temp.append("<td class=td1 nowrap align=middle colspan=3>������������</td>");
    temp.append("<td class=td1 colspan=3>"+sEnterpriseName+"&nbsp;</td>");
    temp.append("</tr>");
    	
    temp.append("<tr> ");
    temp.append("<td class=td1 align=middle colspan=1>�������ż��</td>");
    temp.append("<td class=td1 colspan=1>"+sSimpleName+"&nbsp;</td>");
    temp.append("<td class=td1 align=middle colspan=1>�������ܻ���</td>");
    temp.append("<td class=td1 colspan=1 align=middle>"+sManageOrg+"&nbsp;</td>");
    temp.append("<td class=td1 align=middle colspan=1>���ܿͻ�����</td>");
    temp.append("<td class=td1 colspan=1 align=middle>"+sManageUser+"&nbsp;</td>");
    temp.append("</tr>");
    
    temp.append("<tr> ");
    temp.append("<td class=td1 nowrap align=middle colspan=3>�����ܲ���ĸ��˾�����ڵ�</td>");
    temp.append("<td class=td1 colspan=3>"+sRegionName+"&nbsp;</td>");
    temp.append("</tr>");	
    
    temp.append("<tr> ");
    temp.append("<td class=td1 align=middle  colspan=9 bgcolor=#aaaaaa height='40px'><font style=\" font-size: 14pt;FONT-FAMILY:'����';FONT-WEIGHT: bold;color:black;background-color:#aaaaaa\";>��Ա��˾����</font></td>");
    temp.append("</tr>");			  

	
	
	//���ų�Ա
	temp.append("<tr> ");
    temp.append("<td class=td1 align=middle colspan=2><B>��Ա��˾����</B></td>");
    temp.append("<td class=td1 align=middle colspan=1><B>��֯��������</B></td>");
    temp.append("<td class=td1 align=middle colspan=2><B>Э�ܻ���</B></td>");
    temp.append("<td class=td1 align=middle colspan=1><B>Э�ܿͻ�����</B></td>");
    temp.append("</tr>");

    sSql =      " select CustomerName,"+
	            " CertID,"+
	            " getOrgName(InputOrgID) as ManageOrg,"+
	            " getUserName(InputUserID) as ManageUser from CUSTOMER_RELATIVE"+
    	        " where CustomerID = :CustomerID and Whethen1='0' and Describe=:Describe order by Whethen1 DESC";
	rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("CustomerID",sGroupNo).setParameter("Describe",sAttribute2));
	while(rs.next()){
		sCustomerName=rs.getString("CustomerName");
		sOtherCustomerID=rs.getString("CertID");
		sManageOrg2=rs.getString("ManageOrg");
		sManageUser2=rs.getString("ManageUser");
		
		
		if(sManageOrg2==null)sManageOrg2="&nbsp;";
		if(sCustomerName==null)sCustomerName="&nbsp;";
		if(sOtherCustomerID==null)sOtherCustomerID="&nbsp;";
		if(sManageUser2==null)sManageUser2="&nbsp;";
		
		
        
        temp.append("<tr> ");
        temp.append("<td class=td1 align=left colspan=2>"+sCustomerName+"&nbsp;</td>");
        temp.append("<td class=td1 align=left colspan=1>"+sOtherCustomerID+"&nbsp;</td>");
        temp.append("<td class=td1 align=left colspan=2>"+sManageOrg2+"&nbsp;</td>");
        temp.append("<td class=td1 align=left colspan=1>"+sManageUser2+"&nbsp;</td>");
        temp.append("</tr>");
		
	}
	rs.getStatement().close(); 
					  
        
    temp.append("<tr> ");
    temp.append("<td class=td1  colspan=8 height='30px' align=right><br><br><br><B>�϶��ˣ�&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</B><br><br><br><B>���ڣ�&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</B><br><br><br></td>");
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
<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
<script type="text/javascript">
/*~[Describe=����Word;InputParam=��;OutPutParam=��;]~*/
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
/*~[Describe=����Word;InputParam=��;OutPutParam=��;]~*/
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
/*~[Describe=��ӡ;InputParam=��;OutPutParam=��;]~*/
function spreadsheetPrint()
{ 
����if (confirm("ȷ����ӡ��")) { 
����var tmp1 = document.my_div.outerHTML;
	document.my_div.outerHTML="<form name=my_div font-size:9pt;></form>";
	WebBrowser.ExecWB(6,1);
	document.my_div.outerHTML=tmp1;

����} 
} 
/*~[Describe=Ԥ��Word;InputParam=��;OutPutParam=��;]~*/
function my_printPreview(){
var tmp = document.my_div.outerHTML;
document.my_div.outerHTML='<form name=my_div font-size:9pt;></form>';
WebBrowser.ExecWB(7,1);
document.my_div.outerHTML=tmp;
}
</SCRIPT>
<%/*~END~*/%>
<%@ include file="/IncludeEnd.jsp"%>