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
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	//if (!doTemp.haveReceivedFilterCriteria()) doTemp.WhereClause =  " where 1=2"; 
	
	doTemp.WhereClause += " and landmarkstatus='4' and  (IsArchive is null or IsArchive='02')";
	doTemp.setVisible("AccessType,ArchiveAddress,RenturnDate,ReturnName,InputUserID", false);
	doTemp.setVisible("InputUserIDName,AccessDate,RenturnDate,ReturnName,ArchiveDate,NowReturnDate", false);
	doTemp.setVisible("AccessUserName,ReturnUserName", false);
	
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
			{"true","","Button","Ӱ��","Ӱ��","imageView()",sResourcesPath},
			{"true","","Button","�鵵","�鵵","archiveContract()",sResourcesPath},
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
		//add �ֽ���������
		sObjectType = "ApplySettle";
		var sDocID = "7006";
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
			//���ɳ���֪ͨ��	
			//var sSerialNo = getSerialNo("FORMATDOC_RECORD", "SerialNo", "AS");
			//PopPage("/FormatDoc/Report17/03.jsp?DocID="+sDocID+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType+"&SerialNo="+sSerialNo+"&Method=4&FirstSection=1&EndSection=0&rand="+randomNumber(),"myprint10","dialogWidth=10;dialogHeight=1;status:no;center:yes;help:no;minimize:yes;maximize:no;border:thin;statusbar:no");
			alert("���Ӻ�ͬ�����ڣ�");
			return;
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
	     var param = "ObjectType=Business&TypeNo=20&RightType=100&ObjectNo="+sObjectNo;
	     AsControl.PopView( "/ImageManage/ImageView.jsp", param, "" );
//	     var param = "ObjectType=Business&TypeNo=20&ObjectNo="+sObjectNo;
//	     AsControl.PopView( "/ImageManage/ImageViewNew.jsp", param, "" );
	}
	
	function archiveContract(){
		var sSerialNo = getItemValueArray(0,"SERIALNO");
		var sUserID = "<%=CurUser.getUserID()%>";
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert("������ѡ��һ����¼��");
			return;
		}
		if(confirm("�����ȷ���鵵��")){
			for(var i=0;i<sSerialNo.length;i++){
//				var sReturn= RunMethod("ArchiveContract","GetArchiveContract",sSerialNo[i]); 
				var sReturn = RunJavaMethodSqlca("com.amarsoft.app.lending.bizlets.ContractFile", "updateFile","SerialNo="+sSerialNo[i]);
				if(sReturn=="�鵵�ɹ���"){
					RunMethod("ModifyNumber","GetModifyNumber","business_contract,LandMarkStatus='7',serialNo='"+sSerialNo[i]+"'");//�޸ĵر�״̬ 
					//add CCS-212 ��¼�鵵��Ա���
					RunMethod("ModifyNumber","GetModifyNumber","business_contract,ArchiveUserID='"+sUserID+"',serialNo='"+sSerialNo[i]+"'");
					//end
				}
			}
	    	alert(sReturn);
		}
	  reloadSelf();
	}
	
	<%/*~[Describe=ʹ��ObjectViewer��;InputParam=��;OutPutParam=��;]~*/%>
	function openWithObjectViewer(){
		var sExampleId = getItemValue(0,getRow(),"ExampleId");
		if (typeof(sExampleId)=="undefined" || sExampleId.length==0){
			alert("��ѡ��һ����¼��");
			return;
		}
		
		AsControl.OpenObject("Example",sExampleId,"001");//ʹ��ObjectViewer����ͼ001��Example��
	}

	$(document).ready(function(){
		AsOne.AsInit();
		init();
		my_load(2,0,'myiframe0');
	});
</script>	
<%@ include file="/IncludeEnd.jsp"%>
