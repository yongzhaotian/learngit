<%@ page language="java" contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%@ page import="com.amarsoft.app.als.customer.group.tree.SearchContextLoader" %>
<%@ page import="com.amarsoft.app.als.customer.group.tree.component.*" %>
<!DOCTYPE>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=GBK">
    <title>���ſͻ�������</title>
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
</head>
<body>
<div class="mydiv"><span class="mylabel">��&nbsp;&nbsp;����</span><input type="text" id="searchText"></input></div>



<%
    
    response.setHeader("Cache-Control","no-store");
    response.setHeader("Pragma","no-cache");
    response.setDateHeader("Expires",0);
    //��ȫ�ֱ����Ǳ���ģ����ڿ��ƾ���ʹ���ĸ��ڵ��࣬���������ҳ�淴�����
    String treeNodeClassName = "";
    
//---------------------------------------------------------
    //ȡ���ſͻ���š�������ϵ���ͻ����
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
    
    //����ʵ��
    FacesContext context = loader.getContext();
    
    context.setAttribute("Header","���ſͻ�������ά��");
    //������Ⱦ����
    HTMLRenderer<FamilyTreeNode> renderer = new TreeTableRenderer<FamilyTreeNode>();
    ((TreeTableRenderer<FamilyTreeNode>)renderer).setHeaderSetting("{memberName=����,MemberType=��ϵ}");
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
<script type="text/javascript"> 
//����ʵ����ʵ��ҵ���߼��߶ȹ�����javascript�߼�
    var table = null;
    $(document).ready(function() {
        table = $("table.treetable");
        table.treeTable();//����treeTable
        table.tableLight();//���������ı䱳�������������¼�
        //-----------------------------
        //��ť���ܴ���
        //��������
        $("#searchText").keyup(function(){
            var text = $("#searchText").val();
            var searchResult = table.searchText({
                keyWord:text,             //����text����
                excludeColumn:"editCol"   //���ò���������
            });
            //alert(searchResult.length);
        });
        table.addExecuteColumn({
            headerText:"����",  //������
            name:"editCol",  //��ť������
            colClass:"noremoved",//��ť��ʹ�õ���ʽ����Ҫ����ȥ��ɾ��ʱ�����ӵ�ɾ����
            buttons:[
                    {
                    	text : "���"
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
			alert("��ǰ��ʾ��ͼΪ��ϵ�����������������Ա���뽫��ʾ��ͼ�޸�Ϊ��νṹ��");
			return ;
		}
    	parent.parent.right.addMember(obj);
    }
</script>

<script language="javascript">
//������ͼ�ڵ�ʵ����
TreeTableContext.treeNodeClassName="<%=treeNodeClassName%>";
TreeTableContext.redirector=sWebRootPath + "/Redirector";
TreeTableContext.contextHelperURL="/CustomerManage/GroupManage/Component/TreeTableContextHelper.jsp";
</script>
<%@ include file="/IncludeEnd.jsp"%>