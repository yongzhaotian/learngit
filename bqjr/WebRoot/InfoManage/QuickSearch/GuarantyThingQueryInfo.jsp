<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/%>
	<%
	/*
		Author: zywei 2005-11-27
		Tester:
		Describe: ����Ѻ�������Ϣ����;
		Input Param:
			GuarantyType������Ѻ������				
			GuarantyID������Ѻ����
		Output Param:

		HistoryLog:

	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "����Ѻ�������Ϣ����"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
	String  sTempletNo = "";//--ģ�����
	String sTempletFilter = "";//ģ����˱���
	String sSql = "";//Sql���
	ASResultSet rs = null;//�����
	String sImpawnTypeName = "";//����Ѻ����������
	
	//���ҳ�����������Ѻ�����͡�����Ѻ����
	String sGuarantyType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("GuarantyType"));
	String sGuarantyID = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("GuarantyID"));
	
	//����ֵת��Ϊ���ַ���
	if(sGuarantyType == null) sGuarantyType = "";
	if(sGuarantyID == null) sGuarantyID = "";
		
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/%>
	<%		        
	//���ݵ�Ѻ������ȡ����ʾģ���
	sSql = "select ItemName,ItemDescribe from CODE_LIBRARY where CodeNo='GuarantyList' and ItemNo=:ItemNo";
	rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("ItemNo",sGuarantyType));
	if(rs.next()){
		sTempletNo = rs.getString("ItemDescribe");
		sImpawnTypeName = rs.getString("ItemName");
	}
	rs.getStatement().close();
	
	//����ֵת��Ϊ���ַ���
	if(sTempletNo == null) sTempletNo = "";
	if(sImpawnTypeName == null) sImpawnTypeName = "";

	//���ù�������	
	if(sGuarantyType.substring(0,3).equals("010"))
		sTempletFilter = " (ColAttribute like '%PawnInfo%' ) ";
	else
		sTempletFilter = " (ColAttribute like '%ImpawnInfo%' ) ";

	//ͨ����ʾģ�����ASDataObject����doTemp
	ASDataObject doTemp = new ASDataObject(sTempletNo,sTempletFilter,Sqlca);

	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
		
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sGuarantyID);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info04;Describe=���尴ť;]~*/%>
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
	};
	
	%>
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=Info05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/Info05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info06;Describe=���尴ť�¼�;]~*/%>
	<script type="text/javascript">
	
	//---------------------���尴ť�¼�------------------------------------
		
	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info07;Describe=�Զ��庯��;]~*/%>

	<script type="text/javascript">
	
	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info08;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script type="text/javascript">	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>	
<%/*~END~*/%>


<%@ include file="/IncludeEnd.jsp"%>
