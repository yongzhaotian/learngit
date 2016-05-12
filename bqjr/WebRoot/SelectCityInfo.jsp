<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%
	String sIdenttype = DataConvert.toRealString(iPostChange,
				(String) CurComp.getParameter("identtype"));
		ASResultSet rs = null;

		ARE.getLog().debug("标志位sIdenttype=" + sIdenttype);
		if (sIdenttype.equals("01")) {//门店
			rs = Sqlca
					.getResultSet(new SqlObject(
							"select SNo,SNo|| ' ' || SName as SName from store_info where identtype='01' and sno in (Select sno from STORERELATIVESALESMAN where SalesManNo='"
									+ CurUser.getUserID() + "')"));

		}
		if (sIdenttype.equals("02")) {//展厅
			rs = Sqlca
					.getResultSet(new SqlObject(
							"select SNo,SName from store_info where identtype='02' and sno in (Select sno from STORERELATIVESALESMAN where SalesManNo='"
									+ CurUser.getUserID() + "')"));
		}

		String[][] sButtons = {
				{"true", "All", "Button", "确定", "", "selectCity()", "",
						"", "", ""},
				{"false", "", "Button", "重置", "", "resetCity()", "",
						"", "", ""},
				{"false", "All", "Button", "删除", "", "delRecord()", "",
						"", "", ""},};
%>
<body style="overflow: hidden;">
	<div id="ButtonsDiv"
		style="margin-left: 8%; margin-right: 8%; margin-top: 10px;">
		<form name="CityForm" style="margin-bottom: 0px;"
			enctype="multipart/form-data" action="" method="post">
			<table>
				<tr>
					<%
						if (sIdenttype.equals("01")) {//门店
					%>
					<td>请选择做单门店：</td>
					<%
						} else {
					%>
					<td>请选择做单展厅：</td>
					<%
						}
					%>
					<td><select id="CityIDSelected" name="CityIDSelected"
						onKeyPress="javascript:pressEnter(0, event);" class="select_class">
							<%
								while (rs.next()) {
							%>
							<OPTION value="<%=rs.getString("SNo")%>"><%=rs.getString("SName")%>&nbsp;
							</OPTION>
							<%
								}
							%>
					</select></td>
				<tr align="center">
					<td colspan="2" align="center"><input type="button"
						value="确定" onclick="javascript:selectCity()" /> <input
						type="reset" value="重置" /></td>
				</tr>
				</tr>
			</table>
		</form>
	</div>
</body>

<script type="text/javascript">
	function selectCity() {
		var sSNo = document.getElementById("CityIDSelected").value;
// 		AsControl.OpenView("/SelectCityInfo2.jsp", "SNo=" + sSNo, "_self");

		var ReturnValue = RunMethod("PublicMethod", "UpdateColValue", "String@attribute8@"+sSNo+",user_info,String@UserID@"+'<%=CurUser.getUserID()%>');
		if(ReturnValue != "TRUE"){
			alert("请重新选择");
		}else{
			alert("选择成功");
			self.returnValue = sSNo;
			self.close();
		}
	}

	function resetCity() {
		reloadSelf();
	}
</script>
<%@ include file="/IncludeEnd.jsp"%>
