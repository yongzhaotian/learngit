
<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		ҳ��˵��: ʾ���б�ҳ��
	 */
	String PG_TITLE = "�����ս���ʲ��б�";
	//���ҳ�����
	//String sInputUser =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("InputUser"));
	//if(sInputUser==null) sInputUser="";
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));
	String sInOut = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("InOut"));
	String sFlag="";
	//����ֵת��Ϊ���ַ���
	if(sObjectType == null) sObjectType = "";
	if(sInOut == null) sInOut = "";
	
	//ͨ��DWģ�Ͳ���ASDataObject����doTemp
	String sTempletNo = "PDADisposalEndList";//ģ�ͱ��
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
	if (sInOut.equals("In"))   //��ȡ�����ʲ�
		sFlag = "010";
	else								//��ȡ�����ʲ�
		sFlag = "020";
	
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.setPageSize(20);

	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sObjectType+","+sFlag+","+CurUser.getUserID());
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	String sButtons[][] = {
			{"true","","Button","��ϸ��Ϣ","��ϸ��Ϣ","viewAndEdit()",sResourcesPath},
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
	
	/*~[Describe=��ծ�ʲ������ս����;InputParam=��;OutPutParam=SerialNo;]~*/
	function my_Statistics()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");	
		if (typeof(sSerialNo) == "undefined" || sSerialNo.length == 0)
		{
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
		}

		//type=1 ��ζ�Ŵ�AppDisposingList��ִ�д����սᲢ�һ��ܡ�
		//type=2 ��ζ�Ŵ�PDADisposalEndList�в쿴���ܡ�
		//type=3 ��ζ�Ŵ�PDADisposalBookList�в쿴���ܡ�
        sReturn=popComp("PDADisposalEndInfo","/RecoveryManage/PDAManage/PDADailyManage/PDADisposalEndInfo.jsp","SerialNo="+sSerialNo+"&Type=2","dialogWidth:720px;dialogheight:580px","");
	}

	/*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=SerialNo;]~*/
	function viewAndEdit()
	{
		//��õ�ծ�ʲ���ˮ��
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		sObjectNo = getItemValue(0,getRow(),"ObjectNo");		
		if (typeof(sSerialNo) == "undefined" || sSerialNo.length == 0)
		{
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
		}
		
		popComp("PDABasicView","/RecoveryManage/PDAManage/PDADailyManage/PDABasicView.jsp","SerialNo="+sSerialNo+"&ObjectNo="+sObjectNo,"");
		reloadSelf();
	}	
	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">	
	/*~[Describe=�����ص�����;InputParam=��;OutPutParam=��;]~*/
	function AddUserDefine()
	{
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0) 
		{
			alert(getHtmlMessage('1'));
			return;
		}
		if(confirm("Ҫ���õ�ծ�ʲ������ص���������")) 
		{
			var sRvalue=PopPageAjax("/Common/ToolsB/AddUserDefineActionAjax.jsp?ObjectType=PDAAsset&ObjectNo="+sSerialNo,"","");
			alert(getBusinessMessage(sRvalue));
		}
	}
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