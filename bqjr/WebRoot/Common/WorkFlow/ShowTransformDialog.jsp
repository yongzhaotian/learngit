<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main00;Describe=注释区;]~*/%>
	<%
	/*
		Author: ccxie 2010/03/23
		Tester:
		Describe: 担保合同变更信息提示框
		Input Param:
				ObjectNo：变更申请号
		Output param:
				returnValue：变更总笔数
		History Log: 
	 */
	%>
<%/*~END~*/%>

<%
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	if(sObjectNo == null) sObjectNo = "";
	String sSql = "select count(*) from TRANSFORM_RELATIVE where SerialNo =:SerialNo and RelationStatus = '020' ";
	String addCount  = Sqlca.getString(new SqlObject(sSql).setParameter("SerialNo",sObjectNo));
	sSql = "select count(*) from TRANSFORM_RELATIVE where SerialNo =:SerialNo and RelationStatus = '030' ";
	String delCount  = Sqlca.getString(new SqlObject(sSql).setParameter("SerialNo",sObjectNo));
	int totalCount = Integer.parseInt(addCount)+Integer.parseInt(delCount);
%>

<html>
<head> 
<title>担保合同变更</title>
<script type="text/javascript">
function returnInfo(){

	self.returnValue="<%=totalCount%>";
	self.close();
}
</script>
<style>
.black9pt {  font-size: 9pt; color: #000000; text-decoration: none}
</style>
</head>

<body >
<br>
  <table align="center" width="329" border='1' cellspacing='0' bordercolor='#999999' bordercolordark='#FFFFFF'>
    <tr> 
      <td nowarp align="right" class="black9pt" bgcolor="#DCDCDC"  width="50%">拟新增担保合同：</td>
      <td nowarp bgcolor="#DCDCDC" width="50%">共计<%=addCount%>笔</td>
    </tr>
    
       <tr> 
      <td nowarp align="right" class="black9pt" bgcolor="#DCDCDC" width="50%">拟解除担保合同：</td>
      <td nowarp bgcolor="#DCDCDC" width="50%">共计<%=delCount%>笔</td>
    </tr>
    
    <tr>
      <td nowarp bgcolor="#DCDCDC" height="25" colspan="2" align="center"> 
        <input type="button" name="next" value="确认" onClick="javascript:returnInfo()" style="font-size:9pt;padding-top:3;padding-left:5;padding-right:5;background-image:url(../../Resources/functionbg.gif); border: #DEDFCE;  border-style: outset; border-top-width: 1px; border-right-width: 1px;  border-bottom-width: 1px; border-left-width: 1px" border='1'>
        <input type="button" name="Cancel" value="取消" onClick="javascript:self.returnValue='_none_';self.close()" style="font-size:9pt;padding-top:3;padding-left:5;padding-right:5;background-image:url(../../Resources/functionbg.gif); border: #DEDFCE;  border-style: outset; border-top-width: 1px; border-right-width: 1px;  border-bottom-width: 1px; border-left-width: 1px" border='1'>
      </td>
    </tr>
  </table>
</body>
</html>
<%@ include file="/IncludeEnd.jsp"%>