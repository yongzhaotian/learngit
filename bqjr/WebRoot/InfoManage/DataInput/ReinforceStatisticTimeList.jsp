<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author: yxzhang 2010/03/22
		Tester:
		Describe: 信息补登实时查询列表；
		Input Param:
	
		Output Param:
			
			
		HistoryLog:	sxjiang 2010/07/19  Line77  关闭结果集
	 */
	%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "信息补登实时查询列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%
	String sHeaders[][] = { 
							{"ManageOrgID","机构代码"},
							{"ManageOrgName","机构名称"},
							{"Reinforce1","需补登信贷业务"},
							{"Reinforce2","补登完成信贷业务"},
							{"FinishedRatio","补登完成百分比"},
							{"TotalBC","总数"}
						  }; 
	String sSql=" select ManageOrgID,getOrgName(BC.ManageOrgID) as ManageOrgName,"+
				" sum(case when ReinforceFlag='010' then 1 else 0 end) as Reinforce1,"+
				" sum(case when ReinforceFlag='020' then 1 else 0 end) as Reinforce2,0 as FinishedRatio,"+
				" count(ReinforceFlag) as TotalBC"+
				" from BUSINESS_CONTRACT BC"+
				" where ReinforceFlag in('010','020')"+
				" and BC.ManageOrgID like '"+CurOrg.getOrgID()+"%'"+
				" group by BC.ManageOrgID";

	//设置DataObject				
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders);
    //设置更新的数据库表名
	doTemp.UpdateTable = "BUSINESS_CONTRACT"; 
    //设置关键字段	
	doTemp.setKey("ManageOrgID",true);
	doTemp.setAlign("ManageOrgID,ManageOrgName","2");
	doTemp.setAlign("Reinforce1,Reinforce2,TotalBC,FinishedRatio","3");
	//设置HTML的格式
	doTemp.setHTMLStyle("ManageOrgID"," style={width:200px} ");
	doTemp.setVisible("ManageOrgID",false);
	
	ASResultSet rs = null;
	double dReinForce2 =0;
	double dTotalBC = 0;
	double dFinishedRatio = 0;
	rs = Sqlca.getASResultSet(sSql);
	if(rs.next()){
		dReinForce2 = rs.getDouble("ReinForce2");
		dTotalBC = rs.getDouble("TotalBC");
	}
	rs.getStatement().close();
	dFinishedRatio = dReinForce2/dTotalBC;
	
	//生成查询框
	//doTemp.setColumnAttribute("ManageOrgID","IsFilter","1");
	
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	

	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置为Grid风格
	dwTemp.ReadOnly = "1"; //设置为只读
	
	//生成datawindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
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




<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List05;Describe=自定义函数;]~*/%>

<script>

	//---------------------定义按钮事件------------------------------------
	/*~[Describe=生成图像;InputParam=无;OutPutParam=无;]~*/
	function GraphShowCount()
	{  
		var dTotalBC = <%=dTotalBC%>;
		if(dTotalBC == 0){
			alert("该机构没有补登业务！");
			return;
		}
		OrgID = <%=CurOrg.getOrgID()%>;
		sScreenWidth = screen.availWidth-40;
		sScreenHeight = screen.availHeight-40;
		
		sReturn=RunMethod("信息补登","ReinforceStatisticNow",OrgID+",Counts");
	    sReturns = sReturn.split(",");
	    OrgNames = sReturns[0];
	    FinishCounts = sReturns[1];
	    ItemName = sReturns[2];
	    
	    PopPage("/InfoManage/DataInput/ReinforceStatisticGraphicShow.jsp?ScreenWidth="+sScreenWidth+"&ScreenHeight="+sScreenHeight+"&hValue="+OrgNames+"&vValue="+FinishCounts+"&ItemName="+ItemName,"_blank",sDefaultDialogStyle);
	}

	/*~[Describe=生成图像;InputParam=无;OutPutParam=无;]~*/
	function GraphShowPercent()
	{  
		var dTotalBC = <%=dTotalBC%>;
		if(dTotalBC == 0){
			alert("该机构没有补登业务！");
			return;
		}
		OrgID = <%=CurOrg.getOrgID()%>;
		sScreenWidth = screen.availWidth-40;
		sScreenHeight = screen.availHeight-40;

		sReturn=RunMethod("信息补登","ReinforceStatisticNow",OrgID+",Percents");
	    sReturns = sReturn.split(",");
	    OrgNames = sReturns[0];
	    FinishPercents = sReturns[1];
	    ItemName = sReturns[2];
		
		PopPage("/InfoManage/DataInput/ReinforceStatisticGraphicShow.jsp?ScreenWidth="+sScreenWidth+"&ScreenHeight="+sScreenHeight+"&hValue="+OrgNames+"&vValue="+FinishPercents+"&ItemName="+ItemName,"_blank",sDefaultDialogStyle);
	}

</script>
<%/*~END~*/%>	




<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List07;Describe=页面装载时，进行初始化;]~*/%>
<script type="text/javascript">
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	var dFinishedRatio = <%=dFinishedRatio%>;
	dFinishedRatio = roundOff(dFinishedRatio*100,2);
	setItemValue(0,0,"FinishedRatio",dFinishedRatio);
</script>
<%/*~END~*/%>


<%@	include file="/IncludeEnd.jsp"%>
