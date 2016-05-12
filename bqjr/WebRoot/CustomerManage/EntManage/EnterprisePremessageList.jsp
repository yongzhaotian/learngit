<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author: 
		Tester:
		Describe: 引入客户时提供列表供选择列表;
		Input Param:
			OthercustomerID  客户组织机构代码
		    CustomerName     客户名称    
		    UseType  0－录入员查询客户   
		             1－客户经理查询客户 

		Output Param:
			
		HistoryLog:
	 */
	%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "待选定引入的客户列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>

<html>
<head> 
<title>待选定引入的客户列表</title>
<%    
	String sOtherCustomerID = DataConvert.toRealString(iPostChange,(String)request.getParameter("OtherCustomerID"));
	String sCustomerName = DataConvert.toRealString(iPostChange,(String)request.getParameter("CustomerName"));
	String sUseType = DataConvert.toRealString(iPostChange,(String)request.getParameter("UseType"));
	
	//大小写转换
	sOtherCustomerID = sOtherCustomerID.toUpperCase();  
	sOtherCustomerID = StringFunction.replace(sOtherCustomerID,"—","-");
	
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
	    self.returnValue="NoCustomer";//没有查询的客户信息
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
      	    <%=HTMLControls.generateButton("确定","确定","javascript:doConfirm()",sResourcesPath)%>	     
      </td>
	
      <td>
      	    <%=HTMLControls.generateButton("取消","取消","javascript:self.returnValue='';self.close()",sResourcesPath)%>
      </td>
    </tr>
	
 </table>

<div style='position:absolute;width: 100%;height: 200px;overflow:auto;'>
<table name=dataTable id=dataTable  /**hmGDTable*/ align=center border=1 cellspacing=0 cellpadding=0 bgcolor=#E4E4E4 bordercolor=#999999 bordercolordark=#FFFFFF >
    <tr>
    		<TD  /**hmGDTdHeader*/ style='font-family:宋体,arial,sans-serif;font-size: 9pt;font-weight: normal; padding-left: 2;color: #55554B;background-color: #FEFEFE;  background-image:url(/ploansub/Resources/1/Support/back.gif);cursor: pointer;	text-decoration: none;	text-align:center;'  >&nbsp;组织机构代码 </TD>
<!--    		<TD  /**hmGDTdHeader*/ style='font-family:宋体,arial,sans-serif;font-size: 9pt;font-weight: normal; padding-left: 2;color: #55554B;background-color: #FEFEFE;  background-image:url(/ploansub/Resources/1/Support/back.gif);cursor: pointer;	text-decoration: none;	text-align:center;'  >&nbsp;核心系统客户编号 </td>-->
    		<TD  /**hmGDTdHeader*/ style='font-family:宋体,arial,sans-serif;font-size: 9pt;font-weight: normal; padding-left: 2;color: #55554B;background-color: #FEFEFE;  background-image:url(/ploansub/Resources/1/Support/back.gif);cursor: pointer;	text-decoration: none;	text-align:center;'  >&nbsp;客户名称 </td>
    		
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
	     	<td nowrap><input  style='height:19;font-family:宋体,arial,sans-serif;font-size:9pt; background-color: #FEFEFE; border-style:none;border-width:thin;'  readonly  style={width:90px} ondblClick="dblAction()" onClick="javascript:setCustomerInfo('<%=sCustomerInfo%>',<%=i%>)"  type=text  value="<%=sOtherCustomerID%>"  id="TDName1<%=i%>"> </td>
<!--	     	<td nowrap><input  style='height:19;font-family:宋体,arial,sans-serif;font-size:9pt; background-color: #FEFEFE; border-style:none;border-width:thin;'  readonly  style={width:90px} ondblClick="dblAction()" onClick="javascript:setCustomerInfo('<%=sCustomerInfo%>',<%=i%>)"  type=text  value="<%=sMFCustomerID%>"    id="TDName2<%=i%>"> </td>-->
	      	<td nowrap><input  style='height:19;font-family:宋体,arial,sans-serif;font-size:9pt; background-color: #FEFEFE; border-style:none;border-width:thin;'  readonly  style={width:200px} ondblClick="dblAction()" onClick="javascript:setCustomerInfo('<%=sCustomerInfo%>',<%=i%>)"  type=text  value="<%=sCustomerName%>"    id="TDName3<%=i%>"> </td>
		
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