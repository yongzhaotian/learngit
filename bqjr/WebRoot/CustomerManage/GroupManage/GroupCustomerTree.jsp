<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%@ page import="com.amarsoft.app.als.customer.group.tree.DefaultContextLoader" %>
<%@ page import="com.amarsoft.app.als.customer.group.tree.component.*" %>
<%@ page import="com.amarsoft.are.jbo.JBOFactory"%>
<%@ page import="com.amarsoft.are.jbo.BizObject"%>
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
    String sRefVersionSeq=CurPage.getParameter("RefVersionSeq");
    //正在使用的家谱版本编号
    String sCurrentVersionSeq=CurPage.getParameter("CurrentVersionSeq");
    //集团家谱版本状态
    String sFamilyMapStatus = CurComp.getParameter("FamilyMapStatus");
    //集团客户类型(跨分行/地区性):用于"集团客户详情"按钮
    String sGroupType1 = CurComp.getParameter("GroupType1");
    //当前最新外部信息:用于点击”维护新的家谱“按钮后重新载入页面用
    String sExternalVersionSeq = CurComp.getParameter("ExternalVersionSeq");
    //用于控制显示模式(正常/修订),及相关按钮
    String sRightType=CurComp.getParameter("RightType");
    String sInsertTreeNode=CurComp.getParameter("InsertTreeNode");  
    String groupCustomerID=CurComp.getParameter("GroupCustomerID");
    
    //页面显示信息（因前一页面传中文过来会有乱码问题，故接收家谱状态后在本页面转换为中文）
    String treeViewDetail1 = CurComp.getParameter("TreeViewDetail1");
    String treeViewDetail2 = CurComp.getParameter("TreeViewDetail2");
    //集团家谱版本状态中文名称
    String sFamilyMapStatusName="";
    if("0".equals(treeViewDetail1)){
		sFamilyMapStatusName="草稿";
	}else if("3".equals(treeViewDetail1)){
		sFamilyMapStatusName="审核退回";
	}else if("1".equals(treeViewDetail1)){
		sFamilyMapStatusName="审核中";
	}else if("2".equals(treeViewDetail1)){
		sFamilyMapStatusName="已认定";
	}
    
    //树图说明
    if(sGroupID==null) sGroupID=""; 
    if(sGroupName==null) sGroupName=""; 
    if(sKeyMemberCustomerID==null) sKeyMemberCustomerID=""; 
    if(sRefVersionSeq==null) sRefVersionSeq=""; 
    if(sCurrentVersionSeq==null) sCurrentVersionSeq=""; 
    if(sRightType == null) sRightType = "";
    if(sGroupType1 == null) sGroupType1 = "";
    if(sExternalVersionSeq == null) sExternalVersionSeq = "";
    if(treeViewDetail1 == null) treeViewDetail1 = "";
    if(sInsertTreeNode == null) sInsertTreeNode = "false";
    if(groupCustomerID == null) groupCustomerID = "";
    if(sFamilyMapStatus == null) sFamilyMapStatus = "";
    
    String TreeViewDetail="系统信息-家谱复核状态:["+sFamilyMapStatusName+"]-版本编号:["+treeViewDetail2+"]";//版本编号信息暂不显示
    //String TreeViewDetail="目前家谱版本状态:【"+sFamilyMapStatusName+"】";
    
    //判断当前集团是否有 已认定 的家谱版本，恢复最新已复核版本时使用
	int icount=JBOFactory.getBizObjectManager("jbo.app.GROUP_MEMBER_RELATIVE").createQuery("O.GroupID =:GroupID").setParameter("GroupID",sGroupID).getTotalCount();
	
    ASResultSet rsTemp = null;
    String sSql="";
    String sOldMemberCustomerID="";//已认定的核心企业客户编号
	sSql = "select MemberCustomerID from GROUP_MEMBER_RELATIVE where GroupID = :GroupID and ParentMemberID=:ParmentMemberID";
	rsTemp = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("GroupID",sGroupID).setParameter("ParmentMemberID","None"));
	if (rsTemp.next()){
		sOldMemberCustomerID  = DataConvert.toString(rsTemp.getString("MemberCustomerID"));
		//将空值转化成空字符串
		if(sOldMemberCustomerID == null) sOldMemberCustomerID = "";
	}
    rsTemp.getStatement().close();    
	
    
    //集团管理岗维护家谱可以直接生效 
    //String EditRight="2";
  
    /*=================================权限说明==================================*/
    //家谱树权限，有以下几个取值：All,Readonly,ViewOnly,None
    //All有所有权限;
    //Readonly只能查看修订模式的数据，而不能修改修订模式的数据;
    //ViewOnly只能查看正常模式的数据，不能查看修订模式的数据;
    //None不显示任何与模式有关的按钮
    String RIGHT_TYPE=sRightType;
    //-----------------------以下两个参数为必需参数，无这两个参数，页面会报错-------------------
    String groupId = sGroupID;        //集团客户编号
    String versionSeq=sRefVersionSeq;         //版本号
    
    //-----------TreeTable显示数据项设置-------------
    String sButtons[][] = {
        {((sRightType.equals("All")&&sFamilyMapStatus.equals("2"))||((sRightType.equals("All")&&sFamilyMapStatus.equals("3")))?"true":"false"),"All","Button","维护新的版本 ","","NewVersionSeq()",sResourcesPath},
        {"false","All","Button","完成家谱维护","","save()",sResourcesPath},
        {(sFamilyMapStatus.equals("0")&&sRightType.equals("All")?"true":"false"),"All","Button","提交复核","","doSubmit()",sResourcesPath},
        {((sRightType.equals("All")&&sFamilyMapStatus.equals("0")&&icount>0)?"true":"false"),"All","Button","取消家谱维护 ","","cancel()",sResourcesPath},
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
<div class="mydiv" ><%=TreeViewDetail%></div>
<div id="buttonBar">
<table>
	<tr height=1 id="ButtonTR">
		<td id="ListButtonArea" class="ListButtonArea" valign=top>
			<%@ include file="/Resources/CodeParts/ButtonSet.jsp"%>
		</td>
	</tr>
</table>
</div>
<% if(RIGHT_TYPE.equals("All") && sFamilyMapStatus.equals("0")){ %>
<div class="mydiv"><span class="mylabel">显示模式：</span><a href="javascript:void(0)" id="normalAction">正常</a><a href="javascript:void(0)" id="revisionAction">修订模式</a></div>
<%} %>
<div class="mydiv"><span class="mylabel">查&nbsp;&nbsp;找：</span><input type="text" id="searchText"></input></div>
<%
    response.setHeader("Cache-Control","no-store");
    response.setHeader("Pragma","no-cache");
    response.setDateHeader("Expires",0);
    //该全局变量是必需的，用于控制具体使用哪个节点类，传给后面的页面反射调用
    String treeNodeClassName = "";
    //查找实例
    DefaultContextLoader loader = new DefaultContextLoader(CurUser,sGroupID,versionSeq) ;
    FacesContext context = loader.getContext();
    
    context.setAttribute("Header","集团客户家谱树维护");
    //设置渲染参数
    HTMLRenderer<FamilyTreeNode> renderer = new TreeTableRenderer<FamilyTreeNode>();
    ((TreeTableRenderer<FamilyTreeNode>)renderer).setHeaderSetting("{memberName=名称,shareValue=持股比例}");
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
<!--                   按钮触发                                                              -->
<!-- ************************************************ -->
<script type="text/javascript"> 
	function save(){
		var sGroupID = "<%=sGroupID%>";//集团客户编号
	    if (typeof(sGroupID) == "undefined" || sGroupID.length == 0){
	        alert("维护新的家谱失败,集团客户编号为空!");
	        return;
	    }
		
    	var sRefVersionSeq = "<%=sRefVersionSeq%>";//正在维护的家谱版本编号
       if(confirm("点击确认,将建立新的家谱并对当前复核通过的家谱进行失效操作!")){
			var sReturn=RunJavaMethodTrans("com.amarsoft.app.als.customer.group.model.UpdateFamilyApproveStatus","updateFamilyApproveStatus","userID=<%=CurUser.getUserID()%>,groupID="+sGroupID+",versionSeq="+sRefVersionSeq+",effectiveStatus=2");
			if(sReturn=="SUCCEEDED"){
				alert("当前家谱已经生效！");	
				parent.parent.amarTab.refreshWidgetTab('集团家谱概况');
			}else{
				alert("当前家谱维护失败！");	
			}
		}
	}
	function doSubmit(){
    	var sGroupID = "<%=sGroupID%>";//集团客户编号
    	var sCurrentVersionSeq="<%=sCurrentVersionSeq%>";
    	var sRefVersionSeq = "<%=sRefVersionSeq%>";//正在维护的家谱版本编号
    	//对所有成员进行复核，集团家谱成员需至少2名才可建立集团提交复核
    	var sReturn = RunJavaMethod("com.amarsoft.app.als.customer.group.action.CheckGroupMemberCount","checkGroupMemberCount","groupId="+sGroupID+",VersionSeq="+sRefVersionSeq);
    	if(sReturn == "No"){
			alert("该集团成员少于2名，不能提交复核！");
			return;
        }
    	//对所有成员进行复核，如果成员在其他集团中存在，则不允许提交复核  
		sReturn = RunJavaMethod("com.amarsoft.app.als.customer.group.action.GroupCustomerManage","checkAllGroupMember","GroupID="+sGroupID);
		if(sReturn!="true"){
			alert(sReturn);
			return ;
		}
		var sReturn = AsControl.PopView("/CustomerManage/GroupManage/FamilyVersionApplyOpinionInfo.jsp","GroupID="+sGroupID+"&VersionSeq="+sRefVersionSeq+"&CurrentVersionSeq="+sCurrentVersionSeq+"&EditRight=1&GroupType1=<%=sGroupType1%>","dialogWidth=40;dialogHeight=30;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
    	if(sReturn=="successed"){
			alert("提交复核成功");
			var sParam="TreeViewDetail1=1&TreeViewDetail2=<%=treeViewDetail2%>&RightType=<%=sRightType%>&FamilyMapStatus=1&GroupID=<%=sGroupID%>&KeyMemberCustomerID=<%=sKeyMemberCustomerID%>&RefVersionSeq=<%=sRefVersionSeq%>&CurrentVersionSeq=<%=sCurrentVersionSeq%>&GroupType1=<%=sGroupType1%>&InsertTreeNode=<%=sInsertTreeNode%>&GroupCustomerID=<%=groupCustomerID%>";
			OpenComp("GroupCustomerTree","/CustomerManage/GroupManage/GroupCustomerTree.jsp",sParam,"_self");
 	 	}
	}

	function NewVersionSeq(){
        var sGroupID = "<%=sGroupID%>";
	    if (typeof(sGroupID) == "undefined" || sGroupID.length == 0){
	        alert("维护新的家谱失败,集团客户编号为空!");// 
	        return;
	    }
		if(confirm("点击确认,将建立新的家谱并对当前复核通过的家谱进行失效操作!")){
		  	//重新初始化家谱版本表及家谱成员表,并返回新的正在维护家谱版本编号
			var sRefVersionSeq=RunJavaMethodTrans("com.amarsoft.app.als.customer.group.action.FamilyMaintain","getNewRefVersionSeq","userID=<%=CurUser.getUserID()%>,groupID="+sGroupID+",currentVersionSeq=<%=sCurrentVersionSeq%>");
		  	if(typeof(sRefVersionSeq)!="undefined" && sRefVersionSeq.length !=0 && sRefVersionSeq!="ERROR"){
				var sParam="TreeViewDetail1=0&TreeViewDetail2="+sRefVersionSeq+"&RightType=<%=sRightType%>&FamilyMapStatus=0&GroupID=<%=sGroupID%>&KeyMemberCustomerID=<%=sKeyMemberCustomerID%>&RefVersionSeq="+sRefVersionSeq+"&CurrentVersionSeq=<%=sCurrentVersionSeq%>&GroupType1=<%=sGroupType1%>&InsertTreeNode=<%=sInsertTreeNode%>&GroupCustomerID=<%=groupCustomerID%>";
				OpenComp("GroupCustomerTree","/CustomerManage/GroupManage/GroupCustomerTree.jsp",sParam,"_self");
			}
		}
	}
	
	//取消对当前家谱的维护操作，将家谱恢复到最新的已复核过的版本
	function cancel(){
		var sGroupID = "<%=sGroupID%>";
		if (typeof(sGroupID) == "undefined" || sGroupID.length == 0){
	        alert("操作失败,集团客户编号为空!");
	        return;
	    }
		var sRefVersionSeq="<%=sRefVersionSeq%>";//当前正在维护的家谱版本
		var sCurrentVersionSeq="<%=sCurrentVersionSeq%>";//最新已认定的家谱版本编号
        
		if(confirm("是否取消对家谱的维护，并将家谱恢复到最新已认定状态!")){
			var sReturn=RunJavaMethodTrans("com.amarsoft.app.als.customer.group.action.FamilyMaintain","deleteRefVersion","userID=<%=CurUser.getUserID()%>,groupID="+sGroupID+",refVersionSeq="+sRefVersionSeq+",currentVersionSeq="+sCurrentVersionSeq+",oldMemberCustomerID=<%=sOldMemberCustomerID%>");
		  	if(sReturn="true"){
				alert("恢复集团家谱成功!");
				var sParam="TreeViewDetail1=2&TreeViewDetail2=<%=sCurrentVersionSeq%>&RightType=<%=sRightType%>&FamilyMapStatus=2&GroupID=<%=sGroupID%>&KeyMemberCustomerID=<%=sKeyMemberCustomerID%>&RefVersionSeq="+sCurrentVersionSeq+"&CurrentVersionSeq=<%=sCurrentVersionSeq%>&GroupType1=<%=sGroupType1%>&InsertTreeNode=<%=sInsertTreeNode%>&GroupCustomerID=<%=groupCustomerID%>";
				OpenComp("GroupCustomerTree","/CustomerManage/GroupManage/GroupCustomerTree.jsp",sParam,"_self");
			}
		}
	}
</script>

<!-- ************************************************ -->
<!--                   树图操作                                                              -->
<!-- ************************************************ -->
<script type="text/javascript"> 
//这里实现与实际业务逻辑高度关联的javascript逻辑
    var sKeyMemberCustomerID="<%=sKeyMemberCustomerID%>";
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
        //模式转换按钮
        $("#normalAction").click(normalModelHandler);//正常模式
        $("#revisionAction").click(revisionModelHandler);//修订模型
        normalModelHandler();//默认为正常模式
        return;
    });
    //正常模式
    function normalModelHandler(){
        //更改显示
        $("#normalAction").addClass("actived");
        $("#revisionAction").removeClass("actived");
        
        $("tbody tr",table).each(function(){
            $(this).removeClass("new changed removed");
            if($(this).getValue("state")=="REMOVED"){
                $(this).hide();
                $(this).attr("hidden",true);
            }
        });
        //删除操作列
        try{table.removeColumn({name:"editCol"});}catch(e){};
        normalModel = true;
    }
    //修订模式
    function revisionModelHandler(){
        //只有拥有所有权限才可以修改 
    	  <% if(sRightType.equals("All")){%>
        //添加操作列
        var buttonClass="newbutton";
        table.addExecuteColumn({
            headerText:"操作",  //列名称
            name:"editCol",  //按钮列名称
            colClass:"noremoved",//按钮列使用的样式，主要用于去除删除时，增加的删除线
            buttons:[
                    {buttonClass:buttonClass,text : "新增",title:"插入一个成员",execute : insertHandler}
                    ,{buttonClass:buttonClass,text : "修改",execute : editHandler,filter : editActionFilter}
                    ,{buttonClass:buttonClass,text : "删除",title:"标记为删除",execute : deleteHandler,filter : deleteActionFilter}
                    //,{buttonClass:buttonClass,text : "撤销",execute : undoHandler,filter : undoActionFilter}
                    ]
        });   
        <% }%>      
        //更改显示
        $("#normalAction").removeClass("actived");
        $("#revisionAction").addClass("actived");
        
        $("tbody tr",table).each(function(){
            $(this).attr("hidden",false);//取消隐藏
            if($(this).getValue("state")=="NEW"){
                $(this).addClass("new");
            }else if($(this).getValue("state")=="CHANGED"){
                $(this).addClass("changed");
            }if($(this).getValue("state")=="REMOVED"){
                //如果父节点没有展开，则不需要显示
                //if($(this).parent().hasClass("expanded"))$(this).show();
                //$(this).addClass("removed");
            	 $(this).hide();
                 $(this).attr("hidden",true);
            }
        });
       //修订标志
        normalModel = false;
    }
    //定义按钮过滤器
    //-----------------------------------------------
    //编辑按钮过滤器 删除按钮
    function deleteActionFilter(tr){
        if(tr&&tr.attr&&(tr.attr("id")==sKeyMemberCustomerID)) return false;//根节点不出删除按钮
        else return true;
    }
    //正式成员不能修改
    function editActionFilter(tr){
        if(tr&&tr.attr&&(tr.attr("id")==sKeyMemberCustomerID|| tr.getValue("state")=="CHECKED"))return false;//根节点、正式成员 只能删除，不能编辑或者撤销
        else return true;
    }

  //编辑按钮过滤器  撤销按钮
    function undoActionFilter(tr){
        if(tr&&tr.attr&&tr.attr("id")==sKeyMemberCustomerID) return false;//根节点、正式成员不能撤销
        else return true;
    }
    
    //定义按钮动作
    //----------------------------------------------------------
    //插入新节点，新增集团成员
	function insertHandler(){
		var currentRow = $(this).parents("tr");
       var newRow = currentRow.clone(true);
		var sRefVersionSeq ="<%=sRefVersionSeq%>";
		var sGroupID="<%=sGroupID%>";
		var parentId = currentRow.getValue("id");
		var dialogStyle = "dialogWidth=600px;dialogHeight=400px;status:no;center:yes;help:no;minimize:yes;maximize:no;border:thin;statusbar:no";
		var pageURL="/CustomerManage/MemberInfoViewer.jsp";
		var oReturn= AsControl.PopView(pageURL,"GroupID="+sGroupID+"&ParentMemberID="+parentId+"&RefVersionSeq="+sRefVersionSeq,dialogStyle);
       if(typeof(oReturn) != "undefined"){
         	fillRow(newRow,oReturn,"NEW");
        	var ret = TreeTableContext.addNode(newRow.nodeJSON());
      	 	if(ret){
      	 		applyCSS(newRow,"new");
            	newRow.appendNewBranchTo(currentRow);//成功后，才添加节点
           		//重新计算操作列
            	normalModelHandler();
            	revisionModelHandler();
       		}
		}
    }

    function fillRow(row,json,state){
    	row.setValue("id",json["MemberCustomerID"]);
    	row.setValue("memberName",json["MemberName"]);
    	row.setValue("memberCertType",json["MemberCertType"]);
     	row.setValue("memberCertID",json["MemberCertID"]);
     	row.setValue("memberType",json["MemberType"]);
     	if(json["ShareValue"] != null){
         	if(typeof json["ShareValue"] != "string") json["ShareValue"] = json["ShareValue"].toString();
	     	row.setValue("shareValue",json["ShareValue"]);
        }
    	row.setValue("parentId",json["ParentMemberID"]);
    	row.setValue("parentRelationType",json["ParentRelationType"]);
    	row.setValue("addReason",json["AddReason"]);
    	row.setValue("state",state);
    }
    //编辑集团成员信息
    function editHandler(){
        var currentRow = $(this).parents("tr");
        var state = currentRow.getValue("state");
        if(state=="REMOVED"){
            alert("当前节点为删除状态，请先撤消");
            return;
        }
        var memberJson = viewMemberInfo(currentRow.nodeJSON());
        if(memberJson){
        	fillRow(currentRow,memberJson,"CHANGED");
        }
    }
	//删除集团成员
	function deleteHandler(){
		 var currentRow = $(this).parents("tr"); 
		 var sRefVersionSeq ="<%=sRefVersionSeq%>";
        var sGroupID="<%=sGroupID%>";
        var parentId = currentRow.getValue("id");
        var sReturn = RunJavaMethod("com.amarsoft.app.als.customer.group.action.CheckSubMemberFamilyTree","subMemberExist","GroupId="+sGroupID+",ParentMemberID="+parentId+",VersionSeq="+sRefVersionSeq);
		 if(sReturn == "EXIST"){
			alert("该成员下存在子节点，请先删除子节点再执行此操作！");
			return;
		 }
    	 if(!confirm("您确定要删除该成员吗？"))return;
    	 //执行删除
         var ret = TreeTableContext.removeNode(currentRow.nodeJSON());
         if(ret)currentRow.removeBranch();
    }

    //删除
    function deleteHandler2(){
		var currentRow = $(this).parents("tr");
		var state = currentRow.getValue("state");
		if(state=="NEW"){
			alert("状态为新增的节点，不能删除，只能撤消");
			return;
        }
		var nodes = [];
		nodes[0] = currentRow;
		currentRow.progeny().each(function(){
			nodes.push($(this));
        });
        applyState(nodes,"removed");
    }
    //撤消
    function undoHandler(){
        var currentRow = $(this).parents("tr");
        var state=currentRow.getValue("state");
        if(state=="NEW"){//为新节点时，撤消操作为删除新节点
            if(!confirm("当前节点为新节点，撤消会删除该节点，确定继续吗？"))return;
            //执行删除
            var ret = TreeTableContext.removeNode(currentRow.nodeJSON());
            if(ret)currentRow.removeBranch();
        }else if(state=="REMOVED"){
            var parentNode = currentRow.parent();
            if(parentNode.getValue("state")=="REMOVED"){
                alert("请先撤消父节点的删除状态");
                return;
            }
            applyState(currentRow,"CHANGED");
        }else if(state=="CHANGED"){
            applyState(currentRow,"CHECKED");
        }
    }
    function deleteData(){
        var currentRow = $(this).parents("tr");
        var ret = TreeTableContext.removeNode(currentRow.nodeJSON());
        if(ret)currentRow.removeBranch();
    }
    //修改状态
    function applyState(node,stateValue){
        stateValue = stateValue.toUpperCase();//转为大写
        //先更新服务端数据
        if($.isArray(node)){//为数组的情况,逐个找出，批量发送
            var nodes = [];
            for(var i=0;i<node.length;i++){//找出数组中所有JSON对象
                var item = node[i];
                if(item.getValue("state")==stateValue)continue;//如果状态没有改变，则不需要继续
                item.setValue("state",stateValue);
                nodes[i] = item.nodeJSON();
            }
            if(nodes.length==0)return false;  //如果没有需要改改变的，直接返回
            var ret = TreeTableContext.setValue(nodes);//批量发送
            if(ret>0){                        //成功后，修改客户端显示
                for(var i=0;i<node.length;i++){
                    applyCSS(node[i],stateValue.toLowerCase());
                }
                return true;
            }
            return false;
        }else if(typeof(node)=="object"){//单个对象的情况
            if(node.getValue("state")==stateValue)return false;//如果状态一样，则不用修改了
            node.setValue("state",stateValue);
            var ret = TreeTableContext.setValue(node.nodeJSON());
            if(ret){//这里面来修改客户端显示
                applyCSS(node,stateValue.toLowerCase());
                return true;
            };
            return false;
        }
    }
    function applyCSS(node,cssName){
        var removedClassName = "new changed removed";
        node.removeClass(removedClassName);
        node.addClass(cssName);
    }

    //添加一个新成员
    function addMember(member){
		if(normalModel){
            alert("当前模式不为修订模式，不能添加节点");
            return;
        }
		var selectedRecord = getSelected();
		if(selectedRecord.size()==0){
            alert("请在右侧先选择一条记录");
            return;
        } 
        
		var memberid=member["id"];//选中节点成员客户编号
		var sReturn=RunJavaMethod("com.amarsoft.app.als.customer.group.action.GroupCustomerManage","isGroupCustomer","MemberCustomerID="+memberid+",GroupID="+<%=sGroupID%>);
 		if(sReturn!="true"){//如该成员已属于其他集团不允许添加，系统给出提示信息
			alert(sReturn);
			return;
		}
        
		try{ 
			var bexists=false;
			$("tbody tr",table).each(function(){ 
				myNode=$(this);
				if(myNode.getValue("memberName")==member["memberName"]){
					bexists=true;
				}
			});
        	 
			if(member && !bexists){ 
				var newNode = selectedRecord.clone(true);
				newNode.setValue("state","NEW");
				newNode.setValue("id",member["id"]);
          		newNode.setValue("shareValue","0.0");
          		newNode.setValue("memberCertType",member["memberCertType"]);
          		newNode.setValue("memberCertID",member["memberCertID"]);
          		newNode.setValue("memberName",member["memberName"]);
          		newNode.setValue("parentId",selectedRecord.getValue("id"));
          		newNode.setValue("parentRelationType","01");
          		selectedRecord.removeClass("selected");
          		var ret = TreeTableContext.addNode(newNode.nodeJSON());
          		if(ret){
              	applyCSS(newNode,"new");
              	newNode.appendNewBranchTo(selectedRecord);//成功后，才添加节点
          		}
          		//重新计算操作列
          		normalModelHandler();
          		revisionModelHandler(); 
 			}else{
    			if(!member) alert("没有传入客户对象");
      			if(bexists){
					alert("["+member["memberName"]+"]"+"已属于当前集团成员,不需要再次添加!");
					return ;
        		}
	        }
        }catch(e){
			alert("对不起该节点["+member["memberName"]+"]已存在");
        }
    }
    //获取被选中的记录
    function getSelected(){
        return $("tr.selected",table);
    }

    //查看详情
    function viewMemberInfo(json){
        var MemberCustomerID = json["id"];
        var param = [
                     "MemberCustomerID="+MemberCustomerID
                     ,"GroupID=<%=sGroupID%>"
                     ,"RefVersionSeq=<%=sRefVersionSeq%>"
                     ];
        var dialogStyle = "dialogWidth=600px;dialogHeight=400px;status:no;center:yes;help:no;minimize:yes;maximize:no;border:thin;statusbar:no";
        var pageURL="/CustomerManage/MemberInfoViewer.jsp";
        return AsControl.PopView(pageURL,param.join("&"),dialogStyle);
    }
</script>
<!-- ************************************************ -->
<!--                   插件设置                                                              -->
<!-- ************************************************ -->
<script language="javascript">
//设置树图节点实现类
TreeTableContext.treeNodeClassName="<%=treeNodeClassName%>";
TreeTableContext.redirector=sWebRootPath + "/Redirector";
TreeTableContext.contextHelperURL="/CustomerManage/GroupManage/Component/TreeTableContextHelper.jsp";
</script>

<script language="javascript" type="text/javascript">
<%if("".equals(sGroupID) || "".equals(sRefVersionSeq)){ %>
    alert("数据有问题,树图无法展现!");
<% }%>
</script>

<%@ include file="/IncludeEnd.jsp"%>