<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%
	/* --ҳ��˵��: ʾ������ҳ��-- */
	String PG_TITLE = "ʾ������ҳ��";

	// ���ҳ�����
	String sMethodName =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("methodName"));
	String sClassName =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("className"));
	if(sMethodName==null) sMethodName="";
	if(sClassName==null) sClassName="";
    String className="";
	
	// ͨ��DWģ�Ͳ���ASDataObject����doTemp
	String sTempletNo = "MethodCategoryInfo";//ģ�ͱ��
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	if(sMethodName.equals("")){
		className="��������";
		doTemp.WhereClause+=" and 1=2";
	}else{
		 className=sClassName;
		doTemp.WhereClause+=" and CLASSNAME='"+className+"' and methodName='"+sMethodName+"'";
	}
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      // ����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; // �����Ƿ�ֻ�� 1:ֻ�� 0:��д
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");//�������,���ŷָ�
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{"true","","Button","����","���������޸�","saveRecord()",sResourcesPath},
		{"false","","Button","���沢����","���沢�����б�","saveAndGoBack()",sResourcesPath},
		{"true","","Button","����","�����б�ҳ��","goBack()",sResourcesPath}
	};
%>
<%@include file="/Resources/CodeParts/Info05.jsp"%>
<script type="text/javascript">
	var bIsInsert = false; // ���DW�Ƿ��ڡ�����״̬��
	
	<%/*~[Describe=���������Ƿ��Ѿ�����;]~*/%>
	function checkFlowExists() {
		var methodName = getItemValue(0, 0, "METHODNAME");
		if (typeof(methodName)=='undefined' || methodName.length==0) {
			return;
		}
		
		var methodName1 = RunMethod("���÷���", "GetColValue", "class_method,methodName,className='<%=className%>' and methodName='"+methodName+"'");
		//alert(sFlowNo1+"|"+typeof(sFlowNo1));
		if (methodName1!="Null" && methodName1.length>0) {
			alert("�÷������Ѿ����ڣ����������룡");
			setItemValue(0, 0, "METHODNAME", "");
		}
		return;
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
		AsControl.OpenView("/SystemManage/CarManage/MethodCategoryList.jsp","","_self");
		parent.reloadSelf();
	}

	<%/*~[Describe=ִ�в������ǰִ�еĴ���;]~*/%>
	function beforeInsert(){
		bIsInsert = false;
	}
	
	<%/*~[Describe=ִ�и��²���ǰִ�еĴ���;]~*/%>
	function beforeUpdate(){
	}
	
	function initRow(){
		if (getRowCount(0)==0){//�統ǰ�޼�¼��������һ��
			as_add("myiframe0");
			setItemValue(0, 0, "CLASSNAME", "<%=className%>");
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
