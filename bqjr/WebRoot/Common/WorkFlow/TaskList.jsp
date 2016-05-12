<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   byhu  2004.12.6
		Tester:
		Content: 该页面主要处理业务申请相关的审查审批、最终审批意见复核、放贷申请复核
		Input Param:
			ApproveType:审批对象			
			PhaseType：阶段类型
			FlowNo：流程模型编号
			PhaseNo：阶段编号
			FinishFlag：完成标志（Y：已完成；N：未完成）
		Output param:
		History Log: 
			2005.08.03 jbye    重新修改流程审查相关信息
			2005.08.05 zywei   重检页面
			2006.02.21 zywei   将审查审批列表上的按钮配置从数据表CODE_LIBRARY中字段ItemDescribe移到数据表FLOW_MODEL中字段Attribute1，Attribute2
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量：SQL语句、模版ItemNo、阶段类型组、对象对应阶段、阶段类型强制where子句1、阶段类型强制where子句2
	String sSql = "",sTempletNo = "",sPhaseTypeSet = "",sViewID = "",sWhereClause1 = "",sWhereClause2 = "";     
	//定义变量：按钮集、按钮、申请流程对象
	String sButtonSet = "",sButton = "",sObjectType = "";
	//定义变量：查询结果集，五级分类是借据或合同
	ASResultSet rs = null;
	String sResultType = "";
	
	//获得组件参数:流程对象类型、申请类型、流程编号、阶段编号、阶段类型、完成标志
	String sApproveType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ApproveType"));
	String sFlowNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("FlowNo")); 
	String sPhaseNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("PhaseNo")); 
	String sPhaseType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("PhaseType")); 
	String sFinishFlag = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("FinishFlag"));
	String transactionFilter = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("TransactionFilter",10));
	
	//将空值转化成空字符串
	if(sApproveType == null) sApproveType = "";	
	if(sFlowNo == null) sFlowNo = "";
	if(sPhaseNo == null) sPhaseNo = "";	
	if(sPhaseType == null) sPhaseType = "";
	if(sFinishFlag == null) sFinishFlag = "";
	if(transactionFilter == null) transactionFilter = "";
	
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
	<%
	//从代码表CODE_LIBRARY中获得ApproveMain的树图以及该申请的阶段,流程对象类型,TaskList使用哪个ButtonSet
	sSql = 	" select ItemDescribe,ItemAttribute,Attribute5 from CODE_LIBRARY "+
			" where CodeNo = 'ApproveType' and ItemNo = :ItemNo ";
	rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("ItemNo",sApproveType));
	if(rs.next()){
		sPhaseTypeSet = rs.getString("ItemDescribe");
		sObjectType = rs.getString("ItemAttribute");
		sButtonSet = rs.getString("Attribute5");
		if(sPhaseTypeSet == null) sPhaseTypeSet = "";
		if(sObjectType == null) sObjectType = "";
		if(sButtonSet == null) sButtonSet = "";
	}else{
		throw new Exception("没有找到相应的审批类型定义（CODE_LIBRARY.ApproveType:"+sApproveType+"）！");
	}
	rs.getStatement().close();
	
	//从代码表CODE_LIBRARY中查询出以什么视图查看对象详情,where条件1,where条件2,ApplyList数据对象ID		
	sSql = 	" select ItemAttribute,Attribute1,Attribute2,Attribute4 "+
			" from CODE_LIBRARY where CodeNo = :CodeNo and ItemNo = :ItemNo ";	
	rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("CodeNo",sPhaseTypeSet).setParameter("ItemNo",sFinishFlag));
	if(rs.next()){				
		sViewID = rs.getString("ItemAttribute");
		sWhereClause1 = DataConvert.toString(rs.getString("Attribute1"));
		sWhereClause2 = DataConvert.toString(rs.getString("Attribute2"));		
		sTempletNo = rs.getString("Attribute4");
		
		//如果审批类型为ClassifyApprove(五级分类审批)，则从PARA_CONFIGURE表中读取五级分类的对象类型，确定其是借据还是合同 add by cbsu 2009-10-28
	    if("ClassifyApprove".equals(sApproveType)) {
	    	sResultType = CurConfig.getConfigure("ClassifyObjectType");
	        /* sSql = " select para1 from PARA_CONFIGURE where ObjectType='Classify' and ObjectNo='100'";
	        sResultType = Sqlca.getString(sSql);
	        //如果PARA_CONFIGURE表中没有配置五级分类数据，则直接使用"BusinessDueBill"
	        if(!sResultType.equals("BusinessDueBill") && !sResultType.equals("BusinessContract"))
	        {
	            sResultType = "BusinessDueBill";
	        } */
	    }
		
		//将sTempNo按@进行分割 add by cbsu 2009-10-13
        if ("Classify".equals(sObjectType)) {
            String[] sTempletNos = sTempletNo.split("@");
            //根据五级分类对象是借据还是合同来使用不同的模板 add by cbsu 2009-10-13
            if (sTempletNos.length > 1) {
                if ("BusinessDueBill".equals(sResultType)) {
                    sTempletNo = sTempletNos[0];
                    }
                if ("BusinessContract".equals(sResultType)) {
                    sTempletNo = sTempletNos[1];
                }
            }
        }		
		
		//将空值转化成空字符串		
		if(sViewID == null) sViewID = "";
		if(sWhereClause1 == null) sWhereClause1 = "";
		if(sWhereClause2 == null) sWhereClause2 = "";
		if(sTempletNo == null) sTempletNo = "";
	}else{		
		throw new Exception("没有找到相应的审批阶段定义（CODE_LIBRARY,"+sSql+","+sFinishFlag+"）！");
	}
	rs.getStatement().close();
	
	if(sTempletNo.equals("")) throw new Exception("没有定义任务列表数据对象（CODE_LIBRARY.ApproveType:"+sApproveType+"）！");
	if(sViewID.equals("")) throw new Exception("没有定义审批阶段视图（CODE_LIBRARY,"+sPhaseTypeSet+","+sFinishFlag+"）！");
		
	//add by zywei 2006/02/21 根据完成标志来获取相应流程编号、相应阶段编号应显示的功能按钮
	if(sFinishFlag.equals("N")) //当前工作
		sButton = Sqlca.getString("select Attribute1 from FLOW_MODEL where FlowNo = '"+sFlowNo+"' and PhaseNo = '"+sPhaseNo+"'");
	System.out.println(sButton);
	if(sFinishFlag.equals("Y")) //已完成工作
		sButton = Sqlca.getString("select Attribute2 from FLOW_MODEL where FlowNo = '"+sFlowNo+"' and PhaseNo = '"+sPhaseNo+"'");
	//将空值转化成空字符串
	if(sButton == null) sButton = "";
			
	//通过显示模版产生ASDataObject对象doTemp
	String sTempletFilter = "1=1";
	//根据显示模版编号和显示模版过滤条件生成DataObject对象
	ASDataObject doTemp = new ASDataObject(sTempletNo,sTempletFilter,Sqlca);
	//设置更新表名和主键
	doTemp.UpdateTable = "FLOW_TASK";
	doTemp.setKey("SerialNo",true);	 //为后面的删除
	//将where条件1和where条件2中的变量用实际的值替换，生成有效的SQL语句
	sWhereClause1 = StringFunction.replace(sWhereClause1,"#UserID",CurUser.getUserID());
	sWhereClause1 = StringFunction.replace(sWhereClause1,"#PhaseNo",sPhaseNo);
	sWhereClause1 = StringFunction.replace(sWhereClause1,"#FlowNo",sFlowNo);
	sWhereClause1 = StringFunction.replace(sWhereClause1,"#ObjectType",sObjectType);
	sWhereClause1 = StringFunction.replace(sWhereClause1,"#TransactionFilter"," TransCode in('"+transactionFilter.replaceAll("@","','")+"')");
	sWhereClause2 = StringFunction.replace(sWhereClause2,"#UserID",CurUser.getUserID());
	sWhereClause2 = StringFunction.replace(sWhereClause2,"#PhaseNo",sPhaseNo);
	sWhereClause2 = StringFunction.replace(sWhereClause2,"#FlowNo",sFlowNo);
	sWhereClause2 = StringFunction.replace(sWhereClause2,"#ObjectType",sObjectType);
	sWhereClause2 = StringFunction.replace(sWhereClause2,"#TransactionFilter"," TransCode in('"+transactionFilter.replaceAll("@","','")+"')");
	
	//在做五级分类审批时对SQL语句中的TableSerialNo参数进行替换  add by cbsu 2009-10-29
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
	
	//增加空格防止sql语句拼接出错
	doTemp.WhereClause += " "+sWhereClause1;
	doTemp.WhereClause += " "+sWhereClause2;
	//TODO 暂在这里添加flowNo
	doTemp.WhereClause += "and flowNo ='"+ sFlowNo + "'"; 
	//设置ASDataObject中的排序条件
	//doTemp.OrderClause = " order by FLOW_TASK.SerialNo desc ";
	
	doTemp.setAlign("CurrencyName,OccurTypeName","2");
	doTemp.setType("BusinessSum","Number");
	doTemp.setCheckFormat("BusinessSum","2");
	//生成查询框
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	//if(!sApproveType.equals("CreditCogApprove")){ //信用等级评估审批时不展示
		//doTemp.setFilter(Sqlca,"1","BusinessTypeName","Operators=BeginsWith,EndWith,Contains,EqualsString;");
	//}
	//doTemp.setFilter(Sqlca,"2","CustomerName","Operators=BeginsWith,EndWith,Contains,EqualsString;");

	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
    dwTemp.setPageSize(20);
		
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("'','"+sPhaseType+"','"+CurUser.getUserID()+"'");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	//out.println(doTemp.SourceSql); //常用这句话调试datawindow装载数据的SQL语句
	System.out.println(sPhaseNo+"---------------");
	%>
<%/*~END~*/%>



<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List04;Describe=定义按钮;]~*/%>
	<%
	String sButtons[][] = new String[100][9];
	int iCountRecord = 0;
	sSql = " select * from CODE_LIBRARY where CodeNo = :CodeNo and IsInUse = '1' Order by SortNo ";
	rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("CodeNo",sButtonSet));
	while(rs.next()){	
		iCountRecord++;
		sButtons[iCountRecord][0] = (sButton.indexOf(rs.getString("ItemNo"))>=0?"true":"false");
		sButtons[iCountRecord][1] = rs.getString("Attribute1");
		sButtons[iCountRecord][2] = (rs.getString("Attribute2")==null?rs.getString("Attribute2"):"Button");
		sButtons[iCountRecord][3] = rs.getString("ItemName");
		sButtons[iCountRecord][4] = rs.getString("ItemDescribe");
		if(sButtons[iCountRecord][4]==null) sButtons[iCountRecord][4] = sButtons[iCountRecord][3];
		sButtons[iCountRecord][5] = rs.getString("RelativeCode");
		if(sButtons[iCountRecord][5]!=null){
			sButtons[iCountRecord][5] = StringFunction.replace(sButtons[iCountRecord][5],"#ApplyType",sObjectType);
			sButtons[iCountRecord][5] = StringFunction.replace(sButtons[iCountRecord][5],"#PhaseType",sPhaseType);
			sButtons[iCountRecord][5] = StringFunction.replace(sButtons[iCountRecord][5],"#ObjectType",sObjectType);
			sButtons[iCountRecord][5] = StringFunction.replace(sButtons[iCountRecord][5],"#ViewID",sViewID);
		} 
		sButtons[iCountRecord][6] = sResourcesPath;
		if(sApproveType.equals("ApproveCreditApply")){
			if("viewFlowGraph".equals(rs.getString("ItemNo"))){	//匹配按钮
					if("Demonstration".equals(sCurRunMode)){			//只有在演示模式下才显示查看流程图按钮
						sButtons[iCountRecord][0] = "true";
					}else{
						sButtons[iCountRecord][0] = "false";
					}
				}
			}
	}
	rs.getStatement().close();
	 
	%> 
<%/*~END~*/%>
