<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%>
 <%@ page import="com.amarsoft.dict.als.cache.CodeCache"%>
<%
	/*
		Author:  xswang 2015/05/25
		Tester:
		Content: Ӱ��������Ϣ
		Input Param:
		Output param:
		History Log: 
	*/
	
	String PG_TITLE = "Ӱ��������Ϣ";
	CurPage.setAttribute("ShowDetailArea","true");
	CurPage.setAttribute("DetailAreaHeight","450");
	String iButtonsLineMax = "4";
	CurPage.setAttribute("ButtonsLineMax",iButtonsLineMax);
 	//��ȡҳ�����
 	
 	String sObjectNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectNo"));//������
 	String sPhaseNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("PhaseNo"));//�׶α��
 	String sObjectType =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectType"));//������
 	String sFlowNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("FlowNo"));//������
 	
 	String ssuretype = Sqlca.getString(new SqlObject("SELECT suretype FROM business_contract WHERE SERIALNO=:SERIALNO").setParameter("SERIALNO", sObjectNo));
	String sCheckDocStatus = Sqlca.getString(new SqlObject("SELECT CheckDocStatus FROM check_contract WHERE CONTRACTSERIALNO=:SERIALNO").setParameter("SERIALNO", sObjectNo));
 	
	String sCheckDocResult = Sqlca.getString(new SqlObject("SELECT CheckDocResult FROM check_contract WHERE CONTRACTSERIALNO=:SERIALNO").setParameter("SERIALNO", sObjectNo));
	
 	String sBusinessType = Sqlca.getString( new SqlObject("Select BusinessType From BUSINESS_CONTRACT "+
		" Where SerialNo = :SerialNo").setParameter( "SerialNo", sObjectNo ) );
	if( sBusinessType == null ) sBusinessType = " ";
 	
 	if(sObjectNo==null) sObjectNo = "";
 	if(sPhaseNo==null) sPhaseNo = "";
 	if(sObjectType==null) sObjectType = "";
 	
	String typeNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("TypeNo"));
 	String sStartWithId = CurComp.getParameter("StartWithId");
 	if (sStartWithId == null) sStartWithId = "";

	//ͨ��DWģ�Ͳ���ASDataObject����doTemp
	String sTempletNo = "CheckDocImageTypeList";
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	doTemp.multiSelectionEnabled=true;//���ÿɶ�ѡ

	if("7".equals(sCheckDocStatus)){//������
		doTemp.setReadOnly("OPINION1,DESCRIBE1,QualityMark1", true);//����ֻ���޸ĸ������
	}
/* 	else if("4".equals(sCheckDocStatus)){//���۲�������
		doTemp.setReadOnly("OPINION1,OPINION2,QualityMark1,QualityMark2,DESCRIBE1,remark", true);//���۶˲���ǩ���κ����
	} */  
	//��������Ҳ�����޸������ȼ���������עCRA-289 
	else if("4".equals(sCheckDocStatus)){
		doTemp.setReadOnly("OPINION2,QualityMark2", true);//������ǩ�������
	}
	else if("2".equals(sCheckDocStatus)){//������
		doTemp.setReadOnly("OPINION2,QualityMark2", true);//������ǩ�������
	}else if("3".equals(sCheckDocStatus) && "1".equals(sCheckDocResult)){
		doTemp.setReadOnly("OPINION2,QualityMark2", true);
	}else if("3".equals(sCheckDocStatus) && !"1".equals(sCheckDocResult)){
		doTemp.setReadOnly("OPINION1,QualityMark1", true);
	}else if("5".equals(sCheckDocStatus)){
		doTemp.setReadOnly("OPINION1,QualityMark1", true);
	}
	
	doTemp.WhereClause += " and ECM_IMAGE_OPINION.TypeNo in (Select ECM_Image_Type.TypeNo from ECM_Image_Type where ECM_Image_Type.isinuse = '1') "; 
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
	//	{sCheckDocStatus.equals("4")?"false":"true","","Button","����","�����¼","saveRecord()",sResourcesPath},
		{"true","","Button","����","�����¼","saveRecord()",sResourcesPath},  
		{"true","","Button","���Ҫ����ʾ","���Ҫ����ʾ","AuditPoints()",sResourcesPath},
		{"true","","Button","���Ӻ�ͬ","���Ӻ�ͬ","createPDF()",sResourcesPath},
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
		var sCheckDocStatus="<%=sCheckDocStatus%>";
		var sToday="<%=sToday%>";
		if(sCheckDocStatus == "2"){//�����ļ����������󱣴�ʱ��
			RunMethod("���÷���","UpdateColValue","check_contract,savetime1,"+sToday+",contractserialno = '"+sObjectNo+"'");
		}else if(sCheckDocStatus == "7"){//�����ļ�������鸴�󱣴�ʱ��
			RunMethod("���÷���","UpdateColValue","check_contract,savetime2,"+sToday+",contractserialno = '"+sObjectNo+"'");
		}
		as_save("myiframe0");
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
	
	//���Ҫ����ʾ
	function AuditPoints(){
        var sObjectNo   = "<%=sObjectNo%>";        
	     var param = "ObjectType=Business&TypeNo=20&ObjectNo="+sObjectNo;
	     AsControl.PopView( "/ImageManage/ImageTypeListAuditPointsView.jsp", param, "" );
    }
	
	//�鿴�ļ�����
	function scanLoan(){
    	var sTypeNo = getItemValue(0,getRow(),"TYPENO");//��ȡѡ�еļ�¼ID	
		if (typeof(sTypeNo)=="undefined" || sTypeNo.length==0){
			alert("��ѡ��һ����¼��");
			return;
		}
    	var sRightType = "ReadOnly";
		var param = "ObjectType=<%=sObjectType%>&ObjectNo=<%=sObjectNo%>&TypeNo="+sTypeNo+"&RightType="+sRightType;
		OpenPage("/ImageManage/ImageViewInfo.jsp?ObjectType=<%=sObjectType%>&ObjectNo=<%=sObjectNo%>&TypeNo="+sTypeNo+"&RightType="+sRightType,"DetailFrame",""); 
    }
	
	function mySelectRow(obj){
		scanLoan();
    }
 	
	function initRecord(){
		var sSeriaslNo = getItemValueArray1(0,"TYPENO");
		var sOpinion1 = getItemValueArray1(0,"OPINION1");
		var sCheckDocStatus = "<%=sCheckDocStatus%>";    
		for(var i = 0; i < sSeriaslNo.length; i ++){
			var tmpTypeNo = sSeriaslNo[i];
			if(tmpTypeNo=="20001" || tmpTypeNo=="20025" || tmpTypeNo=="20002" ){
				setItemValue(0,i,"OPINION1","1");//��������ÿ�
				setItemValue(0,i,"OPINION2","");//��������ÿ�
				setItemReadOnly1(0,i,"OPINION1",true);
				setItemReadOnly1(0,i,"OPINION2",true);
			}
		}
		if(!(sCheckDocStatus=="3" || sCheckDocStatus=="4" || sCheckDocStatus=="5")){
			for(var i = 0; i < sOpinion1.length; i ++){
				var tmpOpinion = sOpinion1[i];
				if(tmpOpinion=="1"){
					setItemValue(0,i,"OPINION2","");//��������ÿ�
					setItemReadOnly1(0,i,"OPINION2",true);
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