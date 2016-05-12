<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author: cchang
		Tester:
		Describe: 单户大户清单;
		Input Param:
			OrgID：机构号
			SortType：排序口径
				01为SumBalance1表内余额
				02为SumBalance2表外余额
				03为SumBalance12表内外余额合计
				04为SumBalance3不良余额
			ListSize：排位数
		Output Param:
			
		HistoryLog:
	 */
	%>
<%/*~END~*/%>



<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "单户大户清单"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>



<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量
	String sSql = "";
	ASResultSet rs = null;
	//获得页面参数
	
	//获得组件参数
	String sOrgId = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("OrgID"));
	if (sOrgId==null) sOrgId = CurOrg.getOrgID();
	String sSortNo=Sqlca.getString(new SqlObject("select SortNo from Org_Info where OrgID=:OrgID").setParameter("OrgID",sOrgId));
	if(sSortNo==null)sSortNo="";
	String sSortType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SortType"));
	if(sSortType==null)sSortType="01";
	String sListSize = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ListSize"));
	if (sListSize==null) sListSize = "10";
	String sCustomerType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("CustomerType"));
	if (sCustomerType==null) sCustomerType = "010";
	double InBalance = 0.0,InBadBalance = 0.0,OutBalance = 0.0,TotalSum = 0.0;

%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%
	sSql = "select sum(Balance) as InBalance,sum(OverDueBalance+DullBalance+BadBalance) as InBadBalance "+
			" from BUSINESS_CONTRACT "+
			" where OffSheetFlag in ('EntOn','IndOn') and ManageOrgID in (select OrgID from ORG_INFO where SortNo like :SortNo)";
	rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("SortNo",sSortNo+"%"));
	if(rs.next()){
		//表内
	   	InBalance=rs.getDouble("InBalance");
		//表内不良
	   	InBadBalance=rs.getDouble("InBadBalance");
	}
	rs.getStatement().close(); 

	sSql = "select sum(Balance) as OutBalance"+
			" from BUSINESS_CONTRACT "+
			" where OffSheetFlag in ('EntOff','IndOff')  and ManageOrgID in (select OrgID from ORG_INFO where SortNo like :SortNo) ";
	rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("SortNo",sSortNo+"%"));
	if(rs.next()){
		//表外
	   	OutBalance=rs.getDouble("OutBalance");
	}
	rs.getStatement().close(); 
	
	TotalSum = InBalance + OutBalance;
	
	String sInBalance = "*0.00";
	String sOutBalance = "*0.00";
	String sTotalSum = "*0.00";;
	String sInBadBalance = "*0.00";;
	if (InBalance>0.00) sInBalance="/"+InBalance;
	if (OutBalance>0.00) sOutBalance="/"+OutBalance;
	if (TotalSum>0.00) sTotalSum="/"+TotalSum;
	if (InBadBalance>0.00) sInBadBalance="/"+InBadBalance;
	
	String sHeaders[][] = {	{"CustomerID","客户号"},
							{"CustomerName","客户名称"},
							{"SumBalance1","表内余额(万元)"},
							{"SumBalance2","表外余额(万元)"},
							{"SumBalance12","表内外合计(万元)"},
							{"SumBalance3","不良余额(万元)"},
							{"SumBalance1Rate","占比(%)"},
							{"SumBalance2Rate","占比(%)"},
							{"SumBalance12Rate","占比(%)"},
							{"SumBalance3Rate","占比(%)"}
						  };

	sSql =	" select CustomerID,getCustomerName(CustomerID) as CustomerName, "+
			" sum(Balance1)/10000 as SumBalance1, "+
			" sum(Balance1)"+sInBalance+"*100 as SumBalance1Rate, "+
			" sum(Balance2)/10000 as SumBalance2, "+
			" sum(Balance2)"+sOutBalance+"*100 as SumBalance2Rate, "+
			" Sum(Balance1+Balance2)/10000 as SumBalance12, "+
			" sum(Balance1+Balance2)"+sTotalSum+"*100 as SumBalance12Rate, "+
			" sum(Balance3)/10000 as SumBalance3, "+
			" Sum(Balance3)"+sInBadBalance+"*100 as SumBalance3Rate "+
			" from "+ 
			" ( "+
			" select CI.CustomerID,"+
			" substring(BusinessType,1,1) as BusinessTypeFlag, "+
			" isEquals(substring(BusinessType,1,1),'1')*sum(Balance)  as Balance1, "+
			" isEquals(substring(BusinessType,1,1),'2')*sum(Balance)  as Balance2, "+
			" sum(OverDueBalance+DullBalance+BadBalance) as Balance3  "+
			" from BUSINESS_CONTRACT BC,CUSTOMER_INFO CI "+
			" where BC.CustomerID = CI.CustomerID and (BusinessType like '1%' or BusinessType like '2%') "+
         	" and ManageOrgID in (select OrgID from ORG_INFO where SortNo like '"+sSortNo+"%')"+
			" group by CI.CustomerID,substring(BusinessType,1,1) "+
			" ) B  "+
			" group by CustomerID ";

	if (sCustomerType.equals("020")) {
		sSql =	" select BelongGroupID as CustomerID,getCustomerName(BelongGroupID) as CustomerName, "+
				" sum(Balance1)/10000 as SumBalance1, "+
				" sum(Balance1)"+sInBalance+"*100 as SumBalance1Rate, "+
				" sum(Balance2)/10000 as SumBalance2, "+
				" sum(Balance2)"+sOutBalance+"*100 as SumBalance2Rate, "+
				" Sum(Balance1+Balance2)/10000 as SumBalance12, "+
				" sum(Balance1+Balance2)"+sTotalSum+"*100 as SumBalance12Rate, "+
				" sum(Balance3)/10000 as SumBalance3, "+
				" Sum(Balance3)"+sInBadBalance+"*100 as SumBalance3Rate "+
				" from "+ 
				" ( "+
				" select CI.BelongGroupID,"+
				" substring(BusinessType,1,1) as BusinessTypeFlag, "+
				" isEquals(substring(BusinessType,1,1),'1')*sum(Balance)  as Balance1, "+
				" isEquals(substring(BusinessType,1,1),'2')*sum(Balance)  as Balance2, "+
				" sum(OverDueBalance+DullBalance+BadBalance) as Balance3  "+
				" from BUSINESS_CONTRACT BC,CUSTOMER_INFO CI "+
				" where BelongGroupID is not null and BC.CustomerID = CI.CustomerID and (BusinessType like '1%' or BusinessType like '2%') "+
				" and ManageOrgID in (select OrgID from ORG_INFO where SortNo like '"+sSortNo+"%')"+
				" group by CI.BelongGroupID,substring(BusinessType,1,1) "+
				" ) B  "+
				" group by BelongGroupID ";
	}

	if(sSortType.equals("01"))
	sSql = sSql+" order by SumBalance1 desc ";
	else if(sSortType.equals("02"))
	sSql = sSql+" order by SumBalance2 desc ";
	else if(sSortType.equals("03"))
	sSql = sSql+" order by SumBalance12 desc ";
	else if(sSortType.equals("04"))
	sSql = sSql+" order by SumBalance3 desc ";

	//用sSql生成数据窗体对象
	ASDataObject doTemp=new ASDataObject(sSql);;
	doTemp.setHeader(sHeaders);
	doTemp.setVisible("CustomerID",false);
	doTemp.setAlign("SumBalance1,SumBalance2,SumBalance12,SumBalance3,SumBalance1Rate,SumBalance2Rate,SumBalance12Rate,SumBalance3Rate","3");
	//doTemp.setColumnType("SumBalance1,SumBalance2,SumBalance12,SumBalance3","2");
	doTemp.setType("SumBalance1,SumBalance2,SumBalance12,SumBalance3,SumBalance1Rate,SumBalance2Rate,SumBalance12Rate,SumBalance3Rate","Number");
	doTemp.setCheckFormat("SumBalance1,SumBalance2,SumBalance12,SumBalance3,SumBalance1Rate,SumBalance2Rate,SumBalance12Rate,SumBalance3Rate","2");

	doTemp.setHTMLStyle("CustomerName"," style={width:200px} ondblclick=\"javascript:parent.viewAndEdit()\"");
	doTemp.setHTMLStyle("SumBalance1,SumBalance2,SumBalance12,SumBalance3"," style={width:100px} ondblclick=\"javascript:parent.viewAndEdit()\"");
	doTemp.setHTMLStyle("SumBalance1Rate,SumBalance2Rate,SumBalance12Rate,SumBalance3Rate"," style={width:54px} ondblclick=\"javascript:parent.viewAndEdit()\"");

	ASDataWindow dwTemp;
	Vector vTemp;
	try {
		Sqlca.executeSQL("set rowcount "+sListSize);
		dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
		dwTemp.Style="1";      //设置为Grid风格
		dwTemp.ReadOnly = "1"; //设置为只读
		//dwTemp.ShowSummary="1";
		vTemp = dwTemp.genHTMLDataWindow("");
	} catch (Exception e) {
		throw e;
	}	finally {
		Sqlca.executeSQL("set rowcount 0");
	}
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
			//{"true","","Button","大户详情","大户详情","viewAndEdit()",sResourcesPath}
		};
	%>
<%/*~END~*/%>




<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script type="text/javascript">

	//---------------------定义按钮事件------------------------------------
	/*~[Describe=新增记录;InputParam=无;OutPutParam=无;]~*/

	/*~[Describe=查看及修改详情;InputParam=无;OutPutParam=无;]~*/
	function viewAndEdit()
	{
		var sCustomerID=getItemValue(0,getRow(),"CustomerID");
		if (typeof(sCustomerID)=="undefined" || sCustomerID.length==0)
		{
			alert(getHtmlMessage('1'));
			return;
		}
		if ("<%=sCustomerType%>"=="020") {
			openObject("Customer",sCustomerID,"001");
		}
		else {
			OpenComp("CustomerLoanAfterList","/CustomerManage/EntManage/CustomerLoanAfterList.jsp","CustomerID="+sCustomerID,"_blank");
		}
	}

	</script>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List07;Describe=页面装载时，进行初始化;]~*/%>
<script type="text/javascript">
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	//init_show();  //only for show report
	//my_load_show(2,0,'myiframe0');  //only for show report

</script>
<%/*~END~*/%>

<%@	include file="/IncludeEnd.jsp"%>
