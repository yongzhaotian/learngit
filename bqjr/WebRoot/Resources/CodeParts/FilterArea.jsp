<tr height=1 >
	<td id="FilterButtonTd">
		<span id="ShowFilterButton">
		<table border="0" cellspacing="0" cellpadding="0">
			<tr><td>
			<img class="FilterIcon" src=<%=sResourcesPath%>/1x1.gif width="1" height="1" id="FilterIconPlus" onClick="showHideFilterArea()">
			<img class="FilterIcon2" src=<%=sResourcesPath%>/1x1.gif width="1" height="1" id="FilterIconMinus" onClick="showHideFilterArea()">
			</td><td><a href="javascript:showHideFilterArea();"> &nbsp;查询条件</a></td></tr>
		</table>
		</span>
	</td>
</tr>
<tr height=1 >
	<form name="DOFilter" method=post onSubmit="if(!checkDOFilterForm(this)) return false;">
		<input type=hidden name=CompClientID value="<%=CurComp.getClientID()%>">
		<input type=hidden name=PageClientID value="<%=CurPage.getClientID()%>">
		<input type=hidden name=DWCurPage value="0">
		<input type=hidden name=DWCurRow value="0">
		<td colspan=2 id="ListCriteriaTd" class="ListCriteriaTd">
		<div id="FilterArea" class="FilterArea">
		<%
		String sFilterHTML = (String)CurPage.getAttribute("FilterHTML");
		if(sFilterHTML!=null && !sFilterHTML.equals("")){
		%>
			<table align=center width="100%" cellspacing="0" cellpadding="3">
				<tr>
				<td>
					<% 
					//如果查询条件有4个以上（DOFilterOperatorSelect在每个查询条件中出现1次）就显示垂直滚动条
					int iOccurTimes = StringFunction.getOccurTimes(sFilterHTML,"DOFilterOperatorSelect");
					if(iOccurTimes >= 4){
					%>
					<div style="overflow:auto;width:100%;height:120">
						<table>
						<%=sFilterHTML%>
						</table>
					</div>
					<%}else{%>
						<table>
						<%=sFilterHTML%>
						</table>
					<%}%>
				</td>
				</tr>
				<tr>
				<td class="FilterSubmitTd" >
				<input type=submit value="查询">
				<input type=button onclick="clearFilterForm('DOFilter')" value="清空">
				<input type=button onclick="resetFilterForm('DOFilter')" value="恢复">
				<input type=button onclick="hideFilterArea()" value="取消">
				</td>
				</tr>
			</table>
		<%}%>
		</div>
		</td>
	</form>
</tr>
<script type="text/javascript">
	var bFilterAreaShowStatus=false;
	<%if(sFilterHTML==null || sFilterHTML.equals("")){%>
		showHideObjects("ShowFilterButton","hide");
		showHideObjects("FilterArea","hide");
		bFilterAreaShowStatus = false;
	<%}else{%>
		hideFilterArea();
		bFilterAreaShowStatus = false;	
	<%}%>
	
	//默认显示filter区，查询完以后，则不再显示
	<%if(!doTemp.haveReceivedFilterCriteria()) {%>
		//showFilterArea();
		hideFilterArea();
	<%}%>
	
	function showHideFilterArea(){
		if(!bFilterAreaShowStatus){
			showFilterArea();
		}else{
			hideFilterArea();
		}
	}
	function showFilterArea(){
		//showHideObjects("ShowFilterButton","hide");
		showHideObjects("FilterArea","show");
		bFilterAreaShowStatus = true;
		showHideObjects("FilterIconPlus","hide");
		showHideObjects("FilterIconMinus","show");
	}
	function hideFilterArea(){
		//showHideObjects("ShowFilterButton","show");
		showHideObjects("FilterArea","hide");
		bFilterAreaShowStatus = false;
		showHideObjects("FilterIconPlus","show");
		showHideObjects("FilterIconMinus","hide");
	}
</script>