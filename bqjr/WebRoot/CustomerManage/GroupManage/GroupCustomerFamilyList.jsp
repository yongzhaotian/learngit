<%@ page contentType="text/html; charset=GBK"%>
<%@ page import="com.amarsoft.app.als.customer.group.action.Version"%>
<%@ page import="com.amarsoft.app.als.bizobject.customer.*"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   
		Tester:
		Content:  查看集团家谱历次已认定版本页面
		Input Param:
			  
		Output param:
	 */
	%>
<%/*~END~*/%> 
<%
	String sGroupID = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("GroupID"));
	if(sGroupID==null) sGroupID="";
	
	String sRightType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("RightType"));
	if(sRightType==null) sRightType="";
	
	String sFamilySeq = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("FamilySEQ"));
	if(sFamilySeq==null) sFamilySeq="";

	//初始化客户对象，并根据集团客户编号装载对象
	CustomerModelAction customerModelAction = new CustomerModelAction();
	GroupCustomer groupcustomer=(GroupCustomer)customerModelAction.initByCustomerID(sGroupID);
	CustomerManager customerManager = customerModelAction.getManager();
	customerManager.loadCustomerModelInfo(groupcustomer);
	customerManager.loadCustomerInfo(groupcustomer);
	//获取集团客户对象属性
	String sGroupName = groupcustomer.getGroupName();
	String sKeyMemberCustomerID = groupcustomer.getKeyMemberCustomerID();
	String sGroupType1 = groupcustomer.getGroupType1();
%>

<html lang="en" xml:lang="en" xmlns="http://www.w3.org/1999/xhtml">
    <head>
        <title>jQuery treeTable Plugin Documentation</title>
       	<!-- Begin jQuery core Code -->
        <script type="text/javascript" src="<%=sWebRootPath%>/CustomerManage/GroupManage/resources/js/jquery/jquery.ui.js"></script>
        <script type="text/javascript" src="<%=sWebRootPath%>/CustomerManage/GroupManage/resources/js/jquery/jquery.treeTable.js"></script>
        <!-- BEGIN Plugin Code -->
        <link href="<%=sWebRootPath%>/CustomerManage/GroupManage/resources/css/jquery.treeTable.css" rel="stylesheet" type="text/css" />
        <link href="<%=sWebRootPath%>/CustomerManage/GroupManage/resources/css/groupcustomerfamily.css" rel="stylesheet" type="text/css" />
    </head>
    <body>
        <table cellspacing="0" cellpadding="0" class="main">
            <tr>
                <td class="main-header"><span>集团客户家谱维护【<%=sGroupName %>】</span></td>
            </tr>
            <tr>
                <td class="main-nav">
                    <table cellspacing="0" cellpadding="0">
                        <tr>
                            <td>显示视图：</td>
                            <td>
                                <INPUT id="tier" type=radio name="view" checked="checked" onclick="javascript:sView='tier';view();"><label for="tier">层次结构</label>
                                <INPUT id="web" type=radio name="view" onclick="javascript:sView='web';view();"><label for="web">关系网</label>
                                <!-- <INPUT id="excel" type=radio name="view" disabled="disabled" onclick="javascript:sView='excel';view();"><label for="excel">EXCEL表</label> -->
                            </td>
                        </tr>
                        <tr>
                            <td>区域设置：</td>
                            <td>
                             	<INPUT id="autosys" type=radio name="area" onClick="autoindexAndSystem();"><label for="autosys">关联关系搜索---现有家谱</label>
                                <!-- <INPUT id="outersys" type=radio name="area" onClick="externalAndSystem();"><label for="outersys">外部信息-系统信息</label> -->
                                <INPUT id="sys" type=radio name="area" onClick="systemFamily();"><label for="sys">现有家谱</label>
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
<%/*自定义函数区域*/ %>
<script type="text/javascript" language="javascript">
	var sView = "tier";
	var sReloadFlag=false;
	//插入按钮标识
	var sInsertNodeFlag=false;
	//relativeId,客户编号
	var GroupCustomerID="";
	view();	
	//将自动搜索结果中数据插入到集团家谱树中
	function addTree(){
		if(sInsertNodeFlag){
			autoindexAndSystem();			
			sInsertNodeFlag=false;
			GroupCustomerID="";
		}
	}
	//只刷新右边集团家谱树
	function reloadTree(){		
			var sGroupID = "<%=sGroupID%>";
		    var sGroupName = "<%=sGroupName%>";
		    var sKeyMemberCustomerID = "<%=sKeyMemberCustomerID%>";
		    var sRightType = "<%=sRightType%>";	  
		 	if (typeof(sGroupID) == "undefined" || sGroupID.length == 0){
		 	       OpenPage("/AppMain/Blank.jsp?TextToShow=获取集团信息失败,集团客户编号为空!","left");
		 	       return;
		 	}
		    if(sKeyMemberCustomerID.length == 0){
		    	   OpenPage("/AppMain/Blank.jsp?TextToShow=母公司客户编号未填写！","left");
		           return;
		    }	
			
			var sTreeViewDetail1="2";
			var sTreeViewDetail2="<%=sFamilySeq%>";
		   	if(<%=!Version.isVersion(sGroupID,sFamilySeq)%>)
	   			OpenPage("/AppMain/Blank.jsp?TextToShow=该集团客户的系统信息暂时还未建好，请稍后...","right");
		   	else
		   		openIFram("sys","right","TreeViewDetail1="+sTreeViewDetail1+"&TreeViewDetail2="+sTreeViewDetail2+"&RightType="+sRightType+"&FamilyMapStatus="+sTreeViewDetail1+"&GroupID=<%=sGroupID%>&GroupName=<%=sGroupName%>&KeyMemberCustomerID=<%=sKeyMemberCustomerID%>&RefVersionSeq=<%=sFamilySeq%>&GroupType1=<%=sGroupType1%>");
	}
	//仅查看系统信息
    function systemFamily(){
		document.getElementById("bodyleft").style.display = "none";
		document.getElementById("bodyright").style.display = "none";
		document.getElementById("single").style.display = "";
		var sTreeViewDetail1="2";
		var sTreeViewDetail2="<%=sFamilySeq%>";
		var sParam = "TreeViewDetail1="+sTreeViewDetail1+"&TreeViewDetail2="+sTreeViewDetail2+"&RightType=<%=sRightType%>&FamilyMapStatus="+sTreeViewDetail1+"&GroupID=<%=sGroupID%>&GroupName=<%=sGroupName%>&KeyMemberCustomerID=<%=sKeyMemberCustomerID%>&RefVersionSeq=<%=sFamilySeq%>&GroupType1=<%=sGroupType1%>";
		if(<%=!Version.isVersion(sGroupID,sFamilySeq)%>){
			OpenPage("/AppMain/Blank.jsp?TextToShow=该集团客户的系统信息暂时还未建好，请稍后...","single");
		}else{
			openIFram("sys","single",sParam);
		}
    }
  //对比查看自动搜索结果-系统信息
    function autoindexAndSystem(){
    	document.getElementById("bodyleft").style.display = "";
		document.getElementById("bodyright").style.display = "";
		document.getElementById("single").style.display = "none";
		var sGroupID = "<%=sGroupID%>";
	    var sGroupName = "<%=sGroupName%>";
	    var sKeyMemberCustomerID = "<%=sKeyMemberCustomerID%>";
	    var sRightType = "<%=sRightType%>";	    
	    var sInsertTreeNode="false";
	    if(sInsertNodeFlag){
	    	sInsertTreeNode="true";
		}
	 	if (typeof(sGroupID) == "undefined" || sGroupID.length == 0){
	 	       OpenPage("/AppMain/Blank.jsp?TextToShow=获取集团信息失败,集团客户编号为空!","left");
	 	       return;
	 	}
	    if(sKeyMemberCustomerID.length == 0){
	    	   OpenPage("/AppMain/Blank.jsp?TextToShow=母公司客户编号未填写！","left");
	           return;
	    }	
	    if(!sInsertNodeFlag){
		    OpenPage("/CustomerManage/GroupManage/GroupRelationSearch.jsp?GroupID="+sGroupID+"&GroupName="+sGroupName+"&KeyMemberCustomerID="+sKeyMemberCustomerID+"&RightType="+sRightType,"left");
		}   
		//系统信息
		var sTreeViewDetail1="2";
		var sTreeViewDetail2="<%=sFamilySeq%>";
	   	if(<%=!Version.isVersion(sGroupID,sFamilySeq)%>)
   			OpenPage("/AppMain/Blank.jsp?TextToShow=该集团客户的系统信息暂时还未建好，请稍后...","right");
	   	else
	   		openIFram("sys","right","TreeViewDetail1="+sTreeViewDetail1+"&TreeViewDetail2="+sTreeViewDetail2+"&RightType="+sRightType+"&FamilyMapStatus="+sTreeViewDetail1+"&GroupID=<%=sGroupID%>&KeyMemberCustomerID=<%=sKeyMemberCustomerID%>&RefVersionSeq=<%=sFamilySeq%>&GroupType1=<%=sGroupType1%>&InsertTreeNode="+sInsertTreeNode+"&GroupCustomerID="+GroupCustomerID);
    }
	
	// 显示视图
	function view(){
		document.getElementById("sys").checked = true;
		systemFamily();
	}

	function openIFram(versionType,sStyle,sParam){
		if(sView == "tier") // 层次结构
			OpenComp("GroupCustomerTree","/CustomerManage/GroupManage/GroupCustomerTree.jsp",sParam,sStyle);
		else if(sView == "web") // 关系网
	    	OpenComp("GroupCustomerPlot","/CustomerManage/GroupManage/GroupCustomerPlot.jsp",sParam,sStyle);
		else if(sView == "excel") // EXCEL表，还未实现
			alert("未实现！");
	}

	/**获得当前是否为关系网，如果为关系网时不允许搜索增加成员*/
	function myCheck()
	{
			var obj=document.getElementById("web");
			return obj.checked;
	}
</script>
<%@ include file="/IncludeEnd.jsp"%>