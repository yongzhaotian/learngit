<%@ page contentType="text/html; charset=GBK"%>
<!-- 
本页面根据dono参数显示dw信息
被linklist.jspf和linkinfo.jspf调用
 -->
<%@ page import="com.amarsoft.are.ARE,com.amarsoft.are.jbo.*,java.util.*,com.amarsoft.dict.als.manage.*,com.amarsoft.awe.dw.ui.util.PublicFuns"%>
<html>
<head>
<style>
body{font-size:12px;}
table{border:0;margin:0;border-collapse:collapse;} table th, table td{padding:0;}
td{border:1px solide #000000;font-size:12px;}
</style>
</head>
<body>
<%
String sDono = request.getParameter("dono");
if(sDono==null){
	out.println("无效参数</body></html>");
	return;
}
BizObjectManager manager = JBOFactory.getFactory().getManager("jbo.ui.system.DATAOBJECT_CATALOG");
BizObjectKey key = manager.getBizObjectKey();
key.setAttributeValue("dono",sDono);
BizObject catalog = manager.getBizObject(key);
if(catalog==null){
	out.println("没有找到符合条件的记录</body></html>");
	return;
}
%>
<table width="100%" border="1" cellpadding="3" cellspacing="0">
  <tr>
    <td colspan="4" bgcolor="#B0C4DE"><strong>业务场景（DATAOBJECT_CATALOG）</strong></td>
  </tr>
  <tr>
    <td bgcolor="#FDF5E6">页面(url):</td>
    <td colspan="3"><%=request.getParameter("url")%></td>
  </tr>
  <tr>
    <td bgcolor="#FDF5E6">显示模板编号(dono):</td>
    <td colspan="3"><%=PublicFuns.filterHtmlStr(catalog.getAttribute("dono").getString())%></td>
  </tr>
  <tr>
    <td bgcolor="#FDF5E6">JBO定义表名(jboclass):</td>
    <td colspan="3"><%=PublicFuns.filterHtmlStr(catalog.getAttribute("jboclass").getString())%></td>
  </tr>
  <tr>
    <td bgcolor="#FDF5E6">业务模型(businessprocess):</td>
    <td colspan="3"><%=PublicFuns.filterHtmlStr(catalog.getAttribute("businessprocess").getString())%></td>
  </tr>
  <tr>
    <td bgcolor="#FDF5E6">查询条件(jbowhere)</td>
    <td colspan="3"><%=PublicFuns.filterHtmlStr(catalog.getAttribute("jbowhere").getString())%></td>
  </tr>
  <tr>
    <td  bgcolor="#FDF5E6" width="25%">查询来源表(jbofrom)</td>
    <td colspan="3"><%=PublicFuns.filterHtmlStr(catalog.getAttribute("jbofrom").getString())%></td>
  </tr>
  <tr>
    <td colspan="4">&nbsp;</td>
  </tr>
  <tr>
  	<td width="25%">名称(doname)</td>
    <td width="25%"><%=PublicFuns.filterHtmlStr(catalog.getAttribute("doname").getString())%></td>
    <td width="25%">有效(isinuse)</td>
    <td width="25%"><%=catalog.getAttribute("isinuse").getString().equals("1")?"是":"否"%></td>
    
  </tr>
  <tr>
    <td>分类(doclass)</td>
    <td><%=CodeManager.getItemName("DOType",catalog.getAttribute("doclass").getString())%></td>
    <td>用途(dotype)</td>
    <td><%=CodeManager.getItemName("DOType",catalog.getAttribute("dotype").getString())%></td>
  </tr>
  
  <tr>
    <td>分栏数(colcount)</td>
    <td><%=PublicFuns.filterHtmlStr(catalog.getAttribute("colcount").getString())%></td>
    <td>风格编号(modeid)</td>
    <td><%=PublicFuns.filterHtmlStr(catalog.getAttribute("MODEID").getString())%></td>
  </tr>
  
  <tr>
    <td>排序(jboorder)</td>
    <td><%=PublicFuns.filterHtmlStr(catalog.getAttribute("jboorder").getString())%></td>
    <td>分组(jbogroup)</td>
    <td><%=PublicFuns.filterHtmlStr(catalog.getAttribute("jbogroup").getString())%></td>
  </tr>
  <tr>
    <td>备注(remark)</td>
    <td colspan="3"><%=PublicFuns.filterHtmlStr(catalog.getAttribute("remark").getString())%></td>
  </tr>
</table>
<br>
<table border="1"> 
  <tr>
    <td colspan="27" bgcolor="#B0C4DE"><strong>字段信息（DATAOBJECT_LIBRARY）</strong></td>
  </tr>
  <tr>
    <td>序号(COLINDEX)</td>
    <td>排序号(SORTNO)</td>
    <td>是否使用(ISINUSE)</td>
    <td>栏位中文名(COLHEADER)</td>
    <td>显示后缀(COLUNIT)</td>
    <td>JBO类名(COLTABLENAME)</td>
    <td>JBO属性名(COLACTUALNAME)</td>
    <td>栏位英文名(COLNAME)</td>
    <td>可见(COLVISIBLE)</td>
    <td>只读(COLREADONLY)</td>
    <td>必需(COLREQUIRED)</td>
    <td>查询(ISFILTER)</td>
    <td>值类型(COLTYPE)</td>
    <td>缺省值(COLDEFAULTVALUE)</td>
    <td>格式检查(COLCHECKFORMAT)</td>
    <td>对齐(COLALIGN)</td>
    <td>编辑形式(COLEDITSTYLE)</td>
    <td>下拉框来源(COLEDITSOURCETYPE)</td>
    <td>来源描述(COLEDITSOURCE)</td>
    <td>HTML格式(COLHTMLSTYLE)</td>
    <td>长度限制(COLLIMIT)</td>
    <td>可排序(COLSORTABLE)</td>
    <td>自动输入提示(ISAUTOCOMPLETE)</td>
    <td>关联的实际字段(COLFILTERREFID)</td>
    <td>是否Sum(COLCOLUMNTYPE)</td>
    <td>所属组(GROUPID)</td>
    <td>跨几栏(COLCOUNT)0</td>
  </tr>
<% 
  String[] fieldArray = {"COLINDEX","SORTNO","ISINUSE","COLHEADER","COLUNIT","COLTABLENAME","COLACTUALNAME","COLNAME","COLVISIBLE","COLREADONLY"
		  ,"COLREQUIRED","ISFILTER","COLTYPE","COLDEFAULTVALUE","COLCHECKFORMAT","COLALIGN","COLEDITSTYLE","COLEDITSOURCETYPE","COLEDITSOURCE","COLHTMLSTYLE"
		  ,"COLLIMIT","COLSORTABLE","ISAUTOCOMPLETE","COLFILTERREFID","COLCOLUMNTYPE","GROUPID","COLSPAN"};
  String[] aYesNoFields = {"ISINUSE","COLVISIBLE","COLREADONLY","COLREQUIRED","ISFILTER","COLSORTABLE","ISAUTOCOMPLETE"};//使用 0 1 标记的字段
  BizObjectManager manager2 = JBOFactory.getFactory().getManager("jbo.ui.system.DATAOBJECT_LIBRARY");
  BizObjectQuery query = manager2.createQuery("dono=:dono and isinuse='1' order by colindex");
  query.setParameter("dono",sDono);
  List list = query.getResultList();
  if(list==null || list.size()==0){
%>
	<tr>
    	<td colspan="27">没有数据</td>
    </tr>
<%
  }
  else{
	  for(int i=0;i<list.size();i++){
		  BizObject obj = (BizObject)list.get(i);
		  out.println("<tr>");
		  for(int j=0;j<fieldArray.length;j++){
			  String sValue = "";
			  if(PublicFuns.strInArr(aYesNoFields,fieldArray[j])>-1)//0 1 处理
				  sValue = obj.getAttribute(fieldArray[j]).getString().equals("1")?"是":"否";
			  else if(fieldArray[j].equals("COLCHECKFORMAT")){
				  sValue = CodeManager.getItemName("CheckFormat",obj.getAttribute(fieldArray[j]).getString());
			  }
			  else if(fieldArray[j].equals("COLALIGN")){
				  sValue = CodeManager.getItemName("ColAlign",obj.getAttribute(fieldArray[j]).getString());
			  }
			  else if(fieldArray[j].equals("COLEDITSOURCETYPE")){
				  sValue = CodeManager.getItemName("ColEditSourceType",obj.getAttribute(fieldArray[j]).getString());
				  if(sValue==null || sValue.equals(""))sValue = "&nbsp;";
			  }
			  else if(fieldArray[j].equals("COLEDITSTYLE")){
				  sValue = obj.getAttribute(fieldArray[j]).getString();
				  if(sValue == null) sValue = "";
				  if(sValue.equals("1"))
					  sValue="Text";
				  else if(sValue.equals("2"))
					  sValue="Select";
				  else if(sValue.equals("3"))
					  sValue="Textarea";
				  sValue = CodeManager.getItemName("COLINPUTTYPE",sValue);
				  if(sValue==null || sValue.equals(""))sValue = "&nbsp;";
			  }
			  else
				  sValue = PublicFuns.filterHtmlStr(obj.getAttribute(fieldArray[j]).getString());
			  out.println("<td>"+ sValue +"</td>");
		  }
		  out.println("</tr>");	  
	  }
  }
%>
</table>
</body>
</html>