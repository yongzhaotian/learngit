<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/%>
	<%
	/*
		Author: FMWu 2004-11-29
		Tester:
		Describe: ����С���Ա��Ϣ;
		Input Param:
			CustomerID����ǰ�ͻ����
			RelativeID�������ͻ����
			Relationship��������ϵ
		Output Param:
			CustomerID����ǰ�ͻ����

		HistoryLog:
	 */
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "����С���Ա��Ϣ"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info02;Describe=�����������ȡ����;]~*/%>
<%

	//�������

	//����������

	String sCustomerID    = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerID"));

	//���ҳ�����
	String sRelativeID    = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("RelativeID"));
	String sRelationShip  = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("RelationShip"));

%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/%>
	<%
	String sHeaders[][] = {
							{"CustomerName","����С���Ա����"},
							{"CertType","֤������"},
							{"CertID","֤������"},
							{"RelativeID","����С���Ա���"},
							{"Remark","��ע"},
							{"OrgName","�Ǽǻ���"},
							{"UserName","�Ǽ���"},
							{"InputDate","�Ǽ�����"},
							{"UpdateDate","��������"}
						   };

	String sSql =	" select CustomerID,RelativeID," +
					" CustomerName,CertType,CertID,RelationShip"+
					" Remark," +
					" InputUserId,getUserName(InputUserId) as UserName,InputDate,UpdateDate "+
					" InputOrgId,getOrgName(InputOrgId) as OrgName,"+
					" from CUSTOMER_RELATIVE " +
					" where CustomerID='"+sCustomerID+"' " +
					" and RelativeID='"+sRelativeID+"' " +
					" and RelationShip ='"+sRelationShip+"'" ;

	//��sSql���ɴ������
	ASDataObject doTemp = new ASDataObject(sSql);

	//���ñ�ͷ,���±���,��ֵ,������,�ɼ����ɼ�,�Ƿ���Ը���
	doTemp.setHeader(sHeaders);
	doTemp.UpdateTable = "CUSTOMER_RELATIVE";
	doTemp.setKey("CustomerID,RelativeID,RelationShip",true);
	doTemp.setRequired("RelativeID,CustomerName,RelationShip",true);
	doTemp.setVisible("RelationShip,CustomerID,RelativeID,InputUserId,InputOrgId",false);
	doTemp.setUpdateable("UserName,OrgName",false);

	//�����ֶθ�ʽ
	doTemp.setEditStyle("Remark","3");
	doTemp.setHTMLStyle("Remark","style={height:150px;width:400px};overflow:scroll ");
	doTemp.setHTMLStyle("CustomerName"," style={width:300px} ");
	//ע��,����HTMLStyle������ReadOnly������ReadOnly������
	doTemp.setHTMLStyle("OrgName,UserName,InputDate,UpdateDate"," style={width:80px}");
	doTemp.setReadOnly("CustomerName,CertType,CertID,OrgName,UserName,InputDate,UpdateDate",true);

	//����������
	doTemp.setDDDWSql("CertType","select ItemNo,ItemName from CODE_LIBRARY where CodeNo = 'CertType' and ItemNo like '1%'");

	//����Ĭ��ֵ
	doTemp.setDefaultValue("RelationShip","0501");

	//�������ͻ����Ϊ�գ������ѡ��ͻ���ʾ��
	if(sRelativeID == null || sRelativeID.equals(""))
	{
		doTemp.setUnit("CustomerName"," <input type=button value=.. onclick=parent.selectCustomer()>");
	} else {
		doTemp.setReadOnly("RelationShip",true);
	}

	//�������ݴ���
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";//freeform��ʽ

	//���ò���͸����¼������������͸���
	dwTemp.setEvent("AfterInsert","!CustomerManage.AddRelation(#CustomerID,#RelativeID,#RelationShip)");
	dwTemp.setEvent("AfterUpdate","!CustomerManage.UpdateRelation(#CustomerID,#RelativeID,#RelationShip)");

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
			//����ǰ���м��,���ͨ�����������,���������ʾ
		    if (!RetaiveCheck()) return;
			//��������,���Ϊ��������,�����ҳ��ˢ��һ��,��ֹ�������޸�
			beforeUpdate();
			as_save("myiframe0","pageReload()");
			return;
		}

		beforeUpdate();
		as_save("myiframe0",sPostEvents);
	}

	/*~[Describe=�����б�ҳ��;InputParam=��;OutPutParam=��;]~*/
	function goBack()
	{
		OpenPage("/CustomerManage/EntManage/AssureGroupList.jsp?","_self","");
	}

	</script>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info07;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">
	/*~[Describe=��������ҳ��ˢ�¶���;InputParam=��;OutPutParam=��;]~*/
	function pageReload()
	{
		var sRelativeID   = getItemValue(0,getRow(),"RelativeID");
		var sRelationShip   = getItemValue(0,getRow(),"RelationShip");
		OpenPage("/CustomerManage/EntManage/AssureGroupInfo.jsp?RelativeID="+sRelativeID+"&RelationShip="+sRelationShip, "_self","");
	}

	/*~[Describe=�����ͻ�ѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/
	function selectCustomer()
	{
		sReturn = setObjectInfo("Customer","CustomerType=in ('030','040')@RelativeID@0@CustomerName@1",0,0);
		if(sReturn!="_CANCEL_" && typeof(sReturn)!="undefined"){
			getCustomerInfo();
		}
	}

	/*~[Describe=�õ�֤�����ͺ�֤������;InputParam=��;OutPutParam=��;]~*/
	function getCustomerInfo()
	{
		var sRelativeID   = getItemValue(0,getRow(),"RelativeID");

		sCustomerInfo     = PopPageAjax("/Common/ToolsB/GetCustomerInfoAjax.jsp?CustomerID="+sRelativeID,"","");
		if(typeof(sCustomerInfo)!="undefined" && sCustomerInfo.length!=0)
		{
			var sss = getSplitArray(sCustomerInfo);
			sCertType=sss[0];
			sCertID=sss[1];
			setItemValue(0,getRow(),"CertType",sCertType);
			setItemValue(0,getRow(),"CertID",sCertID);
		}
	}

	/*~[Describe=ִ�в������ǰִ�еĴ���;InputParam=��;OutPutParam=��;]~*/
	function beforeInsert()
	{
		if (getItemValue(0,getRow(),"RelativeID") ==  "") {
			//������ؿͻ����Ϊ�գ���ʼ��һ���ͻ���ˮ��
			initSerialNo();
		}
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
			bIsInsert = true;
			setItemValue(0,0,"CustomerID","<%=sCustomerID%>");
			setItemValue(0,0,"InputUserId","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"UserName","<%=CurUser.getUserName()%>");
			setItemValue(0,0,"InputOrgId","<%=CurOrg.getOrgID()%>");
			setItemValue(0,0,"OrgName","<%=CurOrg.getOrgName()%>");
			setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
		}
	}

	/*~[Describe=������ϵ����ǰ���;InputParam=��;OutPutParam=ͨ��true,����false;]~*/
	function RetaiveCheck() 
	{
		sCustomerID   = getItemValue(0,0,"CustomerID");
		sCustomerName = getItemValue(0,0,"CustomerName");
		if (typeof(sCustomerName)=="undefined" || sCustomerName.length==0)
		{
			alert("<%=sHeaders[0][1]%>����Ϊ��!");
			return false;
		}
		sCertType = getItemValue(0,0,"CertType");
		if (typeof(sCertType)=="undefined" || sCertType.length==0)
		{
			alert("<%=sHeaders[1][1]%>����Ϊ��!");
			return false;
		}
		sCertID = getItemValue(0,0,"CertID");
		if (typeof(sCertID)=="undefined" || sCertID.length==0)
		{
			alert("<%=sHeaders[2][1]%>����Ϊ��!");
			return false;
		}

		sRelationShip = getItemValue(0,0,"RelationShip");
		if (typeof(sRelationShip)=="undefined" || sRelationShip.length==0)
		{
			alert("<%=sHeaders[3][1]%>����Ϊ��!");
			return false;
		}
		var sMessage = PopPageAjax("/CustomerManage/EntManage/RelativeCheckActionAjax.jsp?CustomerID="+sCustomerID+"&RelationShip="+sRelationShip+"&CertType="+sCertType+"&CertID="+sCertID,"","");
		var messageArray = sMessage.split("@");
		var isRelationExist = messageArray[0];
		var info = messageArray[1];
		if (typeof(sMessage)=="undefined" || sMessage.length==0) {
			return false;
		}
		else if(isRelationExist == "false"){
			alert(info);
			return false;
		}
		else if(isRelationExist == "true"){
			setItemValue(0,0,"RelativeID",info);
		}

		return true;
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

<%@	include file="/IncludeEnd.jsp"%>