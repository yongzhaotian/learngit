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
	int iDescribeCount = 6;	//这个是页面需要输入的个数，必须写对：客户化1
%>

<%@include file="/FormatDoc/IncludeFDHeader.jsp"%>

<%
	//获得调查报告数据
	String sGuarantyNo = "";//担保号
	ASResultSet rs2 = Sqlca.getResultSet("select GuarantyNo from FORMATDOC_DATA where SerialNo='"+sSerialNo+"' and ObjectNo ='"+sObjectNo+"'");
	//out.println("select GuarantyNo from FORMATDOC_DATA where SerialNo='"+sObjectNo+"' and ObjectNo ='"+sSerialNo+"'");
	if(rs2.next())
	{
		sGuarantyNo = rs2.getString(1);
	}
	rs2.getStatement().close();	
	
	
	String sSql = "select getItemName('GuarantyList',GuarantyType) as GuarantyTypeName,GuarantyID,"+
				  "GuarantyName,GuarantyLocation,OwnerName,GuarantyRightID,"+
				  "GuarantyDescript,GuarantyPrice,BeginDate,GuarantyAmount1,"+
				  "AboutRate,OwnerTime,EvalNetValue,EvalOrgName,EvalDate,ConfirmValue,GuarantyRate "+
				  "from GUARANTY_INFO where GuarantyID = '"+sGuarantyNo+"'";
	
	String sGuarantyTypeName = "";	//抵押物分类
	String sGuarantyID = "";		//抵押物编号
	String sGuarantyName = "";		//抵押物名称
	String sGuarantyLocation = "";	//抵押物位置
	String sOwnerName = "";			//抵押物的所有权人
	String sGuarantyRightID = "";	//抵押物相关证明文件
	String sGuarantyDescript = "";	//抵押物详细描述
	String sGuarantyPrice = "";		//抵押物原值
	String sGuarantyAmount1 = "";	//数量
	String sAboutRate = "";			//折旧率
	String sOwnerTime = "";			//抵押物使用年限
	String sBeginDate = "";			//购置时间
	String sEvalNetValue = "";		//正式评估价值
	String sEvalOrgName = "";		//抵押物评估机构
	String sEvalDate = "";			//评估时间
	String sConfirmValue = "";		//我行确认价值
	String sGuarantyRate = "";		//抵押率
	
	rs2= Sqlca.getResultSet(sSql);
	if(rs2.next())
	{
		sGuarantyTypeName = rs2.getString("GuarantyTypeName");
		if(sGuarantyTypeName == null) sGuarantyTypeName = "";
		
		sGuarantyID = rs2.getString("GuarantyID");
		if(sGuarantyID == null) sGuarantyID = "";
		
		sGuarantyName = rs2.getString("GuarantyName");
		if(sGuarantyName == null) sGuarantyName = "";
		
		sGuarantyLocation = rs2.getString("GuarantyLocation");
		if(sGuarantyLocation == null) sGuarantyLocation = "";
		
		sOwnerName = rs2.getString("OwnerName");
		if(sOwnerName == null) sOwnerName = "";
		
		sGuarantyRightID = rs2.getString("GuarantyRightID");
		if(sGuarantyRightID == null) sGuarantyRightID = "";
		
		sGuarantyDescript = rs2.getString("GuarantyDescript");
		if(sGuarantyDescript == null) sGuarantyDescript = "";
		
		sGuarantyPrice = DataConvert.toMoney(rs2.getDouble("GuarantyPrice")/10000);
		
		sGuarantyAmount1 = DataConvert.toMoney(rs2.getDouble("GuarantyAmount1"));

		sAboutRate = DataConvert.toMoney(rs2.getDouble("AboutRate"));
		
		sOwnerTime = rs2.getString("OwnerTime");
		if(sOwnerTime == null) sOwnerTime = "";
		
		sBeginDate = rs2.getString("BeginDate");
		if(sBeginDate == null) sBeginDate = "";
		
		sEvalNetValue = DataConvert.toMoney(rs2.getDouble("EvalNetValue")/10000);
		
		sEvalOrgName = rs2.getString("EvalOrgName");
		if(sEvalOrgName == null) sEvalOrgName = "";
		
		sEvalDate = rs2.getString("EvalDate");
		if(sEvalDate == null) sEvalDate = "";
		
		sConfirmValue = DataConvert.toMoney(rs2.getDouble("ConfirmValue")/10000);
		
		sGuarantyRate = DataConvert.toMoney(rs2.getDouble("GuarantyRate"));
		
	}
	rs2.getStatement().close();
	
	//获得编号
	String sTreeNo = "";
	String[] sNo = null;
	String[] sNo1 = null; 
	int iNo=1,j=0;
	sSql = "select TreeNo from FORMATDOC_DATA where ObjectNo = '"+sObjectNo+"' and TreeNo like '06__' and ObjectType = '"+sObjectType+"'";
	rs2 = Sqlca.getResultSet(sSql);
	while(rs2.next())
	{
		sTreeNo += rs2.getString(1)+",";
	}
	rs2.getStatement().close();
	sNo = sTreeNo.split(",");
	sNo1 = new String[sNo.length];
	for(j=0;j<sNo.length;j++)
	{		
		sNo1[j] = "6."+iNo;
		iNo++;
	}
	
	sSql = "select TreeNo from FORMATDOC_DATA where SerialNo = '"+sSerialNo+"'";
	
	rs2 = Sqlca.getResultSet(sSql);
	if(rs2.next()) sTreeNo = rs2.getString(1);
	rs2.getStatement().close();
	for(j=0;j<sNo.length;j++)
	{
		if(sNo[j].equals(sTreeNo.substring(0,4)))  break;
	}
%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=ReportInfo;Describe=生成报告信息;客户化2;]~*/%>
<%
	StringBuffer sTemp=new StringBuffer();
	sTemp.append("<form method='post' action='0660.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>");	
	sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >	");
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=left colspan=20 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >"+sNo1[j]+"、抵押方式</font></td>"); 	
	sTemp.append("   </tr>");	
	sTemp.append("   <tr>");
  	sTemp.append("   <td width=34% align=center class=td1 > 抵押物分类</td>");
	sTemp.append("   <td width=18% align=center class=td1 >"+sGuarantyTypeName+"&nbsp;</td>");
	sTemp.append("   <td width=28% align=center class=td1 > 抵押物编号 </td>");
	sTemp.append("   <td width=20% align=center class=td1 >"+sGuarantyID+"&nbsp;</td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append("   <td width=28% align=center class=td1 > 抵押物名称</td>");
	sTemp.append("   <td width=22% align=center class=td1 >"+sGuarantyName+"&nbsp;</td>");
	sTemp.append("   <td width=28% align=center class=td1 > 抵押物位置/存放地点 </td>");
	sTemp.append("   <td width=22% align=center class=td1 >"+sGuarantyLocation+"&nbsp;</td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append("   <td width=28% align=center class=td1 > 抵押物的所有权人 </td>");
	sTemp.append("   <td width=22% align=center class=td1 >"+sOwnerName+"&nbsp;</td>");
	sTemp.append("   <td width=28% align=center class=td1 > 抵押物相关证明文件 </td>");
	sTemp.append("   <td width=22% align=center class=td1 >"+sGuarantyRightID+"&nbsp;</td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr align=left>");
  	sTemp.append("   <td colspan=4 class=td1 > 抵押物详细描述: <br>"+sGuarantyDescript+"</td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append("   <td width=28% align=center class=td1 >抵押物原值/购置价（万元）</td>");
	sTemp.append("   <td width=22% align=center class=td1 >"+sGuarantyPrice+"&nbsp;</td>");
	sTemp.append("   <td width=28% align=center class=td1 > 建成时间/购置时间 </td>");
	sTemp.append("   <td width=22% align=center class=td1 >"+sBeginDate+"&nbsp;</td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append("   <td width=28% align=center class=td1 > 面积/数量 </td>");
	sTemp.append("   <td width=22% align=center class=td1 >"+sGuarantyAmount1+"&nbsp;</td>");
	sTemp.append("   <td width=28% align=center class=td1 > 折旧率 </td>");
	sTemp.append("   <td width=22% align=center class=td1 >&nbsp;</td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append("   <td width=28% align=center class=td1 > 抵押物使用年限 </td>");
	sTemp.append("   <td width=22% align=center class=td1 >"+sOwnerTime+"&nbsp;</td>");
	sTemp.append("   <td width=28% align=center class=td1 > 剩余年限 </td>");
	sTemp.append("   <td width=22% align=center class=td1 >&nbsp;</td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr align=left>");
  	sTemp.append("   <td colspan=4 class=td1 > 抵押物评估机构 <br>"+sEvalOrgName+"</td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append("   <td width=28% align=center class=td1 > 正式评估价值(万元)</td>");
	sTemp.append("   <td width=22% align=center class=td1 >"+sEvalNetValue+"&nbsp;</td>");
	sTemp.append("   <td width=28% align=center class=td1 > 评估时间</td>");
	sTemp.append("   <td width=22% align=center class=td1 >"+sEvalDate+"&nbsp;</td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append("   <td width=28% align=center class=td1 > 我行确认价值(万元)</td>");
	sTemp.append("   <td width=22% align=center class=td1 >"+sConfirmValue+"&nbsp;</td>");
	sTemp.append("   <td width=28% align=center class=td1 > 抵押率</td>");
	sTemp.append("   <td width=22% align=center class=td1 >"+sGuarantyRate+"&nbsp;</td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append("   <td align=left colspan=4 class=td1 "+myShowTips(sMethod)+" >描述抵押物是否有财产共有人？共有人是否出具同意抵押的书面文件？<br></td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append("   <td align=left colspan=4 class=td1 "+myShowTips(sMethod)+" ><p>多次或分割抵押状况</p>");
  	sTemp.append("     <p>1、若以同一抵押物设定若干抵押的，须提交已告知各债权人的书面证明，并提供将来对债权人的清偿顺序；</p>");
  	sTemp.append("     <p>2、若抵押物为整体建筑的一部分，应介绍整体建筑情况和其他房产权属情况；</p>");
  	sTemp.append("     3、若以前做过抵押，应介绍当时抵押情况，债务是否结清。");
	sTemp.append("   </td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append("   <td colspan='4' align=left class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe1' style='width:100%; height:150'",getUnitData("describe1",sData)));
	sTemp.append("   <br>");
	sTemp.append("&nbsp;</td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append("   <td colspan=4 align=left class=td1 "+myShowTips(sMethod)+" ><p>抵押物的附属情况分析</p>");
  	sTemp.append("    抵押物的附属物名称、面积、性质（是否划拨土地或是否公益性建筑）。");
	sTemp.append("   </td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append("   <td colspan='4' align=left class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe2' style='width:100%; height:150'",getUnitData("describe2",sData)));
	sTemp.append("   <br>");
	sTemp.append("&nbsp;</td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append("   <td colspan=4 align=left class=td1 "+myShowTips(sMethod)+" ><p>抵押物价值稳定性分析</p>");
  	sTemp.append("   对抵押物的成新率(若厂房须考虑折旧率)、地段、市场价格波动性进行分析，抵押物的预期价值上涨还是下降趋势，是否能覆盖贷款金额、不致产生缺口。");
	sTemp.append("   </td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append("   <td colspan='4' align=left class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe3' style='width:100%; height:150'",getUnitData("describe3",sData)));
	sTemp.append("   <br>");
	sTemp.append("&nbsp;</td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append("   <td align=left colspan=4 class=td1 "+myShowTips(sMethod)+" ><p>抵押物变现能力分析</p>");
  	sTemp.append("   对抵押物的市场变现能力做出预测分析：是否可以迅速的出售，市场对抵押物的需求大小，变现清偿时是否会产生一些法律及销售费用等。");
	sTemp.append("   </td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append("   <td colspan='4' align=left class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe4' style='width:100%; height:150'",getUnitData("describe4",sData)));
	sTemp.append("&nbsp;</td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append("   <td align=left colspan=4 class=td1 "+myShowTips(sMethod)+" ><p>对抵押物的法律控制能力</p>");
  	sTemp.append("   描述抵押物的来源如何，产权是否明晰，有无法律纠纷，是否拥有优先受偿权。");
  	sTemp.append("   </td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append("   <td colspan='4' align=left class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe5' style='width:100%; height:150'",getUnitData("describe5",sData)));
	sTemp.append("   <br>");
	sTemp.append("&nbsp;</td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append("   <td align=left colspan=4 class=td1 "+myShowTips(sMethod)+" ><p>其他情况分析</p>");
  	sTemp.append("   对抵押物其他未尽事项，进行分析。"); 
  	sTemp.append("   </td>");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
  	sTemp.append("   <td colspan='4' align=left class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe6' style='width:100%; height:150'",getUnitData("describe6",sData)));
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
	editor_generate('describe2');		//需要html编辑,input是没必要
	editor_generate('describe3');		//需要html编辑,input是没必要
	editor_generate('describe4');		//需要html编辑,input是没必要
	editor_generate('describe5');		//需要html编辑,input是没必要
	editor_generate('describe6');		//需要html编辑,input是没必要
<%
	}
%>	
</script>	
	
<%@ include file="/IncludeEnd.jsp"%>