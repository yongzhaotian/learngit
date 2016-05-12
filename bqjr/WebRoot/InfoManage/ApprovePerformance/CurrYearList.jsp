<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   zywei 2006-12-28
		Tester:
		Content: 支行本年审批绩效查询
		Input Param:
		Output param:
		History Log: 
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "本年审批绩效查询"; // 浏览器窗口标题 <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;本年审批绩效查询&nbsp;&nbsp;";
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%
	//定义变量
	String sSql = "";//--存放sql语句
	
	//获得组件参数	
	
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%	
	//获取当前日期
	String sCurDate = StringFunction.getToday();
	//获取前十天的日期
	String sBeforeDate =  StringFunction.getRelativeDate(sCurDate,-10);
	//定义表头文件
	String sHeaders[][] = { 							
							{"StatisticDate","统计日期"},
							{"OrgName","审批人所属机构"},
							{"UserName","审批人姓名"},
							{"YApplySum","本年申请总金额（元）"},
							{"CurrDealCount","目前待审批笔数"},
							{"CurrDealSum","目前待审批金额（元）"},
							{"YAggreeCount","本年批准总笔数"},
							{"YDisagreeCount","本年否决总笔数"},
							{"YAfloatCount","本年在途总笔数"},
							{"YAggreeTime","本年批准总耗时（天）"},										
							{"YDisagreeTime","本年否决总耗时（天）"},
							{"YAfloatTime","本年在途总耗时（天）"},
							{"YNApproveCount","本年未签批复总笔数"},
							{"YNApproveSum","本年未签批复总金额（元）"},
							{"YNContractCount","本年未签合同总笔数"},
							{"YNContractSum","本年未签合同总金额（元）"},
							{"YNPutoutCount","本年未放贷总笔数"},
							{"YNPutoutSum","本年未放贷总金额（元）"},
							{"YNormalSum","本年正常总余额（元）"},
							{"YAttentionSum","本年关注总余额（元）"},
							{"YSecondarySum","本年次级总余额（元）"},
							{"YShadinessSum","本年可疑总余额（元）"},
							{"YLossSum","本年损失总余额（元）"}
						   }; 
	
	sSql = 	" select StatisticDate,OrgID,getOrgName(OrgID) as OrgName,UserID, "+
			" getUserName(UserID) as UserName,sum(YApplySum) as YApplySum, "+
			" sum(CurrDealCount) as CurrDealCount,sum(CurrDealSum) as CurrDealSum, "+
			" sum(YAggreeCount) as YAggreeCount,sum(YDisagreeCount) as YDisagreeCount, "+
			" sum(YAfloatCount) as YAfloatCount,sum(YAggreeTime) as YAggreeTime, "+
			" sum(YDisagreeTime) as YDisagreeTime,sum(YAfloatTime) as YAfloatTime, "+
			" sum(YNApproveCount) as YNApproveCount,sum(YNApproveSum) as YNApproveSum, "+
			" sum(YNContractCount) as YNContractCount,sum(YNContractSum) as YNContractSum, "+
			" sum(YNPutoutCount) as YNPutoutCount,sum(YNPutoutSum) as YNPutoutSum, "+
			" sum(YNormalSum) as YNormalSum,sum(YAttentionSum) as YAttentionSum, "+
			" sum(YSecondarySum) as YSecondarySum,sum(YShadinessSum) as YShadinessSum, "+
			" sum(YLossSum) as YLossSum "+			
			" from APPROVE_PERFORMANCE "+
			" where OrgID in (select OrgID from ORG_INFO where SortNo like '"+CurOrg.getSortNo()+"%') "+
			" group by StatisticDate,OrgID,UserID ";
	
	//利用sSql生成数据对象
	ASDataObject doTemp = new ASDataObject(sSql);   
	//设置表头
	doTemp.setHeader(sHeaders);	
	
	//设置可见属性
	doTemp.setVisible("OrgID,UserID",false);	
	//生成查询框
	doTemp.generateFilters(Sqlca);
	doTemp.setFilter(Sqlca,"1","StatisticDate","");
	doTemp.setFilter(Sqlca,"2","OrgName","");
	doTemp.setFilter(Sqlca,"3","UserName","");	
	doTemp.parseFilterData(request,iPostChange);
	if(!doTemp.haveReceivedFilterCriteria()) doTemp.WhereClause+=" and StatisticDate < '"+sCurDate+"' and StatisticDate >= '"+sBeforeDate+"'";
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));	

	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	dwTemp.setPageSize(16);  //服务器分页

	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List04;Describe=定义按钮;]~*/%>
	<%
	//依次为：
		//0.是否显示
		//1.注册目标组件号(为空则自动取当前组件)
		//2.类型(Button/ButtonWithNoAction/HyperLinkText/TreeviewItem/PlainText/Blank)
		//3.按钮文字
		//4.说明文字
		//5.事件
		//6.资源图片路径
	String sButtons[][] = {		
	};
	%> 
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script type="text/javascript">
	//---------------------定义按钮事件------------------------------//
	
	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List07;Describe=页面装载时，进行初始化;]~*/%>
<script type="text/javascript">	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>	
<%/*~END~*/%>


<%@ include file="/IncludeEnd.jsp"%>
