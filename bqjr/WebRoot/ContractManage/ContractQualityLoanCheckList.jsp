<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%>
 <%@ page import="com.amarsoft.dict.als.cache.CodeCache"%>
<%
	/*
		Author: daihuafeng 2015-9-30
		Tester:
		Describe: ��ͬ��������-�����ļ�����
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
 	
 	String ssuretype = Sqlca.getString(new SqlObject("SELECT suretype FROM business_contract WHERE SERIALNO=:SERIALNO").setParameter("SERIALNO", sObjectNo));
 	
 	String sCheckStatus = Sqlca.getString( new SqlObject("Select checkstatus From CHECK_CONTRACT "+
		" Where ContractSerialNo = :SerialNo").setParameter( "SerialNo", sObjectNo ) );
	if( sCheckStatus == null ) sCheckStatus = " ";
 	
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
	
	doTemp.WhereClause += " and ECM_IMAGE_OPINION.TypeNo in (Select ECM_Image_Type.TypeNo from ECM_Image_Type where ECM_Image_Type.isinuse = '1') and ECM_IMAGE_OPINION.ObjectType = 'BusinessLoan' "; 
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.setPageSize(20);

	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sObjectNo+","+sObjectType);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	
	String sButtons[][] = {
	};
	
%>
<%@include file="/Resources/CodeParts/List0501.jsp"%>

<script type="text/javascript">
	
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
	var typeNo = "";
	function mySelectRow(obj){
		var sCheckStatus="<%=sCheckStatus%>";
		var sTypeNo = getItemValue(0,getRow(),"TYPENO");//��ȡѡ�еļ�¼ID	
		var sCheckopinion1 = getItemValue(0,getRow(),"CHECKOPINION1");//��ȡѡ�еĳ������
		if(sCheckopinion1 !="2" && sCheckopinion1 !="3" && sCheckStatus == "7"){//����Ϊ�ϸ�
			setItemValue(0,getRow(),"CHECKOPINION2","");//��������ÿ�
			setItemValue(0,getRow(),"QualityMarkLoan2","");//���������ÿ�
			scanLoan();
		}else{
			if(typeNo!=sTypeNo){
				scanLoan();
				typeNo = sTypeNo;
			}
		}
    }
 	
	$(document).ready(function(){
		AsOne.AsInit();
		init();
		my_load(2,0,'myiframe0');
	});
</script>	

<%@ include file="/IncludeEnd.jsp"%>