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

            <table style="width:739px"><tr><td><img src="<%=request.getContextPath()%>/FormatDoc/Images/logo2.jpg" /></td><td style="text-align:right">
            <img src="<%=request.getContextPath()%>/FormatDoc/Images//12.jpg" style="width:500px" /></td></tr></table>
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
					���ڣ�����г��ϴ��ڲ�����Աƭȡ���ڴ�������������а�Ǫ���ڷ������޹�˾�����¼�ơ���Ǫ���ڡ����ڴ���<br/><br/>
					ʾ����Ϊ��ά������������Ϣ��ȫ���������õ����ü�¼����ܾ�������թ���һ�����ֱؽ���׷���������Ρ�</span></span></p>
                 	<span style="font-size:9.0pt;line-height:150%;font-family:&quot;΢���ź�&quot;,&quot;sans-serif&quot;"><br/>
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					�����ڰ����Ǫ�����ֽ���ڴ���ʱ�������˳�ŵ���Գƣ�</span></p>
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
color:red'>���֤��ʧ��������������ڴ�������ֽ���Ϊ����</span></b></p>

<p class=MsoListParagraph align=left style='margin-left:42.3pt;text-align:left;
text-indent:-21.0pt;line-height:150%'><span lang=EN-US style='line-height:150%;
font-family:Wingdings;color:red'>&sup2;<span style='font:7.0pt "Times New Roman"'>&nbsp;
</span></span><b><span style='line-height:150%;font-family:"΢���ź�","sans-serif";
color:red'>����Ƹ����Ҫ����������ڴ�����Ϊ��ְ����</span></b></p>

<p class=MsoListParagraph align=left style='margin-left:42.3pt;text-align:left;
text-indent:-21.0pt;line-height:150%'><span lang=EN-US style='line-height:150%;
font-family:Wingdings;color:red'>&sup2;<span style='font:7.0pt "Times New Roman"'>&nbsp;
</span></span><b><span style='line-height:150%;font-family:"΢���ź�","sans-serif";
color:red'>��Ӧ�������������ÿ�����������ҵ��</span></b></p>

<p class=MsoListParagraph align=left style='margin-left:42.3pt;text-align:left;
text-indent:-21.0pt;line-height:150%'><span lang=EN-US style='line-height:150%;
font-family:Wingdings;color:red'>&sup2;<span style='font:7.0pt "Times New Roman"'>&nbsp;
</span></span><b><span style='line-height:150%;font-family:"΢���ź�","sans-serif";
color:red'>��Ӧ����������������������Ա��������Ա��Ϊ����ȣ�</span></b></p>
                    </td>
                 </tr>
             </table>
</td>
            </tr>
         <tr> <td style="font-size:12px;text-align:left;border-color:white;" class="auto-style1" >
            
                 <span style="font-size:9.0pt;
line-height:150%;font-family:&quot;΢���ź�&quot;,&quot;sans-serif&quot;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<br />
                 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;  
                 	��������������ʱ���������Ѿ��ϵ���ƭ��������������˾������Ա��ӳ����ֹͣ��������;ͬʱ�����Ǫ���ڷ���թ��<br/><br/>
                 	�ߣ�<b style="mso-bidi-font-weight:normal"><span lang="EN-US" style="color:black">40099-87-105<br />
                 <br /></span></b><span lang="EN-US"><o:p></o:p></span></span>
            </td>
            </tr>
         <tr> <td style="font-size:12px;text-align:left;border-color:white;" class="auto-style1">
             <span style="font-size:9.0pt;font-family:&quot;΢���ź�&quot;,&quot;sans-serif&quot;;
				mso-bidi-font-family:&quot;Times New Roman&quot;;mso-bidi-theme-font:minor-bidi;
				mso-ansi-language:EN-US;mso-fareast-language:ZH-CN;mso-bidi-language:AR-SA">
				 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; �ڴ˰�Ǫ����֣�����ѣ�<br/><br/>
	             &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;1��	�����ʹ�������˵���ʵ��ݼ���ʵ���������������緢���ṩ������ϣ����ǽ��������������ɹ������Ŵ���<br/>
	             &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;2��	��Ǫ����û����Ȩ�κε������������߸������κθ�������Ҫ������������������������׼���밴��ͬԼ����<br/>
	             &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; �����л�������<br/>
	             &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;3��	�������κ����ʣ���ֱ�����Ǫ���ڵ�Ա��Ǣ̸���򲦴��Ǫ���ڿͻ��������ߣ�
             <span lang="EN-US">40099-87-101</span></span></td>
            </tr>
        <tr> <td style="font-size:12px;text-align:left;border-color:white;" class="auto-style1">
            </td>
            </tr>
        <tr> <td style="font-size:12px;text-align:left;border-color:white; BACKGROUND-REPEAT:no-repeat" class="auto-style2">
            
            <table style="width: 603px"><tr ><td class="auto-style8" ></td>
                <td class="auto-style4">
                    <table style="width: 550px; margin-left: 0px; height: 136px;"><tr><td class="auto-style5">&nbsp;</td><td class="auto-style7">&nbsp;</td>
                    	<td>&nbsp;</td><td class="auto-style3">&nbsp;</td></tr><tr><td class="auto-style5">
                        <p class="MsoNormal">
                            <b style="mso-bidi-font-weight:normal"><span style="font-family:&quot;΢���ź�&quot;,&quot;sans-serif&quot;;color:#833C0B;mso-themecolor:
							accent2;mso-themeshade:128">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
							���ְ�Ǫ����������<span lang="EN-US"><o:p></o:p></span></span></b></p><br />
                        <p class="MsoNormal">
                            <b style="mso-bidi-font-weight:normal">
                            <span style="font-family:&quot;΢���ź�&quot;,&quot;sans-serif&quot;;color:#833C0B;mso-themecolor:accent2;mso-themeshade:128">
                            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                            	�ܾ���թ����������<span lang="EN-US"><o:p></o:p></span></span></b></p>
                        </td><td class="auto-style7">&nbsp;</td><td>
                        <p class="MsoNormal">
                            <b style="mso-bidi-font-weight:normal"><span style="font-family:&quot;΢���ź�&quot;,&quot;sans-serif&quot;">
                            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span></b></p><br /><br />
                        <p class="MsoNormal">
                            <b style="mso-bidi-font-weight:normal"><span style="font-family:&quot;΢���ź�&quot;,&quot;sans-serif&quot;">
                            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span></b></p>
                        </td><td class="auto-style3">
                                <b style="mso-bidi-font-weight:normal"><span style="font-size:11.0pt;
                                	mso-bidi-font-size:9.0pt;font-family:&quot;΢���ź�&quot;,&quot;sans-serif&quot;;
									mso-bidi-font-family:&quot;Times New Roman&quot;;mso-bidi-theme-font:minor-bidi;
									mso-ansi-language:EN-US;mso-fareast-language:ZH-CN;mso-bidi-language:AR-SA">
									&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
									&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
									&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <br />
                                <br />
                                <br />
                                </span></b></td></tr></table>

                </td></tr>
                <tr>
                    <td class="auto-style8">

                    </td>
                     <td class="auto-style4">

                            <b style="mso-bidi-font-weight:normal"><span style="font-family:&quot;΢���ź�&quot;,&quot;sans-serif&quot;">
                            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;
                            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;
                            <span style="font-size:10.5pt;mso-bidi-font-size:11.0pt;font-family:&quot;΢���ź�&quot;,&quot;sans-serif&quot;;
									mso-bidi-font-family:&quot;Times New Roman&quot;;mso-bidi-theme-font:minor-bidi;
									mso-ansi-language:EN-US;mso-fareast-language:ZH-CN;mso-bidi-language:AR-SA">
									�ͻ�ǩ<span lang="EN-US">��:<%=sReplace%></span></span><span lang="EN-US"><o:p><br />
                            <br />
							&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
							&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
							&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
							&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </o:p>
                            </span></span><span style="font-size:10.5pt;mso-bidi-font-size:11.0pt;font-family:&quot;΢���ź�&quot;,&quot;sans-serif&quot;;
								mso-bidi-font-family:&quot;Times New Roman&quot;;mso-bidi-theme-font:minor-bidi;
								mso-ansi-language:EN-US;mso-fareast-language:ZH-CN;mso-bidi-language:AR-SA">����ǩ��<span lang="EN-US">:<%=sReplace_Salesman%></span><span lang="EN-US"><o:p><br />
                            <br />
								&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
								&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
								&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
								&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
								&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
								&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</o:p>
                            </span></span>
							<span style="font-size:10.5pt;mso-bidi-font-size:11.0pt;font-family:&quot;΢���ź�&quot;,&quot;sans-serif&quot;;
								mso-bidi-font-family:&quot;Times New Roman&quot;;mso-bidi-theme-font:minor-bidi;
								mso-ansi-language:EN-US;mso-fareast-language:ZH-CN;mso-bidi-language:AR-SA">����<span lang="EN-US">:</span></span></b></td>
                    </tr>
                
            </table>

             </td>
            </tr>
        <tr> <td style="font-size:12px;text-align:left;border-color:white;" class="auto-style1">
				<img src="<%=request.getContextPath()%>/FormatDoc/Images/34.jpg" style="width:500px; margin-left: 0px;" /></td><td></td>
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