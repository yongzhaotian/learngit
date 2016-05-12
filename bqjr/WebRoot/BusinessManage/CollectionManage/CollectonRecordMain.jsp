<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		页面说明:电话催收主页面
	 */
	String PG_TITLE = "电话催收"; // 浏览器窗口标题 <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;催收管理&nbsp;&nbsp;"; //默认的内容区标题
	String PG_CONTNET_TEXT = "请点击左侧列表";//默认的内容区文字
	String PG_LEFT_WIDTH = "200";//默认的treeview宽度

	//获得登陆人的角色
	String roleID="";
	//M1、M2、M3、查找组等角色的菜单显示
	boolean roleM1=false;
	boolean roleM2=false;
	boolean roleM3=false;
	boolean roleMM=false;
	//M1,M2,M3按钮显示 
	String buttonM1="false";
	String buttonM2="false";
	String buttonM3="false";
	
	String userID=CurUser.getUserID();
    String sSql="select roleid from User_Role where userid=:userid order by roleid";
    String sSql1="select roleid from User_Role where userid=:userid order by roleid desc";
	ASResultSet rs=Sqlca.getASResultSet(new SqlObject(sSql).setParameter("userid", userID));
	while(rs.next()){
		roleID=rs.getString("roleid");
		//催收高级经理、电催高级主管
		if("1110".equals(roleID) || "1210".equals(roleID)){
			roleM1=true;
			roleM2=true;
			roleM3=true;
			roleMM=true;
			break;
		}
		
		//电催M1主管、电催M1组长、电催M1专员
		if("1310".equals(roleID) || "1410".equals(roleID) || "1510".equals(roleID)){
			roleM1=true;
		}
		//电催M2主管、电催M2组长、电催M2专员
		if("1311".equals(roleID) || "1411".equals(roleID) || "1511".equals(roleID)){
			roleM2=true;
		}
		//电催M3主管、电催M3组长、电催M3专员
		if("1312".equals(roleID) || "1412".equals(roleID) || "1512".equals(roleID)){
			roleM3=true;
		}
		//查找组主管、电催查找组组长、查找组专员
		if("1313".equals(roleID) || "1413".equals(roleID) || "1513".equals(roleID)){
			roleMM=true;
		}
	}
	rs.getStatement().close();
	
	//按钮显示
	ASResultSet rs1=Sqlca.getASResultSet(new SqlObject(sSql1).setParameter("userid", userID));
	while(rs1.next()){
		roleID=rs1.getString("roleid");
		if("1510".equals(roleID)){
			buttonM1="true";
		}
		if("1511".equals(roleID)){
			buttonM2="true";
		}
		if("1512".equals(roleID)){
			buttonM3="true";
		}
		if("1110".equals(roleID) || "1210".equals(roleID) || "1310".equals(roleID) || "1410".equals(roleID)){
			buttonM1="false";
		}
		if("1110".equals(roleID) || "1210".equals(roleID) || "1311".equals(roleID) || "1411".equals(roleID)){
			buttonM2="false";
		}
		if("1110".equals(roleID) || "1210".equals(roleID) || "1312".equals(roleID) || "1412".equals(roleID)){
			buttonM3="false";
		}
	}
	rs1.getStatement().close();
	
	//定义Treeview
	HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,"电话催收","right");
	tviTemp.ImageDirectory = sResourcesPath; //设置资源文件目录（图片、CSS）
	tviTemp.toRegister = false; //设置是否需要将所有的节点注册为功能点及权限点
	tviTemp.TriggerClickEvent=true; //是否选中时自动触发TreeViewOnClick()函数

	//定义树图结构
	String sFolder1=tviTemp.insertFolder("root","电话催收信息","",1);
	if(roleM1){
		tviTemp.insertPage("root","M1催收录入","",1);
	}
	if(roleM2){
		tviTemp.insertPage("root","M2催收录入","",2);
	}
	if(roleM3){
		tviTemp.insertPage("root","M3催收录入","",3);
	}
	if(roleMM){
		tviTemp.insertPage("root","查找组","",4);
	}
	

	
	//另外两种定义树图结构的方法：SQL生成和代码生成   参见View的生成 ExampleView.jsp和ExampleView01.jsp
%><%@include file="/Resources/CodeParts/Main04.jsp"%>
<script type="text/javascript"> 
	function TreeViewOnClick(){
		//如果tviTemp.TriggerClickEvent=true，则在单击时，触发本函数
		//var sCurItemID = getCurTVItem().id;
		var sCurItemname = getCurTVItem().name;

		if(sCurItemname=='M1催收录入'){
			AsControl.OpenView("/BusinessManage/CollectionManage/ConsumeCollectionTelList.jsp","PhaseType1=0011&&buttonM1=<%=buttonM1%>&&buttonM2=<%=buttonM2%>&&buttonM3=<%=buttonM3%>","right");
		}else if(sCurItemname=='M2催收录入'){
			AsControl.OpenView("/BusinessManage/CollectionManage/ConsumeCollectionTelList.jsp","PhaseType1=0012&&buttonM1=<%=buttonM1%>&&buttonM2=<%=buttonM2%>&&buttonM3=<%=buttonM3%>","right");
		}else if(sCurItemname=='M3催收录入'){
			AsControl.OpenView("/BusinessManage/CollectionManage/ConsumeCollectionTelList.jsp","PhaseType1=0013&&buttonM1=<%=buttonM1%>&&buttonM2=<%=buttonM2%>&&buttonM3=<%=buttonM3%>","right");
		}else if(sCurItemname=='查找组'){
			AsControl.OpenView("/BusinessManage/CollectionManage/ConsumeCollectionGroupList.jsp","PhaseType1=0060","right");
		}else{
			return;
		}
		setTitle(getCurTVItem().name);
	}
	
	<%/*~[Describe=生成treeview;]~*/%>
	function initTreeView(){
		<%=tviTemp.generateHTMLTreeView()%>
		expandNode('root');
		selectItem(1);
		selectItemByName("M1催收录入");	//默认打开的(叶子)选项	
	}
	
	initTreeView();
</script>
<%@ include file="/IncludeEnd.jsp"%>
