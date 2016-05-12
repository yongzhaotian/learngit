<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginReportMD.jsp"%>
<%
/* 
 * Title: ѡ���ѯ�����б�
 * Description: չ�г���ǰ�û����ڵ�ȫϽ����
 *
 * @author zllin@amarsoft.com
 * @version 1.00 Mar 11,2005
 *          Date: 2005-05-16
 *          Time: 9:13:25
 *          HistoryLog: 1. 
 */
%>
<%
	/*10***���е�Ӫ������,����ҵ��
	 *11***���еĹ������
	 *20***��֧��,����ҵ��
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
			if(sortno == null ||sortno.equals("")||sortno.indexOf("11") == 0){		//�������
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
<title>��ѡ�����</title>
<script type="text/javascript" src="<%=sResourcesPath%>/expand.js"></script>
<script type="text/javascript">
	function TreeViewOnClick(){
		var sSortNo=getCurTVItem().id;
		var sVouchName=getCurTVItem().name;
		var sType = getCurTVItem().type;
		if(sSortNo=="root"){
			alert("��ѡ��Ļ���["+sVouchName+"]����");
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
			alert("��ѡ��һ����Ч�Ļ�����");
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
		<td align="left">�����б�:</td>
	</tr>
	<tr>
		<td align="left" colspan="3">
			<select name="OrgRange" class="right" size="20" STYLE="width:100%;text-align:left" onclick="javascript:OptionOnClick();">
<%
	if(bIsManageOrg){
%>
				<option value="00@ȫ�з�Χ">ȫ�з�Χ</option>
<%
	}
%>
				<%=HTMLControls.generateDropDownSelect(Sqlca,sSqlScript,1,2,"")%>
			</select>
		</td>
	</tr>
	<tr>
      <td nowarp bgcolor="#F0F1DE" height="25" align=center> 
        <input type="button" name="ok" value="ȷ��" onClick="javascript:returnSelection()" style="font-size:9pt;padding-top:3;padding-left:5;padding-right:5;background-image:url(../../Resources/functionbg.gif); border: #DEDFCE;  border-style: outset; border-top-width: 1px; border-right-width: 1px;  border-bottom-width: 1px; border-left-width: 1px" border='1'>
		<input type="button" name="Cancel" value="���" onClick="javascript:self.returnValue='_NONE_';self.close()" style="font-size:9pt;padding-top:3;padding-left:5;padding-right:5;background-image:url(../../Resources/functionbg.gif); border: #DEDFCE;  border-style: outset; border-top-width: 1px; border-right-width: 1px;  border-bottom-width: 1px; border-left-width: 1px" border='1'>
		<input type="button" name="Cancel" value="ȡ��" onClick="javascript:self.returnValue='';self.close()" style="font-size:9pt;padding-top:3;padding-left:5;padding-right:5;background-image:url(../../Resources/functionbg.gif); border: #DEDFCE;  border-style: outset; border-top-width: 1px; border-right-width: 1px;  border-bottom-width: 1px; border-left-width: 1px" border='1'>
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
