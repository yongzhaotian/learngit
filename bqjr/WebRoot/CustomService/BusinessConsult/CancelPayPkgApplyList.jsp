<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		ҳ��˵��: ʾ���б�ҳ��
	 */
	String PG_TITLE = "ʾ���б�ҳ��";
	
	//ͨ��DWģ�Ͳ���ASDataObject����doTemp
	String sTempletNo = "CancelPayPkgApplyQueryList";//ģ�ͱ��
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);

	//���ɲ�ѯ��
	doTemp.setFilter(Sqlca, "0010", "SerialNo", "Operators=EqualsString;");
	doTemp.setFilter(Sqlca, "0020", "CustomerID", "Operators=EqualsString;");
	doTemp.setFilter(Sqlca, "0030", "CustomerName", "Operators=EqualsString,BeginsWith;");
	doTemp.setFilter(Sqlca, "0040", "CertID", "Operators=EqualsString;");
	//doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	
	if(!doTemp.haveReceivedFilterCriteria()) doTemp.WhereClause = " where 1=2";
	
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.setPageSize(10);

	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{"true","","Button","����ȡ��","����ȡ��","cancelApply()",sResourcesPath},
		{"true","","Button","��ϸ��Ϣ","��ϸ��Ϣ","viewAndEdit()",sResourcesPath},
	};
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">

	/*~[Describe=ȡ������;InputParam=��;OutPutParam=��;]~*/
	function cancelApply(){
		//�ֶ�ȡ�������1020��FT����ֶ�
		//��ú�ͬ��ˮ�š��������͡����̱�š��׶α��
		var sObjectNo = getItemValue(0, getRow(), "SerialNo");//��ͬ��ˮ��
		var sCUSTOMERID = getItemValue(0, getRow(), "CUSTOMERID");
		var sCustomerName = getItemValue(0, getRow(), "CustomerName");
		var sBUGPAYPKGIND = getItemValue(0, getRow(), "BUGPAYPKGIND");
		
		var sStartDate = '';
		var sEndDate = '';
		var sCREATEOR = "<%=CurUser.getUserID()%>";
		var sUPDATEOR = "<%=CurUser.getUserID()%>";
		<%-- var sCREATETIME = "<%=StringFunction.getTodayNow()%>";
		var sUPDATETIME = "<%=StringFunction.getTodayNow()%>";
		var sCANCELSYSDATE = "<%=StringFunction.getTodayNow()%>"; --%>
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
		{
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
		}
		
		if(sBUGPAYPKGIND!="��"){
			var sTemp="û�й������Ļ����������ȡ����";
			alert(sTemp);
			return;
		}
		
		var sReturn = RunJavaMethodSqlca("com.amarsoft.app.lending.bizlets.CheckContractInfo", "checkContractStatus","contractNO="+sObjectNo);
		if("TRUE" != sReturn.split("@")[0]){
			alert(sReturn.split("@")[1]);
			return;
		}
		
		if (confirm("��ȷ��Ҫȡ���ñ����Ļ��������")) {
			var sPkgStatus =getItemValue(0,getRow(),"PkgStatus");
			if(sPkgStatus!="������"){
				var sTemp="ֻ�������е����Ļ����������ȡ����";
				alert(sTemp);
				return;
			}
			
			sReturn = RunJavaMethodSqlca("com.amarsoft.app.lending.bizlets.CancelPayPkgApply","cancelApply","serialNo="+sObjectNo+",CUSTOMERID="+sCUSTOMERID+",CustomerName="+sCustomerName+",StartDate="+sStartDate+",EndDate="+sEndDate+",CREATEOR="+sCREATEOR+",UPDATEOR="+sUPDATEOR);
			sPhaseInfo = sReturn.split("@")[0];
			if(typeof(sPhaseInfo)=="undefined" || sPhaseInfo=="" || sPhaseInfo==null || sPhaseInfo=="null" || sPhaseInfo=="_CANCEL_") return;
			else if (sPhaseInfo == "Success"){
				alert("ȡ�����Ļ�������ɹ���");
			}else if (sPhaseInfo == "Failure"){
				alert(sReturn.split("@")[1]);//�ύʧ�ܣ�
				return;
			}
			reloadSelf();
		}
	}

	/*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=SerialNo;]~*/
	function viewAndEdit()
	{
		//���ҵ����ˮ��
		sSerialNo =getItemValue(0,getRow(),"SerialNo");	
		
	    sObjectType = "BusinessContract";
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
		}else
		{
			sCompID = "CreditTab";
    		sCompURL = "/CreditManage/CreditApply/ObjectTab.jsp";
    		sParamString = "ObjectType="+sObjectType+"&ObjectNo="+sSerialNo;
    		OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
		}

	}
	
	$(document).ready(function(){
		AsOne.AsInit();
		init();
		my_load(2,0,'myiframe0');
	});
</script>	
<%@ include file="/IncludeEnd.jsp"%>