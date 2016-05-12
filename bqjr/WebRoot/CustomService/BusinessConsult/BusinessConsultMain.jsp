<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		页面说明:示例模块主页面
	 */
	String PG_TITLE = "客服信息查询"; // 浏览器窗口标题 <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;客服信息查询&nbsp;&nbsp;"; //默认的内容区标题
	String PG_CONTNET_TEXT = "请点击左侧列表";//默认的内容区文字
	String PG_LEFT_WIDTH = "1";	//"200";//默认的treeview宽度 modified by tbzeng 2014/07/30

	//获得页面参数

	//定义Treeview
	HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,"示例模块主页面","right");
	tviTemp.ImageDirectory = sResourcesPath; //设置资源文件目录（图片、CSS）
	tviTemp.toRegister = false; //设置是否需要将所有的节点注册为功能点及权限点
	tviTemp.TriggerClickEvent=true; //是否选中时自动触发TreeViewOnClick()函数

	//定义树图结构
	//String sFolder1=tviTemp.insertFolder("root","示例信息","",1);
	//tviTemp.insertPage(sFolder1,"所有的示例信息","",1);
	//tviTemp.insertPage(sFolder1,"我的示例信息","",2);
	//tviTemp.insertPage(sFolder1,"他的示例信息","",3);
	tviTemp.insertPage("root","贷款咨询","",1);
	tviTemp.insertPage("root","门店咨询","",2);
	
	tviTemp.insertPage("root","退货审批","",3);
	tviTemp.insertPage("root","保险取消审批","",4);
	tviTemp.insertPage("root","保险金审批","",5);
	tviTemp.insertPage("root","提前还款审批","",6);
	tviTemp.insertPage("root","退款审批","",7);
	tviTemp.insertPage("root","代扣账号变更审批","",8);
	tviTemp.insertPage("root","进账文件查询","",9);
	tviTemp.insertPage("root","贷款结清证明审批","",10);
	tviTemp.insertPage("root","商户咨询","",11);
	tviTemp.insertPage("root","销售咨询","",12);
	
	
	//另外两种定义树图结构的方法：SQL生成和代码生成   参见View的生成 ExampleView.jsp和ExampleView01.jsp
%><%@include file="/Resources/CodeParts/Main04.jsp"%>
<script type="text/javascript"> 
	var defExpandId = '贷款咨询';
	function TreeViewOnClick(){
		//如果tviTemp.TriggerClickEvent=true，则在单击时，触发本函数
		//var sCurItemID = getCurTVItem().id;
		var sCurItemname = getCurTVItem().name;
		if(sCurItemname=='贷款咨询'){
			AsControl.OpenView("/CustomService/BusinessConsult/LoanConsultList.jsp","","right");
		}else if(sCurItemname=='门店咨询'){
			AsControl.OpenView("/CustomService/BusinessConsult/StoreConsultList.jsp","","right");
		}else if(sCurItemname=='退货审批'){
			AsControl.OpenView("/CustomService/BusinessConsult/ReturnApplyList.jsp","ApplyType="+"Y001","right");
		}else if(sCurItemname=='保险取消审批'){
			AsControl.OpenView("/CustomService/BusinessConsult/ReturnApplyList.jsp","ApplyType="+"Y002","right");
		}else if(sCurItemname=='保险金审批'){
			AsControl.OpenView("/CustomService/BusinessConsult/ReturnApplyList.jsp","ApplyType="+"Y003","right");
		}else if(sCurItemname=='提前还款审批'){
			AsControl.OpenView("/CustomService/BusinessConsult/ReturnApplyList.jsp","ApplyType="+"Y004","right");
		}else if(sCurItemname=='退款审批'){
			AsControl.OpenView("/CustomService/BusinessConsult/ReturnApplyList.jsp","ApplyType="+"Y005","right");
		}else if(sCurItemname=='代扣账号变更审批'){
			AsControl.OpenView("/CustomService/BusinessConsult/ReturnApplyList.jsp","ApplyType="+"Y006","right");
		}else if (sCurItemname=='进账文件查询') {
			AsControl.OpenView("/CustomService/BusinessConsult/ReturnApplyList.jsp", "ApplyType="+"Y007", "right");
		}else if (sCurItemname=='贷款结清证明审批') {
			AsControl.OpenView("/CustomService/BusinessConsult/CreditSettleApproveList.jsp", "", "right");
		}else if (sCurItemname=='商户咨询') {
			AsControl.OpenView("/CustomService/BusinessConsult/StoreConsultList.jsp", "temp=001", "right");
		}else if (sCurItemname=='销售咨询') {
			AsControl.OpenView("/CustomService/BusinessConsult/StoreConsultList.jsp", "temp=002", "right");
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
		selectItemByName("贷款咨询");	//默认打开的(叶子)选项	
	}
	
	initTreeView();
</script>
<%@ include file="/IncludeEnd.jsp"%>
