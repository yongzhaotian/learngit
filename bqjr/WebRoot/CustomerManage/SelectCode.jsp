<%@page import="com.amarsoft.dict.als.object.Item"%>
<%@page import="com.amarsoft.dict.als.manage.CodeManager"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main00;Describe=注释区;]~*/%>
	<%
	/*
		Author: syang 2009/10/14 选择代码
		Tester:
		Describe: 选择代码;
		Input Param:
		Output param:
		History Log: 
	 */
	%>
<%/*~END~*/%>

<%
	String sCaption  = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("Caption"));				//选择框标题
	String sDefaultValue  = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("DefaultValue"));				//选择框标题
	String sCodeNo  = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("CodeNo"));					//从已有的代码中仅仅匹配的代码
	String sItemNoExp  = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ItemNoExpr"));				//匹配表达式，如10*
	
	if(sCaption == null) sCaption = "代码选择";
	if(sDefaultValue == null) sDefaultValue = "";
	if(sCodeNo == null) throw new Exception("参数Code未传入");
	if(sItemNoExp == null) sItemNoExp = "";
	
	//取出代码对象
	Item[] codeDef = CodeManager.getItems(sCodeNo);
	if(codeDef == null) throw new Exception("未找到代码"+sCodeNo);
	
	//遍历代码
	Vector list = new Vector();
	for(int i=0;i<codeDef.length;i++){
		String[] option = new String[2];
		Item vpItem = codeDef[i];
		String sTmp = (String)vpItem.getItemNo();	//取出ItemNo的值，进行匹配
		if(!sItemNoExp.equals("")){
			if(sTmp.matches(sItemNoExp)){
				option[0] = sTmp;
				option[1] = (String)vpItem.getItemName();
				list.add(option);
			}
		}else{
			option[0] = (String)vpItem.getItemNo();
			option[1] = (String)vpItem.getItemName();
			list.add(option);
		}
	}
%>
<html>
<head> 
<title><%=sCaption%></title>
<script type="text/javascript">
function returnSelected(){
		self.returnValue=document.getElementById("ValueField").value;
		self.close();
}
</script>
<style>
.black9pt {  font-size: 9pt; color: #000000; text-decoration: none}
</style>
</head>
<body bgcolor="#DCDCDC">
<br>
  <table align="center" width="260" border='1' cellspacing='0' bordercolor='#999999' bordercolordark='#FFFFFF'>
    <tr> 
      <td nowarp align="right" class="black9pt" bgcolor="#DCDCDC" >请选择<%=sCaption%></td>
      <td nowarp bgcolor="#DCDCDC" > 
        <select id="ValueField">
					<option value="">&nbsp;</option>
					<% 
					for(int i=0;i<list.size();i++){
						String[] option = (String[])list.get(i);
						//设置默认值
						if(sDefaultValue.equals(option[0])){
							out.println("<option value='"+option[0]+"' selected>"+option[1]+"</option>");
						}else{
							out.println("<option value='"+option[0]+"'>"+option[1]+"</option>");
						}
					} 
					%>
        </select>
      </td>
    </tr>
    <tr>
      <td nowarp align="right" class="black9pt" bgcolor="#DCDCDC" height="25" >&nbsp;</td>
      <td nowarp bgcolor="#DCDCDC" height="25"> 
        <input type="button" name="next" value="确认" onClick="javascript:returnSelected()" style="font-size:9pt;padding-top:3;padding-left:5;padding-right:5;background-image:url(../../Resources/functionbg.gif); border: #DEDFCE;  border-style: outset; border-top-width: 1px; border-right-width: 1px;  border-bottom-width: 1px; border-left-width: 1px" border='1'>
        <input type="button" name="Cancel" value="取消" onClick="javascript:self.returnValue='_CANCEL_';self.close()" style="font-size:9pt;padding-top:3;padding-left:5;padding-right:5;background-image:url(../../Resources/functionbg.gif); border: #DEDFCE;  border-style: outset; border-top-width: 1px; border-right-width: 1px;  border-bottom-width: 1px; border-left-width: 1px" border='1'>
      </td>
    </tr>
  </table>
</body>
</html>
<%@ include file="/IncludeEnd.jsp"%>