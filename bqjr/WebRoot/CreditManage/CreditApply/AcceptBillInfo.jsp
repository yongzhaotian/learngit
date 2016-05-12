<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/%>
	<%
	/*
		Author: cwliu 2004-11-29  ndeng 2004-11-30
		Tester:
		Describe: ���Ʊ����Ϣ
		Input Param:
			ObjectType: ��������
			ObjectNo:   ������
			SerialNo:	��ˮ��
		Output Param:
			

		HistoryLog:
			
	 */
	%>
<%/*~END~*/%>



<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "���Ʊ����Ϣ"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>



<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
	
	//����������

	String sObjectType  = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));
	String sObjectNo    = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	String sPerPutOutNo    = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("PerPutOutNo"));
	
	//���ҳ�����	
	String sSerialNo    = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
	if(sSerialNo == null ) sSerialNo = "";
	String sSql = "";
	String sInterSerialNo = "";
    String sAccountNo = "";
    String sGatheringName = "";
    String sAboutBankID = "";
    String sAboutBankName = "";
    boolean bIsHave = false;
    
	String sSqlNo = "select InterSerialNo,AccountNo,GatheringName,AboutBankID,AboutBankName from BILL_INFO where ObjectNo =:ObjectNo"+
                    " and ObjectType=:ObjectType and InputUserID=:InputUserID order by InterSerialNo DESC";
	SqlObject so = new SqlObject(sSqlNo);
	so.setParameter("ObjectNo",sObjectNo).setParameter("ObjectType",sObjectType).setParameter("InputUserID",CurUser.getUserID());
    ASResultSet rsNo = Sqlca.getResultSet(so);
    if (rsNo.next()) {
        bIsHave = true;
        sInterSerialNo = rsNo.getString("InterSerialNo");
        sAccountNo = rsNo.getString("AccountNo");
        sGatheringName = rsNo.getString("GatheringName");
        sAboutBankID = rsNo.getString("AboutBankID");
        sAboutBankName = rsNo.getString("AboutBankName");     
    }
    rsNo.getStatement().close();
    if(sAccountNo==null)sAccountNo="";
    if(sGatheringName==null)sGatheringName="";
    if(sAboutBankID==null)sAboutBankID="";
    if(sAboutBankName==null)sAboutBankName="";
   
%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/%>
	<%
	//ͨ����ʾģ�����ASDataObject����doTemp
	String sTempletNo = "AcceptBillInfo";
	//out.println(sTempletNo);
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sObjectType+","+sObjectNo+","+sSerialNo);
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
		var sInterSerialNo = getItemValue(0,getRow(),"InterSerialNo");
		if (sInterSerialNo.length > 4) {
			alert("�жһ�Ʊ������Ų��ܳ���4λ��");
			return;
		}

		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		sBusinessSum = getItemValue(0,getRow(),"BillSum");
		if (sBusinessSum == null || sBusinessSum=="undefined" || sBusinessSum=="") {
			alert("Ʊ�ݽ��δ¼�룡");
			return;
		}
		<%
		if (sPerPutOutNo!=null) {
		%>
		sMessage = PopPage("/CreditManage/CreditApply/AcceptBillCheckSumAction.jsp?SerialNo="+sSerialNo+"&ObjectNo=<%=sPerPutOutNo%>&ObjectType=PutOutApply&BusinessSum="+sBusinessSum,"","");
		<%
		} else {
		%>
		sMessage = PopPage("/CreditManage/CreditApply/AcceptBillCheckSumAction.jsp?SerialNo="+sSerialNo+"&ObjectNo=<%=sObjectNo%>&ObjectType=<%=sObjectType%>&BusinessSum="+sBusinessSum,"","");		<%
		}
		%>

		if(typeof(sMessage)!="undefined" && sMessage!="") {
			alert(sMessage);
			return;
		}

		if(bIsInsert){
			beforeInsert();
		}

		beforeUpdate();
		as_save("myiframe0",sPostEvents);	
	}
	
	/*~[Describe=�����б�ҳ��;InputParam=��;OutPutParam=��;]~*/
	function goBack()
	{
		OpenPage("/CreditManage/CreditApply/AcceptBillList.jsp","_self","");
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
	/*~[Describe=ִ�и��²���ǰִ�еĴ���;InputParam=��;OutPutParam=��;]~*/
	function beforeUpdate()
	{
		setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
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
			setItemValue(0,0,"InputOrgID","<%=CurUser.getOrgID()%>");
			setItemValue(0,0,"InputUserName","<%=CurUser.getUserName()%>");
			setItemValue(0,0,"InputOrgName","<%=CurOrg.getOrgName()%>");
			setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
			bIsInsert = true;
			setItemValue(0,0,"InterSerialNo","0001");
			<%
			if (sPerPutOutNo!=null) {
			%>
				setItemValue(0,0,"PerPutOutNo","<%=sPerPutOutNo%>");
			<%
			}
			%>
			<%
			if(bIsHave)
			{
			        //����ַ����������ٵ��ַ�����ת������������λǰ��0
			        sInterSerialNo = "1" + sInterSerialNo;
			        int dInterSerialNo = Integer.parseInt(sInterSerialNo);
			        dInterSerialNo = dInterSerialNo + 1;
			        String sdInterSerialNo = String.valueOf(dInterSerialNo);
			        String ssdInterSerialNo = sdInterSerialNo.substring(1);
			%>
			    setItemValue(0,0,"InterSerialNo","<%=ssdInterSerialNo%>");
			    setItemValue(0,0,"AccountNo","<%=sAccountNo%>");
    			setItemValue(0,0,"GatheringName","<%=sGatheringName%>");
    			setItemValue(0,0,"AboutBankID","<%=sAboutBankID%>");
    			setItemValue(0,0,"AboutBankName","<%=sAboutBankName%>");
			<%
			}
			%>
		}
    }
	
	/*~[Describe=��ʼ����ˮ���ֶ�;InputParam=��;OutPutParam=��;]~*/
	function initSerialNo() 
	{
		var sTableName = "BILL_INFO";//����
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