<%@page import="com.amarsoft.dict.als.object.ObjectTypeRela"%>
<%@page import="com.amarsoft.awe.res.AppBizObject"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<link rel="stylesheet" href="<%=sResourcesPath%>/css/tabs.css">
<link rel="stylesheet" href="<%=sSkinPath%>/css/tabs.css">
<script type='text/javascript' src='<%=sResourcesPath%>/js/plugins/tabstrip-1.0.js'></script>
<%
	/*
		ҳ��˵��: tabҳ�鿴������Ϣ
	 */
	//�������
	String sTitle = "";
	//���ҳ������� ObjectNo�������� ��ObjectType����������
	String sObjectNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectNo"));
	String sObjectType =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectType"));	
	String sViewID =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ViewID"));
	String sSureType = Sqlca.getString(new SqlObject("select sureType from Business_Contract where SerialNo = SerialNo").setParameter("SerialNo", sObjectNo));
	 CurARC.setAttribute("BQContractNo", sObjectNo);
	if (sObjectNo == null) sObjectNo = "";
	if (sObjectType == null) sObjectType = "";
	if (sViewID == null) sViewID = "001";
%>
<script type="text/javascript">
	$(document).ready(function(){
		var tabCompent = new TabStrip("T001","<%=sObjectType%>","tab","#tab06_code_part");
		tabCompent.setSelectedItem("0");
		tabCompent.setIsDialogTitle(true);		//�Ƿ���ʾ�Ի������
		<%
		ArrayList<ObjectTypeRela> relaList = AppBizObject.getObjectRelaList(Sqlca,sObjectType,sObjectNo,sViewID);
		//���ݶ��������� tab
		for(int i=0;i<relaList.size();i++){ 
			if(relaList.get(i). getObjectType()!= null&&relaList.get(i). getDisplayName() != null&&relaList.get(i). getViewExpr() != null){
				System.out.println(relaList.get(i). getObjectType()+"---"+relaList.get(i). getDisplayName()+"---"+relaList.get(i). getViewExpr());
					//add by xswang CSS-889 ��Ǯô���װٷ������ᵥϵͳ��Ҫ���ε�Э��ģ��
					if(("JQM".equals(sSureType) || "EBF".equals(sSureType)) && "AssistInvestigate".equals(relaList.get(i). getObjectType())){
						continue;
					}
					//end
				out.println("tabCompent.addDataItem('"+i+"',\""+relaList.get(i). getDisplayName()+"\",\""+relaList.get(i). getViewExpr() +"\",true,false);");
			}
		}
		%>
		tabCompent.initTab();
	});
</script>
<html>
<head>
<title><%=sTitle%></title>
</head> 
<body leftmargin="0" topmargin="0" class="pagebackground" style="margin:0;padding:0;">
<div id="tab06_code_part" style="border:0px solid #F00;z-index:-1;width:100%;height:100%;padding:0,0.5%">&nbsp;</div>
</body>
</html>
<%@ include file="/IncludeEnd.jsp"%>