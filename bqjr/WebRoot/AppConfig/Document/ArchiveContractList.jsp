<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		--ҳ��˵��: ʾ���б�ҳ��--
	 */
	String PG_TITLE = "ʾ���б�ҳ��";
	//���ҳ�����
	//String sInputUser =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("InputUser"));
	//if(sInputUser==null) sInputUser="";
	
	//ͨ��DWģ�Ͳ���ASDataObject����doTemp
	String sTempletNo = "ArchiveContractList";//ģ�ͱ��
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	doTemp.multiSelectionEnabled=true;
	doTemp.setColumnAttribute("CERTID,SALESMANAGER,AccessUserName,ReturnUserName,InputUserID,ArchiveDate,NowReturnDate","IsFilter","1");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	doTemp.WhereClause+=" and ISARCHIVE='01' and (RENTURNDATE>=ACCESSDATE or ACCESSDATE is null )  ";
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.setPageSize(10);

	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{"true","","Button","��ͬ����","��ͬ����","viewtab()",sResourcesPath},
		{"true","","Button","���Ӻ�ͬ","���Ӻ�ͬ","elecContractView()",sResourcesPath},
		{"true","","Button","���ĵ�����Э��","���ĵ�����Э��","creatThirdTable()",sResourcesPath},
		{"true","","Button","Ӱ��","Ӱ��","imageView()",sResourcesPath},
		{"true","","Button","��ͬ����","��ͬ����","contractView()",sResourcesPath},
		{"true","","Button","�黹","�黹","tackbackContract()",sResourcesPath},
		{"false","","Button","����","����","destroyContract()",sResourcesPath},
		{"true","","Button","�鿴��ʷ������Ϣ","�鿴��ʷ������Ϣ","lookHistory()",sResourcesPath},
		{CurUser.getRoleTable().contains("2001")?"true":"false","","Button","����EXCEL","����EXCEL","exportExcel()",sResourcesPath},
	};
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">

		//Excel����������	
		function exportExcel(){
			amarExport("myiframe0");
		}
		//end by pli2 20140417	
	
	function viewtab(){
		//����������͡�������ˮ��
		var sObjectType = "BusinessContract";
		var sObjectNo = getItemValue(0,getRow(),"SERIALNO");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		sCompID = "CreditTab";
		sCompURL = "/CreditManage/CreditApply/ObjectTab.jsp";
		sParamString = "ObjectType="+sObjectType+"&ObjectNo="+sObjectNo;
		OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
		reloadSelf();
	}
	
	function elecContractView(){
		var sObjectNo = getItemValue(0,getRow(),"SERIALNO");
		
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert("��ѡ��һ����¼��");
			return;
		}
		sObjectType = "ApplySettle";
		var sDocID = "7006";
		//add �ֽ���������
		var ssProductID = RunMethod("PublicMethod","GetColValue","productid,business_contract,String@SerialNo@"+sObjectNo);
		var sProductID=ssProductID.split("@")[1];
		if(null == sProductID) sProductID = "";
		if("020" == sProductID)
		{
			sObjectType = "CashLoanSettle";
			sDocID = "L001";
		}
		//end
		
		sExchangeType = "";
		//������֪ͨ���Ƿ��Ѿ�����
		var sReturn = PopPageAjax("/FormatDoc/GetReportFile.jsp?DocID="+sDocID+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType,"","");
		if (sReturn == "false"){ //δ���ɳ���֪ͨ��
			alert("���Ӻ�ͬ�����ڣ�");
			return;
			//���ɳ���֪ͨ��	
// 			var sSerialNo = getSerialNo("FORMATDOC_RECORD", "SerialNo", "AS");
// 			PopPage("/FormatDoc/Report17/03.jsp?DocID="+sDocID+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType+"&SerialNo="+sSerialNo+"&Method=4&FirstSection=1&EndSection=0&rand="+randomNumber(),"myprint10","dialogWidth=10;dialogHeight=1;status:no;center:yes;help:no;minimize:yes;maximize:no;border:thin;statusbar:no");	
		}else{
			//��¼�鿴����
			RunJavaMethodSqlca("com.amarsoft.app.billions.InsertFormatDocLog", "recordFormatDocLog", "serialNo="+sReturn+",orgID=<%=CurUser.getOrgID()%>,userID=<%=CurUser.getUserID()%>,occurType=view");
			//��ü��ܺ�ĳ�����ˮ��
			var sEncryptSerialNo = PopPageAjax("/PublicInfo/EncryptSerialNoAction.jsp?EncryptionType=MD5&SerialNo="+sObjectNo);
			//ͨ����serverlet ��ҳ��
			var CurOpenStyle = "width=720,height=540,top=20,left=20,toolbar=no,scrollbars=yes,resizable=yes,status=yes,menubar=no,";	
			//+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType  add by cdeng 2009-02-17
			OpenPage("/FormatDoc/POPreviewFile.jsp?EncryptSerialNo="+sEncryptSerialNo+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType,"_blank02",CurOpenStyle); 
		}					
	}
	
	function lookHistory(){
		var sCount=RunMethod("Unique","uniques","EVENT_INFO,SERIALNO,type='030' or type='040'");
		if(sCount=="Null"){
			alert("û����ʷ������Ϣ��¼��");
			return;
		}
		AsControl.OpenView("/AppConfig/Document/LookAccessList.jsp","","right","");
	}

	/* function imageView(){
		 var sObjectNo   = getItemValue(0,getRow(),"SERIALNO");
	        if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
	            alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
	            return;
	        }
	     var param = "ObjectType=Business&TypeNo=20&ObjectNo="+sObjectNo;
	     AsControl.PopView( "/ImageManage/ImageView.jsp", param, "" );
	} */
	function imageView(){
	    var sObjectNo   = getItemValue(0,getRow(),"SERIALNO");
	    if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
	        alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
	        return;
	    }
//	     var param = "ObjectType=Business&TypeNo=20&ObjectNo="+sObjectNo;
//	     AsControl.PopView( "/ImageManage/ImageViewNew.jsp", param, "" );
	     var param = "ObjectType=Business&TypeNo=20&RightType=100&ObjectNo="+sObjectNo;
	     AsControl.PopView( "/ImageManage/ImageView.jsp", param, "" );
	}
	
	/*~[Describe=��ӡ������;InputParam=��;OutPutParam=��;]~*/
	function creatThirdTable(){
		var sObjectNo = getItemValue(0,getRow(),"SERIALNO");
		var sCustomerID=getItemValue(0,getRow(),"CUSTOMERID");
		//alert("sObjectNo"+sObjectNo+"==sCustomerID"+sCustomerID);
		var sObjectType = "ThirdSettle";
		//var sTempSaveFlag = getItemValue(0,getRow(),"TempSaveFlag");
		var xx = RunMethod("PublicMethod","GetColValue","TempSaveFlag,business_contract,String@SerialNo@"+sObjectNo);
		var sTempSaveFlag = xx.split("@")[1];
		sExchangeType = "";
		var sSerialNo = getSerialNo("FORMATDOC_RECORD", "SerialNo", "TS");
		var sCTempSaveFlag = RunMethod("BusinessManage","TempSaveFlag",sCustomerID);
		 if (typeof(sTempSaveFlag)=="undefined" || sTempSaveFlag.length==0 || sTempSaveFlag == "1" || typeof(sCTempSaveFlag)=="undefined" || sCTempSaveFlag.length==0 || sCTempSaveFlag == "1"){
			alert("�ͻ���������Ϣδ���棬�뱣����Ϣ���ٴ�ӡ�����");
			return;
		}else{ 
			//������֪ͨ���Ƿ��Ѿ�����
			var sReturn = PopPageAjax("/FormatDoc/GetReportFile.jsp?DocID=7006&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType,"","");
			if (sReturn == "false"){ //δ���ɳ���֪ͨ��
				var sUrl = "/FormatDoc/Report17/04.jsp";
				//add �ֽ���������
				var ssProductID = RunMethod("PublicMethod","GetColValue","productid,business_contract,String@SerialNo@"+sObjectNo);
				var sProductID=ssProductID.split("@")[1];
				if(null == sProductID) sProductID = "";
				if("020" == sProductID)
				{
					sUrl = "/FormatDoc/CashLoanReport/04.jsp";
				}
				//end
				//���ɳ���֪ͨ��	
 				PopPage(sUrl+"?DocID=7006&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType+"&SerialNo="+sSerialNo+"&Method=4&FirstSection=1&EndSection=0&rand="+randomNumber(),"myprint10","dialogWidth=10;dialogHeight=1;status:no;center:yes;help:no;minimize:yes;maximize:no;border:thin;statusbar:no");
 				//��¼���ɶ���
				RunJavaMethodSqlca("com.amarsoft.app.billions.InsertFormatDocLog", "recordFormatDocLog", "serialNo="+sSerialNo+",orgID=<%=CurUser.getOrgID()%>,userID=<%=CurUser.getUserID()%>,occurType=produce");
				
			}else{
				//��¼�鿴����
				RunJavaMethodSqlca("com.amarsoft.app.billions.InsertFormatDocLog", "recordFormatDocLog", "serialNo="+sReturn+",orgID=<%=CurUser.getOrgID()%>,userID=<%=CurUser.getUserID()%>,occurType=view");
				
			}
			
			//��ü��ܺ�ĳ�����ˮ��
			var sEncryptSerialNo = PopPageAjax("/PublicInfo/EncryptSerialNoAction.jsp?EncryptionType=MD5&SerialNo="+sObjectNo);
			//ͨ����serverlet ��ҳ��
			var CurOpenStyle = "width=720,height=540,top=20,left=20,toolbar=no,scrollbars=yes,resizable=yes,status=yes,menubar=no,";	
			//+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType  add by cdeng 2009-02-17	
			OpenPage("/FormatDoc/POPreviewFile.jsp?EncryptSerialNo="+sEncryptSerialNo+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType,"_blank02",CurOpenStyle); 
			
		}
	}
	
	function contractView() {
		var sSerialNo=getItemValueArray(0, "SERIALNO");
		var sCustomerID=getItemValueArray(0, "CUSTOMERID");
//		var sSerialNo = getItemValue(0,getRow(),"SERIALNO");
//		var sCustomerID = getItemValue(0,getRow(),"CUSTOMERID");
//		var sAccessType = getItemValue(0,getRow(),"AccessType");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
	         alert("������ѡ��һ����Ϣ�� ");//��ѡ��һ����Ϣ��
	         return;
	     }
		for(var i=0; i<sSerialNo.length;i++){
			var sValue=RunMethod("GetElement","GetElementValue","AccessType,business_contract,serialNo='"+sSerialNo[i]+"'");
			if(sValue=="01"){
				alert("��ѡ���еĺ�ͬ�Ѵ��ڱ����ģ�");
				return;
			}
		}
		
		sCompID = "AccessTypeInfo";
		sCompURL = "/AppConfig/Document/AccessTypeInfo.jsp";
	    var returnValue=popComp(sCompID,sCompURL,"serialNo="+sSerialNo+"&Type=Access&ssCustomerID="+sCustomerID+"&ssSerialNo="+sSerialNo,"dialogWidth=350px;dialogHeight=360px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
	    if(returnValue=="Success"){
	    	for(var i=0;i<sSerialNo.length;i++){
	    		 RunMethod("ModifyNumber","GetModifyNumber","business_contract,AccessType='01',serialNo='"+sSerialNo[i]+"'");
	    	}
	   	 alert("���ĳɹ���");
	    }
	    reloadSelf();
	}
	
	function tackbackContract() {
		var sSerialNo = getItemValue(0,getRow(),"SERIALNO");
		var sAccessType = getItemValue(0,getRow(),"AccessType");
		var sCustomerID = getItemValue(0,getRow(),"CUSTOMERID");
		 if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
	           alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
	           return;
	     }
		 if (typeof(sAccessType)=="undefined" || sAccessType.length==0 || sAccessType=="����(�ѹ黹)"){
	           alert("�ú�ͬû�б�����,����Ҫ�黹��");//��ѡ��һ����Ϣ��
	           return;
	     }
		sCompID = "AccessTypeInfo";
		sCompURL = "/AppConfig/Document/AccessTypeInfo.jsp";
		var returnValue=popComp(sCompID,sCompURL,"serialNo="+sSerialNo+"&Type=Return&customerID="+sCustomerID,"dialogWidth=350px;dialogHeight=360px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		 if(returnValue=="Success"){
			RunMethod("ModifyNumber","GetModifyNumber","business_contract,AccessType='02',serialNo='"+sSerialNo+"'");
			alert("�黹�ɹ���");
		 }
		reloadSelf();
	}
	
	function destroyContract() {
		var sSerialNo = getItemValue(0,getRow(),"SERIALNO");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
	           alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
	           return;
	    }
		if(confirm("�����Ҫ������")){
		    RunMethod("ModifyNumber","GetModifyNumber","business_contract,AccessType='03',serialNo='"+sSerialNo+"'");
			reloadSelf();
		}
	}
	
	$(document).ready(function(){
		AsOne.AsInit();
		init();
		my_load(2,0,'myiframe0');
	});
</script>	
<%@ include file="/IncludeEnd.jsp"%>
