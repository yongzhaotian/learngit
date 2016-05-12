<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author: hxli 2005-8-1
		Tester:
		Describe: �������б�
		Input Param:
			InspectType��  �������� 
				010     ������;��鱨��
	            010010  δ���
	            010020  �����
	            020     �����鱨��
	            020010  δ���
	            020020  �����
		Output Param:
			SerialNo:��ˮ��
			ObjectType:��������
			ObjectNo��������
			
		HistoryLog:
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "�������б�"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%

	//����������
	String sInspectType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("InspectType"));
    if(sInspectType == null) sInspectType="020010";
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%
	
 	 
   
    String sWhereCond="";
  	ASDataObject doTemp = null;
  	if(sInspectType.equals("010010") || sInspectType.equals("010020")){ 
  		 String sTempletNo = "BusinessInspectList1";
  		 doTemp = new ASDataObject(sTempletNo,Sqlca);	
  		 sWhereCond=" where  INSPECT_INFO.ObjectType='BusinessContract' "+
	                " and  INSPECT_INFO.InspectType like '010%' "+
	                " and  INSPECT_INFO.ObjectNo=BUSINESS_CONTRACT.SerialNo "+
	                " and  INSPECT_INFO.InputUserID='"+CurUser.getUserID()+"'";
  		if(sInspectType.equals("010010")){
			doTemp.WhereClause=doTemp.WhereClause+sWhereCond+" and ( INSPECT_INFO.FinishDate = ' ' or  INSPECT_INFO.FinishDate is null)";
			doTemp.OrderClause += " order by INSPECT_INFO.UpDateDate desc";
		}
  		else{
			doTemp.WhereClause=doTemp.WhereClause+sWhereCond+" and  INSPECT_INFO.FinishDate <> ' ' and  INSPECT_INFO.FinishDate is not null";
			doTemp.OrderClause += " order by INSPECT_INFO.FinishDate desc";
		}
  		doTemp.generateFilters(Sqlca);
		doTemp.parseFilterData(request, iPostChange);
		CurPage.setAttribute("FilterHTML",
				doTemp.getFilterHtml(Sqlca));
  	}
  	else if(sInspectType.equals("020010") || sInspectType.equals("020020")){
  		 String sTempletNo = "BusinessInspectList2";
  		doTemp = new ASDataObject(sTempletNo,Sqlca);	
  		sWhereCond="where ObjectType='Customer' "+
                " and InspectType  like '020%' "+
                " and InputUserID='"+CurUser.getUserID()+"'";
  		if(sInspectType.equals("020010")){
  			doTemp.WhereClause=doTemp.WhereClause+sWhereCond+" and (FinishDate = ' ' or FinishDate is null)";
  			doTemp.OrderClause += "Order by UpDateDate desc";
		}
  		else{
			doTemp.WhereClause=doTemp.WhereClause+sWhereCond+" and FinishDate is not null";
			doTemp.OrderClause += "Order by FinishDate desc";
		}
  		doTemp.generateFilters(Sqlca);
		doTemp.parseFilterData(request, iPostChange);
		CurPage.setAttribute("FilterHTML",
				doTemp.getFilterHtml(Sqlca));
	} //����ģ�ͣ�2013-5-9

  	
  	  	
  	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
  	dwTemp.Style="1";      //����ΪGrid���
  	dwTemp.ReadOnly = "1"; //����Ϊֻ��
  	
    //��������¼���ͬʱɾ��������Ϣ
	dwTemp.setEvent("BeforeDelete","!InfoManage.DeleteInspectData(#SerialNo)");
  
  	Vector vTemp = dwTemp.genHTMLDataWindow("");
  	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List04;Describe=���尴ť;]~*/%>
	<%
	//����Ϊ��
		//0.�Ƿ���ʾ
		//1.ע��Ŀ�������(Ϊ�����Զ�ȡ��ǰ���)
		//2.����(Button/ButtonWithNoAction/HyperLinkText/TreeviewItem/PlainText/Blank)
		//3.��ť����
		//4.˵������
		//5.�¼�
		//6.��ԴͼƬ·��

	String sButtons[][] = {
		{"true","","Button","����","��������","newRecord()",sResourcesPath},
		{"true","","Button","����","�鿴��������","viewAndEdit()",sResourcesPath},
		{"true","","Button","ɾ��","ɾ���ñ���","deleteRecord()",sResourcesPath},
		{"true","","Button","�ͻ�������Ϣ","�鿴�ͻ�������Ϣ","viewCustomer()",sResourcesPath},
		{"true","","Button","ҵ���嵥","�鿴ҵ���嵥","viewBusiness()",sResourcesPath},
		{"false","","Button","���","��ɱ���","finished()",sResourcesPath},
		{"false","","Button","����","������д����","ReEdit()",sResourcesPath}
		};
		
		if(sInspectType.equals("010010") || sInspectType.equals("020010")){
			sButtons[5][0] = "true";
		}
		
		if(sInspectType.equals("010020") || sInspectType.equals("020020")){
		    sButtons[0][0] = "false";
		    sButtons[2][0] = "false";
		    sButtons[6][0] = "true";
		}
	%>
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">

	//---------------------���尴ť�¼�------------------------------------
	/*~[Describe=������¼;InputParam=��;OutPutParam=��;]~*/
	function newRecord(){
		sInspectType = "<%=sInspectType%>";
		if(sInspectType == '010010'){
			//ѡ�����ĺ�ͬ��Ϣ
			var sParaString = "ManageUserID" + "," + "<%=CurUser.getUserID()%>";
			sReturn = selectObjectValue("SelectInspectContract",sParaString,"",0,0);
			if(sReturn=="" || sReturn=="_CANCEL_" || sReturn=="_CLEAR_" || sReturn=="_NONE_" || typeof(sReturn)=="undefined") 
				return;
			sReturn = sReturn.split("@");
			//�õ���ͬ���
			sContractNo=sReturn[0];
			sSerialNo = PopPageAjax("/CreditManage/CreditCheck/AddInspectActionAjax.jsp?ObjectNo="+sContractNo+"&InspectType="+sInspectType+"&ObjectType=BusinessContract","","");
			sCompID = "PurposeInspectTab";
			sCompURL = "/CreditManage/CreditCheck/PurposeInspectTab.jsp";
			sParamString = "SerialNo="+sSerialNo+"&ObjectNo="+sContractNo+"&ObjectType=BusinessContract";
			OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
		}else if(sInspectType == '020010'){
			sParaString = "UserID" + "," + "<%=CurUser.getUserID()%>";
			sReturn = selectObjectValue("SelectInspectCustomer",sParaString,"",0,0);
			//alert(sReturn);
			if(sReturn=="" || sReturn=="_CANCEL_" || sReturn=="_CLEAR_" || sReturn=="_NONE_" || typeof(sReturn)=="undefined") return;
			sReturn = sReturn.split("@");			
			//�õ��ͻ�������Ϣ
			sCustomerID=sReturn[0];
			//������в��¼
			sSerialNo = PopPageAjax("/CreditManage/CreditCheck/AddInspectActionAjax.jsp?ObjectNo="+sCustomerID+"&InspectType="+sInspectType+"&ObjectType=Customer","","");
			sCompID = "InspectTab";
			sCompURL = "/CreditManage/CreditCheck/InspectTab.jsp";
			sParamString = "SerialNo="+sSerialNo+"&ObjectNo="+sCustomerID+"&ObjectType=Customer";
			OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
		}
		reloadSelf();
	}

	/*~[Describe=ɾ����¼;InputParam=��;OutPutParam=��;]~*/
	function deleteRecord(){
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if(typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}
		else if(confirm(getHtmlMessage('2')))//�������ɾ������Ϣ��
		{
			as_del('myiframe0');
			as_save('myiframe0');  //�������ɾ������Ҫ���ô����
		}
	}

	/*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=��;]~*/
	function viewAndEdit(){
		var sInspectType = "<%=sInspectType%>";
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		var sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		var sObjectType=getItemValue(0,getRow(),"ObjectType");
		if(typeof(sSerialNo)=="undefined" || sSerialNo.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else{
			if(sInspectType == '010010' || sInspectType == '010020'){
				sCompID = "PurposeInspectTab";
				sCompURL = "/CreditManage/CreditCheck/PurposeInspectTab.jsp";
				sParamString = "SerialNo="+sSerialNo+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType;

				OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
			}else if(sInspectType == '020010' || sInspectType == '020020'){
				sCompID = "InspectTab";
				sCompURL = "/CreditManage/CreditCheck/InspectTab.jsp";
				sParamString = "SerialNo="+sSerialNo+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType;
				
				OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
			}
		}
	}

  	/*~[Describe=���;InputParam=��;OutPutParam=��;]~*/
	function finished(){
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		var sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		var sObjectType=getItemValue(0,getRow(),"ObjectType");
		if(typeof(sSerialNo)=="undefined" || sSerialNo.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}
		else if(confirm(getBusinessMessage('650')))//���������ɸñ�����
		{
			sReturn=PopPageAjax("/CreditManage/CreditCheck/FinishInspectActionAjax.jsp?SerialNo="+sSerialNo+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType,"","");
			if(sReturn=="Inspectunfinish"){
				alert(getBusinessMessage('651'));//�ô����鱨���޷���ɣ�������ɷ��շ��࣡
				return;
			}
			if(sReturn=="Purposeunfinish"){
				alert(getBusinessMessage('652'));//�ô�����;�����޷���ɣ�������������¼���ÿ��¼��
				return;
			}
			if(sReturn=="finished"){
				alert(getBusinessMessage('653'));//�ñ�������ɣ�
				reloadSelf();
			}
		}
	}
	 
    /*~[Describe=�鿴�ͻ�����;InputParam=��;OutPutParam=��;]~*/
	function viewCustomer(){
		if("<%=sInspectType%>"=="010010" || "<%=sInspectType%>"=="010020"){
            sCustomerID   = getItemValue(0,getRow(),"CustomerID");
        }else if("<%=sInspectType%>"=="020010" || "<%=sInspectType%>"=="020020"){
    	    sCustomerID   = getItemValue(0,getRow(),"ObjectNo");
    	}
		
		if (typeof(sCustomerID)=="undefined" || sCustomerID.length==0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else{
			openObject("Customer",sCustomerID,"001");
		}
    		
    }
    /*~[Describe=�鿴ҵ���嵥;InputParam=��;OutPutParam=��;]~*/
	function viewBusiness(){
		if("<%=sInspectType%>"=="010010" || "<%=sInspectType%>"=="010020"){
            sCustomerID   = getItemValue(0,getRow(),"CustomerID");
        }else if("<%=sInspectType%>"=="020010" || "<%=sInspectType%>"=="020020"){
    	    sCustomerID   = getItemValue(0,getRow(),"ObjectNo");
    	}
		
		if (typeof(sCustomerID)=="undefined" || sCustomerID.length==0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else{
			popComp("CustomerLoanAfterList","/CustomerManage/EntManage/CustomerLoanAfterList.jsp","CustomerID="+sCustomerID,"","","");
		}
	}
	
	function ReEdit(){
	    var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		var sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		var sObjectType=getItemValue(0,getRow(),"ObjectType");
		if(typeof(sSerialNo)=="undefined" || sSerialNo.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}
		else if(confirm(getBusinessMessage('654')))//��ȷ��Ҫ���ظñ�����
		{
			sReturn=PopPageAjax("/CreditManage/CreditCheck/ReEditInspectActionAjax.jsp?SerialNo="+sSerialNo+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType,"","");
			if(sReturn=="succeed")
				alert(getBusinessMessage('655'));//���泷����ɣ�
			reloadSelf();
		}
	}
	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List07;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script type="text/javascript">
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>
<%/*~END~*/%>

<%@	include file="/IncludeEnd.jsp"%>