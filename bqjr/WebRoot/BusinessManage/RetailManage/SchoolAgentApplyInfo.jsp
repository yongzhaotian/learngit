<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%
	/* --ҳ��˵��: ʾ������ҳ��-- */
	String PG_TITLE = "ʾ������ҳ��";

	// ���ҳ�����
	String sUserID = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("UserID"));
	if(sUserID == null) sUserID = "";
	
	// ͨ��DWģ�Ͳ���ASDataObject����doTemp
	String sTempletNo = "SchoolAgentInfo1";//ģ�ͱ��
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      // ����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; // �����Ƿ�ֻ�� 1:ֻ�� 0:��д
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sUserID);//�������,���ŷָ�
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
	//0���Ƿ�չʾ 1��	Ȩ�޿���  2�� չʾ���� 3����ť��ʾ���� 4����ť�������� 5����ť�����¼�����	6����ݼ�	7��	8��	9��ͼ�꣬CSS�����ʽ 10�����
	{"true","All","Button","����","���������޸�","saveRecord()","","","","btn_icon_save",""},
	{"true","All","Button","���沢����","���沢�����б�","saveAndGoBack()","","","","",""},
	{"true","","Button","����","�����б�ҳ��","goBack()","","","","",""},
		};
%>
<%@include file="/Resources/CodeParts/Info05.jsp"%>
<script type="text/javascript">
	var bIsInsert = false; // ���DW�Ƿ��ڡ�����״̬��
	function saveRecord(sPostEvents){
		var sPhone =getItemValue(0,getRow(),"PHONE");
		var sOtherTel =getItemValue(0,getRow(),"OTHERTEL");
		if(bIsInsert && checkPrimaryKey("school_agent_info","USERID")){
			alert("��¼�˺��Ѵ��ڣ��������룡");
			return;
		}
		if(bIsInsert && checkPrimaryKey("school_agent_info","WORKID")){
			alert("�����Ѵ��ڣ��������룡");
			return;
		}
		if(bIsInsert){
			beforeInsert();
		}
		
		if(!CheckWorkID()){
			return;
		}
		if (!isCardNo()) return;
		
		
		if(!(/^1[3|4|5|7|8][0-9]\d{8}$/.test(sPhone))){
	        alert("��ϵ�绰������������������");
	        return false; 
	    }
		
		if(!(/^1[3|4|5|7|8][0-9]\d{8}$/.test(sOtherTel))){
	        alert("������ϵ��ʽ������������������");
	        return false; 
	    }
		
		beforeUpdate();
		as_save("myiframe0",sPostEvents);
	}
	
	function saveAndGoBack(){
		saveRecord("goBack()");
	}
	
	function goBack(){
		AsControl.OpenView("/BusinessManage/RetailManage/SchoolAgentApplyList.jsp","","_self");
	}
	
	/* ѡ���û��ϼ� */
    function selectSuperUser() {
    	var retVal  = setObjectValue("SelectSchoolAgentSalesman", "","", 0, 0, "");
    	if (typeof retVal=="undefined" || retVal=="_CLEAR_") {
    		return;
    	}
    	setItemValue(0, 0, "SURPERORG", retVal.split("@")[0]);
    }
	
	//��鹤��
    /* function CheckWorkID(){
		var sWorkID = getItemValue(0,getRow(),"WORKID");
		var sUserID = getItemValue(0,getRow(),"USERID");
		if (typeof(sWorkID)=="undefined" || sWorkID.length==0) {
			sWorkID = " ";
		}
		if (typeof(sUserID)=="undefined" || sUserID.length==0) {
			sUserID = " ";
		}
		var sReturnWorkID= RunMethod("���÷���","GetColValue","school_agent_info,count(1),WorkID='"+sWorkID+"'and userid<>'"+sUserID+"'");
		if((!(typeof(sWorkID)=="undefined" || sWorkID.length==0))&&sReturnWorkID!="0.0"){
			alert("�����Ѵ��ڣ���������д��");
			return false;
		}
		return true;

	} */

	<%/*~[Describe=ִ�в������ǰִ�еĴ���;]~*/%>
	function beforeInsert(){
		var serialNo = getSerialNo("EXAMPLE_INFO","ExampleId");// ��ȡ��ˮ��
		setItemValue(0,getRow(),"ExampleID",serialNo);
		setItemValue(0,0,"InputUser","<%=CurUser.getUserID()%>");
		setItemValue(0,0,"InputUserName","<%=CurUser.getUserName()%>");
		setItemValue(0,0,"InputTime","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd hh:mm:ss")%>");
		bIsInsert = false;
	}
	
	<%/*~[Describe=ִ�и��²���ǰִ�еĴ���;]~*/%>
	function beforeUpdate(){
		setItemValue(0,0,"UpdateUser","<%=CurUser.getUserID()%>");
		setItemValue(0,0,"UpdateUserName","<%=CurUser.getUserName()%>");
		setItemValue(0,0,"UpdateTime","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd hh:mm:ss")%>");
	}
	function initRow() {
		if (getRowCount(0) == 0) {//�統ǰ�޼�¼��������һ��
			as_add("myiframe0");
			bIsInsert = true;
		} else {
			setItemReadOnly(0, 0, "USERID", true);
			setItemReadOnly(0, 0, "WORKID", true);
		}
	}
	
	/*~[Describe=���������滮ѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/
    function getRegionCode() {
    	
    	var retVal = setObjectValue("SelectCityCodeSingle","","",0,0,"");
    	if (typeof(retVal)=="undefined" || retVal=='_CLEAR_') {
    		return;
    	}
    	
    	setItemValue(0, 0, "CITY", retVal.split("@")[0]);
    	setItemValue(0, 0, "CITYNAME", retVal.split("@")[1]);
    }
	
	//���֤������У��
	function isCardNo() {
		var card = getItemValue(0, getRow(), "CERTID");
		if (card != "" || card.length != 0) {
			if (!checkIdcard(card)) {
				return false;
			}
			return true;
		} else {
			alert("���֤����Ϊ�գ�");
			return false;
		}
	}
	//���֤
	function checkIdcard(idcard) {
		var Errors = new Array("��֤ͨ��!", "���֤����λ������!", "���֤����������ڳ�����Χ���зǷ��ַ�!",
				"���֤����У�����!", "���֤�����Ƿ�!");
		var area = {
			11 : "����",
			12 : "���",
			13 : "�ӱ�",
			14 : "ɽ��",
			15 : "���ɹ�",
			21 : "����",
			22 : "����",
			23 : "������",
			31 : "�Ϻ�",
			32 : "����",
			33 : "�㽭",
			34 : "����",
			35 : "����",
			36 : "����",
			37 : "ɽ��",
			41 : "����",
			42 : "����",
			43 : "����",
			44 : "�㶫",
			45 : "����",
			46 : "����",
			50 : "����",
			51 : "�Ĵ�",
			52 : "����",
			53 : "����",
			54 : "����",
			61 : "����",
			62 : "����",
			63 : "�ຣ",
			64 : "����",
			65 : "�½�",
			71 : "̨��",
			81 : "���",
			82 : "����",
			91 : "����"
		}
		var idcard, Y, JYM;
		var S, M;
		var idcard_array = new Array();
		idcard_array = idcard.split("");
		//�������� 
		if (area[parseInt(idcard.substr(0, 2))] == null) {
			alert(Errors[4]);
			return false;
		}
		//��ݺ���λ������ʽ���� 
		switch (idcard.length) {
		case 15:
			if ((parseInt(idcard.substr(6, 2)) + 1900) % 4 == 0
					|| ((parseInt(idcard.substr(6, 2)) + 1900) % 100 == 0 && (parseInt(idcard
							.substr(6, 2)) + 1900) % 4 == 0)) {
				ereg = /^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}$/;//���Գ������ڵĺϷ��� 
			} else {
				ereg = /^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}$/;//���Գ������ڵĺϷ��� 
			}
			if (ereg.test(idcard)) {
				alert(Errors[0]);
				return true;
			} else {
				alert(Errors[2]);
				return false;
			}
			break;
		case 18:
			//18λ��ݺ����� 
			//�������ڵĺϷ��Լ��  
			//��������:((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9])) 
			//ƽ������:((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8])) 
			if (parseInt(idcard.substr(6, 4)) % 4 == 0
					|| (parseInt(idcard.substr(6, 4)) % 100 == 0 && parseInt(idcard
							.substr(6, 4)) % 4 == 0)) {
				ereg = /^[1-9][0-9]{5}19[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}[0-9Xx]$/;//����������ڵĺϷ���������ʽ 
			} else {
				ereg = /^[1-9][0-9]{5}19[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}[0-9Xx]$/;//ƽ��������ڵĺϷ���������ʽ 
			}
			if (ereg.test(idcard)) {//���Գ������ڵĺϷ��� 
				//����У��λ 
				S = (parseInt(idcard_array[0]) + parseInt(idcard_array[10]))
						* 7
						+ (parseInt(idcard_array[1]) + parseInt(idcard_array[11]))
						* 9
						+ (parseInt(idcard_array[2]) + parseInt(idcard_array[12]))
						* 10
						+ (parseInt(idcard_array[3]) + parseInt(idcard_array[13]))
						* 5
						+ (parseInt(idcard_array[4]) + parseInt(idcard_array[14]))
						* 8
						+ (parseInt(idcard_array[5]) + parseInt(idcard_array[15]))
						* 4
						+ (parseInt(idcard_array[6]) + parseInt(idcard_array[16]))
						* 2 + parseInt(idcard_array[7]) * 1
						+ parseInt(idcard_array[8]) * 6
						+ parseInt(idcard_array[9]) * 3;
				Y = S % 11;
				M = "F";
				JYM = "10X98765432";
				M = JYM.substr(Y, 1);//�ж�У��λ 
				if (M == idcard_array[17]) {
					return Errors[0]; //���ID��У��λ 
				} else {
					alert(Errors[3]);
					return false;
				}
			} else {
				alert(Errors[2]);
				return false;
			}
			break;
		default:
			alert(Errors[1]);
			return false;
			break;
		}
	}
	$(document).ready(function() {
		AsOne.AsInit();
		init();
		bFreeFormMultiCol = false;
		my_load(2, 0, 'myiframe0');
		initRow();
	});
</script>
<%@ include file="/IncludeEnd.jsp"%>