<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%
	/* --ҳ��˵��: ʾ������ҳ��-- */
	String PG_TITLE = "ʾ������ҳ��";

	// ���ҳ�����
	String sSerialNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
	if(sSerialNo==null) sSerialNo="";
	System.out.print("------------"+sSerialNo);
	// ͨ��DWģ�Ͳ���ASDataObject����doTemp
	String sTempletNo = "AgreeApprovemodel";//ģ�ͱ��
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	doTemp.setHRadioSql("AgreementApproveStatus", "Select itemno,itemname from code_library  where codeno='PrimaryApproveStatus' and itemno in ('1','2') ");
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      // ����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; // �����Ƿ�ֻ�� 1:ֻ�� 0:��д
	
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sSerialNo);//�������,���ŷָ�
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
			//0���Ƿ�չʾ 1��	Ȩ�޿���  2�� չʾ���� 3����ť��ʾ���� 4����ť�������� 5����ť�����¼�����	6����ݼ�	7��	8��	9��ͼ�꣬CSS�����ʽ 10�����
			{"true","All","Button","�ύ","�ύ�����޸�","saveRecord()","","","","btn_icon_save",""},
		};
%>
<%@include file="/Resources/CodeParts/Info05.jsp"%>
<script type="text/javascript">	
	//���Э�������ظ���
	function checkAgreementCode(){
		var sSerialNo = getItemValue(0,getRow(),"SERIALNO");
		var sAgreementApproveCode = getItemValue(0,getRow(),"AgreementApproveCode");
		sAgreementApproveCode = sAgreementApproveCode.replace(" ","");
		setItemValue(0,0,"AgreementApproveCode",sAgreementApproveCode);
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0) {
			sSerialNo = " ";
		}
		var sReturnAgreementApproveCode = RunMethod("CustomerManage","SelectAgreementApproveCode",sAgreementApproveCode+","+sSerialNo);
		if((!(typeof(sAgreementApproveCode)=="undefined" || sAgreementApproveCode.length==0))&&sReturnAgreementApproveCode!="0.0"){
			alert("Э������Ѵ��ڣ���������д��");
			return false;
		}
		return true;
	}
	function showAgreementCode(){
		var sAgreementApproveStatus=getItemValue(0, 0, "AgreementApproveStatus");
		var sAgreementApproveCode=getItemValue(0, 0, "AgreementApproveCode");
		if(sAgreementApproveStatus=="1"){
				setItemValue(0,0,"AgreementApproveCode",sAgreementApproveCode);
				showItem(0, 0, "AgreementApproveCode");
				setItemReadOnly(0, 0, "AgreementApproveCode", false);
				setItemRequired(0, 0, "AgreementApproveCode", true);
				//setItemDisabled(0,0,"AgreementCode",true)		
		}else{	
			hideItem(0, 0, "AgreementApproveCode");//����
			setItemValue(0,0,"AgreementApproveCode","");
			setItemRequired(0, 0, "AgreementApproveCode", false);
	//		setItemDisabled(0,0,"AgreementCode",false);
		}
	}
	
	function saveRecord(sPostEvents){
		if(!checkAgreementCode()){
			return;
		}
		
		var serialno = getItemValue(0, 0, "SERIALNO"); //�������
		var agreementapprovestatus = getItemValue(0, 0, "AgreementApproveStatus"); //���״̬
		var agreementapprovetime = getItemValue(0, 0, "AgreementApproveTime"); //���ʱ��
		var agreementapproveman = getItemValue(0, 0, "agreementapproveman"); //�����
		var agreementapprovecode = getItemValue(0, 0, "AgreementApproveCode"); //Э�����
		
		var parameter = "AllSerialNo="+serialno+",AgreementApproveStatus="+agreementapprovestatus+",AgreementApproveTime="+agreementapprovetime
				+",agreementapprovecode="+agreementapprovecode+",agreementapproveman="+agreementapproveman;
		
		/************begin CCS-1040, ����Э�����Ϊ��Ҳ�ܱ�������� huzp 20160126*****************************************************/
		if(agreementapprovestatus=="1" && agreementapprovecode.length==0){
			as_save("myiframe0",sPostEvents);
		}else{
			RunJavaMethodSqlca("com.amarsoft.app.billions.UpdateRetailRno", "agreementApproveRetail", parameter); //����ͨ������״̬
			RunJavaMethodSqlca("com.amarsoft.app.billions.UpdateRetailRno", "selectRnoIsBuild", "AllSerialNo="+serialno); // ����������״̬
			showAgreementCode();
			alert("��˳ɹ�");
		}
		/*************end*****************************************************/
		//as_save("myiframe0",sPostEvents);

		
	}
	
	function initRow(){
		setItemValue(0,0,"AgreementApproveTime","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd") %>");
		setItemValue(0,0,"agreementapproveman","<%=CurUser.getUserID() %>");
		showAgreementCode();
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
