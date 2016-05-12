<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginReportMD.jsp"%>
<%
/* 
 * Title: 选择查询机构列表
 * Description: 展列出当前用户所在的全辖机构
 *
 * @author zllin@amarsoft.com
 * @version 1.00 Mar 11,2005
 *          Date: 2005-05-16
 *          Time: 9:13:25
 *          HistoryLog: 1. 
 */
%>
<%
	/*10***总行的营销机构,办理业务
	 *11***总行的管理机构
	 *20***分支行,办理业务
	 */
	class OrgJudgement{
		Transaction sqlca;
		String orgid	= "";
		String sortno	= "";
		String orgrange	= "select SortNo||'@'||OrgName,OrgName from ORG_INFO where ";
		boolean bIsManage = false;
		public OrgJudgement(String orgid,Transaction Sqlca){
			this.orgid = orgid;
			this.sqlca = Sqlca;
			initSortNo();
		}
		public String SortNo(){
			return sortno;
		}
		public boolean ManageOrg(){
			return bIsManage;
		}
		public void initSortNo() {
			try{
				ASResultSet rs = sqlca.getASResultSet(new SqlObject("select SortNo from Org_INFO where OrgID = :OrgID").setParameter("OrgID",orgid));
				if(rs.next()) {
					sortno = rs.getString("SortNo");
				}
				rs.getStatement().close();
			}catch(Exception e){
				sortno = orgid;
			}
		}
		public String getOrgCondition(){
			if(sortno == null ||sortno.equals("")||sortno.indexOf("11") == 0){		//管理机构
				orgrange += " (SortNo NOT LIKE '11%') ";
				bIsManage = true;
			}else{
				orgrange += " SortNo = '"+sortno+"'";
			}
			return orgrange+" ORDER BY SortNo";
		}
	}
%>
<html>
<head> 
<title>请选择机构</title>
<script type="text/javascript" src="<%=sResourcesPath%>/expand.js"></script>
<script type="text/javascript">
	function TreeViewOnClick(){
		var sSortNo=getCurTVItem().id;
		var sVouchName=getCurTVItem().name;
		var sType = getCurTVItem().type;
		if(sSortNo=="root"){
			alert("您选择的机构["+sVouchName+"]有误");
			return;
		}
		buff.SortNo.value=sSortNo+"@"+sVouchName;
	}
	
	function OptionOnClick(){
		var sSortNo = buff.OrgRange.value;
		buff.SortNo.value=sSortNo;
	}

	function returnSelection(){
		if(buff.SortNo.value!=""){
			//alert(buff.SortNo.value);
			self.returnValue=buff.SortNo.value;
			self.close();
		}else
			alert("请选择一个有效的机构！");
	}
	
	function startMenu(){
	<%
		OrgJudgement ojm = new OrgJudgement(CurOrg.getOrgID(),Sqlca);
		String sSqlScript = ojm.getOrgCondition();
		boolean bIsManageOrg = ojm.ManageOrg();
	%>
	}
</script>
<style>
.black9pt {  font-size: 9pt; color: #000000; text-decoration: none}
</style>
</head>

<body class="pagebackground">
<center>
<form  name="buff">
<input type="hidden" name="SortNo" value="">
<table width="90%" border='1' height="98%" cellspacing='0' bordercolor='#999999' bordercolordark='#FFFFFF'>
	<tr>
		<td align="left">机构列表:</td>
	</tr>
	<tr>
		<td align="left" colspan="3">
			<select name="OrgRange" class="right" size="20" STYLE="width:100%;text-align:left" onclick="javascript:OptionOnClick();">
<%
	if(bIsManageOrg){
%>
				<option value="00@全行范围">全行范围</option>
<%
	}
%>
				<%=HTMLControls.generateDropDownSelect(Sqlca,sSqlScript,1,2,"")%>
			</select>
		</td>
	</tr>
	<tr>
      <td nowarp bgcolor="#F0F1DE" height="25" align=center> 
        <input type="button" name="ok" value="确认" onClick="javascript:returnSelection()" style="font-size:9pt;padding-top:3;padding-left:5;padding-right:5;background-image:url(../../Resources/functionbg.gif); border: #DEDFCE;  border-style: outset; border-top-width: 1px; border-right-width: 1px;  border-bottom-width: 1px; border-left-width: 1px" border='1'>
		<input type="button" name="Cancel" value="清空" onClick="javascript:self.returnValue='_NONE_';self.close()" style="font-size:9pt;padding-top:3;padding-left:5;padding-right:5;background-image:url(../../Resources/functionbg.gif); border: #DEDFCE;  border-style: outset; border-top-width: 1px; border-right-width: 1px;  border-bottom-width: 1px; border-left-width: 1px" border='1'>
		<input type="button" name="Cancel" value="取消" onClick="javascript:self.returnValue='';self.close()" style="font-size:9pt;padding-top:3;padding-left:5;padding-right:5;background-image:url(../../Resources/functionbg.gif); border: #DEDFCE;  border-style: outset; border-top-width: 1px; border-right-width: 1px;  border-bottom-width: 1px; border-left-width: 1px" border='1'>
      </td>
    </tr>
</table>
</form>
</center>
</body>
<script>
startMenu();

</script></html>
<%@ include file="/IncludeEnd.jsp"%>
