<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/%>
	<%
	/*
		Author: --FMWu 2004-11-29
		Tester:
		Describe: --�ɶ����;
		Input Param:
			CustomerID��--��ǰ�ͻ����
			RelativeID��--�����ͻ���֯��������
			Relationship��--������ϵ	
			EditRight:--Ȩ�޴��루01���鿴Ȩ��02��ά��Ȩ��		
		Output Param:

		HistoryLog:
			DATE	CHANGER		CONTENT
			2005-7-24	fbkang	��������ʽ			
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "�ʱ��������"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
     String sSql = "";
     
	//����������,�ͻ�����
	String sCustomerID = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerID"));
	if(sCustomerID == null) sCustomerID = "";
	//���ҳ������������ͻ����롢������ϵ���༭Ȩ��
	String sRelativeID = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("RelativeID"));
	String sRelationShip = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("RelationShip"));
	String sEditRight  = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("EditRight"));
	String sCustomerScale = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerScale",2));
	if(sRelativeID == null) sRelativeID = "";
	if(sRelationShip == null) sRelationShip = "";
	if(sEditRight == null) sEditRight = "";
	if(sCustomerScale == null) sCustomerScale = "";
	
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/%>
	<%
 
	
	// ͨ��DWģ�Ͳ���ASDataObject����doTemp
	String sTempletNo = "EntOwnerInfo";//ģ�ͱ��
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	if(sRelativeID == null || sRelativeID.equals("")){
		doTemp.setUnit("CustomerName"," <input type=button class=inputdate value=.. onclick=parent.selectCustomer()><font color=red>(�����ѡ)</font><font class=ecrmpt9>&nbsp;(���� M)&nbsp;</font>");
		doTemp.setHTMLStyle("CertID"," onchange=parent.getCustomerName() ");
	} else {
		doTemp.setUnit("CustomerName"," <font class=ecrmpt9>&nbsp;(���� M)&nbsp;</font>");
		doTemp.setReadOnly("CustomerName,CertType,CertID,RelationShip,CustomerType",true);
	}
	//doTemp.appendHTMLStyle("CertType","onchange=parent.setCustomerType()");
	//����ʵ��Ͷ�ʽ��(Ԫ)��Χ
	//doTemp.appendHTMLStyle("InvestmentSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"ʵ��Ͷ�ʽ��(Ԫ)������ڵ���0��\" ");
	//���ó��ʱ���(%)��Χ
  	//doTemp.appendHTMLStyle("InvestmentProp"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"���ʱ���(%)�ķ�ΧΪ[0,100]\" ");
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";		// ����DW��� 1:Grid 2:Freeform
	if(sEditRight.equals("01"))
	{
		dwTemp.ReadOnly="1";
		doTemp.appendHTMLStyle(""," style={color:#848284} ");
	}
	
	/* dwTemp.Style="2";      // ����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; // �����Ƿ�ֻ�� 1:ֻ�� 0:��д */
	
	//���ò���͸����¼������������͸���
	dwTemp.setEvent("AfterInsert","!CustomerManage.AddRelation(#CustomerID,#RelativeID,#RelationShip)+!CustomerManage.AddCustomerInfo(#RelativeID,#CustomerName,#CertType,#CertID,#LoanCardNo,#InputUserID,#CustomerType)");
	dwTemp.setEvent("AfterUpdate","!CustomerManage.UpdateRelation(#CustomerID,#RelativeID,#RelationShip)");

	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sCustomerID+","+sRelativeID+","+sRelationShip);//�������,���ŷָ�
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
			{"false","","Button","����","�����ʱ�����","newRecord()",sResourcesPath},
			{(sEditRight.equals("02")?"true":"false"),"All","Button","����","���������޸�","saveRecord()",sResourcesPath},
			{"true","","Button","�ɶ���Ϣ����","�鿴�ɶ���Ϣ����","viewOwnerInfo()",sResourcesPath},
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
	var selectCustMode = false;//�ͻ�ѡ��ʽ��false��ʾ����ͻ���true��ʾ����ͻ������ڴ��Ψһ��У�������ơ�
	var sLoanCard ="";//��¼�����
	//---------------------���尴ť�¼�------------------------------------
	
	/*~[Describe=������¼;InputParam=��;OutPutParam=��;]~*/
	//add by wlu 2009-02-19
	function newRecord()
	{
		OpenPage("/CustomerManage/EntManage/EntOwnerInfo.jsp?EditRight=02","_self","");
	}	

	/*~[Describe=����;InputParam=�����¼�;OutPutParam=��;]~*/
	function saveRecord(sPostEvents)
	{
		//¼��������Ч�Լ��
		if (!ValidityCheck()) return;	
		//if(!chkCustomerType()) return;
		if(bIsInsert){
			//����ǰ���м��,���ͨ�����������,���������ʾ
		    if (!RelativeCheck()) return;
			beforeInsert();
			//��������,���Ϊ��������,�����ҳ��ˢ��һ��,��ֹ�������޸�
			beforeUpdate();
			as_save("myiframe0","pageReload()");
			return;
		}

		beforeUpdate();
		as_save("myiframe0",sPostEvents);
	}
	
	/*~[Describe=���عɶ���Ϣ����ҳ��;InputParam=��;OutPutParam=��;]~*/
	//add by wlu 2009-02-19
	function viewOwnerInfo()
	{
		sRelativeID = getItemValue(0,getRow(),"RelativeID");//--�����ͻ�����
		if(typeof(sRelativeID) == "undefined" || sRelativeID == "")
		{
			alert("���ȱ��棡");
			return;
		}
		sReturn = RunMethod("CustomerManage","CheckRolesAction",sRelativeID+",<%=CurUser.getUserID()%>");
	    if (typeof(sReturn) == "undefined" || sReturn.length == 0){
	    	return;
	    }

	    var sReturnValue = sReturn.split("@");
	    sReturnValue1 = sReturnValue[0];
	    sReturnValue2 = sReturnValue[1];
	    sReturnValue3 = sReturnValue[2];
	                        
	    if(sReturnValue1 == "Y" || sReturnValue2 == "Y1" || sReturnValue3 == "Y2"){    		
	    		openObject("Customer",sRelativeID+"&<%=sCustomerScale%>","001");
	    		//reloadSelf();
		}else{
		    alert(getBusinessMessage('115'));//�Բ�����û�в鿴�ÿͻ���Ȩ�ޣ�
		}
	}
		
	/*~[Describe=�����б�ҳ��;InputParam=��;OutPutParam=��;]~*/
	function goBack()
	{
		OpenPage("/CustomerManage/EntManage/EntOwnerList.jsp?","_self","");
	}


	
	/*~[Describe=֤������Ϊ����֤��ʱ���ͻ���������Ϊ���˿ͻ�;InputParam=��;OutPutParam=��;]~*/
	function setCustomerType(){
		sCertType = getItemValue(0,getRow(),"CertType");
		if(sCertType.length >= 3){
			if(sCertType.substr(0,3) == "Ind"){
				setItemValue(0,getRow(),"CustomerType","0310");
			}else{
				setItemValue(0,getRow(),"CustomerType","0110");
			}
		}
	}
	/*~[Describe=���ͻ�����;InputParam=��;OutPutParam=��;]~*/
	/* function chkCustomerType(){
			sCertType = getItemValue(0,getRow(),"CertType");
			sCustomerType = getItemValue(0,getRow(),"CustomerType");

			if(sCustomerType == "" || sCustomerType.length == 0){
				alert("�ͻ����Ͳ���Ϊ��");
				try{setItemFocus(0,0,"CustomerType");}catch(e){}
				return false;
			}
			if(sCertType.length >= 3){
				//����֤��ʱ������ѡ����ҵ��ͻ�
				if(sCertType.substr(0,3) == "Ind"){
					if(sCustomerType.substr(0,2) != "03"){
						alert("֤������Ϊ������֤��ʱ���ͻ����ͱ���Ϊ������ͻ�");
						try{setItemFocus(0,0,"CustomerType");}catch(e){}
						return false;
					}
				//��ҵ�ͻ�����Ҫ���ͻ������Ƿ�¼��
				}else if(sCertType.substr(0,3) == "Ent"){
					if(sCustomerType.substr(0,2) != "01"){
						alert("֤������Ϊ��ҵ��֤��ʱ���ͻ����ͱ���Ϊ��˾��ͻ�");
						try{setItemFocus(0,0,"CustomerType");}catch(e){}
						return false;
					}
				}
			}
			return true;
	} */
	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info07;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">
	/*~[Describe=��������ҳ��ˢ�¶���;InputParam=��;OutPutParam=��;]~*/
	function pageReload()
	{
		var sRelativeID   = getItemValue(0,getRow(),"RelativeID");//--�����ͻ�����
		var sRelationShip   = getItemValue(0,getRow(),"RelationShip");//--������ϵ
		OpenPage("/CustomerManage/EntManage/EntOwnerInfo.jsp?RelativeID="+sRelativeID+"&RelationShip="+sRelationShip+"&EditRight=<%=sEditRight%>", "_self","");
	}

	/*~[Describe=�����ͻ�ѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/
	function selectCustomer()
	{
	    //���ؿͻ��������Ϣ���ͻ����롢�ͻ����ơ�֤�����͡��ͻ�֤�����롢������	
	    var sReturn = "";
	    if(sCertType!=""&&typeof(sCertType)!="undefined"){
	    	sParaString = "CertType,"+sCertType;
	    	sReturn = setObjectValue("SelectOwner",sParaString,"@RelativeID@0@CustomerName@1@CertType@2@CertID@3@LoanCardNo@4",0,0,"");	    
	    }else{
	    	sParaString = "CertType, ";
			sReturn = setObjectValue("SelectOwner",sParaString,"@RelativeID@0@CustomerName@1@CertType@2@CertID@3@LoanCardNo@4",0,0,"");	    
	    }
		if(sReturn == "_CLEAR_"){
			setItemDisabled(0,0,"CertType",false);
			setItemDisabled(0,0,"CertID",false);
			setItemDisabled(0,0,"CustomerName",false);
			selectCustMode = false;
			sLoanCard = "";
		}else{
			//��ֹ�û��㿪��ʲôҲ��ѡ��ֱ��ȡ��������ס�⼸������
			sCertID = getItemValue(0,0,"CertID");
			if(typeof(sCertID) != "undefined" && sCertID != ""){
				setItemDisabled(0,0,"CertType",true);
				setItemDisabled(0,0,"CertID",true);
				setItemDisabled(0,0,"CustomerName",true);
				setItemDisabled(0,0,"CustomerType",true);  //added by yzheng
				selectCustMode = true;
				var certType = getItemValue(0,0,"CertType");
				var temp = certType.substring(0,3); 
				  if(temp=='Ent'){
					  sLoanCard = getItemValue(0,0,"LoanCardNo");//�����
					  setItemRequired(0,0,"LoanCardNo",true);
					  setItemDisabled(0,0,"LoanCardNo",true);
				  }  else{
					    sLoanCard = "";
		            	setItemRequired(0,0,"LoanCardNo",false);
		            	setItemDisabled(0,0,"LoanCardNo",false);
		            }
				  sCertType="";
			}else{
				setItemDisabled(0,0,"CertType",false);
				setItemDisabled(0,0,"CertID",false);
				setItemDisabled(0,0,"CustomerName",false);
				setItemDisabled(0,0,"LoanCardNo",false);
				selectCustMode = false;
				sLoanCard = "";
			}
		}
	}
	
	/*~[Describe=����֤�����ͺ�֤����Ż�ÿͻ���źͿͻ�����;InputParam=��;OutPutParam=��;]~*/
	var sCertType="";
	function getCustomerName()
	{
		sCertType   = getItemValue(0,getRow(),"CertType");//--֤������
		var sCertID   = getItemValue(0,getRow(),"CertID");//--֤������
        
        if(typeof(sCertType) != "undefined" && sCertType != "" && 
		typeof(sCertID) != "undefined" && sCertID != "")
		{
	        //��ÿͻ�����
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
						//���ÿͻ����
						if(my_array2[n] == "customerid")
							setItemValue(0,getRow(),"RelativeID",sReturnInfo[n+1]);
						//���ÿͻ�����
						if(my_array2[n] == "customername")
							setItemValue(0,getRow(),"CustomerName",sReturnInfo[n+1]);
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
				setItemValue(0,getRow(),"RelativeID","");
				setItemValue(0,getRow(),"CustomerName","");	
				setItemValue(0,getRow(),"LoanCardNo","");			
			}  
		}
	}

	/*~[Describe=ִ�в������ǰִ�еĴ���;InputParam=��;OutPutParam=��;]~*/
	function beforeInsert()
	{
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
			setItemValue(0,0,"InputUserID","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"UserName","<%=CurUser.getUserName()%>");
			setItemValue(0,0,"InputOrgID","<%=CurOrg.getOrgID()%>");
			setItemValue(0,0,"OrgName","<%=CurOrg.getOrgName()%>");
			setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"CurrencyType","01");
		}
	}
	
	/*~[Describe=��Ч�Լ��;InputParam=��;OutPutParam=ͨ��true,����false;]~*/
	function ValidityCheck()
	{		
	    sCertID = getItemValue(0,0,"CertID");//֤������
		//У��ɶ�������
		sLoanCardNo = getItemValue(0,getRow(),"LoanCardNo");//�ɶ�������	
		if(typeof(sLoanCardNo) != "undefined" && sLoanCardNo != "" )
		{
			if(sLoanCard != sLoanCardNo || selectCustMode == false)
			{
				//����ɶ�������Ψһ��
				sCustomerName = getItemValue(0,getRow(),"CustomerName");//�ͻ�����	
				sReturn=RunMethod("CustomerManage","CheckLoanCardNo",sCustomerName+","+sLoanCardNo);
				if(typeof(sReturn) != "undefined" && sReturn != "" && sReturn == "Many") 
				{
					alert(getBusinessMessage('231'));//�ùɶ��������ѱ������ͻ�ռ�ã�							
					return false;
				}	
			}					
		}

		//У��ɶ��Ƿ��޸�
		sCustomerName = getItemValue(0,getRow(),"CustomerName");//�ͻ�����
		sReturn=RunMethod("CustomerManage","CheckCustomerName",sCustomerName+","+sCertID);
		if(typeof(sReturn) != "undefined" && sReturn != "" && sReturn == "Many") 
		{
			alert(getBusinessMessage('257'));//�ùɶ��Ѿ����ڣ��벻Ҫ�޸��û�����							
			return false;
		}						
		//У��ɶ��ĳ��ʱ���(%)֮���Ƿ񳬹�100%
		sRelativeID = getItemValue(0,getRow(),"RelativeID");//--�����ͻ�����
		sCustomerID = getItemValue(0,getRow(),"CustomerID");//--����ͻ�����
		sInvestmentProp = getItemValue(0,getRow(),"InvestmentProp");//--���ʱ���(%)
		if(typeof(sInvestmentProp) != "undefined" && sInvestmentProp != "" )
		{
			sStockSum = RunMethod("CustomerManage","CalculateStock",sCustomerID+","+sRelativeID);
			sTotalStockSum = parseFloat(sStockSum) + parseFloat(sInvestmentProp);
			if(sTotalStockSum > 100)
			{
				alert(getBusinessMessage('138'));//���йɶ��ĳ��ʱ���(%)֮�Ͳ��ܳ���100%��
				return false;
			}
		}
		return true;
	}

	/*~[Describe=������ϵ����ǰ���;InputParam=��;OutPutParam=ͨ��true,����false;]~*/
	function RelativeCheck()
	{			
		sCustomerID   = getItemValue(0,0,"CustomerID");//--�ͻ�����		
		sCertType = getItemValue(0,0,"CertType");//--֤������		
		sCertID = getItemValue(0,0,"CertID");//֤������		
		sRelationShip = getItemValue(0,0,"RelationShip");//--������ϵ
		if (typeof(sRelationShip) != "undefined" && sRelationShip != '')
		{			
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
