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
	
	//取已配置的条件信息
	ASValuePool as = new ASValuePool();
	ASResultSet rs = Sqlca.getASResultSet(new SqlObject("select * from CONDITION_RULE where ObjectNo = :ObjectNo and ObjectType = :ObjectType order by RuleID asc,SerialNo asc").setParameter("ObjectNo",objectNo).setParameter("ObjectType",objectType));
	while(rs.next()){
		BusinessObject bo = new BusinessObject("jbo.app.CONDITION_RULE",rs.getRS());
		List<BusinessObject> lsbo = (List<BusinessObject>)as.getAttribute(bo.getString("RuleID"));
		if(lsbo == null)
		{
			lsbo = new ArrayList<BusinessObject>();
			as.setAttribute(bo.getString("RuleID"),lsbo);
		}
		lsbo.add(bo);
	}
	rs.getStatement().close();
	//数组表示 :字段ID，字段名，字段类型，字段值来源
	StringBuffer fieldsArray = new StringBuffer();
	fieldsArray.append("var term = new Array();");
	int m =0;
	ArrayList<com.amarsoft.dict.als.object.Item> itemList = new ArrayList<com.amarsoft.dict.als.object.Item>();
	com.amarsoft.dict.als.object.Item[] items = com.amarsoft.dict.als.cache.CodeCache.getItems("TermAttribute");
	for(com.amarsoft.dict.als.object.Item item:items)
	{
		if(item.getItemAttribute().indexOf("OH") >=0 && item.getItemDescribe().indexOf("BAS") >= 0)
		{
			fieldsArray.append("  term["+m+"]=new Array(\""+item.getItemNo()+"\",\""+item.getItemName()+"\",\""+DataConvert.toString(item.getBankNo())+"\",\""+DataConvert.toString(item.getRelativeCode())+"\");");
			m++;
			itemList.add(item);
		}
	}
%>
<html> 
<head>
<title></title>
</head>
<body class=pagebackground leftmargin="0" topmargin="0" >
<div id="Layer1" style="position:absolute;width:99.9%; height:99.9%; z-index:1; overflow: auto">
<table align='center' width='98%'  cellspacing="4" cellpadding="0">
<tr id = "CRTitle"> 
	<td colspan="4" align='center'> 
		<font color='#000880'><h2>方案条件</h2></font> 
	</td>
</tr>
<tr>
	<td colspan="4" align='center'> 
		<font color='#000880'>（逻辑框内各个条件是且关系，框与框之间是或关系）</font> 
	</td>
</tr>
<%
	int row = 0;
	for(;row < as.getKeys().length+8;row++)
	{
		String key = "";
		if(row < as.getKeys().length)
			key = (String)as.getKeys()[row];
		String tabDisplay = "",imgDisplay="";
		if(row > as.getKeys().length)
		{
			tabDisplay = "display:none";
		}
		if(row >= as.getKeys().length)
		{
			imgDisplay = "display:none";
		}
			
		if(row!=0)
		{
%>
 <tr id="TRTR<%= row%>" style="<%=tabDisplay%>"> 
    <td colspan="4"> 
      <div id=CROR<%=row%>TITLE style='WIDTH: 100%;'>
	      <table border=0 cellspacing=0 cellpadding=0 bordercolordark="#FFFFFF" bordercolorlight="#666666" width='100%'>
	      	<tr>
				<td align='left'> <font color='#00659C' ><h4>或</h4></font> </td>
			</tr>
	      </table>
      </div>
    </td>
  </tr>
 <%
		}
 %>
   <tr id="TRCR<%= row%>" style="<%=tabDisplay%>"> 
	<%
		if(row<as.getKeys().length)
		{
	%>
		<td style=' text-align: center; WIDTH: 2%;'>
			<img class="btn_icon_delete" border=0 id="IMGDR<%=row%>" onClick=deleteTab(<%=row%>) style='CURSOR: hand' width='15' height='15'/>
			<img class="btn_icon_add"  id="IMGAR<%=row%>" border=0  onClick=addTab(<%=row%>) style='CURSOR: hand; display:none;' width='15' height='15'/>
		</td>
	<%
		}
		else
		{
	%>
		<td style=' text-align: center; WIDTH: 2%;'>
			<img class="btn_icon_delete" id="IMGDR<%=row%>" border=0 onClick=deleteTab(<%=row%>) style='CURSOR: hand;display:none;' width='15' height='15'/>
			<img class="btn_icon_add"  id="IMGAR<%=row%>" border=0  onClick=addTab(<%=row%>) style='CURSOR: hand;' width='15' height='15'/>
		</td>
	<%
		}
	%>
	<td>
     <div id = "DIVR<%= row%>" style=' WIDTH: 100%; <%=imgDisplay%>'> 
	<table class='conditionmap' width='100%' align='left' border='1' cellspacing='0' cellpadding='4' bordercolordark="#FFFFFF" bordercolorlight="#666666">
	<tr>
		<td>
			<INPUT class=fftdinput type=hidden onblur=parent.trimField(this) value="<%=key %>" id="RuleIDR<%=row%>"/>
			<table id="TB<%=row%>">
					<%
					List<BusinessObject> boList = (List<BusinessObject>)as.getAttribute(key);
					if(boList == null) boList = new ArrayList<BusinessObject>();
					for(int col=0;col<boList.size()+20;){
						BusinessObject bo = null;
						if(col<boList.size())
							bo = boList.get(col);
						else
							bo = new BusinessObject("jbo.app.CONDITION_RULE");
						String serialNo = bo.getString("SerialNo");
						String ruleID = bo.getString("RuleID");
						String colID = DataConvert.toString(bo.getString("ColID"));
						String colName = DataConvert.toString(bo.getString("ColName"));
						String colType = DataConvert.toString(bo.getString("ColType"));
						String colSource = DataConvert.toString(bo.getString("ColSource"));
						String compareType = DataConvert.toString(bo.getString("CompareType"));
						String valueList = DataConvert.toString(bo.getString("ValueList"));
						String valueListName = DataConvert.toString(bo.getString("ValueListName"));
						
						StringBuffer compareOption = new StringBuffer();
						items = com.amarsoft.dict.als.cache.CodeCache.getItems("CompareType");
						compareOption.append("<option  value=''></option>");
						for(com.amarsoft.dict.als.object.Item item:items)
						{
							if(item.getItemNo().equals(compareType))
								compareOption.append("<option  value='"+item.getItemNo()+"' selected>"+item.getItemName()+"</option>");
							else
								compareOption.append("<option  value='"+item.getItemNo()+"'>"+item.getItemName()+"</option>");
						}
						
						StringBuffer fieldsOption = new StringBuffer();
						fieldsOption.append("<option  value=''></option>");
						for(com.amarsoft.dict.als.object.Item item:itemList)
						{
							if(item.getItemNo().equals(colID))
								fieldsOption.append("<option  value='"+item.getItemNo()+"' selected>"+item.getItemName()+"</option>");
							else
								fieldsOption.append("<option  value='"+item.getItemNo()+"'>"+item.getItemName()+"</option>");
						}
						
						//判断区域展示
						String textareaStyle = "display:none" ;
						String inputareaStyle = "";
						if(compareType != null && (compareType.equalsIgnoreCase("Contain")||compareType.equalsIgnoreCase("NoContain")
								||compareType.equalsIgnoreCase("in") || compareType.equalsIgnoreCase("notin")))
						{
							inputareaStyle = "style=' display:none '";
							textareaStyle = "";
						}
						
						String display="";
						if(col>boList.size())
						{
							display="style=' display:none '";
						}
						%>
						<tr id="TRR<%=row%>C<%=col%>"  <%=display %>>
						<%
						display="";
						if(col<boList.size())
						{
					%>
						<td style=' text-align: center; '>
							<img class="btn_icon_delete" border=0 id="IMGDR<%=row%>C<%=col%>" onClick=Delete(<%=row%>,<%=col%>) style='CURSOR: hand' width='15' height='15'/>
							<img class="btn_icon_add"  id="IMGAR<%=row%>C<%=col%>" border=0  onClick=add(<%=row%>,<%=col%>) style='CURSOR: hand; display:none;' width='15' height='15'/>
						</td>
					<%
						}
						else
						{
							display="style=' display:none '";
					%>
						<td style=' text-align: center; '>
							<img class="btn_icon_delete" id="IMGDR<%=row%>C<%=col%>" border=0 onClick=Delete(<%=row%>,<%=col%>) style='CURSOR: hand;display:none;' width='15' height='15'/>
							<img class="btn_icon_add"  id="IMGAR<%=row%>C<%=col%>" border=0  onClick=add(<%=row%>,<%=col%>) style='CURSOR: hand;' width='15' height='15'/>
						</td>
					<%
						}
					%>
						<td class=fftdhead noWrap colSpan=1 style="text-align: center; ">
							<INPUT class=fftdinput type=hidden onblur=parent.trimField(this) <%=display %> value="<%=serialNo %>" id="SerialNoR<%=row%>C<%=col%>"/>
							<INPUT class=fftdinput type=hidden onblur=parent.trimField(this) <%=display %> value="<%=colName %>" id="ColNameR<%=row%>C<%=col%>"/>
							<INPUT class=fftdinput type=hidden onblur=parent.trimField(this) <%=display %> value="<%=colType %>" id="ColTypeR<%=row%>C<%=col%>"/>
							<INPUT class=fftdinput type=hidden onblur=parent.trimField(this) <%=display %> value="<%=colSource %>" id="ColSourceR<%=row%>C<%=col%>"/>
							<SELECT id="ColIDR<%=row%>C<%=col%>" class=fftdselect <%=display %> onchange=ChangeAttribute(<%=row%>,<%=col%>) value="">
							<%= fieldsOption%>
							</SELECT>
						</td>
						<td class=FFContentTD noWrap colSpan=1>
							<SELECT id="CompareTypeR<%=row%>C<%=col%>" class=fftdselect <%=display %> onchange=ChangeCompare(<%=row%>,<%=col%>) value="">
							<%= compareOption.toString()%>
							</SELECT>
						</td>
						<td class=FFContentTD noWrap colSpan=1>
						<%
						 if(colSource!=null && !colSource.equals(""))
						 {
							 StringBuffer sb = new StringBuffer();
							 sb.append("<option  value=''></option>");
							 if(colSource.toUpperCase().startsWith("CODE:"))
							 {
								items = com.amarsoft.dict.als.cache.CodeCache.getItems(colSource.substring(5));
								for(com.amarsoft.dict.als.object.Item item:items)
								{
									if(item.getItemNo().equals(valueList))
										sb.append("<option  value='"+item.getItemNo()+"' selected>"+item.getItemName()+"</option>");
									else
										sb.append("<option  value='"+item.getItemNo()+"'>"+item.getItemName()+"</option>");
								}
							 }
							 else
							 {
								 ASResultSet rsTemp = Sqlca.getASResultSet(colSource.substring(4));
								 while(rsTemp.next())
								 {
									if(rsTemp.getString(1).equals(valueList))
										sb.append("<option  value='"+rsTemp.getString(1)+"' selected>"+rsTemp.getString(2)+"</option>");
									else
										sb.append("<option  value='"+rsTemp.getString(1)+"'>"+rsTemp.getString(2)+"</option>");
								 }
								 rsTemp.close();
							 }
							 %>
							 <SELECT id="ValueListAR<%=row%>C<%=col%>" class=fftdselect <%=display %> <%=inputareaStyle%> onchange=ChangeValue(<%=row%>,<%=col%>) value="">
								<%= sb.toString()%>
							 </SELECT>
							 <INPUT id="ValueListBR<%=row%>C<%=col%>" class=fftdinput type=text onblur=parent.trimField(this) <%=display %> value="<%=valueList %>" style="display:none" onchange=ChangeValue(<%=row%>,<%=col%>)>
							 <%
						 }else
						 {
						%>
							<SELECT id="ValueListAR<%=row%>C<%=col%>" class=fftdselect <%=display %> style="display:none" onchange=ChangeValue(<%=row%>,<%=col%>) value="">
								<option  value='' selected></option>
							 </SELECT>
							<INPUT class=fftdinput type=text onblur=parent.trimField(this) <%=display %> value="<%=valueList %>" <%=inputareaStyle%> id="ValueListBR<%=row%>C<%=col%>" onchange=ChangeValue(<%=row%>,<%=col%>)>
						<%
						 }
						%>
							<INPUT class=fftdinput type=text onblur=parent.trimField(this) style="BACKGROUND: #efefef; COLOR: black; BORDER-TOP-STYLE: groove; BORDER-RIGHT-STYLE: groove; BORDER-LEFT-STYLE: groove; BORDER-BOTTOM-STYLE: groove; WIDTH:600px;<%=textareaStyle%>" readOnly value="<%=valueListName %>" id="ValueListNameR<%=row%>C<%=col%>">
							<INPUT class=inputdate id='ValueListSelectR<%=row%>C<%=col%>' onclick=selectDataSource(<%=row%>,<%=col%>) style="<%=textareaStyle%>" type=button value='...'>
						</td>
						</tr>
					<%
						col++;
					}
					%>
			</table>
		</td>
	</tr>
	</table>
      </div>
    </td>
  </tr>

<%
	}
%>

</table>
</div>
</body>
</html>

<script language="javascript">
	<%out.print(fieldsArray.toString());%>

	function ChangeAttribute(row,col)
	{
		var colIDValue = document.getElementById("ColIDR"+row+"C"+col).value;
		if(typeof(colIDValue) == "undefined" || colIDValue.length == 0)
			return;
		for(var i = 0; i < term.length;i++)
		{
			if(term[i][0] == colIDValue)
			{
				document.getElementById("ColNameR"+row+"C"+col).value = term[i][1];
				document.getElementById("ColTypeR"+row+"C"+col).value = term[i][2];
				document.getElementById("ColSourceR"+row+"C"+col).value = term[i][3];
				document.getElementById("ValueListAR"+row+"C"+col).value = "";
				document.getElementById("ValueListBR"+row+"C"+col).value = "";
				document.getElementById("ValueListNameR"+row+"C"+col).value = "";
			}
		}
		ChangeCompare(row,col);
	}

	function ChangeCompare(row,col)
	{
		var compareType = document.getElementById("CompareType"+"R"+row+"C"+col).value;
		if(compareType == "in" || compareType == "notin")
		{
			var valueList = document.all.item("ValueListB"+"R"+row+"C"+col);	
			valueList.style.display = "none";
			var valueList = document.all.item("ValueListA"+"R"+row+"C"+col);	
			valueList.style.display = "none";
			var valueListName = document.all.item("ValueListName"+"R"+row+"C"+col);	
			valueListName.style.display = "";
			var valueListSelect = document.all.item("ValueListSelect"+"R"+row+"C"+col);	
			valueListSelect.style.display = "";
		}
		else
		{
			var colSource = document.getElementById("ColSource"+"R"+row+"C"+col).value;
			if(typeof(colSource)=="undefined" || colSource.length == 0 || colSource == null)
			{
				var valueList = document.all.item("ValueListB"+"R"+row+"C"+col);	
				valueList.style.display = "";
				var valueList = document.all.item("ValueListA"+"R"+row+"C"+col);	
				valueList.style.display = "none";
			}
			else
			{
				var valueList = document.all.item("ValueListB"+"R"+row+"C"+col);	
				valueList.style.display = "none";
				var valueList = document.all.item("ValueListA"+"R"+row+"C"+col);	
				valueList.style.display = "";
				var result=PopPage("/Accounting/Config/ConditionRuleAction.jsp?Type=getCode&ColSource="+colSource,"","dialogWidth=60;dialogheight=25;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no");
				if(typeof(result) =="undefined" || result.length == 0)
					return;
				var obj = document.getElementById("ValueListA"+"R"+row+"C"+col);
				var value = obj.value;
				obj.options[0] = new Option("","");
				obj.options.length = 1;
				var items = result.split("@");
				for(var i = 0; i < items.length; i ++)
				{
					var item = items[i].split(",");
					obj.options[i+1] = new Option(item[1],item[0]);
				}
				obj.value = value;
			}
			
			var valueListName = document.all.item("ValueListName"+"R"+row+"C"+col);	
			valueListName.style.display = "none";
			var valueListSelect = document.all.item("ValueListSelect"+"R"+row+"C"+col);	
			valueListSelect.style.display = "none";
		}
		var colType = document.getElementById("ColType"+"R"+row+"C"+col).value;
		if(colType == "2" || colType == "5")
		{
			var valueList = document.all.item("ValueListB"+"R"+row+"C"+col);	
			valueList.style.textAlign="right";
		}
		
		update(row,col);
	}

	function selectDataSource(row,col)
	{
		var valueList = document.getElementById("ValueListB"+"R"+row+"C"+col).value;
		var colSource = document.getElementById("ColSource"+"R"+row+"C"+col).value;
		if(typeof(colSource)=="undefined" || colSource.length == 0)
			return;
		var sReturn = AsControl.PopView("/Accounting/Config/SelectDataSourceTree.jsp","ColSource="+colSource+"&ColValue="+valueList,"dialogWidth=400px;dialogHeight=500px;center:yes;resizable:yes;scrollbars:no;status:no;help:no");
		if(typeof(sReturn) == "undefined" || sReturn.length == 0)
			return;
		if(sReturn == "_CLEAR_")
		{
			document.getElementById("ValueListB"+"R"+row+"C"+col).value = "";
			document.getElementById("ValueListName"+"R"+row+"C"+col).value = "";
		}
		else{
			document.getElementById("ValueListB"+"R"+row+"C"+col).value = sReturn.split("@")[0];
			document.getElementById("ValueListName"+"R"+row+"C"+col).value = sReturn.split("@")[1];
		}
		update(row,col);
	}

	function ChangeValue(row,col)
	{
		var valueListB = document.getElementById("ValueListB"+"R"+row+"C"+col).value;
		var valueListA = document.getElementById("ValueListA"+"R"+row+"C"+col).value;
		if(typeof(valueListA)!="undefined" && valueListA!=null && valueListA.length!=0)
			valueListB = valueListA;
		document.getElementById("ValueListB"+"R"+row+"C"+col).value = valueListB; 
		document.getElementById("ValueListName"+"R"+row+"C"+col).value=valueListB;
		update(row,col);
	}

	function Delete(row,col)
	{
		if(!confirm("确定删除吗?"))return;
		var serialno = document.getElementById("SerialNoR"+row+"C"+col).value;
		if(typeof(serialno) == "undefined" || serialno.length == 0)
			return;
		var i = RunMethod("LoanAccount","DeleteConditionRule",serialno); 
		if(parseInt(i)==1)
		{
			var tr = document.all.item("TRR"+row+"C"+col);	
			tr.style.display = "none";
		}
	}
	function deleteTab(row)
	{
		if(!confirm("确定删除吗?"))return;
		var ruleID = document.getElementById("RuleIDR"+row).value;
		if(typeof(ruleID) == "undefined" || ruleID.length == 0)
			return;
		var i = RunMethod("LoanAccount","DeleteConditionRule1",ruleID); 
		var tr = document.all.item("TRTR"+parseInt(row+1));	
		tr.style.display = "none";
		var tr = document.all.item("TRCR"+row);	
		tr.style.display = "none";
	}
	
	function addTab(row)
	{
		try
		{
			var tr = document.all.item("TRTR"+parseInt(row+1));	
			tr.style.display = "";
			var tr = document.all.item("TRCR"+parseInt(row+1));	
			tr.style.display = "";
		}catch(e)
		{
			reLoad();
		}
		var tr = document.all.item("DIVR"+row);	
		tr.style.display = "";

		var tr = document.all.item("IMGAR"+row);	
		tr.style.display = "none";
		var tr = document.all.item("IMGDR"+row);	
		tr.style.display = "";
		
		var ruleID = getSerialNo("CONDITION_RULE","RuleID","");
		document.getElementById("RuleID"+"R"+row).value=ruleID;
	}
	
	function add(row,col)
	{
		try
		{
			var tr = document.all.item("TRR"+row+"C"+parseInt(col+1));	
			tr.style.display = "";
		}catch(e)
		{
			reLoad();
		}
		var tr = document.all.item("ColIDR"+row+"C"+col);	
		tr.style.display = "";
		var tr = document.all.item("CompareTypeR"+row+"C"+col);	
		tr.style.display = "";
		var tr = document.all.item("ValueListBR"+row+"C"+col);	
		tr.style.display = "";
		var tr = document.all.item("IMGAR"+row+"C"+col);	
		tr.style.display = "none";
		var tr = document.all.item("IMGDR"+row+"C"+col);	
		tr.style.display = "";

		var serialNo = getSerialNo("CONDITION_RULE","SerialNo","");
		document.getElementById("SerialNo"+"R"+row+"C"+col).value=serialNo;
		var ruleID = document.getElementById("RuleID"+"R"+row).value;

		var cnt = RunMethod("LoanAccount","InsertConditionRule",serialNo+",<%=objectNo%>,<%=objectType%>,"+ruleID);
	}

	function update(row,col)
	{
		var colID = document.getElementById("ColID"+"R"+row+"C"+col).value;
		var colType = document.getElementById("ColType"+"R"+row+"C"+col).value;
		var colName = document.getElementById("ColName"+"R"+row+"C"+col).value;
		var colSource = document.getElementById("ColSource"+"R"+row+"C"+col).value;
		var compareType = document.getElementById("CompareType"+"R"+row+"C"+col).value;
		var valueList = document.getElementById("ValueListB"+"R"+row+"C"+col).value;
		var valueListName = document.getElementById("ValueListName"+"R"+row+"C"+col).value;
		var serialno = document.getElementById("SerialNo"+"R"+row+"C"+col).value;

		if(typeof(colID)=="undefined" || colID.length == 0)
			return;
		if(typeof(compareType) == "undefined" || compareType.length == 0)
			return;
		if(typeof(valueList) == "undefined" || valueList.length == 0)
			return;
		if(typeof(valueListName) == "undefined" || valueListName.length == 0)
			return;
		var result=PopPage("/Accounting/Config/ConditionRuleAction.jsp?Type=update&ValueListName="+valueListName+"&ValueList="+valueList+"&ColSource="+colSource+"&CompareType="+compareType+"&ColID="+colID+"&ColName="+colName+"&ColType="+colType+"&SerialNo="+serialno,"","dialogWidth=60;dialogheight=25;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no");
	}

	function reLoad()
	{
        AsControl.OpenView("/Accounting/Config/ConditionRuleDef.jsp","ObjectNo=<%=objectNo%>&ObjectType=<%=objectType%>","_self",OpenStyle);
	}
</script>
<%@ include file="/IncludeEnd.jsp"%>