<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		ҳ��˵��: ʾ���б�ҳ��
	 */
	String PG_TITLE = "�������ծ�ʲ����䶯";
	//���ҳ�����
	//String sInputUser =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("InputUser"));
	//if(sInputUser==null) sInputUser="";	
    String sAssetStatus = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("AssetStatus"));
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));
	//����ֵת��Ϊ���ַ���
	if(sObjectNo == null) sObjectNo = "";
	if(sObjectType == null) sObjectType = "";
	if(sAssetStatus == null ) sAssetStatus = "";
	
	//ͨ��DWģ�Ͳ���ASDataObject����doTemp
	String sTempletNo = "PDABalanceChangeList";//ģ�ͱ��
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);

	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.setPageSize(10);

	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sObjectNo+","+sObjectType);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	String sButtons[][] = {
			{sAssetStatus.equals("04")?"false":"true","","Button","����","�����䶯��¼","newRecord()",sResourcesPath},
			{"true","","Button","����","�䶯��¼����","viewAndEdit()",sResourcesPath},
			{sAssetStatus.equals("04")?"false":"true","","Button","ɾ��","ɾ���䶯��¼","deleteRecord()",sResourcesPath}
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
		OpenPage("/RecoveryManage/PDAManage/PDADailyManage/PDABalanceChangeInfo.jsp","right","");
	}
	
	/*~[Describe=ɾ����¼;InputParam=��;OutPutParam=��;]~*/
	function deleteRecord()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo) == "undefined" || sSerialNo.length == 0)
		{
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;			
		}
		
		if(confirm(getHtmlMessage(2))) //�������ɾ������Ϣ��
		{
			// ����ͬʱ�޸ĵ�ծ�ʲ������
			var NewValue = "0"; //�õ��޸�֮���ֵ.	ɾ���൱�ڱ䶯�����ԭ����Ϊ0
			var OldValue = getItemValue(0,getRow(),"ChangeSum");  //�õ�ԭ����ֵ	
			if (OldValue == "") OldValue = "0";

			var TempValue = parseFloat(NewValue)-parseFloat(OldValue);//������Ҫ�䶯��ֵ.
			var sChangeType = getItemValue(0,getRow(),"ChangeType");  //�õ��䶯����	

			//�޸ĵ�ծ�ʲ���ĵ�ծ���.
			var sObjectNo = "<%=sObjectNo%>";//��ծ�ʲ����
			var sReturn = PopPageAjax("/RecoveryManage/PDAManage/PDADailyManage/PDABalanceChangeActionAjax.jsp?SerialNo="+sObjectNo+"&Interval_Value="+TempValue+"&ChangeType="+sChangeType,"","");

			as_del("myiframe0");
			as_save("myiframe0");  //�������ɾ������Ҫ���ô����
		}
	}

	/*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=SerialNo;]~*/
	function viewAndEdit()
	{
		sChangeType = getItemValue(0,getRow(),"ChangeType");  //�õ��䶯����	
		sSerialNo = getItemValue(0,getRow(),"SerialNo");		
		var sAssetStatus="<%=sAssetStatus%>";
		if (typeof(sSerialNo) == "undefined" || sSerialNo.length == 0)
		{
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
		}
		
		OpenPage("/RecoveryManage/PDAManage/PDADailyManage/PDABalanceChangeInfo.jsp?SerialNo="+sSerialNo+"&ChangeType="+sChangeType+"AssetStatus="+sAssetStatus,"right","");
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