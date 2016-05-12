<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
/*
*	Describe: ��ȫѡ���޸ļ��鿴ҳ��
*/
	String sCodeType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CodeType"));
	
	String sItemNo = "";  //������
	if(sCodeType.equals("06010")){  //����У�����
		sItemNo = "01%";
	}else if(sCodeType.equals("06030")){  //ǿ�Ƹ��¹���
		sItemNo = "03%";
	}else if(sCodeType.equals("06040")){  //������������
		sItemNo = "04%";
	}else if(sCodeType.equals("06050")){  //�û���ɫ����
		sItemNo = "05%";
	}else if(sCodeType.equals("065")){  //��ȫѡ��鿴
		sItemNo = "%";  //ȫ��
	}

 	String sSql = "select ItemName,ItemValue,IsInUse,ItemNo from SECURITY_AUDIT where ItemNo like :ItemNo order by ItemNo";
	String[][] auditArray = Sqlca.getStringMatrix(new SqlObject(sSql).setParameter("ItemNo",sItemNo));
%>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=gbk" />
<title>��ȫѡ��һ��</title>
<style>
body{
	
}
</style>
</head>
<body>
	<form>
	<table border="1" width="100%" bordercolor="#FFFFFF">
		<tr>
			<td width="40%"><b>��������</b></td>
			<td width="35%"><b>����ֵ</b></td>
			<td width="10%"><b>�Ƿ�����</b></td>
			<%if(!sItemNo.equals("%")){ %>
			<td width="15%" colspan="2"><b>����</b></td>
			<%}%>
		</tr>
		<%for(int i=0;i<auditArray.length;i++){
			String ItemName = auditArray[i][0];
			String ItemValue = auditArray[i][1];
			String isInUse = auditArray[i][2];
			if("Y".equalsIgnoreCase(isInUse)) isInUse = "������";
			if("N".equalsIgnoreCase(isInUse)) isInUse = "��ͣ��";
			String ItemNo = auditArray[i][3];
		%>
			<tr>
				<td><%=ItemName%><input type="hidden" value="<%=ItemNo%>" id="ItemNo<%=++i%>"></td>
				<td><table>
						<%if("0101".equals(ItemNo) || "0301".equals(ItemNo) || "0401".equals(ItemNo)){%>
						  <tr>
						  	<%if(!sItemNo.equals("%")){ %>
						  	<td><input type="text" id="ItemValue<%=i%>" value="<%=ItemValue %>"></td>
						  	<td><%=HTMLControls.generateButton("����","�������ֵ","javascript:saveValue("+"'"+isInUse+"'"+");",sResourcesPath) %></td>
						  	<%}else{ %><%=ItemValue%>
						  	<%} %>
						<%}else{ %>&nbsp;<%} %></tr>
					</table></td>
				<td><%=isInUse%></td>
				<%if(!sItemNo.equals("%")){ %>
				<td><%=HTMLControls.generateButton("����","���ø���Ŀ","javascript:beginUse("+"'"+ItemNo+"','"+ItemValue+"'"+");",sResourcesPath) %></td>
				<td><%=HTMLControls.generateButton("ͣ��","ͣ�ø���Ŀ","javascript:stopUse("+"'"+ItemNo+"','"+ItemValue+"'"+");",sResourcesPath) %></td>
				<%}%>
			</tr>
		<%}%>
	</table>
	</form>
</body>
<script type="text/javascript">
	var changeUserId = "<%=CurUser.getUserID()%>";
	var changeUserName = "<%=CurUser.getUserName()%>";
	
	//�������ֵ
	function saveValue(sIsInUse){
		if(document.getElementById("button1").title == "�������ֵ"){
			sItemNo = document.forms[0].elements[0].value;
			sItemValue = document.forms[0].elements[1].value;
			if("������" == (sIsInUse)) sIsInUse = "Y";
			if("��ͣ��" == (sIsInUse)) sIsInUse = "N";
			flag1 = checkNumber(sItemNo,sItemValue);
			if(flag1 == "0")return;
			flag2 = RunMethod("PublicMethod","SaveAuditOption",sItemNo+","+sItemValue+","+sIsInUse+","+changeUserId+","+changeUserName);
			if(flag2=="1"){
				alert("���ݱ���ɹ���");
				self.location.reload();
			}else{
				alert("����������飡");
			}
		}
	}
		
	//���ø���Ŀ
	function beginUse(ItemNo,ItemValue){
		IsInUse = 'Y';
		flag = RunMethod('PublicMethod','SaveAuditOption',ItemNo+','+ItemValue+','+IsInUse+','+changeUserId+','+changeUserName);
		if(flag=='1'){
			alert('���óɹ���');
			self.location.reload();
		}else{
			alert('���ó������飡');
		}
	}

	//ͣ�ø���Ŀ
	function stopUse(ItemNo,ItemValue){
		IsInUse = 'N';
		flag = RunMethod('PublicMethod','SaveAuditOption',ItemNo+','+ItemValue+','+IsInUse+','+changeUserId+','+changeUserName);
		if(flag=='1'){
			alert('ͣ�óɹ���');
			self.location.reload();
		}else{
			alert('ͣ�ó������飡');
		}
	}

	//����ֵУ��
	function checkNumber(ItemNo,ItemValue){
		if(ItemNo=="0101"){
			var patrn=/^[0-9]{1,2}$/;
			if(!patrn.exec(ItemValue)){
				alert("���볤�Ȳ����Ϲ淶��");
				return "0";
			}
			if(ItemValue>20 || ItemValue<0){
				alert("���볤�Ȳ����Ϲ淶��");
				return "0";
			}
		}else if(ItemNo=="0301"){
			var patrn1=/^[0-9]{1,3}$/;
			if(!patrn1.exec(ItemValue)){
				alert("�����ʹ�����޲����Ϲ淶��");
				return "0";
			}
			if(ItemValue>180 || ItemValue<0){
				alert("�����ʹ�����޲����Ϲ淶��");
				return "0";
			}
		}else if(ItemNo=="0401"){
			var patrn2=/^[0-9]{1,2}$/;
			if(!patrn2.exec(ItemValue)){
				alert("�������̴��������Ϲ淶��");
				return "0";
			}
			if(ItemValue>10 || ItemValue<0){
				alert("�������̴��������Ϲ淶��");
				return "0";
			}
		}
		return "1";
	}
</script>
<%@include file="/IncludeEnd.jsp"%>