<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
	Author:   zywei 2006.3.22
	Tester:
	Content: ǩ��Ԥ���ź��϶����
	Input Param:
		ObjectNo��Ԥ���ź���ˮ��
		SignalType��Ԥ�����ͣ�01������02�������
	Output param:
	
	History Log:
	
	*/
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "ǩ���϶����";
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%	
	//�������
	String sSql = "";
	//��ȡ�������
	String sObjectNo = DataConvert.toRealString(iPostChange,CurComp.getParameter("ObjectNo"));
	String sSignalType = DataConvert.toRealString(iPostChange,CurComp.getParameter("SignalType"));
	//����ֵת��Ϊ���ַ���	
	if(sObjectNo == null) sObjectNo = "";
	if(sSignalType == null) sSignalType = "";
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
	<%
	String sHeaders[][]={     
							{"ConfirmType","��ʵ����"},
							{"NextCheckDate","�´�Ԥ���������"},
							{"NextCheckUserName","�´�Ԥ�������"},
							{"SignalLevel","Ԥ������"},
							{"opinion","�϶����"},
							{"Remark","��ע"},
							{"CheckOrgName","�϶�����"},
							{"CheckUserName","�϶���"},
							{"CheckDate","�϶�ʱ��"}                  
                        };                    
		
	sSql =  " select SerialNo,ObjectNo,ConfirmType,NextCheckDate,NextCheckUser, "+
			" GetUserName(NextCheckUser) as NextCheckUserName,SignalLevel,Opinion, "+
			" Remark,CheckOrg,GetOrgName(CheckOrg) as CheckOrgName,CheckUser, "+
			" GetUserName(CheckUser) as CheckUserName,CheckDate "+
			" from RISKSIGNAL_OPINION "+
			" where ObjectNo = '"+sObjectNo+"' "+
			" and CheckUser = '"+CurUser.getUserID()+"' ";
	//ͨ��sql����doTemp���ݶ���
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.UpdateTable="RISKSIGNAL_OPINION";
	//���ùؼ���
	doTemp.setKey("SerialNo,ObjectNo",true);
	//���ñ�ͷ
	doTemp.setHeader(sHeaders);
	//���ò��ɼ���
	doTemp.setVisible("SerialNo,ObjectNo,CheckUser,CheckOrg,NextCheckUser",false);
	
	//��������������
	doTemp.setDDDWCode("ConfirmType","ConfirmType");
	doTemp.setDDDWCode("SignalLevel","SignalLevel");
		
	//���ø�ʽ
	doTemp.setCheckFormat("NextCheckDate","3");	
	doTemp.setHTMLStyle("CheckUserName,CheckDate"," style={width:80px;} ");
	doTemp.setHTMLStyle("Opinion,Remark"," style={height:100px;width:400px} ");
	doTemp.setEditStyle("Opinion,Remark","3");
 	doTemp.setLimit("Opinion,Remark",100);
 	doTemp.setReadOnly("CheckOrgName,CheckUserName,CheckDate",true);
 	doTemp.setRequired("ConfirmType,Opinion",true);
 	if(sSignalType.equals("02")) 	
 		doTemp.setVisible("NextCheckDate,NextCheckUserName,SignalLevel",false);
	if(sSignalType.equals("01"))
		doTemp.setRequired("NextCheckDate,NextCheckUserName",true);
  	doTemp.setUpdateable("NextCheckUserName,CheckOrgName,CheckUserName",false);
  	doTemp.setUnit("NextCheckUserName","<input type=button value=\"...\" onClick=parent.selectUser()>");		
	
  	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	
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
			{"true","","Button","����","�����б�ҳ��","goBack()",sResourcesPath}
		};

		
	%> 
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=Info05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/Info05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info06;Describe=���尴ť�¼�;]~*/%>
	<script type="text/javascript">
	var bIsInsert = false; //���DW�Ƿ��ڡ�����״̬��
	
	//---------------------���尴ť�¼�------------------------------------
	/*~[Describe=����;InputParam=�����¼�;OutPutParam=��;]~*/
	function saveRecord(sPostEvents)
	{	
		if(bIsInsert){
			beforeInsert();
		}
		//������ǩ������Ϊ�հ��ַ�
		if(/^\s*$/.exec(getItemValue(0,0,"Opinion"))){
			alert("��ǩ���϶������");
			setItemValue(0,0,"Opinion","");
			return;
		}
		as_save("myiframe0",sPostEvents);	
	}
	
	/*~[Describe=�رմ�ҳ��;InputParam=��;OutPutParam=��;]~*/
	function goBack()
	{
		self.close();
	}	
	
	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info07;Describe=�Զ��庯��;]~*/%>

	<script type="text/javascript">
	
	/*~[Describe=ִ�в������ǰִ�еĴ���;InputParam=��;OutPutParam=��;]~*/
	function beforeInsert()
	{
		initSerialNo();
		bIsInsert = false;
	}
	
	/*~[Describe=ҳ��װ��ʱ����DW���г�ʼ��;InputParam=��;OutPutParam=��;]~*/
	function initRow()
	{
		if (getRowCount(0)==0) //���û���ҵ���Ӧ��¼��������һ�����������ֶ�Ĭ��ֵ
		{
			as_add("myiframe0");//������¼
			setItemValue(0,0,"ObjectNo","<%=sObjectNo%>");
			setItemValue(0,0,"CheckUser","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"CheckUserName","<%=CurUser.getUserName()%>");
			setItemValue(0,0,"CheckOrg","<%=CurOrg.getOrgID()%>");			
			setItemValue(0,0,"CheckOrgName","<%=CurOrg.getOrgName()%>");		
			setItemValue(0,0,"CheckDate","<%=StringFunction.getToday()%>");
			bIsInsert = true;			
		}
    }
    
    /*~[Describe=��ʼ����ˮ���ֶ�;InputParam=��;OutPutParam=��;]~*/
	function initSerialNo() 
	{
		var sTableName = "RISKSIGNAL_OPINION";//����
		var sColumnName = "SerialNo";//�ֶ���
		var sPrefix = "";//ǰ׺

		//��ȡ��ˮ��
		var sSerialNo = getSerialNo(sTableName,sColumnName,sPrefix);
		//����ˮ�������Ӧ�ֶ�
		setItemValue(0,getRow(),sColumnName,sSerialNo);
	}
    
    /*~[Describe=�����û�ѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/
	function selectUser()
	{			
		setObjectValue("SelectAllUser","","@NextCheckUser@0@NextCheckUserName@1",0,0,"");
	}
	
	</script>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info08;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script type="text/javascript">	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	initRow(); //ҳ��װ��ʱ����DW��ǰ��¼���г�ʼ��
</script>	
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>