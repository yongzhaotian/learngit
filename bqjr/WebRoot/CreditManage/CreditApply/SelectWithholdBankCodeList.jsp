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
	String PG_TITLE = "ѡ�����/�ſ����"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info02;Describe=�����������ȡ����;]~*/%>
<%
	//���ҳ�����
    String sPayWay    = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("PayWay"));


    if(sPayWay == null) sPayWay="";
%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/%>
	<%
	String sHeaders[][] = { 							
			{"ItemNo","����/�ſ���д���"},
			{"ItemName","����/�ſ��������"}
		   }; 

	 String sSql = "select ItemNo as ItemNo,"+
			       " ItemName as ItemName"+
			       " from Code_Library where CodeNo='BankCode' ";
	 if ("1".equals(sPayWay)) {
		 sSql += " and IsInUse='1' ";
	 } else if ("2".equals(sPayWay)) {
		 sSql += " and 1=1 ";
	 }
		
	 ASDataObject doTemp = null;
	 doTemp = new ASDataObject(sSql);
	 doTemp.setHeader(sHeaders);	
	 //doTemp.multiSelectionEnabled=true;//���ƶ�ѡ
	 //doTemp.setKey("ArtificialNo", true);
	 
	 //doTemp.setHTMLStyle("modelsID", "style={width:50px}");
	 //doTemp.setHTMLStyle("modelsBrand,modelsSeries,carModel,carModelCode", "style={width:100px}");
	 //doTemp.setHTMLStyle("bodyType,manufacturers,salesStartTime,engineSize,color", "style={width:100px}");
	 doTemp.setColumnAttribute("ItemName","IsFilter","1");
	 
	 //������ʾ�ı���ĳ��ȼ��¼�����
	 doTemp.setHTMLStyle("ItemName","style={width:280px} ");
	 //doTemp.setHTMLStyle("Bank","style={width:150px} ");
	 
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
		var sItemNo     = getItemValue(0,getRow(),"ItemNo");
		var sItemName  = getItemValue(0,getRow(),"ItemName");
		
		if (sItemNo==="undefined" || typeof sItemNo == "undefined") {
			top.returnValue = "";
		} else {
			top.returnValue = sItemNo+"@"+sItemName;			
		}
		
		top.close();
	}
	
	/*~[Describe=ȡ��;InputParam=��;OutPutParam=��;]~*/
	function doCancel()
	{
		self.returnValue='';
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