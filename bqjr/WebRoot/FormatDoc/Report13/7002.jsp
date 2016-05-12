<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main00;Describe=注释区;]~*/%>
	<%
	/*
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
	int iDescribeCount = 0;	//这个是页面需要输入的个数，必须写对：客户化1
%>

<%@include file="/FormatDoc/IncludePOHeader.jsp"%>

<%
	//获得调查报告数据
	String sSql = "select CustomerID from Business_Contract where SerialNo = '"+sObjectNo+"'";
	String sCustomerID = Sqlca.getString(sSql);
	//获取对应数据
	String sCustomerName = Sqlca.getString("select CustomerName from Business_Contract where SerialNo = '"+sObjectNo+"'");
	ASResultSet rs2 = Sqlca.getResultSet(sSql);
	//sSql = "select CustomerName,";
	
	rs2.getStatement().close();	
	
%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=ReportInfo;Describe=生成报告信息;客户化2;]~*/%>
<%
	StringBuffer sTemp=new StringBuffer();
	sTemp.append("	<form method='post' action='7001.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>");
	String sDay = StringFunction.getToday().replaceAll("/","");
		sTemp.append("<table  width=640 align=center border='0' cellspacing='0' cellpadding='2'  >	");
		sTemp.append("   <td align=right colspan=4  ></td>");
		sTemp.append("   </tr>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td colspan=4 align=center  >&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td colspan=4 align=center  >&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td colspan=4 align=center  >&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td colspan=4 align=center  >&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td colspan=4 align=center  >&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td align=left colspan=4  > 广东省深圳市福田区 </td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td align=left colspan=4 >福田天安创业园B座801</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td align=left colspan=4 >"+sCustomerName+"&nbsp;先生/女士&nbsp;&nbsp;收</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td colspan=4 align=center  >&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td colspan=4 align=center  >&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td colspan=4 align=center  >&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td colspan=4 align=center  >&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td colspan=4 align=center  >&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td colspan=4 align=center  >&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td colspan=4 align=center  >&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td width=28% align=right colspan=2 >合同号/Reference&nbsp;</td>");
		sTemp.append("   <td align=left colspan=2 >&nbsp;"+sObjectNo+"</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td width=28% align=right colspan=2 >部门/Department/From&nbsp;</td>");
		sTemp.append("   <td align=left colspan=2 >&nbsp;客户服务中心</td>");
		sTemp.append("   <tr>");
		sTemp.append("   <td width=28% align=right colspan=2 >邮箱/E-mail&nbsp;</td>");
		sTemp.append("   <td align=left colspan=2 >&nbsp;Customer.Service@XXX com.cn</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td width=28% align=right colspan=2 >日期/Date&nbsp;</td>");
		sTemp.append("   <td align=left colspan=2 >&nbsp;"+DataConvert.toDate_YMD(sDay)+"</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td width=28% align=right colspan=2 >项目/Subject&nbsp;</td>");
		sTemp.append("   <td align=left colspan=2 >&nbsp;车辆贷款结清证明</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td colspan=4 align=center  >&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td colspan=4 align=center  >&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td width=28% align=right colspan=2 >&nbsp;&nbsp;&nbsp;&nbsp;</td>");
		sTemp.append("   <td align=left colspan=2 >&nbsp;&nbsp;&nbsp;&nbsp;车辆信息</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td width=28% align=right colspan=2 >&nbsp;&nbsp;&nbsp;&nbsp;</td>");
		sTemp.append("   <td align=left >车牌号：</td>");
		sTemp.append("   <td align=left >&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td width=28% align=right colspan=2 >&nbsp;&nbsp;&nbsp;&nbsp;</td>");
		sTemp.append("   <td align=left >车架号：</td>");
		sTemp.append("   <td align=left >&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td colspan=4 align=center  >&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td colspan=4 align=center  >&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td width=28% align=right colspan=2 >&nbsp;&nbsp;&nbsp;&nbsp;</td>");
		sTemp.append("   <td align=left colspan=2 >&nbsp;&nbsp;&nbsp;&nbsp;截至"+DataConvert.toDate_YMD(sDay)+"，车主"+sCustomerName+"（身份证: xxxxxxxxxxxxxxxxxx）已经还清与汽车金融(中国)有限公司所签订之《汽车贷款合同》(编号："+sObjectNo+") 项下的全部贷款，至即日止该合同义务已履行完毕。</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td colspan=4 align=center  >&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td width=28% align=right colspan=2 >&nbsp;&nbsp;&nbsp;&nbsp;</td>");
		sTemp.append("   <td align=left colspan=2 >&nbsp;&nbsp;&nbsp;&nbsp;对于在合同履行期间，您给予我们工作的大力支持和配合，本公司在此向您表示诚挚的谢意，衷心欢迎您对我们的工作多提宝贵意见，并真诚地希望能有机会再次为您服务。</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td colspan=4 align=center  >&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td width=28% align=right colspan=2 >&nbsp;&nbsp;&nbsp;&nbsp;</td>");
		sTemp.append("   <td align=left colspan=2 >&nbsp;&nbsp;&nbsp;&nbsp;根据合同约定，现归还您全部有关所购车辆的正本文件如下：</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td width=28% align=right colspan=2 >&nbsp;&nbsp;&nbsp;&nbsp;</td>");
		sTemp.append("   <td align=left colspan=2 >&nbsp;&nbsp;&nbsp;&nbsp;机动车登记证书</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td width=28% align=right colspan=2 >&nbsp;&nbsp;&nbsp;&nbsp;</td>");
		sTemp.append("   <td align=left colspan=2 >此致!</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td width=28% align=right colspan=2 >&nbsp;&nbsp;&nbsp;&nbsp;</td>");
		sTemp.append("   <td align=right colspan=2 >客户服务中心</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td width=28% align=right colspan=2 >&nbsp;&nbsp;&nbsp;&nbsp;</td>");
		sTemp.append("   <td align=right colspan=2 >深圳佰仟金融服务有限公司</td>");
		sTemp.append("   </tr>");
		//sTemp.append("   <tr>");
		//sTemp.append("   <td align=right colspan=4  ><p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</p><p>深圳佰仟金融服务有限公司：&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</p><p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</p> 日期："+DataConvert.toDate_YMD(sDay)+"</td>");
		//sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td align=left colspan=4  >&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("</table>");	
	    
	
	sTemp.append("</div>");	
	sTemp.append("<input type='hidden' name='Method' value='1'>");
	sTemp.append("<input type='hidden' name='SerialNo' value='111'>");
	sTemp.append("<input type='hidden' name='ObjectNo' value='111'>");
	sTemp.append("<input type='hidden' name='ObjectType' value='111'>");
	sTemp.append("<input type='hidden' name='Rand' value=''>");
	sTemp.append("<input type='hidden' name='CompClientID' value='111'>");
	sTemp.append("<input type='hidden' name='PageClientID' value='111'>");
	sTemp.append("</form>");	
	if(sEndSection.equals("1"))
		sTemp.append("<br clear=all style='mso-special-character:line-break;page-break-before:always'>");
	
	String sReportInfo = sTemp.toString();
	String sPreviewContent = "pvw"+java.lang.Math.random();
%>
<%/*~END~*/%>

<%@include file="/FormatDoc/IncludePOFooter.jsp"%>

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

