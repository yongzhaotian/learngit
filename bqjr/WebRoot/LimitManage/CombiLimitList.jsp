<%@page contentType="text/html; charset=GBK"%>
<%@include file="/IncludeBegin.jsp"%>
<%@page import="com.amarsoft.web.config.check.ASConfigCheck"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author:Thong 2005.8.29 15:20
		Tester:
		Content: ����޶������б�
		Input Param:
		Output param:
		History Log: 

	 */
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "����޶������б�"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%
	//�������
	String sSql;
	String sInputUser; //������	
	String sKindCode; //����޶���
	//����������	
	sKindCode =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("KindCode"));

	sInputUser =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("InputUser"));
	if(sInputUser==null) sInputUser="";
	//���ҳ�����	
	//sParameter =  DataConvert.toRealString(iPostChange,(String)request.getParameter("Parameter"));
%>
<%/*~END~*/%>
	<%/*~BEGIN~���ɱ༭��~[Describe=Ϊ����޶��Ƿ���Code_Library�д���;]~*/%>	
	<%
		ASConfigCheck asc = new ASConfigCheck(Sqlca,sKindCode);
		if(!asc.getIsSucceed()){
			//��session�д洢HASH
			session.setAttribute("equalsed",asc.getHashValue()); 
	%>
	<script type="text/javascript">
			if(confirm("��ҳ����Ҫ��ȫƥ��CODE_LIBRARY�е�<%=sKindCode%>�������ݣ�[ȷ��]���£�[ȡ��]����"))
			{
				sTemp = PopPage("/Common/ToolsB/GetVerifyCode.jsp","KindCode=<%=sKindCode%>","");
			}
	</script>
	<%
		}
	%>
	<%/*~END~*/%>



<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%

	String sTempletFilter = "1=1"; //�й�������ע�ⲻҪ�����ݹ���������
	//ͨ��Sql����ASDataObject����doTemp
	String sHeaders[][] = { 
				{"LimitType","�޶�����"},
				{"KindCode","�������"},
				{"KindItem","�������"},
				{"TotalSum","�޶�����(Ԫ)"},
				
				{"Limit","Ŀ���޶�(Ԫ)"},
				{"Rate","Ŀ��ռ��(%)"},
				{"ActualLimit","ʵ���޶�(Ԫ)"},
				{"ActualRate","ʵ��ռ��(%)"},
				
				{"AlertRate","��ʾ����(%)"},
				{"LimitLevel","���Ƽ���"},
				{"BeginDate","��Ч����"},
				{"EndDate","ʧЧ����"},
				{"Useflg","�Ƿ�ʹ��"},
				{"UserName","������Ա"}
			       };   				   		
			       
	sSql = "select SerialNo,LimitType,KindCode,KindItem,TotalSum,Limit,Rate,ActualLimit"
			+",ActualRate,BeginDate,EndDate,AlertRate,getItemName('YesOrNo',Useflg) as Useflg"
			+",getUserName(UserID) as UserName  "
			+"from LIMIT_INFO where LimitType='�����޶�' and KindCode='"+sKindCode+"'";

	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders);	
	
	doTemp.setColumnAttribute("KindItem","IsFilter","1");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	doTemp.UpdateTable="LIMIT_INFO";
	doTemp.setKey("SerialNo",true);
	doTemp.setReadOnly("KindItem",true);
	doTemp.setUpdateable("UserName",false);
	doTemp.setVisible("SerialNo,LimitType,KindCode,ActualLimit,ActualRate",false);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));

	if(!sInputUser.equals("")) doTemp.WhereClause += " and InputUser = '"+sInputUser+"'";

	doTemp.setHTMLStyle("LimitType,BeginDate,EndDate,Useflg,UserName,Rate,AlertRate,"," style={width:70px}");
	doTemp.setHTMLStyle("TotalSum,Limit,ActualLimit"," style={width:130px}");

	doTemp.setDDDWCode("KindItem",sKindCode);
	
	doTemp.setAlign("TotalSum,Limit,ActualLimit,Rate,AlertRate","3");
	doTemp.setCheckFormat("TotalSum,Limit,ActualLimit","2");
	
	if(sKindCode.equals("Term"))
	doTemp.setDDDWCode("KindItem","Term");
		
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д

	//��������¼�
	//dwTemp.setEvent("AfterDelete","!CustomerManage.DeleteRelation(#CustomerID,#RelativeID,#RelationShip)");
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("%");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	//out.println(doTemp.SourceSql); //������仰����datawindow
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
		{"true","","Button","��������","��������޶�����","saveRecord()",sResourcesPath}
		};
	%> 
<%/*~END~*/%>




<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">

	//---------------------���尴ť�¼�------------------------------------
	/*~[Describe=����;InputParam=��;OutPutParam=��;]~*/
	function saveRecord(){
		beforeUpdate();
		as_save("myiframe0");		
	}

	/*~[Describe=ִ�и��²���ǰִ�еĴ���;InputParam=��;OutPutParam=��;]~*/
	function beforeUpdate(){
		setItemValue(0,0,"UserID","<%=CurUser.getUserID()%>");
		setItemValue(0,0,"UserName","<%=CurUser.getUserName()%>");
		setItemValue(0,0,"InputDate","<%=StringFunction.getTodayNow()%>");
	}
	function verifyCode(){
		PopPage("/Common/ToolsB/GetVerifyCode.jsp","","");
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

<%@ include file="/IncludeEnd.jsp"%>
