<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author: ndeng 2004-12-24
		Tester:
		Describe: ���������Ա�б�;
		Input Param:
			CustomerID����ǰ�ͻ����
		Output Param:
			CustomerID����ǰ�ͻ����
			
		HistoryLog:
	 */
	%>
<%/*~END~*/%>



<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "���������Ա�б�"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>



<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
	String sSql = "";
	//����������
	
	//���ҳ�����
	String sBelongNo = DataConvert.toRealString(iPostChange,CurPage.getParameter("BelongNo"));
	//Flag=Y��ʾ�����������Ϣ�б�����
	String sFlag = DataConvert.toRealString(iPostChange,CurPage.getParameter("Flag"));
	//����ֵת��Ϊ���ַ���
	if(sBelongNo == null) sBelongNo = "";
	if(sFlag == null) sFlag = "";
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%
	//ͨ��DWģ�Ͳ���ASDataObject����doTemp
	String sTempletNo = "";
	if(sBelongNo.equals(""))
	{
		sTempletNo = "CourtPersonList";//ģ�ͱ��
	 }else
	 {		
		 sTempletNo = "CourtPersonList1";//ģ�ͱ��
	 }      

	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);

	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.setPageSize(10);

	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sBelongNo+","+sFlag);
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
			{"true","","Button","����","����������","newRecord()",sResourcesPath},
			{"true","","Button","����","�鿴������","viewAndEdit()",sResourcesPath},
			{"true","","Button","��������","�鿴��������","my_lawcase()",sResourcesPath},
			{"true","","Button","����","�����б�ҳ��","goBack()",sResourcesPath},
			{"true","","Button","ɾ��","ɾ��������","deleteRecord()",sResourcesPath}
		};
		
	if(sFlag.equals("Y")) //�ӻ�����Ϣ�б����
	{
		sButtons[0][0]="false";
		//jqcao: ������Աָ��Ӧ�÷ų������顰�͡�����������������ť
		//sButtons[1][0]="false";
		//sButtons[2][0]="false";
		sButtons[4][0]="false";
	}else
	{
		sButtons[3][0]="false";
	}
	
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
		OpenPage("/RecoveryManage/Public/CourtPersonInfo.jsp","_self","");
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
		sSerialNo   = getItemValue(0,getRow(),"SerialNo");
		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else
		{
			OpenPage("/RecoveryManage/Public/CourtPersonInfo.jsp?SerialNo="+sSerialNo, "_self","");
		}
	}
	
	/*~[Describe=�����б�;InputParam=��;OutPutParam=��;]~*/
	function goBack()
	{     	
		OpenPage("/RecoveryManage/Public/CourtList.jsp?rand="+randomNumber(),"_self","");
	}
	
	/*~[Describe=�Ѵ�������Ϣ;InputParam=��;OutPutParam=��;]~*/
	function my_lawcase()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");	
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else
		{
			OpenPage("/RecoveryManage/Public/SupplyLawCase.jsp?QuaryName=PersonNo&QuaryValue="+sSerialNo+"&Back=4&rand="+randomNumber(),"_self","");           	
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

<%@	include file="/IncludeEnd.jsp"%>
