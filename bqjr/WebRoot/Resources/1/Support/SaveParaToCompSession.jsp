<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>

<html>
<head>
<title>jsp composer tester</title>
</head>

<body leftmargin="10" topmargin="10" class="windowbackground" style="overflow:auto;overflow-x:visible;overflow-y:visible">

<%
	String sTempPostAction = (String)DataConvert.toRealString(iPostChange,CurPage.getParameter("TempPostAction"));
	String sTempParaString = (String)DataConvert.toRealString(iPostChange,CurPage.getParameter("TempParaString"));
	String sParas[][];
	int iParas = 0;
	if(sTempParaString!=null && !sTempParaString.equals(""))
	{
		sTempParaString = SpecialTools.amarsoft2Real(sTempParaString);
		iParas = StringFunction.getSeparateSum(sTempParaString,"&");
		if(sTempParaString.substring(0,1).equals("&")) iParas--;
		sParas = new String[iParas][2];
		for(int i=0;i<sParas.length;i++){
			String sSeg = StringFunction.getSeparate(sTempParaString,"&",i+1);
			sParas[i][0] = sSeg.substring(0,sSeg.indexOf("=")).trim();
			sParas[i][1] = sSeg.substring(sSeg.indexOf("=")+1).trim();
			CurCompSession.setAttribute(sParas[i][0],sParas[i][1]);
		}
	}
%>
<script type="text/javascript">
sPostAction = amarsoft2Real("<%=sTempPostAction%>");
try{
	parent.eval(sPostAction);
}catch(e){
	alert("错误："+e.name+" "+e.number+" :"+e.message+"\n\n后续动作定义错误:"+sPostAction+"\n\n示例1：\n\n as_save(\"myiframe0\",\"location.reload();\") \n\n示例2：\n\n as_save(\"myiframe0\",\"alert('abc');\")");
}
</script>

</body>
</html>
<%@ include file="/IncludeEnd.jsp"%>