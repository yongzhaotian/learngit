<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author: 
		Tester:
		Describe: ����ͻ�ʱ�ṩ�б�ѡ���б�;
		Input Param:
			OthercustomerID  �ͻ���֯��������
		    CustomerName     �ͻ�����    
		    UseType  0��¼��Ա��ѯ�ͻ�   
		             1���ͻ������ѯ�ͻ� 

		Output Param:
			
		HistoryLog:
	 */
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "��ѡ������Ŀͻ��б�"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>

<html>
<head> 
<title>��ѡ������Ŀͻ��б�</title>
<%    
	String sOtherCustomerID = DataConvert.toRealString(iPostChange,(String)request.getParameter("OtherCustomerID"));
	String sCustomerName = DataConvert.toRealString(iPostChange,(String)request.getParameter("CustomerName"));
	String sUseType = DataConvert.toRealString(iPostChange,(String)request.getParameter("UseType"));
	
	//��Сдת��
	sOtherCustomerID = sOtherCustomerID.toUpperCase();  
	sOtherCustomerID = StringFunction.replace(sOtherCustomerID,"��","-");
	
	if(sUseType==null)
	sUseType="1";
	String sCustomerInfo;        
	
	String sSql="";	 
	ASResultSet rs;
	
	   if (sUseType.equals("1"))
	   {
	    sSql =  "  select CustomerID,CertID,MFCustomerID,CustomerName from CUSTOMER_INFO "+
	                "  where CertID like '%"+sOtherCustomerID+"%' And CustomerName like '%"+sCustomerName+ "%'";
	    }
	    else
	    {
	    sSql =  "  select DISTINCT C.CustomerID,C.CertID,C.MFCustomerID,C.CustomerName from CUSTOMER_INFO C,CUSTOMER_BELONG L"+
	                "  where C.CertID like '%"+sOtherCustomerID+"%' And C.CustomerName like '%"+sCustomerName+ "%'"+
	                " AND C.CustomerID=L.CustomerID and L.OrgID like  '"+CurOrg.getOrgID()+"%' and L.BelongAttribute2 ='02'";    
	    }
	
	    rs = Sqlca.getASResultSet(sSql); 
	   
	    if(!rs.next())
	    {
	    %>
	    <script type="text/javascript">
	    self.returnValue="NoCustomer";//û�в�ѯ�Ŀͻ���Ϣ
	    self.close();
	    </script>
	    <%
	    return;
	    }
	    else
	      rs.beforeFirst();
%>	

<script type="text/javascript">
    var sCustomerInfo,lastRow,j=0;
    function setCustomerInfo(sInfo,iRow)
    {      
           if(j==0)
           lastRow=iRow;
           sCustomerInfo = sInfo;
           document.getElementById("TDName1"+iRow).style.background="#DCDFF6";
//           document.getElementById("TDName2"+iRow).style.background="#DCDFF6";
           document.getElementById("TDName3"+iRow).style.background="#DCDFF6";
    
           if(iRow!=lastRow)
           {
              document.getElementById("TDName1"+lastRow).style.background="#FEFEFE";
 //             document.getElementById("TDName2"+lastRow).style.background="#FEFEFE";
              document.getElementById("TDName3"+lastRow).style.background="#FEFEFE";
    
           }
           lastRow = iRow;
           j++;
    }

    function doConfirm()
    {  
           if(typeof(sCustomerInfo)=="undefined")
           {
              
              alert(getHtmlMessage('1'));         
           }
           else
           {         
             self.returnValue=sCustomerInfo;                
             self.close();
           }
    }
    
    function doCancel()
    {  
           self.returnValue=""; 
           self.close();	
    }
    
    function dblAction()
    {
    	   doConfirm();
    
    }

</script>


<body class="ShowModalPage" leftmargin="0" topmargin="0" onload="" >
<br>

<form name="buff">
<table id=table0 border='0' align="center" cellspacing='0' bordercolor='#999999' bordercolordark='#FFFFFF'>
    <tr> 
      
      <td>
      	    <%=HTMLControls.generateButton("ȷ��","ȷ��","javascript:doConfirm()",sResourcesPath)%>	     
      </td>
	
      <td>
      	    <%=HTMLControls.generateButton("ȡ��","ȡ��","javascript:self.returnValue='';self.close()",sResourcesPath)%>
      </td>
    </tr>
	
 </table>

<div style='position:absolute;width: 100%;height: 200px;overflow:auto;'>
<table name=dataTable id=dataTable  /**hmGDTable*/ align=center border=1 cellspacing=0 cellpadding=0 bgcolor=#E4E4E4 bordercolor=#999999 bordercolordark=#FFFFFF >
    <tr>
    		<TD  /**hmGDTdHeader*/ style='font-family:����,arial,sans-serif;font-size: 9pt;font-weight: normal; padding-left: 2;color: #55554B;background-color: #FEFEFE;  background-image:url(/ploansub/Resources/1/Support/back.gif);cursor: pointer;	text-decoration: none;	text-align:center;'  >&nbsp;��֯�������� </TD>
<!--    		<TD  /**hmGDTdHeader*/ style='font-family:����,arial,sans-serif;font-size: 9pt;font-weight: normal; padding-left: 2;color: #55554B;background-color: #FEFEFE;  background-image:url(/ploansub/Resources/1/Support/back.gif);cursor: pointer;	text-decoration: none;	text-align:center;'  >&nbsp;����ϵͳ�ͻ���� </td>-->
    		<TD  /**hmGDTdHeader*/ style='font-family:����,arial,sans-serif;font-size: 9pt;font-weight: normal; padding-left: 2;color: #55554B;background-color: #FEFEFE;  background-image:url(/ploansub/Resources/1/Support/back.gif);cursor: pointer;	text-decoration: none;	text-align:center;'  >&nbsp;�ͻ����� </td>
    		
    </tr>
    
 <%
	 String sCustomerID,sMFCustomerID; 
	 int i=0;
	 
	 while(rs.next())
	 {
	    i++;            
	        sOtherCustomerID = DataConvert.toString(rs.getString("CertID"));		
	        sCustomerID = DataConvert.toString(rs.getString("CustomerID"));
	        sMFCustomerID=DataConvert.toString(rs.getString("MFCustomerID"));
	        sCustomerName=DataConvert.toString(rs.getString("CustomerName"));
	        sCustomerInfo = sCustomerID+"@"+sOtherCustomerID+"@"+sCustomerName;   
      
 %>
	<tr>	     	
	     	<td nowrap><input  style='height:19;font-family:����,arial,sans-serif;font-size:9pt; background-color: #FEFEFE; border-style:none;border-width:thin;'  readonly  style={width:90px} ondblClick="dblAction()" onClick="javascript:setCustomerInfo('<%=sCustomerInfo%>',<%=i%>)"  type=text  value="<%=sOtherCustomerID%>"  id="TDName1<%=i%>"> </td>
<!--	     	<td nowrap><input  style='height:19;font-family:����,arial,sans-serif;font-size:9pt; background-color: #FEFEFE; border-style:none;border-width:thin;'  readonly  style={width:90px} ondblClick="dblAction()" onClick="javascript:setCustomerInfo('<%=sCustomerInfo%>',<%=i%>)"  type=text  value="<%=sMFCustomerID%>"    id="TDName2<%=i%>"> </td>-->
	      	<td nowrap><input  style='height:19;font-family:����,arial,sans-serif;font-size:9pt; background-color: #FEFEFE; border-style:none;border-width:thin;'  readonly  style={width:200px} ondblClick="dblAction()" onClick="javascript:setCustomerInfo('<%=sCustomerInfo%>',<%=i%>)"  type=text  value="<%=sCustomerName%>"    id="TDName3<%=i%>"> </td>
		
	</tr>
 <% 
 }

 rs.getStatement().close();
 
 %>
 
  </table>
    </div>
</form>

</body>
</html>
<%@ include file="/IncludeEnd.jsp"%>