<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%
	/* ҳ��˵��: ʾ������ҳ�� */
	String PG_TITLE = "ʾ������ҳ��";

	// ���ҳ�����
	String sSerialNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
	if(sSerialNo==null) sSerialNo="";
	
	// ͨ��DWģ�Ͳ���ASDataObject����doTemp
	String sTempletNo = "ErrorTypeCodeInfo";//ģ�ͱ��
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      // ����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; // �����Ƿ�ֻ�� 1:ֻ�� 0:��д
	System.out.println("SerialNo==============================" + sSerialNo);
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sSerialNo);//�������,���ŷָ�
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{"false","","Button","����","���������޸�","saveRecord()",sResourcesPath},
		{"true","","Button","���沢����","���沢�����б�","saveAndGoBack()",sResourcesPath},
		{"true","","Button","����","�����б�ҳ��","goBack()",sResourcesPath}
	};
%>
<%@include file="/Resources/CodeParts/Info05.jsp"%>
<script type="text/javascript">
	var bIsInsert = false; // ���DW�Ƿ��ڡ�����״̬��
	
	// ����������Ƿ��Ѿ�����
	function checkErrorCode() {
		var sCode = getItemValue(0, 0, "ErrorCode");
		var sErrorSerialNo = RunMethod("���÷���", "GetColValue", "ErrorTypecode_Info,SerialNo,ErrorCode='"+sCode+"'");
		//alert(sErrorSerialNo+"|"+typeof(sErrorSerialNo));
		if (sErrorSerialNo!="Null") {
			alert("�ô�������Ѿ����ڣ����������룡");
			setItemValue(0, 0, "ErrorCode", "");
			return;
		}
	}
	
	function saveRecord(sPostEvents){
		if(bIsInsert){
			beforeInsert();
		}
		beforeUpdate();
		as_save("myiframe0",sPostEvents);
	}
	
	function saveAndGoBack(){
		saveRecord("goBack()");
	}
	
	function goBack(){
		AsControl.OpenView("/SystemManage/CustomerFinanceManage/ErrorTypeCodeList.jsp","","_self");
	}

	<%/*~[Describe=ִ�в������ǰִ�еĴ���;]~*/%>
	function beforeInsert(){
		
		setItemValue(0, 0, "InputOrg", "<%=CurOrg.orgID %>");
		setItemValue(0,0,"InputUser","<%=CurUser.getUserID()%>");
		setItemValue(0,0,"InputDate","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd HH:mm:ss")%>");
		bIsInsert = false;
	}
	
	<%/*~[Describe=ִ�и��²���ǰִ�еĴ���;]~*/%>
	function beforeUpdate(){
		setItemValue(0, 0, "UpdateOrg", "<%=CurOrg.orgID %>");
		setItemValue(0,0,"UpdateUser","<%=CurUser.getUserID()%>");
		setItemValue(0,0,"UpdateDate","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd HH:mm:ss")%>");
	}
	//ͨ��ѡ�������ȼ����ж�Ӧ���ж�
	function changeValue(){
		var a =getItemValue(0,getRow(),"qualitygradecodeno");//�����ȼ�
		if(a==1||a==2){//alert("Ϊ�ؼ���ǹؼ�ʱ������3����������");
			setItemReadOnly(0,getRow(),"ErrorCode",false);//���ò�����
			setItemReadOnly(0,getRow(),"ErrorType",false);//���ò�����
			setItemReadOnly(0,getRow(),"ErrorContent",false);//���ò�����
			
			setItemValue(0, getRow(), "ErrorCode", "");//�����ѡ��
			setItemValue(0, getRow(), "ErrorType", "");//�����ѡ��
			setItemValue(0, getRow(), "ErrorContent", "");//�����ѡ��

			setItemRequired(0,getRow(),"ErrorCode",1);//���ñ�����
			setItemRequired(0,getRow(),"ErrorType",1);//���ñ�����
			setItemRequired(0,getRow(),"ErrorContent",1);//���ñ�����
		}else if(a==3){//alert("Ϊ�ϸ�ʱ������3�������򲻿��");
			setItemValue(0, getRow(), "ErrorCode", "");//�����ѡ��
			setItemValue(0, getRow(), "ErrorType", "");//�����ѡ��
			setItemValue(0, getRow(), "ErrorContent", "");//�����ѡ��
			
			setItemReadOnly(0,getRow(),"ErrorCode",true);//���ò�����
			setItemReadOnly(0,getRow(),"ErrorType",true);//���ò�����
			setItemReadOnly(0,getRow(),"ErrorContent",true);//���ò�����
			
			setItemRequired(0,getRow(),"ErrorCode",0);//���÷Ǳ�����
			setItemRequired(0,getRow(),"ErrorType",0);//���÷Ǳ�����
			setItemRequired(0,getRow(),"ErrorContent",0);//���ñ�����

		}else if (a==4 || a==5||a==6){//alert("Ϊ�ذ�ʱ������3�����������ɲ��");
			setItemValue(0, getRow(), "ErrorCode", "");//�����ѡ��
			setItemValue(0, getRow(), "ErrorType", "");//�����ѡ��
			setItemValue(0, getRow(), "ErrorContent", "");//�����ѡ��

			setItemReadOnly(0,getRow(),"ErrorCode",false);//���ÿ���
			setItemReadOnly(0,getRow(),"ErrorType",false);//���ÿ���
			setItemReadOnly(0,getRow(),"ErrorContent",false);//���ÿ���
			
			setItemRequired(0,getRow(),"ErrorCode",0);//����Ϊ�Ǳ�����
			setItemRequired(0,getRow(),"ErrorType",0);//����Ϊ�Ǳ�����
			setItemRequired(0,getRow(),"ErrorContent",0);//���ñ�����

		}else{
			setItemReadOnly(0,getRow(),"ErrorCode",true);

		}
	}
	function initRow(){
		if (getRowCount(0)==0){//�統ǰ�޼�¼��������һ��
			as_add("myiframe0");
			var sSerialNo = getSerialNo("ErrorTypeCode_Info","SerialNo");// ��ȡ��ˮ��`
			setItemValue(0,getRow(),"SerialNo",sSerialNo);
			setItemValue(0, 0, "InputOrg", "<%=CurOrg.orgID %>");
			setItemValue(0, 0, "InputOrgName", "<%=CurOrg.orgName %>");
			setItemValue(0,0,"InputUser","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"InputDate","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd HH:mm:ss")%>");

			setItemValue(0, 0, "UpdateOrg", "<%=CurOrg.orgID %>");
			setItemValue(0, 0, "UpdateOrgName", "<%=CurOrg.orgName %>");
			setItemValue(0,0,"UpdateUser","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"UpdateDate","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd HH:mm:ss")%>");
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
