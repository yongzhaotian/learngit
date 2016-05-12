<%@page import="com.amarsoft.app.lending.bizlets.CheckCreditCycle"%>
<%@page import="com.amarsoft.proj.action.P2PCreditCommon"%>
<%@page import="com.amarsoft.app.accounting.config.loader.DateFunctions"%>
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
		             xswang 2015/06/01 CCS-713 合同中的门店跳转为其他门店
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
	// 权限控制显示按钮 ReadOnly All
	String sRigthType = CurComp.getAttribute("RightType");
	CurComp.setAttribute("RightType", "All");
	
	String productIdTemp = "";
	//定义变量：对象主表名、对应关联表名、SQL语句、产品类型、客户代码、显示属性、产品版本
	String sMainTable = "",sRelativeTable = "",sSql = "",sBusinessType = "",sCustomerID = "",sColAttribute = "",sThirdParty="0.0",sProductVersion="",sSalesexecutive="",sSalesexecutiveName="";
	//定义变量：查询列名、显示模版名称、申请类型、发生类型、暂存标志
	String sFieldName = "",sDisplayTemplet = "",sApplyType = "",sOccurType = "",sTempSaveFlag = "",sProductid="",sProductcategoryname="",sProductcategoryId="";
	//定义变量：关联业务币种、关联业务到期日、关联流水号、借据号
	String sOldBusinessCurrency = "",sOldMaturity = "",sRelativeSerialNo = "",dOldSerialNo = "",ssSno="",sSno="",sSname="",ssSname="",sServiceprovidersname="",sGenusgroup="",sCarfactoryid="",sCreditId="",sCreditPerson="",sCity="",sAttr2="",sCarfactory="";
	// 定义变量： 门店经理，城市经理
	String sSalesManager = "", sCityManager = "", sSalesManagerName = "", sCityManagerName = "";
	//定义变量 ：CCS-681合同表增加门店城市 add by jiangyuanlin 20150513
    String sStoreCityCode = "";
  	//消费贷项目CCS-1113 合同增加区县信息 daihuafeng
	String sStoreCountyCode = "";
    //CCS-681合同表增加门店城市 end
    
    
    
	//定义变量：关联业务金额、关联业务利率、关联业务余额
	double dOldBusinessSum = 0.0,dOldBusinessRate = 0.0,dOldBalance = 0.0,dThirdPartyRatio=0.0,dThirdParty=0.0;
	//定义变量：展期次数、借新还旧次数、还旧借新次数、债务重组次数
	int iExtendTimes = 0,iLNGOTimes = 0,iGOLNTimes = 0,iDRTimes = 0,dTermDay=0;
	//定义变量：产品子类型
	String sSubProductType = "";
	//录单时间
	String sInputDate = "";
	//定义变量：查询结果集
	ASResultSet rs = null;
	String subProductTypename ="";//子类型
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

    //销售门店
    //add by xswang 2015/06/01 CCS-713 合同中的门店跳转为其他门店
	String sNo = "";
	// 根据合同号去查门店信息
	String sql = "SELECT BC.STORES FROM BUSINESS_CONTRACT BC WHERE BC.SERIALNO = :SERIALNO";
	sNo = Sqlca.getString(new SqlObject(sql).setParameter("SERIALNO", sObjectNo));
	if (sNo == null || "".equals(sNo)) {
		sNo = CurUser.getAttribute8();
	}
  	// end by xswang 2015/06/01
  	
   //客户主管    add by ybpan at 20150409 CCS-588  系统中增加中域ALDI模式的客户主管
     String sCustomerHolder= Sqlca.getString(new SqlObject("select SalesManNO  as CustomerHolder from STORERELATIVESALESMAN where SNO=:sSNO and SALETYPE='02'").setParameter("sSNO",sNo ));
     String sCustomerHolderName= Sqlca.getString(new SqlObject("select getUserName(SalesManNO)  as CustomerHolder from STORERELATIVESALESMAN where SNO=:sSNO and SALETYPE='02'").setParameter("sSNO",sNo ));
     
     if(sNo == null) sNo = "";
     if(sCustomerHolder == null) sCustomerHolder = "";
     if(sCustomerHolderName == null) sCustomerHolderName = "";
     
     
     //修改城市经理从销售经理的上级取得。 edit by Dahl 2015-03-17    CCS-681合同表增加门店城市  edit by jiangyuanlin 20150515

     sSql="select si.city as city,getitemname('AreaCode',si.city) as cityName,si.country,si.sno,si.sname, si.SALESMANAGER, getusername(si.SALESMANAGER) as  SALESMANAGERNAME, ui.superId as CITYMANAGER, getusername(ui.superId) as CITYMANAGERNAME from store_info si ,user_info ui where si.salesmanager=ui.userid and sno = :sno and  identtype = '01'";
     
     rs=Sqlca.getASResultSet(new SqlObject(sSql).setParameter("sno",sNo));
     if(rs.next()){
    	 sSno = DataConvert.toString(rs.getString("sno"));//门店
    	 sSname = DataConvert.toString(rs.getString("sname"));
    	 sSalesManager = DataConvert.toString(rs.getString("SALESMANAGER"));		// 销售经理
    	 sCityManager = DataConvert.toString(rs.getString("CITYMANAGER")); 	// 城市经理
    	 sSalesManagerName = DataConvert.toString(rs.getString("SALESMANAGERNAME"));		// 销售经理
    	 sCityManagerName = DataConvert.toString(rs.getString("CITYMANAGERNAME")); 	// 城市经理
    	 sStoreCityCode = DataConvert.toString(rs.getString("city"));//门店所在城市  CCS-681合同表增加门店城市

    
       	 sStoreCountyCode = DataConvert.toString(rs.getString("country"));//消费贷项目CCS-1113 合同增加区县信息 daihuafeng
    	 //打印log，以备以后合同表销售经理为空时，跟踪数据。 add by Dahl 2015-03-17
    	 ARE.getLog().info("\n"+sObjectNo+"-------销售门店-------"+sNo+"\n-------销售经理-------"+sSalesManager+"\n-------城市经理-------"+sCityManager);
    	 
 		//将空值转化成空字符串
 		if(sSno == null) sSno = "";
 		if(sSname == null) sSname = "";
 		if (sSalesManager == null) sSalesManager = "";
 		if (sCityManager == null) sCityManager = "";
 		if (sSalesManagerName == null) sSalesManagerName = "";
 		if (sCityManagerName == null) sCityManagerName = "";
 		if (sStoreCityCode == null) sStoreCityCode = "";  //CCS-681合同表增加门店城市


 		if (sStoreCountyCode == null) sStoreCountyCode = "";  //消费贷项目CCS-1113 合同增加区县信息
     }
     rs.getStatement().close();
     System.out.println("sStoreCountyCode=============================="+sStoreCountyCode);
     //销售代表联系方式
     String sSalesexecutivePhone =Sqlca.getString("select MobileTel from user_info where UserID = '"+CurUser.getUserID()+"'");
     if(null == sSalesexecutivePhone) sSalesexecutivePhone = "";
     
     String sCityName = "" ;//区域中文名
     
	  String sCreditAttribute = "";//0002消费/0001汽车/0003经销商/0004小企业贷款
     
     //查询销售代表
     sSql="select Salesexecutive,getusername(Salesexecutive) as SalesexecutiveName,ProductID,CreditAttribute,SubProductType,InputDate from business_contract where serialno=:serialno";
     rs=Sqlca.getASResultSet(new SqlObject(sSql).setParameter("serialno",sObjectNo));
     if(rs.next()){
    	 sSalesexecutive = DataConvert.toString(rs.getString("Salesexecutive"));//销售代表ID
    	 sSalesexecutiveName = DataConvert.toString(rs.getString("SalesexecutiveName"));//销售代表Name
    	 
    	 sProductid = DataConvert.toString(rs.getString("ProductID"));//产品类型
    	 productIdTemp = sProductid;
    	 sCreditAttribute =  DataConvert.toString(rs.getString("CreditAttribute"));//产品类型
    	 
    	 sSubProductType = DataConvert.toString(rs.getString("SubProductType"));//产品子类型
    	 sInputDate = DataConvert.toString(rs.getString("InputDate"));
 		//将空值转化成空字符串
 		if(sSalesexecutive == null) sSalesexecutive = "";
 		if(sSalesexecutiveName == null) sSalesexecutiveName = "";
     }
     rs.getStatement().close();
     
     String ssCity = Sqlca.getString(new SqlObject("select city from store_info si where si.sno=:sno").setParameter("sno", sNo));
   	//获取贷款人信息(汽车金融与消费金融取值逻辑一致)
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
	String sFlag = "true";
	String productobjectno = sBusinessType+"-V1.0";
	Double CredFeeRate = 0.0;
	Double CredFeeRateAll = 0.0;
	String CredTermID = Sqlca.getString(new SqlObject("select termid from product_term_library where subtermtype = 'A12' and objecttype='Product' and objectno='"+productobjectno+"' "));
	if(CredTermID==null) CredTermID = "";
	if("".equals(CredTermID)){
		doTemp.setReadOnly("CreditCycle", true);
		doTemp.setRequired("CreditCycle", false);
		sFlag = "false";
	}else{
		CredFeeRate = DataConvert.toDouble(Sqlca.getString(new SqlObject("select defaultvalue from product_term_para where paraid='FeeRate' and termid = '"+CredTermID+"' and objectno='"+productobjectno+"' ")));
		CredFeeRateAll = CredFeeRate*iPeriods;
	}
	
	/** add CCS-996：系统根据产品类型和城市匹配保险公司 tangyb 20150928 start */
	String sInsuranceNo = Sqlca.getString(new SqlObject("select InsuranceNo from Business_Contract where serialno = '"+sObjectNo+"' "));
	if(sInsuranceNo==null) sInsuranceNo = "";
	//检查是否可以投保
	CheckCreditCycle check = new CheckCreditCycle();
	check.setBusinessType(sBusinessType);
	check.setInsuranceNo(sInsuranceNo);
	String sReturn = check.CreditCycle(Sqlca);
	if(!"true".equals(sReturn)){
		doTemp.setReadOnly("CreditCycle", true);
		doTemp.setRequired("CreditCycle", false);
		sFlag = "false";
	}
	/** add CCS-996：系统根据产品类型和城市匹配保险公司 tangyb 20150928 end */
	
	String tTermTemp="",tTerm = "",tLoanFixedRate = "",tHighestFixedRate = "",tShouFuRatio = "",tRateFloat = "", tSectionRatio = "",tDealcomminssion = "",tSalesComminssion="",tDisCountFixedRate="",tSectionFixedRate="";
	
	double cCreditRate = 0.0d;//贷款利率
	//人行贷款利率需修改
	//String cRateValue = Sqlca.getString(new SqlObject("select rateValue from rate_info where ratetype = '010' and rateunit='02' and termunit='020' and status='1' and term='"+tTerm+"' "));
	
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
		//CCS-797 add by clhuang 2015/05/12 代扣合同中必填项的代扣省市为空
		if("0".equals(sSubProductType)){
			String sRepaymentWay = Sqlca.getString(new SqlObject("select RepaymentWay from Business_Contract where serialno='"+sObjectNo+"'"));
			if(sRepaymentWay==null) sRepaymentWay = "";
			if(sRepaymentWay.equals("1")){
				doTemp.setRequired("ReplaceAccount", true);
				doTemp.setRequired("OpenBank",true);
				doTemp.setRequired("OpenBankName",true);
				doTemp.setRequired("ReplaceName",true);
				doTemp.setRequired("CityName",true);//代扣省市
			}else{
				doTemp.setRequired("ReplaceAccount", false);
				doTemp.setRequired("OpenBank",false);
				doTemp.setRequired("OpenBankName",false);
				doTemp.setRequired("ReplaceName",false);
				doTemp.setRequired("CityName",false);//代扣省市  
			}
		} 
	  //end by  clhuang
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
	
	String sIsP2p = Sqlca.getString("select isP2p from Business_Contract where SerialNo = '"+sObjectNo+"'");

	//获取贷款人的相关信息
	String RepaymentNo = "";//还款账号
	String RepaymentBank = "";//还款账号开户行
	String RepaymentName = "";//还款账号户名
	String RepaymentBankName = "";
	
	// modified by huangshuo, 添加获取原地复活字段
	// String sCreditid = Sqlca.getString("select CreditID from Business_Contract where SerialNo = '"+sObjectNo+"'");
	String sCreditid = "";
	String isReconsider = "";
	String contractStatus = "";
	sSql = "select CreditID, IsReconsider, ContractStatus from Business_Contract where SerialNo = :SerialNo";
	rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("SerialNo", sObjectNo));
	if (rs.next()) {
		sCreditid = rs.getString("CreditID");
		isReconsider = rs.getString("IsReconsider");
		contractStatus = rs.getString("ContractStatus");
	}
	
	boolean checkLog = true;//是否需要查询历史记录表
	sSql = "select pc.backAccountPrefix,pc.turnAccountName,pc.turnAccountBlank,getItemName('LoanSubBank', pc.subBankName) as RepaymentBankName "+
	   "from Service_Providers sp,ProvidersCity pc where sp.SerialNo = :SerialNo "+
	   "and pc.serialno = sp.serialno and pc.areacode = '"+ssCity+"' and pc.ProductType = '"+sSubProductType+"'";
	SqlObject soSer = new SqlObject(sSql).setParameter("SerialNo", sCreditid);
	rs = Sqlca.getASResultSet(soSer);
	if(rs.next()){
		checkLog = false;
		RepaymentNo = rs.getString("backAccountPrefix");
		RepaymentBank = rs.getString("turnAccountBlank");
		RepaymentName = rs.getString("turnAccountName");
		RepaymentBankName = rs.getString("RepaymentBankName");
	}
	rs.getStatement().close();
	//需要查询历史记录表
	if(checkLog){
		sSql = "select pc.backAccountPrefix,pc.turnAccountName,pc.turnAccountBlank,getItemName('LoanSubBank', pc.subBankName) as RepaymentBankName "+
				   "from Service_Providers sp,ProvidersCity_Log pc where sp.SerialNo = :SerialNo "+
				   "and pc.serialno = sp.serialno and pc.areacode = '"+ssCity+"' and pc.ProductType = '"+sSubProductType+"' "+
				   "and :InputDate between pc.beginTime and pc.endTime";
		SqlObject soSerLog = new SqlObject(sSql).setParameter("SerialNo", sCreditid).setParameter("InputDate", sInputDate);
		rs = Sqlca.getASResultSet(soSerLog);
		if(rs.next()){
			RepaymentNo = rs.getString("backAccountPrefix");
			RepaymentBank = rs.getString("turnAccountBlank");
			RepaymentName = rs.getString("turnAccountName");
			RepaymentBankName = rs.getString("RepaymentBankName");
		}
		rs.getStatement().close();
	}
	//update CCS-399(消费贷默认显示为”四海支行“，现金贷默认显示为”安联支行  “;)。 add CCS-1000消费贷中的学生教育贷与成人教育贷也默认显示为”安联支行  “ by huanghui 
	if(RepaymentNo == null || RepaymentNo == "") 
	{
		if("020".equals(sProductid) || "4".equals(sSubProductType) || "5".equals(sSubProductType))//现金贷、消费贷中的学生贷与成人教育贷
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
		if("020".equals(sProductid) || "1".equals(sIsP2p) || "4".equals(sSubProductType) || "5".equals(sSubProductType) )//现金贷或p2p。  add CCS-1000消费贷中的学生教育贷与成人教育贷也默认显示为”安联支行  “ by huanghui 
		{
			RepaymentBankName = "招商银行股份有限公司深圳安联支行";
		}else
		{
			RepaymentBankName = "招商银行深圳四海支行";
		}
	}
	if(RepaymentName == null || RepaymentName == "") RepaymentName = "深圳市佰仟金融服务有限公司";
	//end
	
	RepaymentNo = RepaymentNo+Sqlca.getString("select CustomerID from Business_Contract where SerialNo = '"+sObjectNo+"'");
	
	//update CCS-399(消费贷默认显示为”四海支行“，现金贷默认显示为”安联支行  “;)
	/*if("020".equals(sProductid) || "1".equals(sIsP2p) )//现金贷或p2p
	{
		RepaymentBankName = "招商银行股份有限公司深圳安联支行";
	}else
	{
		RepaymentBankName = "招商银行深圳四海支行";
	}*/
	//end
		
	
	//获取客户保存状态
	String sCTempSaveFlag = Sqlca.getString(new SqlObject("select Tempsaveflag from Ind_Info where CustomerID =:CustomerID").setParameter("CustomerID", sCustomerID));
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
		{"true","All","Button","暂存","暂时保存所有修改内容","saveRecordTemp()",sResourcesPath},
		{"false","All","Button","打印申请表","打印申请表","creatApplyTable()",sResourcesPath},
		{"false","All","Button","打印电子合同","打印电子合同","creatContract()",sResourcesPath},
		{"true","All","Button","上传照片","上传照片","imageManage()",sResourcesPath},
		{"false","All","Button","打印三方协议","打印三方协议","creatThirdTable()",sResourcesPath},
		{"true","All","Button","生成还款信息","生成还款信息","generatePaymentInfo()",sResourcesPath}	// 要加权限控制
	};
	//当暂存标志为否，即已保存，暂存按钮应隐藏
	if(sTempSaveFlag.equals("2"))
		sButtons[1][0] = "false";
	if ("ReadOnly".equals(sRigthType))  {
		sButtons[0][0] = "false";
		sButtons[1][0] = "false";
		sButtons[2][0] = "false";
		sButtons[4][0] = "false";
		sButtons[5][0] = "false";
		
		if ("060".equals(contractStatus) && !"1".equals(isReconsider)) {
			sButtons[6][0] = "true";
		} else {
			sButtons[6][0] = "false";
		}
		
	}
	
	if("0001".equals(sCreditAttribute)){
		sButtons[2][0] = "false";
		sButtons[3][0] = "false";
		sButtons[4][0] = "false";
		sButtons[5][0] = "false";
	}
	%>
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=Info05;Describe=主体页面;]~*/%>
<%@include file="/Resources/CodeParts/Info05.jsp"%>
<%/*~END~*/%>

<script type="text/javascript">
	var loadAmount = "0.00"; 
	var isInsure = "";
/*~[Describe=打印申请表;InputParam=无;OutPutParam=无;]~*/
function creatApplyTable(){

		var sObjectNo = "<%=sObjectNo%>";
		sObjectType = "ApplySettle";
		sExchangeType = "";
		var sSerialNo = getSerialNo("FORMATDOC_RECORD", "SerialNo", "AS");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}else{
			//检查出帐通知单是否已经生成
			var sReturn = PopPageAjax("/FormatDoc/GetReportFile.jsp?DocID=7006&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType,"","");
			if (sReturn == "false"){ //未生成出帐通知单
				//生成出帐通知单	
				PopPage("/FormatDoc/Report17/03.jsp?DocID=7006&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType+"&SerialNo="+sSerialNo+"&Method=4&FirstSection=1&EndSection=0&rand="+randomNumber(),"myprint10","dialogWidth=10;dialogHeight=1;status:no;center:yes;help:no;minimize:yes;maximize:no;border:thin;statusbar:no");
			}
			//获得加密后的出帐流水号
			var sEncryptSerialNo = PopPageAjax("/PublicInfo/EncryptSerialNoAction.jsp?EncryptionType=MD5&SerialNo="+sObjectNo);
			//通过　serverlet 打开页面
			var CurOpenStyle = "width=720,height=540,top=20,left=20,toolbar=no,scrollbars=yes,resizable=yes,status=yes,menubar=no,";	
			//+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType  add by cdeng 2009-02-17	
			OpenPage("/FormatDoc/POPreviewFile.jsp?EncryptSerialNo="+sEncryptSerialNo+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType,"_blank02",CurOpenStyle); 
			
		}
	 
}

	/*~[Describe=打印电子合同;InputParam=无;OutPutParam=无;]~*/
	function creatContract(){
		var sObjectNo = getItemValue(0,getRow(),"SerialNo");
		var sObjectType = RunMethod("公用方法", "GetColValue", "Business_Contract,ProductId,SerialNo='"+sObjectNo+"'");//getItemValue(0,getRow(),"ProductID");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}else{
			var sManageUserID = "<%=CurUser.getUserID()%>";
			sParaString = "ManageUserID," +sManageUserID;
			sEDocNo = PopPage("/Common/EDOC/EDocNo.jsp?ObjectType="+sObjectType,"","resizable=yes;dialogWidth=0;dialogHeight=0;center:no;status:no;statusbar:no");
			if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
			{
				alert(getHtmlMessage('1'));//请选择一条信息！
				return;
			}
			sReturn = PopPage("/Common/EDOC/EDocCreateCheckAll.jsp?ObjectType="+sObjectType+"&ObjectNo="+sObjectNo+"&EDocNo="+sEDocNo,"","resizable=yes;dialogWidth=0;dialogHeight=0;center:no;status:no;statusbar:no");
			
			if(sReturn == "nodef")
			{
				alert("没有对应的模板，电子合同生成失败！");
				return;
			}
			if(sReturn == "nodoc")
			{
				sReturn = PopPage("/Common/EDOC/EDocCreateActionAll.jsp?ObjectType="+sObjectType+"&ObjectNo="+sObjectNo+"&EDocNo="+sEDocNo,"","resizable=yes;dialogWidth=150;dialogHeight=100;center:no;status:no;statusbar:no");
			}
			sSerialNo = sReturn;
			OpenComp("ViewEDOC","/Common/EDOC/EDocView.jsp","SerialNo="+sSerialNo,"_blank",OpenStyle);
			
			reloadSelf();
		}
		
	}

	/*~[Describe=保存;InputParam=后续事件;OutPutParam=无;]~*/
	function saveRecord() {	
		// 去掉贷款本金字段后面提示 add by tbzeng 2014/05/03  
		var sTemp = _user_validator[0].rules.BUSINESSSUM.expressions;
		for (var x in sTemp) {
			sTemp[x] = "";
		} 
		// hope fixme carefully

		// add by tbzeng 2014/09/23 
		var regManuExpr = /^[1-9]\d{1,}[e|E][1-9]\d{1,}/i;
		var sManufacturer1 = getItemValue(0, 0, "Manufacturer1");
		var sManufacturer2 = getItemValue(0, 0, "Manufacturer2");
		var sManufacturer3 = getItemValue(0, 0, "Manufacturer3");

		if (regManuExpr.test(sManufacturer1)) {
			alert("型号1不能输入科学计数法，请在前面输入非数字!");
			return;
		}
		if (regManuExpr.test(sManufacturer2)) {
			alert("型号2不能输入科学计数法，请在前面输入非数字!");
			return;
		}
		if (regManuExpr.test(sManufacturer3)) {
			alert("型号3不能输入科学计数法，请在前面输入非数字!");
			return;
		}
	
		//录入数据有效性检查
		if (!ValidityCheck()) {
	  		return;
	  	}
		
		//-- add by CCS-1255 tangyb 20160220 start --//
		//防止佰保袋金额未获取，再次计算
		if(!getSellPrice()){
			return;
		}
		
		//佰保袋服务验证
		if(!validateBbd()){
			return;
		}
		//-- end --//
		
		// 还款方式选择代扣，检测所选行是否在配置范围内 add by tbzeng 2014/09/02
		var sPaymentWay = getItemValue(0, 0, "RepaymentWay");
		if (sPaymentWay == "1") {
			var sOpenBank = RunMethod("公用方法", "GetColValue", "Code_Library,itemno,CodeNo='BankCode' and ISINUSE='1' and itemno='"+getItemValue(0, 0, "OpenBank")+"'");
			if (sOpenBank == "Null") {
				alert("代扣行与系统设定不符，请重新选择代扣开户行！");
				return;
			}
		}

         //合同保存按钮（非暂存）再次进行代扣情况下，四个字段开户行开户行账号等校验 ccs708 add by xiaoyp
		 selectWay();

		//单选：职业提升、个人深造、考证、其他；选择其他时，可以增加备注quliangmao
		var course_Education_training1=getItemValue(0,getRow(),"course_Education_training1");
		if(course_Education_training1=="其他"){
			var course_Remarks1=getItemValue(0,getRow(),"course_Remarks1");
			if(!course_Remarks1){
				alert("请输入填写备注1");
				return ;
			}
		}
		// end 2014/09/02
		
		var sReturnReplaceAccount = checkReplaceAccount();
		if(sReturnReplaceAccount=="error"){
			return;
		}
		if ("020" == "<%=sProductid%>") {
			ChangePurposeRemark();//贷款用途如选择“其他”，备注内容
		}
		
		if(vI_all("myiframe0")) {
			var returncheck = CheckSum();// 校验贷款金额
			if(!returncheck){
				return;
			}
			
			if("01"=='<%=CurUser.getIsCar()%>' &&!CarValidityCheck()){	//汽车金融相关校验
				return;			
			}
			
			if (!saveSubItem()) return;// 核算参数校验
			
			//-- add by tangyb CCS-1255 20160220 start 保存佰保袋信息 --//
			if(!saveBbdInfo()) return; 
			//-- end --//
			
			// 核算处理开始、、、、
			var SerialNo = getItemValue(0, getRow(), "SerialNo");// 合同流水号
			var sCreditCycle = getItemValue(0, 0, "CreditCycle"); // 是否投保
			var ReplaceAccount = getItemValue(0,0,"ReplaceAccount");// 扣款账号
			var ReplaceName = getItemValue(0,0,"ReplaceName");// 扣款账号名
			var sBusinessSum = getItemValue(0,getRow(),"BusinessSum");// 本金
			var businessType = getItemValue(0,getRow(),"BusinessType");// 产品代码
			var buyPayPkgind = getItemValue(0,getRow(),"BugPayPkgind");// 随心还服务包
			var openBranch = getItemValue(0,getRow(),"OpenBranch");// 开户行支行--CCS-1247 add by zty
			var openBank = getItemValue(0,getRow(),"OpenBank");// 开户行--CCS-1247 add by zty
			var city = getItemValue(0,getRow(),"City");// 开户行--CCS-1247 add by zty
			var type = "";
		    if (sCreditCycle != "1") {		// 没选择投保的时候，才判断投保项是否必须选择
		    	var res = RunJavaMethodSqlca("com.amarsoft.app.lending.bizlets.CheckCreditCycle", "checkNecessity", "businessType=" + businessType);
		    	if (res == "1") {
		    		alert("该产品必须选择投保！");
		    		return;
		    	}
		    } 
			
			if (sBusinessSum != loadAmount || sCreditCycle != isInsure) {
				type = "1";	
				loadAmount = sBusinessSum;
				isInsure = sCreditCycle;
			} else {
				type = "";
			}
			var sParms = "objectNo=" + SerialNo + ",userID=<%=CurUser.getUserID()%>," 
						+ "businessType=<%=sBusinessType%>,creditCycle=" + sCreditCycle 
						+ ",replaceAccount=" + ReplaceAccount + ",replaceName=" + ReplaceName 
						+ ",businessSum=" + sBusinessSum + ",type=" + type + ",org=<%=CurUser.getOrgID() %>"
						+ ",businessType=" + businessType + ",buyPayPkgind=" + buyPayPkgind
						//CCS-1247 add by zty 
						+ ",productId=<%=productIdTemp%>,repaymentWay=" +  sPaymentWay + ",openBranch="+openBranch + ",openBank="+openBank + ",city="+city;
			
			var sReturn = RunJavaMethodSqlca("com.amarsoft.app.lending.bizlets.LoadContractLoanInfo", "initContractLoanInfo", sParms);
			if(sReturn == null || sReturn.length == 0 || sReturn == "Error"){
				alert("合同保存失败！");
				return;
			}
			// setItemValue(0, 0, "MonthRepayment",fix(parseFloat(sReturn)));
			// 核算处理结束
			setItemValue(0,getRow(),"TempSaveFlag","2"); //暂存标志（1：是；2：否）
			beforeUpdate();
			as_save("myiframe0",afterSaveEvent());//保存操作后执行的代码
			
			//-- add CCS-1255：佰保袋需求 tangyb 20160218 start --//
			var subProductType = "<%=sSubProductType%>";
			
			// 是否是普通消费或学生消费贷
			if("0" == subProductType || "7" == subProductType) {
				var businesstype2 = getItemValue(0, 0, "BusinessType2"); //商品类型2
				
				if(businesstype2 == "2015061500000017") { //佰保袋添加控制
					operateMobileSerialNumber("1");
				} else {
					setItemReadOnly(0, 0, "TotalSum2", false); //自付金额2  非只读
					
					setItemRequired(0, 0, "Price2", false); //价格2 必输
					setItemReadOnly(0, 0, "Price2", false); //价格2 非只读
					
					setItemRequired(0, 0, "mobileSerialNumber", false); // 手机串号 非必输
					setItemRequired(0, 0, "MODELNO", false); // 佰保袋机型 非必输
					setItemRequired(0, 0, "SERVEYEAR", false); // 延保期限 非必输
					
					setItemDisabled(0, 0, "MODELNO", true); // 佰保袋机型 只读
					setItemDisabled(0, 0, "SERVEYEAR", true); // 延保期限 只读
					setItemReadOnly(0, 0, "mobileSerialNumber", true); // 手机串号 只读
				}
				
				var businessrangename3 = getItemValue(0, 0, "BusinessRangeName3"); //商品范畴3
				if(businessrangename3 == null || businessrangename3 == ""){
					setItemRequired(0, 0, "Price3", false); // 手机串号 非必输
				}
			}
			//-- end --//
		}
	}
	
	/*~[Describe=保存操作后执行的代码;InputParam=无;OutPutParam=无;]~*/
	function afterSaveEvent(){
		if("020" == "<%=sProductid%>"){
			ChangePurposeRemark();
		}
		var iseducation="<%=subProductTypename%>";
		if(iseducation && (iseducation=="5" || iseducation=="4")){
			save_business_education_info();// 保存教育信息
		}
	}
	 //edit by awang 20150215 CCS-447
	
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
	
	/*~[Describe=暂存;InputParam=无;OutPutParam=无;]~*/
	function saveRecordTemp() {
		
		var sCreditCycle = getItemValue(0, 0, "CreditCycle"); // 是否投保
		var sBusinessSum = getItemValue(0,getRow(),"BusinessSum");// 本金
		
		//-- add by CCS-1255 佰保袋 tangyb 20160220 start --//
		//防止佰保袋金额未获取，再次计算
		if(!getSellPrice()){
			return;
		}
		
		// 保存佰保袋信息
		if(!saveBbdInfo()){
			return; 
		}
		//-- end --//
		
		//0：表示第一个dw
		setNoCheckRequired(0);  //先设置所有必输项都不检查
		setItemValue(0,getRow(),'TempSaveFlag',"1");//暂存标志（1：是；2：否）
		if(!saveSubItem()) return;//核算参数校验
		as_save("myiframe0","afterLoad('<%=sObjectType%>','<%=sObjectNo%>')");   //再暂存
		// 更新BUSINESS_CREDIT.STATUS type = 0 -- 暂存
		var sParms = "objectNo=" + getItemValue(0, 0, "SerialNo") + ",type=0" 
					+ ",userID=<%=CurUser.getUserID() %>,org=<%=CurUser.getOrgID() %>"
					+ ",businessType=<%=sBusinessType%>,creditCycle=" + sCreditCycle
					+ ",businessSum=" + sBusinessSum;	
		var sReturn = RunJavaMethodSqlca("com.amarsoft.app.lending.bizlets.LoadContractLoanInfo", 
					"updateBusinessCredit", sParms);
		if (sReturn != "SUCCESS") {
			alert("暂存失败！");
			return;
		}
		var iseducation="<%=subProductTypename%>";
		if(iseducation && (iseducation=="5" || iseducation=="4")){
			save_business_education_info();// 保存教育信息
		}
		setNeedCheckRequired(0);//最后再将必输项设置回来
		selectWay();//CCS-797 add by clhuang 2015/05/12 代扣合同中必填项的代扣省市为空
		
		//-- add CCS-1255：佰保袋需求 tangyb 20160218 start --//
		var subProductType = "<%=sSubProductType%>";
		
		// 是否是普通消费或学生消费贷
		if("0" == subProductType || "7" == subProductType) {
			var businesstype2 = getItemValue(0, 0, "BusinessType2"); //商品类型2
			if(businesstype2 == "2015061500000017") { //佰保袋添加控制
				operateMobileSerialNumber("1");
			} else {
				setItemReadOnly(0, 0, "TotalSum2", false); //自付金额2  非只读
				
				setItemRequired(0, 0, "Price2", false); //价格2 必输
				setItemReadOnly(0, 0, "Price2", false); //价格2 非只读
				
				setItemRequired(0, 0, "mobileSerialNumber", false); // 手机串号 非必输
				setItemRequired(0, 0, "MODELNO", false); // 佰保袋机型 非必输
				setItemRequired(0, 0, "SERVEYEAR", false); // 延保期限 非必输
				
				setItemDisabled(0, 0, "MODELNO", true); // 佰保袋机型 只读
				setItemDisabled(0, 0, "SERVEYEAR", true); // 延保期限 只读
				setItemReadOnly(0, 0, "mobileSerialNumber", true); // 手机串号 只读
			}

			var businessrangename3 = getItemValue(0, 0, "BusinessRangeName3"); //商品范畴3
			if(businessrangename3 == null || businessrangename3 == ""){
				setItemRequired(0, 0, "Price3", false); // 手机串号 非必输
			}
		}
		//-- end --//
	}		
	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info07;Describe=自定义函数;]~*/%>

<script type="text/javascript">


/****************************business_education_info**********quliangmao******************/

function save_business_education_info(){
	var putoutno 				= "<%=sObjectNo%>";//合同号
	var course_start_time1 	= getItemValue(0,getRow(),"course_Start_time1");//开学时间
	var course_consultant_name1 = getItemValue(0,getRow(),"course_consultant_name1");//顾问名称
	var course_consultant_phone1 			= getItemValue(0,getRow(),"course_consultant_phone1");//顾问联系方式
	var is_probation1 					= getItemValue(0,getRow(),"is_probation1");//是否试读
	var probation_time1 			= getItemValue(0,getRow(),"probation_time1");//试读时间长
	var course_education_training1 = getItemValue(0,getRow(),"course_Education_training1");//培训目的
	var course_remarks1 = getItemValue(0,getRow(),"course_Remarks1");//备注
	var course_start_time2 = getItemValue(0,getRow(),"course_start_time2");//开学时间
	var course_consultant_name2 = getItemValue(0,getRow(),"course_consultant_name2");//顾问名称
	var course_consultant_phone2 = getItemValue(0,getRow(),"course_consultant_phone2");//顾问联系方式
	var is_probation2 = getItemValue(0,getRow(),"is_probation2");//是否试读
	var probation_time2 = getItemValue(0,getRow(),"probation_time2");//试读时间长
	var course_education_training2 = getItemValue(0,getRow(),"course_education_training2");//培训目的
	var course_remarks2 = getItemValue(0,getRow(),"course_Remarks2");//备注
	var educationPutoutno=RunMethod("公用方法", "GetColValue", "business_education_info,putoutno,putoutno='"+putoutno+"'");
	var 	updateOrinsert="updateEducationInfoByServerNo";//更新表
	if( null== educationPutoutno || ""==educationPutoutno|| "Null"==educationPutoutno){//判断是否已经存在
	updateOrinsert ="InserOrupdateEducationInfoByServerNo";//插入表
	}
	var baseRate = RunJavaMethodSqlca("com.amarsoft.app.billions.InserOrupdateEducationInfo", updateOrinsert,
			"putoutno="+putoutno+",course_start_time1="+course_start_time1+",course_consultant_name1="+course_consultant_name1+
			",course_consultant_phone1="+course_consultant_phone1+",is_probation1="+is_probation1+",probation_time1="+probation_time1+
			",course_education_training1="+course_education_training1+",course_remarks1="+course_remarks1+
			",course_start_time2="+course_start_time2+",course_consultant_name2="+course_consultant_name2+
			",course_consultant_phone2="+course_consultant_phone2+",is_probation2="+is_probation2+",probation_time2="+probation_time2+
			",course_education_training2="+course_education_training2+",course_remarks2="+course_remarks2+",updateby="+"<%=CurUser.getUserID()%>"+",createby="+"<%=CurUser.getUserID()%>");
}
/****************************business_education_info****************************/

	/*~[Describe=执行更新操作前执行的代码;InputParam=无;OutPutParam=无;]~*/
	function CheckSum()
	{	
		var temBusinessSum = getItemValue(0, getRow(), "BusinessSum");
		var LowPrinciPalMin = "<%=LowPrinciPalMin%>";
		var TallPrinciPalMax = "<%=TallPrinciPalMax%>";
		var ShoufuRatio = "<%=ShoufuRatio%>";//产品首付比例
		
		//-- add by tangyb CCS-1255比较贷款最高额度（贷款本金减去佰保袋贷款本金） 20160220 start --//
		var subProductType = "<%=sSubProductType%>";
		// 是否是普通消费或学生消费贷
		if("0" == subProductType || "7" == subProductType) {
			var businesstype2 = getItemValue(0, 0,"BusinessType2");
			if("2015061500000017" == businesstype2){ //2015061500000017[佰保袋]
				var businessSum2 = getItemValue(0, 0, "BusinessSum2"); //贷款本金2
				temBusinessSum = parseFloat(temBusinessSum) - parseFloat(businessSum2);
			}
		}
		//-- end --//
		
		if(parseFloat(temBusinessSum) > parseFloat(TallPrinciPalMax) || parseFloat(temBusinessSum) < parseFloat(LowPrinciPalMin)){
			alert("贷款本金金额不在产品的的最低和最高范围内，请确认！");
			return false;
		}
		
		var ShoufuRatioType = "<%=ShoufuRatioType%>";//1:固定比例2:最低比例3:固定金额
		var sBusinessSum = getItemValue(0,getRow(),"BusinessSum");//本金
		var sTotalSum = getItemValue(0,getRow(),"TotalSum");//自付金额
		
		var sPaymentRate = getItemValue(0,getRow(),"PaymentRate");//合同首付比例
		if(ShoufuRatioType=="1"){
			if(parseFloat(sPaymentRate) == parseFloat(ShoufuRatio)){
				return true;
			}else{
				alert("首付比例必须等于产品首付比例："+ShoufuRatio+"%");
				return false;
			}
		}else if(ShoufuRatioType=="2"){
			if(parseFloat(sPaymentRate) >= parseFloat(ShoufuRatio)){
				return true;
			}else{
				alert("首付比例必须大于等于产品首付比例："+ShoufuRatio+"%");
				return false;
			}
		} else if (ShoufuRatioType=="3") {
			if(parseFloat(sTotalSum) == parseFloat(ShoufuRatio)){
				return true;
			}else{
				alert("首付金额必须等于产品首付金额："+ShoufuRatio+"元");
				return false;
			}
		} else if (ShoufuRatioType=="4") {
			if(parseFloat(sTotalSum) >= parseFloat(ShoufuRatio)){
				return true;
			}else{
				alert("首付金额必须大于等于产品首付金额："+ShoufuRatio+"元");
				return false;
			}
		}
		
		return true;
	}

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
		//
		sReplaceName = getItemValue(0,getRow(),"ReplaceName");//代扣/放款账号户名
		sRepaymentWay = getItemValue(0,getRow(),"RepaymentWay");//还款方式
		sCustomerName = getItemValue(0,getRow(),"CustomerName");//客户姓名
		//alert(sReplaceName+"---"+sCustomerName+"----"+sRepaymentWay);
		
		if(sRepaymentWay == "1" && sReplaceName != sCustomerName){
			alert("非客户本人的银行卡不能办理银行代扣业务!");
			return false;
		}
		var sBusinessSum = getItemValue(0,getRow(),"BusinessSum");//本金
		if(parseFloat(sBusinessSum) < 0.0){
			alert("贷款本金不能小于零!");
			return false;
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
	/* function selectCategoryID()
	{
		sBusinessType = getItemValue(0,0,"BusinessType");

		sParaString = "BusinessType"+","+sBusinessType;
		//设置返回参数 
		setObjectValue("SelectCategoryType",sParaString,"@BusinessRange1@0@BusinessRangeName@1",0,0,"");
	} */
	
	/*~[Describe=弹出类型选择窗口，并置将返回的值设置到指定的域;InputParam=无;OutPutParam=无;]~*/
		/*~[Describe=弹出范畴选择窗口，并置将返回的值设置到指定的域;InputParam=无;OutPutParam=无;]~*/
	function selectCategoryID()
	{
		sBusinessType = getItemValue(0,0,"BusinessType");

		//sParaString = "BusinessType"+","+sBusinessType;
		//设置返回参数 
//		setObjectValue("SelectCategoryType",sParaString,"@BusinessRange1@0@BusinessRangeName@1",0,0,"");
		
		sCompID = "CreditCategoryList";
		sCompURL = "/CreditManage/CreditApply/CreditCategoryList.jsp";
	    var sReturn=popComp(sCompID,sCompURL,"BusinessType="+sBusinessType,"dialogWidth=500px;dialogHeight=460px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		if(typeof(sReturn) == "undefined" || sReturn == "")
		{
			return;
		}
	    sReturn=sReturn.split("@");
	    if(sReturn=="_CANCEL_"){
	    	 setItemValue(0,0,"BusinessRangeName","");
	    	 //-- add by tangyb ccs-1255 start --//
			 setItemValue(0,0,"BusinessRange1",""); //清空商品范畴1编码
			 //-- end --//
	    	 return;
	    }
	    setItemValue(0,0,"BusinessRange1",sReturn[0]);
	    setItemValue(0,0,"BusinessRangeName",sReturn[1]);
	}
	
	//-- add CCS-1255：佰保袋需求 tangyb 20160218 start --//
	/**
	 * add by tangyb CCS-1255 20160220 
	 * 获取佰保袋售价
	 */
	function getSellPrice() {
		var subProductType = "<%=sSubProductType%>";
		// 是否是普通消费或学生消费贷
		if("0" == subProductType || "7" == subProductType) {
			var modelno = getItemValue(0, 0, "MODELNO"); //佰保袋机型
			var serveyear = getItemValue(0,0,"SERVEYEAR");//延保期限
			
			modelno = modelnoCheck(modelno); //add 手机串号重复检查 PRM-837 tangyb 20160418
			
			if((modelno != null && modelno != "" && modelno != "undefined")
					&& (serveyear != null && serveyear != "" && serveyear != "undefined")){
				var modelInfo = RunMethod("公用方法", "GetColValue", "bbd_model_cost_config,price ||','||deduct,modelno = '"+modelno+"' AND serveyear = '"+serveyear+"'");
				if(modelInfo != null && modelInfo != "" && modelInfo != "Null"){
					var modelInfos = modelInfo.split(",");
					
					var price = modelInfos[0]; // 佰保袋售价
					var deduct = modelInfos[1]; // 销售提成
					
					setItemValue(0,0,"Price2", price);//价格2
					setItemValue(0,0,"BusinessSum2", price);//贷款本金2
					setItemValue(0,0,"DEDUCT", deduct);//销售提成
					
					//计算每月还款额,自付金额，贷款本金，总价格联动
					getMonthPayment();
				} else {
					setItemValue(0, 0, "SERVEYEAR", "");//延保期限
					alert("您选择机型的延保期限费用未配置");
					return false;
				}
			}
		}
		return true;
	}
	
	/**
	 * add by tangyb CCS-1255 20160220 
	 * 商品类型佰保袋控制
	 * flag[0:非佰保袋,1:佰保袋]
	 */
	function operateMobileSerialNumber(flag){
		var subProductType = "<%=sSubProductType%>";
		// 是否是普通消费或学生消费贷
		if("0" == subProductType || "7" == subProductType) {
			if("1" == flag){ // 佰保袋
				setItemValue(0, 0, "TotalSum2", "0"); //自付金额2  
				setItemReadOnly(0, 0, "TotalSum2", true); //自付金额2  只读
				
				setItemRequired(0, 0, "Price2", true); //价格2 必输
				setItemReadOnly(0, 0, "Price2", true); //价格2 只读
				
				setItemRequired(0, 0, "MODELNO", true); // 佰保袋机型 必输
				setItemRequired(0, 0, "SERVEYEAR", true); // 延保期限 必输
				setItemRequired(0, 0, "mobileSerialNumber", true); // 手机串号 必输
				
				setItemDisabled(0, 0, "MODELNO", false); // 佰保袋机型 非只读
				setItemDisabled(0, 0, "SERVEYEAR", false); // 延保期限 非只读
				
				setItemReadOnly(0, 0, "mobileSerialNumber", false); // 手机串号 非只读
			}else{
				setItemValue(0, 0, "TotalSum2", ""); //自付金额2 
				setItemReadOnly(0, 0, "TotalSum2", false); //自付金额2  非只读
				
				setItemRequired(0, 0, "Price2", false); //价格2 非必输
				setItemReadOnly(0, 0, "Price2", false); //价格2 非只读
				
				setItemRequired(0, 0, "mobileSerialNumber", false); // 手机串号 非必输
				setItemRequired(0, 0, "MODELNO", false); // 佰保袋机型 非必输
				setItemRequired(0, 0, "SERVEYEAR", false); // 延保期限 非必输
				
				setItemDisabled(0, 0, "MODELNO", true); // 佰保袋机型 只读
				setItemDisabled(0, 0, "SERVEYEAR", true); // 延保期限 只读
				setItemReadOnly(0, 0, "mobileSerialNumber", true); // 手机串号 只读
				
				setItemValue(0, 0, "MODELNO", ""); //佰保袋机型 
				setItemValue(0, 0, "SERVEYEAR", ""); //延保期限 
				setItemValue(0, 0, "Price2", ""); //价格2 
				setItemValue(0, 0, "BusinessSum2", "0"); //贷款本金2
				setItemValue(0, 0, "mobileSerialNumber", ""); //手机串号
				
				//计算每月还款额,自付金额，贷款本金，总价格联动
				getMonthPayment();
			}
		}
	}
	
	/**
	 * add by tangyb CCS-1255 20160220 
	 * 佰保袋服务验证
	 */
	function validateBbd(){
		var subProductType = "<%=sSubProductType%>"; //子产品类型代码
		
		// 普通消费贷或学生消费贷
		if(subProductType == "0" || subProductType == "7") {
			var storeCityCode = "<%=sStoreCityCode%>"; //门店所在的城市
			var businesstype1 = getItemValue(0, 0, "BusinessType1"); //商品类型1
			var businesstype2 = getItemValue(0, 0, "BusinessType2"); //商品类型2
			var businesstype3 = getItemValue(0, 0, "BusinessType3"); //商品类型3
			
			//商品类型1、商品类型3选择佰保袋2015061500000017[佰保袋]
			if(businesstype1 == "2015061500000017" || businesstype3 == "2015061500000017"){
				alert("佰保袋服务必须在商品信息2中选择");
				return false;
			}
			
			//商品类型2选择佰保袋2015061500000017[佰保袋]
			if(businesstype2 == "2015061500000017") { 
				var serveyear = getItemValue(0, 0, "SERVEYEAR"); //延保期限
				var modelno = getItemValue(0, 0, "MODELNO"); //百宝袋机型
				var price2 = getItemValue(0, 0, "Price2"); //价格2
				var mobileserialnumber = getItemValue(0, 0, "mobileSerialNumber"); //手机串号
				var businessRangeName1 = getItemValue(0, 0, "BusinessRangeName"); //商品范畴1
				
				var businessrange1 = getItemValue(0, 0, "BusinessRange1"); //商品范畴1
				var businessRangeName3 = getItemValue(0, 0, "BusinessRangeName3"); //商品范畴3
				
				if(serveyear == null || serveyear == "" || serveyear == "undefined"){
					alert("延保期限不能为空");
					return false;
				}
				
				if(modelno == null || modelno == "" || modelno == "undefined"){
					alert("百宝袋机型不能为空");
					return false;
				}
				
				if(price2 == null || price2 == "" || price2 == "undefined"){
					alert("价格2不能为空");
					return false;
				}
				
				if(mobileserialnumber == null || mobileserialnumber == "" || mobileserialnumber == "undefined"){
					alert("手机串号不能为空");
					return false;
				} else {
					if(mobileserialnumber.length != 15 && mobileserialnumber.length != 17){
						alert("手机串号长度必须为15位或17位 ");
						return false;
					}
					
					//--add 手机串号重复检查 PRM-837 tangyb 20160418 start--//
					var serialno = getItemValue(0,0,"SerialNo"); //合约编号
					var checkParams = "mobnumber="+mobileserialnumber+",serialno="+serialno;
					var msginfo = RunJavaMethodSqlca("com.amarsoft.app.lending.bizlets.BaibaobagManageInfo", "mobnumberCheck", checkParams);
					if(msginfo != ""){
						alert(msginfo);
						return false;
					}
					//-- end --//
				}
				
				if(businessRangeName1 == null || businessRangeName1 == "" || businessRangeName1 == "undefined"){
					alert("商品范畴1不能为空");
					return false;
				}
				
				// 验证商品范畴是否允许选择佰保袋服务
				var params = "businessrange1="+businessrange1;
				var msgInfo = RunJavaMethodSqlca("com.amarsoft.app.lending.bizlets.BaibaobagManageInfo", "bbdBusinessCheck", params);
				if(msgInfo != "" && msgInfo != null){
					alert(msgInfo);
					return false;
				}
				
				if((businessRangeName3 != null && businessRangeName3 != "")
						|| (businesstype3 != null && businesstype3 != "")){
					alert("选择佰保袋服务“商品信息3”不能再填写信息");
					return false;
				}
				
				// 获取该门店所在城市对应的佰保袋供应商
				var providerId = RunMethod("公用方法", "GetColValue", "bbd_provider_relative_city,provider_id,status='1' and city_id='"+storeCityCode+"'");
				if(providerId == null || providerId == "" || providerId == "Null"){
					alert("该门店所在的城市还未提供佰保袋服务");
					return false;
				}
				
				setItemValue(0, 0, "PROVIDER_ID", providerId);  //供应商ID
			}
		} 
		return true;
	}
	
	/**
	 * add by tangyb CCS-1255 20160220 
	 * 佰保袋信息保存
	 */
	function saveBbdInfo(){
		var subProductType = "<%=sSubProductType%>";
		
		// 是否是普通消费或学生消费贷
		if("0" == subProductType || "7" == subProductType) {
			var userid = "<%=CurUser.getUserID()%>"; //操作用户
			var serialno = getItemValue(0, getRow(), "SerialNo");// 合同流水号
			var typename2 =  getItemValue(0, 0,"BusinessType2"); //商品类型2
			var mobnumber =  getItemValue(0, 0,"mobileSerialNumber"); //手机串号
			var providerid =  getItemValue(0, 0,"PROVIDER_ID"); //供应商ID
			var serveyear =  getItemValue(0, 0,"SERVEYEAR"); //延保期限
			var modelno =  getItemValue(0, 0,"MODELNO"); //百宝袋机型编码
			var price =  getItemValue(0, 0,"Price2"); //价格2(百宝袋售价)
			var deduct =  getItemValue(0, 0,"DEDUCT"); //销售提成
			
			// 佰保袋信息保存参数
			var parms = "serialno="+serialno+",userid="+userid+",typename2="+typename2+",mobnumber="+mobnumber
					+",providerid="+providerid+",serveyear="+serveyear+",modelno="+modelno+",price="+price+",deduct="+deduct;
			
			var sReturn = RunJavaMethodSqlca("com.amarsoft.app.lending.bizlets.BaibaobagManageInfo", "saveBbdInfo", parms);
			if(sReturn == "Error"){
				alert("佰保袋信息保存失败！");
				return false;
			}
		}
		
		return true;
	}
	
	/**
	 * add PRM-837：手机串号重复检查 tangyb 20160418 
	 * 验证手机价格与佰保袋机型是否匹配
	 */
	function modelnoCheck(modelno){
		var price =  getItemValue(0, 0,"Price1"); //价格1(手机价格)
		
		//手机价格不为空
		if(price != null && typeof(price) != "undefined" && sReturn != ""){
			
			//非苹果机型(其他)
			if(modelno == "2001" || modelno == "2002"){
				if(parseFloat(price) > 2500){
					modelno = "2001"; //2001:其他：手机商品价格2500元以上
				} else {
					modelno = "2002"; //2002:其他：手机商品价格2500元及以下
				}
				
				setItemValue(0, 0, "MODELNO", modelno); //赋值佰保袋机型
			}
		}
		
		return modelno;
	}
	//-- add ccs-1255 tangyb 20160220 end --//
	
	/*~[Describe=弹出类型选择窗口，并置将返回的值设置到指定的域;InputParam=无;OutPutParam=无;]~*/
	function selectTypeID()
	{
		sBusinessRange1 = getItemValue(0,0,"BusinessRange1");
		
		if(typeof(sBusinessRange1) == "undefined" || sBusinessRange1 == "")
		{
			alert("请先选择范畴1类型!");
			return;
		}
		sCompID = "CreditCategoryList1";
		sCompURL = "/CreditManage/CreditApply/CreditCategoryList1.jsp";
	    var sReturn=popComp(sCompID,sCompURL,"BusinessRange1="+sBusinessRange1,"dialogWidth=500px;dialogHeight=460px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
	    if(typeof(sReturn) == "undefined" || sReturn == "")
		{
			return;
		}
	    sReturn=sReturn.split("@");
	    if(sReturn=="_CANCEL_"){
	    	 setItemValue(0,0,"BusinessTypeName","");
	    	 //-- add by tangyb ccs-1255 start --//
			 setItemValue(0,0,"BusinessType1",""); //清空类型1编码
			 //-- end --//
	    	 return;
	    }
	    setItemValue(0,0,"BusinessType1",sReturn[0]);
	    setItemValue(0,0,"BusinessTypeName",sReturn[1]);
	    
	  //如果前面的商品类型有输入，则价格为必选项
	    var sBusinessTypeName=getItemValue(0,getRow(),"BusinessTypeName");
	    
	    if(typeof(sBusinessTypeName) == "undefined" || sBusinessTypeName.length==0){
			return false;
		}else{
			setItemRequired(0, 0, "Price1", true);
		}
//		sParaString = "ProductcategoryID"+","+sBusinessRange1;
		//设置返回参数 
//		setObjectValue("SelectMoldType",sParaString,"@BusinessType1@0@BusinessTypeName@1",0,0,"");
	}
	
	
	function selectCategoryID2()
	{
		sBusinessType = getItemValue(0,0,"BusinessType");
		
		sCompID = "CreditCategoryList";
		sCompURL = "/CreditManage/CreditApply/CreditCategoryList.jsp";
	    var sReturn=popComp(sCompID,sCompURL,"BusinessType="+sBusinessType,"dialogWidth=500px;dialogHeight=460px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
	    if(typeof(sReturn) == "undefined" || sReturn == "")
		{
			return;
		}
	    sReturn=sReturn.split("@");
	    if(sReturn=="_CANCEL_"){
	    	 setItemValue(0,0,"BusinessRangeName2","");
	    	 //-- add by tangyb ccs-1255 start --//
			 setItemValue(0,0,"BusinessRange2",""); //清空商品范畴2编码
			 //-- end --//
	    	 return;
	    }
	    setItemValue(0,0,"BusinessRange2",sReturn[0]);
	    setItemValue(0,0,"BusinessRangeName2",sReturn[1]);

//		sParaString = "BusinessType"+","+sBusinessType;
		//设置返回参数 
//		setObjectValue("SelectCategoryType",sParaString,"@BusinessRange2@0@BusinessRangeName2@1",0,0,"");
	}
	
	function selectTypeID2()
	{
		sBusinessRange2 = getItemValue(0,0,"BusinessRange2");
		
		if(typeof(sBusinessRange2) == "undefined" || sBusinessRange2 == "")
		{
			alert("请先选择范畴2类型!");
			return;
		}

		sCompID = "CreditCategoryList1";
		sCompURL = "/CreditManage/CreditApply/CreditCategoryList1.jsp";
	    var sReturn=popComp(sCompID,sCompURL,"BusinessRange1="+sBusinessRange2,"dialogWidth=500px;dialogHeight=460px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
	    if(typeof(sReturn) == "undefined" || sReturn == "")
		{
			return;
		}
	    sReturn=sReturn.split("@");
	    if(sReturn=="_CANCEL_"){
	    	setItemValue(0,0,"BusinessTypeName2","");
	    	 
			//-- add by tangyb ccs-1255 start --//
			setItemValue(0,0,"BusinessType2",""); //清空类型2编码
			operateMobileSerialNumber("0");
			//-- end --//
	    	return;
	    }
	    setItemValue(0,0,"BusinessType2",sReturn[0]);
	    setItemValue(0,0,"BusinessTypeName2",sReturn[1]);
	  //如果前面的商品类型有输入，则价格为必选项
	    var sBusinessTypeName2=getItemValue(0,getRow(),"BusinessTypeName2");
	    
	    if(typeof(sBusinessTypeName2) == "undefined" || sBusinessTypeName2.length==0){
			return false;
		}else{
			//-- add by tangyb ccs-1255 20160220 start --//
			var businesstype2=getItemValue(0,getRow(),"BusinessType2"); // 商品类型
			if("2015061500000017" == businesstype2){ //2015061500000017[佰保袋]
				operateMobileSerialNumber("1");
			}else{
				operateMobileSerialNumber("0");
			}
			//-- end --//
		}
//	    sParaString = "ProductcategoryID"+","+sBusinessRange2;
		//设置返回参数 
//		setObjectValue("SelectMoldType",sParaString,"@BusinessType2@0@BusinessTypeName2@1",0,0,"");
	}
	
	
	function selectCategoryID3()
	{
		sBusinessType = getItemValue(0,0,"BusinessType");
		
		sCompID = "CreditCategoryList";
		sCompURL = "/CreditManage/CreditApply/CreditCategoryList.jsp";
	    var sReturn=popComp(sCompID,sCompURL,"BusinessType="+sBusinessType,"dialogWidth=500px;dialogHeight=460px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
	    if(typeof(sReturn) == "undefined" || sReturn == "")
		{
			return;
		}
	    sReturn=sReturn.split("@");
	    if(sReturn=="_CANCEL_"){
	    	 setItemValue(0,0,"BusinessRangeName3","");
	    	 //-- add by tangyb ccs-1255 start --//
			 setItemValue(0,0,"BusinesSrange3",""); //清空商品范畴3编码
			 //-- end --//
	    	 return;
	    }
	    setItemValue(0,0,"BusinesSrange3",sReturn[0]);
	    setItemValue(0,0,"BusinessRangeName3",sReturn[1]);

//		sParaString = "BusinessType"+","+sBusinessType;
		//设置返回参数 
//		setObjectValue("SelectCategoryType",sParaString,"@BusinessRange3@0@BusinessRangeName3@1",0,0,"");
	}
	
	function selectTypeID3()
	{
		sBusinessRange3 = getItemValue(0,0,"BusinesSrange3");
		if(typeof(sBusinessRange3) == "undefined" || sBusinessRange3 == "")
		{
			alert("请先选择范畴3类型!");
			return;
		}

		sCompID = "CreditCategoryList1";
		sCompURL = "/CreditManage/CreditApply/CreditCategoryList1.jsp";
	    var sReturn=popComp(sCompID,sCompURL,"BusinessRange1="+sBusinessRange3,"dialogWidth=500px;dialogHeight=460px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
	    sReturn=sReturn.split("@");
	    if(sReturn=="_CANCEL_"){
	    	setItemValue(0,0,"BusinessTypeName3","");
	    	 
	    	//-- add by tangyb ccs-1255 20160220 start --//
	    	setItemValue(0,0,"BusinessType3",""); //清空类型3编码
	    	setItemRequired(0, 0, "Price3", false); //价格3 非必输
	    	//-- end --//
	    	 
	    	return;
	    }
	    setItemValue(0,0,"BusinessType3",sReturn[0]);
	    setItemValue(0,0,"BusinessTypeName3",sReturn[1]);
	    
	  //如果前面的商品类型有输入，则价格为必选项
	    var sBusinessTypeName3=getItemValue(0,getRow(),"BusinessTypeName3");
	    
	    if(typeof(sBusinessTypeName3) == "undefined" || sBusinessTypeName3.length==0){
			return false;
		}else{
			setItemRequired(0, 0, "Price3", true);
		}
//		sParaString = "ProductcategoryID"+","+sBusinessRange3;
		//设置返回参数 
//		setObjectValue("SelectMoldType",sParaString,"@BusinessType3@0@BusinessTypeName3@1",0,0,"");
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
	
	// 选择代扣行
	function getBankCodeName() {
		
		var sPayWay = getItemValue(0, 0, "RepaymentWay");
		var sCompID = "SelectWithholdBankCodeList";
		var sCompURL = "/CreditManage/CreditApply/SelectWithholdBankCodeList.jsp";
		var sParaString="PayWay=" + sPayWay;
		
		var sReturn = popComp(sCompID,sCompURL,sParaString,"dialogWidth=680px;dialogHeight=450px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		
		if(typeof(sReturn)=="undefined" || sReturn=="" || sReturn=="_CANCEL_") return;
		
		//获取返回值
		if (sReturn) {
			var sReturn = sReturn.split("@");
			var sOpenBank = sReturn[0];		//
			var sOpenBankName = sReturn[1];		//
			setItemValue(0,0,"OpenBank",sOpenBank);
			setItemValue(0,0,"OpenBankName",sOpenBankName);	
		} else {
			setItemValue(0,0,"OpenBank","");
			setItemValue(0,0,"OpenBankName","");			
		}
		//add CCS-368 现金贷放款需要提供支行代码信息才能放款，系统需增加放款的支行信息
		if("020" == "<%=sProductid%>")
		{
			setItemValue(0,0,"OpenBranch","");
			setItemValue(0,0,"OpenBranchName","");
		}
		//end
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
		
		sReturn = popComp(sCompID,sCompURL,sParaString,"dialogWidth=680px;dialogHeight=450px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		if(sReturn=="undefined@undefined"){
			sReturn="@";
		}
		if(typeof(sReturn)=="undefined" || sReturn=="" || sReturn=="_CANCEL_") return;
		
		//获取返回值
		sReturn = sReturn.split("@");
		sBankNo=sReturn[0];//
		sBranch=sReturn[1];//

		setItemValue(0,0,"OpenBranch",sBankNo);
		setItemValue(0,0,"OpenBranchName",sBranch);
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
			setItemRequired(0,0,"OpenBankName",true);
			setItemRequired(0,0,"ReplaceName",true);
			setItemRequired(0,0,"CityName",true);//代扣省市
		}else{
			setItemRequired(0,0,"ReplaceAccount",false);
			setItemRequired(0,0,"OpenBank",false);
			setItemRequired(0,0,"OpenBankName",false);
			setItemRequired(0,0,"ReplaceName",false);
			setItemRequired(0,0,"CityName",false);//代扣省市
		}
	}
	
	//add  wlq   校验放款账号长度 20140814  
	function checkReplaceAccount(){
		var sReplaceAccount =getItemValue(0,getRow(),"ReplaceAccount");
		sRepaymentWay = getItemValue(0,0,"RepaymentWay");
		sReplaceAccount=sReplaceAccount+"";
		
		if(sRepaymentWay=="1"){
			var tst = /^\d+$/;
			if(!tst.test(sReplaceAccount)){
				alert("代扣/放款账号必须是数字！");
				return "error";
			}
			//add by pli 2015/04/09 CCS-609 安硕系统支持代扣银行增加“哈尔滨银行”
			//如销售选择”哈尔滨银行股份有限公司“为客户的银行卡开户行后，对代扣账户账号框做出判断以下两项判断:填写的账号为”625952“开头、且卡号为16位
			//update by huanghui 2015/12/01 PRM-668哈行代扣卡校验设置  卡号前12位必须是625952100000的数字开头。
			var sOpenBank = getItemValue(0,getRow(),"OpenBank");//代扣银行代码
			if((typeof(sOpenBank) != "undefined" || sOpenBank.length != 0)&&sOpenBank=="142"){//选择了哈尔滨银行作为代扣银行
				if(typeof(sReplaceAccount) == "undefined" || sReplaceAccount.length == 0||sReplaceAccount.substring(0,12)!="625952100000"){
					alert("代扣/放款账号必须以“625952100000”开头！");
					return "error";
				}else if(sReplaceAccount.length!=16){
					alert("代扣/放款账号长度必须为16位！");
					return "error";
				}
			}else if(sReplaceAccount.length<16||sReplaceAccount.length>19){
				alert("代扣/放款账号长度在16-19位之间！");
				return "error";
			}
			//end by pli
			if(typeof(sReplaceAccount) != "undefined" || sReplaceAccount.length != 0){
				var sFirstStr=sReplaceAccount.substring(0,1);
			if(sFirstStr=="5"){
				alert("代扣/放款账号不能以5开头！");
				return "error";
			}
			//end
			}
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
		selectCreditRates();
	}
	
	//汽车型号代码
	function selectCarCode(){
		//设置返回参数 
		setObjectValue("SelectCarCode","","@CarCode@0@CarBrand@1@CartypeDescribe@2@CarSeries@3@CarPrice@4@CarBody@5@Enginecapacity@6@ProductionYear@7@CarColour@8",0,0,"");
		selectSalvageSum();//联动计算残值金额与比率
		selectSalvageRatio();
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
	
	/*~[Describe=车贷初始化数据;InputParam=无;OutPutParam=无;]~*/
	function carInitRow()
	{
		setItemValue(0,getRow(),"IntereStrate","<%=sRateType%>");//利率类型
		setItemValue(0,getRow(),"Periods","<%=tTerm%>");//贷款期数
		setItemValue(0,getRow(),"CreditRate","<%=cCreditRate%>");//贷款利率
		//setItemValue(0,getRow(),"PaymentRate","<%=tShouFuRatio%>");//首付比例
		setItemValue(0,getRow(),"FinalPayment","<%=tSectionRatio%>");//尾款比例
		
	}
	
	/*~[Describe=初始化数据;InputParam=无;OutPutParam=无;]~*/
	function initRow() {
		//-- add by tangyb CCS-1255 初始化佰保袋信息 20160220 start --//
		var subProductType = "<%=sSubProductType%>";
		
		// 是否是普通消费或学生消费贷
		if("0" == subProductType || "7" == subProductType) {
			var businesstype2 = getItemValue(0,getRow(),"BusinessType2"); //商品类型2
			
			if("2015061500000017" == businesstype2){ //佰保袋[2015061500000017]
				operateMobileSerialNumber("1");
			} else {
				setItemReadOnly(0, 0, "TotalSum2", false); //自付金额2  非只读
				
				setItemRequired(0, 0, "Price2", false); //价格2 必输
				setItemReadOnly(0, 0, "Price2", false); //价格2 非只读
				
				setItemRequired(0, 0, "mobileSerialNumber", false); // 手机串号 非必输
				setItemRequired(0, 0, "MODELNO", false); // 佰保袋机型 非必输
				setItemRequired(0, 0, "SERVEYEAR", false); // 延保期限 非必输
				
				setItemDisabled(0, 0, "MODELNO", true); // 佰保袋机型 只读
				setItemDisabled(0, 0, "SERVEYEAR", true); // 延保期限 只读
				setItemReadOnly(0, 0, "mobileSerialNumber", true); // 手机串号 只读
			}
			
			var bbdinfo = RunMethod("公用方法", "GetColValue", "bbd_treasurebag_info,mobile_serial_number||'@'||provider_id||'@'||modelno||'@'||deduct||'@'||serveyear,SerialNo='"+getItemValue(0, 0, "SerialNo")+"'");
			if(null != bbdinfo && "" != bbdinfo && "Null" != bbdinfo){
				var bbdinfos = bbdinfo.split("@");
				setItemValue(0, getRow(), "mobileSerialNumber", bbdinfos[0]); // 手机串号
				setItemValue(0, getRow(), "PROVIDER_ID", bbdinfos[1]); // 供应商ID
				setItemValue(0, getRow(), "MODELNO", bbdinfos[2]); // 百宝袋机型编码
				setItemValue(0, getRow(), "DEDUCT", bbdinfos[3]); // 销售提成
				setItemValue(0, getRow(), "SERVEYEAR", bbdinfos[4]); // 延保期限
			}
		}
		//-- add by tangyb CCS-1255 初始化佰保袋信息 20160220 end --//
		
		//客户主管  add  by ybpan  CCS-588  系统中增加中域ALDI模式的客户主管
	   setItemValue(0,getRow(),"CustomerHolder","<%=sCustomerHolder%>");
	   setItemValue(0,getRow(),"CustomerHolderName","<%=sCustomerHolderName%>");
		//end
	//贷款用途如选择“其他”，备注内容必填
	   if("020" == "<%=sProductid%>"){
			ChangePurposeRemark();
			}
		var sMonthRepayment=getItemValue(0,0,"MonthRepayment");
		if(<%=sCreditAttribute%>=="0001"){
			carInitRow();
		}
		//add 现金贷
		if("020" == "<%=sProductid%>"&&(sMonthRepayment==null 
							|| "" == sMonthRepayment)) {//update 增加sMonthRepayment为空的情况 20150515
			CashLoanGetMonthPayment();
		} 
		//end
		if ("020" != "<%=sProductid%>" && (sMonthRepayment == null || "" == sMonthRepayment)) {
			getMonthPayment();
		}
		
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
		if(sObjectType == "ReinforceContract" && (typeof(sManageUserID) == "undefined"
				|| sManageUserID == "")) {
			setItemValue(0, getRow(), "ManageUserID", "<%=CurUser.getUserID()%>");
			setItemValue(0, getRow(), "ManageUserName", "<%=CurUser.getUserName()%>");
		}
		if(sObjectType == "ReinforceContract" && (typeof(sPutOutOrgID) == "undefined"
				|| sPutOutOrgID == "")){
			setItemValue(0, getRow(), "PutOutOrgID", "<%=CurOrg.getOrgID()%>");
			setItemValue(0, getRow(), "PutOutOrgName", "<%=CurOrg.getOrgName()%>");
		}
		if(sObjectType == "ReinforceContract" && (typeof(sInputUserID) == "undefined"
				|| sInputUserID == "")){
			setItemValue(0, getRow(), "InputUserID", "<%=CurUser.getUserID()%>");
			setItemValue(0, getRow(), "InputUserName", "<%=CurUser.getUserName()%>");
		}
		if(sObjectType == "ReinforceContract" && (typeof(sOperateUserID) == "undefined"
				|| sOperateUserID == "")){
			setItemValue(0, getRow(), "OperateUserID", "<%=CurUser.getUserID()%>");
			setItemValue(0, getRow(), "OperateUserName", "<%=CurUser.getUserName()%>");
		}
		var sBusinessCurrency = getItemValue(0, getRow(), "BusinessCurrency");
		if(isNull(sBusinessCurrency)){
			setItemValue(0,getRow(),"BusinessCurrency","01");
			sBusinessCurrency="01";
		}	
		var sBaseRateType = getItemValue(0,getRow(),"BaseRateType");
		if(isNull(sBaseRateType)){
			//币种为人民币,基准利率类型设置为人行基准利率,排除贴现业务、除公司委托贷款的typeno以2开头的业务、个人公积金贷款、进口信用证开立、备用信用证开立、福费庭、提货担保、国内信用证开立、国内信用证项下买方代付
			if (sBusinessCurrency == "01" && !(!isNull(sBusinessType) 
					&& (sBusinessType.indexOf("1020") == 0 || sBusinessType.indexOf("3") == 0 
					|| (sBusinessType.indexOf("2") == 0 && sBusinessType != "2070")) 
					|| ",1110180,1080005,1080007,1080060,1080410,1090010,1090030".indexOf(sBusinessType) > 0)) {
				setItemValue(0, getRow(), "BaseRateType", "010");
			}
		}	

        //申请"福庭费"业务时，如果"票据币种"值为空，则设置为人名币
        if (sBusinessType == "1080060") {
            var sTradeCurrency = getItemValue(0,getRow(),"TradeCurrency");
            if (sTradeCurrency == "") {
                setItemValue(0,getRow(),"TradeCurrency","01");
           }
        }
				
		if(sBusinessType == "1100010" && sObjectType == "CreditApply") {
			setItemValue(0,getRow(),"BusinessSum",0);
		}
		
		if(sOccurType == "015" && sObjectType == "CreditApply") { //展期业务
		
			setItemValue(0,getRow(),"Relativeagreement","<%=dOldSerialNo%>");
			setItemValue(0,getRow(),"TotalSum","<%=dOldBusinessSum%>");
			setItemValue(0,getRow(),"BusinessSum","<%=dOldBalance%>");
			setItemValue(0,getRow(),"BusinessCurrency","<%=sOldBusinessCurrency%>");
			setItemValue(0,getRow(),"TermDate1","<%=sOldMaturity%>");
			setItemValue(0,getRow(),"BaseRate","<%=dOldBusinessRate%>");
			setItemValue(0,getRow(),"ExtendTimes","<%=iExtendTimes%>");
		}
		
		if(sOccurType == "020") { //借新还旧
			//setItemValue(0,getRow(),"LNGOTimes","<%=iLNGOTimes%>");
		}
		if(sOccurType == "060") { //还旧借新
			setItemValue(0,getRow(),"GOLNTimes","<%=iGOLNTimes%>");
		}
		if(sOccurType == "030" && sObjectType == "CreditApply") { //债务重组
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
		//CCS-681 合同表增加门店城市 新增加合同时保存  jiangyuanlin20150515 增加
	    setItemValue(0,getRow(),"StoreCityCode","<%=sStoreCityCode%>");
	    //CCS-681 合同表增加门店城市  end
	    //消费贷项目CCS-1113 合同增加区县信息 daihuafeng begin
	    setItemValue(0,getRow(),"StoreCountyCode","<%=sStoreCountyCode%>");
	  	//消费贷项目CCS-1113 合同增加区县信息 daihuafeng end 
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

		//modify by jli5 默认值展示逻辑修正
		//展厅
		var ExhibitionHall = getItemValue(0,getRow(),"ExhibitionHall");
		if(typeof(ExhibitionHall) !="undefind" && ExhibitionHall==""){
			setItemValue(0,getRow(),"ExhibitionHall","<%=ssSno%>");
			setItemValue(0,getRow(),"ExhibitionHallName","<%=ssSname%>");
		}
		//经销商名称
		var DealerName = getItemValue(0,getRow(),"DealerName");
		if(typeof(DealerName) !="undefind" && DealerName==""){
			setItemValue(0,getRow(),"DealerName","<%=sServiceprovidersname%>");
		}
				
		//经销商所属集团
		var DealerGroup = getItemValue(0,getRow(),"DealerGroup");
		if(typeof(DealerGroup) !="undefind" && DealerGroup==""){
			setItemValue(0,getRow(),"DealerGroup","<%=sGenusgroup%>");
		}
		
		//所属车厂
		var Depot = getItemValue(0,getRow(),"Depot");
		if(typeof(Depot) !="undefind" && Depot==""){
			setItemValue(0,getRow(),"Depot","<%=sCarfactory%>");
		}
		//区域
		var Area = getItemValue(0,getRow(),"Area");
		if(typeof(Area) !="undefind" && Area==""){
			setItemValue(0,getRow(),"Area","<%=sCity%>");
			setItemValue(0,getRow(),"AreaName","<%=sCityName%>");		
		}
		//end by jli5 默认值展示逻辑修正
		//保险费率
		setItemValue(0,getRow(),"CreditFeeRate","<%=CredFeeRate%>");
		
		//贷款人
		setItemValue(0,getRow(),"CreditPerson","<%=sCreditPerson%>");
		setItemValue(0,getRow(),"CreditId","<%=sCreditId%>");
				
		// 还款帐号，户名初始化
		var sRepayAccountNo = RunMethod("公用方法", "GetColValue", "Business_Contract,755920947910910||CustomerId, SerialNo='"+getItemValue(0, 0, "SerialNo")+"'");
		//var sInsuranceNo = RunMethod("公用方法", "GetColValue", "Business_Contract,InsuranceNo, SerialNo='"+getItemValue(0, 0, "SerialNo")+"'");//保险公司
		var sCreditCycleFlag = "<%=sFlag %>";//是否可以投保的标志
		var subProductTypename ="<%=subProductTypename%>";
		if( "4"== subProductTypename || "5"==subProductTypename ){//消费贷中的学生贷与成人教育贷
			setItemValue(0, 0, "RepaymentWay", "1");// 还款方式 初始化为代扣
			setItemValue(0, 0, "CreditCycle", "2");// 是否投保 ，默认为否
			setItemValue(0, 0, "RepaymentNo", "<%=RepaymentNo%>");
			setItemValue(0, 0, "RepaymentBank", "<%=RepaymentBank%>");
			setItemValue(0, 0, "RepaymentBankName", "<%=RepaymentBankName%>");
			setItemValue(0, 0, "RepaymentName", "<%=RepaymentName%>");
		}else if("090" != "<%=sProductid%>"){
			//CCS-1239 合同页面已已经投保的合同，删除增值服务费，页面状态为：”未投保“。
			var CreditCycleValue = getItemValue(0, 0, "CreditCycle");
			if(sCreditCycleFlag=="false" && (CreditCycleValue=="" || CreditCycleValue =="undefind")){
				setItemValue(0, 0, "CreditCycle", "2");
			}
			setItemValue(0, 0, "RepaymentNo", "<%=RepaymentNo%>");
			setItemValue(0, 0, "RepaymentBank", "<%=RepaymentBank%>");
			setItemValue(0, 0, "RepaymentBankName", "<%=RepaymentBankName%>");
			setItemValue(0, 0, "RepaymentName", "<%=RepaymentName%>");
		}else{  //add 小企业贷需求
			setItemValue(0,getRow(),"SalesManager","<%=CurUser.getUserID()%>");
			setItemValue(0,getRow(),"MobileTel","<%=sSalesexecutivePhone%>");
		}
		
		loadAmount = getItemValue(0, 0, "BusinessSum"); 
		isInsure = getItemValue(0, 0, "CreditCycle");
		
		// 加载提交状态字段
		var operatedStatus = getItemValue(0, 0, "OPERATEDSTATUS");
		if (operatedStatus == null || operatedStatus == "" || operatedStatus == "undefind") {
			setItemValue(0, 0, "OPERATEDSTATUS", "0");// 提交状态
		}
	}
	//检测数据类型
	/* function CreditColumnCheck(sColumnName,sCheckType)
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
	} */
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
	
	/*~[Describe=设置首付比例;InputParam=无;OutPutParam=无;]~*/
	function inputPaymentSum(){
		var sCarTotal_ = '0'+getItemValue(0,getRow(),"CarTotal");//车辆总价
		var sPaymentSum_ = getItemValue(0,getRow(),"PaymentSum");//首付金额
		
		var nMonthRate = ''+getItemValue(0,getRow(),"CreditRate");//利率
		var nLoanTerm = getItemValue(0,getRow(),"Periods");//贷款期限
		var sBusinessSum_ = getItemValue(0,getRow(),"BusinessSum");//贷款本金
		var nMonthPay = 0.0;
		
		var sCarTotal=parseFloat(sCarTotal_);
		var sPaymentSum=parseFloat(sPaymentSum_);
		var sBusinessSum=parseFloat(sBusinessSum_);
		
		if(sCarTotal<0.0){
			alert("车辆总价错误，请检查！");
			return;
		}

		if(sPaymentSum<0.0) {
			alert("请输入大于等于0的首付款额！");
			setItemValue(0,0,"PaymentSum","");
			setItemValue(0,0,"BusinessSum","");
			return;
		}else if(sPaymentSum==0.0){
			setItemValue(0,0,"PaymentSum","");
			setItemValue(0,0,"BusinessSum","");
		}else if(sPaymentSum>sCarTotal){
			alert("首付额不能大于车辆总价！");
			setItemValue(0,0,"PaymentSum","");
			setItemValue(0,0,"BusinessSum","");
			return;
		}
		setItemValue(0, 0, "PaymentRate", (sPaymentSum/sCarTotal*100).toFixed(2));//首付比例
		sBusinessSum = sCarTotal-parseFloat(sPaymentSum);
		setItemValue(0, 0, "BusinessSum", sBusinessSum.toFixed(2));//贷款本金
	}
	
	// quliangmao    验证手机号码
	function checkMobile1(obj){
	    var sMobile = obj.value;
	    if(typeof(sMobile) == "undefined" || sMobile.length==0){
	    	alert("手机号码不能空");
	    	return false;
	    }
	    if(!(/^1[3|4|5|7|8][0-9]\d{8}$/.test(sMobile))){ 
	        alert("手机号码输入有误，请重新输入"); 
	        //obj.focus();
		    //setItemValue(0,0,"MobileTelephone","");
	        return false; 
	    } 
	}
	
/*********************验证手机号码**************************************************/
	
	function isCheckMobilePhone(obj){
		var sSchCouTel=obj.value;
		//空格自动忽略
		var sSCTel=sSchCouTel.replace(" ","");
		 if(typeof(sSCTel) == "undefined" || sSCTel.length==0){     
			 return false;
		 }
			var sSCTel1=sSCTel.split("-");
			var sSCTel2=sSCTel.substring(0,1);
			if(sSCTel1.length=="1"){
					if(sSCTel2=="1"){
					if(!(/^1[3|4|5|7|8][0-9]\d{8}$/.test(sSCTel))){    //非手机号
						alert("手机号码格式填写错误"); 
						obj.focus();
				        return false; 
						}	
					}else if(sSCTel2=="0"){
						alert("固定电话格式填写错误"); 
						obj.focus();
				        return false; 
					}else{
						alert("号码格式填写不合法");
						obj.focus();
						return false;
					}
			}else if(sSCTel1.length=="2"){
				if(/^0\d{2,3}$/.test(sSCTel1[0])){
					if((/^0\d{2,3}-?\d{7,9}$/.test(sSCTel))){
					}else{
						alert("固定电话格式填写错误");
						obj.focus();
						return false;
					}
				}else{
					alert("区号填写错误");
					obj.focus();
					return false;
				}
			}else if(sSCTel1.length>"3"){
				alert("固定电话填写不规范，请重新填写");
				obj.focus();
				return false;
			}else{			
				if(/^0\d{2,3}$/.test(sSCTel1[0])){
					if((/^\d{7,9}$/.test(sSCTel1[1]))){
						 if((/^\d{1,9}$/.test(sSCTel1[2]))){
						 }else{
							 alert("分机号码填写错误");
							 obj.focus();
							 return false;
						 }
					}else{
						alert("固定电话格式填写错误");
						obj.focus();
						return false;
					}
				}else{
					alert("区号填写错误");
					obj.focus();
					return false;
				}
			}
	}		
	
	//add 现金贷需求
	//初始化每月还款额
	function CashLoanGetMonthPayment()
	{
		var sBusinessSum = '0'+getItemValue(0,getRow(),"BusinessSum");//贷款本金
		var sBusinessType="<%=sBusinessType%>";//产品编号
		var sPeriods = getItemValue(0,getRow(),"Periods");//分期期数
		var sBugPayPkgind = getItemValue(0,0,"BugPayPkgind");//是否购买随心还服务包
		//增加账户管理费、财务顾问费 或保险费
		var YesNo = getItemValue(0, getRow(), "CreditCycle");//是否投保1:是 2：否		
		if(typeof(YesNo) == "undefined" || YesNo.length == 0){
			YesNo = "2";
		}
		//判断该产品是否配置随心还服务包费用
		if(sBugPayPkgind=="1"){
			var sRe = RunJavaMethodSqlca("com.amarsoft.app.lending.bizlets.CheckBugPayPkgind", "checkSuiXinHuan", "businessType="+sBusinessType);
			if(sRe == 0){
				alert("该产品未配置收取随心还服务包费用！");
				setItemValue(0,0,"BugPayPkgind","0");
			}
		}
		
		var sMonthPayment=RunMethod("PublicMethod","GetMonthPayment",sBusinessSum+","+sBusinessType+","+sPeriods+","+YesNo+","+sBugPayPkgind);
		var MonthPaymentBefore = parseFloat(sMonthPayment).toFixed(2);
		var MonthPaymentAfter = fix(MonthPaymentBefore);
		setItemValue(0,getRow(),"MonthRepayment",MonthPaymentAfter+"");
		setItemValue(0,getRow(),"RepaymentWay","1");//现金贷：客户还款方式：默认客户选择代扣，且不可修改。
    }
    //放款账号格式检查
    function CheckPutOutAccount()
    {
    	var sflag2 =getItemValue(0,getRow(),"RepaymentNo");
    	
		sflag2=sflag2+"";
		var checkaccount = /^\d+$/;
		if(!checkaccount.test(sflag2)){
			alert("放款/还款账号必须是数字！");
			setItemValue(0,getRow(),"RepaymentNo","");
			return;
		}
		if(sflag2.length<10){
			alert("放款/还款账号长度不小于10位数！");
			setItemValue(0,getRow(),"RepaymentNo","");
			return;
		}
    }
	//获得放款帐号开户行编号/放款账户开户行名称/还款账号开户行编号/还款账号开户行名称
	function getOpenBankCodeName(Flag)
	{
		var ReturnSelInfo = "";
		if("Repayment" == Flag)
		{
			ReturnSelInfo = "@flag3@0@flag3Name@1@RepaymentBank@0@RepaymentBankName@1";
		}else if("OpenBank" == Flag)
		{
			ReturnSelInfo = "@OpenBank@0@OpenBankName@1";
		}
		setObjectValue("getOpenBankCodeName","",ReturnSelInfo,0,0,""); 
	}
	//贷款用途如选择“其他”，备注内容
	function ChangePurposeRemark()
	{
		var sPurpose = getItemValue(0,getRow(),"purpose");
		if("05" == sPurpose)
		{
			setItemRequired(0,getRow(),"purposeRemark",true);
		}else
		{
			setItemRequired(0,getRow(),"purposeRemark",false);
		}
	}

	//放款账号信息 与还款账号信息一致
	function UpdateRepaymentInfo()
	{
		var sRepaymentName = getItemValue(0,getRow(),"RepaymentName");//还款账户名
		var sRepaymentNo = getItemValue(0,getRow(),"RepaymentNo");//还款账号
		if(null != sRepaymentName && "" != sRepaymentName && "undefined" != sRepaymentName) setItemValue(0,0,"flag1",sRepaymentName);//放款账户名
		if(null != sRepaymentNo && "" != sRepaymentNo && "undefined" != sRepaymentNo) setItemValue(0,0,"flag2",sRepaymentNo);//放款账号
	}
    //end
    
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
		
		//-- add by tangyb CCS-1255 计算首付比例的时候总价格需要减去佰保袋的价格 20160220 start --//
		var subProductType = "<%=sSubProductType%>";
		// 是否是普通消费或学生消费贷
		if("0" == subProductType || "7" == subProductType) {
			var businesstype2 = getItemValue(0,getRow(),"BusinessType2"); // 商品类型2
			if("2015061500000017" == businesstype2){ //2015061500000017[佰保袋]
				sValue4 = sValue4 - parseFloat(sPrice2);
			}
		}
		//-- end --//
		
		var sValue7=sValue5/sValue4; //首付比列
		setItemValue(0,getRow(),"PaymentRate",sValue7.toFixed(2)*100+"");
		
		var sBusinessSum = getItemValue(0,getRow(),"BusinessSum");//本金
		var sTotalSum = getItemValue(0,getRow(),"TotalSum");//自付金额
		var sPeriods = getItemValue(0,getRow(),"Periods");//分期期数
		var sBusinessType="<%=sBusinessType%>";
		var sBugPayPkgind = getItemValue(0,0,"BugPayPkgind");//是否购买随心还服务包
		
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
		

		//判断该产品是否配置随心还服务包费用
		if(sBugPayPkgind=="1"){
			var sRe = RunJavaMethodSqlca("com.amarsoft.app.lending.bizlets.CheckBugPayPkgind", "checkSuiXinHuan", "businessType="+BusinessType);
			if(sRe == 0){
				alert("该产品未配置收取随心还服务包费用！");
				setItemValue(0,0,"BugPayPkgind","0");
			}
		}
		
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
				var sMonthPayment=RunMethod("PublicMethod","GetMonthPayment",sBusinessSum+","+sBusinessType+","+sPeriods+","+YesNo+","+sBugPayPkgind);
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
	
	/*~[Describe=影像操作;InputParam=无;OutPutParam=无;]~*/
    function imageManage(){
        var sObjectNo   = getItemValue(0,getRow(),"SerialNo");
        if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
            alert(getHtmlMessage('1'));//请选择一条信息！
            return;
        }
        //验证合同产品是否已经在影响配置中配置
		var sBusinessType = RunMethod("公用方法", "GetColValue", "Business_Contract,BusinessType,SerialNo='"+sObjectNo+"'");
     	var sAmount = RunMethod("公用方法","GetColValueTables","product_ecm_type,product_type_ctype,count(1),product_ecm_type.PRODUCT_TYPE_ID = product_type_ctype.PRODUCT_TYPE_ID and product_type_ctype.PRODUCT_ID ='"+sBusinessType+"' ");
     	if(sAmount == 0){
			alert("请先在商品影像配置中配置该产品对应的影像文件！");
			return false;
		}
	     var param = "ObjectType=Business&TypeNo=20&ObjectNo="+sObjectNo;
	     AsControl.PopView( "/ImageManage/ImageViewNew.jsp", param, "" );
    }
	
	// 生成还款信息
	function generatePaymentInfo() {
		
		// 1. 先判断是否需要重新生成
		var params = "objectNo=<%=sObjectNo %>";
		var isReconsider = "<%=isReconsider %>";
		var res = RunJavaMethodSqlca("com.amarsoft.app.lending.bizlets.LoadContractLoanInfo", 
									"gainIsGenSchedule", params);
		if ((res == null || res == "" || res == "0") && (isReconsider != "1")) {
			alert("请先保存合同信息！");
			return;
		} else if (res == "2") {
			alert("不用重新试算还款信息！");
			return;
		} else {
			// 2. 再生成还款信息
			var SerialNo = getItemValue(0,getRow(),"SerialNo");//合同流水号
			var sCreditCycle = getItemValue(0, 0, "CreditCycle"); //是否投保
			var ReplaceAccount = getItemValue(0,0,"ReplaceAccount");//扣款账号
			var ReplaceName = getItemValue(0,0,"ReplaceName");//扣款账号名
			var sBusinessSum = getItemValue(0,getRow(),"BusinessSum");//本金
			
			params = "objectNo=" + SerialNo + ",userID=<%=CurUser.getUserID()%>," 
					+ "businessType=<%=sBusinessType%>,creditCycle=" + sCreditCycle 
					+ ",replaceAccount=" + ReplaceAccount + ",replaceName=" 
					+ ReplaceName + ",businessSum="+sBusinessSum + ",org=<%=CurUser.getOrgID()%>";
			
			res = RunJavaMethodSqlca("com.amarsoft.app.lending.bizlets.LoadContractLoanInfo", 
									"firstMonthPayTry", params);
			if(res == null || res.length == 0 || res == "Error") {
				alert("生成还款信息失败！");
				return;
			} else {
				setItemValue(0, 0, "MonthRepayment", fix(parseFloat(res)));
				alert("生成还款信息成功！");
				return;
			} 
		}
	}
</script>

<script type="text/javascript">
//身份证正则表达校验
function isCardNo()  
{
	var card = getItemValue(0,getRow(),"Idcard");
	//alert("==================="+card);
	checkIdcard(card);
}

//身份证
function checkIdcard(idcard){
		var Errors=new Array( 
							"验证通过!", 
							"身份证号码位数不对!", 
							"身份证号码出生日期超出范围或含有非法字符!", 
							"身份证号码校验错误!", 
							"身份证地区非法!" 
							); 
		var area={11:"北京",12:"天津",13:"河北",14:"山西",15:"内蒙古",21:"辽宁",22:"吉林",23:"黑龙江",31:"上海",32:"江苏",33:"浙江",34:"安徽",35:"福建",36:"江西",37:"山东",41:"河南",42:"湖北",43:"湖南",44:"广东",45:"广西",46:"海南",50:"重庆",51:"四川",52:"贵州",53:"云南",54:"西藏",61:"陕西",62:"甘肃",63:"青海",64:"宁夏",65:"新疆",71:"台湾",81:"香港",82:"澳门",91:"国外"} 
							 
		var idcard,Y,JYM; 
		var S,M; 
		var idcard_array = new Array(); 
		idcard_array     = idcard.split(""); 
		//alert(area[parseInt(idcard.substr(0,2))]);
		
		//地区检验 
		if(area[parseInt(idcard.substr(0,2))]==null){
			alert(Errors[4]);
			setItemValue(0,0,"Idcard","");
			return Errors[4];
		}
		 
		//身份号码位数及格式检验 
		
		switch(idcard.length){
		case 15: 
			if((parseInt(idcard.substr(6,2))+1900) % 4 == 0 || ((parseInt(idcard.substr(6,2))+1900) % 100 == 0 && (parseInt(idcard.substr(6,2))+1900) % 4 == 0 )){ 
				ereg=/^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}$/;//测试出生日期的合法性 
			}else{ 
				ereg=/^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}$/;//测试出生日期的合法性 
			} 
		 
			if(ereg.test(idcard)){
				alert(Errors[0]);
				setItemValue(0,0,"Idcard","");
				return Errors[0]; 
		        
			}else{ 
				alert(Errors[2]);
				setItemValue(0,0,"Idcard","");
				return Errors[2];  
			}
			break; 
		case 18: 
			//18位身份号码检测 
			//出生日期的合法性检查  
			//闰年月日:((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9])) 
			//平年月日:((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8])) 
			if ( parseInt(idcard.substr(6,4)) % 4 == 0 || (parseInt(idcard.substr(6,4)) % 100 == 0 && parseInt(idcard.substr(6,4))%4 == 0 )){ 
				ereg=/^[1-9][0-9]{5}19[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}[0-9Xx]$/;//闰年出生日期的合法性正则表达式 
			}else{
				ereg=/^[1-9][0-9]{5}19[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}[0-9Xx]$/;//平年出生日期的合法性正则表达式 
			} 
			if(ereg.test(idcard)){//测试出生日期的合法性 
				//计算校验位 
				S  =  (parseInt(idcard_array[0]) + parseInt(idcard_array[10])) * 7 
					+ (parseInt(idcard_array[1]) + parseInt(idcard_array[11])) * 9 
					+ (parseInt(idcard_array[2]) + parseInt(idcard_array[12])) * 10 
					+ (parseInt(idcard_array[3]) + parseInt(idcard_array[13])) * 5 
					+ (parseInt(idcard_array[4]) + parseInt(idcard_array[14])) * 8 
					+ (parseInt(idcard_array[5]) + parseInt(idcard_array[15])) * 4 
					+ (parseInt(idcard_array[6]) + parseInt(idcard_array[16])) * 2 
					+  parseInt(idcard_array[7]) * 1  
					+  parseInt(idcard_array[8]) * 6 
					+  parseInt(idcard_array[9]) * 3 ; 
				Y    = S % 11; 
				M    = "F"; 
				JYM  = "10X98765432"; 
				M    = JYM.substr(Y,1);//判断校验位 
				if(M == idcard_array[17]){
					return  Errors[0];		//检测ID的校验位 
				}else{
					alert(Errors[3]);
					setItemValue(0,0,"Idcard","");
					return  Errors[3]; 
		        }
			}else{
				alert(Errors[2]);
				setItemValue(0,0,"Idcard","");
				return Errors[2]; 
		    }
			break;
		default:
		    alert(Errors[1]);
		    setItemValue(0,0,"Idcard","");
			return  Errors[1]; 

			break;
		} 
			 
}
	/*~ 选择选择登陆用户关联的展厅下的有效的金融经理~*/
	function selectManage(){
		var sParaString ="sNo,"+"<%=sNo%>";
		setObjectValue("SelectManage",sParaString,"@ManageUserID@0@ManagerName@1",0,0,"");
	}

	/*~ 填写推荐人信息 ~*/
	function judgeName() {
		
		var username = getItemValue(0, 0, "REFERER");
		if (username == null || username == "") {
			return;
		}
		
    	var res = RunJavaMethodSqlca("com.amarsoft.app.awe.config.orguser.action.UserManageAction", 
    			"judgeName", "username=" + username);
    	if (res == "ERROR" || res == "0") {
    		if (!window.confirm("无法找到该推荐人, 是否继续保存该推荐人信息！")) {
    			setItemValue(0, 0, "REFERER", "");
    		}
    	}
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
