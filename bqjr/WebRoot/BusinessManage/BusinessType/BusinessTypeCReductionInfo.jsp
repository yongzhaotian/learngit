<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/%>
	<%
	/*
		Author: lwang 20140220 
		Tester:
		Describe:��������ҳ��
		Input Param:
			SerialNo:
		Output Param:

		HistoryLog:
			
	 */
	%>
<%/*~END~*/%>



<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "�������ü�������"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>



<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info02;Describe=�����������ȡ����;]~*/%>
<%

	//���ҳ�����
	String sTypeNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("typeNo"));
	String sSerialNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("serialNo"));
	String sTemp = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("temp"));
	if(sTemp==null) sTemp=""; 
	if(sSerialNo==null) sSerialNo=""; 
    if(sTypeNo==null) sTypeNo=""; 
    System.out.println(sSerialNo+","+sTypeNo);
%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/%>
	<%
	//ͨ����ʾģ�����ASDataObject����doTemp
	String sTempletNo = "BusinessTypeCReductionInfo";

	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	//out.print(doTemp.SourceSql);
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sSerialNo);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	
	String sterm = Sqlca.getString(new SqlObject("SELECT term FROM  business_type  where typeno='"+sTypeNo+"' "));//��Ʒ�ڴ�

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
		{"true","","Button","����","����ҳ��","saveRecord()",sResourcesPath},
		{"true","","Button","����","����","saveRecordAndBack()",sResourcesPath}
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
	function saveRecord()
	{
		var sterm = "<%=sterm%>";
		var swaiveFromStage = getItemValue(0, 0, "waiveFromStage");//���⿪ʼ�ڴ�
		var swaiveToStage = getItemValue(0, 0, "waiveToStage");//���⵽���ڴ�
		if(sterm=="0"){
			alert("��Ʒ������Ϣ�ڴ������Ƿ���ȷ����");
			return;
		}
		if(parseInt(sterm, 10)<parseInt(swaiveToStage, 10)){
			alert("���ü��⵽���ڴβ��ܴ��ڲ�Ʒ������Ϣ������(��)��ֵ����");
			return;
		}
		if(parseInt(swaiveFromStage, 10)>parseInt(swaiveToStage, 10)){
			alert("���ü��⵽���ڴβ���С�ڷ��ü��⿪ʼ���ڴΣ���");
			return;
		}
		if(swaiveFromStage=="0"){
			alert("���⿪ʼ�ڴβ���Ϊ0����");
			return;
		}
		
		var costReductionType = getItemValue(0,0,"costReductionType");
		var costType=costReductionType.split(",");
		var costTypes = "";
		var costTypes1 = "";
		for(var i=0;i<costType.length;i++){
			if(costType[i]=="3"){
				costTypes1="ӡ��˰";
			}else if(costType[i]=="4"){
				costTypes1="���շ�";
			}else if(costType[i]=="5"){
				costTypes1="����Ϣ";
			}else if(costType[i]=="6"){
				costTypes1="�²�������";
			}else if(costType[i]=="7"){
				costTypes1="�¿ͻ������";
			}
			costTypes += costTypes1 + ", ";
			
		}
		
		setItemValue(0, 0, "remark", costTypes);
		
		
		bIsInsert = false;
	    as_save("myiframe0");
	}

    /*~[Describe=����;InputParam=�����¼�;OutPutParam=��;]~*/
	function saveRecordAndBack()
	{
		OpenPage("/BusinessManage/BusinessType/BusinessTypeCReductionList.jsp","_self","");

	}
    
    
	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">	
	function initRow(){
		if (getRowCount(0)==0) //���û���ҵ���Ӧ��¼��������һ�����������ֶ�Ĭ��ֵ
		{
			as_add("myiframe0");//������¼
			bIsInsert = true;
		}
		if("<%=sTemp%>"=="add"){
			setItemValue(0,0,"serialNo", getSerialNo("acct_fee_waive", "serialNo", ""));
		}
		setItemValue(0,0,"typeNo", "<%=sTypeNo%>");
		setItemValue(0,0,"inputOrg", "<%=CurOrg.getOrgName()%>");
		setItemValue(0,0,"inputUser", "<%=CurUser.getUserName()%>");
		setItemValue(0,0,"inputTime", "<%=StringFunction.getToday()%>");
		setItemValue(0,0,"updateOrg", "<%=CurOrg.getOrgName()%>");
		setItemValue(0,0,"updateUser", "<%=CurUser.getUserName()%>");
		setItemValue(0,0,"updateTime", "<%=StringFunction.getToday()%>");
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
