<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		页面说明: 示例列表页面
	 */
	String PG_TITLE = "注册部包裹关联页面";
	//获得页面参数
	String sPackNo =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("PackNo"));
	String sFlag =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("Flag"));
	String sCreditID =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CreditID"));
	String sCreateUser =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CreateUser"));
	
	System.out.println("-------"+sCreditID);
	if(sPackNo==null) sPackNo="";
	if(sFlag==null) sFlag="";
	if(sCreditID==null) sCreditID="";
	if(sCreateUser==null) sCreateUser="";
	
	//通过DW模型产生ASDataObject对象doTemp
	String sTempletNo = "RegisterContractList";//模型编号
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	doTemp.multiSelectionEnabled=true;//显示多选框
	
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	dwTemp.setPageSize(10);

	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sPackNo);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{((sFlag.equals("Y") && sCreateUser.equals(CurUser.getUserID()))?"true":"false"),"","Button","新增","新增一条记录","newRecord()",sResourcesPath},
		{((sFlag.equals("Y") && sCreateUser.equals(CurUser.getUserID()))?"true":"false"),"","Button","删除","删除所选中的记录","saveRecord()",sResourcesPath},
		{CurUser.getRoleTable().contains("2001")?"true":"false","","Button","导出EXCEL","导出EXCEL","exportExcel()",sResourcesPath},

	};
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
    <%/*~[Describe=新增信息;InputParam=无;OutPutParam=无;] ~*/%>
    
  //Excel导出功能呢	
    function exportExcel(){
    	amarExport("myiframe0");
    }
    //end by pli2 20140417	
	
	function newRecord(){
		sCompID = "PackContractList";
		sCompURL = "/BusinessManage/ContractManage/PackContractList.jsp";
		sString = "PackNo=<%=sPackNo%>"+"&CreditID=<%=sCreditID%>";
	    popComp(sCompID,sCompURL,sString,"dialogWidth=850px;dialogHeight=500px;resizable=no;scrollbars=no;status:yes;maximize:yes;minimize:no;help:no;");
	    reloadSelf();
	}
	
	<%/*~[Describe=删除信息;InputParam=无;OutPutParam=无;] ~*/%>
	function deleteRecord(){
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert("请选择一条记录！");
			return;
		}
		
		if(confirm("您真的想删除该信息吗？")){
			//as_del("myiframe0");
			RunMethod("BusinessManage","delPackRelative",sSerialNo);
			//更新合同中包裹关联状态：为空
			RunMethod("BusinessManage","UpdatePackStatus",sArtificialNo[i]+","+"");
			as_save("myiframe0");  //如果单个删除，则要调用此语句
			reloadSelf();
		}
	}
	
	function saveRecord(){
		var sArtificialNo = getItemValueArray(0,"ContractNo");//合同编号
		var sSerialNo = getItemValueArray(0,"SerialNo");//包裹编号
        
        if(sArtificialNo != ""){
			for(var i=0;i<sArtificialNo.length;i++){
				 //更新合同中包裹关联状态：2
				 RunMethod("BusinessManage","UpdatePackStatus",sArtificialNo[i]+","+"");
				 //删除包裹关联关系
				 RunMethod("BusinessManage","delPackRelative",sSerialNo[i]);
				 as_save("myiframe0");  //如果单个删除，则要调用此语句
				 reloadSelf();
			}
	     }else{
			alert("你没有选择记录,请选择！");
		 }	
	}


	$(document).ready(function(){
		showFilterArea();
		AsOne.AsInit();
		init();
		my_load(2,0,'myiframe0');
	});
</script>	
<%@ include file="/IncludeEnd.jsp"%>