<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		ҳ��˵��: ʾ���б�ҳ��
	 */
	String PG_TITLE = "��Ӧ��ͬ�����Ϣ�б�";
	//���ҳ�����
	//String sInputUser =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("InputUser"));
	//if(sInputUser==null) sInputUser="";
	
	String sSerialNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("SerialNo"));	//�ʲ���ˮ��
	String sAssetStatus = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("AssetStatus"));
	if(sSerialNo == null) sSerialNo = "";	
	if(sAssetStatus == null ) sAssetStatus = "";
	//ͨ��DWģ�Ͳ���ASDataObject����doTemp
	String sTempletNo = "PDARelativeContractList";//ģ�ͱ��
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);

	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.setPageSize(20);

	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sSerialNo);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	String sButtons[][] = {
		{sAssetStatus.equals("04")?"false":"true","","Button","����","����һ����ͬ��Ϣ","newRecord()",sResourcesPath},
		{"true","","Button","����","�鿴/�޸�����","viewAndEdit()",sResourcesPath},
		{"true","","Button","��ͬ����","�쿴��ͬ����","my_Contract()",sResourcesPath}	,
		{sAssetStatus.equals("04")?"false":"true","","Button","ɾ��","ɾ����ѡ�еļ�¼","deleteRecord()",sResourcesPath}		
		};
	%> 
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">

	//---------------------���尴ť�¼�------------------------------------
	/*~[Describe=������¼;InputParam=��;OutPutParam=SerialNo;]~*/
	function newRecord()
	{
		var sRelativeContractNo = "";	
		//��ȡ��ծ�ʲ������ĺ�ͬ��ˮ��	
		var sContractInfo = setObjectValue("SelectRelativeContract","","@RelativeContract@0",0,0,"");
		if(typeof(sContractInfo) != "undefined" && sContractInfo != "" && sContractInfo != "_NONE_" 
		&& sContractInfo != "_CLEAR_" && sContractInfo != "_CANCEL_")  
		{
			sContractInfo = sContractInfo.split('@');
			sRelativeContractNo = sContractInfo[0];
		}		
		if(sRelativeContractNo == "" || typeof(sRelativeContractNo) == "undefined") return;
		{	
			sSerialNo = "<%=sSerialNo%>";			
			popComp("PDARelativeContractInfo","/RecoveryManage/PDAManage/PDADailyManage/PDARelativeContractInfo.jsp","ContractSerialNo="+sRelativeContractNo+"&SerialNo="+sSerialNo);
			reloadSelf();
		}
	}
	
	/*~[Describe=ɾ����¼;InputParam=��;OutPutParam=��;]~*/
	function deleteRecord()
	{
		sContractSerialNo = getItemValue(0,getRow(),"ContractSerialNo");
		if (typeof(sContractSerialNo) == "undefined" || sContractSerialNo.length == 0)
		{
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
		}
		
		if(confirm(getHtmlMessage(2))) //�������ɾ������Ϣ��
		{
			as_del("myiframe0");
			as_save("myiframe0");  //�������ɾ������Ҫ���ô����
		}
	}

	/*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=SerialNo;]~*/
	function viewAndEdit()
	{				
		sContractSerialNo = getItemValue(0,getRow(),"ContractSerialNo");  
		sSerialNo = getItemValue(0,getRow(),"SerialNo");		
		var sAssetStatus="<%=sAssetStatus%>";
		if (typeof(sContractSerialNo) == "undefined" || sContractSerialNo.length == 0)
		{
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��	
			return;		
		}
		
		popComp("PDARelativeContractInfo","/RecoveryManage/PDAManage/PDADailyManage/PDARelativeContractInfo.jsp","ContractSerialNo="+sContractSerialNo+"&SerialNo="+sSerialNo+"&AssetStatus="+sAssetStatus);
	}	
	
	/*~[Describe=�鿴��ͬ����;InputParam=��;OutPutParam=SerialNo;]~*/
	function my_Contract()
	{  
		//��ú�ͬ��ˮ��
		var sContractNo = getItemValue(0,getRow(),"ContractSerialNo");  //��ͬ��ˮ�Ż������
		if (typeof(sContractNo) == "undefined" || sContractNo.length == 0)
		{
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
		}
		
		sObjectType = "AfterLoan";
		sObjectNo = sContractNo;				
		sCompID = "CreditTab";
		sCompURL = "/CreditManage/CreditApply/ObjectTab.jsp";
		sParamString = "ObjectType="+sObjectType+"&ObjectNo="+sObjectNo;
		OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
	}	
	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">

	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List07;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script type="text/javascript">	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>	
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>
