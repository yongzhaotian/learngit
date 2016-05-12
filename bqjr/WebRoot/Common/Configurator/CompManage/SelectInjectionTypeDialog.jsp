<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML>
<HEAD>
<TITLE> New Document </TITLE>

</HEAD>

<BODY class="pagebackground">
<TABLE>
<TR>
	<TD></TD>
	<TD><INPUT TYPE="radio" NAME="InjectionType" value="before">之前</TD>
</TR>
<TR>
	<TD></TD>
	<TD><INPUT TYPE="radio" NAME="InjectionType" value="after" selected>之后</TD>
</TR>
<TR>
	<TD></TD>
	<TD><INPUT TYPE="radio" NAME="InjectionType" value="below">之下</TD>
</TR>
<TR>
	<TD></TD>
	<TD>
	<INPUT TYPE="button" NAME="confirm" value="确定" onclick="doConfirm()">
	<INPUT TYPE="button" NAME="cancel" value="取消" onclick="doCancel()">
	</TD>
</TR>
</TABLE>

</BODY>
</HTML>
<script type="text/javascript">

function doConfirm(){
	//alert(GetPropertiesString(InjectionType[0]));
	var checkedType = getCheckType();
	top.returnValue=checkedType;
	top.close();
}

function doCancel(){
	top.close();
}

function getCheckType(){
	for(var i=0;i<InjectionType.length;i++){
		if(InjectionType[i].checked) return InjectionType[i].value;
	}
}
</script>

<%@ include file="/IncludeEnd.jsp"%>
