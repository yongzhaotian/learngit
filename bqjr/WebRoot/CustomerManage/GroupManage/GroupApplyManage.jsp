<%@page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/* 
		ҳ��˵��:
	 */	 
	//����������
	String sSerialNo  =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("SerialNo"));
	if(sSerialNo==null) sSerialNo="";
	
	//�������
	ASResultSet rs = null;
	String sRelaCustomerID = "";
	String sRelaCustomerID1 = "";
	String sRelaCustomerID2 = "";
	String sRelaCustomerID3 = "";
	String sRelaCustomerID4 = "";
	String sRelaCustomerID5 = "";
	String sJoinCustomerID = "";
	
	String sSql = "select CustomerID,RelaCustomerID1,RelaCustomerID2,RelaCustomerID3,RelaCustomerID4,RelaCustomerID5 from GROUP_RESULT where SerialNo = :SerialNo ";
	rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("SerialNo",sSerialNo));
	if(rs.next()){
		sRelaCustomerID = rs.getString("CustomerID");
		sRelaCustomerID1 = rs.getString("RelaCustomerID1");
		sRelaCustomerID2 = rs.getString("RelaCustomerID2");
		sRelaCustomerID3 = rs.getString("RelaCustomerID3");
		sRelaCustomerID4 = rs.getString("RelaCustomerID4");
		sRelaCustomerID5 = rs.getString("RelaCustomerID5");
	}
	rs.getStatement().close(); 
	
	//����sRelaCustomerID1-sRelaCustomerID1ֵ�ĸ�ʽ�п��ܲ��ǵ�һ�ͻ��ţ�����ʹ��@�ָ�Ķ���ͻ�ID
	//�����Ҫͳһ���Ӻ�ͳһ����
	sJoinCustomerID = sRelaCustomerID
					+"@"+sRelaCustomerID1
					+"@"+sRelaCustomerID2
					+"@"+sRelaCustomerID3
					+"@"+sRelaCustomerID4
					+"@"+sRelaCustomerID5;
	sJoinCustomerID = sJoinCustomerID.replaceAll("@+", "@");	//���ַ����п��ܴ��ڵĶ��@��Ϊ����@
	sJoinCustomerID = sJoinCustomerID.replaceAll("^@+", "");	//ȥ�����׿��ܳ��ֵ�@
	sJoinCustomerID = sJoinCustomerID.replaceAll("@+$", "");	//ȥ����ĩ�������ڵ�@
	sJoinCustomerID = sJoinCustomerID.replaceAll("@","','");	//��@��Ϊ','
	sJoinCustomerID = "'"+sJoinCustomerID+"'";
	
	//�������ɴ�ѡ��������
	sSql = "select CustomerID,CustomerName from Customer_info where CustomerID in ("+sJoinCustomerID+")";
	rs = Sqlca.getASResultSet(new SqlObject(sSql));

	String sButtons[][] = {	
		{"true","","Button","����","���������϶���","save()",sResourcesPath},
		{"true","","Button","�����϶���Ԥ��","�����϶���Ԥ��","nextStep()",sResourcesPath},		
	};
%>
<HTML>
<HEAD>
<TITLE></TITLE>
<style>
body {
	margin-left: auto;
	margin-right: auto;
}
div { /*border:1px solid #0000FF;*/
	margin: 0px;
}
div#outter { /*border:1px solid #0000FF;*/
	width: 100%;
	height: 100%;
}
div#buttonBar {
	width: 100%;
	height: 1%;
}
/*��������*/
div#containBar {
	border: 1px solid #DDDDDD;
	margin-top: 1%;
	width:100%;
	height:50%;
	padding-top:1%;
}
div#buttonBar li {
	list-style: none;
	float: left;
	margin-left: 10px;
}
/*��ѡ������ݳ���ʽ����*/
div#dataPoolDiv{
	/*border:1px solid #00FF00;*/
	width:40%;
	height:100%;
	float:left;
	padding-left:3%;
}
/*��ѡ���������ʽ����(ĸ��˾���ӹ�˾������)*/
div#selectedDiv{
	width:56%;
	height:100%;
	float:left;
	/*border:1px solid #FF0000;*/
}
/*ĸ��˾��ʽ����*/
div#selectedDiv div#parentCompany{
	width:100%;
	height:50%;
	/*border:1px solid #FF0000;*/ 
}
/*�ӹ�˾��ʽ����*/
div#selectedDiv div#childCompany{
	width:100%; 
	height:50%;
	/*border:1px solid #FF0000;*/
}
h1{
	font-size: 14px;
	margin: 0px;
	padding-left:1%; 
}
h2{ /*border:1px solid #FF0000;*/
	font-size: 14px;
	padding-left:6%; 
	margin: 0px;
}
 /*������»���*/
.lineSpan{
	border-bottom:1px solid #DDDDDD;
	width:97%;
}
/*����ı���*/
h1 span span,h2 span span{
	padding:1%,3%;  
	background-color:#DDDDDD;
}
table{
	margin:0px;
	padding:0px;
}
p { /*border:1px solid #0000FF;*/
	margin: 0px;
}
select {
	width: 20%;
	heigth: 100;
	margin: 1%;
}
.poolSelect{
	width:98%;
	heigth:100%;
	font-size:14px;
}
.selectedSelect{
	width:98%;
	heigth:100%;
	font-size:14px;
}
</style>
</HEAD>
<body>
<div id="outter">
	<div id="buttonBar">
	<table>
	<tr height=1 id="ButtonTR">
		<td id="ListButtonArea" class="ListButtonArea" valign=top>
		<%@ include file="/Resources/CodeParts/ButtonSet.jsp"%>
		</td>
	</tr>
	</table>
	</div>
	<div id="containBar">
		<!-- �ɹ�ѡ��������б� -->
		<div id="dataPoolDiv">
			<h1><span class="lineSpan"><span>�ɹ�ѡ�������</span></span></h1>
			<table width="100%" height="90%" cellpadding="0" cellspacing="0">   
				<tr>
					<td>
						<select name="allCustomerSle" id="allCustomerSle" multiple = true" class="poolSelect" size = "40">
						<%
						while(rs.next()){
							out.println("<option  value='"+rs.getString("CustomerID")+"'>"+rs.getString("CustomerID")+" "+rs.getString("CustomerName")+"</option>");
						}
						rs.getStatement().close(); 
						%>
						</select>
					</td>
				</tr>
			</table>
		</div>
		<!-- ��ѡ��������б� -->
		<div id="selectedDiv">
			<div id="parentCompany">
				<h2><span class="lineSpan"><span>ĸ��˾�б�</span></span></h2>
				<table width="100%" height="90%"> 
					<tr>
						<td text-align ="left" width="2%" height="100%"> 
							<table width="100%" height="100%"> 
								<tr><td height="50%">
										<img border='0' src='<%=sResourcesPath%>/chooser_orange/arrowRight_disabled.gif'
											alt='����ĸ��˾�б�' title="����ĸ��˾�б�"
											style="cursor: pointer;"
											name='btnParentCompanyMoveIn' id="btnParentCompanyMoveIn"
											onmouseover ='swapImg("btnParentCompanyMoveIn","MOUSE_OVER");'
											onmousedown='swapImg("btnParentCompanyMoveIn","MOUSE_DOWN");'
											onmouseup='swapImg("btnParentCompanyMoveIn","MOUSE_UP");'
											onmouseout='swapImg("btnParentCompanyMoveIn","MOUSE_OUT");'
											onclick="parentMoveIn()" />
										</td></tr>
								<tr><td height="50%">
											<img border='0' src='<%=sResourcesPath%>/chooser_orange/arrowLeft_disabled.gif'
											alt='�Ƴ�ĸ��˾�б�' title="�Ƴ�ĸ��˾�б�"
											style="cursor: pointer;"
											name='btnParentCompanyMoveOut' id="btnParentCompanyMoveOut"
											onmouseover ='swapImg("btnParentCompanyMoveOut","MOUSE_OVER");'
											onmousedown='swapImg("btnParentCompanyMoveOut","MOUSE_DOWN");'
											onmouseup='swapImg("btnParentCompanyMoveOut","MOUSE_UP");'
											onmouseout='swapImg("btnParentCompanyMoveOut","MOUSE_OUT");'
											onclick="parentMoveOut()" />
										</td></tr>
							</table>							
						</td>
						<td text-align="left" width="98%" height="100%"> 
							<select multiple =true name="parentCompanySle" id="parentCompanySle" class="selectedSelect" size = "18">
							</select>
						</td>
					</tr>
				</table>
			</div>
			<div id="childCompany">
				<h2><span class="lineSpan"><span>�ӹ�˾�б�</span></span></h2>
				<table width="100%" height="90%"> 
					<tr>
						<td text-align="left" width="2%" height="100%">
							<table width="100%" height="100%">
								<tr><td height="50%">
										<img border='0' src='<%=sResourcesPath%>/chooser_orange/arrowRight_disabled.gif'
											alt='�����ӹ�˾�б�' title="�����ӹ�˾�б�"
											style="cursor: pointer;"
											name='btnchildCompanyMoveIn' id="btnchildCompanyMoveIn"
											onmouseover ='swapImg("btnchildCompanyMoveIn","MOUSE_OVER");'
											onmousedown='swapImg("btnchildCompanyMoveIn","MOUSE_DOWN");'
											onmouseup='swapImg("btnchildCompanyMoveIn","MOUSE_UP");'
											onmouseout='swapImg("btnchildCompanyMoveIn","MOUSE_OUT");'
											onclick="childMoveIn()" />
										</td></tr>
								<tr><td height="50%">
										<img border='0' src='<%=sResourcesPath%>/chooser_orange/arrowLeft_disabled.gif'
											alt='�Ƴ��ӹ�˾�б�' title="�Ƴ��ӹ�˾�б�"
											style="cursor: pointer;"
											name='btnchildCompanyMoveOut' id="btnchildCompanyMoveOut"
											onmouseover ='swapImg("btnchildCompanyMoveOut","MOUSE_OVER");'
											onmousedown='swapImg("btnchildCompanyMoveOut","MOUSE_DOWN");'
											onmouseup='swapImg("btnchildCompanyMoveOut","MOUSE_UP");'
											onmouseout='swapImg("btnchildCompanyMoveOut","MOUSE_OUT");'
											onclick="childMoveOut()" />
										</td></tr>
							</table>
						</td>
						<td text-align="left" height="100%">
							<select multiple =true name="childCompanySle" id="childCompanySle" class="selectedSelect" size = "18">
							</select>
						</td>
					</tr>
				</table>
			</div>
		</div>
	</div>
</div>
</body>
</html>
<script type="text/javascript">
	/**
	 *��һ��select��������Ƶ���һ��select��
	 *@srcSle Դ�б��
	 *@descSle Ŀ����
	 *@options ��ѡ���ֵ��
	 */
	function optionMove(srcSle,descSle,options){
		for(var i=0;i<options.length;i++){
			//1.ɾ��Դ��
			for(var j=0;j<srcSle.length;j++){
				if(srcSle[j] == options[i]){
					bSaveFlag = false;
					srcSle[j] = null;
					break;
				}
			}
			options[i].selected = false;//ȡ������ѡ������
			//2.����Ŀ���
			descSle.options.add(options[i]);
		}
	}
	/**
	 *��һ��select����ѵ�������option�������ʽ����
	 *@select �б������
	 */
	function getSelectedOptions(select){
		var options = new Array();
		for(var i=0;i<select.length;i++){
			if(select[i].selected){
				options.push(select[i]); 
			}
		}
		return options;
	}

	/**
	 *ͼƬ��������ť��̬Ч��
	 *ͼƬ��ʽ�����룬���£��ɿ����Ƴ�
	 *@buttonId ��ťID��
	 *@type �������� ,MOUSE_OVER,MOUSE_DOWN,MOUSE_UP,MOUSE_OUT
	 */
	function swapImg(buttonId,type) {
		var img = document.getElementById(buttonId); 
		if (img == null) return; 
		var src = img.src; 
		var und = -1;											
		var oldSuffix = "";								//ԴͼƬ�ĺ�׺
		var newSuffix = "";								//��ͼƬ�ĺ�׺
		var imgPrefix = ""; 							//ͼƬǰ׺
		if(type == "MOUSE_OVER"){
			oldSuffix = "_disabled.gif";
			newSuffix = ".gif";
		}else if(type == "MOUSE_DOWN"){
			oldSuffix = ".gif";
			newSuffix = "_clicked.gif";
		}else if(type == "MOUSE_UP"){
			oldSuffix = "_clicked.gif";
			newSuffix = ".gif";
		}else if(type == "MOUSE_OUT"){
			//��ֹ���º���Ƴ�ȥ��,ִ�в�UP�¼������ͼƬ����ƴ�Ӵ�������������
			u = src.lastIndexOf("_clicked.gif");
			if(u == -1){
				oldSuffix = ".gif";
			}else{
				oldSuffix = "_clicked.gif";
			}
			newSuffix = "_disabled.gif";
		}else{
			return;
		}
		
		und = src.lastIndexOf(oldSuffix); 
		if (und == -1){
			return false;
		} 
		imgPrefix = src.substring(0,und);
		img.src = imgPrefix + newSuffix;
		
	}

	var bSaveFlag = false;
	
	/*~[Describe=����ĸ��˾�б�;]~*/
	function parentMoveIn(){
		var allCustomerSle = document.getElementById("allCustomerSle");
		var parentCompanySle = document.getElementById("parentCompanySle");
		var options = getSelectedOptions(allCustomerSle);
		//��ѡ������������������ң���ѡ������ݲ��ܶ���1��������ĸ��˾�б����ݲ��ܶ���һ����
		if(options.length > 0 &&(options.length > 1 || parentCompanySle.length >= 1 )){
			alert("ĸ��˾�������ܳ���һ��");
			return;
		}else{
			optionMove(allCustomerSle,parentCompanySle,options);
		}
	}
	/*~[Describe=�Ƴ�ĸ��˾�б�;]~*/
	function parentMoveOut(){
		var allCustomerSle = document.getElementById("allCustomerSle");
		var parentCompanySle = document.getElementById("parentCompanySle");
		var options = getSelectedOptions(parentCompanySle);
		optionMove(parentCompanySle,allCustomerSle,options);
	}
	/*~[Describe=�����ӹ�˾�б�;]~*/
	function childMoveIn(){
		var allCustomerSle = document.getElementById("allCustomerSle");
		var childCompanySle = document.getElementById("childCompanySle");
		var options = getSelectedOptions(allCustomerSle);
		optionMove(allCustomerSle,childCompanySle,options);
	}
	/*~[Describe=�����ӹ�˾�б�;]~*/
	function childMoveOut(){
		var allCustomerSle = document.getElementById("allCustomerSle");
		var childCompanySle = document.getElementById("childCompanySle");
		var options = getSelectedOptions(childCompanySle);
		optionMove(childCompanySle,allCustomerSle,options);
	}

	function save(){
		var parentCustomerID = new Array();
		var chileCustomerID = new Array();

		//ȡ����
		var parentCompanySle = document.getElementById("parentCompanySle");
		for(var i=0;i<parentCompanySle.length;i++){
			parentCustomerID.push(parentCompanySle[i].value);
		}
		var childCompanySle = document.getElementById("childCompanySle");
		for(var i=0;i<childCompanySle.length;i++){
			chileCustomerID.push(childCompanySle[i].value);
		}
		
		var boolvalue =RunMethod("CustomerManage","SaveGroupRela","<%=sSerialNo%>,"+parentCustomerID.join("@")+","+chileCustomerID.join("@"));
		if(boolvalue == "1" ){			
			alert("����ɹ�");
			bSaveFlag = true;
		}else if(boolvalue == "2"){
			alert("����ѡ���ӹ�˾�ٱ���");	
		}else{
			alert("����ʧ��");
		}
	}
	
	/*~[Describe=���������϶���;]~*/
	function nextStep(){
		var sSerialNo = "<%=sSerialNo%>";
		if(bSaveFlag == false){
			alert("���ȱ���");
			return;
		}
		
		/* �����˴�����Ҫʱ�ɴ򿪡�ע�⣺ʹ��ʱ�����sSerialNo��ֵӦ��ͬ������ʵʱ�����϶������顣
		  //�鼯�ſͻ��϶��������Ƿ��Ѿ�����
		  sReturn = PopPage("/FormatDoc/GetReportFile.jsp?ObjectNo="+sSerialNo+"&ObjectType=GroupCustomer","","");
		  //δ���ɼ��ſͻ��϶�������
		  if (sReturn == "false"){ 
			PopPage("/FormatDoc/GroupManage/7502.jsp?DocID=7502&ObjectNo="+sSerialNo+"&ObjectType=GroupCustomer&SerialNo="+sSerialNo+"&Method=4&FirstSection=1&EndSection=1&rand="+randomNumber(),"myprint10","dialogWidth=10;dialogHeight=1;status:no;center:yes;help:no;minimize:yes;maximize:no;border:thin;statusbar:no");	
		}*/
		PopPageAjax("/FormatDoc/GroupManage/7502.jsp?DocID=7502&ObjectNo="+sSerialNo+"&ObjectType=GroupCustomer&SerialNo="+sSerialNo+"&Method=4&FirstSection=1&EndSection=0&rand="+randomNumber(),"myprint10","dialogWidth=10;dialogHeight=1;status:no;center:yes;help:no;minimize:yes;maximize:no;border:thin;statusbar:no");		
		//��ü��ܺ����ˮ��
		var sEncryptSerialNo = PopPageAjax("/PublicInfo/EncryptSerialNoAction.jsp?EncryptionType=MD5&SerialNo="+sSerialNo);
		//ͨ����serverlet ��ҳ��
		if(navigator.appName=="Microsoft Internet Explorer"){
			var CurOpenStyle = "width=100,height=100,top=20,left=20,toolbar=no,scrollbars=yes,resizable=yes,status=yes,menubar=no,";	
			PopPage("/FormatDoc/POPreviewFile.jsp?TimeOut=1&EncryptSerialNo="+sEncryptSerialNo+"&ObjectNo="+sSerialNo+"&ObjectType=GroupCustomer","_blank02",CurOpenStyle); 	
		}else{
			PopComp("POPreviewFile","/FormatDoc/POPreviewFile.jsp","TimeOut=1&EncryptSerialNo="+sEncryptSerialNo+"&ObjectNo="+sSerialNo+"&ObjectType=GroupCustomer"); 	
		}
	}
</script>
<%@ include file="/IncludeEnd.jsp"%>