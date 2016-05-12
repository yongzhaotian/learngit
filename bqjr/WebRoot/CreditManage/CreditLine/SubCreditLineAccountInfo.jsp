<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/%>
	<%
	/*
		Author:zywei 2006/03/31
		Tester:
		Content: ��ȷ��������Ϣҳ��
		Input Param:
			ParentLineID����ȱ��
			LineID����ȷ�����
		Output param:
		History Log:

	 */
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "δ����ģ��"; // ��������ڱ��� <title> PG_TITLE </title>
	CurPage.setAttribute("ShowDetailArea","true");
	CurPage.setAttribute("DetailAreaHeight","300");
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
	
	//����������

	//���ҳ�����	
	String sParentLineID =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ParentLineID"));
	String sSubLineID =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SubLineID"));
	//����ֵת��Ϊ���ַ���
	if(sParentLineID == null) sParentLineID = "";
	if(sSubLineID == null) sSubLineID = "";	
%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/%>
	<%
	//������ʾ����
	String[][] sHeaders = {
					{"CustomerID","�ͻ����"},
					{"CustomerName","�ͻ�����"},
					{"BusinessTypeName","ҵ��Ʒ��"},
					{"Rotative","�Ƿ�ѭ��"},
					{"BailRatio","��ͱ�֤�����"},
					{"LineSum1","�����޶�"},
					{"LineSum2","�����޶�"},
					{"InputOrgName","�Ǽǻ���"},
					{"InputUserName","�Ǽ���"},
					{"InputTime","�Ǽ�����"},
					{"UpdateTime","��������"}
					};

	String sSql = 	" select ParentLineID,LineID,CustomerID,CustomerName,BusinessType, "+
					" getBusinessName(BusinessType) as BusinessTypeName,Rotative, "+
					" BailRatio,LineSum1,LineSum2,GetOrgName(InputOrg) as InputOrgName, "+
					" InputOrg,InputUser,GetUserName(InputUser) as InputUserName,InputTime, "+
					" UpdateTime,CLTypeID,CLTypeName,BCSerialNo "+
					" from CL_INFO "+
					" Where LineID = '"+sSubLineID+"' "+
					" and ParentLineID = '"+sParentLineID+"' ";	
					
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.UpdateTable = "CL_INFO";
	doTemp.setKey("LineID",true);
	doTemp.setHeader(sHeaders);
	doTemp.setDDDWCode("Rotative","YesNo");
	
	//���ò��ɼ�����
	doTemp.setVisible("ParentLineID,LineID,BusinessType,InputUser,InputOrg,CLTypeID,CLTypeName,BCSerialNo,",false);
	//����ֻ������
	doTemp.setReadOnly("CustomerID,CustomerName,InputUserName,InputOrgName,InputTime,UpdateTime",true);
	//���ñ�����
	doTemp.setRequired("BusinessTypeName,Rotative",true);
	//���ò��ɸ�������
	doTemp.setUpdateable("BusinessTypeName,InputUserName,InputOrgName",false);
	
	//���ø�ʽ
	doTemp.setType("LineSum1,LineSum2,BailRatio","Number");
	doTemp.setCheckFormat("LineSum1,LineSum2,BailRatio","2");
	doTemp.setUnit("LineSum1,LineSum2","(Ԫ)");
	doTemp.setUnit("BailRatio","(%)");
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	
	//����setEvent

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
			{"true","","Button","�����Ӷ������ҵ��","�鿴�����Ӷ������ҵ������","viewBusiness()",sResourcesPath}
		};
	%>
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=Info05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/Info05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info06;Describe=���尴ť�¼�;]~*/%>
	<script type="text/javascript">
	
	//---------------------���尴ť�¼�------------------------------------
	/*~[Describe=�鿴�����Ӷ������ҵ������;InputParam=��;OutPutParam=��;]~*/
	function viewBusiness()
	{
		sBusinessType = getItemValue(0,getRow(),"BusinessType");
		sBCSerialNo = getItemValue(0,getRow(),"BCSerialNo");
		if (typeof(sBCSerialNo)=="undefined" || sBCSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		popComp("SublineSubList","/CreditManage/CreditLine/SublineSubList.jsp","LineNo="+sBCSerialNo+"&BusinessType="+sBusinessType,"","");
	}
	</script>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info07;Describe=�Զ��庯��;]~*/%>

	<script type="text/javascript">
		
	</script>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info08;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script type="text/javascript">
	AsOne.AsInit();
	init();
	var bFreeFormMultiCol = true;
	my_load(2,0,'myiframe0');
	OpenPage("/CreditManage/CreditLine/LimitationItemAccountList.jsp?SubLineID=<%=sSubLineID%>","DetailFrame","");	
</script>
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>
