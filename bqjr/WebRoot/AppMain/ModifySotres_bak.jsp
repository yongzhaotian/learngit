<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%
    String sIdenttype = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("identtype"));
    ASResultSet rs=null;
    
    sIdenttype = "01";
	
	if(sIdenttype.equals("01")){//�ŵ�
	    rs = Sqlca.getResultSet(new SqlObject("select SNo,SNo|| ' ' || SName as SName from store_info where identtype='01' and sno in (Select sno from STORERELATIVESALESMAN where SalesManNo='"+CurUser.getUserID()+"')"));
	
	}
	if(sIdenttype.equals("02")){//չ��
		rs = Sqlca.getResultSet(new SqlObject("select SNo,SName from store_info where identtype='02' and sno in (Select sno from STORERELATIVESALESMAN where SalesManNo='"+CurUser.getUserID()+"')"));
	}

	String[][] sButtons = {
			{"true","All","Button","ȷ��","","selectCity()","","","",""},
			{"false","","Button","����","","resetCity()","","","",""},
			{"false","All","Button","ɾ��","","delRecord()","","","",""},
	};
%>
<body style="overflow:hidden;">
<div id="ButtonsDiv" style="margin-left: 8%; margin-right:8%; margin-top : 10px;">
<form name="CityForm" style="margin-bottom:0px;" enctype="multipart/form-data" action="" method="post">
<table align=center><tr>
<td>��ѡ�������ŵ꣺</td>
	<td>
		<select id="CityIDSelected" name="CityIDSelected" onKeyPress="javascript:pressEnter(0, event);" class="select_class" >
		<%while (rs.next()){%> 
			<OPTION value="<%=rs.getString("SNo") %>" ><%=rs.getString("SName") %>&nbsp;</OPTION>
		<%} %>
		</select>
	</td>
	<tr align="center">
	<td colspan="2" align="center" ><input type="button" value="ȷ��" onclick="javascript:selectCity()"/>
	<input type="reset" value="����" /></td></tr>
</tr></table>
</form>
</div>
</body>

<script type="text/javascript">
	
	function selectCity(){
		var sSNo = document.getElementById("CityIDSelected").value;
		AsControl.OpenView("/SelectCityInfo2.jsp", "SNo="+sSNo, "_self");
		self.returnValue = sSNo;
		self.close();
	}

	function resetCity() {
		reloadSelf();
	}
	
</script>
<%@ include file="/IncludeEnd.jsp"%>
