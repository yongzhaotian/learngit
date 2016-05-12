<%@ page contentType="text/html; charset=GBK"%>
<%@ page import="com.amarsoft.app.als.customer.group.action.Version"%>
<%@ page import="com.amarsoft.app.als.bizobject.customer.*"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   
		Tester:
		Content:  �鿴���ż����������϶��汾ҳ��
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

	//��ʼ���ͻ����󣬲����ݼ��ſͻ����װ�ض���
	CustomerModelAction customerModelAction = new CustomerModelAction();
	GroupCustomer groupcustomer=(GroupCustomer)customerModelAction.initByCustomerID(sGroupID);
	CustomerManager customerManager = customerModelAction.getManager();
	customerManager.loadCustomerModelInfo(groupcustomer);
	customerManager.loadCustomerInfo(groupcustomer);
	//��ȡ���ſͻ���������
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
                <td class="main-header"><span>���ſͻ�����ά����<%=sGroupName %>��</span></td>
            </tr>
            <tr>
                <td class="main-nav">
                    <table cellspacing="0" cellpadding="0">
                        <tr>
                            <td>��ʾ��ͼ��</td>
                            <td>
                                <INPUT id="tier" type=radio name="view" checked="checked" onclick="javascript:sView='tier';view();"><label for="tier">��νṹ</label>
                                <INPUT id="web" type=radio name="view" onclick="javascript:sView='web';view();"><label for="web">��ϵ��</label>
                                <!-- <INPUT id="excel" type=radio name="view" disabled="disabled" onclick="javascript:sView='excel';view();"><label for="excel">EXCEL��</label> -->
                            </td>
                        </tr>
                        <tr>
                            <td>�������ã�</td>
                            <td>
                             	<INPUT id="autosys" type=radio name="area" onClick="autoindexAndSystem();"><label for="autosys">������ϵ����---���м���</label>
                                <!-- <INPUT id="outersys" type=radio name="area" onClick="externalAndSystem();"><label for="outersys">�ⲿ��Ϣ-ϵͳ��Ϣ</label> -->
                                <INPUT id="sys" type=radio name="area" onClick="systemFamily();"><label for="sys">���м���</label>
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
<%/*�Զ��庯������*/ %>
<script type="text/javascript" language="javascript">
	var sView = "tier";
	var sReloadFlag=false;
	//���밴ť��ʶ
	var sInsertNodeFlag=false;
	//relativeId,�ͻ����
	var GroupCustomerID="";
	view();	
	//���Զ�������������ݲ��뵽���ż�������
	function addTree(){
		if(sInsertNodeFlag){
			autoindexAndSystem();			
			sInsertNodeFlag=false;
			GroupCustomerID="";
		}
	}
	//ֻˢ���ұ߼��ż�����
	function reloadTree(){		
			var sGroupID = "<%=sGroupID%>";
		    var sGroupName = "<%=sGroupName%>";
		    var sKeyMemberCustomerID = "<%=sKeyMemberCustomerID%>";
		    var sRightType = "<%=sRightType%>";	  
		 	if (typeof(sGroupID) == "undefined" || sGroupID.length == 0){
		 	       OpenPage("/AppMain/Blank.jsp?TextToShow=��ȡ������Ϣʧ��,���ſͻ����Ϊ��!","left");
		 	       return;
		 	}
		    if(sKeyMemberCustomerID.length == 0){
		    	   OpenPage("/AppMain/Blank.jsp?TextToShow=ĸ��˾�ͻ����δ��д��","left");
		           return;
		    }	
			
			var sTreeViewDetail1="2";
			var sTreeViewDetail2="<%=sFamilySeq%>";
		   	if(<%=!Version.isVersion(sGroupID,sFamilySeq)%>)
	   			OpenPage("/AppMain/Blank.jsp?TextToShow=�ü��ſͻ���ϵͳ��Ϣ��ʱ��δ���ã����Ժ�...","right");
		   	else
		   		openIFram("sys","right","TreeViewDetail1="+sTreeViewDetail1+"&TreeViewDetail2="+sTreeViewDetail2+"&RightType="+sRightType+"&FamilyMapStatus="+sTreeViewDetail1+"&GroupID=<%=sGroupID%>&GroupName=<%=sGroupName%>&KeyMemberCustomerID=<%=sKeyMemberCustomerID%>&RefVersionSeq=<%=sFamilySeq%>&GroupType1=<%=sGroupType1%>");
	}
	//���鿴ϵͳ��Ϣ
    function systemFamily(){
		document.getElementById("bodyleft").style.display = "none";
		document.getElementById("bodyright").style.display = "none";
		document.getElementById("single").style.display = "";
		var sTreeViewDetail1="2";
		var sTreeViewDetail2="<%=sFamilySeq%>";
		var sParam = "TreeViewDetail1="+sTreeViewDetail1+"&TreeViewDetail2="+sTreeViewDetail2+"&RightType=<%=sRightType%>&FamilyMapStatus="+sTreeViewDetail1+"&GroupID=<%=sGroupID%>&GroupName=<%=sGroupName%>&KeyMemberCustomerID=<%=sKeyMemberCustomerID%>&RefVersionSeq=<%=sFamilySeq%>&GroupType1=<%=sGroupType1%>";
		if(<%=!Version.isVersion(sGroupID,sFamilySeq)%>){
			OpenPage("/AppMain/Blank.jsp?TextToShow=�ü��ſͻ���ϵͳ��Ϣ��ʱ��δ���ã����Ժ�...","single");
		}else{
			openIFram("sys","single",sParam);
		}
    }
  //�ԱȲ鿴�Զ��������-ϵͳ��Ϣ
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
	 	       OpenPage("/AppMain/Blank.jsp?TextToShow=��ȡ������Ϣʧ��,���ſͻ����Ϊ��!","left");
	 	       return;
	 	}
	    if(sKeyMemberCustomerID.length == 0){
	    	   OpenPage("/AppMain/Blank.jsp?TextToShow=ĸ��˾�ͻ����δ��д��","left");
	           return;
	    }	
	    if(!sInsertNodeFlag){
		    OpenPage("/CustomerManage/GroupManage/GroupRelationSearch.jsp?GroupID="+sGroupID+"&GroupName="+sGroupName+"&KeyMemberCustomerID="+sKeyMemberCustomerID+"&RightType="+sRightType,"left");
		}   
		//ϵͳ��Ϣ
		var sTreeViewDetail1="2";
		var sTreeViewDetail2="<%=sFamilySeq%>";
	   	if(<%=!Version.isVersion(sGroupID,sFamilySeq)%>)
   			OpenPage("/AppMain/Blank.jsp?TextToShow=�ü��ſͻ���ϵͳ��Ϣ��ʱ��δ���ã����Ժ�...","right");
	   	else
	   		openIFram("sys","right","TreeViewDetail1="+sTreeViewDetail1+"&TreeViewDetail2="+sTreeViewDetail2+"&RightType="+sRightType+"&FamilyMapStatus="+sTreeViewDetail1+"&GroupID=<%=sGroupID%>&KeyMemberCustomerID=<%=sKeyMemberCustomerID%>&RefVersionSeq=<%=sFamilySeq%>&GroupType1=<%=sGroupType1%>&InsertTreeNode="+sInsertTreeNode+"&GroupCustomerID="+GroupCustomerID);
    }
	
	// ��ʾ��ͼ
	function view(){
		document.getElementById("sys").checked = true;
		systemFamily();
	}

	function openIFram(versionType,sStyle,sParam){
		if(sView == "tier") // ��νṹ
			OpenComp("GroupCustomerTree","/CustomerManage/GroupManage/GroupCustomerTree.jsp",sParam,sStyle);
		else if(sView == "web") // ��ϵ��
	    	OpenComp("GroupCustomerPlot","/CustomerManage/GroupManage/GroupCustomerPlot.jsp",sParam,sStyle);
		else if(sView == "excel") // EXCEL����δʵ��
			alert("δʵ�֣�");
	}

	/**��õ�ǰ�Ƿ�Ϊ��ϵ�������Ϊ��ϵ��ʱ�������������ӳ�Ա*/
	function myCheck()
	{
			var obj=document.getElementById("web");
			return obj.checked;
	}
</script>
<%@ include file="/IncludeEnd.jsp"%>