<%@page import="com.amarsoft.app.billions.CommonConstans"%>
<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		ҳ��˵��: ʾ���б�ҳ��
	 */
	String PG_TITLE = "ʾ���б�ҳ��";
	//���ҳ�����
	String sSSerialNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SSerialNo"));
	String sSNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SNo"));
	String sStatus =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("Status"));
	String sFlag =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("sFlag"));

	
	if(sSSerialNo==null) sSSerialNo="";
	if(sFlag == null) sFlag = ""; 

	
	//ͨ��DWģ�Ͳ���ASDataObject����doTemp
	String sTempletNo = "StorePostStoreList";//ģ�ͱ��
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);

	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.setPageSize(10);

	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sSNo);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		//  ����  ����  �ر�  ��ʱ�ر�  ȡ���ر�
			{"true","","Button","����","����һ����¼","newRecord()",sResourcesPath},
			{"true","","Button","����","�鿴/�޸�����","viewAndEdit()",sResourcesPath},
			{"true","","Button","ɾ��","ɾ��","deleteRecord()",sResourcesPath},
	};
	
	//add CCS-884 �ر�״̬���ر��水ť tangyb 20150720
	if("06".equals(sStatus)){
		sButtons[0][0]="false";
		sButtons[2][0]="false";
	}
	if("CountAndCheck".equals(sFlag)){
		sButtons[0][0] ="false";
		sButtons[1][0] ="false";
		sButtons[2][0] ="false";
    }
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">

	function newRecord(){
		AsControl.OpenView("/BusinessManage/StoreManage/PostStoreInfo.jsp","SSerialNo=<%=sSSerialNo %>&SNo=<%=sSNo%>","_self","");
	}
	
	function deleteRecord(){
		var sSerialNo = getItemValue(0,getRow(),"SERIALNO");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert("��ѡ��һ����¼��");
			return;
		}
		
		if(confirm("�������ɾ������Ϣ��")){
			as_del("myiframe0");
			as_save("myiframe0");  //�������ɾ������Ҫ���ô����
		}
		reloadSelf();
	}

	function viewAndEdit(){
		var sSerialNo = getItemValue(0,getRow(),"SERIALNO");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert("��ѡ��һ����¼��");
			return;
		}
		AsControl.OpenView("/BusinessManage/StoreManage/PostStoreInfo.jsp","SerialNo="+sSerialNo+"&ActionType=<%=CommonConstans.VIEW_DETAIL %>&Status=<%=sStatus %>","_blank","");
		reloadSelf();
	}
	
	<%/*~[Describe=ʹ��ObjectViewer��;InputParam=��;OutPutParam=��;]~*/%>
	function openWithObjectViewer(){
		var sExampleId = getItemValue(0,getRow(),"ExampleId");
		if (typeof(sExampleId)=="undefined" || sExampleId.length==0){
			alert("��ѡ��һ����¼��");
			return;
		}
		
		AsControl.OpenObject("Example",sExampleId,"001");//ʹ��ObjectViewer����ͼ001��Example��
	}

	$(document).ready(function(){
		AsOne.AsInit();
		showFilterArea();
		init();
		my_load(2,0,'myiframe0');
	});
</script>	
<%@ include file="/IncludeEnd.jsp"%>