<%@ page contentType="text/html; charset=GBK"%>
<jsp:directive.page import="com.amarsoft.app.als.credit.apply.action.AddOpinionInfo"/>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
	Author:   CChang 2003.8.25
	Tester:
	Content: 签署意见
	Input Param:
		TaskNo：任务流水号
		ObjectNo：对象编号
		ObjectType：对象类型
	Output param:
	History Log: zywei 2005/07/31 重检页面
	*/
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "签署意见";
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%	
	//定义变量
	String sSql = "";
	String sCustomerID = "",sCustomerName = "",sBusinessCurrency = "",sProductVersion="",sLoanRateTermID = "",sRPTTermID = "";
	String sBailCurrency = "",sRateFloatType = "",sBusinessType = "";
	String sApplyType = "",sApproveType = "",sOccurType = "",sBusinessSum = "",sExposureSum = "";
	double dBusinessSum = 0.0,dExposureSum = 0.0,dBaseRate = 0.0,dRateFloat = 0.0,dBusinessRate = 0.0;
	double dBailSum = 0.0,dBailRatio = 0.0,dPdgRatio = 0.0,dPdgSum = 0.0;
	int iTermYear = 0,iTermMonth = 0,iTermDay = 0;
	ASResultSet rs = null;
	
	//获取组件参数：任务流水号、对象编号、对象类型
	String sSerialNo = DataConvert.toRealString(iPostChange,CurComp.getParameter("TaskNo"));
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));
	String sFlowNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("FlowNo"));
	String sPhaseNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("PhaseNo"));
	sApproveType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ApproveType"));

	
	//将空值转化为空字符串
	if(sSerialNo == null) sSerialNo = "";
	if(sObjectNo == null) sObjectNo = "";
	if(sObjectType == null) sObjectType = "";

	//初始化意见
	AddOpinionInfo api = new AddOpinionInfo(sObjectNo,sObjectType,sSerialNo,CurUser);
	String opinionNo = api.transfer(tx);
	tx.commit();
	
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
	<%
	//根据对象类型和对象编号获取流程号
	sSql = 	" select PhaseNo from FLOW_OBJECT "+
			" where ObjectType =:ObjectType "+
			" and ObjectNo =:ObjectNo ";
	sPhaseNo = Sqlca.getString(new SqlObject(sSql).setParameter("ObjectType",sObjectType).setParameter("ObjectNo",sObjectNo));
	if(sPhaseNo == null) sPhaseNo = "";
				
	//根据对象类型和对象编号获取相应的业务信息
	sSql = 	" select CustomerID,CustomerName,BusinessCurrency,BusinessSum,ExposureSum, "+
			" BaseRate,RateFloatType,RateFloat,BusinessRate,BailCurrency, "+
			" BailSum,BailRatio,PdgRatio,PdgSum,BusinessType,TermYear, "+
			" TermMonth,TermDay,OccurType,ApplyType,ProductVersion,LoanRateTermID,RPTTermID "+
			" from BUSINESS_APPLY "+
			" where SerialNo =:SerialNo ";
	rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("SerialNo",sObjectNo));
	if(rs.next()){
		sCustomerID = rs.getString("CustomerID");
		sCustomerName = rs.getString("CustomerName");
		sBusinessCurrency = rs.getString("BusinessCurrency");
		dBusinessSum = rs.getDouble("BusinessSum");
		dExposureSum = rs.getDouble("ExposureSum");
		dBaseRate = rs.getDouble("BaseRate");
		sRateFloatType = rs.getString("RateFloatType");
		dRateFloat = rs.getDouble("RateFloat");
		dBusinessRate = rs.getDouble("BusinessRate");
		sBailCurrency = rs.getString("BailCurrency");
		dBailSum = rs.getDouble("BailSum");
		dBailRatio = rs.getDouble("BailRatio");
		dPdgRatio = rs.getDouble("PdgRatio");
		dPdgSum = rs.getDouble("PdgSum");
		sBusinessType = rs.getString("BusinessType");
		iTermYear = rs.getInt("TermYear");
		iTermMonth = rs.getInt("TermMonth");
		iTermDay = rs.getInt("TermDay");
		sOccurType = rs.getString("OccurType");
		sApplyType = rs.getString("ApplyType");
		sProductVersion = rs.getString("ProductVersion");
		sLoanRateTermID = rs.getString("LoanRateTermID");
		sRPTTermID = rs.getString("RPTTermID");
		
		//将空值转化为空字符串
		if(sCustomerID == null) sCustomerID = "";
		if(sCustomerName == null) sCustomerName = "";
		if(sBusinessCurrency == null) sBusinessCurrency = "";
		if(sRateFloatType == null) sRateFloatType = "";
		if(sBailCurrency == null) sBailCurrency = "";
		if(sBusinessType == null) sBusinessType = "";
		if(sOccurType == null) sOccurType = "";
		if(sLoanRateTermID == null) sLoanRateTermID = "";
		if(sRPTTermID == null) sRPTTermID = "";
	}
	rs.getStatement().close();
	
	String sHeaders[][]={                       
	                        {"CustomerID","客户编号"},
	                        {"CustomerName","客户名称"},
	                        {"BusinessCurrency","业务币种"},
	                        {"BusinessSum","名义金额"},
	                        {"ExposureSum","敞口金额"},
	                        {"TermMonth","期限"},
	                        {"TermDay","零"},
	                        {"BaseRate","基准年利率(%)"},
	                        {"RateFloatType","利率浮动方式"},
	                        {"RateFloat","利率浮动值"},
	                        {"BusinessRate","执行月利率(‰)"},
	                        {"LoanRateTermID","利率信息"},
	                        {"RPTTermID","还款方式"},
	                        {"BailCurrency","保证金币种"},
	                        {"BailSum","保证金金额"},
	                        {"BailRatio","保证金比例(%)"},	                        
	                        {"PdgRatio","手续费率(‰)"},
	                        {"PdgSum","手续费金额(元)"},
	                        {"PhaseOpinion","意见"},
	                        {"InputOrgName","登记机构"}, 
	                        {"InputUserName","登记人"}, 
	                        {"InputTime","登记日期"}                      
                        };                    
	String sHeaders1[][]={                       
	                        {"CustomerID","客户编号"},
	                        {"CustomerName","客户名称"},
	                        {"BusinessCurrency","业务币种"},
	                        {"BusinessSum","名义金额"},
	                        {"ExposureSum","敞口金额"},
	                        {"TermMonth","期限"},
	                        {"TermDay","零"},
	                        {"BaseRate","基准年利率(%)"},
	                      //核算添加或修改-start
		                      {"LoanRateTermID","利率信息"},
		                        {"RPTTermID","还款方式"},
		                      //核算添加或修改-end
	                        {"RateFloatType","利率浮动方式"},
	                        {"RateFloat","利率浮动值"},
	                        {"BusinessRate","执行月利率(‰)"},
	                        {"BailCurrency","保证金币种"},
	                        {"BailSum","保证金金额"},
	                        {"BailRatio","保证金比例(%)"},	                        
	                        {"PdgRatio","手续费率(‰)"},
	                        {"PdgSum","手续费金额(元)"},
	                        {"PhaseOpinion","意见"},
	                        {"InputOrgName","登记机构"}, 
	                        {"InputUserName","登记人"}, 
	                        {"InputTime","登记日期"}                      
                        }; 	
    String sHeaders2[][]={                       
	                        {"CustomerID","客户编号"},
	                        {"CustomerName","客户名称"},
	                        {"BusinessCurrency","展期币种"},
	                        {"BusinessSum","展期金额"},
	                        {"TermMonth","展期期限"},
	                        {"TermDay","零"},
	                        {"BaseRate","基准年利率(%)"},
	                        {"RateFloatType","利率浮动方式"},
	                        {"RateFloat","利率浮动值"},
	                        {"BusinessRate","展期执行月利率(‰)"},
	                      //核算添加或修改-start
		                    {"LoanRateTermID","利率信息"},
		                    {"RPTTermID","还款方式"},
		                      //核算添加或修改-end
	                        {"BailCurrency","保证金币种"},
	                        {"BailSum","保证金金额"},
	                        {"BailRatio","保证金比例(%)"},	                        
	                        {"PdgRatio","手续费率(‰)"},
	                        {"PdgSum","手续费金额(元)"},
	                        {"PhaseOpinion","意见"},
	                        {"InputOrgName","登记机构"}, 
	                        {"InputUserName","登记人"}, 
	                        {"InputTime","登记日期"}                      
                        }; 	
    String sHeaders3[][]={                       
	                        {"PhaseOpinion","意见"},
	                        {"InputOrgName","登记机构"}, 
	                        {"InputUserName","登记人"}, 
	                        {"InputTime","登记日期"}                      
                        };  
	//定义SQL语句
	sSql = 	" select SerialNo,OpinionNo,ObjectType,ObjectNo,CustomerID, "+
			" CustomerName,BusinessCurrency,BusinessSum,ExposureSum,TermYear,TermMonth, "+
			" TermDay,BaseRate,RateFloatType,RateFloat,BusinessRate,LoanRateTermID,RPTTermID,BailCurrency, "+
			" BailSum,BailRatio,PdgRatio,PdgSum,PhaseOpinion,InputOrg, "+
			" getOrgName(InputOrg) as InputOrgName,InputUser, "+
			" getUserName(InputUser) as InputUserName,InputTime, "+
			" UpdateUser,UpdateTime "+
			" from FLOW_OPINION " +
			" where SerialNo='"+sSerialNo+"' ";

	//通过SQL参数产生ASDataObject对象doTemp
	ASDataObject doTemp = new ASDataObject(sSql);
	
	//定义列表表头	
	if(sPhaseNo.equals("0010") || sPhaseNo.equals("3000")) //申请初始阶段和发回补充资料阶段
	{
		doTemp.setHeader(sHeaders3); 
	}else
	{
		if(sOccurType.equals("015"))//发生类型为展期
		{
			doTemp.setHeader(sHeaders2); 
		}else
		{
			
			//业务品种为商业承兑汇票贴现、协议付息票据贴现、个人经营循环贷款、个人质押贷款、
			//个人保证贷款、个人抵押贷款、个人营运汽车贷款、个人消费汽车贷款、商业助学贷款、
			//国家助学贷款、银行承兑汇票贴现、个人住房装修贷款、个人付款保函、个人经营贷款、
			//个人抵押循环贷款、个人小额信用贷款、个人自助质押贷款、个人再交易商业用房贷款、
			//个人商业用房按贷款、个人再交易住房贷款、个人住房贷款、买入返售业务、个人委托贷款
			//是执行月利率
			if(sBusinessType.equals("1020020") || sBusinessType.equals("1020030")
			 || sBusinessType.equals("1110080") || sBusinessType.equals("1110090")
			 || sBusinessType.equals("1110100") || sBusinessType.equals("1110110")
			 || sBusinessType.equals("1110120") || sBusinessType.equals("1110130")
			 || sBusinessType.equals("1110140") || sBusinessType.equals("1110150")
			 || sBusinessType.equals("1020010") || sBusinessType.equals("1110160")	 
			 || sBusinessType.equals("1110200") || sBusinessType.equals("1110170")
			 || sBusinessType.equals("1110070") || sBusinessType.equals("1110060")
			 || sBusinessType.equals("1110050") || sBusinessType.equals("1110040")
			 || sBusinessType.equals("1110030") || sBusinessType.equals("1110020")
			 || sBusinessType.equals("1110010") || sBusinessType.equals("2100")
			 || sBusinessType.equals("1110190")){
				doTemp.setHeader(sHeaders1); 
			}else{ //反之执行年利率
				doTemp.setHeader(sHeaders);
			}
			//非额度申请,隐藏敞口金额字段,并将BusinessSum列名更新为申请金额
			if(!"CreditLineApply".equals(sApplyType)){
				doTemp.setVisible("ExposureSum",false);
				doTemp.setHeader("BusinessSum","申请金额");
			}
			else
			{
				doTemp.setVisible("ExposureSum",true);
				doTemp.setRequired("ExposureSum",true);
			}
		}
		doTemp.setReadOnly("LoanRateTermID", true); //by qzhang1 20131203
		doTemp.setReadOnly("RPTTermID",true);
	}
	
	//对表进行更新、插入、删除操作时需要定义表对象、主键   
	doTemp.UpdateTable = "FLOW_OPINION";
	doTemp.setKey("SerialNo,OpinionNo",true);		
	doTemp.setUnit("TermMonth","月");
	doTemp.setUnit("TermDay","天");
	doTemp.setVisible("BaseRate,RateFloatType,RateFloat,BusinessRate,PdgRatio,PdgSum",false);
	//设置字段是否可见和必输项	
	if(sPhaseNo.equals("0010") || sPhaseNo.equals("3000")) //申请初始阶段和发回补充资料阶段
	{
		doTemp.setVisible("CustomerName,BusinessCurrency,BusinessSum,ExposureSum,BusinessRate,TermMonth,TermDay,BaseRate,RateFloatType,RateFloat,BailSum,BailRatio,PdgRatio,PdgSum",false);
		doTemp.setRequired("PhaseOpinion",true);
	}else
	{
		if(sOccurType.equals("015"))//发生类型为展期
		{
			doTemp.setVisible("BailSum,BailRatio,PdgRatio,PdgSum",false);
			doTemp.setRequired("BusinessCurrency,BusinessSum,TermMonth,PhaseOpinion",true);
			doTemp.setReadOnly("BusinessSum",true);
			doTemp.setHTMLStyle("BaseRate,RateFloatType,RateFloat"," onchange=parent.getBusinessRate(\\'Y\\') ");	
		}else if(sBusinessType.length()>1 && "2".equals(sBusinessType.substring(0,1))){//增加对表外业务控制
			doTemp.setVisible("BaseRate,RateFloatType,RateFloat,BusinessRate",false);
			doTemp.setRequired("BusinessCurrency,BusinessSum,TermMonth,PdgRatio,PdgSum,PhaseOpinion,BailSum,BailRatio",true);	
			doTemp.setHTMLStyle("PdgRatio"," onchange=parent.getpdgsum() ");
			doTemp.setHTMLStyle("PdgSum"," onchange=parent.getPdgRatio() ");
			doTemp.setHTMLStyle("BailRatio"," onchange=parent.getBailSum() ");
			doTemp.setHTMLStyle("BailSum"," onchange=parent.getBailRatio() ");
		}else{
			//业务品种为个人付款保函、发行债券转贷款、个人委托贷款、国家外汇储备转贷款、其他转贷款、
			//转贷国际金融组织贷款、转贷买方信贷、转贷外国政府贷款
			if(sBusinessType.equals("1110200") || sBusinessType.equals("2060050")
			 || sBusinessType.equals("1110190") || sBusinessType.equals("2060030")
			 || sBusinessType.equals("2060060") || sBusinessType.equals("2060020")
			 || sBusinessType.equals("2060040") || sBusinessType.equals("2060010"))  
			{
				doTemp.setVisible("BailSum,BailRatio",false);	
				doTemp.setRequired("BusinessCurrency,BusinessSum,TermMonth,PdgRatio,PdgSum,PhaseOpinion",true);
				if(sBusinessType.equals("1110200") || sBusinessType.equals("1110190"))
					doTemp.setHTMLStyle("BaseRate,RateFloatType,RateFloat"," onchange=parent.getBusinessRate(\\'M\\') ");
				else
					doTemp.setHTMLStyle("BaseRate,RateFloatType,RateFloat"," onchange=parent.getBusinessRate(\\'Y\\') ");
				doTemp.setHTMLStyle("PdgRatio"," onchange=parent.getpdgsum() ");
				doTemp.setHTMLStyle("PdgSum"," onchange=parent.getPdgRatio() ");	
			}
			//业务品种为备用信用证、补偿贸易保函（融资类）、补偿贸易保函（非融资类）、承包工程保函
			//贷款承诺函、贷款担保、贷款意向书、付款保函、关税保付保函、国内信用证、
			//海事保函、加工装配业务进口保函、借款偿还保函、进口信用证、留置金保函、履约保函、
			//其他非融资性保函、其他融资性保函、诉讼保函、提货担保、投标保函、透支归还保函、
			//银行承兑汇票、银行信贷证明、有价证券发行担保、预付款保函、质量维修保函、租金偿还保函
			else if(sBusinessType.equals("1080007") || sBusinessType.equals("2030050")
			 || sBusinessType.equals("2040070") || sBusinessType.equals("2040040")
			 || sBusinessType.equals("2080010") || sBusinessType.equals("2090010")
			 || sBusinessType.equals("2080020")
			 || sBusinessType.equals("2030060") || sBusinessType.equals("2030040")
			 || sBusinessType.equals("1090010") || sBusinessType.equals("2040060")
			 || sBusinessType.equals("2040100") || sBusinessType.equals("2030010")	 
			 || sBusinessType.equals("1080005") || sBusinessType.equals("2040090")
			 || sBusinessType.equals("2040020") || sBusinessType.equals("2040110")
			 || sBusinessType.equals("2030070") || sBusinessType.equals("2040080")
			 || sBusinessType.equals("1080410") || sBusinessType.equals("2040010")	 
			 || sBusinessType.equals("2030030") || sBusinessType.equals("2010")
			 || sBusinessType.equals("2080030") || sBusinessType.equals("2090020")
			 || sBusinessType.equals("2040030") || sBusinessType.equals("2040050")
			 || sBusinessType.equals("2030020"))  
			{
				doTemp.setVisible("BaseRate,RateFloatType,RateFloat,BusinessRate",false);
				doTemp.setRequired("BusinessCurrency,BusinessSum,TermMonth,BailSum,BailRatio,PdgRatio,PdgSum,PhaseOpinion",true);	
				doTemp.setHTMLStyle("PdgRatio"," onchange=parent.getpdgsum() ");
				doTemp.setHTMLStyle("PdgSum"," onchange=parent.getPdgRatio() ");
				doTemp.setHTMLStyle("BailRatio"," onchange=parent.getBailSum() ");
				doTemp.setHTMLStyle("BailSum"," onchange=parent.getBailRatio() ");
			}
			//业务品种为个贷其它合作商、个人房屋贷款合作项目、汽车消费贷款合作经销商	
			else if(sBusinessType.equals("3030030") || sBusinessType.equals("3030010")
			 || sBusinessType.equals("3030020")) 
			{
				doTemp.setVisible("BaseRate,RateFloatType,RateFloat,BusinessRate,PdgRatio,PdgSum",false);
				doTemp.setRequired("BusinessCurrency,BusinessSum,TermMonth,BailSum,BailRatio,PhaseOpinion",true);	
				doTemp.setHTMLStyle("BailRatio"," onchange=parent.getBailSum() ");
				doTemp.setHTMLStyle("BailSum"," onchange=parent.getBailRatio() ");
			}	
			//业务品种为个人经营贷款、国家助学贷款、商业助学贷款
			else if(sBusinessType.equals("1110170") || sBusinessType.equals("1110150")
			 || sBusinessType.equals("1110140"))
			{
				doTemp.setVisible("PdgRatio,PdgSum",false);
				doTemp.setRequired("BusinessCurrency,BusinessSum,TermMonth,BailSum,BailRatio,PhaseOpinion",true);	
				doTemp.setHTMLStyle("BaseRate,RateFloatType,RateFloat"," onchange=parent.getBusinessRate(\\'M\\') ");
				doTemp.setHTMLStyle("BailRatio"," onchange=parent.getBailSum() ");
				doTemp.setHTMLStyle("BailSum"," onchange=parent.getBailRatio() ");
			}	
			else if(sBusinessType.equals("1110180"))  //业务品种为个人住房公积金贷款
			{
				doTemp.setVisible("RateFloatType,RateFloat,BusinessRate,PdgRatio,PdgSum",false);	
				doTemp.setRequired("BusinessCurrency,BusinessSum,TermMonth,BailSum,BailRatio,PhaseOpinion",true);	
				doTemp.setHTMLStyle("BailRatio"," onchange=parent.getBailSum() ");
				doTemp.setHTMLStyle("BailSum"," onchange=parent.getBailRatio() ");
			}
			else if(sBusinessType.equals("2070"))  //业务品种为委托贷款
			{
				doTemp.setVisible("BailSum,BailRatio,PdgSum",false);
				doTemp.setRequired("BusinessCurrency,BusinessSum,TermMonth,PdgRatio,PhaseOpinion",true);	
				doTemp.setHTMLStyle("BaseRate,RateFloatType,RateFloat"," onchange=parent.getBusinessRate(\\'Y\\') ");
			}
			else //反之
			{
				if(sBusinessType.startsWith("3") || sBusinessType.startsWith("20"))//授信额度业务、表外业务
					doTemp.setVisible("BusinessRate,BailSum,BailRatio,PdgRatio,PdgSum,BaseRate,RateFloatType,RateFloat",false);
				else
					doTemp.setVisible("BailSum,BailRatio,PdgRatio,PdgSum",false);
				/************add by hwang 增加对贴现业务处理*************/
				//贴现业务没有期限，隐藏期限		商业承兑汇票贴现、协议付息票据贴现、银行承兑汇票贴现、信用证项下出口押汇、托收项下出口押汇
				if(sBusinessType.equals("1020020") || sBusinessType.equals("1020030")
				 || sBusinessType.equals("1020010")	|| sBusinessType.equals("1080040")
				 || sBusinessType.equals("1080030") ){
					doTemp.setVisible("TermMonth,TermDay",false);
					doTemp.setRequired("BusinessCurrency,BusinessSum,PhaseOpinion",true);
				}else{
					doTemp.setRequired("BusinessCurrency,BusinessSum,TermMonth,PhaseOpinion",true);
				}
				//业务品种为商业承兑汇票贴现、协议付息票据贴现、银行承兑汇票贴现、买入返售业务、
				//个人住房贷款、个人再交易住房贷款、个人商业用房按贷款、个人再交易商业用房贷款、
				//个人自助质押贷款、个人小额信用贷款、个人抵押循环贷款、个人经营循环贷款、
				//个人质押贷款、个人保证贷款、个人抵押贷款、个人营运汽车贷款、个人消费汽车贷款
				//个人住房装修贷款是执行月利率
				if(sBusinessType.equals("1020020") || sBusinessType.equals("1020030")
				 || sBusinessType.equals("1020010")	|| sBusinessType.equals("2100")
				 || sBusinessType.equals("1110010") || sBusinessType.equals("1110020")
				 || sBusinessType.equals("1110030") || sBusinessType.equals("1110040")
				 || sBusinessType.equals("1110050") || sBusinessType.equals("1110060")
				 || sBusinessType.equals("1110070") || sBusinessType.equals("1110080")
				 || sBusinessType.equals("1110090") || sBusinessType.equals("1110100") 
				 || sBusinessType.equals("1110110") || sBusinessType.equals("1110120") 
				 || sBusinessType.equals("1110130") || sBusinessType.equals("1110160"))
					doTemp.setHTMLStyle("BaseRate,RateFloatType,RateFloat"," onchange=parent.getBusinessRate(\\'M\\') ");
				else//反之执行年利率
					doTemp.setHTMLStyle("BaseRate,RateFloatType,RateFloat"," onchange=parent.getBusinessRate(\\'Y\\') ");	
			}	
		}
	}
	
	doTemp.setVisible("SerialNo,OpinionNo,ObjectType,ObjectNo,CustomerID,TermYear,BailCurrency,InputOrg,InputUser,UpdateUser,UpdateTime",false);		
	//设置不可更新字段
	doTemp.setUpdateable("InputOrgName,InputUserName",false);
	//设置下拉框内容
	doTemp.setDDDWCode("BusinessCurrency,BailCurrency","Currency");
	doTemp.setDDDWCode("RateFloatType","RateFloatType");
	//设置只读属性
	doTemp.setReadOnly("CustomerName,BusinessRate,InputOrgName,InputUserName,InputTime,PdgSum",true);
	//编辑形式为备注栏
	doTemp.setEditStyle("PhaseOpinion","3");
	//限制评定原因的输入字数 // add by cbsu 2009-11-06
    doTemp.setLimit("PhaseOpinion",400);
	//设置字段格式
	doTemp.setType("BusinessSum,ExposureSum,BaseRate,RateFloat,BusinessRate,BailSum,BailRatio,PdgRatio,PdgSum","Number");
	doTemp.setCheckFormat("BusinessSum,ExposureSum,BaseRate,RateFloat,BusinessRate,BailSum,BailRatio,PdgRatio,PdgSum","2");
	doTemp.setAlign("BusinessSum,ExposureSum,BaseRate,RateFloat,BusinessRate,BailSum,BailRatio,PdgRatio,PdgSum","3");	
	doTemp.setType("TermMonth,TermDay","Number");
	doTemp.setCheckFormat("TermMonth,TermDay","5");
	doTemp.setAlign("TermMonth,TermDay","3");
	//设置html格式
	doTemp.setHTMLStyle("PhaseOpinion"," style={height:100px;width:30%;overflow:auto;font-size:9pt;} ");
	doTemp.appendHTMLStyle("BailRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"保证金比例必须大于等于0,小于等于100！\" ");
	doTemp.appendHTMLStyle("PdgRatio"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=1000 \" mymsg=\"手续费率必须大于等于0,小于等于1000！\" ");
	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"基准年利率必须大于等于0,小于等于100！\" ");
	doTemp.appendHTMLStyle("RateFloat"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"利率浮动值必须大于等于0,小于等于100！\" ");
	doTemp.setHTMLStyle("TermDay"," onchange=parent.getTermDay() ");	
	doTemp.setReadOnly("BailSum",true);
	
	
	/*--------------------------以下核算功能增加代码-----------------*/
	doTemp.setDDDWSql("LoanRateTermID","select termid,termname from product_term_library where termtype = 'RAT' and objecttype='Product' and objectno='"+sBusinessType+"-"+sProductVersion+"' and status='1' order by TermID desc ");
	doTemp.setDDDWSql("RPTTermID","select termid,termname from product_term_library where termtype='RPT' and objecttype='Product' and objectno='"+sBusinessType+"-"+sProductVersion+"' and status='1'");
	doTemp.setEditStyle("LoanRateTermID,RPTTermID","5");
	doTemp.setHTMLStyle("LoanRateTermID"," onchange=parent.calcLoanRateTermID(\""+BUSINESSOBJECT_CONSTATNTS.flow_opinion+"\",\""+opinionNo+"\") ");
	doTemp.setHTMLStyle("RPTTermID"," onchange=parent.calcRPTTermID(\""+BUSINESSOBJECT_CONSTATNTS.flow_opinion+"\",\""+opinionNo+"\") ");
	StringBuilder sDockOptions = (new StringBuilder()).append("DockID=RatePart").append(";ColSpan=;PositionType=;BlankColsAhead=;BlankColsAfter=");
    doTemp.setColumnAttribute("LoanRateTermID", "DockOptions", sDockOptions.toString());
    sDockOptions = (new StringBuilder()).append("DockID=RPTPart").append(";ColSpan=;PositionType=;BlankColsAhead=;BlankColsAfter=");
    doTemp.setColumnAttribute("RPTTermID", "DockOptions", sDockOptions.toString());
    sDockOptions = (new StringBuilder()).append("DockID=UserPart").append(";ColSpan=;PositionType=;BlankColsAhead=;BlankColsAfter=");
    doTemp.setColumnAttribute("InputOrgName,InputUserName,InputTime,UpdateUser,UpdateTime", "DockOptions", sDockOptions.toString());
	/*--------------------------以下核算功能增加代码-----------------*/
	
	String bVisibleFlag = doTemp.getColumnAttribute("BusinessSum","Visible");
	if(bVisibleFlag!=null && bVisibleFlag.equals("1")){ //可见
		//转化金额的显示格式		
		if(dBusinessSum > 0) {
			sBusinessSum = DataConvert.toMoney(dBusinessSum);
			sExposureSum = DataConvert.toMoney(dExposureSum);
		}
	}
	
	//生成ASDataWindow对象		
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);	
	dwTemp.Style="2";//freeform形式
	
	dwTemp.setHarborTemplate(DWExtendedFunctions.getDWDockHTMLTemplate(Sqlca.getString("select ApplyDetailNo from BUSINESS_TYPE where TypeNo = '"+sBusinessType+"' "),"DockID IN('FEEPart','FINPart','RPTPart','RatePart','SPTPart','UserPart')",Sqlca));
	
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	
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
			{"true","","Button","保存","保存所有修改","saveRecord()",sResourcesPath},
			{"true","","Button","删除","删除意见","deleteRecord()",sResourcesPath},
			{"true","","Button","提交","提交任务","commitTask()",sResourcesPath},
		};
	%> 
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=Info05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/Info05.jsp"%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script type="text/javascript">
	function commitTask()
	{
		//获得申请类型、申请流水号、阶段编号
		var sObjectType = "<%=sObjectType%>";
		var sObjectNo = "<%=sObjectNo%>";
		var sPhaseNo = "<%=sPhaseNo%>";
		var sUserID = "<%=CurUser.getUserID()%>";
		var sFlowNo = "<%=sFlowNo%>";
		
		//获得任务流水号
		var sSerialNo = "<%=sSerialNo%>";
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert(getHtmlMessage('1'));//请选择一条信息！ 
			return;
		}
		
		//检查该业务是否已经提交了（解决用户打开多个界面进行重复操作而产生的错误）
		var sEndTime=RunMethod("WorkFlowEngine","GetEndTime",sSerialNo);
		if(typeof(sEndTime)=="undefined" || sEndTime.trim().length >0) {
			alert("该业务这阶段审批已经提交，不能再次提交！");//该业务这阶段审批已经提交，不能再次提交！
			reloadSelf();
			return;
		}
				

		//弹出审批提交选择窗口	     增加参数传递，防止重复提交 by yzheng,qxu 2013/6/28	
		//var sPhaseInfo = PopPage("/Common/WorkFlow/SubmitDialog.jsp?SerialNo="+sSerialNo+"&objectType="+sObjectType+"&objectNo="+sObjectNo+"&oldPhaseNo="+sPhaseNo,"","dialogWidth=580px;dialogHeight=420px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		var sPhaseInfo = RunJavaMethodSqlca("com.amarsoft.biz.workflow.action.FlowAction","AutoCommit","SerialNo="+sSerialNo+",objectType="+sObjectType+",objectNo="+sObjectNo+",oldPhaseNo="+sPhaseNo+",userID="+sUserID);
		if(typeof(sPhaseInfo)=="undefined" || sPhaseInfo=="" || sPhaseInfo==null || sPhaseInfo=="null" || sPhaseInfo=="_CANCEL_") return;
		else if (sPhaseInfo == "Success"){
			//alert(getHtmlMessage('18'));//提交成功！	// comment by tbzeng 2014/05/03 取消提交时弹出的提示提交成功消息框
			//top.close();
			
			var sSerialNo = RunJavaMethodSqlca("com.amarsoft.biz.workflow.action.FlowAction","getSerialNo","objectNo="+sObjectNo+",objectType="+sObjectType);
			var sPhaseNo = RunJavaMethodSqlca("com.amarsoft.biz.workflow.action.FlowAction","getPhaseNo","objectNo="+sObjectNo+",objectType="+sObjectType);
			
			var sCompID = "CheckOpinionTab";
			var sCompURL = "/Common/WorkFlow/CheckOpinionTab.jsp";
			OpenComp(sCompID,sCompURL,"ObjectType="+sObjectType+"&ObjectNo="+sObjectNo+"&TaskNo="+sSerialNo+"&FlowNo="+sFlowNo+"&PhaseNo="+sPhaseNo,"_blank",OpenStyle);



			//刷新件数及页面
		}else if (sPhaseInfo == "Failure"){
			alert(getHtmlMessage('9'));//提交失败！
			return;
		}else if (sPhaseInfo == "Working"){//by yzheng,qxu 2013/6/28
			alert(getBusinessMessage('486'));//该申请已经提交了，不能再次提交！
			reloadSelf();
			return;
		}else{
			sPhaseInfo = PopPage("/Common/WorkFlow/SubmitDialogSecond.jsp?SerialNo="+sSerialNo+"&PhaseOpinion1="+sPhaseInfo,"","dialogWidth=34;dialogHeight=22;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
			//如果提交成功，则刷新页面
			if (sPhaseInfo == "Success"){
				alert(getHtmlMessage('18'));//提交成功！
				//刷新件数及页面
				}else if (sPhaseInfo == "Failure"){
				alert(getHtmlMessage('9'));//提交失败！
				return;
			}
		}
	}
	
	
	/*~[Describe=保存签署的意见;InputParam=无;OutPutParam=无;]~*/
	function saveRecord()
	{
		sOpinionNo = getItemValue(0,getRow(),"OpinionNo");		
		if (typeof(sOpinionNo)=="undefined" || sOpinionNo.length==0)
		{
			initOpinionNo();
		}
		//审批金额，审批期限不能为0
		dBusinessSum = getItemValue(0,getRow(),"BusinessSum");
		var dExposureSum = getItemValue(0,getRow(),"ExposureSum");
		iTermMonth = getItemValue(0,getRow(),"TermMonth");
		sBusinessType = "<%=sBusinessType%>";
		if("<%=sPhaseNo%>"!="0010"&&"<%=sPhaseNo%>"!="3000")
		{
			//贴现业务没有期限概念，另行处理。商业承兑汇票贴现、协议付息票据贴现、银行承兑汇票贴现、信用证项下出口押汇、托收项下出口押汇
			if(sBusinessType == "1020020" || sBusinessType=="1020030"  || sBusinessType=="1020010"	|| sBusinessType=="1080040"	 || sBusinessType=="1080030" ){
				if(dBusinessSum<=0)
				{
					alert("审批金额必须大于0！");
					return;
				}
			}else{//非贴现业务
				if(dBusinessSum<=0 || iTermMonth<=0)
				{
					alert(getBusinessMessage('679'));//审批金额，审批期限不能为0！
					//alert("审批期限和审批金额必须大于0！");
					return;
				}
			}
			if (dBusinessSum > "<%=sBusinessSum%>" || dExposureSum > "<%=sExposureSum%>") {
			    alert("审批金额不能大于申请金额！");
			    return;
			}
			
		}
		//不允许签署的意见为空白字符
		if(/^\s*$/.exec(getItemValue(0,0,"PhaseOpinion"))){
			alert("请签署意见！");
			setItemValue(0,0,"PhaseOpinion","");
			return;
		}
		saveSubItem();
		setItemValue(0,0,"UpdateUser","<%=CurUser.getUserID()%>");
        setItemValue(0,0,"UpdateTime","<%=StringFunction.getToday()%>");
		as_save("myiframe0","afterLoad('<%=BUSINESSOBJECT_CONSTATNTS.flow_opinion%>','<%=opinionNo%>')");
	}
	
	/*~[Describe=删除已删除意见;InputParam=无;OutPutParam=无;]~*/
    function deleteRecord()
    {
	    sSerialNo=getItemValue(0,getRow(),"SerialNo");
	    sOpinionNo = getItemValue(0,getRow(),"OpinionNo");
	    
	    if (typeof(sOpinionNo)=="undefined" || sOpinionNo.length==0){
	   		alert("您还没有签署意见，不能做删除意见操作！");
	 	}
	 	else if(confirm("你确实要删除意见吗？"))
	 	{
	   		sReturn= RunMethod("BusinessManage","DeleteSignOpinion",sSerialNo+","+sOpinionNo);
	   		if (sReturn==1)
	   		{
	    		alert("意见删除成功!");
	  		}
	   		else
	   		{
	    		alert("意见删除失败！");
	   		}
			reloadSelf();
		}
	} 
	
	function getTermDay()
	{
		sBusinessType = "<%=sBusinessType%>";
	    dTermDay = getItemValue(0,getRow(),"TermDay");
	    if(parseInt(dTermDay) > 30 || parseInt(dTermDay) < 0)
	    {
	    	if(!(sBusinessType=="1080005") || !(sBusinessType=="1090010"))
	        alert("“零”天数必须大于等于0,小于等于30！");
	    }
	}
	/*~[Describe=初始化流水号字段;InputParam=无;OutPutParam=无;]~*/
	function initOpinionNo() 
	{
		/** --update Object_Maxsn取号优化 tangyb 20150817 start-- 
		var sTableName = "FLOW_OPINION";//表名
		var sColumnName = "OpinionNo";//字段名
		var sPrefix = "";//无前缀
		//获取流水号
		var sOpinionNo = getSerialNo(sTableName,sColumnName,sPrefix);*/
		var sOpinionNo = '<%=DBKeyUtils.getSerialNo("FO")%>';
		/** --end --*/
		
		//将流水号置入对应字段
		setItemValue(0,getRow(),"OpinionNo",sOpinionNo);
	}
	
	/*~[Describe=插入一条新记录;InputParam=无;OutPutParam=无;]~*/
	function initRow()
	{
		//如果没有找到对应记录，则新增一条，并可以设置字段默认值
		if (getRowCount(0)==0) 
		{
			as_add("myiframe0");//新增记录
			setItemValue(0,getRow(),"SerialNo","<%=sSerialNo%>");
			setItemValue(0,getRow(),"ObjectType","<%=sObjectType%>");
			setItemValue(0,getRow(),"ObjectNo","<%=sObjectNo%>");
			setItemValue(0,getRow(),"CustomerID","<%=sCustomerID%>");
			setItemValue(0,getRow(),"CustomerName","<%=sCustomerName%>");
			setItemValue(0,getRow(),"BusinessCurrency","<%=sBusinessCurrency%>");
			setItemValue(0,getRow(),"BusinessSum","<%=sBusinessSum%>");
			setItemValue(0,getRow(),"ExposureSum","<%=sExposureSum%>");
			setItemValue(0,getRow(),"TermMonth","<%=iTermMonth%>");
			setItemValue(0,getRow(),"TermDay","<%=iTermDay%>");
			setItemValue(0,getRow(),"BaseRate","<%=DataConvert.toMoney(dBaseRate)%>");
			setItemValue(0,getRow(),"RateFloatType","<%=sRateFloatType%>");
			setItemValue(0,getRow(),"RateFloat","<%=DataConvert.toMoney(dRateFloat)%>");
			setItemValue(0,getRow(),"BusinessRate","<%=dBusinessRate%>");
			setItemValue(0,getRow(),"BailCurrency","<%=sBailCurrency%>");
			setItemValue(0,getRow(),"BailRatio","<%=dBailRatio%>");
			setItemValue(0,getRow(),"BailSum","<%= DataConvert.toMoney(dBailSum)%>");
			setItemValue(0,getRow(),"PdgRatio","<%=dPdgRatio%>");
			setItemValue(0,getRow(),"PdgSum","<%=DataConvert.toMoney(dPdgSum)%>");
			setItemValue(0,getRow(),"InputOrgName","<%=CurOrg.getOrgName()%>");
			setItemValue(0,getRow(),"InputOrg","<%=CurOrg.getOrgID()%>");
			setItemValue(0,getRow(),"InputUserName","<%=CurUser.getUserName()%>");
			setItemValue(0,getRow(),"InputTime","<%=StringFunction.getToday()%>");			
			setItemValue(0,getRow(),"LoanRateTermID","<%=sLoanRateTermID%>");
			setItemValue(0,getRow(),"RPTTermID","<%=sRPTTermID%>");
		}        
	}
	
	/*~[Describe=根据基准利率、利率浮动方式、利率浮动值计算执行年(月)利率;InputParam=无;OutPutParam=无;]~*/
	function getBusinessRate(sFlag)
	{		
		//基准利率
		dBaseRate = getItemValue(0,getRow(),"BaseRate");
		//利率浮动方式
		sRateFloatType = getItemValue(0,getRow(),"RateFloatType");
		//利率浮动值
		dRateFloat = getItemValue(0,getRow(),"RateFloat");		
		if(typeof(sRateFloatType) != "undefined" && sRateFloatType != "" 
		&& parseFloat(dBaseRate) >= 0 && parseFloat(dRateFloat) >= 0)
		{					
			if(sRateFloatType=="0")	//浮动百分比
			{	
				if(sFlag == 'Y') //执行年利率
					dBusinessRate = parseFloat(dBaseRate) * (1 + parseFloat(dRateFloat)/100 );
				if(sFlag == 'M') //执行月利率
					dBusinessRate = parseFloat(dBaseRate) * (1 + parseFloat(dRateFloat)/100 ) / 1.2;
			}else	//1:浮动点数
			{
				if(sFlag == 'Y') //执行年利率
					dBusinessRate = parseFloat(dBaseRate) + parseFloat(dRateFloat);
				if(sFlag == 'M') //执行月利率
					//dBusinessRate = (parseFloat(dBaseRate) + parseFloat(dRateFloat)) / 1.2;
					dBusinessRate = parseFloat(dBaseRate)/1.2 + parseFloat(dRateFloat); // 修改执行月利率的计算公式 add by cbsu 2009-10-22
			}
			
			dBusinessRate = roundOff(dBusinessRate,6);
			setItemValue(0,getRow(),"BusinessRate",dBusinessRate);			
		}else
		{
			setItemValue(0,getRow(),"BusinessRate","");
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
	   // sBusinessCurrency = getItemValue(0,getRow(),"BusinessCurrency");
	   // sBailCurrency = getItemValue(0,getRow(),"BailCurrency");
		//if (sBusinessCurrency != sBailCurrency)
		//	return;
	    dBusinessSum = getItemValue(0,getRow(),"BusinessSum");
	    if(parseFloat(dBusinessSum) >= 0)
	    {
	        dPdgSum = getItemValue(0,getRow(),"PdgSum");
	        dPdgSum = roundOff(dPdgSum,2);
	        if(parseFloat(dPdgSum) >= 0)
	        {	       
	            dPdgRatio = parseFloat(sPdgSum)/parseFloat(dBusinessSum)*1000;
	            dPdgRatio = roundOff(dPdgRatio,2);
	            setItemValue(0,getRow(),"PdgRatio",dPdgRatio);
	        }
	    }
	}
	
	/*~[Describe=根据保证金比例计算保证金金额;InputParam=无;OutPutParam=无;]~*/
	function getBailSum()
	{
	   // sBusinessCurrency = getItemValue(0,getRow(),"BusinessCurrency");
	    //sBailCurrency = getItemValue(0,getRow(),"BailCurrency");
		//if (sBusinessCurrency != sBailCurrency)
		//	return;
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
	  //  sBusinessCurrency = getItemValue(0,getRow(),"BusinessCurrency");
	  //  sBailCurrency = getItemValue(0,getRow(),"BailCurrency");
		//if (sBusinessCurrency != sBailCurrency)
		//	return;
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
	        }
	    }
	}
	</script>
<%/*~END~*/%>

<script type="text/javascript" src="<%=sWebRootPath%>/Accounting/js/loan/loaninfo.js"></script>

<script type="text/javascript">	
	AsOne.AsInit();
	init();
	var bFreeFormMultiCol = true;
	my_load(2,0,'myiframe0');
	initRow(); //页面装载时，对DW当前记录进行初始化
	/*------------------核算加入JS代码---------------*/
	afterLoad("<%=BUSINESSOBJECT_CONSTATNTS.flow_opinion%>","<%=opinionNo%>"); 
	/*------------------核算加入JS代码---------------*/
</script>	
<%@ include file="/IncludeEnd.jsp"%>