<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main00;Describe=ע����;]~*/%>
<%
	/*
		Author:   phe  2015/03/17
		Tester:
		Content: ҵ�������Ϣ   CCS-213 PRM-26 ������ע �����ļ�����
	 */
	%>
<%/*~END~*/%>
<%
	/* --ҳ��˵��: ʾ������ҳ��-- */
	String PG_TITLE = "�ļ�����ά��";

	// ���ҳ�����
	String sCodeNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("CodeNo"));
	if(sCodeNo==null) sCodeNo="";
	String sItemNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ItemNo"));
	if(sItemNo==null) sItemNo="";
	
	// ͨ��DWģ�Ͳ���ASDataObject����doTemp
	String sTempletNo = "QualityFileInfo";//ģ�ͱ��
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      // ����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; // �����Ƿ�ֻ�� 1:ֻ�� 0:��д
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sCodeNo+","+sItemNo);//�������,���ŷָ�
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
		AsControl.OpenView("/SystemManage/CustomerFinanceManage/QualityFileCodeList.jsp","","_self");
	}

	<%/*~[Describe=ִ�в������ǰִ�еĴ���;]~*/%>
	function beforeInsert(){
		bIsInsert = false;
	}
	
	<%/*~[Describe=ִ�и��²���ǰִ�еĴ���;]~*/%>
	function beforeUpdate(){
		setItemValue(0,0,"UpdateUser","<%=CurUser.getUserID()%>");
		setItemValue(0,0,"UpdateTime","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd HH:mm:ss")%>");
	}
	//ͨ��ѡ�������ȼ����ж�Ӧ���ж�
	function changeValue(){
		var a =getItemValue(0,getRow(),"Attribute7");//�����ȼ�
		if(a==1||a==2){//alert("Ϊ�ؼ���ǹؼ�ʱ������3����������");
			setItemValue(0, getRow(), "ITEMNAME", "");//�����ѡ��
			setItemValue(0, getRow(), "Attribute8", "");//�����ѡ��
			setItemValue(0, getRow(), "Attribute5", "");//�����ѡ��

			setItemReadOnly(0,getRow(),"ITEMNAME",false);//���ÿ���

			setItemRequired(0,getRow(),"ITEMNAME",1);//���ñ�����
			setItemRequired(0,getRow(),"Attribute5",1);//���ñ�����
		}else if(a==3){//alert("Ϊ�ϸ�ʱ������3�������򲻿��");
			setItemValue(0, getRow(), "ITEMNAME", "");//�����ѡ��
			setItemValue(0, getRow(), "Attribute8", "");//�����ѡ��
			setItemValue(0, getRow(), "Attribute5", "");//�����ѡ��
			
			setItemReadOnly(0,getRow(),"ITEMNAME",true);//���ò�����

			setItemRequired(0,getRow(),"ITEMNAME",0);//���÷Ǳ�����
			setItemRequired(0,getRow(),"Attribute5",0);//���÷Ǳ�����
		}else if (a==4 || a==5||a==6){//alert("Ϊ�ذ�ʱ������3�����������ɲ��");
			setItemValue(0, getRow(), "ITEMNAME", "");//�����ѡ��
			setItemValue(0, getRow(), "Attribute8", "");//�����ѡ��
			setItemValue(0, getRow(), "Attribute5", "");//�����ѡ��

			setItemReadOnly(0,getRow(),"ITEMNAME",false);//���ÿ���

			setItemRequired(0,getRow(),"ITEMNAME",0);//����Ϊ�Ǳ�����
			setItemRequired(0,getRow(),"Attribute5",0);//����Ϊ�Ǳ�����
		}else{
			setItemReadOnly(0,getRow(),"Attribute8",true);
		}
	}
	
	function initRow(){
		if (getRowCount(0)==0){//�統ǰ�޼�¼��������һ��
			as_add("myiframe0");
			setItemValue(0, 0, "CODENO", "QualityFile");
			var sItemNo=RunMethod("SystemManage","SelectMaxNo","QualityFile");
			sItemNo=parseInt(sItemNo)+10;
			setItemValue(0, 0, "ITEMNO", sItemNo);
			setItemValue(0, 0, "SORTNO", sItemNo);
			setItemValue(0, 0, "INPUTORG", "<%=CurOrg.orgID %>");
			setItemValue(0, 0, "InputOrgName", "<%=CurOrg.orgName %>");
			setItemValue(0,0,"INPUTUSER","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"INPUTTIME","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd HH:mm:ss")%>");
			bIsInsert = true;
		}
    }
	
	/*~[Describe=������ѡ��ѡ���������;InputParam=��;OutPutParam=��;]~*/
	function selectErrorTypeMulti() {
		var Attribute7= getItemValue(0,getRow(),"Attribute7");
		if(Attribute7==""){
			alert("��ѡ���Ӧ�����ȼ�!");
			return;
		}
		var qualitygradecodeno ="qualitygradecodeno,"+Attribute7;
		
		var sRetVal = setObjectValue("SelectErrorType", qualitygradecodeno,"@qualitygradecodeno@0" , 0, 0, "");
		if (typeof(sRetVal)=="undefined" || sRetVal=="_CLEAR_" || sRetVal.length==0) {
			alert("��ѡ���������");
			return;
		}
		var sTypeArry = sRetVal.substring(0, sRetVal.length-1).split("@");
		var sCTypeIds = "";
		var SCTypeNames = "";
		for (var i=0;i<sTypeArry.length;i=i+2) {
			sCTypeIds += sTypeArry[i] + ",";
			SCTypeNames += sTypeArry[i+1] + ",";
		}
		setItemValue(0, 0, "Attribute8", sCTypeIds.substring(0, sCTypeIds.length-1));
		// code_library �� t.codeno='QualityFile'ģ������ Attribute5������Attribute8��������ʾ�ֶ�
		setItemValue(0, 0, "Attribute5", SCTypeNames.substring(0, SCTypeNames.length-1));
		return;
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
