<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%>
 
 <%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author:
		Tester:
		Content: 
		Input Param:
		Output param:
		History Log: xswang 20150429 CCS-433 PRM-146 ��˶ϵͳ������ϢȨ������
	 */
	%>
<%/*~END~*/%>
 
 <%
	/*
		ҳ��˵��: ��������
	 */
	String PG_TITLE = "��������";

	//���ҳ�����
	String sBoardNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("BoardNo"));
	if(sBoardNo==null) sBoardNo="";

	
	//ͨ��DWģ�Ͳ���ASDataObject����doTemp
	String sTempletNo = "BoardInfo";//ģ�ͱ��
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sBoardNo);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{"true","","Button","����","���������޸�","saveRecord()",sResourcesPath},
		{"true","","Button","�ϴ��ļ�","�ϴ��ļ�","fileadd()",sResourcesPath},
	};
%><%@include file="/Resources/CodeParts/Info05.jsp"%>
<script type="text/javascript">
	var bIsInsert = false; //���DW�Ƿ��ڡ�����״̬��
	function saveRecord(sPostEvents){
		if(bIsInsert){
			setItemValue(0,getRow(),"BoardNo", getSerialNo("BOARD_LIST","BoardNo",""));
			setItemValue(0,getRow(),"DocNo", getSerialNo("DOC_LIBRARY","DocNo",""));
			bIsInsert = false;
		}
		as_save("myiframe0",sPostEvents);
	}
	
	function fileadd(){
		var sDocNo = getItemValue(0,getRow(),"DocNo");
		if(typeof(sDocNo)=="undefined" || sDocNo.length==0) {
			alert("�ȱ�����Ϣ���ϴ��ļ�!");
			return ;
		}else{
			AsControl.PopView("/AppConfig/Document/AttachmentFrame.jsp", "DocNo="+sDocNo, "dialogWidth=650px;dialogHeight=350px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
	    }
	}
	
	//add by xswang 20150429 CCS-433 PRM-146 ��˶ϵͳ������ϢȨ������
	//������������ѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������
	function selectBoardObject(){
		var retVal = setObjectValue("SelectOrg1","","",0,0,"");
		if (typeof(retVal)=="undefined" || retVal=='_CLEAR_') {
			alert("��ѡ�������");
			return;
		}
		var orgName = retVal.split("~");
		var sOrgId = "";
		var sOrgName = "";
		for (var i in orgName) {
			sOrgId += orgName[i].split("@")[0]+",";
			sOrgName += orgName[i].split("@")[1]+",";
		}
		sOrgId = sOrgId.substring(0,sOrgId.length-1);
		setItemValue(0, 0, "BoardObject", sOrgName);
	}
	//end by xswang 20150429

	function initRow(){
		if (getRowCount(0)==0){
			as_add("myiframe0");
			bIsInsert = true;
		}
    }

	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	initRow();
</script>	
<%@ include file="/IncludeEnd.jsp"%>