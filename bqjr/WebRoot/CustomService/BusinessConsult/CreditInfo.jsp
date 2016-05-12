<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%@page import="com.amarsoft.app.bizmethod.*,com.amarsoft.app.accounting.businessobject.BUSINESSOBJECT_CONSTATNTS"%>



<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main00;Describe=注释区;]~*/%>
<%
	/*
		Author:   jytian  2004/12/12
		Tester:
		Content: 业务基本信息
		Input Param:
				 ObjectType：对象类型
				 ObjectNo：对象编号
		Output param:
		History Log: zywei 2005/08/03 重检页面
		             pwang 2009/08/13 修改页面显示，让默认币种显示
		             djia  2009/10/21 增加获取展期借据的借据号信息，让Business_Apply保存借据号信息
	 */
	%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info01;Describe=定义页面属性;]~*/%>
<%
	String PG_TITLE = "业务基本信息"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info02;Describe=定义变量，获取参数;]~*/%>
<%
	//定义变量：对象主表名、对应关联表名、SQL语句、产品类型、客户代码、显示属性、产品版本
	String sMainTable = "",sRelativeTable = "",sSql = "",sBusinessType = "",sCustomerID = "",sColAttribute = "",sThirdParty="0.0",sProductVersion="";
	//定义变量：查询列名、显示模版名称、申请类型、发生类型、暂存标志
	String sFieldName = "",sDisplayTemplet = "",sApplyType = "",sOccurType = "",sTempSaveFlag = "",sProductid="",sProductcategoryname="",sProductcategoryId="";
	//定义变量：关联业务币种、关联业务到期日、关联流水号、借据号
	String sOldBusinessCurrency = "",sOldMaturity = "",sRelativeSerialNo = "",dOldSerialNo = "",ssSno="",sSname="",sServiceprovidersname="",sGenusgroup="",sCarfactoryid="";
	//定义变量：关联业务金额、关联业务利率、关联业务余额
	double dOldBusinessSum = 0.0,dOldBusinessRate = 0.0,dOldBalance = 0.0,dThirdPartyRatio=0.0,dThirdParty=0.0;
	//定义变量：展期次数、借新还旧次数、还旧借新次数、债务重组次数
	int iExtendTimes = 0,iLNGOTimes = 0,iGOLNTimes = 0,iDRTimes = 0,dTermDay=0;
	//定义变量：查询结果集
	ASResultSet rs = null;
	
	//获得页面参数	
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));	
	String sObjectNo =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	
	String sApproveNeed =  CurConfig.getConfigure("ApproveNeed");
	
	//将空值转化成空字符串
	if(sObjectType == null) sObjectType = "";
	if(sObjectNo == null) sObjectNo = "";
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info03;Describe=定义数据对象;]~*/%>
<%	
  /*  sSql = "select ProductID from business_contract where serialno =:ObjectNo ";
	rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("ObjectNo",sObjectNo));
	if(rs.next()){
		sProductid = DataConvert.toString(rs.getString("ProductID"));
	
		//将空值转化成空字符串
		if(sProductid == null) sProductid = "";
	
	}
	rs.getStatement().close(); 

    //设置商品范畴和商品类型
    sSql = "select ProductcategoryId,ProductcategoryName from product_category where productcategoryid in (select productcategory from business_type where typeno =:ProductID) ";
	rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("ProductID",sProductid));
	if(rs.next()){
		sProductcategoryId = DataConvert.toString(rs.getString("ProductcategoryId"));
		sProductcategoryname = DataConvert.toString(rs.getString("ProductcategoryName"));
		
		//将空值转化成空字符串
		if(sProductcategoryname == null) sProductcategoryname = "";
		if(sProductcategoryId == null) sProductcategoryId = "";
	}
	rs.getStatement().close();
*/
    
     //销售门店
     String sSNo = CurARC.getAttribute(request.getSession().getId()+"city");
     System.out.println("-------销售门店-------"+sSNo);
     
     sSql="select sno,sname from store_info where sno = :sno";
     rs=Sqlca.getASResultSet(new SqlObject(sSql).setParameter("sno",sSNo));
     if(rs.next()){
    	 ssSno = DataConvert.toString(rs.getString("sno"));
    	 sSname = DataConvert.toString(rs.getString("sname"));
    	 
 		//将空值转化成空字符串
 		if(ssSno == null) ssSno = "";
 		if(sSname == null) sSname = "";
     }
     rs.getStatement().close();
     
     //汽车贷款处理
     sSql="select si.sno as sno,si.sname as sname,sp.serviceprovidersname as serviceprovidersname,sp.genusgroup as genusgroup,sp.carfactoryid as carfactoryid from store_info si,service_providers sp where si.rserialno=sp.serialno and si.identtype='02' and sp.customertype1='07' and si.sno=:sno";
     rs=Sqlca.getASResultSet(new SqlObject(sSql).setParameter("sno",sSNo));
     if(rs.next()){
    	 ssSno = DataConvert.toString(rs.getString("sno"));
    	 sSname = DataConvert.toString(rs.getString("sname"));
    	 sServiceprovidersname = DataConvert.toString(rs.getString("serviceprovidersname"));
    	 sGenusgroup = DataConvert.toString(rs.getString("genusgroup"));
    	 sCarfactoryid = DataConvert.toString(rs.getString("carfactoryid"));
    	 
 		//将空值转化成空字符串
 		if(ssSno == null) ssSno = "";
 		if(sSname == null) sSname = "";
 		if(sServiceprovidersname == null) sServiceprovidersname = "";
 		if(sGenusgroup == null) sGenusgroup = "";
 		if(sCarfactoryid == null) sCarfactoryid = "";
     }
     rs.getStatement().close();
     
     

	//根据对象类型从对象类型定义表中查询到相应对象的主表名
	sSql = " select ObjectTable,RelativeTable from OBJECTTYPE_CATALOG where ObjectType =:ObjectType ";
	rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("ObjectType",sObjectType));
	if(rs.next()){
		sMainTable = DataConvert.toString(rs.getString("ObjectTable"));
		sRelativeTable = DataConvert.toString(rs.getString("RelativeTable"));
				
		//将空值转化成空字符串
		if(sMainTable == null) sMainTable = "";
		if(sRelativeTable == null) sRelativeTable = "";		
	}
	rs.getStatement().close(); 
	
	//从业务表中获得业务品种
	sSql = "select ApplyType,RelativeSerialNo,CustomerID,BusinessType,OccurType,TempSaveFlag,ProductVersion from "+sMainTable+" where SerialNo =:SerialNo ";
	rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("SerialNo",sObjectNo));
	if(rs.next()){
		sApplyType = DataConvert.toString(rs.getString("ApplyType"));
		sRelativeSerialNo = DataConvert.toString(rs.getString("RelativeSerialNo"));
		sCustomerID = DataConvert.toString(rs.getString("CustomerID"));
		sBusinessType = DataConvert.toString(rs.getString("BusinessType"));
		sOccurType = DataConvert.toString(rs.getString("OccurType"));
		sTempSaveFlag = DataConvert.toString(rs.getString("TempSaveFlag"));
		sProductVersion = DataConvert.toString(rs.getString("ProductVersion"));
		
		//将空值转化成空字符串
		if(sApplyType == null) sApplyType = "";
		if(sRelativeSerialNo == null) sRelativeSerialNo = "";
		if(sCustomerID == null) sCustomerID = "";
		if(sBusinessType == null) sBusinessType = "";
		if(sOccurType == null) sOccurType = "";
		if(sTempSaveFlag == null) sTempSaveFlag = "";
	}
	rs.getStatement().close(); 
	
	//从表BUSINESS_APPLY中取ISLIQUIDITY和ISFIXED的值
	BizSort bizSort = new BizSort(Sqlca,sObjectType,sObjectNo,sApproveNeed,sBusinessType);
	boolean isLiquidity = bizSort.isLiquidity();
	boolean isFixed = bizSort.isFixed();
		
	//如果业务品种为空,则显示短期流动资金贷款
	if (sBusinessType.equals(""	)) sBusinessType = "1010010";
	
	//在业务对象为申请时才执行如下业务逻辑
	if(sObjectType.equals("CreditApply")){
		//根据发生类型（系统暂处理展期、借新还旧、还旧借新、债务重组四种类型）获取相应的关联业务信息
		if(sOccurType.equals("015") || sOccurType.equals("060")){ //展期、借新还旧、还旧借新
			//获取展期合同（/借据）的借据号、金额、余额、利率、币种、到期日、展期次数、借新还旧次数、还旧借新次数、债务重组次数等信息
			sSql = 	" select SerialNo,BusinessSum,Balance,BusinessRate,BusinessCurrency,Maturity,ExtendTimes,RenewTimes as LNGOTimes,GOLNTimes,ReorgTimes as DRTimes "+ //按照借据
					//" from BUSINESS_CONTRACT "+ //按照合同
					" from BUSINESS_DUEBILL "+ //按照借据
					" where SerialNo = (select ObjectNo "+
					" from "+sRelativeTable+" "+
					//" where ObjectType = 'BusinessContract' "+ //按照合同
					" where ObjectType = 'BusinessDueBill' "+ //按照借据
					" and SerialNo =:SerialNo) ";
			rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("SerialNo",sObjectNo));
			if(rs.next()){
				dOldSerialNo = DataConvert.toString(rs.getString("SerialNo"));
				dOldBusinessSum = rs.getDouble("BusinessSum");
				dOldBalance = rs.getDouble("Balance");
				dOldBusinessRate = rs.getDouble("BusinessRate");			
				sOldBusinessCurrency = DataConvert.toString(rs.getString("BusinessCurrency"));
				sOldMaturity = DataConvert.toString(rs.getString("Maturity"));
				iExtendTimes = rs.getInt("ExtendTimes");
				iLNGOTimes = rs.getInt("LNGOTimes");
				iGOLNTimes = rs.getInt("GOLNTimes");
				iDRTimes = rs.getInt("DRTimes");
							
				//将空值转化成空字符串					
				if(sOldBusinessCurrency == null) sOldBusinessCurrency = "";
				if(sOldMaturity == null) sOldMaturity = "";
			}
			rs.getStatement().close(); 		
		}else if(sOccurType.equals("030")){ //债务重组
			//获取资产重组方案编号
			sSql = 	" select ObjectNo from "+sRelativeTable+" "+
					" where ObjectType = 'CapitalReform' "+
					" and SerialNo =:SerialNo ";
			String sCapitalReformNo = Sqlca.getString(new SqlObject(sSql).setParameter("SerialNo",sObjectNo));
			
			//获取重组合同的金额、债务重组合同余额、利率、币种、到期日、展期次数、借新还旧次数、还旧借新次数、债务重组次数等信息
			sSql = 	" select BusinessSum,Balance,BusinessRate,BusinessCurrency,Maturity,ExtendTimes,LNGOTimes,GOLNTimes,DRTimes "+ //按照合同
					" from BUSINESS_CONTRACT "+ //按照合同
					" where SerialNo = (select max(ObjectNo) "+
					" from APPLY_RELATIVE "+
					" where ObjectType = 'BusinessContract' "+ 				
					" and SerialNo =:SerialNo) ";
			rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("SerialNo",sCapitalReformNo));
			if(rs.next()){
				dOldBusinessSum = rs.getDouble("BusinessSum");
				dOldBalance = rs.getDouble("Balance");
				dOldBusinessRate = rs.getDouble("BusinessRate");			
				sOldBusinessCurrency = DataConvert.toString(rs.getString("BusinessCurrency"));
				sOldMaturity = DataConvert.toString(rs.getString("Maturity"));
				iExtendTimes = rs.getInt("ExtendTimes");
				iLNGOTimes = rs.getInt("LNGOTimes");
				iGOLNTimes = rs.getInt("GOLNTimes");
				iDRTimes = rs.getInt("DRTimes");
							
				//将空值转化成空字符串					
				if(sOldBusinessCurrency == null) sOldBusinessCurrency = "";
				if(sOldMaturity == null) sOldMaturity = "";
			}
			rs.getStatement().close(); 		
		}
		//这些关联业务需要再进行关联一次（展期/借新还旧/还旧借新/债务重组），因此需要在原来的次数上增加一次
		iExtendTimes = iExtendTimes + 1;
		iLNGOTimes = iLNGOTimes + 1;
		iGOLNTimes = iExtendTimes + 1;
		iDRTimes = iDRTimes + 1;
	}
	
	//根据产品类型从产品信息表BUSINESS_TYPE中获得显示模版名称
	//发生类型为展期，需要调用展期信息模板
	if(sOccurType.equals("015")){
		if(sObjectType.equals("CreditApply")) //申请对象
			sDisplayTemplet = "ApplyInfo0000";
		if(sObjectType.equals("ApproveApply")) //最终审批意见对象
			sDisplayTemplet = "ApproveInfo0000";
		if(sObjectType.equals("BusinessContract") || sObjectType.equals("AfterLoan") || sObjectType.equals("ReinforceContract")) //合同对象
			sDisplayTemplet = "ContractInfo0000";					
	}else{
		if(sObjectType.equals("CreditApply")) //申请对象
			sFieldName = "ApplyDetailNo";
		if(sObjectType.equals("ApproveApply")) //最终审批意见对象
			sFieldName = "ApproveDetailNo";
		if(sObjectType.equals("BusinessContract") || sObjectType.equals("AfterLoan") || sObjectType.equals("ReinforceContract")) //合同对象
			sFieldName = "ContractDetailNo";

		sSql = " select "+sFieldName+" as DisplayTemplet from BUSINESS_TYPE where TypeNo =:TypeNo ";
		sDisplayTemplet = Sqlca.getString(new SqlObject(sSql).setParameter("TypeNo",sBusinessType));
	
		//区分同一模板在不同阶段显示不同的内容	
		if(sObjectType.equals("BusinessContract") || sObjectType.equals("AfterLoan") || sObjectType.equals("ReinforceContract")) //合同对象
			sColAttribute = " ColAttribute like '%"+sObjectType+"%' ";
		//国内/国际贸易融资业务,合同阶段暂时不使用ColAttribute属性
		if(sBusinessType!=null && (sBusinessType.startsWith("1080") || sBusinessType.startsWith("1090") || "1030025".equals(sBusinessType))){
			sColAttribute="";
		}
	}

	//通过显示模版产生ASDataObject对象doTemp
	ASDataObject doTemp = new ASDataObject(sDisplayTemplet,sColAttribute,Sqlca);
	
	//设置更新表名和主键
	doTemp.UpdateTable = sMainTable;

    //根据业务类型BusinessType来显示相应的下拉列表选项 (在Business_Type表中："2030"-融资性保函、"2040"-非融资性保函；
    //在模板AssureType中："01010"-融资性保函,"01020"-非融资性保函)    Add by zhuang 2010-03-17
    if(sBusinessType.equals("2030")){
        doTemp.setDDDWSql("SafeGuardType","select ItemNo,ItemName from CODE_LIBRARY where CodeNo = 'AssureType' and ItemNo like '01010%' and ItemNo not in ('01010')" );
    }else if(sBusinessType.equals("2040")){
        doTemp.setDDDWSql("SafeGuardType","select ItemNo,ItemName from CODE_LIBRARY where CodeNo = 'AssureType' and ItemNo like '01020%' and ItemNo not in ('01020')" );
    }

	//设置字段的可见属性	
	if(sOccurType.equals("020")) //借新还旧时显示借新还旧次数字段
		doTemp.setVisible("LNGOTimes",false);
	if(sOccurType.equals("060")) //还旧借新显示还旧借新次数字段
		doTemp.setVisible("GOLNTimes",true);
	if(sOccurType.equals("030")) //债务重组显示债务重组次数字段
		doTemp.setVisible("DRTimes",true);	
	if(sOccurType.equals("015"))
		doTemp.setCheckFormat("TotalSum,BusinessSum","2"); 
	doTemp.setVisible("REQUITALACCOUNT",isLiquidity);//流动资金贷款时显示资金回笼账户字段 
	doTemp.setRequired("REQUITALACCOUNT",isLiquidity);//流动资金贷款时资金回笼账户字段为必需
	doTemp.setVisible("FUNDBACKACCOUNT",isFixed);//固定资产贷款时显示还款准备金账户字段
	doTemp.setRequired("FUNDBACKACCOUNT",isFixed);//固定资产贷款时还款准备金账户字段为必需
	//jschen@20100408 对补登的非额度业务，合同金额、敞口金额只读
	if(sObjectType.equals("ReinforceContract") && !sBusinessType.startsWith("30")){
		doTemp.setReadOnly("BusinessSum",true);
	}

%>
<%
	//生成DataWindow对象	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	//设置DW风格 1:Grid 2:Freeform
	dwTemp.Style="2";      
	//设置是否只读 1:只读 0:可写
	dwTemp.ReadOnly = "0"; 
	
	/*--------------------------以下核算功能增加代码-----------------*/
	ASValuePool valuePool=new ASValuePool();
	valuePool.setAttribute("ProductID", sBusinessType);
	valuePool.setAttribute("ProductVersion", sProductVersion);
	DWExtendedFunctions.exinitASDataObject(dwTemp, CurPage, valuePool, Sqlca,CurUser);
	/*--------------------------以上核算功能增加代码-----------------*/
	
	//设置保存时操作流程对象表的动作
	//只有业务品种是额度时需要更新CL_Info
	if(sBusinessType.startsWith("3"))
	{
		//modify by hwang,增加对Rotative字段更新操作
		dwTemp.setEvent("AfterUpdate","!BusinessManage.UpdateCLInfo("+sObjectType+",#SerialNo,#BusinessSum,#BusinessCurrency,#LimitationTerm,#BeginDate,#PutOutDate,#Maturity,#UseTerm,#CreditCycle)");
	}			
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sObjectNo);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	
	//获取校验数据信息
	double dCheckBusinessSum = 0.0,dCheckBaseRate = 0.0,dCheckRateFloat = 0.0,dCheckBusinessRate = 0.0;
	double dCheckPdgRatio = 0.0,dCheckPdgSum = 0.0,dCheckBailSum = 0.0,dCheckBailRatio = 0.0;
	String sCheckRateFloatType = "";
	int iCheckTermYear = 0,iCheckTermMonth = 0,iCheckTermDay = 0;
	SqlObject so1 = null;
	//当对象类型为最终审批意见时，获取最终审批意见所对应的申请信息
	if(sObjectType.equals("ApproveApply")){
		//获取最后终审的任务流水号
		sSql = 	" select max(SerialNo) "+
				" from FLOW_OPINION "+
				" where ObjectType = 'CreditApply' "+
				" and ObjectNo =:ObjectNo ";
		String sTaskSerialNo = Sqlca.getString(new SqlObject(sSql).setParameter("ObjectNo",sRelativeSerialNo));

		//根据最后终审的任务流水号和对象编号获取相应的业务信息
		sSql = 	" select BA.BusinessSum,BA.BaseRate,BA.RateFloatType,BA.RateFloat, "+
				" BA.BusinessRate,BA.BailSum,BA.BailRatio,BA.PdgRatio,BA.PdgSum, "+
				" BA.TermYear,BA.TermMonth,BA.TermDay "+
				" from FLOW_OPINION BA "+
				" where BA.SerialNo =:SerialNo";
		so1 = new SqlObject(sSql).setParameter("SerialNo",sTaskSerialNo);
	}
	
	//当对象类型为合同时，获取合同所对应的校验信息
	if(sObjectType.equals("BusinessContract")){
		//jschen@20100401 如果不需要最终审批意见批复，则从FLOW_OPINION表中取校验值
		if(!"true".equalsIgnoreCase(sApproveNeed)){
			//获取合同对应申请流水号
			String sApplySerialNo = Sqlca.getString(new SqlObject("select RelativeSerialNo from BUSINESS_CONTRACT where SerialNo =:SerialNo").setParameter("SerialNo",sObjectNo));
			String sTaskSerialNo = Sqlca.getString(new SqlObject("select max(SerialNo) from FLOW_OPINION where ObjectType = 'CreditApply' and ObjectNo =:ObjectNo ").setParameter("ObjectNo",sApplySerialNo));
			
			//根据最后终审的任务流水号和对象编号获取相应的业务信息
			sSql = 	" select BusinessSum,BaseRate, "+
					" RateFloatType,RateFloat,BusinessRate,BailCurrency, "+
					" BailSum,BailRatio,PdgRatio,PdgSum,TermYear, "+
					" TermMonth,TermDay "+
					" from FLOW_OPINION "+
					" where SerialNo =:SerialNo "+
					" and ObjectNo =:ObjectNo ";
			so1 = new SqlObject(sSql);
			so1.setParameter("SerialNo",sTaskSerialNo).setParameter("ObjectNo",sApplySerialNo);
		//否则从BUSINESS_APPROVE表中取校验值
		}else{
			sSql = 	" select BA.BusinessSum,BA.BaseRate,BA.RateFloatType,BA.RateFloat, "+
					" BA.BusinessRate,BA.PdgRatio,BA.PdgSum,BA.BailSum,BA.BailRatio, "+
					" BA.TermYear,BA.TermMonth,BA.TermDay "+
					" from BUSINESS_APPROVE BA"+
					" where exists (select BC.RelativeSerialNo from BUSINESS_CONTRACT BC "+
					" where BC.SerialNo =:SerialNo "+
					" and BC.RelativeSerialNo = BA.SerialNo) ";	
			so1 = new SqlObject(sSql).setParameter("SerialNo",sObjectNo);
		}
	}
	
	if(sObjectType.equals("ApproveApply") || sObjectType.equals("BusinessContract")){
		rs = Sqlca.getASResultSet(so1);
		if(rs.next()){ 
			dCheckBusinessSum = rs.getDouble("BusinessSum");
			dCheckBaseRate = rs.getDouble("BaseRate");
			dCheckRateFloat = rs.getDouble("RateFloat");
			dCheckBusinessRate = rs.getDouble("BusinessRate");
			dCheckPdgRatio = rs.getDouble("PdgRatio");
			dCheckPdgSum = rs.getDouble("PdgSum");
			dCheckBailSum = rs.getDouble("BailSum");
			dCheckBailRatio = rs.getDouble("BailRatio");
			sCheckRateFloatType = rs.getString("RateFloatType");
			iCheckTermYear = rs.getInt("TermYear");
			iCheckTermMonth = rs.getInt("TermMonth");
			iCheckTermDay = rs.getInt("TermDay");
		}
		rs.getStatement().close(); 
		if(sCheckRateFloatType == null) sCheckRateFloatType = "";
	}
	
	String sRateType = "";
	String monthcalculationMethod = "";
	String CreditAttribute = Sqlca.getString(new SqlObject("SELECT CreditAttribute FROM  business_type bt where bt.typeno='"+sBusinessType+"' "));
	if(CreditAttribute=="0001"){//车贷 */
		sSql = 	"SELECT bt.rateType,bt.monthcalculationMethod FROM  business_type bt where bt.typeno=:sbusinesstype";	
		so1 = new SqlObject(sSql).setParameter("sbusinesstype",sBusinessType);
		rs = Sqlca.getASResultSet(so1);
		if(rs.next()){ 
			sRateType = rs.getString("rateType");
			monthcalculationMethod = rs.getString("monthcalculationMethod");
		}
		rs.getStatement().close(); 
	}
	
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info04;Describe=定义按钮;]~*/%>
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
		{"true","All","Button","保存","保存所有修改","saveRecord()",sResourcesPath},
		{"true","All","Button","暂存","暂时保存所有修改内容","saveRecordTemp()",sResourcesPath}
	};
	//当暂存标志为否，即已保存，暂存按钮应隐藏
	if(sTempSaveFlag.equals("2"))
		sButtons[1][0] = "false";
	%>
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=Info05;Describe=主体页面;]~*/%>
<%@include file="/Resources/CodeParts/Info05.jsp"%>
<%/*~END~*/%>

<script type="text/javascript">
	
	/*~[Describe=保存;InputParam=后续事件;OutPutParam=无;]~*/
	function saveRecord()
	{	
		//setNoCheckRequired(0);
		//录入数据有效性检查
		if ( !ValidityCheck() )
			return;									
		//文本合同编号重复性检测
		//alert(checkPrimaryKey("BUSINESS_CONTRACT", "ArtificialNo@CustomerID") );
		//alert(checkPrimaryKey("BUSINESS_CONTRACT", "ArtificialNo"));
		if(!checkPrimaryKey("BUSINESS_CONTRACT", "ArtificialNo@CustomerID") && checkPrimaryKey("BUSINESS_CONTRACT", "ArtificialNo")){
			alert("该文本合同编号已经存在，请检查输入！");
			return;
		}
		inserTermPara();//加入利率，还款方式
		if(vI_all("myiframe0"))
		{
			beforeUpdate();
			if(!saveSubItem()) return;
			setItemValue(0,getRow(),"TempSaveFlag","2"); //暂存标志（1：是；2：否）			
			as_save("myiframe0","afterLoad('<%=sObjectType%>','<%=sObjectNo%>')");
		}
	}
	
	//加入组件参数
	function inserTermPara(){
		var sObjectType = "<%=sObjectType%>";
		var sObjectNo="<%=sObjectNo%>";
		var sApplyType="<%=sApplyType%>";
		var sBusinessType = "<%=sBusinessType%>";
		var CreditAttribute = "<%=CreditAttribute%>";
		var RepaymentWay = getItemValue(0,0,"RepaymentWay");//还款渠道
		if(CreditAttribute == "0002"){//消费贷
			var sTermID = "RPT17";//等额本息
			RunMethod("ProductManage","initObjectWithProduct","initObjectWithProduct,"+sTermID+",<%=sObjectType%>,<%=sObjectNo%>");
			//固定利率
			RunMethod("ProductManage","initObjectWithProduct","initObjectWithProduct,RAT002,<%=sObjectType%>,<%=sObjectNo%>");
			//创建费用
			var sReturn = RunMethod("LoanAccount","CreateFeeList",sBusinessType+",<%=sObjectType%>,<%=sObjectNo%>,<%=CurUser.getUserID()%>");
			//放款账户信息
			
			//扣款账户信息
			if(RepaymentWay=="1"){//代扣
				var accountIndicator="01";//扣款
				alert(sObjectType);
				//查询该笔合同关联的扣款卡号是否存在
				sReturn = RunMethod("PublicMethod","DistinctAccount1","<%=sObjectNo%>,jbo.app.BUSINESS_CONTRACT,"+accountIndicator);
				alert(sReturn);return;
				if(sReturn>0){
					RunMethod("PublicMethod","UpdateColValue","String@OBJECTNO@"+sObjectNo+",acct_deposit_accounts,String@accountname@"+AccountallName+"@String@accountno@"+AccountNo);
				}else{
					var paymentSerialNo = getSerialNo("ACCT_DEPOSIT_ACCOUNTS","SerialNo","");
					var ReplaceAccount = getItemValue(0,0,"ReplaceAccount");//扣款账号
					var ReplaceName = getItemValue(0,0,"ReplaceName");//扣款账号名
					RunMethod("LoanAccount","CreateRepayAccount",paymentSerialNo+","+"<%=sObjectNo%>"+","+ReplaceAccount+","+ReplaceName);
				}
				
			}
			
		
		}else if(CreditAttribute == "0001"){//汽车金融
			var sRateType = "<%=sRateType%>";
			var Issue = getItemValue(0, 0, "Issue");//贷款期次
			var monthcalculationMethod = "<%=monthcalculationMethod%>";
			var finrate = "FIN003";//浮动罚息
			var IntereStrate = getItemValue(0, 0, "IntereStrate");//利率类型
			var CreditRate = getItemValue(0, 0, "CreditRate");//贷款利率利率
			
			if(IntereStrate == "RAT004"){//固定灵活利率
				RunMethod("PublicMethod","UpdateColValue","String@DEFAULTVALUE@"+CreditRate+",PRODUCT_TERM_PARA,String@paraid@ExecuteRate@String@termid@"+IntereStrate+"@String@ObjectNo@"+sObjectNo);//利率
			}
			RunMethod("PublicMethod","UpdateColValue","String@DEFAULTVALUE@"+Issue+",PRODUCT_TERM_PARA,String@paraid@SEGStages@String@termid@"+monthcalculationMethod+"@String@ObjectNo@"+sObjectNo);//贷款期次
			RunMethod("ProductManage","initObjectWithProduct","initObjectWithProduct,"+IntereStrate+",<%=sObjectType%>,<%=sObjectNo%>");//利率
			RunMethod("ProductManage","initObjectWithProduct","initObjectWithProduct,"+finrate+",<%=sObjectType%>,<%=sObjectNo%>");//罚息
<%-- 			RunMethod("ProductManage","initObjectWithProduct","initObjectWithProduct,"+monthcalculationMethod+",<%=sObjectType%>,<%=sObjectNo%>");//补贴
 --%>		RunMethod("ProductManage","initObjectWithProduct","initObjectWithProduct,"+monthcalculationMethod+",<%=sObjectType%>,<%=sObjectNo%>");//月供计算方式
 			
			//创建费用String FeeTermID,String ObjectType,String ObjectNo,String UserID FeeAmount
			RunMethod("ProductManage","UpdateProductTerm","importTermToProduct,<%=sBusinessType%>,V1.0,YB100");//延保费
			RunMethod("ProductManage","UpdateProductTerm","importTermToProduct,<%=sBusinessType%>,V1.0,QT100");//其他费
			RunMethod("ProductManage","UpdateProductTerm","importTermToProduct,<%=sBusinessType%>,V1.0,CD100");//保险金
			var Premiums = getItemValue(0, 0, "Premiums");//延保费
			var OtherCost = getItemValue(0, 0, "OtherCost");//其他费
			var InsuranceSum = getItemValue(0, 0, "InsuranceSum");//保险金
			RunMethod("PublicMethod","UpdateColValue","String@DEFAULTVALUE@"+Premiums+",PRODUCT_TERM_PARA,String@paraid@FeeAmount@String@termid@YB100@String@ObjectNo@"+sObjectNo);//延保费
			RunMethod("PublicMethod","UpdateColValue","String@DEFAULTVALUE@"+OtherCost+",PRODUCT_TERM_PARA,String@paraid@FeeAmount@String@termid@QT100@String@ObjectNo@"+sObjectNo);//其他费
			RunMethod("PublicMethod","UpdateColValue","String@DEFAULTVALUE@"+InsuranceSum+",PRODUCT_TERM_PARA,String@paraid@FeeAmount@String@termid@CD100@String@ObjectNo@"+sObjectNo);//保险金
			
			RunMethod("LoanAccount","CreateFeeList",sBusinessType+",<%=sObjectType%>,<%=sObjectNo%>,<%=CurUser.getUserID()%>");
			//扣款账号
			var RepaymentWay = getItemValue(0,0,"RepaymentWay");//还款方式
			if(RepaymentWay=="1"){//代扣
				var accountIndicator="01";//还款
				sReturn = RunMethod("PublicMethod","DistinctAccount","<%=sObjectNo%>,<%=sObjectType%>,"+accountIndicator+","+serialNo);
				if(sReturn>=1){
					RunMethod("PublicMethod","UpdateColValue","String@OBJECTNO@"+sObjectNo+",acct_deposit_accounts,String@accountname@"+AccountallName+"@String@accountno@"+AccountNo);
				}else{
					var paymentSerialNo = getSerialNo("ACCT_DEPOSIT_ACCOUNTS","SerialNo","");
					var ReplaceName = getItemValue(0,0,"ReplaceName");//账户所有人名称
					var ReplaceAccount = getItemValue(0,0,"ReplaceAccount");//扣款账号 
					RunMethod("LoanAccount","CreateRepayAccount",paymentSerialNo+","+"<%=sObjectNo%>"+","+ReplaceAccount+","+ReplaceName);
				}
				
			}
			
		}
		
	}
	
	/*~[Describe=暂存;InputParam=无;OutPutParam=无;]~*/
	function saveRecordTemp()
	{
		//0：表示第一个dw
		setNoCheckRequired(0);  //先设置所有必输项都不检查
		setItemValue(0,getRow(),'TempSaveFlag',"1");//暂存标志（1：是；2：否）
		if(!saveSubItem()) return;
		as_save("myiframe0","afterLoad('<%=sObjectType%>','<%=sObjectNo%>')");   //再暂存
		setNeedCheckRequired(0);//最后再将必输项设置回来		
	}		
	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info07;Describe=自定义函数;]~*/%>

<script type="text/javascript">

	/*~[Describe=执行更新操作前执行的代码;InputParam=无;OutPutParam=无;]~*/
	function beforeUpdate()
	{	
		setItemValue(0,0,"UpdateOrgID","<%=CurOrg.getOrgID()%>");
		setItemValue(0,0,"UpdateOrgName","<%=CurOrg.getOrgName()%>");
		setItemValue(0,0,"UpdateUserID","<%=CurUser.getUserID()%>");
		setItemValue(0,0,"UpdateUserName","<%=CurUser.getUserName()%>");
		setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");					
	}
	
	/*~[Describe=有效性检查;InputParam=无;OutPutParam=通过true,否则false;]~*/
	function ValidityCheck()
	{
		//发生类型
		sOccurType = "<%=sOccurType%>";
		//余额
		dOldBalance = "<%=dOldBalance%>";
		//对象类型
		sObjectType = "<%=sObjectType%>";
		//对象编号
		sObjectNo = "<%=sObjectNo%>";
		//业务品种
		sBusinessType = "<%=sBusinessType%>";
		
		//add by ttshao 2013/1/7
		//敞口金额应不能大于名义金额
		//名义金额
		dBusinessSum = getItemValue(0,getRow(),"BusinessSum");
		//敞口金额
		dExposureSum = getItemValue(0,getRow(),"ExposureSum");
		
		if(sObjectType == "CreditApply") //申请对象
		{
			if(sOccurType == "015") //展期业务
			{
				dBusinessSum = getItemValue(0,getRow(),"BusinessSum");
				if(dBusinessSum != dOldBalance)
				{
					//jqcao： 复杂计算，无法配置在模板中
					alert(getBusinessMessage('511'));//展期金额必须等于展期前的业务余额！
					return false;
				}
			}
			
			 //申请金额
			dBusinessSum = getItemValue(0,getRow(),"BusinessSum");
			//保证金金额
			dBailSum = getItemValue(0,getRow(),"BailSum");
			//手续费金额
			dPdgSum = getItemValue(0,getRow(),"PdgSum"); 
		}
		<%-- 
		if(sObjectType == "ApproveApply")//最终审批意见对象
		{
			//申请金额
			dCheckBusinessSum = <%=dCheckBusinessSum%>;
			//批准金额
			dBusinessSum = getItemValue(0,getRow(),"BusinessSum");
			sBusinessType = "<%=sBusinessType%>";

		    //jqcao：以下一段代码，因为校验设计复杂数据库查询，暂时无法配置在模板中
			if(parseFloat(dCheckBusinessSum) >= 0 && parseFloat(dBusinessSum) >= 0){
				if(dBusinessSum > dCheckBusinessSum){
					if(sOccurType == "015"){ //展期业务					
						alert(getBusinessMessage('512'));//批准展期金额(元)必须等于申请中的展期金额(元)！
						return false;
					}else{					
						if(sBusinessType == '1020030') {//协议付息票据贴现
							alert(getBusinessMessage('513'));//批准票据总金额(元)必须小于或等于申请中的票据总金额(元)！
							return false;
						}else if(sBusinessType == '1080005' || sBusinessType == '1090010' || sBusinessType == '1080007'){//进口信用证、国内信用证、备用信用证
							alert(getBusinessMessage('514'));//批准信用证金额(元)必须小于或等于申请中的信用证金额(元)！
							return false;
						}else if(sBusinessType == '1080410') {//提货担保
							alert(getBusinessMessage('515'));//批准单据金额(元)必须小于或等于申请中的单据金额(元)！
							return false;
						}else if(sBusinessType == '3030010' || sBusinessType == '3030030' || sBusinessType == '3030020'){ //个人房屋贷款合作项目、个贷其它合作商、汽车消费贷款合作经销商
							alert(getBusinessMessage('517'));//批准敞口总额度(元)必须小于或等于申请中的申请敞口总额度(元)！
							return false;
						}else{
							alert(getBusinessMessage('518'));//批准金额(元)必须小于或等于申请中的金额(元)！
							return false;
						}						
					}
				}
			}
			
		    //jqcao：以下一段代码，因为校验设计复杂数据库查询，暂时无法配置在模板中
			//校验期限，统一折算成天数（总天数＝期限月*30＋期限天（系统暂没有使用期限年））
			//申请的期限月			
			dCheckTermMonth = "<%=iCheckTermMonth%>";
			//申请的期限天
			dCheckTermDay = "<%=iCheckTermDay%>";
			//申请的总天数
			dCheckTotalDay = parseInt(dCheckTermMonth)*30 + parseInt(dCheckTermDay);
			//批准的期限月
			dTermMonth = getItemValue(0,getRow(),"TermMonth");
			//批准的期限天
			dTermDay = getItemValue(0,getRow(),"TermDay");
			//批准的总天数
			dTotalDay = parseInt(dTermMonth)*30 + parseInt(dTermDay);
			if(parseFloat(dCheckTotalDay) >= 0 && parseFloat(dTotalDay) >= 0)
			{
				if(dTotalDay > dCheckTotalDay)
				{
					alert(getBusinessMessage('550'));//批准的期限必须小于或等于申请的期限！
					return false;
				}
			}
			
			//批准金额
			dBusinessSum = getItemValue(0,getRow(),"BusinessSum");
			//保证金金额
			dBailSum = getItemValue(0,getRow(),"BailSum");
			//手续费金额
			dPdgSum = getItemValue(0,getRow(),"PdgSum");
		}
	
		
		//jqcao：注释
		if(sObjectType == "CreditApply" || sObjectType == 'ApproveApply')
		{
			//检查提款方式和提款说明的关系
			sDrawingType = getItemValue(0,getRow(),"DrawingType");//提款方式（01：一次提款；02：分次提款）
			sContextInfo = getItemValue(0,getRow(),"ContextInfo");
			
			//检查还款方式和还款说明的关系
			sCorpusPayMethod = getItemValue(0,getRow(),"CorpusPayMethod");//还款方式（1：一次还款；2：分次还款）
			sPaySource = getItemValue(0,getRow(),"PaySource");
		}
		
		if(sObjectType == "BusinessContract")//合同对象
		{			
			//批准金额
			dCheckBusinessSum = <%=dCheckBusinessSum%>;
			//合同金额
			dBusinessSum = getItemValue(0,getRow(),"BusinessSum");
			//jqcao：该段代码使用了复杂数据库查询，无法在显示模板中配置
			if(parseFloat(dCheckBusinessSum) >= 0 && parseFloat(dBusinessSum) >= 0)
			{
				if(dBusinessSum > dCheckBusinessSum)
				{
					if(sOccurType == "015") //展期业务
					{
						alert(getBusinessMessage('552'));//展期金额(元)必须等于最终审批意见中的批准展期金额(元)！
						return false;
					}else
					{
						if(sBusinessType == '1020030') //协议付息票据贴现
						{
							alert(getBusinessMessage('553'));//票据总金额(元)必须小于或等于最终审批意见中的批准票据总金额(元)！
							return false;
						}else if(sBusinessType == '1080005' || sBusinessType == '1090010' || sBusinessType == '1080007') //进口信用证、国内信用证、备用信用证
						{
							alert(getBusinessMessage('554'));//信用证金额(元)必须小于或等于最终审批意见中的批准信用证金额(元)！
							return false;
						}else if(sBusinessType == '1080410') //提货担保
						{
							alert(getBusinessMessage('555'));//单据金额(元)必须小于或等于最终审批意见中的批准单据金额(元)！
							return false;
						}else if(sBusinessType == '3030010' || sBusinessType == '3030030' || sBusinessType == '3030020') //个人房屋贷款合作项目、个贷其它合作商、汽车消费贷款合作经销商
						{
							alert(getBusinessMessage('557'));//敞口总额度(元)必须小于或等于最终审批意见中的批准敞口总额度(元)！
							return false;
						}else
						{
							alert(getBusinessMessage('558'));//合同金额(元)必须小于或等于最终审批意见中的批准金额(元)！
							return false;
						}	
					}
				}
			}
			
			//合同起始日
			sPutOutDate = getItemValue(0,getRow(),"PutOutDate");
			//合同到期日
			sMaturity = getItemValue(0,getRow(),"Maturity");			
			if(typeof(sPutOutDate) != "undefined" && sPutOutDate != ""
			&& typeof(sMaturity) != "undefined" && sMaturity != ""){
				if(sMaturity <= sPutOutDate){
				//检验授信协议的额度生效日、额度使用最迟日期、额度项下业务最迟到期日期与起始日、到期日的逻辑关系
				sBeginDate = getItemValue(0,getRow(),"BeginDate");
				sLimitationTerm = getItemValue(0,getRow(),"LimitationTerm");
				sUseTerm = getItemValue(0,getRow(),"UseTerm");
				
				//jqcao：以下代码使用了数据库查询，无法配置到模板中
				//校验合同到期日与合同起始日之间的期限是否超过了批准的期限
				iCheckTermYear = "<%=iCheckTermYear%>";
				iCheckTermMonth = "<%=iCheckTermMonth%>";
				//jschen@20100413 如果值为0，则不检验。如果是贴现类业务会出现这种情况，因为申请时没有期限项
				if(typeof(iCheckTermYear) != "undefined" && iCheckTermYear != ""
					&& typeof(iCheckTermMonth) != "undefined" && iCheckTermMonth != ""
					&& iCheckTermYear != 0 && iCheckTermMonth != 0)	
					{						
						a = new Date(sPutOutDate);
						b = new Date(sMaturity);			
						if(parseInt((b-a)/1000/24/60/60/30) > (parseInt(iCheckTermMonth)+parseInt(iCheckTermYear)*12))
						{
							alert(getBusinessMessage('591'));//合同期限必须小于或等于最终审批意见中的期限（仅控制整月）！
							return;
						}
					}	
				}
			}
			
			//合同金额
			dBusinessSum = getItemValue(0,getRow(),"BusinessSum");
			//保证金金额
			dBailSum = getItemValue(0,getRow(),"BailSum");
			//手续费金额
			dPdgSum = getItemValue(0,getRow(),"PdgSum");
			//批准的基准利率
			sCheckBaseRate = "<%=dCheckBaseRate%>";
			//批准的利率浮动方式
			sCheckRateFloatType = "<%=sCheckRateFloatType%>";
			//批准的利率浮动值
			sCheckRateFloat = "<%=dCheckRateFloat%>";
			//基准利率
			sBaseRate = getItemValue(0,getRow(),"BaseRate");
			//利率浮动方式
			sRateFloatType = getItemValue(0,getRow(),"RateFloatType");
			//利率浮动值
			sRateFloat = getItemValue(0,getRow(),"RateFloat");
			//jqcao：以下代码使用数据库查询，无法在模板中配置
			if(parseFloat(sBaseRate) >= 0 && parseFloat(sCheckBaseRate) >= 0)
			{
				if(parseFloat(sBaseRate) < parseFloat(sCheckBaseRate))
				{
					alert(getBusinessMessage('559'));//基准利率必须大于或等于最终审批意见中的基准利率！
					return false;
				}
			}
			if(typeof(sRateFloatType) != "undefined" && sRateFloatType != ""
			&& typeof(sCheckRateFloatType) != "undefined" && sCheckRateFloatType != "")
			{
				if(sRateFloatType == sCheckRateFloatType)
				{
					if(parseFloat(sRateFloat) >= 0 && parseFloat(sCheckRateFloat) >= 0)
					{
						if(parseFloat(sRateFloat) < parseFloat(sCheckRateFloat))
						{
							alert(getBusinessMessage('560'));//利率浮动值必须大于或等于最终审批意见中的利率浮动值！
							return false;
						}
					}
				}
			}
			
			//jqcao：以下代码使用了复杂方法，无法在模板中配置
			//判断还款准备金账户或者资金回笼账户在账户管理是否已经登记
			sFundbackAccount = getItemValue(0,getRow(),"FundbackAccount");
			sRequitalAccount = getItemValue(0,getRow(),"RequitalAccount");
			sCustomerID = getItemValue(0,getRow(),"CustomerID");
			sReturn = RunMethod("BusinessManage","CheckRegister",sFundbackAccount+","+sRequitalAccount+","+sCustomerID);
			if (sReturn == "true")
			{
				alert("该账号已经登记，是否继续使用？");
			}else if(sReturn == "own")
			{
				alert("该账号已被其他用户占用");
				return false;
			}
		}
		 --%>
		//汽车金融申请详情验证
		
		sProductID = getItemValue(0,getRow(),"ProductID");//产品类型
		//alert("---------------"+sProductID);
		if(sProductID=="01"){
			//车辆售价验证
			var sVehiclePrice =getItemValue(0,0,"VehiclePrice");//车辆售价
			var sCarPrice =getItemValue(0,0,"CarPrice");//出厂价
			
			if(parseFloat(sVehiclePrice) > parseFloat(sCarPrice)){
				alert("车辆售价不得高于出厂价!");
				return false;
			}
			
			//首付款比例验证
			var sPaymentSum =getItemValue(0,0,"PaymentSum");//首付款金额
			var sCarTotal   =getItemValue(0,0,"CarTotal");//车辆总价
			
			
		}
		
		
		
		
		
		return true;
	}
	
	/*~[Describe=弹出授信额度选择窗口，并置将返回的值设置到指定的域;InputParam=无;OutPutParam=无;]~*/
	function selectCreditLine()
	{		
		sCustomerID = getItemValue(0,getRow(),"CustomerID");
		var sTableName = "CUSTOMER_INFO" ;
		var sColName = "CustomerType";
		var sWhereClause = "CustomerID="+"'"+sCustomerID+"'";		
		if(typeof(sCustomerID) == "undefined" || sCustomerID == "")
		{
			alert(getBusinessMessage('226'));//请先选择客户！
			return;
		}
		//获得客户类型
		sCustomerType = RunMethod("公用方法","GetColValue",sTableName + "," + sColName + "," + sWhereClause); 
		//查找该客户的有效授信协议
		if(sCustomerType.substring(0,2) == "01")
		{
			sParaString = "CustomerID"+","+sCustomerID+","+"PutOutDate"+","+"<%=StringFunction.getToday()%>"+","+"Maturity"+","+"<%=StringFunction.getToday()%>";
					setObjectValue("SelectCLContract",sParaString,"@CreditAggreement@0",0,0,"");
		}
		if(sCustomerType.substring(0,2) == "03")
		{
			sParaString = "PutOutDate"+","+"<%=StringFunction.getToday()%>"+","+"Maturity"+","+"<%=StringFunction.getToday()%>";
			setObjectValue("SelectCLContract1",sParaString,"@CreditAggreement@0",0,0,"");
		}
	}

	/*~[Describe=弹出国家/地区选择窗口，并置将返回的值设置到指定的域;InputParam=无;OutPutParam=无;]~*/
	function selectCountryCode(ID,Name){
		sParaString = "CodeNo"+",CountryCode";
		sCountryCodeInfo = setObjectValue("SelectCode",sParaString,"@"+ID+"@0@"+Name+"@1",0,0,"");
	}
			
	/*~[Describe=选择主要担保方式;InputParam=无;OutPutParam=无;]~*/
	function selectVouchType() {
		sParaString = "CodeNo"+","+"VouchType";
		setObjectValue("SelectCode",sParaString,"@VouchType@0@VouchTypeName@1",0,0,"");		
	}

	//选择项下业务担保方式
	function selectVouchType3(){
		sParaString = "CodeNo"+","+"VouchType";
		setObjectValue("SelectCode",sParaString,"@Describe1@0@DescribeName@1",0,0,"");
	}
	
	//抵押和质押担保
	function selectVouchType1() {
		ssBusinessType = "<%=sBusinessType%>";
		sParaString = "CodeNo"+","+"VouchType";
		if(ssBusinessType == "1110090" || ssBusinessType == "1110050")
		setObjectValue("SelectImpawnCode",sParaString,"@VouchType@0@VouchTypeName@1",0,0,"");
		else 
		setObjectValue("SelectPawnCode",sParaString,"@VouchType@0@VouchTypeName@1",0,0,"");	
			
	}
	//保证担保
	function selectVouchType2() {
		sParaString = "CodeNo"+","+"VouchType";
		setObjectValue("SelectAssureCode",sParaString,"@VouchType@0@VouchTypeName@1",0,0,"");		
	}
	
	/*~[Describe=弹出经办人选择窗口，并置将返回的值设置到指定的域;InputParam=无;OutPutParam=无;]~*/
	function selectUser(sType)
	{
		sParaString = "BelongOrg"+","+"<%=CurOrg.getOrgID()%>";
		if(sType == "OperateUser")
			setObjectValue("SelectUserBelongOrg",sParaString,"@OperateUserID@0@OperateUserName@1@OperateOrgID@2@OperateOrgName@3",0,0,"");		
		if(sType == "ManageUser")
			setObjectValue("SelectUserBelongOrg",sParaString,"@ManageUserID@0@ManageUserName@1@ManageOrgID@2@ManageOrgName@3",0,0,"");	
		if(sType == "RecoveryUser")
			setObjectValue("SelectUserBelongOrg",sParaString,"@RecoveryUserID@0@RecoveryUserName@1@RecoveryOrgID@2@RecoveryOrgName@3",0,0,"");			
	}
	
	/*~[Describe=弹出机构选择窗口，并置将返回的值设置到指定的域;InputParam=无;OutPutParam=无;]~*/
	function selectOrg(sType)
	{		
		if(sType == "StatOrg")
			setObjectValue("SelectAllOrg","","@StatOrgID@0@StatOrgName@1",0,0,"");		
	}
	
	/*~[Describe=弹出保函类型选择窗口，并置将返回的值设置到指定的域;InputParam=无;OutPutParam=无;]~*/
	function selectAssureType()
	{		
		sParaString = "CodeNo"+","+"AssureType";
		setObjectValue("SelectCode",sParaString,"@SafeGuardType@0@SafeGuardTypeName@1",0,0,"");		
	}

	/*~[Describe=选择行业投向（国标行业类型）;InputParam=无;OutPutParam=无;]~*/
	function getIndustryType()
	{
		var sIndustryType = getItemValue(0,getRow(),"Direction");
		//由于行业分类代码有几百项，分两步显示行业代码
		sIndustryTypeInfo = PopComp("IndustryVFrame","/Common/ToolsA/IndustryVFrame.jsp","IndustryType="+sIndustryType,"dialogWidth=650px;dialogHeight=500px;center:yes;status:no;statusbar:no","");
		//sIndustryTypeInfo = PopPage("/Common/ToolsA/IndustryTypeSelect.jsp?rand="+randomNumber(),"","dialogWidth=20;dialogHeight=25;center:yes;status:no;statusbar:no");
		if(sIndustryTypeInfo == "NO")
		{
			setItemValue(0,getRow(),"Direction","");
			setItemValue(0,getRow(),"DirectionName","");
		}else if(typeof(sIndustryTypeInfo) != "undefined" && sIndustryTypeInfo != "")
		{
			sIndustryTypeInfo = sIndustryTypeInfo.split('@');
			sIndustryTypeValue = sIndustryTypeInfo[0];//-- 行业类型代码
			sIndustryTypeName = sIndustryTypeInfo[1];//--行业类型名称
			setItemValue(0,getRow(),"Direction",sIndustryTypeValue);
			setItemValue(0,getRow(),"DirectionName",sIndustryTypeName);				
		}
	}
	
	//add by ttshao 2013/1/5
	/*~[Describe=选择承兑人名称、证件号码;InputParam=无;OutPutParam=无;]~*/
	function selectAcceptanceCustomer()
	{
		sParaString = "UserID"+","+"<%=CurUser.getUserID()%>";
		setObjectValue("SelectGuarantor",sParaString,"@ThirdPartyID1@0@THIRDPARTY1@1",0,0,"");		
	}
	 
	/*~[Describe=根据自定义小数位数四舍五入,参数object为传入的数值,参数decimal为保留小数位数;InputParam=基数，四舍五入位数;OutPutParam=四舍五入后的数据;]~*/
	function roundOff(number,digit)
	{
		var sNumstr = 1;
    	for (i=0;i<digit;i++)
    	{
       		sNumstr=sNumstr*10;
        }
    	sNumstr = Math.round(parseFloat(number)*sNumstr)/sNumstr;
    	return sNumstr;
    	
	}
	
	/*~[Describe=根据基准利率、利率浮动方式、利率浮动值计算执行年(月)利率;InputParam=无;OutPutParam=无;]~*/
	function getBusinessRate(sFlag)
	{
		//基准利率
		var dBaseRate = getItemValue(0,getRow(),"BaseRate");
		//利率浮动方式
		var sRateFloatType = getItemValue(0,getRow(),"RateFloatType");
		//利率浮动值
		var dRateFloat = getItemValue(0,getRow(),"RateFloat");
		if(typeof(sRateFloatType) != "undefined" && sRateFloatType != "" 
		&& parseFloat(dBaseRate) >= 0 && parseFloat(dRateFloat) >= 0)
		{			
			var dYearRate="";
			var dMonthRate="";
			if(sRateFloatType=="0"){	//浮动百分比
				//执行年利率
				dYearRate = parseFloat(dBaseRate) * (1 + parseFloat(dRateFloat)/100 );
			 	//执行月利率
				dMonthRate = parseFloat(dBaseRate) * (1 + parseFloat(dRateFloat)/100 ) / 1.2;
			}else{	//1:浮动点数
				//执行年利率
				dYearRate = parseFloat(dBaseRate) + parseFloat(dRateFloat);
				//执行月利率
				dMonthRate = (parseFloat(dBaseRate) + parseFloat(dRateFloat)) / 1.2;
					//dBusinessRate = parseFloat(dBaseRate)/1.2 + parseFloat(dRateFloat); // 修改执行月利率的计算公式 add by cbsu 2009-10-22
			}
			dMonthRate = roundOff(dMonthRate,6);
			dYearRate = roundOff(dYearRate,6);
			setItemValue(0,getRow(),"BusinessRate",dMonthRate);
			setItemValue(0,getRow(),"ExecuteYearRate",dYearRate);
		}else{
			setItemValue(0,getRow(),"BusinessRate","");
			setItemValue(0,getRow(),"ExecuteYearRate","");
		}
	}
	
	/*~[Describe=计算贴现利息和实付贴现金额;InputParam=无;OutPutParam=无;]~*/
	function getDiscountInterest()
	{
		//月利率
		dBusinessRate = getItemValue(0,getRow(),"BusinessRate");
		//票据总金额
		dBusinessSum = getItemValue(0,getRow(),"BusinessSum");
		//获取贴现利息
		if(parseFloat(dBusinessSum) >= 0 && parseFloat(dBusinessRate) >= 0)
		{
			//贴现利息＝票据总金额×月利率
			dDiscountInterst = roundOff(parseFloat(dBusinessSum) * parseFloat(dBusinessRate)/1000,2);
			//贴现实付金额＝票据总金额－贴现利息
			dDiscountSum = parseFloat(dBusinessSum) - parseFloat(dDiscountInterst);
			setItemValue(0,getRow(),"DiscountInterest",dDiscountInterst);
			setItemValue(0,getRow(),"DiscountSum",dDiscountSum);
		}
	}
	
	/*~[Describe=计算卖方应付贴现利息;InputParam=无;OutPutParam=无;]~*/
	function getBargainorInterest()
	{
		//贴现利息
		dDiscountInterest = getItemValue(0,getRow(),"DiscountInterest");
		//买方应付贴现利息
		dPurchaserInterest = getItemValue(0,getRow(),"PurchaserInterest");
		//获取卖方应付贴现利息
		if(parseFloat(dDiscountInterest) >= 0 && parseFloat(dPurchaserInterest) >= 0)
		{
			//卖方应付贴现利息＝贴现利息－买方应付贴现利息
			dBargainorInterest = parseFloat(dDiscountInterest) - parseFloat(dPurchaserInterest);
			setItemValue(0,getRow(),"BargainorInterest",dBargainorInterest);
		}
	}
	
	/*~[Describe=银团贷款中“我行贷款份额占比”计算;InputParam=无;OutPutParam=无;]~*/	
	function setBusinessProp()
	{
	    dBusinessSum = getItemValue(0,getRow(),"BusinessSum");
	    dTradeSum = getItemValue(0,getRow(),"TradeSum");
        dBusinessProp = roundOff(parseFloat(dBusinessSum)/parseFloat(dTradeSum)*100,2);
		if(dBusinessProp>100)
		{
			setItemValue(0,getRow(),"BusinessProp",0);
		}
		else
		{
			 setItemValue(0,getRow(),"BusinessProp",dBusinessProp);
		}
    }
	
	/*~[Describe=根据手续费率计算手续费;InputParam=无;OutPutParam=无;]~*/
	function getpdgsum()
	{
	    dBusinessSum = getItemValue(0,getRow(),"BusinessSum");
	    if(parseFloat(dBusinessSum) >= 0)
	    {
	        dPdgRatio = getItemValue(0,getRow(),"PdgRatio");
	        dPdgRatio = roundOff(dPdgRatio,2);
	        if(parseFloat(dPdgRatio) >= 0)
	        {
	            dPdgSum = parseFloat(dBusinessSum)*parseFloat(dPdgRatio)/1000;
	            dPdgSum = roundOff(dPdgSum,2);
	            setItemValue(0,getRow(),"PdgSum",dPdgSum);
	        }
	    }
	}
	
	/*~[Describe=根据手续费计算手续费率;InputParam=无;OutPutParam=无;]~*/
	function getPdgRatio()
	{
	    dBusinessSum = getItemValue(0,getRow(),"BusinessSum");
	    if(parseFloat(dBusinessSum) >= 0)
	    {
	        dPdgSum = getItemValue(0,getRow(),"PdgSum");
	        dPdgSum = roundOff(dPdgSum,2);
	        if(parseFloat(dPdgSum) >= 0)
	        {	       
	            dPdgRatio = parseFloat(dPdgSum)/parseFloat(dBusinessSum)*1000;
	            dPdgRatio = roundOff(dPdgRatio,2);
	            setItemValue(0,getRow(),"PdgRatio",dPdgRatio);
	        }
	    }
	}
	
	
	/*~[Describe=弹出范畴选择窗口，并置将返回的值设置到指定的域;InputParam=无;OutPutParam=无;]~*/
	function selectCategoryID()
	{
		sBusinessType = getItemValue(0,0,"BusinessType");

		sParaString = "BusinessType"+","+sBusinessType;
		//设置返回参数 
		setObjectValue("SelectCategoryType",sParaString,"@BusinessRange1@0@BusinessRangeName@1",0,0,"");
	}
	
	/*~[Describe=弹出类型选择窗口，并置将返回的值设置到指定的域;InputParam=无;OutPutParam=无;]~*/
	function selectTypeID()
	{
		sBusinessRange1 = getItemValue(0,0,"BusinessRange1");
		
		if(typeof(sBusinessRange1) == "undefined" || sBusinessRange1 == "")
		{
			alert("请先选择范畴1类型!");
			return;
		}

		sParaString = "ProductcategoryID"+","+sBusinessRange1;
		//设置返回参数 
		setObjectValue("SelectMoldType",sParaString,"@BusinessType1@0@BusinessTypeName@1",0,0,"");
	}
	
	
	function selectCategoryID2()
	{
		sBusinessType = getItemValue(0,0,"BusinessType");

		sParaString = "BusinessType"+","+sBusinessType;
		//设置返回参数 
		setObjectValue("SelectCategoryType",sParaString,"@BusinessRange2@0@BusinessRangeName2@1",0,0,"");
	}
	
	function selectTypeID2()
	{
		sBusinessRange2 = getItemValue(0,0,"BusinessRange2");
		
		if(typeof(sBusinessRange2) == "undefined" || sBusinessRange2 == "")
		{
			alert("请先选择范畴2类型!");
			return;
		}

		sParaString = "ProductcategoryID"+","+sBusinessRange2;
		//设置返回参数 
		setObjectValue("SelectMoldType",sParaString,"@BusinessType2@0@BusinessTypeName2@1",0,0,"");
	}
	
	
	function selectCategoryID3()
	{
		sBusinessType = getItemValue(0,0,"BusinessType");

		sParaString = "BusinessType"+","+sBusinessType;
		//设置返回参数 
		setObjectValue("SelectCategoryType",sParaString,"@BusinessRange3@0@BusinessRangeName3@1",0,0,"");
	}
	
	function selectTypeID3()
	{
		sBusinessRange3 = getItemValue(0,0,"BusinessRange3");
		
		if(typeof(sBusinessRange3) == "undefined" || sBusinessRange3 == "")
		{
			alert("请先选择范畴3类型!");
			return;
		}

		sParaString = "ProductcategoryID"+","+sBusinessRange3;
		//设置返回参数 
		setObjectValue("SelectMoldType",sParaString,"@BusinessType3@0@BusinessTypeName3@1",0,0,"");
	}
	
	
	/*~[Describe=弹出省市选择窗口，并置将返回的值设置到指定的域;InputParam=无;OutPutParam=无;]~*/
	function getCityName()
	{
		//var sAreaCode = getItemValue(0,getRow(),"City");
		//sAreaCodeInfo = PopComp("AreaVFrame","/Common/ToolsA/AreaVFrame.jsp","AreaCode="+sAreaCode,"dialogWidth=650px;dialogHeight=450px;center:yes;status:no;statusbar:no","");
        var sAreaCodeInfo = setObjectValue("SelectCityCodeSingle","","",0,0,"");
		
		//增加清空功能的判断
		if(sAreaCodeInfo == "NO" || sAreaCodeInfo == '_CLEAR_'){
			setItemValue(0,getRow(),"City","");
			setItemValue(0,getRow(),"CityName","");
		}else{
			 if(typeof(sAreaCodeInfo) != "undefined" && sAreaCodeInfo != ""){
					sAreaCodeInfo = sAreaCodeInfo.split('@');
					sAreaCodeValue = sAreaCodeInfo[0];//-- 行政区划代码
					sAreaCodeName = sAreaCodeInfo[1];//--行政区划名称
					setItemValue(0,getRow(),"City",sAreaCodeValue);
					setItemValue(0,getRow(),"CityName",sAreaCodeName);			
			}
		}
	}
	
	//代扣账号开户行选择
	function selectBankCode(){
		var sOpenBank = getItemValue(0,0,"OpenBank");
		var sCity     = getItemValue(0,0,"City");
		
		if(sCity=="" ||sOpenBank==""){
			alert("请选择开户银行或省市！");
			return;
		}
		
		sCompID = "SelectWithholdList";
		sCompURL = "/CreditManage/CreditApply/SelectWithholdList.jsp";
		sParaString="OpenBank="+sOpenBank+"&City="+sCity;
		
		sReturn = popComp(sCompID,sCompURL,sParaString,"dialogWidth=550px;dialogHeight=450px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		
		if(typeof(sReturn)=="undefined" || sReturn=="" || sReturn=="_CANCEL_") return;
		
		//获取返回值
		sReturn = sReturn.split("@");
		sBankNo=sReturn[0];//
		sBranch=sReturn[1];//

		setItemValue(0,0,"OpenBranch",sBankNo);
		setItemValue(0,0,"OpenBranchName",sBranch);
	}
	
	//控制车辆售价不得高于出厂价
	function selectVPrice(obj){
		var sVehiclePrice =getItemValue(0,0,"VehiclePrice");//车辆售价
		var sCarPrice =getItemValue(0,0,"CarPrice");//出厂价
		
		if(parseFloat(sVehiclePrice) > parseFloat(sCarPrice)){
			alert("车辆售价不得高于出厂价");
			obj.focus();
		}
	}
	
	//计算车辆总价
	function selectOtherCost(){
		var sVehiclePrice =getItemValue(0,0,"VehiclePrice");//车辆售价
		var sInsuranceSum =getItemValue(0,0,"InsuranceSum");//保险金额
		var sRevenueTax =getItemValue(0,0,"RevenueTax");//购置税
		var sOtherCost =getItemValue(0,0,"OtherCost");//其他费用
		var sAllocationSum =getItemValue(0,0,"AllocationSum");//附加配置金额
		var sPremiums =getItemValue(0,0,"Premiums");//延保费
		
		if(!isNaN(sVehiclePrice) && !isNaN(sInsuranceSum) && !isNaN(sRevenueTax) && !isNaN(sOtherCost) && !isNaN(sAllocationSum) && !isNaN(sPremiums)){
			var stotal=parseFloat(sVehiclePrice)+parseFloat(sInsuranceSum)+parseFloat(sRevenueTax)+parseFloat(sOtherCost)+parseFloat(sAllocationSum)+parseFloat(sPremiums);
			//alert("--------------"+stotal);
	        dTotal = roundOff(stotal,2);//四舍五入保留2位小数

	        if(!isNaN(dTotal)){
			    setItemValue(0,0,"CarTotal",dTotal);//车辆总价
	        }
		}
	}
	
	//首付款比例(汽车金融):(首付款金额/车辆总价)*100%
	function selectPaymentRate(){
		var sProductID =getItemValue(0,0,"ProductID");//产品类型
		if(sProductID=="01"){
			var sPaymentSum =getItemValue(0,0,"PaymentSum");//首付款金额
			var sCarTotal   =getItemValue(0,0,"CarTotal");//车辆总价
			
			if(!isNaN(sPaymentSum) && !isNaN(sCarTotal)){
				var sPaymentRate=roundOff((parseFloat(sPaymentSum)/parseFloat(sCarTotal))*0.1,2);
	
				if(!isNaN(sPaymentRate)){
				    setItemValue(0,0,"PaymentRate",sPaymentRate);//首付款比例
				}
			}
		}
	}
	
	//尾款比例:（尾款金额/ 车辆总价）*100%
	function selectPaymentRate(){
		var sFinalPaymentSum =getItemValue(0,0,"FinalPaymentSum");//尾款金额
		var sCarTotal   =getItemValue(0,0,"CarTotal");//车辆总价
		
		if(!isNaN(sFinalPaymentSum) && !isNaN(sCarTotal)){
			var sFinalPayment=roundOff((parseFloat(sFinalPaymentSum)/parseFloat(sCarTotal))*0.1,2);

			if(!isNaN(sFinalPayment)){
			    setItemValue(0,0,"FinalPayment",sFinalPayment);//尾款比例
			}
		}
	}
	
	//残值比例(汽车租赁):（残值金额/ 车辆出厂价）*100%
	function selectSalvageRatio(){
		var sProductID =getItemValue(0,0,"ProductID");//产品类型
		if(sProductID=="02"){
			var sSalvageSum =getItemValue(0,0,"SalvageSum");//残值金额
			var sCarPrice   =getItemValue(0,0,"CarPrice");//车辆总价
			
			if(!isNaN(sSalvageSum) && !isNaN(sCarPrice)){
				var sSalvageRatio=roundOff((parseFloat(sSalvageSum)/parseFloat(sCarPrice))*0.1,2);
	
				if(!isNaN(sSalvageRatio)){
				    setItemValue(0,0,"SalvageRatio",sSalvageRatio);//残值比例
				}
			}
		}
	}
	
	//贷款金额
	function selectBusinessSum(){
		var sProductID =getItemValue(0,0,"ProductID");//产品类型
		//汽车金融：车辆总价-首付款金额
		if(sProductID=="01"){
			var sCarTotal   =getItemValue(0,0,"CarTotal");//车辆总价
			var sPaymentSum =getItemValue(0,0,"PaymentSum");//首付款金额
			
			if(!isNaN(sCarTotal) && !isNaN(sPaymentSum)){
				sBusinessSum=roundOff(parseFloat(sCarTotal)-parseFloat(sPaymentSum),2);
				if(!isNaN(sBusinessSum)){
				    setItemValue(0,0,"BusinessSum",sBusinessSum);//贷款金额
				}
			}
		 }
		
		//汽车租赁：车辆总价-残值金额
		if(sProductID=="02"){
			var sCarTotal   =getItemValue(0,0,"CarTotal");//车辆总价
			var sSalvageSum =getItemValue(0,0,"SalvageSum");//残值金额
			
			if(!isNaN(sCarTotal) && !isNaN(sSalvageSum)){
				sBusinessSum=roundOff(parseFloat(sCarTotal)-parseFloat(sSalvageSum),2);
				if(!isNaN(sBusinessSum)){
				    setItemValue(0,0,"BusinessSum",sBusinessSum);//贷款金额
				}
			}
		}

		//控制贷款金额/车辆总价不得高于产品配置中的最高贷款比例
		
	}
	
	//保证金金额:车辆指导价*保证金比例
	function selectBailSum(){
		var sCarguiDeprice   =getItemValue(0,0,"CarguiDeprice");//车辆指导价
		var sDeposit   =getItemValue(0,0,"Deposit");//保证金比例
		
		if(!isNaN(sCarguiDeprice) && !isNaN(sDeposit)){
			sBailSum=roundOff(parseFloat(sCarguiDeprice)*parseFloat(sDeposit),2);
			if(!isNaN(sBailSum)){
			    setItemValue(0,0,"BailSum",sBailSum);//保证金金额
			}
		}
		
	}
	
	//选择还款方式
	function selectRepay(){
		var sRepaymentWay   =getItemValue(0,0,"RepaymentWay");//还款方式
		if(sRepaymentWay=="1"){//代扣
			setItemRequired(0,0,"ReplaceName",true);//账户所有人姓名
			setItemRequired(0,0,"ReplaceAccount",true);//账号
			setItemRequired(0,0,"OpenBankName",true);//开户银行名称
			setItemRequired(0,0,"OpenBranchName",true);//开户支行名称
		}else{
			setItemRequired(0,0,"ReplaceName",false);//账户所有人姓名
			setItemRequired(0,0,"ReplaceAccount",false);//账号
			setItemRequired(0,0,"OpenBankName",false);//开户银行名称
			setItemRequired(0,0,"OpenBranchName",false);//开户支行名称
		}
	}
	
	//代扣开户银行名称(车贷)
	function selectBankNo()
	{
		//sParaString = "ProductcategoryID"+","+sBusinessRange3;
		//设置返回参数 
		setObjectValue("SelectOpenBank","","@OpenBank@0@OpenBankName@1",0,0,"");
	}
	
	//代扣开户支行名称
	function selectBranchNo(){
		sOpenBank = getItemValue(0,0,"OpenBank");
		
		if(typeof(sOpenBank) == "undefined" || sOpenBank == "")
		{
			alert("请选择代扣开户银行！");
			return;
		}
		
		sParaString = "SerialNo"+","+sOpenBank;
		//设置返回参数 
		setObjectValue("SelectBranchName",sParaString,"@OpenBranch@0@OpenBranchName@1",0,0,"");
	}
	
	
	//计算金额
	function countMoney(){
		var sPrice1 =parseFloat(getItemValue(0,0,"Price1"));
		var sTotalSum1 =parseFloat(getItemValue(0,0,"TotalSum1"));
		
		if(!isNaN(sPrice1) && !isNaN(sTotalSum1)){
			var sTotal=sPrice1-sTotalSum1;
			dTotal = roundOff(sTotal,2);
			
			if(!isNaN(dTotal)){
			   setItemValue(0,0,"BusinessSum1",dTotal);
			}
		}	
	}
	
	
	function countMoney2(){
		var sPrice2 =parseFloat(getItemValue(0,0,"Price2"));
		var sTotalSum2 =parseFloat(getItemValue(0,0,"TotalSum2"));
		
		if(!isNaN(sPrice2) && !isNaN(sTotalSum2)){
			var sTotal=sPrice2-sTotalSum2;
			dTotal = roundOff(sTotal,2);
			
			if(!isNaN(dTotal)){
			   setItemValue(0,0,"BusinessSum2",dTotal);
			}
		}	
	}
	
	function countMoney3(){
		var sPrice3 =parseFloat(getItemValue(0,0,"Price3"));
		var sTotalSum3 =parseFloat(getItemValue(0,0,"TotalSum3"));
		
		if(!isNaN(sPrice3) && !isNaN(sTotalSum3)){
			var sTotal=sPrice3-sTotalSum3;
			dTotal = roundOff(sTotal,2);
			
			if(!isNaN(dTotal)){
			  setItemValue(0,0,"BusinessSum3",dTotal);
			}
		}	
	}
	
	//还款方式设置
	function selectWay(){
		sRepaymentWay = getItemValue(0,0,"RepaymentWay");
		if(sRepaymentWay=="1"){
			//设置必选项，如果选择代扣，显示”代扣账号“、”开户银行“、”代扣账户名“为必输
			setItemRequired(0,0,"ReplaceAccount",true);
			setItemRequired(0,0,"OpenBank",true);
			setItemRequired(0,0,"ReplaceName",true);
			
			//隐藏和显示字段
			//hideItem(0, 0, "ReplaceAccount");
			//showItem(0, 0, "RepaymentWay");
		}else{
			setItemRequired(0,0,"ReplaceAccount",false);
			setItemRequired(0,0,"OpenBank",false);
			setItemRequired(0,0,"ReplaceName",false);
		}
	}
	
	//车况设置
	function selectCarStatus(){
		sCarStatus = getItemValue(0,0,"CarStatus");
		//alert("---------------------"+sCarStatus);
		if(sCarStatus=="02"){
			//设置必选项，
			setItemRequired(0,0,"CarFrame",true);
			setItemRequired(0,0,"ProductDate",true);
			setItemRequired(0,0,"AssessPrice",true);
			setItemRequired(0,0,"CarYear",true);
			setItemRequired(0,0,"Journey",true);
		}else{
			setItemRequired(0,0,"CarFrame",false);
			setItemRequired(0,0,"ProductDate",false);
			setItemRequired(0,0,"AssessPrice",false);
			setItemRequired(0,0,"CarYear",false);
			setItemRequired(0,0,"Journey",false);
		}
	}
	
	//汽车型号代码
	function selectCarCode(){
		sCarCode = getItemValue(0,0,"CarCode");
		//alert("---------------------"+sCarCode);
		if(sCarCode !=""){
			sReturn = RunMethod("BusinessManage","GetCarInfo",sCarCode);
			//alert("------------"+sReturn);
			if(typeof(sReturn)=="undefined" || sReturn=="" || sReturn=="_CANCEL_") return;
			
			//获取返回值
			sReturn = sReturn.split("@");
			sModelsBrand=sReturn[0];//车辆品牌
			sCarDescription=sReturn[1];//车型描述
			sModelsSeries=sReturn[2];//系列
			sPrice=sReturn[3];//车辆出厂价
			sBodyType=sReturn[4];//车身类型
			sEngineSize=sReturn[5];//发动机容量
			sSalesstartTime=sReturn[6];//新车生产年份
			sColor=sReturn[7];//颜色
	
			setItemValue(0,0,"CarBrand",sModelsBrand);
			setItemValue(0,0,"CartypeDescribe",sCarDescription);
			setItemValue(0,0,"CarSeries",sModelsSeries);
			setItemValue(0,0,"CarPrice",sPrice);
			setItemValue(0,0,"CarBody",sBodyType);
			setItemValue(0,0,"Enginecapacity",sEngineSize);
			setItemValue(0,0,"ProductionYear",sSalesstartTime);
			setItemValue(0,0,"CarColour",sColor);
		}
	}
	

	/*~[Describe=检查"零"天数是否合法;InputParam=无;OutPutParam=无;]~*/
 	function getTermDay()
	{
	    /* var dTermDay = getItemValue(0,getRow(),"TermDay");
	    if(parseInt(dTermDay)>30){
	    	if(!(sBusinessType=="1080005") && !(sBusinessType=="1090010"))
	        alert("零(天)必须小于等于30!");
	    } */
	} 
	
	/*~[Describe=根据首付金额计算首付比例;InputParam=无;OutPutParam=无;]~*/
	function getThirdPartyRatio()
	{
	    //dBusinessSum = getItemValue(0,getRow(),"BusinessSum");
	    sBusinessType = "<%=sBusinessType%>";
	    //取房屋总价@jlwu
	    if(sBusinessType =="1110180" )
	    {
	    	sThirdPartyID2 = getItemValue(0,getRow(),"ThirdParty2");
	    }else
	    { 
	    	sThirdPartyID2 = getItemValue(0,getRow(),"ThirdPartyID2");
	    }
	    dThirdPartyID2 = parseFloat(sThirdPartyID2);
	    
	    //取首付金额@jlwu
	    if(sBusinessType =="1110180" )
	    {
	    	sThirdParty = getItemValue(0,getRow(),"ThirdPartyID2");
	    }else
	    { 
	    	sThirdParty = getItemValue(0,getRow(),"ThirdPartyAdd1");
	    }	  
	    dThirdParty = parseFloat(sThirdParty);
	   
	    //配到校验规则里@qzhang1
	    /* if(dThirdPartyID2 < dThirdParty)
	    {
		    alert('首付金额应小于等于房屋总价！');
			setItemValue(0,getRow(),"ThirdPartyAdd1","");
		    return;
	    } */
	    if(parseFloat(sThirdPartyID2) >= 0)
	    {
	        dThirdParty = roundOff(dThirdParty,2);
	        
	        if(parseFloat(dThirdParty) >= 0)
	        {	     
	            dThirdPartyRatio = parseFloat(dThirdParty)/parseFloat(dThirdPartyID2)*100;
	            dThirdPartyRatio = roundOff(dThirdPartyRatio,2);
	            dThirdPartyRatio+="";
	             if(sBusinessType =="1110180" )
	             {
	             	setItemValue(0,getRow(),"ThirdParty3",dThirdPartyRatio);
	             }else //if(sBusinessType=="1110010" || sBusinessType=="1110020" || sBusinessType=="1110030" || sBusinessType=="1110040" )
				 {
	            	setItemValue(0,getRow(),"ThirdPartyZIP1",dThirdPartyRatio);
	             }
	        }
	    }
	}
	
	/*~[Describe=根据保证金比例计算保证金金额;InputParam=无;OutPutParam=无;]~*/
	function getBailSum()
	{
		/*默认与当前币种一样
	    sBusinessCurrency = getItemValue(0,getRow(),"BusinessCurrency");
	    sBailCurrency = getItemValue(0,getRow(),"BailCurrency");
		if (sBusinessCurrency != sBailCurrency)
			return;
		*/
	    dBusinessSum = getItemValue(0,getRow(),"BusinessSum");
	    if(parseFloat(dBusinessSum) >= 0)
	    {
	        dBailRatio = getItemValue(0,getRow(),"BailRatio");
	        dBailRatio = roundOff(dBailRatio,2);
	        if(parseFloat(dBailRatio) >= 0)
	        {	        
	            dBailSum = parseFloat(dBusinessSum)*parseFloat(dBailRatio)/100;
	            dBailSum = roundOff(dBailSum,2);
	            setItemValue(0,getRow(),"BailSum",dBailSum);
	        }
	    }
	}
	
	/*~[Describe=根据保证金金额计算保证金比例;InputParam=无;OutPutParam=无;]~*/
	function getBailRatio()
	{
	    /*默认与当前币种一样
	    sBusinessCurrency = getItemValue(0,getRow(),"BusinessCurrency");
	    sBailCurrency = getItemValue(0,getRow(),"BailCurrency");
		if (sBusinessCurrency != sBailCurrency)
			return;
		*/
	    dBusinessSum = getItemValue(0,getRow(),"BusinessSum");
	    if(parseFloat(dBusinessSum) >= 0)
	    {
	        dBailSum = getItemValue(0,getRow(),"BailSum");
	        if(parseFloat(dBailSum) >= 0)
	        {	        
				dBailSum = roundOff(dBailSum,2);
	            dBailRatio = parseFloat(dBailSum)/parseFloat(dBusinessSum)*100;
	            dBailRatio = roundOff(dBailRatio,2);
	            setItemValue(0,getRow(),"BailRatio",dBailRatio);
				if (dBailRatio=="100") {
					setItemValue(0,getRow(),"VouchType",'005');
					setItemValue(0,getRow(),"VouchTypeName",'信用');
				}
	        }
	    }
	}

	/*~[Describe=设置基准年利率;InputParam=无;OutPutParam=无;]~*/
	function setBaseRate()
	{
		var currency = getItemValue(0,getRow(),"BusinessCurrency");
		var termMonth = getItemValue(0,getRow(),"TermMonth");
		var termDay = getItemValue(0,getRow(),"TermDay");
		if(isNull(currency) || isNull(termMonth)){
			return;
		}
		if(isNull(termDay)) termDay = 0;
		
		termDay = parseInt(termMonth)*30+parseInt(termDay);
		
		var baseRateType = getItemValue(0,getRow(),"BaseRateType");
		if(isNull(baseRateType)){
			setItemValue(0,getRow(),"BaseRate","");
			setItemValue(0,getRow(),"BusinessRate","");
			setItemValue(0,getRow(),"BusinessRate","");
			return;
		}
		var baseRate = RunJavaMethod("com.amarsoft.app.util.CalcBaseRate", "getBaseRate", "RateType="+baseRateType+",TermDay="+termDay+",Currency="+currency);
		if(baseRate=="-9999"){
			alert("未能找到对应的基准利率，请检查期限和币种!");
			return;
		}
		setItemValue(0,getRow(),"BaseRate",baseRate);
		//设置执行利率
		getBusinessRate(); 
	}
	
	/*~[Describe=初始化数据;InputParam=无;OutPutParam=无;]~*/
	function initRow()
	{
		sOccurType = "<%=sOccurType%>";
		if(sOccurType == null || sOccurType==""){
			setItemValue(0,getRow(),"OccurType","010");
	    }		
		sObjectType = "<%=sObjectType%>";
		sBusinessType = "<%=sBusinessType%>";
		sManageUserID = getItemValue(0,getRow(),"ManageUserID");
		sPutOutOrgID = getItemValue(0,getRow(),"PutOutOrgID");
		sInputUserID = getItemValue(0,getRow(),"InputUserID");
		sOperateUserID = getItemValue(0,getRow(),"OperateUserID");
		//add by ttshao 2013/1/4
		var sOperateType=getItemValue(0,getRow(),"OPERATETYPE");
		if(isNull(sOperateType)){
			//信用证项下进口代付、汇款项下进口代付、并购项目贷款、代收项下进口代付、国内信用证项下买方代付业务增加贷款操作方式默认
			if(sBusinessType == "1080015" || sBusinessType == "1080110" || sBusinessType == "1030025" || sBusinessType == "1080090" || sBusinessType == "1090030"){
				setItemValue(0,getRow(),"OPERATETYPE","01");
		    }
		}
			
		//对于补登进来的合同，没有管户人信息或放贷机构值为空，自动设置为当前用户或当前机构
		if(sObjectType=="ReinforceContract"&&(typeof(sManageUserID)=="undefined"||sManageUserID=="")){
			setItemValue(0,getRow(),"ManageUserID","<%=CurUser.getUserID()%>");
			setItemValue(0,getRow(),"ManageUserName","<%=CurUser.getUserName()%>");
		}
		if(sObjectType=="ReinforceContract"&&(typeof(sPutOutOrgID)=="undefined"||sPutOutOrgID=="")){
			setItemValue(0,getRow(),"PutOutOrgID","<%=CurOrg.getOrgID()%>");
			setItemValue(0,getRow(),"PutOutOrgName","<%=CurOrg.getOrgName()%>");
		}
		if(sObjectType=="ReinforceContract"&&(typeof(sInputUserID)=="undefined"||sInputUserID=="")){
			setItemValue(0,getRow(),"InputUserID","<%=CurUser.getUserID()%>");
			setItemValue(0,getRow(),"InputUserName","<%=CurUser.getUserName()%>");
		}
		if(sObjectType=="ReinforceContract"&&(typeof(sOperateUserID)=="undefined"||sOperateUserID=="")){
			setItemValue(0,getRow(),"OperateUserID","<%=CurUser.getUserID()%>");
			setItemValue(0,getRow(),"OperateUserName","<%=CurUser.getUserName()%>");
		}
		var sBusinessCurrency = getItemValue(0,getRow(),"BusinessCurrency");//"<%=sOldBusinessCurrency%>";
		if(isNull(sBusinessCurrency)){
			setItemValue(0,getRow(),"BusinessCurrency","01");
			sBusinessCurrency="01";
		}	
		var sBaseRateType = getItemValue(0,getRow(),"BaseRateType");//"<%=sOldBusinessCurrency%>";
		if(isNull(sBaseRateType)){
			//币种为人民币,基准利率类型设置为人行基准利率,排除贴现业务、除公司委托贷款的typeno以2开头的业务、个人公积金贷款、进口信用证开立、备用信用证开立、福费庭、提货担保、国内信用证开立、国内信用证项下买方代付
			if(sBusinessCurrency=="01" && !(!isNull(sBusinessType) && (sBusinessType.indexOf("1020")==0 || sBusinessType.indexOf("3")==0 || (sBusinessType.indexOf("2")==0 && sBusinessType!="2070")) || ",1110180,1080005,1080007,1080060,1080410,1090010,1090030".indexOf(sBusinessType)>0)){
				setItemValue(0,getRow(),"BaseRateType","010");
			}
		}	

        //申请"福庭费"业务时，如果"票据币种"值为空，则设置为人名币
        if (sBusinessType == "1080060") {
            var sTradeCurrency = getItemValue(0,getRow(),"TradeCurrency");
            if (sTradeCurrency == "") {
                setItemValue(0,getRow(),"TradeCurrency","01");
           }
        }
				
		if(sBusinessType == "1100010" && sObjectType == "CreditApply" )
		{
			setItemValue(0,getRow(),"BusinessSum",0);
		}
		if(sOccurType == "015" && sObjectType == "CreditApply") //展期业务
		{
			setItemValue(0,getRow(),"Relativeagreement","<%=dOldSerialNo%>");
			setItemValue(0,getRow(),"TotalSum","<%=dOldBusinessSum%>");
			setItemValue(0,getRow(),"BusinessSum","<%=dOldBalance%>");
			setItemValue(0,getRow(),"BusinessCurrency","<%=sOldBusinessCurrency%>");
			setItemValue(0,getRow(),"TermDate1","<%=sOldMaturity%>");
			setItemValue(0,getRow(),"BaseRate","<%=dOldBusinessRate%>");
			setItemValue(0,getRow(),"ExtendTimes","<%=iExtendTimes%>");
		}
		//setItemValue(0,getRow(),"BusinessCurrency","01");
		if(sOccurType == "020") //借新还旧
		{
			//setItemValue(0,getRow(),"LNGOTimes","<%=iLNGOTimes%>");
		}
		if(sOccurType == "060") //还旧借新
		{
			setItemValue(0,getRow(),"GOLNTimes","<%=iGOLNTimes%>");
		}
		if(sOccurType == "030" && sObjectType == "CreditApply") //债务重组
		{
			setItemValue(0,getRow(),"DRTimes","<%=iDRTimes%>");
		}
		
		//销售门店
		setItemValue(0,getRow(),"Stores","<%=ssSno%>");
		setItemValue(0,getRow(),"StoresName","<%=sSname%>");
		//销售代表
		setItemValue(0,getRow(),"Salesexecutive","<%=CurUser.getUserID()%>");
		setItemValue(0,getRow(),"SalesexecutiveName","<%=CurUser.getUserName()%>");
		
		//展厅
		setItemValue(0,getRow(),"ExhibitionHall","<%=ssSno%>");
		setItemValue(0,getRow(),"ExhibitionHallName","<%=sSname%>");
		//经销商名称
		setItemValue(0,getRow(),"DealerName","<%=sServiceprovidersname%>");
		//经销商所属集团
		setItemValue(0,getRow(),"DealerGroup","<%=sGenusgroup%>");
		//所属车厂
		setItemValue(0,getRow(),"Depot","<%=sCarfactoryid%>");
	}
	//检测数据类型
	function CreditColumnCheck(sColumnName,sCheckType)
	{
		sCheckWord = getItemValue(0,getRow(),sColumnName);
		
		if(typeof(sCheckWord) != "undefined" && sCheckWord != "")	
		{
			if(!CheckTypeScript(sCheckWord,sCheckType))	
			{
				alert("数据类型不正确，请重新输入！");
				setItemValue(0,getRow(),sColumnName,"");
				return false;
			}
			return true;
		}
	}
	//检测是否是浮点数
	function isDigit(s)
	{
		var patrn=/^(-?\d+)(\.\d+)?$/;
		if (s!="" && !patrn.exec(s)) 
		{
			alert(s+"数据格式错误！");
			return false;
		}
		return true;
	}

	function isNull(value){
		if(typeof(value)=="undefined" || value==""){
			return true;
		}
		return false;
	}
	
	//add by ttshao 2012/1/4
	/*~[Describe=根据比例、金额计算押汇比例(%),索汇金额;InputParam=无;OutPutParam=无;]~*/
	function getBusinessSum(){
		var sOverDraftCurrent = getItemValue(0,getRow(),"RATIO");
		var sMFeeSum = getItemValue(0,getRow(),"MFeeSum");
		if(typeof(sOverDraftCurrent) == "undefined" || sOverDraftCurrent.length == 0
		|| typeof(sMFeeSum) == "undefined" || sMFeeSum.length == 0)
			return;
		
		var sValue = parseFloat(sOverDraftCurrent)*parseFloat(sMFeeSum)/parseFloat(100);
		setItemValue(0,getRow(),"BusinessSum",sValue+"");
	}
	
	/*~[Describe=计算每月还款额,自付金额，贷款本金，总价格联动;InputParam=无;OutPutParam=无;]~*/
	function getMonthPayment(){
		var sPrice1 = '0'+getItemValue(0,getRow(),"Price1");//价格1
		var sTotalSum1 = '0'+getItemValue(0,getRow(),"TotalSum1");//自付金额1
		var sPrice2 = '0'+getItemValue(0,getRow(),"Price2");//价格2
		var sTotalSum2 = '0'+getItemValue(0,getRow(),"TotalSum2");//自付金额2
		var sPrice3 = '0'+getItemValue(0,getRow(),"Price3");//价格3
		var sTotalSum3 = '0'+getItemValue(0,getRow(),"TotalSum3");//自付金额3
		
		var sValue1 = parseFloat(sPrice1)-parseFloat(sTotalSum1);//本金1
		setItemValue(0,getRow(),"BusinessSum1",sValue1+"");
		var sValue2 = parseFloat(sPrice2)-parseFloat(sTotalSum2);//本金2
		setItemValue(0,getRow(),"BusinessSum2",sValue2+"");
		var sValue3 = parseFloat(sPrice3)-parseFloat(sTotalSum3);//本金3
		setItemValue(0,getRow(),"BusinessSum3",sValue3+"");
		var sValue4 = parseFloat(sPrice1)+parseFloat(sPrice2)+parseFloat(sPrice3);//总价格
		setItemValue(0,getRow(),"TotalPrice",sValue4+"");
		var sValue5 = parseFloat(sTotalSum1)+parseFloat(sTotalSum2)+parseFloat(sTotalSum3);//自付金额
		setItemValue(0,getRow(),"TotalSum",sValue5+"");
		var sValue6 = parseFloat(sValue1)+parseFloat(sValue2)+parseFloat(sValue3);//本金
		setItemValue(0,getRow(),"BusinessSum",sValue6+"");
		
		var sBusinessSum = getItemValue(0,getRow(),"BusinessSum");//本金
		var sTotalSum = getItemValue(0,getRow(),"TotalSum");//自付金额
		var sPeriods = getItemValue(0,getRow(),"Periods");//分期期数
		var sBusinessType="<%=sBusinessType%>";
		if(parseFloat(sBusinessSum) > 0 && parseFloat(sPeriods) > 0){
			 if(parseFloat(sTotalSum)-parseFloat(sBusinessSum)>0){
				alert("自付总金额不能大于贷款总本金!");
				return;
			}else{
				var sMonthPayment=RunMethod("PublicMethod","GetMonthPayment",sBusinessSum+","+sBusinessType+","+sPeriods);
				setItemValue(0,getRow(),"MonthRepayment",parseFloat(sMonthPayment).toFixed(2)+"");
			}
		}
	}
</script>

<script type="text/javascript">
//身份证正则表达校验
function isCardNo()  
{
	var card = getItemValue(0,getRow(),"IdentityID");
	//alert("==================="+card);
	
   // 身份证号码为15位或者18位，15位时全为数字，18位前17位为数字，最后一位是校验位，可能为数字或字符X   
   var reg = /(^\d{15}$)|(^\d{18}$)|(^\d{17}(\d|X|x)$)/;  
   if(reg.test(card) === false)  
   {  
      alert("身份证输入不合法");  
       return  false;  
   }  
}


function getFoucs(){
	alert("他飞快地");
}
</script>



<script type="text/javascript" src="<%=sWebRootPath%>/Accounting/js/loan/loaninfo.js"></script>
<script type="text/javascript" src="<%=sWebRootPath%>/Accounting/js/loan/common.js"></script>

<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info08;Describe=页面装载时，进行初始化;]~*/%>
<script type="text/javascript">	
	AsOne.AsInit();
	init();
	bFreeFormMultiCol=true;
	my_load(2,0,'myiframe0');
	initRow();	
	/*------------------核算加入JS代码---------------*/
	afterLoad("<%=sObjectType%>","<%=sObjectNo%>"); 
	/*------------------核算加入JS代码---------------*/
</script>
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>
