<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   ltma 2010-08-04
		Tester:
		Content: �������		                
		History Log: cwzhan 2004-12-15
            
	 */
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = ""; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%
CurPage.setAttribute("ShowDetailArea","true");
CurPage.setAttribute("DetailAreaHeight","150");

	String termID = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("TermID"));
	if(termID == null)
	{
		termID = "";
	}
	String objectType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectType"));
	if(objectType == null)
	{
		objectType = "Term";
	}
	String objectNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectNo"));
	if(objectNo == null)
	{
		objectNo = "";
	}
	
	ASDataWindow dwTemp=com.amarsoft.app.accounting.product.ProductTermView.createTermDataWindow(objectType, objectNo, termID, Sqlca, CurPage);
	ASDataObject doTemp = dwTemp.DataObject;
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
			{"true","","Button","����","����","updateParaValues()",sResourcesPath},
	};
	%> 
<%/*~END~*/%>




<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script language=javascript>
	//---------------------���尴ť�¼�------------------------------------
	/*~[Describe=������¼;InputParam=��;OutPutParam=��;]~*/
	function saveRecord(){
		as_save("myiframe0","updateParaValues();");
	}

	function updateParaValues(){
		var paraList="ObjectType=<%=objectType%>&VersionID=<%=objectNo%>&TermID=<%=termID%>";
<%
		for(int i=0;i<doTemp.Columns.size();i++){
			String paraname = doTemp.getColumnAttribute(i, "Name");
%>
			var s=getItemValue(0,getRow(),"<%=paraname%>");
			
			if(typeof(s) != "undefined" ){
				s=real2Amarsoft(s);
				paraList = paraList+"&<%=paraname%>="+s;
			}
<%
		}
%>		
		var result =PopPage("/Accounting/Config/TermParaSaveAction.jsp?"+paraList,"","dialogWidth=60;dialogheight=25;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no");
		alert(result);//parent.reloadSelf(1);
	}

	function OpenSubPage()
	{
		OpenPage("/Accounting/Config/TermSetSegmentList.jsp?ObjectType=<%=objectType%>&ObjectNo=<%=objectNo%>&ParentTermID=<%=termID%>","DetailFrame");
	}
	</script>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List07;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script language=javascript>
	AsOne.AsInit();
	init();
	var bFreeFormMultiCol = true;
	my_load(2,0,'myiframe0');
	OpenSubPage();
</script>
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>
