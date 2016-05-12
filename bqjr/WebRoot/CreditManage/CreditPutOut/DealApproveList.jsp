<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author: cchang 2004-12-06
		Tester:
		Describe: 对最终审批意见进行登记;
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
	String PG_TITLE = "最终审批意见列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%
	//定义变量
	String sCondition="";	
    String sWhereCond = "";
	//获得组件参数
	String sDealType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("DealType"));
%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%
	//where语句统一修改处，涉及业务不配在模板中				
	sWhereCond	= " where OperateUserID ='"+CurUser.getUserID()+"' and ApproveType = '01' "+
			                   " and SerialNo in (select ObjectNo from FLOW_OBJECT where FlowNo='ApproveFlow' "+
			                   " and PhaseNo='1000') ";
	
	//通过DW模型产生ASDataObject对象doTemp
	String sTempletNo = "DealApproveList";//模型编号
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);

	if(sDealType.equals("01")){
		sCondition = " and Flag5 = '010' ";
	}
	else if(sDealType.equals("02")){
		sCondition = " and Flag5 = '020' ";
	}
	doTemp.WhereClause = doTemp.WhereClause + sWhereCond + sCondition;

	doTemp.setKeyFilter("SerialNo");
	//增加过滤器 
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));

	//产生datawindows
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置为Grid风格
	dwTemp.ReadOnly = "1"; //设置为只读
	dwTemp.setPageSize(20); 	//服务器分页

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
		{"true","","Button","最终审批意见详情","最终审批意见详情","viewTab()",sResourcesPath},
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
		sObjectType = "ApproveApply";//对象类型
		var sOccurType=getItemValue(0,getRow(),"OccurType");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
		}else
		{
			/********************add by hwang 20090630,对于额度项下业务增加额度有效性检查*******************************/
			sReturn = autoRiskScan("010","OccurType="+sOccurType+"&ApplyType="+sApplyType+"&ObjectType="+sObjectType+"&ObjectNo="+sSerialNo);
			if(sReturn != true){
				return;
			}
			
			if(!confirm("你确定要根据选中的电子最终审批意见登记合同吗？ \n\r确定后将根据最终审批意见生成合同！")) 
			{
				return;
			}

		    sReturn = RunJavaMethodTrans("com.amarsoft.app.als.credit.contract.action.InitializeContract","initialize","ApproveSerialNo="+sSerialNo+",UserID=<%=CurUser.getUserID()%>");
		    if(typeof(sReturn)=="undefined" || sReturn.length==0) return;
			alert("根据最终审批意见生成合同成功，合同流水号["+sReturn+"]！\n\r请继续填写合同要素并“保存”或稍后在“待完成放贷的合同”列表中选择该合同并填写合同要素！");

			sObjectType = "BusinessContract";
			sCompID = "CreditTab";
			sCompURL = "/CreditManage/CreditApply/ObjectTab.jsp";
			sParamString = "ObjectType="+sObjectType+"&ObjectNo="+sReturn;
			OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
			reloadSelf();
		}
	}
    
	/*~[Describe=查看最终审批意见详情;InputParam=无;OutPutParam=无;]~*/
	function viewTab()
	{
		sObjectType = "ApproveApply";
		sObjectNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		sCompID = "CreditTab";
		sCompURL = "/CreditManage/CreditApply/ObjectTab.jsp";
		sParamString = "ObjectType="+sObjectType+"&ObjectNo="+sObjectNo;
		OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);//sApproveNeed是否登记最终审批意见：true-登记，false-不登记
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