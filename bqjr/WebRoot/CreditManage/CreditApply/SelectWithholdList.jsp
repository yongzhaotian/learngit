<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author: 
		Tester:
		Describe: 
		
		Input Param:
		SerialNo:��ˮ��
		ObjectType:��������
		ObjectNo��������
		
		Output Param:
			
		HistoryLog:
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "����������ͬ"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info02;Describe=�����������ȡ����;]~*/%>
<%
	//���ҳ�����
    String sOpenBank    = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("OpenBank"));
    String sCity        = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("City"));

    System.out.println("----------------"+sOpenBank+"---------------"+sCity);

    if(sOpenBank==null) sOpenBank="";
    if(sCity==null) sCity="";
%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/%>
	<%
	String sHeaders[][] = { 							
			{"Bank","��������"},
			{"BankNo","֧�д���"},
			{"Branch","����֧��"}
		   }; 

	 String sSql = "select (getItemName('BankPutCode',BANACODE)) as Bank,"+
	               " BankNo,"+
			       " BankName as Branch"+
			       " from bankput_info where BANACODE = '"+sOpenBank+"' and"+
			       " City ='"+sCity+"'";
		
	 ASDataObject doTemp = null;
	 doTemp = new ASDataObject(sSql);
	 doTemp.setHeader(sHeaders);	
	 //doTemp.multiSelectionEnabled=true;//���ƶ�ѡ
	 //doTemp.setKey("ArtificialNo", true);
	 
	 //doTemp.setHTMLStyle("modelsID", "style={width:50px}");
	 //doTemp.setHTMLStyle("modelsBrand,modelsSeries,carModel,carModelCode", "style={width:100px}");
	 //doTemp.setHTMLStyle("bodyType,manufacturers,salesStartTime,engineSize,color", "style={width:100px}");
	 doTemp.setColumnAttribute("BankNo,Branch","IsFilter","1");
	 
	 //������ʾ�ı���ĳ��ȼ��¼�����
	 doTemp.setHTMLStyle("Branch","style={width:380px} ");
	 doTemp.setHTMLStyle("Bank","style={width:150px} ");
	 
	 doTemp.generateFilters(Sqlca);
	 doTemp.parseFilterData(request,iPostChange);
	 CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //����Ϊֻ��
	//����HTMLDataWindow
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
			{"true","","Button","ȷ��","ȷ��","doCreation()",sResourcesPath},
			{"true","","Button","ȡ��","ȡ��","doCancel()",sResourcesPath}	
		};
	
	%>
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">

	//---------------------���尴ť�¼�------------------------------------
	/*~[Describe=ȷ����Ϣ;InputParam=��;OutPutParam=��;]~*/
	function doCreation()
	{
      doReturn();
	}
	
	/*~[Describe=ȷ��;InputParam=��;OutPutParam=��;]~*/
	function doReturn(){
		sBankNo     = getItemValue(0,getRow(),"BankNo");
		sBranch     = getItemValue(0,getRow(),"Branch");
		
		//alert("-----"+sBranch+"------"+sBankNo);
		top.returnValue = sBankNo+"@"+sBranch;
		top.close();
	}
	
	/*~[Describe=ȡ��;InputParam=��;OutPutParam=��;]~*/
	function doCancel()
	{
		self.returnValue='_CANCEL_';
		self.close();
	}
	
	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List07;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script type="text/javascript">
	AsOne.AsInit();
	init();
	showFilterArea();
	my_load(2,0,'myiframe0');
</script>
<%/*~END~*/%>

<%@	include file="/IncludeEnd.jsp"%>