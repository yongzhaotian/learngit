<%@ page import="com.amarsoft.are.util.StringFunction" %>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   zywei 
		Tester:
		Content: ���ͳ��ʽ�����Ϣ
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
<title>���ͳ���ָ��</title>

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
                          <p><font size=2>�������ӷ�����...</font>
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
                          <p><font size=2 color=red>���ӷ�������ʱ��������ٽ��У�</font>
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