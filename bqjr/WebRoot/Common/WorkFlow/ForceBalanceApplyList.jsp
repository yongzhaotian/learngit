<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
<%
	/*
	Author:   byhu  2004.12.6
	Tester:
	Content: 该页面主要处理业务相关的申请列表，如授信额度申请列表，额度项下业务申请列表，
			 单笔授信业务申请列表
	Input Param:
	Output param:
	History Log: 
		zywei 2005/07/27 重检页面 
		zywei 2007/10/10 修改取消申请的提示语
		zywei 2007/10/10 新增调查报告时，仅低风险业务、授信项下业务、银票贴现业务、综合授信业务、个人客户、
						 中小企业之外的业务才进行调查报告格式保留与否的判断
		zywei 2007/10/10 解决用户打开多个界面进行重复操作而产生的错误
		qfang 2011/06/13 增加判断：如果为"贷款新规适用产品"，则弹出页面，显示业务品种分类的三个标志位字段
	*/
	%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
<%
	String PG_TITLE = "授信方案管理"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=ApplyList;Describe=主体页面;]~*/%>
<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
	<%
	//定义变量
	String sSql = ""; //存放SQL语句
	ASResultSet rs = null; //存放查询结果集
	String sTempletNo = ""; //显示模版ItemNo
	String sPhaseTypeSet = ""; //存放阶段类型组
	String sButton = ""; 
	String sObjectType = ""; //存放对象类型
	String sViewID = ""; //存放查看方式
	String sWhereClause1 = ""; //存放阶段类型强制where子句1
	String sWhereClause2 = ""; //存放阶段类型强制where子句2
	String sInitFlowNo = ""; 
	String sInitPhaseNo = "";
	String sButtonSet = "";
	
	//获得组件参数:申请类型,阶段类型
	String sApplyType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ApplyType"));
	String sPhaseType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("PhaseType"));
	String transactionFilter = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("TransactionFilter",10));
	String sPhaseNo=DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("PhaseNo"));
	System.out.println("sPhaseNo:"+sPhaseNo);
	//将空值转化成空字符串
	if(sApplyType == null) sApplyType = "";
	if(sPhaseType == null) sPhaseType = "";	
	if(transactionFilter == null) transactionFilter = "";
	if(sPhaseNo==null)sPhaseNo="";
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
	<%
	//如果申请类型为ClassifyApply(五级分类申请)，则从PARA_CONFIGURE表中读取五级分类的对象类型，确定其是借据还是合同 add by cbsu 2009-10-28
    String sResultType = CurConfig.getConfigure("ClassifyObjectType");
    /*if("ClassifyApply".equals(sApplyType)) {
        sSql = " select para1 from PARA_CONFIGURE where ObjectType='Classify' and ObjectNo='100'";    
        sResultType = Sqlca.getString(sSql); 
        //如果PARA_CONFIGURE表中没有配置五级分类数据，则直接使用"BusinessDueBill"
        if(!sResultType.equals("BusinessDueBill") && !sResultType.equals("BusinessContract"))
        {
            sResultType = "BusinessDueBill";
        }
    }*/
    
    //销售门店
    String sSNo = CurUser.getAttribute8();
    if(sSNo == null) sSNo = "";
    System.out.println("-------销售门店-------"+sSNo);
    
    
	//根据组件参数(申请类型)从代码表CODE_LIBRARY中获得ApplyMain的树图以及该申请的阶段,流程对象类型,ApplyList使用哪个ButtonSet
	sSql = 	" select ItemDescribe,ItemAttribute,Attribute5 from CODE_LIBRARY "+
			" where CodeNo = 'ApplyType' and ItemNo =:ItemNo ";
	rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("ItemNo",sApplyType));
	if(rs.next()){
		sPhaseTypeSet = rs.getString("ItemDescribe");
		sObjectType = rs.getString("ItemAttribute");
		sButtonSet = rs.getString("Attribute5");
		if(sPhaseTypeSet == null) sPhaseTypeSet = "";
		if(sObjectType == null) sObjectType = "";
		if(sButtonSet == null) sButtonSet = "";
	}else{
		throw new Exception("没有找到相应的申请类型定义（CODE_LIBRARY.ApplyType:"+sApplyType+"）！");
	}
	rs.getStatement().close();
	//根据组件ID和组件参数(阶段类型)从代码表CODE_LIBRARY中查询出显示的按钮,以什么视图查看对象详情,where条件1,where条件2,ApplyList数据对象ID
	sSql = 	" select ItemDescribe,ItemAttribute,Attribute1,Attribute2,Attribute4 "+
			" from CODE_LIBRARY where CodeNo =:CodeNo and ItemNo =:ItemNo ";
	rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("CodeNo",sPhaseTypeSet).setParameter("ItemNo",sPhaseType));
	if(rs.next()){
		sButton = rs.getString("ItemDescribe");
		sViewID = rs.getString("ItemAttribute");
		sWhereClause1 = DataConvert.toString(rs.getString("Attribute1"));
		sWhereClause2 = DataConvert.toString(rs.getString("Attribute2"));		
		sTempletNo = rs.getString("Attribute4");
		
		//将sTempNo按@进行分割 add by cbsu 2009-10-12
		if ("Classify".equals(sObjectType)) {
			String[] sTempletNos = sTempletNo.split("@");
			//根据五级分类对象是借据还是合同来使用不同的模板 add by cbsu 2009-10-12
			if (sTempletNos.length > 1) {
				if ("BusinessDueBill".equals(sResultType)) {
					sTempletNo = sTempletNos[0];
					}
				if ("BusinessContract".equals(sResultType)) {
					sTempletNo = sTempletNos[1];
				}
			}
		}
		
		if(sButton == null) sButton = "";
		if(sViewID == null) sViewID = "";
		if(sWhereClause1 == null) sWhereClause1 = "";
		if(sWhereClause2 == null) sWhereClause2 = "";
		if(sTempletNo == null) sTempletNo = "";
	}else{
		throw new Exception("没有找到相应的申请阶段定义（CODE_LIBRARY,"+sPhaseTypeSet+","+sPhaseType+"）！");
	}
	rs.getStatement().close();
	
	if(sTempletNo.equals("")) throw new Exception("没有定义sTempletNo, 检查CODE_LIBRARY,"+sPhaseTypeSet+","+sPhaseType+"??");
	if(sViewID.equals("")) throw new Exception("没有定义ViewID 检查CODE_LIBRARY,"+sPhaseTypeSet+","+sPhaseType+"??");
	
	//根据组件参数(申请类型)从代码表CODE_LIBRARY中获得默认流程ID
	sSql = " select Attribute2 from CODE_LIBRARY where CodeNo = 'ApplyType' and ItemNo =:ItemNo ";
	rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("ItemNo",sApplyType));
	while(rs.next()){
		sInitFlowNo = rs.getString("Attribute2");
		if(sInitFlowNo == null) sInitFlowNo = "";
	}
	rs.getStatement().close();
	
	//根据默认流程ID从流程表FLOW_CATALOG中获得初始阶段
	sSql = " select InitPhase from FLOW_CATALOG where FlowNo =:FlowNo ";
	rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("FlowNo",sInitFlowNo));
	while(rs.next()){
		sInitPhaseNo = rs.getString("InitPhase");
		if(sInitPhaseNo == null) sInitPhaseNo = "";
	}
	rs.getStatement().close();


	//通过显示模版产生ASDataObject对象doTemp
	String sTempletFilter = "1=1";
	//根据显示模版编号和显示模版过滤条件生成DataObject对象
	ASDataObject doTemp = new ASDataObject(sTempletNo,sTempletFilter,Sqlca);
	//非额度申请,隐藏敞口金额字段,并将BusinessSum列名更新为申请金额
	if(!"CreditLineApply".equals(sApplyType)){
		doTemp.setVisible("ExposureSum",false);
		doTemp.setHeader("BusinessSum","申请金额");
	}
	//设置更新表名和主键
	doTemp.UpdateTable = "FLOW_OBJECT";
	doTemp.setKey("ObjectType,ObjectNo",true);	 //为后面的删除
	//将where条件1和where条件2中的变量用实际的值替换，生成有效的SQL语句
	sWhereClause1 = StringFunction.replace(sWhereClause1,"#UserID",CurUser.getUserID());
	sWhereClause1 = StringFunction.replace(sWhereClause1,"#ApplyType",sApplyType);
	sWhereClause1 = StringFunction.replace(sWhereClause1,"#ObjectType",sObjectType);
	sWhereClause1 = StringFunction.replace(sWhereClause1,"#PhaseType",sPhaseType);
	sWhereClause1 = StringFunction.replace(sWhereClause1,"#TransactionFilter"," TransCode in('"+transactionFilter.replaceAll("@","','")+"')");
	sWhereClause2 = StringFunction.replace(sWhereClause2,"#UserID",CurUser.getUserID());
	sWhereClause2 = StringFunction.replace(sWhereClause2,"#ApplyType",sApplyType);
	sWhereClause2 = StringFunction.replace(sWhereClause2,"#ObjectType",sObjectType);
	sWhereClause2 = StringFunction.replace(sWhereClause2,"#PhaseType",sPhaseType);
	sWhereClause2 = StringFunction.replace(sWhereClause2,"#Stores",sSNo);//添加门店控制
	sWhereClause2 = StringFunction.replace(sWhereClause2,"#TransactionFilter"," TransCode in('"+transactionFilter.replaceAll("@","','")+"')");
	
	
    
	
	//增加空格防止sql语句拼接出错
	doTemp.WhereClause += " "+sWhereClause1;
	doTemp.WhereClause += " "+sWhereClause2;
	//设置ASDataObject中的排序条件
	//doTemp.OrderClause = " order by FLOW_OBJECT.ObjectNo desc ";

	//生成查询框
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));//jgao 2009-10-09修改，查询框内容已在显示模板中配置，
	//doTemp.setFilter(Sqlca,"1","CustomerName","Operators=BeginsWith,EndWith,Contains,EqualsString;");
	//if(!sApplyType.equals("CreditCogApply")){ //信用等级评估申请时不展示
		//doTemp.setFilter(Sqlca,"2","BusinessTypeName","Operators=BeginsWith,EndWith,Contains,EqualsString;");
	//}	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
    dwTemp.setPageSize(20); 

	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sPhaseNo);
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
	String sButtons[][] = new String[100][9];
	int iCountRecord = 0;
	//用于控制单行按钮显示的最大个数
	String iButtonsLineMax = "8";
	//根据按钮集从代码表CODE_LIBRARY中查询到按钮英文名称，属性1，属性2（Button）、按钮中文名称、按钮功能描述、按钮调用javascript函数名称
	sSql = 	" select ItemNo,Attribute1,Attribute2,ItemName,ItemDescribe,RelativeCode "+
			" from CODE_LIBRARY where CodeNo =:CodeNo and IsInUse = '1' Order by SortNo ";
	rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("CodeNo",sButtonSet)); 
	while(rs.next()){
		iCountRecord++;
		sButtons[iCountRecord][0] = (sButton.indexOf(rs.getString("ItemNo"))>=0?"true":"false");
		//sButtons[iCountRecord][0] = "true";
		sButtons[iCountRecord][1] = rs.getString("Attribute1");
		sButtons[iCountRecord][2] = (rs.getString("Attribute2")==null?rs.getString("Attribute2"):"Button");
		sButtons[iCountRecord][3] = rs.getString("ItemName");
		sButtons[iCountRecord][4] = rs.getString("ItemDescribe");
		if(sButtons[iCountRecord][4]==null) sButtons[iCountRecord][4] = sButtons[iCountRecord][3];
		sButtons[iCountRecord][5] = rs.getString("RelativeCode");
		if(sButtons[iCountRecord][5]!=null){
			sButtons[iCountRecord][5] = StringFunction.replace(sButtons[iCountRecord][5],"#ApplyType",sApplyType);
			sButtons[iCountRecord][5] = StringFunction.replace(sButtons[iCountRecord][5],"#PhaseType",sPhaseType);
			sButtons[iCountRecord][5] = StringFunction.replace(sButtons[iCountRecord][5],"#ObjectType",sObjectType);
			sButtons[iCountRecord][5] = StringFunction.replace(sButtons[iCountRecord][5],"#ViewID",sViewID);
		}
		sButtons[iCountRecord][6] = sResourcesPath;
		//add sy syang 2009/10/22 放贷复核通过的申请，在演示模式下，“转入贷后”按钮可见
		if(sApplyType.equals("PutOutApply")){
			if("transToAfterLoan".equals(rs.getString("ItemNo"))){	//匹配按钮
				if(sButton.indexOf(rs.getString("ItemNo"))>=0){ //是否允许显示
					if("Demonstration".equals(sCurRunMode)||"Development".equals(sCurRunMode)){			//允许显示后，判断是否为演示模式
						sButtons[iCountRecord][0] = "true";
					}else{
						sButtons[iCountRecord][0] = "false";
					}
				}
			}
		}
		if(sApplyType.equals("IndependentApply") || sApplyType.equals("CreditLineApply") || sApplyType.equals("DependentApply")){
			if("greenWay".equals(rs.getString("ItemNo"))||"viewFlowGraph".equals(rs.getString("ItemNo"))){	//匹配按钮
				if(sButton.indexOf(rs.getString("ItemNo"))>=0){ //是否允许显示
					if("Demonstration".equals(sCurRunMode)){			//只有在演示模式下才显示绿色通道和查看流程图按钮
						sButtons[iCountRecord][0] = "true";
					}else{
						sButtons[iCountRecord][0] = "false";
					}
				}
			}
		}

	}
	rs.getStatement().close();
	CurPage.setAttribute("ButtonsLineMax",iButtonsLineMax);

	%> 
<%/*~END~*/%>
<%/*~END~*/%>




<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
<script type="text/javascript">
/*~[Describe=新增记录;InputParam=无;OutPutParam=无;]~*/
function newApply(){
	//将jsp中的变量值转化成js中的变量值
	var sObjectType = "<%=sObjectType%>";	
	var sApplyType = "<%=sApplyType%>";	
	var sPhaseType = "<%=sPhaseType%>";
	var sInitFlowNo = "<%=sInitFlowNo%>";
	var sInitPhaseNo = "<%=sInitPhaseNo%>";
	
	//弹出新增申请参数对话框
		sCompID = "ForceBalanceApplyInfo";
		sCompURL = "/Common/WorkFlow/ForceBalanceApplyInfo.jsp";		
	    sReturn=PopComp(sCompID,sCompURL,"ObjectType="+sObjectType+"&ApplyType="+sApplyType+"&PhaseType="+sPhaseType+"&FlowNo="+sInitFlowNo+"&PhaseNo="+sInitPhaseNo,"dialogWidth=750px;dialogHeight=600px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;"); 
	    reloadSelf();
    }
/*~[Describe=签署意见;InputParam=无;OutPutParam=无;]~*/
function signOpinion(){
	//获得申请类型、申请流水号、流程编号、阶段编号
	var sObjectType = getItemValue(0,getRow(),"ObjectType");
	var sObjectNo = getItemValue(0,getRow(),"ObjectNo");
	var sFlowNo = getItemValue(0,getRow(),"FlowNo");
	var sPhaseNo = getItemValue(0,getRow(),"PhaseNo");
	if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
		alert(getHtmlMessage('1'));//请选择一条信息！
		return;
	}
	//获取任务流水号
	var sTaskNo=RunMethod("WorkFlowEngine","GetUnfinishedTaskNo",sObjectType+","+sObjectNo+","+sFlowNo+","+sPhaseNo+","+"<%=CurUser.getUserID()%>");
	if(typeof(sTaskNo)=="undefined" || sTaskNo.length==0) {
		alert(getBusinessMessage('500'));//该申请所对应的流程任务不存在，请核对！
		return;
	}
	var sCompID = "SignTaskOpinionInfo";
	var sCompURL = "/Common/WorkFlow/SignTaskOpinionInfo.jsp";
	popComp(sCompID,sCompURL,"TaskNo="+sTaskNo+"&ObjectType="+sObjectType+"&ObjectNo="+sObjectNo,"dialogWidth=680px;dialogHeight=450px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
}
/*~[Describe=提交;InputParam=无;OutPutParam=无;]~*/
function doSubmit(){
    //获得申请类型、申请流水号、流程编号、阶段编号、申请类型、合同号
    var sObjectType = getItemValue(0,getRow(),"ObjectType");
    var sFlowNo = getItemValue(0,getRow(),"FlowNo");
    var sPhaseNo = getItemValue(0,getRow(),"PhaseNo");
    var sApplyType1 = "<%=sApplyType%>";      
    var sObjectNo = getItemValue(0,getRow(),"ObjectNo");
    var sApplyType = "<%=sApplyType%>";
    if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
        alert(getHtmlMessage('1'));//请选择一条信息！
        return;
    }

    //检查该业务是否已经提交了（解决用户打开多个界面进行重复操作而产生的错误）
    var sNewPhaseNo=RunMethod("WorkFlowEngine","GetPhaseNo",sObjectType+","+sObjectNo);
    if(sNewPhaseNo != sPhaseNo) {
        alert(getBusinessMessage('486'));//该申请已经提交了，不能再次提交！
        reloadSelf();
        return;
    }

    //获取任务流水号
    var sTaskNo=RunMethod("WorkFlowEngine","GetUnfinishedTaskNo",sObjectType+","+sObjectNo+","+sFlowNo+","+sPhaseNo+","+"<%=CurUser.getUserID()%>");
    if(typeof(sTaskNo)=="undefined" || sTaskNo.length==0) {
        alert(getBusinessMessage('500'));//该申请所对应的流程任务不存在，请核对！
        return;
    }
    
    //弹出审批提交选择窗口     增加参数传递，防止重复提交 by yzheng,qxu 2013/6/28
	var sPhaseInfo = PopPage("/Common/WorkFlow/SubmitDialog.jsp?SerialNo="+sTaskNo+"&objectType="+sObjectType+"&objectNo="+sObjectNo+"&oldPhaseNo="+sPhaseNo,"","dialogWidth=580px;dialogHeight=420px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
	if(typeof(sPhaseInfo)=="undefined" || sPhaseInfo=="" || sPhaseInfo==null || sPhaseInfo=="null" || sPhaseInfo=="_CANCEL_") return;
	else if (sPhaseInfo == "Success"){
		alert(getHtmlMessage('18'));//提交成功！
		reloadSelf();
	}else if (sPhaseInfo == "Failure"){
		alert(getHtmlMessage('9'));//提交失败！
		return;
	}else if (sPhaseInfo == "Working"){//by yzheng,qxu 2013/6/28
		alert(getBusinessMessage('486'));//该申请已经提交了，不能再次提交！
		reloadSelf();
		return;
	}else{
		sPhaseInfo = PopPage("/Common/WorkFlow/SubmitDialogSecond.jsp?SerialNo="+sTaskNo+"&PhaseOpinion1="+sPhaseInfo,"","dialogWidth=34;dialogHeight=34;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		//如果提交成功，则刷新页面
		if (sPhaseInfo == "Success"){
			alert(getHtmlMessage('18'));//提交成功！
			reloadSelf();
		}else if (sPhaseInfo == "Failure"){
			alert(getHtmlMessage('9'));//提交失败！
			return;
		}
	}
}
function viewTab(){
	var sObjectNo = getItemValue(0,getRow(),"ObjectNo");
    if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
        alert(getHtmlMessage('1'));//请选择一条信息！
        return;
    }
    sObjectType = "BusinessContract";
    sCompID = "CreditTab";
	sCompURL = "/CreditManage/CreditApply/ObjectTab.jsp";
	sParamString = "ObjectType="+sObjectType+"&ObjectNo="+sObjectNo;
	OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
  	reloadSelf();
}
function viewOpinions(){
	//获得申请类型、申请流水号、流程编号、阶段编号
	var sObjectType = getItemValue(0,getRow(),"ObjectType");
	var sObjectNo = getItemValue(0,getRow(),"ObjectNo");
	var sFlowNo = getItemValue(0,getRow(),"FlowNo");
	var sPhaseNo = getItemValue(0,getRow(),"PhaseNo");
	var sObjectNo = getItemValue(0,getRow(),"ObjectNo");
    if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
        alert(getHtmlMessage('1'));//请选择一条信息！
        return;
    }
    
  	//检查是否签署意见
    var sObjectNo = getItemValue(0,getRow(),"ObjectNo");
    var sObjectType = getItemValue(0,getRow(),"ObjectType");
    var sSerialNo = RunMethod("公用方法", "GetColValue", "Billions_Opinion,SerialNo,ObjectNo='"+sObjectNo+"' and ObjectType='"+sObjectType+"'")
	sReturn = RunMethod("公用方法", "GetCountByWhereClause", "Flow_Opinion,OpinionNo,ObjectNo='"+sObjectNo+"'");
	if(sReturn<=0) {
		//alert(getBusinessMessage('501'));//该业务未签署意见,不能提交,请先签署意见！
		alert("该笔申请还未签署意见！");
		return;
	}
	
	popComp("ViewFlowOpinions","/Common/WorkFlow/ViewFlowOpinions.jsp","FlowNo="+sFlowNo+"&PhaseNo=0010&ObjectType="+sObjectType+"&ObjectNo="+sObjectNo,"");
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


<%@ include file="/IncludeEnd.jsp"%>

