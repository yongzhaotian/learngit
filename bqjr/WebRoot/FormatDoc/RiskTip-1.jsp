<%@ page language="java" contentType="text/html; charset=GBK " %>
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

</head>
<body>
    <form method="post" action="" id="form1">
    <div>
    
    <input id ="printClass"   type=button value='��ӡ����' onclick="print()"/>
    <input id ="printClass1"   type= button value='��ӡԤ��' onclick="print1()"/> 
    <input id ="printClass2"   type=button value='��ӡ' onclick="print2()"/> 
    
    <input type="hidden" name="clearHead" id="clearHead" class="tab" value="ȥ��ҳüҳ��" onclick="pagesetup_null()">  
    </div>
    <div>
        <OBJECT  id="WebBrowser"  classid=CLSID:8856F961-340A-11D0-A96B-00C04FD705A2  height=0  width=0>
    </OBJECT>
    <table style="width:739px">
        <tbody><tr> <td style="font-size:12px;text-align:left;border-color:white;">
            <img src="./Images/image001.png"><img src="./Images/logo2.jpg">
             </td>
        </tr>
        <tr> <td style="font-size:12px;text-align:center;border-color:white;">
            <b style="mso-bidi-font-weight:normal"><span style="font-size:16.0pt;mso-bidi-font-size:22.0pt;font-family:&quot;΢���ź�&quot;,&quot;sans-serif&quot;;
mso-bidi-font-family:&quot;Times New Roman&quot;;mso-bidi-theme-font:minor-bidi;
mso-ansi-language:EN-US;mso-fareast-language:ZH-CN;mso-bidi-language:AR-SA">����թ������ʾ</span></b></td>
            </tr>
         <tr> <td style="font-size:12px;text-align:left;border-color:white;">
             <p align="left" class="MsoNormal" style="text-align:left;line-height:150%">
                 <span style="font-size:9.0pt;line-height:150%;font-family:&quot;΢���ź�&quot;,&quot;sans-serif&quot;">�𾴵Ŀͻ���<span lang="EN-US"><o:p></o:p></span></span></p>
             <p align="left" class="MsoNormal" style="text-align:left;text-indent:18.0pt;
mso-char-indent-count:2.0;line-height:150%">
                 <span class="ca-3"><span style="font-size:9.0pt;line-height:150%;font-family:&quot;΢���ź�&quot;,&quot;sans-serif&quot;;
mso-bidi-font-family:Tahoma;color:black">���ڣ������<u style="text-underline:thick">����</u>��Ա�Ƿ��������ҵ����˾�Ѷ�<u style="text-underline:thick">����</u>������Ա������ȡ֤������Ϊ��ά������������Ϣ��ȫ�ͱ������õ����Ŷȣ�<br>��ž�����<u style="text-underline:thick">���ֺ���թ</u>��Ϊ��<br></span></span><span lang="EN-US" style="font-size:9.0pt;line-height:150%;font-family:&quot;΢���ź�&quot;,&quot;sans-serif&quot;"><o:p></o:p></span></p>
             <p align="left" class="MsoNormal" style="text-align:left;text-indent:18.0pt;
mso-char-indent-count:2.0;line-height:150%">
                 <span style="font-size:9.0pt;
line-height:150%;font-family:&quot;΢���ź�&quot;,&quot;sans-serif&quot;"><br>��Ǫ������ʾ�������������Ǫ����ҵ��ʱ����������ŵ��ѳƣ�<br><span lang="EN-US"><o:p></o:p></span></span></p>
            </td>
            </tr>
         <tr> <td style="font-size:12px;text-align:left;border-color:white;">
             <p class="MsoListParagraph" align="left" style="margin-left:42.3pt;text-align:left;
text-indent:-21.0pt;line-height:150%"><span lang="EN-US" style="line-height:150%;
font-family:Wingdings;color:red"><span style="font:7.0pt &quot;Times New Roman&quot;">&nbsp;
</span></span><span style="position:absolute;z-index:251659253;left:0px;
margin-left:7px;margin-top:7px;width:436px;height:239px"><!-- <img width="436" height="239" src="./Images/image003.png"> --></span><b><span style="line-height:
150%;font-family:&quot;΢���ź�&quot;,&quot;sans-serif&quot;;color:red">��ѳƳɹ���������軹��<span lang="EN-US">, </span>���豾�˻�����ٻ���</span></b></p>

<p class="MsoListParagraph" align="left" style="margin-left:42.3pt;text-align:left;
text-indent:-21.0pt;line-height:150%"><span lang="EN-US" style="line-height:150%;
font-family:Wingdings;color:red"><span style="font:7.0pt &quot;Times New Roman&quot;">&nbsp;
</span></span><b><span style="line-height:150%;font-family:&quot;΢���ź�&quot;,&quot;sans-serif&quot;;
color:red">�������˾������ҵ���������ֽ���Ϊ����</span></b></p>

<p class="MsoListParagraph" align="left" style="margin-left:42.3pt;text-align:left;
text-indent:-21.0pt;line-height:150%"><span lang="EN-US" style="line-height:150%;
font-family:Wingdings;color:red"><span style="font:7.0pt &quot;Times New Roman&quot;">&nbsp;
</span></span><b><span style="line-height:150%;font-family:&quot;΢���ź�&quot;,&quot;sans-serif&quot;;
color:red">��ѳ����֤��ʧ��������������ڣ������ֽ���Ϊ����</span></b></p>

<p class="MsoListParagraph" align="left" style="margin-left:42.3pt;text-align:left;
text-indent:-21.0pt;line-height:150%"><span lang="EN-US" style="line-height:150%;
font-family:Wingdings;color:red"><span style="font:7.0pt &quot;Times New Roman&quot;">&nbsp;
</span></span><b><span style="line-height:150%;font-family:&quot;΢���ź�&quot;,&quot;sans-serif&quot;;
color:red">������Ƹ����Ҫ�������������Ϊ��ְ����</span></b></p>

<p class="MsoListParagraph" align="left" style="margin-left:42.3pt;text-align:left;
text-indent:-21.0pt;line-height:150%"><span lang="EN-US" style="line-height:150%;
font-family:Wingdings;color:red"><span style="font:7.0pt &quot;Times New Roman&quot;">&nbsp;
</span></span><b><span style="line-height:150%;font-family:&quot;΢���ź�&quot;,&quot;sans-serif&quot;;
color:red">���Ӧ�������������ÿ�����������ҵ��</span></b></p>

<p class="MsoListParagraph" align="left" style="margin-left:42.3pt;text-align:left;
text-indent:-21.0pt;line-height:150%"><span lang="EN-US" style="line-height:150%;
font-family:Wingdings;color:red"><span style="font:7.0pt &quot;Times New Roman&quot;">&nbsp;
</span></span><b><span style="line-height:150%;font-family:&quot;΢���ź�&quot;,&quot;sans-serif&quot;;
color:red">���Ӧ���������������������̻�������Ա��Ϊ����ȣ�</span></b></p>

</td>
            </tr>
         <tr> <td style="font-size:12px;text-align:left;border-color:white;">
             <p align="left" class="MsoNormal">
                 <span style="font-size:9.0pt;
line-height:150%;font-family:&quot;΢���ź�&quot;,&quot;sans-serif&quot;">��������������ʱ���������ѱ�������ƭ��������ֹͣ�������룬������˾������Ա��ӳ��ͬʱ�����Ǫ����թ���ߣ�<b style="mso-bidi-font-weight:normal"><span lang="EN-US" style="color:red">40099-87-105<br><br></span></b><span lang="EN-US"><o:p></o:p></span></span></p>
            </td>
            </tr>
         <tr> <td style="font-size:12px;text-align:left;border-color:white;">
             <span style="font-size:9.0pt;font-family:&quot;΢���ź�&quot;,&quot;sans-serif&quot;;
mso-bidi-font-family:&quot;Times New Roman&quot;;mso-bidi-theme-font:minor-bidi;
mso-ansi-language:EN-US;mso-fareast-language:ZH-CN;mso-bidi-language:AR-SA">�ڴ�֣�����ѣ������ʹ�������˵���ʵ��ݼ���ʵ��������������ڸ�����з���������ϣ���˾��������������Ǫ����û����Ȩ�κ�<br><br>�������������߸������κθ�������Ҫ�����������ҵ����������������׼���밴��ͬԼ���ϸ����л��������������⣬��ֱ����<br><br>��Ǫ���ڵ�Ա���������̻�Ǣ̸�����ǻ������ȷ��ָ�����򲦴��Ǫ�ͻ��������ߣ�<span lang="EN-US">40099-87-101</span></span></td>
            </tr>
        <tr> <td style="font-size:12px;text-align:left;border-color:white;">
            </td>
            </tr>
        <tr> <td style="font-size:12px;text-align:left;border-color:white;background-image:url(./Images/image004.jpg);height:200px;BACKGROUND-REPEAT:no-repeat">
            
            <table><tbody><tr><td><img src="./Images/image006.jpg"></td>
                <td>
                    <table><tbody><tr><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td><b style="mso-bidi-font-weight:normal"><span style="font-size:11.0pt;mso-bidi-font-size:9.0pt;font-family:&quot;΢���ź�&quot;,&quot;sans-serif&quot;;
mso-bidi-font-family:&quot;Times New Roman&quot;;mso-bidi-theme-font:minor-bidi;
mso-ansi-language:EN-US;mso-fareast-language:ZH-CN;mso-bidi-language:AR-SA">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;��Ǫ���ڰ�ȫ��<br><br></span></b></td></tr><tr><td>
                        <p class="MsoNormal">
                            <b style="mso-bidi-font-weight:
normal"><span style="font-family:&quot;΢���ź�&quot;,&quot;sans-serif&quot;;color:#833C0B;mso-themecolor:
accent2;mso-themeshade:128">���ְ�Ǫ����������<span lang="EN-US"><o:p></o:p></span></span></b></p>
                        <p class="MsoNormal">
                            <b style="mso-bidi-font-weight:
normal"><span style="font-family:&quot;΢���ź�&quot;,&quot;sans-serif&quot;;color:#833C0B;mso-themecolor:
accent2;mso-themeshade:128">�ܾ���թ���ܾ����֣�<span lang="EN-US"><o:p></o:p></span></span></b></p>
                        </td><td>&nbsp;</td><td>
                        <p class="MsoNormal">
                            <b style="mso-bidi-font-weight:normal"><span style="font-family:&quot;΢���ź�&quot;,&quot;sans-serif&quot;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;�ͻ�ǩ��<span lang="EN-US"><o:p></o:p></span></span></b></p><br><br>
                        <p class="MsoNormal">
                            <b style="mso-bidi-font-weight:normal"><span style="font-family:&quot;΢���ź�&quot;,&quot;sans-serif&quot;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;����ǩ��<span lang="EN-US"><o:p></o:p></span></span></b></p>
                        </td><td>
                            &nbsp;</td></tr></tbody></table>

                </td></tr></tbody></table>

             </td>
            </tr>
        <tr> <td style="font-size:12px;text-align:left;border-color:white;">
            </td>
            </tr>
        <tr> <td style="font-size:12px;text-align:left;border-color:white;">
            </td>
            </tr>
        </tbody></table>
       
    </div>
    </form>
</body>
</html>