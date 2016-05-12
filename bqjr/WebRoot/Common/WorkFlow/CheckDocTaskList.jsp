<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main00;Describe=注释区;]~*/%>
    <%
    /*
		Author:  xswang 2015/05/25
		Tester:
		Content: 文件质量检查
		Input Param:
		Output param:
		History Log: 
 	*/
    %>
<%/*~END~*/%>


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

	String sButtonSet = "";

	
	//获得组件参数:申请类型,阶段类型
	String sApplyType = "CreditLineApply";
	String sPhaseType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("PhaseType"));
	String sFinishFlag = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("FinishFlag"));
	String sApproveType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ApproveType"));
	//将空值转化成空字符串
	if(sApplyType == null) sApplyType = "";
	if(sPhaseType == null) sPhaseType = "";	
	if(sFinishFlag == null) sFinishFlag = "";

	//获得合同取消时的显示参数,合同取消时新增"取消原因"，"取消类型"的显示

	
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
	<%
	//如果申请类型为ClassifyApply(五级分类申请)，则从PARA_CONFIGURE表中读取五级分类的对象类型，确定其是借据还是合同
    String sResultType = CurConfig.getConfigure("ClassifyObjectType");
    
    //销售门店
    String sSNo = CurUser.getAttribute8();
    if(sSNo == null) sSNo = "";
    
	//根据组件参数(申请类型)从代码表CODE_LIBRARY中获得ApplyMain的树图以及该申请的阶段,流程对象类型,ApplyList使用哪个ButtonSet
	sSql = 	" select ItemDescribe,ItemAttribute,Attribute5 from CODE_LIBRARY "+
			" where CodeNo = 'ApproveType' and ItemNo =:ItemNo ";
	rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("ItemNo",sApproveType));
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
	rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("CodeNo",sPhaseTypeSet).setParameter("ItemNo",sFinishFlag));
	if(rs.next()){
		sButton = rs.getString("ItemDescribe");
		sViewID = rs.getString("ItemAttribute");
		sWhereClause1 = DataConvert.toString(rs.getString("Attribute1"));
		sWhereClause2 = DataConvert.toString(rs.getString("Attribute2"));		
		sTempletNo = rs.getString("Attribute4");
		
		//将sTempNo按@进行分割 
		if ("Classify".equals(sObjectType)) {
			String[] sTempletNos = sTempletNo.split("@");
			//根据五级分类对象是借据还是合同来使用不同的模板
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


	



	//通过显示模版产生ASDataObject对象doTemp
	String sTempletFilter = "1=1";
	//根据显示模版编号和显示模版过滤条件生成DataObject对象
	ASDataObject doTemp = new ASDataObject(sTempletNo,sTempletFilter,Sqlca);
	//非额度申请,隐藏敞口金额字段,并将BusinessSum列名更新为申请金额

	
	if(sFinishFlag.equals("N")) //褰撳墠宸ヤ綔
		sButton = "getTask,checkDoc,doSubmit";
	System.out.println(sButton);
	if(sFinishFlag.equals("Y") && CurUser.hasRole("2040")) //宸插畬鎴愬伐浣?
		sButton = "updateDocOpinion,doSubmit";

	if(sButton == null) sButton = "";
	
	//设置更新表名和主键

	//将where条件1和where条件2中的变量用实际的值替换，生成有效的SQL语句
	sWhereClause1 = StringFunction.replace(sWhereClause1,"#UserID",CurUser.getUserID());
	if(sFinishFlag.equals("Y") && CurUser.hasRole("2040")){
		
	}else {
		sWhereClause1 += " and (Check_Contract.GetTaskUserID1='#UserID' or Check_Contract.GetTaskUserID2='#UserID') ";
		sWhereClause1 = StringFunction.replace(sWhereClause1,"#UserID",CurUser.getUserID());
	}


   
	
	//增加空格防止sql语句拼接出错
	doTemp.WhereClause += " "+sWhereClause1;
	doTemp.WhereClause += " "+sWhereClause2;
	

	
	//生成查询框
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));//查询框内容已在显示模板中配置，
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
    dwTemp.setPageSize(20); 
	//删除当前的业务信息 

	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("'"+sApplyType+"','"+sPhaseType+"','"+CurUser.getUserID()+"'");
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
	
	
	
	
		
	}
	rs.getStatement().close();
	CurPage.setAttribute("ButtonsLineMax",iButtonsLineMax);

	%> 
<%/*~END~*/%>