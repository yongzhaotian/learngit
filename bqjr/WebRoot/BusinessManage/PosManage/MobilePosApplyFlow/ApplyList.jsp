<%@ page contentType="text/html; charset=GBK"%>
<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
	Content: 该页面主要处理业务相关的申请列表，如授信额度申请列表，额度项下业务申请列表，
			 单笔授信业务申请列表，最终审批意见登记列表、出帐申请列表
	Input Param:
		ApplyType：申请类型
			—CreditLineApply/授信额度申请
			—DependentApply/额度项下申请	
			—IndependentApply/单笔授信业务申请	
			—ApproveApply/待提交复核最终审批意见
			—PutOutApply/待提交审核出帐
		PhaseType：阶段类型
			—1010/待提交阶段（初始阶段）
	Output param:
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
	String sInitFlowNo = ""; 
	String sInitPhaseNo = "";
	String sButtonSet = "";
	
	//获得组件参数:申请类型,阶段类型
	String sApplyType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ApplyType"));
	String sPhaseType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("PhaseType"));
	//将空值转化成空字符串
	if(sApplyType == null) sApplyType = "";
	if(sPhaseType == null) sPhaseType = "";	
	
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
	<%
	//如果申请类型为ClassifyApply(五级分类申请)，则从PARA_CONFIGURE表中读取五级分类的对象类型，确定其是借据还是合同 add by cbsu 2009-10-28

    
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
	//设置更新表名和主键
	doTemp.UpdateTable = "FLOW_OBJECT";
	doTemp.setKey("ObjectType,ObjectNo",true);	 //为后面的删除
	//将where条件1和where条件2中的变量用实际的值替换，生成有效的SQL语句
	sWhereClause1 = StringFunction.replace(sWhereClause1,"#UserID",CurUser.getUserID());
	sWhereClause1 = StringFunction.replace(sWhereClause1,"#ApplyType",sApplyType);
	sWhereClause1 = StringFunction.replace(sWhereClause1,"#ObjectType",sObjectType);
	sWhereClause1 = StringFunction.replace(sWhereClause1,"#PhaseType",sPhaseType);
	sWhereClause2 = StringFunction.replace(sWhereClause2,"#UserID",CurUser.getUserID());
	sWhereClause2 = StringFunction.replace(sWhereClause2,"#ApplyType",sApplyType);
	sWhereClause2 = StringFunction.replace(sWhereClause2,"#ObjectType",sObjectType);
	sWhereClause2 = StringFunction.replace(sWhereClause2,"#PhaseType",sPhaseType);
	
	/*
	//在做五级分类申请时对SQL语句进行拼接  add by cbsu 2009-10-29
    if ("Classify".equals(sObjectType)) {
        String sTableSerialNo = "";
        if ("BusinessDueBill".equals(sResultType)) {
        	sTableSerialNo = "BUSINESS_DUEBILL.SerialNo";
        }
        if ("BusinessContract".equals(sResultType)) {
        	sTableSerialNo = "BUSINESS_CONTRACT.SerialNo";
        }
        sWhereClause1 = StringFunction.replace(sWhereClause1,"#TableSerialNo",sTableSerialNo);
        sWhereClause2 = StringFunction.replace(sWhereClause2,"#TableSerialNo",sTableSerialNo);
    }
	*/
	//增加空格防止sql语句拼接出错
	doTemp.WhereClause += " "+sWhereClause1;
	doTemp.WhereClause += " "+sWhereClause2;
	//设置ASDataObject中的排序条件

	//生成查询框
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
    dwTemp.setPageSize(20); 
	//删除当前的业务信息 
	if(sObjectType.equals("CreditApply") || sObjectType.equals("ApproveApply") || sObjectType.equals("BusinessContract")){
		dwTemp.setEvent("AfterDelete","!BusinessManage.AddCLInfoLog(#ObjectType,#ObjectNo,Delete,#UserID,#OrgID)+!WorkFlowEngine.DeleteTask(#ObjectType,#ObjectNo,DeleteTask)");
	}else if(sObjectType.equals("Reserve")){
		//增加减值准备删除的操作逻辑，add by syang 2009-10-10
		dwTemp.setEvent("AfterDelete","!ReserveManage.ReserveCancelApply(#ObjectNo)+!WorkFlowEngine.DeleteTask(#ObjectType,#ObjectNo,DeleteReserve)");
	}else if(sObjectType.equals("Classify")){
		//增加删除五级分类删除的操作逻辑，add by cbsu 2009-10-12
        dwTemp.setEvent("AfterDelete","!WorkFlowEngine.DeleteTask(#ObjectType,#ObjectNo,DeleteClassify)");
	}else if(sObjectType.equals("TransformApply")){
        //增加删除担保合同变更的操作逻辑
		dwTemp.setEvent("AfterDelete","!WorkFlowEngine.DeleteTask(#ObjectType,#ObjectNo,DeleteGuarantyTransform)");
	}else{
		dwTemp.setEvent("AfterDelete","!WorkFlowEngine.DeleteTask(#ObjectType,#ObjectNo,DeleteTask)");
	}
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("'"+sApplyType+"','"+sPhaseType+"','"+CurUser.getUserID()+"'");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	if(sApplyType.equals("PutOutApply")){
		dwTemp.setEvent("AfterDelete","!WorkFlowEngine.DeleteTask(#ObjectType,#ObjectNo,DeletePutoutTask)");
	}
	if(sApplyType.equals("PaymentApply")){
		dwTemp.setEvent("AfterDelete","!WorkFlowEngine.DeleteTask(#ObjectType,#ObjectNo,DeletePaymentApply)");
	}
	//add end
	
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