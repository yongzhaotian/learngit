<%@page import="com.amarsoft.are.util.*"%> 
<%@page import="com.amarsoft.awe.Configure"%>
<%@page import="com.amarsoft.awe.RuntimeContext"%>
<%@page contentType="text/html; charset=GBK"%>
<%@page buffer="64kb" errorPage="/Frame/page/control/ErrorPage.jsp"%>
<%
	RuntimeContext CurARC = (RuntimeContext)session.getAttribute("CurARC");
	if(CurARC == null) throw new Exception("------Timeout------");

	Configure CurConfig = Configure.getInstance(application);
	int iPostChange = Integer.valueOf(CurConfig.getConfigure("PostChange")).intValue();

	//传过来的参数:fieldname,defaultvalue,codelist	
	String sDefault = DataConvert.toRealString(iPostChange,(String)request.getParameter("defaultvalue"));
	String sSelect = DataConvert.toRealString(iPostChange,(String)request.getParameter("codelist"));
	
	sSelect = StringFunction.replace(sSelect,"ssppaaccee"," ");
	String[] sss=StringFunction.toStringArray(sSelect,"@");
%>
<head>
	<title>请选择...</title>
	<META http-equiv=Content-Type content="text/html; charset=GBK">
</head>
<body onunload="doUnload()" >
<div align=center>
<br>请选择：<br><br>
<select id=curselect size='10'  style='width:100%;' width='100%' >
<%
	int iLen=sss.length,k;
	String sSelected="";
	for(k=0;k<iLen;k+=2){
		if(sss[k].equals(sDefault)) sSelected="selected";
		else                        sSelected="";
%>
		<option value='<%=sss[k]%>' <%=sSelected%> ><%=sss[k+1]%></option>
<%		
	}
%>
</select>
<br><br>
<input type=button name=btnOk value="选定"     onclick="javascipt:doOk();" >
<input type=button name=btnCancel value="取消" onclick="javascipt:doCancel();" >
</div>
</body>

<script type="text/javascript">
bNormal=false;
function doOk(){
	self.returnValue=curselect.value;
	bNormal=true;
	window.close();
}
function doCancel(){
	self.returnValue="_none_";
	bNormal=true;
	window.close();
}
function doUnload(){
	if(!bNormal){
		self.returnValue="_none_";		
	}
}
</script>