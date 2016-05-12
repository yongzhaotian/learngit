<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
  
<%
	String PG_TITLE = "���ü�����Ϣ"; // ��������ڱ��� <title> PG_TITLE </title>
	//�������
	String businessType = "";
	String projectVersion = "";
	
	//���ҳ�����
	String SerialNo = DataConvert.toRealString(iPostChange,CurPage.getParameter("SerialNo"));
	String sObjectNo = DataConvert.toRealString(iPostChange,CurPage.getParameter("ObjectNo"));
	String sObjectType = DataConvert.toRealString(iPostChange,CurPage.getParameter("ObjectType"));
	if(SerialNo == null) SerialNo = "";
	if(sObjectNo == null) sObjectNo = "";
	if(sObjectType == null) sObjectType = "";
	//��ʾģ����
	String sTempletNo = "AcctFeeWaiveInfo";
	String sTempletFilter = "1=1";
	
	ASDataObject doTemp = new ASDataObject(sTempletNo,sTempletFilter,Sqlca);
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage, doTemp, Sqlca);
	dwTemp.Style = "2"; //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(SerialNo);
	for(int i=0;i < vTemp.size();i++)out.print((String) vTemp.get(i));
	

	String sButtons[][] = {
			{"true", "", "Button", "����", "����һ����Ϣ","saveRecord()",sResourcesPath},
			{"true", "", "Button", "����", "��������","goBack()",sResourcesPath},
	};
%>
<%@include file="/Resources/CodeParts/List05.jsp"%>

<script language=javascript>
	//����
	function saveRecord(){
		if(bIsInsert){
			beforeInsert();
		}else
			beforeUpdate();	
		as_save("myiframe0","goBack();");
	}
	//����
	function goBack(){
		OpenPage("/Accounting/LoanDetail/LoanTerm/AcctFeeWaiveList.jsp","_self","");
	}
	function beforeInsert()
	{
		initSerialNo();
		bIsInsert = false;
	}
	/*~[Describe=ִ�и��²���ǰִ�еĴ���;InputParam=��;OutPutParam=��;]~*/
	function beforeUpdate()
	{
		setItemValue(0,0,"UpdateTime","<%=StringFunction.getToday()%>");
		setItemValue(0,0,"UpdateUser","<%=CurUser.getUserName()%>");
		setItemValue(0,0,"UpdateOrg","<%=CurOrg.getOrgName()%>");
	}

	/*~[Describe=��ʼ����ˮ���ֶ�;InputParam=��;OutPutParam=��;]~*/
	function initSerialNo() 
	{
		var sTableName = "ACCT_FEE_WAIVE";//����
		var sColumnName = "SerialNo";//�ֶ���
		var sPrefix = "";//ǰ׺
	
		//��ȡ��ˮ��
		var sSerialNo = getSerialNo(sTableName,sColumnName,sPrefix);
		//����ˮ�������Ӧ�ֶ�
		setItemValue(0,getRow(),sColumnName,sSerialNo);
	}
	
	/*~[Describe=ҳ��װ��ʱ����DW���г�ʼ��;InputParam=��;OutPutParam=��;]~*/
	function initRow()
	{
		if (getRowCount(0)==0) //���û���ҵ���Ӧ��¼��������һ�����������ֶ�Ĭ��ֵ
		{
			as_add("myiframe0");//������¼
			setItemValue(0,0,"ObjectType","<%=sObjectType%>");
			setItemValue(0,0,"ObjectNo","<%=sObjectNo%>");
			setItemValue(0,0,"InputUserID","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"InputOrgID","<%=CurOrg.getOrgID()%>");
			setItemValue(0,0,"InputUser","<%=CurUser.getUserName()%>");
			setItemValue(0,0,"InputOrg","<%=CurOrg.getOrgName()%>");
			setItemValue(0,0,"InputTime","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"FinishDate","<%=StringFunction.getToday()%>");
			bIsInsert = true;
		}else{
		    bIsInsert = false;
		}
	}
	//�޸ļ�������(0Ϊ���1Ϊ����)
	function changeWaiveType(){
		var sResult = getItemValue(0,getRow(),"WaiveType");
		if("0"==sResult){
			try{
				setItemDisabled(0,getRow(),"WaiveAmount",false);
				setItemDisabled(0,getRow(),"WaivePercent",true);
				setItemValue(0,getRow(),"WaivePercent","");
				setItemRequired(0,getRow(),"WaiveAmount",1);
				setItemRequired(0,getRow(),"WaivePercent",0);
			}catch(e){}
			
			return;
		}else{
			try{
				setItemDisabled(0,getRow(),"WaiveAmount",true);
				setItemDisabled(0,getRow(),"WaivePercent",false);
				setItemValue(0,getRow(),"WaiveAmount","");
				setItemRequired(0,getRow(),"WaiveAmount",0);
				setItemRequired(0,getRow(),"WaivePercent",1);
			}catch(e){}
			
			return;
		}
	}
</script>
<script language=javascript>
	//��ʼ��
	AsOne.AsInit();
	init();
	var bFreeFormMultiCol = true;
	my_load(2,0,'myiframe0');
	initRow();
</script>
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>