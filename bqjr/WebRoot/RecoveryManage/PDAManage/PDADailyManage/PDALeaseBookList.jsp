<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		ҳ��˵��: ʾ���б�ҳ��
	 */
	String PG_TITLE = "��ծ�ʲ�����̨���б�";
	//���ҳ�����
	//String sInputUser =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("InputUser"));
	//if(sInputUser==null) sInputUser="";
	String sAssetStatus = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("AssetStatus"));
	String sObjectType	=DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));
	String sObjectNo	=DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	//����ֵת��Ϊ���ַ���
	if(sObjectNo == null) sObjectNo = "";
	if(sObjectType == null) sObjectType = "";
	if(sAssetStatus == null ) sAssetStatus = "";
	//ͨ��DWģ�Ͳ���ASDataObject����doTemp
	String sTempletNo = "PDALeaseBookList";//ģ�ͱ��
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);

	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.setPageSize(10);

	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sObjectType+","+sObjectNo);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	String sButtons[][] = {
			{sAssetStatus.equals("04")?"false":"true","","Button","����","����","newRecord()",sResourcesPath},
			{"true","","Button","����","��ϸ��Ϣ","viewAndEdit()",sResourcesPath},
			{sAssetStatus.equals("04")?"false":"true","","Button","ɾ��","ɾ��","deleteRecord()",sResourcesPath},
			{"true","","Button","�����������","�����������","my_Statistics()",sResourcesPath}
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
		OpenPage("/RecoveryManage/PDAManage/PDADailyManage/PDADisposalBookInfo.jsp?DispositionType=01&ObjectType=<%=sObjectType%>&ObjectNo=<%=sObjectNo%>","right");
	}
	
	/*~[Describe=��ծ�ʲ������ս����;InputParam=��;OutPutParam=SerialNo;]~*/
	function my_Statistics()
	{
		var sObjectNo = "<%=sObjectNo%>";//�ʲ����к�
		//type=1 ��ζ�Ŵ�AppDisposingList��ִ�д����սᲢ�һ��ܡ�
		//type=2 ��ζ�Ŵ�PDADisposalEndList�в쿴���ܡ�
		//type=3 ��ζ�Ŵ�PDADisposalBookList�в쿴���ܡ�
        sReturn=popComp("PDADisposalEndInfo","/RecoveryManage/PDAManage/PDADailyManage/PDADisposalEndInfo.jsp","SerialNo="+sObjectNo+"&Type=3","dialogWidth:720px;dialogheight:580px","");
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
			as_del("myiframe0");
			as_save("myiframe0");  //�������ɾ������Ҫ���ô����
		}
	}

	/*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=SerialNo;]~*/
	function viewAndEdit()
	{
		//����ʲ�������ˮ��
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");	
		var sDispositionType = getItemValue(0,getRow(),"DispositionType");
		var sAssetStatus="<%=sAssetStatus%>";

		if (typeof(sSerialNo) == "undefined" || sSerialNo.length == 0)
		{
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
		}
		
		OpenPage("/RecoveryManage/PDAManage/PDADailyManage/PDADisposalBookInfo.jsp?SerialNo="+sSerialNo
				+"&DispositionType="+sDispositionType+"&ObjectType="+"<%=sObjectType%>"+"&ObjectNo="+"<%=sObjectNo%>"+"&AssetStatus="+sAssetStatus,"right");
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