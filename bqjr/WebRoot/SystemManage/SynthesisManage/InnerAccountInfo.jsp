<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

	<%
	String PG_TITLE = "�ڲ��˻�����"; // ��������ڱ��� <title> PG_TITLE </title>

	//���ҳ�����	
	String sAccountNo = DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("CoreAccountNo")));
	String sOrgID = DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("OrgID")));
	String sCurrency = DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("Currency")));
	String sAccountType = DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("AccountType")));
	if(sAccountNo==null||sAccountNo.length()==0)sAccountNo="";
	if(sOrgID==null||sOrgID.length()==0)sOrgID="";
	if(sCurrency==null||sCurrency.length()==0)sCurrency="";
	if(sAccountType==null||sAccountType.length()==0)sAccountType="";

	//ͨ����ʾģ�����ASDataObject����doTemp
	String sTempletNo = "InnerAccountInfo";
	String sTempletFilter = "1=1";
	
	ASDataObject doTemp = new ASDataObject(sTempletNo,sTempletFilter,Sqlca);

	ASDataWindow dwTemp = new ASDataWindow(CurPage, doTemp, Sqlca);
	dwTemp.Style = "2";//����DW���
	dwTemp.ReadOnly = "0";//�����Ƿ�ֻ��
	
	Vector vTemp = dwTemp.genHTMLDataWindow(sAccountNo+","+sOrgID+","+sCurrency+","+sAccountType);
	for (int i = 0; i < vTemp.size(); i++)
	out.print((String) vTemp.get(i));

	String sButtons[][] = { 
		{"true","","Button","����","���������޸�","saveRecord()",sResourcesPath },
	};
	%> 


	<%@include file="/Resources/CodeParts/Info05.jsp"%>


<script language=javascript>
	var bIsInsert = false;	//�ж��Ƿ�Ϊ���	< ���� >

	/*~[Describe=������Ϣ;InputParam=��;OutPutParam=��;]~*/
	function saveRecord(sPostEvents) {
	
		if( !vI_all("myiframe0") ) return;
		
		if(bIsInsert ) {
			if( isExist() ) return;
			bIsInsert = false;
		}
		as_save("myiframe0","self.close();");
		
	}
	
	/*~[Describe=�����б�ҳ��;InputParam=��;OutPutParam=��;]~*/
	</script>

<script language=javascript>

	/*~[Describe=����ҳ��ʱ��ʼ��;InputParam=��;OutPutParam=��;]~*/
	function initRow() {
		//���û���ҵ���Ӧ��¼��������һ�����������ֶ�Ĭ��ֵ
		if (getRowCount(0)==0) {
			as_add("myiframe0");//������¼
			bIsInsert = true ;
		}
    }
    
   	/*~[Describe=ѡ�����;InputParam=��;OutPutParam=��;]~*/
	function selectAllOrg() {
		setObjectValue("SelectAllOrg","","@OrgID@0@OrgName@1",0,0,"");
	}
	
	/*~[Describe=�ж��ʺ��Ƿ��Ѵ���;InputParam=��;OutPutParam=��;]~*/
	function isExist(){
		var sAccountNo = getItemValue(0,getRow(),"CoreAccountNo");
		var sCurrency = getItemValue(0,getRow(),"Currency");
		var sReturn = RunMethod("PublicMethod","GetColValue","Count(*),acct_core_account,String@CoreAccountNo@"+sAccountNo+"@String@Currency@"+sCurrency);
    	if(sReturn.split("@")[1]!="0")
        {
    		alert("�û��˺��Ѿ�����!");
    		return true;
    	}
	}
		 
</script>

<script language=javascript>	
	AsOne.AsInit();
	init();
	//var bFreeFormMultiCol = true;
	my_load(2,0,'myiframe0');
	initRow();
</script>

<%@ include file="/IncludeEnd.jsp"%>
