<%@ page contentType="text/html; charset=GBK"%>
<%@page import="com.amarsoft.app.als.credit.model.CreditObjectAction"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	%>
<%/*~END~*/%>



<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "��ȹ����б�"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>



<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%

	//��ò���,��������,������
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	//����ֵת���ɿ��ַ���
	if(sObjectType == null) sObjectType = "";	
	if(sObjectNo == null) sObjectNo = "";
%>
<%/*~END~*/%>



<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%
	ASDataObject doTemp = new ASDataObject("RelativeCreditList",Sqlca);
   CreditObjectAction  creditObjectAction = new CreditObjectAction(sObjectNo,sObjectType);

	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����ΪGrid���
	dwTemp.ReadOnly = "1"; //����Ϊֻ��

	Vector vTemp = dwTemp.genHTMLDataWindow(creditObjectAction.getRealCreditObjectType()+","+sObjectNo);
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

	String sButtons[][] = 
		{
		{"true","","Button","����","����","newRecord()",sResourcesPath},
		{"true","","Button","�鿴�����������","�鿴�����������","CreditLineInfo()",sResourcesPath},
		{"true","","Button","���ʹ�ò�ѯ","���ʹ�ò�ѯ","QueryUseInfo()",sResourcesPath},
		{"true","","Button","ɾ��","ɾ��","deleteRecord()",sResourcesPath}		
		};
	%>
<%/*~END~*/%>




<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">

	//---------------------���尴ť�¼�------------------------------------
	/*~[Describe=������¼;InputParam=��,;OutPutParam=��;]~*/
	function newRecord()
	{
		OpenPage("/CreditManage/CreditApply/CreditLineRelaInfo.jsp?ObjectNo=<%=sObjectNo%>&ObjectType=<%=sObjectType%>","_self","");
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

	/*~[Describe=�鿴���ʹ�����;InputParam=��;OutPutParam=��;]~*/
	function QueryUseInfo()
	{
		var serialNo=getItemValue(0,getRow(),"RelativeSerialNo");
		var sBusinessType=getItemValue(0,getRow(),"BusinessType");

		if (typeof(serialNo)=="undefined" || serialNo.length==0){
            alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
            return;
        }  
		//AsControl.PopView("/CreditManage/CreditLine/CreditLineUseList.jsp","SerialNo="+serialNo,"dialogWidth=800px;dialogHeight=600px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		AsControl.OpenView("/CreditManage/CreditLine/CreditLineUseList.jsp","SerialNo="+serialNo,"_self","dialogWidth=800px;dialogHeight=600px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
	}
	
	/*~[Describe=�鿴�����Ķ�ȶ������;InputParam=��;OutPutParam=��;]~*/
	function CreditLineInfo()
	{
		sObjectNo = getItemValue(0,getRow(),"RelativeSerialNo");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		sCompID = "CreditTab";
		sCompURL = "/CreditManage/CreditApply/ObjectTab.jsp";
		sParamString = "ObjectType=CreditLine&ObjectNo="+sObjectNo;	
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

<%@include file="/IncludeEnd.jsp"%>
