<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   xiongtao  2005.02.18
		Tester:
		Content: 报告的第?页
		Input Param:
			必须传入的参数：
				DocID:	  文档template
				ObjectNo：业务号
				SerialNo: 调查报告流水号
			可选的参数：
				Method:   其中 1:display;2:save;3:preview;4:export
				FirstSection: 判断是否为报告的第一页
		Output param:

		History Log: 
	 */
	%>
<%/*~END~*/%>

<%
	int iDescribeCount = 1;	//这个是页面需要输入的个数，必须写对：客户化1
%>

<%@include file="/FormatDoc/IncludeFDHeader.jsp"%>
<%
	String sSql = "select BusinessType from Business_Apply where serialNo = '"+sObjectNo+"'";
	ASResultSet rs2 = Sqlca.getResultSet(sSql);
	String sBusinessType = "";
	if(rs2.next()) sBusinessType = rs2.getString(1);
	rs2.getStatement().close();	
%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=ReportInfo;Describe=生成报告信息;客户化2;]~*/%>
<%
	StringBuffer sTemp=new StringBuffer();
	sTemp.append("<form method='post' action='08.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>");	
	sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >	");
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=left bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >7、授信申请用途</font></td>"); 	
	sTemp.append("   </tr>");	
	sTemp.append("   <tr>");
  	sTemp.append("   <td align=left class=td1 "+myShowTips(sMethod)+" ><p>描述此笔授信业务的资金用途，涉及到贸易融资产品时，详细描述其贸易背景及合法合规性，并根据不同的贸易融资的贷款品种，详细分析如何规避风险。</p>");
  	if(sBusinessType.equals("1020010"))
  		sTemp.append("     承兑汇票贴现：要求说明申请人和其直接前手或出票人之间的贸易关系（贸易标的、金额、付款条件、是否有交易合同、增值税发票、发运单据）；汇票的承兑机构、承兑金额、票据号码、到期日。检查汇票是否经背书转让，背书是否连续。检查汇票、交易合同、增值税发票上的交易合同号码是否一致，日期、金额等要素是否匹配。对于缺少增值税发票复印件的，要求说明原因。</p>");
  	if(sBusinessType.equals("2010") || sBusinessType.equals("1090010"))
  		sTemp.append("     开立承兑汇票：要求说明申请人和收款人的贸易关系，（贸易标的、金额、付款条件、是否有交易合同、收货凭证）。要求承兑汇票的收款人、金额、付款条件和期限是否与交易合同一致。收款人的经营范围和交易合同的履行内容是否匹配。如果不能提供收货凭证，要求说明交易合同目前的履行状态。");
  	if(sBusinessType.equals("1020010"))
  		sTemp.append("     开立信用证：要求说明申请人和信用证受益人的贸易关系（贸易标的、金额、付款条件、对信用证的规定）。信用证受益人、金额、装期、到期日是否与交易合同一致。信用证受益人是否与申请人有历史贸易记录和收汇记录。如果为代理开证，还要求提交代理合同并说明代理关系。如有预付款，预付款项是否已对外支付。");
  	if(sBusinessType.equals("1080020010") || sBusinessType.equals("1080020020") || sBusinessType.equals("1080020030"))
  		sTemp.append("     出口押汇：要求说明申请人和进口方的贸易合同关系（贸易标的、金额、付款条件、交货日期、付款日期）。说明出口押汇项下的信用证要素（开证行、编号、有效期、金额）。检查信用证和贸易合同的主要要素是否匹配，出口商是否已按信用证要求提供了全套商务单据，并且无实质性的不符点，信用证是否存在影响收汇的软条款。检查出口押汇申请的金额和期限是否与信用证条款匹配。");
  	if(sBusinessType.equals("1080040010") || sBusinessType.equals("1080040020") || sBusinessType.equals("1080040030"))
  		sTemp.append("     福费廷：要求说明申请人和进口方的贸易合同关系（贸易标的、金额、付款条件、交货日期、付款日期）。了解申请人和进口方采用远期结算方式的原因。确认出口商是否已按信用证要求提供了全套商务单据，确认单据是否与信用证一致，开证行是否已经同意偿付信用证，并且承兑了相应的远期票据。");
  	if(sBusinessType.equals("1080030010") || sBusinessType.equals("1080030020"))
  		sTemp.append("     进口押汇：要求说明申请人和进口方的贸易关系；货物是否已经运达，货物的状态；申请人和国内买家的销售合同（如有），申请押汇的金额和期限是否和此贸易合同项下的收款相匹配；确认申请人进行押汇的动机是正常的短期资金融通，而非来证后无力支付（以防我行被迫垫款）；确认客户是否要求放行货物，如是，客户是否与我行签订信托收据，并提供一定的担保，若否，我行是否持有货物的提单、仓单、货物的性质是否易变质、难处理或易贬值。");
  	if(",1080310,1080320,1090060,1090070".indexOf(sBusinessType)>0)
  		sTemp.append("     保理：要求说明保理项下的应收帐款的清单，列明各笔应收帐款的金额、债务人，期限和约定付款日。查验大额应收款项的交易合同、增值税发票和发货凭证，如果不能提供，要求说明原因。调查大额应收款的债务人的经营范围是否和交易合同相一致。调查大额应收款的债务人和申请人的历史贸易记录和付款记录。");
  	if(sBusinessType.equals("2050020010"))
  		sTemp.append("     投标保函：要求提供招标邀请书，查验招标邀请书对投标保函的规定，了解招标方开标的日期和方式，查验招标内容是否符合申请人的经营范围。");
  	if(sBusinessType.equals("2050020020"))
  		sTemp.append("     履约保函：要求提供商务合同，查验商务合同对履约保函的规定，了解商务合同的履行期限、形象进度和主要节点。调查申请人的资质和履约能力");
  	if(sBusinessType.equals("2050020030"))
  		sTemp.append("     预付款保函：要求提供商务合同，预付款收据。查验商务合同对预付款保函的规定，了解预付款的去向和用途，调查申请人的资质和履约能力。");

  	sTemp.append("   </td>");
    sTemp.append("   </tr>");
    sTemp.append("   <tr>");
  	sTemp.append("   <td align=left class=td1 >");
  	sTemp.append(myOutPut("1",sMethod,"name='describe1' style='width:100%; height:150'",getUnitData("describe1",sData)));
  	sTemp.append("   <br>");
	sTemp.append("&nbsp;</td>");
    sTemp.append("   </tr>");
	sTemp.append("</table>");	
	sTemp.append("</div>");	
	sTemp.append("<input type='hidden' name='Method' value='1'>");
	sTemp.append("<input type='hidden' name='SerialNo' value='"+sSerialNo+"'>");
	sTemp.append("<input type='hidden' name='ObjectNo' value='"+sObjectNo+"'>");
	sTemp.append("<input type='hidden' name='ObjectType' value='"+sObjectType+"'>");
	sTemp.append("<input type='hidden' name='Rand' value=''>");
	sTemp.append("<input type='hidden' name='CompClientID' value='"+CurComp.getClientID()+"'>");
	sTemp.append("<input type='hidden' name='PageClientID' value='"+CurPage.getClientID()+"'>");
	sTemp.append("</form>");	



	String sReportInfo = sTemp.toString();
	String sPreviewContent = "pvw"+java.lang.Math.random();
%>
<%/*~END~*/%>

<%@include file="/FormatDoc/IncludeFDFooter.jsp"%>

<script type="text/javascript">
<%	
	if(sMethod.equals("1"))  //1:display
	{
%>
	//客户化3
	var config = new Object();    
	editor_generate('describe1');		//需要html编辑,input是没必要
<%
	}
%>	
</script>	
	
<%@ include file="/IncludeEnd.jsp"%>