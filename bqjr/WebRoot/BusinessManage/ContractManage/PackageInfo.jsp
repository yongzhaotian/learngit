<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%
	/* ҳ��˵��: ʾ������ҳ�� */
	String PG_TITLE = "ע�Ჿ��������ҳ��";

	// ���ҳ�����
	String sPackNo =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("PackNo"));

	if(sPackNo==null) sPackNo="";

	
	// ͨ��DWģ�Ͳ���ASDataObject����doTemp
	String sTempletNo = "PackagePostInfo";//ģ�ͱ��
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      // ����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; // �����Ƿ�ֻ�� 1:ֻ�� 0:��д
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sPackNo);//�������,���ŷָ�
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{"true","","Button","����","���������޸�","saveRecord()",sResourcesPath},
		{"false","","Button","����","�����б�ҳ��","goBack()",sResourcesPath},
	};
%>
<%@include file="/Resources/CodeParts/Info05.jsp"%>
<script type="text/javascript">
	var bIsInsert = false; // ���DW�Ƿ��ڡ�����״̬��
	
	/*~[Describe=��ȡ������ˮ��;InputParam=��;OutPutParam=��;]~*/
	function getSerialNo(sTableName,sColumnName,sPrefix){
		//ʹ��GetSerialNo.jsp����ռһ����ˮ��
		if(typeof(sPrefix)=="undefined" || sPrefix=="") sPrefix="";
		return RunJspAjax("/Frame/page/sys/GetSerialNo.jsp?TableName="+sTableName+"&ColumnName="+sColumnName+"&Prefix="+sPrefix);
	}
	
	function saveRecord(sPostEvents){
		as_save("myiframe0",sPostEvents);
	}

	function goBack(){
		//AsControl.OpenView("/BusinessManage/ContractManage/MailingPackageList.jsp","","_self");
	}
	
	/*~[Describe=����������ѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/
	function selectCreditPerson()
	{
		setObjectValue("SelectCreditPersonInfo","","@CreditPerson@0@CreditID@1",0,0,"");
	}

	
	function initRow(){
		if (getRowCount(0)==0){//�統ǰ�޼�¼��������һ��
			as_add("myiframe0");
			var serialNo = getSerialNo("Package_Info","PackNo");// ��ȡ��ˮ��
			setItemValue(0,getRow(),"PackNo",serialNo);
			//�������ͣ�02ע�Ჿ����
			setItemValue(0,0,"PackType","02");
			//����״̬��01���ʼģ�02���ʼ�
			setItemValue(0,0,"Status","01");
			
			setItemValue(0,0,"CreateUser","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"CreateUserName","<%=CurUser.getUserName()%>");
			setItemValue(0,0,"CreateDate","<%=StringFunction.getToday()%>");
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
