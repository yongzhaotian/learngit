<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%

	String PG_TITLE = "�ʲ�ת��Э���б�ҳ��";
	//���ҳ�����
	String sSerialNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
	if(sSerialNo==null) sSerialNo="";
	
	
	String sRelaSerialNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("RelaSerialNo"));
	if(sRelaSerialNo==null) sRelaSerialNo="";
	
	String sApplyType =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ApplyType"));
	if(sApplyType==null) sApplyType="";
	
	
	
	//ͨ��DWģ�Ͳ���ASDataObject����doTemp
	ASDataObject doTemp = new ASDataObject("ContractDealList",Sqlca);
		
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
		
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.setPageSize(10);
	dwTemp.ShowSummary = "1";//���û���

	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sRelaSerialNo);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{"true","","Button","��ͬ����","��ͬ����","viewtab()",sResourcesPath},
		{"false","","Button","ɾ��","ɾ���ʲ�ת��Э��","deleteRecord()",sResourcesPath},
		{"true","","Button","��ͬ����","��ͬ����","ContractImport()",sResourcesPath},
	};


%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
	/*~��ͬ������~*/
	function viewtab(){
		//����������͡�������ˮ��
		var sObjectType = "BusinessContract";
		var sObjectNo = getItemValue(0,getRow(),"ContractSerialNo");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		sCompID = "CreditTab";
		sCompURL = "/CreditManage/CreditApply/ObjectTab.jsp";
		sParamString = "ObjectType="+sObjectType+"&ObjectNo="+sObjectNo;
		OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
		reloadSelf();
	}
	
	function ContractImport(){
		var serialNo = "<%=sSerialNo%>";
		var sRelaSerialNo = "<%=sRelaSerialNo%>";
		var sReturn  = RunMethod("���÷���","GetColValue","dealcontract_reative,count(*),SerialNo='"+sRelaSerialNo+"'");
		if(typeof(sReturn)!="undefined"&&parseInt(sReturn)>0){
			if(!confirm("���ʲ������Ѵ��ں�ͬ����,\nȷ�����������ͬ���ݣ�")){
				return;
			}
		}
		//�ļ��ϴ�
		AsControl.PopView("/BusinessManage/CollectionManage/TransferDealImportInfo.jsp", "ObjectNo="+serialNo+",RelaSerialNo="+sRelaSerialNo, "dialogWidth=450px;dialogHeight=250px;resizable=no;scrollbars=no;status:no;maximize:no;help:no;");
		reloadSelf();
	}
	
	function deleteRecord(){
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert("��ѡ��һ����¼��");
			return;
		}
		
		if(confirm("�������ɾ������Ϣ��")){
			as_del("myiframe0");
			as_save("myiframe0");  //�������ɾ������Ҫ���ô����
		}
	//	reloadSelf();
	}
	
	$(document).ready(function(){
		hideFilterArea();
		AsOne.AsInit();
		init();
		my_load_show(2,0,'myiframe0');
	});
</script>	
<%@ include file="/IncludeEnd.jsp"%>