<%@page import="com.amarsoft.proj.action.P2PCreditCommon"%>
<%@page import="com.amarsoft.app.accounting.config.loader.DateFunctions"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%@page import="com.amarsoft.app.bizmethod.*,com.amarsoft.app.accounting.businessobject.BUSINESSOBJECT_CONSTATNTS"%>



<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main00;Describe=注释区;]~*/%>
<%
	/*
		Author:   rqiao 20150413
		Tester:
		Content: CCS-574 PRM-256 原地复活计划安硕系统需求
		Input Param:
				 ObjectType：对象类型
				 ObjectNo：对象编号
		Output param:
		History Log: xswang 2015/06/01 CCS-713 合同中的门店跳转为其他门店
	 */
	%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info01;Describe=定义页面属性;]~*/%>
<%
	String PG_TITLE = "重新保存业务详情"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量：对象主表名、对应关联表名、SQL语句、产品类型、客户代码、显示属性、产品版本
	String sMainTable = "",sRelativeTable = "",sSql = "",sBusinessType = "",sCustomerID = "",sColAttribute = "",sThirdParty="0.0",sProductVersion="",sSalesexecutive="",sSalesexecutiveName="";
	//定义变量：查询列名、显示模版名称、申请类型、发生类型、暂存标志
	String sFieldName = "",sDisplayTemplet = "",sApplyType = "",sOccurType = "",sTempSaveFlag = "",sProductid="",sProductcategoryname="",sProductcategoryId="";
	//定义变量：关联业务币种、关联业务到期日、关联流水号、借据号
	String sOldBusinessCurrency = "",sOldMaturity = "",sRelativeSerialNo = "",dOldSerialNo = "",ssSno="",sSno="",sSname="",ssSname="",sServiceprovidersname="",sGenusgroup="",sCarfactoryid="",sCreditId="",sCreditPerson="",sCity="",sAttr2="",sCarfactory="";
	// 定义变量： 门店经理，城市经理
	String sSalesManager = "", sCityManager = "", sSalesManagerName = "", sCityManagerName = "";
	//定义变量：关联业务金额、关联业务利率、关联业务余额
	double dOldBusinessSum = 0.0,dOldBusinessRate = 0.0,dOldBalance = 0.0,dThirdPartyRatio=0.0,dThirdParty=0.0;
	//定义变量：展期次数、借新还旧次数、还旧借新次数、债务重组次数
	int iExtendTimes = 0,iLNGOTimes = 0,iGOLNTimes = 0,iDRTimes = 0,dTermDay=0;
	//定义变量：产品子类型
	String sSubProductType = "";
	//定义变量：查询结果集
	ASResultSet rs = null;
	String subProductTypename ="";//子类型
	//获得页面参数	
	String sObjectType = DataConvert.toString((String)CurComp.getParameter("ObjectType"));	
	String sObjectNo =  DataConvert.toString((String)CurComp.getParameter("ObjectNo"));
	
	String sApproveNeed =  CurConfig.getConfigure("ApproveNeed");
	
	//将空值转化成空字符串
	if(sObjectType == null) sObjectType = "";
	if(sObjectNo == null) sObjectNo = "";
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info03;Describe=定义数据对象;]~*/%>
<%	
    
     //销售门店
     //String sNo = CurARC.getAttribute(request.getSession().getId()+"city");
	//add by xswang 2015/06/01 CCS-713 合同中的门店跳转为其他门店
     //String sNo = Sqlca.getString(new SqlObject("select attribute8 from user_info  where userid=:UserID").setParameter("UserID", CurUser.getUserID()));
     String sNo = CurUser.getAttribute8();
 	// end by xswang 2015/06/01
 	
   //客户主管    add by ybpan at 20150409 CCS-588  系统中增加中域ALDI模式的客户主管
     String sCustomerHolder= Sqlca.getString(new SqlObject("select SalesManNO  as CustomerHolder from STORERELATIVESALESMAN where SNO=:sSNO and SALETYPE='02'").setParameter("sSNO",sNo ));
     String sCustomerHolderName= Sqlca.getString(new SqlObject("select getUserName(SalesManNO)  as CustomerHolder from STORERELATIVESALESMAN where SNO=:sSNO and SALETYPE='02'").setParameter("sSNO",sNo ));
     
     if(sNo == null) sNo = "";
     if(sCustomerHolder == null) sCustomerHolder = "";
     if(sCustomerHolderName == null) sCustomerHolderName = "";
     
     
     //"select sno,sname, SALESMANAGER, getusername(SALESMANAGER) as  SALESMANAGERNAME, CITYMANAGER, getusername(CITYMANAGER) as CITYMANAGERNAME  from store_info where sno = :sno and  identtype = '01'";
     //修改城市经理从销售经理的上级取得。 edit by Dahl 2015-03-17
     sSql="select si.sno,si.sname, si.SALESMANAGER, getusername(si.SALESMANAGER) as  SALESMANAGERNAME, ui.superId as CITYMANAGER, getusername(ui.superId) as CITYMANAGERNAME from store_info si ,user_info ui where si.salesmanager=ui.userid and sno = :sno and  identtype = '01'";
     rs=Sqlca.getASResultSet(new SqlObject(sSql).setParameter("sno",sNo));
     if(rs.next()){
    	 sSno = DataConvert.toString(rs.getString("sno"));//门店
    	 sSname = DataConvert.toString(rs.getString("sname"));
    	 sSalesManager = DataConvert.toString(rs.getString("SALESMANAGER"));		// 销售经理
    	 sCityManager = DataConvert.toString(rs.getString("CITYMANAGER")); 	// 城市经理
    	 sSalesManagerName = DataConvert.toString(rs.getString("SALESMANAGERNAME"));		// 销售经理
    	 sCityManagerName = DataConvert.toString(rs.getString("CITYMANAGERNAME")); 	// 城市经理
    	 //打印log，以备以后合同表销售经理为空时，跟踪数据。 add by Dahl 2015-03-17
    	 ARE.getLog().info("\n"+sObjectNo+"-------销售门店-------"+sNo+"\n-------销售经理-------"+sSalesManager+"\n-------城市经理-------"+sCityManager);
    	 
 		//将空值转化成空字符串
 		if(sSno == null) sSno = "";
 		if(sSname == null) sSname = "";
 		if (sSalesManager == null) sSalesManager = "";
 		if (sCityManager == null) sCityManager = "";
 		if (sSalesManagerName == null) sSalesManagerName = "";
 		if (sCityManagerName == null) sCityManagerName = "";
     }
     rs.getStatement().close();
     
     //销售代表联系方式
     String sSalesexecutivePhone =Sqlca.getString("select MobileTel from user_info where UserID = '"+CurUser.getUserID()+"'");
     if(null == sSalesexecutivePhone) sSalesexecutivePhone = "";
     
     String sCityName = "" ;//区域中文名
     //汽车贷款处理
     sSql="select si.city as city,getitemname('AreaCode',si.city) as cityName,si.sno as sno,si.sname as sname,sp.serviceprovidersname as serviceprovidersname,sp.genusgroup as genusgroup,sp.carfactoryid as carfactoryid,sp.carfactory as carfactory from store_info si,service_providers sp where si.rserialno=sp.serialno and si.identtype='02' and sp.customertype1='07' and si.sno=:sno";
     rs=Sqlca.getASResultSet(new SqlObject(sSql).setParameter("sno",sNo));
     if(rs.next()){
    	 ssSno = DataConvert.toString(rs.getString("sno"));//展厅编号
    	 ssSname = DataConvert.toString(rs.getString("sname"));//展厅名称
    	 sServiceprovidersname = DataConvert.toString(rs.getString("serviceprovidersname"));//服务商名称
    	 sGenusgroup = DataConvert.toString(rs.getString("genusgroup"));//所属集团
    	 sCarfactoryid = DataConvert.toString(rs.getString("carfactoryid"));//所属车厂ID
    	 sCarfactory = DataConvert.toString(rs.getString("carfactory"));//所属车厂名称
    	 sCity = DataConvert.toString(rs.getString("city"));//区域
    	 sCityName = DataConvert.toString(rs.getString("cityName"));//区域
     }
     rs.getStatement().close();
     
     ARE.getLog().debug("======"+sCity+","+ssSno+","+ssSname+","+sServiceprovidersname+","+sGenusgroup+","+sCarfactoryid+","+sCarfactory);
     
	

	  String sCreditAttribute = "";//0002消费/0001汽车/0003经销商/0004小企业贷款
     
     //查询销售代表
     sSql="select Salesexecutive,getusername(Salesexecutive) as SalesexecutiveName,ProductID,CreditAttribute,SubProductType from business_contract where serialno=:serialno";
     rs=Sqlca.getASResultSet(new SqlObject(sSql).setParameter("serialno",sObjectNo));
     if(rs.next()){
    	 sSalesexecutive = DataConvert.toString(rs.getString("Salesexecutive"));//销售代表ID
    	 sSalesexecutiveName = DataConvert.toString(rs.getString("SalesexecutiveName"));//销售代表Name
    	 
    	 sProductid = DataConvert.toString(rs.getString("ProductID"));//产品类型
    	 sCreditAttribute =  DataConvert.toString(rs.getString("CreditAttribute"));//产品类型
    	 
    	 sSubProductType = DataConvert.toString(rs.getString("SubProductType"));//产品子类型
    	 
 		//将空值转化成空字符串
 		if(sSalesexecutive == null) sSalesexecutive = "";
 		if(sSalesexecutiveName == null) sSalesexecutiveName = "";
     }
     rs.getStatement().close();
     
     String ssCity = Sqlca.getString(new SqlObject("select city from store_info si where si.sno=:sno").setParameter("sno", sNo));
   	//获取贷款人信息(汽车金融与消费金融取值逻辑一直)
       sSql="select sp.serialno as SerialNo, sp.serviceprovidersname as ServiceProvidersName "+
    	         "from Service_Providers sp,ProvidersCity pc where sp.customertype1 = '06' and pc.ProductType = '"+sSubProductType+"' "+
    		     "and pc.serialno=sp.serialno and sp.loaner = '010' and pc.areacode='"+ssCity+"'";
 	   rs=Sqlca.getASResultSet(sSql);
       if(rs.next()){
      	 sCreditId = DataConvert.toString(rs.getString("SerialNo"));//贷款人编号
      	 sCreditPerson = DataConvert.toString(rs.getString("ServiceProvidersName"));//贷款人名称
      	
   		//将空值转化成空字符串
   		if(sCreditId == null) sCreditId = "";
   		if(sCreditPerson == null) sCreditPerson = "";
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
		
		// fixme 未判断根据申请类型改变成相应的模板号
		if (sDisplayTemplet == null) sDisplayTemplet = "ContractInfo1210";
		
		String	SubProductTypesSql = 	" select SubProductType from BUSINESS_CONTRACT where  SerialNo =:SerialNo ";
		 subProductTypename = Sqlca.getString(new SqlObject(SubProductTypesSql).setParameter("SerialNo",sObjectNo));
		if ("5".equals(subProductTypename)){//学生贷 quliangmao
				sDisplayTemplet = "School001";
			}else if ("4".equals(subProductTypename)){//成人贷
				sDisplayTemplet = "School002";
			}
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
	
	//获取关联产品的参数
	String LowPrinciPalMin = "",TallPrinciPalMax = "",ShoufuRatio = "",ShoufuRatioType = "",sRateType = "",monthcalculationMethod = "",sRateFloatType="",cProductType="";
	String highestLoansProportion = "",whetherDiscount = "" ,dMonthlyInterstRate="";
	int iPeriods = 0;
		String sSqlBT = " select term,MONTHLYINTERESTRATE,LOWPRINCIPAL,TALLPRINCIPAL,SHOUFURATIO,SHOUFURATIOTYPE,ratetype,monthcalculationMethod,floatingManner,highestLoansProportion,whetherDiscount,producttype from business_type where typeno='"+sBusinessType+"' ";
		rs = Sqlca.getASResultSet(new SqlObject(sSqlBT));
		while(rs.next()){
			iPeriods = rs.getInt("term");
			LowPrinciPalMin = rs.getString("LOWPRINCIPAL");
			TallPrinciPalMax = rs.getString("TALLPRINCIPAL");
			ShoufuRatio = rs.getString("SHOUFURATIO");
			ShoufuRatioType = rs.getString("SHOUFURATIOTYPE");
			sRateType = DataConvert.toString(rs.getString("rateType"));//利率类型  modify by jli5 处理null
			monthcalculationMethod = rs.getString("monthcalculationMethod");//月供计算方式
			sRateFloatType = rs.getString("floatingManner");//利率浮动方式
			dMonthlyInterstRate = rs.getString("MONTHLYINTERESTRATE");//产品月利率
			
			highestLoansProportion = rs.getString("highestLoansProportion");//最高贷款比例
			whetherDiscount = rs.getString("whetherDiscount");//是否贴息
			cProductType = rs.getString("producttype");//区分汽车金融/融资租赁 01：汽车，02：融资
			
		}
		rs.getStatement().close();
		
	//是否有保险费
	String productobjectno = sBusinessType+"-V1.0";
	Double CredFeeRate = 0.0;
	Double CredFeeRateAll = 0.0;
	String CredTermID = Sqlca.getString(new SqlObject("select termid from product_term_library where subtermtype = 'A12' and objecttype='Product' and objectno='"+productobjectno+"' "));
	if(CredTermID==null) CredTermID = "";
	if("".equals(CredTermID)){
		doTemp.setReadOnly("CreditCycle", true);
		doTemp.setRequired("CreditCycle", false);
	}else{
		CredFeeRate = DataConvert.toDouble(Sqlca.getString(new SqlObject("select defaultvalue from product_term_para where paraid='FeeRate' and termid = '"+CredTermID+"' and objectno='"+productobjectno+"' ")));
		CredFeeRateAll = CredFeeRate*iPeriods;
	}
	
	ARE.getLog().debug("======CredFeeRateAll======"+CredFeeRateAll);
	
	String tTermTemp="",tTerm = "",tLoanFixedRate = "",tHighestFixedRate = "",tShouFuRatio = "",tRateFloat = "", tSectionRatio = "",tDealcomminssion = "",tSalesComminssion="",tDisCountFixedRate="",tSectionFixedRate="";
	if("0001".equals(sCreditAttribute)){//车贷期限参数
		sSql = 	"SELECT term,loanfixedrate,highestfixedrate,shoufuratio,floatingrate,sectionratio,dealercommissionrate,salescommission,discountfixedrate,sectionfixedrate FROM term where typeno=:sBusinessType and status='1' ";	
		rs = Sqlca.getASResultSet( new SqlObject(sSql).setParameter("sBusinessType",sBusinessType));
		if(rs.next()){
			tTerm = rs.getString("term");//期限
			tLoanFixedRate = rs.getString("loanfixedrate");//贷款固定利率
			tHighestFixedRate = rs.getString("highestfixedrate");//最高固定利率
			tShouFuRatio = rs.getString("shoufuratio");//首付比例
			tRateFloat = rs.getString("floatingrate");//浮动幅度
			tSectionRatio = rs.getString("sectionratio");//尾款比例
			tDealcomminssion = rs.getString("dealercommissionrate");
			tSalesComminssion = rs.getString("salescommission");
			tDisCountFixedRate	 = rs.getString("discountfixedrate");//贴息客户固定利率
			tSectionFixedRate = rs.getString("sectionfixedrate");//尾款固定利率
		}
		rs.getStatement().close();
		
		//add by jli5 增加null处理 
		if(tTerm==null) tTerm="0";
		if(tLoanFixedRate==null) tLoanFixedRate="0";
		if(tHighestFixedRate==null) tHighestFixedRate="0";
		if(tShouFuRatio==null) tShouFuRatio="0";
		if(tRateFloat==null) tRateFloat="0";
		if(tSectionRatio==null) tSectionRatio="0";
		if(tDealcomminssion==null) tDealcomminssion="0";
		if(tSalesComminssion==null) tSalesComminssion="0";
		if(tDisCountFixedRate==null) tDisCountFixedRate="0";
		if(tSectionFixedRate==null) tSectionFixedRate="0";
		
		if("02".equals(monthcalculationMethod)||"04".equals(monthcalculationMethod)){//尾款不计息
			tSectionFixedRate = "0.0";
		}
		//end 
		if(Integer.parseInt(tTerm)<=6){
			tTermTemp = "0"; 
		}else if(Integer.parseInt(tTerm)>6&&Integer.parseInt(tTerm)<=12){
			tTermTemp = "1"; 
		}else if(Integer.parseInt(tTerm)>12&&Integer.parseInt(tTerm)<=36){
			tTermTemp = "2"; 
		}else if(Integer.parseInt(tTerm)>36&&Integer.parseInt(tTerm)<=60){
			tTermTemp = "3"; 
		}
	}
	double cCreditRate = 0.0d;//贷款利率
	//人行贷款利率需修改
	//String cRateValue = Sqlca.getString(new SqlObject("select rateValue from rate_info where ratetype = '010' and rateunit='02' and termunit='020' and status='1' and term='"+tTerm+"' "));
	//汽车金融  根据产品类型   显示模版控制 add by jli5 
	if("0001".equals(sCreditAttribute)){
		String cRateValue = Sqlca.getString(new SqlObject("select yearsinterestrate from Interest_Rate where interestratetype='01' and isinuse='1' "+ 
		        " and to_date(to_char(sysdate, 'yyyy/MM/dd'), 'yyyy/mm/dd')>=to_date(effectivedate, 'yyyy/MM/dd') and term='"+tTermTemp+"' and rownum='1' "));
		if(cRateValue==null) cRateValue="0";
		if("01".equals(monthcalculationMethod)){
			doTemp.setVisible("FinalPayment,FinalPaymentSum", false);
		}
		if(cProductType.equals("02")){
			
		}
		System.out.println("利率类型："+sRateType+"期限："+tTerm+"人行基准利率："+cRateValue+"浮动幅度："+tRateFloat+"贷款利率："+(Float.parseFloat(cRateValue)*(1+Float.parseFloat(tRateFloat)*0.01)));
		if(sRateType.equals("RAT004")){//固定灵活利率
			doTemp.setReadOnly("CreditRate", false);
			doTemp.setRequired("CreditRate", true);
			cCreditRate = Double.parseDouble(tLoanFixedRate);
		}else if(sRateType.equals("RAT001")){//浮动利率
			if(sRateFloatType.equals("0")){//浮动比例
				cCreditRate = (Double.parseDouble(cRateValue)+(Double.parseDouble(cRateValue)*Double.parseDouble(tRateFloat)*0.01));
			}else if(sRateFloatType.equals("1")){//按浮动点
				cCreditRate = (Double.parseDouble(cRateValue)+Double.parseDouble(tRateFloat));
			}
		}else{
			cCreditRate = Double.parseDouble(tLoanFixedRate);
		}
		doTemp.setDefaultValue("PaymentRate", tShouFuRatio);
		
		//金融经理姓名
		doTemp.setReadOnly("ManagerName,DealerGroup,Depot,CustomerName,ProductName,CreditPerson", true);
		doTemp.setUnit("ManagerName", "<input type=\"button\" value=\"...\" class=\"inputdate\" onclick=\"parent.selectManage()\">");
		doTemp.setVisible("ManageUserID", false);
		doTemp.setUpdateable("ManagerName,ManageUserID", true);
		
	}
	
	//若产品关联了提前还款手续费 申请阶段删除此费用，做提前还款申请时再产生费用记录
	String tqhksxfTermID = Sqlca.getString(new SqlObject("select termid from product_term_library where subtermtype = 'A9' and objecttype='Product' and objectno='"+productobjectno+"' "));
	if(tqhksxfTermID == null) tqhksxfTermID = "";
	
	//edit by phe 20150305 CCS-470
	 String sOperatorMode =  Sqlca.getString(new SqlObject("select OperatorMode from Business_Contract where  serialno='"+sObjectNo+"' "));
	 if(sOperatorMode==null) sOperatorMode = "";
	  if(sOperatorMode.equals("01")){
		
		doTemp.setRequired("PromotersName",true);
		doTemp.setRequired("Idcard",true);
		doTemp.setRequired("Phone",true);
		
	}   
%>
<%
   doTemp.setReadOnly("CustomerType", true);//add by jli5 客户申请类型不能修改
   
	// 门店显示 add by tbzeng 2014/09/17
   if ("0002".equals(sCreditAttribute)) {
   	doTemp.setVisible("Stores,StoresName", true);
   	doTemp.setReadOnly("Stores,StoresName", true);
   	doTemp.setHeader("Stores", "门店编号");
   }
   // end --------------
   
   //仅在无预约现金贷，合同详情页面展示“推荐人”信息
     if (!"2".equals(sSubProductType)) {
   	doTemp.setVisible("Recommender", false);
   }
   //end
    doTemp.setVisible("",false);
	//生成DataWindow对象	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	//设置DW风格 1:Grid 2:Freeform
	dwTemp.Style="2";      
	//设置是否只读 1:只读 0:可写
	dwTemp.ReadOnly = "1"; 
	
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
	
	/* //首次还款金额
	dwTemp.setEvent("AfterUpdate","!LoanAccount.PutOutLoanTry("+sObjectNo+")"); */
	
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
	
/*
	//判断是否为p2p合同， add by Dahl 2015-3-31
	P2PCreditCommon p2p = new P2PCreditCommon(sObjectNo, Sqlca);
	boolean isP2p = p2p.isUseP2P();
	ARE.getLog().debug("P2P判断结束,合同"+sObjectNo+"是否为P2P合同"+isP2p+"，结束时间为："+StringFunction.getNow());
	//end by Dahl 2015-3-31 	
*/
	String sIsP2p = Sqlca.getString("select isP2p from Business_Contract where SerialNo = '"+sObjectNo+"'");

	//获取贷款人的相关信息
	String RepaymentNo = "";//还款账号
	String RepaymentBank = "";//还款账号开户行
	String RepaymentName = "";//还款账号户名
	String RepaymentBankName = "";
	String sCreditid = Sqlca.getString("select CreditID from Business_Contract where SerialNo = '"+sObjectNo+"'");
	sSql = "select pc.backAccountPrefix,pc.turnAccountName,pc.turnAccountBlank,getItemName('BankCode', pc.turnAccountBlank) as RepaymentBankName "+
	       "from Service_Providers sp,ProvidersCity pc where sp.SerialNo = :SerialNo "+
	       "and pc.serialno = sp.serialno and pc.areacode = '"+ssCity+"' and pc.ProductType = '"+sSubProductType+"'";
	SqlObject soSer = new SqlObject(sSql).setParameter("SerialNo", sCreditid);
	rs = Sqlca.getASResultSet(soSer);
	if(rs.next()){
		RepaymentNo = rs.getString("backAccountPrefix");
		RepaymentBank = rs.getString("turnAccountBlank");
		RepaymentName = rs.getString("turnAccountName");
		RepaymentBankName = rs.getString("RepaymentBankName");
	}
	//update CCS-399(消费贷默认显示为”四海支行“，现金贷默认显示为”安联支行  “;)
	if(RepaymentNo == null || RepaymentNo == "") 
	{
		if("020".equals(sProductid))//现金贷
		{
			RepaymentNo = "755920947910303";
		}else if("1".equals(sIsP2p))	//p2p
		{
			RepaymentNo = "755920947910212";
		}else
		{
			RepaymentNo = "755920947910920";
			  
		}
	}
	if(RepaymentBank == null || RepaymentBank == "") RepaymentBank = "308";
	if(RepaymentBankName == null || RepaymentBankName == "") 
	{
		if("020".equals(sProductid) || "1".equals(sIsP2p) )//现金贷或p2p
		{
			RepaymentBankName = "招商银行股份有限公司深圳安联支行";
		}else
		{
			RepaymentBankName = "招商银行深圳四海支行";
		}
	}
	if(RepaymentName == null || RepaymentName == "") RepaymentName = "深圳市佰仟金融服务有限公司";
	//end
	rs.getStatement().close();
	
	RepaymentNo = RepaymentNo+Sqlca.getString("select CustomerID from Business_Contract where SerialNo = '"+sObjectNo+"'");
	
	//update CCS-399(消费贷默认显示为”四海支行“，现金贷默认显示为”安联支行  “;)
	if("020".equals(sProductid) || "1".equals(sIsP2p) )//现金贷或p2p
	{
		RepaymentBankName = "招商银行股份有限公司深圳安联支行";
	}else
	{
		RepaymentBankName = "招商银行深圳四海支行";
	}
	//end
		
	
	//获取客户保存状态
	String sCTempSaveFlag = Sqlca.getString(new SqlObject("select Tempsaveflag from Ind_Info where CustomerID =:CustomerID").setParameter("CustomerID", sCustomerID));
	
	//首次还款日
	String sFirstDueDate = "";
	String sDefaultDueDay = "";
	String temDay = "";
	String sSpecialDay = "";//是否特殊发放日
	int iDaytemp =0;
	String businessDate = SystemConfig.getBusinessDate();
	
	temDay = businessDate.substring(8, 10);
	if(temDay.equals("29")){
		temDay = "02";
		sDefaultDueDay = DateFunctions.getRelativeDate(businessDate, DateFunctions.TERM_UNIT_MONTH, 2);
		sFirstDueDate = sDefaultDueDay.substring(0, 8)+temDay;
		sSpecialDay = "1";
	}else if(temDay.equals("30")){
		temDay = "03";
	    sDefaultDueDay = DateFunctions.getRelativeDate(businessDate, DateFunctions.TERM_UNIT_MONTH, 2);
		sFirstDueDate = sDefaultDueDay.substring(0, 8)+temDay;
		sSpecialDay = "1";
	}else if(temDay.equals("31")){
		temDay = "04";
	    sDefaultDueDay = DateFunctions.getRelativeDate(businessDate, DateFunctions.TERM_UNIT_MONTH, 2);
		sFirstDueDate = sDefaultDueDay.substring(0, 8)+temDay;
		sSpecialDay = "1";
	}else{
		sFirstDueDate = DateFunctions.getRelativeDate(businessDate, DateFunctions.TERM_UNIT_MONTH, 1);
	}
	iDaytemp = DateFunctions.getDays(DateFunctions.getRelativeDate(businessDate, DateFunctions.TERM_UNIT_MONTH, 1), sFirstDueDate);
	
	//一个客户多个合同的情况，判定首次还款日，取客户之前最早的合同
	String sFirstNextDueDate = "";
	int sDays=0;
	String minSerialNo = Sqlca.getString(new SqlObject("SELECT min(serialno) FROM business_contract where finishdate is null and CONTRACTSTATUS = '050' and customerid = :CustomerID and serialno <> :serialno ").setParameter("CustomerID", sCustomerID).setParameter("serialno", sObjectNo));
	if(minSerialNo == null) minSerialNo = "";
	if(!minSerialNo.equals("")){
		sFirstNextDueDate = Sqlca.getString(new SqlObject("SELECT NEXTDUEDATE FROM acct_loan where loanstatus in ('0','1') and putoutno = :minSerialNo ").setParameter("minSerialNo", minSerialNo));	
		if(sFirstNextDueDate == null) sFirstNextDueDate = "";
		if(sFirstNextDueDate.compareTo(businessDate)<=0) sFirstNextDueDate = sFirstDueDate;
		if(!sFirstNextDueDate.equals("")){
			sDays = DateFunctions.getDays(businessDate, sFirstNextDueDate);
			if(sDays >= 14){
				sFirstDueDate = sFirstNextDueDate;
			}else{
				sFirstDueDate = DateFunctions.getRelativeDate(sFirstNextDueDate, DateFunctions.TERM_UNIT_MONTH, 1);
			}
			temDay = sFirstDueDate.substring(8, 10);
		}		
	}
	
	//String sMaturity = DateFunctions.getRelativeDate(sFirstDueDate, DateFunctions.TERM_UNIT_MONTH, iPeriods-1);
	String sMaturity = DateFunctions.getRelativeDate(businessDate, DateFunctions.TERM_UNIT_MONTH, iPeriods);
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
	};
	%>
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=Info05;Describe=主体页面;]~*/%>
<%@include file="/Resources/CodeParts/Info05.jsp"%>
<%/*~END~*/%>

<script type="text/javascript">
	/*~[Describe=保存;InputParam=后续事件;OutPutParam=无;]~*/
	function saveRecord()
	{	
		ShowMessage("系统正在提交，请等待...",true,true);
			beforeUpdate();
			if(!saveSubItem()) return;
			setItemValue(0,getRow(),"TempSaveFlag","2"); //暂存标志（1：是；2：否）
			var returnvalue = inserTermPara();//加入利率，还款方式
			/* if(!returnvalue){
				alert("产生费用记录出错,请检查再重新保存！");
				return;
			} */
			var xxx = SetBusinessMaturity();//合同保存为合同生效
			if(!xxx) {
				setItemValue(0,getRow(),"TempSaveFlag","1"); //暂存标志（1：是；2：否）
			}
			//暂时这样写 放款试算失败合同保存标记置为暂存
			if(!firstMonthPayTry()){
				setItemValue(0,getRow(),"TempSaveFlag","1"); //暂存标志(1：是；2：否)
			}
			as_save("myiframe0",UpdatePromoters());
	}
	
	
	//edit by phe 20150305 CCS-470
	/*~[Describe=更新零售商信息;InputParam=无;OutPutParam=无;]~*/
	function UpdatePromoters(){
		var SerialNo=getItemValue(0,getRow(),"SerialNo");//合同流水号
		var sPromotersName=getItemValue(0,getRow(),"PromotersName");
		var sIdcard=getItemValue(0,getRow(),"Idcard");
		var sPhone=getItemValue(0,getRow(),"Phone");
		var sStores=getItemValue(0,getRow(),"Stores");
		var sRSerialno=RunMethod("BusinessManage", "selectRSerialno", sStores);
		
		var count=RunMethod("BusinessManage", "selectPromoterCount", SerialNo);
		if(count=="0.0"){
			<%-- <%=CurUser.getUserID()%>,<%=CurUser.getOrgID()%>,<%=StringFunction.getToday()%> --%>
			RunMethod("BusinessManage", "InsertPromoterInfo", SerialNo+",,"+sPromotersName+","+sPhone+","+sIdcard+","+sStores+","+sRSerialno+","+'<%=CurUser.getOrgID()%>'+","+'<%=CurUser.getUserID()%>'+","+'<%=StringFunction.getToday()%>');
		}else{
			RunMethod("BusinessManage", "UpdatePromoterInfo", ","+sPromotersName+","+sPhone+","+sIdcard+","+sStores+","+sRSerialno+","+'<%=CurUser.getOrgID()%>'+","+'<%=CurUser.getUserID()%>'+","+'<%=StringFunction.getToday()%>'+","+SerialNo);

		}
		
	}
	
	
	/*~[Describe=计算到期日;InputParam=无;OutPutParam=无;]~*/
	function SetBusinessMaturity(){
		var SerialNo=getItemValue(0,getRow(),"SerialNo");//合同流水号
		var sPutOutDate = "<%=SystemConfig.getBusinessDate()%>";
		var sFirstDueDate = "<%=sFirstDueDate%>";
		//设置首次还款日
		RunMethod("PublicMethod","UpdateColValue","String@FIRSTDUEDATE@"+sFirstDueDate+",acct_rpt_segment,String@ObjectNo@"+SerialNo);//首次还款日	
		RunMethod("PublicMethod","UpdateColValue","String@ORIGINALPUTOUTDATE@"+sFirstDueDate+",BUSINESS_CONTRACT,String@SerialNo@"+SerialNo);//首次还款日
		
		var sDay = sPutOutDate.substring(8,10); 
		var deDaultDueDay = "<%=temDay%>";
		
		RunMethod("PublicMethod","UpdateColValue","String@defaultdueday@"+deDaultDueDay+",acct_rpt_segment,String@ObjectNo@"+SerialNo);//合同默认还款日	
		var sTermMonth_ = RunMethod("GetElement","GetElementValue","Periods,business_contract,SerialNo='"+SerialNo+"'");//期限
		var sTermMonth = parseInt(sTermMonth_,10);
		var sMaturity = "";
		if(typeof(sTermMonth)== "undefined" || sTermMonth.length == 0 ) {
			alert("合同未录入贷款期次！");
			return false;
		}
		if(sTermMonth !=0){
		   sLoanTermFlag ="020";//期限单位(月)
		   sMaturity = RunMethod("BusinessManage","CalcMaturity",sLoanTermFlag+","+sTermMonth+","+sPutOutDate);
		}
		
		sMaturity = "<%=sMaturity%>";
		if(sMaturity==""||sMaturity==null){
			alert("到期日为空，请重新检查！");
			return false;
		}
		RunMethod("PublicMethod","UpdateColValue","String@PutOutDate@"+sPutOutDate+",BUSINESS_CONTRACT,String@SerialNo@"+SerialNo);//合同生效日
		RunMethod("PublicMethod","UpdateColValue","String@contractEffectiveDate@"+sPutOutDate+",BUSINESS_CONTRACT,String@SerialNo@"+SerialNo);//合同生效日
		RunMethod("PublicMethod","UpdateColValue","String@Maturity@"+sMaturity+",BUSINESS_CONTRACT,String@SerialNo@"+SerialNo);//合同到期日
		
		/* //首次还款金额
		firstMonthPayTry(); */
		
		//return firstMonthPayTry();
		return true;
	}
	
	//首次还款金额、贷款试算
	function firstMonthPayTry(){
		//首期还款还款金额
		var dMonthlyInterstRate = "<%=dMonthlyInterstRate%>";//产品月利率
		var dBusinessSum = getItemValue(0,getRow(),"BusinessSum");//贷款本金
		var dMonthRepayment = getItemValue(0,getRow(),"MonthRepayment");
		var iDaytemp="<%=iDaytemp%>";
		
		//特殊日子放款试算 暂时屏蔽  待修改
		var sSpecialDay = "<%=sSpecialDay%>";
		var sContractSerialNo = "<%=sObjectNo%>";
		//if("1"==sSpecialDay){
			//贷款试算
			var paymentValue = RunMethod("LoanAccount","PutOutLoanTry", sContractSerialNo);
			if(paymentValue==""||paymentValue==null||typeof(paymentValue)=="undefined"||paymentValue.length==0) return false;
			 
			var paymentValue1 = paymentValue.split("@")[0];//第一期应还总金额
			var paymentValue2 = paymentValue.split("@")[1];//第二期应还总金额
			var paymentValueEnd = paymentValue.split("@")[2];//最后一期应还总金额
			var totalPaylAmt1 = paymentValue.split("@")[3];//第一期应还本息
			var totalPaylAmt2 = paymentValue.split("@")[4];//第二期应还本息
			if(parseFloat(paymentValueEnd)>parseFloat(paymentValue2)) paymentValueMonth = paymentValueEnd;
			else paymentValueMonth = paymentValue2;
			try{
				setItemValue(0,getRow(),"FIRSTDRAWINGDATE",fix(parseFloat(paymentValue1)));//首期
				setItemValue(0,getRow(),"MonthRepayment",fix(parseFloat(paymentValueMonth)));//每月
			}catch(e){
				return false;
			}
		//}
		
		//若录入没设置 保存时再设置一次
		var MonthRepayment = getItemValue(0,getRow(),"MonthRepayment");
		var Firstpayment = getItemValue(0,getRow(),"FIRSTDRAWINGDATE");//首期还款额
		try{
			if(Firstpayment == "NaN" || typeof(MonthRepayment)=="undefind" || MonthRepayment.length==0 || isNaN(MonthRepayment) || parseFloat(MonthRepayment)<=0.0 || typeof(Firstpayment)=="undefind" || Firstpayment.length==0 || isNaN(Firstpayment) || parseFloat(Firstpayment)<=0.0){
				getMonthPayment();
				return false;
			}
			var MonthRepaymentend = getItemValue(0,getRow(),"MonthRepayment");
			var Firstpaymentend = getItemValue(0,getRow(),"FIRSTDRAWINGDATE");//首期还款额
			if(Firstpayment == "NaN" || typeof(MonthRepaymentend)=="undefind" || MonthRepaymentend.length==0 || isNaN(MonthRepayment) || parseFloat(MonthRepaymentend)<=0.0 || typeof(Firstpaymentend)=="undefind" || Firstpaymentend.length==0 || isNaN(Firstpaymentend) || parseFloat(Firstpaymentend)<=0.0){
				return false;
			}
		}catch(e){
			alert("请联系管理员重载数据缓存,在做保存");
			return false;
		}
		
		return true;
	}
	
	//加入组件参数
	function inserTermPara(){
		var sObjectType = "<%=sObjectType%>";
		var sObjectNo="<%=sObjectNo%>";
		var sApplyType="<%=sApplyType%>";
		var sBusinessType = "<%=sBusinessType%>";
		var CreditAttribute = "<%=sCreditAttribute%>";
		var RepaymentWay = getItemValue(0,0,"RepaymentWay");//还款渠道
		//if(CreditAttribute == "0002"){//消费贷
			var sTermID = "RPT17";//等额本息
			RunMethod("ProductManage","initObjectWithProduct","initObjectWithProduct,"+sTermID+",<%=sObjectType%>,<%=sObjectNo%>");
			//固定利率
			RunMethod("ProductManage","initObjectWithProduct","initObjectWithProduct,RAT002,<%=sObjectType%>,<%=sObjectNo%>");
			//创建费用
			var sReturnFeeBool = RunMethod("LoanAccount","CreateFeeList",sBusinessType+",<%=sObjectType%>,<%=sObjectNo%>,<%=CurUser.getUserID()%>");
						
			var sCreditCycle = getItemValue(0, 0, "CreditCycle"); //是否投保 
			if(sCreditCycle!="1"){//不投保  
				//删除管理的保险费 方案信息
				RunMethod("PublicMethod","DeleteFee","A12,<%=sObjectNo%>");
			}else{
				RunMethod("PublicMethod","UpdateColValue","String@FeeRate@<%=CredFeeRateAll%>,ACCT_FEE,String@FeeType@A12@String@ObjectNo@<%=sObjectNo%>");//保险费
			}
			
			//账户信息
			accountDeposit(RepaymentWay,"2");
			
			//产生产品管理的费用减免信息未处理完
			var sReturn = RunMethod("LoanAccount","InsertFeeWaive",sBusinessType+",<%=sObjectType%>,<%=sObjectNo%>");
			//生成放款日
			var sPutOutDate = "<%=SystemConfig.getBusinessDate()%>";
			RunMethod("PublicMethod","UpdateColValue","String@PutOutDate@"+sPutOutDate+",BUSINESS_CONTRACT,String@SerialNo@<%=sObjectNo%>");//合同生效日
			
			if(sReturnFeeBool == "ture"){
				return true;
			}else{
				return false;
			}
		//}
		
	}
	function accountDeposit(RepaymentWay,isCar){
		var sObjectNo="<%=sObjectNo%>";
		//扣款账户信息
		if(RepaymentWay=="1"){//代扣
			var accountIndicator1="01";//扣款
			//查询该笔合同关联的扣款卡号是否存在
			var sReturn1 = RunMethod("PublicMethod","DistinctAccount1","<%=sObjectNo%>,jbo.app.BUSINESS_CONTRACT,"+accountIndicator1);
			var ReplaceAccount = getItemValue(0,0,"ReplaceAccount");//扣款账号
			var ReplaceName = getItemValue(0,0,"ReplaceName");//扣款账号名
			
			if(sReturn1>0.0){
				RunMethod("PublicMethod","UpdateColValue","String@accountno@"+ReplaceAccount+"@String@accountname@"+ReplaceName+",acct_deposit_accounts,String@objecttype@jbo.app.BUSINESS_CONTRACT@String@accountindicator@01@String@OBJECTNO@"+sObjectNo);
			}else{
				var paymentSerialNo = getSerialNo("ACCT_DEPOSIT_ACCOUNTS","SerialNo","");
				RunMethod("LoanAccount","CreateRepayAccount",paymentSerialNo+","+"<%=sObjectNo%>"+","+ReplaceAccount+","+ReplaceName);
			}
			
		}else {//非代扣
			var accountIndicator2="01";//扣款
			//查询该笔合同关联的扣款卡号是否存在
			var sReturn2 = RunMethod("PublicMethod","DistinctAccount1","<%=sObjectNo%>,jbo.app.BUSINESS_CONTRACT,"+accountIndicator2);
			var ReplaceAccount = getItemValue(0,0,"RepaymentNo");//還款账号
			var ReplaceName = getItemValue(0,0,"RepaymentName");//扣款账号名
			if (typeof(ReplaceName) == "undefined" || ReplaceName.length == 0 || typeof(ReplaceAccount) == "undefined" || ReplaceAccount.length == 0){
				if(isCar=="1"){
					ReplaceName = "汽车金融";//放款账号名
					ReplaceAccount = "CAR"+"<%=sObjectNo%>";//扣款账号
				}else{
					ReplaceName = "消费贷客户";//放款账号名
					ReplaceAccount = "XFD"+"<%=sObjectNo%>";//扣款账号
				}
			}
			if(sReturn2>0.0){
				RunMethod("PublicMethod","UpdateColValue","String@accountno@"+ReplaceAccount+"@String@accountname@"+ReplaceName+",acct_deposit_accounts,String@objecttype@jbo.app.BUSINESS_CONTRACT@String@accountindicator@01@String@OBJECTNO@"+sObjectNo);
			}else{
				var paymentSerialNo = getSerialNo("ACCT_DEPOSIT_ACCOUNTS","SerialNo","");
				RunMethod("LoanAccount","CreateRepayAccount",paymentSerialNo+","+"<%=sObjectNo%>"+","+ReplaceAccount+","+ReplaceName);
			}
		}
		//放款账户
		var accountIndicator="00";//放款
		//查询该笔合同关联的扣款卡号是否存在
		var sReturn3 = RunMethod("PublicMethod","DistinctAccount1","<%=sObjectNo%>,jbo.app.BUSINESS_CONTRACT,"+accountIndicator);
		var ReplaceAccount = "";
		var ReplaceName = "";
		if(isCar=="1"){
			ReplaceName = "汽车金融";//放款账号名
			ReplaceAccount = "CAR"+"<%=sObjectNo%>";//扣款账号
		}else{
			ReplaceName = "消费贷客户";//放款账号名
			ReplaceAccount = "XFD"+"<%=sObjectNo%>";//扣款账号
		}
		if(sReturn3>0){
			RunMethod("PublicMethod","UpdateColValue","String@OBJECTNO@"+sObjectNo+",acct_deposit_accounts,String@accountname@"+ReplaceAccount+"@String@accountno@"+ReplaceName);
		}else{
			var AccountSerialNo = getSerialNo("ACCT_DEPOSIT_ACCOUNTS","SerialNo","");
			RunMethod("LoanAccount","CreateDepositAccount",AccountSerialNo+","+"<%=sObjectNo%>,jbo.app.BUSINESS_CONTRACT"+","+ReplaceAccount+","+accountIndicator+","+ReplaceName);
		}
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
	
	/*~[Describe=初始化数据;InputParam=无;OutPutParam=无;]~*/
	function initRow()
	{
		//客户主管  add  by ybpan  CCS-588  系统中增加中域ALDI模式的客户主管
	   setItemValue(0,getRow(),"CustomerHolder","<%=sCustomerHolder%>");
	   setItemValue(0,getRow(),"CustomerHolderName","<%=sCustomerHolderName%>");
		//end
		
		var sMonthRepayment=getItemValue(0,0,"MonthRepayment");
		
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
		if(sOccurType == "060") //还旧借新
		{
			setItemValue(0,getRow(),"GOLNTimes","<%=iGOLNTimes%>");
		}
		if(sOccurType == "030" && sObjectType == "CreditApply") //债务重组
		{
			setItemValue(0,getRow(),"DRTimes","<%=iDRTimes%>");
		}
		
		//销售门店
		var sTempFlag = getItemValue(0, 0, "TempSaveFlag");
		var vSSNo = "<%=sSno%>";
		if (sTempFlag == "1" && vSSNo!= "") {
			setItemValue(0,getRow(),"Stores","<%=sSno%>");
			setItemValue(0,getRow(),"StoresName","<%=sSname%>");
			setItemValue(0, getRow(), "SalesManager", "<%=sSalesManager%>");
			setItemValue(0, getRow(), "SalesManagerName", "<%=sSalesManagerName%>");
			setItemValue(0, getRow(), "CityManager", "<%=sCityManager%>");
			setItemValue(0, getRow(), "CityManagerName", "<%=sCityManagerName%>");
			//add 现金贷需求
			if("020" == "<%=sProductid%>")
			{
				setItemValue(0,getRow(),"SalesexecutivePhone","<%=sSalesexecutivePhone%>");
			}
			//end
		}
		//销售代表
		var sSalesexecutive="<%=sSalesexecutive%>";
		var sSalesexecutiveName="<%=sSalesexecutiveName%>";

		if(sSalesexecutive == null || sSalesexecutive==""){
			setItemValue(0,getRow(),"Salesexecutive","<%=CurUser.getUserID()%>");
			setItemValue(0,getRow(),"SalesexecutiveName","<%=CurUser.getUserName()%>");
		}else{
			setItemValue(0,getRow(),"Salesexecutive",sSalesexecutive);
			setItemValue(0,getRow(),"SalesexecutiveName",sSalesexecutiveName);
		}

		//保险费率
		setItemValue(0,getRow(),"CreditFeeRate","<%=CredFeeRate%>");
		
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
		var sValue7=sValue5/sValue4; //首付比列
		setItemValue(0,getRow(),"PaymentRate",sValue7.toFixed(2)*100+"");
		
		var sBusinessSum = getItemValue(0,getRow(),"BusinessSum");//本金
		var sTotalSum = getItemValue(0,getRow(),"TotalSum");//自付金额
		var sPeriods = getItemValue(0,getRow(),"Periods");//分期期数
		var sBusinessType="<%=sBusinessType%>";
		
	    //设置销售提成开始
		
		var commission = getItemValue(0,getRow(),"commission");//销售提层率
		var minload = getItemValue(0,getRow(),"minload");//最低贷款
		var maxload = getItemValue(0,getRow(),"maxload");//最大贷款
		var payment_num = getItemValue(0,getRow(),"payment_num");//基表期数
		var BusinessType =  getItemValue(0,getRow(),"BusinessType");//产品编号
		if(parseInt(minload) <= parseInt(sBusinessSum) && parseInt(maxload) >= parseInt(sBusinessSum) ){
			if(sPeriods == payment_num){
				var bounes = parseInt(sBusinessSum) * commission;
				setItemValue(0,getRow(),"bonus",bounes);
			}
			//下面这些产品都是固定提成
			var arr = new Array();
			arr[0] = "CDN013";
			arr[1] = "CDN014";
			arr[2] = "CDN015";
			arr[3] = "CDN016";
			arr[4] = "CDN017";
			arr[5] = "CJD013";
			arr[6] = "CJD014";
			arr[7] = "CJD015";
			arr[8] = "CJD016";
			arr[9] = "CJD017";
			arr[10] = "JDN003";
			for(var i=0;i<arr.length; i++){
				if(BusinessType == arr[i]){
					setItemValue(0,getRow(),"bonus",commission);
					break;
				}
			}
		}else{
			setItemValue(0,getRow(),"bonus","");
		}
		//设置销售提成结束
		
		if(parseFloat(parseInt(sValue6,10))<parseFloat(sValue6)){
			alert("贷款本金必须为整数，请检查");
			return;
		}
		
		
		//增加账户管理费、财务顾问费 或保险费
		var YesNo = getItemValue(0, getRow(), "CreditCycle");//是否投保1:是 2：否		
		if(typeof(YesNo) == "undefined" || YesNo.length == 0){
			YesNo = "2";
		}
		
		if(parseFloat(sBusinessSum) < 0.0){
			alert("自付总金额不能大于商品总价格,请检查!");
			return;
		}
		
		if(parseFloat(sBusinessSum) > 0 && parseFloat(sPeriods) > 0){
			 if(parseFloat(sTotalSum)-parseFloat(sValue4)>0){
				alert("自付总金额不能大于贷款总价格!");
				return;
			}else{
				var sMonthPayment=RunMethod("PublicMethod","GetMonthPayment",sBusinessSum+","+sBusinessType+","+sPeriods+","+YesNo);
				//setItemValue(0,getRow(),"MonthRepayment",parseFloat(sMonthPayment).toFixed(0)+"");
				//setItemValue(0,getRow(),"TotalSum2","转化前："+parseFloat(sMonthPayment)+"");
				var MonthPaymentBefore = parseFloat(sMonthPayment);
				var MonthPaymentAfter = fix(MonthPaymentBefore);
				//setItemValue(0,getRow(),"BrandType2","转化后："+MonthPaymentAfter+"");
				//update CCS-376 【生产】合同详情-每月还款额不显示-保存不了(改回联动设置每月还款金额)
				//联动不再设置每月还款金额
				setItemValue(0,getRow(),"MonthRepayment",MonthPaymentAfter+"");
				//end
			}
		}
		//设置保险提成金额
		if(YesNo =='1'){
			setItemValue(0,getRow(),"insur_bonus","15.00");
		}else if(YesNo =='2'){
			setItemValue(0,getRow(),"insur_bonus","");
		}
	}
	
	/*~[Describe=小数进位;InputParam=无;OutPutParam=无;]~*/
	function fix(d) {
		var temp = d * 10;
		var value1 = Math.ceil(parseFloat(temp));//进位取整
		var finalyvalue = parseFloat(value1)/10;
		if(d==parseInt(d,10)){
			finalyvalue = d;
		}
		return finalyvalue;
	}
	
	
</script>

<script type="text/javascript">

</script>

<script type="text/javascript" src="<%=sWebRootPath%>/Accounting/js/loan/loaninfo.js"></script>
<script type="text/javascript" src="<%=sWebRootPath%>/Accounting/js/loan/common.js"></script>

<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info08;Describe=页面装载时，进行初始化;]~*/%>
<script type="text/javascript">	
ShowMessage("系统正在提交，请等待...",true,true);
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	
	initRow();	
	/*------------------核算加入JS代码---------------*/
	afterLoad("<%=sObjectType%>","<%=sObjectNo%>"); 
	/*------------------核算加入JS代码---------------*/
	saveRecord();
	self.returnValue = "Success";
	self.close();
</script>
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>