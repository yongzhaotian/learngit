<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%
	String PG_TITLE = "���Ļ��������"; // ��������ڱ��� <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;���Ļ��������&nbsp;&nbsp;"; //Ĭ�ϵ�����������
	String PG_CONTNET_TEXT = "���Ժ�";//Ĭ�ϵ�����������
	String PG_LEFT_WIDTH = "200";//Ĭ�ϵ�treeview���
	
	// ����Treeview
    HTMLTreeView tviTemp = new HTMLTreeView(Sqlca, CurComp, sServletURL, PG_TITLE, "right");
    tviTemp.ImageDirectory = sResourcesPath; 			// ������Դ�ļ�Ŀ¼��ͼƬ��CSS��
    tviTemp.toRegister = false; 						// �����Ƿ���Ҫ�����еĽڵ�ע��Ϊ���ܵ㼰Ȩ�޵�
    tviTemp.TriggerClickEvent = true; 					// �Ƿ��Զ�����ѡ���¼�

    // ������ͼ�ṹ���Ӵ����CODE_LIBRARY�в�ѯ��ApplyMainҳ�������Ч�����Ͳ˵���Ϣ
    String sqlTreeView = "FROM CODE_LIBRARY WHERE CODENO = 'BOMTRManage' AND ISINUSE = '1' ";
    tviTemp.initWithSql("SORTNO", "ITEMNAME", "ATTRIBUTE5", "", "", sqlTreeView, "ORDER BY ITEMNO", Sqlca);
%>
<%@include file="/Resources/CodeParts/Main04.jsp"%>

<!-- <script type="text/javascript">
	AsControl.OpenView("/CustomService/BusinessConsult/CancelPayPkgApplyList.jsp", "", "right", "");
</script> -->
<script type="text/javascript"> 
	/*~[Describe=treeview����ѡ���¼�;InputParam=��;OutPutParam=��;]~*/
    function TreeViewOnClick() {
        var sCurItemDescribe = getCurTVItem().value;        
        sCurItemDescribe = sCurItemDescribe.split("@");
        sCurItemDescribe1 = sCurItemDescribe[0];
        sCurItemDescribe2 = sCurItemDescribe[1];
        sCurItemDescribe3 = sCurItemDescribe[2];
    
        if(sCurItemDescribe1 != "root") {
        	AsControl.OpenComp(sCurItemDescribe1, "ComponentName=���Ļ��������", "right");
            setTitle(getCurTVItem().name);
        }
    }
    
    /*~[Describe=����treeview;InputParam=��;OutPutParam=��;]~*/
    function startMenu() {
        <%=tviTemp.generateHTMLTreeView() %>
    }
            
    </script>
<% /*~END~*/ %>
<script type="text/javascript">
    startMenu();
    expandNode('root');
</script>
<%/*~END~*/%>
<%@ include file="/IncludeEnd.jsp"%>
	