<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author:  2005.7.22 fbkang    新的版本的改写
		Tester:	
		Content: 客户列表
		Input Param:
			              ObjectType:  对象类型
			              ObjectNo  :  对象编号
			              ModelType :  评估模型类型 010--信用等级评估   030--风险度评估  080--授信限额 018--信用村镇评定  具体由'EvaluateModelType'代码说明     
		Output param:
			               
		History Log: 
			DATE	CHANGER		CONTENT
			
	 */
	%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = ""; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%
	String sModelTypeAttributes="",sDefaultModelNo="";
	String sAccountMonthSelectSQL = "",sAccountMonthInputType = "",sDefaultModelNoSQL="",sAccountMonthExplanation="";

	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectType"));	
	String sObjectNo   = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectNo"));
	String sModelType  = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ModelType"));
	if(sModelType==null) sModelType = "";
%>
<%/*END*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%
	String sSql = "select RelativeCode from CODE_LIBRARY where CodeNo='EvaluateModelType' and ItemNo=:ItemNo";
	ASResultSet rs   = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("ItemNo",sModelType));
	if(rs.next()){
		sModelTypeAttributes = rs.getString("RelativeCode");
	}
	else{
		throw new Exception("模型类型 ["+sModelType+"] 没有定义。请和系统管理员联系！");
	}
	rs.getStatement().close();

	/* 等级评估变量说明
	sModelTypeAttributes	模型相关的参数定义串
	sAccountMonthSelectSQL  
	sAccountMonthExplanation 对于会计月份的补充说明
	sDefaultModelNoSQL		取得对应类型的查询语句
	*/
	sAccountMonthInputType = StringFunction.getProfileString(sModelTypeAttributes,"AccountMonthInputType");
	sAccountMonthSelectSQL = StringFunction.getProfileString(sModelTypeAttributes,"AccountMonthSelectSQL");	
	sAccountMonthExplanation = StringFunction.getProfileString(sModelTypeAttributes,"AccountMonthExplanation");
	sDefaultModelNoSQL = StringFunction.getProfileString(sModelTypeAttributes,"DefaultModelNoSQL");

	//将对应的参数转换为当前实际数据
	sAccountMonthSelectSQL = StringFunction.replace(sAccountMonthSelectSQL,"#ObjectType",sObjectType);
	sAccountMonthSelectSQL = StringFunction.replace(sAccountMonthSelectSQL,"#ObjectNo",sObjectNo);
	sAccountMonthSelectSQL = StringFunction.replace(sAccountMonthSelectSQL,"#ModelType",sModelType);
	sDefaultModelNoSQL = StringFunction.replace(sDefaultModelNoSQL,"#ObjectType",sObjectType);
	sDefaultModelNoSQL = StringFunction.replace(sDefaultModelNoSQL,"#ObjectNo",sObjectNo);
	sDefaultModelNoSQL = StringFunction.replace(sDefaultModelNoSQL,"#ModelType",sModelType);

	//取得对应的评估模型
	if(sDefaultModelNoSQL!=null && !sDefaultModelNoSQL.equals("")){
		sDefaultModelNo = Sqlca.getString(sDefaultModelNoSQL);
	}
	String sModelTypeName = Sqlca.getString(new SqlObject("select ItemName from CODE_LIBRARY where CodeNo='EvaluateModelType' and ItemNo=:ItemNo").setParameter("ItemNo",sModelType));
	
	//取得客户名称
	String sObjectName = Sqlca.getString(new SqlObject("select CustomerName from CUSTOMER_INFO where CustomerID=:CustomerID ").setParameter("CustomerID",sObjectNo));
%> 
<%/*END*/%>

<html>
<head><title><%=sModelTypeName%> - 新增</title></head>
<body  leftmargin="0" topmargin="0">
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
		<tr> 
			<td width="10%">&nbsp;</td>
			<td width="100%" align="left" valign="top"> 
			<form name="evaluate">
				<table width="100%" align="left" border="0" cellspacing="0" cellpadding="5">
				<tr> 
					<td>&nbsp;</td>
				</tr>
<%
				if(sAccountMonthInputType.equals("select")){
					if(sAccountMonthSelectSQL==null || sAccountMonthSelectSQL.equals(""))
						throw new Exception("该评估类型("+sModelType+")会计月份输入方式为 select ，但是没有定义 AccountMonthSelectSQL"+"   sModelTypeAttributes:"+sModelTypeAttributes);
%> 
				<tr> 
					<td nowrap> 月份： 
						<select name="AccountMonth" class="right">
							<%=HTMLControls.generateDropDownSelect(Sqlca,sAccountMonthSelectSQL,1,2,"")%> 
						</select>
						(<%=sAccountMonthExplanation%>)
					</td>
				</tr>
<% 
				}
				else{
%> 
				<tr> 
					<td nowrap> 月份： 
						<SELECT id="AccountMonth" name="AccountMonth" class=loginInput>
<%
						int iMonth = 0;
						String sVisibleString = StringFunction.getToday().substring(0,7);
						for(iMonth=0;iMonth<24;iMonth++){
							out.println("<OPTION value='"+sVisibleString+"'>"+sVisibleString+"</OPTION>");
							sVisibleString = StringFunction.getRelativeAccountMonth(sVisibleString,"Month",-1);
						}
%>
						</SELECT>
					</td>
				</tr>
<%
				}
%>
			<tr> 
				<td>&nbsp;</td>
			</tr>
			<tr> 
				<td nowrap> 模型： 
					<select name="ModelNo" class="right">
<% 
						if (sModelType.equals("010")||sModelType.equals("012"))	out.print(HTMLControls.generateDropDownSelect(Sqlca,"select ModelNo,ModelName from EVALUATE_CATALOG where ModelType='"+sModelType+"' and ModelNo = '"+sDefaultModelNo+"'  order by ModelNo ",1,2,sDefaultModelNo));
						else	out.print(HTMLControls.generateDropDownSelect(Sqlca,"select ModelNo,ModelName from EVALUATE_CATALOG where ModelType='"+sModelType+"' order by ModelNo ",1,2,sDefaultModelNo));
%>
					</select>
				</td>
			</tr>
			<tr> <td>&nbsp;</td>  </tr>
			<tr> 
				<td> 
					<table width="70%" border="0">
						<tr> 
							<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>  
							<td><%=ASWebInterface.generateControl(SqlcaRepository,CurComp,sServletURL,"","Button","确定","确定进行新评估","javascript:setNext()",sResourcesPath)%></td>
			    		<td><%=ASWebInterface.generateControl(SqlcaRepository,CurComp,sServletURL,"","Button","取消","取消新评估","javascript:self.close();",sResourcesPath)%></td>
						</tr>
					</table>
				</td>
			</tr>
		</table>
		</form>
    </td>
  </tr>
</table>
</body>
</html>
<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List04;Describe=定义按钮;]~*/%>
<script type="text/javascript">
	function setNext() {
		sDateScopeCustomerID = document.forms["evaluate"].AccountMonth.value;
		var sModelType = "<%=sModelType%>";
		var str = sDateScopeCustomerID.split("@");
		sAccountMonth = str[0];
		sReportScope = str[1];
		sCustomerID = str[2];
		sModelNo = document.forms["evaluate"].ModelNo.value;
		if(sAccountMonth==""){
			alert(getBusinessMessage('191'));//请先选择会计报表月份！
			return;
		}
		if(!isDateForAccountMonth(sAccountMonth+"/01")){
			alert(getBusinessMessage('192'));//请输入正确的会计报表月份格式（YYYY/MM）！
			return;
		}
		if(sModelNo==""){
			alert(getBusinessMessage('193'));//请先选择一个模型！
			return;
		} 
		//sReportScope != "undefined" 说明为公司客户
		if(typeof(sReportScope) != "undefined" && sReportScope.length > 0){
			//将财务报表设置为锁定状态
			sReportStatus = '03';
		}else{
			//个人客户没有报表口径，设为空
			//设置为空字符串，兼容ORACLE数据库对空值的处理
			sReportScope=' ';
		}	
		//如果新增客户信用等级评估申请记录,要将报表状态置为锁定。sModelType=010为企业信用等级评估，sModelType=012为中小企业信用等级评估,sModelType=017为个体经营户。
		// 详情见代码表EvaluateModelType。modify by cbsu 2009-11-05
		if(sModelType == '010' || sModelType == '012' || sModelType == '017')
			sReturn = RunMethod("CustomerManage","UpdateFSStatus",sCustomerID+","+sReportStatus+","+sAccountMonth+","+sReportScope);
		self.returnValue="<%=sObjectType%>@<%=sObjectNo%>@<%=sModelType%>@"+sModelNo+"@"+sAccountMonth+"@"+sReportScope;
		self.close();
	} 
	function isDateForAccountMonth(sItemName) {
		var sItems = sItemName.split("/");
		if (sItems.length!=3) return false;
		if (isNaN(sItems[0])) return false;
		if (isNaN(sItems[1])) return false;
		if (isNaN(sItems[2])) return false;
		if (parseInt(sItems[0],10)<1900 || parseInt(sItems[0],10)>2050) return false;
		if (parseInt(sItems[1],10)<1 || parseInt(sItems[1],10)>12) return false;
		if (parseInt(sItems[2],10)<1 || parseInt(sItems[2],10)>31) return false;
		return true;
	}
</script>
<%/*END*/%>

<%@ include file="/IncludeEnd.jsp"%>