<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   ccxie 2010/03/25
		Tester:
		Content:  ��ӡ����˴��պ�
		Input Param:

		History Log: sxjiang 2010/07/19 Line50 �رս����
	 */
	%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=�����������ȡ����;]~*/%>
<%
	String sSerialNo = DataConvert.toRealString(iPostChange,(String) CurPage.getParameter("SerialNo"));
	if (sSerialNo == null)sSerialNo = "";
	
	String sSql = "";
	String sDunObjectType = "";//���ն���01-����ˣ�02-��֤�ˣ�03-����
	String sOperateOgID = "";
	String sDunObjectName = "";//���ն�������
	String sObjectNo = "";//���պ����
	String sDunSum = "";//���ս��
	String sCorpus = "";//����
	String sInterestInSheet = "";//������Ϣ
	String sInterestOutSheet = "";//������Ϣ
	String sElseFee = "";//����
	String sMaturity = "";//�ս�����
	String sArtificialNo = "";//�˹���ͬ���
	String sDunDate = "";//��������
	String sYear = "",sMonth = "",sDay = "";
	String sDunYear = "",sDunMonth = "",sDunDay = "";
	double LineRate = 0;
	double dCorpus = 0;
	double dInterestInSheet = 0;
	double dInterestOutSheet = 0;
	double dElseFee = 0;
	double dDunSum = 0;
	ASResultSet rs = null;
	sSql = " select getERate1(DunCurrency,'01') as LineRate,di.ObjectType,di.ObjectNo,di.SerialNo,di.DunLetterNo,"+
	   " di.DunDate,di.DunForm,di.DunObjectType,di.DunObjectName,di.DunCurrency,"+
	   " di.DunSum,di.Corpus,di.InterestInSheet,di.InterestOutSheet,di.ElseFee,di.ServiceMode,"+
	   " di.FeedbackValitity,di.FeedbackContent,di.Remark,di.OperateUserID,di.OperateUserID,di.OperateOrgID,di.OperateOrgID,"+ 
	   " di.InputUserID,di.InputUserID,di.InputOrgID,di.InputOrgID,di.InputDate,di.UpdateDate,bc.Maturity,bc.ArtificialNo,di.DunDate "+ 
	   " from DUN_INFO di,BUSINESS_CONTRACT bc"+
	   " where di.SerialNo= :SerialNo and di.ObjectNo = bc.serialNo" ;
	rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("SerialNo",sSerialNo));
	if (rs.next()) {
		LineRate = rs.getDouble("LineRate");
		sDunObjectType = rs.getString("DunObjectType");
		sOperateOgID = rs.getString("OperateOrgID");
		sDunObjectName = rs.getString("DunObjectName");
		sObjectNo = rs.getString("ObjectNo");
		dCorpus = rs.getDouble("Corpus");
		dInterestInSheet = rs.getDouble("InterestInSheet");
		dInterestOutSheet = rs.getDouble("InterestOutSheet");
		dElseFee = rs.getDouble("ElseFee");
		dDunSum = rs.getDouble("DunSum");
		sMaturity = rs.getString("Maturity");
		sArtificialNo = rs.getString("ArtificialNo");
		sDunDate = rs.getString("DunDate");
	}
	rs.getStatement().close();
	
	if (sDunObjectType == null)
		sDunObjectType = "&nbsp";
	if (sOperateOgID == null)
		sOperateOgID = "&nbsp";
	if (sDunObjectName == null)
		sDunObjectName = "&nbsp";
	if (sObjectNo == null)
		sObjectNo = "&nbsp";
	if (sMaturity == null)
		sMaturity = "&nbsp";
	if (sArtificialNo == null)
		sArtificialNo = "&nbsp";
	if (sDunDate == null)
	    sDunDate = "&nbsp";
	
	sCorpus = DataConvert.toMoney(dCorpus*LineRate);
	sInterestInSheet = DataConvert.toMoney(dInterestInSheet*LineRate);
	sInterestOutSheet = DataConvert.toMoney(dInterestOutSheet*LineRate);
	sElseFee = DataConvert.toMoney(dElseFee*LineRate);
	sDunSum = DataConvert.toMoney(dDunSum*LineRate);
	
	//��������ȡ���ս�����
	if(sMaturity != null && !sMaturity.equals(""))
	{
		sYear = sMaturity.substring(0,4);
		sMonth = sMaturity.substring(5,7);
		sDay = sMaturity.substring(8,10);
	}
	//��ȡϵͳ��ǰ����
	sDunYear = sDunDate.substring(0,4)+"��";;
	sDunMonth = sDunDate.substring(5,7)+"��";
	sDunDay = sDunDate.substring(8,10)+"��";
	sDunDate = sDunYear+sDunMonth+sDunDay;
%>

<html>

	<body onbeforePrint="beforePrint()"  onafterprint="afterPrint()">

	<head>
	<title></title>
	</head>
	
	<object ID='WebBrowser1' WIDTH=0 HEIGHT=0 border=1  style="display:none" CLASSID='CLSID:8856F961-340A-11D0-A96B-00C04FD705A2' > </object>
	
	<div id='PrintButton'>
	<input type=button value='��ӡ����' onclick="WebBrowser1.ExecWB(8,1)">
	<input type=button value='��ӡԤ��' onclick="WebBrowser1.ExecWB(7,1)">
	<input type=button value=' ��  ӡ ' onclick="WebBrowser1.ExecWB(6,1)">
	<input type=button value=' ��  �� ' onclick="goBack()">
	</div>

	<form method='post' action='ALPassBook.jsp' name='reportInfo'>	
	<div id=reporttable>	
	<table class=table1 width='600' align=center border="0" >
	<tr>
		<td colspan='5' align=left class=td1 height='10'> 
		<font size='4'></font> 
		</td>
	</tr>

	<tr>
		<td colspan='5' align=center class=td1 height='10'> 
		<font style=font-size:14pt;line-height:130%> <b> XX��ҵ���д��պ� </b> </font>  
		</td>
	</tr>	
	
	<tr>
		<td colspan='5' align=right class=td1 height='25'> 
		<font style=font-size:11pt;line-height:130%> ���պ����<%=sObjectNo%> </font> 
		</td>
	</tr>
	<tr></tr>
	<tr></tr>
	<tr></tr>
	<tr></tr>
	<tr></tr>
	<tr></tr>
	<tr>
		<td colspan='5' align=left class=td1 height='25'> 
		<font style=font-size:11pt;line-height:130%>�𾴵Ŀͻ���<%=sDunObjectName%> </font> 
		</td>
	</tr>

	<tr>
		<td colspan='5' align=left class=td1 height='35'> 
		<font style=font-size:11pt;line-height:2> &nbsp &nbsp ����<span lang=EN-US><%=sArtificialNo%></span>�ţ��ı���ͬ��ţ�����ͬ��
			��λ�����н����<%=sYear%>��<%=sMonth%>��<%=sDay%>�յ��ڣ��뾡�����ʽ𳥻�(�����Ĵ��ձ���Ϊ�����):</font>
		</td>
	</tr>	
	<tr>
		<td colspan='5' align=left class=td1 height='25'> 
		<font style=font-size:11pt;line-height:130%>1��	����<%=sCorpus%>Ԫ��</font> 
		</td>
	</tr>
		<tr>
		<td colspan='5' align=left class=td1 height='25'> 
		<font style=font-size:11pt;line-height:130%>2��	������Ϣ:<%=sInterestInSheet%>Ԫ��</font> 
		</td>
	</tr>
		<tr>
		<td colspan='5' align=left class=td1 height='25'> 
		<font style=font-size:11pt;line-height:130%>3��	������Ϣ:<%=sInterestOutSheet%>Ԫ��</font> 
		</td>
	</tr>
	<tr>
		<td colspan='5' align=left class=td1 height='25'> 
		<font style=font-size:11pt;line-height:130%>4��	����:<%=sElseFee%>Ԫ��</font> 
		</td>
	</tr>
	<tr>
		<td colspan='5' align=left class=td1 height='25'> 
		<font style=font-size:11pt;line-height:130%>����:<%=sDunSum%>Ԫ��</font> 
		</td>
	</tr>
	<tr>
		<td colspan='5' align=left class=td1 height='25'> 
		<font style=font-size:11pt;line-height:130%>�������н���ȡ������Ӧ��ʩ��</font> 
		</td>
	</tr>
	<tr>
		<td colspan='5' align=left class=td1 height='25'> 
		<font style=font-size:11pt;line-height:130%>1��	���ñʴ���ת�����ڴ���ר�������պ�ͬԼ��������Ϣ����Ϣ����</font> 
		</td>
	</tr>
	<tr>
		<td colspan='5' align=left class=td1 height='25'> 
		<font style=font-size:11pt;line-height:130%>2��	�����������õȼ�����</font> 
		</td>
	</tr>
	<tr>
		<td colspan='5' align=left class=td1 height='25'> 
		<font style=font-size:11pt;line-height:130%>3��	ֹͣ�������Ĵ�����гжһ�Ʊ������ҵ�����롣��</font> 
		</td>
	</tr>
	<tr>
		<td colspan='5' align=left class=td1 height='25'> 
		<font style=font-size:11pt;line-height:130%>4��	�������������������ò���������������ṫ������ </font> 
		</td>
	</tr>
	<tr>
		<td colspan='5' align=left class=td1 height='25'> 
		<font style=font-size:11pt;line-height:130%>5��	������Ժ����֧�������ǿ��ִ�л�ֱ���������ϣ�׷�����Ϣ���� </font> 
		</td>
	</tr>
	<tr>
		<td colspan='3' align=left class=td1 height='55' width='50%'> 
		<font style=font-size:11pt;line-height:130%>�������(��ǩ����ǩ��)��</font> 
		</td>
		<td colspan='2' align=center class=td1 height='55'> 
		<font style=font-size:11pt;line-height:130%> �������£�</font> 
		</td>
	</tr>
	<tr>
		<td colspan='5' align=left class=td1 height='20'> 
		<font style=font-size:11pt;line-height:130%> </font> 
		</td>
	</tr>
		<tr>
		<td colspan='3' align=left class=td1 height='40' width='50%'> 
		<font style=font-size:11pt;line-height:130%><%=sDunDate%></font> 
		</td>
	</tr>
		<tr>
		<td colspan='5' align=left class=td1 height='25'> 
		<font style=font-size:11pt;line-height:130%>ע����֪ͨ��һʽ���ݣ������ǩ�պ�����һ�ݣ��˴�����һ����Ϊ��ִ��</font> 
		</td>
	</tr>
	
	</table>	
	</div>

	</form>
</html>	

<script type="text/javascript">

	function beforePrint(){
		document.all('PrintButton').style.display='none';
	}
		
	function afterPrint(){
		document.all('PrintButton').style.display="";
	}
	/*~[Describe=�����б�ҳ��;InputParam=��;OutPutParam=��;]~*/
	function goBack()
	{
		self.close();
	}		

</script>

<%@ include file="/IncludeEnd.jsp"%>

