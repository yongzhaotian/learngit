<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>
<%@ page import="com.amarsoft.app.als.customer.group.tree.DefaultContextLoader" %>
<%@ page import="com.amarsoft.app.als.customer.group.tree.component.*" %>
<%
/***************************************************
 * Module: GroupCustomerTree.jsp
 * Author: syang
 * Modified: 2010/09/26 16:15
 * Purpose: 家谱树组件调用页面
 ***************************************************/
%>
<%
    String sGroupID=CurPage.getParameter("GroupID");
    String sGroupName=CurPage.getParameter("GroupName");
    //母公司客户编号(关联关系搜索用)
    String sKeyMemberCustomerID=CurPage.getParameter("KeyMemberCustomerID");
    //正在维护的家谱版本编号
    String sRefVersionSeq=CurPage.getParameter("VersionSeq");
    //旧的的家谱版本编号
    String sCurrentVersionSeq=CurPage.getParameter("CurrentVersionSeq");

    //用于控制显示模式(正常/修订),及相关按钮
    String sRightType=CurComp.getParameter("RightType");
    String sInsertTreeNode=CurComp.getParameter("InsertTreeNode");  
    String GroupCustomerID=CurComp.getParameter("GroupCustomerID");
    //树图说明
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

    /*=================================权限说明==================================*/
    //家谱树权限，有以下几个取值：All,Readonly,ViewOnly,None
    //All有所有权限，Readonly只能查看修订模式的数据，而不能修改修订模式的数据
    //ViewOnly只能查看正常模式的数据，不能查看修订模式的数据,None，不显示任何与模式有关的按钮
    String RIGHT_TYPE=sRightType;
    //-----------------------以下两个参数为必需参数，无这两个参数，页面会报错-------------------
    String groupId = sGroupID;        //集团客户编号
    String versionSeq=sRefVersionSeq;         //版本号
    
    //-----------TreeTable显示数据项设置-------------
    String sButtons[][] = {
        {"true","All","Button","确定","","doReturn()","","","","btn_icon_save"},
        {"true","All","Button","取消 ","","goback()","","","","btn_icon_delete"},
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
/*已移除*/
.treetable tbody tr.removed td{text-decoration:line-through;color: #F00;}
/*在被删除的行里，去除该单元格的删除线*/
.treetable tbody tr.removed .noremoved{text-decoration:none;}
/*修改过*/
.treetable tbody tr.changed td{color: #00F;}
/*新建立*/
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
<div class="mydiv"><span class="mylabel">搜&nbsp;&nbsp;索：</span><input type="text" id="searchText" /></div>




<%
    
    response.setHeader("Cache-Control","no-store");
    response.setHeader("Pragma","no-cache");
    response.setDateHeader("Expires",0);
    //该全局变量是必需的，用于控制具体使用哪个节点类，传给后面的页面反射调用
    String treeNodeClassName = "";
    //查找实例
    DefaultContextLoader loader = new DefaultContextLoader(CurUser,sGroupID,versionSeq) ;
    //DefaultContextLoader loader = new DefaultContextLoader(CurUser,"Demo001","1") ;
    FacesContext context = loader.getContext();
    
    context.setAttribute("Header","集团客户家谱树维护");
    //设置渲染参数
    HTMLRenderer<FamilyTreeNode> renderer = new TreeTableRenderer<FamilyTreeNode>();
    ((TreeTableRenderer<FamilyTreeNode>)renderer).setHeaderSetting("{MemberName=名称,shareValue=持股比例(%)}");
    ((TreeTableRenderer<FamilyTreeNode>)renderer).setCodeSetting("{{id=root:根,1010:第一级}}");
    treeNodeClassName = FamilyTreeNode.class.getName();
    //开始编码
    renderer.encodeBegin(context, (FamilyTreeNode)context.getRootComponent());
    renderer.encodeBody(context, (FamilyTreeNode)context.getRootComponent());
    renderer.encodeEnd(context, (FamilyTreeNode)context.getRootComponent());
    //输出
    out.println(renderer.getHTML());

%>
</body>
</html>
<!-- ************************************************ -->
<!--                   树图操作                                                              -->
<!-- ************************************************ -->
<script type="text/javascript"> 
//这里实现与实际业务逻辑高度关联的javascript逻辑
    var table = null;
    var normalModel = true;
    $(document).ready(function() {
        table = $("table.treetable");
        //生成treeTable
        table.treeTable({initialState:"expanded"});
        //给表绑定移入改变背景，单击高亮事件
        table.tableLight();
        
        //搜索功能
        $("#searchText").keyup(function(){
            var text = $("#searchText").val();
            var searchResult = table.searchText({
                keyWord:text,             //搜索text文字
                excludeColumn:"editCol"   //设置不搜索的列
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