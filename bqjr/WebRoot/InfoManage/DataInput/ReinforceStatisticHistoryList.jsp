<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author: yxzhang 2010/03/22
		Tester:
		Describe: 信息补登历史查询列表；
		Input Param:
	
		Output Param:
			
			
		HistoryLog:
	 */
	%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "信息补登历史查询列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%
    String sSortNo = CurOrg.getSortNo()+"%";

	String sTempletNo = "ReinforceStatisticHistoryList";
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	

	
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	//多选
	doTemp.multiSelectionEnabled = true;
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置为Grid风格
	dwTemp.ReadOnly = "1"; //设置为只读
	
	//生成datawindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sSortNo);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List04;Describe=定义按钮;]~*/%>
	<%
	String sButtons[][] = {
			{"true","","Button","业务补登完成数量展示","业务补登完成数量展示","GraphShowCount()",sResourcesPath},	
			{"true","","Button","业务补登百分比展示","业务补登百分比展示","GraphShowPercent()",sResourcesPath}	
		  };
	%>
<%/*~END~*/%>




<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
<script type="text/javascript">
    //---------------------定义按钮事件------------------------------------
    /*~[Describe=生成图像;InputParam=无;OutPutParam=无;]~*/
	function GraphShowCount()
	{  
        sOrgIDArray = getItemValueArray(0,"OrgID");//取得被勾选机构的OrgID
        sOrgID = "";
        
        if (sOrgIDArray.length==0){
            alert("你没有选择信息，请在需要选择的信息前打√！ ");
            return;
        }else if(sOrgIDArray.length > 10){
            alert("选择的机构过多,请不要超过10个！ ");
            return;
        }else{        	
            for(var i=0; i<sOrgIDArray.length; i++){
            	sOrgID = sOrgID + sOrgIDArray[i] + ";";
            }
            sOrgID = sOrgID.substring(0,sOrgID.length-1);
        }
        
	    sScreenWidth = screen.availWidth-40;
	    sScreenHeight = screen.availHeight-40;
	    
	    sReturn=RunMethod("信息补登","ReinforceStatisticHistory",sOrgID+",Counts");
	    sReturns = sReturn.split(",");
	    OrgNames = sReturns[0];
	    FinishCounts = sReturns[1];
	    ItemName = sReturns[2];
	    PopPage("/InfoManage/DataInput/ReinforceStatisticGraphicShow.jsp?ScreenWidth="+sScreenWidth+"&ScreenHeight="+sScreenHeight+"&hValue="+OrgNames+"&vValue="+FinishCounts+"&ItemName="+ItemName,"_blank",sDefaultDialogStyle);
	}
	
	/*~[Describe=生成图像;InputParam=无;OutPutParam=无;]~*/
	function GraphShowPercent()
	{  
        sOrgIDArray = getItemValueArray(0,"OrgID");//取得被勾选机构的OrgID
        sOrgID = "";
        
        if (sOrgIDArray.length==0){
            alert("你没有选择信息，请在需要选择的信息前打√！ ");
            return;
        }else if(sOrgIDArray.length > 10){
        	alert("选择的机构过多,请不要超过10个！ ");
            return;
        }else{          
            for(var i=0; i<sOrgIDArray.length; i++){
                sOrgID = sOrgID + sOrgIDArray[i] + ";";
            }
            sOrgID = sOrgID.substring(0,sOrgID.length-1);
        }
        
        sScreenWidth = screen.availWidth-40;
        sScreenHeight = screen.availHeight-40;
        
        sReturn=RunMethod("信息补登","ReinforceStatisticHistory",sOrgID+",Percents");
        sReturns = sReturn.split(",");
        OrgNames = sReturns[0];
        FinishCounts = sReturns[1];
        ItemName = sReturns[2];
        PopPage("/InfoManage/DataInput/ReinforceStatisticGraphicShow.jsp?ScreenWidth="+sScreenWidth+"&ScreenHeight="+sScreenHeight+"&hValue="+OrgNames+"&vValue="+FinishCounts+"&ItemName="+ItemName,"_blank",sDefaultDialogStyle);
	}
</script>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List07;Describe=页面装载时，进行初始化;]~*/%>
<script type="text/javascript">
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>
<%/*~END~*/%>


<%@	include file="/IncludeEnd.jsp"%>
