<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMDAJAX.jsp"%>
<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Part00;Describe=ע����;]~*/%>
	<%
	/*
		Content: ȡ�ö�Ӧ�ı�������
		Input Param: sReportNo ������           
	 */
	%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Part01;Describe=�����������ȡ����,�߼�����;]~*/%>
<%
    //�������
	String sReturnValue = "02";//--��ʾ�Ƿ�Ϊ��ϸ����
	
	//���ҳ������������� ��ʱΪ������
	String sReportNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ReportNo"));

	//��ȡ���񱨱�����
	String sSql = "select MODELNO from REPORT_RECORD  where  ReportNo  =:ReportNo ";
	String sModelno = Sqlca.getString(new SqlObject(sSql).setParameter("ReportNo",sReportNo));	
	if(sModelno == null) sModelno = "";
	
	sSql = "select MODELABBR from REPORT_CATALOG  where  ModelNo  =:ModelNo ";
	String sModelLabbr = Sqlca.getString(new SqlObject(sSql).setParameter("ModelNo",sModelno));	
	if(sModelLabbr == null) sModelLabbr = "";
	
	if(sModelLabbr.equals("����˵��")){
		sReturnValue ="00";
	}else if(sModelLabbr.equals("�ͻ��ʲ��븺ծ��ϸ")){
		sReturnValue ="01";
	}else{
		sReturnValue = sModelno;
	}
%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Part02;Describe=����ֵ����;]~*/%>
<%	
%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Part03;Describe=����ֵ;]~*/%>
<%	
	out.println(sReturnValue);
%>
<%/*~END~*/%>
<%@ include file="/IncludeEndAJAX.jsp"%>