<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>
<%@ page import="com.amarsoft.app.als.customer.group.tree.DefaultContextLoader" %>
<%@ page import="com.amarsoft.app.als.customer.group.tree.component.*" %>
<%
/***************************************************
 * Module: GroupCustomerTree.jsp
 * Author: syang
 * Modified: 2010/09/26 16:15
 * Purpose: �������������ҳ��
 ***************************************************/
%>
<%
    String sGroupID=CurPage.getParameter("GroupID");
    String sGroupName=CurPage.getParameter("GroupName");
    //ĸ��˾�ͻ����(������ϵ������)
    String sKeyMemberCustomerID=CurPage.getParameter("KeyMemberCustomerID");
    //����ά���ļ��װ汾���
    String sRefVersionSeq=CurPage.getParameter("VersionSeq");
    //�ɵĵļ��װ汾���
    String sCurrentVersionSeq=CurPage.getParameter("CurrentVersionSeq");

    //���ڿ�����ʾģʽ(����/�޶�),����ذ�ť
    String sRightType=CurComp.getParameter("RightType");
    String sInsertTreeNode=CurComp.getParameter("InsertTreeNode");  
    String GroupCustomerID=CurComp.getParameter("GroupCustomerID");
    //��ͼ˵��
    String sTreeViewDetail = CurComp.getParameter("TreeViewDetail");
    if(sGroupID==null) sGroupID=""; 
    if(sGroupName==null) sGroupName=""; 
    if(sKeyMemberCustomerID==null) sKeyMemberCustomerID=""; 
    if(sRefVersionSeq==null) sRefVersionSeq=""; 
    if(sCurrentVersionSeq==null) sCurrentVersionSeq=""; 
    if(sRightType == null) sRightType = "";
    if(sTreeViewDetail == null) sTreeViewDetail = "";
    if(sInsertTreeNode == null) sInsertTreeNode = "false";
    if(GroupCustomerID == null) GroupCustomerID = "";

    /*=================================Ȩ��˵��==================================*/
    //������Ȩ�ޣ������¼���ȡֵ��All,Readonly,ViewOnly,None
    //All������Ȩ�ޣ�Readonlyֻ�ܲ鿴�޶�ģʽ�����ݣ��������޸��޶�ģʽ������
    //ViewOnlyֻ�ܲ鿴����ģʽ�����ݣ����ܲ鿴�޶�ģʽ������,None������ʾ�κ���ģʽ�йصİ�ť
    String RIGHT_TYPE=sRightType;
    //-----------------------������������Ϊ�����������������������ҳ��ᱨ��-------------------
    String groupId = sGroupID;        //���ſͻ����
    String versionSeq=sRefVersionSeq;         //�汾��
    
    //-----------TreeTable��ʾ����������-------------
    String sButtons[][] = {
        {"true","All","Button","ȷ��","","doReturn()","","","","btn_icon_save"},
        {"true","All","Button","ȡ�� ","","goback()","","","","btn_icon_delete"},
    };
%>

<!DOCTYPE>
<script type="text/javascript" src="<%=sWebRootPath%>/CustomerManage/GroupManage/resources/js/jquery/jquery.treeTable.js"></script>
<script type="text/javascript" src="<%=sWebRootPath%>/CustomerManage/GroupManage/resources/js/jquery/jquery.treeTable.extends.js"></script>
<link rel="stylesheet" type="text/css" href="<%=sWebRootPath%>/CustomerManage/GroupManage/resources/css/jquery.treeTable.css"></link>
<link rel="stylesheet" type="text/css" href="<%=sWebRootPath%>/CustomerManage/GroupManage/resources/css/jquery.treeTable.extends.css"></link>
<style type="text/css">
 body{font-size:14px;}
 .treetable{font-size:12px;margin:10px;width:99%;border:none;}
 .treetable thead tr th{padding:6px 20px 6px auto;font-size:14px;font-weight: bold;border:none;border-top: 1px solid #369;border-bottom: 1px solid #369;}
 .treetable tbody tr td{padding:3px 20px 3px auto;border-bottom: 1px dotted #369;}
/*���Ƴ�*/
.treetable tbody tr.removed td{text-decoration:line-through;color: #F00;}
/*�ڱ�ɾ�������ȥ���õ�Ԫ���ɾ����*/
.treetable tbody tr.removed .noremoved{text-decoration:none;}
/*�޸Ĺ�*/
.treetable tbody tr.changed td{color: #00F;}
/*�½���*/
.treetable tbody tr.new td{color:#008000;}
.newbutton{padding:2px;text-decoration: none;}
.newbutton:hover{color:#F00;}

/*-------------------------------------*/
.mydiv{font-size:14px;padding:3px;}
#normalAction,#revisionAction{text-decoration: none;padding:2px;}
#normalAction:hover,#revisionAction:hover{color:#DAA520;}
.actived{border:1px solid #B0C4DE;background-color: #FAFAD2;}
</style>
<body>
<div class="mydiv" style="height:1px;padding-bottom:10px;"><%@ include file="/Resources/CodeParts/ButtonSet.jsp"%></div>
<div class="mydiv"><span class="mylabel">��&nbsp;&nbsp;����</span><input type="text" id="searchText" /></div>




<%
    
    response.setHeader("Cache-Control","no-store");
    response.setHeader("Pragma","no-cache");
    response.setDateHeader("Expires",0);
    //��ȫ�ֱ����Ǳ���ģ����ڿ��ƾ���ʹ���ĸ��ڵ��࣬���������ҳ�淴�����
    String treeNodeClassName = "";
    //����ʵ��
    DefaultContextLoader loader = new DefaultContextLoader(CurUser,sGroupID,versionSeq) ;
    //DefaultContextLoader loader = new DefaultContextLoader(CurUser,"Demo001","1") ;
    FacesContext context = loader.getContext();
    
    context.setAttribute("Header","���ſͻ�������ά��");
    //������Ⱦ����
    HTMLRenderer<FamilyTreeNode> renderer = new TreeTableRenderer<FamilyTreeNode>();
    ((TreeTableRenderer<FamilyTreeNode>)renderer).setHeaderSetting("{MemberName=����,shareValue=�ֹɱ���(%)}");
    ((TreeTableRenderer<FamilyTreeNode>)renderer).setCodeSetting("{{id=root:��,1010:��һ��}}");
    treeNodeClassName = FamilyTreeNode.class.getName();
    //��ʼ����
    renderer.encodeBegin(context, (FamilyTreeNode)context.getRootComponent());
    renderer.encodeBody(context, (FamilyTreeNode)context.getRootComponent());
    renderer.encodeEnd(context, (FamilyTreeNode)context.getRootComponent());
    //���
    out.println(renderer.getHTML());

%>
</body>
</html>
<!-- ************************************************ -->
<!--                   ��ͼ����                                                              -->
<!-- ************************************************ -->
<script type="text/javascript"> 
//����ʵ����ʵ��ҵ���߼��߶ȹ�����javascript�߼�
    var table = null;
    var normalModel = true;
    $(document).ready(function() {
        table = $("table.treetable");
        //����treeTable
        table.treeTable({initialState:"expanded"});
        //���������ı䱳�������������¼�
        table.tableLight();
        
        //��������
        $("#searchText").keyup(function(){
            var text = $("#searchText").val();
            var searchResult = table.searchText({
                keyWord:text,             //����text����
                excludeColumn:"editCol"   //���ò���������
            });
        });

        return;
    });
    
	function doReturn(){
		 var currentRow = $(".selected",table);
		 var ParentMemberID = currentRow.getValue("id");
		 var ParentMemberName =currentRow.getValue("memberName");
		 var oReturn = {};
		 oReturn["id"] =ParentMemberID;
		 oReturn["MemberName"]=ParentMemberName;
		 self.returnValue = oReturn;
		 self.close();
	}
	function goback(){
		self.close();
	}
   
</script>
<%@ include file="/IncludeEnd.jsp"%>