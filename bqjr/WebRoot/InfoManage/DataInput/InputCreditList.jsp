<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%> 

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author: cchang 2004-12-06
		Tester:
		Describe: �Ŵ����ݲ����б�;
		Input Param:
					DataInputType��010�貹���Ŵ�ҵ��
									020��������Ŵ�ҵ��
		Output Param:
			
		HistoryLog:
			     pwang 2009-10-19      ���ӵ��ǹ���
	 */
	%>
<%/*~END~*/%>



<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "�Ŵ����ݲ����б�"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>



<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
	String sSql="";
	
	String sClauseWhere="";
	//���ҳ�����
	
	//����������
	String sReinforceFlag = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ReinforceFlag"));
	if(sReinforceFlag==null) sReinforceFlag="";

	%>
<%/*~END~*/%>



<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%
	
 String sTempletNo="InputCreditList";
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	if(sReinforceFlag.equals("010") || sReinforceFlag.equals("110"))  //�����ǻ�������ҵ��
	{	
		doTemp.WhereClause += " and ManageOrgID ='"+CurOrg.getOrgID()+"' and (DeleteFlag ='' or DeleteFlag =' ' or  DeleteFlag is null)";
	}
	
	if(sReinforceFlag.equals("020") || sReinforceFlag.equals("120"))  //���ǻ�������ɵ�ҵ��
	{
		doTemp.WhereClause += " and ManageOrgID ='"+CurOrg.getOrgID()+"' and (DeleteFlag ='' or DeleteFlag =' ' or  DeleteFlag is null)";
	}
	
	doTemp.OrderClause +=" order by CustomerID,PutOutDate";
	
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style="1";      //����ΪGrid���
	dwTemp.ReadOnly = "1"; //����Ϊֻ��
	dwTemp.setPageSize(20); 	//��������ҳ

	Vector vTemp = dwTemp.genHTMLDataWindow(sReinforceFlag);
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
				{"true","","Button","���ǿͻ�","���ǿͻ���Ϣ","InputCustomerInfo()",sResourcesPath},
				{"true","","Button","����ҵ��","����ҵ����Ϣ","InputBusinessInfo()",sResourcesPath},
				{"true","","Button","�������","�������","NewContract()",sResourcesPath},
				{"true","","Button","�������","�������","CreditBusinessInfo()",sResourcesPath},
				{"true","","Button","ɾ�����","ɾ�����","DeleteContract()",sResourcesPath},
				{"true","","Button","���ǿͻ���Ϣ","���ǿͻ���Ϣ","InputCustomerInfo()",sResourcesPath},		
				{"true","","Button","�������","�������","Finished()",sResourcesPath},
				{"true","","Button","�ͻ�����","�ͻ�����","CustomerInfo()",sResourcesPath},
				{"true","","Button","ҵ������","ҵ������","BusinessInfo()",sResourcesPath},
				{"true","","Button","�ٴβ���","�ٴβ���","secondFinished()",sResourcesPath},
				{"false","","Button","�ı�ҵ��Ʒ��","�ı�ҵ��Ʒ��","changeBusinessType()",sResourcesPath},
				{"true","","Button","�ͻ���ģת��","�ͻ���ģת��","changeCustomerType()",sResourcesPath},
				{"true","","Button","��ͬ�ϲ�","��ͬ�ϲ�","UniteContract()",sResourcesPath},
				{"false","","Button","������ͬ","������ͬ","NewContract()",sResourcesPath},
				{"false","","Button","ɾ����ͬ","ɾ����ͬ","DeleteContract()",sResourcesPath},
				{"true","","Button","������ԭ����ҵ��","������ԭ����ҵ��","RelativeBusiness()",sResourcesPath},
				
			};
	String sButtons2[][] = {
				{"true","","Button","������ԭ����ҵ��","������ԭ����ҵ��","RelativeBusiness()",sResourcesPath},
				{"true","","Button","�ս���Ϣ�Ǽ�","�ս���Ϣ�Ǽ�","Account()",sResourcesPath},
				{"true","","Button","����EXCEL","����EXCEL","exportAll()",sResourcesPath}
			};
	
	//�貹���Ŵ�ҵ��
	if(sReinforceFlag.equals("010")) 
	{
		sButtons[2][0] = "false";
		sButtons[3][0] = "false";
		sButtons[4][0] = "false";
		sButtons[5][0] = "false";
		sButtons[7][0] = "false";
		sButtons[8][0] = "false";
		sButtons[9][0] = "false";
		sButtons2[0][0] = "true";
	}
	
	//��������Ŵ�ҵ��
	if(sReinforceFlag.equals("020")) 
	{
		sButtons[0][0] = "false";
		sButtons[1][0] = "false";
		sButtons[2][0] = "false";
		sButtons[3][0] = "false";
		sButtons[4][0] = "false";
		sButtons[5][0] = "false";
		sButtons[6][0] = "false";		
		sButtons[10][0] = "false";
		sButtons[11][0] = "false";
		sButtons[12][0] = "false";
		sButtons[13][0] = "false";
		sButtons[14][0] = "false";
		sButtons[15][0] = "false";
		sButtons2[0][0] = "false";
		
	}
	
	//�������
	if(sReinforceFlag.equals("110")) 
	{
		sButtons[0][0] = "false";
		sButtons[1][0] = "false";		
		sButtons[7][0] = "false";
		sButtons[8][0] = "false";
		sButtons[9][0] = "false";
		sButtons[10][0] = "false";
		sButtons[11][0] = "false";
		sButtons[12][0] = "false";
		sButtons[13][0] = "false";
		sButtons[14][0] = "false";
		sButtons[15][0] = "false";
		sButtons2[0][0] = "false";
		
	}
	
	//������ɶ��
	if(sReinforceFlag.equals("120")) 
	{		
		sButtons[0][0] = "false";
		sButtons[1][0] = "false";
		sButtons[2][0] = "false";
		sButtons[3][0] = "false";
		sButtons[4][0] = "false";
		sButtons[5][0] = "false";
		sButtons[6][0] = "false";		
		sButtons[10][0] = "false";
		sButtons[11][0] = "false";
		sButtons[12][0] = "false";
		sButtons[13][0] = "false";
		sButtons[14][0] = "false";
		sButtons[15][0] = "false";
		sButtons2[0][0] = "false";
	}
	%>
<%/*~END~*/%>




<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*�鿴��ͬ��������ļ�*/%>
<%@include file="/RecoveryManage/Public/ContractInfo.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">

	//---------------------���尴ť�¼�------------------------------------
	/*~[Describe=ɾ����¼;InputParam=��;OutPutParam=��;]~*/
	function DeleteContract()
	{
		var sSerialNo=getItemValue(0,getRow(),"SerialNo");
		var sBusinessType=getItemValue(0,getRow(),"BusinessType");
		var sReinforceFlag = "<%=sReinforceFlag%>";
				
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
		}else
		{			
			as_del("myiframe0");
			as_save("myiframe0");  //�������ɾ������Ҫ���ô����			
		}
	}
	
	/*~[Describe=�ͻ�����;InputParam=��;OutPutParam=��;]~*/
	function CustomerInfo()
	{
		var sCustomerID   = getItemValue(0,getRow(),"CustomerID");
		
		if (typeof(sCustomerID)=="undefined" || sCustomerID.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else
		{
			var sReturn = PopPageAjax("/InfoManage/DataInput/CustomerQueryActionAjax.jsp?CustomerID="+sCustomerID,"","");
			if(sReturn == "NOEXSIT")
			{
				alert("Ҫ��ѯ�Ŀͻ���Ϣ�����ڣ�");
				return;
			}
			if(sReturn == "EMPTY")
			{
				alert("Ҫ��ѯ�Ŀͻ�����Ϊ�գ���ѡ��ͻ����ͣ�");
			}
			
			openObject("ReinforceCustomer",sCustomerID,"002");
		}
	}

	/*~[Describe=��ͬ����;InputParam=��;OutPutParam=��;]~*/
	function BusinessInfo()
	{
		var sSerialNo   = getItemValue(0,getRow(),"SerialNo");
		var sReinforceFlag = "<%=sReinforceFlag%>";
		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else
		{
			if(sReinforceFlag=="110") 
			{
				openObject("AfterLoan",sSerialNo,"000");
			}
			else
			{
				openObject("AfterLoan",sSerialNo,"002");
			}
		}
	}

	/*~[Describe=��Ⱥ�ͬ����;InputParam=��;OutPutParam=��;]~*/
	function CreditBusinessInfo()
	{
		var sSerialNo   = getItemValue(0,getRow(),"SerialNo");
		var sReinforceFlag = "<%=sReinforceFlag%>";
		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else
		{
			if(sReinforceFlag=="110") 
			{
				openObject("ReinforceContract",sSerialNo,"000");
			}else
			{
				openObject("ReinforceContract",sSerialNo,"002");
			}
		}
	}

	/*~[Describe=���ǿͻ���Ϣ;InputParam=��;OutPutParam=��;]~*/
	function InputCustomerInfo()
	{
		sCustomerID   = getItemValue(0,getRow(),"CustomerID");
		if (typeof(sCustomerID)=="undefined" || sCustomerID.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else
		{
			var sReturn = PopPageAjax("/InfoManage/DataInput/CustomerQueryActionAjax.jsp?CustomerID="+sCustomerID,"","");
			if(sReturn == "NOEXSIT")
			{
				alert("Ҫ���ǵĿͻ���Ϣ�����ڣ�");
				return;
			}
			if(sReturn == "EMPTY")
			{
				alert("Ҫ���ǵĿͻ�����Ϊ�գ���ѡ��ͻ����ͣ�");
				sReturn = PopPage("/InfoManage/DataInput/UpdateInputCustomerDialog.jsp","","dialogWidth=24;dialogHeight=12;resizable=no;scrollbars=no;status:no;maximize:no;help:no;");
				if(sReturn=="" || sReturn=="_CANCEL_" || typeof(sReturn)=="undefined") return;
				sCustomerType = sReturn;
				sReturn = PopPageAjax("/InfoManage/DataInput/UpdateInputCustomerActionAjax.jsp?CustomerID="+sCustomerID+"&CustomerType="+sCustomerType,"","");
			}
			openObject("ReinforceCustomer",sCustomerID,"000");
		}
	}

	/*~[Describe=����ҵ����Ϣ;InputParam=��;OutPutParam=��;]~*/
	function InputBusinessInfo()
	{
		var sSerialNo   = getItemValue(0,getRow(),"SerialNo");		
		var sBusinessType   = getItemValue(0,getRow(),"BusinessType");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else
		{			
			if(typeof(sBusinessType)=="undefined" || sBusinessType.length==0)
			{				
				sReturn=setObjectValue("SelectBusinessType","","",0,0,"");				
				if (!(sReturn=='_CANCEL_' || typeof(sReturn)=="undefined" || sReturn.length==0 || sReturn=='_CLEAR_' || sReturn=='_NONE_'))
				{
					sss1 = sReturn.split("@");
					sBusinessType=sss1[0];									
					sReturn = PopPageAjax("/InfoManage/DataInput/UpdateInputContractActionAjax.jsp?SerialNo="+sSerialNo+"&BusinessType="+sBusinessType,"","");
				}else if (sReturn=='_CLEAR_')
				{
					return;
				}else 
				{
					return;
				}
			}
			
			openObject("ReinforceContract",sSerialNo,"001");
			reloadSelf();
		}
	}

	/*~[Describe=�ı�ͻ�����;InputParam=��;OutPutParam=��;]~*/
	function changeCustomerType()
	{
		sSerialNo   = getItemValue(0,getRow(),"SerialNo");
		sCustomerID   = getItemValue(0,getRow(),"CustomerID");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else 
		{
			sReturn=PopPage("/InfoManage/DataInput/UpdateInputCustomerDialog.jsp","","dialogWidth=350px;dialogHeight=110px;resizable=no;scrollbars=no;status:no;maximize:no;help:no;");
			if(sReturn=="" || sReturn=="_CANCEL_" || typeof(sReturn)=="undefined") return;
			sCustomerType = sReturn;
			sReturn = PopPageAjax("/InfoManage/DataInput/UpdateInputCustomerActionAjax.jsp?CustomerID="+sCustomerID+"&CustomerType="+sCustomerType,"","");
			reloadSelf();
		}
	}

	/*~[Describe=�ı�ҵ��Ʒ��;InputParam=��;OutPutParam=��;]~*/
	function changeBusinessType()
	{
		var sSerialNo   = getItemValue(0,getRow(),"SerialNo");
		var sBusinessType   = getItemValue(0,getRow(),"BusinessType");
		var sReinforceFlag = "<%=sReinforceFlag%>";
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else 
		{			
			sReturn=setObjectValue("SelectBusinessType","","",0,0,"");
			if (!(sReturn=='_CANCEL_' || typeof(sReturn)=="undefined" || sReturn.length==0 || sReturn=='_CLEAR_' || sReturn=='_NONE_'))
			{
				sss1 = sReturn.split("@");
				sBusinessType=sss1[0];
				sReturn = PopPageAjax("/InfoManage/DataInput/UpdateInputContractActionAjax.jsp?SerialNo="+sSerialNo+"&BusinessType="+sBusinessType,"","");
				reloadSelf();				
			}else if (sReturn=='_CLEAR_')
			{
				return;
			}else 
			{
				return;
			}
		
		}
	}

	/*~[Describe=������ͬ;InputParam=��;OutPutParam=��;]~*/
	function NewContract()
	{		
		var sReinforceFlag = "<%=sReinforceFlag%>";
		var sSerialNo=getItemValue(0,getRow(),"SerialNo");
				
		if(sReinforceFlag=="010")
		{  
			//������ͬ����
			var sReturn = createObject("ReinforceContract","ItemNo="+sReinforceFlag+"~ReinforceFlag=G");
		}else
		{
			//������Ƚ���
			var sReturn = createObject("ReinforceContract","ItemNo="+sReinforceFlag);
		}
		
		if(sReturn=="" || sReturn=="_CANCEL_" || typeof(sReturn)=="undefined") return;
		sss = sReturn.split("@");
		sSerialNo=sss[0];

		openObject("ReinforceContract",sSerialNo,"000");
		reloadSelf();		
	}

	/*~[Describe=����ɲ��Ǳ�־;InputParam=��;OutPutParam=��;]~*/
	function Finished()
	{
		//��ͬ��ˮ�š��ͻ���š�ҵ��Ʒ��
		var sSerialNo   = getItemValue(0,getRow(),"SerialNo");
		var sCustomerID   = getItemValue(0,getRow(),"CustomerID");
		var sBusinessType   = getItemValue(0,getRow(),"BusinessType");
		
		//��ʾ���ǽ����б�
		var sReinforceFlag = "<%=sReinforceFlag%>";
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else if(confirm("���Ҫ���������")) 
		{						
			if(typeof(sBusinessType)=="undefined" || sBusinessType.length==0)
			{
				alert("ҵ��Ʒ��Ϊ�գ����Ȳ���ҵ��Ʒ�֣�");
				return;
			}else
			{	
				var sExistFlag = PopPageAjax("/InfoManage/DataInput/ReinforceCheckActionAjax.jsp?ContractNo="+sSerialNo+"&CustomerID="+sCustomerID,"","");
				
				if(sExistFlag!="true")
				{
					alert(sExistFlag);
					return;
				}else
				{					
					sReturn = PopPage("/InfoManage/DataInput/ReinforceFlagAction.jsp?SerialNo="+sSerialNo+"&ReinforceFlag="+sReinforceFlag,"","");
					if(sReturn == "succeed")
					{
						if(sReinforceFlag == "010")
						{
							alert("������ɣ���ҵ����ת����������Ŵ�ҵ���б�!");
						}else
						{
							alert("������ɣ���ҵ����ת��������ɶ���б�!");
						}
						
					}
					reloadSelf();	
				}
			}
		}
	}

	</script>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">
	/*~[Describe=�ٴβ���;InputParam=��;OutPutParam=��;]~*/
	function secondFinished()
	{
		sSerialNo   = getItemValue(0,getRow(),"SerialNo");
		var sReinforceFlag = "<%=sReinforceFlag%>";
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}
		else if(confirm("���Ҫ�ٴβ�����")) 
		{
			sReturn = PopPage("/InfoManage/DataInput/ReinforceFlagAction.jsp?SerialNo="+sSerialNo+"&ReinforceFlag="+sReinforceFlag+"&Flag1=SecondFlag","","");
			
			if(sReturn == "succeed")
			{
				alert(getBusinessMessage('186'));
			}
			
			if(sReturn == "true")
			{
				if(sReinforceFlag == "020")
				{
					alert("�ٴβ��ǣ���ѡ���ݽ��ص��貹��ҵ���б�!");
				}else
				{
					alert("�ٴβ��ǣ���ѡ���ݽ��ص���������б�!");
				}
			}
			
			if(sReturn == "false")
			{
				alert("��ѡ�ʲ��Ѿ��ַ�,�����ٴβ���!");
			}
			reloadSelf();		
		}
	}


	/*~[Describe=�ϲ���ͬ;InputParam=��;OutPutParam=��;]~*/
	function UniteContract()
	{
		//��ͬ��ˮ�š��ͻ���š���ͬ���
		var sSerialNo   = getItemValue(0,getRow(),"SerialNo");
		var sCustomerID   = getItemValue(0,getRow(),"CustomerID");
		var sArtificialNo   = getItemValue(0,getRow(),"ArtificialNo");
		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else 
		{			
			 var sReturn = popComp("UniteContractSelectList","/InfoManage/DataInput/UniteContractSelectList.jsp","ContractNo="+sSerialNo+"&ArtificialNo="+sArtificialNo+"&CustomerID="+sCustomerID,"dialogWidth=50;dialogHeight=40;","resizable=yes;scrollbars=yes;status:no;maximize:yes;help:no;");
			 if(sReturn=="true")
			 {
				reloadSelf();
			 }	
		}
	}

	/*~[Describe=�Ѻϲ���ͬ��ѯ;InputParam=��;OutPutParam=��;]~*/
	function QueryContract()
	{
		//��ͬ��ˮ�š��ͻ���š���ͬ���
		var sSerialNo   = getItemValue(0,getRow(),"SerialNo");
		var sCustomerID   = getItemValue(0,getRow(),"CustomerID");
		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else 
		{			
			 popComp("UniteContractSelectList","/InfoManage/DataInput/UniteContractSelectList.jsp","ContractNo="+sSerialNo+"&CustomerID="+sCustomerID+"&Flag=QueryContract","_self","dialogWidth=100;dialogHeight=20;resizable=no;scrollbars=no;status:no;maximize:no;help:no;");
		}
	}

	function RelativeBusiness()
	{
		//��ͬ��ˮ�š��ͻ���š���ͬ���
		var sBCSerialNo   = getItemValue(0,getRow(),"SerialNo");
		var sBusinessType = getItemValue(0,getRow(),"BusinessType");
		var sCustomerID = getItemValue(0,getRow(),"CustomerID");
		var OriBDSerialNo ;
		var sRelativeContractNo;
		var sReturn ;
		var sParaString;
		
		if (typeof(sBCSerialNo)=="undefined" || sBCSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else 
		{
			if (sBusinessType == '1130010' || sBusinessType == '1130020' || sBusinessType == '1130030' || sBusinessType == '1130040' || sBusinessType == '1130050')
			{
				sParaString = "CustomerID"+","+sCustomerID;
				sRelativeContractNo=setObjectValue("SelectOriDuebill",sParaString,"",0,0,"");				
				
				if(typeof(sRelativeContractNo)=="undefined" || sRelativeContractNo.length==0 || sRelativeContractNo == "_CANCEL_" || sRelativeContractNo == "_CLEAR_")
				{
				    return;
				}
				sRelativeContractNo = sRelativeContractNo.split("@");
				sRelativeContractNo=sRelativeContractNo[0];

				sReturn = RunMethod("InfoManage","DataInputLater",sBCSerialNo+","+sRelativeContractNo);
				if(sReturn == "1")
				{
					alert("�����ɹ�");
				}else{
					if(sReturn == "2"){
					   alert("û�й����ú�ͬ�Ľ��.")
					}
					else
						 alert("����");
				}
			}else
			{
				alert("��ǰҵ���ǵ��ҵ����ѡ��һ�ʵ��ҵ��չ��");
			}
		}
		reloadSelf();
	}

	/*~[Describe=̨�ʹ���;InputParam=��;OutPutParam=��;]~*/
	function Account()
	{
		sSerialNo   = getItemValue(0,getRow(),"SerialNo");
		sBalance   = getItemValue(0,getRow(),"Balance");
		sInterestbalance1   = getItemValue(0,getRow(),"Interestbalance1");
		sInterestbalance2   = getItemValue(0,getRow(),"Interestbalance2");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else
		{
			if((sBalance=="0" || sBalance=="") && (sInterestbalance1=="0" || sInterestbalance1=="") && (sInterestbalance2=="0" || sInterestbalance2==""))
			{
			    OpenComp("ContractFinished","/CreditManage/CreditCheck/ContractFinishedInfo.jsp","cando=Y&ComponentName=�ս���Ϣ&ObjectNo="+sSerialNo,"_blank",OpenStyle);
			}
			else
			{
			    OpenComp("ContractFinished","/CreditManage/CreditCheck/ContractFinishedInfo.jsp","ComponentName=�ս���Ϣ&ObjectNo="+sSerialNo,"_blank",OpenStyle);
			}
		}
	}
    /*~[Describe=����;InputParam=��;OutPutParam=��;]~*/
	function exportAll()
	{
		amarExport("myiframe0");
	}
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
