<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author:
		Tester:
		Describe: �������
		Input Param:
		Output Param:
		
		HistoryLog:
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "�������"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%
	//���������SQL���
	String sSql = "";	
	
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%	

	
	//ͨ����ʾģ�����ASDataObject����doTemp
	String sTempletNo = "CarLawCollectionList"; //ģ����
	String sTempletFilter = "1=1"; //�й�������ע�ⲻҪ�����ݹ���������

	ASDataObject doTemp = new ASDataObject(sTempletNo,sTempletFilter,Sqlca);

	//���ɲ�ѯ����
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));

	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.setPageSize(25);//25��һ��ҳ

	//��������¼�
	//dwTemp.setEvent("AfterDelete","!CustomerManage.DeleteRelation(#CustomerID,#RelativeID,#RelationShip)");

	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");//������ʾģ�����
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
				
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List04;Describe=���尴ť;]~*/%>
	<%
	//����Ϊ��
		//0.�Ƿ���ʾ
		//1.ע��Ŀ�������(Ϊ�����Զ�ȡ��ǰ���)
		//2.����(Button/ButtonWithNoAction/HyperLinkText/TreeviewItem/PlainText/Blank)
		//3.��ť����
		//4.˵������
		//5.�¼�
		//6.��ԴͼƬ·��

	String sButtons[][] = {
		   {"true","","Button","�鿴��ͬ","�鿴��ͬ","viewContractInfo()",sResourcesPath},
		   {"true","","Button","������Ϣ�Ǽ�","������Ϣ�Ǽ��б�","lawsList()",sResourcesPath},
		   {"true","","Button","ת����","ת����","gotoChargeOff()",sResourcesPath},
		   {"true","","Button","ȷ�������","ȷ���������ϼ����","",sResourcesPath},
		};
	%> 
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">

	//---------------------���尴ť�¼�------------------------------------
	/*~[Describe=ת����;InputParam=��;OutPutParam=��;]~*/
	function gotoChargeOff(){
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		
		var sRec = AsControl.RunJavaMethodSqlca("com.amarsoft.app.hhcf.after.colection.AfterColectionAction","gotoVerification","ColSerialNo="+sSerialNo);
		if(sRec!="true")
		{
			alert("ת����ʧ��!");
		}
		else
		{
			reloadSelf();
		}
	}
	
	
	
	/*~[Describe=�鿴��������ĺ�ͬ����;InputParam=��;OutPutParam=��;]~*/
	function viewContractInfo(){
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		sContractSerialNo = getItemValue(0,getRow(),"ContractSerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		//��ͬ��У��
		if (typeof(sContractSerialNo)=="undefined" || sContractSerialNo.length==0)
		{
			alert("������δ������ͬ���,�޷��鿴��ͬ����!");
			return;
		}
		sObjectType = "BusinessContract";
		sCompURL = "/BusinessManage/CollectionManage/BusinessContractViewTab.jsp";
		sParamString = "ObjectType="+sObjectType+"&ObjectNo="+sContractSerialNo+"&RightType=ReadOnly";
		AsControl.OpenComp(sCompURL,sParamString,"_blank",OpenStyle);
	}
	
	/*~[Describe=������Ϣ�б�;InputParam=��;OutPutParam=��;]~*/
	function lawsList(){
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		var sBcSerialNo = getItemValue(0,getRow(),"ContractSerialNo");
		if (typeof(sBcSerialNo)=="undefined" || sBcSerialNo.length==0)
		{
			alert("�ô����������ݲ�����,[��ͬ��Ϊ��]!");//��ѡ��һ����Ϣ��
			return;
		}
		//�򿪷���Ǽǽ���б����
		AsControl.OpenPage("/BusinessManage/CollectionManage/CarCollectionLawsList.jsp", "CollectionSerialNo="+sSerialNo+"&ContractSerialNo="+sBcSerialNo, "_self", "");
	}
	/*~[Describe=������¼;InputParam=��;OutPutParam=��;]~*/
	function my_add()
	{ 	 
	    OpenPage("/BusinessManage/QueryManage/PhoneManageInfo.jsp","_self","");
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
			OpenPage("/BusinessManage/QueryManage/PhoneManageInfo.jsp?SerialNo="+sSerialNo, "_self","");
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
