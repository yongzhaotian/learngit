<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%
	/* --ҳ��˵��: ʾ������ҳ��-- */
	String PG_TITLE = "ʾ������ҳ��";

	// ���ҳ�����
	String sSerialNO =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNO"));
	String sObjectNO =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectNO"));
	if(sSerialNO==null) sSerialNO="";
	if(sObjectNO==null) sObjectNO="";
	
	// ͨ��DWģ�Ͳ���ASDataObject����doTemp
	String sTempletNo = "DelegateCompanyCityInfo";//ģ�ͱ��
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      // ����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; // �����Ƿ�ֻ�� 1:ֻ�� 0:��д
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sSerialNO);//�������,���ŷָ�
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{"true","","Button","����","���������޸�","saveRecord()",sResourcesPath},
		{"false","","Button","���沢����","���沢�����б�","saveAndGoBack()",sResourcesPath},
		{"true","","Button","����","�����б�ҳ��","goBack()",sResourcesPath}
	};
%>
<%@include file="/Resources/CodeParts/Info05.jsp"%>
<script type="text/javascript">
	var bIsInsert = false; // ���DW�Ƿ��ڡ�����״̬��
	function saveRecord(sPostEvents){
		if(bIsInsert){
			beforeInsert();
		}
		var sExistNo = RunMethod("���÷���", "GetColValue", "DELEGATECOMPANY_RELATIVE,SerialNo,objectno='<%=sObjectNO%>' and cityno='"+getItemValue(0, 0, "CITYNO")+"' and rownum=1");
		//alert(sExistNo+"|"+typeof(sExistNo));
		if (sExistNo!="Null") {
			alert("�ó����Ѿ����ڣ�������ѡ��");
			return;
		}
		as_save("myiframe0",sPostEvents);
	}
	
	function saveAndGoBack(){
		saveRecord("goBack()");
	}
	
	function goBack(){
		AsControl.OpenView("/SystemManage/ConsumeLoanManage/DelegateCompanyCityList.jsp","ObjectNO=<%=sObjectNO%>","_self");
	}

	<%/*~[Describe=ִ�в������ǰִ�еĴ���;]~*/%>
	function beforeInsert(){
		var serialNo = getSerialNo("DELEGATECOMPANY_RELATIVE","SERIALNO");// ��ȡ��ˮ��
		setItemValue(0,getRow(),"SERIALNO",serialNo);
		bIsInsert = false;
	}
	
	
	function initRow(){
		if (getRowCount(0)==0){//�統ǰ�޼�¼��������һ��
			as_add("myiframe0");
			setItemValue(0,0,"OBJECTTYPE","DelegateCompany");
			setItemValue(0,0,"OBJECTNO","<%=sObjectNO%>");
			setItemValue(0,0,"INPUTUSER","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"INPUTUSERNAME","<%=CurUser.getUserName()%>");
			setItemValue(0,0,"INPUTORG","<%=CurOrg.getOrgID()%>");
			setItemValue(0,0,"INPUTORGNAME", "<%=CurOrg.orgName%>");
			setItemValue(0,0,"INPUTDATE","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd")%>");
			bIsInsert = true;
		}
    }
	
	$(document).ready(function(){
		AsOne.AsInit();
		init();
		bFreeFormMultiCol = false;
		my_load(2,0,'myiframe0');
		initRow();
	});
	
	/*~[Describe=���������滮ѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/
	function getCellRegionCode()
	{
		var sAreaCode = getItemValue(0,getRow(),"CITYNO");
		//sAreaCodeInfo = PopComp("AreaVFrame","/Common/ToolsA/AreaVFrame.jsp","AreaCode="+sAreaCode,"dialogWidth=650px;dialogHeight=450px;center:yes;status:no;statusbar:no","");
		var sAreaCodeInfo = setObjectValue("SelectCityCodeSingle","","",0,0,"");
		//������չ��ܵ��ж�
		if(sAreaCodeInfo == "NO" || sAreaCodeInfo == '_CLEAR_'){
			setItemValue(0,getRow(),"CITYNO","");
			setItemValue(0,getRow(),"CITYNONAME","");
		}else{
			 if(typeof(sAreaCodeInfo) != "undefined" && sAreaCodeInfo != ""){
					sAreaCodeInfo = sAreaCodeInfo.split('@');
					sAreaCodeValue = sAreaCodeInfo[0];//-- ������������
					sAreaCodeName = sAreaCodeInfo[1];//--������������
					setItemValue(0,getRow(),"CITYNO",sAreaCodeValue);
					setItemValue(0,getRow(),"CITYNONAME",sAreaCodeName);				
			}
		}
	}
</script>
<%@ include file="/IncludeEnd.jsp"%>
