<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
		/*
		Author:   cwzhan 2004-12-15
		Tester:
		Content: ������Ŀ��Ϣ����
		Input Param:
                    FunctionID��    �������
 		Output param:
		                
		History Log: 
            
	 */
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "Ӧ��"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
	String sSql;
	String sSortNo; //������
	
	//����������	
	String sFunctionID =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("FunctionID"));
	if(sFunctionID==null) sFunctionID="";

%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%	
   	String sHeaders[][] = {
				{"FunctionID","����ID"},
				{"CompID","���ID"},
				{"PageID","ҳ��ID"},
				{"FunctionName","��������"},
				{"RightID","Ȩ��ID"},
				{"TargetComp","Դ���"},
				{"InfoRightType","InfoRightType"},
				{"DefaultForm","DefaultForm"},
				{"TargetPage","TargetPage"},
				{"Remark","��ע"},
				{"InputUserName","������"},
				{"InputUser","������"},
				{"InputOrgName","�������"},
				{"InputOrg","�������"},
				{"InputTime","����ʱ��"},
				{"UpdateUserName","������"},
				{"UpdateUser","������"},
				{"UpdateTime","����ʱ��"}
			       };  

	sSql = " Select  "+
				"FunctionID,"+
				"CompID,"+
				"PageID,"+
				"FunctionName,"+
				"RightID,"+
				"TargetComp,"+
				"InfoRightType,"+
				"DefaultForm,"+
				"TargetPage,"+
				"Remark,"+
				"getUserName(InputUser) as InputUserName,"+
				"InputUser,"+
				"getOrgName(InputOrg) as InputOrgName,"+
				"InputOrg,"+
				"InputTime,"+
				"getUserName(UpdateUser) as UpdateUserName,"+
				"UpdateUser,"+
				"UpdateTime "+
				"From REG_FUNCTION_DEF Where FunctionID = '"+sFunctionID+"'";
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.UpdateTable="REG_FUNCTION_DEF";
	doTemp.setKey("FunctionID",true);
	doTemp.setHeader(sHeaders);

	doTemp.setHTMLStyle("FunctionID"," style={width:160px} ");
	doTemp.setHTMLStyle("CompID"," style={width:160px} ");
	doTemp.setHTMLStyle("PageID"," style={width:160px} ");
	doTemp.setHTMLStyle("FunctionName"," style={width:160px} ");
	doTemp.setHTMLStyle("RightID"," style={width:160px} ");
	doTemp.setHTMLStyle("TargetComp"," style={width:160px} ");
	doTemp.setHTMLStyle("InfoRightType"," style={width:160px} ");
	doTemp.setHTMLStyle("DefaultForm"," style={width:160px} ");
	doTemp.setHTMLStyle("TargetPage"," style={width:160px} ");

	doTemp.setHTMLStyle("InputUser,UpdateUser"," style={width:160px} ");
	doTemp.setHTMLStyle("InputOrg"," style={width:160px} ");
	doTemp.setHTMLStyle("InputTime,UpdateTime"," style={width:130px} ");
	doTemp.setReadOnly("InputUserName,InputOrgName,UpdateUserName,InputTime,UpdateTime",true);
	doTemp.setUpdateable("InputUserName,InputOrgName,UpdateUserName",false);
  	doTemp.setVisible("InputUser,UpdateUser,InputOrg",false);    	

 	doTemp.setEditStyle("PageID,TargetPage,Remark","3");
	doTemp.setHTMLStyle("PageID,TargetPage,Remark"," style={height:100px;width:600px;overflow:auto} ");
			
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д

	//��������¼�
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	

	String sCriteriaAreaHTML = ""; 
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
		{"true","","Button","����","�����޸�","saveRecord()",sResourcesPath},
		// Del by wuxiong 2005-02-22 �򷵻���TreeView�л��д��� {"true","","Button","����","���ش����б�","doReturn('N')",sResourcesPath}
		};
	%> 
<%/*~END~*/%>




<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">
    var sCurFunctionID=""; //��¼��ǰ��ѡ���еĴ����

	//---------------------���尴ť�¼�------------------------------------
	/*~[Describe=����;InputParam=�����¼�;OutPutParam=��;]~*/
	function saveRecord()
	{
		setItemValue(0,0,"UpdateUser","<%=CurUser.getUserID()%>");
		setItemValue(0,0,"UpdateUserName","<%=CurUser.getUserName()%>");
		setItemValue(0,0,"UpdateTime","<%=StringFunction.getToday()%>");
	        as_save("myiframe0","doReturn('Y');");
	}
    
	/*~[Describe=����;InputParam=��;OutPutParam=��;]~*/
	function doReturn(sIsRefresh){
		sObjectNo = getItemValue(0,getRow(),"FunctionID");
	        parent.sObjectInfo = sObjectNo+"@"+sIsRefresh;
		parent.closeAndReturn();
	}
    
	</script>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">
	function initRow()
	{
		if (getRowCount(0)==0) //���û���ҵ���Ӧ��¼��������һ�����������ֶ�Ĭ��ֵ
		{
			as_add("myiframe0");//������¼
			setItemValue(0,0,"InputUser","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"InputUserName","<%=CurUser.getUserName()%>");
			setItemValue(0,0,"InputOrg","<%=CurOrg.getOrgID()%>");
			setItemValue(0,0,"InputOrgName","<%=CurOrg.getOrgName()%>");
			setItemValue(0,0,"InputTime","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"UpdateUser","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"UpdateUserName","<%=CurUser.getUserName()%>");
			setItemValue(0,0,"UpdateTime","<%=StringFunction.getToday()%>");
			bIsInsert = true;
		}
	}

	</script>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List07;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script type="text/javascript">	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	initRow();
</script>	
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>
