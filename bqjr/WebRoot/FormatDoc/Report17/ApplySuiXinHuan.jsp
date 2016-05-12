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
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectNo")); 
	String sql = "select suretype,isp2p,salesexecutive,getuserName(salesexecutive) as salesexecutiveName " + 
		" from business_contract where serialno='"+sObjectNo+"'";

	String customerSignUrl = CodeCache.getItem("SignAppUrl","0030").getItemAttribute();
	String salesmanSignUrl = CodeCache.getItem("SignAppUrl","0040").getItemAttribute();
	String appBorrowerSign = "&nbsp;<img src='"+customerSignUrl+sObjectNo+"' width='100' height='30'/>";
	String appSalesmanSign = "&nbsp;<img src='"+salesmanSignUrl+sObjectNo+"' width='100' height='30'/>";
	String borrowerSign = "";//如果业务来源是APP则替换为签名图片URL地址,非APP来源则不替换
	String salesmanSign = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";//如果业务来源是APP则替换为签名图片URL地址,非APP来源则不替换
	
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
	
	//三分协议名称
	String triple = "分期购消费贷款三方协议";
	if("1".equals(isp2p)){
		triple = "委托融资咨询服务协议（P2P资金）";
	}
	
	//如果业务来源是APP则替换为签名图片URL地址,非APP来源则不替换
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









<div class=WordSection1 style='layout-grid:15.6pt'>

<p class=MsoNormal align=center style='text-align:center;layout-grid-mode:char'><b><span
style='font-size:14.0pt;font-family:宋体'>随心还服务申请书</span></b></p>

<p class=MsoNormal style='layout-grid-mode:char'><b><span style='font-family:
宋体'>深圳市佰仟金融服务有限公司并贷款人：</span></b></p>

<p class=MsoNormal style='layout-grid-mode:char'><span lang=EN-US>&nbsp;&nbsp;&nbsp;&nbsp;
</span><b><span style='font-family:宋体'>本人与深圳市佰仟金融服务有限公司（以下简称“佰仟金融”）并贷款人签署了编号为</span></b><b><u><span
style='font-family:宋体'> <span lang=EN-US><%=sObjectNo %> </span></span></u></b><b><span
style='font-family:宋体'>的《<%=triple %>》及《申请表》（以下统称为贷款合同，本申请书所称贷款人与贷款合同中的贷款人一致），现向二司提出随心还服务申请，并自愿接受以下条款：</span><span
lang=EN-US>&nbsp; </span></b></p>

<p class=MsoNormal style='layout-grid-mode:char'><b><span lang=EN-US>1.&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
</span></b><b><span style='font-family:宋体'>随心还服务内容介绍：</span></b></p>

<p class=MsoNormal style='layout-grid-mode:char'><span style='font-family:宋体'>（</span><span
lang=EN-US>1</span><span style='font-family:宋体'>）借款人可针对任一笔贷款选择购买随心还服务，服务内容包括三项：延期还款、变更还款日期和优惠提前还款；借款人选择购买随心还服务后，应按月向佰仟金融支付随心还服务费，该费用包含在该笔贷款的每一期期款中，具体金额以该笔贷款申请表中的“月随心还服务费”数额为准。</span></p>

<p class=MsoNormal style='layout-grid-mode:char'><span style='font-family:宋体'>（</span><span
lang=EN-US>2</span><span style='font-family:宋体'>）如借款人申请任一笔贷款后，佰仟金融实施了新的随心还服务收费标准，则已有贷款的随心还服务费仍按其原有标准缴纳。</span></p>

<p class=MsoNormal style='layout-grid-mode:char'><b><span lang=EN-US>2. </span></b><b><span
style='font-family:宋体'>延期还款：</span></b></p>

<p class=MsoNormal style='layout-grid-mode:char'><span style='font-family:宋体'>（</span><span
lang=EN-US>1</span><span style='font-family:宋体'>）申请条件（借款人满足以下任意一条即可，但本申请书其他条款有更高要求的，申请人亦应符合）：</span></p>

<p class=MsoNormal style='text-indent:10.5pt;layout-grid-mode:char'><span
lang=EN-US>a</span><span style='font-family:宋体'>．未使用过随心还服务任何项目的，借款人已按时足额偿付该笔贷款</span><span
lang=EN-US>5</span><span style='font-family:宋体'>期及以上期款；</span></p>

<p class=MsoNormal style='text-indent:10.5pt;layout-grid-mode:char'><span
lang=EN-US>b</span><span style='font-family:宋体'>．第二次申请延期还款或在使用了变更还款日服务后又申请延期还款的，应在上次延期还款或变更还款日之后按时足额偿还两期及以上期款。</span></p>

<p class=MsoNormal style='layout-grid-mode:char'><span style='font-family:宋体'>（</span><span
lang=EN-US>2</span><span style='font-family:宋体'>）借款人每次申请时最多只能使用一次延期还款，每次延期期数最少为一期，最多为两期。</span></p>

<p class=MsoNormal style='layout-grid-mode:char'><span style='font-family:宋体'>（</span><span
lang=EN-US>3</span><span style='font-family:宋体'>）延期还款期间不计利息、财务管理费、客户服务费、增值服务费（如有）及随心还服务费。</span></p>

<p class=MsoNormal style='layout-grid-mode:char'><span style='font-family:宋体'>（</span><span
lang=EN-US>4</span><span style='font-family:宋体'>）借款人提出延期还款申请时，如佰仟金融及贷款人合理认为借款人的情况不符合其风险管理要求和或有增加借款人违约的可能性，则其有权拒绝借款人的该次申请。</span><span
lang=EN-US>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span></p>

<p class=MsoNormal style='layout-grid-mode:char'><b><span lang=EN-US>3.&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
</span></b><b><span style='font-family:宋体'>变更还款日：</span></b></p>

<p class=MsoNormal style='layout-grid-mode:char'><span style='font-family:宋体'>（</span><span
lang=EN-US>1</span><span style='font-family:宋体'>）申请条件（借款人满足以下任意一条即可，但本申请书其他条款有更高要求的，申请人亦应符合）：</span></p>

<p class=MsoNormal style='text-indent:10.5pt;layout-grid-mode:char'><span
lang=EN-US>a</span><span style='font-family:宋体'>．未使用过随心还服务任何项目的，按时足额偿付该笔贷款的两期及以上期款；</span></p>

<p class=MsoNormal style='text-indent:10.5pt;layout-grid-mode:char'><span
lang=EN-US>b</span><span style='font-family:宋体'>．第二次申请变更还款日或在使用了延期还款服务后又申请变更还款日的，应在上次延期还款或变更还款日之后按时足额偿还两期及以上期款。</span></p>

<p class=MsoNormal style='layout-grid-mode:char'><span style='font-family:宋体'>（</span><span
lang=EN-US>2</span><span style='font-family:宋体'>）如申请时借款人名下有未结清的重合贷款（重合贷款：指在借款人签署了多份由深圳市佰仟金融服务有限公司作为金融服务公司的贷款合同的情况下，其中一笔贷款与其他一笔或多笔贷款含有至少一个相同还款到期日的贷款），在借款人就本合同申请了变更还款日，则其他贷款的还款日均同时变更为新的还款日。</span></p>

<p class=MsoNormal style='layout-grid-mode:char'><span style='font-family:宋体'>（</span><span
lang=EN-US>3</span><span style='font-family:宋体'>）新的还款日日期可在</span><span
lang=EN-US>1-28</span><span style='font-family:宋体'>日之间选择，但借款人提出变更申请之日与首个变更后还款日之间间隔应在</span><span
lang=EN-US>5</span><span style='font-family:宋体'>日（含）到</span><span lang=EN-US>35</span><span
style='font-family:宋体'>日（不含）之间（自申请日起算，含申请日）。</span></p>

<p class=MsoNormal style='layout-grid-mode:char'><b><span lang=EN-US>4. </span></b><b><span
style='font-family:宋体'>优惠提前还款：</span></b></p>

<p class=MsoNormal style='layout-grid-mode:char'><span style='font-family:宋体'>借款人在足额偿还欲申请提前还款的贷款的连续三期期款后，可按照本条款关于提前还款的约定就该笔贷款申请提前还款，但无须另行支付提前还款费。</span></p>

<p class=MsoNormal style='layout-grid-mode:char'><b><span lang=EN-US>5.</span></b><b><span
style='font-family:宋体'>服务次数：</span></b></p>

<p class=MsoNormal style='layout-grid-mode:char'><span style='font-family:宋体'>（</span><span
lang=EN-US>1</span><span style='font-family:宋体'>）购买随心还服务的每笔贷款的延期还款和变更还款日服务次数如下：分期期数为</span><span
lang=EN-US>12</span><span style='font-family:宋体'>期（含）以下的分别为一次，分期期数为</span><span
lang=EN-US>12</span><span style='font-family:宋体'>期以上的分别为累计两次。</span></p>

<p class=MsoNormal style='layout-grid-mode:char'><span style='font-family:宋体'>（</span><span
lang=EN-US>2</span><span style='font-family:宋体'>）购买随心还服务的每笔贷款的延期还款的最高延期期数如下：分期期数为</span><span
lang=EN-US>12</span><span style='font-family:宋体'>期（含）以下的为一期，分期期数为</span><span
lang=EN-US>12</span><span style='font-family:宋体'>期以上的为累计两期，延期最高期数使用完毕的，即使还有随心还服务项下任何剩余服务次数的，也不能再次申请。</span></p>

<p class=MsoNormal style='layout-grid-mode:char'><span style='font-family:宋体'>（</span><span
lang=EN-US>3</span><span style='font-family:宋体'>）借款人名下有重合贷款，借款人就本合同申请了变更还款日，如果其他贷款有一笔或多笔亦购买了随心还服务，则视同每笔贷款均使用了一次变更还款日服务。</span></p>

<p class=MsoNormal style='layout-grid-mode:char'><span style='font-family:宋体'>（</span><span
lang=EN-US>4</span><span style='font-family:宋体'>）变更还款日及延期还款服务次数计算举例：借款人申请了</span><span
lang=EN-US>24</span><span style='font-family:宋体'>期的贷款，使用了一次延期一期的延期还款服务后，再次申请时，则只能申请一次变更还款日服务或延期一期的延期还款服务。</span></p>

<p class=MsoNormal style='layout-grid-mode:char'><span style='font-family:宋体'>（</span><span
lang=EN-US>5</span><span style='font-family:宋体'>）一笔贷款借款人只能使用一次优惠提前还款服务，优惠提前还款服务生效后随心还服务终结。</span></p>

<p class=MsoNormal style='layout-grid-mode:char'><span lang=EN-US>6. </span><span
style='font-family:宋体'>借款人申请延期还款和变更还款日应在最近下一个还款到期日至少五日前致电佰仟金融提出；申请优惠提前还款的，应在最近下一个还款到期日至少十五日前致电佰仟金融提出。借款人在同一时间只能申请一项随心还款服务，在前一项随心还款服务使用结束并偿还两期及以上期款后，才能申请使用其他服务。如本申请第</span><span
lang=EN-US>2</span><span style='font-family:宋体'>条、第</span><span lang=EN-US>3</span><span
style='font-family:宋体'>条、第</span><span lang=EN-US>4</span><span
style='font-family:宋体'>条和第</span><span lang=EN-US>5</span><span
style='font-family:宋体'>条规定更高的要求，则以其规定为准。</span></p>

<p class=MsoNormal style='layout-grid-mode:char'><b><span lang=EN-US>7</span></b><b><span
style='font-family:宋体'>．取消随心还服务</span></b></p>

<p class=MsoNormal style='layout-grid-mode:char'><span style='font-family:宋体'>（</span><span
lang=EN-US>1</span><span style='font-family:宋体'>）犹豫期：借款人《申请表》所列之申请日起的十五个自然日内（包含申请日当天）向佰仟金融致电申请取消随心还服务，则无需支付随心还服务费。</span></p>

<p class=MsoNormal style='layout-grid-mode:char'><span style='font-family:宋体'>（</span><span
lang=EN-US>2</span><span style='font-family:宋体'>）借款人申请取消一笔贷款的随心还服务的，应在最近下一个还款到期日至少五日前（犹豫期取消除外）致电佰仟金融提出，申请取消成功后，借款人自申请取消之日的下一个自然月起停止支付随心还服务费。。</span></p>

<p class=MsoNormal style='layout-grid-mode:char'><span style='font-family:宋体'>（</span><span
lang=EN-US>3</span><span style='font-family:宋体'>）借款人申请取消随心还服务后，已经支付的随心还服务费不予退还，即使借款人从未使用过该服务；</span></p>

<p class=MsoNormal style='layout-grid-mode:char'><span style='font-family:宋体'>（</span><span
lang=EN-US>4</span><span style='font-family:宋体'>）取消随心还服务一旦成功申请，则即时生效，随心还服务终结。同一笔贷款随心还服务包取消后不能再次申请。（</span><span
lang=EN-US>5</span><span style='font-family:宋体'>）借款人已经使用过服务包内任何一项服务的，不能申请取消服务包。</span></p>

<p class=MsoNormal style='layout-grid-mode:char'><span lang=EN-US>8. </span><span
style='font-family:宋体'>申请时如借款人在本合同以及任何其他由佰仟金融作为其金融服务公司的合同项下期款处于逾期状态的，都不能申请使用或取消本服务包，或者申请时没有逾期，但在申请后首个延期还款日前、首个变更后还款日前、优惠提前还款生效前或取消服务包生效前发生逾期的，则申请自动失效。</span></p>

<p class=MsoNormal style='layout-grid-mode:char'><span lang=EN-US>9. </span><span
style='font-family:宋体'>借款人购买了随心还服务后，各期期款中包含的各款项按照以下顺序依次清偿：滞纳金（如有）、财务管理费、客户服务费、增值服务费（如有）、随心还服务费、利息、贷款本金。</span></p>

<p class=MsoNormal style='layout-grid-mode:char'><span lang=EN-US>10. </span><span
style='font-family:宋体'>贷款人及佰仟金融保留基于借款人的情况和风险程度减少随心还服务的服务范围或全部取消随心还服务的权利。</span></p>

<p class=MsoNormal style='layout-grid-mode:char'><span lang=EN-US>11. </span><span
style='font-family:宋体'>借款人使用本申请书约定的服务内容的，不产生违约金，也不影响借款人的征信记录。</span></p>

<p class=MsoNormal style='layout-grid-mode:char'><span lang=EN-US>12. </span><span
style='font-family:宋体'>借款人承诺：借款人在本申请下方签字则视为接受本申请的全部条款，佰仟金融及贷款人在贷款合同上签章即视为三方对本申请书达成了一致协议，协议生效日期同《申请表》签署日期。</span></p>
<%
	//如果业务来源是APP则在杂而立添加一项
	if("APP".equals(suretype)){
%>
<p class=MsoNormal style='layout-grid-mode:char'><span lang=EN-US>13. </span><span
style='font-family:宋体'>除正常纸质签署方式外借款人也可以通过佰仟金融提供的设备在本申请书上进行电子签名。借款人同意本申请书的签署可以采用电子签章、电子文本形式，认可电子签章、电子文本的法律效力，并同意采用数据电文的形式保管。</span></p>
<p class=MsoNormal style='layout-grid-mode:char'><span lang=EN-US>14. </span><span
<%
	}else if("JCC".equals(suretype)){
		%>
		<p class=MsoNormal style='layout-grid-mode:char'><span lang=EN-US>13. </span><span
		style='font-family:宋体'>除正常纸质签署方式外借款人也可以通过佰仟金融提供的设备在本申请书上进行电子签名。借款人同意本申请书的签署可以采用电子签章、电子文本形式，认可电子签章、电子文本的法律效力，并同意采用数据电文的形式保管。</span></p>
		<p class=MsoNormal style='layout-grid-mode:char'><span lang=EN-US>14. </span><span
		<%
			}else{
%>		
<p class=MsoNormal style='layout-grid-mode:char'><span lang=EN-US>13. </span><span
<%
	}
%>
style='font-family:宋体'>本申请作为贷款合同的附件与贷款合同具有同等效力，借款人授权佰仟金融将其与贷款合同采取同样方式一并保存处理。</span></p>

<p class=MsoNormal style='layout-grid-mode:char'><span lang=EN-US>&nbsp;</span></p>

<p class=MsoNormal style='layout-grid-mode:char'><span style='font-family:宋体'>销售顾问姓名：
<%=salesexecutiveName %><span lang=EN-US>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span>销售顾问签名：<%=salesmanSign %></span><span
lang=EN-US>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span><span
style='font-family:宋体'>申请人（借款人）签名：<%=borrowerSign %></span></p>

<p class=MsoNormal style='layout-grid-mode:char'><span lang=EN-US>&nbsp;</span></p>
<%
	if("JCC".equals(suretype)){
%>
<br>
<p class=MsoNormal style='layout-grid-mode:char'><span lang=EN-US>版本号:J_XF_TY_TY_2016030801 </span>
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