<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>



<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author:  jschen 2010/03/25
		Tester:	
		Content: --����ͳ��
		Input Param:
		Output param:
		History Log: 
			
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "����ͳ��"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%
   //�������
    String sAccountMonths = "";//--�������� 
	
   //���ҳ����������������ͻ������ͻ�����
	String sReportCount = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ReportCount"));
	//����������
	
%>
<%/*~END~*/%>
<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=��ȡ����ֵ;]~*/%>

<%

%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List04;Describe=��ҳ���д;]~*/%>
<HEAD>
	<title>����ͳ��</title>
</HEAD>
<body class="ReportPage" leftmargin="0" topmargin="0" onLoad="" style="overflow:auto" oncontextmenu="return false">
<form name="form0">
<table border="0" width="80%" height="100%" cellspacing="0" cellpadding="0" >
	<tr height=1 valign=top id="buttonback" >
		<td>
			<table width="100%" >
			<tr>
			  <td width="20%">&nbsp;</td>
  <td width="39%">
					<span >
<table width="100%" >
<tr>
							<td width="77%" align="right" valign="middle">
								��ѯ������ 
			    <input name="OrgName" type='text' value="" size="20" ReadOnly=true></td>
			    <input type=hidden name="OrgID" value="" >
							<td width="23%" align="center" valign="middle">
								<%=HTMLControls.generateButton("ѡ�����","ѡ�����","javascript:selectOrg();",sResourcesPath)%>							</td>
			  </tr></table>
			</span>				</td>
  <td width="25%" align=left>
					<span >
					<table width="96%" >
					  <tr><td align="left" valign="middle">
						ѡȡͼ��չ�ַ�ʽ��
						    <select name="GraphType">
                              <option value=0 >�б�</option>
                              <option value=6 >��״ͼ</option>
                            </select>
					</td>
					  </tr></table>
		    </span>				</td>
			</tr>
            <tr>
            <td>&nbsp;</td>
            <td><table width="200" align="right">
              <tr>
                <td><%=HTMLControls.generateButton("ʵʱ��ѯ","ʵʱ��ѯ","javascript:graphShow();",sResourcesPath)%></td>
                <td><%=HTMLControls.generateButton("��ʷ��ѯ","��ʷ��ѯ","javascript:graphShow();",sResourcesPath)%></td>
              </tr>
            </table></td>
			  </tr>	
			</table>
	</tr>

</table>
</font>
</body>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=�Զ��庯��;]~*/%>

<script>

	//---------------------���尴ť�¼�------------------------------------
	/*~[Describe=����excel;InputParam=��;OutPutParam=��;]~*/
	function excelShow()
	{
		var mystr = document.all('reporttable').innerHTML;
		spreadsheetTransfer(mystr.replace(/type=checkbox/g,"type=hidden"));
	}
	
	/*~[Describe=����ͼ��;InputParam=��;OutPutParam=��;]~*/
	function graphShow()
	{
		var sChecked = "",iChecked = 0,sItemNames="",sItemValues="";
		
		sChecked = sChecked.substr(0,sChecked.length-1);
		sItemNames = sItemNames.substr(0,sItemNames.length-1);
		sItemValues = sItemValues.substr(0,sItemValues.length-1);
		sGraphType = document.all("GraphType").value;
		sScreenWidth = screen.availWidth-40;
		sScreenHeight = screen.availHeight-40;
	    PopPage("/InfoManage/DataInput/ReinforceStatisticGraphic.jsp?GraphType="+sGraphType+"&rand="+randomNumber(),"_blank",sDefaultDialogStyle);
	}

	/*~[Describe=ѡ�����;InputParam=��;OutPutParam=��;]~*/
	function selectOrg()
	{
		var sParaString = "OrgID,"+"<%=CurOrg.getOrgID()%>";
		//��ѡ���������Ϊ���л���
		var sReturn= selectObjectValue("SelectBelongOrg",sParaString,0,0,"");	
		
		if (!(sReturn=='_CANCEL_' || typeof(sReturn)=="undefined" || sReturn.length==0 || sReturn=='_CLEAR_'))
		{
			sReturn=sReturn.split("@");
			sTraceOrgID=sReturn[0];
		
			document.all("OrgID").value=sReturn[0];
			document.all("OrgName").value=sReturn[1];
			
		}
		else if (sReturn=='_CLEAR_')
		{
			sTraceOrgID="";
		
			document.all("OrgID").value="";
			document.all("OrgName").value="";
		}
		else 
		{
			return;
		}
		
	}
</script>
<%/*~END~*/%>


<%@ include file="/IncludeEnd.jsp"%>
