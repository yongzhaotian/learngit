<%@page import="com.amarsoft.app.accounting.config.loader.DateFunctions"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main00;Describe=注释区;]~*/%>
	<%
	/*
		协审打印表
		Author:   awang  2015.02.26

	 */
	%>
<%/*~END~*/%>



<%@include file="/FormatDoc/IncludePOHeader.jsp"%>

<%
      String ssObjectNo=""; //合同编号
      String sCheckBank=""; //是否已确认代扣还款借记卡卡号及背后本人签名
      String sCheckContent="";//申请资料是否已查看原件，复印件（影像件）与原件内容完全一致
      String sCheckItems="";//是否已明确告知申请人贷款相关注意事项，并告知其还款义务
      String sCheckPhone="";//申请人手机号是否已核实
      String sCheckWorkTel="";//单位电话是否已核实
      String sCheckContactTel="";//联系人电话是否已核实
      String sCheckSino="";//是否查询申请人社保信息
      String sCheckWork="";//是否网络查询申请人单位信息
      String sCompanyWith="";//陪同人数
      String sCheckPartner="";//陪同人员是否有申请
      String sPartnerName="";//陪同人姓名
      String sPhoneBrand="";//申请人目前所用手机品牌
      String sPhoneType="";//型号
      String sPhoneStatus="";//目前所用手机新旧程度
      String sStoretoHome="";//门店与家庭住址距离
      String sStoretoWork="";//门店与工作地址距离
      String sHometoWork="";//家庭住址与工作地址距离
      String sRemarks="";//异常备注
      String sPartnerPhone="";//陪同人手机号
      String sContractInputDate=""; //合同申请日期
      String sInputDate=""; //协审日期
      String sInputUser="";//协审销售代表
%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=ReportInfo;Describe=生成协审信息;]~*/%>
<%
//获得调查报告数据
String sSql = "select ObjectNo as ObjectNo,getItemName('YesNo',CheckBank) as CheckBank,getItemName('YesNo',CheckContent) as CheckContent,getItemName('YesNo',CheckItems) as CheckItems,getItemName('YesNo',CheckPhone) as CheckPhone,"
                       +" getItemName('YesNo',CheckWorkTel) as CheckWorkTel,getItemName('YesNo',CheckContactTel) as CheckContactTel,getItemName('YesNo',CheckSino) as CheckSino,getItemName('YesNo',CheckWork) as CheckWork,CompanyWith as CompanyWith,getItemName('YesNo',CheckPartner) as CheckPartner,"
                       +" PartnerName as PartnerName,PhoneBrand as PhoneBrand,PhoneType as PhoneType,getItemName('PhoneStatus',PhoneStatus) as PhoneStatus,StoretoHome as StoretoHome,StoretoWork as StoretoWork,"
                       +" HometoWork as HometoWork,Remarks as Remarks,PartnerPhone as PartnerPhone,getUserName(InputUser) as InputUser,InputDate as InputDate from Assistinvestigate where ObjectNo="+sObjectNo;

ASResultSet rs2 = Sqlca.getResultSet(sSql);
	if(rs2.next()){
		ssObjectNo=rs2.getString("ObjectNo");
		sCheckBank=rs2.getString("CheckBank");
		sCheckContent=rs2.getString("CheckContent");
		sCheckItems=rs2.getString("CheckItems");
		sCheckPhone=rs2.getString("CheckPhone");
		sCheckWorkTel=rs2.getString("CheckWorkTel");
		sCheckContactTel=rs2.getString("CheckContactTel");
		sCheckSino=rs2.getString("CheckSino");
		sCheckWork=rs2.getString("CheckWork");
		sCompanyWith=rs2.getString("CompanyWith");
		sCheckPartner=rs2.getString("CheckPartner");
		sPartnerName=rs2.getString("PartnerName");
		sPhoneBrand=rs2.getString("PhoneBrand");
		sPhoneType=rs2.getString("PhoneType");
		sPhoneStatus=rs2.getString("PhoneStatus");
		sStoretoHome=rs2.getString("StoretoHome");
		sStoretoWork=rs2.getString("StoretoWork");
		sHometoWork=rs2.getString("HometoWork");
		sRemarks=rs2.getString("Remarks");
		sPartnerPhone=rs2.getString("PartnerPhone");
		sContractInputDate = Sqlca.getString(new SqlObject("SELECT FT1.PHASEOPINION4 FROM FLOW_TASK FT1 WHERE SERIALNO=(SELECT MIN(FT2.SERIALNO) FROM FLOW_TASK FT2 WHERE FT2.OBJECTNO=:OBJECTNO)").setParameter("OBJECTNO", sObjectNo));
		sInputDate=rs2.getString("InputDate");
		sInputUser=rs2.getString("InputUser");
		
		
		if(ssObjectNo == null) ssObjectNo ="&nbsp;";
		if(sCheckBank == null) sCheckBank ="&nbsp;";
		if(sCheckContent == null) sCheckContent ="&nbsp;";
		if(sCheckItems == null) sCheckItems ="&nbsp;";
		if(sCheckPhone == null) sCheckPhone ="&nbsp;";
		if(sCheckWorkTel == null) sCheckWorkTel ="&nbsp;";
		if(sCheckContactTel == null) sCheckContactTel ="&nbsp;";
		if(sCheckSino == null) sCheckSino ="&nbsp;";
		if(sCheckWork == null) sCheckWork ="&nbsp;";
		if(sCompanyWith == null) sCompanyWith ="&nbsp;";
		if(sCheckPartner == null) sCheckPartner ="&nbsp;";
		if(sPartnerName == null) sPartnerName ="&nbsp;";
		if(sPhoneBrand == null) sPhoneBrand ="&nbsp;";
		if(sPhoneType == null) sPhoneType ="&nbsp;";
		if(sPhoneStatus == null) sPhoneStatus ="&nbsp;";
		if(sStoretoHome == null) sStoretoHome ="&nbsp;";
		if(sStoretoWork == null) sStoretoWork ="&nbsp;";
		if(sHometoWork == null) sHometoWork ="&nbsp;";
		if(sRemarks == null) sRemarks ="&nbsp;";
		if(sPartnerPhone == null) sPartnerPhone ="&nbsp;";
		if(sContractInputDate == null) sContractInputDate ="&nbsp;";
		if(sInputDate==null) sInputDate ="&nbsp;";
		if(sInputUser==null) sInputUser="&nbsp;";
	}
	rs2.getStatement().close();
	
  	
%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=ReportInfo;Describe=生成报告信息;客户化2;]~*/%>
<%
	StringBuffer sTemp=new StringBuffer();
	sTemp.append("	<form method='post' action='05.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable >");	
	sTemp.append("<table class=table1 align=center  border=0 cellspacing=0 cellpadding=0  width='810' >	");
	
/* 	sTemp.append("<tr>");
	sTemp.append("<td colspan=10 align=left><img src='"+sWebRootPath+"/FormatDoc/Images/122.jpg' /></td>");
	sTemp.append("</tr>"); */
	
	sTemp.append("<tr>");	
	sTemp.append("<td colspan=3 rowspan=2 align=left><img src='"+sWebRootPath+"/FormatDoc/Images/122.jpg' /></td>");
	sTemp.append("<td class=td1 rowspan=2 align=center colspan=5 bgcolor=#aaaaaa ><font style=' font-size: 16pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >销售协审信息表</font></td> ");	
	sTemp.append("<td colspan=2 align=left class=td1 ><img src="+request.getContextPath()+"/barcode?msg="+sObjectNo+"&height=7 width='150' height='40' />&nbsp;</td>");
	sTemp.append("</tr>");
	
	sTemp.append("<tr>");
	sTemp.append("<td colspan=3 align=center class=td1 >合同编号："+sObjectNo+"&nbsp;申请日期："+sContractInputDate+"&nbsp;</td>");
	sTemp.append("</tr>");
	
	sTemp.append("<tr>");
	sTemp.append("<td colspan=1 align=center class=td1 >项目</td>");
	sTemp.append("<td colspan=9 align=left class=td1 >具体内容</td>");
	sTemp.append("</tr>");
	
	sTemp.append("<tr  style='height:20px;' >");
	sTemp.append("<td colspan=1 align=center class=td1 >申请表</td>");
	sTemp.append("<td colspan=9 align=left class=td1 >是否已确认代扣还款借记卡卡号及背后本人签名:  "+sCheckBank+"</td>");
	sTemp.append("</tr>");

	sTemp.append("<tr  style='height:20px;' >");
	sTemp.append("<td colspan=1 align=center class=td1 >申请资料</td>");
	sTemp.append("<td colspan=9 align=left class=td1 >申请资料是否已查看原件，复印件（影像件）与原件内容完全一致:  "+sCheckContent+"</td>");
	sTemp.append("</tr>");
	
	sTemp.append("<tr  style='height:20px;' >");
	sTemp.append("<td colspan=1 align=center class=td1 >告知事项</td>");
	sTemp.append("<td colspan=9 align=left class=td1 >是否已明确告知申请人贷款相关注意事项，并告知其还款义务: "+sCheckItems+"</td>");
	sTemp.append("</tr>");
	
	sTemp.append("<tr  style='height:20px;' >");
	sTemp.append("<td rowspan=3 colspan=1 align=center class=td1 >电话核实</td>");
	sTemp.append("<td rowspan=1 colspan=9 align=left class=td1 >申请人手机号是否已核实: "+sCheckPhone+"</td>");
	sTemp.append("</tr>");
	sTemp.append("<tr  style='height:20px;'>");
	sTemp.append("<td rowspan=1 colspan=9 align=left class=td1 >单位电话是否已核实: "+sCheckWorkTel+"</td>");
	sTemp.append("</tr>");
	sTemp.append("<tr  style='height:20px;'>");
	sTemp.append("<td rowspan=1 colspan=9 align=left class=td1 >联系人电话是否已核实: "+sCheckContactTel+"</td>");
	sTemp.append("</tr>");
	
	sTemp.append("<tr  style='height:20px;'>");
	sTemp.append("<td rowspan=2 colspan=1 align=center class=td1 >网络核实</td>");
	sTemp.append("<td rowspan=1 colspan=9 align=left class=td1 >是否查询申请人社保信息: "+sCheckSino+"</td>");
	sTemp.append("</tr>");
	sTemp.append("<tr  style='height:20px;'>");
	sTemp.append("<td rowspan=1 colspan=9 align=left class=td1 >是否网络查询申请人单位信息: "+sCheckWork+"</td>");
	sTemp.append("</tr>");
	
	sTemp.append("<tr  style='height:20px;'>");
	sTemp.append("<td rowspan=5 colspan=1 align=center class=td1 >其他信息</td>");
	sTemp.append("<td rowspan=1 colspan=9 align=left class=td1 >陪同人数: "+sCompanyWith+"</td>");
	sTemp.append("</tr>");
	sTemp.append("<tr  style='height:20px;'>");
	sTemp.append("<td rowspan=1 colspan=3 align=left class=td1 >陪同人员是否有申请: "+sCheckPartner+"</td>");
	sTemp.append("<td rowspan=1 colspan=3 align=left class=td1 >陪同人姓名: "+sPartnerName+"</td>");
	sTemp.append("<td rowspan=1 colspan=3 align=left class=td1 >手机号: "+sPartnerPhone+"</td>");
	sTemp.append("</tr>");
	sTemp.append("<tr  style='height:20px;'>");
	sTemp.append("<td rowspan=1 colspan=5 align=left class=td1 >申请人目前所用同类商品品牌: "+sPhoneBrand+"</td>");
	sTemp.append("<td rowspan=1 colspan=4 align=left class=td1 >型号: "+sPhoneType+"</td>");
	sTemp.append("</tr>");
	sTemp.append("<tr  style='height:20px;'>");
	sTemp.append("<td rowspan=1 colspan=9 align=left class=td1 >目前所用手机新旧程度（或者摩托车等）: "+sPhoneStatus+"</td>");
	sTemp.append("</tr>");
	sTemp.append("<tr  style='height:20px;'>");
	sTemp.append("<td rowspan=1 colspan=3 align=left class=td1 >门店与家庭住址距离: "+sStoretoHome+"km</td>");
	sTemp.append("<td rowspan=1 colspan=3 align=left class=td1 >门店与工作地址距离: "+sStoretoWork+"km</td>");
	sTemp.append("<td rowspan=1 colspan=3 align=left class=td1 >家庭住址与工作地址距离: "+sHometoWork+"km</td>");
	sTemp.append("</tr>");
	sTemp.append("<tr  style='height:40px;'>");
	sTemp.append("<td rowspan=1 colspan=1 align=left class=td1 >备注: </td>");
	sTemp.append("<td rowspan=1 colspan=9 align=left class=td1 >"+sRemarks+"</td>");
	sTemp.append("</tr>");
	
	sTemp.append("<tr  style='height:20px;'>");
	sTemp.append("<td rowspan=1 colspan=10 align=center class=td1 >销售代表 :"+sInputUser+"  日期:"+sInputDate+" </td>");
	sTemp.append("</tr>");
	
	sTemp.append("<input type='hidden' name='Method' value='1'>");
	sTemp.append("<input type='hidden' name='SerialNo' value='111'>");
	sTemp.append("<input type='hidden' name='ObjectNo' value='111'>");
	sTemp.append("<input type='hidden' name='ObjectType' value='111'>");
	sTemp.append("<input type='hidden' name='Rand' value=''>");
	sTemp.append("<input type='hidden' name='CompClientID' value='111'>");
	sTemp.append("<input type='hidden' name='PageClientID' value='111'>");
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