<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author: cyyu 2009-02-09
		Tester:
		Describe: ��ӵ��Ӻ�ͬģ��ʱ��������Ӧ��ҵ������;
		Input Param:
			ObjectType����������
			ObjectNo: ������
			ContractNo��������Ϣ���
		Output Param:
			
		HistoryLog:
	 */
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "����ҵ��������Ϣ�б�"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>



<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
	String sSql = "";

	//���ҳ��������������͡������š�������Ϣ���
	String sEDocNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("EDocNo"));
	String sEDocType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("EDocType"));
	
	//����ֵת��Ϊ���ַ���
	if(sEDocNo == null) sEDocNo = "";
	if(sEDocType == null) sEDocType = "";
	
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%
	String sHeaders[][] = {
			{"EDocNo","���Ӻ�ͬģ����"},
			{"TypeNo","ҵ�����ͱ��"},
			{"TypeName","ҵ������"}
		  };
	sSql =  " select TypeNo,TypeName,EDocNo from EDOC_RELATIVE where EDocNo='" + sEDocNo + "' ";
	
	//���Ӻ�ͬģ���Ӧ��ҵ������	
	PG_TITLE = "���Ӻ�ͬģ��["+sEDocNo+"]��Ӧ��ҵ������@PageTitle";
	
	//��sSql�������ݴ������
	ASDataObject doTemp = new ASDataObject(sSql);
	//���ñ�ͷ,���±���,��ֵ,�ɼ����ɼ�,�Ƿ���Ը���
	doTemp.setHeader(sHeaders);
	doTemp.UpdateTable = "EDOC_RELATIVE";
	doTemp.setKey("TypeNo",true);
	doTemp.setVisible("EDocNo,TypeNo",false);
	//���ø�ʽ
	doTemp.setHTMLStyle("TypeName"," style={width:180px} ");
	
	//����datawindow
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����ΪGrid���
	dwTemp.ReadOnly = "1"; //����Ϊֻ��
	
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	//out.print(doTemp.SourceSql);//����datawindow��Sql���

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
		{"true","","Button","���Ĺ�������","�޸�ģ���Ӧ��ҵ������","changeRecord()",sResourcesPath},
	};
		
	%>
<%/*~END~*/%>




<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script language=javascript>
			
	/*~[Describe=�����µ�ҵ������;InputParam=��;OutPutParam=��;]~*/
	function changeRecord()
	{
		sEDocNo = "<%=sEDocNo%>";
		sEDocType = "<%=sEDocType%>";
		if(typeof(sEDocNo)=="undefined" || sEDocNo.length==0) 
		{
			alert(getHtmlMessage("�����ڵ�ģ���ţ����ȶ���ģ����"));
		}else 
		{
			sReturnValue = PopPage("/Common/EDOC/EDocTerm.jsp?EDocNo="+sEDocNo+"&EDocType"+sEDocType,"","width=160,height=20,left=20,top=20,status=yes,center=yes");
			if(typeof(sReturnValue)=="undefined" || sReturnValue=="_none_")
			{
				return;
			}
			sReturn = RunMethod("Configurator","SaveEDoc",sReturnValue+","+sEDocNo+","+sEDocType);
			if(sReturn == '0' || typeof(sReturn)=="undefined" || sReturn=="_none_")
			{
				alert("���ݱ���ʧ��");
			}
		}
		reloadSelf();
	}
		
	</script>
<%/*~END~*/%>



<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script language=javascript>
	
	</script>
<%/*~END~*/%>



<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List07;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script	language=javascript>
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>
<%/*~END~*/%>

<%@	include file="/IncludeEnd.jsp"%>