<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		ҳ��˵��: ʾ���б�ҳ��
	 */
	String PG_TITLE = "ծȨ�ò���¼����";
	//���ҳ�����
	String sFinishType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("FinishType"));   
    String sObjectType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType")); //��������
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));     //��ͬ���
	if(sFinishType == null) sFinishType = "";

	//ͨ��DWģ�Ͳ���ASDataObject����doTemp
	String sTempletNo = "ConsessionList";//ģ�ͱ��
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
			{sFinishType.equals("")?"true":"false","","Button","����","�����ͻ�����ծȯ��Ϣ","newRecord()",sResourcesPath},
			{"true","","Button","����","�鿴�ͻ�����ծȯ��ϸ��Ϣ","viewAndEdit()",sResourcesPath},
			{sFinishType.equals("")?"true":"false","","Button","ɾ��","ɾ���ͻ�����ծȯ��Ϣ","deleteRecord()",sResourcesPath},
			};
		%>
	<%/*~END~*/%>

	<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
		<%@include file="/Resources/CodeParts/List05.jsp"%>
	<%/*~END~*/%>

	<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">

		//---------------------���尴ť�¼�------------------------------------
		/*~[Describe=������¼;InputParam=��;OutPutParam=��;]~*/
		function newRecord()
		{
			sObjectNo = "<%=sObjectNo%>";
			OpenPage("/RecoveryManage/NPAManage/NPADailyManage/ConsessionInfo.jsp?ObjectNo="+sObjectNo,"_self","");
		}

		/*~[Describe=ɾ����¼;InputParam=��;OutPutParam=��;]~*/
		function deleteRecord()
		{
			sSerialNo = getItemValue(0,getRow(),"SerialNo");
			if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
			{
				alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			}
			else if(confirm(getHtmlMessage('2')))//�������ɾ������Ϣ��
			{	
				as_del('myiframe0');
				as_save('myiframe0');  //�������ɾ������Ҫ���ô����
			}
		}

		/*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=��;]~*/
		function viewAndEdit()
		{
			sSerialNo = getItemValue(0,getRow(),"SerialNo");
			if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
			{
				alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			}else
			{
				OpenPage("/RecoveryManage/NPAManage/NPADailyManage/ConsessionInfo.jsp?SerialNo="+sSerialNo,"_self","");
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

	<%@include file="/IncludeEnd.jsp"%>
