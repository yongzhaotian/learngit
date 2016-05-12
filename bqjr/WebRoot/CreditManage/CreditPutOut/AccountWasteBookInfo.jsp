<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		ҳ��˵��: ʾ���б�ҳ��
	 */
	String PG_TITLE = "ҵ����ˮ��Ϣ";
	//���ҳ�����
	String sSerialNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
	if(sSerialNo == null) sSerialNo = "";
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	if(sObjectNo == null) sObjectNo = "";
	String sAccountType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("AccountType"));
	if(sAccountType.equals("01"))//01��Ӧ����   02��Ӧ����
		sAccountType = "0";
	else
		sAccountType = "1";
	
	//ͨ��DWģ�Ͳ���ASDataObject����doTemp
	String sTempletNo="";
	String sSql = "";
	sSql = "select OccurDirection from BUSINESS_WASTEBOOK where SerialNo=:SerialNo";
	String sOccurDirection = Sqlca.getString(new SqlObject(sSql).setParameter("SerialNo",sSerialNo));
	if(sOccurDirection == null){
		sOccurDirection=sAccountType; //1.�ǻ���
	}
	if(sOccurDirection.equals("1")){
		sTempletNo="1_AccountWasteBookInfo";
	}else{
		sTempletNo="2_AccountWasteBookInfo";
	}
	
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);

	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.setPageSize(10);
	
	sSql="select BusinessType from BUSINESS_CONTRACT where SerialNo=:SerialNo";
	String sBusinessType = Sqlca.getString(new SqlObject(sSql).setParameter("SerialNo",sObjectNo));
	sSql="select attribute4 from BUSINESS_TYPE where TypeNo=:TypeNo";
	String sOrigin = Sqlca.getString(new SqlObject(sSql).setParameter("TypeNo",sBusinessType));
	if (sOrigin == null) sOrigin = "";
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sSerialNo+","+sObjectNo+","+sAccountType);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
			{"false","","Button","����","���������޸�","saveRecord()",sResourcesPath},
			{"true","","Button","����","�����б�ҳ��","goBack()",sResourcesPath}
			};

		//����Ϊ������������Դ����628
		//if (sOccurDirection.equals("1") && !sOrigin.equals("010")) {
			//sButtons[0][0] = "true";
		//}
		%>
	<%/*~END~*/%>


	<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=Info05;Describe=����ҳ��;]~*/%>
		<%@include file="/Resources/CodeParts/Info05.jsp"%>
	<%/*~END~*/%>


	<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info06;Describe=���尴ť�¼�;]~*/%>
		<script type="text/javascript">
		var bIsInsert = false; //���DW�Ƿ��ڡ�����״̬��

		//---------------------���尴ť�¼�------------------------------------
		/*~[Describe=����;InputParam=��;OutPutParam=��;]~*/
		function saveRecord(sPostEvents)
		{
			if(bIsInsert){
				beforeInsert();
				bIsInsert = false;
			}

			as_save("myiframe0",sPostEvents);	
		}

		/*~[Describe=�����б�ҳ��;InputParam=��;OutPutParam=��;]~*/
		function goBack()
		{
			OpenPage("/CreditManage/CreditPutOut/AccountWasteBookList.jsp","_self","");
		}

		</script>
	<%/*~END~*/%>


	<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info07;Describe=�Զ��庯��;]~*/%>
		<script type="text/javascript">

		function beforeInsert()
		{		
			initSerialNo();//��ʼ����ˮ���ֶ�
		}

		/*~[Describe=��ʼ����ˮ���ֶ�;InputParam=��;OutPutParam=��;]~*/
		function initSerialNo() 
		{
			var sTableName = "BUSINESS_WASTEBOOK";//����
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
				bIsInsert = true;
				setItemValue(0,0,"OccurDirection","<%=sAccountType%>");
				setItemValue(0,0,"RelativeContractNo","<%=sObjectNo%>");
				setItemValue(0,0,"UserID","<%=CurUser.getUserID()%>");
				setItemValue(0,0,"OrgID","<%=CurOrg.getOrgID()%>");
				setItemValue(0,0,"UserName","<%=CurUser.getUserName()%>");
				setItemValue(0,0,"OrgName","<%=CurOrg.getOrgName()%>");
			}
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