<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/%>
	<%
	/*
		Author: ndeng 2005-04-20 
		Tester:
		Describe: ���Ӻ�ͬģ���������
		Input Param:
			EDocNo��
		Output Param:
			

		HistoryLog:
			
	 */
	%>
<%/*~END~*/%>



<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "�����ĵ�ģ���������"; // ��������ڱ��� <title> PG_TITLE </title>
	CurPage.setAttribute("ShowDetailArea","true");
	CurPage.setAttribute("DetailAreaHeight","300");
	%>
<%/*~END~*/%>



<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
	
	//����������

	String sEDocNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("EDocNo"));
	if(sEDocNo==null) sEDocNo="";
	
	//���ҳ�����	
%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/%>
	<%
    	 String sHeaders[][] = { 
								{"EDocNo","ģ����"},
								{"EDocName","ģ������"},
								{"EDocType","�����ĵ�����"},
								{"StamperType","ǩ��ҳ����"},
								{"IsInUse","�Ƿ���Ч"},
								{"FileNameFmt","��ʽ�ļ�"},
								{"FileNameDef","���ݶ����ļ�"},
								{"InputUserName","�Ǽ���"},
								{"InputOrgName","�Ǽǻ���"},
								{"InputTime","�Ǽ�ʱ��"},
								{"UpdateUserName","������"},
								{"UpdateOrgName","���»���"},
								{"UpdateTime","����ʱ��"}
				            }; 	 

	String sSql = " select EDocNo,EDocName,EDocType,StamperType,IsInUse,FileNameFmt,FileNameDef," +
				  " getUserName(InputUser) as InputUserName,InputUser," + 
				  " getOrgName(InputOrg) as InputOrgName,InputOrg,InputTime," +
		          " getUserName(UpdateUser) as UpdateUserName,UpdateUser," + 
		          " getOrgName(UpdateOrg) as UpdateOrgName,UpdateOrg,UpdateTime " +
		          " from EDOC_DEFINE"+
		          " where EDocNo = '"+sEDocNo+"' ";	
                	
    ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders);
	doTemp.UpdateTable = "EDOC_DEFINE"; 

	doTemp.setVisible("InputOrg,UpdateOrg,InputUser,UpdateUser,UpdateUserName,UpdateOrgName,UpdateTime",false);
	
	doTemp.setKey("EDocNo",true);
	doTemp.setReadOnly("FileNameFmt,FileNameDef,InputUserName,InputOrgName,InputTime,UpdateUserName,UpdateOrgName,UpdateTime,",true);
	if (sEDocNo != "") {
		doTemp.setReadOnly("EDocNo,EDocName",true);
		doTemp.setVisible("UpdateUserName,UpdateOrgName,UpdateTime",true);
		doTemp.setVisible("InputUserName,InputOrgName,InputTime",false);
	}
	doTemp.setDDDWCode("IsInUse","YesNo");
	doTemp.setDDDWCode("EDocType","EDocType");
	doTemp.setDDDWCode("StamperType","StamperType");
	doTemp.setRequired("EDocNo,EDocName,EdocType",true);
	doTemp.setUnit("FileNameFmt","<input type=button class=inputDate   value=\" �鿴..\" name=button2 onClick=\"javascript:parent.TemplateViewFmt();\"> ");
	doTemp.setUnit("FileNameDef","<input type=button class=inputDate   value=\" �鿴..\" name=button4 onClick=\"javascript:parent.TemplateViewDef();\"> ");
	
	doTemp.setUpdateable("InputUserName,InputOrgName,UpdateUserName,UpdateOrgName",false);
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
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
		{"true","","Button","����","���������޸�","saveRecord()",sResourcesPath},
		{"false","","Button","����","�����б�ҳ��","goBack()",sResourcesPath}
		};
	%> 
<%/*~END~*/%>




<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=Info05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/Info05.jsp"%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info06;Describe=���尴ť�¼�;]~*/%>
	<script language=javascript>
	var bIsInsert = false; //���DW�Ƿ��ڡ�����״̬��

	//---------------------���尴ť�¼�------------------------------------

	/*~[Describe=����;InputParam=�����¼�;OutPutParam=��;]~*/
	function saveRecord(sPostEvents)
	{
		if(bIsInsert){
			beforeInsert();
			sEDocNo = getItemValue(0,getRow(),"EDocNo");
			sReturn = RunMethod("Configurator","CheckEDocNoExist",sEDocNo);
			if(sReturn == sEDocNo)
			{
				alert("["+sEDocNo+"]ģ�����Ѿ����ڣ��������µ�ģ����");
				bIsInsert = true;
				return;	
			}
		}
		beforeUpdate();
		as_save("myiframe0",sPostEvents);
		//��ҵ�����͹���ҳ��
		sEDocNo = getItemValue(0,getRow(),"EDocNo");
		sEDocType = getItemValue(0,getRow(),"EDocType");
		OpenPage("/Common/EDOC/EDocRelativeList.jsp?EDocNo="+sEDocNo+"&EDocType="+sEDocType,"DetailFrame","");
	}
	
	/*~[Describe=�����б�ҳ��;InputParam=��;OutPutParam=��;]~*/
	function goBack()
	{
		OpenPage("/Common/EDOC/TemplateList.jsp","","");
	}
	
	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info07;Describe=�Զ��庯��;]~*/%>

	<script language=javascript>
	/*~[Describe=ִ�в������ǰִ�еĴ���;InputParam=��;OutPutParam=��;]~*/
	function beforeInsert()
	{
		bIsInsert = false;
	}

	/*~[Describe=ִ�и��²���ǰִ�еĴ���;InputParam=��;OutPutParam=��;]~*/
	function beforeUpdate()
	{
		
	}

	/*~[Describe=ҳ��װ��ʱ����DW���г�ʼ��;InputParam=��;OutPutParam=��;]~*/
	function initRow()
	{
		if (getRowCount(0)==0) //���û���ҵ���Ӧ��¼��������һ�����������ֶ�Ĭ��ֵ
		{
			as_add("myiframe0");//������¼
			bIsInsert = true;
			setItemValue(0,getRow(),"InputTime","<%=StringFunction.getToday()%>");
			setItemValue(0,getRow(),"InputUser","<%=CurUser.getUserID()%>");
			setItemValue(0,getRow(),"InputUserName","<%=CurUser.getUserName()%>");
			setItemValue(0,getRow(),"InputOrg","<%=CurOrg.getOrgID()%>");
			setItemValue(0,getRow(),"InputOrgName","<%=CurOrg.getOrgName()%>");
		}
		else
		{
			setItemValue(0,getRow(),"UpdateTime","<%=StringFunction.getToday()%>");
			setItemValue(0,getRow(),"InputUser","<%=CurUser.getUserID()%>");
			setItemValue(0,getRow(),"InputUserName","<%=CurUser.getUserName()%>");
			setItemValue(0,getRow(),"InputOrg","<%=CurOrg.getOrgID()%>");
			setItemValue(0,getRow(),"InputOrgName","<%=CurOrg.getOrgName()%>");
		}
    }
	
	/*~[Describe=��ʽ�ļ��鿴;InputParam=��;OutPutParam=��;]~*/
	function TemplateViewFmt()
	{
		sEDocNo = getItemValue(0,getRow(),"EDocNo");//--�������ͱ��
		sFileName = getItemValue(0,getRow(),"FileNameFmt");//--��ʽ�ļ�
	    if(typeof(sFileName)=="undefined" || sFileName.length==0) {
			alert("�ļ�δ�ϴ���");//��ѡ��һ����Ϣ��
	        return ;
		}
		popComp("EDocTemplateView","/Common/EDOC/TemplateView.jsp","EDocNo="+sEDocNo+"&EDocType=Fmt");
	}

	/*~[Describe=�����ļ��鿴;InputParam=��;OutPutParam=��;]~*/
	function TemplateViewDef()
	{
		sEDocNo = getItemValue(0,getRow(),"EDocNo");//--�������ͱ��
		sFileName = getItemValue(0,getRow(),"FileNameDef");//--��ʽ�ļ�
	    if(typeof(sFileName)=="undefined" || sFileName.length==0) {
			alert("�ļ�δ�ϴ���");//��ѡ��һ����Ϣ��
	        return ;
		}
		popComp("EDocTemplateView","/Common/EDOC/TemplateView.jsp","EDocNo="+sEDocNo+"&EDocType=Def");
	}
	</script>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info08;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script language=javascript>	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	initRow(); //ҳ��װ��ʱ����DW��ǰ��¼���г�ʼ��
	if(!bIsInsert) 
	{
		sEDocType = getItemValue(0,getRow(),"EDocType");
		OpenPage("/Common/EDOC/EDocRelativeList.jsp?EDocNo=<%=sEDocNo%>&EDocType="+sEDocType ,"DetailFrame","");
	}
</script>	
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>
