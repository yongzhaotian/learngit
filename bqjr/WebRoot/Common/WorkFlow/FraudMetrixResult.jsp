<%@ page language="java" contentType="text/html; charset=GBK " %>
<%@ include file="/IncludeBeginMD.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=GBK">
<title></title>
<% 
	//��ȡ������������ˮ��
	String sSerialNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
	if(sSerialNo==null) sSerialNo="";
	
	String sSql="";
	String sSql1="";
	String sSql2="";
	String sSql3="";
	
	String policyset="";
	String success = "";
	String reasoncode = "";
	String policysetname="";//���Լ�����
	String finalscore=""; //��������[���ȡ����߷���,ϵ��Խ��˵������Խ��]
	String finaldecision = "";
	String policy_name=""; //��������
	//String name = ""; 
	String policyid ="";//���Թ�����
%>
<%/*~END~*/%>	
		<%
			sSql = "select s.finalscore,s.policysetname,s.finaldecision from scoredetail_info s where s.SerialNo = :SerialNo";
			ASResultSet rsTemp = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("SerialNo",sSerialNo));
 		%>
</head>
<body>
	<hr size="2">
 	<div >
		<% if(!rsTemp.next()){
			
		%>
		<table width="100%">
			<tr>
				<td>�˺�ͬ����ͬ�ܽӿ�����</td>
			</tr>
		</table>
		<% 	
 			}else{
	 			finalscore = rsTemp.getString("finalscore");
	 			finaldecision = rsTemp.getString("finaldecision");
	 			policysetname = rsTemp.getString("policysetname");
	 			if(policysetname == null || "".equals(policysetname)){
	 	%>
	 	<table width="100%">
			<tr>
				<td>�˺�ͬ����ͬ�ܽӿ�����</td>
			</tr>
		</table>
	 	<%} else{%>
	 	<table>
			<tr>
				<td style="width: 85px" align="left">&nbsp;&nbsp;���Լ����ƣ�</td>
				<td align="left" style="width: 250px">&nbsp;<%=policysetname %>&nbsp;</td>
				<td style="width: 125px" align="left">&nbsp;&nbsp;���շ�������������</td>
				<td align="left"style="width: 150px">&nbsp;<%=finalscore %>&nbsp;</td>
				<td style="width: 125px" align="left">&nbsp;&nbsp;�������������</td>
				<td align="left">&nbsp;<%=finaldecision %>&nbsp;</td>
			</tr>
		</table>
	<hr size="2">
		<div>
			<table width="100%">
				<tr>
					<td>��������</td>
				</tr>
			</table>
		</div>
	<hr size="2">
	 	<% 	
	 			sSql1 = "SELECT t.policy_name,t.policyid FROM policy_info t where t.SerialNo = :SerialNo";
	 			ASResultSet rsTemp1 = Sqlca.getASResultSet(new SqlObject(sSql1).setParameter("SerialNo",sSerialNo));
	 			while(rsTemp1.next()){
	 				policy_name = DataConvert.toString(rsTemp1.getString(1));
	 				policyid = DataConvert.toString(rsTemp1.getString(2));
	 				sSql2 = "SELECT h.name FROM hitrule_info h where h.SerialNo = :SerialNo and h.POLICYID = :POLICYID order by h.taskid";
	 				ASResultSet rsTemp2 = Sqlca.getASResultSet(new SqlObject(sSql2).setParameter("SerialNo",sSerialNo).setParameter("POLICYID", policyid));
	 				StringBuilder name = new StringBuilder();//��������
	 				String nameStr="";
	 				while(rsTemp2.next()){
		 			 	name.append(rsTemp2.getString(1)+";\r\n");
	 				}
	 				if(name.lastIndexOf(";")!=-1){
	 					name.deleteCharAt(name.length()-1);
	 				}
	 				if(name.toString()!=null&&!"".equals(name.toString())){
		 %>
	 	<div >
	 		<table width="100%">
		 		<tr >
		 			<td align="left" style="width: 85px">&nbsp;&nbsp;�������ƣ�</td>
	 			 	 <td align="left" style="width:250px" >&nbsp;<%=policy_name%>&nbsp;</td>
	 			 	 <td align="left" style="width:85px"><span >&nbsp;&nbsp;�������ƣ�</span></td>
	 			 	 <td align="left" >&nbsp;<%=name%>&nbsp;</td>
	 			 </tr>
	 			 <tr>
	 			 	 <td>&nbsp;</td>
	 			 </tr>
			</table>
	 	 </div>
	 		<% 
	 				}
	 				rsTemp2.getStatement().close();		
	 			}
	 			rsTemp1.getStatement().close();
	 		%>
	 <hr size="2">			
	 	<div >	
	 		<table width="100%">
	 		 <%
				sSql3 = "select success,reasoncode,policyset from backdetails_info where SerialNo = :SerialNo ";
	 			ASResultSet rsTemp3 = Sqlca.getASResultSet(new SqlObject(sSql3).setParameter("SerialNo",sSerialNo));
	 		 	
	 		 	if(rsTemp3.next()){
					policyset = rsTemp3.getString("policyset");
					success = rsTemp3.getString("success");
					reasoncode = rsTemp3.getString("reasoncode");
					if(!"".equals(policyset)&&null!=policyset){
						policyset = policyset.substring(2, policyset.length());
						policyset = policyset.replaceAll("@", "&nbsp;&nbsp;");
					}
					//System.out.println(policyset);
				}else{
					policyset = "�˺�ͬͬ��������ʱ�޷������ݣ�";
				}
				rsTemp3.getStatement().close();
			%>	
				
				<tr>
					<td>���й�������</td>
				</tr>
				<tr>
					<td>&nbsp;&nbsp;</td>
				</tr>
	 			<tr>
	 				<td>&nbsp;&nbsp;<%=policyset %></td>
	 			</tr>
	 		</table>
	 	</div>
	 	
	 	<%
	 	}}
	 		 rsTemp.getStatement().close();
	 	%>
 	</div>
</body>
</html>
<script type="text/javascript">
	var cobj=document.getElementsByTagName("tr");
   	for (i=0;i< cobj.length ;i++) {
      (i%2==0)?(cobj[i].style.background = "#F0FFF0"):(cobj[i].style.background = "#fff");
    }
</script>
<%@ include file="/IncludeEnd.jsp"%>