<%@page import="com.amarsoft.app.accounting.config.loader.DateFunctions"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main00;Describe=ע����;]~*/%>
	<%
	/*
		Э���ӡ��
		Author:   awang  2015.02.26

	 */
	%>
<%/*~END~*/%>



<%@include file="/FormatDoc/IncludePOHeader.jsp"%>

<%
      String ssObjectNo=""; //��ͬ���
      String sCheckBank=""; //�Ƿ���ȷ�ϴ��ۻ����ǿ����ż�������ǩ��
      String sCheckContent="";//���������Ƿ��Ѳ鿴ԭ������ӡ����Ӱ�������ԭ��������ȫһ��
      String sCheckItems="";//�Ƿ�����ȷ��֪�����˴������ע���������֪�仹������
      String sCheckPhone="";//�������ֻ����Ƿ��Ѻ�ʵ
      String sCheckWorkTel="";//��λ�绰�Ƿ��Ѻ�ʵ
      String sCheckContactTel="";//��ϵ�˵绰�Ƿ��Ѻ�ʵ
      String sCheckSino="";//�Ƿ��ѯ�������籣��Ϣ
      String sCheckWork="";//�Ƿ������ѯ�����˵�λ��Ϣ
      String sCompanyWith="";//��ͬ����
      String sCheckPartner="";//��ͬ��Ա�Ƿ�������
      String sPartnerName="";//��ͬ������
      String sPhoneBrand="";//������Ŀǰ�����ֻ�Ʒ��
      String sPhoneType="";//�ͺ�
      String sPhoneStatus="";//Ŀǰ�����ֻ��¾ɳ̶�
      String sStoretoHome="";//�ŵ����ͥסַ����
      String sStoretoWork="";//�ŵ��빤����ַ����
      String sHometoWork="";//��ͥסַ�빤����ַ����
      String sRemarks="";//�쳣��ע
      String sPartnerPhone="";//��ͬ���ֻ���
      String sContractInputDate=""; //��ͬ��������
      String sInputDate=""; //Э������
      String sInputUser="";//Э�����۴���
%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=ReportInfo;Describe=����Э����Ϣ;]~*/%>
<%
//��õ��鱨������
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

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=ReportInfo;Describe=���ɱ�����Ϣ;�ͻ���2;]~*/%>
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
	sTemp.append("<td class=td1 rowspan=2 align=center colspan=5 bgcolor=#aaaaaa ><font style=' font-size: 16pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >����Э����Ϣ��</font></td> ");	
	sTemp.append("<td colspan=2 align=left class=td1 ><img src="+request.getContextPath()+"/barcode?msg="+sObjectNo+"&height=7 width='150' height='40' />&nbsp;</td>");
	sTemp.append("</tr>");
	
	sTemp.append("<tr>");
	sTemp.append("<td colspan=3 align=center class=td1 >��ͬ��ţ�"+sObjectNo+"&nbsp;�������ڣ�"+sContractInputDate+"&nbsp;</td>");
	sTemp.append("</tr>");
	
	sTemp.append("<tr>");
	sTemp.append("<td colspan=1 align=center class=td1 >��Ŀ</td>");
	sTemp.append("<td colspan=9 align=left class=td1 >��������</td>");
	sTemp.append("</tr>");
	
	sTemp.append("<tr  style='height:20px;' >");
	sTemp.append("<td colspan=1 align=center class=td1 >�����</td>");
	sTemp.append("<td colspan=9 align=left class=td1 >�Ƿ���ȷ�ϴ��ۻ����ǿ����ż�������ǩ��:  "+sCheckBank+"</td>");
	sTemp.append("</tr>");

	sTemp.append("<tr  style='height:20px;' >");
	sTemp.append("<td colspan=1 align=center class=td1 >��������</td>");
	sTemp.append("<td colspan=9 align=left class=td1 >���������Ƿ��Ѳ鿴ԭ������ӡ����Ӱ�������ԭ��������ȫһ��:  "+sCheckContent+"</td>");
	sTemp.append("</tr>");
	
	sTemp.append("<tr  style='height:20px;' >");
	sTemp.append("<td colspan=1 align=center class=td1 >��֪����</td>");
	sTemp.append("<td colspan=9 align=left class=td1 >�Ƿ�����ȷ��֪�����˴������ע���������֪�仹������: "+sCheckItems+"</td>");
	sTemp.append("</tr>");
	
	sTemp.append("<tr  style='height:20px;' >");
	sTemp.append("<td rowspan=3 colspan=1 align=center class=td1 >�绰��ʵ</td>");
	sTemp.append("<td rowspan=1 colspan=9 align=left class=td1 >�������ֻ����Ƿ��Ѻ�ʵ: "+sCheckPhone+"</td>");
	sTemp.append("</tr>");
	sTemp.append("<tr  style='height:20px;'>");
	sTemp.append("<td rowspan=1 colspan=9 align=left class=td1 >��λ�绰�Ƿ��Ѻ�ʵ: "+sCheckWorkTel+"</td>");
	sTemp.append("</tr>");
	sTemp.append("<tr  style='height:20px;'>");
	sTemp.append("<td rowspan=1 colspan=9 align=left class=td1 >��ϵ�˵绰�Ƿ��Ѻ�ʵ: "+sCheckContactTel+"</td>");
	sTemp.append("</tr>");
	
	sTemp.append("<tr  style='height:20px;'>");
	sTemp.append("<td rowspan=2 colspan=1 align=center class=td1 >�����ʵ</td>");
	sTemp.append("<td rowspan=1 colspan=9 align=left class=td1 >�Ƿ��ѯ�������籣��Ϣ: "+sCheckSino+"</td>");
	sTemp.append("</tr>");
	sTemp.append("<tr  style='height:20px;'>");
	sTemp.append("<td rowspan=1 colspan=9 align=left class=td1 >�Ƿ������ѯ�����˵�λ��Ϣ: "+sCheckWork+"</td>");
	sTemp.append("</tr>");
	
	sTemp.append("<tr  style='height:20px;'>");
	sTemp.append("<td rowspan=5 colspan=1 align=center class=td1 >������Ϣ</td>");
	sTemp.append("<td rowspan=1 colspan=9 align=left class=td1 >��ͬ����: "+sCompanyWith+"</td>");
	sTemp.append("</tr>");
	sTemp.append("<tr  style='height:20px;'>");
	sTemp.append("<td rowspan=1 colspan=3 align=left class=td1 >��ͬ��Ա�Ƿ�������: "+sCheckPartner+"</td>");
	sTemp.append("<td rowspan=1 colspan=3 align=left class=td1 >��ͬ������: "+sPartnerName+"</td>");
	sTemp.append("<td rowspan=1 colspan=3 align=left class=td1 >�ֻ���: "+sPartnerPhone+"</td>");
	sTemp.append("</tr>");
	sTemp.append("<tr  style='height:20px;'>");
	sTemp.append("<td rowspan=1 colspan=5 align=left class=td1 >������Ŀǰ����ͬ����ƷƷ��: "+sPhoneBrand+"</td>");
	sTemp.append("<td rowspan=1 colspan=4 align=left class=td1 >�ͺ�: "+sPhoneType+"</td>");
	sTemp.append("</tr>");
	sTemp.append("<tr  style='height:20px;'>");
	sTemp.append("<td rowspan=1 colspan=9 align=left class=td1 >Ŀǰ�����ֻ��¾ɳ̶ȣ�����Ħ�г��ȣ�: "+sPhoneStatus+"</td>");
	sTemp.append("</tr>");
	sTemp.append("<tr  style='height:20px;'>");
	sTemp.append("<td rowspan=1 colspan=3 align=left class=td1 >�ŵ����ͥסַ����: "+sStoretoHome+"km</td>");
	sTemp.append("<td rowspan=1 colspan=3 align=left class=td1 >�ŵ��빤����ַ����: "+sStoretoWork+"km</td>");
	sTemp.append("<td rowspan=1 colspan=3 align=left class=td1 >��ͥסַ�빤����ַ����: "+sHometoWork+"km</td>");
	sTemp.append("</tr>");
	sTemp.append("<tr  style='height:40px;'>");
	sTemp.append("<td rowspan=1 colspan=1 align=left class=td1 >��ע: </td>");
	sTemp.append("<td rowspan=1 colspan=9 align=left class=td1 >"+sRemarks+"</td>");
	sTemp.append("</tr>");
	
	sTemp.append("<tr  style='height:20px;'>");
	sTemp.append("<td rowspan=1 colspan=10 align=center class=td1 >���۴��� :"+sInputUser+"  ����:"+sInputDate+" </td>");
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
	//�ͻ���3
	var config = new Object();  
<%
	}
%>	
</script>	
	
<%@ include file="/IncludeEnd.jsp"%>