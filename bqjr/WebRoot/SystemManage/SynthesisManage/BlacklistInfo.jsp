<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/%>
	<%
	/*
		Author:
		Tester:
		Content: ����������
		Input Param:
		       --SerialNO:��ˮ��
		Output param:
		History Log: 
		-- fbkang ��������ҳ��

	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "����������"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info02;Describe=�����������ȡ����;]~*/%>

<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/%>
	<%
	
	//�������
	
		//���ҳ�����	����������ˮ��
    	String sSerialNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
    	if(sSerialNo==null) sSerialNo="";
		
		// ͨ��DWģ�Ͳ���ASDataObject����doTemp
		String sTempletNo = "BlacklistInfo";//ģ�ͱ��
		ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
		
		ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
		dwTemp.Style="2";      // ����DW��� 1:Grid 2:Freeform
		dwTemp.ReadOnly = "0"; // �����Ƿ�ֻ�� 1:ֻ�� 0:��д

		//ʹ������ģ��ǰ�ġ���ʾ��׺��
		//doTemp.setUnit("CustomerName"," <input type=button value=.. onclick=parent.selectCustomer()>");
		//doTemp.setHTMLStyle("CertID"," onchange=parent.getCustomerName() ");
		
		//����HTMLDataWindow
		Vector vTemp = dwTemp.genHTMLDataWindow(sSerialNo);//�������,���ŷָ�
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
	function saveRecord(sPostEvents){
	
		if(bIsInsert){
			beforeInsert();
			//��������,���Ϊ��������,�����ҳ��ˢ��һ��,��ֹ�������޸�
			beforeUpdate();
			as_save("myiframe0","pageReload()");
			return;
		}

		beforeUpdate();
		as_save("myiframe0",sPostEvents);
	}

	/*~[Describe=�����б�ҳ��;InputParam=��;OutPutParam=��;]~*/
	function goBack(){
		OpenPage("/SystemManage/SynthesisManage/BlacklistList.jsp","_self","");
	}	
	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info07;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">
	/*~[Describe=��������ҳ��ˢ�¶���;InputParam=��;OutPutParam=��;]~*/
	function pageReload(){
		sSerialNo = getItemValue(0,getRow(),"SerialNo");//--���»����ˮ��
		OpenPage("/SystemManage/SynthesisManage/BlacklistInfo.jsp?SerialNo="+sSerialNo+"", "_self","");
	}
	/*~[Describe=ִ�в������ǰִ�еĴ���;InputParam=��;OutPutParam=��;]~*/
	function beforeInsert(){
       initSerialNo();//��ʼ����ˮ���ֶ�
	}
	/*~[Describe=ִ�и��²���ǰִ�еĴ���;InputParam=��;OutPutParam=��;]~*/
	function beforeUpdate(){
		setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
	}
	/*~[Describe=�����ͻ�ѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/
	function selectCustomer(){
		//���ء��ͻ����롢�ͻ����ơ�֤�����͡�֤������
		if(sCertType!=""&&typeof(sCertType)!="undefined"){
			sParaString = "CertType,"+sCertType;
			setObjectValue("SelectOwner",sParaString,"@CustomerID@0@CustomerName@1@CertType@2@CertID@3",0,0);
		}else{
			sParaString = "CertType, ";
			setObjectValue("SelectOwner",sParaString,"@CustomerID@0@CustomerName@1@CertType@2@CertID@3",0,0);
		}
	}
	
	/*~[Describe=�õ��ͻ�����;InputParam=��;OutPutParam=��;]~*/
	var sCertType ="";
	function getCustomerName(){
		sCertType   = getItemValue(0,getRow(),"CertType");//--֤������
		var sCertID   = getItemValue(0,getRow(),"CertID");//--֤������
        //��ÿͻ�����
        var sColName = "CustomerID@CustomerName";
		var sTableName = "CUSTOMER_INFO";
		var sWhereClause = "String@CertID@"+sCertID+"@String@CertType@"+sCertType;
		if(typeof(sCertType) != "undefined" && sCertType != ""&&typeof(sCertID) != "undefined" && sCertID != ""){
			sReturn=RunMethod("PublicMethod","GetColValue",sColName + "," + sTableName + "," + sWhereClause);
		}else return;
		if(typeof(sReturn) != "undefined" && sReturn != ""){
			sReturn = sReturn.split('~');
			var my_array1 = new Array();
			for(var i = 0;i < sReturn.length;i++){
				my_array1[i] = sReturn[i];
			}
			
			for(var j = 0;j < my_array1.length;j++){
				sReturnInfo = my_array1[j].split('@');	
				var my_array2 = new Array();
				for(var m = 0;m < sReturnInfo.length;m++){
					my_array2[m] = sReturnInfo[m];
				}
				
				for(var n = 0;n < my_array2.length;n++){
					//���ÿͻ����
					if(my_array2[n] == "customerid")
						setItemValue(0,getRow(),"CustomerID",sReturnInfo[n+1]);
					//���ÿͻ�����
					if(my_array2[n] == "customername")
						setItemValue(0,getRow(),"CustomerName",sReturnInfo[n+1]);
				}
			}			
		} 
	}
	/*~[Describe=ҳ��װ��ʱ����DW���г�ʼ��;InputParam=��;OutPutParam=��;]~*/
	function initRow(){
		if (getRowCount(0)==0){ //���û���ҵ���Ӧ��¼��������һ�����������ֶ�Ĭ��ֵ
			as_add("myiframe0");//������¼
			bIsInsert = true;

			setItemValue(0,0,"InputUserID","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"UserName","<%=CurUser.getUserName()%>");
			setItemValue(0,0,"InputOrgID","<%=CurOrg.getOrgID()%>");
			setItemValue(0,0,"OrgName","<%=CurOrg.getOrgName()%>");
			setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"SectionType","40");//--�������б�
		}
	}
	
	/*~[Describe=��ʼ����ˮ���ֶ�;InputParam=��;OutPutParam=��;]~*/
	function initSerialNo(){
		var sTableName = "CUSTOMER_SPECIAL";//����
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
