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

	//定义变量：对象主表名、对应关联表名、SQL语句、产品类型、客户代码、显示属性、产品版本
	String sMainTable = "",sRelativeTable = "",sSql = "",sBusinessType = "",sCustomerID = "",sColAttribute = "",sThirdParty="0.0",sProductVersion="",sSalesexecutive="",sSalesexecutiveName="";
	//定义变量：查询列名、显示模版名称、申请类型、发生类型、暂存标志
	String sFieldName = "",sDisplayTemplet = "",sApplyType = "",sOccurType = "",sTempSaveFlag = "",sProductid="",sProductcategoryname="",sProductcategoryId="";
	//定义变量：关联业务币种、关联业务到期日、关联流水号、借据号
	String sOldBusinessCurrency = "",sOldMaturity = "",sRelativeSerialNo = "",dOldSerialNo = "",ssSno="",sSno="",sSname="",ssSname="",sServiceprovidersname="",sGenusgroup="",sCarfactoryid="",sCreditId="",sCreditPerson="",sCity="",sAttr2="",sCarfactory="";
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
     //String sNo = CurARC.getAttribute(request.getSession().getId()+"city");
     String sNo = Sqlca.getString(new SqlObject("select attribute8 from user_info  where userid=:UserID").setParameter("UserID", CurUser.getUserID()));

     if(sNo == null) sNo = "";
     System.out.println("-------销售门店-------"+sNo);
     
     sSql="select sno,sname from store_info where sno = :sno and  identtype = '01'";
     rs=Sqlca.getASResultSet(new SqlObject(sSql).setParameter("sno",sNo));
     if(rs.next()){
    	 sSno = DataConvert.toString(rs.getString("sno"));//门店
    	 sSname = DataConvert.toString(rs.getString("sname"));
 		//将空值转化成空字符串
 		if(sSno == null) sSno = "";
 		if(sSname == null) sSname = "";
 		
     }
     rs.getStatement().close();
     
     
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
     
  	
  	String ssCity = Sqlca.getString(new SqlObject("select city from store_info si where si.sno=:sno").setParameter("sno", sNo));
  	//获取贷款人信息(汽车金融与消费金融取值逻辑一直)
    sSql="select sp.serialno as SerialNo,sp.serviceprovidersname as ServiceProvidersName "+
  				" from Service_Providers sp where sp.customertype1='06' and sp.city like '%"+ssCity+"%' ";
      rs=Sqlca.getASResultSet(sSql);
      if(rs.next()){
     	 sCreditId = DataConvert.toString(rs.getString("SerialNo"));//贷款人编号
     	 sCreditPerson = DataConvert.toString(rs.getString("ServiceProvidersName"));//贷款人名称
     	
  		//将空值转化成空字符串
  		if(sCreditId == null) sCreditId = "";
  		if(sCreditPerson == null) sCreditPerson = "";
      }
      rs.getStatement().close();
     
     //查询区域
//      sSql="select attr2 from BaseDataSet_Info WHERE TypeCode='AreaCodeCar' and attr1 in (select attrstr2 from BaseDataSet_Info WHERE TypeCode='CityCodeCar' and Attr1=:city)";
//      rs=Sqlca.getASResultSet(new SqlObject(sSql).setParameter("city",sCity));
//      if(rs.next()){
//     	 sAttr2 = DataConvert.toString(rs.getString("attr2"));//区域名称
//      }
//      rs.getStatement().close();
//      ARE.getLog().debug("区域"+sAttr2);
      
	

	  String sCreditAttribute = "";//0002消费/0001汽车/0003经销商
     
     //查询销售代表
     sSql="select Salesexecutive,getusername(Salesexecutive) as SalesexecutiveName,ProductID,CreditAttribute from business_contract where serialno=:serialno";
     rs=Sqlca.getASResultSet(new SqlObject(sSql).setParameter("serialno",sObjectNo));
     if(rs.next()){
    	 sSalesexecutive = DataConvert.toString(rs.getString("Salesexecutive"));//销售代表ID
    	 sSalesexecutiveName = DataConvert.toString(rs.getString("SalesexecutiveName"));//销售代表Name
    	 
    	 sProductid = DataConvert.toString(rs.getString("ProductID"));//产品类型
    	 sCreditAttribute =  DataConvert.toString(rs.getString("CreditAttribute"));//产品类型
    	 
 		//将空值转化成空字符串
 		if(sSalesexecutive == null) sSalesexecutive = "";
 		if(sSalesexecutiveName == null) sSalesexecutiveName = "";
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
	
	//是否有保险费
	String productobjectno = sBusinessType+"-V1.0";
	String scount = Sqlca.getString(new SqlObject("select count(*) from product_term_library where subtermtype = 'A12' and objecttype='Product' and objectno='"+productobjectno+"' "));
	if(Integer.valueOf(scount)==0){
		doTemp.setReadOnly("CreditCycle", true);
		doTemp.setRequired("CreditCycle", false);
	}
	
	//获取关联产品的参数
	String LowPrinciPalMin = "",TallPrinciPalMax = "",ShoufuRatio = "",ShoufuRatioType = "",sRateType = "",monthcalculationMethod = "",sRateFloatType="",cProductType="";
	String highestLoansProportion = "",whetherDiscount = "";
		String sSqlBT = " select LOWPRINCIPAL,TALLPRINCIPAL,SHOUFURATIO,SHOUFURATIOTYPE,ratetype,monthcalculationMethod,floatingManner,highestLoansProportion,whetherDiscount,producttype from business_type where typeno='"+sBusinessType+"' ";
		rs = Sqlca.getASResultSet(new SqlObject(sSqlBT));
		while(rs.next()){
			LowPrinciPalMin = rs.getString("LOWPRINCIPAL");
			TallPrinciPalMax = rs.getString("TALLPRINCIPAL");
			ShoufuRatio = rs.getString("SHOUFURATIO");
			ShoufuRatioType = rs.getString("SHOUFURATIOTYPE");
			sRateType = DataConvert.toString(rs.getString("rateType"));//利率类型  modify by jli5 处理null
			monthcalculationMethod = rs.getString("monthcalculationMethod");//月供计算方式
			sRateFloatType = rs.getString("floatingManner");//利率浮动方式
			
			highestLoansProportion = rs.getString("highestLoansProportion");//最高贷款比例
			whetherDiscount = rs.getString("whetherDiscount");//是否贴息
			cProductType = rs.getString("producttype");//区分汽车金融/融资租赁 01：汽车，02：融资
			
		}
		rs.getStatement().close();
	
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
	String cRateValue = Sqlca.getString(new SqlObject("select yearsinterestrate from Interest_Rate where interestratetype='01' and isinuse='1' "+ 
	        " and to_date(to_char(sysdate, 'yyyy/MM/dd'), 'yyyy/mm/dd')>=to_date(effectivedate, 'yyyy/MM/dd') and term='"+tTermTemp+"' and rownum='1' "));
	if(cRateValue==null) cRateValue="0";

	//汽车金融  根据产品类型   显示模版控制 add by jli5 
	if("0001".equals(sCreditAttribute)){
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
	}
	
	//若产品关联了提前还款手续费 申请阶段删除此费用，做提前还款申请时再产生费用记录
	String tqhksxfTermID = Sqlca.getString(new SqlObject("select termid from product_term_library where subtermtype = 'A9' and objecttype='Product' and objectno='"+productobjectno+"' "));
	if(tqhksxfTermID == null) tqhksxfTermID = "";
	
%>
<%
   doTemp.setReadOnly("CustomerType", true);//add by jli5 客户申请类型不能修改
  
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
	
	//获取贷款人的相关信息
	String RepaymentNo = "";//还款账号
	String RepaymentBank = "";//还款账号开户行
	String RepaymentName = "";//还款账号户名
	String RepaymentBankName = "";
	String sCreditid = Sqlca.getString("select CreditID from Business_Contract where SerialNo = '"+sObjectNo+"'");
	sSql = "select backAccountPrefix,turnAccountName,turnAccountBlank,getItemName('BankCode',turnAccountBlank) as RepaymentBankName from Service_Providers where SerialNo =:SerialNo";
	SqlObject soSer = new SqlObject(sSql).setParameter("SerialNo", sCreditid);
	rs = Sqlca.getASResultSet(soSer);
	if(rs.next()){
		RepaymentNo = rs.getString("backAccountPrefix");
		RepaymentBank = rs.getString("turnAccountBlank");
		RepaymentName = rs.getString("turnAccountName");
		RepaymentBankName = rs.getString("RepaymentBankName");
	}
	if(RepaymentNo == null || RepaymentNo == "") RepaymentNo = "755920947910920";
	if(RepaymentBank == null || RepaymentBank == "") RepaymentBank = "308";
	if(RepaymentBankName == null || RepaymentBankName == "") RepaymentBankName = "招商银行深圳四海支行";
	if(RepaymentName == null || RepaymentName == "") RepaymentName = "深圳市佰仟金融服务有限公司";
	rs.getStatement().close();
	
	RepaymentNo = RepaymentNo+Sqlca.getString("select CustomerID from Business_Contract where SerialNo = '"+sObjectNo+"'");
	
	RepaymentBankName = "招商银行深圳四海支行";
	//获取客户保存状态
	String sCTempSaveFlag = Sqlca.getString(new SqlObject("select Tempsaveflag from Ind_Info where CustomerID =:CustomerID").setParameter("CustomerID", sCustomerID));
	
	//首次还款日
	String sFirstDueDate = "";
	String sDefaultDueDay = "";
	String temDay = "";
	String businessDate = SystemConfig.getBusinessDate();	
	
	temDay = businessDate.substring(8, 10);
	if(temDay.equals("29")){
		temDay = "02";
		sDefaultDueDay = DateFunctions.getRelativeDate(businessDate, DateFunctions.TERM_UNIT_MONTH, 2);
		sFirstDueDate = sDefaultDueDay.substring(0, 8)+temDay;
	}else if(temDay.equals("30")){
		temDay = "03";
	    sDefaultDueDay = DateFunctions.getRelativeDate(businessDate, DateFunctions.TERM_UNIT_MONTH, 2);
		sFirstDueDate = sDefaultDueDay.substring(0, 8)+temDay;
	}else if(temDay.equals("31")){
		temDay = "04";
	    sDefaultDueDay = DateFunctions.getRelativeDate(businessDate, DateFunctions.TERM_UNIT_MONTH, 2);
		sFirstDueDate = sDefaultDueDay.substring(0, 8)+temDay;
	}else{
		sFirstDueDate = DateFunctions.getRelativeDate(businessDate, DateFunctions.TERM_UNIT_MONTH, 1);
	}

	//一个客户多个合同的情况，判定首次还款日，取客户之前最早的合同
	String sFirstNextDueDate = "";
	int sDays=0;
	String minSerialNo = Sqlca.getString(new SqlObject("SELECT min(serialno) FROM business_contract where finishdate is null and CONTRACTSTATUS not in ('090','200','140','130','160','040','120','210','010','150','110','030') and customerid = :CustomerID and serialno != :serialno ").setParameter("CustomerID", sCustomerID).setParameter("serialno", sObjectNo));
	if(minSerialNo == null) minSerialNo = "";
	if(!minSerialNo.equals("")){
		sFirstNextDueDate = Sqlca.getString(new SqlObject("SELECT NEXTDUEDATE FROM acct_loan where putoutno in (SELECT min(serialno) FROM business_contract where CONTRACTSTATUS not in ('090','200','140','130','160','040','120','210','010','150','110','030') and customerid = :CustomerID and serialno != :serialno) ").setParameter("CustomerID", sCustomerID).setParameter("serialno", sObjectNo));	
		if(sFirstNextDueDate == null) sFirstNextDueDate = "";
		if(!sFirstNextDueDate.equals("")){
			sDays = DateFunctions.getDays(businessDate, sFirstNextDueDate);
			if(sDays >= 14){
				sFirstDueDate = sFirstNextDueDate;
			}else{
				sFirstDueDate = DateFunctions.getRelativeDate(sFirstNextDueDate, DateFunctions.TERM_UNIT_MONTH, 1);
			}
		}		
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
		{"true","All","Button","暂存","暂时保存所有修改内容","saveRecordTemp()",sResourcesPath},
		{"false","All","Button","打印申请表","打印申请表","creatApplyTable()",sResourcesPath},
		{"false","All","Button","打印电子合同","打印电子合同","creatContract()",sResourcesPath},
		{"true","All","Button","上传照片","上传照片","imageManage()",sResourcesPath},
		{"false","All","Button","打印三方协议","打印三方协议","creatThirdTable()",sResourcesPath},
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
	function saveRecord()
	{	
		// 去掉贷款本金字段后面提示 add by tbzeng 2014/05/03  
		var sTemp = _user_validator[0].rules.BUSINESSSUM.expressions;
		for (var x in sTemp) {
			sTemp[x] = "";
		} 
		// hope fixme carefully
		
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
	
		if(vI_all("myiframe0"))
		{
			var returncheck = CheckSum();
			if(!returncheck){
				return;
			}
			
			if("01"=='<%=CurUser.getIsCar()%>' &&!CarValidityCheck()){	//汽车金融相关校验
				return;			
			}
			
			beforeUpdate();
			if(!saveSubItem()) return;
			setItemValue(0,getRow(),"TempSaveFlag","2"); //暂存标志（1：是；2：否）
			
			var returnvalue = inserTermPara();//加入利率，还款方式
			if(!returnvalue){
				alert("产生费用记录出错,请检查再重新保存！");
				return;
			}
			
			SetBusinessMaturity();//合同保存为合同生效
			as_save("myiframe0");
		}
	}
	
	
	/*~[Describe=汽车金融相关校验;InputParam=无;OutPutParam=无;]~*/
	function CarValidityCheck(){
		
		
		return true;
	}
	
	
	/*~[Describe=计算到期日;InputParam=无;OutPutParam=无;]~*/
	function SetBusinessMaturity(){
		var SerialNo=getItemValue(0,getRow(),"SerialNo");//合同流水号
		var sPutOutDate = "<%=SystemConfig.getBusinessDate()%>";
		var sFirstDueDate = "<%=sFirstDueDate%>";
		//设置首次还款日
		RunMethod("PublicMethod","UpdateColValue","String@FIRSTDUEDATE@"+sFirstDueDate+",acct_rpt_segment,String@ObjectNo@"+SerialNo);//首次还款日	
		
		var sDay = sPutOutDate.substring(8,10); 
		var deDaultDueDay = "<%=temDay%>";
		
		RunMethod("PublicMethod","UpdateColValue","String@defaultdueday@"+deDaultDueDay+",acct_rpt_segment,String@ObjectNo@"+SerialNo);//合同默认还款日	
		var sTermMonth_ = RunMethod("GetElement","GetElementValue","Periods,business_contract,SerialNo='"+SerialNo+"'");//期限
		var sTermMonth = parseInt(sTermMonth_,10);
		var sMaturity = "";
		if(typeof(sTermMonth)== "undefined" || sTermMonth.length == 0 ) {
			alert("合同未录入贷款期次！");
			return ;
		}
		if(sTermMonth !=0){
		   sLoanTermFlag ="020";//期限单位(月)
		   sMaturity = RunMethod("BusinessManage","CalcMaturity",sLoanTermFlag+","+sTermMonth+","+sPutOutDate);
		}
		RunMethod("PublicMethod","UpdateColValue","String@PutOutDate@"+sPutOutDate+",BUSINESS_CONTRACT,String@SerialNo@"+SerialNo);//合同生效日
		RunMethod("PublicMethod","UpdateColValue","String@contractEffectiveDate@"+sPutOutDate+",BUSINESS_CONTRACT,String@SerialNo@"+SerialNo);//合同生效日
		RunMethod("PublicMethod","UpdateColValue","String@Maturity@"+sMaturity+",BUSINESS_CONTRACT,String@SerialNo@"+SerialNo);//合同到期日
	}
	
	//加入组件参数
	function inserTermPara(){
		var sObjectType = "<%=sObjectType%>";
		var sObjectNo="<%=sObjectNo%>";
		var sApplyType="<%=sApplyType%>";
		var sBusinessType = "<%=sBusinessType%>";
		var CreditAttribute = "<%=sCreditAttribute%>";
		var RepaymentWay = getItemValue(0,0,"RepaymentWay");//还款渠道
		if(CreditAttribute == "0002"){//消费贷
			var sTermID = "RPT17";//等额本息
			RunMethod("ProductManage","initObjectWithProduct","initObjectWithProduct,"+sTermID+",<%=sObjectType%>,<%=sObjectNo%>");
			//固定利率
			RunMethod("ProductManage","initObjectWithProduct","initObjectWithProduct,RAT002,<%=sObjectType%>,<%=sObjectNo%>");
			//创建费用
			var sReturnFeeBool = RunMethod("LoanAccount","CreateFeeList",sBusinessType+",<%=sObjectType%>,<%=sObjectNo%>,<%=CurUser.getUserID()%>");
						
			var sCreditCycle = getItemValue(0, 0, "CreditCycle"); //是否投保 
			if(sCreditCycle=="2"){//不投保  
				//删除管理的保险费 方案信息
				RunMethod("PublicMethod","DeleteFee","A12,<%=sObjectNo%>");
			}
			
			//扣款账户信息
			if(RepaymentWay=="1"){//代扣
				var accountIndicator="01";//扣款
				//查询该笔合同关联的扣款卡号是否存在
				sReturn = RunMethod("PublicMethod","DistinctAccount1","<%=sObjectNo%>,jbo.app.BUSINESS_CONTRACT,"+accountIndicator);
				var ReplaceAccount = getItemValue(0,0,"ReplaceAccount");//扣款账号
				var ReplaceName = getItemValue(0,0,"ReplaceName");//扣款账号名
				if(sReturn>0){
					RunMethod("PublicMethod","UpdateColValue","String@accountno@"+ReplaceAccount+"@String@accountname@"+ReplaceName+",acct_deposit_accounts,String@objecttype@jbo.app.BUSINESS_CONTRACT@String@accountindicator@01@String@OBJECTNO@"+sObjectNo);
				}else{
					var paymentSerialNo = getSerialNo("ACCT_DEPOSIT_ACCOUNTS","SerialNo","");
					RunMethod("LoanAccount","CreateRepayAccount",paymentSerialNo+","+"<%=sObjectNo%>"+","+ReplaceAccount+","+ReplaceName);
				}
				
			}else if(RepaymentWay=="2"){//非代扣
				var accountIndicator="01";//扣款
				//查询该笔合同关联的扣款卡号是否存在
				sReturn = RunMethod("PublicMethod","DistinctAccount1","<%=sObjectNo%>,jbo.app.BUSINESS_CONTRACT,"+accountIndicator);
				var ReplaceAccount = getItemValue(0,0,"RepaymentNo");//還款账号
				var ReplaceName = getItemValue(0,0,"RepaymentName");//扣款账号名
				if(sReturn>0){
					RunMethod("PublicMethod","UpdateColValue","String@accountno@"+ReplaceAccount+"@String@accountname@"+ReplaceName+",acct_deposit_accounts,String@objecttype@jbo.app.BUSINESS_CONTRACT@String@accountindicator@01@String@OBJECTNO@"+sObjectNo);
				}else{
					var paymentSerialNo = getSerialNo("ACCT_DEPOSIT_ACCOUNTS","SerialNo","");
					RunMethod("LoanAccount","CreateRepayAccount",paymentSerialNo+","+"<%=sObjectNo%>"+","+ReplaceAccount+","+ReplaceName);
				}
			}
			//放款账户
			var accountIndicator="00";//放款
			//查询该笔合同关联的扣款卡号是否存在
			sReturn = RunMethod("PublicMethod","DistinctAccount1","<%=sObjectNo%>,jbo.app.BUSINESS_CONTRACT,"+accountIndicator);
			var ReplaceAccount = "XFD"+"<%=sObjectNo%>";//扣款账号
			var ReplaceName = "消费贷客户";//放款账号名
			if(sReturn>0){
				RunMethod("PublicMethod","UpdateColValue","String@OBJECTNO@"+sObjectNo+",acct_deposit_accounts,String@accountname@"+ReplaceAccount+"@String@accountno@"+ReplaceName);
			}else{
				var AccountSerialNo = getSerialNo("ACCT_DEPOSIT_ACCOUNTS","SerialNo","");
				RunMethod("LoanAccount","CreateDepositAccount",AccountSerialNo+","+"<%=sObjectNo%>,jbo.app.BUSINESS_CONTRACT"+","+ReplaceAccount+","+accountIndicator+","+ReplaceName);
			}
			
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
		}else if(CreditAttribute == "0001"){//汽车金融
			var sRateType = "<%=sRateType%>";
			var Issue = getItemValue(0, 0, "Issue");//贷款期次
		
			var finrate = "FIN003";//浮动罚息
			var IntereStrate = getItemValue(0, 0, "IntereStrate");//利率类型
			var CreditRate = getItemValue(0, 0, "CreditRate");//贷款利率利率
			
			var RATTerm = "";
			if(IntereStrate=="0"){//固定利率
				 RATTerm = "RAT002";
			}else if(IntereStrate=="1"){//浮动利率
				 RATTerm = "RAT001";
			}else if(IntereStrate=="2"){//固定灵活
				 RATTerm = "RAT004";
			}
			
			RunMethod("ProductManage","initObjectWithProduct","initObjectWithProduct,"+RATTerm+",<%=sObjectType%>,<%=sObjectNo%>");//利率
			if(RATTerm == "RAT004"){//固定灵活利率
				RunMethod("PublicMethod","UpdateColValue","String@BUSINESSRATE@"+CreditRate+",acct_rate_segment,String@ratetermid@RAT004@String@OBJECTNO@"+sObjectNo);
			}
			RunMethod("ProductManage","initObjectWithProduct","initObjectWithProduct,"+finrate+",<%=sObjectType%>,<%=sObjectNo%>");//罚息
<%-- 			RunMethod("ProductManage","initObjectWithProduct","initObjectWithProduct,"+monthcalculationMethod+",<%=sObjectType%>,<%=sObjectNo%>");//补贴
 --%>		
 			
 			var SEGRPTAmount = getItemValue(0, 0, "FinalPaymentSum");//尾款金额
 			if(!(typeof(shoufuRatio)=="undefined" || shoufuRatio=="shoufuRatio" || shoufuRatio.length==0)){
 				RunMethod("PublicMethod","UpdateColValue","String@BUSINESSRATE@"+CreditRate+",acct_rate_segment,String@ratetermid@RAT004@String@OBJECTNO@"+sObjectNo);
 				/* RunMethod("PublicMethod","UpdateColValue","String@DEFAULTVALUE@"+SEGRPTAmount+",PRODUCT_TERM_PARA,String@paraid@SEGRPTAmount@String@termid@"+monthcalculationMethod+"@String@ObjectNo@"+sObjectNo);//尾款金额 */
 			}
 			
 			//还款方式
 			var monthcalculationMethod = "<%=monthcalculationMethod%>";
 			RunMethod("ProductManage","initObjectWithProduct","initObjectWithProduct,"+monthcalculationMethod+",<%=sObjectType%>,<%=sObjectNo%>");//月供计算方式
			
			<%-- 
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
			 --%>
			var sReturnFeeBool = RunMethod("LoanAccount","CreateFeeList",sBusinessType+",<%=sObjectType%>,<%=sObjectNo%>,<%=CurUser.getUserID()%>");
			
			/* if(s!="true"){
				alert("产品定义出错!");
				return "false";
			} */
			
			//扣款账号
			var RepaymentWay = getItemValue(0,0,"RepaymentWay");//还款方式ReplaceAccount
			
			if(RepaymentWay=="1"){//代扣
				var accountIndicator="01";//还款
				var ReplaceAccount = getItemValue(0,0,"ReplaceAccount");//扣款账号
				var ReplaceName = getItemValue(0,0,"ReplaceName");//扣款账号名
				sReturn = RunMethod("PublicMethod","DistinctAccount1","<%=sObjectNo%>,jbo.app.BUSINESS_CONTRACT,"+accountIndicator);
				if(sReturn>0){
					RunMethod("PublicMethod","UpdateColValue","String@OBJECTNO@"+sObjectNo+",acct_deposit_accounts,String@accountname@"+ReplaceName+"@String@accountno@"+ReplaceAccount);
				}else{
					var paymentSerialNo = getSerialNo("ACCT_DEPOSIT_ACCOUNTS","SerialNo","");
					RunMethod("LoanAccount","CreateRepayAccount",paymentSerialNo+","+"<%=sObjectNo%>"+","+ReplaceAccount+","+ReplaceName);
				}
				
			}
			
			if(sReturnFeeBool == "ture"){
				return true;
			}else{
				return false;
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
	function CheckSum()
	{	
		var temBusinessSum = getItemValue(0, getRow(), "BusinessSum");
		var LowPrinciPalMin = "<%=LowPrinciPalMin%>";
		var TallPrinciPalMax = "<%=TallPrinciPalMax%>";
		var ShoufuRatio = "<%=ShoufuRatio%>";//产品首付比例
		if(parseFloat(temBusinessSum) > parseFloat(TallPrinciPalMax) || parseFloat(temBusinessSum) < parseFloat(LowPrinciPalMin)){
			alert("贷款本金金额不在产品的的最低和最高范围内，请确认！");
			return false;
		}
		
		var ShoufuRatioType = "<%=ShoufuRatioType%>";//1:固定2:最低
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
	    	 return;
	    }
	    setItemValue(0,0,"BusinessRange1",sReturn[0]);
	    setItemValue(0,0,"BusinessRangeName",sReturn[1]);
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
	    	 return;
	    }
	    setItemValue(0,0,"BusinessType1",sReturn[0]);
	    setItemValue(0,0,"BusinessTypeName",sReturn[1]);
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
	    	 setItemValue(0,0,"BusinessRangeName","");
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
	    	 setItemValue(0,0,"BusinessTypeName","");
	    	 return;
	    }
	    setItemValue(0,0,"BusinessType2",sReturn[0]);
	    setItemValue(0,0,"BusinessTypeName2",sReturn[1]);
	
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
	    	 setItemValue(0,0,"BusinessRangeName","");
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
	    	 setItemValue(0,0,"BusinessTypeName","");
	    	 return;
	    }
	    setItemValue(0,0,"BusinessType3",sReturn[0]);
	    setItemValue(0,0,"BusinessTypeName3",sReturn[1]);
	    
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
		
		if(typeof(sReturn)=="undefined" || sReturn=="" || sReturn=="_CANCEL_") return;
		
		//获取返回值
		sReturn = sReturn.split("@");
		sBankNo=sReturn[0];//
		sBranch=sReturn[1];//

		setItemValue(0,0,"OpenBranch",sBankNo);
		setItemValue(0,0,"OpenBranchName",sBranch);
	}
	
	
	/*--------------汽车金融页面联动控制--------------begin-----------------modify by jli5-----------------*/
	//控制车辆售价不得高于出厂价
	function selectVPrice(obj){
		var sVehiclePrice =getItemValue(0,0,"VehiclePrice");//车辆售价
		var sCarPrice =getItemValue(0,0,"CarPrice");//出厂价
		
		if(parseFloat(sVehiclePrice) > parseFloat(sCarPrice)){
			alert("车辆售价不得高于出厂价");
			obj.focus();
		}
		//计算车辆总价
		selectOtherCost();
		
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
			    selectPaymentRateW();
			    selectPaymentSumW();//尾款比例与金额
				selectPaymentSum();//首付款比例与金额
				selectPaymentRate();
				
				selectBusinessSum();//计算贷款金额
	        }else{
	        	setItemValue(0,0,"CarTotal","");//车辆总价
	        }
		}
	}
	
	//首付款比例(汽车金融):(首付款金额/车辆总价)*100%
	function selectPaymentRate(){
		selectBusinessSum();//计算贷款金额
		var sProductID =getItemValue(0,0,"ProductID");//产品类型
		if(sProductID=="01"){
			var sPaymentSum =getItemValue(0,0,"PaymentSum");//首付款金额
			var sCarTotal   =getItemValue(0,0,"CarTotal");//车辆总价
		
			if(!isNaN(sPaymentSum) && !isNaN(sCarTotal)){
				var sPaymentRate=roundOff((parseFloat(sPaymentSum)/parseFloat(sCarTotal))*100,2);
	
				if(!isNaN(sPaymentRate)){
				    setItemValue(0,0,"PaymentRate",sPaymentRate);//首付款比例
				}else{
					  setItemValue(0,0,"PaymentRate","");
				}
			}
		}
	}
	//根据比率计算金额
	function selectPaymentSum(){
		var sProductID =getItemValue(0,0,"ProductID");//产品类型
		if(sProductID=="01"){
			var sPaymentRate =getItemValue(0,0,"PaymentRate");//首付款比例
			var sCarTotal   =getItemValue(0,0,"CarTotal");//车辆总价
			if(!isNaN(sPaymentRate) && !isNaN(sCarTotal)){
				var sPaymentSum=roundOff((parseFloat(sPaymentRate)*parseFloat(sCarTotal))*0.01,2);
				if(!isNaN(sPaymentSum)){
				    setItemValue(0,0,"PaymentSum",sPaymentSum);//首付款金额
				    selectBusinessSum();//计算贷款金额
				}else{
					 setItemValue(0,0,"PaymentSum","");//首付款金额
				}
			}
		}
	}
	
	
	//尾款比例:（尾款金额/ 车辆总价）*100%
	function selectPaymentRateW(){
		var sFinalPaymentSum =getItemValue(0,0,"FinalPaymentSum");//尾款金额
		var sCarTotal   =getItemValue(0,0,"CarTotal");//车辆总价
		if(!isNaN(sFinalPaymentSum) && !isNaN(sCarTotal)){
			var sFinalPayment=roundOff((parseFloat(sFinalPaymentSum)/parseFloat(sCarTotal))*100,2);
			if(!isNaN(sFinalPayment)){
			    setItemValue(0,0,"FinalPayment",sFinalPayment);//尾款比例
			}else{
				setItemValue(0,0,"FinalPayment","");//尾款比例
			}
		}
	}
	//根据比率计算金额
	function selectPaymentSumW(){
		var sFinalPayment =getItemValue(0,0,"FinalPayment");//尾款金额
		var sCarTotal   =getItemValue(0,0,"CarTotal");//车辆总价
		
		if(!isNaN(sFinalPayment) && !isNaN(sCarTotal)){
			var sFinalPaymentSum=roundOff((parseFloat(sFinalPayment)*parseFloat(sCarTotal))*0.01,2);
			if(!isNaN(sFinalPaymentSum)){
			    setItemValue(0,0,"FinalPaymentSum",sFinalPaymentSum);//尾款比例
			}else{
				setItemValue(0,0,"FinalPaymentSum","");
			}
		}
	}
	
	
	//残值比例(汽车租赁):（残值金额/ 车辆出厂价）*100%
	function selectSalvageRatio(){
		selectBusinessSum();//计算贷款金额
		var sProductID =getItemValue(0,0,"ProductID");//产品类型
 		if(sProductID=="02"){
			var sSalvageSum =getItemValue(0,0,"SalvageSum");//残值金额
			var sCarPrice   =getItemValue(0,0,"CarPrice");//车辆总价
			if(!isNaN(sSalvageSum) && !isNaN(sCarPrice)){
				var sSalvageRatio=roundOff((parseFloat(sSalvageSum)/parseFloat(sCarPrice))*100,2);
				if(!isNaN(sSalvageRatio)){
				    setItemValue(0,0,"SalvageRatio",sSalvageRatio);//残值比例
				}else{
					setItemValue(0,0,"SalvageRatio","")
				}
			}
		}
	}
	//根据比率计算金额
	function selectSalvageSum(){
		var sProductID =getItemValue(0,0,"ProductID");//产品类型
		if(sProductID=="02"){
			var sSalvageRatio =getItemValue(0,0,"SalvageRatio");//残值比率
			var sCarPrice   =getItemValue(0,0,"CarPrice");//车辆总价
			alert(sSalvageRatio+","+sCarPrice);
			if(!isNaN(sSalvageRatio) && !isNaN(sCarPrice)){
				var sSalvageSum=roundOff((parseFloat(sSalvageRatio)*parseFloat(sCarPrice))*0.01,2);
				if(!isNaN(sSalvageSum)){
				    setItemValue(0,0,"SalvageSum",sSalvageSum);//残值金额
				    selectBusinessSum();//计算贷款金额
				}else{
					setItemValue(0,0,"SalvageSum","");
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
				var 	sBusinessSum=roundOff(parseFloat(sCarTotal)-parseFloat(sPaymentSum),2);
				if(!isNaN(sBusinessSum)){
				    setItemValue(0,0,"BusinessSum",sBusinessSum);//贷款金额
				}else{
					setItemValue(0,0,"BusinessSum","");
				}
			}
			//控制贷款金额/车辆总价不得高于产品配置中的最高贷款比例
			var sBusinessType =  getItemValue(0,0,"BusinessType");//产品类型
			var sBusinessSum =  getItemValue(0,0,"BusinessSum");//贷款金额
			var sCarTotal =  getItemValue(0,0,"CarTotal");//车辆总价
			RunJavaMethodSqlca("","","");
		 }
		
		//汽车租赁：车辆总价-残值金额
		if(sProductID=="02"){
			var sCarTotal   =getItemValue(0,0,"CarTotal");//车辆总价
			var sSalvageSum =getItemValue(0,0,"SalvageSum");//残值金额
			
			if(!isNaN(sCarTotal) && !isNaN(sSalvageSum)){
				sBusinessSum=roundOff(parseFloat(sCarTotal)-parseFloat(sSalvageSum),2);
				if(!isNaN(sBusinessSum)){
				    setItemValue(0,0,"BusinessSum",sBusinessSum);//贷款金额
				}else{
					 setItemValue(0,0,"BusinessSum","");//贷款金额
				}
			}
		}
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
		
	//贷款利率
	/* 利率类型选择固定灵活利率需要销售经理手工输入贷款利率，并控制贷款利率不能小于产品期限相关参数配置表中的固定利率值，同时不得高于最高固定利率。
		若利率类型为固定利率，显示产品期限相关参数配置表中的固定利率值。
		当利率类型为浮动利率时，根据期限找到对应的基准利率，按照浮动类型，若为按比例浮动，则贷款利率=基准利率*（1+浮动幅度），若为按浮动点，则贷款利率=基准利率+浮动幅度 */
	function	selectCreditRate(){
		var sIntereStrate =  getItemValue(0,0,"IntereStrate");//利率类型
		var sProductID =  getItemValue(0,0,"ProductID");//产品
		var sPeriods =  getItemValue(0,0,"Periods");//贷款期数
		
		//
		var sCreditRate = RunJavaMethodSqlca("","","");
		if(!isNaN(sCreditRate) ){
			setItemValue(0,0,"CreditRates",sCreditRate);
		}else{
			setItemValue(0,0,"CreditRates","");
		}
	}
	
	
	//贷款金额/二手车评估价，二手车时显示
	function selectCreditRates(){
		var sCarStatus = getItemValue(0,0,"CarStatus");//车况
		if("02"!=sCarStatus){//旧车
			setItemValue(0,0,"CreditRates","");//基于评估价的贷款比例
			return;
		}
		var sBusinessSum   = getItemValue(0,0,"BusinessSum");//贷款金额
		var sAssessPrice   = getItemValue(0,0,"AssessPrice");//二手车评估价格
		if(!isNaN(sBusinessSum) && !isNaN(sAssessPrice)){
			var sCreditRates=roundOff(parseFloat(sBusinessSum)/parseFloat(sAssessPrice)*100,2);
			if(!isNaN(sCreditRates)){
			    setItemValue(0,0,"CreditRates",sCreditRates);//基于评估价的贷款比例
			}
		}
	}
	/*--------------汽车金融页面联动控制--------------end-----------------modify by jli5-----------------*/
		
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
			setItemRequired(0,0,"CityName",true);//代扣省市
			
			//隐藏和显示字段
			//hideItem(0, 0, "ReplaceAccount");
			//showItem(0, 0, "RepaymentWay");
		}else{
			setItemRequired(0,0,"ReplaceAccount",false);
			setItemRequired(0,0,"OpenBank",false);
			setItemRequired(0,0,"ReplaceName",false);
			setItemRequired(0,0,"CityName",false);//代扣省市
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
		setItemValue(0,getRow(),"PaymentRate","<%=tShouFuRatio%>");//首付比例
		
		
	}
	
	/*~[Describe=初始化数据;InputParam=无;OutPutParam=无;]~*/
	function initRow()
	{
		
		if(<%=sCreditAttribute%>=="0001"){
			carInitRow();
		}
		
		// fixme xx
		//DZ[iDW][1][iCol][0]
		//var iColNum = getColIndex(0, "BusinessSum");
		//alert(iColNum);
		//DZ[0][1][iColNum][0] = "";
		
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
		setItemValue(0,getRow(),"Stores","<%=sSno%>");
		setItemValue(0,getRow(),"StoresName","<%=sSname%>");
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

		
		//展厅
		setItemValue(0,getRow(),"ExhibitionHall","<%=ssSno%>");
		setItemValue(0,getRow(),"ExhibitionHallName","<%=ssSname%>");
		//经销商名称
		setItemValue(0,getRow(),"DealerName","<%=sServiceprovidersname%>");
		//经销商所属集团
		setItemValue(0,getRow(),"DealerGroup","<%=sGenusgroup%>");
		//所属车厂
		setItemValue(0,getRow(),"Depot","<%=sCarfactory%>");
		
		//贷款人
		setItemValue(0,getRow(),"CreditPerson","<%=sCreditPerson%>");
		setItemValue(0,getRow(),"CreditId","<%=sCreditId%>");
		//区域
		setItemValue(0,getRow(),"Area","<%=sCity%>");
		setItemValue(0,getRow(),"AreaName","<%=sCityName%>");
		
		
		//金融经理姓名
		setItemValue(0,getRow(),"ManagerName","<%=CurUser.getUserID()%>");
		
		// 还款帐号，户名初始化
		var sRepayAccountNo = RunMethod("公用方法", "GetColValue", "Business_Contract,755920947910910||CustomerId, SerialNo='"+getItemValue(0, 0, "SerialNo")+"'");
		//alert(sRepayAccountNo);
		setItemValue(0, 0, "RepaymentNo", "<%=RepaymentNo%>");
		setItemValue(0, 0, "RepaymentBank", "<%=RepaymentBank%>");
		setItemValue(0, 0, "RepaymentBankName", "<%=RepaymentBankName%>");
		setItemValue(0, 0, "RepaymentName", "<%=RepaymentName%>");
		
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
	
	/*~[Describe=设置首付金额;InputParam=无;OutPutParam=无;]~*/
	function inputPaymentRate(){
		var sCarTotal_ = '0'+getItemValue(0,getRow(),"CarTotal");//车辆总价
		var nLoanTerm = getItemValue(0,getRow(),"Periods");//贷款期限
		var sPaymentRate_ = '0'+getItemValue(0,getRow(),"PaymentRate");//首付比例
		var nMonthRate = ''+getItemValue(0,getRow(),"IntereStrate");//月利率
		var sBusinessSum_ = ''+getItemValue(0,getRow(),"BusinessSum");//贷款金额
		var nMonthPay = 0.0;
		
		var sCarTotal=parseFloat(sCarTotal_);
		var sPaymentRate=parseFloat(sPaymentRate_);
		var sBusinessSum=parseFloat(sBusinessSum_);
		
		if(sCarTotal<0.0){
			alert("车辆总价错误，请检查！");
			return;
		}
		
		if(parseFloat(sPaymentRate)<0.0) {
			alert("请输入大于等于0的首付比例！");
			setItemValue(0,0,"PaymentRate","");
			setItemValue(0,0,"BusinessSum","");
			return;
		}else if(parseFloat(sPaymentRate)>100.0){
			alert("首付比例不能大于100！");
			setItemValue(0,0,"PaymentRate","");
			setItemValue(0,0,"BusinessSum","");
			return;
		}
		
		setItemValue(0, 0, "PaymentSum", (sCarTotal*parseFloat(sPaymentRate)*0.01).toFixed(2));//首付金额
		sBusinessSum =  sCarTotal-(sCarTotal*parseFloat(sPaymentRate)*0.01).toFixed(2);
		setItemValue(0, 0, "BusinessSum", sBusinessSum.toFixed(2));//贷款本金
		
		setItemValue(0,0,"MonthRepayment","");
	}
	
	/*~[Describe=车贷计算每月还款额,贷款本金，车辆总价格联动;InputParam=无;OutPutParam=无;]~*/
	function carGetMonthPayment(){
		var sCarPrice = '0'+getItemValue(0,getRow(),"CarPrice");//车辆出厂价
		var sVehiclePrice = '0'+getItemValue(0,getRow(),"VehiclePrice");//车辆售价
		var sInsuranceSum = '0'+getItemValue(0,getRow(),"InsuranceSum");//保险金额
		var sRevenueTax = '0'+getItemValue(0,getRow(),"RevenueTax");//购置税
		var sAllocationSum = '0'+getItemValue(0,getRow(),"AllocationSum");//附加配置金额
		//var sCarTotal = '0'+getItemValue(0,getRow(),"CarTotal");//车辆总价
		
		if(parseFloat(sVehiclePrice)>parseFloat(sCarPrice)){
			alert("车辆售价不得高于出厂价！");
			return;
		}
		if(parseFloat(sInsuranceSum)>parseFloat(sVehiclePrice)*0.01*7){
			alert("保险金金额不得高于车辆售价的7%！");
			return;
		}
		if(parseFloat(sAllocationSum)>parseFloat(sVehiclePrice)*0.01*8){
			alert("附加配置金额不得高于车辆售价的8%！");
			return;
		}
		if(parseFloat(sRevenueTax)>parseFloat(sVehiclePrice)*0.01*10){
			alert("购置税不得高于车辆售价的8%！");
			return;
		}
		//贷款本金/车辆总价
		var sValue1 = parseFloat(sRevenueTax)+parseFloat(sAllocationSum)+parseFloat(sInsuranceSum)+parseFloat(sVehiclePrice);//车辆总价
		setItemValue(0,getRow(),"CarTotal",sValue1+"");
		var sCarTotal = getItemValue(0,getRow(),"CarTotal");//车辆总价
		
		var sPaymentRate = '0'+getItemValue(0,getRow(),"PaymentRate");//首付比例
		var sPaymentSum = '0'+getItemValue(0,getRow(),"PaymentSum");//首付金额
		if(parseFloat(sCarTotal)>0.0&&parseFloat(sPaymentRate)>0.0){
			inputPaymentRate();
		}
		
		var sBusinessSum = '0'+getItemValue(0,getRow(),"BusinessSum");//贷款本金
		if(parseFloat(parseInt(sBusinessSum,10))<parseFloat(sBusinessSum)){
			alert("贷款本金必须为整数，请检查");
			return;
		}
		
		var sMonthPayment=RunMethod("PublicMethod","GetMonthPayment",sBusinessSum+","+sBusinessType+","+sPeriods+","+YesNo);
		var MonthPaymentBefore = parseFloat(sMonthPayment).toFixed(2);
		var MonthPaymentAfter = fix(MonthPaymentBefore);
		setItemValue(0,getRow(),"MonthRepayment",MonthPaymentAfter+"");
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
				//setItemValue(0,getRow(),"TotalSum2","转化前："+parseFloat(sMonthPayment).toFixed(2)+"");
				var MonthPaymentBefore = parseFloat(sMonthPayment).toFixed(2);
				var MonthPaymentAfter = fix(MonthPaymentBefore);
				//setItemValue(0,getRow(),"BrandType2","转化后："+MonthPaymentAfter+"");
				setItemValue(0,getRow(),"MonthRepayment",MonthPaymentAfter+"");
			
			}
		}
	}
	
	/*~[Describe=小数进位;InputParam=无;OutPutParam=无;]~*/
	function fix(d) {
		var temp = d * 10;
		var value1 = Math.ceil(parseFloat(temp).toFixed(2));//进位取整
		var finalyvalue = parseFloat(value1)/10;
		return finalyvalue;
	}  
	
	/*~[Describe=影像操作;InputParam=无;OutPutParam=无;]~*/
    function imageManage(){
        var sObjectNo   = getItemValue(0,getRow(),"SerialNo");
        if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
            alert(getHtmlMessage('1'));//请选择一条信息！
            return;
        }
	     var param = "ObjectType=Business&TypeNo=20&ObjectNo="+sObjectNo;
	     AsControl.PopView( "/ImageManage/ImageViewNew.jsp", param, "" );
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
