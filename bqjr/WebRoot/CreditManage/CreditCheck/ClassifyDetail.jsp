<%@page import="com.amarsoft.dict.als.manage.CodeManager"%>
<%@page contentType="text/html; charset=GBK"%>
<%@include file="/IncludeBegin.jsp"%>
<%@page import="com.amarsoft.biz.classify.*"%>
<%
	//���������������
	int i = 0,iCount = 0;
	//�����������ѯ�����
	ASResultSet rs = null ;
	//�����������װsql����ֹsqlע��
	SqlObject so = null;
	//������������շ�����
	Classify classify = null;
	//���������Sql��䡢������Ϣ���ͻ����ơ���Ʒ����
	String sSQLText = "",sMessage = "",sCustomerName = "",sBusinessName = "";
	//����������ͻ����롢�������͡������š���ˮ��
	String sObjectType = "",sObjectNo = "",sSerialNo = "";
	//�������������·ݡ�ģ�ͺš��쳣��ʾ����������
	String sAccountMonth = "",sModelNo = "",sException = "",sClassifyType = "";
	//�����������������Ŀ���ơ���Ŀֵ������
	String sAction = "",sItemName = "",sItemValue = "",sValueCode ="";
	//���������ֵ������ֵ���͡�Sql���
	String sValueMethod = "",sValueType = "",sSql = "";
	//����򿪷�ʽ
	String sOpenType = "";
	//������������
	double dBalance = 0.0;
	//�����弶�����ݻ��ͬ add by cbsu 2009-10-12
	String sResultType = "";
	
	//��ȡҳ��������������������͡��������͡���ݻ��ͬ��š��弶����������ˮ�š�����·ݡ�ģ�ͺš���ͬ���߽�ݷ���
	sAction = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("Action"));
	sClassifyType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ClassifyType"));
	sObjectType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectType"));
	sObjectNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectNo"));
	sSerialNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
	sAccountMonth = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("AccountMonth"));
	sModelNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ModelNo"));
	sResultType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ResultType"));
	sOpenType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("OpenType"));
	
	//����ֵת��Ϊ���ַ���
	if(sAction == null) sAction = "";
	if(sClassifyType == null) sClassifyType = "";
	if(sObjectType == null) sObjectType = "";
	if(sObjectNo == null) sObjectNo = "";
	if(sSerialNo == null) sSerialNo = "";
	if(sAccountMonth == null) sAccountMonth = "";
	if(sModelNo == null) sModelNo = "";
	if(sResultType == null) sResultType ="";
	if(sOpenType == null) sOpenType ="";
	
	//jschen@20100412 ͨ��sOpenType ����sObjectNo��ת��
	if("Tab".equalsIgnoreCase(sOpenType)){
		//�����Tab��ʽչ�֣�sObjectNoʵ����CLASSIFY_RECORD��SerialNo,sSerialNo�ǽ��/��ͬ�ţ�������Ҫ����ֵ
		String sTempNo = sObjectNo;
		sObjectNo = sSerialNo;
		sSerialNo = sTempNo;
	}
	
	//��ѯ����ͬ���з��շ����ҵ��Ʒ�֡��ͻ����ƺ����
	if(sResultType.equals("BusinessContract")){
		sSQLText = 	" select CustomerName,getBusinessName(BusinessType) as BusinessTypeName,Balance "+
					" from BUSINESS_CONTRACT "+
					" where SerialNo =:SerialNo ";
		rs = Sqlca.getASResultSet(new SqlObject(sSQLText).setParameter("SerialNo",sObjectNo));
		if(rs.next()){
			sCustomerName = rs.getString("CustomerName");
			sBusinessName = rs.getString("BusinessTypeName");
			dBalance = rs.getDouble("Balance");
			
			//����ֵת��Ϊ���ַ���
			if(sCustomerName == null) sCustomerName = "";
			if(sBusinessName == null) sBusinessName = "";
		}
		rs.getStatement().close();
	}
	
	//��ѯ����ݽ��з��շ����ҵ��Ʒ�֡��ͻ����ƺ����
	if(sResultType.equals("BusinessDueBill")){
		sSQLText = 	" select CustomerName,getBusinessName(BusinessType) as BusinessTypeName,Balance "+
					" from BUSINESS_DUEBILL "+
					" where SerialNo =:SerialNo ";
		rs = Sqlca.getASResultSet(new SqlObject(sSQLText).setParameter("SerialNo",sObjectNo));
		if(rs.next()){
			sCustomerName = rs.getString("CustomerName");
			sBusinessName = rs.getString("BusinessTypeName");
			dBalance = rs.getDouble("Balance");
			
			//����ֵת��Ϊ���ַ���
			if(sCustomerName == null) sCustomerName = "";
			if(sBusinessName == null) sBusinessName = "";
		}
		rs.getStatement().close();
	}
	//�½�һ��classify
	if(sAction.equals("_NEW_")){
		sSql = 	" select count(SerialNo) from CLASSIFY_RECORD "+
				" where ObjectType =:ObjectType "+
				" and ObjectNo =:ObjectNo "+
				" and AccountMonth =:AccountMonth ";
		so = new SqlObject(sSql).setParameter("ObjectType",sResultType)
		.setParameter("ObjectNo",sObjectNo).setParameter("AccountMonth",sAccountMonth);
		rs = Sqlca.getASResultSet(so);
		if (rs.next())
			iCount = rs.getInt(1);
		//�رս����
		rs.getStatement().close(); 
		
		if(iCount > 0){
%>
			<script type="text/javascript"> 
				alert(getBusinessMessage("665"));//�����ʲ����շ����Ѿ����ڣ�
				self.close();
			</script> 
<%
		}else{
			//��ȡ�ʲ����շ�������
			String sClassifyDate = StringFunction.getToday();
			//��ȡ��ǰ��������
			String sOrgID = CurOrg.getOrgID();
			//��ȡ��ǰ�û�����
			String sUserID = CurUser.getUserID();
			//�ڷ��շ����¼��������һ�������¼
			sSerialNo = Classify.newClassify(sResultType,sObjectNo,sAccountMonth,sModelNo,sClassifyDate,sOrgID,sUserID,Sqlca); 
			
			sSql = 	" update CLASSIFY_RECORD set BusinessBalance =:BusinessBalance, "+
					" InputDate =:InputDate, "+
					" UpdateDate =:UpdateDate "+
					" where SerialNo =:SerialNo ";
			so = new SqlObject(sSql);
			so.setParameter("BusinessBalance",dBalance).setParameter("InputDate",StringFunction.getToday())
			.setParameter("UpdateDate",StringFunction.getToday()).setParameter("SerialNo",sSerialNo);
			Sqlca.executeSQL(so);

			session.setAttribute("AccountMonth",sAccountMonth);
			session.setAttribute("ModelNo",sModelNo);
		}
	}
	
	classify = new Classify(sResultType,sObjectNo,sSerialNo,Sqlca);
	//����,����ʱҲ���б���
	if(sAction.equals("_UPDATE_") || sAction.equals("_CLASSIFY_")){
		if (classify.ClassifyData.first()){
			do {
	    		i++;
	     		sItemName  = "R" + String.valueOf(i);
	     		sItemValue = request.getParameter(sItemName);
			
	     		if (sItemValue!=null && sItemValue.trim().length()!=0){
	     			Sqlca.executeSQL(" update CLASSIFY_DATA set ItemValue = '"+sItemValue+"' where ObjectType = '"+sResultType+"' and ObjectNo = '"+sObjectNo+"' and SerialNo = '"+sSerialNo+"' and ItemNo = '"+classify.ClassifyData.getString("ItemNo")+"' ");
	     		}
			}while(classify.ClassifyData.next());
		 }
			 
		 classify.getRecord();	
		 classify.getData(); 
		 sMessage =  "FinishSave";  //�����ʲ����շ������ݱ�����ɣ�
	}

	//��ʼ����
	if(sAction.equals("_CLASSIFY_")){
		//ȡֵ
		classify.getValue();
		try{   //����
			classify.classify();
			sMessage = "FinishCalculate";//�����ʲ����շ��������ɣ�
		}catch(Exception e){
			classify.FirstResult = "";
			classify.SecondResult = "";
			classify.updateRecord();
			sMessage = "UnfinishCalculate";//�����ʲ����շ������û��������ɣ�
			sException = e.toString();
		}
		//����ȡ����
		classify.getRecord();
		classify.getData();  
	}

	//ɾ������
	if(sAction.equals("_DELETE_")){
		Classify.deleteClassify(classify.ObjectType,classify.ObjectNo,classify.SerialNo,Sqlca);
%>
		<script type="text/javascript"> 
			alert(getBusinessMessage("666"));//�����ʲ����շ�����Ϣɾ����ɣ�
			self.close();
		</script> 
<%		
	}
%>
<html>
<head>
<title>�ʲ����շ��� - ���������</title>
	<style>
	 input {border-style:none;border-width:thin;border-color:#e9e9e9}
	 .number {text-align:right;}
	</style>

<script type="text/javascript"> 

	/*~[Describe=����;InputParam=��;OutPutParam=SerialNo;]~*/
   	function classify(){
        var sParameter = "1=1"+  //jschen@20100423 �������
            "&OpenType= "+
	        "&Action=_CLASSIFY_"+
	        //"&ClassifyType="+sClassifyType+
	        "&ObjectType="+"<%=sObjectType%>"+
	        "&ObjectNo="+"<%=sObjectNo%>"+
	        "&SerialNo="+"<%=sSerialNo%>"+
	        "&AccountMonth="+"<%=sAccountMonth%>"+
	        "&ModelNo="+"<%=sModelNo%>"+
	        "&ResultType="+"<%=sResultType%>"+
	        "&Rand="+randomNumber();
		document.report.action="<%=sWebRootPath%>/CreditManage/CreditCheck/ClassifyDetail.jsp?"+sParameter;
		document.report.submit(); 
   	} 
  	
  	/*~[Describe=����;InputParam=��;OutPutParam=SerialNo;]~*/
   	function updateData(){
        var sParameter = "1=1"+
	        "&OpenType= "+
	        "&Action=_UPDATE_"+
	        //"&ClassifyType="+sClassifyType+
	        "&ObjectType="+"<%=sObjectType%>"+
	        "&ObjectNo="+"<%=sObjectNo%>"+
	        "&SerialNo="+"<%=sSerialNo%>"+
	        "&AccountMonth="+"<%=sAccountMonth%>"+
	        "&ModelNo="+"<%=sModelNo%>"+
	        "&ResultType="+"<%=sResultType%>"+
	        "&Rand="+randomNumber();
		document.report.action="<%=sWebRootPath%>/CreditManage/CreditCheck/ClassifyDetail.jsp?"+sParameter;
		document.report.submit(); 
   	}
   	
   	/*~[Describe=ɾ����¼;InputParam=��;OutPutParam=SerialNo;]~*/
   	function deleteData(){
		if (confirm(getBusinessMessage("667"))){ //��Ҫɾ���ø����ʲ����շ�����Ϣ��������
	        var sParameter = "1=1"+
		        "&OpenType= "+
		        "&Action=_DELETE_"+
		        //"&ClassifyType="+sClassifyType+
		        "&ObjectType="+"<%=sObjectType%>"+
		        "&ObjectNo="+"<%=sObjectNo%>"+
		        "&SerialNo="+"<%=sSerialNo%>"+
		        "&AccountMonth="+"<%=sAccountMonth%>"+
		        "&ModelNo="+"<%=sModelNo%>"+
		        "&ResultType="+"<%=sResultType%>"+
		        "&Rand="+randomNumber();
			document.report.action="<%=sWebRootPath%>/CreditManage/CreditCheck/ClassifyDetail.jsp?"+sParameter;
			document.report.submit(); 
		}
   	}  
   	
   	/*~[Describe=����;InputParam=��;OutPutParam=SerialNo;]~*/
   	function goback(){
		self.close();
   	}  
   	
   	/*~[Describe=��ʼ��ҳ��;InputParam=��;OutPutParam=SerialNo;]~*/
   	function initPage(){
		//����˲���״���Զ���ȡ
		document.report.R10.disabled=true;
		//����״���еĵ�����ʽ�Զ���ȡ
		document.report.R13.disabled=true;	
		//��֤�˲���״���Զ���ȡ	
		document.report.R15.disabled=true;
		//�Ƿ�ֱ���϶�Ϊ��ʧ��Ϊ��
		if(document.report.R2.value=="0")
			document.report.R2.value="2";
		//�Ƿ�ֱ���϶�Ϊ������Ϊ��
		if(document.report.R5.value=="0")
			document.report.R5.value="2";
		ClassifyChange();
   	}
   	
   	/*~[Describe=��ʧ����;InputParam=��;OutPutParam=SerialNo;]~*/
	function ClassifyChange(){
		//���ֱ���϶�Ϊ��ʧ�࣬��ֻ��ѡ�����ԭ����������ٽ���ѡ��
		if(document.report.R2.value == "1"){
			document.report.R3.disabled=false;
			document.report.R4.disabled=false;				
			document.report.R5.disabled=true;
			document.report.R6.disabled=true;
			document.report.R7.disabled=true;			
			document.report.R9.disabled=true;			
			document.report.R11.disabled=true;					
			document.report.R16.disabled=true;
			document.report.R19.disabled=true;									
			document.report.R20.disabled=true;
			document.report.R21.disabled=true;
			document.report.R22.disabled=true;			
			if((document.report.R3.value=="0")&&(document.report.R4.value==""))
				alert(getBusinessMessage("663"));//��ѡ��ֱ���϶�Ϊ��ʧ��ľ���ԭ�����������ԭ��
		}else{
			document.report.R3.disabled=true;	
			document.report.R4.disabled=true;
			document.report.R5.disabled=false;
			document.report.R6.disabled=false;
			document.report.R7.disabled=false;			
			document.report.R9.disabled=false;			
			document.report.R11.disabled=false;							
			document.report.R16.disabled=false;	
			document.report.R19.disabled=false;							
			document.report.R20.disabled=false;
			document.report.R21.disabled=false;
			document.report.R22.disabled=false;			
			//���ֱ���϶�Ϊ�����࣬��ֻ��ѡ�����ԭ����������ٽ���ѡ��
			if(document.report.R5.value == "1"){
				document.report.R3.disabled=true;	
				document.report.R4.disabled=true;
				document.report.R5.disabled=false;
				document.report.R6.disabled=false;
				document.report.R7.disabled=false;			
				document.report.R9.disabled=true;				
				document.report.R11.disabled=true;												
				document.report.R16.disabled=true;
				document.report.R19.disabled=true;										
				document.report.R20.disabled=true;
				document.report.R21.disabled=true;
				document.report.R22.disabled=true;
				if((document.report.R6.value=="0")&&(document.report.R7.value==""))
					alert(getBusinessMessage("664"));//��ѡ��ֱ���϶�Ϊ������ľ���ԭ�����������ԭ��
			}else{
				document.report.R3.disabled=true;	
				document.report.R4.disabled=true;
				document.report.R5.disabled=false;
				document.report.R6.disabled=true;
				document.report.R7.disabled=true;			
				document.report.R9.disabled=false;				
				document.report.R11.disabled=false;								
				document.report.R16.disabled=false;	
				document.report.R19.disabled=false;								
				document.report.R20.disabled=false;
				document.report.R21.disabled=false;
				document.report.R22.disabled=false;				
			}
		}
	}
		
</script>
  
<link rel="stylesheet" href="style.css">
</head>
<body bgcolor="#FFFFFF" leftmargin="0" topmargin="0">
<p>
<table width="100%" border="0" align="center" height="100%" cellspacing="0" cellpadding="0">
  <tr >
    <td height="1"></td>
  </tr>
  <tr > 
    <td height="1"> 
      <table width="80%" border="0" cellspace="0" cellpad="2" align="center">
        <tr> 
        <%
        	if(sClassifyType.equals("010")){
        %>
          <!-- <td ><a href="javascript:updateData()">����</a></td>
          <td ><a href="javascript:classify()" >����</a></td> -->
          <td align="center">
			<%=ASWebInterface.generateControl(SqlcaRepository,CurComp,sServletURL,"","Button","����","����","javascript:updateData()",sResourcesPath)%>
    	  </td>
    	  <td align="left">
			<%=ASWebInterface.generateControl(SqlcaRepository,CurComp,sServletURL,"","Button","����","����","javascript:classify()",sResourcesPath)%>
    	  </td>
          <!-- <td ><a href="javascript:deleteData()">ɾ��</a></td>-->
         <%
         	}
         %>
          <!-- <td ><a href="javascript:goback()">����</a></td> -->
        </tr>
      </table>
    </td>
  </tr>
  <tr> 
    <td height="1" > 
      <hr size="1" noshade color="orange">
    </td>
  </tr>
  <tr align="left" valign="top"> 
    <td width="100%"> 
      <div id="Layer1" style="position:absolute; width:100%; height:100%; z-index:1; overflow: auto"> 
       <form name="report" method="post"> <center><b><%=sCustomerName +" "+ sBusinessName +" "+  classify.AccountMonth %>���շ����<br>
		<input type=hidden name=CompClientID value="<%=CurComp.getClientID()%>">
		<input type=hidden name=PageClientID value="<%=CurPage.getClientID()%>">
		  </b> ģ�ͷ�����:
		  <b>
		  <%		  	
			String s_tmp=DataConvert.toString(classify.SecondResult);
		  %>
		  <%=CodeManager.getItemName("ClassifyResult",s_tmp)%>
		  </b> 
        </center>
        
          <table cellspacing=1 cellpadding=1 align="center">
            <tr bgcolor="#CCCCCC"> 
              <td nowrap width="50"><font color="#000099">���</font></td>
              <td nowrap width="180"><font color="#000099">��Ŀ����</font></td>
              <td nowrap width="450"><font color="#000099">��Ŀֵ</font></td>
            </tr>
            <%
				i = 0;
				if(classify.ClassifyData.first()){
					do {
				    	i ++;
				     	sItemName = "R" + String.valueOf(i);				     	
			%> 
            <tr bgcolor="#e9e9e9"> 
              <td nowrap width="50"><%=DataConvert.toString(classify.ClassifyData.getString("ItemNo"))%></td>
              <td nowrap width="180" ><input style="background-color:#e9e9e9" type=text readonly size='28' value='<%=DataConvert.toString(classify.ClassifyData.getString("ItemName"))%>'></td>
             <%
					 	sValueCode   = classify.ClassifyData.getString("ValueCode"); 
					 	sValueMethod = classify.ClassifyData.getString("ValueMethod"); 
					 	sValueType   = classify.ClassifyData.getString("ValueType"); 
					 	sItemValue   = classify.ClassifyData.getString("ItemValue"); 					 
					 	if (sValueCode != null && sValueCode.trim().length() > 0){ //����д�������ʾ�����б�
	 						//�����ģ��չ����Ŀ�������б��������õ��Ǵ��룬��ʹ�����µ����
	 						//sSql = " select ItemNo,ItemDescribe,ItemName from CODE_LIBRARY where CodeNo = '" + sValueCode + "' order by SortNo ";
	 						//�����ģ��չ����Ŀ�������б��������õ���SQL����ʹ�����µ����
	 						sSql = sValueCode;
	 		%> 
              <td width="450" class="right" > 
                <select name=<%=sItemName%> class="right" onchange="ClassifyChange();">
                  <option value='0'> </option>
                  <%=HTMLControls.generateDropDownSelect(Sqlca,sSql,1,3,DataConvert.toString(sItemValue))%> 
                </select>
              </td>
            <%
					 	}else if ((sValueMethod != null && sValueMethod.trim().length() > 0) || sValueType==null || sValueType.trim().length() == 0) //�����ȡֵ�������ܽ����޸�
					 	{
	 		%> 
	 		<% 
	 						if(DataConvert.toString(classify.ClassifyData.getString("ItemValue")).length()>0){
	 		%>
              	<td nowrap height='22' width="450" class="right" name=<%=sItemName%>> <%=DataConvert.toMoney(classify.ClassifyData.getString("ItemValue"))%></td>
            <%
             				}else{
            %>
              	<td nowrap height='22' width="450" class="right" name=<%=sItemName%>> <%=DataConvert.toString(classify.ClassifyData.getString("ItemValue"))%></td>
            <%
             				}
					 	}else{ //������Խ����޸�
			%> 
              <td nowrap width="450" class="right" > 
                <input class="right" size=100 type=text name=<%=sItemName%> value='<%=DataConvert.toString(classify.ClassifyData.getString("ItemValue"))%>'>
              </td>
            <%
	 					}	
	 		%>
	      </tr>
            <%	
					}while(classify.ClassifyData.next());
				}	
			%> 
          </table>
        </form>
      </div>
    </td>
  </tr>
</table>

<%
	if(!sAction.equals("_NEW_") && !sAction.equals("_DISPLAY_"))
	{
%>
		<script type="text/javascript">
			sMessage = "<%=sMessage%>"
			if(sMessage == "FinishSave")
				alert(getBusinessMessage("668"));//�����ʲ����շ������ݱ�����ɣ�
			if(sMessage == "FinishCalculate")
				alert(getBusinessMessage("669"));//�����ʲ����շ��������ɣ�
			if(sMessage == "UnfinishCalculate"){
				alert(getBusinessMessage("670"));//�����ʲ����շ������û��������ɣ�
				alert("<%=sException%>");
			}
		</script>
<%	 
	}
	classify.close();
	classify = null;
%>
</body>
</html>

<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List07;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script type="text/javascript">
try{
	initPage();}catch(e){}
</script>
<%/*~END~*/%>
<%@include file="/IncludeEnd.jsp"%>
