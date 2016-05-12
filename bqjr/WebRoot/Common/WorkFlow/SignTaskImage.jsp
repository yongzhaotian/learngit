<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>
<% 
	//获得页面参数
	String sObjectNo = DataConvert.toRealString(iPostChange,CurComp.getParameter("ObjectNo"));
	//获取客户编 客户姓名与身份证号 客户编@客户姓名@身份证号
	String sCustomerNameCertId = Sqlca.getString("select bc.customerid ||'@'|| nvl(bc.customername,'')||'@'||nvl(bc.certid,'') from business_contract bc  where bc.serialno='"+sObjectNo+"'");
	//客户编号
	String sCustomerID = sCustomerNameCertId.split("@")[0];
	String sCustomerName = sCustomerNameCertId.split("@")[1];
	String sCustomerCertId = sCustomerNameCertId.split("@")[2];
	String wzPath = "";
	String xcpath = Sqlca.getString("select  documentId  from  ECM_PAGE where objectType='Business' and objectNo='"+sObjectNo+"' and typeNo='20002' and documentId is not null order by pageNum");
	String sfPath = Sqlca.getString("select  documentId  from  ECM_PAGE where objectType='Business' and objectNo='"+sObjectNo+"' and typeNo='20001' and documentId is not null order by pageNum");
	
	// 银行卡背面照片   20151208_CCS-1016（PRM-559安硕系统查看照片选项增加内容）
	String sBankCardBgPath = Sqlca.getString("select  documentId  from  ECM_PAGE where objectType='Business' and objectNo='"+sObjectNo+"' and typeNo='20026' and documentId is not null order by modifytime desc");
	
	// ID5照片
	String sId5Path = Sqlca.getString(new SqlObject("SELECT CHECKPHOTO FROM ID5_XML_ELE_VAL WHERE CUSTOMERID=:CUSTOMERID AND REQHEADER='1A020201'").setParameter("CUSTOMERID", sCustomerID));
	String sql ="select serialno from business_contract where customerid  = '"+sCustomerID+"' order by serialno desc ";
	ASResultSet result = Sqlca.getResultSet(sql);
	boolean isCurrentlyContract  = false;
	//获取前一笔申请流水号
	String sFistObjectno=null;
	//获取前第二笔流水号
	String sSendObjectNo=null;
	//获取前第三笔流水号
	String sThodObjectNo= null;
	while(result.next()){
		String serialno = result.getString("serialno");
		if(serialno ==null ) continue;
		if(serialno.equals(sObjectNo)){//取得的合同是不是当前合同
			isCurrentlyContract  = true; 
			continue;
		}
		if(isCurrentlyContract==false) continue;//如果不是，继续找下条
		sFistObjectno = serialno; //当前合同前一合同
	   if(result.next()){//前2个合同
		   sSendObjectNo = result.getString("serialno");
	   }
	   if(result.next()){//前三个合同
		   sThodObjectNo = result.getString("serialno");
	   }
	   break;
	}
	result.getStatement().close();
	//前第一笔照片地址
	String sFistPath = null;
	if(sFistObjectno!=null){
		sFistPath = Sqlca.getString("select  documentId  from  ECM_PAGE where objectType='Business' and objectNo='"+sFistObjectno+"' and typeNo='20002' and documentId is not null order by pageNum");
	}
	//前第二笔照片地址
	String sSendPath  = null;
	if(sSendObjectNo != null){
		sSendPath = Sqlca.getString("select  documentId  from  ECM_PAGE where objectType='Business' and objectNo='"+sSendObjectNo+"' and typeNo='20002' and documentId is not null order by pageNum");
	}
	//前第三笔照片地址
	String sThodPath  = null ;
	if(sThodObjectNo != null){
		sThodPath = Sqlca.getString("select  documentId  from  ECM_PAGE where objectType='Business' and objectNo='"+sThodObjectNo+"' and typeNo='20002' and documentId is not null order by pageNum");
	}
	//移动pos点的背景图片地址
	String sPno = Sqlca.getString("select PosNo from Business_Contract where serialNo = '"+sObjectNo+"'");
	if(sPno == null) sPno = ""; 
	String sPosPath = Sqlca.getString("select Fullpath from doc_attachment where type='A0002' and objectno=(select serialNo from MOBILEPOS_INFO where MOBLIEPOSNO = '"+sPno+"')");
	if(sPosPath == null) sPosPath = ""; 
	
//	String path = request.getContextPath(); 
//	String requestpath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
	String requestpath = sWebRootPath+"/servlet/ImageServlet?ImageId=";
	String id5PhotoPath = requestpath + sId5Path;
	String nxcpath = requestpath+xcpath;
	String nsfPath = requestpath+sfPath;
	String nsFistPath = requestpath+sFistPath;
	String nsSendPath = requestpath+sSendPath;
	String nsThodPath = requestpath+sThodPath;
    String nsPosPath = requestpath+sPosPath;
    
 // 银行卡背面照片   20151208_CCS-1016（PRM-559安硕系统查看照片选项增加内容）
    String nsBankCardBgPath = requestpath + sBankCardBgPath;
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=GBK">
<title></title>
<script type="text/javascript" src="Frame/resources/js/js/jquery-1.7.2.min.js"></script>
<script type="text/javascript" src="Frame/resources/js/js/artZoom.js"></script>
<script type="text/javascript">jQuery('a.artZoom').artZoom();</script>
<style type="text/css">
.divcss5{ border:1px solid #F00; width:420px; height:310px}
img { border:0 none; width: 420px; height: 310px;}
#idContainer{border:1px solid 0000;width:420px; height:310px; background:#FFF center no-repeat;}

</style>

<!-- 添加图片放大缩小功能 -->
<script type="text/javascript">

	var zoom = 1.2; // 缩放率
    function big(img){
		var img =  document.getElementById(img);
		var width = img.scrollWidth;
		var height = img.scrollHeight;
		img.style.width=parseInt(width)*zoom+"px";
		img.style.height=parseInt(height)*zoom+"px";
    }
    function small(img){
		var img =  document.getElementById(img);
		var width = img.scrollWidth;
		var height = img.scrollHeight;
		img.style.width=parseInt(width)/zoom+"px";
		img.style.height=parseInt(height)/zoom+"px";
    }
	var num = 0; 
	function change(img){ 
		num = (num + 1) % 4; 
		document.getElementById(img).style.filter = 'progid:DXImageTransform.Microsoft.BasicImage(rotation='+num+')'; 
	}
</script>

</head>
<body>

<div align="right" style="margin-top:5px;margin-right:5px;"><b>姓名:<%=sCustomerName%>&nbsp;&nbsp;身份证号码:<%=sCustomerCertId%></b></div>

<table>
<tr>
<td align="center" >
	<% 
	if (id5PhotoPath == null || id5PhotoPath == ""){
		%><font face="字体名称" size="字体大小"  color="red"><b>身份证网站查询照片不存在</b></font><%
	}else{
		%>
		<input type="button" value='放大' onclick="javascript:big('id5page')"/>
			<input type="button" value='缩小' onclick="javascript:small('id5page')"/>
			<input type="button" value='旋转' onclick="javascript:change('id5page')"/> <br>
		<a class="miniImg artZoom"  rel="<%=id5PhotoPath%>"><img id="id5page" src="<%=id5PhotoPath%>"  alt="1" ><br></a>
		<font face="字体名称" size="字体大小"  color="字体颜色"><b>身份证网站查询照片</b></font>
		<%
	}
	%>
</td>
<td align="center" >
	<% 
	if (xcpath == null || xcpath == ""){
		%><font face="字体名称" size="字体大小"  color="red"><b>现场照片不存在</b></font><%
	}else{
		%>
		<input type="button" value='放大' onclick="javascript:big('xcpage')"/>
			<input type="button" value='缩小' onclick="javascript:small('xcpage')"/>
			<input type="button" value='旋转' onclick="javascript:change('xcpage')"/> <br>
		<a class="miniImg artZoom"  rel="<%=nxcpath%>"><img id="xcpage" src="<%=nxcpath%>" onmousewheel="MW(this)"  /></a>
		<br/>
		<font face="字体名称" size="字体大小"  color="字体颜色"><b>现场照片</b></font>
		<%
	}
	%>
</td>
<td align="center" >
	<% 
	if (sfPath == null || sfPath == ""){
		%><font face="字体名称" size="字体大小"  color="red"><b>身份证照片不存在</b></font><%
	}else{
		%>
		
		<input type="button" value='放大' onclick="javascript:big('focusphoto')"/>
			<input type="button" value='缩小' onclick="javascript:small('focusphoto')"/>
			<input type="button" value='旋转' onclick="javascript:change('focusphoto')"/> <br>
		<a class="miniImg artZoom"  rel="<%=nsfPath%>"><img id="focusphoto" src="<%=nsfPath%>" onmousewheel="MW(this)"  /></a>
		<br>
		<font face="字体名称" size="字体大小"  color="字体颜色"><b>身份证照片</b></font>
		<%
	}
	%>
</td>
</tr>
<tr>
<td align="center" >
	<% 
	if (sFistPath == null || sFistPath == ""){
		%><font face="字体名称" size="字体大小"  color="red"><b>前一张申请现场照片不存在</b></font><%
	}else{
		%>
		<a class="miniImg artZoom"  rel="<%=nsFistPath%>"><img id="focusphoto" src="<%=nsFistPath%>" onmousewheel="MW(this)"  /></a>
		<font face="字体名称" size="字体大小"  color="字体颜色"><b>前一张申请现场照片</b></font>
		<%
	}
	%>
</td>
<td align="center" >
	<% 
	if (sSendPath == null || sSendPath == ""){
		%><font face="字体名称" size="字体大小"  color="red"><b>前二张申请现场照片不存在</b></font><%
	}else{
		%>
		<a class="miniImg artZoom"  rel="<%=nsSendPath%>"><img id="focusphoto" src="<%=nsSendPath%>" onmousewheel="MW(this)"  /></a>
		<font face="字体名称" size="字体大小"  color="字体颜色"><b>前二张申请现场照片</b></font>
		<%
	}
	%>
</td>
<td align="center" >
	<% 
	if (sThodPath == null || sThodPath == ""){
		%><font face="字体名称" size="字体大小"  color="red"><b>前三张申请现场照片不存在</b></font><%
	}else{
		%>
		<a class="miniImg artZoom"  rel="<%=nsThodPath%>"><img src="<%=nsThodPath%>" alt="6"  /><br></a>
		<font face="字体名称" size="字体大小"  color="字体颜色"><b>前三张申请现场照片</b></font>
		<%
	}
	%>
</td>
</tr>
<tr>
<td align="center" >
	<% 
	if (sPosPath == null || sPosPath == ""){
		%><font face="字体名称" size="字体大小"  color="red"><b>移动POS点申请背景照片不存在</b></font><%
	}else{
		%>
		<a class="miniImg artZoom"  rel="<%=nsPosPath%>"><img src="<%=nsPosPath%>" alt="7"  onmousewheel="MW(this)" /><br></a>
		<font face="字体名称" size="字体大小"  color="字体颜色"><b>移动POS点申请背景照片</b></font>
		<%
	}
	%>
</td>
<td align="center" >
	<% // 银行卡背面照片   20151208_CCS-1016（PRM-559安硕系统查看照片选项增加内容）
	if (sBankCardBgPath == null || "".equals(sBankCardBgPath)){
		%><font face="字体名称" size="字体大小"  color="red"><b>银行卡背面照片不存在</b></font><%
	}else{
		%>
		<a class="miniImg artZoom"  rel="<%=nsBankCardBgPath%>"><img src="<%=nsBankCardBgPath%>" alt="银行卡背面照片"  onmousewheel="MW(this)" /><br/></a>
		<font face="字体名称" size="字体大小"  color="字体颜色"><b>银行卡背面照片</b></font>
		<%
	}
	%>
</td>
<td align="center" ></td>
</tr>
</table>

</body>
</html>
<%@ include file="/IncludeEnd.jsp"%>