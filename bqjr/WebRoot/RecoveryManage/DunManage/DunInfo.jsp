<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   ��ҵ� 2005-08-18
		Tester:
		Content: ���պ���ϸ��Ϣ_List
		Input Param:
				SerialNo	���պ���ˮ��
				���в�����Ϊ�����������
				ObjectType	�������ͣ�BUSINESS_CONTRACT
				ObjectNo	�����ţ���ͬ���
						��������������Ŀ���Ǳ�����չ��,�������ܲ������û������ʲ��Ĵ��պ�����.
						
		Output param:
		
		History Log:
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "��������"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info02;Describe=�����������ȡ����;]~*/%>
<%
	//����������	
	String sObjectType	=DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectType"));
	if(sObjectType==null) sObjectType="";
	String sObjectNo	=DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectNo"));
	if(sObjectNo==null) sObjectNo="";
	String sSerialNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));			
	if(sSerialNo==null) sSerialNo="";
	String sCurrency = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("Currency"));			
	if(sCurrency==null) sCurrency="";
	String flag = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("flag"));
	if(flag==null) flag="";
	
	//ͨ��DunList.jspҳ�洫�����Ĳ�������ѯ�����𡢱�����Ϣ��������Ϣ������������ս���ֵ     Add by zhuang 2010-03-17
    ASResultSet rs = null;
	double dDunSum = 0.0;//���ս��
    double dBusinessSum = 0.0;//����
    double dInterestBalance1 = 0.0;//������Ϣ
    double dInterestBalance2 = 0.0;//������Ϣ
    double dElseFee = 0.0;//������������ʱ������ֶε�ֵΪ 0.0
    
    String sSql = "select BusinessSum,InterestBalance1,InterestBalance2 from business_contract where SerialNo = :SerialNo";
    rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("SerialNo",sObjectNo));
    if(rs.next()){
        dBusinessSum = rs.getDouble("BusinessSum");
        dInterestBalance1 = rs.getDouble("InterestBalance1");
        dInterestBalance2 = rs.getDouble("InterestBalance2");
        dDunSum = dBusinessSum + dInterestBalance1 + dInterestBalance2 + dElseFee;//���ս�������������ĺ�
    }
    rs.getStatement().close();
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/%>
	<%
	ASDataObject doTemp = new ASDataObject("DunManageInfo",Sqlca);

	//�����Զ��ۼ��ֶ�
	doTemp.appendHTMLStyle("Corpus,InterestInSheet,InterestOutSheet,ElseFee"," onChange=\"javascript:parent.getDunSum()\" ");
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д

	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sSerialNo);
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
		{(!flag.equals("comp")?"true":"false"),"","Button","����","����","goBack()",sResourcesPath},
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
	    fCorpus = getItemValue(0,getRow(),"Corpus");
		fInterestInSheet = getItemValue(0,getRow(),"InterestInSheet");
		fInterestOutSheet = getItemValue(0,getRow(),"InterestOutSheet");
		fElseFee = getItemValue(0,getRow(),"ElseFee");
		fFeedbackContent = getItemValue(0,getRow(),"FeedbackContent");
	
     	if(bIsInsert)
		{
			beforeInsert();
			bIsInsert = false;
		}

		beforeUpdate();
		as_save("myiframe0",sPostEvents);		
	}
	
     	//���ս��������ϼƻ��
	function getDunSum()
	{
		fCorpus = getItemValue(0,getRow(),"Corpus");
		fInterestInSheet = getItemValue(0,getRow(),"InterestInSheet");
		fInterestOutSheet = getItemValue(0,getRow(),"InterestOutSheet");
		fElseFee = getItemValue(0,getRow(),"ElseFee");
     		
		if(typeof(fCorpus)=="undefined" || fCorpus.length==0) fCorpus=0; 
		if(typeof(fInterestInSheet)=="undefined" || fInterestInSheet.length==0) fInterestInSheet=0; 
		if(typeof(fInterestOutSheet)=="undefined" || fInterestOutSheet.length==0) fInterestOutSheet=0; 
		if(typeof(fElseFee)=="undefined" || fElseFee.length==0) fElseFee=0; 
     		
		fDunSum = fCorpus+fInterestInSheet+fInterestOutSheet+fElseFee;
		setItemValue(0,getRow(),"DunSum",fDunSum);
	}
	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info07;Describe=�Զ��庯��;]~*/%>

	<script type="text/javascript">

	/*~[Describe=ִ�в������ǰִ�еĴ���;InputParam=��;OutPutParam=��;]~*/
	function beforeInsert()
	{
		initSerialNo();//��ʼ����ˮ���ֶ�
		setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
				
		bIsInsert = false;
	}
	
	/*~[Describe=ִ�и��²���ǰִ�еĴ���;InputParam=��;OutPutParam=��;]~*/
	function beforeUpdate()
	{
		setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
	}
	
	function goBack()
	{
		OpenPage("/RecoveryManage/DunManage/DunList.jsp?ObjectType="+"<%=sObjectType%>"+"&ObjectNo="+"<%=sObjectNo%>"+"&Currency="+"<%=sCurrency%>","_self","");
	}

	/*~[Describe=�����û�ѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/
	function selectUser()
	{
		setObjectInfo("User","OrgID=<%=CurOrg.getOrgID()%>@OperateUserID@0@OperateUserName@1@OperateOrgID@2@OperateOrgName@3",0,0);
		/*
		* setObjectInfo()����˵����---------------------------
		* ���ܣ� ����ָ�������Ӧ�Ĳ�ѯѡ��Ի��򣬲������صĶ������õ�ָ��DW����
		* ����ֵ�� ���硰ObjectID@ObjectName���ķ��ش��������ж�Σ����硰UserID@UserName@OrgID@OrgName��
		* sObjectType�� ��������
		* sValueString��ʽ�� ������� @ ID���� @ ID�ڷ��ش��е�λ�� @ Name���� @ Name�ڷ��ش��е�λ��
		* iArgDW:  �ڼ���DW��Ĭ��Ϊ0
		* iArgRow:  �ڼ��У�Ĭ��Ϊ0
		* ��������� common.js -----------------------------
		*/
	}


	/*~[Describe=ҳ��װ��ʱ����DW���г�ʼ��;InputParam=��;OutPutParam=��;]~*/
	function initRow()
	{
		if (getRowCount(0)==0) //���û���ҵ���Ӧ��¼��������һ�����������ֶ�Ĭ��ֵ
		{
			as_add("myiframe0");//������¼
			bIsInsert = true;
			
			setItemValue(0,0,"DunDate","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"InputUserID","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"InputUserID","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"InputUserID","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"InputUserID","<%=CurUser.getUserID()%>");

			setItemValue(0,0,"InputUserID","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"InputUserName","<%=CurUser.getUserName()%>");
			setItemValue(0,0,"InputOrgID","<%=CurOrg.getOrgID()%>");			
			setItemValue(0,0,"InputOrgName","<%=CurOrg.getOrgName()%>");			
			setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"ObjectType","<%=sObjectType%>");
			setItemValue(0,0,"ObjectNo","<%=sObjectNo%>");		
			setItemValue(0,0,"DunCurrency","<%=sCurrency%>");	
			
			//��ʼ�����ս����𡢱�����Ϣ��������Ϣ���������        Add by zhuang 2010-03-17
            setItemValue(0,0,"Corpus","<%=DataConvert.toMoney(dBusinessSum)%>");
            setItemValue(0,0,"InterestInSheet","<%=DataConvert.toMoney(dInterestBalance1)%>");   
            setItemValue(0,0,"InterestOutSheet","<%=DataConvert.toMoney(dInterestBalance2)%>");  
            setItemValue(0,0,"ElseFee","<%=DataConvert.toMoney(dElseFee)%>");
            setItemValue(0,0,"DunSum","<%=DataConvert.toMoney(dDunSum)%>");

			setItemValue(0,0,"OperateUserID","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"OperateUserName","<%=CurUser.getUserName()%>");
			setItemValue(0,0,"OperateOrgID","<%=CurOrg.getOrgID()%>");	
			setItemValue(0,0,"OperateOrgName","<%=CurOrg.getOrgName()%>");
		}
    }
	
	/*~[Describe=��ʼ����ˮ���ֶ�;InputParam=��;OutPutParam=��;]~*/
	function initSerialNo() 
	{
		var sTableName = "Dun_Info";//����
		var sColumnName = "SerialNo";//�ֶ���
		var sPrefix = "";//ǰ׺

		//��ȡ��ˮ��
		var sSerialNo = getSerialNo(sTableName,sColumnName,sPrefix);
		//����ˮ�������Ӧ�ֶ�
		setItemValue(0,getRow(),sColumnName,sSerialNo);
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