<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
  
<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author:  xswang 2015/05/25
		Tester:
		Content: �ļ����������Ϣ
		Input Param:
		Output param:
		History Log: 
	 */
	%>
<%/*~END~*/%>

	
<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "�ļ��������"; // ��������ڱ��� <title> PG_TITLE </title>
	String sToday = StringFunction.getTodayNow();//ϵͳʱ��
	
	%>
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=ApplyList;Describe=����ҳ��;]~*/%>
	<%@include file="/Common/WorkFlow/CheckDocTaskList.jsp"%>	
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
<script type="text/javascript">
	
	//��ȡ���������
	function getTask(){
		
		var sToday = "<%=sToday%>";
		var sUser = "<%=CurUser.getUserID()%>";
		//�ж��Ƿ��д���������
		var sReturn3 = RunMethod("���÷���","GetColValueTables","BUSINESS_CONTRACT,Check_Contract,count(1),BUSINESS_CONTRACT.serialno=Check_Contract.contractserialno and (business_contract.suretype = 'APP' or business_contract.suretype = 'FC') and (Check_Contract.CheckDocStatus = '2' and Check_Contract.gettaskuserid1='"+sUser+"' or Check_Contract.CheckDocStatus = '7' and Check_Contract.gettaskuserid2='"+sUser+"') and (business_contract.contractstatus='160' or business_contract.contractstatus='050') ");
		if(sReturn3 > 0){
			alert("��ǰ��δ���������!");
			return;
		}
		//��ͬ��
		var sReturn4 = RunMethod("���÷���","GetColValueTables","BUSINESS_CONTRACT,Check_Contract,Check_Contract.ContractSerialNo,BUSINESS_CONTRACT.serialno=Check_Contract.contractserialno and (BUSINESS_CONTRACT.contractstatus='160' or BUSINESS_CONTRACT.contractstatus='050') and (Check_Contract.checkdocstatus = '1' or Check_Contract.checkdocstatus = '6')  and (business_contract.suretype = 'APP' or business_contract.suretype = 'FC') ");
		//�ļ��������״̬
		var sReturn2 = RunMethod("���÷���","GetColValue","Check_Contract,CheckDocStatus,ContractSerialNo='"+sReturn4+"'");
		if(sReturn2 == "6"){// "6":�����������
			//����״̬Ϊ�����С����¸���ʼʱ�䡢���µ�ǰ��ȡ������û�
			RunMethod("PublicMethod","UpdateColValue","String@GetTaskUserID2@"+sUser+"@String@CheckDocStatus@7@String@checkagainbegintime@" + sToday + ",check_contract,String@contractserialno@" + sReturn4);
			alert("��ȡ�ɹ�!");
			parent.reloadSelf();
		}else if(sReturn2 == "1"){// "1":δ���
			//����״̬Ϊ����С������ļ���鿪ʼʱ�䡢���µ�ǰ��ȡ������û�
			RunMethod("PublicMethod","UpdateColValue","String@GetTaskUserID1@"+sUser+"@String@CheckDocStatus@2@String@checkbegintime@" + sToday + ",check_contract,String@contractserialno@" + sReturn4);
			alert("��ȡ�ɹ�!");
			parent.reloadSelf();
		}else{
			alert("û�п��Ի�ȡ������!");
			return;
		}
	}
	
	function checkDoc(){
		var sObjectNo = getItemValue(0,getRow(),"SerialNo"); //��ͬ��ˮ��
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert("��ѡ��һ����¼��");
			return;
		}
		//��ECM_IMAGE_OPINION��������
		RunJavaMethodSqlca("com.amarsoft.proj.action.InitCheckDocEcmImageOpinion","InitOpinion","objectNo="+sObjectNo+",objectType=Business");
		var param = "ObjectType=Business&ObjectNo="+sObjectNo;
		AsControl.OpenView("/Common/WorkFlow/ImageCheckList.jsp",param,"_blank","");
	}
	
	function updateDocOpinion(){
		var sObjectNo = getItemValue(0,getRow(),"SerialNo"); //��ͬ��ˮ��
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert("��ѡ��һ����¼��");
			return;
		}
		var param = "ObjectType=Business&ObjectNo="+sObjectNo;
		AsControl.OpenView("/Common/WorkFlow/ImageCheckList.jsp",param,"_blank","");
	}
	function doSubmit(){
		var sToday = "<%=sToday%>";
		var sObjectNo = getItemValue(0,getRow(),"SerialNo"); //��ͬ��ˮ��
		var sSureType = getItemValue(0,getRow(),"SureType"); //��ͬ��Դ
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert("��ѡ��һ����¼��");
			return;
		}
		//�������
		var sReturn0 = RunMethod("���÷���","GetColValue","Ecm_Image_Opinion,count(1),ObjectNo='"+sObjectNo+"' and ObjectType = 'Business' and opinion1 ='3' ");
		var sReturn1 = RunMethod("���÷���","GetColValue","Ecm_Image_Opinion,count(1),ObjectNo='"+sObjectNo+"' and ObjectType = 'Business' and opinion1 ='2' ");
		var sReturn11 = RunMethod("���÷���","GetColValue","Ecm_Image_Opinion,count(1),ObjectNo='"+sObjectNo+"' and ObjectType = 'Business' and opinion1 ='1' ");
		//�������
		var sReturn20 = RunMethod("���÷���","GetColValue","Ecm_Image_Opinion,count(1),ObjectNo='"+sObjectNo+"' and ObjectType = 'Business' and opinion2 ='3' ");
		var sReturn2 = RunMethod("���÷���","GetColValue","Ecm_Image_Opinion,count(1),ObjectNo='"+sObjectNo+"' and ObjectType = 'Business' and opinion2 ='2' ");
		var sReturn21 = RunMethod("���÷���","GetColValue","Ecm_Image_Opinion,count(1),ObjectNo='"+sObjectNo+"' and ObjectType = 'Business' and opinion2 ='1' ");
		//�ļ��������״̬
		var sReturn3 = RunMethod("���÷���","GetColValue","CHECK_CONTRACT,CheckDocStatus,CONTRACTSERIALNO='"+sObjectNo+"' ");
		if(sReturn3 == "2"){//�����
			//�Ƿ�����������
			var sReturn = RunMethod("���÷���","GetColValueTables","ecm_page,ecm_image_opinion,count(*),ecm_page.typeno=ecm_image_opinion.typeno and ecm_page.objectno=ecm_image_opinion.objectno and ecm_image_opinion.objectno='"+sObjectNo+"' and ecm_page.objecttype='Business' and ecm_image_opinion.objecttype='Business' and ecm_image_opinion.opinion1 is null ");
			if(sReturn > 0){
				alert("�����ļ�δ��д�������!");
				return false;
			}
			if(sReturn0 > 0){//�йؼ�����
				RunMethod("PublicMethod","UpdateColValue","String@CheckDocResult@3@String@CheckDocStatus@4@String@adddoctime@" + sToday + ",check_contract,String@contractserialno@" + sObjectNo);
			}else if(sReturn1 > 0){//�зǹؼ�����
				RunMethod("PublicMethod","UpdateColValue","String@CheckDocResult@2@String@CheckDocStatus@4@String@adddoctime@" + sToday + ",check_contract,String@contractserialno@" + sObjectNo);
			}else if(sReturn1 == 0 && sReturn11 > 0){// ���ϸ�
				RunMethod("PublicMethod","UpdateColValue","String@CheckDocResult@1@String@CheckDocStatus@3@String@adddoctime@" + sToday + ",check_contract,String@contractserialno@" + sObjectNo);
			}
			alert("�ύ�ɹ�!");
			parent.reloadSelf();
			//�ļ�������������PAD�˷���֪ͨ��Ϣ
			RunJavaMethodSqlca("com.amarsoft.app.billions.SendMessageUtil","sendMessage","sSendType=1,sObjectNo="+sObjectNo+",sSureType="+sSureType);
		}else if(sReturn3 == "7"){//������
			//�Ƿ�����������
			var sReturn31 = RunMethod("���÷���","GetColValue","Ecm_Image_Opinion,count(1),ObjectNo='"+sObjectNo+"' and ObjectType = 'Business' and opinion1 ='2' and opinion2 is null ");
			if(sReturn31 > 0){
				alert("�����ļ�δ��д�������!");
				return false;
			}
			if(sReturn20 > 0){//�ؼ�����
				RunMethod("PublicMethod","UpdateColValue","String@CheckDocResult2@3@String@CheckDocStatus@5@String@checkagainendtime@"+ sToday+",check_contract,String@contractserialno@" + sObjectNo);
			}else if(sReturn2 > 0){//�зǹؼ�����
				RunMethod("PublicMethod","UpdateColValue","String@CheckDocResult2@2@String@CheckDocStatus@5@String@checkagainendtime@"+ sToday+",check_contract,String@contractserialno@" + sObjectNo);
			}else if(sReturn2 == 0 && sReturn21 > 0){// ���ϸ�
				RunMethod("PublicMethod","UpdateColValue","String@CheckDocResult2@1@String@CheckDocStatus@3@String@checkagainendtime@"+ sToday+",check_contract,String@contractserialno@" + sObjectNo);
			}
			alert("�ύ�ɹ�!");
			parent.reloadSelf();
			//�ļ�������鸴����PAD�˷���֪ͨ��Ϣ
			RunJavaMethodSqlca("com.amarsoft.app.billions.SendMessageUtil","sendMessage","sSendType=2,sObjectNo="+sObjectNo+",sSureType="+sSureType);
		}else if(sReturn3 == "4"){//����������
			//�Ƿ�����������
			var sReturn32 = RunMethod("���÷���","GetColValueTables","ecm_page,ecm_image_opinion,count(*),ecm_page.typeno=ecm_image_opinion.typeno and ecm_page.objectno=ecm_image_opinion.objectno and ecm_image_opinion.objectno='"+sObjectNo+"' and ecm_page.objecttype='Business' and ecm_image_opinion.objecttype='Business' and ecm_image_opinion.opinion1 is null ");
			if(sReturn32 > 0){
				alert("�����ļ�δ��д�������!");
				return false;
			}
			if(sReturn0 > 0){//�йؼ�����
				RunMethod("PublicMethod","UpdateColValue","String@CheckDocResult@3@String@CheckDocStatus@4,check_contract,String@contractserialno@" + sObjectNo);
				alert("�ύ�ɹ�!�����ȼ�������ؼ�����!");
			}else if(sReturn1 > 0){//�зǹؼ�����
				RunMethod("PublicMethod","UpdateColValue","String@CheckDocResult@2@String@CheckDocStatus@4,check_contract,String@contractserialno@" + sObjectNo);
				alert("�ύ�ɹ�!�����ȼ�������ǹؼ�����!");
			}else if(sReturn1 == 0 && sReturn11 > 0){// ���ϸ�
				RunMethod("PublicMethod","UpdateColValue","String@CheckDocResult@1@String@CheckDocStatus@3,check_contract,String@contractserialno@" + sObjectNo);
				alert("�ύ�ɹ�!�����ȼ�������ϸ�");
			}
//			parent.reloadSelf();
			//�ļ�������鸴����PAD�˷���֪ͨ��Ϣ
//			RunJavaMethodSqlca("com.amarsoft.app.billions.SendMessageUtil","sendMessage","sSendType=2,sObjectNo="+sObjectNo);
		}else if(sReturn3 == "3"){//�ϸ�
			//�Ƿ�����������
//			var sReturn31 = RunMethod("���÷���","GetColValue","Ecm_Image_Opinion,count(1),ObjectNo='"+sObjectNo+"' and ObjectType = 'Business' and opinion1 ='2' and opinion2 is null ");
			var sCheckDocResult = RunMethod("���÷���","GetColValue","Check_Contract,checkDocResult,contractSerialNo='"+sObjectNo+"' ");
/* 			if(sReturn31 > 0){
				alert("�����ļ�δ��д�������!");
				return false;
			} */
			if(sReturn0 > 0 && sCheckDocResult == "1"){
				RunMethod("PublicMethod","UpdateColValue","String@CheckDocResult@2@String@CheckDocStatus@4,check_contract,String@contractserialno@" + sObjectNo);
				alert("�ύ�ɹ�!����ϸ������ؼ�����");
			}else if(sReturn1 > 0 && sCheckDocResult == "1"){
				RunMethod("PublicMethod","UpdateColValue","String@CheckDocResult@2@String@CheckDocStatus@4,check_contract,String@contractserialno@" + sObjectNo);
				alert("�ύ�ɹ�!����ϸ������ǹؼ�����");
			}else if(sReturn20 > 0 && sCheckDocResult != "1"){ //�йؼ�����
				RunMethod("PublicMethod","UpdateColValue","String@CheckDocResult2@2@String@CheckDocStatus@5,check_contract,String@contractserialno@" + sObjectNo);
				alert("�ύ�ɹ�!����ϸ������ؼ�����");
			}else if(sReturn2 > 0 && sCheckDocResult != "1"){ //�зǹؼ�����
				RunMethod("PublicMethod","UpdateColValue","String@CheckDocResult2@2@String@CheckDocStatus@5,check_contract,String@contractserialno@" + sObjectNo);
				alert("�ύ�ɹ�!����ϸ������ǹؼ�����");
			}else if(sReturn2 == 0 && sReturn21 > 0){// ���ϸ�
				//RunMethod("PublicMethod","UpdateColValue","String@CheckDocResult2@1@String@CheckDocStatus@3,check_contract,String@contractserialno@" + sObjectNo);
				alert("�ޱ��!");
			}
//			parent.reloadSelf();
			//�ļ�������鸴����PAD�˷���֪ͨ��Ϣ
//			RunJavaMethodSqlca("com.amarsoft.app.billions.SendMessageUtil","sendMessage","sSendType=2,sObjectNo="+sObjectNo);
		}else if(sReturn3 == "5"){//�ǹؼ�����ͨ��
			//�Ƿ�����������
			var sReturn31 = RunMethod("���÷���","GetColValue","Ecm_Image_Opinion,count(1),ObjectNo='"+sObjectNo+"' and ObjectType = 'Business' and opinion1 ='2' and opinion2 is null ");
			if(sReturn31 > 0){
				alert("�����ļ�δ��д�������!");
				return false;
			}

			if(sReturn20 > 0){//�йؼ�����
				RunMethod("PublicMethod","UpdateColValue","String@CheckDocResult2@3@String@CheckDocStatus@5,check_contract,String@contractserialno@" + sObjectNo);
				alert("�ύ�ɹ�!�ǹؼ�����ͨ��������ؼ�����!");
			}else if(sReturn2 > 0){//�зǹؼ�����
				RunMethod("PublicMethod","UpdateColValue","String@CheckDocResult2@2@String@CheckDocStatus@5,check_contract,String@contractserialno@" + sObjectNo);
				alert("�ύ�ɹ�!�ǹؼ�����ͨ��������ǹؼ�����!");
			}else if(sReturn2 == 0 && sReturn21 > 0){// ���ϸ�
				RunMethod("PublicMethod","UpdateColValue","String@CheckDocResult2@1@String@CheckDocStatus@3,check_contract,String@contractserialno@" + sObjectNo);
				alert("�ύ�ɹ�!�ǹؼ�����ͨ��������ϸ�ͨ��");
			}
//			parent.reloadSelf();
			//�ļ�������鸴����PAD�˷���֪ͨ��Ϣ
//			RunJavaMethodSqlca("com.amarsoft.app.billions.SendMessageUtil","sendMessage","sSendType=2,sObjectNo="+sObjectNo);
		}
	}
	
	
</script>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List07;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script type="text/javascript">
	AsOne.AsInit();
	init();
	//initRow();
	my_load(2,0,"myiframe0");
</script>
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>