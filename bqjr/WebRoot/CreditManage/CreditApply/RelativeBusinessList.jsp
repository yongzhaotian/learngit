<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author: jytian 2004-12-11
		Tester:
		Describe: ���ҵ����Ϣ
		Input Param:
			ObjectType: �׶α��
			ObjectNo��ҵ����ˮ��
			CustomerID:�ͻ����
		Output Param:
			
		HistoryLog:
	 */
	%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "���ҵ����Ϣ"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
	String sRTableName = "";
	String sSql = "";
	
	//���ҳ�����

	//����������
	String sObjectType = CurPage.getParameter("ObjectType");
	String sObjectNo = CurPage.getParameter("ObjectNo");
	String sCustomerID = CurPage.getParameter("CustomerID");
	String sOccurType = CurPage.getParameter("OccurType");
	if(sObjectType==null) sObjectType="";
	if(sObjectNo==null) sObjectNo="";
	if(sCustomerID==null) sCustomerID="";
	if(sOccurType==null) sOccurType="";
%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%
	//����sObjectType�Ĳ�ͬ���õ���ͬ�Ĺ���������ģ����
	sSql = " select RelativeTable from OBJECTTYPE_CATALOG where ObjectType =:ObjectType ";
	sRTableName = Sqlca.getString(new SqlObject(sSql).setParameter("ObjectType",sObjectType));

	String sTempletNo = "";//ģ�ͱ��
	
	if(sRTableName.equals("APPROVE_RELATIVE")){
		sTempletNo = "RelativeBusinessList2";
	}
	else if(sRTableName.equals("APPLY_RELATIVE")){
		sTempletNo = "RelativeBusinessList1";
	}
	else if(sRTableName.equals("CONTRACT_RELATIVE")){
		sTempletNo = "RelativeBusinessList";
	}

	//ͨ��DWģ�Ͳ���ASDataObject����doTemp
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
	//����datawindow
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����ΪGrid���
	dwTemp.ReadOnly = "1"; //����Ϊֻ��

	Vector vTemp = dwTemp.genHTMLDataWindow(sObjectNo);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
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
			{(sOccurType.equals("020")?"true":"false"),"","Button","��ӹ������","����һ�����е�ҵ��","newRecord()",sResourcesPath},
			{"true","","Button","�������","�鿴�������","view()",sResourcesPath},
			{"true","","Button","��غ�ͬ����","�鿴��غ�ͬ����","viewTab()",sResourcesPath},
			{(sOccurType.equals("020")?"true":"false"),"","Button","ɾ��","ɾ������","deleteRecord()",sResourcesPath},
		};
	%>
<%/*~END~*/%>

<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">
	
	function viewTab()
	{
		sObjectType = "BusinessContract";
		sObjectNo = getItemValue(0,getRow(),"RELATIVESERIALNO2");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		sCompID = "CreditTab";
		sCompURL = "/CreditManage/CreditApply/ObjectTab.jsp";
		sParamString = "ObjectType="+sObjectType+"&ObjectNo="+sObjectNo;
		OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
		reloadSelf();
	}
	
	function newRecord()
	{		
		var sRelativeSerialNo = "";			
		//���պ�ͬ����	
		//sParaString = "CustomerID,<%=sCustomerID%>,ManageUserID,<%=CurUser.getUserID()%>";
		//var sContractInfo = setObjectValue("SelectExtendContract",sParaString,"",0,0,"");
		//if(typeof(sContractInfo) != "undefined" && sContractInfo != "") 
		//{
		//	sContractInfo = sContractInfo.split('@');
		//	sRelativeSerialNo = sContractInfo[0];
		//}
		//���ս�ݹ���	
		sParaString = "CustomerID,<%=sCustomerID%>,OperateUserID,<%=CurUser.getUserID()%>";
		var sDueBillInfo = setObjectValue("SelectExtendDueBill",sParaString,"",0,0,"");			
		if(typeof(sDueBillInfo) != "undefined" && sDueBillInfo != "") 
		{
			sDueBillInfo = sDueBillInfo.split('@');
			sRelativeSerialNo = sDueBillInfo[0];
		}
		//���ѡ���˺�ͬ/�����Ϣ�����жϸú�ͬ�Ƿ��Ѻ͵�ǰ��ҵ�����˹�����������������ϵ��
		if(typeof(sRelativeSerialNo) != "undefined" && sRelativeSerialNo != "") 
		{
			//���պ�ͬ����	
			//sReturn = RunMethod("PublicMethod","GetColValue","ObjectNo,"+<%=sRTableName%>+",String@SerialNo@"+"<%=sObjectNo%>"+"@String@ObjectType@BusinessContract@String@ObjectNo@"+sRelativeSerialNo);
			//���ս�ݹ���	
			sReturn = RunMethod("PublicMethod","GetColValue","ObjectNo,"+"<%=sRTableName%>"+",String@SerialNo@"+"<%=sObjectNo%>"+"@String@ObjectType@BusinessDueBill@String@ObjectNo@"+sRelativeSerialNo);
			if(typeof(sReturn) != "undefined" && sReturn != "") 
			{			
				sReturn = sReturn.split('~');
				var my_array = new Array();
				for(i = 0;i < sReturn.length;i++)
				{
					my_array[i] = sReturn[i];
				}
				
				for(j = 0;j < my_array.length;j++)
				{
					sReturnInfo = my_array[j].split('@');				
					if(typeof(sReturnInfo) != "undefined" && sReturnInfo != "")
					{						
						if(sReturnInfo[0] == "objectno")
						{
							if(typeof(sReturnInfo[1]) != "undefined" && sReturnInfo[1] != "" && sReturnInfo[1] == sRelativeSerialNo)
							{
								alert("��ѡ��ͬ�ѱ���ҵ������,�����ٴ����룡");
								//alert("��ѡ����ѱ���ҵ������,�����ٴ����룡");
								return;
							}
						}				
					}
				}			
			}
			//����ҵ������ѡ��ͬ�Ĺ�����ϵ
			//sReturn = RunMethod("BusinessManage","InsertRelative","<%=sObjectNo%>"+",BusinessContract,"+sRelativeSerialNo+","+<%=sRTableName%>);
			//����ҵ������ѡ��ݵĹ�����ϵ
			sReturn = RunMethod("BusinessManage","InsertRelative","<%=sObjectNo%>"+",BusinessDueBill,"+sRelativeSerialNo+","+"<%=sRTableName%>");
			if(typeof(sReturn) != "undefined" && sReturn != "")
			{
				//alert("���������ͬ�ɹ���");
				alert("���������ݳɹ���");
				reloadSelf();	
			}else
			{
				//alert("���������ͬʧ�ܣ������²�����");
				alert("����������ʧ�ܣ������²�����");
				return;
			}
		}
	}
	
	function view()
	{
		var sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		//alert(sObjectNo);
		
		if(typeof(sObjectNo)=="undefined" || sObjectNo.length==0) 
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}		
		else 
		{
			openObject("BusinessDueBill",sObjectNo,"002");
		}
	}
	
	function deleteRecord()
	{
		sObjectNo = getItemValue(0,getRow(),"ObjectNo");		
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		if(confirm(getHtmlMessage('2')))//�������ɾ������Ϣ��
		{
			as_del('myiframe0');
			as_save('myiframe0');  //�������ɾ������Ҫ���ô����
		}
	}

	</script>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">


	</script>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List07;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script type="text/javascript">
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>
<%/*~END~*/%>

<%@	include file="/IncludeEnd.jsp"%>