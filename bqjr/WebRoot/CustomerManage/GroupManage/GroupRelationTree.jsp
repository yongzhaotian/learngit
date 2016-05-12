<%@ page language="java" contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%@ page import="com.amarsoft.app.als.customer.group.tree.SearchContextLoader" %>
<%@ page import="com.amarsoft.app.als.customer.group.tree.component.*" %>
<!DOCTYPE>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=GBK">
    <title>集团客户家谱树</title>
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
</head>
<body>
<div class="mydiv"><span class="mylabel">搜&nbsp;&nbsp;索：</span><input type="text" id="searchText"></input></div>



<%
    
    response.setHeader("Cache-Control","no-store");
    response.setHeader("Pragma","no-cache");
    response.setDateHeader("Expires",0);
    //该全局变量是必需的，用于控制具体使用哪个节点类，传给后面的页面反射调用
    String treeNodeClassName = "";
    
//---------------------------------------------------------
    //取集团客户编号、关联关系起点客户编号
	String sGroupID = CurPage.getParameter("GroupID");
	String sCustomerID = CurPage.getParameter("CustomerID");
	String sCustomerName = CurPage.getParameter("CustomerName");
	String sFundRela = CurPage.getParameter("FundRela");
	String sPersonRela = CurPage.getParameter("PersonRela");
	String sOtherRela = CurPage.getParameter("OtherRela");
	String sAssureRela = CurPage.getParameter("AssureRela");
	String sSearchlevel = CurPage.getParameter("Searchlevel");
	String sLevel = CurPage.getParameter("Level");
	String sPersonNode = CurPage.getParameter("PersonNode");
	String sLowerLimit = CurPage.getParameter("LowerLimit");
	String sRightType=CurPage.getParameter("RightType");
	
	if(sGroupID == null) sGroupID = "";
	if(sCustomerID == null) sCustomerID = "";
	if(sCustomerName == null) sCustomerName = "";
	if(sLevel == null || sLevel == "") sLevel = "5";
	if(sLowerLimit == null || sLowerLimit == "") sLowerLimit = "0";
	if(sPersonNode == null || "".equals(sPersonNode)) sPersonNode = "PersonNodeNo"; 
	if(sRightType == null) sRightType = ""; 
	
	SearchContextLoader loader = new SearchContextLoader();
	loader.setGroupID(sGroupID);
	loader.setCustomerID(sCustomerID);
	loader.setCustomerName(sCustomerName);
	loader.setFundRela(sFundRela);
	loader.setPersonRela(sPersonRela);
	loader.setOtherRela(sOtherRela);
	loader.setAssureRela(sAssureRela);
	loader.setLowerLimit(Double.parseDouble(sLowerLimit));
	loader.setSearchlevel(Integer.parseInt(sLevel));
	loader.setPersonNode(sPersonNode);
    
    //查找实例
    FacesContext context = loader.getContext();
    
    context.setAttribute("Header","集团客户家谱树维护");
    //设置渲染参数
    HTMLRenderer<FamilyTreeNode> renderer = new TreeTableRenderer<FamilyTreeNode>();
    ((TreeTableRenderer<FamilyTreeNode>)renderer).setHeaderSetting("{memberName=名称,MemberType=关系}");
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
<script type="text/javascript"> 
//这里实现与实际业务逻辑高度关联的javascript逻辑
    var table = null;
    $(document).ready(function() {
        table = $("table.treetable");
        table.treeTable();//生成treeTable
        table.tableLight();//给表绑定移入改变背景，单击高亮事件
        //-----------------------------
        //按钮功能触发
        //搜索功能
        $("#searchText").keyup(function(){
            var text = $("#searchText").val();
            var searchResult = table.searchText({
                keyWord:text,             //搜索text文字
                excludeColumn:"editCol"   //设置不搜索的列
            });
            //alert(searchResult.length);
        });
        table.addExecuteColumn({
            headerText:"操作",  //列名称
            name:"editCol",  //按钮列名称
            colClass:"noremoved",//按钮列使用的样式，主要用于去除删除时，增加的删除线
            buttons:[
                    {
                    	text : "添加"
                    	,execute : function(){
                    		var currentRow = $(this).parents("tr");
                    		myadd(currentRow.nodeJSON());
                    		
                    	}
                    }
                    ]
        });   
    });


    function myadd(obj)
    { 
		oweb=parent.parent.myCheck();
		 if(oweb)
		 {
			alert("当前显示视图为关系网，不能添加搜索成员，请将显示视图修改为层次结构！");
			return ;
		}
    	parent.parent.right.addMember(obj);
    }
</script>

<script language="javascript">
//设置树图节点实现类
TreeTableContext.treeNodeClassName="<%=treeNodeClassName%>";
TreeTableContext.redirector=sWebRootPath + "/Redirector";
TreeTableContext.contextHelperURL="/CustomerManage/GroupManage/Component/TreeTableContextHelper.jsp";
</script>
<%@ include file="/IncludeEnd.jsp"%>