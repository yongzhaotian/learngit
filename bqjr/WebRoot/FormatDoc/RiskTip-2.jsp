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
	  document.all("clearHead").click();//打印之前去掉页眉，页脚  
	  document.getElementById("printClass1").style.display="none"; 
		document.getElementById("printClass2").style.display="none"; 
		document.getElementById("printClass").style.display="none"; 
		document.getElementById("WebBrowser").ExecWB(8,1);
		document.getElementById("printClass1").style.display=""; 
		document.getElementById("printClass2").style.display=""; 
		document.getElementById("printClass").style.display=""; 
		}
  
  function print1(){
	  document.all("clearHead").click();//打印之前去掉页眉，页脚  
		document.getElementById("printClass1").style.display="none"; 
		document.getElementById("printClass2").style.display="none"; 
		document.getElementById("printClass").style.display="none"; 
		document.getElementById("WebBrowser").ExecWB(7,1);
		document.getElementById("printClass1").style.display=""; 
		document.getElementById("printClass2").style.display=""; 
		document.getElementById("printClass").style.display=""; 
		}
  
  function print2(){
	  document.all("clearHead").click();//打印之前去掉页眉，页脚  
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
'//设置网页打印的页眉页脚为空  
function pagesetup_null()  
on error resume next  
Set RegWsh = CreateObject("WScript.Shell")  
hkey_key="\header"  
RegWsh.RegWrite hkey_root+hkey_path+hkey_key,""  
hkey_key="\footer"  
RegWsh.RegWrite hkey_root+hkey_path+hkey_key,""  
end function  
'//设置网页打印的页眉页脚为默认值  
function pagesetup_default()  
on error resume next  
Set RegWsh = CreateObject("WScript.Shell")  
hkey_key="\header"  
RegWsh.RegWrite hkey_root+hkey_path+hkey_key,"&w&b页码，&p/&P"  
hkey_key="\footer"  
RegWsh.RegWrite hkey_root+hkey_path+hkey_key,"&u&b&d"  
end function  
</script> 

</head>
<body>
    <form method="post" action="" id="form1">
    <div>
    
    <input id ="printClass"   type=button value='打印设置' onclick="print()"/>
    <input id ="printClass1"   type= button value='打印预览' onclick="print1()"/> 
    <input id ="printClass2"   type=button value='打印' onclick="print2()"/> 
    
    <input type="hidden" name="clearHead" id="clearHead" class="tab" value="去掉页眉页脚" onclick="pagesetup_null()">  
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
            <b style="mso-bidi-font-weight:normal"><span style="font-size:16.0pt;mso-bidi-font-size:22.0pt;font-family:&quot;微软雅黑&quot;,&quot;sans-serif&quot;;
mso-bidi-font-family:&quot;Times New Roman&quot;;mso-bidi-theme-font:minor-bidi;
mso-ansi-language:EN-US;mso-fareast-language:ZH-CN;mso-bidi-language:AR-SA">反欺诈风险提示</span></b></td>
            </tr>
         <tr> <td style="font-size:12px;text-align:left;border-color:white;">
             <p align="left" class="MsoNormal" style="text-align:left;line-height:150%">
                 <span style="font-size:9.0pt;line-height:150%;font-family:&quot;微软雅黑&quot;,&quot;sans-serif&quot;">尊敬的客户：<span lang="EN-US"><o:p></o:p></span></span></p>
             <p align="left" class="MsoNormal" style="text-align:left;text-indent:18.0pt;
mso-char-indent-count:2.0;line-height:150%">
                 <span class="ca-3"><span style="font-size:9.0pt;line-height:150%;font-family:&quot;微软雅黑&quot;,&quot;sans-serif&quot;;
mso-bidi-font-family:Tahoma;color:black">近期，针对市场上存在不法人员申请分期付款业务进行非法套现的现象，深圳市佰仟金融服务有限公司（以下简称“佰仟金融”）在此提示您为了维护您的自身信息安全，保持良好的信誉度，请拒绝参与<u style="text-underline:thick">套现和欺诈</u>行为。套现是一种违法行为，一经发现必将被追究法律责任。<br></span></span><span lang="EN-US" style="font-size:9.0pt;line-height:150%;font-family:&quot;微软雅黑&quot;,&quot;sans-serif&quot;"><o:p></o:p></span></p>
             <p align="left" class="MsoNormal" style="text-align:left;text-indent:18.0pt;
mso-char-indent-count:2.0;line-height:150%">
                 <span style="font-size:9.0pt;
line-height:150%;font-family:&quot;微软雅黑&quot;,&quot;sans-serif&quot;">如您办理佰仟金融分期付款业务时遇到他人承诺或自称：<br><span lang="EN-US"><o:p></o:p></span></span></p>
            </td>
            </tr>
         <tr> <td style="font-size:12px;text-align:left;border-color:white;">
             <p class="MsoListParagraph" align="left" style="margin-left:42.3pt;text-align:left;
text-indent:-21.0pt;line-height:150%"><span lang="EN-US" style="line-height:150%;
font-family:Wingdings;color:red"><span style="font:7.0pt &quot;Times New Roman&quot;">&nbsp;
</span></span><span style="position:absolute;z-index:251659253;left:0px;
margin-left:7px;margin-top:7px;width:436px;height:239px"><!-- <img width="436" height="239" src="./Images/image003.png"> --></span><b><span style="line-height:
150%;font-family:&quot;微软雅黑&quot;,&quot;sans-serif&quot;;color:red">◇成功办理后无需还款,无需本人还款或可以少还款<span lang="EN-US">, </span>无需本人还款或少还款</span></b></p>

<p class="MsoListParagraph" align="left" style="margin-left:42.3pt;text-align:left;
text-indent:-21.0pt;line-height:150%"><span lang="EN-US" style="line-height:150%;
font-family:Wingdings;color:red"><span style="font:7.0pt &quot;Times New Roman&quot;">&nbsp;
</span></span><b><span style="line-height:150%;font-family:&quot;微软雅黑&quot;,&quot;sans-serif&quot;;
color:red">◇帮助公司冲销售业绩，给您现金作为报酬</span></b></p>

<p class="MsoListParagraph" align="left" style="margin-left:42.3pt;text-align:left;
text-indent:-21.0pt;line-height:150%"><span lang="EN-US" style="line-height:150%;
font-family:Wingdings;color:red"><span style="font:7.0pt &quot;Times New Roman&quot;">&nbsp;
</span></span><b><span style="line-height:150%;font-family:&quot;微软雅黑&quot;,&quot;sans-serif&quot;;
color:red">◇身份证丢失请您帮助办理分期付款，给您现金作为报酬</span></b></p>

<p class="MsoListParagraph" align="left" style="margin-left:42.3pt;text-align:left;
text-indent:-21.0pt;line-height:150%"><span lang="EN-US" style="line-height:150%;
font-family:Wingdings;color:red"><span style="font:7.0pt &quot;Times New Roman&quot;">&nbsp;
</span></span><b><span style="line-height:150%;font-family:&quot;微软雅黑&quot;,&quot;sans-serif&quot;;
color:red">◇以招聘名义要求您办理分期作为入职条件</span></b></p>

<p class="MsoListParagraph" align="left" style="margin-left:42.3pt;text-align:left;
text-indent:-21.0pt;line-height:150%"><span lang="EN-US" style="line-height:150%;
font-family:Wingdings;color:red"><span style="font:7.0pt &quot;Times New Roman&quot;">&nbsp;
</span></span><b><span style="line-height:150%;font-family:&quot;微软雅黑&quot;,&quot;sans-serif&quot;;
color:red">◇答应给您办理大额信用卡或其它贷款业务</span></b></p>

<p class="MsoListParagraph" align="left" style="margin-left:42.3pt;text-align:left;
text-indent:-21.0pt;line-height:150%"><span lang="EN-US" style="line-height:150%;
font-family:Wingdings;color:red"><span style="font:7.0pt &quot;Times New Roman&quot;">&nbsp;
</span></span><b><span style="line-height:150%;font-family:&quot;微软雅黑&quot;,&quot;sans-serif&quot;;
color:red">◇答应代您还款的情况（如零售商或销售人员代为还款等）</span></b></p>

</td>
            </tr>
         <tr> <td style="font-size:12px;text-align:left;border-color:white;text-indent: 18px;">
             <p align="left" class="MsoNormal">
                 <span style="font-size:9.0pt;
line-height:150%;font-family:&quot;微软雅黑&quot;,&quot;sans-serif&quot;">当出现以上情形时，您可能已被他人欺骗，请立即停止分期付款申请，并向我司工作人员反映，同时拨打佰仟金融反欺诈热线：<b style="mso-bidi-font-weight:normal"><span lang="EN-US" style="color:red">40099-87-105<br><br></span></b><span lang="EN-US"><o:p></o:p></span></span></p>
            </td>
            </tr>
         <tr> <td style="font-size:12px;text-align:left;border-color:white;text-indent: 18px;">
             <span style="font-size:9.0pt;font-family:&quot;微软雅黑&quot;,&quot;sans-serif&quot;;
mso-bidi-font-family:&quot;Times New Roman&quot;;mso-bidi-theme-font:minor-bidi;
mso-ansi-language:EN-US;mso-fareast-language:ZH-CN;mso-bidi-language:AR-SA">在此郑重提醒，请务必使用您本人的真实身份及真实个人资料申请分期付款，如发现提供虚假资料，我司将立即报警。佰仟金融没有授权任何第三方机构或者个人以任何附加理由要求您办理分期业务。如您的申请获得批准，请按合同约定严格履行还款义务。如有问题，请直接与佰仟金融的员工及合作商户洽谈，他们会给您正确的指引，或拨打佰仟金融客户服务热线：<span lang="EN-US">40099-87-101</span>。</span></td>
            </tr>
        <tr> <td style="font-size:12px;text-align:left;border-color:white;">
            </td>
            </tr>
        <tr> <td style="font-size:12px;text-align:left;border-color:white;background-image:url(./Images/image004.jpg);height:200px;BACKGROUND-REPEAT:no-repeat">
            
            <table><tbody><tr><td><img src="./Images/image006.jpg"></td>
                <td>
                    <table><tbody><tr><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td><b style="mso-bidi-font-weight:normal"><span style="font-size:11.0pt;mso-bidi-font-size:9.0pt;font-family:&quot;微软雅黑&quot;,&quot;sans-serif&quot;;
mso-bidi-font-family:&quot;Times New Roman&quot;;mso-bidi-theme-font:minor-bidi;
mso-ansi-language:EN-US;mso-fareast-language:ZH-CN;mso-bidi-language:AR-SA">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;佰仟金融<br><br></span></b></td></tr><tr><td>
                        <p class="MsoNormal">
                            <b style="mso-bidi-font-weight:
normal"><span style="font-family:&quot;微软雅黑&quot;,&quot;sans-serif&quot;;color:#833C0B;mso-themecolor:
accent2;mso-themeshade:128">快乐佰仟，快乐申请<span lang="EN-US"><o:p></o:p></span></span></b></p>
                        <p class="MsoNormal">
                            <b style="mso-bidi-font-weight:
normal"><span style="font-family:&quot;微软雅黑&quot;,&quot;sans-serif&quot;;color:#833C0B;mso-themecolor:
accent2;mso-themeshade:128">拒绝欺诈，拒绝套现！<span lang="EN-US"><o:p></o:p></span></span></b></p>
                        </td><td>&nbsp;</td><td>
                        <p class="MsoNormal">
                            <b style="mso-bidi-font-weight:normal"><span style="font-family:&quot;微软雅黑&quot;,&quot;sans-serif&quot;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;客户签字<span lang="EN-US"><o:p></o:p></span></span></b></p><br><br>
                        <p class="MsoNormal">
                            <b style="mso-bidi-font-weight:normal"><span style="font-family:&quot;微软雅黑&quot;,&quot;sans-serif&quot;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;销售签字<span lang="EN-US"><o:p></o:p></span></span></b></p>
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