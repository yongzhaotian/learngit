<table <%=sTableStyle%>>
	<tr>
		<td valign='top' colspan=2 class='tabhead' <%=sTabHeadStyle%>><%=sTabHeadText%></td>
	</tr>
	<tr>
		<td valign='top' align='left' id="<%=sTabID%>" class="tabtd"></td>
		<td valign='top' class="tabbar">
		<%=sTopRight%>
		</td>
	</tr>
	<tr>
		<td class='tabcontent' align='center' valign='top' colspan=2>
			<table cellspacing=0 cellpadding=4 border=0	width='100%' height='100%'>
				<tr> 
					<td valign="top">
					<iframe name="<%=sIframeName%>" src="<%=sDefaultPage%>" <%=sIframeStyle%>></iframe>
					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>