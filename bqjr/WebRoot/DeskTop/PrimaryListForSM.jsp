<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%
	//add by ybpan at 20150210
	/*
		--页面说明: 示例列表页面--
	 */
	String PG_TITLE = "错误非关键错误列表";
	//获得页面参数
	String sInputUser =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("UserID"));
	if(sInputUser==null) sInputUser="";

	String sCurUser = CurUser.getUserID();
	ARE.getLog().debug("========当前用户："+sCurUser);
	
	//通过DW模型产生ASDataObject对象doTemp
	String sTempletNo = "IsPrimaryErrorList";//模型编号
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	//用服务器当前时间
	String curDateTime = DateX.format(new java.util.Date(),"yyyy/MM/dd HH:mm:ss");

	doTemp.WhereClause = " WHERE (qg.QUALITYGRADE = '1' or (qg.QUALITYGRADE = '2' AND ceil((to_date('"+curDateTime+"','yyyy-mm-dd hh24-mi-ss') - To_date(inputtime, 'yyyy-mm-dd hh24-mi-ss'))) < 4)) AND ceil((to_date('"+curDateTime+"','yyyy-mm-dd hh24-mi-ss') - To_date(inputtime, 'yyyy-mm-dd hh24-mi-ss'))) > 1 AND bc.SERIALNO=qg.ARTIFICIALNO AND bc.salesmanager='"+sCurUser+"' ";                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      

	
	
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	dwTemp.setPageSize(10);

	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sCurUser);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
			//0、是否展示 1、	权限控制  2、 展示类型 3、按钮显示名称 4、按钮解释文字 5、按钮触发事件代码	6、快捷键	7、	8、	9、图标，CSS层叠样式 10、风格
			/* {"true","All","Button","新增","新增一条记录","newRecord()","","","","btn_icon_add",""},
			{"true","","Button","详情","查看/修改详情","viewAndEdit()","","","","btn_icon_detail",""},
			{"true","All","Button","删除","删除所选中的记录","deleteRecord()","","","","btn_icon_delete",""},
			{"true","","Button","使用ObjectViewer打开","使用ObjectViewer打开","openWithObjectViewer()","","","","",""}, */
		};
%>
<%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
	function newRecord(){
		AsControl.OpenView("/FrameCase/ExampleInfo.jsp","","_self","");
	}
	
	function deleteRecord(){
		var sExampleId = getItemValue(0,getRow(),"ExampleId");
		if (typeof(sExampleId)=="undefined" || sExampleId.length==0){
			alert("请选择一条记录！");
			return;
		}
		
		if(confirm("您真的想删除该信息吗？")){
			as_del("myiframe0");
			as_save("myiframe0");  //如果单个删除，则要调用此语句
		}
	}

	function viewAndEdit(){
		var sExampleId = getItemValue(0,getRow(),"ExampleId");
		if (typeof(sExampleId)=="undefined" || sExampleId.length==0){
			alert("请选择一条记录！");
			return;
		}
		AsControl.OpenView("/FrameCase/ExampleInfo.jsp","ExampleId="+sExampleId,"_self","");
	}
	
	<%/*~[Describe=使用ObjectViewer打开;InputParam=无;OutPutParam=无;]~*/%>
	function openWithObjectViewer(){
		var sExampleId = getItemValue(0,getRow(),"ExampleId");
		if (typeof(sExampleId)=="undefined" || sExampleId.length==0){
			alert("请选择一条记录！");
			return;
		}
		
		AsControl.OpenObject("Example",sExampleId,"001");//使用ObjectViewer以视图001打开Example，
	}

	$(document).ready(function(){
		AsOne.AsInit();
		init();
		my_load(2,0,'myiframe0');
	});
</script>	
<%@ include file="/IncludeEnd.jsp"%>
