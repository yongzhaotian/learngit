<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
		/*
		Author:   --fbkang 
		Tester:
		Content:    --��Ʒ��������
			δ�õ��������ֶ���ʱ���أ������Ҫ��չʾ������
		Input Param:
        	TypeNo��    --���ͱ��
 		Output param:
		                
		History Log: 
            
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "�������չ�˾��Ʒ����"; // ��������ڱ��� <title> PG_TITLE </title>
	
	//���ҳ�����,��Ʒ���
	String sSerialNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
	String sFlag =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("sFlag"));

	if(sSerialNo == null) sSerialNo = "";
	if(sFlag == null) sFlag = "";


	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%	
	ASDataObject doTemp = new ASDataObject("InsuranceCommpayInfo",Sqlca);

	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д


	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sSerialNo);
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
			{"true","","Button","����","����Detail","saveDetailRecord()",sResourcesPath},
			{"true","","Button","����","����Add","saveAddRecord()",sResourcesPath},

		    };
	if("Add".equals(sFlag)){
		sButtons[0][0]="false";		
	}else if("Detail".equals(sFlag)){
		sButtons[1][0]="false";		
	}
	%> 
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
	
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">
    var sCurTypeNo=""; //��¼��ǰ��ѡ���еĴ����
    var bIsInsert = false; //���DW�Ƿ��ڡ�����״̬��

	//---------------------���尴ť�¼�------------------------------------
	/*~[Describe=����;InputParam=�����¼�;OutPutParam=��;]~*/
	function saveDetailRecord()
	{
    	var SerialNo = getItemValue(0,0,"SerialNo"); //���չ�˾���
    	if(checkServiceProvidersType(SerialNo)){
    		alert("������ı��չ�˾�ͱ��ղ�Ʒ�Ѵ���");
    		return;
    	}
	    as_save("myiframe0");
	}

    /*~[Describe=����;InputParam=�����¼�;OutPutParam=��;]~*/
	function saveAddRecord(){	
		if(checkServiceProvidersType("")){
    		alert("������ı��չ�˾�ͱ��ղ�Ʒ�Ѵ���");
    		return;
    	}
	    var sReturn = as_save("myiframe0");
        if(sReturn == undefined){
    	     return;
        } else{
    	    self.close();
        }	
	}
    
		/**
		 * У�鱣�չ�˾�ͱ��ղ�Ʒ�Ƿ��Ѵ��� [true:�Ѵ��ڣ�false���Ǵ���]
		 */
		function checkServiceProvidersType(SerialNo) {
			var type = getItemValue(0, 0, "ServiceProvidersType"); //���չ�˾����
			var name = getItemValue(0, 0, "ServiceProvidersName"); //���ղ�Ʒ����


		var count = "1";
			if (SerialNo == "") {
				count = RunMethod("���÷���", "GetColValue", "bq_insurance_info,count(1),INS_NAME='" + type + "' and INS_SERVICEPROVIDERSNAME='" + name + "'");
			} else {
				count = RunMethod("���÷���", "GetColValue", "bq_insurance_info,count(1),INS_NAME='" + type + "' and INS_SERVICEPROVIDERSNAME='" + name + "' and INS_SERIALNO <> '" + SerialNo + "'");
			}
			
			
			if (count == "0.0") {
				return false;
			}
			return true;
		}
	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">
	
	function initRow(){
		if (getRowCount(0)==0) //���û���ҵ���Ӧ��¼��������һ�����������ֶ�Ĭ��ֵ
		{
			as_add("myiframe0");//������¼
			setItemValue(0,0,"CreditAttribute", "0002");
			setItemValue(0,0,"CustomerType1", "09");
			setItemValue(0,0,"SerialNo", "<%=sSerialNo%>");
			setItemValue(0,0,"insId", "<%=sSerialNo%>");
			setItemValue(0,0,"InputUserID", "<%=CurUser.getUserID()%>");
			setItemValue(0,0,"InputDate", "<%=StringFunction.getToday()%>");
			setItemValue(0,0,"InputOrgID", "<%=CurOrg.getOrgID()%>");
			setItemValue(0,0,"InputUserIDName", "<%=CurUser.getUserName()%>");
			setItemValue(0,0,"InputOrgIDName", "<%=CurOrg.getOrgName()%>");
			bIsInsert = true;
		}
	}
	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List07;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script type="text/javascript">	
	AsOne.AsInit();
	init();
	var bCheckBeforeUnload = false;
	my_load(2,0,'myiframe0');
	initRow();
	
</script>	
<%/*~END~*/%>


<%@ include file="/IncludeEnd.jsp"%>
