<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/%>
	<%
	/*
		Author: zywei 2005-11-27
		Tester:
		Describe: ҵ���ͬ����Ӧ�ı�֤�˻�����Ϣ����;
		Input Param:
			ObjectType����������
			ObjectNo: ������
			ContractNo: ������Ϣ���
			GuarantyID����֤���			
		Output Param:

		HistoryLog:

	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "��֤�˻�����Ϣ����"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
	String sTempletNo = "";//--ģ�����
	String sTempletFilter = "";//ģ����˱���
	String sSql = "";//Sql���
	ASResultSet rs = null;//�����
	String sGuarantyType = "";//��������
	String sItemNo = "";//��֤����
	
	//���ҳ��������������͡������š�������Ϣ��š���֤���
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectType"));
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectNo"));
	String sContractNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ContractNo"));
	String sGuarantyID = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("GuarantyID"));
	
	//����ֵת��Ϊ���ַ���
	if(sObjectType == null) sObjectType = "";
	if(sObjectNo == null) sObjectNo = "";
	if(sContractNo == null) sContractNo = "";
	if(sGuarantyID == null) sGuarantyID = "";
			
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/%>
	<%		        	
	//��ȡҵ��������
	sSql = " select CustomerID from BUSINESS_APPLY where SerialNo=:SerialNo ";
	String sCustomerID = Sqlca.getString(new SqlObject(sSql).setParameter("SerialNo",sObjectNo));
	
	//��ȡ������Ϣ�еĵ�������
	sSql ="select GuarantyType from GUARANTY_CONTRACT where SerialNo =:SerialNo";
	sGuarantyType = Sqlca.getString(new SqlObject(sSql).setParameter("SerialNo",sContractNo));
	//����ֵת��Ϊ���ַ���
	if(sGuarantyType == null) sGuarantyType = "";
	
	//���ݵ�������ȡ����ʾģ���
	if(sGuarantyType.equals("010010")){	//��֤ 		
		sSql = "select ItemNo,ItemDescribe from CODE_LIBRARY where CodeNo='GuarantyList' and ItemNo='030010'";
	}else if(sGuarantyType.equals("010020")){	//��Լ���ձ�֤		
		sSql = "select ItemNo,ItemDescribe from CODE_LIBRARY where CodeNo='GuarantyList' and ItemNo='030020'";
	}else if(sGuarantyType.equals("010030")){	//������֤		
		sSql = "select ItemNo,ItemDescribe from CODE_LIBRARY where CodeNo='GuarantyList' and ItemNo='030030'";
	}else if(sGuarantyType.equals("010040")){	//��֤��      		
		sSql = "select ItemNo,ItemDescribe from CODE_LIBRARY where CodeNo='GuarantyList' and ItemNo='030040'";
	}
	rs = Sqlca.getASResultSet(sSql);
	if(rs.next()){
		sTempletNo = rs.getString("ItemDescribe");
		sItemNo = rs.getString("ItemNo");
	}
	rs.getStatement().close();
	
	//����ֵת��Ϊ���ַ���
	if(sTempletNo == null) sTempletNo = "";
	if(sItemNo == null) sItemNo = "";

	//���ù�������	
	sTempletFilter = " (ColAttribute like '%BusinessContract%' ) ";

	//ͨ����ʾģ�����ASDataObject����doTemp
	ASDataObject doTemp = new ASDataObject(sTempletNo,sTempletFilter,Sqlca);

	//���õ�����ѡ���
	doTemp.setUnit("CertID"," <input type=button value=.. onclick=parent.selectCustomer()><font color=red>(���ڵĿͻ���ѡ��,����������)</font>");
	doTemp.setHTMLStyle("CertType,CertID"," onchange=parent.getCustomerName() ");
	doTemp.setHTMLStyle("OwnerName"," style={width:400px} ");
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	
	//����setEvent
	dwTemp.setEvent("AfterInsert","!BusinessManage.InsertGuarantyRelative("+sObjectType+","+sObjectNo+","+sContractNo+",#GuarantyID,New)+!CustomerManage.AddCustomerInfo(#OwnerID,#OwnerName,#CertType,#CertID,#LoanCardNo,#InputUserID)");
	dwTemp.setEvent("AfterUpdate","!BusinessManage.InsertGuarantyRelative("+sObjectType+","+sObjectNo+","+sContractNo+",#GuarantyID,New)+!CustomerManage.AddCustomerInfo(#OwnerID,#OwnerName,#CertType,#CertID,#LoanCardNo,#InputUserID)");
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sGuarantyID);
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
		//¼��������Ч�Լ��
		if (!ValidityCheck()) return;
		if(bIsInsert){		
			beforeInsert();
		}

		beforeUpdate();
		as_save("myiframe0",sPostEvents);		
	}
	
	/*~[Describe=�����б�ҳ��;InputParam=��;OutPutParam=��;]~*/
	function goBack()
	{
		OpenPage("/CreditManage/GuarantyManage/ContractGuarantorList1.jsp?ObjectType=<%=sObjectType%>&ObjectNo=<%=sObjectNo%>&ContractNo=<%=sContractNo%>","_self","");
	}
	
	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info07;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">

	/*~[Describe=ִ�в������ǰִ�еĴ���;InputParam=��;OutPutParam=��;]~*/
	function beforeInsert()
	{
		initSerialNo();//��ʼ����ˮ���ֶ�
		bIsInsert = false;
	}
	/*~[Describe=ִ�и��²���ǰִ�еĴ���;InputParam=��;OutPutParam=��;]~*/
	function beforeUpdate()
	{
		setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
	}
	
	/*~[Describe=��Ч�Լ��;InputParam=��;OutPutParam=ͨ��true,����false;]~*/
	function ValidityCheck()
	{			
		
		//���֤������Ƿ���ϱ������
		sCertType = getItemValue(0,0,"CertType");//--֤������		
		sCertID = getItemValue(0,0,"CertID");//֤������
		
		if(typeof(sCertType) != "undefined" && sCertType != "" )
		{
			//�ж���֯��������Ϸ���
			if(sCertType =='Ent01')
			{
				if(typeof(sCertID) != "undefined" && sCertID != "" )
				{
					if(!CheckORG(sCertID))
					{
						alert(getBusinessMessage('102'));//��֯������������						
						return false;
					}
				}
			}
				
			//�ж����֤�Ϸ���,�������֤����Ӧ����15��18λ��
			if(sCertType =='Ind01' || sCertType =='Ind08')
			{
				if(typeof(sCertID) != "undefined" && sCertID != "" )
				{
					if (!CheckLisince(sCertID))
					{
						alert(getBusinessMessage('156'));//���֤��������				
						return false;
					}
				}
			}
		}
		
		//У�鵣���˴�����
		sLoanCardNo = getItemValue(0,getRow(),"LoanCardNo");//�����˴�����	
		if(typeof(sLoanCardNo) != "undefined" && sLoanCardNo != "" )
		{
			if(!CheckLoanCardID(sLoanCardNo))
			{
				alert(getBusinessMessage('414'));//�����˵Ĵ���������							
				return false;
			}	
			
			//���鵣���˴�����Ψһ��
			sOwnerName = getItemValue(0,getRow(),"OwnerName");//�ͻ�����	
			sReturn=RunMethod("CustomerManage","CheckLoanCardNo",sOwnerName+","+sLoanCardNo);
			if(typeof(sReturn) != "undefined" && sReturn != "" && sReturn == "Many") 
			{
				alert(getBusinessMessage('419'));//�õ����˵Ĵ������ѱ������ͻ�ռ�ã�							
				return false;
			}					
		}
		
		//�������ĵ������Ƿ����Ŵ���ϵ�����δ��������Ҫ�»�ȡ�����˵Ŀͻ����
		if(typeof(sCertType) != "undefined" && sCertType != "" 
		&& typeof(sCertID) != "undefined" && sCertID != "")
		{
			var sOwnerID = PopPageAjax("/PublicInfo/CheckCustomerActionAjax.jsp?CertType="+sCertType+"&CertID="+sCertID,"","");
			if (typeof(sOwnerID)=="undefined" || sOwnerID.length==0) {
				return false;
			}
			setItemValue(0,0,"OwnerID",sOwnerID);
		}	
		
		sGuarantyType = getItemValue(0,0,"GuarantyType");//--��������	
		//�����������Ϊ��֤����Լ���ձ�֤��������֤ʱ����Ե����˽��кϷ��Խ�����֤����֤�˷�ҵ�������ˣ�
		if(sGuarantyType == '030010' || sGuarantyType == '030020' || sGuarantyType == '030030')
		{
			sGuarantyID = getItemValue(0,getRow(),"GuarantyID");//������Ϣ��ˮ��
			sCustomerID = "<%=sCustomerID%>";	
			sReturn=RunMethod("BusinessManage","CheckGuaranrtyInfo",sGuarantyID + "," + sCustomerID);
			if(typeof(sReturn) != "undefined" && sReturn != "" && parseInt(sReturn) > 0) 
			{
				alert(getBusinessMessage('502'));//�ñ�֤�˲���Ϊ�Լ������ҵ����б�֤��
				return false;
			}		
		}		
				
		return true;
	}

	/*~[Describe=ҳ��װ��ʱ����DW���г�ʼ��;InputParam=��;OutPutParam=��;]~*/
	function initRow()
	{
		if (getRowCount(0) == 0) //���û���ҵ���Ӧ��¼��������һ�����������ֶ�Ĭ��ֵ
		{
			as_add("myiframe0");//������¼
			setItemValue(0,0,"InputUserID","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"InputOrgID","<%=CurOrg.getOrgID()%>");
			setItemValue(0,0,"GuarantyType","<%=sItemNo%>");			
			setItemValue(0,0,"GuarantyStatus","01");
			setItemValue(0,0,"InputUserName","<%=CurUser.getUserName()%>");
			setItemValue(0,0,"InputOrgName","<%=CurOrg.getOrgName()%>");
			setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
			
			bIsInsert = true;			
		}
		
    }
    
    /*~[Describe=������������ѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/
	function selectAssureType()
	{
		sParaString = "CodeNo"+",AssureType";		
		setObjectValue("SelectCode",sParaString,"@GuarantySubType@0@GuarantySubTypeName@1",0,0,"");
	}

	/*~[Describe=�����ͻ�ѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/
	function selectCustomer()
	{
		//���ؿͻ��������Ϣ���ͻ����롢�ͻ����ơ�֤�����͡��ͻ�֤�����롢������		
		var sReturn = "";
		if(sCertType!=''&&typeof(sCertType)!='undefined'){
			sParaString = "CertType,"+sCertType;
			sReturn = setObjectValue("SelectOwner",sParaString,"@OwnerID@0@OwnerName@1@CertType@2@CertID@3@LoanCardNo@4",0,0,"");		
		}
		else{
			sParaString = "CertType, ";
			sReturn = setObjectValue("SelectOwner",sParaString,"@OwnerID@0@OwnerName@1@CertType@2@CertID@3@LoanCardNo@4",0,0,"");		
		}
		var sCertID = getItemValue(0,0,"CertID");
		if( String(sReturn)==String("_CLEAR_") ){
            setItemDisabled(0,0,"CertType",false);
            setItemDisabled(0,0,"CertID",false);
            setItemDisabled(0,0,"OwnerName",false);
            setItemDisabled(0,0,"LoanCardNo",false);
		}else if( String(sReturn)!=String("_CLEAR_") && typeof(sCertID) != "undefined" && sCertID != "" ){
            setItemDisabled(0,0,"CertType",true);
            setItemDisabled(0,0,"CertID",true);
            setItemDisabled(0,0,"OwnerName",true);
            var certType = getItemValue(0,0,"CertType");
            var temp = certType.substring(0,3);
            if(temp=='Ent'){
            	setItemRequired(0,0,"LoanCardNo",true);
            	setItemDisabled(0,0,"LoanCardNo",true);
            }
            else{
            	setItemRequired(0,0,"LoanCardNo",false);
            	setItemDisabled(0,0,"LoanCardNo",false);
            }  
            sCertType="";
        }
	}
	
	/*~[Describe=����֤�����ͺ�֤����Ż�ÿͻ���š��ͻ����ƺʹ�����;InputParam=��;OutPutParam=��;]~*/
	var sCertType="";
	function getCustomerName()
	{
		sCertType   = getItemValue(0,getRow(),"CertType");
		var sCertID   = getItemValue(0,getRow(),"CertID");
		
		if(typeof(sCertType) != "undefined" && sCertType != "" && 
		typeof(sCertID) != "undefined" && sCertID != "")
		{
			//��ÿͻ���š��ͻ����ƺʹ�����
	        var sColName = "CustomerID@CustomerName@LoanCardNo";
			var sTableName = "CUSTOMER_INFO";
			var sWhereClause = "String@CertID@"+sCertID+"@String@CertType@"+sCertType;
			
			sReturn=RunMethod("PublicMethod","GetColValue",sColName + "," + sTableName + "," + sWhereClause);
			if(typeof(sReturn) != "undefined" && sReturn != "") 
			{			
				sReturn = sReturn.split('~');
				var my_array1 = new Array();
				for(i = 0;i < sReturn.length;i++)
				{
					my_array1[i] = sReturn[i];
				}
				
				for(j = 0;j < my_array1.length;j++)
				{
					sReturnInfo = my_array1[j].split('@');	
					var my_array2 = new Array();
					for(m = 0;m < sReturnInfo.length;m++)
					{
						my_array2[m] = sReturnInfo[m];
					}
					
					for(n = 0;n < my_array2.length;n++)
					{									
						//���ÿͻ�ID
						if(my_array2[n] == "customerid")
							setItemValue(0,getRow(),"OwnerID",sReturnInfo[n+1]);
						//���ÿͻ�����
						if(my_array2[n] == "customername")
							setItemValue(0,getRow(),"OwnerName",sReturnInfo[n+1]);
						//���ô�����
						if(my_array2[n] == "loancardno") 
						{
							if(sReturnInfo[n+1] != 'null')
								setItemValue(0,getRow(),"LoanCardNo",sReturnInfo[n+1]);
							else
								setItemValue(0,getRow(),"LoanCardNo","");
						}
					}
				}			
			}else
			{
				setItemValue(0,getRow(),"OwnerID","");
				setItemValue(0,getRow(),"OwnerName","");	
				setItemValue(0,getRow(),"LoanCardNo","");			
			} 	
		}	
	}
        
	/*~[Describe=��ʼ����ˮ���ֶ�;InputParam=��;OutPutParam=��;]~*/
	function initSerialNo() 
	{
		var sTableName = "GUARANTY_INFO";//����
		var sColumnName = "GuarantyID";//�ֶ���
		var sPrefix = "";//ǰ׺

		//ʹ��GetGuarantyID.jsp����ռһ����ˮ��
		var sGuarantyID = getSerialNo(sTableName,sColumnName,sPrefix);
		//����ˮ�������Ӧ�ֶ�
		setItemValue(0,getRow(),"GuarantyID",sGuarantyID);				
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
