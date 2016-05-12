<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%>
 
 <%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main00;Describe=注释区;]~*/%>
<%
	/*
		Author:   phe  2015/03/17
		Tester:
		Content: 业务基本信息   CCS-213 PRM-26 质量标注 增加文件名称
	 */
	%>
<%/*~END~*/%>
 <%
	/*
		--页面说明: 示例列表页面--
	 */
	String PG_TITLE = "文件名称维护";
	//获得页面参数
	//String sInputUser =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("InputUser"));
	//if(sInputUser==null) sInputUser="";
	
	//通过DW模型产生ASDataObject对象doTemp
	String sTempletNo = "QualityFile";//模型编号
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	dwTemp.setPageSize(10);

	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{"true","","Button","新增","新增一条记录","newRecord()",sResourcesPath},
		{"true","","Button","详情","查看/修改详情","viewAndEdit()",sResourcesPath},
		{"true","","Button","删除","删除所选中的记录","deleteRecord()",sResourcesPath},
	};
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
	function newRecord(){
		AsControl.OpenView("/SystemManage/CustomerFinanceManage/QualityFileInfo.jsp","","_self","");
	}
	
	function deleteRecord(){
		var sCodeNo = getItemValue(0,getRow(),"CODENO");
		var sItemNo = getItemValue(0,getRow(),"ITEMNO");
		if (typeof(sCodeNo)=="undefined" || sCodeNo.length==0||typeof(sItemNo)=="undefined" || sItemNo.length==0){
			alert("请选择一条记录！");
			return;
		}
		
		if(confirm("您真的想删除该信息吗？")){
			as_del("myiframe0");
			as_save("myiframe0");  //如果单个删除，则要调用此语句
			reloadSelf();
		}
	}

	function viewAndEdit(){
		var sCodeNo = getItemValue(0,getRow(),"CODENO");
		var sItemNo = getItemValue(0,getRow(),"ITEMNO");
		if (typeof(sCodeNo)=="undefined" || sCodeNo.length==0||typeof(sItemNo)=="undefined" || sItemNo.length==0){
			alert("请选择一条记录！");
			return;
		}
		AsControl.OpenView("/SystemManage/CustomerFinanceManage/QualityFileInfo.jsp","CodeNo="+sCodeNo+"&ItemNo="+sItemNo,"_self","");
	}
	
	$(document).ready(function(){
		AsOne.AsInit();
		init();
		my_load(2,0,'myiframe0');
	});
</script>	
<%@ include file="/IncludeEnd.jsp"%>
