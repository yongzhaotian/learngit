<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main00;Describe=ע����;]~*/%>
    <%
    /*
        Author: cbsu 2009-10-20
        Tester:
        Content: �����ֵTabҳ�棬����"��ֵ��Ϣ", "�ͻ���Ϣ", "�����Ϣ", "��ͬ��Ϣ"�ĸ�Tabҳ
        Input Param:
        Output param:
        History Log: 
     */
    %>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main01;Describe=����ҳ������;]~*/%>
    <%
    String PG_TITLE = "��ֵ��������"; // ��������ڱ��� <title> PG_TITLE </title>
    %>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main02;Describe=�����������ȡ����;]~*/%>
    <%
    //����������    
    String sReserveFlag = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ReserveFlag")); //����ģʽ
    String sAccountMonth = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("AccountMonth")); //����·�
    String sDueBillNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("DueBillNo")); //��ݺ�
    String sCustomerType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("CustomerType")); //�ͻ�����
    String sCustomerID = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("CustomerID")); //�ͻ����
    %>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main03;Describe=�����ǩ;]~*/%>
<script type="text/javascript">
    var tabstrip = new Array();
    <%
        String sTabStrip[][] = {
                                {"1","��ֵ��Ϣ","doTabAction(\'firstTab\')"},
                                {"2","�ͻ���Ϣ","doTabAction(\'secondTab\')"},
                                {"3","�����Ϣ","doTabAction(\'thirdTab\')"},
                                {"4","��ͬ��Ϣ","doTabAction(\'fourthTab\')"}
                                };

        out.println(HTMLTab.genTabArray(sTabStrip,"tab_DeskTopInfo","document.getElementById('tabtd')"));

        String sTableStyle = "align=center cellspacing=0 cellpadding=0 border=0 width=98% height=98%";
        String sTabHeadStyle = "";
        String sTabHeadText = "<br>";
        String sTopRight = "";
        String sTabID = "tabtd";
        String sIframeName = "TabContentFrame";
        String sDefaultPage = sWebRootPath+"/Blank.jsp?TextToShow=���ڴ�ҳ�棬���Ժ�";
        String sIframeStyle = "width=100% height=100% frameborder=0 hspace=0 vspace=0 marginwidth=0 marginheight=0 scrolling=no";

    %>

</script>
<%/*~END~*/%>




<%/*~BEGIN~���ɱ༭��[Editable=false;CodeAreaID=Main04;Describe=����ҳ��]~*/%>
<html>
<head>
<title><%=PG_TITLE%></title>
</head> 
<body leftmargin="0" topmargin="0" class="pagebackground">
    <%@include file="/Resources/CodeParts/Tab04.jsp"%>
</body>
</html>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��[Editable=true;CodeAreaID=Main05;Describe=��ͼ�¼�;]~*/%>
    <script type="text/javascript">

    /**
     * Ĭ�ϵ�tabִ�к���
     * ����true�����л�tabҳ;
     * ����false�����л�tabҳ
     */
    function doTabAction(sArg)
    {
        var sReserveFlag = "<%=sReserveFlag%>";
        var sAccountMonth = "<%=sAccountMonth%>";
        var sDueBillNo = "<%=sDueBillNo%>";
        var sCustomerType = "<%=sCustomerType%>";
        var sCustomerID = "<%=sCustomerID%>";
        
        //���ݽ�ݺŵõ���ͬ��
        var sContractNo = RunMethod("BusinessManage","GetRelativeSerialNo","BusinessDueBill,BusinessContract"+","+sDueBillNo);
        
        if(sArg == "firstTab")
        {
            if (sReserveFlag == "10") { //��ϼ����ֵģʽ
                sParameter = "AccountMonth=" + sAccountMonth +
                                 "&DuebillNo=" + sDueBillNo +
                                 "&CustomerType=" + sCustomerType
                OpenComp("ReserveCompInfo","/Reserve/ReserveComp/ReserveCompInfo.jsp",sParameter,"<%=sIframeName%>","");
            }
            if (sReserveFlag == "20") { //��������ֵģʽ
                sParameter = "AccountMonth=" + sAccountMonth +
                                 "&DuebillNo=" + sDueBillNo +
                                 "&CustomerType=" + sCustomerType
                OpenComp("ReserveSingleInfo","/Reserve/ReserveSingle/ReserveSingleInfo.jsp",sParameter,"<%=sIframeName%>","");
            }            
            return true; 
        } else if (sArg == "secondTab") //�ͻ���Ϣ
        {
            openObjectInFrame("Customer", sCustomerID,"003", "<%=sIframeName%>");
            return true;
        } else if (sArg == "thirdTab")
        {
            openObjectInFrame("BusinessDueBill",sDueBillNo,"003","<%=sIframeName%>");
            return true; 
        } else if (sArg == "fourthTab") {
            openObjectInFrame("BusinessContract",sContractNo,"003","<%=sIframeName%>");
            return true;             
        } else {
            return false;
        }
    }
    
    </script>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��[Editable=true;CodeAreaID=Main06;Describe=��ҳ��װ��ʱִ��,��ʼ��;]~*/%>
    <script type="text/javascript">
    
    //��������Ϊ�� tab��ID,tab��������,Ĭ����ʾ�ڼ���,Ŀ�굥Ԫ��
    hc_drawTabToTable("tab_DeskTopInfo",tabstrip,1,document.getElementById('<%=sTabID%>'));
    doTabAction('firstTab');

    </script>
<%/*~END~*/%>


<%@ include file="/IncludeEnd.jsp"%>
