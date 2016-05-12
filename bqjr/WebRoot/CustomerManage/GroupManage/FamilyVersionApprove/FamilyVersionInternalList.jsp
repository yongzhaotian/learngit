<%@ page contentType="text/html; charset=GBK"%>
<%@ page import="com.amarsoft.app.als.customer.group.action.Version"%>
<%@ page import="com.amarsoft.app.als.bizobject.customer.*"%>
<%@ include file="/IncludeBeginMD.jsp"%>

<html lang="en" xml:lang="en" xmlns="http://www.w3.org/1999/xhtml">
<%
	String sGroupID = CurComp.getParameter("GroupID");
	String sOldFamilySEQ = CurComp.getParameter("OldFamilySEQ");
	String sFamilySEQ = CurComp.getParameter("FamilySEQ");
	
	//��ʼ���ͻ����󣬲����ݼ��ſͻ����װ�ض���
	CustomerModelAction customerModelAction = new CustomerModelAction();
	GroupCustomer groupcustomer=(GroupCustomer)customerModelAction.initByCustomerID(sGroupID);
	CustomerManager customerManager = customerModelAction.getManager();
	customerManager.loadCustomerModelInfo(groupcustomer);
	customerManager.loadCustomerInfo(groupcustomer);
	
	if(sOldFamilySEQ==null) sOldFamilySEQ=groupcustomer.getCurrentVersionSeq();
	if(sFamilySEQ==null) sFamilySEQ=groupcustomer.getRefVersionSeq();
	//-----��ȡ���ſͻ���������
	String sGroupName = groupcustomer.getGroupName();
	String sVersionSeq = sFamilySEQ; //��ǰ���º�ļ��ż��װ汾���
	String sCurrentVersionSeq = sOldFamilySEQ; //��ǰ����ǰ�ļ��ż��װ汾���
	String sKeyMemberCustomerID = groupcustomer.getKeyMemberCustomerID();
	String sFamilyMapStatus = groupcustomer.getFamilyMapStatus(); //���׸���״̬
	if(sGroupID==null) sGroupID="";
	if(sGroupName == null) sGroupName = "";
	if(sKeyMemberCustomerID == null) sKeyMemberCustomerID = "";
	if(sFamilyMapStatus == null) sFamilyMapStatus = "";
	if("".equals(sFamilyMapStatus) || "1".equals(sFamilyMapStatus)){
		sFamilyMapStatus="�����";
	}else if("0".equals(sFamilyMapStatus)){
		sFamilyMapStatus="�ݸ�";
	}else if("2".equals(sFamilyMapStatus)){
		sFamilyMapStatus="�����˻�";
	}else if("3".equals(sFamilyMapStatus)){
		sFamilyMapStatus="����ͨ��";
	}
%>
    <head>
        <title>jQuery treeTable Plugin Documentation</title>
        <!-- Begin jQuery core Code -->
        <script type="text/javascript" src="<%=sWebRootPath%>/CustomerManage/GroupManage/resources/js/jquery/jquery.ui.js"></script>
        <script type="text/javascript" src="<%=sWebRootPath%>/Frame/resources/js/jquery/plugins/jquery.treeTable.min.js"></script>
        <!-- BEGIN Plugin Code -->
        <link href="<%=sWebRootPath%>/CustomerManage/GroupManage/resources/css/jquery.treeTable.css" rel="stylesheet" type="text/css" />
        <link href="<%=sWebRootPath%>/CustomerManage/GroupManage/resources/css/groupcustomerfamily.css" rel="stylesheet" type="text/css" />
    </head>
    <body>
        <table cellspacing="0" cellpadding="0" class="main">
            <tr>
                <td class="main-nav">
                    <table cellspacing="0" cellpadding="0">
                        <tr>
                            <td>��ʾ��ͼ��</td>
                            <td>
                                <INPUT id="tier" type=radio name="view" checked="checked"><label for="tier">��νṹ</label>
                                <INPUT id="web" type=radio name="view" disabled="disabled"><label for="web">��ϵ��</label>
                            </td>
                        </tr>
                        <tr>
                            <td>�������ã�</td>
                            <td>
                                <INPUT id="afterupdate" type=radio name="area" onfocus="viewAfterUpdate();"><label for="afterupdate">���鿴���º���Ϣ</label>
                                <INPUT id="baupdate" type=radio name="area" onfocus="viewAll();" checked="checked"><label for="baupdate">�ԱȲ鿴����ǰ����Ϣ</label>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td class="main-body">
                    <div id="bodyleft" class="main-body-left"><iframe id="left" src="<%=sWebRootPath%>/AppMain/Blank.html" name="left"></iframe></div>
                    <div id="bodyright" class="main-body-right"><iframe id="right" src="<%=sWebRootPath%>/AppMain/Blank.html" name="right"></iframe></div>
                    <div id="single" style="width:100%;height:100%;"><iframe id="single"  style="width:100%;height:100%;"src="<%=sWebRootPath%>/AppMain/Blank.html" name="single"></iframe></div>
                </td>
            </tr>
            <tr>
                <td class="main-footer"><span>&nbsp;</span>
                </td>
            </tr>
        </table>
    </body>
</html>
<script type="text/javascript" language="javascript">
	var sGroupID = "<%=sGroupID%>";
	var sVersionSeq = "<%=sVersionSeq%>";
	var sCurrentVersionSeq = "<%=sCurrentVersionSeq%>";
	var sGroupName = "<%=sGroupName%>";
	var sKeyMemberCustomerID = "<%=sKeyMemberCustomerID%>";
	var sFrontStatus="";
	if(<%=sCurrentVersionSeq.equals(sVersionSeq)%>){
		sFrontStatus="<%=sFamilyMapStatus%>";
	}else{
		sFrontStatus="����ͨ��";
	}
	var sTreeViewDetail1="����ǰ-���׸���״̬:["+sFrontStatus+"]-�汾���:[<%=sCurrentVersionSeq%>]";
	if(<%=!Version.isVersion(sGroupID,sCurrentVersionSeq)%>)
		goToBlank("left","�ÿͻ�Ŀǰ���޸���ͨ���ļ���");
	else
	    OpenComp("FamilyVersionInternalTree","/CustomerManage/GroupManage/FamilyVersionApprove/FamilyVersionInternalTree.jsp","TreeViewDetail="+sTreeViewDetail1+"&RightType=ViewOnly&GroupID="+sGroupID+"&VersionSeq="+sCurrentVersionSeq+"&GroupName="+sGroupName+"&KeyMemberCustomerID="+sKeyMemberCustomerID,"left");
	var sTreeViewDetail2="���º�-���׸���״̬:[<%=sFamilyMapStatus%>]-�汾���:<%=sVersionSeq%>";
	if(<%=!Version.isVersion(sGroupID,sVersionSeq)%>)
		goToBlank("right","�ÿͻ�Ŀǰ���޸���ͨ���ļ���");
	else
	    OpenComp("FamilyVersionInternalTree","/CustomerManage/GroupManage/FamilyVersionApprove/FamilyVersionInternalTree.jsp","TreeViewDetail="+sTreeViewDetail2+"&RightType=Readonly&GroupID="+sGroupID+"&VersionSeq="+sVersionSeq+"&GroupName="+sGroupName+"&KeyMemberCustomerID="+sKeyMemberCustomerID,"right");

  	//���鿴���º���Ϣ
    function viewAfterUpdate(){
		document.getElementById("bodyleft").style.display = "none";
		document.getElementById("bodyright").style.display = "none";
		document.getElementById("single").style.display = "";
		var sTreeViewDetail="���º�-�����-�汾���:<%=sVersionSeq%>";
		if(<%=!Version.isVersion(sGroupID,sVersionSeq)%>)
			OpenPage("/AppMain/Blank.jsp?TextToShow=Ŀ��ϵͳ�ڼ��ײ�����","single");
		else
	    	OpenComp("FamilyVersionInternalTree","/CustomerManage/GroupManage/FamilyVersionApprove/FamilyVersionInternalTree.jsp","TreeViewDetail="+sTreeViewDetail+"&RightType=Readonly&GroupID="+sGroupID+"&VersionSeq="+sVersionSeq+"&GroupName="+sGroupName+"&KeyMemberCustomerID="+sKeyMemberCustomerID,"single");
    }

    //�ԱȲ鿴����ǰ����Ϣ
    function viewAll(){
    	document.getElementById("bodyleft").style.display = "";
		document.getElementById("bodyright").style.display = "";
		document.getElementById("single").style.display = "none";
    }

 	// ���󲻳���ʱ����ʾ��Ϣ
    function goToBlank(sType,sText){
		viewAll();
		OpenPage("/AppMain/Blank.jsp?TextToShow="+sText,sType);
    }
</script>
<%@ include file="/IncludeEnd.jsp"%>