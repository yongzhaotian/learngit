<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%
	/* ҳ��˵��: ʾ������ҳ�� */
	String PG_TITLE = "����ת��";

	// ���ҳ�����
	String sCity =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("City"));
	String sSNO =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SNO"));
	if(sCity == null) sCity = "";
	if(sSNO == null) sSNO = "";
	
	// ͨ��DWģ�Ͳ���ASDataObject����doTemp
	String sTempletNo = "UpdateManagerInfo";//ģ�ͱ��
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      // ����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; // �����Ƿ�ֻ�� 1:ֻ�� 0:��д
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");//�������,���ŷָ�
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{"true","","Button","ȷ��","ȷ��","saveRecord()",sResourcesPath},
		{"false","","Button","���沢����","���沢�����б�","saveAndGoBack()",sResourcesPath},
		{"true","","Button","ȡ��","ȡ�� ","goBack()",sResourcesPath},
	};
%>
<%@include file="/Resources/CodeParts/Info05.jsp"%>
<script type="text/javascript">

/*~[Describe=��Ч����Ҫ���ڵ��ڽ���;InputParam=��;OutPutParam=��;]~*/
	function datecheck() {
		var sMoveDate = getItemValue(0, 0, "moveDate");
		sMoveDate = sMoveDate.split("/");//�õ���ʱ��ؼ���ʽ��yyyy/MM/dd
		//var sEndTime = getItemValue(0, 0, "endDate");
		//��Ϊ��ǰʱ����·���Ҫ+1�����ڴ�-1����Ȼ�͵�ǰʱ�����Ƚϻ��жϴ���
		var MoveDate = new Date(sMoveDate[0], sMoveDate[1] - 1, sMoveDate[2]);
		var now = new Date();//��ǰʱ��
		if (MoveDate < now && !( sMoveDate[0] == now.getFullYear() && sMoveDate[1] == (now.getMonth() + 1) && sMoveDate[2] == now.getDate() )) {
			alert("��Ч�ձ�����ڵ��ڽ��죡");
			return 1;
		}
		return 0;
	}

/*~[Describe=������ѡ��ѡ��������Ա;InputParam=��;OutPutParam=��;]~*/
	function selectSalesmanSingle() {
		sCity="<%=sCity%>";
		var sRetVal = setObjectValue("SelectSalesmanSingleByCity", "City,"+ sCity, "", 0, 0, "");
		if (typeof(sRetVal)=="undefined" || sRetVal=="_CLEAR_" || sRetVal.length==0) {
			return;
		}
	
		setItemValue(0, 0, "SALESMANAGER", sRetVal.split("@")[0]);
		setItemValue(0, 0, "SALESMANAGERNAME", sRetVal.split("@")[1]);
		return;
	}
	
	function saveRecord(sPostEvents){
		var sSalesManager = getItemValue(0,getRow(),"SALESMANAGER");	
		if (typeof(sSalesManager)=="undefined" || sSalesManager.length==0) {
			alert("����ѡ��һ���µ����۾���");
			return;
		}
		if(confirm("��ȷ����ԭ���۾����µ��������۴�������ת�Ƶ������۾�������")){
			beforeUpdate();
		}
	}
	
	function saveAndGoBack(){
		self.close();
	}
	
	function goBack(){
		
		//AsControl.OpenView("/BusinessManage/StoreManage/StoreList.jsp", "", "_self","");
		top.close();
	}

	<%/*~[Describe=ִ�в������ǰִ�еĴ���;]~*/%>
	function beforeInsert(){
		
		setItemValue(0,0,"INPUTORG","<%=CurOrg.orgID%>");
		setItemValue(0,0,"INPUTUSER","<%=CurUser.getUserID()%>");
		setItemValue(0,0,"INPUTDATE","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd")%>");

		bIsInsert = false;
	}
	
	<%/*~[Describe=ִ�и��²���ǰִ�еĴ���;]~*/%>
	function beforeUpdate(){
		var moveDate = getItemValue(0,getRow(),"moveDate");
		var sParam = "sNo=<%=sSNO%>,newSalesManager="+getItemValue(0, 0, "SALESMANAGER")+",moveDate="+moveDate+",userid=<%=CurUser.getUserID()%>,orgid=<%=CurOrg.orgID%>";
		var retResult = RunJavaMethodSqlca("com.amarsoft.app.billions.StoreManagerRelativeCommon", "updateAllManager", sParam);
		if("SUCESS"==retResult){
			alert("���ĳɹ���");
		}
		self.close();
	}
	
	function initRow(){
		if (getRowCount(0)==0){//�統ǰ�޼�¼��������һ��
			as_add("myiframe0");
			bIsInsert = true;
		}
		
    }
	
	$(document).ready(function(){
		AsOne.AsInit();
		init();
		bFreeFormMultiCol = true;
		my_load(2,0,'myiframe0');
		initRow();
	});
</script>
<%@ include file="/IncludeEnd.jsp"%>
