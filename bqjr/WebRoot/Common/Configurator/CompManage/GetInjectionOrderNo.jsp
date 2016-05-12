<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>

<%
	String sTargetCompID = DataConvert.toRealString(iPostChange,CurPage.getParameter("TargetCompID"));
	String sTargetOrderNo = DataConvert.toRealString(iPostChange,CurPage.getParameter("TargetOrderNo"));
	
	int iTargetLength = sTargetOrderNo.length();
	
%>


<script type="text/javascript">

function doConfirm(){
	//alert(GetPropertiesString(InjectionType[0]));
	var checkedType = getCheckType();
	top.returnValue=checkedType;
	top.close();
}

function doCancel(){

}

function getCheckType(){
	for(var i=0;i<InjectionType.length;i++){
		if(InjectionType[i].checked) return InjectionType[i].value;
	}
}
</script>

<%@ include file="/IncludeEnd.jsp"%>
