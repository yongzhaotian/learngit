<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main00;Describe=注释区;]~*/%>
    <%
    /*
        Author: cbsu 2009-10-20
        Tester:
        Content: 计提减值Tab页面，包括"减值信息", "客户信息", "借据信息", "合同信息"四个Tab页
        Input Param:
        Output param:
        History Log: 
     */
    %>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main01;Describe=定义页面属性;]~*/%>
    <%
    String PG_TITLE = "减值计提详情"; // 浏览器窗口标题 <title> PG_TITLE </title>
    %>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main02;Describe=定义变量，获取参数;]~*/%>
    <%
    //获得组件参数    
    String sReserveFlag = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ReserveFlag")); //计提模式
    String sAccountMonth = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("AccountMonth")); //会计月份
    String sDueBillNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("DueBillNo")); //借据号
    String sCustomerType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("CustomerType")); //客户类型
    String sCustomerID = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("CustomerID")); //客户编号
    %>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main03;Describe=定义标签;]~*/%>
<script type="text/javascript">
    var tabstrip = new Array();
    <%
        String sTabStrip[][] = {
                                {"1","减值信息","doTabAction(\'firstTab\')"},
                                {"2","客户信息","doTabAction(\'secondTab\')"},
                                {"3","借据信息","doTabAction(\'thirdTab\')"},
                                {"4","合同信息","doTabAction(\'fourthTab\')"}
                                };

        out.println(HTMLTab.genTabArray(sTabStrip,"tab_DeskTopInfo","document.getElementById('tabtd')"));

        String sTableStyle = "align=center cellspacing=0 cellpadding=0 border=0 width=98% height=98%";
        String sTabHeadStyle = "";
        String sTabHeadText = "<br>";
        String sTopRight = "";
        String sTabID = "tabtd";
        String sIframeName = "TabContentFrame";
        String sDefaultPage = sWebRootPath+"/Blank.jsp?TextToShow=正在打开页面，请稍候";
        String sIframeStyle = "width=100% height=100% frameborder=0 hspace=0 vspace=0 marginwidth=0 marginheight=0 scrolling=no";

    %>

</script>
<%/*~END~*/%>




<%/*~BEGIN~不可编辑区[Editable=false;CodeAreaID=Main04;Describe=主体页面]~*/%>
<html>
<head>
<title><%=PG_TITLE%></title>
</head> 
<body leftmargin="0" topmargin="0" class="pagebackground">
    <%@include file="/Resources/CodeParts/Tab04.jsp"%>
</body>
</html>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区[Editable=true;CodeAreaID=Main05;Describe=树图事件;]~*/%>
    <script type="text/javascript">

    /**
     * 默认的tab执行函数
     * 返回true，则切换tab页;
     * 返回false，则不切换tab页
     */
    function doTabAction(sArg)
    {
        var sReserveFlag = "<%=sReserveFlag%>";
        var sAccountMonth = "<%=sAccountMonth%>";
        var sDueBillNo = "<%=sDueBillNo%>";
        var sCustomerType = "<%=sCustomerType%>";
        var sCustomerID = "<%=sCustomerID%>";
        
        //根据借据号得到合同号
        var sContractNo = RunMethod("BusinessManage","GetRelativeSerialNo","BusinessDueBill,BusinessContract"+","+sDueBillNo);
        
        if(sArg == "firstTab")
        {
            if (sReserveFlag == "10") { //组合计提减值模式
                sParameter = "AccountMonth=" + sAccountMonth +
                                 "&DuebillNo=" + sDueBillNo +
                                 "&CustomerType=" + sCustomerType
                OpenComp("ReserveCompInfo","/Reserve/ReserveComp/ReserveCompInfo.jsp",sParameter,"<%=sIframeName%>","");
            }
            if (sReserveFlag == "20") { //单项计提减值模式
                sParameter = "AccountMonth=" + sAccountMonth +
                                 "&DuebillNo=" + sDueBillNo +
                                 "&CustomerType=" + sCustomerType
                OpenComp("ReserveSingleInfo","/Reserve/ReserveSingle/ReserveSingleInfo.jsp",sParameter,"<%=sIframeName%>","");
            }            
            return true; 
        } else if (sArg == "secondTab") //客户信息
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




<%/*~BEGIN~可编辑区[Editable=true;CodeAreaID=Main06;Describe=在页面装载时执行,初始化;]~*/%>
    <script type="text/javascript">
    
    //参数依次为： tab的ID,tab定义数组,默认显示第几项,目标单元格
    hc_drawTabToTable("tab_DeskTopInfo",tabstrip,1,document.getElementById('<%=sTabID%>'));
    doTabAction('firstTab');

    </script>
<%/*~END~*/%>


<%@ include file="/IncludeEnd.jsp"%>
