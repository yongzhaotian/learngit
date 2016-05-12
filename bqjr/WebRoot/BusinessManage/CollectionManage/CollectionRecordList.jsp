<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		页面说明: 示例列表页面
	 */
	String PG_TITLE = "示例列表页面";
	//获得页面参数
	//String sInputUser =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("InputUser"));
	//if(sInputUser==null) sInputUser="";
	
	//通过DW模型产生ASDataObject对象doTemp
	String sTempletNo = "CollectionList";//模型编号
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
		{"true","","Button","合同查看","查看合同信息","newRecord()",sResourcesPath},
		{"true","","Button","催收录入","催收录入","newRecord()",sResourcesPath},
		{"true","","Button","查看历史","查看历史","newRecord()",sResourcesPath},
		//{"false","","Button","新增","新增一条记录","newRecord()",sResourcesPath},
		//{"false","","Button","使用ObjectViewer打开","使用ObjectViewer打开","openWithObjectViewer()",sResourcesPath},
		//{"true","","Button","催收录入","录入催收历史","newRecord()",sResourcesPath},
		//{"true","","Button","查看历史","查看催收历史","viewAndEdit()",sResourcesPath},
		//{"true","","Button","逾期合同列表","逾期合同列表","viewOverdueContract()",sResourcesPath},
		//{"false","","Button","催收历史查询","催收历史查询","newRecord()",sResourcesPath},
		//{"false","","Button","申请代扣","申请代扣","viewAndEdit()",sResourcesPath},
		//{"false","","Button","费用减免","费用减免","deleteRecord()",sResourcesPath},
		//{"true","","Button","案件转移","案件转移","",sResourcesPath},
		//{"true","","Button","逾期记录统计查询","逾期记录统计查询","",sResourcesPath},
		//{"true","","Button","短信发送","短信发送","",sResourcesPath},
		//{"true","","Button","电邮发送","电邮发送","",sResourcesPath},
		//{"true","","Button","删除","删除所选中的记录","deleteRecord()",sResourcesPath},
	};
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
	function newRecord(){
		AsControl.OpenView("/BusinessManage/CollectionManage/CollectionRecodeInfo.jsp","","_self","");
	}
	
	function deleteRecord(){
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert("请选择一条记录！");
			return;
		}
		
		if(confirm("您真的想删除该信息吗？")){
			as_del("myiframe0");
			as_save("myiframe0");  //如果单个删除，则要调用此语句
		}
	}
	
	/*~[Describe=逾期客户合同查询;InputParam=无;OutPutParam=无;]~*/
	function viewOverdueContract(){
		OpenPage("/BusinessManage/CollectionManage/OverdueContractList.jsp","_self","");
	}

	function viewAndEdit(){
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		//alert("======"+sSerialNo);
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert("请选择一条记录！");
			return;
		}
		AsControl.OpenView("/BusinessManage/CollectionManage/CollectionRecodeInfo.jsp","SerialNo="+sSerialNo+"&flag=Y","_self","");
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
		showFilterArea();
		AsOne.AsInit();
		init();
		my_load(2,0,'myiframe0');
	});
</script>	
<%@ include file="/IncludeEnd.jsp"%>