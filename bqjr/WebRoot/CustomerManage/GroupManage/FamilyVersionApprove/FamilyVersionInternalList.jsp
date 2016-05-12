<%@ page contentType="text/html; charset=GBK"%>
<%@ page import="com.amarsoft.app.als.customer.group.action.Version"%>
<%@ page import="com.amarsoft.app.als.bizobject.customer.*"%>
<%@ include file="/IncludeBeginMD.jsp"%>

<html lang="en" xml:lang="en" xmlns="http://www.w3.org/1999/xhtml">
<%
	String sGroupID = CurComp.getParameter("GroupID");
	String sOldFamilySEQ = CurComp.getParameter("OldFamilySEQ");
	String sFamilySEQ = CurComp.getParameter("FamilySEQ");
	
	//初始化客户对象，并根据集团客户编号装载对象
	CustomerModelAction customerModelAction = new CustomerModelAction();
	GroupCustomer groupcustomer=(GroupCustomer)customerModelAction.initByCustomerID(sGroupID);
	CustomerManager customerManager = customerModelAction.getManager();
	customerManager.loadCustomerModelInfo(groupcustomer);
	customerManager.loadCustomerInfo(groupcustomer);
	
	if(sOldFamilySEQ==null) sOldFamilySEQ=groupcustomer.getCurrentVersionSeq();
	if(sFamilySEQ==null) sFamilySEQ=groupcustomer.getRefVersionSeq();
	//-----获取集团客户对象属性
	String sGroupName = groupcustomer.getGroupName();
	String sVersionSeq = sFamilySEQ; //当前更新后的集团家谱版本编号
	String sCurrentVersionSeq = sOldFamilySEQ; //当前更新前的集团家谱版本编号
	String sKeyMemberCustomerID = groupcustomer.getKeyMemberCustomerID();
	String sFamilyMapStatus = groupcustomer.getFamilyMapStatus(); //家谱复核状态
	if(sGroupID==null) sGroupID="";
	if(sGroupName == null) sGroupName = "";
	if(sKeyMemberCustomerID == null) sKeyMemberCustomerID = "";
	if(sFamilyMapStatus == null) sFamilyMapStatus = "";
	if("".equals(sFamilyMapStatus) || "1".equals(sFamilyMapStatus)){
		sFamilyMapStatus="审核中";
	}else if("0".equals(sFamilyMapStatus)){
		sFamilyMapStatus="草稿";
	}else if("2".equals(sFamilyMapStatus)){
		sFamilyMapStatus="复核退回";
	}else if("3".equals(sFamilyMapStatus)){
		sFamilyMapStatus="复核通过";
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
                            <td>显示视图：</td>
                            <td>
                                <INPUT id="tier" type=radio name="view" checked="checked"><label for="tier">层次结构</label>
                                <INPUT id="web" type=radio name="view" disabled="disabled"><label for="web">关系网</label>
                            </td>
                        </tr>
                        <tr>
                            <td>区域设置：</td>
                            <td>
                                <INPUT id="afterupdate" type=radio name="area" onfocus="viewAfterUpdate();"><label for="afterupdate">仅查看更新后信息</label>
                                <INPUT id="baupdate" type=radio name="area" onfocus="viewAll();" checked="checked"><label for="baupdate">对比查看更新前后信息</label>
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
		sFrontStatus="复核通过";
	}
	var sTreeViewDetail1="更新前-家谱复核状态:["+sFrontStatus+"]-版本编号:[<%=sCurrentVersionSeq%>]";
	if(<%=!Version.isVersion(sGroupID,sCurrentVersionSeq)%>)
		goToBlank("left","该客户目前暂无复核通过的家谱");
	else
	    OpenComp("FamilyVersionInternalTree","/CustomerManage/GroupManage/FamilyVersionApprove/FamilyVersionInternalTree.jsp","TreeViewDetail="+sTreeViewDetail1+"&RightType=ViewOnly&GroupID="+sGroupID+"&VersionSeq="+sCurrentVersionSeq+"&GroupName="+sGroupName+"&KeyMemberCustomerID="+sKeyMemberCustomerID,"left");
	var sTreeViewDetail2="更新后-家谱复核状态:[<%=sFamilyMapStatus%>]-版本编号:<%=sVersionSeq%>";
	if(<%=!Version.isVersion(sGroupID,sVersionSeq)%>)
		goToBlank("right","该客户目前暂无复核通过的家谱");
	else
	    OpenComp("FamilyVersionInternalTree","/CustomerManage/GroupManage/FamilyVersionApprove/FamilyVersionInternalTree.jsp","TreeViewDetail="+sTreeViewDetail2+"&RightType=Readonly&GroupID="+sGroupID+"&VersionSeq="+sVersionSeq+"&GroupName="+sGroupName+"&KeyMemberCustomerID="+sKeyMemberCustomerID,"right");

  	//仅查看更新后信息
    function viewAfterUpdate(){
		document.getElementById("bodyleft").style.display = "none";
		document.getElementById("bodyright").style.display = "none";
		document.getElementById("single").style.display = "";
		var sTreeViewDetail="更新后-审核中-版本编号:<%=sVersionSeq%>";
		if(<%=!Version.isVersion(sGroupID,sVersionSeq)%>)
			OpenPage("/AppMain/Blank.jsp?TextToShow=目标系统内家谱不存在","single");
		else
	    	OpenComp("FamilyVersionInternalTree","/CustomerManage/GroupManage/FamilyVersionApprove/FamilyVersionInternalTree.jsp","TreeViewDetail="+sTreeViewDetail+"&RightType=Readonly&GroupID="+sGroupID+"&VersionSeq="+sVersionSeq+"&GroupName="+sGroupName+"&KeyMemberCustomerID="+sKeyMemberCustomerID,"single");
    }

    //对比查看更新前后信息
    function viewAll(){
    	document.getElementById("bodyleft").style.display = "";
		document.getElementById("bodyright").style.display = "";
		document.getElementById("single").style.display = "none";
    }

 	// 对象不成立时，显示信息
    function goToBlank(sType,sText){
		viewAll();
		OpenPage("/AppMain/Blank.jsp?TextToShow="+sText,sType);
    }
</script>
<%@ include file="/IncludeEnd.jsp"%>