<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		页面说明: 节点信息列表页面
		author: yzheng
		date: 2013/05/22
	 */
	String PG_TITLE = "节点信息列表页面";
	//获得页面参数

	//通过DW模型产生ASDataObject对象doTemp
	String sTempletNo = "PRDNodeManageList";//模型编号
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);

	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	dwTemp.setPageSize(25);

	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{"true","","Button","新增","新增一条记录","newRecord()",sResourcesPath},
		{"true","","Button","详情","查看/修改详情","viewAndEdit()",sResourcesPath},
		{"true","","Button","删除","删除所选中的记录","deleteRecord()",sResourcesPath}
	};
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
	function newRecord(){
		AsControl.OpenView("/SystemManage/SynthesisManage/PRDNodeManageInfo.jsp","","_self","");
	}
	
	function deleteRecord(){
		var sNodeID = getItemValue(0,getRow(),"NodeID");
		var result = "";
		var sPara = "NodeIDArr=" + sNodeID;
		
		result =  RunJavaMethodSqlca("com.amarsoft.app.als.product.CVNodeDBManipulateController","check4Delete",sPara);
		
		if(result != "NOT EXISTS"){
			var prdName = result.split("@").join("|");
			var msg = "无法删除. 产品 (" + prdName.substring(0,prdName.length-1) + ") 关联到该节点.";
			alert(msg);
			
			return;
		}
		
		if (typeof(sNodeID)=="undefined" || sNodeID.length==0){
			alert("请选择一条记录！");
			return;
		}
		
		if(confirm("您真的想删除该信息吗？")){
			as_del("myiframe0");
			as_save("myiframe0");  //如果单个删除，则要调用此语句
		}
	}

	function viewAndEdit(){
		var sNodeID=getItemValue(0,getRow(),"NodeID");
		if (typeof(sNodeID)=="undefined" || sNodeID.length==0){
			alert("请选择一条记录！");
			return;
		}
		AsControl.OpenView("/SystemManage/SynthesisManage/PRDNodeManageInfo.jsp","NodeID="+sNodeID,"_self","");
	}

	$(document).ready(function(){
		AsOne.AsInit();
		init();
		my_load(2,0,'myiframe0');
	});
</script>	
<%@ include file="/IncludeEnd.jsp"%>
