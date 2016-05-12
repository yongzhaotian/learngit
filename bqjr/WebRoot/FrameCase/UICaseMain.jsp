<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		页面说明:UI组件导航主页面
	 */
	String PG_TITLE = "UI组件导航"; // 浏览器窗口标题 <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;UI组件导航&nbsp;&nbsp;"; //默认的内容区标题
	String PG_CONTNET_TEXT = "请点击左侧列表";//默认的内容区文字
	String PG_LEFT_WIDTH = "200";//默认的treeview宽度
	
	//定义Treeview
	HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,"UI组件导航","right");
	tviTemp.ImageDirectory = sResourcesPath; //设置资源文件目录（图片、CSS）
	tviTemp.toRegister = false; //设置是否需要将所有的节点注册为功能点及权限点
	tviTemp.TriggerClickEvent=true; //是否选中时自动触发TreeViewOnClick()函数

	//定义树图结构
	String sFolder10=tviTemp.insertFolder("root","基本组件","",1);
	String sFolder11=tviTemp.insertFolder(sFolder10,"DataWindow","",1);
	tviTemp.insertPage(sFolder11,"DW数据过滤器","",1);
	tviTemp.insertPage(sFolder11,"DW前置/后续事件(事务)","",2);
	tviTemp.insertPage(sFolder11,"DW数据校验","",3);
	tviTemp.insertPage(sFolder11,"DW单击事件","",4);
	tviTemp.insertPage(sFolder11,"DW自定义单元格事件","",5);
	String sFolder12=tviTemp.insertFolder(sFolder10,"Button","",2);
	tviTemp.insertPage(sFolder12,"数组定义按钮","",1);
	tviTemp.insertPage(sFolder12,"硬编码按钮","",2);
	String sFolder13=tviTemp.insertFolder(sFolder10,"TreeView","",3);
	tviTemp.insertPage(sFolder13,"SQL生成树图","",1);
	tviTemp.insertPage(sFolder13,"代码生成树图","",2);
	tviTemp.insertPage(sFolder13,"手工生成树图","",3);
	tviTemp.insertPage(sFolder13,"多选树图","",4);
	String sFolder15=tviTemp.insertFolder(sFolder10,"Selector","",5);
	tviTemp.insertPage(sFolder15,"树图/列表弹出选择框","",1);
	tviTemp.insertPage(sFolder15,"日历选择","",3);
	
	String sFolder1=tviTemp.insertFolder("root","基本视图","",2);
	String sFolder2=tviTemp.insertFolder(sFolder1,"List视图","",1);
	tviTemp.insertPage(sFolder2,"典型List","",1);
	tviTemp.insertPage(sFolder2,"多选List","",2);
	tviTemp.insertPage(sFolder2,"汇总List","",3);
	String sFolder3=tviTemp.insertFolder(sFolder1,"Info视图","",2);
	tviTemp.insertPage(sFolder3,"典型Info","",1);
	tviTemp.insertPage(sFolder3,"信息分组","",2);
	tviTemp.insertPage(sFolder3,"Info校验","",3);
	tviTemp.insertPage(sFolder3,"js脚本","",4);
	String sFolder7=tviTemp.insertFolder(sFolder1,"Main视图","",4);
	tviTemp.insertPage(sFolder7,"一般Main","",1);
	tviTemp.insertPage(sFolder7,"隐藏左侧区域的Main","",2);
	
	String sFolder4=tviTemp.insertFolder("root","视图面板","",3);
	tviTemp.insertPage(sFolder4,"上下区域","",1);
	tviTemp.insertPage(sFolder4,"左右区域","",2);
	tviTemp.insertPage(sFolder4,"上下联动","",3);
	tviTemp.insertPage(sFolder4,"左右联动","",4);
	tviTemp.insertPage(sFolder4,"Tab","",5);
	tviTemp.insertPage(sFolder4,"Strip","",6);
	
	String sFolder5 = tviTemp.insertFolder("root","对象窗口(ObjectWindow)","",4);
	String sFolder51=tviTemp.insertFolder(sFolder5,"List演示","",1);
	tviTemp.insertPage(sFolder51,"简单列表[不锁定表头和列]","",1);
	tviTemp.insertPage(sFolder51,"多选列表","",2);
	tviTemp.insertPage(sFolder51,"编辑列表","",3);
	tviTemp.insertPage(sFolder51,"数据导出","",4);
	tviTemp.insertPage(sFolder51,"根据jbo生成数据","",5);
	tviTemp.insertPage(sFolder51,"视图结合jbo生成数据","",6);
	tviTemp.insertPage(sFolder51,"列表汇总 小计、合计","",7);
	tviTemp.insertPage(sFolder51,"自定义列表样式","",8);
	tviTemp.insertPage(sFolder51,"自定义HTML事件","",9);
	tviTemp.insertPage(sFolder51,"根据数组生成数据","",10);
	tviTemp.insertPage(sFolder51,"自定义数据来源","",11);
	tviTemp.insertPage(sFolder51,"自定义联动菜单","",12);
	tviTemp.insertPage(sFolder51,"每行放自定义按钮","",13);
	tviTemp.insertPage(sFolder51,"列表自定义过滤条件","",14);
	String sFolder52=tviTemp.insertFolder(sFolder5,"Info演示","",2);
	tviTemp.insertPage(sFolder52,"简单Info","",1);
	tviTemp.insertPage(sFolder52,"自定义HTML事件(Info)","",2);
	tviTemp.insertPage(sFolder52,"界面分组","",3);
	tviTemp.insertPage(sFolder52,"日期控件区间自定义","",4);
	tviTemp.insertPage(sFolder52,"特殊js脚本","",5);
	tviTemp.insertPage(sFolder52,"前后统一自定义校验","",6);
	tviTemp.insertPage(sFolder52,"自定义联动菜单(Info)","",7);
	tviTemp.insertPage(sFolder52,"复合页面","",8);
	tviTemp.insertPage(sFolder52,"五星控件","",9);
	
	String sFolder6 = tviTemp.insertFolder("root","SWF图形","",5);
	tviTemp.insertPage(sFolder6,"bar","",1);
	tviTemp.insertPage(sFolder6,"bar_stack","",2);
	tviTemp.insertPage(sFolder6,"hbar","",3);
	tviTemp.insertPage(sFolder6,"line","",4);
	tviTemp.insertPage(sFolder6,"area_hollow","",5);
	tviTemp.insertPage(sFolder6,"pie","",6);
	tviTemp.insertPage(sFolder6,"Chart其他写法","",7);
	tviTemp.insertPage(sFolder6,"仪表盘","",8);
	tviTemp.insertPage(sFolder6,"DragNode","",9);
%><%@include file="/Resources/CodeParts/Main04.jsp"%>
<script type="text/javascript"> 
	<%/*treeview单击选中事件;如果tviTemp.TriggerClickEvent=true，则在单击时，触发本函数*/%>
	function TreeViewOnClick(){
		var sCurItemname = getCurTVItem().name;
		if(sCurItemname=='DW数据过滤器'){
			AsControl.OpenView("/FrameCase/ExampleList08.jsp","","right","");
		}else if(sCurItemname=='DW数据校验'){
			AsControl.OpenView("/FrameCase/ExampleInfo03.jsp","ExampleId=2013012300000001","right","");
		}else if(sCurItemname=='DW前置/后续事件(事务)'){
			AsControl.OpenView("/FrameCase/ExampleInfo04.jsp","ExampleId=2013012300000001","right","");
		}else if(sCurItemname=='DW单击事件'){
			AsControl.OpenView("/FrameCase/ExampleList04.jsp","","right","");
		}else if(sCurItemname=='DW自定义单元格事件'){
			AsControl.OpenView("/FrameCase/ExampleInfo05.jsp","ExampleId=2013012300000001","right","");
		}else if(sCurItemname=='数组定义按钮'){
			AsControl.OpenView("/FrameCase/ExampleButtonArray.jsp","","right","");
		}else if(sCurItemname=='硬编码按钮'){
			AsControl.OpenView("/FrameCase/ExampleButtonHardCoding.jsp","","right","");
		}else if(sCurItemname=='SQL生成树图'){
			AsControl.PopView("/FrameCase/ExampleView.jsp","ViewId=001","","");
		}else if(sCurItemname=='代码生成树图'){
			AsControl.PopView("/FrameCase/ExampleView01.jsp","ViewId=001","","");
		}else if(sCurItemname=='手工生成树图'){
			AsControl.PopView("/FrameCase/ExampleView02.jsp","ViewId=001","","");
		}else if(sCurItemname=='多选树图'){
			AsControl.OpenView("/FrameCase/ExampleView04.jsp", "", "right", "");
		}else if(sCurItemname=='树图/列表弹出选择框'){
			AsControl.OpenView("/FrameCase/ExampleSelect.jsp","","right","");
		}else if(sCurItemname=='日历选择'){
			AsControl.OpenView("/FrameCase/ExampleCalendar.jsp","","right");
		}else if(sCurItemname=='典型List'){
			AsControl.OpenView("/FrameCase/ExampleList.jsp","","right","");
		}else if(sCurItemname=='多选List'){
			AsControl.OpenView("/FrameCase/ExampleList02.jsp","","right","");
		}else if(sCurItemname=='汇总List'){
			AsControl.OpenView("/FrameCase/ExampleList03.jsp","","right","");
		}else if(sCurItemname=='典型Info'){
			AsControl.OpenView("/FrameCase/ExampleInfo.jsp","ExampleId=2013012300000001","right","");
		}else if(sCurItemname=='信息分组'){
			AsControl.OpenView("/FrameCase/ExampleInfo01.jsp","ExampleId=2013012300000001","right","");
		}else if(sCurItemname=='Info校验'){
			AsControl.OpenView("/FrameCase/ExampleInfoWithValid.jsp","","right","");
		}else if(sCurItemname=='js脚本'){
			AsControl.OpenView("/FrameCase/ExampleSpecJS.jsp","","right","");
		}else if(sCurItemname=='一般Main'){
			AsControl.OpenView("/FrameCase/ExampleMain01.jsp","ComponentName=一般Main&ComponentType=MainWindow","_self","");
		}else if(sCurItemname=='隐藏左侧区域的Main'){
			AsControl.OpenView("/FrameCase/ExampleMain02.jsp","ComponentName=隐藏左侧区域的Main&ComponentType=MainWindow","_self","");
		}else if(sCurItemname=='上下区域'){
			AsControl.OpenView("/FrameCase/ExampleFrame01.jsp","","right","");
		}else if(sCurItemname=='左右区域'){
			AsControl.OpenView("/FrameCase/ExampleFrame02.jsp","","right","");
		}else if(sCurItemname=='上下联动'){
			AsControl.OpenView("/FrameCase/ExampleFrame.jsp","","right","");
		}else if(sCurItemname=='左右联动'){
			AsControl.OpenView("/FrameCase/ExampleFrame03.jsp","","right","");
		}else if(sCurItemname=='Tab'){
			AsControl.OpenView("/FrameCase/ExampleTab.jsp","","right","");
		}else if(sCurItemname=='Strip'){
			AsControl.OpenView("/FrameCase/ExampleStrip.jsp","","right","");
		}
		else if(sCurItemname=='简单列表[不锁定表头和列]'){
			AsControl.OpenView("/FrameCase/widget/dw/DemoListSimple.jsp","","right");
		}
		else if(sCurItemname=='多选列表'){
			AsControl.OpenView("/FrameCase/widget/dw/DemoListMulty.jsp","","right");
		}
		else if(sCurItemname=='编辑列表'){
			AsControl.OpenView("/FrameCase/widget/dw/DemoListEdit.jsp","","right");
		}
		else if(sCurItemname=='数据导出'){
			AsControl.OpenView("/FrameCase/widget/dw/DemoListExport.jsp","","right");
		}
		else if(sCurItemname=='根据jbo生成数据'){
			AsControl.OpenView("/FrameCase/widget/dw/DemoListSimpleJBO.jsp","","right");
		}
		else if(sCurItemname=='视图结合jbo生成数据'){
			AsControl.OpenView("/FrameCase/widget/dw/DemoListSimpleJBO3.jsp","","right");
		}
		else if(sCurItemname=='列表汇总 小计、合计'){
			AsControl.OpenView("/FrameCase/widget/dw/DemoListCount.jsp","","right");
		}
		else if(sCurItemname=='自定义列表样式'){
			AsControl.OpenView("/FrameCase/widget/dw/DemoListRegular.jsp","","right");
		}
		else if(sCurItemname=='自定义HTML事件'){
			AsControl.OpenView("/FrameCase/widget/dw/DemoListEvent2.jsp","","right");
		}
		else if(sCurItemname=='根据数组生成数据'){
			AsControl.OpenView("/FrameCase/widget/dw/DemoListSimpleArray.jsp","","right");
		}
		else if(sCurItemname=='自定义数据来源'){
			AsControl.OpenView("/FrameCase/widget/dw/DemoListCustomDataSource2.jsp","","right");
		}
		else if(sCurItemname=='自定义联动菜单'){
			AsControl.OpenView("/FrameCase/widget/dw/DemoListDMenu.jsp","","right");
		}
		else if(sCurItemname=='每行放自定义按钮'){
			AsControl.OpenView("/FrameCase/widget/dw/DemoListWithAction.jsp","","right");
		}
		else if(sCurItemname=='列表自定义过滤条件'){
			AsControl.OpenView("/FrameCase/widget/dw/DemoCustomListFilter.jsp","","right");
		}
		else if(sCurItemname=='简单Info'){
			AsControl.OpenView("/FrameCase/widget/dw/DemoInfoSimple.jsp","","right");
		}
		else if(sCurItemname=='自定义HTML事件(Info)'){
			AsControl.OpenView("/FrameCase/widget/dw/DemoInfoEvent2.jsp","","right");
		}
		else if(sCurItemname=='界面分组'){
			AsControl.OpenView("/FrameCase/widget/dw/DemoInfoGroup.jsp","","right");
		}
		else if(sCurItemname=='日期控件区间自定义'){
			AsControl.OpenView("/FrameCase/widget/dw/DemoInfoCalendarWidget.jsp","","right");
		}
		else if(sCurItemname=='特殊js脚本'){
			AsControl.OpenView("/FrameCase/widget/dw/DemoInfoSp.jsp","","right");
		}
		else if(sCurItemname=='前后统一自定义校验'){
			AsControl.OpenView("/FrameCase/widget/dw/DemoInfoCValid.jsp","","right");
		}
		else if(sCurItemname=='自定义联动菜单(Info)'){
			AsControl.OpenView("/FrameCase/widget/dw/DemoInfoDMenu.jsp","","right");
		}
		else if(sCurItemname=='复合页面'){
			AsControl.OpenView("/FrameCase/widget/dw/DemoMultiPage.jsp","","right");
		}
		else if(sCurItemname=='五星控件'){
			AsControl.OpenView("/FrameCase/widget/dw/FiveStarMark.jsp","","right");
		}
		else if(sCurItemname=='bar'){
			AsControl.OpenView("/FrameCase/Chart/ChartData.jsp","GraphType=bar","right");
		}
		else if(sCurItemname=='bar_stack'){
			AsControl.OpenView("/FrameCase/Chart/ChartData.jsp","GraphType=bar_stack","right");
		}
		else if(sCurItemname=='hbar'){
			AsControl.OpenView("/FrameCase/Chart/ChartData.jsp","GraphType=hbar","right");
		}
		else if(sCurItemname=='line'){
			AsControl.OpenView("/FrameCase/Chart/ChartData.jsp","GraphType=line","right");
		}
		else if(sCurItemname=='area_hollow'){
			AsControl.OpenView("/FrameCase/Chart/ChartData.jsp","GraphType=area_hollow","right");
		}
		else if(sCurItemname=='pie'){
			AsControl.OpenView("/FrameCase/Chart/ChartData.jsp","GraphType=pie","right");
		}
		else if(sCurItemname=='Chart其他写法'){
			AsControl.OpenView("/FrameCase/Chart/ChartDataFile.jsp","GraphType=bar","right");
		}
		else if(sCurItemname=='仪表盘'){
			AsControl.OpenView("/FrameCase/Chart/CharDial.jsp","GraphType=bar","right");
		}
		else if(sCurItemname=='DragNode'){
			AsControl.OpenView("/FrameCase/Chart/DragNodeData.jsp","","right");
		}
		else{
			return;
		}
		setTitle(getCurTVItem().name);
	}
	
	<%/*~[Describe=生成treeview;InputParam=无;OutPutParam=无;]~*/%>
	function initTreeVeiw(){
		<%=tviTemp.generateHTMLTreeView()%>
		expandNode('root');
		selectItemByName("Border");
		selectItemByName("典型List");
		selectItemByName("典型Info");	//默认打开的(叶子)选项
		myleft.width = 250;
	}

	initTreeVeiw();
</script>
<%@ include file="/IncludeEnd.jsp"%>