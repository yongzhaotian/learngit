<%@ page language="java" contentType="text/html; charset=GBK " %>
<%@ include file="/IncludeBeginMD.jsp"%>
<%@page import="com.amarsoft.dict.als.cache.CodeCache"%>
<head><meta http-equiv="Content-Type" content="text/html; charset=GBK">
<html>
<title></title>
    <style type="text/css">

 p.MsoNormal
	{margin-bottom:.0001pt;
	text-align:justify;
	text-justify:inter-ideograph;
	font-size:10.5pt;
	font-family:"Calibri","sans-serif";
	        margin-left: 0cm;
            margin-right: 0cm;
            margin-top: 0cm;
        }
    </style>
<SCRIPT language=javascript>  

  function print(){
	  document.all("clearHead").click();//��ӡ֮ǰȥ��ҳü��ҳ��  
	  document.getElementById("printClass1").style.display="none"; 
		document.getElementById("printClass2").style.display="none"; 
		document.getElementById("printClass").style.display="none"; 
		document.getElementById("WebBrowser").ExecWB(8,1);
		document.getElementById("printClass1").style.display=""; 
		document.getElementById("printClass2").style.display=""; 
		document.getElementById("printClass").style.display=""; 
		}
  
  function print1(){
	  document.all("clearHead").click();//��ӡ֮ǰȥ��ҳü��ҳ��  
		document.getElementById("printClass1").style.display="none"; 
		document.getElementById("printClass2").style.display="none"; 
		document.getElementById("printClass").style.display="none"; 
		document.getElementById("WebBrowser").ExecWB(7,1);
		document.getElementById("printClass1").style.display=""; 
		document.getElementById("printClass2").style.display=""; 
		document.getElementById("printClass").style.display=""; 
		}
  
  function print2(){
	  document.all("clearHead").click();//��ӡ֮ǰȥ��ҳü��ҳ��  
	  document.getElementById("printClass1").style.display="none"; 
		document.getElementById("printClass2").style.display="none"; 
		document.getElementById("printClass").style.display="none"; 
		document.getElementById("WebBrowser").ExecWB(6,1);
		document.getElementById("printClass1").style.display=""; 
		document.getElementById("printClass2").style.display=""; 
		document.getElementById("printClass").style.display=""; 
		}
  
  
</SCRIPT> 
<script language="VBScript">  
	dim hkey_root,hkey_path,hkey_key  
	hkey_root="HKEY_CURRENT_USER"  
hkey_path="\Software\Microsoft\Internet Explorer\PageSetup"  
'//������ҳ��ӡ��ҳüҳ��Ϊ��  
function pagesetup_null()  
on error resume next  
Set RegWsh = CreateObject("WScript.Shell")  
hkey_key="\header"  
RegWsh.RegWrite hkey_root+hkey_path+hkey_key,""  
hkey_key="\footer"  
RegWsh.RegWrite hkey_root+hkey_path+hkey_key,""  
end function  
'//������ҳ��ӡ��ҳüҳ��ΪĬ��ֵ  
function pagesetup_default()  
on error resume next  
Set RegWsh = CreateObject("WScript.Shell")  
hkey_key="\header"  
RegWsh.RegWrite hkey_root+hkey_path+hkey_key,"&w&bҳ�룬&p/&P"  
hkey_key="\footer"  
RegWsh.RegWrite hkey_root+hkey_path+hkey_key,"&u&b&d"  
end function  
</script> 

<% 
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectNo")); 
	String sql = "select suretype,isp2p,salesexecutive,getuserName(salesexecutive) as salesexecutiveName " + 
		" from business_contract where serialno='"+sObjectNo+"'";

	String customerSignUrl = CodeCache.getItem("SignAppUrl","0030").getItemAttribute();
	String salesmanSignUrl = CodeCache.getItem("SignAppUrl","0040").getItemAttribute();
	String appBorrowerSign = "&nbsp;<img src='"+customerSignUrl+sObjectNo+"' width='100' height='30'/>";
	String appSalesmanSign = "&nbsp;<img src='"+salesmanSignUrl+sObjectNo+"' width='100' height='30'/>";
	String borrowerSign = "";//���ҵ����Դ��APP���滻Ϊǩ��ͼƬURL��ַ,��APP��Դ���滻
	String salesmanSign = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";//���ҵ����Դ��APP���滻Ϊǩ��ͼƬURL��ַ,��APP��Դ���滻
	
	ASResultSet rs = Sqlca.getASResultSet(sql);
	String suretype="",isp2p = "",salesexecutiveName = "";
	if(rs.next()){
		suretype = rs.getString("suretype");
		isp2p = rs.getString("isp2p");
		salesexecutiveName = rs.getString("salesexecutiveName");
	}
	if(rs != null)rs.close();
	
	if(suretype == null) suretype="";
	if(isp2p == null) isp2p="";
	if(salesexecutiveName == null) salesexecutiveName="";
	
	//����Э������
	String triple = "���ڹ����Ѵ�������Э��";
	if("1".equals(isp2p)){
		triple = "ί��������ѯ����Э�飨P2P�ʽ�";
	}
	
	//���ҵ����Դ��APP���滻Ϊǩ��ͼƬURL��ַ,��APP��Դ���滻
	if("APP".equals(suretype)){
		borrowerSign = appBorrowerSign;
		salesmanSign = appSalesmanSign;
	}
	
	java.util.Date dateNow = new java.util.Date();
	SimpleDateFormat sdfTemp = new SimpleDateFormat("yyyy/MM/dd");
	String today = sdfTemp.format(dateNow);
%>

</head>
<body>
<form method="post" action="" id="form1">
    	<div>
		    <input id ="printClass"   type="button" value='��ӡ����' onclick="print()"/>
		    <input id ="printClass1"   type= "button" value='��ӡԤ��' onclick="print1()"/> 
		    <input id ="printClass2"   type="button" value='��ӡ' onclick="print2()"/> 
		    <input type="hidden" name="clearHead" id="clearHead" class="tab" value="ȥ��ҳüҳ��" onclick="pagesetup_null()">  
    	</div>
    <div>
     <OBJECT  id="WebBrowser"  classid=CLSID:8856F961-340A-11D0-A96B-00C04FD705A2  height=0  width=0>
    </OBJECT>
    <table style="width:739px" align="center">
    	<tbody>









<div class=WordSection1 style='layout-grid:15.6pt'>

<p class=MsoNormal align=center style='text-align:center;layout-grid-mode:char'><b><span
style='font-size:14.0pt;font-family:����'>���Ļ�����������</span></b></p>

<p class=MsoNormal style='layout-grid-mode:char'><b><span style='font-family:
����'>�����а�Ǫ���ڷ������޹�˾�������ˣ�</span></b></p>

<p class=MsoNormal style='layout-grid-mode:char'><span lang=EN-US>&nbsp;&nbsp;&nbsp;&nbsp;
</span><b><span style='font-family:����'>�����������а�Ǫ���ڷ������޹�˾�����¼�ơ���Ǫ���ڡ�����������ǩ���˱��Ϊ</span></b><b><u><span
style='font-family:����'> <span lang=EN-US><%=sObjectNo %> </span></span></u></b><b><span
style='font-family:����'>�ġ�<%=triple %>�����������������ͳ��Ϊ�����ͬ�������������ƴ�����������ͬ�еĴ�����һ�£��������˾������Ļ��������룬����Ը�����������</span><span
lang=EN-US>&nbsp; </span></b></p>

<p class=MsoNormal style='layout-grid-mode:char'><b><span lang=EN-US>1.&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
</span></b><b><span style='font-family:����'>���Ļ��������ݽ��ܣ�</span></b></p>

<p class=MsoNormal style='layout-grid-mode:char'><span style='font-family:����'>��</span><span
lang=EN-US>1</span><span style='font-family:����'>������˿������һ�ʴ���ѡ�������Ļ����񣬷������ݰ���������ڻ������������ں��Ż���ǰ��������ѡ�������Ļ������Ӧ�������Ǫ����֧�����Ļ�����ѣ��÷��ð����ڸñʴ����ÿһ���ڿ��У��������Ըñʴ���������еġ������Ļ�����ѡ�����Ϊ׼��</span></p>

<p class=MsoNormal style='layout-grid-mode:char'><span style='font-family:����'>��</span><span
lang=EN-US>2</span><span style='font-family:����'>��������������һ�ʴ���󣬰�Ǫ����ʵʩ���µ����Ļ������շѱ�׼�������д�������Ļ�������԰���ԭ�б�׼���ɡ�</span></p>

<p class=MsoNormal style='layout-grid-mode:char'><b><span lang=EN-US>2. </span></b><b><span
style='font-family:����'>���ڻ��</span></b></p>

<p class=MsoNormal style='layout-grid-mode:char'><span style='font-family:����'>��</span><span
lang=EN-US>1</span><span style='font-family:����'>�����������������������������һ�����ɣ��������������������и���Ҫ��ģ���������Ӧ���ϣ���</span></p>

<p class=MsoNormal style='text-indent:10.5pt;layout-grid-mode:char'><span
lang=EN-US>a</span><span style='font-family:����'>��δʹ�ù����Ļ������κ���Ŀ�ģ�������Ѱ�ʱ�����ñʴ���</span><span
lang=EN-US>5</span><span style='font-family:����'>�ڼ������ڿ</span></p>

<p class=MsoNormal style='text-indent:10.5pt;layout-grid-mode:char'><span
lang=EN-US>b</span><span style='font-family:����'>���ڶ����������ڻ������ʹ���˱�������շ�������������ڻ���ģ�Ӧ���ϴ����ڻ������������֮��ʱ�������ڼ������ڿ</span></p>

<p class=MsoNormal style='layout-grid-mode:char'><span style='font-family:����'>��</span><span
lang=EN-US>2</span><span style='font-family:����'>�������ÿ������ʱ���ֻ��ʹ��һ�����ڻ��ÿ��������������Ϊһ�ڣ����Ϊ���ڡ�</span></p>

<p class=MsoNormal style='layout-grid-mode:char'><span style='font-family:����'>��</span><span
lang=EN-US>3</span><span style='font-family:����'>�����ڻ����ڼ䲻����Ϣ���������ѡ��ͻ�����ѡ���ֵ����ѣ����У������Ļ�����ѡ�</span></p>

<p class=MsoNormal style='layout-grid-mode:char'><span style='font-family:����'>��</span><span
lang=EN-US>4</span><span style='font-family:����'>�������������ڻ�������ʱ�����Ǫ���ڼ������˺�����Ϊ����˵��������������չ���Ҫ��ͻ������ӽ����ΥԼ�Ŀ����ԣ�������Ȩ�ܾ�����˵ĸô����롣</span><span
lang=EN-US>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span></p>

<p class=MsoNormal style='layout-grid-mode:char'><b><span lang=EN-US>3.&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
</span></b><b><span style='font-family:����'>��������գ�</span></b></p>

<p class=MsoNormal style='layout-grid-mode:char'><span style='font-family:����'>��</span><span
lang=EN-US>1</span><span style='font-family:����'>�����������������������������һ�����ɣ��������������������и���Ҫ��ģ���������Ӧ���ϣ���</span></p>

<p class=MsoNormal style='text-indent:10.5pt;layout-grid-mode:char'><span
lang=EN-US>a</span><span style='font-family:����'>��δʹ�ù����Ļ������κ���Ŀ�ģ���ʱ�����ñʴ�������ڼ������ڿ</span></p>

<p class=MsoNormal style='text-indent:10.5pt;layout-grid-mode:char'><span
lang=EN-US>b</span><span style='font-family:����'>���ڶ��������������ջ���ʹ�������ڻ��������������������յģ�Ӧ���ϴ����ڻ������������֮��ʱ�������ڼ������ڿ</span></p>

<p class=MsoNormal style='layout-grid-mode:char'><span style='font-family:����'>��</span><span
lang=EN-US>2</span><span style='font-family:����'>��������ʱ�����������δ������غϴ���غϴ��ָ�ڽ����ǩ���˶���������а�Ǫ���ڷ������޹�˾��Ϊ���ڷ���˾�Ĵ����ͬ������£�����һ�ʴ���������һ�ʻ��ʴ��������һ����ͬ������յĴ�����ڽ���˾ͱ���ͬ�����˱�������գ�����������Ļ����վ�ͬʱ���Ϊ�µĻ����ա�</span></p>

<p class=MsoNormal style='layout-grid-mode:char'><span style='font-family:����'>��</span><span
lang=EN-US>3</span><span style='font-family:����'>���µĻ��������ڿ���</span><span
lang=EN-US>1-28</span><span style='font-family:����'>��֮��ѡ�񣬵����������������֮�����׸�����󻹿���֮����Ӧ��</span><span
lang=EN-US>5</span><span style='font-family:����'>�գ�������</span><span lang=EN-US>35</span><span
style='font-family:����'>�գ�������֮�䣨�����������㣬�������գ���</span></p>

<p class=MsoNormal style='layout-grid-mode:char'><b><span lang=EN-US>4. </span></b><b><span
style='font-family:����'>�Ż���ǰ���</span></b></p>

<p class=MsoNormal style='layout-grid-mode:char'><span style='font-family:����'>�������������������ǰ����Ĵ�������������ڿ�󣬿ɰ��ձ����������ǰ�����Լ���͸ñʴ���������ǰ�������������֧����ǰ����ѡ�</span></p>

<p class=MsoNormal style='layout-grid-mode:char'><b><span lang=EN-US>5.</span></b><b><span
style='font-family:����'>���������</span></b></p>

<p class=MsoNormal style='layout-grid-mode:char'><span style='font-family:����'>��</span><span
lang=EN-US>1</span><span style='font-family:����'>���������Ļ������ÿ�ʴ�������ڻ���ͱ�������շ���������£���������Ϊ</span><span
lang=EN-US>12</span><span style='font-family:����'>�ڣ��������µķֱ�Ϊһ�Σ���������Ϊ</span><span
lang=EN-US>12</span><span style='font-family:����'>�����ϵķֱ�Ϊ�ۼ����Ρ�</span></p>

<p class=MsoNormal style='layout-grid-mode:char'><span style='font-family:����'>��</span><span
lang=EN-US>2</span><span style='font-family:����'>���������Ļ������ÿ�ʴ�������ڻ������������������£���������Ϊ</span><span
lang=EN-US>12</span><span style='font-family:����'>�ڣ��������µ�Ϊһ�ڣ���������Ϊ</span><span
lang=EN-US>12</span><span style='font-family:����'>�����ϵ�Ϊ�ۼ����ڣ������������ʹ����ϵģ���ʹ�������Ļ����������κ�ʣ���������ģ�Ҳ�����ٴ����롣</span></p>

<p class=MsoNormal style='layout-grid-mode:char'><span style='font-family:����'>��</span><span
lang=EN-US>3</span><span style='font-family:����'>��������������غϴ������˾ͱ���ͬ�����˱�������գ��������������һ�ʻ����๺�������Ļ���������ͬÿ�ʴ����ʹ����һ�α�������շ���</span></p>

<p class=MsoNormal style='layout-grid-mode:char'><span style='font-family:����'>��</span><span
lang=EN-US>4</span><span style='font-family:����'>����������ռ����ڻ�����������������������������</span><span
lang=EN-US>24</span><span style='font-family:����'>�ڵĴ��ʹ����һ������һ�ڵ����ڻ��������ٴ�����ʱ����ֻ������һ�α�������շ��������һ�ڵ����ڻ������</span></p>

<p class=MsoNormal style='layout-grid-mode:char'><span style='font-family:����'>��</span><span
lang=EN-US>5</span><span style='font-family:����'>��һ�ʴ�������ֻ��ʹ��һ���Ż���ǰ��������Ż���ǰ���������Ч�����Ļ������սᡣ</span></p>

<p class=MsoNormal style='layout-grid-mode:char'><span lang=EN-US>6. </span><span
style='font-family:����'>������������ڻ���ͱ��������Ӧ�������һ�����������������ǰ�µ��Ǫ��������������Ż���ǰ����ģ�Ӧ�������һ�������������ʮ����ǰ�µ��Ǫ����������������ͬһʱ��ֻ������һ�����Ļ��������ǰһ�����Ļ������ʹ�ý������������ڼ������ڿ�󣬲�������ʹ�����������籾�����</span><span
lang=EN-US>2</span><span style='font-family:����'>������</span><span lang=EN-US>3</span><span
style='font-family:����'>������</span><span lang=EN-US>4</span><span
style='font-family:����'>���͵�</span><span lang=EN-US>5</span><span
style='font-family:����'>���涨���ߵ�Ҫ��������涨Ϊ׼��</span></p>

<p class=MsoNormal style='layout-grid-mode:char'><b><span lang=EN-US>7</span></b><b><span
style='font-family:����'>��ȡ�����Ļ�����</span></b></p>

<p class=MsoNormal style='layout-grid-mode:char'><span style='font-family:����'>��</span><span
lang=EN-US>1</span><span style='font-family:����'>����ԥ�ڣ�����ˡ����������֮���������ʮ�����Ȼ���ڣ����������յ��죩���Ǫ�����µ�����ȡ�����Ļ�����������֧�����Ļ�����ѡ�</span></p>

<p class=MsoNormal style='layout-grid-mode:char'><span style='font-family:����'>��</span><span
lang=EN-US>2</span><span style='font-family:����'>�����������ȡ��һ�ʴ�������Ļ�����ģ�Ӧ�������һ�����������������ǰ����ԥ��ȡ�����⣩�µ��Ǫ�������������ȡ���ɹ��󣬽����������ȡ��֮�յ���һ����Ȼ����ֹ֧ͣ�����Ļ�����ѡ���</span></p>

<p class=MsoNormal style='layout-grid-mode:char'><span style='font-family:����'>��</span><span
lang=EN-US>3</span><span style='font-family:����'>�����������ȡ�����Ļ�������Ѿ�֧�������Ļ�����Ѳ����˻�����ʹ����˴�δʹ�ù��÷���</span></p>

<p class=MsoNormal style='layout-grid-mode:char'><span style='font-family:����'>��</span><span
lang=EN-US>4</span><span style='font-family:����'>��ȡ�����Ļ�����һ���ɹ����룬��ʱ��Ч�����Ļ������սᡣͬһ�ʴ������Ļ������ȡ�������ٴ����롣��</span><span
lang=EN-US>5</span><span style='font-family:����'>��������Ѿ�ʹ�ù���������κ�һ�����ģ���������ȡ���������</span></p>

<p class=MsoNormal style='layout-grid-mode:char'><span lang=EN-US>8. </span><span
style='font-family:����'>����ʱ�������ڱ���ͬ�Լ��κ������ɰ�Ǫ������Ϊ����ڷ���˾�ĺ�ͬ�����ڿ������״̬�ģ�����������ʹ�û�ȡ�������������������ʱû�����ڣ�����������׸����ڻ�����ǰ���׸�����󻹿���ǰ���Ż���ǰ������Чǰ��ȡ���������Чǰ�������ڵģ��������Զ�ʧЧ��</span></p>

<p class=MsoNormal style='layout-grid-mode:char'><span lang=EN-US>9. </span><span
style='font-family:����'>����˹��������Ļ�����󣬸����ڿ��а����ĸ����������˳�������峥�����ɽ����У����������ѡ��ͻ�����ѡ���ֵ����ѣ����У������Ļ�����ѡ���Ϣ�������</span></p>

<p class=MsoNormal style='layout-grid-mode:char'><span lang=EN-US>10. </span><span
style='font-family:����'>�����˼���Ǫ���ڱ������ڽ���˵�����ͷ��ճ̶ȼ������Ļ�����ķ���Χ��ȫ��ȡ�����Ļ������Ȩ����</span></p>

<p class=MsoNormal style='layout-grid-mode:char'><span lang=EN-US>11. </span><span
style='font-family:����'>�����ʹ�ñ�������Լ���ķ������ݵģ�������ΥԼ��Ҳ��Ӱ�����˵����ż�¼��</span></p>

<p class=MsoNormal style='layout-grid-mode:char'><span lang=EN-US>12. </span><span
style='font-family:����'>����˳�ŵ��������ڱ������·�ǩ������Ϊ���ܱ������ȫ�������Ǫ���ڼ��������ڴ����ͬ��ǩ�¼���Ϊ�����Ա�����������һ��Э�飬Э����Ч����ͬ�������ǩ�����ڡ�</span></p>
<%
	//���ҵ����Դ��APP�����Ӷ������һ��
	if("APP".equals(suretype)){
%>
<p class=MsoNormal style='layout-grid-mode:char'><span lang=EN-US>13. </span><span
style='font-family:����'>������ֽ��ǩ��ʽ������Ҳ����ͨ����Ǫ�����ṩ���豸�ڱ��������Ͻ��е���ǩ���������ͬ�Ȿ�������ǩ����Բ��õ���ǩ�¡������ı���ʽ���Ͽɵ���ǩ�¡������ı��ķ���Ч������ͬ��������ݵ��ĵ���ʽ���ܡ�</span></p>
<p class=MsoNormal style='layout-grid-mode:char'><span lang=EN-US>14. </span><span
<%
	}else if("JCC".equals(suretype)){
		%>
		<p class=MsoNormal style='layout-grid-mode:char'><span lang=EN-US>13. </span><span
		style='font-family:����'>������ֽ��ǩ��ʽ������Ҳ����ͨ����Ǫ�����ṩ���豸�ڱ��������Ͻ��е���ǩ���������ͬ�Ȿ�������ǩ����Բ��õ���ǩ�¡������ı���ʽ���Ͽɵ���ǩ�¡������ı��ķ���Ч������ͬ��������ݵ��ĵ���ʽ���ܡ�</span></p>
		<p class=MsoNormal style='layout-grid-mode:char'><span lang=EN-US>14. </span><span
		<%
			}else{
%>		
<p class=MsoNormal style='layout-grid-mode:char'><span lang=EN-US>13. </span><span
<%
	}
%>
style='font-family:����'>��������Ϊ�����ͬ�ĸ���������ͬ����ͬ��Ч�����������Ȩ��Ǫ���ڽ���������ͬ��ȡͬ����ʽһ�����洦��</span></p>

<p class=MsoNormal style='layout-grid-mode:char'><span lang=EN-US>&nbsp;</span></p>

<p class=MsoNormal style='layout-grid-mode:char'><span style='font-family:����'>���۹���������
<%=salesexecutiveName %><span lang=EN-US>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span>���۹���ǩ����<%=salesmanSign %></span><span
lang=EN-US>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span><span
style='font-family:����'>�����ˣ�����ˣ�ǩ����<%=borrowerSign %></span></p>

<p class=MsoNormal style='layout-grid-mode:char'><span lang=EN-US>&nbsp;</span></p>
<%
	if("JCC".equals(suretype)){
%>
<br>
<p class=MsoNormal style='layout-grid-mode:char'><span lang=EN-US>�汾��:J_XF_TY_TY_2016030801 </span>
<%
	}
%>
</div>












       </tbody> </table>
	</div>
    </form>

</body>
</html>
<%@ include file="/IncludeEnd.jsp"%>