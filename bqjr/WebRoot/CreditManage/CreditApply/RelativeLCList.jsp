<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author: jytian 2004-12-11
		Tester:
		Describe: �������֤��Ϣ
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
	String PG_TITLE = "�������֤��Ϣ"; // ��������ڱ��� <title> PG_TITLE </title>
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


/*	String sHeaders[][] = {	{"SerialNo","��ˮ��"},
							{"LCNo","����֤���"},
							{"LCTypeName","����֤����"},
							{"IssueBank","��֤��"},
	                        {"IssueState","��֤����"},
							{"IssueDate","��������"},
							{"Purpose","��;"},
							{"Applicant","����������"},
	                        {"ApplicantAddress","�����˵�ַ"},
							{"Beneficiary","����������"},
							{"BeneficiaryAddress","�����˵�ַ"},
	                        {"LCCurrencyName","����֤����"},
							{"LCSum","����֤���"},
	                        {"ImportCargo","���ڻ���"},
							{"Exporter","���ڹ�"},
							{"VouchType","������ʽ"},
							{"LoadingDate","����֤װ��"},
	                        {"ValidDate","����֤Ч��"},
							{"DocumentDate","����֤������"},
							{"OrgName","�Ǽǻ���"},
							{"UserName","�Ǽ���"}
	                       }; 


	String sSql =  " select "+
			" ObjectType,ObjectNo,SerialNo,LCNo,"+
			" getItemName('Currency',LCCurrency) as LCCurrencyName,LCSum,"+
			" InputUserID,getUserName(InputUserID) as UserName,InputOrgID,"+
			" getOrgName(InputOrgID) as OrgName"+
			" from LC_INFO "+
	     	" where ObjectType='"+sObjectType+"' and ObjectNo='"+sObjectNo+"' ";
*/
	//��SQL������ɴ������
	ASDataObject doTemp = new ASDataObject("RelativeLCList",Sqlca);
/*	doTemp.setHeader(sHeaders);
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
*/
	//����datawindow
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����ΪGrid���
	dwTemp.ReadOnly = "1"; //����Ϊֻ��

	Vector vTemp = dwTemp.genHTMLDataWindow(sObjectNo+","+sObjectType);
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
		{"true","","Button","����","��������֤��Ϣ","newRecord()",sResourcesPath},
		{"true","","Button","����","�鿴����֤����","viewAndEdit()",sResourcesPath},
		{"true","","Button","ɾ��","ɾ������֤��Ϣ","deleteRecord()",sResourcesPath},
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
		OpenPage("/CreditManage/CreditApply/RelativeLCInfo.jsp","_self","");
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
		if(typeof(sSerialNo)=="undefined" || sSerialNo.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}
		else {
			OpenPage("/CreditManage/CreditApply/RelativeLCInfo.jsp?SerialNo="+sSerialNo, "_self","");
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
