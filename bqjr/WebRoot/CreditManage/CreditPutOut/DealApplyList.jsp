<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author: wqchen 2010-03-20
		Tester:
		Describe: 对业务申请进行登记;
		Input Param:
					DealType：
						01：待签署合同的通知书（一般授信业务）
						02：完成操作的通知书（一般授信业务）
		Output Param:
			
		HistoryLog: zywei 2005/08/13 重检页面
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "申请列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量
	String sCondition="";	
	//获得组件参数
	String sDealType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("DealType"));
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%
	//设置列表标题
	String sHeaders[][] = {
							{"SerialNo","申请流水号"},
							{"CustomerName","客户名称"},
							{"BusinessTypeName","业务品种"},
							{"OccurType","发生类型"},
							{"Currency","币种"},
							{"BusinessSum","申请金额"},
							{"RelativeSum","已登记合同金额(元)"},
							{"VouchTypeName","主要担保方式"},
							{"InputUserName","登记人"},
							{"InputOrgName","登记机构"}
						  };

	String sSql =   " select SerialNo,CustomerName,"+
					" getBusinessName(BusinessType) as BusinessTypeName,"+
					" OccurType,"+
					" getItemName('Currency',BusinessCurrency) as Currency,"+
					" BusinessSum,ApplyType,"+
					" getItemName('VouchType',VouchType) as VouchTypeName,"+
					" getUserName(InputUserID) as InputUserName,"+
					" getOrgName(InputOrgID) as InputOrgName"+
					" from BUSINESS_APPLY"+
					" where OperateUserID ='"+CurUser.getUserID()+"'"+
					" and SerialNo in (select ObjectNo from FLOW_OBJECT where ApplyType in ('CreditLineApply','DependentApply','IndependentApply') "+
					" and PhaseNo='1000') ";

	if(sDealType.equals("01"))
	{
		sCondition = " and Flag5 = '010' ";
	}else if(sDealType.equals("02"))
	{
		sCondition = " and Flag5 = '020' ";
	}
	sSql = sSql + sCondition + " order by SerialNo desc ";

	//由SQL语句生成窗体对象。
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.UpdateTable="BUSINESS_APPly";
	doTemp.setKey("SerialNo",true);
	doTemp.setKeyFilter("SerialNo");
	
	doTemp.setHeader(sHeaders);
	doTemp.setAlign("Currency","2");
	
	//设置不可见项
	doTemp.setVisible("ApplyType,OccurType",false);
	doTemp.setUpdateable("ApproveTypeName,CustomerName",false);
	doTemp.setAlign("BusinessSum,RelativeSum","3");
	doTemp.setType("BusinessSum,RelativeSum","Number");
	doTemp.setCheckFormat("BusinessSum,RelativeSum","2");
	//设置html格式
	doTemp.setHTMLStyle("Currency,ClassifyResultName"," style={width:80px} ");
    doTemp.setHTMLStyle("CustomerName"," style={width:200px} ");
    doTemp.setHTMLStyle("VouchTypeName"," style={width:350px} ");
	doTemp.setColumnAttribute("CustomerName,BusinessTypeName,BusinessSum","IsFilter","1");
	doTemp.setFilter(Sqlca,"1","CustomerName","Operators=BeginsWith,EndWith,Contains,EqualsString;");
	doTemp.setFilter(Sqlca,"2","BusinessTypeName","Operators=BeginsWith,EndWith,Contains,EqualsString;");
	doTemp.setFilter(Sqlca,"3","BusinessSum","");
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	String sApproveNeed = "";
	sApproveNeed = CurConfig.getConfigure("ApproveNeed");
	

	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置为Grid风格
	dwTemp.ReadOnly = "1"; //设置为只读
	dwTemp.setPageSize(20); 	//服务器分页

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
		{"true","","Button","申请详情","申请详情","viewTab()",sResourcesPath},
		{"true","","Button","登记合同","登记合同","BookInContract()",sResourcesPath}
		}; 
	if(sDealType.equals("02"))
		sButtons[1][0]="false";
	%>
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script type="text/javascript">

	//---------------------定义按钮事件------------------------------------
	/*~[Describe=登记合同;InputParam=无;OutPutParam=无;]~*/
	function BookInContract()
	{
		//新增申请类型,对象类型两参数,用于额度有效性检查
		sSerialNo   = getItemValue(0,getRow(),"SerialNo");
		sApplyType = getItemValue(0,getRow(),"ApplyType");//申请类型
		sObjectType = "CreditApply";//对象类型
		var sOccurType=getItemValue(0,getRow(),"OccurType");//发生类型，发生类型为“借新还旧”或“展期”不进行额度项下关联额度检查
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
		}else
		{
			/********************add by hwang 20090630,对于额度项下业务增加额度有效性检查*******************************/
			sReturn = autoRiskScan("011","OccurType="+sOccurType+"&ApplyType="+sApplyType+"&ObjectType="+sObjectType+"&ObjectNo="+sSerialNo);
			if(sReturn != true){
				return;
			}
			
			if(!confirm("你确定要根据选中的申请信息登记合同吗？")) 
			{
				return;
			}

		    sReturn = RunJavaMethodTrans("com.amarsoft.app.als.credit.apply.action.InitializeContractFromApply","initialize","ApplySerialNo="+sSerialNo+",UserID=<%=CurUser.getUserID()%>");
		    if(typeof(sReturn)=="undefined" || sReturn.length==0) return;
			alert("根据申请信息生成合同成功，合同流水号["+sReturn+"]！\n\r请继续填写合同要素并“保存”或稍后在“待完成放贷的合同”列表中选择该合同并填写合同要素！");

			sObjectType = "BusinessContract";
			sCompID = "CreditTab";
			sCompURL = "/CreditManage/CreditApply/ObjectTab.jsp";
			sParamString = "ObjectType="+sObjectType+"&ObjectNo="+sReturn;
			OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
			reloadSelf();
		}
	}
    
	/*~[Describe=查看申请详情;InputParam=无;OutPutParam=无;]~*/
	function viewTab()
	{
		sObjectType = "CreditApply";
		sObjectNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		sCompID = "CreditTab";
		sCompURL = "/CreditManage/CreditApply/ObjectTab.jsp";
		sParamString = "ObjectType="+sObjectType+"&ObjectNo="+sObjectNo;
		OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
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
</script>
<%/*~END~*/%>

<%@	include file="/IncludeEnd.jsp"%>