<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%
	/* ҳ��˵��: ʾ������ҳ�� */
	String PG_TITLE = "����������ҳ��";

	// ���ҳ�����
	String sLoanNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("LoanNo"));
	if(sLoanNo==null) sLoanNo="";
	
	// ͨ��DWģ�Ͳ���ASDataObject����doTemp
	String sTempletNo = "LoanManInfo";//ģ�ͱ��
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
	//CCS-344 �����˲������޷�������г���   ���������óɲ����棬����ᳬ���ֶη�Χ      edit by awang  2015/03/12
 	doTemp.setUpdateable("city", false);
	doTemp.setUpdateable("cityName", false); 
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      // ����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; // �����Ƿ�ֻ�� 1:ֻ�� 0:��д
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sLoanNo);//�������,���ŷָ�
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{"true","","Button","����","���������޸�","saveRecord()",sResourcesPath},
		{"false","","Button","���沢����","���沢�����б�","saveAndGoBack()",sResourcesPath},
		{"true","","Button","����","�����б�ҳ��","goBack()",sResourcesPath}
	};
	
	// add  wlq    20140408  begin--
	if(!sLoanNo.equals("")){
		sButtons[2][0]="false";
	}
	// add  wlq    20140408  end--
%>
<%@include file="/Resources/CodeParts/Info05.jsp"%>
<script type="text/javascript">
	var bIsInsert = false; // ���DW�Ƿ��ڡ�����״̬��
	
	/*~[Describe=ѡ��鼯���ʺ�;InputParam=��;OutPutParam=��;]~*/
	function selectBankAccount() {
		alert("selec bank account info!");
	}
	
	/*~[Describe=�ж������ձ�����ڿ�ʼ����;InputParam=��;OutPutParam=��;]~*/
	function dateCompare() {
		
		var sStartTime = getItemValue(0, 0, "startDate");
		var sEndTime = getItemValue(0, 0, "endDate");
		
		if (sEndTime.localeCompare(sStartTime)<=0) {
			alert("������Ч�ڵ����ձ��������ʼ���ڣ�");
			return 1;
		}
		return 0;
	}
	
	/*~[Describe=���������滮ѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/
/* 	function getRegionCode()
	{
		
		var sSerialNo = getItemValue(0,getRow(),"serialNo");
		//CCS-344 �����˲������޷�������г���     edit by awang 2015/03/11
	   /*  var sProductType=getItemValue(0,getRow(),"ProductType"); 
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		} */
		/* var sLoaner = getItemValue(0,getRow(),"Loaner"); 
 		if (typeof(sLoaner)=="undefined" || sLoaner.length==0){
 			alert("����ѡ��ô����˵Ĵ��������ͣ�Ȼ����ѡ�����");
 			return;
 		}
 		var result = setObjectValue("selectSubProductType","","",0,0,""); //��ȡҪ�����Ĳ�Ʒ����
 		if(typeof(result)=="undefined" || result.length==0 || result=="_CLEAR_"){
 			return;
 		}
 		result = result.replace("@","");
 		
	    var sCityName = PopPage("/BusinessManage/CollectionManage/AddLoanManCity.jsp?SerialNo="+sSerialNo+"&ProductType="+result+"&sLoaner="+sLoaner,"","400px;dialogHeight=540px;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;");
	    if(typeof(sCityName)=="undefined" || sCityName.length==0 || sCityName=="_none_"){
	    	return;
	    }
	    var sSubProductType = "Temp"+result;
	    var sReturn = PopPageAjax("/BusinessManage/CollectionManage/LoanManInfoAjax.jsp?SerialNo="+sSerialNo+"&ProductType="+sSubProductType,"","");
		if (typeof(sReturn)=="undefined" || sReturn.length==0){
			return;
		}
		var SubProductType = RunJavaMethodSqlca("com.amarsoft.app.billions.RetailStoreCommon", "selectLoanProductType", "serialNo="+sSerialNo);

		if(SubProductType==null || SubProductType=="" || typeof(SubProductType)=="undefined" || SubProductType.length==0) SubProductType = result;
		
		setItemValue(0,0,"ProductType",SubProductType); 
		setItemValue(0,0,"cityName",sReturn);  */
		
		//PopPage("/BusinessManage/CollectionManage/AddLoanManCity.jsp?SerialNo="+sSerialNo,"","400px;dialogHeight=540px;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;"); 
		
		//alert(sReturn);
		
		/* var sReturn=RunMethod("LoanManCitySetting","selectCity",sSerialNo);
	    sVal=sReturn.substring(1,sReturn.length-1);
	    var sValue=sVal.split(",");
	    var sCityNos="";
	    var sCityNames="";
	    var CityName="";
	    for(var i=0;i<sValue.length;i++){
	    		  CityName=RunMethod("LoanManCitySetting","getCityName",sValue[i]);
	    		  sCityNames+=CityName+",";
	    	      sCityNos+=sValue[i]+",";
	    }
	    sCityNos = sCityNos.substring(0,sCityNos.length-1);
	    sCityNames = sCityNames.substring(0,sCityNames.length-1);
	    setItemValue(0,0,"city",sCityNos);
	    setItemValue(0, 0, "cityName", sCityNames);    */  //�޸�Ϊ awang 2014-12-2
	    
		//var retVal = setObjectValue("SelectCityCodeMulti","","",0,0,"");
		//alert(retVal+"|"+typeof(retVal));
		/* if (typeof(retVal)=="undefined" || retVal=='_CLEAR_') {
			alert("��ѡ����Ҫѡ��ĳ��У�");
			return;
		}
		var cityItems = retVal.split("~");
		var sCityNos = "";
		var sCityNames = "";
		for (var i in cityItems) {
			sCityNos += cityItems[i].split("@")[0]+",";
			sCityNames += cityItems[i].split("@")[1]+",";
		}
		sCityNos = sCityNos.substring(0,sCityNos.length-1);
		sCityNames = sCityNames.substring(0,sCityNames.length-1);
		//setItemValue(0, 0, "NearCity", sCityNos);
		//setItemValue(0, 0, "NearCityName", sCityNames);
		setItemValue(0, 0, "city", sCityNos);    //�޸�Ϊ  wlq 
		setItemValue(0, 0, "cityName", sCityNames); */
		
	/* } */
	// add   wlq  ���ӷ���   20140408   begin--
	/*  function getRegionCode1()
		{
			var retVal = setObjectValue("SelectCityCodeMulti","","",0,0,"");
			if (typeof(retVal)=="undefined" || retVal=='_CLEAR_') {
				alert("��ѡ����Ҫѡ��ĳ��У�");
				return;
			}
			var cityItems = retVal.split("~");
			var sCityNos = "";
			var sCityName = "";
			for (var i in cityItems) {
				sCityNos += cityItems[i].split("@")[0]+",";
				sCityName+=cityItems[i].split("@")[1]+",";
			}
			sCityNos = sCityNos.substring(0,sCityNos.length-1);
			sCityName = sCityName.substring(0,sCityName.length-1);
			setItemValue(0, 0, "province", sCityNos);
			setItemValue(0, 0, "provinceName", sCityName);
		} */
	// add   wlq  ���ӷ���   20140408   end-- */
	
	function saveRecord(sPostEvents){
		
		//  ��������ֶκϷ���
		var sret = dateCompare();
		if (sret != 0) return;
		//CCS-344 �����˲������޷�������г���     edit by awang 2015/03/11
	    var sSerialNo = getItemValue(0,getRow(),"serialNo");
		/* var sProductType=getItemValue(0,getRow(),"ProductType"); */
		var sLoaner = getItemValue(0,getRow(),"Loaner"); 
 		if (typeof(sLoaner)=="undefined" || sLoaner.length==0){
 			alert("����ѡ��ô����˵Ĵ��������ͣ�Ȼ����ѡ�����");
 			return;
 		}
		/* var sReturn=RunMethod("LoanManCitySetting","selectMulti",sSerialNo+","+sProductType);
		//��������ظ��ĳ���
		if(sReturn!="Null"){
		sVal=sReturn.substring(1,sReturn.length-1);
	    var sValue=sVal.split(",");
	    var CityName="";
	    var sCityNames="";
	    for(var i=0;i<sValue.length;i++){
  		  CityName=RunMethod("LoanManCitySetting","getCityName",sValue[i]);
  		  sCityNames+=CityName+",";
       }
	   alert(sCityNames+"�����Ѵ��������������˹����ĳ�����");
	    RunMethod("LoanManCitySetting","delMulti",sSerialNo+","+sProductType);
		}  */
		// ͬһ���У���ʱ����Ƿ��Ѿ����ڴ�����
		/* var sCityNos = getItemValue(0, 0, "city");
		var sCityNames = getItemValue(0, 0, "cityName");
		var sRepCityNos = sCityNos.replace(/,/g,"@");
		var sRepCityNames = sCityNames.replace(/,/g,"@");
		
		//alert(sRepCityNos.length+"|"+sRepCityNos+"xx");
		if (sRepCityNos.length!=0) { 
			//var sCmpVal = RunMethod("���÷���", "GetColValue", "Service_Providers,SerialNo,customerType1='06'  and CreditAttribute='0002' and city='"+sCtiy+"' and ((startdate>='"+sStartTime+"' and startdate<='"+sEndTime+"') or (enddate>='"+sStartTime+"' and enddate<='"+sEndTime+"'))");
			var sRetVal = RunJavaMethodSqlca("com.amarsoft.app.billions.RetailStoreCommon", "loanAccountCity", "serialNo="+getItemValue(0, 0, "serialNo")+",startDate="+getItemValue(0, 0, "startDate")+",endDate="+getItemValue(0, 0, "endDate")+",citys="+sRepCityNos+",citynames="+sRepCityNames+",ProductType="+getItemValue(0,0,"ProductType"));//update CCS-159-�ֽ���ж��������
	      // var sRetVal=RunJavaMethodSqlca("com.amarsoft.app.billions.RetailStoreCommon","loanProviderCity","serialNo="+getItemValue(0, 0, "serialNo")+",citys="+sRepCityNos+",citynames="+sRepCityNames+",ProductType="+getItemValue(0,0,"ProductType"));
			var exitsVal = sRetVal.split("~")[0];
			//wlq
			var dispNameID="";
			var exitsValCityNamesID= exitsVal.split("@")[0].split("#");
			for ( var j in exitsValCityNamesID) {
				RunMethod("DeleteNumber","GetDeleteNumber1","ProvidersCity,serialno='"+getItemValue(0, 0, "serialNo")+"' and AREACODE='"+exitsValCityNamesID[j]+"'");
			}
		    
			//var exitsValCityNos = exitsVal.split("@")[0].replace(/#/g,",");
			if (exitsVal.split("@")[1].length >0 ) {
				var exitsValCityNames =  exitsVal.split("@")[1].split("#");
				//alert(exitsValCityNos);
				//alert(exitsValCityNames);
				var dispName = "";
				
				//alert("|"+exitsValCityNames+"|"+exitsValCityNames.length+"aa");
				for (var i in exitsValCityNames) {
					//alert(i + "|" + exitsValCityNames[i]);
					dispName += exitsValCityNames[i];
					if (i!=0 && i%4 == 0) dispName += "\n";
					else dispName += ",";
				}
				//alert(dispName+"|"+dispName.length);
				if (dispName != "") alert(dispName.substring(0, dispName.length-1) + "\n����ѡʱ����������������Ѿ����ڴ�����!");
				var noExitsVal = sRetVal.split("~")[1];
				var noExitsValCityNos = noExitsVal.split("@")[0].replace(/#/g,",");
				var noExitsValCityNames = noExitsVal.split("@")[1].replace(/#/g,",");
				
				setItemValue(0, 0, "city", noExitsValCityNos);   
				setItemValue(0, 0, "cityName", noExitsValCityNames);
			}
		} */
		//alert(noExitsValCityNos);
		//alert(noExitsValCityNames);
		/* if (sCmpVal != "Null") {
			alert("�ó��и�ʱ����Ѿ����ڴ����ˣ�������ѡ��ʱ����ʼ������!");
			return;
		} */
		//return;
		if(bIsInsert){
			beforeInsert();
		}
		beforeUpdate();
		var sCount=RunMethod("LoanAccount","selectLoanCount",sSerialNo);
		if (sCount ==0){
			as_save("myiframe0",sPostEvents);
			self.returnValue=sSerialNo;
			self.close();
		}else{
		as_save("myiframe0",sPostEvents);
		reloadSelf();
		}
	}
	//�������������Ƿ�ı�
	function getLanCode(){
		var sSerialNo = getItemValue(0,getRow(),"serialNo");
		
		var sReturn = RunMethod("���÷���", "GetColValue", "ProvidersCity,count(1),serialno="+sSerialNo);
		var sLoaner = RunMethod("���÷���", "GetColValue", "service_providers,loaner,serialno="+sSerialNo);
		if(sReturn!="0.0"){
			alert("������ոô����˹��������г��У�Ȼ�����޸Ĵ��������ͣ�");
			setItemValue(0,getRow(),"Loaner",sLoaner);
			return;
		}
		
	}
	//CCS-344 �����˲������޷�������г���     edit by awang 2015/03/11
	/*���´�������Ϣ*/
	 /* function updateProviderScity(){
		var sProductType = getItemValue(0,0,"ProductType");
		sProductType = sProductType.replace(new RegExp(',','g'),'@');
	    RunJavaMethodSqlca("com.amarsoft.app.billions.RetailStoreCommon","updateProviderScity","serialNo="+getItemValue(0, 0, "serialNo")+",ProductType="+sProductType);
		
	}	  */
		
	function saveAndGoBack(){
		saveRecord("goBack()");
	}
	
	function goBack(){
		
		//self.close();
		AsControl.OpenView("/BusinessManage/CollectionManage/LoanManList.jsp","temp=1","_self");
	}

	<%/*~[Describe=ִ�в������ǰִ�еĴ���;]~*/%>
	function beforeInsert(){
		
		setItemValue(0, 0, "inputOrgID", "<%=CurOrg.orgID %>");
		setItemValue(0,0,"inputOrgName","<%=CurUser.getUserID()%>");
		setItemValue(0,0,"INPUTDATE","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd")%>");
		bIsInsert = false;
	}
	
	<%/*~[Describe=ִ�и��²���ǰִ�еĴ���;]~*/%>
	function beforeUpdate(){
		setItemValue(0, 0, "UPDATEORG", "<%=CurOrg.orgID %>");
		setItemValue(0,0,"UPDATEUSER","<%=CurUser.getUserID()%>");
		setItemValue(0,0,"UPDATEDATE","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd")%>");
	}
	
	function initRow(){
		if (getRowCount(0)==0){//�統ǰ�޼�¼��������һ��
			as_add("myiframe0");			
			var sSerialNo = getSerialNo("Service_Providers","serialNo");// �޸�Ϊ wlq begin
			setItemValue(0,getRow(),"serialNo",sSerialNo);
			setItemValue(0,getRow(),"CreditAttribute","0002");
			setItemValue(0,getRow(),"customerType1","06");
			setItemValue(0, 0, "inputOrgID", "<%=CurOrg.orgID %>");
			setItemValue(0, 0, "inputOrgName", "<%=CurOrg.orgName %>");
			setItemValue(0,0,"inputUserID","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"inputDate","<%=StringFunction.getToday()%>");

			setItemValue(0, 0, "updateOrgID", "<%=CurOrg.orgID %>");
			setItemValue(0, 0, "updateOrgName", "<%=CurOrg.orgName %>");
			setItemValue(0,0,"updateUserID","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"updateDate","<%=StringFunction.getToday()%>"); // �޸�Ϊ wlq  end
			bIsInsert = true;
		}
		setItemValue(0, 0, "endDate","9999/12/31");
    }
	
	$(document).ready(function(){
		AsOne.AsInit();
		init();
		bFreeFormMultiCol = true;
		my_load(2,0,'myiframe0');
		initRow();
		//CCS-344 �����˲������޷�������г���     edit by awang 2015/03/11
		var sSerialNo=getItemValue(0,0,"serialNo");
		var sProductType=getItemValue(0,0,"ProductType");
		//var sReturn = PopPageAjax("/BusinessManage/CollectionManage/LoanManInfoAjax.jsp?SerialNo="+sSerialNo+"&ProductType="+sProductType,"","");
		//alert(sReturn);
		var sReturn = RunJavaMethodSqlca("com.amarsoft.app.billions.RetailStoreCommon", "selectLoanCity", "serialNo="+sSerialNo);

		setItemValue(0,0,"cityName",sReturn); 
	});
	
</script>
<%@ include file="/IncludeEnd.jsp"%>
