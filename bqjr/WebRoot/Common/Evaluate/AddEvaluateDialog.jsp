<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   jytian  2004/12/16
		Tester:
		Content: �������õȼ�����
		Input Param: 	ObjectType:  ��������
 		    			ObjectNo  :  ������
 		    			ModelType :  ����ģ������
		Output param:
		
		History Log: 
			
	 */
	%>
<%/*~END~*/%>


<html>
<head> 
<title>�������õȼ�����</title>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main02;Describe=�����������ȡ����;]~*/%>
	<%
	//����������	
	
	String sObjectType    = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));
 	String sObjectNo      = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerID"));

	//���ҳ�����	
	String sSql="",sObjectName="",sCustomerType="01",sCustomerID="",sCustomerName="";
	String sModelType,sModelTypeName="",sDefaultAccountMonth="",sDefaultModelNo="";
	ASResultSet rs ;
	
	//����ۺ������޶�
	sModelType  = DataConvert.toRealString(iPostChange,(String)request.getParameter("ModelType"));
	
	//ȡ����ģ���������
	if (sModelType==null) sModelType = "010"; //ȱʡģ������Ϊ"���õȼ�����"
	rs = Sqlca.getASResultSet(new SqlObject("select ItemName from CODE_LIBRARY where CodeNo='EvaluateModelType' and ItemNo=:ItemNo").setParameter("ItemNo",sModelType));
	if (rs.next()){
		sModelTypeName = rs.getString(1);
	}
	rs.getStatement().close();
	//out.println(sModelTypeName);	
	
	//Ѱ��ȱʡ������ģ��	
	if (sObjectType.equals("Customer")){  //�ͻ����õȼ�����
		sCustomerID = sObjectNo;
		//ȡ�ͻ����ƺ����
		rs = Sqlca.getASResultSet(new SqlObject("select CustomerName,CustomerType from CUSTOMER_INFO where CustomerID=:CustomerID").setParameter("CustomerID",sObjectNo));
		if (rs.next()){
			sObjectName = rs.getString(1);
			sCustomerType = rs.getString(2);
			//out.println(sCustomerType);
		}
		rs.getStatement().close();
		
		//�ֱ����ҵ�͸��˿ͻ�ȡȱʡ����ģ��
		if (sCustomerType.equals("03")) 
			rs = Sqlca.getASResultSet(new SqlObject("select CreditBelong from IND_INFO where CustomerID= :CustomerID").setParameter("CustomerID",sObjectNo));
		else 
			rs = Sqlca.getASResultSet(new SqlObject("select CreditBelong from ENT_INFO where CustomerID= :CustomerID").setParameter("CustomerID",sObjectNo)); 
		if (rs.next()) 
			sDefaultModelNo = rs.getString(1);		
		rs.getStatement().close();
		
		//���ݿͻ��ſ����е����õȼ��������ʹ��룬�ҳ���Ӧ�����õȼ�����ģ�ͱ��
		sSql =  " select Itemdescribe from Code_Library where CodeNo='CreditTempletType'"+
				" and ItemNo=:ItemNo";
		rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("ItemNo",sDefaultModelNo)); 
		if (rs.next()) 
			sDefaultModelNo = rs.getString(1);
		rs.getStatement().close();
		
		if (sDefaultModelNo==null) sDefaultModelNo="";
	}
	else if(sObjectType.equals("Business") || sObjectType.equals("BusinessApply") || sObjectType.equals("BusinessLoanPrice") )   //ҵ������
	{ 
		//ȡ����Ӧ�����˴���
		rs = Sqlca.getASResultSet(new SqlObject("select CustomerID,CustomerName from  Business_Apply where SerialNo=:SerialNo").setParameter("SerialNo",sObjectNo));
		if (rs.next()){
			sCustomerID = rs.getString(1);
			sCustomerName = rs.getString(2);
		}
		rs.getStatement().close();
		sObjectName = sObjectNo + "ҵ��";
	}else{
		rs=Sqlca.getASResultSet(new SqlObject("select orgname   from ORG_INFO where orgid=:orgid").setParameter("orgid",sObjectNo));
		if(rs.next())  
			sObjectName=rs.getString(1);
		rs.getStatement().close();
	}
	%>
<%/*~END~*/%>


<script type="text/javascript">

	var sModelType    = "<%=sModelType%>";
	var sAccountMonth = "";
	var sModelNo      = "";
	
	  
   	function goBack() {
       	self.close();
   	}	
  
  	function setNext(){
  		var sAccountMonth = document.forms["evaluate"].AccountMonth.value;
		if (sModelType=='010'){
			sModelNo="<%=sDefaultModelNo%>";
		}else{
			sModelNo = document.forms["evaluate"].ModelNo.value;
		}	
		
		if(sAccountMonth==""){
			alert(getBusinessMessage('191'));//����ѡ���Ʊ����·ݣ�
			return;
		}
		
		if(!isDateForAccountMonth(sAccountMonth+"/01")){
			alert(getBusinessMessage('192'));//��������ȷ�Ļ�Ʊ����·ݸ�ʽ��YYYY/MM����
			return;
		}
	
		if(sModelNo==""){
			alert(getBusinessMessage('193'));//����ѡ��һ��ģ�ͣ�
			return;
		}
		var sReturn= "";
	
		sReturn=PopPage("/EvaluateReport/AddEvaluateAction.jsp?ModelType="+sModelType+"&ModelNo="+ sModelNo+"&AccountMonth="+sAccountMonth,"","");
	
		if(typeof(sReturn)!="undefined" && sReturn.length!=0 && sReturn != '_none_'){
			self.returnValue = sReturn;
			self.close();
		}
	} 
	function isDateForAccountMonth(sItemName) 
	{
		var sItems = sItemName.split("/");
		
		if (sItems.length!=3) return false;
		if (isNaN(sItems[0])) return false;
		if (isNaN(sItems[1])) return false;
		if (isNaN(sItems[2])) return false;
		if (parseInt(sItems[0],10)<1900 || parseInt(sItems[0],10)>2050) return false;
		if (parseInt(sItems[1],10)<1 || parseInt(sItems[1],10)>12) return false;
		if (parseInt(sItems[2],10)<1 || parseInt(sItems[2],10)>31) return false;
		return true;
	}

</script>

<style>
.black9pt {  font-size: 9pt; color: #000000; text-decoration: none}
</style>
</head>

<body  leftmargin="0" topmargin="0">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
   <tr> 
    <td width="21%">&nbsp;</td>
    <td width="10%" background="<%=sResourcesPath%>/vline_bos.gif">
      <p>&nbsp;</p>
      <p>&nbsp;</p>
      <p>&nbsp;</p>
      <p>&nbsp;</p>
      <p>&nbsp;</p>
      <p>&nbsp;</p>
      <p>&nbsp;</p>
      <p>&nbsp;</p>
      <p>&nbsp;</p>
      <p>&nbsp;</p>
    </td>
    <td width="100%" align="left" valign="top"> 
      <form name="evaluate">
		<table width="100%" align="left" border="0" cellspacing="0" cellpadding="5">
			<tr>
            	<td>&nbsp;</td>
            	<td>&nbsp;</td>
          	</tr>
          	<tr> 
            	<td><br>
				��<b><%=sObjectName%></b>����<%=sModelTypeName%></td>
            	<td>&nbsp;</td>
			</tr>
			<tr> 
				<td>&nbsp;</td>
				<td>&nbsp;</td>  
			</tr>
			<% if(sModelType.equals("010")){
			%> 
			<tr> 
            	<td nowrap>  ��ѡ���Ʊ����·ݣ� 
					<select name="AccountMonth" class="right">
						<%=HTMLControls.generateDropDownSelect(Sqlca,"select distinct AccountMonth from CUSTOMER_FSRECORD a where CustomerID = '"+sCustomerID+"' and 4=( select count(*) from REPORT_RECORD b where ReportDate=a.ReportDate and CustomerID='"+sCustomerID+"')"+" order by AccountMonth DESC",1,1,sDefaultAccountMonth)%> 
					</select>
				</td>
            	<td>&nbsp;</td>
			</tr>
			<% }
			   else if(sModelType.equals("030"))//���ն�������
			{%> 
			<tr> 
            	<td nowrap>  ������ͻ���������õȼ�����ʱ�䣺 
					<%
						// zbdeng  2004/02/17
						String sMonth="";
						rs=Sqlca.getASResultSet(new SqlObject("select AccountMonth from EVALUATE_RECORD where ObjectType='Customer' and ObjectNo=:ObjectNo order by AccountMonth DESC  ").setParameter("ObjectNo",sCustomerID));
						if(rs.next())
							sMonth=DataConvert.toString(rs.getString("AccountMonth"));
						rs.getStatement().close();
					%>
					<input  type=text name="AccountMonth" value="<%=sMonth%>"  >
				</td>
            	<td>&nbsp;</td>
			</tr>
			<% }
			else
			{%>
			<tr >
            	<td nowrap>1����������һ������·ݣ�
            	<input  type=text name="AccountMonth" >
            	</td>
            </tr>
			<%
			}
			%>
			<tr> 
            	<td>&nbsp;</td>
            	<td>&nbsp;</td>
			</tr>
			<%
			if(!(sModelType.equals("010")))
			{
			%>	
			<tr> 
				<td nowrap>2����ѡ��ʹ�õ�����ģ�ͣ� 
					<select name="ModelNo" class="right">
						<%=HTMLControls.generateDropDownSelect(Sqlca,"select ModelNo,ModelName from EVALUATE_CATALOG where ModelType='"+sModelType+"'  order by ModelNo ",1,2,sDefaultModelNo)%> 
					</select>
				</td>
				<td>&nbsp;</td>
			</tr>
			<%
			}
			%> 
          <tr> 
            <td>&nbsp;</td>  
            <td>&nbsp;</td>
          </tr>
          <tr> 
            <td> 
              <table width="30%" border="0">
                <tr> 
                  <td > 
                    <input type="button" name="btnNext" value="ȷ  ��" onClick="setNext();">
                  </td>
                  <td > 
                    <input type="button" name="btnBack" value="��  ��" onClick="goBack()">
                  </td>
                </tr>
              </table>
            </td>
            <td>&nbsp;</td>
          </tr>
        </table>
      </form>
    </td>
  </tr>
</table>
</body>
</html>

<%@ include file="/IncludeEnd.jsp"%>