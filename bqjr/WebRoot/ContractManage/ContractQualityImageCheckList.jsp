<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%>
 <%@ page import="com.amarsoft.dict.als.cache.CodeCache"%>
<%
	/*
		Author: daihuafeng 2015-9-30
		Tester:
		Describe: ��ͬ��������-Ӱ���ͬ����
	*/
	
	String PG_TITLE = "Ӱ��������Ϣ";
	CurPage.setAttribute("ShowDetailArea","true");
	CurPage.setAttribute("DetailAreaHeight","450");
	String iButtonsLineMax = "4";
	CurPage.setAttribute("ButtonsLineMax",iButtonsLineMax);
 	//��ȡҳ�����
 	
 	String sObjectNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectNo"));//������
 	String sObjectType =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectType"));//������
 	
 	String ssuretype = Sqlca.getString(new SqlObject("SELECT suretype FROM business_contract WHERE SERIALNO=:SERIALNO").setParameter("SERIALNO", sObjectNo));
	String sCheckDocStatus = Sqlca.getString(new SqlObject("SELECT CheckDocStatus FROM check_contract WHERE CONTRACTSERIALNO=:SERIALNO").setParameter("SERIALNO", sObjectNo));
 	
 	String sBusinessType = Sqlca.getString( new SqlObject("Select BusinessType From BUSINESS_CONTRACT "+
		" Where SerialNo = :SerialNo").setParameter( "SerialNo", sObjectNo ) );
	if( sBusinessType == null ) sBusinessType = " ";
 	
 	if(sObjectNo==null) sObjectNo = "";
 	if(sObjectType==null) sObjectType = "";
 	
	String typeNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("TypeNo"));
 	String sStartWithId = CurComp.getParameter("StartWithId");
 	if (sStartWithId == null) sStartWithId = "";

	//ͨ��DWģ�Ͳ���ASDataObject����doTemp
	String sTempletNo = "CheckDocImageTypeList";
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	doTemp.multiSelectionEnabled=false;//���ÿɶ�ѡ
	
	doTemp.WhereClause += " and ECM_IMAGE_OPINION.TypeNo in (Select ECM_Image_Type.TypeNo from ECM_Image_Type where ECM_Image_Type.isinuse = '1') "; 
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
	
	var typeNo = "";
	function mySelectRow(obj){
		var sCheckDocStatus="<%=sCheckDocStatus%>";
		var sTypeNo = getItemValue(0,getRow(),"TYPENO");//��ȡѡ�еļ�¼ID	
		var sOpinion1 = getItemValue(0,getRow(),"OPINION1");//��ȡѡ�еĳ������
		if(sOpinion1 !="2" && sCheckDocStatus == "7"){//����Ϊ�ϸ�
			setItemValue(0,getRow(),"OPINION2","");//��������ÿ�
			setItemValue(0,getRow(),"QualityMark2","");//���������ÿ�
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