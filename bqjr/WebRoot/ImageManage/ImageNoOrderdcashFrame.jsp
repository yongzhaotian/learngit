<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
/*
	ҳ��˵��: ʾ�����¿��ҳ��
 */
%><%@include file="/Resources/CodeParts/Frame02.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "�������Ų�ѯ��Ȩ��"; // ��������ڱ��� <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;�������Ų�ѯ��Ȩ��&nbsp;&nbsp;"; //Ĭ�ϵ�����������
	%>
<%/*~END~*/%>

<%
	//�ĵ����
	String sDocNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("DocNo"));
	String sTypeNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("TypeNo"));
    System.out.println("-------sDocNo:"+sDocNo+",-------sTypeNo:"+sTypeNo);
	if (sTypeNo == null) sTypeNo = "";
	if (sDocNo == null) sDocNo = "";
	
%>

<script type="text/javascript">
	AsControl.OpenView("/AppConfig/Document/AttachmentChooseNoOrder.jsp","DocNo=<%=sDocNo%>&TypeNo=<%=sTypeNo%>","rightup");
	AsControl.OpenView("/ImageManage/ImageViewNoOrderInfo.jsp","ObjectNo=<%=sDocNo%>&TypeNo=<%=sTypeNo%>","rightdown");
</script>

<%@ include file="/IncludeEnd.jsp"%>
