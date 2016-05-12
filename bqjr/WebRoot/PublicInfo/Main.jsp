<%@ page contentType="text/html; charset=GBK"%>
<%@page import="com.amarsoft.web.ui.mainmenu.AmarMenu"%>
<%@ include file="/IncludeBegin.jsp"%>
<link rel="stylesheet" href="<%=sResourcesPath%>/css/strip.css">
<link rel="stylesheet" href="<%=sResourcesPath%>/css/tabs.css">
<link rel="stylesheet" href="<%=sSkinPath%>/css/tabs.css">
<link rel="stylesheet" href="<%=sResourcesPath%>/css/treeview.css">
<script type='text/javascript' src='<%=sResourcesPath%>/js/plugins/jquery.treeview.js'></script>
<script type='text/javascript' src='<%=sResourcesPath%>/js/plugins/tabstrip-1.0.js'></script>
<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   
		Tester:
		Content: 主页面
		Input Param:
			          
		Output param:
			      
		History Log: syang 2009/09/27 工作台及日历挪到日常工作提示上。
		History Log: syang 2009/12/09 改写页面TAB生成方式。
		History Log: syang 2009/12/16 TAB支持自定义功能
	 */
	%>
<%/*~END~*/%>

<%
	//取系统名称
	String sImplementationName = CurConfig.getConfigure("ImplementationName");
	if (sImplementationName == null) sImplementationName = "";
%> 
<html>
<head>
<title><%=sImplementationName%></title>
<%
//String sSNo = CurARC.getAttribute(request.getSession().getId()+"city");
String sSNo = Sqlca.getString(new SqlObject("select attribute8 from user_info  where userid=:UserID").setParameter("UserID", CurUser.getUserID()));
System.out.println("----user_info中门店编号---"+sSNo);
ARE.getLog().debug("是否车贷用户标识isCar="+CurUser.getIsCar());
ARE.getLog().debug("门店获展厅编号="+CurUser.getAttribute8());

// 判定该销售是否已经关联门店
ASResultSet rs = Sqlca.getResultSet(new SqlObject("select sno,sname from store_info where identtype='01' and sno in (Select sno from STORERELATIVESALESMAN where SalesManNo='"+CurUser.getUserID()+"')"));
//判定该销售是否已经关联展厅
ASResultSet rs2 = Sqlca.getResultSet(new SqlObject("select sno,sname from store_info where identtype='02' and sno in (Select sno from STORERELATIVESALESMAN where SalesManNo='"+CurUser.getUserID()+"')"));


//消费金融、门店 
if (CurUser.hasRole("1006")) { %>
<script type="text/javascript">
str="<%=rs.next()%>";
if("false"==str){
	alert("请先在门店管理关联该销售员！");
	window.open("index.html","_top");
}else if("true"==str){
	var sRetVal = AsControl.PopView("/AppMain/ModifySotres.jsp", "identtype=01", "dialogWidth=450px;dialogHeight=150px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
	if (typeof(sRetVal)=='undefined' || sRetVal.length==0) {
		alert("请重新登录并选择关联门店！");
		window.open("index.html","_top");
	}else{
		OpenComp("Main","/Main.jsp","ToDestroyAllComponent=Y&StoreChosen="+sRetVal,"_top","");//用于解决头部当前账户信息无法及时获取的问题 add by phe
	}
}
</script><%}else if(CurUser.hasRole("3008")){ %>
<!-- 汽车金融、展厅 -->
<script type="text/javascript">
st="<%=rs2.next()%>";
if("false"==st){
	alert("请先在经销商管理关联该销售员！");
	window.open("index.html","_top");
}else if("true"==st){
	var sRetVal = AsControl.PopView("/AppMain/ModifySotres.jsp", "identtype=02", "dialogWidth=450px;dialogHeight=150px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
	if(typeof(sRetVal)=='undefined' || sRetVal.length==0){
		alert("请重新登录并选择关联展厅！");
		window.open("index.html","_top");
	}
}
</script><%}%>


</head>
<body leftmargin="0" topmargin="0" class="windowbackground">
	<table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%">
		<tr>
			<td valign="bottom" class="mytop">
				<%@include file="/MainTop.jsp"%>
			</td>
		</tr> 
	<!--	<tr>
  			<td valign="top" id="mymiddleShadow" class="mymiddleShadow"></td>
		</tr>-->
   	<tr>
			<td valign="top">
			<!-- 工作台内容 -->
				<div  valign=middle class="groupboxmaxcontent" style="padding:0;border:0px solid #F00;position:absolute; height:100%;width: 100%; overflow:hidden" id="window1">
 				</div>
			</td>
		</tr>
	</table>
</body>
</html>
<script type="text/javascript">
	//生成工作台Tab页
	var tabCompent = null;
	$(document).ready(function(){
		tabCompent = new TabStrip("T001","工作台","tab","#window1");
		tabCompent.setSelectedItem("0");
		tabCompent.setIsCache(true);	 						//是否缓存
//		tabCompent.setIsAddButton(true);	 			//设置新增按钮
		tabCompent.setAddCallback("addNewTabListen(this)");
		tabCompent.setCloseCallback("deleteTabListen(this)");
		//tabCompent.setCanClose(false);
  	<%
		String sSql = "",sSqlTab = "";
		int iCount = 0;
		ASResultSet rs1 = null;
		
		sSqlTab = 	" select ItemNo,ItemName,ItemAttribute from CODE_LIBRARY CL"+
					" where CodeNo = 'TabStrip'  and IsInUse = '1' "+
					" order by SortNo";
  		String sTabStrip[][] = HTMLTab.getTabArrayWithSql(sSqlTab,Sqlca);
		for(int i=0;i<sTabStrip.length;i++){
			if(sTabStrip[i][0] != null&&sTabStrip[i][1] != null&&sTabStrip[i][2] != null){
				out.println("tabCompent.addDataItem('"+i+"',\""+sTabStrip[i][1]+"\",\""+sTabStrip[i][2]+"\",true,false);");
			}
		}
		//用户自定义工作台
		String custTab = com.amarsoft.app.util.WorkTipTabsManage.genTabScript(CurUser.getUserID(),Sqlca);
		out.println(custTab);
	%>
		tabCompent.init();
	});

/************************************************************************
 * 
 * 以下函数为工作台TAB增加或关闭时，回调监听函数，以同步更新数据库表数据
 *
 ***********************************************************************/
	/**
	 *回调函数：添加一个新Tab选项
	 */
	function addNewTabListen(obj){
		if($(obj).data("_treeview") != "1"){
			//1.处理菜单DOM数据
			var menuHTML = $("#MenuHeaderUl").parent("td").html();
			menuHTML = menuHTML.replace("id=MenuHeaderUl","id=menuTree");					//换掉原来的ID
			menuHTML = menuHTML.replace("class=MenuHeaderUl","class=treeview");		//换掉原来的CSS
			//2.生成树图容器
			var offset = $(obj).offset();
			x = offset.left;			//取”新增“按钮的x坐标
			y = offset.top;				//取”新增“按钮的y坐标
			var treeContainer = $('<div id="newTabMenu"></div>');
			treeContainer.css("top",y+10);					//10px为tab选项卡空白的高度，菜单出现在选项卡以下
			treeContainer.css("left",x);
			treeContainer.addClass("treeview-container");
			//3.添加至容器
			treeContainer.append(menuHTML);																				//添加数据至容器
			$("#window1").before(treeContainer);																	//添加树图容器至窗口
			//4.生成树图
			$("#menuTree").treeview({
				persist: "location",
				collapsed: true,
				unique: false
			});
			//5.记录下加载状态，再次点击时，不再重新生成
			$(obj).data("_treeview","1");
			//6.绑定事件
			//6.1 鼠标移出后，菜单消失
			$(obj).mouseout(function(){
				$("#newTabMenu").css("display","none");
			});
			//6.2 鼠标移入菜单容器内
			$("#newTabMenu").hover(function(){
					$("#newTabMenu").css("display","block");
				},function(){
					$("#newTabMenu").css("display","none");
				});
			//6.3.绑定树图单击事件
			$("#menuTree").children("li").each(function(i){
					workTipTreeBindClick($(this));
			});
		//........................
		}else{
			//增加或关闭Tab后，新增按钮的位置发生了变化，需要重新计算
			var offset = $(obj).offset();
			x = offset.left;													//取”新增“按钮的x坐标
			y = offset.top;														//取”新增“按钮的y坐标
			$("#newTabMenu").css("top",y+10);
			$("#newTabMenu").css("left",x);
			$("#newTabMenu").css("display","block");
		}
	}
	/**
   *页面TAB关闭回调函数
   */
	function deleteTabListen(obj){
		id = $(obj).attr("id").replace(/^handle_/,"");
		var curUserID = "<%=CurUser.getUserID()%>";
		var param = "Operate=del";
				param += "&UserID="+curUserID;
				param += "&TabID="+id;
		var b = PopPageAjax("/Common/ToolsB/WorkTipTabsManage.jsp?"+param);
	}

/***********************************************************************************
 * 
 *给树图的节点绑定单击事件，不一次全部绑定，采用点击时，才绑定其子节点的单击事件
 *
 **********************************************************************************/
	function workTipTreeBindClick(obj){
		obj.click(function(e){
			liNode = $(this);
			bChild = (liNode.find('ul:first').html() != null);	//取出是否有子菜单
			if(bChild){														//如果有子节点，则绑定其子节点单击事件
				$(this).unbind("click");						//如果节点有子节点，则当前节点单击不生效
				ulNode = liNode.find('ul:first');
				//为子节点绑定单击事件
				ulNode.children("li").each(function(){
					workTipTreeBindClick($(this));
				});
			}else{				//否则执行添加动作
				id = liNode.attr("id");
				action = liNode.attr("_action");
				text = liNode.text();
				encodeScript = action.replace(/&/gi,'`');
				if(tabCompent.getItemNumber() < 8 ){
					var curUserID = "<%=CurUser.getUserID()%>";
					var param = "Operate=add";
							param += "&UserID="+curUserID;
							param += "&TabID="+id;
							param += "&TabName="+text;
							param += "&Script="+encodeScript;
							param += "&Cache=true";
							param += "&Close=true";
					var b = PopPageAjax("/Common/ToolsB/WorkTipTabsManage.jsp?"+param);
					if(b == "true"){
						tabCompent.addItem(id,text,action,true,true,true);
					}
					//记录至服务器
				}else{
						alert("工作台选项卡数量不能超过8个");
				}
		    if (e && e.stopPropagation){
		        e.stopPropagation();
		    }else{
		        window.event.cancelBubble=true;
		    }
				$("#newTabMenu").css("display","none");
			}
			return false;
		});
	}
</script>
<%@ include file="/IncludeEnd.jsp"%>
