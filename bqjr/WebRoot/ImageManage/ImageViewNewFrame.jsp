<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
/*
	ҳ��˵��: ʾ�����¿��ҳ��
 */
%><%@include file="/Resources/CodeParts/Frame02.jsp"%>
<%
	//�ĵ����
	String sDocNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("DocNo"));
	String sTypeNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("TypeNo"));
	//��ȡ�жϴ�ǰ���Ǵ�������ݲ���
	String uploadPeriod = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("uploadPeriod"));
    System.out.println("-------"+sDocNo+"-------"+sTypeNo);
	if (sTypeNo == null) sTypeNo = "";
	if (sDocNo == null) sDocNo = "";
%>

<script type="text/javascript">
	AsControl.OpenView("/AppConfig/Document/AttachmentChooseDialog3.jsp","DocNo=<%=sDocNo%>&TypeNo=<%=sTypeNo%>&uploadPeriod=<%=uploadPeriod%>","rightup");
	AsControl.OpenView("/ImageManage/ImageViewInfo.jsp","ObjectNo=<%=sDocNo%>&TypeNo=<%=sTypeNo%>&uploadPeriod=<%=uploadPeriod%>","rightdown");
</script>

<%@ include file="/IncludeEnd.jsp"%>
