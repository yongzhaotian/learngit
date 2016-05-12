<%@ page contentType="text/html; charset=GBK"%>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>
<%@ include file="/IncludeBegin.jsp"%><%
	/*
		--页面说明: 示例列表页面--
	 */
	String PG_TITLE = "示例列表页面";
	//获得页面参数
	//String sInputUser =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("InputUser"));
	//if(sInputUser==null) sInputUser="";
	
	SimpleDateFormat forMat=new SimpleDateFormat("yyyy/MM/dd");
	String nowDate=forMat.format(new Date());
	//通过DW模型产生ASDataObject对象doTemp
	String sTempletNo = "ContractNoReturnList";//模型编号
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);

	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	doTemp.WhereClause+=" and ACCESSTYPE='01' and ISARCHIVE='01' and RENTURNDATE<'"+nowDate+"'";
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	dwTemp.setPageSize(10);

	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
			{CurUser.getRoleTable().contains("2001")?"true":"false","","Button","导出EXCEL","导出EXCEL","exportExcel()",sResourcesPath},
	};
	
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">

		//Excel导出功能呢	
		function exportExcel(){
			amarExport("myiframe0");
		}
		//end by pli2 20140417	

	function viewtab(){
		//获得申请类型、申请流水号
		var sObjectType = "BusinessContract";
		var sObjectNo = getItemValue(0,getRow(),"SERIALNO");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		sCompID = "CreditTab";
		sCompURL = "/CreditManage/CreditApply/ObjectTab.jsp";
		sParamString = "ObjectType="+sObjectType+"&ObjectNo="+sObjectNo;
		OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
		reloadSelf();
	}
	
	function elecContractView(){
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

	function imageView(){
		 var sObjectNo   = getItemValue(0,getRow(),"SERIALNO");
	        if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
	            alert(getHtmlMessage('1'));//请选择一条信息！
	            return;
	        }
	     var param = "ObjectType=Business&TypeNo=20&ObjectNo="+sObjectNo;
	     AsControl.PopView( "/ImageManage/ImageView.jsp", param, "" );
	}
	
	function contractView() {
		var sSerialNo = getItemValue(0,getRow(),"SERIALNO");
		 if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
	            alert(getHtmlMessage('1'));//请选择一条信息！
	            return;
	        }
		sCompID = "AccessTypeInfo";
		sCompURL = "/AppConfig/Document/AccessTypeInfo.jsp";
	    popComp(sCompID,sCompURL,"serialNo="+sSerialNo,"dialogWidth=300px;dialogHeight=360px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
	    reloadSelf();
	}
	
	function tackbackContract() {
		var sSerialNo = getItemValue(0,getRow(),"SERIALNO");
		var sAccessType = getItemValue(0,getRow(),"AccessType");
		 if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
	            alert(getHtmlMessage('1'));//请选择一条信息！
	            return;
	     }
		 if (typeof(sAccessType)=="undefined" || sAccessType.length==0){
	            alert("该合同没有被调阅,不需要归还！");//请选择一条信息！
	            return;
	     }
	    if(confirm("您真的要归还吗？")){
	    	RunMethod("ModifyNumber","GetModifyNumber","business_contract,AccessType='02',serialNo='"+sSerialNo+"'");
			reloadSelf();
		}
		 
	}
	
	function destroyContract() {
		var sSerialNo = getItemValue(0,getRow(),"SERIALNO");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
	           alert(getHtmlMessage('1'));//请选择一条信息！
	           return;
	    }
		if(confirm("您真的要销毁吗？")){
		    RunMethod("ModifyNumber","GetModifyNumber","business_contract,AccessType='03',serialNo='"+sSerialNo+"'");
			reloadSelf();
		}
	}
	
	$(document).ready(function(){
		AsOne.AsInit();
		init();
		my_load(2,0,'myiframe0');
	});
</script>	
<%@ include file="/IncludeEnd.jsp"%>
