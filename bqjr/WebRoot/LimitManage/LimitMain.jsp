<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main00;Describe=ע����;]~*/%>
	<%
	/*
		Author:Thong 2005.8.29 11:30
		Tester:
		Content:�޶����������
		Input Param:
		Output param:
		History Log: 

	 */
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "�޶����������"; // ��������ڱ��� <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;�޶����������&nbsp;&nbsp;"; //Ĭ�ϵ�����������
	String PG_CONTNET_TEXT = "��������б�";//Ĭ�ϵ�����������
	String PG_LEFT_WIDTH = "200";//Ĭ�ϵ�treeview���
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main02;Describe=�����������ȡ����;]~*/%>
	<%
	//�������
	
	//����������	
	
	//���ҳ�����	
	
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main03;Describe=������ͼ;]~*/%>
	<%
	//����Treeview
	HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,"�޶����ù���̨","right");
	tviTemp.ImageDirectory = sResourcesPath; //������Դ�ļ�Ŀ¼��ͼƬ��CSS��
	tviTemp.toRegister = false; //�����Ƿ���Ҫ�����еĽڵ�ע��Ϊ���ܵ㼰Ȩ�޵�
	tviTemp.TriggerClickEvent=true; //�Ƿ�ѡ��ʱ�Զ�����TreeViewOnClick()����

	//������ͼ�ṹ
	tviTemp.insertPage("root","����޶�","",1);
	tviTemp.insertPage("root","�ͻ��޶�","",2);
	String sFolder1=tviTemp.insertFolder("root","�����޶�","",3);
	
	tviTemp.insertPage(sFolder1,"��ҵ","",1);
	tviTemp.insertPage(sFolder1,"����","",2);
	tviTemp.insertPage(sFolder1,"��ģ","",3);
	tviTemp.insertPage(sFolder1,"����","",4);
	tviTemp.insertPage(sFolder1,"���յȼ�","",5);
	tviTemp.insertPage(sFolder1,"����","",6);
	tviTemp.insertPage(sFolder1,"��Ʒ","",7);
	
	String sFolder4 = tviTemp.insertFolder("root","�����޶�","",4);
	tviTemp.insertPage(sFolder4,"������϶���","",1);
		
	String sFolder5 = tviTemp.insertFolder(sFolder4,"��������޶�","",2);
	
	String sSql = "select SerialNo,GetItemName('CombiType',CombiType1) as CombiType1,"+
				  "GetItemName('CombiType',CombiType2) as CombiType2,GetItemName('CombiType',CombiType3) as CombiType3 "+
				  "from XLIMIT_DEF "+
				  "order by CombiType1,CombiType2,CombiType3";
	ASResultSet rs = Sqlca.getResultSet(sSql);
	int i = 0;
	String sInfo = "";
	while(rs.next())
	{
		i++;
		sInfo = "";
		sInfo = sInfo + rs.getString("CombiType1") + " - ";
		if(rs.getString("CombiType3")!=null)
			sInfo = sInfo + rs.getString("CombiType2") + " - " + rs.getString("CombiType3");
		else
			sInfo = sInfo + rs.getString("CombiType2") ;
			
		tviTemp.insertPage(sFolder5,sInfo,"javascript:top.doAction(\"XCombiLimit\",\""+rs.getString(1)+"\")",i);
	}
	rs.getStatement().close();	
		
	//��һ�ֶ�����ͼ�ṹ�ķ�����SQL
	//String sSqlTreeView = "from EXAMPLE_INFO";
	//tviTemp.initWithSql("SortNo","ExampleName","ExampleID","","",sSqlTreeView,"Order By SortNo",Sqlca);
	//����������������Ϊ�� ID�ֶ�,Name�ֶ�,Value�ֶ�,Script�ֶ�,Picture�ֶ�,From�Ӿ�,OrderBy�Ӿ�,Sqlca
	%>
<%/*~END~*/%>




<%/*~BEGIN~���ɱ༭��[Editable=false;CodeAreaID=Main04;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/Main04.jsp"%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��[Editable=true;CodeAreaID=Main05;Describe=��ͼ�¼�;]~*/%>
	<script type="text/javascript"> 
	/*~[Describe=treeview����ѡ���¼�(��̬ʹ��);InputParam=XCombiLimit,ResultSet;OutPutParam=��;]~*/
	function doAction(sAction,sSerialNo)
	{
		if (sAction=="XCombiLimit")  
		{			
			OpenComp("XCombiLimitList","/LimitManage/XCombiLimitList.jsp","LimitSerialNo="+sSerialNo+"","right");	
		}
	}
	/*~[Describe=treeview����ѡ���¼�;InputParam=��;OutPutParam=��;]~*/

	function TreeViewOnClick()
	{
		//���tviTemp.TriggerClickEvent=true�����ڵ���ʱ������������
		var sCurItemID = getCurTVItem().id;
		var sCurItemname = getCurTVItem().name;

		if(sCurItemname=='����޶�'){
			OpenComp("RegularLimitList","/LimitManage/RegularLimitList.jsp","","right");

		}
		else if(sCurItemname=='�ͻ��޶�'){
			OpenComp("CustomerLimitList","/LimitManage/CustomerLimitList.jsp","","right");						

		}
		else if(sCurItemname=='��ҵ'){
			OpenComp("CombiLimitList","/LimitManage/CombiLimitList.jsp","KindCode=IndustryType","right");	
			
		}
		else if(sCurItemname=='����'){
			OpenComp("CombiLimitList","/LimitManage/CombiLimitList.jsp","KindCode=BankAddress","right");
			
		}
		else if(sCurItemname=='��ģ'){
			OpenComp("CombiLimitList","/LimitManage/CombiLimitList.jsp","KindCode=Scope","right");
			
		}
		else if(sCurItemname=='����'){
			OpenComp("CombiLimitList","/LimitManage/CombiLimitList.jsp","KindCode=Term","right");
			
		}
		else if(sCurItemname=='���յȼ�'){
			OpenComp("CombiLimitList","/LimitManage/CombiLimitList.jsp","KindCode=CustomerLevel","right");
			
		}
		else if(sCurItemname=='����'){
			OpenComp("CombiLimitList","/LimitManage/CombiLimitList.jsp","KindCode=Warrant","right");
			
		}
		else if(sCurItemname=='��Ʒ'){
			OpenComp("CombiLimitList","/LimitManage/CombiLimitList.jsp","KindCode=Product","right");
			
		}								
		else if(sCurItemname=='������϶���'){
			OpenComp("XCombiDef","/LimitManage/XCombiDef.jsp","","right");
			
		}
		else{
			return;
		}
		setTitle(getCurTVItem().name);
	}

	
	
	/*~[Describe=����treeview;InputParam=��;OutPutParam=��;]~*/
	function startMenu() 
	{
		<%=tviTemp.generateHTMLTreeView()%>
	}
		
	</script> 
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��[Editable=true;CodeAreaID=Main06;Describe=��ҳ��װ��ʱִ��,��ʼ��;]~*/%>
	<script type="text/javascript">
	startMenu();
	expandNode('root');		
	</script>
<%/*~END~*/%>
<%@ include file="/IncludeEnd.jsp"%>
