<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main00;Describe=ע����;]~*/%>
	<%
	/*
		Author: FMWu 2004-12-6
		Tester:
		Describe: ��������ѡ���;
		Input Param:
		Output param:
		History Log: 
	 */
	%>
<%/*~END~*/%>

<%
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));

	//����sObjectType�Ĳ�ͬ���õ���ͬ�Ĺ�������
	String sSql="select ObjectTable from OBJECTTYPE_CATALOG where ObjectType=:ObjectType";
	String sObjectTable = Sqlca.getString(new SqlObject(sSql).setParameter("ObjectType",sObjectType));
	sSql="select BusinessType from "+sObjectTable+" where SerialNo=:SerialNo";
	String sBusinessType = Sqlca.getString(new SqlObject(sSql).setParameter("SerialNo",sObjectNo));
	//������ڱ�־
	String sBusinessAttr = sBusinessType.substring(0,1);
%>

<html>
<head> 
<title>ѡ�񵣱�����</title>
<script type="text/javascript">
function newGuarantyInfo()
{
		self.returnValue=document.getElementById("NewGuarantyType").value;
		self.close();
}
</script>
<style>
.black9pt {  font-size: 9pt; color: #000000; text-decoration: none}
</style>
</head>

<body bgcolor="#DCDCDC">
<br>
  <table align="center" width="329" border='1' cellspacing='0' bordercolor='#999999' bordercolordark='#FFFFFF'>
    <tr> 
      <td nowarp align="right" class="black9pt" bgcolor="#DCDCDC" >ѡ�񵣱����ͣ�</td>
      <td nowarp bgcolor="#DCDCDC" > 
        <select id="NewGuarantyType">
			<%=HTMLControls.generateDropDownSelect(Sqlca,"select ItemNo,ItemName from CODE_LIBRARY where CodeNo = 'GuarantyType' and IsInUse = '1' and ItemAttribute like '%"+sBusinessAttr+"%' order by SortNo ",1,2,"")%> 
        </select>
      </td>
    </tr>
    <tr>
      <td nowarp align="right" class="black9pt" bgcolor="#DCDCDC" height="25" >&nbsp;</td>
      <td nowarp bgcolor="#DCDCDC" height="25"> 
        <input type="button" name="next" value="ȷ��" onClick="javascript:newGuarantyInfo()" style="font-size:9pt;padding-top:3;padding-left:5;padding-right:5;background-image:url(../../Resources/functionbg.gif); border: #DEDFCE;  border-style: outset; border-top-width: 1px; border-right-width: 1px;  border-bottom-width: 1px; border-left-width: 1px" border='1'>
        <input type="button" name="Cancel" value="ȡ��" onClick="javascript:self.returnValue='_none_';self.close()" style="font-size:9pt;padding-top:3;padding-left:5;padding-right:5;background-image:url(../../Resources/functionbg.gif); border: #DEDFCE;  border-style: outset; border-top-width: 1px; border-right-width: 1px;  border-bottom-width: 1px; border-left-width: 1px" border='1'>
      </td>
    </tr>
  </table>
</body>
</html>
<%@ include file="/IncludeEnd.jsp"%>