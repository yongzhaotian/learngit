<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		--ҳ��˵��:P2Pƽ̨�������--
	 */
	String PG_TITLE = "P2Pƽ̨�������"; // ��������ڱ��� <title> PG_TITLE </title>
	String  sP2pType =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("p2pType"));
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;P2P��ͬ��ѯ&nbsp;&nbsp;"; //Ĭ�ϵ�����������
	if( "AirtualStore".equals(sP2pType) ){	//��Ǯô�����ŵ��p2p��ͬ
		PG_CONTENT_TITLE = "&nbsp;&nbsp;��Ǯô�����ŵ�P2P��ͬ��ѯ&nbsp;&nbsp;"; //Ĭ�ϵ�����������
	}else if( "EBuyFun".equals(sP2pType) ){	//���װ۷֡����̻����Ϊ��4403000403��
		PG_CONTENT_TITLE = "&nbsp;&nbsp;�װ۷�P2P��ͬ��ѯ&nbsp;&nbsp;"; //Ĭ�ϵ�����������
	}else{	//��ͨ���Ѵ���p2p��ͬ
		PG_CONTENT_TITLE = "&nbsp;&nbsp;P2P��ͬ��ѯ&nbsp;&nbsp;"; //Ĭ�ϵ�����������
	}
	
	String PG_CONTNET_TEXT = "��������б�";//Ĭ�ϵ�����������
	String PG_LEFT_WIDTH = "0";//Ĭ�ϵ�treeview���

	//���ҳ�����

%><%@include file="/Resources/CodeParts/Main04.jsp"%>
<script type="text/javascript">
	myleft.width=1;
	AsControl.OpenView("/SystemManage/P2PManage/P2PContractQueryList.jsp","","right","");
</script>
<%@ include file="/IncludeEnd.jsp"%>