<%@ page contentType="text/html; charset=GBK"%>
<!-- 
��ҳ�����dono������ʾdw��Ϣ
��linklist.jspf��linkinfo.jspf����
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
	out.println("��Ч����</body></html>");
	return;
}
BizObjectManager manager = JBOFactory.getFactory().getManager("jbo.ui.system.DATAOBJECT_CATALOG");
BizObjectKey key = manager.getBizObjectKey();
key.setAttributeValue("dono",sDono);
BizObject catalog = manager.getBizObject(key);
if(catalog==null){
	out.println("û���ҵ����������ļ�¼</body></html>");
	return;
}
%>
<table width="100%" border="1" cellpadding="3" cellspacing="0">
  <tr>
    <td colspan="4" bgcolor="#B0C4DE"><strong>ҵ�񳡾���DATAOBJECT_CATALOG��</strong></td>
  </tr>
  <tr>
    <td bgcolor="#FDF5E6">ҳ��(url):</td>
    <td colspan="3"><%=request.getParameter("url")%></td>
  </tr>
  <tr>
    <td bgcolor="#FDF5E6">��ʾģ����(dono):</td>
    <td colspan="3"><%=PublicFuns.filterHtmlStr(catalog.getAttribute("dono").getString())%></td>
  </tr>
  <tr>
    <td bgcolor="#FDF5E6">JBO�������(jboclass):</td>
    <td colspan="3"><%=PublicFuns.filterHtmlStr(catalog.getAttribute("jboclass").getString())%></td>
  </tr>
  <tr>
    <td bgcolor="#FDF5E6">ҵ��ģ��(businessprocess):</td>
    <td colspan="3"><%=PublicFuns.filterHtmlStr(catalog.getAttribute("businessprocess").getString())%></td>
  </tr>
  <tr>
    <td bgcolor="#FDF5E6">��ѯ����(jbowhere)</td>
    <td colspan="3"><%=PublicFuns.filterHtmlStr(catalog.getAttribute("jbowhere").getString())%></td>
  </tr>
  <tr>
    <td  bgcolor="#FDF5E6" width="25%">��ѯ��Դ��(jbofrom)</td>
    <td colspan="3"><%=PublicFuns.filterHtmlStr(catalog.getAttribute("jbofrom").getString())%></td>
  </tr>
  <tr>
    <td colspan="4">&nbsp;</td>
  </tr>
  <tr>
  	<td width="25%">����(doname)</td>
    <td width="25%"><%=PublicFuns.filterHtmlStr(catalog.getAttribute("doname").getString())%></td>
    <td width="25%">��Ч(isinuse)</td>
    <td width="25%"><%=catalog.getAttribute("isinuse").getString().equals("1")?"��":"��"%></td>
    
  </tr>
  <tr>
    <td>����(doclass)</td>
    <td><%=CodeManager.getItemName("DOType",catalog.getAttribute("doclass").getString())%></td>
    <td>��;(dotype)</td>
    <td><%=CodeManager.getItemName("DOType",catalog.getAttribute("dotype").getString())%></td>
  </tr>
  
  <tr>
    <td>������(colcount)</td>
    <td><%=PublicFuns.filterHtmlStr(catalog.getAttribute("colcount").getString())%></td>
    <td>�����(modeid)</td>
    <td><%=PublicFuns.filterHtmlStr(catalog.getAttribute("MODEID").getString())%></td>
  </tr>
  
  <tr>
    <td>����(jboorder)</td>
    <td><%=PublicFuns.filterHtmlStr(catalog.getAttribute("jboorder").getString())%></td>
    <td>����(jbogroup)</td>
    <td><%=PublicFuns.filterHtmlStr(catalog.getAttribute("jbogroup").getString())%></td>
  </tr>
  <tr>
    <td>��ע(remark)</td>
    <td colspan="3"><%=PublicFuns.filterHtmlStr(catalog.getAttribute("remark").getString())%></td>
  </tr>
</table>
<br>
<table border="1"> 
  <tr>
    <td colspan="27" bgcolor="#B0C4DE"><strong>�ֶ���Ϣ��DATAOBJECT_LIBRARY��</strong></td>
  </tr>
  <tr>
    <td>���(COLINDEX)</td>
    <td>�����(SORTNO)</td>
    <td>�Ƿ�ʹ��(ISINUSE)</td>
    <td>��λ������(COLHEADER)</td>
    <td>��ʾ��׺(COLUNIT)</td>
    <td>JBO����(COLTABLENAME)</td>
    <td>JBO������(COLACTUALNAME)</td>
    <td>��λӢ����(COLNAME)</td>
    <td>�ɼ�(COLVISIBLE)</td>
    <td>ֻ��(COLREADONLY)</td>
    <td>����(COLREQUIRED)</td>
    <td>��ѯ(ISFILTER)</td>
    <td>ֵ����(COLTYPE)</td>
    <td>ȱʡֵ(COLDEFAULTVALUE)</td>
    <td>��ʽ���(COLCHECKFORMAT)</td>
    <td>����(COLALIGN)</td>
    <td>�༭��ʽ(COLEDITSTYLE)</td>
    <td>��������Դ(COLEDITSOURCETYPE)</td>
    <td>��Դ����(COLEDITSOURCE)</td>
    <td>HTML��ʽ(COLHTMLSTYLE)</td>
    <td>��������(COLLIMIT)</td>
    <td>������(COLSORTABLE)</td>
    <td>�Զ�������ʾ(ISAUTOCOMPLETE)</td>
    <td>������ʵ���ֶ�(COLFILTERREFID)</td>
    <td>�Ƿ�Sum(COLCOLUMNTYPE)</td>
    <td>������(GROUPID)</td>
    <td>�缸��(COLCOUNT)0</td>
  </tr>
<% 
  String[] fieldArray = {"COLINDEX","SORTNO","ISINUSE","COLHEADER","COLUNIT","COLTABLENAME","COLACTUALNAME","COLNAME","COLVISIBLE","COLREADONLY"
		  ,"COLREQUIRED","ISFILTER","COLTYPE","COLDEFAULTVALUE","COLCHECKFORMAT","COLALIGN","COLEDITSTYLE","COLEDITSOURCETYPE","COLEDITSOURCE","COLHTMLSTYLE"
		  ,"COLLIMIT","COLSORTABLE","ISAUTOCOMPLETE","COLFILTERREFID","COLCOLUMNTYPE","GROUPID","COLSPAN"};
  String[] aYesNoFields = {"ISINUSE","COLVISIBLE","COLREADONLY","COLREQUIRED","ISFILTER","COLSORTABLE","ISAUTOCOMPLETE"};//ʹ�� 0 1 ��ǵ��ֶ�
  BizObjectManager manager2 = JBOFactory.getFactory().getManager("jbo.ui.system.DATAOBJECT_LIBRARY");
  BizObjectQuery query = manager2.createQuery("dono=:dono and isinuse='1' order by colindex");
  query.setParameter("dono",sDono);
  List list = query.getResultList();
  if(list==null || list.size()==0){
%>
	<tr>
    	<td colspan="27">û������</td>
    </tr>
<%
  }
  else{
	  for(int i=0;i<list.size();i++){
		  BizObject obj = (BizObject)list.get(i);
		  out.println("<tr>");
		  for(int j=0;j<fieldArray.length;j++){
			  String sValue = "";
			  if(PublicFuns.strInArr(aYesNoFields,fieldArray[j])>-1)//0 1 ����
				  sValue = obj.getAttribute(fieldArray[j]).getString().equals("1")?"��":"��";
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