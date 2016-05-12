<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main00;Describe=注释区;]~*/%>
    <%
    /*
        Author: lyin 2013-01-09
        Tester:
        Content: 查看集团家谱维护记录界面-历次已复核版本
        Input Param:
        Output param:
        History Log: 
     */
    %>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main01;Describe=定义页面属性;]~*/%>
    <%
    String PG_TITLE = "集团家谱概况"; // 浏览器窗口标题 <title> PG_TITLE </title>
    %>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main02;Describe=定义变量，获取参数;]~*/%>
    <%
    //获得组件参数    
    String sGroupID = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("GroupID")); 
    String sGroupName = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("GroupName")); 
    String sGroupType2 = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("GroupType2")); 
    String sRightType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("RightType")); 
    String sMgtOrgID = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("MgtOrgID")); 
    String sMgtUserID = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("MgtUserID")); 
    String sKeyMemberCustomerID = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("KeyMemberCustomerID"));
    %>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main03;Describe=定义标签;]~*/%>
<script type="text/javascript">
    var tabstrip = new Array();
    <%
	    String sTabStrip[][] = {
					            {"1","集团概况","doTabAction(\'firstTab\')"},
					            {"2","集团家谱","doTabAction(\'secondTab\')"},
					            {"3","集团家谱最新已认定成员","doTabAction(\'thirdTab\')"},
					            {"4","集团家谱历次已认定版本","doTabAction(\'fourthTab\')"},
					            {"5","集团授信情况","doTabAction(\'fifthTab\')"},
					            {"6","集团变更历史","doTabAction(\'sixthTab\')"},
					            };
        out.println(HTMLTab.genTabArray(sTabStrip,"tab_DeskTopInfo","document.getElementById('tabtd')"));

        String sTableStyle = "align=center cellspacing=0 cellpadding=0 border=0 width=100% height=98%";
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
    	var sGroupID = "<%=sGroupID%>";
	    var sRightType = "<%=sRightType%>";
        var sMgtOrgID = "<%=sMgtOrgID%>";   
        var sMgtUserID = "<%=sMgtUserID%>";   
        var sGroupName = "<%=sGroupName%>";  
        var sGroupType2 = "<%=sGroupType2%>";  
        var sKeyMemberCustomerID = "<%=sKeyMemberCustomerID%>";   
        if(sArg == "firstTab"){
            OpenComp("GroupCustomerInfo","/CustomerManage/GroupManage/GroupCustomerInfo.jsp","GroupID="+sGroupID+"&GroupName="+sGroupName+"&GroupType2="+sGroupType2+"&RightType="+sRightType+"&MgtOrgID="+sMgtOrgID+"&MgtUserID="+sMgtUserID+"&KeyMemberCustomerID="+sKeyMemberCustomerID,"<%=sIframeName%>","");
            return true; 
        } else if (sArg == "secondTab"){ //客户信息
        	OpenComp("GroupCustomerFamily","/CustomerManage/GroupManage/GroupCustomerFamily.jsp","GroupID="+sGroupID+"&RightType="+sRightType,"<%=sIframeName%>","");
            return true;
        } else if (sArg == "thirdTab"){
        	OpenComp("GroupMemberList","/CustomerManage/GroupManage/GroupMemberList.jsp","GroupID="+sGroupID+"&RightType="+sRightType,"<%=sIframeName%>","");
        	return true; 
        } else if (sArg == "fourthTab") {
        	OpenComp("GroupFamilyVersionList","/CustomerManage/GroupManage/GroupFamilyVersionList.jsp","GroupID="+sGroupID+"&RightType="+sRightType,"<%=sIframeName%>","");
            return true;     	
        } else if (sArg == "fifthTab") {
        	OpenComp("GroupCustomerCreditView","/CustomerManage/GroupManage/GroupCustomerCreditView.jsp","GroupID="+sGroupID+"&RightType="+sRightType,"<%=sIframeName%>","");
            return true;             
        } else if (sArg == "sixthTab") {
        	OpenComp("GroupEventChangeList","/CustomerManage/GroupManage/GroupEventChangeList.jsp","GroupID="+sGroupID+"&RightType="+sRightType,"<%=sIframeName%>","");
            return true;   
        }else {
            return false;
        }
    }
    </script>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区[Editable=true;CodeAreaID=Main06;Describe=在页面装载时执行,初始化;]~*/%>
    <script type="text/javascript">
    
    //参数依次为： tab的ID,tab定义数组,默认显示第几项,目标单元格
    hc_drawTabToTable("tab_DeskTopInfo",tabstrip,4,document.getElementById('<%=sTabID%>'));
    doTabAction('fourthTab');

    </script>
<%/*~END~*/%>


<%@ include file="/IncludeEnd.jsp"%>
