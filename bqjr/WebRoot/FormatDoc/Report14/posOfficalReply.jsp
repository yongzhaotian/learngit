<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>
<%@page import="com.amarsoft.dict.als.cache.CodeCache"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   xiongtao  2005.02.18
		Tester:
		Content: 报告的第0页
		Input Param:
			必须传入的参数：
				DocID:	  文档template
				ObjectNo：业务号
				SerialNo: 调查报告流水号
			可选的参数：
				Method:   其中 1:display;2:save;3:preview;6:export
				FirstSection: 判断是否为报告的第一页
		Output param:

		History Log: 
	 */
	%>
<%/*~END~*/%>

<%
	int iDescribeCount = 0;	//这个是页面需要输入的个数，必须写对：客户化1
%>

<%@include file="/FormatDoc/IncludePOHeader.jsp"%>

<%
	//获得调查报告数据
	String sSql = "select bc.CreditID,bc.StoreCityCode,bc.SubProductType,bc.SureType,bc.CustomerID,bc.CustomerName,bc.BusinessType,bc.BusinessSum,bc.InteriorCode,getstorename(bc.Stores) as StoresName,bc.Stores as Stores,getTypeName(bc.BusinessRange1,bc.BusinessType1) as BusinessType1,getTypeName(bc.BusinessRange2,bc.BusinessType2) as BusinessType2,getTypeName(bc.BusinessRange3,bc.BusinessType3) as BusinessType3,"+
					" bc.TotalPrice,bc.BusinessType1,bc.BrandType1,bc.Price1,bc.BusinessType2,bc.BrandType2,bc.Price2,bc.BusinessType3,bc.BrandType3,bc.Price3,getitemname('BankCode',bc.RepaymentBank) as RepaymentBank, "+
					" bc.BusinessType2 btype2, bc.BusinessSum-bc.BusinessSum2 ActualSum,bc.TotalPrice-bc.Price2 BbdTotalPrice," + //CCS-1256 佰保袋，by fangxq 20160311
					" bc.TotalSum,bc.MonthRepayMent,bc.Periods,bc.RepaymentNo,bc.RepaymentName,bc.PutOutDate,bc.Manufacturer1,bc.Manufacturer2,bc.Manufacturer3,bc.InputDate,bc.InputUserID from Business_Contract bc where SerialNo = '"+sObjectNo+"'";

	String sSureType = "";//业务来源
	String customerSignUrl = CodeCache.getItem("SignAppUrl","0010").getItemAttribute();
	String salesmanSignUrl = CodeCache.getItem("SignAppUrl","0020").getItemAttribute();
	String appCustomerSign = "&nbsp;&nbsp;<img src='"+customerSignUrl+sObjectNo+"' width='100' height='30'/>";
	String appSalesmanSign = "<img src='"+salesmanSignUrl+sObjectNo+"' width='100' height='30'/>";
	String customerSign = "___________________";//如果业务来源是APP则替换为签名图片URL地址,非APP来源则不替换
	String salesmanSign = "";//如果业务来源是APP则替换为签名图片URL地址,非APP来源则不替换
	String sCustomerID = "";//客户编号
	String sBusinessType = "";//产品编号
	String sCustomerName = "";//客户名称
	String sCertID = "";//证件号码
	String sBusinessSum = "";//贷款金额
	String sEndTime = "";//审核时间
	String sBusinessType1 = "";//商品类型1
	String sBrandType1 = "";//品牌型号1
	String sPrice1="";//价格1
	String sBusinessType2 = "";//商品类型2
	String sBrandType2 = "";//品牌型号2
	String sPrice2="";//价格2	
	String sBusinessType3 = "";//商品类型3
	String sBrandType3 = "";//品牌型号3
	String sPrice3="";//价格3
	String sMonthRepayMent = "";//每月还款额
	String sTotalSum="";//自付总金额
	String sPeriods="";//期数
	String sRepaymentNo="";//还款账号
	String sRepaymentBank="";//还款银行
	String sRepaymentName="";//还款户名
	String sPutOutDate="";//
	String sStores="";//
	String sManufacturer1 = "";
	String sManufacturer2 = "";
	String sManufacturer3 = "";
	String sInputDate = "";
	String sInputUserID = "";
	String sCreditID = "",sStoreCityCode="",sSubProductType="";
	//自付金额（元）
	//未结算金额（元）
	//每月还款额（元）
	//分期期数
	//首次还款日
	//每月还款日
	//指定还款账户账号
	//开户银行
	//户名
	//销售顾问姓名/代码
	//商家推荐人员
	String sInteriorCode = "";//销售点代码
	String sTotalPrice = "";//商品总价（元）
	String sStoresName = "";
	
	//-- CCS-1256 佰保袋 by fangxq 20160311 --//
	String btype2 = ""; //佰保袋判断项目类型代码
	String sActualSum = ""; //去除商品本金2的贷款本金
	String sBbdTotalPrice = "";//去掉佰保袋价格（价格2）的商品总价
	//-- end --//

%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=ReportInfo;Describe=生成报告信息;客户化2;]~*/%>
<%
	StringBuffer sTemp=new StringBuffer();
	String sDay = StringFunction.getToday().replaceAll("/","");
	sTemp.append("	<form method='post' action='ApproveReport.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable >");
	ASResultSet rs2 = Sqlca.getResultSet(sSql);
	if(rs2.next()){
		sCreditID = rs2.getString("CreditID");
		sStoreCityCode = rs2.getString("StoreCityCode");
		sSubProductType = rs2.getString("SubProductType");
		sSureType = rs2.getString("SureType");
		sCustomerID = rs2.getString("CustomerID");
		sCustomerName = rs2.getString("CustomerName");
		sBusinessType = rs2.getString("BusinessType");
		sBusinessSum = DataConvert.toMoney(rs2.getString("BusinessSum"));
		sInteriorCode = rs2.getString("InteriorCode");
		sTotalPrice = DataConvert.toMoney(rs2.getString("TotalPrice"));
		sStoresName = rs2.getString("StoresName");
		sBusinessType1 = rs2.getString("BusinessType1");
		sBrandType1 = rs2.getString("BrandType1");
		sPrice1 = DataConvert.toMoney(rs2.getString("Price1"));
		sBusinessType2 = rs2.getString("BusinessType2");
		sBrandType2 = rs2.getString("BrandType2");
		sPrice2 = DataConvert.toMoney(rs2.getString("Price2"));
		sBusinessType3 = rs2.getString("BusinessType3");
		sBrandType3 = rs2.getString("BrandType3");
		sPrice3 = DataConvert.toMoney(rs2.getString("Price3"));
		sTotalSum=DataConvert.toMoney(rs2.getString("TotalSum"));
		sMonthRepayMent=DataConvert.toMoney(rs2.getString("MonthRepayMent"));
		sRepaymentNo=rs2.getString("RepaymentNo");
		//sRepaymentBank=rs2.getString("RepaymentBank");
		sRepaymentName=rs2.getString("RepaymentName");
		sPutOutDate=rs2.getString("PutOutDate");
		sPeriods=rs2.getString("Periods");
		sStores=rs2.getString("Stores");
		sManufacturer1 = rs2.getString("Manufacturer1");
		sManufacturer2 = rs2.getString("Manufacturer2");
		sManufacturer3 = rs2.getString("Manufacturer3");
		
		//CCS-1256 佰保袋   by fangxq 
		btype2 = rs2.getString("btype2"); //佰保袋判断项目类型代码
		sActualSum=rs2.getString("ActualSum");
		sBbdTotalPrice=rs2.getString("BbdTotalPrice");
		//end
		
		//sInputDate = rs2.getString("InputDate");
		sInputDate = Sqlca.getString(new SqlObject("SELECT PHASEOPINION3 FROM FLOW_TASK WHERE RELATIVESERIALNO=(SELECT SERIALNO FROM FLOW_TASK WHERE OBJECTNO=:OBJECTNO AND RELATIVESERIALNO IS NULL)").setParameter("OBJECTNO", sObjectNo));
		if (sInputDate == null) {
			sInputDate = Sqlca.getString(new SqlObject("SELECT endtime FROM FLOW_TASK WHERE RELATIVESERIALNO=(SELECT SERIALNO FROM FLOW_TASK WHERE OBJECTNO=:OBJECTNO AND RELATIVESERIALNO IS NULL)").setParameter("OBJECTNO", sObjectNo));
		}
		sInputUserID = rs2.getString("InputUserID");

		if(sCustomerID == null) sCustomerID ="&nbsp;";
		if(sCustomerName == null) sCustomerName ="&nbsp;";
		if(sBusinessType == null) sBusinessType ="&nbsp;";
		if(sBusinessSum == null) sBusinessSum ="&nbsp;";
		if(sInteriorCode == null) sInteriorCode ="&nbsp;";
		if(sStoresName == null) sStoresName ="&nbsp;";
		if(sBusinessType1 == null) sBusinessType1 ="&nbsp;";
		if(sBrandType1 == null) sBrandType1 ="&nbsp;";
		if(sPrice1 == null) sPrice1 ="&nbsp;";
		if(sBusinessType2 == null) sBusinessType2 ="&nbsp;";
		if(sBrandType2 == null) sBrandType2 ="&nbsp;";
		if(sPrice2 == null) sPrice2 ="&nbsp;";
		if(sBusinessType3 == null) sBusinessType3 ="&nbsp;";
		if(sBrandType3 == null) sBrandType3 ="&nbsp;";
		if(sPrice3 == null) sPrice3 ="&nbsp;";
		if(sTotalSum == null) sTotalSum ="&nbsp;";
		if(sMonthRepayMent == null) sMonthRepayMent ="&nbsp;";
		if(sRepaymentNo == null) sRepaymentNo ="&nbsp;";
		//if(sRepaymentBank == null) sRepaymentBank ="&nbsp;";
		if(sRepaymentName == null) sRepaymentName ="&nbsp;";
		if(sTotalPrice == null) sTotalPrice ="&nbsp;";
		if(sPutOutDate == null) sPutOutDate ="&nbsp;";
		if(sPeriods == null) sPeriods ="&nbsp;";
		if(sStores == null) sStores ="&nbsp;";
		if(sManufacturer1 == null) sManufacturer1 ="&nbsp;";
		if(sManufacturer2 == null) sManufacturer2 ="&nbsp;";
		if(sManufacturer3 == null) sManufacturer3 ="&nbsp;";
		if(sInputDate == null) sInputDate ="&nbsp;";
		if(sInputUserID == null) sInputUserID ="&nbsp;";
		
		//CCS-1256 佰保袋，by fangxq 20160311
		if(sActualSum == null) sActualSum = "&nbsp;";
		if(sBbdTotalPrice == null) sBbdTotalPrice = "&nbsp;";
		//end
		
		//sRepaymentBank = "招商银行深圳四海支行";
		
	}
	
	//还款银行
	sRepaymentBank = Sqlca.getString(new SqlObject("select getItemName('LoanSubBank',subBankName) as subBankName " + 
		" from ProvidersCity where SerialNo=:SerialNo and AreaCode=:AreaCode " + 
			" and ProductType=:ProductType").setParameter("SerialNo", sCreditID)
				.setParameter("AreaCode", sStoreCityCode).setParameter("ProductType", sSubProductType));
	if(sRepaymentBank == null){
		sRepaymentBank = Sqlca.getString(new SqlObject("select getItemName('LoanSubBank',subBankName) as subBankName " + 
				" from ProvidersCity_Log where SerialNo=:SerialNo and AreaCode=:AreaCode " + 
				" and ProductType=:ProductType and :InputDate between beginTime and endTime").setParameter("SerialNo", sCreditID)
					.setParameter("AreaCode", sStoreCityCode).setParameter("ProductType", sSubProductType)
					.setParameter("InputDate", sInputDate));
	};
	
	//如果业务来源是APP则替换为签名图片URL地址,非APP来源则不替换
	//sSureType = "APP";
	if("APP".equals(sSureType)){
		customerSign = appCustomerSign;
		salesmanSign = appSalesmanSign;
	}
	
	String sAddress = Sqlca.getString(new SqlObject("select getItemName('AreaCode',CITY)||ADDRESS as Address from STORE_INFO where SNO =:SNO").setParameter("SNO", sStores));
	
	//取合同状态
	String sContractStatus = Sqlca.getString(new SqlObject("select CASE WHEN ContractStatus IN ( '020', '050','080','090') THEN '已批准'  WHEN ContractStatus = '010' THEN '已否决'  WHEN ContractStatus = '100' THEN '已取消' ELSE getItemName('ContractStatus',ContractStatus) END from business_contract where SerialNo =:ObjectNo").setParameter("ObjectNo", sObjectNo));
	
	//首次还款日
	String sFirstDueDate = "";
	String sDefaultDueDay = "";
	String businessDate = SystemConfig.getBusinessDate();
	if(!sPutOutDate.equals("&nbsp;")){	
		sFirstDueDate = Sqlca.getString(new SqlObject("select FirstDueDate from acct_rpt_segment where objectno = :objectNo ").setParameter("objectNo", sObjectNo));
		sDefaultDueDay = sFirstDueDate.substring(8,10);
	}
	//Double sFutureAmt = Arith.round(Double.parseDouble(sMonthRepayMent)*Integer.parseInt(sPeriods, 10),2);//应还总金额
	String sFutureAmt = DataConvert.toMoney(sBusinessSum);//未结算金额

	
	sCertID = Sqlca.getString("select CertID from Customer_Info where CustomerID = '"+sCustomerID+"'");
	//sEndTime = Sqlca.getString("");
		
		sTemp.append("<table width='660' align=center border=0 cellspacing=0 cellpadding=0 >	");
		
		sTemp.append("   <tr>");
		sTemp.append("<td colspan=1 rowspan=2 style='margin-left:30%' align=left><img src='"+sWebRootPath+"/FormatDoc/Images/121.jpg' /></td>");
		sTemp.append("   </tr>");
		sTemp.append("</table>");
	
		sTemp.append("<table class=table1 width='660' height='300' align=center border=0 cellspacing=0 cellpadding=0 >	");
		sTemp.append("   <tr>");
		sTemp.append("   <td align=left colspan=4 class=td1 ><b>审核意见书及自付金额支付确认书</b></td>");
		sTemp.append("   <td colspan=2 align=left class=td1 ><b>合同编号：</b>"+sObjectNo+"&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td colspan=2 align=left class=td1 ><b>商家：</b>"+sStoresName+"&nbsp;</td>");
		sTemp.append("   <td colspan=2 align=left class=td1 ><b>商家地址：</b>"+sAddress+"&nbsp;</td>");
		//sTemp.append("   <td colspan=2 align=left class=td1 ><b>销售点代码：</b>"+sInteriorCode+"&nbsp;</td>");
		sTemp.append("   <td colspan=2 align=left class=td1 ><b>销售点代码：</b>"+sStores+"&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td colspan=2 align=left class=td1 >1.客户姓名："+sCustomerName+"&nbsp;</td>");
		sTemp.append("   <td colspan=2 align=left class=td1 >2.身份证号码："+sCertID+"&nbsp;</td>");
		
		//CCS-1256  佰保袋 by fangxq 20160314
		if("2015061500000017".equals(btype2)){
			sTemp.append("   <td colspan=2 align=left class=td1 >3.商品总价（元）："+sBbdTotalPrice+"&nbsp;</td>");
		}else{
			sTemp.append("   <td colspan=2 align=left class=td1 >3.商品总价（元）："+sTotalPrice+"&nbsp;</td>");
		}
		//end 
		
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td colspan=2 align=left class=td1 >4.商品类型（1）："+sBusinessType1+"&nbsp;</td>");
		sTemp.append("   <td align=left class=td1 >5.商品型号（1）："+sManufacturer1+"&nbsp;</td>");
		sTemp.append("   <td colspan=2 align=left class=td1 >6.品牌（1）："+sBrandType1+"&nbsp;</td>");
		sTemp.append("   <td align=left class=td1 >7.价格（1）："+sPrice1+"&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");

		//CCS-1256  佰保袋 by fangxq 20160311
		if("2015061500000017".equals(btype2)){
			sTemp.append("   <td colspan=2 align=left class=td1 >8.商品类型（2）：&nbsp;</td>");
			sTemp.append("   <td align=left class=td1 >9.商品型号（2）：&nbsp;</td>");
			sTemp.append("   <td colspan=2 align=left class=td1 >10.品牌（2）：&nbsp;</td>");
			sTemp.append("   <td align=left class=td1 >11.价格（2）：&nbsp;</td>");
		}else{
			sTemp.append("   <td colspan=2 align=left class=td1 >8.商品类型（2）："+sBusinessType2+"&nbsp;</td>");
			sTemp.append("   <td align=left class=td1 >9.商品型号（2）："+sManufacturer2+"&nbsp;</td>");
			sTemp.append("   <td colspan=2 align=left class=td1 >10.品牌（2）："+sBrandType2+"&nbsp;</td>");
			sTemp.append("   <td align=left class=td1 >11.价格（2）："+sPrice2+"&nbsp;</td>");
		}
		//end
		
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td colspan=2 align=left class=td1 >8.商品类型（3）："+sBusinessType3+"&nbsp;</td>");
		sTemp.append("   <td align=left class=td1 >9.商品型号（3）："+sManufacturer3+"&nbsp;</td>");
		sTemp.append("   <td colspan=2 align=left class=td1 >10.品牌（3）："+sBrandType3+"&nbsp;</td>");
		sTemp.append("   <td align=left class=td1 >11.价格（3）："+sPrice3+"&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		//sTemp.append("   <td colspan=6 align=left class=td1 ><b>I.审批结果 : 签署的/拒绝/取消/推迟</b>&nbsp;</td>");
		sTemp.append("   <td colspan=6 align=left class=td1 ><b>I.审批结果 : "+sContractStatus+"&nbsp;</b>&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td colspan=6 align=left class=td1 bgcolor=#aaaaaa ><b>II.消费贷款内容摘要</b>&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td colspan=2 align=left class=td1 >12.自付金额（元）："+sTotalSum+"&nbsp;</td>");
		
		//CCS-1256  佰保袋 by fangxq 20160311
		if("2015061500000017".equals(btype2)){
			sTemp.append("   <td colspan=4 align=left class=td1 >13.未结算金额（元）："+sActualSum+"&nbsp;</td>");
		}else{
			sTemp.append("   <td colspan=4 align=left class=td1 >13.未结算金额（元）："+sFutureAmt+"&nbsp;</td>");
		}
		//end
		
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td colspan=2 align=left class=td1 >14.产品代码："+sBusinessType+"&nbsp;</td>");
		
		//CCS-1256  佰保袋 by fangxq 20160311
		if("2015061500000017".equals(btype2)){
			sTemp.append("   <td colspan=2 align=left class=td1 >15.贷款本金（元）："+sActualSum+"&nbsp;</td>");
			sTemp.append("   <td colspan=2 align=left class=td1 >&nbsp;</td>");
			sTemp.append("   </tr>");
			sTemp.append("   <tr>");
			sTemp.append("   <td colspan=2 align=left class=td1 >16.分期期数："+sPeriods+"</td>");
			sTemp.append("   <td colspan=2 align=left class=td1 >17.首次还款日："+sFirstDueDate+"</td>");
			sTemp.append("   <td colspan=2 align=left class=td1 >18.每月还款日："+sDefaultDueDay+"</td>");
			sTemp.append("   </tr>");
			sTemp.append("   <tr>");
			sTemp.append("   <td  colspan=2 align=left class=td1 >19.指定还款账户账号："+sRepaymentNo+"</td>");
			sTemp.append("   <td colspan=4 align=left class=td1 >20.开户银行："+sRepaymentBank+"</td>");
			sTemp.append("   </tr>");
			sTemp.append("   <tr>");
			sTemp.append("   <td align=left colspan=6 class=td1 >21.户名："+sRepaymentName+"</td>");
			sTemp.append("   </tr>");
			sTemp.append("   <tr>");
			sTemp.append("   <td align=left colspan=6 class=td1 ><font style=' font-size: 6pt;' FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >客户与商家签署本文件以确认，自本文件签署时：（1）以上商品描述准确；（2）客户已支付"+sTotalSum+"元为自付金额；（3）除非事后商家书面通知客户，非因商家之过错，使得其未从贷款人处收到贷款本金，否则客户与商家均视为商品价款已全额支付，包括贷款本金加自付金额。（4）贷款协议与商品购买合同是独立的法律关系，贷款人不对商家所提供商品的质量承担任何责任；（5）如购买的商品是货物，则客户已取得该商品或取货凭证；并且商品与贷款协议中的描述一致，可以正常使用；（6）如购买的商品是服务，无论客户是否实际享受该服务，客户必须按照贷款协议偿还贷款。</font></td>");
			sTemp.append("   </tr>");
			sTemp.append("   <tr>");
			sTemp.append("   <td colspan=6 align=left class=td1 bgcolor=#aaaaaa ><b>III.系统使用&nbsp;</td>");
			sTemp.append("   </tr>");
			sTemp.append("   <tr>");
			sTemp.append("   <td colspan=2 align=left class=td1 >22.审核日期及时间："+sInputDate+"&nbsp;</td>");
			sTemp.append("   <td colspan=2 align=left class=td1 >23.销售顾问姓名/代码："+sInputUserID+"&nbsp</td>");
			sTemp.append("   <td colspan=2 align=left class=td1 >24.销售顾问签名："+salesmanSign+"</td>");
			sTemp.append("   </tr>");
			sTemp.append("   <tr>");
			sTemp.append("   <td  colspan=2 align=left class=td1 >25.商家推荐人员：</td>");
			sTemp.append("   <td colspan=4 align=left class=td1 >26.商家接收人签名：</td>");
			
		}else{
			sTemp.append("   <td colspan=2 align=left class=td1 >15.贷款本金（元）："+sBusinessSum+"&nbsp;</td>");
			sTemp.append("   <td colspan=2 align=left class=td1 >16.每月还款额（元）："+sMonthRepayMent+"</td>");
			sTemp.append("   </tr>");
			sTemp.append("   <tr>");
			sTemp.append("   <td colspan=2 align=left class=td1 >17.分期期数："+sPeriods+"</td>");
			sTemp.append("   <td colspan=2 align=left class=td1 >18.首次还款日："+sFirstDueDate+"</td>");
			sTemp.append("   <td colspan=2 align=left class=td1 >19.每月还款日："+sDefaultDueDay+"</td>");
			sTemp.append("   </tr>");
			sTemp.append("   <tr>");
			sTemp.append("   <td  colspan=2 align=left class=td1 >20.指定还款账户账号："+sRepaymentNo+"</td>");
			sTemp.append("   <td colspan=4 align=left class=td1 >21.开户银行："+sRepaymentBank+"</td>");
			sTemp.append("   </tr>");
			sTemp.append("   <tr>");
			sTemp.append("   <td align=left colspan=6 class=td1 >22.户名："+sRepaymentName+"</td>");
			sTemp.append("   </tr>");
			sTemp.append("   <tr>");
			sTemp.append("   <td align=left colspan=6 class=td1 ><font style=' font-size: 6pt;' FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >客户与商家签署本文件以确认，自本文件签署时：（1）以上商品描述准确；（2）客户已支付"+sTotalSum+"元为自付金额；（3）除非事后商家书面通知客户，非因商家之过错，使得其未从贷款人处收到贷款本金，否则客户与商家均视为商品价款已全额支付，包括贷款本金加自付金额。（4）贷款协议与商品购买合同是独立的法律关系，贷款人不对商家所提供商品的质量承担任何责任；（5）如购买的商品是货物，则客户已取得该商品或取货凭证；并且商品与贷款协议中的描述一致，可以正常使用；（6）如购买的商品是服务，无论客户是否实际享受该服务，客户必须按照贷款协议偿还贷款。</font></td>");
			sTemp.append("   </tr>");
			sTemp.append("   <tr>");
			sTemp.append("   <td colspan=6 align=left class=td1 bgcolor=#aaaaaa ><b>III.系统使用&nbsp;</td>");
			sTemp.append("   </tr>");
			sTemp.append("   <tr>");
			sTemp.append("   <td colspan=2 align=left class=td1 >23.审核日期及时间："+sInputDate+"&nbsp;</td>");
			sTemp.append("   <td colspan=2 align=left class=td1 >24.销售顾问姓名/代码："+sInputUserID+"&nbsp</td>");
			sTemp.append("   <td colspan=2 align=left class=td1 >25.销售顾问签名："+salesmanSign+"</td>");
			sTemp.append("   </tr>");
			sTemp.append("   <tr>");
			sTemp.append("   <td  colspan=2 align=left class=td1 >26.商家推荐人员：</td>");
			sTemp.append("   <td colspan=4 align=left class=td1 >27.商家接收人签名：</td>");
		}
		//end
		
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td align=left colspan=6 class=td1 >商家名称（盖章）：_____________________ &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;客户签名:"+customerSign+"</td>");
		sTemp.append("   </tr>");
		sTemp.append("</table>");
	sTemp.append("</div>");	
	sTemp.append("<div align=center>");	
	sTemp.append("<font style=' font-size: 9pt;' >版本：XF_TY_TY_2016030902 商家联</font></br>");// update by fangxq 20160316 佰保袋
	sTemp.append("----------------------------------------------------------------------------------");
	sTemp.append("</div>");	
	
	sTemp.append("<div id=reporttable >");
		
		sTemp.append("<table width='660' align=center border=0 cellspacing=0 cellpadding=0 >	");
		
		sTemp.append("   <tr>");
		sTemp.append("<td colspan=1 rowspan=2 style='margin-left:30%' align=left><img src='"+sWebRootPath+"/FormatDoc/Images/121.jpg' /></td>");
		sTemp.append("   </tr>");
		sTemp.append("</table>");
		
		sTemp.append("<table class=table1 width='660' height='300' align=center border=0 cellspacing=0 cellpadding=0  >	");
		sTemp.append("   <tr>");
		sTemp.append("   <td align=left colspan=4 class=td1 ><b>审核意见书及自付金额支付确认书</b></td>");
		sTemp.append("   <td colspan=2 align=left class=td1 ><b>合同编号：</b>"+sObjectNo+"&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td colspan=2 align=left class=td1 ><b>商家：</b>"+sStoresName+"&nbsp;</td>");
		sTemp.append("   <td colspan=2 align=left class=td1 ><b>商家地址：</b>"+sAddress+"&nbsp;</td>");
		//sTemp.append("   <td colspan=2 align=left class=td1 ><b>销售点代码：</b>"+sInteriorCode+"&nbsp;</td>");
		sTemp.append("   <td colspan=2 align=left class=td1 ><b>销售点代码：</b>"+sStores+"&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td colspan=2 align=left class=td1 >1.客户姓名："+sCustomerName+"</td>");
		sTemp.append("   <td colspan=2 align=left class=td1 >2.身份证号码："+sCertID+"</td>");
		
		//CCS-1256  佰保袋 by fangxq 20160314
		if("2015061500000017".equals(btype2)){
			sTemp.append("   <td colspan=2 align=left class=td1 >3.商品总价（元）："+sBbdTotalPrice+"</td>");
		}else{
			sTemp.append("   <td colspan=2 align=left class=td1 >3.商品总价（元）："+sTotalPrice+"</td>");
		}
		//end
		
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td colspan=2 align=left class=td1 >4.商品类型（1）："+sBusinessType1+"</td>");
		sTemp.append("   <td align=left class=td1 >5.商品型号（1）："+sManufacturer1+"</td>");
		sTemp.append("   <td colspan=2 align=left class=td1 >6.品牌（1）："+sBrandType1+"</td>");
		sTemp.append("   <td align=left class=td1 >7.价格（1）："+sPrice1+"</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		
		//CCS-1256  佰保袋 by fangxq 20160311
		if("2015061500000017".equals(btype2)){
			sTemp.append("   <td colspan=2 align=left class=td1 >8.商品类型（2）：&nbsp;</td>");
			sTemp.append("   <td align=left class=td1 >9.商品型号（2）：&nbsp;</td>");
			sTemp.append("   <td colspan=2 align=left class=td1 >10.品牌（2）：&nbsp;</td>");
			sTemp.append("   <td align=left class=td1 >11.价格（2）：&nbsp;</td>");
		}else{
			sTemp.append("   <td colspan=2 align=left class=td1 >8.商品类型（2）："+sBusinessType2+"</td>");
			sTemp.append("   <td align=left class=td1 >9.商品型号（2）："+sManufacturer2+"</td>");
			sTemp.append("   <td colspan=2 align=left class=td1 >10.品牌（2）："+sBrandType2+"</td>");
			sTemp.append("   <td align=left class=td1 >11.价格（2）："+sPrice2+"</td>");
		}
		//end
		
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td colspan=2 align=left class=td1 >8.商品类型（3）："+sBusinessType3+"&nbsp;</td>");
		sTemp.append("   <td align=left class=td1 >9.商品型号（3）："+sManufacturer3+"&nbsp;</td>");
		sTemp.append("   <td colspan=2 align=left class=td1 >10.品牌（3）："+sBrandType3+"&nbsp;</td>");
		sTemp.append("   <td align=left class=td1 >11.价格（3）："+sPrice3+"&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		//sTemp.append("   <td colspan=6 align=left class=td1 ><b>I.审批结果 : 签署的/拒绝/取消/推迟</b>&nbsp;</td>");
		sTemp.append("   <td colspan=6 align=left class=td1 ><b>I.审批结果 : "+sContractStatus+"&nbsp;</b>&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td colspan=6 align=left class=td1 bgcolor=#aaaaaa ><b>II.消费贷款内容摘要</b>&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td  colspan=2 align=left class=td1 >12.自付金额（元）："+sTotalSum+"</td>");

		//CCS-1256  佰保袋 by fangxq 20160311
		if("2015061500000017".equals(btype2)){
			sTemp.append("   <td colspan=4 align=left class=td1 >13.未结算金额（元）："+sActualSum+"&nbsp;</td>");
		}else{
			sTemp.append("   <td colspan=4 align=left class=td1 >13.未结算金额（元）："+sFutureAmt+"</td>");
		}
		//end
		
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td colspan=2 align=left class=td1 >14.产品代码："+sBusinessType+"</td>");
		
		//CCS-1256  佰保袋 by fangxq 20160311
		if("2015061500000017".equals(btype2)){
			sTemp.append("   <td colspan=2 align=left class=td1 >15.贷款本金（元）："+sActualSum+"&nbsp;</td>");
			sTemp.append("   <td colspan=2 align=left class=td1 >&nbsp;</td>");
			sTemp.append("   </tr>");
			sTemp.append("   <tr>");
			sTemp.append("   <td colspan=2 align=left class=td1 >16.分期期数："+sPeriods+"</td>");
			sTemp.append("   <td colspan=2 align=left class=td1 >17.首次还款日："+sFirstDueDate+"</td>");
			sTemp.append("   <td colspan=2 align=left class=td1 >18.每月还款日："+sDefaultDueDay+"</td>");
			sTemp.append("   </tr>");
			sTemp.append("   <tr>");
			sTemp.append("   <td  colspan=2 align=left class=td1 >19.指定还款账户账号："+sRepaymentNo+"</td>");
			sTemp.append("   <td colspan=4 align=left class=td1 >20.开户银行："+sRepaymentBank+"</td>");
			sTemp.append("   </tr>");
			sTemp.append("   <tr>");
			sTemp.append("   <td align=left colspan=6 class=td1 >21.户名："+sRepaymentName+"</td>");
			sTemp.append("   </tr>");
			sTemp.append("   <tr>");
			sTemp.append("   <td align=left colspan=6 class=td1 ><font style=' font-size: 6pt;' FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >客户与商家签署本文件以确认，自本文件签署时：（1）以上商品描述准确；（2）客户已支付"+sTotalSum+"元为自付金额；（3）除非事后商家书面通知客户，非因商家之过错，使得其未从贷款人处收到贷款本金，否则客户与商家均视为商品价款已全额支付，包括贷款本金加自付金额。（4）贷款协议与商品购买合同是独立的法律关系，贷款人不对商家所提供商品的质量承担任何责任；（5）如购买的商品是货物，则客户已取得该商品或取货凭证；并且商品与贷款协议中的描述一致，可以正常使用；（6）如购买的商品是服务，无论客户是否实际享受该服务，客户必须按照贷款协议偿还贷款。</font></td>");
			sTemp.append("   </tr>");
			sTemp.append("   <tr>");
			sTemp.append("   <td colspan=6 align=left class=td1 bgcolor=#aaaaaa ><b>III.系统使用&nbsp;</td>");
			sTemp.append("   </tr>");
			sTemp.append("   <tr>");
			sTemp.append("   <td colspan=2 align=left class=td1 >22.审核日期及时间："+sInputDate+"&nbsp;</td>");
			sTemp.append("   <td colspan=2 align=left class=td1 >23.销售顾问姓名/代码："+sInputUserID+"&nbsp</td>");
			sTemp.append("   <td colspan=2 align=left class=td1 >24.销售顾问签名："+salesmanSign+"</td>");
			sTemp.append("   </tr>");
			sTemp.append("   <tr>");
			sTemp.append("   <td  colspan=2 align=left class=td1 >25.商家推荐人员：</td>");
			sTemp.append("   <td colspan=4 align=left class=td1 >26.商家接收人签名：</td>");
			
		}else{
			sTemp.append("   <td colspan=2 align=left class=td1 >15.贷款本金（元）："+sBusinessSum+"</td>");
			sTemp.append("   <td colspan=2 align=left class=td1 >16.每月还款额（元）："+sMonthRepayMent+"</td>");
			sTemp.append("   </tr>");
			sTemp.append("   <tr>");
			sTemp.append("   <td colspan=2 align=left class=td1 >17.分期期数："+sPeriods+"</td>");
			sTemp.append("   <td colspan=2 align=left class=td1 >18.首次还款日："+sFirstDueDate+"</td>");
			sTemp.append("   <td colspan=2 align=left class=td1 >19.每月还款日："+sDefaultDueDay+"</td>");
			sTemp.append("   </tr>");
			sTemp.append("   <tr>");
			sTemp.append("   <td  colspan=2 align=left class=td1 >20.指定还款账户账号："+sRepaymentNo+"</td>");
			sTemp.append("   <td colspan=4 align=left class=td1 >21.开户银行："+sRepaymentBank+"</td>");
			sTemp.append("   </tr>");
			sTemp.append("   <tr>");
			sTemp.append("   <td align=left colspan=6 class=td1 >22.户名："+sRepaymentName+"</td>");
			sTemp.append("   </tr>");
			sTemp.append("   <tr>");
			sTemp.append("   <td align=left colspan=6 class=td1 ><font style=' font-size: 6pt;' FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >客户与商家签署本文件以确认，自本文件签署时：（1）以上商品描述准确；（2）客户已支付"+sTotalSum+"元为自付金额；（3）除非事后商家书面通知客户，非因商家之过错，使得其未从贷款人处收到贷款本金，否则客户与商家均视为商品价款已全额支付，包括贷款本金加自付金额。（4）贷款协议与商品购买合同是独立的法律关系，贷款人不对商家所提供商品的质量承担任何责任；（5）如购买的商品是货物，则客户已取得该商品或取货凭证；并且商品与贷款协议中的描述一致，可以正常使用；（6）如购买的商品是服务，无论客户是否实际享受该服务，客户必须按照贷款协议偿还贷款。</font></td>");
			sTemp.append("   </tr>");
			sTemp.append("   <tr>");
			sTemp.append("   <td colspan=6 align=left class=td1 bgcolor=#aaaaaa ><b>III.系统使用&nbsp;</td>");
			sTemp.append("   </tr>");
			sTemp.append("   <tr>");
			sTemp.append("   <td colspan=2 align=left class=td1 >23.审核日期及时间："+sInputDate+"&nbsp;</td>");
			sTemp.append("   <td colspan=2 align=left class=td1 >24.销售顾问姓名/代码："+sInputUserID+"&nbsp</td>");
			sTemp.append("   <td colspan=2 align=left class=td1 >25.销售顾问签名："+salesmanSign+"</td>");
			sTemp.append("   </tr>");
			sTemp.append("   <tr>");
			sTemp.append("   <td  colspan=2 align=left class=td1 >26.商家推荐人员：</td>");
			sTemp.append("   <td colspan=4 align=left class=td1 >27.商家接收人签名：</td>");
		}
		//end
		
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td align=left colspan=6 class=td1 >商家名称（盖章）：_____________________ &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;客户签名:"+customerSign+"</td>");
		sTemp.append("   </tr>");
		sTemp.append("</table>");
	sTemp.append("</div>");	
	sTemp.append("<div align=center>");	
	sTemp.append("<font style=' font-size: 9pt;' >版本：XF_TY_TY_2016030902 公司联</font></br>");//update by fangxq 20160316 佰保袋
	sTemp.append("</div>");	
	
	
	rs2.getStatement().close();	
	
	sTemp.append("<input type='hidden' name='Method' value='1'>");
	sTemp.append("<input type='hidden' name='SerialNo' value='111'>");
	sTemp.append("<input type='hidden' name='ObjectNo' value='111'>");
	sTemp.append("<input type='hidden' name='ObjectType' value='111'>");
	sTemp.append("<input type='hidden' name='Rand' value=''>");
	sTemp.append("<input type='hidden' name='CompClientID' value='111'>");
	sTemp.append("<input type='hidden' name='PageClientID' value='111'>");
	sTemp.append("</form>");	
	if(sEndSection.equals("1"))
		sTemp.append("<br clear=all style='mso-special-character:line-break;page-break-before:always'>");
	
	String sReportInfo = sTemp.toString();
	String sPreviewContent = "pvw"+java.lang.Math.random();
%>
<%/*~END~*/%>

<%@include file="/FormatDoc/IncludeFDFooter.jsp"%>

<script type="text/javascript">
<%	
	if(sMethod.equals("1"))  //1:display
	{
%>
	//客户化3
	var config = new Object();  
<%
	}
%>	
</script>	
	
<%@ include file="/IncludeEnd.jsp"%>

