<%@ page contentType="text/html; charset=GBK"%>
<%@ page import="com.amarsoft.app.creditline.bizlets.*"%>
<%@ page import="com.amarsoft.biz.bizlet.Bizlet"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/%>
	<%
	/*
		Author: hwang 2009-06-22
		Tester:
		Describe: ȡ�Ӷ�����
		Input Param:
			LineNo:���Э���(��ȵĺ�ͬ��ˮ��)
			BusinessType:ҵ������
		Output Param:
		
		HistoryLog:
			
	 */
	%>
<%/*~END~*/%> 


<% 
	//��ò�����������ˮ�š��������͡������š��ͻ����͡��ͻ�ID
	String sLineNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("LineNo"));
	String sBusinessType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("BusinessType"));
	String sSql="";
	double dLineBalance = 0.0;//������
	double dSubLineBalance=0.0;//�Ӷ�����
	double dLineAvailableBalance=0.0;//���ָ��ҵ�����Ϳ��ý��
	//����ֵת���ɿ��ַ���
	if(sLineNo == null) sLineNo = "";
	if(sBusinessType == null) sBusinessType = "";
	
	//ȡ������
	Bizlet bzGetCreditLineBalance = new GetCreditLineBalance();
	bzGetCreditLineBalance.setAttribute("LineNo",sLineNo);
	String sCreditBalance=(String)bzGetCreditLineBalance.run(Sqlca);
	dLineBalance = Double.valueOf(sCreditBalance).doubleValue();
	//ȡ�Ӷ�����
	Bizlet bzGetCreditSubLineBalance = new GetCreditSubLineBalance();
	bzGetCreditSubLineBalance.setAttribute("LineNo",sLineNo);
	bzGetCreditSubLineBalance.setAttribute("BusinessType",sBusinessType);
	String sSubCreditBalance=(String)bzGetCreditSubLineBalance.run(Sqlca);
	//��ַ���ֵ���Ӷ�����&�Ӷ�ȱ���
	if(sSubCreditBalance !=null && sSubCreditBalance.indexOf("&") <0){//û�з��䵱ǰ�����Ӧ��ҵ�������Ӷ��
		dLineAvailableBalance=dLineBalance;//�Ӷ�����=������
	}else{
		String[] sSubCreditBalances = sSubCreditBalance.split("&");
		//�Ӷ�����
		if(sSubCreditBalances[0]==null || sSubCreditBalances[0].length() ==0){
			dSubLineBalance=0;
		}else{
			dSubLineBalance = Double.valueOf(sSubCreditBalances[0]).doubleValue();
		}
		if(dSubLineBalance<=dLineBalance){
			dLineAvailableBalance = dSubLineBalance;
		}else{
			dLineAvailableBalance = dLineBalance;
		}
	}
	
	if((dLineAvailableBalance<0)){
		dLineAvailableBalance = 0;	
	}
%>
<html>
<body bgcolor="#EAEAEA" >
<table align="center">
	<tr>
		<td><font size='5' color='blue'>�Ӷ�����</font></td>
	</tr>
</table></br>
<table border="0" width="100%" id="table1" cellspacing="0" cellpadding="0" bordercolordark="#000000">	
	<tr>
		<td width="250">[<%=Sqlca.getString(new SqlObject("select TypeName from Business_Type where TypeNo=:TypeNo").setParameter("TypeNo",sBusinessType)) %>]ҵ�������Ӷ����</td>
		<td><%=DataConvert.toMoney(dLineAvailableBalance)%></td>
	</tr>	
</table><br><br>
<table valign="bottom" width="100%" border="0" cellspacing="0" cellpadding="3"  bordercolordark="#FFFFFF">
		<tr>
			<td align = center> 
		    	<input type="button" style="width:50px"  value=" ��  �� " class="button" onclick="javascipt: self.close();">
		    </td>
	    </tr>
</table>
</body>
</html>
<%@ include file="/IncludeEnd.jsp"%>