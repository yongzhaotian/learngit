<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%
	/* --ҳ��˵��: ʾ������ҳ��-- */
	String PG_TITLE = "�ŵ�׼������";

	// ���ҳ�����
	String sSerialNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
	String[] sSerialNoArr = null;
	String SerialNo="";
	if(sSerialNo==null){
		sSerialNo="";
	}else{
		sSerialNoArr = sSerialNo.split(",");
		SerialNo = sSerialNoArr[0];
	}
	
	System.out.print("------------"+sSerialNo);
	// ͨ��DWģ�Ͳ���ASDataObject����doTemp
	String sTempletNo = "AgreeApproveStoremodel";//ģ�ͱ��
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	doTemp.setHRadioSql("AgreementApproveStatus", "Select itemno,itemname from code_library  where codeno='PrimaryApproveStatus' and itemno in ('1','2') ");
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      // ����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; // �����Ƿ�ֻ�� 1:ֻ�� 0:��д
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(SerialNo);//�������,���ŷָ�
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
			//0���Ƿ�չʾ 1��	Ȩ�޿���  2�� չʾ���� 3����ť��ʾ���� 4����ť�������� 5����ť�����¼�����	6����ݼ�	7��	8��	9��ͼ�꣬CSS�����ʽ 10�����
			{"true","All","Button","�ύ","�ύ�����޸�","saveRecord()","","","","btn_icon_save",""},
			
			
		};
%>
<%@include file="/Resources/CodeParts/Info05.jsp"%>
<script type="text/javascript">
	
 	function showAgreementCode(){
		var sAgreementApproveStatus=getItemValue(0, 0, "AgreementApproveStatus");
		var sAgreementCode=getItemValue(0, 0, "AgreementCode");
		var sRAgreementApproveCode=getItemValue(0, 0, "RAgreementApproveCode");
		if(sAgreementApproveStatus=="1"){
			if(sRAgreementApproveCode!=""&&sRAgreementApproveCode!=null){
				setItemValue(0,0,"AgreementCode",sRAgreementApproveCode);
				showItem(0, 0, "AgreementCode");
				setItemReadOnly(0, 0, "AgreementCode", true);
			}else{
				alert("��������̻���");
				return ;
			}
		}else{	
			hideItem(0, 0, "AgreementCode");//����
			setItemValue(0,0,"AgreementCode","");
		}
		
	} 
	
	function saveRecord(sPostEvents){
		var sssSerialNo="<%=sSerialNo%>";
		if(sssSerialNo==null){
			alert("��ѡ��һ����¼��");
			return;
		}
		var ssSerialNo=sssSerialNo.split(",");
		var sAgreementApproveStatus=getItemValue(0, 0, "AgreementApproveStatus");
		var sAgreementCode=getItemValue(0, 0, "AgreementCode");
		var sRAgreementApproveCode=getItemValue(0, 0, "RAgreementApproveCode");
		var sAgreementApproveTime=getItemValue(0, 0, "AgreementApproveTime");
		var sAgreementApprovePerson=getItemValue(0,0,"AgreementApprovePerson");//Э������� add by tangyb CCS-992
		if(sRAgreementApproveCode==""){
			alert("��������̻���");
			return ;
		}
		
		//�ύ
		var AllSerialNo = sssSerialNo.replace(/,/g,"|");//�滻������,
		var para = "AllSerialNo="+AllSerialNo+",AgreementCode="+sAgreementCode+",AgreementApproveStatus="+sAgreementApproveStatus
					+",AgreementApproveTime="+sAgreementApproveTime+",agreementapproveperson="+sAgreementApprovePerson;
		RunJavaMethodSqlca("com.amarsoft.app.billions.UpdateRetailRno","AgreementApproveStore", para);
		
		var rt = RunJavaMethodSqlca("com.amarsoft.app.billions.UpdateRetailRno", "selectSnoIsBuild", "AllSerialNo="+AllSerialNo);
	
		as_save("myiframe0",sPostEvents);
		showAgreementCode();
	}
	
	function initRow(){
		setItemValue(0,0,"AgreementApprovePerson","<%=CurUser.getUserID()%>");
		setItemValue(0,0,"AgreementApproveTime","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd") %>");
		showAgreementCode();
		if (getRowCount(0)==0){//�統ǰ�޼�¼��������һ��
			as_add("myiframe0");//������¼
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
