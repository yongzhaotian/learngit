<%@page import="com.amarsoft.app.lending.bizlets.GetBugPayPkgindFee"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main00;Describe=注释区;]~*/%>
	<%
	/*
		打印佰保袋合同
		Author:   fangxq  2016.02.14
		Tester:
		Content: 报告的第0页
		Input Param:
			必须传入的参数：
				DocID:	  文档template
				ObjectNo：业务号
				SerialNo: 调查报告流水号
			可选的参数：
				Method:   其中 1:display;2:save;3:preview;4:export
				FirstSection: 判断是否为报告的第一页
		Output param:

		History Log: 
	 */
	%>
<%/*~END~*/%>

<%
	int iDescribeCount = 30;	//这个是页面需要输入的个数，必须写对：客户化1
	int iCount = 1;
	int iCountNew = 20 ;
%>

<%@include file="/FormatDoc/IncludePOHeader.jsp"%>

<%
	//String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectNo")); 
	
	String sql="select bc.customername,bc.brandtype1,bc.manufacturer1,bc.price1,bc.price2,bc.salesubmittime, "+
		"bc.InputUserID"+ //add by fangxq 20160317 佰保袋—获取销售顾问姓名/代码
		" from business_contract bc where bc.serialno='"+sObjectNo+"'";
		
	String sCustomerName = "";	//顾客姓名
	String sBrandType1 = "";	//手机品牌
	String sManufacturer1 = "";	//手机型号
	String sPrice1 = "";		//购机价格
	String sPrice2 = "";		//延保价格
	String sSalesubmittime = "";	//合同提交日期 
	String sCity = ""; //城市ID
	
	//add by fangxq  CCS-1320 添加审核意见书 20160317 
	String sInputDate = ""; //审核日期及时间
	String sInputUserID = "";//销售顾问姓名/代码
	//end 
	
	ASResultSet rs = Sqlca.getASResultSet(sql);
	if(rs.next()){
		sCustomerName = rs.getString("customername");
		sBrandType1 = rs.getString("brandtype1");
		sManufacturer1 = rs.getString("manufacturer1");
		sPrice1 = rs.getString("price1");
		sPrice2 = rs.getString("price2");
		sSalesubmittime = rs.getString("salesubmittime");	
		sInputUserID = rs.getString("InputUserID"); //add by fangxq  CCS-1320 添加审核意见书 20160317
	}	
	
	//城市id
	String sql3 = "select si.city from store_info si where si.sno in("
		+"select bc.stores from business_contract bc where bc.serialno='"+sObjectNo+"')";
	
	ASResultSet rs3 = Sqlca.getASResultSet(sql3);
	if(rs3.next()){
		sCity = rs3.getString("city");
	}
	if(sCity == null) sCity="";
	rs3.getStatement().close(); 	

	if(sCustomerName == null) sCustomerName="";
	if(sBrandType1 == null) sBrandType1="";
	if(sManufacturer1 == null) sManufacturer1="";
	if(sPrice1 == null) sPrice1="";
	if(sPrice2 == null) sPrice2="";
	if(sSalesubmittime == null) sSalesubmittime="";
	if(sInputUserID == null) sInputUserID ="&nbsp;"; //add by fangxq  CCS-1320 添加审核意见书 20160317
	String sDate = "";
	sDate = sSalesubmittime.substring(0,10);//购买日期 
	
	rs.getStatement().close(); 
	
	String sql1 = " select bpi.service_tel,bpi.provider_name,bpi.abbreviate from bbd_provider_info bpi"+
			  " where bpi.provider_id in (select prc.provider_id from bbd_provider_relative_city prc where prc.city_id ='"+sCity+"')";
	String sql2 = "select bti.mobile_serial_number,bti.serveyear from bbd_treasurebag_info bti where bti.serialno='"+sObjectNo+"'";
	
	String sService_tel = "";	//供应商电话
	String sProvider_name = "";	//供应商名称
	String sMobile_serial_number = "";	//手机串号
	String sServeyear = "";	//延保期限
	String sAbbreviate = "";//供应商名称缩写 
	String sVersion = "";//版本号 
	
	ASResultSet rs1 = Sqlca.getASResultSet(sql1);
	ASResultSet rs2 = Sqlca.getASResultSet(sql2);
	
	//供应商名称、供应商电话 、供应商名称缩写 
	if(rs1.next()){
		sService_tel = rs1.getString("service_tel");
		sProvider_name = rs1.getString("provider_name");
		sAbbreviate = rs1.getString("abbreviate");
	}
	if(sService_tel == null) sService_tel="";
	if(sProvider_name == null) sProvider_name=""; 
	if(sAbbreviate == null) sAbbreviate=""; 
	rs1.getStatement().close();
	sVersion = sAbbreviate+"-BBD-2016031601"; //update by fangxq CCS-1320 20160318
		
	//手机串号 、延保期限  
	if(rs2.next()){
		sMobile_serial_number = rs2.getString("mobile_serial_number");
		sServeyear = rs2.getString("SERVEYEAR");
	}
	if(sMobile_serial_number == null) sMobile_serial_number=""; 
	if(sServeyear == null) sServeyear="";
	rs2.getStatement().close();
	
	//add by fangxq CCS-1320 佰保袋添加审核意见书 20160318
	//取合同状态
	String sContractStatus = Sqlca.getString(new SqlObject("select phasename from flow_object where objectno =:ObjectNo").setParameter("ObjectNo", sObjectNo));
	sInputDate = Sqlca.getString(new SqlObject("SELECT PHASEOPINION3 FROM FLOW_TASK WHERE RELATIVESERIALNO=(SELECT SERIALNO FROM FLOW_TASK WHERE OBJECTNO=:OBJECTNO AND RELATIVESERIALNO IS NULL)").setParameter("OBJECTNO", sObjectNo));
	if (sInputDate == null) {
		sInputDate = Sqlca.getString(new SqlObject("SELECT endtime FROM FLOW_TASK WHERE RELATIVESERIALNO=(SELECT SERIALNO FROM FLOW_TASK WHERE OBJECTNO=:OBJECTNO AND RELATIVESERIALNO IS NULL)").setParameter("OBJECTNO", sObjectNo));
	}
	if(sInputDate == null) sInputDate ="&nbsp;";
	//end

%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=ReportInfo;Describe=生成报告信息;客户化2;]~*/%>
<%
		StringBuffer sTemp=new StringBuffer();
		sTemp.append("<form method='post' action='ApplyBaiBaoDai.jsp' name='BaiBaoDaiReportInfo'>");	
		sTemp.append("<div id=reporttable style='position:relative;'>");
		
		//add by fangxq CCS-1320 佰保袋合同添加审核意见书 20160318
		sTemp.append("<table class=table1 width='690' align=center border=0 cellspacing=0 cellpadding=0 >	");
		sTemp.append("   <tr>");
		sTemp.append("   <td align=left colspan=5 class=td1 ><b>佰仟金融消费贷款审核意见书—佰保袋服务专用</b></td>");
		sTemp.append("   <td colspan=1 align=left class=td1 ><b>合同编号：</b>"+sObjectNo+"&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td colspan=4 align=left class=td1 ><b>商家：</b>"+sProvider_name+"&nbsp;</td>");
		sTemp.append("   <td colspan=3 align=left class=td1 >客户姓名："+sCustomerName+"&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td colspan=3 align=left class=td1 >手机品牌："+sBrandType1+"&nbsp;</td>");
		sTemp.append("   <td colspan=2 align=left class=td1 >手机型号："+sManufacturer1+"&nbsp;</td>");
		sTemp.append("   <td colspan=2 align=left class=td1 >手机串号："+sMobile_serial_number+"&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td colspan=5 align=left class=td1 >延保期限：<u>&nbsp;"+sServeyear+"&nbsp;</u>年期</td>");
		sTemp.append("   <td colspan=2 align=left class=td1 >服务价格（元）:"+sPrice2+"&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td colspan=6 align=left class=td1 ><b>I.审批结果 :  "+sContractStatus+"&nbsp;</b>&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td colspan=6 align=left class=td1 bgcolor=#aaaaaa ><b>II.消费贷款内容摘要</b>&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td colspan=3 align=left class=td1 >自付金额（元）：0.00&nbsp;</td>");
		sTemp.append("   <td colspan=2 align=left class=td1 >未结算金额（元）："+sPrice2+"&nbsp;</td>");
		sTemp.append("   <td colspan=2 align=left class=td1 >贷款本金（元）："+sPrice2+"&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td align=left colspan=6 class=td1 ><font style=' font-size: 6pt;' FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >客户签署本文件以确认，自本文件签署时：（1）以上描述准确；（2）贷款协议与《手机“佰保袋”限额延保服务合同》是独立的法律关系，贷款人不对商家所提供的服务质量承担任何责任；（3）无论客户是否发生延保范围内的故障，客户均需按照贷款协议偿还贷款。（5）为方便客户，本文件与《手机“佰保袋”限额延保服务合同》可合并签署，客户签署一次即视为对本文件及《手机“佰保袋”限额延保服务合同》的确认。</font></td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td colspan=6 align=left class=td1 bgcolor=#aaaaaa ><b>III.系统使用&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td colspan=4 align=left class=td1 >审核日期及时间："+sInputDate+"&nbsp;</td>");
		sTemp.append("   <td colspan=4 align=left class=td1 >销售顾问姓名/代码："+sInputUserID+"&nbsp</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td colspan=6 align=left class=td1 >销售顾问签名：________________</td>");
		sTemp.append("   </tr>");
		sTemp.append("</table>");
		//end 
		
		sTemp.append("<table  style='border:1px;' width='690' align=center>");
		sTemp.append("<tr>");   
		sTemp.append("<td style='border:0px;text-align:center; font-size: 15pt;FONT-FAMILY:宋体;FONT-WEIGHT: bolder;color:black;background-color:white' colspan=6>手机“佰保袋”限额延保服务合同<br/></td>");
		sTemp.append("</tr>");
		//sTemp.append("<tr><td colspan=6 style='border:0px;'>&nbsp;</td></tr>");
		sTemp.append("</table>");
		

		sTemp.append("<table  width='690' align=center>");
		 sTemp.append("<tr>");
		 sTemp.append("<td style='border:0px;text-align:left; font-size: 9pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black; colspan=5 '>顾客姓名:<u>&nbsp;&nbsp;&nbsp;&nbsp;"+sCustomerName+"&nbsp;&nbsp;&nbsp;&nbsp;</u></td>");
		 sTemp.append("<td style='border:0px;text-align:left; font-size: 9pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black; colspan=5 '>串号:<u>&nbsp;&nbsp;&nbsp;&nbsp;"+sMobile_serial_number+"&nbsp;&nbsp;&nbsp;&nbsp;</u></td>");
		 sTemp.append("<td style='border:0px;text-align:left; font-size: 9pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black; colspan=5 '>合同号:<u>&nbsp;&nbsp;&nbsp;"+sObjectNo+"&nbsp;&nbsp;&nbsp;</u></td>");
		 sTemp.append("</tr>");
		 sTemp.append("<tr>");
		 sTemp.append("<td style='border:0px;text-align:left; font-size: 9pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black; colspan=5 '>手机品牌:<u>&nbsp;&nbsp;&nbsp;&nbsp;"+sBrandType1+"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</u></td>");
		 sTemp.append("<td style='border:0px;text-align:left; font-size: 9pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black; colspan=5 '>手机型号:<u>&nbsp;&nbsp;&nbsp;&nbsp;"+sManufacturer1+"&nbsp;&nbsp;&nbsp;&nbsp;</u></td>");
		 sTemp.append("<td style='border:0px;text-align:left; font-size: 9pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black; colspan=5 '>购机价格:<u>&nbsp;&nbsp;&nbsp;&nbsp;"+sPrice1+"&nbsp;&nbsp;&nbsp;&nbsp;</u>元</td>");
		 sTemp.append("</tr>");
		 sTemp.append("<tr>");
		 sTemp.append("<td style='border:0px;text-align:left; font-size: 9pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black; colspan=5 '>延保价格:<u>&nbsp;&nbsp;&nbsp;"+sPrice2+"&nbsp;&nbsp;&nbsp;</u>元</td>");
		 sTemp.append("<td style='border:0px;text-align:left; font-size: 9pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black; colspan=5 '>购买日期:<u>&nbsp;&nbsp;"+sDate+"&nbsp;&nbsp;</u></td>");
		 sTemp.append("<td style='border:0px;text-align:left; font-size: 9pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black; colspan=5 '>延保期限:<u>&nbsp;&nbsp;&nbsp;&nbsp;"+sServeyear+"&nbsp;&nbsp;&nbsp;&nbsp;</u>年期</td>");
		 sTemp.append("</tr>");
		 sTemp.append("</table>");

		sTemp.append("<table  width='690' align=center>");
		sTemp.append("<tr><td style='border:0px;text-align:left; font-size: 9pt;FONT-FAMILY:宋体;FONT-WEIGHT: normal;color:black;>&nbsp;</td></tr>");
		sTemp.append("<tr><td style='border:0px;text-align:left; font-size: 9pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black; colspan=6 colspan=6 style='border:0px; '>&nbsp;&nbsp;&nbsp;本手机“佰保袋”服务（以下简称“服务”）是"+sProvider_name+"本着平等互利、公平自愿的原则，在您的手机发生意外事故导致屏幕碎裂时，为您的手机提供维修保障服务。</td></tr>");
		sTemp.append("<tr><td style='border:0px;text-align:left; font-size: 9pt;FONT-FAMILY:宋体;FONT-WEIGHT: normal;color:black; colspan=6 colspan=6 style='border:0px;'>&nbsp;&nbsp;&nbsp;具体服务条款如下：</td></tr>");
		sTemp.append("<tr><td style='border:0px;text-align:left; font-size: 9pt;FONT-FAMILY:宋体;FONT-WEIGHT: normal;color:black; colspan=6 colspan=6 style='border:0px;'><b>第一条：定义</b></td></tr>");
		sTemp.append("<tr><td style='border:0px;text-align:left; font-size: 9pt;FONT-FAMILY:宋体;FONT-WEIGHT: normal;color:black; colspan=6 colspan=6 style='border:0px;'>1.服务：系指本手机碎屏保修服务。</td></tr>");
		sTemp.append("<tr><td style='border:0px;text-align:left; font-size: 9pt;FONT-FAMILY:宋体;FONT-WEIGHT: normal;color:black; colspan=6 colspan=6 style='border:0px;'>2.商品：系指您购买的属于本“佰保袋”服务范围的手机。</td></tr>");
		
		sTemp.append("<tr><td style='border:0px;text-align:left; font-size: 9pt;FONT-FAMILY:宋体;FONT-WEIGHT: normal;color:black; colspan=6 colspan=6 style='border:0px;'><b>第二条：适用手机</b></td></tr>");
		sTemp.append("<tr><td style='border:0px;text-align:left; font-size: 9pt;FONT-FAMILY:宋体;FONT-WEIGHT: normal;color:black; colspan=6 colspan=6 style='border:0px;'>&nbsp;&nbsp;&nbsp;本合同适用于（1）中国大陆销售的具备中华人民共和国工业和信息化部颁发的入网许可证的；且（2）通过与佰仟金融、信托公司签订贷款协议分期购买的手机。</td></tr>");
		sTemp.append("<tr><td style='border:0px;text-align:left; font-size: 9pt;FONT-FAMILY:宋体;FONT-WEIGHT: normal;color:black; colspan=6 colspan=6 style='border:0px;'><b>第三条：保修服务范围：</b></td></tr>");
		sTemp.append("<tr><td style='border:0px;text-align:left; font-size: 9pt;FONT-FAMILY:宋体;FONT-WEIGHT: normal;color:black; colspan=6 colspan=6 style='border:0px;'>&nbsp;&nbsp;&nbsp;在本服务有效期内，您的手机发生<b>因意外碰撞或跌损导致屏幕碎裂时，在符合本合同约定的情形内，我们承担责任限额内的维修费用，为您提供一次屏幕维修或屏幕更换的保修服务（仅限一次，因维修更换所产生的旧零部件的所有权归维修服务提供商所有）</b>, 以确保您的手机屏幕恢复正常使用状态。<b>若您的手机仍在原厂保修期内，我们为您提供屏幕修复服务后，我们不承诺该手机仍享受原厂保修服务。</b></td></tr>");
		sTemp.append("<tr><td style='border:0px;text-align:left; font-size: 9pt;FONT-FAMILY:宋体;FONT-WEIGHT: normal;color:black; colspan=6 colspan=6 style='border:0px;'><b>第四条：报修流程：</b></td></tr>");
		sTemp.append("<tr><td style='border:0px;text-align:left; font-size: 9pt;FONT-FAMILY:宋体;FONT-WEIGHT: normal;color:black; colspan=6 colspan=6 style='border:0px;'>&nbsp;&nbsp;&nbsp;当手机发生本服务项规定的保修范围内的故障时，您需要致电服务热线"+sService_tel+"，以获得热线服务人员的协助与服务。您需要提供：姓名、联系电话、地址、手机品牌及型号、手机串号、故障等我们所需要的信息，且<b>维修时还需提供本服务合同，</b>以便更快捷地为您提供服务（如您的手机在厂保期间经过厂家处理过导致串号有变动的，您需要提供维修工单或换机单等有效凭证，方可享受正常的延保服务）。</td></tr>");
		sTemp.append("<tr><td style='border:0px;text-align:left; font-size: 9pt;FONT-FAMILY:宋体;FONT-WEIGHT: normal;color:black; colspan=6 colspan=6 style='border:0px;'><b>第五条：责任限额</b></td></tr>");
		sTemp.append("<tr><td style='border:0px;text-align:left; font-size: 9pt;FONT-FAMILY:宋体;FONT-WEIGHT: normal;color:black; colspan=6 colspan=6 style='border:0px;'>&nbsp;&nbsp;&nbsp;本服务有效期内，我们承担一次换屏或维修屏幕费用总额不超过人民币壹仟伍佰（1500）元。</td></tr>");

	 	sTemp.append("<tr><td style='border:0px;text-align:left; font-size: 9pt;FONT-FAMILY:宋体;FONT-WEIGHT: normal;color:black; colspan=6 colspan=6 style='border:0px;'><b>第六条： 除外条款</b></td></tr>");
		sTemp.append("<tr><td style='border:0px;text-align:left; font-size: 9pt;FONT-FAMILY:宋体;FONT-WEIGHT: normal;color:black; colspan=6 colspan=6 style='border:0px;'><b>&nbsp;&nbsp;&nbsp;本服务不包含以下情况导致的维修、服务或损失：</b></td></tr>");
		sTemp.append("<tr><td style='border:0px;text-align:left; font-size: 9pt;FONT-FAMILY:宋体;FONT-WEIGHT: normal;color:black; colspan=6 colspan=6 style='border:0px;'><b><ol><li>手机因进液、自身电性能故障等原因导致的损坏。<br/></li>"
		+"<li>盗窃、抢劫、遗忘、失踪或丢弃。<br/></li>"
		+"<li>属于厂家保修范围内的手机故障，以及手机的日常保养、检修、清洁、外部调节。<br/></li>"
		+"<li>手机外壳、装饰性部件、附加配件（包括电池、耳机、充电器、数据线等）或者耗材（包括存储卡等）。<br/></li>"
		+"<li>不可抗力（包括但不限于地震、雷电、洪灾、火灾、战争等）、交通意外（如车辆碾压等）、人身伤害等。<br/></li>"
		+"<li>手机串号的涂改或缺失，或手机主板变形、扭曲、断裂、主板IC元器件断裂或缺失。<br/></li>"
		+"<li>因手机故障而导致的任何信息或数据丢失及其间接损失或附带损失（包括但不限于无法使用、业务损失、利润损失、数据损失、故障时间损失及误工费）和责任。<br/></li>"
		+"<li>编造虚假的故障原因或因将该手机用于租赁、出借给他人使用造成手机故障的。<br/></li>"
		+"<li>不影响手机屏幕使用功能的外观划痕、磨损或色料物附着。<br/></li></ol></b></td></tr>");
		
		sTemp.append("<tr><td style='border:0px;text-align:left; font-size: 9pt;FONT-FAMILY:宋体;FONT-WEIGHT: normal;color:black; colspan=6 colspan=6 style='border:0px;'><b>第七条： 本服务的有效期：</b></td></tr>"); 
		sTemp.append("<tr><td style='border:0px;text-align:left; font-size: 9pt;FONT-FAMILY:宋体;FONT-WEIGHT: normal;color:black; colspan=6 colspan=6 style='border:0px;'>&nbsp;&nbsp;1、生效日期：购买本“佰保袋”服务之日起15天后开始生效。</td></tr>");
		sTemp.append("<tr><td style='border:0px;text-align:left; font-size: 9pt;FONT-FAMILY:宋体;FONT-WEIGHT: normal;color:black; colspan=6 colspan=6 style='border:0px;'>&nbsp;&nbsp;2、终止日期：购买本“佰保袋”服务之日起顺延1年（一年期）/ 2年（两年期）之零时止。</td></tr>");
		sTemp.append("<tr><td style='border:0px;text-align:left; font-size: 9pt;FONT-FAMILY:宋体;FONT-WEIGHT: normal;color:black; colspan=6 colspan=6 style='border:0px;'><b>第八条：</b>本服务有效期内，发生延保服务范围内的故障时，如总维修费（包含配件费用、快递费用及劳务费）未超出服务限额的金额，您无需支付任何费用，如总费用超出限额部分需要你自行承担。本服务不支持单独退货，如所您购买商品因厂保故障或其他原因退货的，本合同也一起解除。</td></tr>");
		sTemp.append("<tr><td style='border:0px;text-align:left; font-size: 9pt;FONT-FAMILY:宋体;FONT-WEIGHT: normal;color:black; colspan=6 colspan=6 style='border:0px;'><b>第九条： 本服务的终止：</b></td></tr>");
		sTemp.append("<tr><td style='border:0px;text-align:left; font-size: 9pt;FONT-FAMILY:宋体;FONT-WEIGHT: normal;color:black; colspan=6 colspan=6 style='border:0px;'>&nbsp;&nbsp;&nbsp;有下列情形之一的，本佰保袋服务自然终止：</td></tr>");
		sTemp.append("<tr><td style='border:0px;text-align:left; font-size: 9pt;FONT-FAMILY:宋体;FONT-WEIGHT: normal;color:black; colspan=6 colspan=6 style='border:0px;'>1.	已达到本合同约定的延保有效期或合同有效期内手机已享受一次屏幕更换或维修服务的（但您仍需归还贷款协议约定的款项）。<br/>"
		+"2.	您的商品非经由我们或同品牌厂家授权的维修机构进行修理或置换的。<br/>"
		+"3.	若您故意损坏手机或编造虚假故障理由以骗取我们免费维修的，一经证实，我们有权立即解除本服务，并不退还已收取的延保服务费，且有权要求您补偿已经发生的维修费用及其它相关费用，包括但不限于零部件成本、工时费用、物流费用。</td></tr>");
		
		sTemp.append("<tr><td style='border:0px;text-align:left; font-size: 9pt;FONT-FAMILY:宋体;FONT-WEIGHT: normal;color:black; colspan=6 colspan=6 style='border:0px;'><b>第十条 争议处理：</b></td></tr>");
		sTemp.append("<tr><td style='border:0px;text-align:left; font-size: 9pt;FONT-FAMILY:宋体;FONT-WEIGHT: normal;color:black; colspan=6 colspan=6 style='border:0px;'>&nbsp;&nbsp;&nbsp;本服务在执行过程中存在争议的，双方可友好协商解决，经友好协商仍未能达成一致的，双方均可提请深圳仲裁委员会仲裁。</td></tr>");
		sTemp.append("<tr><td style='border:0px;text-align:left; font-size: 9pt;FONT-FAMILY:宋体;FONT-WEIGHT: normal;color:black; colspan=6 colspan=6 style='border:0px;'><b>顾客声明：顾客确认已经认真阅读并完全理解本合同中的各项条款，且对合同中免除和限制其责任的条款已收到提醒注意和特别说明。</b></td></tr>");
		
		sTemp.append("<tr><td style='border:0px;text-align:left; font-size: 9pt;FONT-FAMILY:宋体;FONT-WEIGHT: normal;color:black; colspan=6 colspan=6 style='border:0px;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"
		+"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<b>顾客（签名）：  </b></td></tr>");	
		sTemp.append("<tr><td style='border:0px;text-align:left; font-size: 8pt;FONT-FAMILY:宋体;FONT-WEIGHT: normal;color:black; colspan=6 colspan=6 style='border:0px;'>版本号："+sVersion+"</td></tr>");	


		sTemp.append("</table>");	
		sTemp.append("</div>");	
		sTemp.append("<input type='hidden' name='Method' value='1'>");
		sTemp.append("<input type='hidden' name='SerialNo' value='"+sSerialNo+"'>");
		sTemp.append("<input type='hidden' name='ObjectNo' value='"+sObjectNo+"'>");
		sTemp.append("<input type='hidden' name='ObjectType' value='"+sObjectType+"'>");
		sTemp.append("<input type='hidden' name='Rand' value=''>");
		sTemp.append("<input type='hidden' name='CompClientID' value='"+CurComp.getClientID()+"'>");
		sTemp.append("<input type='hidden' name='PageClientID' value='"+CurPage.getClientID()+"'>");
		sTemp.append("</form>");	
			

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
