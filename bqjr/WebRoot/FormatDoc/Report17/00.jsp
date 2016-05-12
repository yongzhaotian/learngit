<%-- <%@page import="org.jbpm.jpdl.internal.activity.SqlActivity"%> --%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main00;Describe=注释区;]~*/%>
	<%
	/*
		邮寄清单
		Author:   xiongtao  2005.02.18
		Tester:
		Content: 报告的第0页
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
	int iDescribeCount = 30;	//这个是页面需要输入的个数，必须写对：客户化1
	int iCount = 1;
	int iCountNew = 20 ;
%>

<%@include file="/FormatDoc/IncludePOHeader.jsp"%>

<%



String sOperateMode="";//门店运作模式
String sRemark="";//备注
String sSalesExecutive="";//销售代表
String sContractNo="";
String sContractNum="";//合同总数
String sSno="";//门店号
String sPackType="";//包裹类型
String sStores="";//门店
String sBusinessSum="";//贷款金额
String sPeriods="";//期限

String Sql = "SELECT pi.sno,pi.packtype "+
        " FROM package_info pi where pi.packno='"+sObjectNo+"'";


ASResultSet ar = Sqlca.getASResultSet(Sql);
 if(ar.next()){
	 sSno = ar.getString("sno");
	 if(sSno==null) sSno="&nbsp;";
	 sPackType = ar.getString("PackType");
	 if(sPackType==null) sPackType="&nbsp;";
	 
 }
   ar.getStatement().close();
   
   System.out.println("packtype:"+sPackType);
  	String sSql = "SELECT count(contractno)as contractnum "+
        " FROM shop_contract sc where sc.packno='"+sObjectNo+"'";

      ASResultSet rs = Sqlca.getASResultSet(sSql);

     if (rs.next()){
       sContractNum = rs.getString("ContractNum");
       if(sContractNum==null) sContractNum="&nbsp;";
      }
     rs.getStatement().close(); 

     sOperateMode=Sqlca.getString("select getItemName('OperatorMode',si.OPERATEMODE) AS OperateMode from store_info si where si.sno='"+sSno+"'");
	 if(sOperateMode == null) sOperateMode  = "&nbsp;";
	 
	String sBusinessName = Sqlca.getString(new SqlObject("select CreditPerson from Package_Info where PackNo =:PackNo").setParameter("PackNo", sObjectNo));
	
	if(sBusinessName == null) sBusinessName = "&nbsp;";
     
     /* String Sql2 = "SELECT bc.salesexecutive,"+
                  "bc.ContractEffectiveDate,bc.Remark "+
	" FROM business_contract bc where bc.SerialNo='"+sContractNo+"'";

ASResultSet rs2 = Sqlca.getASResultSet(Sql2);
	
	if (rs.next()){
		sSalesExecutive = rs2.getString("SalesExecutive");
		sContractEffectiveDate=rs2.getString("ContractEffectiveDate");
		sRemark=rs2.getString("Remark");
		if(sSalesExecutive == null) sSalesExecutive  = "";
		if(sContractEffectiveDate == null) sContractEffectiveDate="";
		if(sRemark==null) sRemark="";
		
	}
	rs2.getStatement().close(); */
	
/* 		
	String Sql3="select getItemName('OperatorMode',si.OPERATEMODE) AS OperateMode from store_info si where si.sno='"+sSno+"'";		
	ASResultSet rs3 = Sqlca.getASResultSet(Sql3);
	if(rs3.next()){

			sOperateMode = rs3.getString("OperateMode");
			if(sOperateMode == null) sOperateMode  = "";

		}
	rs3.getStatement().close(); */

	
%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=ReportInfo;Describe=生成报告信息;客户化2;]~*/%>
<%
	StringBuffer sTemp=new StringBuffer();
	sTemp.append("	<form method='post' action='00.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>");	
	
	sTemp.append("<table  class=table1 width='660' align=center border=0 cellspacing=0 cellpadding=2 >	");

	
	sTemp.append("<tr>");
	sTemp.append("<td class=td1 style='border:0px;text-align:center; font-size: 20pt;FONT-FAMILY:仿宋_GB2312;FONT-WEIGHT: bold;color:black;background-color:white' colspan=6>邮&nbsp;寄&nbsp;清&nbsp;单&nbsp;&nbsp;&nbsp;</td>");
	sTemp.append("</tr>");
		
	sTemp.append("<tr>");
	sTemp.append("<td   colspan=1 class=td1>包裹编号</td>");
	sTemp.append("<td   colspan=2 class=td1>"+sObjectNo+"</td>");
	sTemp.append("<td   colspan=1 class=td1>总合同数</td>");
	sTemp.append("<td   colspan=2 class=td1>"+sContractNum+"</td>");
	sTemp.append("</tr>");
	String sDay = StringFunction.getToday().replaceAll("/","");
	if(sPackType.equals("01")){ 
	sTemp.append("<tr>");
	sTemp.append("<td   colspan=1 class=td1>门店号</td>");
	sTemp.append("<td   colspan=2 class=td1>"+sSno+"</td>");
	sTemp.append("<td   colspan=1 class=td1>发送日期</td>");
	sTemp.append("<td   colspan=2 class=td1>"+DataConvert.toDate_YMD(sDay)+"</td>");

	sTemp.append("</tr>");
	
	sTemp.append("<tr>");
	sTemp.append("<td   colspan=1 class=td1>序号</td>");
	sTemp.append("<td   colspan=1 class=td1>合同编号</td>");
	sTemp.append("<td   colspan=1 class=td1>门店</td>");
	sTemp.append("<td   colspan=1 class=td1>门店运作模式</td>");
	sTemp.append("<td   colspan=1 class=td1>销售代表</td>");
	sTemp.append("<td   colspan=1 class=td1>备注</td>");
	sTemp.append("</tr>");
	
	String Sq = "select sc.contractno,bc.salesexecutive,bc.stores,bc.Remark"+
	          " from shop_contract sc,business_contract bc where bc.serialno=sc.contractno"+
	         " and sc.PackNo='"+sObjectNo+"'";
  ASResultSet re = Sqlca.getASResultSet(Sq);
  int i = 1;
  while(re.next()){
      sContractNo = re.getString("ContractNo");
      sSalesExecutive = re.getString("SalesExecutive");
	  sRemark=re.getString("Remark");
	  sStores = re.getString("Stores");
	  if(sSalesExecutive == null) sSalesExecutive  = "&nbsp;";
	  if(sRemark==null) sRemark="&nbsp;";
      if(sContractNo == null) sContractNo  = "&nbsp;";

    sTemp.append("<tr>");
  	sTemp.append("<td   colspan=1 class=td1>"+i+"</td>");
  	sTemp.append("<td   colspan=1 class=td1>"+sContractNo+"</td>");
  	sTemp.append("<td   colspan=1 class=td1>"+sStores+"</td>");
  	sTemp.append("<td   colspan=1 class=td1>"+sOperateMode+"</td>");
  	sTemp.append("<td   colspan=1 class=td1>"+sSalesExecutive+"</td>");
  	sTemp.append("<td   colspan=1 class=td1>"+sRemark+"</td>");
  	sTemp.append("</tr>");
  	i++;
  }
  re.getStatement().close(); 
	
	
	
 }else if(sPackType.equals("02")){
	sTemp.append("<tr>");
	sTemp.append("<td   colspan=1 class=td1>贷款人</td>");
	sTemp.append("<td   colspan=2 class=td1>"+sBusinessName+"</td>");
	sTemp.append("<td   colspan=1 class=td1>发送日期</td>");
	sTemp.append("<td   colspan=2 class=td1>"+DataConvert.toDate_YMD(sDay)+"</td>");
	sTemp.append("</tr>");

	sTemp.append("<tr>");
	sTemp.append("<td   colspan=1 class=td1>序号</td>");
	sTemp.append("<td   colspan=2 class=td1>合同编号</td>");
	sTemp.append("<td   colspan=1 class=td1>贷款金额</td>");
	sTemp.append("<td   colspan=2 class=td1>期限</td>");
	sTemp.append("</tr>");
	

	String Sq = "select sc.contractno,bc.businesssum,bc.periods"+
	          " from shop_contract sc,business_contract bc where bc.serialno=sc.contractno"+
	         " and sc.PackNo='"+sObjectNo+"'";
ASResultSet re = Sqlca.getASResultSet(Sq);
int i = 1;
while(re.next()){
    sContractNo = re.getString("ContractNo");
    sBusinessSum=re.getString("BusinessSum");
    sPeriods=re.getString("Periods");

	if(sContractNo==null) sContractNo="&nbsp;";
	if(sBusinessSum==null) sBusinessSum="&nbsp;";
    if(sPeriods == null) sPeriods  = "&nbsp;";

    sTemp.append("<tr>");
	sTemp.append("<td   colspan=1 class=td1>"+i+"</td>");
	sTemp.append("<td   colspan=2 class=td1>"+sContractNo+"</td>");
	sTemp.append("<td   colspan=1 class=td1>"+sBusinessSum+"</td>");
	sTemp.append("<td   colspan=2 class=td1>"+sPeriods+"</td>");
	sTemp.append("</tr>");
	i++;

   }
  re.getStatement().close(); 
	
	

}
	 
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
<%
	}
%>	
</script>	
	
<%@ include file="/IncludeEnd.jsp"%>