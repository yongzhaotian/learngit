<%@ page import="com.amarsoft.are.util.StringFunction" %>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   zywei 
		Tester:
		Content: 发送出帐交易信息
		Input Param:
			          
		Output param:
			      
		History Log: 
	 */
	%>
<%/*~END~*/%>

<%
	boolean bFlag = false;
	int iBeforeCount = 0;
	int iCurrentCount = 0;
	iBeforeCount = Integer.parseInt(StringFunction.getNow().substring(7));
	for(int i = 0; i < 11; i++)
	{
		iCurrentCount = Integer.parseInt(StringFunction.getNow().substring(7));
		if(Math.abs(iCurrentCount - iBeforeCount) >=5 )
			bFlag = true;
	}
%>

<html>
<head>
<title>发送出帐指令</title>

<link rel="stylesheet" href="Style.css">

</head>
<body class="pagebackground" leftmargin="0" topmargin="0" id="mybody">
<table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%">
 <tr valign="top">
    <td>
      <div id="Layer1" style="position:absolute;width:100%; height:100%; z-index:1; overflow: auto">
        <table align='center' cellspacing=0 cellpadding=0 border=0 width=95% height="95%">
          <tr>
            <td align='center' valign='top'>
              <table border=0 width='100%' height='100%'>
                <tr>
                  <td valign='top'>
                    <table width="100%" border="0" cellspacing="0" cellpadding="4">
                      <tr>
                      	<td valign="top" align="left" colspan=3>
                          <p><font size=2>正在连接服务器...</font>
                          </p>                                                    
                        </td>
                      </tr>
                      <tr>
                        <td width="20%" valign="top" align="center">
                          <p><br>                          
                          <img src="<%=sResourcesPath%>/computer.jpg">
                          </p>                                                    
                        </td>
                        <td width="20%" valign="top" align="center">
                          <p><br><br><font size=4>..................</font>
                          </p>                                                    
                        </td>
                        <td width="20%" valign="top" align="center">
                          <p><br>                          
                          <img src="<%=sResourcesPath%>/computer.jpg">
                          </p>                                                    
                        </td>                        
                      </tr>
                     <%
						if(bFlag)
						{	                          	
                      %>
                      <tr>
                      	<td valign="top" align="left" colspan=3>
                          <p><font size=2 color=red>连接服务器超时，请检查后再进行！</font>
                          </p>                                                    
                        </td>
                      </tr>
                     <%
                     	}
                     %>
                    </table>  
                  </td> 
                </tr>
              </table>
            </td>
          </tr>
        </table>
      </div>
    </td>
  </tr>
</table>

</body>
</html>


<%@ include file="/IncludeEnd.jsp"%>