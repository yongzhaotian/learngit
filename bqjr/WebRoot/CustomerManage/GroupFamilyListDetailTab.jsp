<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main00;Describe=ע����;]~*/%>
    <%
    /*
        Author: lyin 2013-01-09
        Tester:
        Content: �鿴���ż���ά����¼����-�����Ѹ��˰汾
        Input Param:
        Output param:
        History Log: 
     */
    %>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main01;Describe=����ҳ������;]~*/%>
    <%
    String PG_TITLE = "���ż��׸ſ�"; // ��������ڱ��� <title> PG_TITLE </title>
    %>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main02;Describe=�����������ȡ����;]~*/%>
    <%
    //����������    
    String sGroupID = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("GroupID")); 
    String sGroupName = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("GroupName")); 
    String sGroupType2 = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("GroupType2")); 
    String sRightType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("RightType")); 
    String sMgtOrgID = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("MgtOrgID")); 
    String sMgtUserID = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("MgtUserID")); 
    String sKeyMemberCustomerID = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("KeyMemberCustomerID"));
    %>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main03;Describe=�����ǩ;]~*/%>
<script type="text/javascript">
    var tabstrip = new Array();
    <%
	    String sTabStrip[][] = {
					            {"1","���Ÿſ�","doTabAction(\'firstTab\')"},
					            {"2","���ż���","doTabAction(\'secondTab\')"},
					            {"3","���ż����������϶���Ա","doTabAction(\'thirdTab\')"},
					            {"4","���ż����������϶��汾","doTabAction(\'fourthTab\')"},
					            {"5","�����������","doTabAction(\'fifthTab\')"},
					            {"6","���ű����ʷ","doTabAction(\'sixthTab\')"},
					            };
        out.println(HTMLTab.genTabArray(sTabStrip,"tab_DeskTopInfo","document.getElementById('tabtd')"));

        String sTableStyle = "align=center cellspacing=0 cellpadding=0 border=0 width=100% height=98%";
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
        } else if (sArg == "secondTab"){ //�ͻ���Ϣ
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




<%/*~BEGIN~�ɱ༭��[Editable=true;CodeAreaID=Main06;Describe=��ҳ��װ��ʱִ��,��ʼ��;]~*/%>
    <script type="text/javascript">
    
    //��������Ϊ�� tab��ID,tab��������,Ĭ����ʾ�ڼ���,Ŀ�굥Ԫ��
    hc_drawTabToTable("tab_DeskTopInfo",tabstrip,4,document.getElementById('<%=sTabID%>'));
    doTabAction('fourthTab');

    </script>
<%/*~END~*/%>


<%@ include file="/IncludeEnd.jsp"%>
