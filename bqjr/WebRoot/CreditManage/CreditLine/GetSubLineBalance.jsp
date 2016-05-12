<%@ page contentType="text/html; charset=GBK"%>
<%@ page import="com.amarsoft.app.creditline.bizlets.*"%>
<%@ page import="com.amarsoft.biz.bizlet.Bizlet"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info00;Describe=注释区;]~*/%>
	<%
	/*
		Author: hwang 2009-06-22
		Tester:
		Describe: 取子额度余额
		Input Param:
			LineNo:额度协议号(额度的合同流水号)
			BusinessType:业务类型
		Output Param:
		
		HistoryLog:
			
	 */
	%>
<%/*~END~*/%> 


<% 
	//获得参数：申请流水号、对象类型、对象编号、客户类型、客户ID
	String sLineNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("LineNo"));
	String sBusinessType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("BusinessType"));
	String sSql="";
	double dLineBalance = 0.0;//额度余额
	double dSubLineBalance=0.0;//子额度余额
	double dLineAvailableBalance=0.0;//额度指定业务类型可用金额
	//将空值转化成空字符串
	if(sLineNo == null) sLineNo = "";
	if(sBusinessType == null) sBusinessType = "";
	
	//取额度余额
	Bizlet bzGetCreditLineBalance = new GetCreditLineBalance();
	bzGetCreditLineBalance.setAttribute("LineNo",sLineNo);
	String sCreditBalance=(String)bzGetCreditLineBalance.run(Sqlca);
	dLineBalance = Double.valueOf(sCreditBalance).doubleValue();
	//取子额度余额
	Bizlet bzGetCreditSubLineBalance = new GetCreditSubLineBalance();
	bzGetCreditSubLineBalance.setAttribute("LineNo",sLineNo);
	bzGetCreditSubLineBalance.setAttribute("BusinessType",sBusinessType);
	String sSubCreditBalance=(String)bzGetCreditSubLineBalance.run(Sqlca);
	//拆分返回值，子额度余额&子额度币种
	if(sSubCreditBalance !=null && sSubCreditBalance.indexOf("&") <0){//没有分配当前对象对应的业务类型子额度
		dLineAvailableBalance=dLineBalance;//子额度余额=额度余额
	}else{
		String[] sSubCreditBalances = sSubCreditBalance.split("&");
		//子额度余额
		if(sSubCreditBalances[0]==null || sSubCreditBalances[0].length() ==0){
			dSubLineBalance=0;
		}else{
			dSubLineBalance = Double.valueOf(sSubCreditBalances[0]).doubleValue();
		}
		if(dSubLineBalance<=dLineBalance){
			dLineAvailableBalance = dSubLineBalance;
		}else{
			dLineAvailableBalance = dLineBalance;
		}
	}
	
	if((dLineAvailableBalance<0)){
		dLineAvailableBalance = 0;	
	}
%>
<html>
<body bgcolor="#EAEAEA" >
<table align="center">
	<tr>
		<td><font size='5' color='blue'>子额度余额</font></td>
	</tr>
</table></br>
<table border="0" width="100%" id="table1" cellspacing="0" cellpadding="0" bordercolordark="#000000">	
	<tr>
		<td width="250">[<%=Sqlca.getString(new SqlObject("select TypeName from Business_Type where TypeNo=:TypeNo").setParameter("TypeNo",sBusinessType)) %>]业务类型子额度余额：</td>
		<td><%=DataConvert.toMoney(dLineAvailableBalance)%></td>
	</tr>	
</table><br><br>
<table valign="bottom" width="100%" border="0" cellspacing="0" cellpadding="3"  bordercolordark="#FFFFFF">
		<tr>
			<td align = center> 
		    	<input type="button" style="width:50px"  value=" 关  闭 " class="button" onclick="javascipt: self.close();">
		    </td>
	    </tr>
</table>
</body>
</html>
<%@ include file="/IncludeEnd.jsp"%>