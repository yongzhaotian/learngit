<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		ҳ��˵��: ʾ���б�ҳ��
	 */
	String PG_TITLE = "����ʲ��б�";
	String sSql = "";
	String sItemID = "";  
	String sWhereCondition = "";
	
	
	//����������
	String sFinishType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("FinishType")); 
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType")); 
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo")); 
	String sCurItemID = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CurItemID")); 
	if(sObjectType == null) sObjectType = "";
	if(sObjectNo == null) sObjectNo = "";
	if(sCurItemID == null) sCurItemID = "";
	if(sFinishType == null) sFinishType = "";
	
	if(sCurItemID.equals("075010")) //δ�˳������ʲ�
		sItemID="020";
	else if(sCurItemID.equals("075020")) //���˳������ʲ�
		sItemID="030";
	String sTempletNo="";
	if(sItemID.equals("020"))
	{
		sTempletNo = "020_NPALawAssetsList";//δ�˳������ʲ�
	}
	
	if(sItemID.equals("030"))
	{
		sTempletNo = "030_NPALawAssetsList";//���˳������ʲ�
	}
	
	//ͨ��DWģ�Ͳ���ASDataObject����doTemp
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);

	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.setPageSize(20);

	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sObjectType+","+sObjectNo+","+sCurItemID);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {			
			{"true","","Button","����","�鿴����","viewAndEdit()",sResourcesPath},
			{sFinishType.equals("")?"true":"false","","Button","�˳����","�˳�����ʲ���Ϣ","quitRecord()",sResourcesPath}
			};
			
		if(sItemID.equals("030"))
		{
			sButtons[1][0] = "false";
		}
	
		
	%> 
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">

	//---------------------���尴ť�¼�------------------------------------
	
	/*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=SerialNo;]~*/
	function viewAndEdit()
	{
		//��ü�¼��ˮ��
		var sSerialNo=getItemValue(0,getRow(),"SerialNo");
		var sItemID = "<%=sItemID%>";
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
		}
		
		if(sItemID=="030")
		{
			popComp("NPALawAssetsView","/RecoveryManage/NPAManage/NPARMGoodsMag/NPALawAssetsView.jsp","ObjectNo="+sSerialNo,"");
		}
		else
		{
			popComp("NPALawAssetsView","/RecoveryManage/NPAManage/NPARMGoodsMag/NPALawAssetsView.jsp","ObjectNo="+sSerialNo,"");
		}
	
	}
	
	/*~[Describe=�˳����;InputParam=��;OutPutParam=SerialNo;]~*/
	function quitRecord()
	{
		//��ü�¼��ˮ��
		var sSerialNo=getItemValue(0,getRow(),"SerialNo");
		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
		}
		
		if(confirm(getBusinessMessage("774"))) //�ò���ʲ����Ҫ�˳������
		{
			var sReturn = RunMethod("PublicMethod","UpdateColValue","String@AssetStatus@02,ASSET_INFO,String@SerialNo@"+sSerialNo);
			if(sReturn == "TRUE") //ˢ��ҳ��
			{
				alert(getBusinessMessage("775"));//�ò���ʲ��ѳɹ��˳���⣡
				reloadSelf();
			}else
			{
				alert(getBusinessMessage("776")); //�ò���ʲ��˳����ʧ�ܣ�
				return;
			}
		}
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