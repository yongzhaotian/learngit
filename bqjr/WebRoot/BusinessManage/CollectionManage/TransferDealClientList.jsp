<%@ page contentType="text/html; charset=GBK"%>
<%@
 include file="/IncludeBegin.jsp"%><%

	String PG_TITLE = "资产转让协议列表页面";
    String PG_CONTENT_TITLE = "&nbsp;&nbsp;资产转让筛选&nbsp;&nbsp;";
 %>
 <% 
	//通过DW模型产生ASDataObject对象doTemp
	ASDataObject doTemp = new ASDataObject("TrustCompaniesList",Sqlca);

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
		{"true","","Button","新增","新增出让方受让方信息","newRecord()",sResourcesPath},
		{"true","","Button","详情","查看出让方受让方详情","viewAndEdit()",sResourcesPath},
		{"true","","Button","删除","删除出让方受让方信息","deleteRecord()",sResourcesPath},
	};
	
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
	
	/*~~[新增资产转让协议]~~*/
	function newRecord(){
		AsControl.OpenView("/BusinessManage/CollectionManage/TransferDealClientInfo.jsp","","_self","");
	}
	
	function deleteRecord(){
		var sSerialNo = getItemValue(0,getRow(),"SERIALNO");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert("请选择一条记录！");
			return;
		}
		var sReturn = RunMethod("公用方法","GetColValue","Transfer_deal,count(*),RivalSerialNo='"+sSerialNo+"' or TrustCompaniesSerialNo='"+sSerialNo+"'");
		if(typeof(sReturn)!="undefined"&&parseInt(sReturn)){
			alert("已存在有效的协议记录，不允许删除！");
			return;
		}
		if(confirm("您真的想删除该信息吗？")){
			as_del("myiframe0");
			as_save("myiframe0");  //如果单个删除，则要调用此语句
		}
		reloadSelf();
	}

	function viewAndEdit(){
		var sSerialNo = getItemValue(0,getRow(),"SERIALNO");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert("请选择一条记录！");
			return;
		}
		AsControl.OpenView("/BusinessManage/CollectionManage/TransferDealClientInfo.jsp","SerialNo="+sSerialNo,"_self","");
	}

	$(document).ready(function(){
		hideFilterArea();
		AsOne.AsInit();
		init();
		my_load(2,0,'myiframe0');
	});
</script>	
<%@ include file="/IncludeEnd.jsp"%>