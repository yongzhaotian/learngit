<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   ccxie 2010/03/25
		Tester:
		Content:  打印借款人催收函
		Input Param:

		History Log: sxjiang 2010/07/19 Line50 关闭结果集
	 */
	%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义变量，获取参数;]~*/%>
<%
	String sSerialNo = DataConvert.toRealString(iPostChange,(String) CurPage.getParameter("SerialNo"));
	if (sSerialNo == null)sSerialNo = "";
	
	String sSql = "";
	String sDunObjectType = "";//催收对象：01-借款人，02-保证人，03-其他
	String sOperateOgID = "";
	String sDunObjectName = "";//催收对象名称
	String sObjectNo = "";//催收函编号
	String sDunSum = "";//催收金额
	String sCorpus = "";//本金
	String sInterestInSheet = "";//表内利息
	String sInterestOutSheet = "";//表外利息
	String sElseFee = "";//其他
	String sMaturity = "";//终结日期
	String sArtificialNo = "";//人工合同编号
	String sDunDate = "";//催收日期
	String sYear = "",sMonth = "",sDay = "";
	String sDunYear = "",sDunMonth = "",sDunDay = "";
	double LineRate = 0;
	double dCorpus = 0;
	double dInterestInSheet = 0;
	double dInterestOutSheet = 0;
	double dElseFee = 0;
	double dDunSum = 0;
	ASResultSet rs = null;
	sSql = " select getERate1(DunCurrency,'01') as LineRate,di.ObjectType,di.ObjectNo,di.SerialNo,di.DunLetterNo,"+
	   " di.DunDate,di.DunForm,di.DunObjectType,di.DunObjectName,di.DunCurrency,"+
	   " di.DunSum,di.Corpus,di.InterestInSheet,di.InterestOutSheet,di.ElseFee,di.ServiceMode,"+
	   " di.FeedbackValitity,di.FeedbackContent,di.Remark,di.OperateUserID,di.OperateUserID,di.OperateOrgID,di.OperateOrgID,"+ 
	   " di.InputUserID,di.InputUserID,di.InputOrgID,di.InputOrgID,di.InputDate,di.UpdateDate,bc.Maturity,bc.ArtificialNo,di.DunDate "+ 
	   " from DUN_INFO di,BUSINESS_CONTRACT bc"+
	   " where di.SerialNo= :SerialNo and di.ObjectNo = bc.serialNo" ;
	rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("SerialNo",sSerialNo));
	if (rs.next()) {
		LineRate = rs.getDouble("LineRate");
		sDunObjectType = rs.getString("DunObjectType");
		sOperateOgID = rs.getString("OperateOrgID");
		sDunObjectName = rs.getString("DunObjectName");
		sObjectNo = rs.getString("ObjectNo");
		dCorpus = rs.getDouble("Corpus");
		dInterestInSheet = rs.getDouble("InterestInSheet");
		dInterestOutSheet = rs.getDouble("InterestOutSheet");
		dElseFee = rs.getDouble("ElseFee");
		dDunSum = rs.getDouble("DunSum");
		sMaturity = rs.getString("Maturity");
		sArtificialNo = rs.getString("ArtificialNo");
		sDunDate = rs.getString("DunDate");
	}
	rs.getStatement().close();
	
	if (sDunObjectType == null)
		sDunObjectType = "&nbsp";
	if (sOperateOgID == null)
		sOperateOgID = "&nbsp";
	if (sDunObjectName == null)
		sDunObjectName = "&nbsp";
	if (sObjectNo == null)
		sObjectNo = "&nbsp";
	if (sMaturity == null)
		sMaturity = "&nbsp";
	if (sArtificialNo == null)
		sArtificialNo = "&nbsp";
	if (sDunDate == null)
	    sDunDate = "&nbsp";
	
	sCorpus = DataConvert.toMoney(dCorpus*LineRate);
	sInterestInSheet = DataConvert.toMoney(dInterestInSheet*LineRate);
	sInterestOutSheet = DataConvert.toMoney(dInterestOutSheet*LineRate);
	sElseFee = DataConvert.toMoney(dElseFee*LineRate);
	sDunSum = DataConvert.toMoney(dDunSum*LineRate);
	
	//按年月日取出终结日期
	if(sMaturity != null && !sMaturity.equals(""))
	{
		sYear = sMaturity.substring(0,4);
		sMonth = sMaturity.substring(5,7);
		sDay = sMaturity.substring(8,10);
	}
	//获取系统当前日期
	sDunYear = sDunDate.substring(0,4)+"年";;
	sDunMonth = sDunDate.substring(5,7)+"月";
	sDunDay = sDunDate.substring(8,10)+"日";
	sDunDate = sDunYear+sDunMonth+sDunDay;
%>

<html>

	<body onbeforePrint="beforePrint()"  onafterprint="afterPrint()">

	<head>
	<title></title>
	</head>
	
	<object ID='WebBrowser1' WIDTH=0 HEIGHT=0 border=1  style="display:none" CLASSID='CLSID:8856F961-340A-11D0-A96B-00C04FD705A2' > </object>
	
	<div id='PrintButton'>
	<input type=button value='打印设置' onclick="WebBrowser1.ExecWB(8,1)">
	<input type=button value='打印预览' onclick="WebBrowser1.ExecWB(7,1)">
	<input type=button value=' 打  印 ' onclick="WebBrowser1.ExecWB(6,1)">
	<input type=button value=' 返  回 ' onclick="goBack()">
	</div>

	<form method='post' action='ALPassBook.jsp' name='reportInfo'>	
	<div id=reporttable>	
	<table class=table1 width='600' align=center border="0" >
	<tr>
		<td colspan='5' align=left class=td1 height='10'> 
		<font size='4'></font> 
		</td>
	</tr>

	<tr>
		<td colspan='5' align=center class=td1 height='10'> 
		<font style=font-size:14pt;line-height:130%> <b> XX商业银行催收函 </b> </font>  
		</td>
	</tr>	
	
	<tr>
		<td colspan='5' align=right class=td1 height='25'> 
		<font style=font-size:11pt;line-height:130%> 催收函编号<%=sObjectNo%> </font> 
		</td>
	</tr>
	<tr></tr>
	<tr></tr>
	<tr></tr>
	<tr></tr>
	<tr></tr>
	<tr></tr>
	<tr>
		<td colspan='5' align=left class=td1 height='25'> 
		<font style=font-size:11pt;line-height:130%>尊敬的客户：<%=sDunObjectName%> </font> 
		</td>
	</tr>

	<tr>
		<td colspan='5' align=left class=td1 height='35'> 
		<font style=font-size:11pt;line-height:2> &nbsp &nbsp 根据<span lang=EN-US><%=sArtificialNo%></span>号（文本合同编号）借款合同，
			贵单位在我行借款于<%=sYear%>年<%=sMonth%>月<%=sDay%>日到期，请尽快筹措资金偿还(本函的催收币种为人民币):</font>
		</td>
	</tr>	
	<tr>
		<td colspan='5' align=left class=td1 height='25'> 
		<font style=font-size:11pt;line-height:130%>1、	本金：<%=sCorpus%>元；</font> 
		</td>
	</tr>
		<tr>
		<td colspan='5' align=left class=td1 height='25'> 
		<font style=font-size:11pt;line-height:130%>2、	表内利息:<%=sInterestInSheet%>元；</font> 
		</td>
	</tr>
		<tr>
		<td colspan='5' align=left class=td1 height='25'> 
		<font style=font-size:11pt;line-height:130%>3、	表外利息:<%=sInterestOutSheet%>元；</font> 
		</td>
	</tr>
	<tr>
		<td colspan='5' align=left class=td1 height='25'> 
		<font style=font-size:11pt;line-height:130%>4、	其他:<%=sElseFee%>元；</font> 
		</td>
	</tr>
	<tr>
		<td colspan='5' align=left class=td1 height='25'> 
		<font style=font-size:11pt;line-height:130%>共计:<%=sDunSum%>元。</font> 
		</td>
	</tr>
	<tr>
		<td colspan='5' align=left class=td1 height='25'> 
		<font style=font-size:11pt;line-height:130%>否则，我行将采取下列相应措施：</font> 
		</td>
	</tr>
	<tr>
		<td colspan='5' align=left class=td1 height='25'> 
		<font style=font-size:11pt;line-height:130%>1、	将该笔贷款转入逾期贷款专户，按照合同约定计收利息并罚息。□</font> 
		</td>
	</tr>
	<tr>
		<td colspan='5' align=left class=td1 height='25'> 
		<font style=font-size:11pt;line-height:130%>2、	降低您的信用等级。□</font> 
		</td>
	</tr>
	<tr>
		<td colspan='5' align=left class=td1 height='25'> 
		<font style=font-size:11pt;line-height:130%>3、	停止受理您的贷款、银行承兑汇票等融资业务申请。□</font> 
		</td>
	</tr>
	<tr>
		<td colspan='5' align=left class=td1 height='25'> 
		<font style=font-size:11pt;line-height:130%>4、	报请人民银行列入信用不良名单，并向社会公布。□ </font> 
		</td>
	</tr>
	<tr>
		<td colspan='5' align=left class=td1 height='25'> 
		<font style=font-size:11pt;line-height:130%>5、	依法向法院申请支付令、申请强制执行或直接提起诉讼，追偿贷款本息。□ </font> 
		</td>
	</tr>
	<tr>
		<td colspan='3' align=left class=td1 height='55' width='50%'> 
		<font style=font-size:11pt;line-height:130%>借款人章(或签收人签字)：</font> 
		</td>
		<td colspan='2' align=center class=td1 height='55'> 
		<font style=font-size:11pt;line-height:130%> 贷款人章：</font> 
		</td>
	</tr>
	<tr>
		<td colspan='5' align=left class=td1 height='20'> 
		<font style=font-size:11pt;line-height:130%> </font> 
		</td>
	</tr>
		<tr>
		<td colspan='3' align=left class=td1 height='40' width='50%'> 
		<font style=font-size:11pt;line-height:130%><%=sDunDate%></font> 
		</td>
	</tr>
		<tr>
		<td colspan='5' align=left class=td1 height='25'> 
		<font style=font-size:11pt;line-height:130%>注：本通知书一式两份：借款人签收后留存一份，退贷款人一份作为回执。</font> 
		</td>
	</tr>
	
	</table>	
	</div>

	</form>
</html>	

<script type="text/javascript">

	function beforePrint(){
		document.all('PrintButton').style.display='none';
	}
		
	function afterPrint(){
		document.all('PrintButton').style.display="";
	}
	/*~[Describe=返回列表页面;InputParam=无;OutPutParam=无;]~*/
	function goBack()
	{
		self.close();
	}		

</script>

<%@ include file="/IncludeEnd.jsp"%>

