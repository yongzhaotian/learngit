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
<% 
	//add by daihuafeng,如果业务来源是APP则替换为签名图片URL地址,非APP来源则不替换,20150708
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectNo")); 	
	//业务来源
	String sSureType = Sqlca.getString("select bc.SureType from business_contract bc where bc.serialno='"+sObjectNo+"'");
	//签名图片URL地址
	String sInterfaceAddressPort = Sqlca.getString("select ITEMDESCRIBE from code_library where codeno='InterfaceAddressPort' and itemno='010' and isinuse='1'");
	String sPath = "<img src='http://"+sInterfaceAddressPort+"/mbqjr/contract/getcustomersign?serialno="+sObjectNo+"' width='100' height='30'/>";
	String sPath_Salesman = "<img src='http://"+sInterfaceAddressPort+"/mbqjr/contract/getSignatureSales?serialno="+sObjectNo+"' width='100' height='30'/>";
	//如果业务来源是APP则替换为签名图片URL地址,非APP来源则不替换
	String sReplace = "";
	String sReplace_Salesman = "";
	//如果业务来源是APP则替换为签名图片URL地址,非APP来源则不替换
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
    
    <input id ="printClass"   type="button" value='打印设置' onclick="print()"/>
    <input id ="printClass1"   type= "button" value='打印预览' onclick="print1()"/> 
    <input id ="printClass2"   type="button" value='打印' onclick="print2()"/> 
    
    <input type="hidden" name="clearHead" id="clearHead" class="tab" value="去掉页眉页脚" onclick="pagesetup_null()">  
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
            <b style="mso-bidi-font-weight:normal"><span style="font-size:16.0pt;mso-bidi-font-size:22.0pt;font-family:&quot;微软雅黑&quot;,&quot;sans-serif&quot;;
mso-bidi-font-family:&quot;Times New Roman&quot;;mso-bidi-theme-font:minor-bidi;
mso-ansi-language:EN-US;mso-fareast-language:ZH-CN;mso-bidi-language:AR-SA">反欺诈风险提示</span></b></td>
            </tr>
         <tr> <td style="font-size:12px;text-align:left;border-color:white;" class="auto-style2">
             <p align="left" class="MsoNormal" style="text-align:left;line-height:150%">
                 <span style="font-size:9.0pt;line-height:150%;font-family:&quot;微软雅黑&quot;,&quot;sans-serif&quot;">尊敬的客户：<span lang="EN-US"><o:p></o:p></span></span></p>
             <p align="left" class="MsoNormal" style="text-align:left;text-indent:18.0pt;
mso-char-indent-count:2.0;line-height:150%; width: 714px;">
                 <span class="ca-3">
                 <span style="font-size:9.0pt;line-height:150%;font-family:&quot;微软雅黑&quot;,&quot;sans-serif&quot;;
					mso-bidi-font-family:Tahoma;color:black"><br/>
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					近期，针对市场上存在不法人员申请分期付款业务进行非法套现的现象，深圳市佰仟金融服务有限公司（以下简称“佰仟金融”）、北京聚诚财富资产管理有限公司（以下简称”聚诚财富“）在此提示您<br/><br/>
					为了维护您的自身信息安全，保持良好的信誉度，请拒绝参与<u>套现和欺诈</u>行为。套现是一种违法行为，一经发现必将被追究法律责任。</span></span></p>
                 	<span style="font-size:9.0pt;line-height:150%;font-family:&quot;微软雅黑&quot;,&quot;sans-serif&quot;"><br/>
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					如您办理佰仟金融分期付款业务时遇到他人承诺或自称：</span></p>
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
150%;font-family:"微软雅黑","sans-serif";color:red'>成功办理后无需还款,无需本人还款或可以少还款</span></b></p>

<p class=MsoListParagraph align=left style='margin-left:42.3pt;text-align:left;
text-indent:-21.0pt;line-height:150%'><span lang=EN-US style='line-height:150%;
font-family:Wingdings;color:red'>&sup2;<span style='font:7.0pt "Times New Roman"'>&nbsp;
</span></span><b><span style='line-height:150%;font-family:"微软雅黑","sans-serif";
color:red'>帮助公司冲销售业绩，给您现金作为报酬</span></b></p>

<p class=MsoListParagraph align=left style='margin-left:42.3pt;text-align:left;
text-indent:-21.0pt;line-height:150%'><span lang=EN-US style='line-height:150%;
font-family:Wingdings;color:red'>&sup2;<span style='font:7.0pt "Times New Roman"'>&nbsp;
</span></span><b><span style='line-height:150%;font-family:"微软雅黑","sans-serif";
color:red'>身份证丢失请您帮助办理分期付款，给您现金作为报酬</span></b></p>

<p class=MsoListParagraph align=left style='margin-left:42.3pt;text-align:left;
text-indent:-21.0pt;line-height:150%'><span lang=EN-US style='line-height:150%;
font-family:Wingdings;color:red'>&sup2;<span style='font:7.0pt "Times New Roman"'>&nbsp;
</span></span><b><span style='line-height:150%;font-family:"微软雅黑","sans-serif";
color:red'>以招聘名义要求您办理分期付款作为入职条件</span></b></p>

<p class=MsoListParagraph align=left style='margin-left:42.3pt;text-align:left;
text-indent:-21.0pt;line-height:150%'><span lang=EN-US style='line-height:150%;
font-family:Wingdings;color:red'>&sup2;<span style='font:7.0pt "Times New Roman"'>&nbsp;
</span></span><b><span style='line-height:150%;font-family:"微软雅黑","sans-serif";
color:red'>答应给您办理大额信用卡或其它贷款业务</span></b></p>

<p class=MsoListParagraph align=left style='margin-left:42.3pt;text-align:left;
text-indent:-21.0pt;line-height:150%'><span lang=EN-US style='line-height:150%;
font-family:Wingdings;color:red'>&sup2;<span style='font:7.0pt "Times New Roman"'>&nbsp;
</span></span><b><span style='line-height:150%;font-family:"微软雅黑","sans-serif";
color:red'>答应代您还款的情况（如零售商或销售人员代为还款等）</span></b></p>
                    </td>
                 </tr>
             </table>
</td>
            </tr>
         <tr> <td style="font-size:12px;text-align:left;border-color:white;" class="auto-style1" >
            
                 <span style="font-size:9.0pt;
line-height:150%;font-family:&quot;微软雅黑&quot;,&quot;sans-serif&quot;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<br />
                 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;  
                 	当出现以上情形时，您可能已被他人欺骗，请立即停止分期付款申请，并向佰仟金融、聚诚财富的工作人员反映，同时拨打反欺诈热<br/><br/>
                 	线：<b style="mso-bidi-font-weight:normal"><span lang="EN-US" style="color:red">400 998 7105<br />
                 <br /></span></b><span lang="EN-US"><o:p></o:p></span></span>
            </td>
            </tr>
         <tr> <td style="font-size:12px;text-align:left;border-color:white;" class="auto-style1">
             <p class=MsoNormal style='line-height:20.0pt'><span style='position:absolute;
z-index:251658240;left:0px;margin-left:326px;margin-top:198px;width:335px;
height:188px'></span><span
style='font-size:9.0pt;font-family:微软雅黑'>在此郑重提醒，请务必使用您本人的真实身份及真实个人资料申请分期付款，如发现提供虚假资料，佰仟金融、聚诚财富将立即报警。佰仟金融、聚诚财富没有授权任何第三方机构或者个人以任何附加理由要求您办理分期业务。如您的申请获得批准，请按合同约定严格履行还款义务。如逾期未还款将可能导致您产生不良还款记录，佰仟金融不排除将个人不良还款记录以佰仟金融或其他金融机构名义上传至征信系统，届时将产生不良信用记录，不良的信用记录将影响您在银行的所有业务办理，包括但不限于提高贷款的利息、无法办理住房、购车贷款等，所以请您务必保持良好的还款记录和个人信用。如有问题，请直接与佰仟金融、聚诚财富的工作员工及合作商户洽谈，他们会给您正确的指引，或拨打客户服务热线：<b>
<span lang="EN-US" style="color:red"><b>400 998 7101</b><br />
</b></span></p>

<p class=MsoNormal align=right style='margin-right:28.0pt;text-align:right;
line-height:150%'><b><span style='font-size:9.0pt;line-height:150%;font-family:
微软雅黑'>佰仟金融&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</b></span>

<p class=MsoNormal align=right style='margin-right:28.0pt;text-align:right;
line-height:150%'><b><span style='font-size:9.0pt;line-height:150%;font-family:
微软雅黑'>聚诚财富&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</b></span>

<p class=MsoNormal align=right style='margin-right:28.0pt;text-align:right;
line-height:150%'><span style='font-size:9.0pt;line-height:150%;font-family:
微软雅黑'>客户签字:___________</span>

<p class=MsoNormal align=right style='margin-right:28.0pt;text-align:right;
line-height:150%'><span style='font-size:9.0pt;line-height:150%;font-family:
微软雅黑'>销售签字:___________</span>

<p class=MsoNormal align=left style='text-align:left;line-height:20.0pt'><span
lang=EN-US style='font-size:11.0pt;font-family:微软雅黑'>&nbsp;</span></p>

<p class=MsoNormal align=left style='margin-right:28.0pt;text-align:left;
line-height:150%'><b><span style='font-size:9.0pt;line-height:150%;font-family:
微软雅黑'>拒绝欺诈，拒绝套现！</span></b></p></b></td></tr></table>

            
            </table>

             </td>
            </tr>
            <br>
            <br>
            <tr> <td>
            <span style="font-size:8 pt;mso-bidi-font-size:11.0pt;font-family:&quot;微软雅黑&quot;,&quot;sans-serif&quot;;
								mso-bidi-font-family:&quot;Times New Roman&quot;;mso-bidi-theme-font:minor-bidi;
								mso-ansi-language:EN-US;mso-fareast-language:ZH-CN;mso-bidi-language:AR-SA">版本号：J_XF_TY_TY_2016030802</span></b>
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
<% 
	//add by daihuafeng,如果业务来源是APP则替换为签名图片URL地址,非APP来源则不替换,20150708
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectNo")); 	
	//业务来源
	String sSureType = Sqlca.getString("select bc.SureType from business_contract bc where bc.serialno='"+sObjectNo+"'");
	//签名图片URL地址
	String sInterfaceAddressPort = Sqlca.getString("select ITEMDESCRIBE from code_library where codeno='InterfaceAddressPort' and itemno='010' and isinuse='1'");
	String sPath = "<img src='http://"+sInterfaceAddressPort+"/mbqjr/contract/getcustomersign?serialno="+sObjectNo+"' width='100' height='30'/>";
	String sPath_Salesman = "<img src='http://"+sInterfaceAddressPort+"/mbqjr/contract/getSignatureSales?serialno="+sObjectNo+"' width='100' height='30'/>";
	//如果业务来源是APP则替换为签名图片URL地址,非APP来源则不替换
	String sReplace = "";
	String sReplace_Salesman = "";
	//如果业务来源是APP则替换为签名图片URL地址,非APP来源则不替换
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
    
    <input id ="printClass"   type="button" value='打印设置' onclick="print()"/>
    <input id ="printClass1"   type= "button" value='打印预览' onclick="print1()"/> 
    <input id ="printClass2"   type="button" value='打印' onclick="print2()"/> 
    
    <input type="hidden" name="clearHead" id="clearHead" class="tab" value="去掉页眉页脚" onclick="pagesetup_null()">  
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
            <b style="mso-bidi-font-weight:normal"><span style="font-size:16.0pt;mso-bidi-font-size:22.0pt;font-family:&quot;微软雅黑&quot;,&quot;sans-serif&quot;;
mso-bidi-font-family:&quot;Times New Roman&quot;;mso-bidi-theme-font:minor-bidi;
mso-ansi-language:EN-US;mso-fareast-language:ZH-CN;mso-bidi-language:AR-SA">反欺诈风险提示</span></b></td>
            </tr>
         <tr> <td style="font-size:12px;text-align:left;border-color:white;" class="auto-style2">
             <p align="left" class="MsoNormal" style="text-align:left;line-height:150%">
                 <span style="font-size:9.0pt;line-height:150%;font-family:&quot;微软雅黑&quot;,&quot;sans-serif&quot;">尊敬的客户：<span lang="EN-US"><o:p></o:p></span></span></p>
             <p align="left" class="MsoNormal" style="text-align:left;text-indent:18.0pt;
mso-char-indent-count:2.0;line-height:150%; width: 714px;">
                 <span class="ca-3">
                 <span style="font-size:9.0pt;line-height:150%;font-family:&quot;微软雅黑&quot;,&quot;sans-serif&quot;;
					mso-bidi-font-family:Tahoma;color:black"><br/>
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					近期，针对市场上存在不法人员申请分期付款业务进行非法套现的现象，深圳市佰仟金融服务有限公司（以下简称“佰仟金融”）、北京聚诚财富资产管理有限公司（以下简称”聚诚财富“）在此提示您<br/><br/>
					为了维护您的自身信息安全，保持良好的信誉度，请拒绝参与<u>套现和欺诈</u>行为。套现是一种违法行为，一经发现必将被追究法律责任。</span></span></p>
                 	<span style="font-size:9.0pt;line-height:150%;font-family:&quot;微软雅黑&quot;,&quot;sans-serif&quot;"><br/>
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					如您办理佰仟金融分期付款业务时遇到他人承诺或自称：</span></p>
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
150%;font-family:"微软雅黑","sans-serif";color:red'>成功办理后无需还款,无需本人还款或可以少还款</span></b></p>

<p class=MsoListParagraph align=left style='margin-left:42.3pt;text-align:left;
text-indent:-21.0pt;line-height:150%'><span lang=EN-US style='line-height:150%;
font-family:Wingdings;color:red'>&sup2;<span style='font:7.0pt "Times New Roman"'>&nbsp;
</span></span><b><span style='line-height:150%;font-family:"微软雅黑","sans-serif";
color:red'>帮助公司冲销售业绩，给您现金作为报酬</span></b></p>

<p class=MsoListParagraph align=left style='margin-left:42.3pt;text-align:left;
text-indent:-21.0pt;line-height:150%'><span lang=EN-US style='line-height:150%;
font-family:Wingdings;color:red'>&sup2;<span style='font:7.0pt "Times New Roman"'>&nbsp;
</span></span><b><span style='line-height:150%;font-family:"微软雅黑","sans-serif";
color:red'>身份证丢失请您帮助办理分期付款，给您现金作为报酬</span></b></p>

<p class=MsoListParagraph align=left style='margin-left:42.3pt;text-align:left;
text-indent:-21.0pt;line-height:150%'><span lang=EN-US style='line-height:150%;
font-family:Wingdings;color:red'>&sup2;<span style='font:7.0pt "Times New Roman"'>&nbsp;
</span></span><b><span style='line-height:150%;font-family:"微软雅黑","sans-serif";
color:red'>以招聘名义要求您办理分期付款作为入职条件</span></b></p>

<p class=MsoListParagraph align=left style='margin-left:42.3pt;text-align:left;
text-indent:-21.0pt;line-height:150%'><span lang=EN-US style='line-height:150%;
font-family:Wingdings;color:red'>&sup2;<span style='font:7.0pt "Times New Roman"'>&nbsp;
</span></span><b><span style='line-height:150%;font-family:"微软雅黑","sans-serif";
color:red'>答应给您办理大额信用卡或其它贷款业务</span></b></p>

<p class=MsoListParagraph align=left style='margin-left:42.3pt;text-align:left;
text-indent:-21.0pt;line-height:150%'><span lang=EN-US style='line-height:150%;
font-family:Wingdings;color:red'>&sup2;<span style='font:7.0pt "Times New Roman"'>&nbsp;
</span></span><b><span style='line-height:150%;font-family:"微软雅黑","sans-serif";
color:red'>答应代您还款的情况（如零售商或销售人员代为还款等）</span></b></p>
                    </td>
                 </tr>
             </table>
</td>
            </tr>
         <tr> <td style="font-size:12px;text-align:left;border-color:white;" class="auto-style1" >
            
                 <span style="font-size:9.0pt;
line-height:150%;font-family:&quot;微软雅黑&quot;,&quot;sans-serif&quot;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<br />
                 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;  
                 	当出现以上情形时，您可能已被他人欺骗，请立即停止分期付款申请，并向佰仟金融、聚诚财富的工作人员反映，同时拨打反欺诈热<br/><br/>
                 	线：<b style="mso-bidi-font-weight:normal"><span lang="EN-US" style="color:red">400 998 7105<br />
                 <br /></span></b><span lang="EN-US"><o:p></o:p></span></span>
            </td>
            </tr>
         <tr> <td style="font-size:12px;text-align:left;border-color:white;" class="auto-style1">
             <p class=MsoNormal style='line-height:20.0pt'><span style='position:absolute;
z-index:251658240;left:0px;margin-left:326px;margin-top:198px;width:335px;
height:188px'></span><span
style='font-size:11.0pt;font-family:宋体'>在此郑重提醒，请务必使用您本人的真实身份及真实个人资料申请分期付款，如发现提供虚假资料，佰仟金融、聚诚财富将立即报警。佰仟金融、聚诚财富没有授权任何第三方机构或者个人以任何附加理由要求您办理分期业务。如您的申请获得批准，请按合同约定严格履行还款义务。如逾期未还款将可能导致您产生不良还款记录，佰仟金融不排除将个人不良还款记录以佰仟金融或其他金融机构名义上传至征信系统，届时将产生不良信用记录，不良的信用记录将影响您在银行的所有业务办理，包括但不限于提高贷款的利息、无法办理住房、购车贷款等，所以请您务必保持良好的还款记录和个人信用。如有问题，请直接与佰仟金融、聚诚财富的工作员工及合作商户洽谈，他们会给您正确的指引，或拨打客户服务热线：<b>
<span lang="EN-US" style="color:red">400 998 7101<br />
</b></span></p>

<p class=MsoNormal align=right style='margin-right:28.0pt;text-align:right;
line-height:150%'><b><span style='font-size:11.0pt;line-height:150%;font-family:
宋体'>佰仟金融&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>

<p class=MsoNormal align=right style='margin-right:28.0pt;text-align:right;
line-height:150%'><b><span style='font-size:11.0pt;line-height:150%;font-family:
宋体'>聚诚财富&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>

<p class=MsoNormal align=right style='margin-right:28.0pt;text-align:right;
line-height:150%'><b><span style='font-size:11.0pt;line-height:150%;font-family:
宋体'>客户签字:___________</span>

<p class=MsoNormal align=right style='margin-right:28.0pt;text-align:right;
line-height:150%'><b><span style='font-size:11.0pt;line-height:150%;font-family:
宋体'>销售签字:___________</span>

<p class=MsoNormal align=left style='text-align:left;line-height:20.0pt'><span
lang=EN-US style='font-size:11.0pt;font-family:宋体'>&nbsp;</span></p>

<p class=MsoNormal align=left style='margin-right:28.0pt;text-align:left;
line-height:150%'><b><span style='font-size:11.0pt;line-height:150%;font-family:
宋体'>拒绝欺诈，拒绝套现！</span></b></p></b></td></tr></table>

            
            </table>

             </td>
            </tr>
            <br>
            <br>
            <tr> <td>
            <span style="font-size:8 pt;mso-bidi-font-size:11.0pt;font-family:&quot;微软雅黑&quot;,&quot;sans-serif&quot;;
								mso-bidi-font-family:&quot;Times New Roman&quot;;mso-bidi-theme-font:minor-bidi;
								mso-ansi-language:EN-US;mso-fareast-language:ZH-CN;mso-bidi-language:AR-SA">版本号：J_XF_TY_TY_2016030802</span></b>
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