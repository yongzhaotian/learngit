<%@ page language="java" contentType="text/html; charset=GBK " %>
<%@ include file="/IncludeBeginMD.jsp"%>
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
            margin-top: 0cm;<%@ page language="java" contentType="text/html; charset=GBK " %>
<%@ include file="/IncludeBeginMD.jsp"%>
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
	//add by daihuafeng,���ҵ����Դ��APP���滻Ϊǩ��ͼƬURL��ַ,��APP��Դ���滻,20150708
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectNo")); 	
	//ҵ����Դ
	String sSureType = Sqlca.getString("select bc.SureType from business_contract bc where bc.serialno='"+sObjectNo+"'");
	//ǩ��ͼƬURL��ַ
	String sInterfaceAddressPort = Sqlca.getString("select ITEMDESCRIBE from code_library where codeno='InterfaceAddressPort' and itemno='010' and isinuse='1'");
	String sPath = "<img src='http://"+sInterfaceAddressPort+"/mbqjr/contract/getcustomersign?serialno="+sObjectNo+"' width='100' height='30'/>";
	String sPath_Salesman = "<img src='http://"+sInterfaceAddressPort+"/mbqjr/contract/getSignatureSales?serialno="+sObjectNo+"' width='100' height='30'/>";
	//���ҵ����Դ��APP���滻Ϊǩ��ͼƬURL��ַ,��APP��Դ���滻
	String sReplace = "";
	String sReplace_Salesman = "";
	//���ҵ����Դ��APP���滻Ϊǩ��ͼƬURL��ַ,��APP��Դ���滻
	//sSureType = "APP";
	if("APP".equals(sSureType)){
		sReplace = sPath;
		sReplace_Salesman = sPath_Salesman;
	}
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
    	
        <tr> <td style="font-size:12px;text-align:left;border-color:white;" class="auto-style1">

            <table style="width:739px"><tr><td><img src="<%=request.getContextPath()%>/FormatDoc/Images/JCXTS.png" /></td><td style="text-align:right">
            </td></tr></table>
             </td>

        </tr>
        <tr> <td style="font-size:12px;text-align:center;border-color:white;" class="auto-style1">
            <b style="mso-bidi-font-weight:normal"><span style="font-size:16.0pt;mso-bidi-font-size:22.0pt;font-family:&quot;΢���ź�&quot;,&quot;sans-serif&quot;;
mso-bidi-font-family:&quot;Times New Roman&quot;;mso-bidi-theme-font:minor-bidi;
mso-ansi-language:EN-US;mso-fareast-language:ZH-CN;mso-bidi-language:AR-SA">����թ������ʾ</span></b></td>
            </tr>
         <tr> <td style="font-size:12px;text-align:left;border-color:white;" class="auto-style2">
             <p align="left" class="MsoNormal" style="text-align:left;line-height:150%">
                 <span style="font-size:9.0pt;line-height:150%;font-family:&quot;΢���ź�&quot;,&quot;sans-serif&quot;">�𾴵Ŀͻ���<span lang="EN-US"><o:p></o:p></span></span></p>
             <p align="left" class="MsoNormal" style="text-align:left;text-indent:18.0pt;
mso-char-indent-count:2.0;line-height:150%; width: 714px;">
                 <span class="ca-3">
                 <span style="font-size:9.0pt;line-height:150%;font-family:&quot;΢���ź�&quot;,&quot;sans-serif&quot;;
					mso-bidi-font-family:Tahoma;color:black"><br/>
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					���ڣ�����г��ϴ��ڲ�����Ա������ڸ���ҵ����зǷ����ֵ����������а�Ǫ���ڷ������޹�˾�����¼�ơ���Ǫ���ڡ����������۳ϲƸ��ʲ��������޹�˾�����¼�ơ��۳ϲƸ������ڴ���ʾ��<br/><br/>
					Ϊ��ά������������Ϣ��ȫ���������õ������ȣ���ܾ�����<u>���ֺ���թ</u>��Ϊ��������һ��Υ����Ϊ��һ�����ֱؽ���׷���������Ρ�</span></span></p>
                 	<span style="font-size:9.0pt;line-height:150%;font-family:&quot;΢���ź�&quot;,&quot;sans-serif&quot;"><br/>
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					���������Ǫ���ڷ��ڸ���ҵ��ʱ�������˳�ŵ���Գƣ�</span></p>
            </td>
            </tr>
         <tr> <td style="font-size:12px;text-align:left;border-color:white;" class="auto-style1">
             <table style="background-color:#d9d9d9">
                 <tr>
                    <td>
                         <p class=MsoListParagraph align=left style='margin-left:42.3pt;text-align:left;
text-indent:-21.0pt;line-height:150%'><span lang=EN-US style='line-height:150%;
font-family:Wingdings;color:red'>&sup2;<span style='font:7.0pt "Times New Roman"'>&nbsp;
</span></span><b><span style='line-height:
150%;font-family:"΢���ź�","sans-serif";color:red'>�ɹ���������軹��,���豾�˻��������ٻ���</span></b></p>

<p class=MsoListParagraph align=left style='margin-left:42.3pt;text-align:left;
text-indent:-21.0pt;line-height:150%'><span lang=EN-US style='line-height:150%;
font-family:Wingdings;color:red'>&sup2;<span style='font:7.0pt "Times New Roman"'>&nbsp;
</span></span><b><span style='line-height:150%;font-family:"΢���ź�","sans-serif";
color:red'>������˾������ҵ���������ֽ���Ϊ����</span></b></p>

<p class=MsoListParagraph align=left style='margin-left:42.3pt;text-align:left;
text-indent:-21.0pt;line-height:150%'><span lang=EN-US style='line-height:150%;
font-family:Wingdings;color:red'>&sup2;<span style='font:7.0pt "Times New Roman"'>&nbsp;
</span></span><b><span style='line-height:150%;font-family:"΢���ź�","sans-serif";
color:red'>���֤��ʧ��������������ڸ�������ֽ���Ϊ����</span></b></p>

<p class=MsoListParagraph align=left style='margin-left:42.3pt;text-align:left;
text-indent:-21.0pt;line-height:150%'><span lang=EN-US style='line-height:150%;
font-family:Wingdings;color:red'>&sup2;<span style='font:7.0pt "Times New Roman"'>&nbsp;
</span></span><b><span style='line-height:150%;font-family:"΢���ź�","sans-serif";
color:red'>����Ƹ����Ҫ����������ڸ�����Ϊ��ְ����</span></b></p>

<p class=MsoListParagraph align=left style='margin-left:42.3pt;text-align:left;
text-indent:-21.0pt;line-height:150%'><span lang=EN-US style='line-height:150%;
font-family:Wingdings;color:red'>&sup2;<span style='font:7.0pt "Times New Roman"'>&nbsp;
</span></span><b><span style='line-height:150%;font-family:"΢���ź�","sans-serif";
color:red'>��Ӧ�������������ÿ�����������ҵ��</span></b></p>

<p class=MsoListParagraph align=left style='margin-left:42.3pt;text-align:left;
text-indent:-21.0pt;line-height:150%'><span lang=EN-US style='line-height:150%;
font-family:Wingdings;color:red'>&sup2;<span style='font:7.0pt "Times New Roman"'>&nbsp;
</span></span><b><span style='line-height:150%;font-family:"΢���ź�","sans-serif";
color:red'>��Ӧ���������������������̻�������Ա��Ϊ����ȣ�</span></b></p>
                    </td>
                 </tr>
             </table>
</td>
            </tr>
         <tr> <td style="font-size:12px;text-align:left;border-color:white;" class="auto-style1" >
            
                 <span style="font-size:9.0pt;
line-height:150%;font-family:&quot;΢���ź�&quot;,&quot;sans-serif&quot;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<br />
                 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;  
                 	��������������ʱ���������ѱ�������ƭ��������ֹͣ���ڸ������룬�����Ǫ���ڡ��۳ϲƸ��Ĺ�����Ա��ӳ��ͬʱ������թ��<br/><br/>
                 	�ߣ�<b style="mso-bidi-font-weight:normal"><span lang="EN-US" style="color:red">400 998 7105<br />
                 <br /></span></b><span lang="EN-US"><o:p></o:p></span></span>
            </td>
            </tr>
         <tr> <td style="font-size:12px;text-align:left;border-color:white;" class="auto-style1">
             <p class=MsoNormal style='line-height:20.0pt'><span style='position:absolute;
z-index:251658240;left:0px;margin-left:326px;margin-top:198px;width:335px;
height:188px'></span><span
style='font-size:9.0pt;font-family:΢���ź�'>�ڴ�֣�����ѣ������ʹ�������˵���ʵ��ݼ���ʵ��������������ڸ���緢���ṩ������ϣ���Ǫ���ڡ��۳ϲƸ���������������Ǫ���ڡ��۳ϲƸ�û����Ȩ�κε������������߸������κθ�������Ҫ�����������ҵ����������������׼���밴��ͬԼ���ϸ����л�������������δ������ܵ������������������¼����Ǫ���ڲ��ų������˲��������¼�԰�Ǫ���ڻ��������ڻ��������ϴ�������ϵͳ����ʱ�������������ü�¼�����������ü�¼��Ӱ���������е�����ҵ�������������������ߴ������Ϣ���޷�����ס������������ȣ�����������ر������õĻ����¼�͸������á��������⣬��ֱ�����Ǫ���ڡ��۳ϲƸ��Ĺ���Ա���������̻�Ǣ̸�����ǻ������ȷ��ָ�����򲦴�ͻ��������ߣ�<b>
<span lang="EN-US" style="color:red"><b>400 998 7101</b><br />
</b></span></p>

<p class=MsoNormal align=right style='margin-right:28.0pt;text-align:right;
line-height:150%'><b><span style='font-size:9.0pt;line-height:150%;font-family:
΢���ź�'>��Ǫ����&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</b></span>

<p class=MsoNormal align=right style='margin-right:28.0pt;text-align:right;
line-height:150%'><b><span style='font-size:9.0pt;line-height:150%;font-family:
΢���ź�'>�۳ϲƸ�&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</b></span>

<p class=MsoNormal align=right style='margin-right:28.0pt;text-align:right;
line-height:150%'><span style='font-size:9.0pt;line-height:150%;font-family:
΢���ź�'>�ͻ�ǩ��:___________</span>

<p class=MsoNormal align=right style='margin-right:28.0pt;text-align:right;
line-height:150%'><span style='font-size:9.0pt;line-height:150%;font-family:
΢���ź�'>����ǩ��:___________</span>

<p class=MsoNormal align=left style='text-align:left;line-height:20.0pt'><span
lang=EN-US style='font-size:11.0pt;font-family:΢���ź�'>&nbsp;</span></p>

<p class=MsoNormal align=left style='margin-right:28.0pt;text-align:left;
line-height:150%'><b><span style='font-size:9.0pt;line-height:150%;font-family:
΢���ź�'>�ܾ���թ���ܾ����֣�</span></b></p></b></td></tr></table>

            
            </table>

             </td>
            </tr>
            <br>
            <br>
            <tr> <td>
            <span style="font-size:8 pt;mso-bidi-font-size:11.0pt;font-family:&quot;΢���ź�&quot;,&quot;sans-serif&quot;;
								mso-bidi-font-family:&quot;Times New Roman&quot;;mso-bidi-theme-font:minor-bidi;
								mso-ansi-language:EN-US;mso-fareast-language:ZH-CN;mso-bidi-language:AR-SA">�汾�ţ�J_XF_TY_TY_2016030802</span></b>
            </td><td></td>
            </tr>
        <tr> <td style="font-size:12px;text-align:left;border-color:white;" class="auto-style1"></td><td></td>
            </tr>
        <tr> <td style="font-size:12px;text-align:left;border-color:white;" class="auto-style1">
            </td>
            </tr>
       </tbody> </table>
	</div>
    </form>
</body>
</html>
<%@ include file="/IncludeEnd.jsp"%>
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
	//add by daihuafeng,���ҵ����Դ��APP���滻Ϊǩ��ͼƬURL��ַ,��APP��Դ���滻,20150708
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectNo")); 	
	//ҵ����Դ
	String sSureType = Sqlca.getString("select bc.SureType from business_contract bc where bc.serialno='"+sObjectNo+"'");
	//ǩ��ͼƬURL��ַ
	String sInterfaceAddressPort = Sqlca.getString("select ITEMDESCRIBE from code_library where codeno='InterfaceAddressPort' and itemno='010' and isinuse='1'");
	String sPath = "<img src='http://"+sInterfaceAddressPort+"/mbqjr/contract/getcustomersign?serialno="+sObjectNo+"' width='100' height='30'/>";
	String sPath_Salesman = "<img src='http://"+sInterfaceAddressPort+"/mbqjr/contract/getSignatureSales?serialno="+sObjectNo+"' width='100' height='30'/>";
	//���ҵ����Դ��APP���滻Ϊǩ��ͼƬURL��ַ,��APP��Դ���滻
	String sReplace = "";
	String sReplace_Salesman = "";
	//���ҵ����Դ��APP���滻Ϊǩ��ͼƬURL��ַ,��APP��Դ���滻
	//sSureType = "APP";
	if("APP".equals(sSureType)){
		sReplace = sPath;
		sReplace_Salesman = sPath_Salesman;
	}
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
    	
        <tr> <td style="font-size:12px;text-align:left;border-color:white;" class="auto-style1">

            <table style="width:739px"><tr><td><img src="<%=request.getContextPath()%>/FormatDoc/Images/JCXTS.png" /></td><td style="text-align:right">
            </td></tr></table>
             </td>

        </tr>
        <tr> <td style="font-size:12px;text-align:center;border-color:white;" class="auto-style1">
            <b style="mso-bidi-font-weight:normal"><span style="font-size:16.0pt;mso-bidi-font-size:22.0pt;font-family:&quot;΢���ź�&quot;,&quot;sans-serif&quot;;
mso-bidi-font-family:&quot;Times New Roman&quot;;mso-bidi-theme-font:minor-bidi;
mso-ansi-language:EN-US;mso-fareast-language:ZH-CN;mso-bidi-language:AR-SA">����թ������ʾ</span></b></td>
            </tr>
         <tr> <td style="font-size:12px;text-align:left;border-color:white;" class="auto-style2">
             <p align="left" class="MsoNormal" style="text-align:left;line-height:150%">
                 <span style="font-size:9.0pt;line-height:150%;font-family:&quot;΢���ź�&quot;,&quot;sans-serif&quot;">�𾴵Ŀͻ���<span lang="EN-US"><o:p></o:p></span></span></p>
             <p align="left" class="MsoNormal" style="text-align:left;text-indent:18.0pt;
mso-char-indent-count:2.0;line-height:150%; width: 714px;">
                 <span class="ca-3">
                 <span style="font-size:9.0pt;line-height:150%;font-family:&quot;΢���ź�&quot;,&quot;sans-serif&quot;;
					mso-bidi-font-family:Tahoma;color:black"><br/>
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					���ڣ�����г��ϴ��ڲ�����Ա������ڸ���ҵ����зǷ����ֵ����������а�Ǫ���ڷ������޹�˾�����¼�ơ���Ǫ���ڡ����������۳ϲƸ��ʲ��������޹�˾�����¼�ơ��۳ϲƸ������ڴ���ʾ��<br/><br/>
					Ϊ��ά������������Ϣ��ȫ���������õ������ȣ���ܾ�����<u>���ֺ���թ</u>��Ϊ��������һ��Υ����Ϊ��һ�����ֱؽ���׷���������Ρ�</span></span></p>
                 	<span style="font-size:9.0pt;line-height:150%;font-family:&quot;΢���ź�&quot;,&quot;sans-serif&quot;"><br/>
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					���������Ǫ���ڷ��ڸ���ҵ��ʱ�������˳�ŵ���Գƣ�</span></p>
            </td>
            </tr>
         <tr> <td style="font-size:12px;text-align:left;border-color:white;" class="auto-style1">
             <table style="background-color:#d9d9d9">
                 <tr>
                    <td>
                         <p class=MsoListParagraph align=left style='margin-left:42.3pt;text-align:left;
text-indent:-21.0pt;line-height:150%'><span lang=EN-US style='line-height:150%;
font-family:Wingdings;color:red'>&sup2;<span style='font:7.0pt "Times New Roman"'>&nbsp;
</span></span><b><span style='line-height:
150%;font-family:"΢���ź�","sans-serif";color:red'>�ɹ���������軹��,���豾�˻��������ٻ���</span></b></p>

<p class=MsoListParagraph align=left style='margin-left:42.3pt;text-align:left;
text-indent:-21.0pt;line-height:150%'><span lang=EN-US style='line-height:150%;
font-family:Wingdings;color:red'>&sup2;<span style='font:7.0pt "Times New Roman"'>&nbsp;
</span></span><b><span style='line-height:150%;font-family:"΢���ź�","sans-serif";
color:red'>������˾������ҵ���������ֽ���Ϊ����</span></b></p>

<p class=MsoListParagraph align=left style='margin-left:42.3pt;text-align:left;
text-indent:-21.0pt;line-height:150%'><span lang=EN-US style='line-height:150%;
font-family:Wingdings;color:red'>&sup2;<span style='font:7.0pt "Times New Roman"'>&nbsp;
</span></span><b><span style='line-height:150%;font-family:"΢���ź�","sans-serif";
color:red'>���֤��ʧ��������������ڸ�������ֽ���Ϊ����</span></b></p>

<p class=MsoListParagraph align=left style='margin-left:42.3pt;text-align:left;
text-indent:-21.0pt;line-height:150%'><span lang=EN-US style='line-height:150%;
font-family:Wingdings;color:red'>&sup2;<span style='font:7.0pt "Times New Roman"'>&nbsp;
</span></span><b><span style='line-height:150%;font-family:"΢���ź�","sans-serif";
color:red'>����Ƹ����Ҫ����������ڸ�����Ϊ��ְ����</span></b></p>

<p class=MsoListParagraph align=left style='margin-left:42.3pt;text-align:left;
text-indent:-21.0pt;line-height:150%'><span lang=EN-US style='line-height:150%;
font-family:Wingdings;color:red'>&sup2;<span style='font:7.0pt "Times New Roman"'>&nbsp;
</span></span><b><span style='line-height:150%;font-family:"΢���ź�","sans-serif";
color:red'>��Ӧ�������������ÿ�����������ҵ��</span></b></p>

<p class=MsoListParagraph align=left style='margin-left:42.3pt;text-align:left;
text-indent:-21.0pt;line-height:150%'><span lang=EN-US style='line-height:150%;
font-family:Wingdings;color:red'>&sup2;<span style='font:7.0pt "Times New Roman"'>&nbsp;
</span></span><b><span style='line-height:150%;font-family:"΢���ź�","sans-serif";
color:red'>��Ӧ���������������������̻�������Ա��Ϊ����ȣ�</span></b></p>
                    </td>
                 </tr>
             </table>
</td>
            </tr>
         <tr> <td style="font-size:12px;text-align:left;border-color:white;" class="auto-style1" >
            
                 <span style="font-size:9.0pt;
line-height:150%;font-family:&quot;΢���ź�&quot;,&quot;sans-serif&quot;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<br />
                 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;  
                 	��������������ʱ���������ѱ�������ƭ��������ֹͣ���ڸ������룬�����Ǫ���ڡ��۳ϲƸ��Ĺ�����Ա��ӳ��ͬʱ������թ��<br/><br/>
                 	�ߣ�<b style="mso-bidi-font-weight:normal"><span lang="EN-US" style="color:red">400 998 7105<br />
                 <br /></span></b><span lang="EN-US"><o:p></o:p></span></span>
            </td>
            </tr>
         <tr> <td style="font-size:12px;text-align:left;border-color:white;" class="auto-style1">
             <p class=MsoNormal style='line-height:20.0pt'><span style='position:absolute;
z-index:251658240;left:0px;margin-left:326px;margin-top:198px;width:335px;
height:188px'></span><span
style='font-size:11.0pt;font-family:����'>�ڴ�֣�����ѣ������ʹ�������˵���ʵ��ݼ���ʵ��������������ڸ���緢���ṩ������ϣ���Ǫ���ڡ��۳ϲƸ���������������Ǫ���ڡ��۳ϲƸ�û����Ȩ�κε������������߸������κθ�������Ҫ�����������ҵ����������������׼���밴��ͬԼ���ϸ����л�������������δ������ܵ������������������¼����Ǫ���ڲ��ų������˲��������¼�԰�Ǫ���ڻ��������ڻ��������ϴ�������ϵͳ����ʱ�������������ü�¼�����������ü�¼��Ӱ���������е�����ҵ�������������������ߴ������Ϣ���޷�����ס������������ȣ�����������ر������õĻ����¼�͸������á��������⣬��ֱ�����Ǫ���ڡ��۳ϲƸ��Ĺ���Ա���������̻�Ǣ̸�����ǻ������ȷ��ָ�����򲦴�ͻ��������ߣ�<b>
<span lang="EN-US" style="color:red">400 998 7101<br />
</b></span></p>

<p class=MsoNormal align=right style='margin-right:28.0pt;text-align:right;
line-height:150%'><b><span style='font-size:11.0pt;line-height:150%;font-family:
����'>��Ǫ����&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>

<p class=MsoNormal align=right style='margin-right:28.0pt;text-align:right;
line-height:150%'><b><span style='font-size:11.0pt;line-height:150%;font-family:
����'>�۳ϲƸ�&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>

<p class=MsoNormal align=right style='margin-right:28.0pt;text-align:right;
line-height:150%'><b><span style='font-size:11.0pt;line-height:150%;font-family:
����'>�ͻ�ǩ��:___________</span>

<p class=MsoNormal align=right style='margin-right:28.0pt;text-align:right;
line-height:150%'><b><span style='font-size:11.0pt;line-height:150%;font-family:
����'>����ǩ��:___________</span>

<p class=MsoNormal align=left style='text-align:left;line-height:20.0pt'><span
lang=EN-US style='font-size:11.0pt;font-family:����'>&nbsp;</span></p>

<p class=MsoNormal align=left style='margin-right:28.0pt;text-align:left;
line-height:150%'><b><span style='font-size:11.0pt;line-height:150%;font-family:
����'>�ܾ���թ���ܾ����֣�</span></b></p></b></td></tr></table>

            
            </table>

             </td>
            </tr>
            <br>
            <br>
            <tr> <td>
            <span style="font-size:8 pt;mso-bidi-font-size:11.0pt;font-family:&quot;΢���ź�&quot;,&quot;sans-serif&quot;;
								mso-bidi-font-family:&quot;Times New Roman&quot;;mso-bidi-theme-font:minor-bidi;
								mso-ansi-language:EN-US;mso-fareast-language:ZH-CN;mso-bidi-language:AR-SA">�汾�ţ�J_XF_TY_TY_2016030802</span></b>
            </td><td></td>
            </tr>
        <tr> <td style="font-size:12px;text-align:left;border-color:white;" class="auto-style1"></td><td></td>
            </tr>
        <tr> <td style="font-size:12px;text-align:left;border-color:white;" class="auto-style1">
            </td>
            </tr>
       </tbody> </table>
	</div>
    </form>
</body>
</html>
<%@ include file="/IncludeEnd.jsp"%>