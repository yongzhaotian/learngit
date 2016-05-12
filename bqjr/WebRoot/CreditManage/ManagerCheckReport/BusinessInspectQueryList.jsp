<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author: ndeng 2005-01-17
		Tester:
		Describe: 贷后检查列表
		Input Param:
					InspectType：   010     贷款用途检查报告
						            010010  未完成
						            010020  已完成
						            020     贷后检查报告
						            020010  未完成
						            020020  已完成
		Output Param:
			
		HistoryLog:
	 */
	%>
<%/*~END~*/%>



<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "贷后检查列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>



<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量
	

	//获得页面参数
	
	//获得组件参数
	String sInspectType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("InspectType"));
    //只能查询已完成报告
    if(sInspectType == null) sInspectType="020010";
%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%
	ASDataObject doTemp = null;
  //贷款用途报告列表
  if(sInspectType.equals("010010") || sInspectType.equals("010020"))
  {
	  String sHeaders1[][] = {
							{"CustomerName","客户名称"},
							{"BusinessTypeName","业务品种"},
							{"ArtificialNo","合同编号"},
							{"Currency","币种"},
							{"BusinessSum","合同金额"},
							{"PutOutDate","合同生效日期"},
							{"InspectType","检查类型"},
							{"UpDateDate","报告日期"},
							{"InputUser","检查人"},
							{"InputOrg","所属机构"},
							{"ManageOrg","经办机构"}
							};

	  String sSql1 = " select II.SerialNo as SerialNo,II.ObjectNo as ObjectNo,II.ObjectType as ObjectType,"+
					" BC.CustomerID as CustomerID,BC.CustomerName as CustomerName, "+
					" getBusinessName(BusinessType) as BusinessTypeName,"+
					" getItemName('Currency',BC.BusinessCurrency) as Currency,"+
		            " BC.BusinessType as BusinessType ,"+
		            " BC.ArtificialNo as ArtificialNo,"+
		            " BC.BusinessSum as BusinessSum,BC.PutOutDate,getOrgName(BC.ManageOrgid) as ManageOrg,"+
					" getItemName('InspectType',II.InspectType) as InspectType,"+
					" II.UpDateDate as UpDateDate,"+
					" getUserName(II.InputUserID) as InputUser,"+
					" getOrgName(II.InputOrgId) as InputOrg"+
					" from INSPECT_INFO II,BUSINESS_CONTRACT BC "+
					" where II.ObjectType='BusinessContract' "+
	                " and II.InspectType like '010%' "+
	                " and II.ObjectNo=BC.SerialNo ";

	if(sInspectType.equals("010010"))
	{
	  sSql1=sSql1+" and (II.FinishDate = ' ' or II.FinishDate is null)";
	}
	else
	{
	  sSql1=sSql1+" and II.FinishDate is not null";
	}
	//由SQL语句生成窗体对象。
	doTemp = new ASDataObject(sSql1);

	doTemp.UpdateTable = "INSPECT_INFO";

	doTemp.setKey("SerialNo",true);
	doTemp.setHeader(sHeaders1);
  	//设置不可见项
  	doTemp.setVisible("SerialNo,ObjectNo,BusinessType,ObjectType,InspectType,ManageOrg,CustomerID",false);
  	doTemp.setUpdateable("BusinessTypeName,BusinessType,BusinessSum,CustomerName",false);
  	doTemp.setAlign("BusinessSum,Balance","3");
  	doTemp.setCheckFormat("BusinessSum,Balance","2");
  	//设置html格式
  	doTemp.setHTMLStyle("UptoDate,BusinessSum"," style={width:80px} ");
  	doTemp.setHTMLStyle("InspectType"," style={width:100px} ");
  	doTemp.setHTMLStyle("ObjectNo,CustomerName,BusinessTypeName"," style={width:120px} ");      
  	  
	//生成查询框
	doTemp.setFilter(Sqlca,"1","UpDateDate","HtmlTemplate=Date;Operators=BetweenString;");
	doTemp.setFilter(Sqlca,"2","PutOutDate","HtmlTemplate=Date;Operators=BetweenString;");
	doTemp.setFilter(Sqlca,"3","ManageOrg","");
	doTemp.setFilter(Sqlca,"4","CustomerName","");
	doTemp.setFilter(Sqlca,"5","InputUser","");
	doTemp.setFilter(Sqlca,"6","InputOrg","");	
  }
    
  //贷后检查报告列表
  else if(sInspectType.equals("020010") || sInspectType.equals("020020"))
  {
    String sHeaders2[][] = {
							{"CustomerName","客户名称"},
							{"ObjectNo","客户编号"},
							{"CustomerBelongOrg","经办机构"},
							{"InspectType","检查类型"},
							{"UpDateDate","报告日期"},
							{"InputUserName","检查人"},
							{"InputOrgName","所属机构"}							
						  };

	  String sSql2 = //" select SerialNo,ObjectNo,ObjectType,getCustomerName(ObjectNo) as CustomerName,getOrgName(CI.InputOrgID) as CustomerBelongOrg,"+
	                " select II.SerialNo,II.ObjectNo,II.ObjectType,CI.CustomerName,getOrgName(CI.InputOrgID) as CustomerBelongOrg,"+
					" getItemName('InspectType',II.InspectType) as InspectType,"+
		            " II.UpDateDate,II.InputUserID,II.InputOrgID,"+
		            " getUserName(II.InputUserID) as InputUserName,"+
		            " getOrgName(II.InputOrgID) as InputOrgName "+
					" from INSPECT_INFO II,CUSTOMER_INFO CI "+
					" where ObjectType='Customer' and II.ObjectNo = CI.CustomerID"+
	                " and InspectType  like '020%' ";

	  if(sInspectType.equals("020010"))
	  {
	    sSql2=sSql2+" and (FinishDate = ' ' or FinishDate is null)";
	  }
	  else
	  {
	    sSql2=sSql2+" and FinishDate is not null";
	  }
	  //由SQL语句生成窗体对象。
	  doTemp = new ASDataObject(sSql2);

	  doTemp.UpdateTable = "INSPECT_INFO";

	  doTemp.setKey("SerialNo,ObjectNo,ObjectType",true);
	  doTemp.setHeader(sHeaders2);
  	//设置不可见项
  	doTemp.setVisible("SerialNo,InputUserID,InputOrgID,ObjectNo,ObjectType,InspectType,CustomerBelongOrg",false);
  	doTemp.setUpdateable("CustomerName,InputUserName,InputOrgName",false);
  	//设置html格式
  	doTemp.setHTMLStyle("UptoDate,InputUserName"," style={width:80px} ");
  	doTemp.setHTMLStyle("InspectType"," style={width:100px} ");
  	doTemp.setHTMLStyle("ObjectNo,CustomerName"," style={width:250px} ");
  	
  	
  	//生成查询框
	doTemp.setFilter(Sqlca,"1","UpDateDate","HtmlTemplate=Date;Operators=BetweenString;");
	doTemp.setFilter(Sqlca,"2","CustomerBelongOrg","");
	doTemp.setFilter(Sqlca,"3","CustomerName","");
	doTemp.setFilter(Sqlca,"4","InputUserName","");
	doTemp.setFilter(Sqlca,"5","InputOrgName","");
	
	//doTemp.setVisible("CustomerBelongOrg",false);
  }
 
  	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	if(!doTemp.haveReceivedFilterCriteria()) doTemp.WhereClause+=" and 1=2 ";
  	
  	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
  	dwTemp.Style="1";      //设置为Grid风格
  	dwTemp.ReadOnly = "1"; //设置为只读
  
    //out.println(doTemp.SourceSql);
  	Vector vTemp = dwTemp.genHTMLDataWindow("");
  	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

  
  	String sCriteriaAreaHTML = ""; //查询区的页面代码
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
			{"true","","Button","详情","查看报告详情","viewAndEdit()",sResourcesPath},
			{"true","","Button","客户基本信息","查看客户基本信息","viewCustomer()",sResourcesPath},
		    {"true","","Button","业务清单","查看业务清单","viewBusiness()",sResourcesPath}
		};
	%>
<%/*~END~*/%>




<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script type="text/javascript">

	/*~[Describe=查看及修改详情;InputParam=无;OutPutParam=无;]~*/
	function viewAndEdit()
	{
		sInspectType = "<%=sInspectType%>";
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		sObjectType=getItemValue(0,getRow(),"ObjectType");

		if(typeof(sSerialNo)=="undefined" || sSerialNo.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
		}
		else {
			if(sInspectType == '010010' || sInspectType == '010020')
			{
				sCompID = "PurposeInspectTab";
				sCompURL = "/CreditManage/CreditCheck/PurposeInspectTab.jsp";
				sParamString = "SerialNo="+sSerialNo+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType;
				OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
			}
			else if(sInspectType == '020010' || sInspectType == '020020')
			{
				sCompID = "InspectTab";
				sCompURL = "/CreditManage/CreditCheck/InspectTab.jsp";
				sParamString = "SerialNo="+sSerialNo+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType;
				OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
			}
		}
	}
    /*~[Describe=查看客户详情;InputParam=无;OutPutParam=无;]~*/
	function viewCustomer()
	{
		if("<%=sInspectType%>"=="010010" || "<%=sInspectType%>"=="010020")
        {
            sCustomerID   = getItemValue(0,getRow(),"CustomerID");
        }
       	else if("<%=sInspectType%>"=="020010" || "<%=sInspectType%>"=="020020")	
    	{
    	    sCustomerID   = getItemValue(0,getRow(),"ObjectNo");
    	}
		
		if (typeof(sCustomerID)=="undefined" || sCustomerID.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
		}else
		{
			openObject("Customer",sCustomerID,"001");
		}
    		
    }
    /*~[Describe=查看业务清单;InputParam=无;OutPutParam=无;]~*/
	function viewBusiness()
	{
		if("<%=sInspectType%>"=="010010" || "<%=sInspectType%>"=="010020")
        {
            sCustomerID   = getItemValue(0,getRow(),"CustomerID");
        }
       	else if("<%=sInspectType%>"=="020010" || "<%=sInspectType%>"=="020020")	
    	{
    	    sCustomerID   = getItemValue(0,getRow(),"ObjectNo");
    	}
		
		if (typeof(sCustomerID)=="undefined" || sCustomerID.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
		}else
		{
			popComp("CustomerLoanAfterList","/CustomerManage/EntManage/CustomerLoanAfterList.jsp","CustomerID="+sCustomerID,"","","");
		}
	}
	</script>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script type="text/javascript">


	</script>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List07;Describe=页面装载时，进行初始化;]~*/%>
<script type="text/javascript">
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	showFilterArea();
</script>
<%/*~END~*/%>

<%@	include file="/IncludeEnd.jsp"%>