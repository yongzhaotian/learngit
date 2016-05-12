<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>
<%@page import="com.amarsoft.app.accounting.product.ProductManage"%>
<%@page import="com.amarsoft.app.accounting.config.loader.ProductConfig"%>
<%
	//产品编号
	String objectNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectNo"));	
	if(objectNo == null) objectNo = "";
	String objectType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectType"));	
	if(objectType == null) objectType = "";
	String transSerialNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("TransSerialNo"));	
	if(transSerialNo == null) transSerialNo = "";
	
	//权限判断
	String disable = "";
	String display = "";
	String rightType = CurComp.getAttribute("RightType");
	if("ReadOnly".equals(rightType))
	{
		disable = " disabled = true ";
		display = "display:none;";
	}
	
	//入账机构
	String accountingOrgID = "";
	String accountingOrgName = "";
	String currency = "";
	
	AbstractBusinessObjectManager bom=new DefaultBusinessObjectManager(Sqlca);
	if(!"".equals(objectNo) && !"".equals(objectType))
	{
		BusinessObject bo = bom.loadObjectWithKey(objectType, objectNo);
		BusinessObject accountBo = bom.loadObjectWithKey(bo.getString("ObjectType"), bo.getString("ObjectNo"));
		accountingOrgID = accountBo.getString("AccountingOrgID");
		ASOrg ao = new ASOrg(accountingOrgID,Sqlca);
		accountingOrgName = ao.getOrgName();
		currency = accountBo.getString("Currency");
	}
	
	//已填写的会计分录
	ArrayList<BusinessObject> lsbo = new ArrayList<BusinessObject>();
	ASResultSet rs = Sqlca.getASResultSet(new SqlObject("select ACCT_SUBLEDGER_DETAIL.*,getOrgName(ACCT_SUBLEDGER_DETAIL.AccountingOrgID) as AccountingOrgName from ACCT_SUBLEDGER_DETAIL where ObjectNo = :ObjectNo and ObjectType = :ObjectType order by SerialNo asc").setParameter("ObjectNo",objectNo).setParameter("ObjectType",objectType));
	while(rs.next()){
		BusinessObject bo = new BusinessObject(BUSINESSOBJECT_CONSTATNTS.subledger_detail,rs.getRS());
		bo.setAttributeValue("AccountingOrgName", rs.getString("AccountingOrgName"));
		lsbo.add(bo);
	}
	rs.getStatement().close();
	
%>
<html> 
<head>
<title></title>
</head>
<body class=pagebackground leftmargin="0" topmargin="0" >
<div id="Layer1" style="position:absolute;width:99.9%; height:99.9%; z-index:1; overflow: auto">
<table align='left' width='90%'  cellspacing="4" cellpadding="0">


<%
	int row = 0;
	for(;row < lsbo.size()+4;row++)
	{
		
		String tabDisplay = "",imgDisplay="";
		if(row > lsbo.size())
		{
			tabDisplay = "display:none";
		}
		if(row >= lsbo.size())
		{
			imgDisplay = "display:none";
		}
			
		if(row!=0)
		{
%>
 <tr id="TRTR<%= row%>" style="<%=tabDisplay%>"> 
    <td colspan="4"> 
    </td>
  </tr>
 <%
		}
 %>
   <tr id="TRCR<%= row%>" style="<%=tabDisplay%>"> 
	<%
		if(row<lsbo.size())
		{
			BusinessObject bo = lsbo.get(row);
			
			//获取借贷方向
			StringBuffer itemDirectionOptions = new StringBuffer();
			itemDirectionOptions.append("<option  value=''></option>");
			com.amarsoft.dict.als.object.Item[] items = com.amarsoft.dict.als.cache.CodeCache.getItems("Ctrldir");
			for(com.amarsoft.dict.als.object.Item item:items)
			{
				if("B".equals(item.getItemNo())) continue;
				if(item.getItemNo().equals(bo.getString("Direction")))
					itemDirectionOptions.append("<option  value='"+item.getItemNo()+"' selected>"+item.getItemName()+"</option>");
				else
					itemDirectionOptions.append("<option  value='"+item.getItemNo()+"'>"+item.getItemName()+"</option>");
			}
			
			//币种
			StringBuffer itemCurrencyOptions = new StringBuffer();
			itemCurrencyOptions.append("<option  value=''></option>");
			items = com.amarsoft.dict.als.cache.CodeCache.getItems("Currency");
			for(com.amarsoft.dict.als.object.Item item:items)
			{
				if(item.getItemNo().equals(bo.getString("Currency")))
					itemCurrencyOptions.append("<option  value='"+item.getItemNo()+"' selected>"+item.getItemName()+"</option>");
				else
					itemCurrencyOptions.append("<option  value='"+item.getItemNo()+"'>"+item.getItemName()+"</option>");
			}
			//账务科目
			StringBuffer itemAccountCodeNoOptions = new StringBuffer();
			itemAccountCodeNoOptions.append("<option  value=''></option>");
			items = com.amarsoft.dict.als.cache.CodeCache.getItems("AccountCodeConfig");
			for(com.amarsoft.dict.als.object.Item item:items)
			{
				if(!com.amarsoft.app.accounting.config.loader.AccountCodeConfig.accountcode_type_n.equals(item.getBankNo())) continue;
				if(item.getItemNo().equals(bo.getString("AccountCodeNo")))
					itemAccountCodeNoOptions.append("<option  value='"+item.getItemNo()+"' selected>"+item.getItemName()+"</option>");
				else
					itemAccountCodeNoOptions.append("<option  value='"+item.getItemNo()+"'>"+item.getItemName()+"</option>");
			}
			
			String debitDisplay = "";
			String creditDisplay = "";
			if("C".equals(bo.getString("Direction")) || "P".equals(bo.getString("Direction")))
			{
				debitDisplay = "display:none;";
			}
			else
			{
				creditDisplay = "display:none;";
			}
	%>
		<td style=' text-align: center; WIDTH: 2%;'>
			<img class="btn_icon_delete" border=0 id="IMGDR<%=row%>" onClick=deleteTab(<%=row%>) style='CURSOR: hand;<%=display %>' width='15' height='15'/>
			<img class="btn_icon_add"  id="IMGAR<%=row%>" border=0  onClick=addTab(<%=row%>) style='CURSOR: hand; display:none;' width='15' height='15'/>
		</td>
	    <td>
	    	<div id = "DIVR<%= row%>" style=' WIDTH: 100%; <%=imgDisplay%>'> 
				<table class='conditionmap' width='100%' align='left' border='0' cellspacing='0' cellpadding='4' bordercolordark="#FFFFFF" bordercolorlight="#666666">
				<tr>
					<td colSpan=1 style="text-align: center; ">
						<INPUT class=fftdinput type=hidden  value="<%=bo.getString("SerialNo")%>" id="SerialNoR<%=row%>"/>
				 		<INPUT class=fftdinput type=hidden  value="<%=bo.getString("TransSerialNo")%>" id="TransSerialNoR<%=row%>"/>
				 		<INPUT class=fftdinput type=hidden  value="<%=bo.getString("SubLegderSerialNo")%>" id="SubLegderSerialNoR<%=row%>"/>
				 		<INPUT class=fftdinput type=hidden  value="<%=bo.getString("ObjectType")%>" id="ObjectTypeR<%=row%>"/>
				 		<INPUT class=fftdinput type=hidden  value="<%=bo.getString("ObjectNo")%>" id="ObjectNoR<%=row%>"/>
				 		<INPUT class=fftdinput type=hidden  value="<%=bo.getString("BookType")%>" id="BookTypeR<%=row%>"/>
				 		<INPUT class=fftdinput type=hidden  value="<%=bo.getString("LDStatus")%>" id="LDStatusR<%=row%>"/>
					</td>
					<td colSpan=1 style="text-align: center; ">
						<div id=DirectionBeforeR<%=row%> style='<%=creditDisplay %>'><font>&nbsp;&nbsp;&nbsp;&nbsp;</font></div>
					</td>
					<td colSpan=1 style="text-align: center; ">
						<SELECT id="DirectionR<%=row%>" class=fftdselect <%=disable %> onchange=ChangeValue(<%=row%>)>
							<%= itemDirectionOptions.toString()%>
						</SELECT>
					</td>
					<td colSpan=1 style="text-align: center; ">
						<SELECT id="CurrencyR<%=row%>" class=fftdselect disabled=true onchange=ChangeValue(<%=row%>)>
							<%= itemCurrencyOptions.toString()%>
						</SELECT>
					</td>
					<td colSpan=1 style="text-align: center; ">
						<INPUT class=fftdinput type=hidden  value="<%=bo.getString("AccountingOrgID")%>" id="AccountingOrgIDR<%=row%>"/>
						<INPUT class=fftdinput type=text  <%=disable %>  style="BACKGROUND: #efefef; COLOR: black; BORDER-TOP-STYLE: groove; BORDER-RIGHT-STYLE: groove; BORDER-LEFT-STYLE: groove; BORDER-BOTTOM-STYLE: groove; WIDTH:100px;" readOnly value="<%=bo.getString("AccountingOrgName")%>" id="AccountingOrgNameR<%=row%>"/>
					</td>
					<td colSpan=1 style="text-align: center; ">
						<font color='#00659C' >科目</font>
						<SELECT id="AccountCodeNoR<%=row%>" class=fftdselect <%=disable %>  onchange=ChangeValue(<%=row%>)>
							<%= itemAccountCodeNoOptions.toString()%>
						</SELECT>
					</td>
					<td colSpan=1 style="text-align: center; ">
						<font color='#00659C' >发生额</font>
						<INPUT class=fftdinput type=text  onchange=ChangeValue(<%=row%>) <%=disable %> style="text-align: right;<%=debitDisplay %>" value="<%=DataConvert.toMoney(bo.getMoney("DebitAmt"))%>" id="DebitAmtR<%=row%>"/>
						<INPUT class=fftdinput type=text  onchange=ChangeValue(<%=row%>) <%=disable %> style="text-align: right;<%=creditDisplay %>" value="<%=DataConvert.toMoney(bo.getMoney("CreditAmt"))%>" id="CreditAmtR<%=row%>"/>
					</td>
					<td colSpan=1 style="text-align: center; ">
						<font color='#00659C' >注释</font>
						<INPUT class=fftdinput type=text  onchange=ChangeValue(<%=row%>) <%=disable %> style="COLOR: black; BORDER-TOP-STYLE: groove; BORDER-RIGHT-STYLE: groove; BORDER-LEFT-STYLE: groove; BORDER-BOTTOM-STYLE: groove; WIDTH:250px;" value="<%=DataConvert.toString(bo.getString("Description"))%>" id="DescriptionR<%=row%>" />
					</td>
				</tr>
				</table>
			</div>
	    </td>
	<%
		}
		else
		{
			//获取借贷方向
			StringBuffer itemDirectionOptions = new StringBuffer();
			itemDirectionOptions.append("<option  value=''></option>");
			com.amarsoft.dict.als.object.Item[] items = com.amarsoft.dict.als.cache.CodeCache.getItems("Ctrldir");
			for(com.amarsoft.dict.als.object.Item item:items)
			{
				if("B".equals(item.getItemNo())) continue;
				itemDirectionOptions.append("<option  value='"+item.getItemNo()+"'>"+item.getItemName()+"</option>");
			}
			
			//币种
			StringBuffer itemCurrencyOptions = new StringBuffer();
			itemCurrencyOptions.append("<option  value=''></option>");
			items = com.amarsoft.dict.als.cache.CodeCache.getItems("Currency");
			for(com.amarsoft.dict.als.object.Item item:items)
			{
				if(item.getItemNo().equals(currency))
					itemCurrencyOptions.append("<option  value='"+item.getItemNo()+"' selected>"+item.getItemName()+"</option>");
				else
					itemCurrencyOptions.append("<option  value='"+item.getItemNo()+"'>"+item.getItemName()+"</option>");
			}
			//账务科目
			StringBuffer itemAccountCodeNoOptions = new StringBuffer();
			itemAccountCodeNoOptions.append("<option  value=''></option>");
			items = com.amarsoft.dict.als.cache.CodeCache.getItems("AccountCodeConfig");
			for(com.amarsoft.dict.als.object.Item item:items)
			{
				if(!com.amarsoft.app.accounting.config.loader.AccountCodeConfig.accountcode_type_n.equals(item.getBankNo())) continue;
				itemAccountCodeNoOptions.append("<option  value='"+item.getItemNo()+"'>"+item.getItemName()+"</option>");
			}
			
			String debitDisplay = "";
			String creditDisplay = "display:none;";
	%>
		<td style=' text-align: center; WIDTH: 2%;'>
			<img class="btn_icon_delete" id="IMGDR<%=row%>" border=0 onClick=deleteTab(<%=row%>) style='CURSOR: hand;display:none;' width='15' height='15'/>
			<img class="btn_icon_add"  id="IMGAR<%=row%>" border=0  onClick=addTab(<%=row%>) style='CURSOR: hand;<%=display %>' width='15' height='15'/>
		</td>
		<td>
	    	<div id = "DIVR<%= row%>" style=' WIDTH: 100%; <%=imgDisplay%>'> 
				<table class='conditionmap' width='100%' align='left' border='0' cellspacing='0' cellpadding='4' bordercolordark="#FFFFFF" bordercolorlight="#666666">
				<tr>
					<td colSpan=1 style="text-align: center; ">
						<INPUT class=fftdinput type=hidden  value="" id="SerialNoR<%=row%>"/>
				 		<INPUT class=fftdinput type=hidden  value="<%=transSerialNo %>" id="TransSerialNoR<%=row%>"/>
				 		<INPUT class=fftdinput type=hidden  value="" id="SubLegderSerialNoR<%=row%>"/>
				 		<INPUT class=fftdinput type=hidden  value="<%=objectType %>" id="ObjectTypeR<%=row%>"/>
				 		<INPUT class=fftdinput type=hidden  value="<%=objectNo %>" id="ObjectNoR<%=row%>"/>
				 		<INPUT class=fftdinput type=hidden  value="N" id="BookTypeR<%=row%>"/>
				 		<INPUT class=fftdinput type=hidden  value="0" id="LDStatusR<%=row%>"/>
					</td>
					<td colSpan=1 style="text-align: center; ">
						<div id=DirectionBeforeR<%=row%> style='display:none;'><font>&nbsp;&nbsp;&nbsp;&nbsp;</font></div>
					</td>
					<td colSpan=1 style="text-align: center; ">
						<SELECT id="DirectionR<%=row%>" class=fftdselect <%=disable %> onchange=ChangeValue(<%=row%>)>
							<%= itemDirectionOptions.toString()%>
						</SELECT>
					</td>
					<td colSpan=1 style="text-align: center; ">
						<SELECT id="CurrencyR<%=row%>" class=fftdselect disabled=true style="BACKGROUND: #efefef; COLOR: black; BORDER-TOP-STYLE: groove; BORDER-RIGHT-STYLE: groove; BORDER-LEFT-STYLE: groove; BORDER-BOTTOM-STYLE: groove;" readOnly onchange=ChangeValue(<%=row%>)>
							<%= itemCurrencyOptions.toString()%>
						</SELECT>
					</td>
					<td colSpan=1 style="text-align: center; ">
						<INPUT class=fftdinput type=hidden  value="<%=accountingOrgID%>" id="AccountingOrgIDR<%=row%>"/>
						<INPUT class=fftdinput type=text  <%=disable %> style="BACKGROUND: #efefef; COLOR: black; BORDER-TOP-STYLE: groove; BORDER-RIGHT-STYLE: groove; BORDER-LEFT-STYLE: groove; BORDER-BOTTOM-STYLE: groove; WIDTH:100px;" readOnly value="<%=accountingOrgName%>" id="AccountingOrgNameR<%=row%>"/>
					</td>
					<td colSpan=1 style="text-align: center; ">
						<font color='#00659C' >科目</font>
						<SELECT id="AccountCodeNoR<%=row%>" class=fftdselect <%=disable %> onchange=ChangeValue(<%=row%>)>
							<%= itemAccountCodeNoOptions.toString()%>
						</SELECT>
					</td>
					<td colSpan=1 style="text-align: center; ">
						<font color='#00659C' >发生额</font>
						<INPUT class=fftdinput type=text  onchange=ChangeValue(<%=row%>)  <%=disable %> style="text-align: right;<%=debitDisplay %>" value="" id="DebitAmtR<%=row%>"/>
						<INPUT class=fftdinput type=text  onchange=ChangeValue(<%=row%>)  <%=disable %> style="text-align: right;<%=creditDisplay %>" value="" id="CreditAmtR<%=row%>"/>
					</td>
					<td colSpan=1 style="text-align: center; ">
						<font color='#00659C' >注释</font>
						<INPUT class=fftdinput type=text  onchange=ChangeValue(<%=row%>) <%=disable %> style="COLOR: black; BORDER-TOP-STYLE: groove; BORDER-RIGHT-STYLE: groove; BORDER-LEFT-STYLE: groove; BORDER-BOTTOM-STYLE: groove; WIDTH:250px;" value="" id="DescriptionR<%=row%>"/>
					</td>
				</tr>
				</table>
			</div>
	    </td>
	<%
		}
	%>
  </tr>

<%
	}
%>

</table>
</div>
</body>
</html>

<script language="javascript">
	//添加记录
	function addTab(row)
	{
		try
		{
			var tr = document.all.item("TRCR"+parseInt(row+1));	
			tr.style.display = "";
			var tr = document.all.item("DIVR"+parseInt(row));
			tr.style.display = "";
			var tr = document.all.item("TRTR"+parseInt(row+1));
			tr.style.display = "";
			var tr = document.all.item("IMGDR"+parseInt(row));
			tr.style.display = "";
			var tr = document.all.item("IMGAR"+parseInt(row));
			tr.style.display = "none";
		}catch(e)
		{
			reLoad();
		}
		
		var serialNo = getSerialNo("ACCT_SUBLEDGER_DETAIL","SerialNo","");
		document.getElementById("SerialNoR"+row).value=serialNo;
		var transSerialNo = document.getElementById("TransSerialNoR"+row).value;
		var objectType = document.getElementById("ObjectTypeR"+row).value;
		var objectNo = document.getElementById("ObjectNoR"+row).value;
		var bookType = document.getElementById("BookTypeR"+row).value;
		var ldStatus = document.getElementById("LDStatusR"+row).value;
		var currency = document.getElementById("CurrencyR"+row).value;
		var accountingOrgID = document.getElementById("AccountingOrgIDR"+row).value;
		var i = RunMethod("LoanAccount","InsertLedgerDetail",serialNo+","+transSerialNo+","+objectType+","+objectNo+","+bookType+","+ldStatus+","+accountingOrgID+","+currency);
	}
	
	//删除记录
	function deleteTab(row)
	{
		if(!confirm("确定删除吗?"))return;
		var serialno = document.getElementById("SerialNoR"+row).value;
		if(typeof(serialno) == "undefined" || serialno.length == 0)
			return;
		var i = RunMethod("LoanAccount","DeleteLedgerDetail",serialno); 
		if(parseInt(i)==1)
		{
			var tr = document.all.item("TRCR"+row);	
			tr.style.display = "none";
			var tr = document.all.item("TRTR"+row);	
			if(tr != null) tr.style.display = "none";
			var tr = document.all.item("DIVR"+row);	
			tr.style.display = "none";
		}
	}
	
	//改变记录
	function ChangeValue(row)
	{
		var direction = document.getElementById("DirectionR"+row).value;
		if(typeof(direction) == "undefined" || direction.length == 0) return;
		if(direction == "D" || direction == "R")
		{
			var obj = document.all.item("DirectionBeforeR"+row);
			if(obj != null) obj.style.display = "none";
			var obj = document.all.item("DebitAmtR"+row);
			if(obj != null) obj.style.display = "";
			var obj = document.all.item("CreditAmtR"+row);
			if(obj != null){
				obj.style.display = "none";
				obj.value = "";
			}
		}
		else
		{
			var obj = document.all.item("DirectionBeforeR"+row);
			if(obj != null) obj.style.display = "";
			var obj = document.all.item("CreditAmtR"+row);
			if(obj != null) obj.style.display = "";
			var obj = document.all.item("DebitAmtR"+row);
			if(obj != null){
				obj.style.display = "none";
				obj.value = "";
			}
		}
		
		var serialNo = document.getElementById("SerialNoR"+row).value;
		var accountCodeNo = document.getElementById("AccountCodeNoR"+row).value;
		if(typeof(accountCodeNo) == "undefined" || accountCodeNo.length == 0) return;
		var debitAmt = document.getElementById("DebitAmtR"+row).value;
		if(typeof(debitAmt) == "undefined" || debitAmt.length == 0) debitAmt = 0.0;
		var creditAmt = document.getElementById("CreditAmtR"+row).value;
		if(typeof(creditAmt) == "undefined" || creditAmt.length == 0) creditAmt = 0.0;
		
		if(parseFloat(debitAmt) == 0.0 && parseFloat(creditAmt) == 0.0) return;
		
		var description = document.getElementById("DescriptionR"+row).value;
		if(typeof(description) == "undefined" || description.length == 0) description = "";
		var i = RunMethod("LoanAccount","UpdateLedgerDetail",serialNo+","+direction+","+accountCodeNo+","+debitAmt+","+creditAmt+","+description);
	}

	//重新打开页面
	function reLoad()
	{
        AsControl.OpenView("/Accounting/Transaction/TransactionEntryList.jsp","ObjectNo=<%=objectNo%>&ObjectType=<%=objectType%>","_self",OpenStyle);
	}
</script>
<%@ include file="/IncludeEnd.jsp"%>