<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<% 
	/*
		Author: jbye  2004-12-16 20:15
		Tester:
		Describe: ��ʾ�ͻ���صĲ��񱨱�
		Input Param:
			
		Output Param:
			
		HistoryLog:
	 */
	%>
<%/*~END~*/%>

<%!
	//��û������ڵķ���
	String getBranchOrgID(String sOrgID,Transaction Sqlca) throws Exception {
		String sUpperOrgID = sOrgID;
		int sLevel = Integer.parseInt(Sqlca.getString("select OrgLevel from Org_Info where OrgID='"+sOrgID+"'"));
		while (sLevel > 3) {
			sUpperOrgID = Sqlca.getString("select RelativeOrgID from Org_Info where OrgID='"+sOrgID+"'");
			if (sUpperOrgID == null) break;
			sOrgID = sUpperOrgID;
			sLevel = Integer.parseInt(Sqlca.getString("select OrgLevel from Org_Info where OrgID='"+sOrgID+"'"));
		}
		return sOrgID;
	}
	
%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "��ְ���鱨��ģ���б�"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%

	//�������

	//���ҳ�����

	//����������
	
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%
	String sHeaders[][] = {
							{"DocID","ģ����"},
							{"DocName","ģ������"},
							{"InputDate","�Ǽ�����"},
							{"OrgName","�Ǽǻ���"},
							{"UserName","�Ǽ���"},
							{"UpdateDate","�޸�����"}
						  };
	String sOrgID = getBranchOrgID(CurOrg.getOrgID(),Sqlca);
	String sSql = "";
	sSql =  " select DocID,DocName,DefaultValue,"+
			" getUserName(UpdateUser) as UserName,"+
			" getOrgName(OrgID) as OrgName,"+
			" UpdateDate "+
			" from FORMATDOC_PARA "+
			" where OrgID = '"+sOrgID+"'";
	//out.println(sSql);
	//��SQL������ɴ������
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders);
	doTemp.UpdateTable = "FORMATDOC_PARA";
	doTemp.setKey("DocID",true);	
	//���ò��ɼ���
	doTemp.setVisible("DefaultValue,InputDate,OrgName,UserName,UpdateDate",false);
	//���ý�����
	doTemp.appendHTMLStyle("DocID,InputDate,OrgName,UserName,UpdateDate"," style={width=60px} ");
	doTemp.appendHTMLStyle("DocName"," style={width=220px} ");

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
		{"true","","Button","���ƴ�ӡ����","���ƴ�ӡ����","structureInfo()",sResourcesPath},
		//{"true","","Button","��ʼ������","��ʼ������","initInfo()",sResourcesPath},
		};
	%>
<%/*~END~*/%>




<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">
	function structureInfo()
	{
		sDocID = getItemValue(0,getRow(),"DocID");
		if(typeof(sDocID)=="undefined" || sDocID.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		var sDirID = PopPage("/FormatDoc/DefaultPrint/DefaultPrintSelect.jsp?DocID="+sDocID+"&rand="+randomNumber(),"","dialogWidth=36;dialogHeight=20;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;");
		
		if(typeof(sDirID)=="undefined" || sDirID=="_none_")
			return;
		
		PopPage("/FormatDoc/DefaultPrint/GetDefaultPrintAction.jsp?DirID="+sDirID+"&DocID="+sDocID,"","");
		alert("���óɹ�");
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

<%@	include file="/IncludeEnd.jsp"%>
