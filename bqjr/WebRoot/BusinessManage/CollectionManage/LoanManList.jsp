<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		页面说明: 示例列表页面
	 */
	String PG_TITLE = "贷款人列表页面";
	//获得页面参数
	String sTemp =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("temp"));
	if(sTemp==null) sTemp="";
    boolean a=false;
	String ss = CurARC.getAttribute(request.getSession().getId()+"city"); // 测试session中的门店编号值
	//通过DW模型产生ASDataObject对象doTemp
	String sTempletNo = "LoanManList";//模型编号
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	doTemp.WhereClause+=sTemp.equals("1")? " and not exists (select bc.creditid from business_contract bc where bc.creditattribute='0002' and bc.creditid=Service_Providers.serialNo and bc.creditid is not null group by bc.creditid)" 
    		                                :" and exists (select bc.creditid from business_contract bc where bc.creditattribute='0002' and bc.creditid=Service_Providers.serialNo  and bc.creditid is not null group by bc.creditid)";
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
		{sTemp.equals("1")?"true":"false","","Button","新增","新增一条记录","newRecord()",sResourcesPath},
		{"true","","Button","详情","查看/修改详情","viewAndEdit()",sResourcesPath},
		{"false","","Button","删除","删除所选中的记录","deleteRecord()",sResourcesPath},
		{"false","","Button","使用ObjectViewer打开","使用ObjectViewer打开","openWithObjectViewer()",sResourcesPath},
	};
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
	function newRecord(){
		 var sReturn=popComp("","/BusinessManage/CollectionManage/LoanManInfo.jsp","",""); 
		 /* AsControl.OpenView("/BusinessManage/CollectionManage/LoanManInfo.jsp","","_self","");  */
		if(sReturn!=null){
		 AsControl.OpenView("/BusinessManage/CollectionManage/LoanManTab.jsp","LoanNo="+sReturn,"_blank",""); 
		}
	}
	
	function deleteRecord(){

		var sLoanNo = getItemValue(0,getRow(),"serialNo");//修改为 wlq 
		if (typeof(sLoanNo)=="undefined" || sLoanNo.length==0){
			alert("请选择一条记录！");
			return;
		}
		
		if(confirm("您真的想删除该信息吗？")){
			as_del("myiframe0");
			as_save("myiframe0");  //如果单个删除，则要调用此语句
			reloadSelf();
		}
	}
	
	function openXin(){
		var sLoanNo = getItemValue(0,getRow(),"serialNo");//修改为 wlq 
		if (typeof(sLoanNo)=="undefined" || sLoanNo.length==0){
			alert("请选择一条记录！");
			return;
		}
		RunMethod("ModifyNumber","GetModifyNumber","Service_Providers,Status='01',serialNo='"+sLoanNo+"'");
		alert("激活成功");
		reloadSelf();
	}
	
	function stopXin(){
		var sLoanNo = getItemValue(0,getRow(),"serialNo");//修改为 wlq 
		if (typeof(sLoanNo)=="undefined" || sLoanNo.length==0){
			alert("请选择一条记录！");
			return;
		}
		RunMethod("ModifyNumber","GetModifyNumber","Service_Providers,Status='02',serialNo='"+sLoanNo+"'");
		alert("禁用成功");
		reloadSelf();
	}

	function viewAndEdit(){
		
		var sLoanNo = getItemValue(0,getRow(),"serialNo");//修改为 wlq
		if (typeof(sLoanNo)=="undefined" || sLoanNo.length==0){
			alert("请选择一条记录！");
			return;
		}
		AsControl.OpenView("/BusinessManage/CollectionManage/LoanManTab.jsp","LoanNo="+sLoanNo,"_blank","");
		reloadSelf();
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
		showFilterArea();
		init();
		my_load(2,0,'myiframe0');
	});
</script>	
<%@ include file="/IncludeEnd.jsp"%>
