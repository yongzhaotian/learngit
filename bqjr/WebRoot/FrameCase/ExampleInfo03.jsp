<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		ҳ��˵��: DW����У��ʾ��ҳ��
	 */
	String PG_TITLE = "DW����У��ʾ��ҳ��";

	//���ҳ�����	
	String sExampleId =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ExampleId"));
	if(sExampleId==null) sExampleId="";
	
	//ͨ��DWģ�Ͳ���ASDataObject����doTemp
	String sTempletNo = "ExampleInfo";
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sExampleId);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	
	String sButtons[][] = {
		{"false","","Button","���沢����","���������޸�,�������б�ҳ��","saveAndGoBack()",sResourcesPath},
		{"true","","Button","����","���������޸�","saveRecord()",sResourcesPath},
		{"false","","Button","����","�����б�ҳ��","goBack()",sResourcesPath}
	};
%><%@include file="/Resources/CodeParts/Info05.jsp"%>
<script type="text/javascript">
	var bIsInsert = false; //���DW�Ƿ��ڡ�����״̬��

	function saveRecord(sPostEvents){
		if(bIsInsert){
			beforeInsert();
		}
		if (!ValidityCheck()) return;//ִ��һЩ��Ҫ��ǰ��У��
		beforeUpdate();
		as_save("myiframe0",sPostEvents);
	}
	
	function saveAndGoBack(){
		saveRecord("goBack()");
	}
	
	function goBack(){
		AsControl.OpenView("/FrameCase/ExampleList.jsp","","_self","");
	}

	<%//������ǰ��У�麯���μ�checkdatavalidity.js %>
	function ValidityCheck(){
		var passFlag = true;
		//У������ʼ���ַ
		var sEmailAdd = getItemValue(0,getRow(),"Attribute2");//�����ʼ���ַ	
		if(typeof(sEmailAdd) != "undefined" && sEmailAdd != "" ){
			if(!CheckEMail(sEmailAdd)){
				showTips("Attribute2",getBusinessMessage('130'));//��˾E��Mail����!
				passFlag = false;
			}
		}else{
			showTips("Attribute2","Email����Ϊ��");//��ʾУ�������Ϣ showTips(col,msg);�벻Ҫʹ��alert
			passFlag = false;
		}
		return passFlag;
	}

	<%/*~[Describe=ִ�в������ǰִ�еĴ���;]~*/%>
	function beforeInsert(){
		setItemValue(0,getRow(),"ExampleId",getSerialNo("EXAMPLE_INFO","ExampleId"));//��ʼ����ˮ���ֶ�
		setItemValue(0,0,"InputUser","<%=CurUser.getUserID()%>");
		setItemValue(0,0,"InputUserName","<%=CurUser.getUserName()%>");
		setItemValue(0,0,"InputOrg","<%=CurUser.getOrgID()%>");
		setItemValue(0,0,"InputTime","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd hh:mm:ss")%>");
		bIsInsert = false;
	}
	
	<%/*~[Describe=ִ�и��²���ǰִ�еĴ���;]~*/%>
	function beforeUpdate(){
		setItemValue(0,0,"UpdateUser","<%=CurUser.getUserID()%>");
		setItemValue(0,0,"UpdateUserName","<%=CurUser.getUserName()%>");
		setItemValue(0,0,"UpdateTime","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd hh:mm:ss")%>");
	}
	
	function initRow(){
		if(getRowCount(0)==0){
			as_add("myiframe0");
			bIsInsert = true;
		}
    }
	
	$(document).ready(function(){
		AsOne.AsInit();
		init();
		bFreeFormMultiCol = true;
		my_load(2,0,'myiframe0');
		initRow();
	});
</script>	
<%@ include file="/IncludeEnd.jsp"%>