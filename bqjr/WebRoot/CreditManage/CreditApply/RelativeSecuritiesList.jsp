<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author: ndeng 2005-04-18
		Tester:
		Describe: ���ó�׵�����Ϣ
		Input Param:
			ObjectType: �׶α��
			ObjectNo:
			SerialNo��ҵ����ˮ��
		Output Param:
			SerialNo��ҵ����ˮ��
		
		HistoryLog:
	 */
	%>
<%/*~END~*/%>





<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "���ó�׵�����Ϣ"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%

	//�������

	//���ҳ�����

	//����������
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%


	String sHeaders[][] = {	{"SerialNo","��ˮ��"},
	                        {"LCCurrencyName","�鸶���ݱ���"},
							{"LCSum","�鸶���ݽ��(Ԫ)"},
							{"OrgName","�Ǽǻ���"},
							{"UserName","�Ǽ���"}
	                       }; 


	String sSql =  " select "+
			" ObjectType,ObjectNo,SerialNo,"+
			" getItemName('Currency',LCCurrency) as LCCurrencyName,LCSum,"+
			" InputUserID,getUserName(InputUserID) as UserName,InputOrgID,"+
			" getOrgName(InputOrgID) as OrgName"+
			" from LC_INFO "+
	     	" where ObjectType='"+sObjectType+"' and ObjectNo='"+sObjectNo+"' ";

	//��SQL������ɴ������
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders);
	doTemp.UpdateTable = "LC_INFO";
	doTemp.setKey("SerialNo,ObjectNo,ObjectType",true);	 //Ϊ�����ɾ��
	//���ò��ɼ���
	doTemp.setVisible("SerialNo,ObjectNo,ObjectType",false);
	//���ò��ɼ���
	doTemp.setVisible("InputOrgID,InputUserID",false);
	doTemp.setUpdateable("UserName,OrgName,LCCurrencyName",false);
	doTemp.setHTMLStyle("UserName,OrgName"," style={width:80px} ");
	doTemp.setUpdateable("",false);
	doTemp.setAlign("LCSum","3");
	doTemp.setCheckFormat("LCSum","2");

	//����datawindow
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����ΪGrid���
	dwTemp.ReadOnly = "1"; //����Ϊֻ��

	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));


	String sCriteriaAreaHTML = ""; //��ѯ����ҳ�����
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
		{"true","","Button","����","����ó�׵�����Ϣ","newRecord()",sResourcesPath},
		{"true","","Button","����","�鿴ó�׵�������","viewAndEdit()",sResourcesPath},
		{"true","","Button","ɾ��","ɾ��ó�׵�����Ϣ","deleteRecord()",sResourcesPath}
		};
	%>
<%/*~END~*/%>




<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">
	/*~[Describe=������¼;InputParam=��;OutPutParam=��;]~*/
	function newRecord()
	{
		/* OpenPage("/CreditManage/CreditApply/RelativeAllLCInfo.jsp?Templet=SecuritiesInfo","_self",""); */ //SecuritiesInfo�Ƿ���ģ��
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
		/* SecuritiesInfoΪ����ģ��
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if(typeof(sSerialNo)=="undefined" || sSerialNo.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}
		else {
			OpenPage("/CreditManage/CreditApply/RelativeAllLCInfo.jsp?Templet=SecuritiesInfo&SerialNo="+sSerialNo, "_self","");
		} */
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
