<%@ page contentType="text/html; charset=GBK"%><%@
include file="/IncludeBegin.jsp"%><%

	//  ��ȡҳ�����
	String sSSerialNo =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("SSerialNo"));
	String sRelaSerialNo =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ApplySerialNo"));
	String sTransferType =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("TransferType"));
	String sApplyType =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ApplyType"));

	if(sSSerialNo == null) sSSerialNo="";
	if(sRelaSerialNo == null) sRelaSerialNo = ""; 
	if(sTransferType == null) sTransferType = ""; 
	if(sApplyType == null) sApplyType = ""; 

	/* 
	ҳ��˵���� ͨ�����鶨������Tab���ҳ��ʾ��
	*/
	//����tab���飺
	//������0.�Ƿ���ʾ, 1.���⣬2.URL��3��������
	String sTabStrip[][] = {
			{"false", "Э������", "/BusinessManage/CollectionManage/TransferAutoDealList.jsp", "TransferType="+sTransferType+"&SerialNo="+sSSerialNo+"&RelaSerialNo="+sRelaSerialNo},
	};
%><%@ include file="/Resources/CodeParts/Tab01.jsp"%>
<script type="text/javascript">
AsControl.OpenView("/BusinessManage/CollectionManage/TransferAutoDealList.jsp","TransferType="+"<%=sTransferType%>"+"&SerialNo="+"<%=sSSerialNo%>"+"&RelaSerialNo="+"<%=sRelaSerialNo%>"+"&ApplyType="+"<%=sApplyType%>","_self","");
</script>
<%@ include file="/IncludeEnd.jsp"%>
