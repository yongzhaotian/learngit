<%@ page import="com.amarsoft.xquery.*,org.w3c.dom.*"%>
<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBeginMD.jsp"%><%
	/*
		Describe: ѡ���ѯ�ֶ�Ҫ��ʾ��������
		Input Param:
			--sSelectCol  :�ֶ���
			--sSelectedCol������
	 */
	//���ҳ��������ֶ��С�����
	String sSelectedCol   = DataConvert.toRealString(iPostChange,CurPage.getParameter("SelectedCol"));
	String sColName = DataConvert.toRealString(iPostChange,CurPage.getParameter("ColName"));
	String sSelectCol="";
	
	XQuery xquery = new XQuery((String)session.getAttribute("xmlPath"),(String)session.getAttribute("queryType"));
	String as1[] = xquery.getCodeItemDefinition(sColName);
	String as2[][] = {
						{ "CodeItemName", as1[0].trim(), "" },
						{ "ColumnName", sColName, "" },
						{ "ColumnNameWithoutID", StringFunction.replace(sColName, "ID", "Name"), "" },
						{ "RelatedDataObjectName", "", "" },
						{ "LeftEmbrace", "<", "" },
						{ "RightEmbrace", ">", "" },
						{ "EnvironmentOrgID", CurUser.getOrgID(), "" } ,
						{ "QueryType", xquery.querytype, "" } 
	};
	Vector vector = xquery.convertStringArrayToParameterVector(as2);
	String sSql = xquery.getStringWithParameterReplaced(as1[1], vector);
	ASResultSet rs=Sqlca.getASResultSet(sSql);
  	while(rs.next()){
  		sSelectCol += "@@"+rs.getString(1)+"@"+rs.getString(2);
  	}
  	rs.getStatement().close();
  	sSelectCol = sSelectCol.substring(2);
%>
<html>
<head>
<title>�ֶ�ѡ����</title>
</head>
<body leftmargin="0" topmargin="0" bgcolor='#DDDDDD'>
<form method='POST' align='center' name='customize'>
<table width='100%' border='1' align='center' cellpadding='0' cellspacing='8' bgcolor='#DDDDDD'>
	<tr>
		<td bgcolor='#DDDDDD'>
			<span class='dialog-label'>&nbsp;��ѡȡ�ֶ��б�</span>
		</td>
	</tr>
	<tr>
		<td align='center'>
			<select name='select1'  size='17'  style='width:100%;' width='100%' multiple='true'>
			<option></option>
			</select>
		</td>
	</tr>
	<tr>
    	<td align='center'>
      		<input type="button" style="width:70px"  value="ȷ ��" onclick="javascript:doQuery();">
      		<input type="button" style="width:70px"  value="�� ��" onclick="javascript:doBack();">
      		<input type="button" style="width:70px"  value="ȡ ��" onclick="javascript:doCancel();">
    	</td>
	</tr>
</table>
</form>
</body>
</html>
<script type="text/javascript">
	/*~[Describe=ȡ��;]~*/
	function doCancel(){
		self.returnValue="XXXXXXXXXXXXXXX";
		self.close();
	}
	
	/*~[Describe=ȷ��;]~*/
	function doQuery(){
		text="";
		var m=0;
		for (i=0; i < customize.select1.length; i++){
			if(customize.select1.item(i).selected){
				m=i;
				break;
			}
		}
		for (i=0; i < customize.select1.length; i++){
			if(customize.select1.item(i).selected){
				if(m==i){
					text=customize.select1.options[i].text+"@"+customize.select1.options[i].value;
				}else{
					text= text+"@@"+customize.select1.options[i].text+"@"+customize.select1.options[i].value;
				}
			}
		}
		self.returnValue=text;
		self.close();
	}
	
	/*~[Describe=����;]~*/
	function doBack(){
		for (var i=0; i < customize.select1.length; i++){
			if(customize.select1.item(i).selected){
				customize.select1.item(i).selected=false;
			}
		}
		self.close();
	}

	/*~[Describe=֧��ESC�ر�ҳ��;]~*/
	document.onkeydown = function(){
		if(event.keyCode==27){
			doCancel();
		}
	};
	
	/*~[Describe=ȱʡ;]~*/
	function doDefault(stemp,stemp2){
		for(s=customize.select1.options.length-1;s>=0;s--){
			customize.select1.options[s]=null;
		}
		var sTemp1=stemp.split("@@");
		var sTemp4=stemp2.split("@");
		for(s=0;s<sTemp1.length;s++){
			var sTemp2=sTemp1[s].split("@");
			customize.select1.options[s]=new Option(sTemp2[1],sTemp2[0]);
		}
	
		for(f=0;f<customize.select1.options.length;f++){
			for(d=0;d<sTemp4.length;d++){
				if(sTemp4[d].length!=0){
					if(sTemp4[d]==customize.select1.item(f).value){
						customize.select1.options[f].selected=true;
					}
				}
			}
		}
	}
	doDefault("<%=sSelectCol%>","<%=sSelectedCol%>");
</script>
<%@ include file="/IncludeEnd.jsp"%>