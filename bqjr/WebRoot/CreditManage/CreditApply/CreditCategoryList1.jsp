<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author: sjchuan 2009-10-20
		Tester:
		Describe: ������Ϣ�е�Ʊ����Ϣ�б�
		Input Param:
		Output Param:		
		HistoryLog:
	 */
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "��Ʒ���� "; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%

	//�������

	//���ҳ�����

	//����������
	String sBusinessRange1 = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("BusinessRange1"));
    if(sBusinessRange1 == null) sBusinessRange1 = ""; 
%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>

<%

	String[] sBusinessRanges1;
	StringBuffer sb=new StringBuffer();

	sBusinessRanges1=sBusinessRange1.split(",");
	for(int i=0;i<sBusinessRanges1.length;i++){
		sb.append("'");
		sb.append(sBusinessRanges1[i]);
		sb.append("'");
		sb.append(",");
	}

	sBusinessRange1=sb.toString().substring(0, sb.toString().lastIndexOf(","));    


	String sHeaders[][] = {	{"productctypeid","���ͱ��"},
							{"productctypename","��������"}
	                       }; 
	String sSql = " select productctypeid,productctypename from Product_CType where IsinUse='1' and productcategoryid in("+sBusinessRange1+")";

	//��SQL������ɴ������
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders);
	doTemp.setKey("SerialNo,PutoutNo",true);	 //Ϊ�����ɾ��
	//���ɲ�ѯ����
	doTemp.setColumnAttribute("productctypename","IsFilter","1");
	 doTemp.generateFilters(Sqlca);
	 doTemp.parseFilterData(request,iPostChange);
	 CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	 
//	doTemp.multiSelectionEnabled=true;
	
	//���ý��Ϊ��λһ������
//	doTemp.setType("BillSum","Number");

	//���������ͣ���Ӧ����ģ��"ֵ���� 2ΪС����5Ϊ����"
//	doTemp.setCheckFormat("BillSum","2");
	
	//�����ֶζ����ʽ�����뷽ʽ 1 ��2 �С�3 ��
//	doTemp.setAlign("BillSum","3");
	
	//����datawindow
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����ΪGrid���
	dwTemp.ReadOnly = "1"; //����Ϊֻ��
    
	Vector vTemp = dwTemp.genHTMLDataWindow("");
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
		{"true","","Button","ȷ��","ȷ��","doSubmit()",sResourcesPath},
		{"true","","Button","ȡ�� ","ȡ��","doNo()",sResourcesPath},
		};
	%>
<%/*~END~*/%>




<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">
	/*~[Describe=������¼;InputParam=��;OutPutParam=��;]~*/

	function doSubmit(){
		var sProductctypeid = getItemValue(0,getRow(),"productctypeid");
		var sProductctypename = getItemValue(0,getRow(),"productctypename");
		if(typeof(sProductctypeid) == "undefined" || sProductctypeid == "")
		{
			alert("��ѡ��һ��!");
			return;
		}
		top.returnValue=sProductctypeid+"@"+sProductctypename;
		top.close();
	}
	
	function doNo(){
		top.returnValue = "_CANCEL_";
		top.close();
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
	showFilterArea();
</script>
<%/*~END~*/%>

<%@	include file="/IncludeEnd.jsp"%>
