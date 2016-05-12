<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>
<%@page import="com.amarsoft.app.accounting.product.ProductManage"%>
<%
	String termID =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("TermID"));
	if(termID==null)termID = "";
	String objectType =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectType"));
	if(objectType==null)objectType = "";
	String objectNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectNo"));
	if(objectNo==null)objectNo = "";

	String sql="select * from PRODUCT_TERM_PARA where termID='"+termID+"' and objectType='"+objectType+"' and objectNo='"+objectNo+"'";
	ASResultSet rs=Sqlca.getASResultSet(sql);
	while(rs.next()){
		String paraID = rs.getString("ParaID");
		String maxValue=DataConvert.toRealString(iPostChange,(String)CurPage.getParameter(paraID+"_Max"));
		if(maxValue==null||maxValue.length()==0)maxValue="null";
		String minValue=DataConvert.toRealString(iPostChange,(String)CurPage.getParameter(paraID+"_Min"));
		if(minValue==null||minValue.length()==0)minValue="null";
		String defaultValue=DataConvert.toRealString(iPostChange,(String)CurPage.getParameter(paraID+"_DV"));
		if(defaultValue==null)defaultValue="";
		String valueList=DataConvert.toRealString(iPostChange,(String)CurPage.getParameter(paraID+"_VL"));
		if(valueList==null)valueList="";
		String valueListName=DataConvert.toRealString(iPostChange,(String)CurPage.getParameter(paraID+"_VLN"));
		if(valueListName==null)valueListName="";
		if(maxValue==null)maxValue="";
		sql="MaxValue="+maxValue+",MinValue="+minValue+",defaultValue='"+defaultValue+"',valueList='"+valueList+"',valueListName='"+valueListName+"'";
		
		String updatesql = "";
		if("Term".equals(objectType)){
			updatesql ="update PRODUCT_TERM_PARA set "+sql+" where TermID='"+termID+"' "+
					" and ParaID='"+paraID+"' ";
		}else{
			updatesql ="update PRODUCT_TERM_PARA set "+sql+" where TermID='"+termID+"' "+
					" and ParaID='"+paraID+"' and ObjectType='"+objectType+"' and ObjectNo='"+objectNo+"'";
		}
		 
		Sqlca.executeSQL(updatesql);
	}
	rs.getStatement().close();
%>
	<script language=javascript>
		self.returnValue = "±£´æ³É¹¦£¡";   
	    self.close();    
	</script>
<%@ include file="/IncludeEnd.jsp"%>
