<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%>
 <%@ page import="com.amarsoft.dict.als.cache.CodeCache"%>
<%
	/*
		Author:  yongxu 2015/05/25
		Tester:
		Content: Ӱ��������Ϣ
		Input Param:
		Output param:
		History Log: 
	*/
	
	String PG_TITLE = "Ӱ��������Ϣ";
	CurPage.setAttribute("ShowDetailArea","true");
	CurPage.setAttribute("DetailAreaHeight","450");
	String iButtonsLineMax = "3";
	CurPage.setAttribute("ButtonsLineMax",iButtonsLineMax);
 	//��ȡҳ�����
 	
 	String sObjectNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectNo"));//������
 	String sPhaseNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("PhaseNo"));//�׶α��
 	String sObjectType =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectType"));//������
 	String sFlowNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("FlowNo"));//������
 	
 	String sOperateMode = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("OperateMode"));//��������
 	String ssuretype = Sqlca.getString(new SqlObject("SELECT suretype FROM business_contract WHERE SERIALNO=:SERIALNO").setParameter("SERIALNO", sObjectNo));
 	
 	String sCheckStatus = Sqlca.getString( new SqlObject("Select checkstatus From CHECK_CONTRACT "+
		" Where ContractSerialNo = :SerialNo").setParameter( "SerialNo", sObjectNo ) );
	if( sCheckStatus == null ) sCheckStatus = " ";
 	
	String sCheckResult = Sqlca.getString(new SqlObject("SELECT CheckResult FROM check_contract WHERE CONTRACTSERIALNO=:SERIALNO").setParameter("SERIALNO", sObjectNo));
	if( sCheckResult == null ) sCheckResult = " ";
	
 	if(sObjectNo==null) sObjectNo = "";
 	if(sPhaseNo==null) sPhaseNo = "";
 	if(sObjectType==null) sObjectType = "";
 	
	String typeNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("TypeNo"));
 	String sStartWithId = CurComp.getParameter("StartWithId");
 	if (sStartWithId == null) sStartWithId = "";

	//ͨ��DWģ�Ͳ���ASDataObject����doTemp
	String sTempletNo = "CheckDocImageTypeList";
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	doTemp.multiSelectionEnabled=false;//���ÿɶ�ѡ
	
	doTemp.setVisible("OPINION1,OPINION2,QualityMark1,QualityMark2", false);
	doTemp.setVisible("CHECKOPINION1", true);
	doTemp.setVisible("CHECKOPINION2", true);
	doTemp.setVisible("QualityMarkLoan1", true);
	doTemp.setVisible("QualityMarkLoan2", true);
	
	if("4".equals(sCheckStatus)){//������
		doTemp.setReadOnly("CHECKOPINION2", true);//����ֻ���޸ĳ������
		doTemp.setReadOnly("QualityMarkLoan2", true);
	}else if("7".equals(sCheckStatus)){//���۲���������ɣ�������
		doTemp.setReadOnly("CHECKOPINION1", true);//������ǩ�������
		doTemp.setReadOnly("QualityMarkLoan1", true);
	}else if("5".equals(sCheckStatus)) { // �����д���
		doTemp.setReadOnly("CHECKOPINION2,QualityMarkLoan2", true);
	}else if("1".equals(sCheckStatus) && "1".equals(sCheckResult)){
		doTemp.setReadOnly("CHECKOPINION2,QualityMarkLoan2", true);   //�����ͬ������Ա�޸�������ע
	}else if("1".equals(sCheckStatus) && !"1".equals(sCheckResult)){
		doTemp.setReadOnly("CHECKOPINION1,QualityMarkLoan1", true);   //����ϸ񣬹���Ա�޸�������ע
	}
	
	doTemp.WhereClause += " and ECM_IMAGE_OPINION.TypeNo in (Select ECM_Image_Type.TypeNo from ECM_Image_Type where ECM_Image_Type.isinuse = '1') and ECM_IMAGE_OPINION.ObjectType = 'BusinessLoan' "; 
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.setPageSize(20);

	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sObjectNo+","+sObjectType);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	
	String sButtons[][] = {
		{("view".equals(sOperateMode))?"true":"false","","Button","����","�����¼","saveRecord()",sResourcesPath},
		{"true","","Button","���Ҫ����ʾ","���Ҫ����ʾ","AuditPoints()",sResourcesPath},
		{"true","","Button","���Ӻ�ͬ","���Ӻ�ͬ","createPDF()",sResourcesPath},
		{"true","","Button","�鿴Ħ�г����ݺ�","�鿴Ħ�г����ݺ�","viewMotuoPhoto()",sResourcesPath},
		{("upload".equals(sOperateMode))?"true":"false","","Button","�����������","�����������","imageManage()",sResourcesPath}
	};
	
	String AppUrl4pdf = CodeCache.getItem("PrintAppUrl","0010").getItemAttribute();
	String FCUrl4pdf = CodeCache.getItem("PrintAppUrl","0015").getItemAttribute();
	String sToday = StringFunction.getTodayNow();

%>
<%@include file="/Resources/CodeParts/List0501.jsp"%>

<script type="text/javascript">
	
	function saveRecord()
	{	
		//�ļ����������˱���ʱ��
		var sObjectNo   = "<%=sObjectNo%>";
		var sCheckStatus="<%=sCheckStatus%>";
		var sToday="<%=sToday%>";
		if(sCheckStatus=="4"){ //�����ļ����������󱣴�ʱ��
			RunMethod("���÷���","UpdateColValue","check_contract,savetime3,"+sToday+",contractserialno = '"+sObjectNo+"'");
		}else if(sCheckStatus=="7"){//�����ļ�������鸴�󱣴�ʱ��
			RunMethod("���÷���","UpdateColValue","check_contract,savetime4,"+sToday+",contractserialno = '"+sObjectNo+"'");
		}
		as_save("myiframe0");
//		checkAfterSave();
//		parent.reloadSelf();
	}
 	
	function checkAfterSave(){
		var sObjectNo   = "<%=sObjectNo%>"; //��ͬ��ˮ��
		//��������������
		var sReturn = RunMethod("���÷���","GetColValue","Ecm_Image_Opinion,count(1),ObjectNo='"+sObjectNo+"' and ObjectType = 'BusinessLoan' ");
		//����δ��д�������
		var sReturn4 = RunMethod("���÷���","GetColValue","Ecm_Image_Opinion,count(1),ObjectNo='"+sObjectNo+"' and ObjectType = 'BusinessLoan' and checkopinion1 is null ");
		//����ϸ�����
//		var sReturn1 = RunMethod("���÷���","GetColValue","Ecm_Image_Opinion,count(1),ObjectNo='"+sObjectNo+"' and ObjectType = 'BusinessLoan' and checkopinion1 ='1' ");
		//����ؼ���������
		var sReturn23 = RunMethod("���÷���","GetColValue","Ecm_Image_Opinion,count(1),ObjectNo='"+sObjectNo+"' and ObjectType = 'BusinessLoan' and checkopinion1 ='3' ");
		//����ǹؼ���������
		var sReturn22 = RunMethod("���÷���","GetColValue","Ecm_Image_Opinion,count(1),ObjectNo='"+sObjectNo+"' and ObjectType = 'BusinessLoan' and checkopinion1 ='2'  ");
		//����δ��д�������
		var sReturn5 = RunMethod("���÷���","GetColValue","Ecm_Image_Opinion,count(1),ObjectNo='"+sObjectNo+"' and ObjectType = 'BusinessLoan' and checkopinion2 is null ");
		//����ؼ���������
		var sReturn63 = RunMethod("���÷���","GetColValue","Ecm_Image_Opinion,count(1),ObjectNo='"+sObjectNo+"' and ObjectType = 'BusinessLoan' and checkopinion2 ='3' ");
		//����ǹؼ���������
		var sReturn62 = RunMethod("���÷���","GetColValue","Ecm_Image_Opinion,count(1),ObjectNo='"+sObjectNo+"' and ObjectType = 'BusinessLoan' and checkopinion2 ='2'  ");

		//���״̬
		var sReturn3 = RunMethod("���÷���","GetColValue","BUSINESS_CONTRACT,CHECKSTATUS,SerialNo='"+sObjectNo+"' ");
		if(sReturn3 == "4"){//��һ�μ��
			if(sReturn4==sReturn){
				alert("δ��д�����");
				return false;
			}
			if(sReturn23 > 0){//�йؼ�����
				RunMethod("���÷���","UpdateColValue","BUSINESS_CONTRACT,checkstatus,5,SerialNo='"+sObjectNo+"' ");//��������
				RunMethod("���÷���","UpdateColValue","BUSINESS_CONTRACT,checkresult,3,SerialNo='"+sObjectNo+"' ");//���º�ͬ״̬Ϊ�ؼ�����
			}else if(sReturn22 > 0){//�зǹؼ�����
				RunMethod("���÷���","UpdateColValue","BUSINESS_CONTRACT,checkstatus,5,SerialNo='"+sObjectNo+"' ");//��������
				RunMethod("���÷���","UpdateColValue","BUSINESS_CONTRACT,checkresult,2,SerialNo='"+sObjectNo+"' ");//���º�ͬ״̬Ϊ�ǹؼ�����
			}else{// ���ϸ�
				RunMethod("���÷���","UpdateColValue","BUSINESS_CONTRACT,checkstatus,1,SerialNo='"+sObjectNo+"' ");//���ͨ��
				RunMethod("���÷���","UpdateColValue","BUSINESS_CONTRACT,checkresult,1,SerialNo='"+sObjectNo+"' ");//���º�ͬ״̬Ϊ�ϸ�
			}
		}else if(sReturn3 == "7"){//�ڶ��μ��
			if(sReturn5==sReturn){
				alert("δ��д�����");
				return false;
			}
			if(sReturn63 > 0){//�йؼ�����
				RunMethod("���÷���","UpdateColValue","BUSINESS_CONTRACT,checkstatus,1,SerialNo='"+sObjectNo+"' ");//����Ҳ��ͨ��������
				RunMethod("���÷���","UpdateColValue","BUSINESS_CONTRACT,checkresult,3,SerialNo='"+sObjectNo+"' ");//���º�ͬ״̬Ϊ�ؼ�����
			}else if(sReturn62 > 0){//�зǹؼ�����
				RunMethod("���÷���","UpdateColValue","BUSINESS_CONTRACT,checkstatus,1,SerialNo='"+sObjectNo+"' ");//����Ҳ��ͨ��������
				RunMethod("���÷���","UpdateColValue","BUSINESS_CONTRACT,checkresult,2,SerialNo='"+sObjectNo+"' ");//���º�ͬ״̬Ϊ�ǹؼ�����
			}else{// ���ϸ�
				RunMethod("���÷���","UpdateColValue","BUSINESS_CONTRACT,checkstatus,1,SerialNo='"+sObjectNo+"' ");//���ͨ��
				RunMethod("���÷���","UpdateColValue","BUSINESS_CONTRACT,checkresult,1,SerialNo='"+sObjectNo+"' ");//���º�ͬ״̬Ϊ�ϸ�
			}
		}
	}
	//���Ӻ�ͬ
	function createPDF(){
	    var ssuretype = "<%=ssuretype%>";
	    if (ssuretype == null || ssuretype.length == 0 || ssuretype == "null" || ssuretype == "PC") {
	        alert("�ú�ͬ�ǵ��Ӻ�ͬ!");
	        return;
	    }
	    //ͨ����serverlet ��ҳ��
	    var url= "";
	    var CurOpenStyle = "width=720,height=540,top=20,left=20,toolbar=no,scrollbars=yes,resizable=yes,status=yes,menubar=no,";  
	    if(ssuretype == 'APP'){
	    	url="<%=AppUrl4pdf%>"+"<%=sObjectNo%>";
		    window.open(url,"_blank",CurOpenStyle);
	    }else if(ssuretype == 'FC'){
	    	url="<%=FCUrl4pdf%>"+"<%=sObjectNo%>";
	    	window.open(url,"_blank",CurOpenStyle);
	    }
	}
	
	//�������Ӱ������
	function imageManage(){
		var sObjectNo   = "<%=sObjectNo%>";
		var param = "ObjectType=BusinessLoan&ObjectNo="+sObjectNo+"&uploadPeriod=1";
		AsControl.PopView( "/ImageManage/CheckImageAfterLoanView.jsp", param, "" );
    }
	
	//���Ҫ����ʾ
	function AuditPoints(){
        var sObjectNo   = "<%=sObjectNo%>";        
	     var param = "ObjectType=BusinessLoan&ObjectNo="+sObjectNo;
	     AsControl.PopView( "/ImageManage/ImageTypeListAuditPointsView.jsp", param, "" );
    }
	
	//PAD��Ŀ CRA-372 ���������У����Ӳ鿴Ħ�г����ܺ�ͼƬ����
	//�鿴�����ļ�����
	function viewMotuoPhoto(){
		var sTypeNo = "20029";
		var sObjectType = "Business";
    	var sRightType = "ReadOnly";
    	var sObjectNo   = "<%=sObjectNo%>";
    	var sReturn = RunMethod("���÷���","GetColValue","Ecm_Page,count(1),ObjectNo='"+sObjectNo+"' and TypeNo = '"+sTypeNo+"' ");
    	if(sReturn == 0){
    		alert("�ú�ͬû���ϴ�Ħ�г����ݺ�!");
    		return;
    	}
		OpenPage("/ImageManage/ImageViewInfo.jsp?ObjectType="+sObjectType+"&ObjectNo=<%=sObjectNo%>&TypeNo="+sTypeNo+"&RightType="+sRightType,"DetailFrame","");  
    }
	//�鿴�����ļ�����
	function scanLoan(){
    	var sTypeNo = getItemValue(0,getRow(),"TYPENO");//��ȡѡ�еļ�¼ID	
		if (typeof(sTypeNo)=="undefined" || sTypeNo.length==0){
			alert("��ѡ��һ����¼��");
			return;
		}
    	var sRightType = "ReadOnly";
		OpenPage("/ImageManage/ImageViewInfo.jsp?ObjectType=<%=sObjectType%>&ObjectNo=<%=sObjectNo%>&TypeNo="+sTypeNo+"&RightType="+sRightType+"&uploadPeriod=1","DetailFrame","");  
    }
	function mySelectRow(obj){
		scanLoan();
    }
 	
	function initRecord(){
		var sSeriaslNo = getItemValueArray1(0,"TYPENO");
		var sOpinion1 = getItemValueArray1(0,"OPINION1");
		for(var i = 0; i < sSeriaslNo.length; i ++){
			var tmpTypeNo = sSeriaslNo[i];
			if(tmpTypeNo=="20001" || tmpTypeNo=="20025" || tmpTypeNo=="20002" ){
				setItemValue(0,i,"CHECKOPINION1","1");
				setItemValue(0,i,"CHECKOPINION2","");
				setItemReadOnly1(0,i,"CHECKOPINION1",true);
				setItemReadOnly1(0,i,"CHECKOPINION2",true);
			}
		}
		if(!(sCheckStatus=="1" || sCheckStatus == "5")){
			for(var i = 0; i < sOpinion1.length; i ++){
				var tmpOpinion = sOpinion1[i];
				if(tmpOpinion=="1"){
					setItemValue(0,i,"CHECKOPINION2","");//��������ÿ�
					setItemReadOnly1(0,i,"CHECKOPINION2",true);
				}
			}
		}
		
	}
	
	function setItemReadOnly1(iDW,iRow,sCol,bReadOnly){
		iCol = getColIndex(iDW,sCol);
	//	window.frames["myiframe"+iDW].document.forms[0].elements["R"+iRow+"F"+iCol].readOnly = bReadOnly;
		window.frames["myiframe"+iDW].document.forms[0].elements["R"+iRow+"F"+iCol].setAttribute("disabled","disabeld");
	}

	function getItemValueArray1(iDW,sColumnID){
		var b = getRowCount(iDW);
		var countSelected = 0;
		var sMemberIDTemp = "";
		var sSelected = new Array(1000);
		for(var iMSR = 0 ; iMSR < b ; iMSR++){
			var a = getItemValue(iDW,iMSR,"MultiSelectionFlag");
			if(a == "on"){
				sSelected[countSelected] = getItemValue(iDW,iMSR,sColumnID);
				countSelected++;
			}
		}
		var sReturn = new Array(countSelected);
		for(var iReturnMSR = 0;iReturnMSR < countSelected; iReturnMSR++){
			sReturn[iReturnMSR] = sSelected[iReturnMSR];
		}
		return sReturn;
	}
	
	$(document).ready(function(){
		AsOne.AsInit();
		init();
		my_load(2,0,'myiframe0');
		initRecord();
	});
</script>	

<%@ include file="/IncludeEnd.jsp"%>