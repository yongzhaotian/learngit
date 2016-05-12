<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%
	String PG_TITLE = "车辆登记证归档 "; // 浏览器窗口标题 <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;车辆登记证归档 &nbsp;&nbsp;"; //默认的内容区标题
	String PG_CONTNET_TEXT = "请点击左侧列表";//默认的内容区文字
	String PG_LEFT_WIDTH = "200";//默认的treeview宽度


	//定义Treeview
	HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,"车辆登记证归档 ","right");
	tviTemp.ImageDirectory = sResourcesPath; //设置资源文件目录（图片、CSS）
	tviTemp.toRegister = false; //设置是否需要将所有的节点注册为功能点及权限点
	tviTemp.TriggerClickEvent=true; //是否自动触发选中事件

	tviTemp.insertPage("root", "待归档箱子", "", 1);
	tviTemp.insertPage("root", "已归档箱子", "", 2);
	tviTemp.insertPage("root", "未归档的车辆登记证", "", 3);
	tviTemp.insertPage("root", "已归档的车辆登记证", "", 4);
	tviTemp.insertPage("root", "申请借出的车辆登记证", "", 5);
	tviTemp.insertPage("root", "已借出的车辆登记证", "", 6);
	tviTemp.insertPage("root", "待出库的车辆登记证", "", 7);
	tviTemp.insertPage("root", "已出库的车辆登记证", "", 8);
	%>

<%/*~BEGIN~不可编辑区[Editable=false;CodeAreaID=View04;Describe=主体页面]~*/%>
	<%@include file="/Resources/CodeParts/Main04.jsp"%>
<%/*~END~*/%>


<script type="text/javascript"> 
	
	/*~[Describe=treeview单击选中事件;InputParam=无;OutPutParam=无;]~*/
	function TreeViewOnClick(){
		var sCurItemID = getCurTVItem().id;
		if(sCurItemID=="1"){	
			AsControl.OpenView("/AppConfig/Document/BoxList.jsp","temp=1","right");
		}else if(sCurItemID=="2"){
			AsControl.OpenView("/AppConfig/Document/BoxList.jsp","temp=2","right");
		}else if(sCurItemID=="3"){
			AsControl.OpenView("/AppConfig/Document/BoxNOCarList.jsp","curItemID="+sCurItemID,"right");
		}else if(sCurItemID=="4"){
			AsControl.OpenView("/AppConfig/Document/BoxNOCarList.jsp","curItemID="+sCurItemID,"right");
		}else if(sCurItemID=="5"){
			AsControl.OpenView("/AppConfig/Document/BoxNOCarList.jsp","curItemID="+sCurItemID,"right");
		}else if(sCurItemID=="6"){
			AsControl.OpenView("/AppConfig/Document/BoxNOCarList.jsp","curItemID="+sCurItemID,"right");
		}else if(sCurItemID=="7"){
			AsControl.OpenView("/AppConfig/Document/BoxNOCarList.jsp","curItemID="+sCurItemID,"right");
		}else {
			AsControl.OpenView("/AppConfig/Document/BoxNOCarList.jsp","curItemID="+sCurItemID,"right");
		}
	}
	
	/*~[Describe=生成treeview;InputParam=无;OutPutParam=无;]~*/
	function startMenu(){
		<%=tviTemp.generateHTMLTreeView()%>
	}
		
</script> 

<script type="text/javascript">    
	startMenu();
	expandNode('root');
	selectItem('1');
</script>
<%/*~END~*/%>


<%@ include file="/IncludeEnd.jsp"%>
