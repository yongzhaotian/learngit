<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%@page import="com.amarsoft.biz.evaluate.*" %>
<% 
    //�������
	int    i = 0 ;//--������
	String sMessage = "";//--������ʾ��Ϣ
	String sObjectName="";//--��������
	String sModelName="";//--ģ������
	String sModelType="";//--ģ������
	String sItemName="";//--�������
	String sItemValue="";//--���ֵ
	String sItemNo="";//����
	String sValueCode="";//--ֵ���
	String sValueMethod="";//--ֵ����
	String sValueType="";//--ֵ����
	String sSql="";//--���sql
	ASResultSet rs = null;//--��Ž��
	String sEvaDate="";//--��������
	String sEvaResult="";//--�������
	float dEvaScore=0;//--������֮
	String sEvaluateScore="�÷֣�",sEvaluateResult="�����",CurYear="";
	String sBelongAttribute = "";//--����Ȩ
	String sBelongAttribute1 = "";//--�鿴Ȩ
	String sBelongAttribute2 = "";//--ά��Ȩ
	boolean isEditable=true;//�Ƿ���Ա��桢����
	SqlObject so = null;
	String sNewSql = "";	
	
  	//���ҳ�����  Action : ��������;	ObjectType: ��������; ObjectNo: ������; SerialNo : ������ˮ��
	String sAction     = CurPage.getParameter("Action");
	String sObjectType = CurPage.getParameter("ObjectType");
	String sObjectNo   = CurPage.getParameter("ObjectNo"); 
	String sSerialNo   = CurPage.getParameter("SerialNo");
	String sCustomerID   = CurPage.getParameter("CustomerID");
	String sEditable =  CurPage.getParameter("Editable");
	String sModelNo = CurPage.getParameter("ModelNo");
	//���ñ��桢�����Ȩ��
	//if(!CurUser.getUserID().equals("test11")) isEditable = false;//ȡ��ֻ��test11����¼��ģ�����ݵ��ж���modified by ttshao
	if("false".equals(sEditable)) isEditable=false;
	//����ֵת��Ϊ���ַ���
	if(sAction == null) sAction = "";
	if(sObjectType == null) sObjectType = "";
	if(sObjectNo == null) sObjectNo = "";
	if(sSerialNo == null) sSerialNo = "";
	if(sCustomerID == null) sCustomerID = "";
	if(sModelNo == null) sModelNo = "";
	
	Evaluate eEvaluate    = new Evaluate(sObjectType,sObjectNo,sSerialNo,Sqlca);
%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=���ݲ�ͬ�Ĳ�����ȷ������ģ�Ͳ�����Ӧ�ı��桢ɾ��������Ĵ���;]~*/%>
<%	
	if(eEvaluate.ModelNo.equals("RiskEvaluate")){
		sEvaluateScore="���նȣ�";
		sEvaluateResult="";
	}
	//add �޸�ģ�Ͳ���������
	if(eEvaluate.ModelNo.equals("LiquidityForecast")){
		sEvaluateScore="���������ʽ�����Ȳο�ֵ��";
		sEvaluateResult="Ԫ";
	}
	//add end
	if(eEvaluate.ModelNo.equals("CreditLine")){
		sEvaluateScore="��������ۺ������޶�ο�ֵ��";
		sEvaluateResult="��Ԫ";
	}
	
	//�ж��û�Ȩ��
	sNewSql = " select BelongAttribute,BelongAttribute1,BelongAttribute2 " +
			" from CUSTOMER_BELONG " +
			" where CustomerID=:CustomerID and UserID=:UserID and OrgID=:OrgID";
	so = new SqlObject(sNewSql);
	so.setParameter("CustomerID",sCustomerID);
	so.setParameter("UserID",CurUser.getUserID());
	so.setParameter("OrgID",CurUser.getOrgID());
	rs = Sqlca.getASResultSet(so);
	while (rs.next()) {
		sBelongAttribute = rs.getString(1);
		sBelongAttribute1 = rs.getString(2);
		sBelongAttribute2 = rs.getString(3);
	}
	rs.getStatement().close();
	
	//�õ�ģ������,����
	rs = Sqlca.getASResultSet(new SqlObject("select ModelName,ModelType from EVALUATE_CATALOG where ModelNo=:ModelNo").setParameter("ModelNo",eEvaluate.ModelNo));
	if (rs.next()){	
		sModelName = rs.getString(1);
		sModelType = rs.getString(2);
	}
	rs.getStatement().close();
	String sModelTypeName = Sqlca.getString(new SqlObject("select ItemName from CODE_LIBRARY where CodeNo='EvaluateModelType' and ItemNo=:ItemNo").setParameter("ItemNo",sModelType));
	String sModelTypeAttributes = Sqlca.getString(new SqlObject("select RelativeCode from CODE_LIBRARY where CodeNo='EvaluateModelType' and ItemNo=:ItemNo").setParameter("ItemNo",sModelType));

	if(sModelTypeAttributes==null) throw new Exception("ģ������ ["+sModelType+"] �����Լ� û�ж��壬��鿴CODE_LIBRARY:EvaluateModelType��RelativeCode����");
	String sDisplayFinalResult = StringFunction.getProfileString(sModelTypeAttributes,"DisplayFinalResult");
	String sDisplayItemScore = StringFunction.getProfileString(sModelTypeAttributes,"DisplayItemScore");
	String sButtonSaveFace = StringFunction.getProfileString(sModelTypeAttributes,"ButtonSaveFace");
	String sButtonCalcFace = StringFunction.getProfileString(sModelTypeAttributes,"ButtonCalcFace");
	String sButtonDelFace = StringFunction.getProfileString(sModelTypeAttributes,"ButtonDelFace");
	String sButtonCloseFace = StringFunction.getProfileString(sModelTypeAttributes,"ButtonCloseFace");
	String sItemValueDisplayWidth = StringFunction.getProfileString(sModelTypeAttributes,"ItemValueDisplayWidth");
	if(sItemValueDisplayWidth==null || sItemValueDisplayWidth.equals("")) sItemValueDisplayWidth="100";		
	
	if (sObjectType.equals("Customer")|| sObjectType.equals("MaxCreditLine")) //�ͻ�
		sObjectName = Sqlca.getString(new SqlObject("select CustomerName from CUSTOMER_INFO where CustomerID=:CustomerID").setParameter("CustomerID",sObjectNo));
	else //ҵ������
		sObjectName = Sqlca.getString(new SqlObject("select CustomerName||'*'||nvl(getBusinessName(BusinessType),'') from BUSINESS_APPLY where SerialNo=:SerialNo").setParameter("SerialNo",sObjectNo));

	if(sAction.equals("update") || sAction.equals("evaluate")){
		if (eEvaluate.Data.first()){
			do {
				i ++;
				sItemName  = "R" + String.valueOf(i);
				sItemValue = CurPage.getParameter(sItemName);
				sItemNo = eEvaluate.Data.getString("ItemNo");		     		
				if (sItemValue!=null && sItemValue.trim().length()!=0){
					sNewSql = "update EVALUATE_DATA set ItemValue=:ItemValue where ObjectType=:ObjectType and ObjectNo=:ObjectNo "+
								" and SerialNo=:SerialNo and ItemNo=:ItemNo";
					so = new SqlObject(sNewSql);
					so.setParameter("ItemValue",sItemValue);
					so.setParameter("ObjectType",sObjectType);
					so.setParameter("ObjectNo",sObjectNo);
					so.setParameter("SerialNo",sSerialNo);
					so.setParameter("ItemNo",sItemNo);
					Sqlca.executeSQL(so);
				}else{
					sNewSql = "update EVALUATE_DATA set ItemValue=null where ObjectType=:ObjectType and ObjectNo=:ObjectNo "+
							" and SerialNo=:SerialNo and ItemNo=:ItemNo";
					so = new SqlObject(sNewSql);
					so.setParameter("ObjectType",sObjectType);
					so.setParameter("ObjectNo",sObjectNo);
					so.setParameter("SerialNo",sSerialNo);
					so.setParameter("ItemNo",sItemNo);
					Sqlca.executeSQL(so);
				}			
			}while(eEvaluate.Data.next());	
		}
		eEvaluate.getRecord();
		eEvaluate.getData(); 
		sMessage =  "���ݱ�����ɣ�";  		 
		
		if(sAction.equals("evaluate")) {
			eEvaluate.evaluate();
			eEvaluate.getRecord();
			eEvaluate.getData();  
	
			//�õ�ϵͳ���������ϵͳ��������,���������������
			sNewSql = "select EvaluateDate,EvaluateScore,EvaluateResult from EVALUATE_RECORD where ObjectType=:ObjectType and ObjectNo=:ObjectNo and SerialNo=:SerialNo";
			so = new SqlObject(sNewSql);
			so.setParameter("ObjectType",sObjectType);
			so.setParameter("ObjectNo",sObjectNo);
			so.setParameter("SerialNo",sSerialNo);
			rs = Sqlca.getASResultSet(so);
			if (rs.next()){	
				sEvaDate = rs.getString(1);
				dEvaScore = rs.getFloat(2);
				sEvaResult = rs.getString(3);
			}
			rs.getStatement().close();
			
			sNewSql = " Update EVALUATE_RECORD Set CognDate=:CognDate,CognScore=:CognScore,CognResult=:CognResult,"+
		       		" CognOrgID=:CognOrgID,CognUserID=:CognUserID" +
		      		" where ObjectType=:ObjectType and ObjectNo=:ObjectNo and SerialNo=:SerialNo";
			so = new SqlObject(sNewSql);
			so.setParameter("CognDate",sEvaDate);
			so.setParameter("CognScore",dEvaScore);
			so.setParameter("CognResult",sEvaResult);
			so.setParameter("CognOrgID",CurOrg.getOrgID());
			so.setParameter("CognUserID",CurUser.getUserID());
			so.setParameter("ObjectType",sObjectType);
			so.setParameter("ObjectNo",sObjectNo);
			so.setParameter("SerialNo",sSerialNo);
			Sqlca.executeSQL(so);
			
			sNewSql = " select AccountMonth,CognResult from EVALUATE_RECORD Where ObjectNo=:ObjectNo1 and AccountMonth = (select max(AccountMonth) from EVALUATE_RECORD Where ObjectNo=:ObjectNo2)";
			so = new SqlObject(sNewSql);
			so.setParameter("ObjectNo1",sObjectNo);
			so.setParameter("ObjectNo2",sObjectNo);
			rs = Sqlca.getASResultSet(so);
			String sEvaDate1="",sEvaResult1="";
			if (rs.next()){	
				sEvaDate1 = rs.getString(1);
				sEvaResult1 = rs.getString(2);
			}
			rs.getStatement().close();
	
			if(eEvaluate.ModelNo.startsWith("0")){  //��˾�����õȼ�����		
				sNewSql = "Update ENT_INFO  Set EvaluateDate=:EvaluateDate,CreditLevel=:CreditLevel where  CustomerID= :CustomerID";
				so = new SqlObject(sNewSql);
				so.setParameter("EvaluateDate",sEvaDate1);
				so.setParameter("CreditLevel",sEvaResult1);
				so.setParameter("CustomerID",sObjectNo);
				Sqlca.executeSQL(so);
			}
			else if(eEvaluate.ModelNo.equals("RiskEvaluate")){
				sNewSql = "Update BUSINESS_APPLY  Set RiskRate = :RiskRate where  SerialNo= :SerialNo";
				so = new SqlObject(sNewSql);
				so.setParameter("RiskRate",dEvaScore);
				so.setParameter("SerialNo",sObjectNo);
				Sqlca.executeSQL(so);
			}
			else if(eEvaluate.ModelNo.equals("CreditLine")){  //��˾������Ŷ�ȣ�added by yzheng 2013-5-31
				sNewSql = "Update ENT_INFO Set Limit=:Limit where CustomerID= :CustomerID";
				so = new SqlObject(sNewSql);
				so.setParameter("Limit",dEvaScore);
				so.setParameter("CustomerID",sObjectNo);
				Sqlca.executeSQL(so);
			}
			else if(eEvaluate.ModelNo.equals("500") ||eEvaluate.ModelNo.equals("201")){  //���˺͸��徭Ӫ���õȼ�������added by yzheng 2013-5-31
				sNewSql = "Update IND_INFO  Set EvaluateDate=:EvaluateDate,CreditLevel=:CreditLevel where  CustomerID= :CustomerID";
				so = new SqlObject(sNewSql);
				so.setParameter("EvaluateDate",sEvaDate1);
				so.setParameter("CreditLevel",sEvaResult1);
				so.setParameter("CustomerID",sObjectNo);
				Sqlca.executeSQL(so);
			}
			sMessage =  "������ɣ�" ;
		}
	}
%>
<%/*END*/%>


<html>
<head>
<title><%=sModelTypeName%></title>
<style>
.nullPrompt{
	background:#F0E68C;
}
</style>
</head>

<script type="text/javascript"> 
	function evaluateData(){
		var i;
		var b = true;
		for(i = 0;i<=document.forms[0].elements.length-1;i++){
			if(document.forms[0].elements[i].type.substr(0,4)=="text"){
				if(document.forms[0].elements[i].disabled == false){
					document.forms[0].elements[i].focus();					
					$(document.forms[0].elements[i].parentNode).addClass("nullPrompt");
					if(document.forms[0].elements[i].value==""){
						b = false;
						$(document.forms[0].elements[i]).after("<span style='color:#F00'>&nbsp;&nbsp;* ��Ŀ����Ϊ��</span>");
					}else if(document.forms[0].elements[i].value.split(".")[0].length >18){
						b = false;
						$(document.forms[0].elements[i]).after("<span style='color:#F00'>&nbsp;&nbsp;* ������ֵ������Χ</span>");
					}
					else{
						$(document.forms[0].elements[i]).next("span").show();
					}
				}else{
					$(document.forms[0].elements[i].parentNode).removeClass("nullPrompt");
					$(document.forms[0].elements[i]).next("span").hide();
				}
			}
		}
	   		
		for(i = 0;i<=document.forms[0].elements.length-1;i++){
			if(document.forms[0].elements[i].type.substr(0,6)=="select"){
				if(document.forms[0].elements[i].value=="0" && document.forms[0].elements[i].disabled == false){
					document.forms[0].elements[i].focus();
					b = false;
					$(document.forms[0].elements[i].parentNode).addClass("nullPrompt");
					if($(document.forms[0].elements[i]).next("span").html() == null){
						$(document.forms[0].elements[i]).after("<span style='color:#F00'>&nbsp;&nbsp;* ��Ŀ����Ϊ��</span>");
					}else{
						$(document.forms[0].elements[i]).next("span").show();
					}
				}else{
					$(document.forms[0].elements[i].parentNode).removeClass("nullPrompt");
					$(document.forms[0].elements[i]).next("span").hide();
				}
			}
		}
		if(!b) return;
		document.report.action="<%=sWebRootPath%>/Common/Evaluate/EvaluateDetail.jsp?Action=evaluate&CompClientID=<%=SpecialTools.real2Amarsoft(sCompClientID)%>";
		document.report.submit(); 
	}
   
	function updateData(){
		document.report.action="<%=sWebRootPath%>/Common/Evaluate/EvaluateDetail.jsp?Action=update&CompClientID=<%=SpecialTools.real2Amarsoft(sCompClientID)%>";
		document.report.submit();
		//reloadSelf();
	}
   
	function goBack(){
		self.close();
	} 
	
	function initRow(){
		sBelongAttribute = "<%=sBelongAttribute%>";
		sBelongAttribute1 = "<%=sBelongAttribute1%>";
		sBelongAttribute2 = "<%=sBelongAttribute2%>";
		if(sBelongAttribute == "2" && sBelongAttribute1 == "1" && sBelongAttribute2 == "2"&&<%=isEditable%>){
			document.getElementById("updateData").style.display = "none";
			document.getElementById("evaluate").style.display = "none";
		}
	}

	//��ѡ����ƣ�ҳ����ʾ���ƣ�
	function ClassifyChange(){
		//�ԡ����ݷ�����ҵ���õȼ����������п鴦��
		if(<%= "007".equals(eEvaluate.ModelNo) %>){			
			if(document.report.R48.value == "1"){ //����
				document.report.R50.disabled = false;
				//document.report.R50.value = "";
				document.report.R51.disabled = false;
				document.report.R52.disabled = false;
				
				document.report.R54.disabled = true;
				document.report.R55.disabled = true;
				document.report.R56.disabled = true;
				
				document.report.R57.disabled = true;
				document.report.R58.disabled = true;
				document.report.R59.disabled = true;
				
				//document.report.R60.disabled = true;
				//document.report.R61.disabled = true;
			}else if(document.report.R48.value == "2"){ //����
				document.report.R50.disabled = true;
				document.report.R51.disabled = true;
				document.report.R52.disabled = true;
				
				document.report.R54.disabled = false;
				document.report.R55.disabled = false;
				document.report.R56.disabled = false;
				
				document.report.R57.disabled = true;
				document.report.R58.disabled = true;
				document.report.R59.disabled = true;
				
				//document.report.R60.disabled = true;
				//document.report.R61.disabled = true;
			}else if(document.report.R48.value == "3"){ //����
				document.report.R50.disabled = true;
				document.report.R51.disabled = true;
				document.report.R52.disabled = true;
				
				document.report.R54.disabled = true;
				document.report.R55.disabled = true;
				document.report.R56.disabled = true;
							
				document.report.R57.disabled = false;
				
				//document.report.R60.disabled = true;
				//document.report.R61.disabled = true;
				
				if(document.report.R57.value == "1"){ //������
					document.report.R58.disabled = false;
					document.report.R59.disabled = true;
				}else if(document.report.R57.value == "2"){ //���㿪����˾
					document.report.R58.disabled = true;
					document.report.R59.disabled = false;
				}
				
			}else if(document.report.R48.value == "4"){ //����
				document.report.R50.disabled = true;
				document.report.R51.disabled = true;
				document.report.R52.disabled = true;
				
				document.report.R54.disabled = true;
				document.report.R55.disabled = true;
				document.report.R56.disabled = true;
							
				document.report.R57.disabled = true;
				document.report.R58.disabled = true;
				document.report.R59.disabled = true;
				
				//document.report.R60.disabled = false;
				//document.report.R61.disabled = true;
			}else if(document.report.R48.value == "5"){ //����
				document.report.R50.disabled = true;
				document.report.R51.disabled = true;
				document.report.R52.disabled = true;
				
				document.report.R54.disabled = true;
				document.report.R55.disabled = true;
				document.report.R56.disabled = true;
				
				document.report.R57.disabled = true;
				document.report.R58.disabled = true;
				document.report.R59.disabled = true;
				
				//document.report.R60.disabled = true;
				//document.report.R61.disabled = false;
			}
		}
	}
</script>


<body  leftmargin="0" topmargin="0" onBeforeUnload="reloadOpener();">
<table border="0" width="99%" align="center">
	<tr> 
	<td colspan=5>
		<table>
		<%if(sButtonSaveFace!=null && !sButtonSaveFace.equals("NONE")){
			if(isEditable){%>
		<td id="updateData">
			<%=ASWebInterface.generateControl(SqlcaRepository,CurComp,sServletURL,"All","Button",sButtonSaveFace,sButtonSaveFace,"javascript:updateData()",sResourcesPath)%>
    	</td>
		<td id="evaluate"> 
			<%=ASWebInterface.generateControl(SqlcaRepository,CurComp,sServletURL,"All","Button",sButtonCalcFace,sButtonCalcFace,"javascript:evaluateData()",sResourcesPath)%>
		</td>
			<%} %>
		<!-- <td id="goBack"> 
			<%=ASWebInterface.generateControl(SqlcaRepository,CurComp,sServletURL,"","Button",sButtonCloseFace,sButtonCloseFace,"javascript:goBack()",sResourcesPath)%>
		</td> -->
		<%}%>
		</table>
	</td>
	</tr>
	<tr> 
		<td colspan="5"> 
			<hr>
		</td>
	</tr>
	<tr> 
		<td nowrap align="center" colspan="5"><FONT SIZE="4"><B><%=sObjectName +"&nbsp;"+ eEvaluate.AccountMonth+"&nbsp;"+ (((eEvaluate.ReportScope.equals("01"))?"�ϲ�":(eEvaluate.ReportScope.equals("02")?"����":(eEvaluate.ReportScope.equals("03")?"����":""))))+"&nbsp;" %></B><%=sModelName%></FONT></td>
	</tr>
<%
	if(sDisplayFinalResult!=null && sDisplayFinalResult.equalsIgnoreCase("Y")){
%>
	<tr> 
    	<td  nowrap align="center" colspan="5">
    		<FONT SIZE="4"><%=sEvaluateScore%><B><%=DataConvert.toMoney(eEvaluate.EvaluateScore)%></B></FONT> 
<%
				if(!eEvaluate.ModelNo.equals("RiskEvaluate") && !eEvaluate.ModelNo.equals("080")) {
					out.println("<FONT SIZE=\"4\">"+sEvaluateResult+"<B>"+DataConvert.toString(eEvaluate.EvaluateResult)+"</B></FONT>");
				}
				if (eEvaluate.ModelNo.equals("080")){
					out.println("<FONT SIZE=\"4\">"+sEvaluateResult+"</FONT>");
				}
%>
    	</td>
    </tr>
	<%
	}
	%>
	<tr> 
	</tr>
	<tr> 
		<td colspan="5" align="center">
		<div id="Layer1" style="z-index:1;height: 600px;overflow: auto;">
		<form name="report" method="post">
		<table width="100%" align="left" class="dialog_table" border="0" cellspacing="0" cellpadding="0">
			<tr> 
				<td height="21"  align="center" nowrap  class="title">���</td>
			  	<td height="21" nowrap  align="center" class="title">��Ŀ����</td>
				<td height="21" nowrap  align="center" class="title" width="<%=sItemValueDisplayWidth%>">��Ŀֵ</td>
				<%if(sDisplayItemScore!=null && sDisplayItemScore.equalsIgnoreCase("Y")){%>
				<td height="21" nowrap  align="center" class="title">�÷�</td>
				<%}%>
			</tr>
	<%
	i = 0;
	String myS="",myItemName="",sDisplayNo="",sTitle="";
	if(eEvaluate.Data.first()){
		do{
		i ++;
     	sItemName = "R" + String.valueOf(i);          
     	myItemName=DataConvert.toString(eEvaluate.Data.getString("ItemName"));
		sDisplayNo=DataConvert.toString(eEvaluate.Data.getString("DisplayNo"));
	%> 
          <tr  height="25"> 
            <td nowrap ><%=sDisplayNo%></td>
			<% if (sDisplayNo.trim().length() == 1)
              	out.print("<td nowrap ><B>"+myItemName+"</B></td>");
	       else 
                out.print("<td nowrap>"+myItemName+"</td>");%>
            <%
	 	sValueCode   = eEvaluate.Data.getString("ValueCode"); 
	 	sValueMethod = eEvaluate.Data.getString("ValueMethod"); 
	 	sValueType   = eEvaluate.Data.getString("ValueType"); 
	 	
	 	if (sValueCode != null && sValueCode.trim().length() > 0) //����д�������ʾ�����б�
	 	{
	 		sSql = "select ItemNo,ItemDescribe,ItemName from CODE_LIBRARY where CodeNo = '" + sValueCode + "' order by ItemNo";
			if("007".equals(eEvaluate.ModelNo)){//����ԡ����ݷ�����ҵ���õȼ����������п鴦����ʾ���ƣ�
		  %>
            <td nowrap align="left" >
				<select name=<%=sItemName%> align="left" onChange="ClassifyChange()">
                	<option value='0'> </option>
                		<%=HTMLControls.generateDropDownSelect(Sqlca,sSql,1,3,DataConvert.toString(eEvaluate.Data.getString("ItemValue")))%> 
              	</select>
            </td>
		  <%
		   } else {
		  %>
            <td nowrap align="left" >
				<select name=<%=sItemName%> align="left">
                	<option value='0'> </option>
                		<%=HTMLControls.generateDropDownSelect(Sqlca,sSql,1,3,DataConvert.toString(eEvaluate.Data.getString("ItemValue")))%> 
              	</select>
            </td>
		  <%}
	 	}else if ((sValueMethod != null && sValueMethod.trim().length() > 0) || sValueType==null || sValueType.trim().length() == 0) //�����ȡֵ�������ܽ����޸�
	 	{
	 		//ȡ��ʾ���
	 		sDisplayNo=DataConvert.toString(eEvaluate.Data.getString("DisplayNo"));
	 		myS=DataConvert.toString(eEvaluate.Data.getString("ItemValue"));
	 		
	 		if(myS!=null && !myS.equalsIgnoreCase("null") && !myS.equals("")){
				if(sValueType !=null && sValueType.equals("Number")){
	 				myS=DataConvert.toMoney(String.valueOf(eEvaluate.Data.getDouble("ItemValue")));
	 				if(myS.equals("")) myS="0.00";
	 			}else	myS=eEvaluate.Data.getString("ItemValue");
	 		}else{ myS="";}
	 		
	 		if (sDisplayNo.length()==1)
	 			myS="";
	 	%> 
            <td nowrap  height='22' align="left" name="<%=sItemName%>"><%=myS%>&nbsp;</td>
            <%
	 	}else{ //������Խ����޸�
	 	%>  
	 	    <%// �ı����õȼ�����ģ����ı���������ֵʱ��Լ��������ֻ��¼�����ֺ�С���㣬��������ʧ����Ӧ�����Զ�������ֵ���ж�   add by zhuang 2010-03-23%>
            <td nowrap  align="left" >                                                                                                                 
              <input  type=text name="<%=sItemName%>" value='<%=DataConvert.toString(eEvaluate.Data.getString("ItemValue"))%>' onKeyUp="value=value.replace(/[^\d^\.]/g,'')" 
                     onbeforepaste="clipboardData.setData('text',clipboardData.getData('text').replace(/[^\d^\.]/g,''))" onBlur="isMatch(value,name)"/>
            </td>
            <%
	 	}	
		
		if(sDisplayItemScore!=null && sDisplayItemScore.equalsIgnoreCase("Y")){
			if (sValueType != null){
				//ȡ��ʾ���
				sDisplayNo=DataConvert.toString(eEvaluate.Data.getString("DisplayNo"));
			%> 
				<td nowrap  align="right"><%=DataConvert.toMoney(eEvaluate.Data.getDouble("EvaluateScore"))%></td>
			<%	
			}else{
			%> 
				<td nowrap align="right">&nbsp;</td>
				<%	
			}
		}
		%> </tr>
		<%
	}while(eEvaluate.Data.next());
 }
 
%> 
        </table>
		</form>
		</div>
    </td>
  </tr>
</table>
<%
	if(!(sAction.equals("new") || sAction.equals("display"))){
%>
		<script type="text/javascript"> 
			alert('<%=sMessage%>');
		</script>
<%	 
	}
	eEvaluate.close();
%> 
</body>
</html>
<script type="text/javascript">
	function reloadOpener(){
		try{
			top.opener.location.reload();
		}
		catch(e){
		}
	}	

	//��У�����ı�������Ӧ�Ĵ���   add by zhuang 2010-03-23
    function isMatch(sValue,sName){
        var sResult = validateNum(sValue);
        if( sResult == "false" ){ 
        	alert(getBusinessMessage('959'));//�����ֵ������淶���룡
        	document.forms[0].elements[sName].focus();//�۽�
        	document.forms[0].elements[sName].value="";//���ֵ       	
        }else if( sResult == "true" ){           
        }else{       	
            sValue = sValue.substring(sResult);//ȥ������ֵ����Ч��0
            document.forms[0].elements[sName].value=sValue;
        }
    }   
</script>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script type="text/javascript">
	AsOne.AsInit();
	//AsMaxWindow();
	initRow();
    if(<%= "007".equals(eEvaluate.ModelNo)%>){ //��ʼ����ѡ��ģ��
		ClassifyChange();
	}
</script>
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>