<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%
	String sCity =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("City"));
	String oldSNO =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SNO"));
	String oldSalesManager =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("oldSalesManager"));
	if(oldSalesManager == null) oldSalesManager = "";
	if(sCity == null) sCity = "";
	if(oldSNO == null) oldSNO = "";
%>
<html>
   <head>
         <title>请选择一个按钮</title>
   </head>
   <body>
       <form action="formName">
              <table align="center"  style="margin-top:55px;">
              <tr>
                   <td>
                        <input type="button"  name="storeName"  value="部分转移门店"  onClick="javascript: updateStoreName()"   /> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                        <input type="button"  name="salesName"  value="部分转移销售代表"  onclick="javascript:updateSalesName()"  />
                   </td>
              </tr>
       </table>
       </form>
   </body>
</html>
<script type="text/javascript">
      function updateSalesName(){
    		sCompID = "UpdateOtherManager";
    		sCompURL = "/BusinessManage/StoreManage/UpdateOtherManager.jsp";
    	    popComp(sCompID,sCompURL,"City=<%=sCity%>&SNO=<%=oldSNO%>&oldSalesManager=<%=oldSalesManager%>","dialogWidth=400px;dialogHeight=200px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
    	    reloadSelf();	
      }
      
      function updateStoreName(){
    		sCompID = "UpdateOtherStoreManager";
    		sCompURL = "/BusinessManage/StoreManage/UpdateOtherStoreManager.jsp";
    	    popComp(sCompID,sCompURL,"City=<%=sCity%>&SNO=<%=oldSNO%>&oldSalesManager=<%=oldSalesManager%>","dialogWidth=400px;dialogHeight=200px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
    	    reloadSelf();	
      }
</script>
<%@ include file="/IncludeEnd.jsp"%>
