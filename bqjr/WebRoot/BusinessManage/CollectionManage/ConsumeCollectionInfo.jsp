<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%
	/* --ҳ��˵��: ʾ������ҳ��-- */
	String PG_TITLE = "��������Ǽǽ���������";

	// ���ҳ�����
	String sSerialNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));//���ս���ǼǺ�
	if(sSerialNo==null)sSerialNo="";
	
	
	// ͨ��DWģ�Ͳ���ASDataObject����doTemp
	String sTempletNo = "ConsumeCollectionInfo";//ģ�ͱ��
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	doTemp.setVisible("INPUTUSERID,INPUTORGID,UPDATEUSERID,UPDATEORGID,EXECUTORUSERID", false);
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      // ����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; // �����Ƿ�ֻ�� 1:ֻ�� 0:��д
	//<input class=\"inputdate\" value=\"...\" type=button onclick=parent.getRegionCode(\"\")>
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sSerialNo);//�������,���ŷָ�
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{"true","","Button","����","�����б�ҳ��","goBack()",sResourcesPath}
	};
%>
<%@include file="/Resources/CodeParts/Info05.jsp"%>
<script type="text/javascript">
	var bIsInsert = false; // ���DW�Ƿ��ڡ�����״̬��
	
	//ѡ������ж�����
	function getSubExecutorCode(){
		var sExecutorCode = getItemValue(0,getRow(),"EXECUTORCODE");//һ���ж����� 
		if (typeof(sExecutorCode)=="undefined" || sExecutorCode.length==0){
			alert("����ѡ��һ���ж�������ѡ������ж����룡");
			return;
		}
		
		var sSubExecutorCode = AsControl.PopPage("/SystemManage/ConsumeLoanManage/ActionCodeList.jsp", "ExecutorCode="+sExecutorCode+"&IsSelected=true", "");
		if (typeof(sSubExecutorCode)=="undefined" || sSubExecutorCode.length==0){
			alert("����ѡ��һ�");
			return;
		}
		setItemValue(0,0,"SUBEXECUTORCODE",sSubExecutorCode);
	}
	function saveRecord(sPostEvents){
		if(bIsInsert){
			beforeInsert();
		}
		beforeUpdate();
		as_save("myiframe0",sPostEvents);
	}
	
	function saveAndGoBack(){
		saveRecord("goBack()");
	}
	
	function goBack(){
		AsControl.OpenView("/BusinessManage/CollectionManage/ConsumeCollectionList.jsp","","_self");
	}

	<%/*~[Describe=ִ�в������ǰִ�еĴ���;]~*/%>
	function beforeInsert(){
		bIsInsert = false;
	}
	
	<%/*~[Describe=ִ�и��²���ǰִ�еĴ���;]~*/%>
	function beforeUpdate(){
		
	}
	
	function initSerialNo(){
		var sSerialNo = getSerialNo("CONSUME_COLLECTIONREGIST_INFO","SERIALNO");// ��ȡ��ˮ��
		setItemValue(0,getRow(),"SERIALNO",sSerialNo);
	}
	function initRow(){
		if (getRowCount(0)==0){//�統ǰ�޼�¼��������һ��
			as_add("myiframe0");
			initSerialNo();
			bIsInsert = true;
		}
    }
	
	$(document).ready(function(){
		AsOne.AsInit();
		init();
		bFreeFormMultiCol = false;
		my_load(2,0,'myiframe0');
		initRow();
	});
</script>
<%@ include file="/IncludeEnd.jsp"%>
