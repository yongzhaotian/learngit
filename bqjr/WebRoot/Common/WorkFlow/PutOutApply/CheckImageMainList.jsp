<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
  
<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author:  yongxu 2015/05/28
		Tester:
		Content: �������ϼ��
		Input Param:
		Output param:
		History Log: 
	 */
	%>
<%/*~END~*/%>

	
<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "�������ϼ��"; // ��������ڱ��� <title> PG_TITLE </title>
	String sToday = StringFunction.getTodayNow();//ϵͳʱ��
	
	%>
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=ApplyList;Describe=����ҳ��;]~*/%>
	<%@include file="/Common/WorkFlow/PutOutApply/CheckImageList.jsp"%>	
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
		var sReturn3 = RunMethod("���÷���","GetColValueTables","BUSINESS_CONTRACT,check_contract,count(1),BUSINESS_CONTRACT.serialno=check_contract.contractSerialNo and (check_contract.checkstatus = '4'  and check_contract.checkimageuserid='"+sUser+"' or check_contract.checkstatus = '7'  and check_contract.checkimageuserid2='"+sUser+"') and BUSINESS_CONTRACT.contractstatus = '050' ");
		if(sReturn3 > 0){
			alert("��ǰ��δ���������!");
			return;
		}
		//��ͬ��
		var sReturn4 = RunMethod("���÷���","GetColValueTables","BUSINESS_CONTRACT,check_contract,SerialNo,BUSINESS_CONTRACT.serialno=Check_Contract.contractserialno and (BUSINESS_CONTRACT.suretype = 'APP' or BUSINESS_CONTRACT.suretype = 'FC') and BUSINESS_CONTRACT.contractstatus = '050' and check_contract.uploadFlag = '1' and (check_contract.checkstatus = '2' or check_contract.checkstatus = '6') ");
		//���������ϴ�״̬
		var sReturn5 = RunMethod("���÷���","GetColValue","check_contract,uploadFlag,ContractSerialNo='"+sReturn4+"' ");
		//�������ϼ��״̬
		var sReturn2 = RunMethod("���÷���","GetColValue","check_contract,checkstatus,ContractSerialNo='"+sReturn4+"' ");
		if(sReturn2 == "2" && sReturn5 == "1"){// ע����ɲ������ϴ���������
			//����״̬Ϊ�����
			RunMethod("���÷���","UpdateColValue","check_contract,checkstatus,4,ContractSerialNo='"+sReturn4+"' ");
			//���¸���ʼʱ��
//			RunMethod("���÷���","UpdateColValue","BUSINESS_CONTRACT,checkagainbegintime,"+sToday+",PassTime = '"+sReturn1+"'");
			//���µ�һ�λ�ȡ����ʱ��
			RunMethod("���÷���","UpdateColValue","check_contract,getLoanTaskTime,"+sToday+",ContractSerialNo = '"+sReturn4+"'");
			//���µ�ǰ��ȡ������û�
			RunMethod("���÷���","UpdateColValue","check_contract,checkImageUserID,"+sUser+",ContractSerialNo = '"+sReturn4+"'");
			alert("��ȡ�ɹ�!");
			parent.reloadSelf();
		}else if(sReturn2 == "6" && sReturn5 == "1"){// ��������������
			//����״̬Ϊ�����
			RunMethod("���÷���","UpdateColValue","check_contract,checkstatus,7,ContractSerialNo='"+sReturn4+"' ");
			//���¸���ʼʱ��
//			RunMethod("���÷���","UpdateColValue","BUSINESS_CONTRACT,checkagainbegintime,"+sToday+",PassTime = '"+sReturn1+"'");
			//���µ�ǰ��ȡ������û�
			RunMethod("���÷���","UpdateColValue","check_contract,checkImageUserID2,"+sUser+",ContractSerialNo = '"+sReturn4+"'");
			//���µ�һ�λ�ȡ����ʱ��
			RunMethod("���÷���","UpdateColValue","check_contract,getLoanTaskTime2,"+sToday+",ContractSerialNo = '"+sReturn4+"'");
			alert("��ȡ�ɹ�!");
			parent.reloadSelf();
		}else{
			alert("û�п��Ի�ȡ������!");
			return;
		}
	}
	
	function doSubmit(){
		var sToday = "<%=sToday%>";
		var sObjectNo = getItemValue(0,getRow(),"SerialNo"); //��ͬ��ˮ��
		var sSureType = getItemValue(0,getRow(),"SureType"); //��ͬ��Դ
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert("��ѡ��һ����¼��");
			return;
		}
		//��������������
//		var sReturn = RunMethod("���÷���","GetColValue","Ecm_Image_Opinion,count(1),ObjectNo='"+sObjectNo+"' and ObjectType = 'BusinessLoan' ");
		//����δ��д�������
//		var sReturn4 = RunMethod("���÷���","GetColValue","Ecm_Image_Opinion,count(1),ObjectNo='"+sObjectNo+"' and ObjectType = 'BusinessLoan' and checkopinion1 is null ");
		//����ϸ�����
//		var sReturn1 = RunMethod("���÷���","GetColValue","Ecm_Image_Opinion,count(1),ObjectNo='"+sObjectNo+"' and ObjectType = 'BusinessLoan' and checkopinion1 ='1' ");
		//����ؼ���������
		var sReturn23 = RunMethod("���÷���","GetColValue","Ecm_Image_Opinion,count(1),ObjectNo='"+sObjectNo+"' and ObjectType = 'BusinessLoan' and checkopinion1 ='3' ");
		//����ǹؼ���������
		var sReturn22 = RunMethod("���÷���","GetColValue","Ecm_Image_Opinion,count(1),ObjectNo='"+sObjectNo+"' and ObjectType = 'BusinessLoan' and checkopinion1 ='2'  ");
		//����δ��д�������
//		var sReturn5 = RunMethod("���÷���","GetColValue","Ecm_Image_Opinion,count(1),ObjectNo='"+sObjectNo+"' and ObjectType = 'BusinessLoan' and checkopinion2 is null ");
		//����ؼ���������
		var sReturn63 = RunMethod("���÷���","GetColValue","Ecm_Image_Opinion,count(1),ObjectNo='"+sObjectNo+"' and ObjectType = 'BusinessLoan' and checkopinion2 ='3' ");
		//����ǹؼ���������
		var sReturn62 = RunMethod("���÷���","GetColValue","Ecm_Image_Opinion,count(1),ObjectNo='"+sObjectNo+"' and ObjectType = 'BusinessLoan' and checkopinion2 ='2'  ");

		//�ϴ����������ϵ���δǩ���������ļ�¼����
		var sNoSigned1 = RunMethod("���÷���","GetColValueTables","ecm_page,ecm_image_opinion,count(1),ecm_image_opinion.typeno = ecm_page.typeno and ecm_image_opinion.objectno = ecm_page.objectno and ecm_image_opinion.objecttype = ecm_page.objecttype and ecm_image_opinion.objecttype = 'BusinessLoan' and ecm_image_opinion.objectno = '"+sObjectNo+"' and ecm_image_opinion.checkopinion1 is null ");
		//var sNoSigned2 = RunMethod("���÷���","GetColValueTables","ecm_page,ecm_image_opinion,count(1),ecm_image_opinion.typeno = ecm_page.typeno and ecm_image_opinion.objectno = ecm_page.objectno and ecm_image_opinion.objecttype = ecm_page.objecttype and ecm_image_opinion.objecttype = 'BusinessLoan' and ecm_image_opinion.objectno = '"+sObjectNo+"' and ecm_image_opinion.checkopinion2 is null ");
		var sNoSigned2 = RunMethod("���÷���","GetColValue","Ecm_Image_Opinion,count(1),ObjectNo='"+sObjectNo+"' and ObjectType = 'BusinessLoan' and checkopinion1 <>'1' and checkopinion2 is null ");
		//���״̬
		var sReturn3 = RunMethod("���÷���","GetColValue","check_contract,CHECKSTATUS,ContractSerialNo='"+sObjectNo+"' ");
		if(sReturn3 == "4"){//��һ�μ��
		/* 	if(sReturn4==sReturn){
				alert("δ��д�����");
				return false;
			} */
			if(sNoSigned1 > 0){
				alert("�����ļ�δ��д���������");
				return false;
			}
			if(sReturn23 > 0){//�йؼ�����
				RunMethod("���÷���","UpdateColValue","check_contract,checkstatus,5,ContractSerialNo='"+sObjectNo+"' ");//��������
				RunMethod("���÷���","UpdateColValue","check_contract,checkresult,3,ContractSerialNo='"+sObjectNo+"' ");//���º�ͬ״̬Ϊ�ؼ�����
			}else if(sReturn22 > 0){//�зǹؼ�����
				RunMethod("���÷���","UpdateColValue","check_contract,checkstatus,5,ContractSerialNo='"+sObjectNo+"' ");//��������
				RunMethod("���÷���","UpdateColValue","check_contract,checkresult,2,ContractSerialNo='"+sObjectNo+"' ");//���º�ͬ״̬Ϊ�ǹؼ�����
			}else{// ���ϸ�
				RunMethod("���÷���","UpdateColValue","check_contract,checkstatus,1,ContractSerialNo='"+sObjectNo+"' ");//���ͨ��
				RunMethod("���÷���","UpdateColValue","check_contract,checkresult,1,ContractSerialNo='"+sObjectNo+"' ");//���º�ͬ״̬Ϊ�ϸ�
			}
			alert("�ύ�ɹ�!");
			parent.reloadSelf();
			RunMethod("���÷���","UpdateColValue","check_contract,verifyLoanTime,"+sToday+",ContractSerialNo = '"+sObjectNo+"'");
			//�������ϼ�������PAD�˷���֪ͨ��Ϣ
			RunJavaMethodSqlca("com.amarsoft.app.billions.SendMessageUtil","sendMessage","sSendType=3,sObjectNo="+sObjectNo+",sSureType="+sSureType);
		}else if(sReturn3 == "7"){//�ڶ��μ��
			if(sNoSigned2 > 0){
				alert("�����ļ�δ��д���������");
				return false;
			}
			if(sReturn63 > 0){//�йؼ�����
				RunMethod("���÷���","UpdateColValue","check_contract,checkstatus,1,ContractSerialNo='"+sObjectNo+"' ");//����Ҳ��ͨ��������
				RunMethod("���÷���","UpdateColValue","check_contract,CHECKRESULT2,3,ContractSerialNo='"+sObjectNo+"' ");//���º�ͬ״̬Ϊ�ؼ�����
			}else if(sReturn62 > 0){//�зǹؼ�����
				RunMethod("���÷���","UpdateColValue","check_contract,checkstatus,1,ContractSerialNo='"+sObjectNo+"' ");//����Ҳ��ͨ��������
				RunMethod("���÷���","UpdateColValue","check_contract,CHECKRESULT2,2,ContractSerialNo='"+sObjectNo+"' ");//���º�ͬ״̬Ϊ�ǹؼ�����
			}else{// ���ϸ�
				RunMethod("���÷���","UpdateColValue","check_contract,checkstatus,1,ContractSerialNo='"+sObjectNo+"' ");//���ͨ��
				RunMethod("���÷���","UpdateColValue","check_contract,CHECKRESULT2,1,ContractSerialNo='"+sObjectNo+"' ");//���º�ͬ״̬Ϊ�ϸ�
			}
			alert("�ύ�ɹ�!");
			parent.reloadSelf();
			RunMethod("���÷���","UpdateColValue","check_contract,verifyLoanTime2,"+sToday+",ContractSerialNo = '"+sObjectNo+"'");
			//�������ϼ�鸴����PAD�˷���֪ͨ��Ϣ
			RunJavaMethodSqlca("com.amarsoft.app.billions.SendMessageUtil","sendMessage","sSendType=4,sObjectNo="+sObjectNo+",sSureType="+sSureType);
		}else if(sReturn3 == "5"){//���������У�����Ա�����޸Ĵ������ϼ���������ע
			if(sNoSigned1 > 0){
				alert("�����ļ�δ��д���������");
				return false;
			}
			if(sReturn23 > 0){//�йؼ�����
				RunMethod("���÷���","UpdateColValue","check_contract,checkstatus,5,ContractSerialNo='"+sObjectNo+"' ");//��������
				RunMethod("���÷���","UpdateColValue","check_contract,checkresult,3,ContractSerialNo='"+sObjectNo+"' ");//���º�ͬ״̬Ϊ�ؼ�����
				alert("�ύ�ɹ�!�������������ȼ����������ؼ�����");
			}else if(sReturn22 > 0){//�зǹؼ�����
				RunMethod("���÷���","UpdateColValue","check_contract,checkstatus,5,ContractSerialNo='"+sObjectNo+"' ");//��������
				RunMethod("���÷���","UpdateColValue","check_contract,checkresult,2,ContractSerialNo='"+sObjectNo+"' ");//���º�ͬ״̬Ϊ�ǹؼ�����
				alert("�ύ�ɹ�!�������������ȼ����������ǹؼ�����");
			}else{// ���ϸ�
				RunMethod("���÷���","UpdateColValue","check_contract,checkstatus,1,ContractSerialNo='"+sObjectNo+"' ");//���ͨ��
				RunMethod("���÷���","UpdateColValue","check_contract,checkresult,1,ContractSerialNo='"+sObjectNo+"' ");//���º�ͬ״̬Ϊ�ϸ�
				alert("�ύ�ɹ�!����������������ȼ�������ϸ�");
			}
//			parent.reloadSelf();
		}else if(sReturn3 == "1"){//�ϸ񣬹���Ա�����޸Ĵ������ϼ���������ע
			if(sCheckResult=="1" && sNoSigned1 > 0){
				alert("�����ļ�δ��д���������");
				return false;
			}
		
			var sCheckResult = RunMethod("���÷���","GetColValue","Check_Contract,checkResult,ContractSerialNo='"+sObjectNo+"'  ");
			if(sCheckResult=="1"){
				if(sReturn23 > 0){//�йؼ�����
					RunMethod("���÷���","UpdateColValue","check_contract,checkstatus,5,ContractSerialNo='"+sObjectNo+"' ");//��������
					RunMethod("���÷���","UpdateColValue","check_contract,checkresult,3,ContractSerialNo='"+sObjectNo+"' ");//���º�ͬ״̬Ϊ�ؼ�����
					alert("�ύ�ɹ�!�������������ȼ����������ؼ�����");
				}else if(sReturn22 > 0){ //�зǹؼ�����
					RunMethod("���÷���","UpdateColValue","check_contract,checkstatus,5,ContractSerialNo='"+sObjectNo+"' ");//��������
					RunMethod("���÷���","UpdateColValue","check_contract,checkresult,2,ContractSerialNo='"+sObjectNo+"' ");//���º�ͬ״̬Ϊ�ǹؼ�����
					alert("�ύ�ɹ�!�������������ȼ����������ǹؼ�����");
				}else{
					RunMethod("���÷���","UpdateColValue","check_contract,checkresult,1,ContractSerialNo='"+sObjectNo+"' ");//���º�ͬ״̬Ϊ�ϸ�
					alert("�ύ�ɹ�!�������������ȼ����������ϸ�");
				}
			}else {
				if(sReturn63 > 0){//�йؼ�����
					RunMethod("���÷���","UpdateColValue","check_contract,checkresult2,3,ContractSerialNo='"+sObjectNo+"' ");//���º�ͬ״̬Ϊ�ؼ�����
					alert("�ύ�ɹ�!�������������ȼ����������ؼ�����");
				}else if(sReturn62 > 0){ //�зǹؼ�����
					RunMethod("���÷���","UpdateColValue","check_contract,checkresult2,2,ContractSerialNo='"+sObjectNo+"' ");//���º�ͬ״̬Ϊ�ǹؼ�����
					alert("�ύ�ɹ�!�������������ȼ����������ǹؼ�����");
				}else{
					RunMethod("���÷���","UpdateColValue","check_contract,checkresult2,1,ContractSerialNo='"+sObjectNo+"' ");//���º�ͬ״̬Ϊ�ϸ�
					alert("�ύ�ɹ�!�������������ȼ����������ϸ�");
				}
			}
//			parent.reloadSelf();
		}
		
	}
	function checkImage(){
		var sObjectNo = getItemValue(0,getRow(),"SerialNo"); //��ͬ��ˮ��
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert("��ѡ��һ����¼��");
			return;
		}
		//����״̬Ϊ�Ѽ��
//		RunMethod("���÷���","UpdateColValue","BUSINESS_CONTRACT,checkstatus,1,serialno = '"+sObjectNo+"'");
//	     var param = "ObjectType=Business&TypeNo=20&RightType=100&ObjectNo="+sObjectNo+"&uploadPeriod=1";
//	     AsControl.PopView( "/ImageManage/ImageView.jsp", param, "" ); 
		//��ECM_IMAGE_OPINION��������
		RunJavaMethodSqlca("com.amarsoft.proj.action.InitCheckDocEcmImageOpinion","InitOpinionAfterLoan","objectNo="+sObjectNo+",objectType=BusinessLoan");
		var param = "ObjectType=BusinessLoan&ObjectNo="+sObjectNo+"&OperateMode=view";
		AsControl.OpenView("/ImageManage/ImageAfterLoanCheckList.jsp",param,"_blank","");
//	     parent.reloadSelf();
	}
	
	function updateDocOpinion(){
		var sObjectNo = getItemValue(0,getRow(),"SerialNo"); //��ͬ��ˮ��
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert("��ѡ��һ����¼��");
			return;
		}
		var param = "ObjectType=BusinessLoan&ObjectNo="+sObjectNo+"&OperateMode=view";
		AsControl.OpenView("/ImageManage/ImageAfterLoanCheckList.jsp",param,"_blank","");
	}
	
	/*~[Describe=ʹ��OpenComp������;InputParam=��;OutPutParam=��;]~*/
	function viewTab(){
		//����������͡�������ˮ��
		var sObjectNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		sCompID = "CreditTab";
		sCompURL = "/CreditManage/CreditApply/ObjectTab.jsp";
		sParamString = "ObjectType=Business&ObjectNo="+sObjectNo;
		OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
		//reloadSelf(); //update CCS-499 ��������˵��º�ͬ״̬�б����ݳ���һҳ�ģ��鿴ĳҳ��ͬ����������رպ������˵�һҳ  by rqiao 20150331
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