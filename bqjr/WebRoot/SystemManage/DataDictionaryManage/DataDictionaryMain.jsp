<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		页面说明:数据字典管理树图
		author: yzheng
		date: 2013-6-6
	 */
	String PG_TITLE = "数据字典管理主页面"; // 浏览器窗口标题 <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;数据字典管理&nbsp;&nbsp;"; //默认的内容区标题
	String PG_CONTNET_TEXT = "请点击左侧列表";//默认的内容区文字
	String PG_LEFT_WIDTH = "200";//默认的treeview宽度

	//获得页面参数
// 	String sExampleID = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));

	//定义变量
	String templateURL = "/SystemManage/DataDictionaryManage/DataDictionaryTemplateList.jsp";
	String codeURL = "/SystemManage/DataDictionaryManage/DataDictionaryCodeFrame.jsp";
	String tableURL = "/SystemManage/DataDictionaryManage/DataDictionaryTableFrame.jsp";
	String tableColURL = "/SystemManage/DataDictionaryManage/DataDictionaryTableColList.jsp";
	
	//定义Treeview
	HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,"数据字典管理树图","right");
	tviTemp.ImageDirectory = sResourcesPath; //设置资源文件目录（图片、CSS）
	tviTemp.toRegister = false; //设置是否需要将所有的节点注册为功能点及权限点
	tviTemp.TriggerClickEvent=true; //是否自动触发选中事件

	//定义树图结构
	String sFolder1=tviTemp.insertFolder("root","数据字典检索","",1);
	String DW_Template = tviTemp.insertPage(sFolder1,"模板", templateURL,"",2);
	String code = tviTemp.insertPage(sFolder1,"代码",codeURL,"",3);
	String DB_Table = tviTemp.insertPage(sFolder1,"表",tableURL,"",4);
	String DB_TableCol = tviTemp.insertPage(sFolder1,"字段",tableColURL,"",5);
%><%@include file="/Resources/CodeParts/Main04.jsp"%>
<script type="text/javascript"> 
	function openChildComp(sURL,sParameterString){
		sParaStringTmp = "";
		sLastChar=sParameterString.substring(sParameterString.length-1);
		if(sLastChar=="&") sParaStringTmp=sParameterString;
		else sParaStringTmp=sParameterString+"&";

		/*
		 * 附加两个参数
		 * ToInheritObj:是否将对象的权限状态相关变量复制至子组件
		 * OpenerFunctionName:用于自动注册组件关联（REG_FUNCTION_DEF.TargetComp）
		 */
		sParaStringTmp += "ToInheritObj=y&OpenerFunctionName="+getCurTVItem().name;
		AsControl.OpenView(sURL,sParaStringTmp,"right");
	}
	
	//treeview单击选中事件
	function TreeViewOnClick(){
		var sCurItemID = getCurTVItem().id;
		var sCurItemname = getCurTVItem().name;
		var nodeURL = getCurTVItem().value;

		//alert(sCurItemID);
		if(sCurItemID != "1"){  //排除根节点
			openChildComp(nodeURL, "");
		}
		setTitle(sCurItemname);
	}
	
	function initTreeView(){
		<%=tviTemp.generateHTMLTreeView()%>
		expandNode('root');
		expandNode('1');  //展开根节点
		selectItem('2');  //预选中模板节点
	}
		
	initTreeView();
</script>
<%@ include file="/IncludeEnd.jsp"%>