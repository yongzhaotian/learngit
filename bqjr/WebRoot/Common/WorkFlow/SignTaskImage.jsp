<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>
<% 
	//���ҳ�����
	String sObjectNo = DataConvert.toRealString(iPostChange,CurComp.getParameter("ObjectNo"));
	//��ȡ�ͻ��� �ͻ����������֤�� �ͻ���@�ͻ�����@���֤��
	String sCustomerNameCertId = Sqlca.getString("select bc.customerid ||'@'|| nvl(bc.customername,'')||'@'||nvl(bc.certid,'') from business_contract bc  where bc.serialno='"+sObjectNo+"'");
	//�ͻ����
	String sCustomerID = sCustomerNameCertId.split("@")[0];
	String sCustomerName = sCustomerNameCertId.split("@")[1];
	String sCustomerCertId = sCustomerNameCertId.split("@")[2];
	String wzPath = "";
	String xcpath = Sqlca.getString("select  documentId  from  ECM_PAGE where objectType='Business' and objectNo='"+sObjectNo+"' and typeNo='20002' and documentId is not null order by pageNum");
	String sfPath = Sqlca.getString("select  documentId  from  ECM_PAGE where objectType='Business' and objectNo='"+sObjectNo+"' and typeNo='20001' and documentId is not null order by pageNum");
	
	// ���п�������Ƭ   20151208_CCS-1016��PRM-559��˶ϵͳ�鿴��Ƭѡ���������ݣ�
	String sBankCardBgPath = Sqlca.getString("select  documentId  from  ECM_PAGE where objectType='Business' and objectNo='"+sObjectNo+"' and typeNo='20026' and documentId is not null order by modifytime desc");
	
	// ID5��Ƭ
	String sId5Path = Sqlca.getString(new SqlObject("SELECT CHECKPHOTO FROM ID5_XML_ELE_VAL WHERE CUSTOMERID=:CUSTOMERID AND REQHEADER='1A020201'").setParameter("CUSTOMERID", sCustomerID));
	String sql ="select serialno from business_contract where customerid  = '"+sCustomerID+"' order by serialno desc ";
	ASResultSet result = Sqlca.getResultSet(sql);
	boolean isCurrentlyContract  = false;
	//��ȡǰһ��������ˮ��
	String sFistObjectno=null;
	//��ȡǰ�ڶ�����ˮ��
	String sSendObjectNo=null;
	//��ȡǰ��������ˮ��
	String sThodObjectNo= null;
	while(result.next()){
		String serialno = result.getString("serialno");
		if(serialno ==null ) continue;
		if(serialno.equals(sObjectNo)){//ȡ�õĺ�ͬ�ǲ��ǵ�ǰ��ͬ
			isCurrentlyContract  = true; 
			continue;
		}
		if(isCurrentlyContract==false) continue;//������ǣ�����������
		sFistObjectno = serialno; //��ǰ��ͬǰһ��ͬ
	   if(result.next()){//ǰ2����ͬ
		   sSendObjectNo = result.getString("serialno");
	   }
	   if(result.next()){//ǰ������ͬ
		   sThodObjectNo = result.getString("serialno");
	   }
	   break;
	}
	result.getStatement().close();
	//ǰ��һ����Ƭ��ַ
	String sFistPath = null;
	if(sFistObjectno!=null){
		sFistPath = Sqlca.getString("select  documentId  from  ECM_PAGE where objectType='Business' and objectNo='"+sFistObjectno+"' and typeNo='20002' and documentId is not null order by pageNum");
	}
	//ǰ�ڶ�����Ƭ��ַ
	String sSendPath  = null;
	if(sSendObjectNo != null){
		sSendPath = Sqlca.getString("select  documentId  from  ECM_PAGE where objectType='Business' and objectNo='"+sSendObjectNo+"' and typeNo='20002' and documentId is not null order by pageNum");
	}
	//ǰ��������Ƭ��ַ
	String sThodPath  = null ;
	if(sThodObjectNo != null){
		sThodPath = Sqlca.getString("select  documentId  from  ECM_PAGE where objectType='Business' and objectNo='"+sThodObjectNo+"' and typeNo='20002' and documentId is not null order by pageNum");
	}
	//�ƶ�pos��ı���ͼƬ��ַ
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
    
 // ���п�������Ƭ   20151208_CCS-1016��PRM-559��˶ϵͳ�鿴��Ƭѡ���������ݣ�
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

<!-- ���ͼƬ�Ŵ���С���� -->
<script type="text/javascript">

	var zoom = 1.2; // ������
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

<div align="right" style="margin-top:5px;margin-right:5px;"><b>����:<%=sCustomerName%>&nbsp;&nbsp;���֤����:<%=sCustomerCertId%></b></div>

<table>
<tr>
<td align="center" >
	<% 
	if (id5PhotoPath == null || id5PhotoPath == ""){
		%><font face="��������" size="�����С"  color="red"><b>���֤��վ��ѯ��Ƭ������</b></font><%
	}else{
		%>
		<input type="button" value='�Ŵ�' onclick="javascript:big('id5page')"/>
			<input type="button" value='��С' onclick="javascript:small('id5page')"/>
			<input type="button" value='��ת' onclick="javascript:change('id5page')"/> <br>
		<a class="miniImg artZoom"  rel="<%=id5PhotoPath%>"><img id="id5page" src="<%=id5PhotoPath%>"  alt="1" ><br></a>
		<font face="��������" size="�����С"  color="������ɫ"><b>���֤��վ��ѯ��Ƭ</b></font>
		<%
	}
	%>
</td>
<td align="center" >
	<% 
	if (xcpath == null || xcpath == ""){
		%><font face="��������" size="�����С"  color="red"><b>�ֳ���Ƭ������</b></font><%
	}else{
		%>
		<input type="button" value='�Ŵ�' onclick="javascript:big('xcpage')"/>
			<input type="button" value='��С' onclick="javascript:small('xcpage')"/>
			<input type="button" value='��ת' onclick="javascript:change('xcpage')"/> <br>
		<a class="miniImg artZoom"  rel="<%=nxcpath%>"><img id="xcpage" src="<%=nxcpath%>" onmousewheel="MW(this)"  /></a>
		<br/>
		<font face="��������" size="�����С"  color="������ɫ"><b>�ֳ���Ƭ</b></font>
		<%
	}
	%>
</td>
<td align="center" >
	<% 
	if (sfPath == null || sfPath == ""){
		%><font face="��������" size="�����С"  color="red"><b>���֤��Ƭ������</b></font><%
	}else{
		%>
		
		<input type="button" value='�Ŵ�' onclick="javascript:big('focusphoto')"/>
			<input type="button" value='��С' onclick="javascript:small('focusphoto')"/>
			<input type="button" value='��ת' onclick="javascript:change('focusphoto')"/> <br>
		<a class="miniImg artZoom"  rel="<%=nsfPath%>"><img id="focusphoto" src="<%=nsfPath%>" onmousewheel="MW(this)"  /></a>
		<br>
		<font face="��������" size="�����С"  color="������ɫ"><b>���֤��Ƭ</b></font>
		<%
	}
	%>
</td>
</tr>
<tr>
<td align="center" >
	<% 
	if (sFistPath == null || sFistPath == ""){
		%><font face="��������" size="�����С"  color="red"><b>ǰһ�������ֳ���Ƭ������</b></font><%
	}else{
		%>
		<a class="miniImg artZoom"  rel="<%=nsFistPath%>"><img id="focusphoto" src="<%=nsFistPath%>" onmousewheel="MW(this)"  /></a>
		<font face="��������" size="�����С"  color="������ɫ"><b>ǰһ�������ֳ���Ƭ</b></font>
		<%
	}
	%>
</td>
<td align="center" >
	<% 
	if (sSendPath == null || sSendPath == ""){
		%><font face="��������" size="�����С"  color="red"><b>ǰ���������ֳ���Ƭ������</b></font><%
	}else{
		%>
		<a class="miniImg artZoom"  rel="<%=nsSendPath%>"><img id="focusphoto" src="<%=nsSendPath%>" onmousewheel="MW(this)"  /></a>
		<font face="��������" size="�����С"  color="������ɫ"><b>ǰ���������ֳ���Ƭ</b></font>
		<%
	}
	%>
</td>
<td align="center" >
	<% 
	if (sThodPath == null || sThodPath == ""){
		%><font face="��������" size="�����С"  color="red"><b>ǰ���������ֳ���Ƭ������</b></font><%
	}else{
		%>
		<a class="miniImg artZoom"  rel="<%=nsThodPath%>"><img src="<%=nsThodPath%>" alt="6"  /><br></a>
		<font face="��������" size="�����С"  color="������ɫ"><b>ǰ���������ֳ���Ƭ</b></font>
		<%
	}
	%>
</td>
</tr>
<tr>
<td align="center" >
	<% 
	if (sPosPath == null || sPosPath == ""){
		%><font face="��������" size="�����С"  color="red"><b>�ƶ�POS�����뱳����Ƭ������</b></font><%
	}else{
		%>
		<a class="miniImg artZoom"  rel="<%=nsPosPath%>"><img src="<%=nsPosPath%>" alt="7"  onmousewheel="MW(this)" /><br></a>
		<font face="��������" size="�����С"  color="������ɫ"><b>�ƶ�POS�����뱳����Ƭ</b></font>
		<%
	}
	%>
</td>
<td align="center" >
	<% // ���п�������Ƭ   20151208_CCS-1016��PRM-559��˶ϵͳ�鿴��Ƭѡ���������ݣ�
	if (sBankCardBgPath == null || "".equals(sBankCardBgPath)){
		%><font face="��������" size="�����С"  color="red"><b>���п�������Ƭ������</b></font><%
	}else{
		%>
		<a class="miniImg artZoom"  rel="<%=nsBankCardBgPath%>"><img src="<%=nsBankCardBgPath%>" alt="���п�������Ƭ"  onmousewheel="MW(this)" /><br/></a>
		<font face="��������" size="�����С"  color="������ɫ"><b>���п�������Ƭ</b></font>
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