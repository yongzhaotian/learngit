<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/%>
	<%
	/*
		Author: pwang 2009-10-09
		Tester:
		Content: ��С����ҵ�ʸ��϶�������Ϣ
		Input Param:
			ObjectType����������
			ApplyType����������
			PhaseType���׶�����
			FlowNo�����̺�
			PhaseNo���׶κ�
		Output param:
			
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "��С����ҵ�ʸ��϶�������Ϣ"; // ��������ڱ��� <title> PG_TITLE </title>	
	// ���ҳ�����
	String sObjectNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectNo"));
	if(sObjectNo==null) sObjectNo="";
	String sCustomerType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("CustomerType"));
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));
	String sApplyType =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ApplyType"));
	String sPhaseType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("PhaseType"));
	String sFlowNo =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("FlowNo"));
	String sPhaseNo =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("PhaseNo"));
	//����ֵת���ɿ��ַ���
		if(sObjectType == null) sObjectType = "";	
		if(sApplyType == null) sApplyType = "";
		if(sPhaseType == null) sPhaseType = "";	
		if(sFlowNo == null) sFlowNo = "";
		if(sPhaseNo == null) sPhaseNo = "";

	
	
	// ͨ��DWģ�Ͳ���ASDataObject����doTemp
	String sTempletNo = "SMEApplyCreateInfo";//ģ�ͱ��
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      // ����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; // �����Ƿ�ֻ�� 1:ֻ�� 0:��д
	
	dwTemp.setEvent("AfterInsert","!WorkFlowEngine.InitializeFlow("+sObjectType+",#SerialNo,"+sApplyType+","+sFlowNo+","+sPhaseNo+","+CurUser.getUserID()+","+CurOrg.getOrgID()+")+!CustomerManage.UpdateSMECustomerApply(#SerialNo)");
	dwTemp.setEvent("AfterUpdate","!CustomerManage.UpdateSMECustomerApply(#SerialNo)");

	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sObjectNo+","+CurUser.getUserID());//�������,���ŷָ�
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
		{"true","","Button","ȷ��","���沢��ʼ������","doCreation()",sResourcesPath},
		{"true","","Button","ȡ��","ȡ������","doCancel()",sResourcesPath}		
	};
	%> 
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=Info05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/Info05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info07;Describe=�Զ��庯��;]~*/%>

	<script type="text/javascript">

	//ȫ�ֱ���
	var bIsInsert = false;	

	function Validity(){
		sEmployNumber = getItemValue(0,0,"Attribute1");
		var Letters = "1234567890";
		for (i = 0;i < sEmployNumber.length;i++)
		{
			var CheckChar = sEmployNumber.charAt(i);
			if (Letters.indexOf(CheckChar) == -1)
			{			        
				//alert("������������ֵ");
				//setItemValue(0,0,"Attribute1","");
			} 
		}
		
	}
	
	/*~[Describe=ȡ���������÷�ʽ���뷽��;InputParam=��;OutPutParam=ȡ����־;]~*/
	function doCancel(){		
		top.returnValue = "_CANCEL_";
		top.close();
	}

	/*~[Describe=����;InputParam=�����¼�;OutPutParam=��;]~*/
	function doCreation(){
		if(vI_all("myiframe0") && matchModel()){
			saveRecord("doReturn()");
			as_save("myiframe0");
		}
	}
	/*~[Describe=ȷ���������÷�������;InputParam=��;OutPutParam=������ˮ��;]~*/
	function doReturn(){
		sCustomerID = getItemValue(0,0,"CustomerID");
		top.returnValue = "_SUCCESSFUL_"+"@"+sCustomerID;
		top.close();
	}	

	/*~[Describe=������ҵ�����Ϣ�󣬽���ģ��ƥ��;InputParam=��;OutPutParam=��;]~*/
	function setAsset(){
		var sIndustryType = getItemValue(0,0,"Attribute7");				//��С����ҵ��ҵ����**
		//��ҵ,����ҵ�ʲ��ܶ�����Ĭ��ֵ 
		if(sIndustryType == "0130010" || sIndustryType == "0130020"){
			setItemValue(0,0,"Attribute3","");
		}else{
			setItemValue(0,0,"Attribute3",amarMoney(0,2));
		}
	}
		
	/*~[Describe=������ҵ�����Ϣ�󣬽���ģ��ƥ��;InputParam=��;OutPutParam=��;]~*/
	function matchModel(){
		var sIndustryType = getItemValue(0,0,"Attribute7");				//��С����ҵ��ҵ����**
		var sEmployeeNum = getItemValue(0,0,"Attribute1");				//ְ������
		var sSaleSum = getItemValue(0,0,"Attribute2");						//���۶�
		var sAssetSum = getItemValue(0,0,"Attribute3");						//�ʲ��ܶ�
		var sEntScale = getItemValue(0,0,"Attribute6");						//��ҵ��ģ
		var cScale = {"3":"������ҵ","4":"С����ҵ","0":"������ҵ","9":"����"};
	
		var sReturn = RunMethod("CustomerManage","CheckSMECustomerAction",sIndustryType+","+sEmployeeNum+","+sSaleSum+","+sAssetSum);
		if(sEntScale == sReturn){
			return true;
		}else{
			oEntScale = getASObject(0,0,"Attribute6");
			if(sReturn == "9"){
				if(confirm("��¼������ݲ������κ�ģ�ͣ�ȷ��������")){
					return true;
				}else{
					return false;
				}
			}
			if(confirm("��¼������ݷ���"+cScale[sReturn]+"��ȷ��������")){
				return true;
			}else{
				return false;
			}
		}
	}
	/*~[Describe=ҳ��װ��ʱ����DW���г�ʼ��;InputParam=��;OutPutParam=��;]~*/
	function initRow(){
		if (getRowCount(0)==0) {//���û���ҵ���Ӧ��¼��������һ�����������ֶ�Ĭ��ֵ
			as_add("myiframe0");//����һ���ռ�¼			
			setItemValue(0,0,"CustomerType","<%=sCustomerType%>");
			setItemValue(0,0,"InputUserID","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"InputUserName","<%=CurUser.getUserName()%>");
			setItemValue(0,0,"InputOrgID","<%=CurOrg.getOrgID()%>");
			setItemValue(0,0,"InputOrgName","<%=CurOrg.getOrgName()%>");
			setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");
			bIsInsert = true;	
		}
	}
	/*~[Describe=����;InputParam=�����¼�;OutPutParam=��;]~*/
	function saveRecord(sPostEvents){
		if(bIsInsert){
			beforeInsert();
		}
		as_save("myiframe0",sPostEvents);
	}
	/*~[Describe=ִ�в������ǰִ�еĴ���;InputParam=��;OutPutParam=��;]~*/
	function beforeInsert(){
		initSerialNo();//��ʼ����ˮ���ֶ�
		bIsInsert = false;
	}

	/*~[Describe=��ʼ����ˮ���ֶ�;InputParam=��;OutPutParam=��;]~*/
	function initSerialNo(){
		var sTableName = "SME_APPLY";//����
		var sColumnName = "SerialNo";//�ֶ���
		var sPrefix = "";//ǰ׺
								
		//��ȡ��ˮ��
		var sSerialNo = getSerialNo(sTableName,sColumnName,sPrefix);
		setItemValue(0,getRow(),sColumnName,sSerialNo);
	}

	/*~[Describe=�����ͻ�ѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/
	function selectCustomer(){			
		sCustomerType = getItemValue(0,0,"CustomerType");
		if(typeof(sCustomerType) == "undefined" || sCustomerType == "")
		{
			alert("����ѡ��ͻ�����!");
			return;
		}
		//����ҵ�����Ȩ�Ŀͻ���Ϣ
		sParaString = "UserID,"+"<%=CurUser.getUserID()%>"+",CustomerType"+","+sCustomerType;
		//sReturnValue =setObjectValue("SelectApplyCustomer5",sParaString,"@CustomerID@0@CustomerName@1",0,0,"");
		//add by syang 2009/11/06 ����ͻ�����;ҵ�������������С��ҵ�ʸ��϶�
		sReturnValue =setObjectValue("SelectApplyCustomer5",sParaString,"@CustomerID@0@CustomerName@1",0,0,"");

        if (typeof(sReturnValue) == "undefined" || sReturnValue == "") {
        	sCustomerID = "";
        	sCustomerName = "";
        } else {
        	sCustomerID=sReturnValue.split("@")[0];
            sCustomerName=sReturnValue.split("@")[1];
        }
		//��;ҵ����
		sCount = RunMethod("BusinessManage","CustomerUnFinishedBiz",sCustomerID);
		if(sCount != "0"){
			alert("����ʧ�ܣ��ÿͻ�����;���룡");
			setItemValue(0,getRow(),"CustomerID","");
			setItemValue(0,getRow(),"CustomerName","");
			return;
		}
	}

	/*~[Describe=�����Ϣ;InputParam=��;OutPutParam=������ˮ��;]~*/
	function clearData(){
		setItemValue(0,0,"CustomerID","");
		setItemValue(0,0,"CustomerName","");
		setItemValue(0,0,"Attribute6","");
		setItemValue(0,0,"Attribute7","");
		setItemValue(0,0,"Attribute1","");
		setItemValue(0,0,"Attribute2","");
		setItemValue(0,0,"Attribute3","");
	}
	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info08;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script type="text/javascript">	
	AsOne.AsInit();
	init();	
	my_load(2,0,'myiframe0');
	initRow(); //ҳ��װ��ʱ����DW��ǰ��¼���г�ʼ��	
	var bCheckBeforeUnload=false;	//����ҳ���˳�ʱȷ�ϡ�
</script>	
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>