<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
		/*
		Author:   --fbkang 
		Tester:
		Content:    --ȫ�ֱ���ά��
			δ�õ��������ֶ���ʱ���أ������Ҫ��չʾ������
		Input Param:
        	TypeNo��    --���ͱ��
 		Output param:
 			
		History Log: 
            
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%//CCS-769 ����ȫ�ֱ����޸�ΪBIB���õ����� update huzp 20150520
	String PG_TITLE = "BIB����"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%	
    String GlobalVariables="GlobalVariables";
	ASDataObject doTemp = new ASDataObject("GlobalVariablesInfo",Sqlca); 
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д

	//��һ��������"BeforeInsert","AfterInsert","BeforeDelete","AfterDelete","BeforeUpdate","AfterUpdate"

	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(GlobalVariables);
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
			{"true","","Button","����","����","saveAndGoBack()",sResourcesPath},
		    };
	%> 
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
	
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">
    var sCurTypeNo=""; //��¼��ǰ��ѡ���еĴ����
    var bIsInsert = false; //���DW�Ƿ��ڡ�����״̬��

	//---------------------���尴ť�¼�------------------------------------
	/*~[Describe=����;InputParam=�����¼�;OutPutParam=��;]~*/
    
	function saveRecord(sPostEvents){
		if(bIsInsert){
			beforeInsert();
		}
		beforeUpdate();
		as_save("myiframe0",sPostEvents);
	}
	
	function saveAndGoBack(){
		saveRecord("goBack()");
	}
	//CCS-769 ����ȫ�ֱ����޸�ΪBIB���õ�����20150526 update huzp
	function goBack(){
		AsControl.OpenView("/SystemManage/CustomerFinanceManage/GlobalVariablesInfo.jsp","","right","");
		var SERIALNO = getSerialNo("BASEDATASET_INFO","SERIALNO","");
		var ATTRSTR1= getItemValue(0,getRow(),"ATTRSTR1");
		var TYPECODE="<%=GlobalVariables%>";
		var BIBVALUE=ATTRSTR1;
		var FLAG="B";
		var UPDATEORG="<%=CurUser.getOrgID()%>";
		var UPDATEUSER="<%=CurUser.getUserID()%>";
		var UPDATEDATE="<%=DateX.format(new java.util.Date(),"yyyy/MM/dd HH:mm:ss")%>";
		
		var args ="SERIALNO="+SERIALNO+",TypeCode="+TYPECODE+",BibValue="+BIBVALUE+",Flag="+FLAG+",UpDateOrg="+UPDATEORG+",UpDateUser="+UPDATEUSER+",UpDateDate="+UPDATEDATE;
		RunJavaMethodSqlca("com.amarsoft.app.billions.InsertBibHistoryInfo","addBibHistoryInfo",args);
	}

	
	
	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">
	<%/*~[Describe=ִ�в������ǰִ�еĴ���;]~*/%>
	
	function beforeInsert(){
		var SERIALNO = getSerialNo("basedataset_info","SERIALNO","");
		setItemValue(0,0,"SERIALNO", SERIALNO);
		setItemValue(0,0,"TYPECODE", "<%=GlobalVariables%>");
		setItemValue(0,0,"UPDATEORG","<%=CurUser.getOrgID()%>");
		setItemValue(0,0,"UPDATEUSER","<%=CurUser.getUserID()%>");
		setItemValue(0,0,"UPDATEDATE","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd HH:mm:ss")%>");
		bIsInsert = false;
	}
	
	<%/*~[Describe=ִ�и��²���ǰִ�еĴ���;]~*/%>
	function beforeUpdate(){
		setItemValue(0,0,"UPDATEUSER","<%=CurUser.getUserID()%>");
		setItemValue(0,0,"UPDATEDATE","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd HH:mm:ss")%>");
		setItemValue(0,0,"UPDATEORG","<%=CurUser.getOrgID()%>");
	}
	
	function initRow(){
		if (getRowCount(0)==0) //���û���ҵ���Ӧ��¼��������һ�����������ֶ�Ĭ��ֵ
		{
			as_add("myiframe0");//������¼
			setItemValue(0,0,"TYPECODE", "<%=GlobalVariables%>");
			setItemValue(0,0,"UPDATEORG","<%=CurUser.getOrgID()%>");
			setItemValue(0,0,"UPDATEUSER","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"UPDATEDATE","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd HH:mm:ss")%>");
			bIsInsert = true;
		}
	}
	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List07;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script type="text/javascript">	
	$(document).ready(function(){
		AsOne.AsInit();
		init();
		bFreeFormMultiCol = true;
		my_load(2,0,'myiframe0');
		initRow();
	});
	
</script>	
<%/*~END~*/%>


<%@ include file="/IncludeEnd.jsp"%>
