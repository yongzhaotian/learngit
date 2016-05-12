<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author: cchang 2004-12-06
		Tester:
		Describe: ����̨���б���Ϣ;
		Input Param:
			ContractType��
				010010����δ�ս�ҵ��
				010020����δ�ս�ҵ��
				020010�����ս�ҵ��
				020020�����ս�ҵ��	
				030010010����δ�ս�ҵ��(���ƽ���ȫ)
				030010020����δ�ս�ҵ��(���ƽ���ȫ)
				030020010�����ս�ҵ��(���ƽ���ȫ)
				030020020�����ս�ҵ��(���ƽ���ȫ)						
		Output Param:
			
		HistoryLog:
					2005.7.28 hxli  sql��д�������д
					2005.08.09 ��ҵ� �޸ĵ�������ť
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "�����ͬ�б�"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%!
	int getBtnIdxByName(String[][] sArray, String sButtonName){
		for (int i=0;i<sArray.length;i++) {
			if (sButtonName.equals(sArray[i][3]))
				return i;
		}
		return -1;
	}
%>
<%

	//�������
	String sSql = "";
	//���ҳ�����
	//����������
	String sContractType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ContractType"));
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%
	//	010010����δ�ս�ҵ��
	//	010020����δ�ս�ҵ��
	//	020010�����ս�ҵ��
	//	020020�����ս�ҵ��
	//  030010010����δ�ս�ҵ��(���ƽ���ȫ)
	//  030010020����δ�ս�ҵ��(���ƽ���ȫ)
	//  030020010�����ս�ҵ��(���ƽ���ȫ)
	//  030020020�����ս�ҵ��(���ƽ���ȫ)
	
	String sTempletNo = "ContractList";
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
	
	
	if(sContractType.equals("010010") || sContractType.equals("030010010")){
		if(sContractType.equals("010010"))
			doTemp.WhereClause += " and Balance >= 0 and OffSheetFlag in ('EntOn','IndOn') and (FinishDate = ' ' or FinishDate is null) and (RecoveryOrgID = ' ' or RecoveryOrgID is null)" +
					" and (ReinforceFlag ='000' or ReinforceFlag ='020')";
			/* sSql += " and Balance >= 0 and OffSheetFlag in ('EntOn','IndOn') and (FinishDate = ' ' or FinishDate is null) and (RecoveryOrgID = ' ' or RecoveryOrgID is null)" +
					" and (ReinforceFlag ='000' or ReinforceFlag ='020')"; */
		else
			doTemp.WhereClause += " and Balance >= 0 and OffSheetFlag in ('EntOn','IndOn') and (FinishDate = ' ' or FinishDate is null) and (RecoveryOrgID <> ' ' and RecoveryOrgID is not null)"+
					" and (ReinforceFlag ='000' or ReinforceFlag ='020')";
	}
	else if(sContractType.equals("010020") || sContractType.equals("030010020")){
		if(sContractType.equals("010020"))
			doTemp.WhereClause += " and Balance >= 0 and OffSheetFlag in ('EntOff','IndOff') and (FinishDate = ' ' or FinishDate is null) and (RecoveryOrgID = ' ' or RecoveryOrgID is null)" +
					" and (ReinforceFlag ='000' or ReinforceFlag ='020')";
		else
			doTemp.WhereClause += " and Balance >= 0 and OffSheetFlag in ('EntOff','IndOff') and (FinishDate = ' ' or FinishDate is null) and (RecoveryOrgID <> ' ' and RecoveryOrgID is not null)" +
					" and (ReinforceFlag ='000' or ReinforceFlag ='020')";
	}	
	else if(sContractType.equals("020010") || sContractType.equals("030020010")){
		if(sContractType.equals("020010"))
			doTemp.WhereClause += " and (FinishDate <> ' ' and FinishDate is not null) and OffSheetFlag in ('EntOn','IndOn') and (RecoveryOrgID = ' ' or RecoveryOrgID is null)" +
					" and (ReinforceFlag ='000' or ReinforceFlag ='020')";
		else
			doTemp.WhereClause += " and (FinishDate <> ' ' and FinishDate is not null) and OffSheetFlag in ('EntOn','IndOn') and (RecoveryOrgID <> ' ' and RecoveryOrgID is not null)" +
					" and (ReinforceFlag ='000' or ReinforceFlag ='020')";
	}
	else if(sContractType.equals("020020") || sContractType.equals("030020020")){
		if(sContractType.equals("020020"))
			doTemp.WhereClause += " and (FinishDate <> ' ' and FinishDate is not null) and OffSheetFlag in ('EntOff','IndOff') and (RecoveryOrgID = ' ' or RecoveryOrgID is null)" +
					" and (ReinforceFlag ='000' or ReinforceFlag ='020')";
		else
			doTemp.WhereClause += " and (FinishDate <> ' ' and FinishDate is not null) and OffSheetFlag in ('EntOff','IndOff') and (RecoveryOrgID <> ' ' and RecoveryOrgID is not null)" +
					" and (ReinforceFlag ='000' or ReinforceFlag ='020')";
	}
		
	//����֧�пͻ��������пͻ��������пͻ�������û�ֻ�ܲ鿴�Լ��ܻ��ĺ�ͬ
	if(CurUser.hasRole("480") || CurUser.hasRole("280") || CurUser.hasRole("080")){
		doTemp.WhereClause += " and ManageUserID = '"+CurUser.getUserID()+"'";
	}else{
		//���ǿͻ������ܲ鿴
		doTemp.WhereClause += " and 1=2";
	}
	doTemp.OrderClause = " order by CustomerName";
	
	/* doTemp.setHeader(sHeaders); */
	if(sContractType.equals("010010") || sContractType.equals("020010"))
	{
		doTemp.setVisible("BailAccount,BailSum,ClearSum,PdgRatio",false);	
	}
	if(sContractType.equals("010020") || sContractType.equals("020020"))
	{
		doTemp.setVisible("OverdueBalance,FineBalance1,FineBalance2,OccurTypeName,BusinessRate",false);	
	}
	
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));

	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����ΪGrid���
	dwTemp.ReadOnly = "1"; //����Ϊֻ��
	dwTemp.setPageSize(20); 	//��������ҳ
	dwTemp.ShowSummary = "1";

	Vector vTemp = dwTemp.genHTMLDataWindow("");
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
	/* add by hwang 20090611 ��������̨���н軹���¼�ֹ�ά������,���Ӱ�ť���軹���¼��  */
	String sButtons[][] = {
			{"true","","Button","��ͬ����","��ͬ����","viewTab()",sResourcesPath},
			{"true","","Button","������ͬ��Ϣ","������ͬ����","AssureManage()",sResourcesPath},			
			{"false","","Button","�軹���¼","�軹���¼����","WasteBookManage()",sResourcesPath},		
			{"true","","Button","�����ʼ�","�������ʼ�","WorkRecord()",sResourcesPath},
			{"true","","Button","�ƽ���ȫ","�������ʲ��ƽ���ȫ������","ShiftRMDepart()",sResourcesPath},
			{"true","","Button","�����ص�����","�����ص�����","AddUserDefine()",sResourcesPath},
			{"true","","Button","���պ�����","���պ�����","my_DunManage()",sResourcesPath},
			{"true","","Button","��ͬ�ս�","�ս����Ͳ���","my_Finish()",sResourcesPath},
			{"true","","Button","���ʽ����","���ʽ����","my_ReturnWay()",sResourcesPath},
			{"true","","Button","����EXCEL","����EXCEL","exportAll()",sResourcesPath},
		};
		
	if(sContractType.equals("010020"))//δ�ս����ҵ��
	{
		sButtons[getBtnIdxByName(sButtons,"���ʽ����")][0]="false";
	}
	
	if(sContractType.equals("020010") ||sContractType.equals("020020"))//���ս�ҵ��
	{
		sButtons[getBtnIdxByName(sButtons,"������ͬ��Ϣ")][0]="false";
		/* add by hwang 20090611 ��������̨���н軹���¼�ֹ�ά������  */
		sButtons[getBtnIdxByName(sButtons,"�軹���¼")][0]="false";		
		sButtons[getBtnIdxByName(sButtons,"�ƽ���ȫ")][0]="false";
		sButtons[getBtnIdxByName(sButtons,"�����ص�����")][0]="false";
		sButtons[getBtnIdxByName(sButtons,"���պ�����")][0]="false";
		sButtons[getBtnIdxByName(sButtons,"�����ʼ�")][0]="false";
		sButtons[getBtnIdxByName(sButtons,"��ͬ�ս�")][0]="false";
		sButtons[getBtnIdxByName(sButtons,"���ʽ����")][0]="false";
	}
	
	if(sContractType.indexOf("030") >= 0) //���ƽ���ȫ
	{		
		sButtons[getBtnIdxByName(sButtons,"������ͬ��Ϣ")][0]="false";
		/* add by hwang 20090611 ��������̨���н軹���¼�ֹ�ά������  */
		sButtons[getBtnIdxByName(sButtons,"�軹���¼")][0]="false";	
		sButtons[getBtnIdxByName(sButtons,"�ƽ���ȫ")][0]="false";
		sButtons[getBtnIdxByName(sButtons,"�����ص�����")][0]="false";
		sButtons[getBtnIdxByName(sButtons,"���պ�����")][0]="false";
		sButtons[getBtnIdxByName(sButtons,"�����ʼ�")][0]="false";
		sButtons[getBtnIdxByName(sButtons,"��ͬ�ս�")][0]="false";
		sButtons[getBtnIdxByName(sButtons,"���ʽ����")][0]="false";		
	}
	%>
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">

	//---------------------���尴ť�¼�------------------------------------

	/*~[Describe=ʹ��OpenComp������;InputParam=��;OutPutParam=��;]~*/
	function viewTab()
	{
		sObjectType = "AfterLoan";
		sObjectNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		sApproveType = getItemValue(0,getRow(),"ApproveType");
		sCompID = "CreditTab";
		sCompURL = "/CreditManage/CreditApply/ObjectTab.jsp";
		sParamString = "ObjectType="+sObjectType+"&ObjectNo="+sObjectNo+"&ApproveType="+sApproveType;
		OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
	}

	/*~[Describe=������ͬ����;InputParam=��;OutPutParam=��;]~*/
	function AssureManage()
	{
		sSerialNo   = getItemValue(0,getRow(),"SerialNo");		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else
		{
			OpenComp("AssureView","/CreditManage/CreditPutOut/AssureView.jsp","ComponentName=������ͬ����&ObjectType=AfterLoan&ObjectNo="+sSerialNo,"_blank",OpenStyle);
		}
	}
	
	/********** add by hwang 20090611 ��������̨���н軹���¼�ֹ�ά������***************/
	/*~[Describe=�軹���¼����;InputParam=��;OutPutParam=��;]~*/
	function WasteBookManage()
	{
		sSerialNo   = getItemValue(0,getRow(),"SerialNo");		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else
		{
			//OpenPage("/CreditManage/CreditPutOut/AccountWasteBookList.jsp?AccountType=ALL&ObjectNo="+sSerialNo,"_self","");
			OpenComp("WasteBookManage","/CreditManage/CreditPutOut/AccountWasteBookList1.jsp","ComponentName=�軹���¼&AccountType=ALL&ObjectNo="+sSerialNo,"_blank",OpenStyle);
		}
	}
	
	/*~[Describe=�������ʼ�;InputParam=��;OutPutParam=��;]~*/
	function WorkRecord()
	{
		sSerialNo   = getItemValue(0,getRow(),"SerialNo");		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else
		{
			OpenComp("WorkRecordList","/DeskTop/WorkRecordList.jsp","ComponentName=�������ʼ�&NoteType=BusinessContract&ObjectNo="+sSerialNo,"_blank",OpenStyle);
		}
	}
	
	/*~[Describe=�峥�鵵;InputParam=��;OutPutParam=��;]~*/
	function my_Finish()
	{
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo) == "undefined" || sSerialNo.length == 0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		else
		{
			//��ȡ��ͬ������ǷϢ������ǷϢ
			sBalance = getItemValue(0,getRow(),"Balance");
			sInterestBalance1 = getItemValue(0,getRow(),"InterestBalance1");
			sInterestBalance2 = getItemValue(0,getRow(),"InterestBalance2");
			if((parseFloat(sBalance)+parseFloat(sInterestBalance1)+parseFloat(sInterestBalance2)) > 0)
			{
				alert(getBusinessMessage('649'));//�ú�ͬ��������ǷϢ������ǷϢ���>0�����ܽ����ս������
				return;
			}else
			{			
				//�����Ի�ѡ���
				sReturn = PopPage("/RecoveryManage/NPAManage/NPADailyManage/NPAFinishedTypeDialog.jsp","","dialogWidth:22;dialogHeight:10;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no;");
				if(typeof(sReturn) != "undefined" && sReturn.length != 0)
				{
					ss = sReturn.split('@');
					sFinishedType = ss[0];
					sFinishedDate = ss[1];
					//�ս����
					sReturn = RunMethod("PublicMethod","UpdateColValue","String@FinishType@"+sFinishedType+"@String@FinishDate@"+sFinishedDate+",BUSINESS_CONTRACT,String@SerialNo@"+sSerialNo);
					if(typeof(sReturn) == "undefined" || sReturn.length == 0) {				
						alert(getHtmlMessage('62'));//�ս�ʧ�ܣ�
						return;			
					}else
					{
						reloadSelf();	
						alert(getHtmlMessage('43'));//�ս�ɹ���
					}	
				}
			}
		}
	}

	/*~[Describe=�����ص��ͬ����;InputParam=��;OutPutParam=��;]~*/
	function AddUserDefine()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0) 
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		if(confirm(getBusinessMessage('420'))) //Ҫ�������ͬ��Ϣ�����ص��ͬ��������
		{
			var sRvalue=PopPageAjax("/Common/ToolsB/AddUserDefineActionAjax.jsp?ObjectType=BusinessContract&ObjectNo="+sSerialNo,"","");
			alert(getBusinessMessage(sRvalue));
		}
	}
	
	/*~[Describe=���պ�����;InputParam=��;OutPutParam=��;]~*/
	function my_DunManage()
	{
		sSerialNo   = getItemValue(0,getRow(),"SerialNo");	
		sCurrency  = getItemValue(0,getRow(),"BusinessCurrency");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else
		{
			OpenPage("/RecoveryManage/DunManage/DunList.jsp?ObjectType=BusinessContract"+"&Currency="+sCurrency+"&ObjectNo="+sSerialNo+"&flag=page","_self");
		}
	}
	
	/*~[Describe=�����ʲ����ʽ����;InputParam=��;OutPutParam=��;]~*/
	function my_ReturnWay()
	{
		sSerialNo   = getItemValue(0,getRow(),"SerialNo");	
		if (typeof(sSerialNo) == "undefined" || sSerialNo.length == 0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}else
		{
			OpenComp("NPAReturnWayMain","/RecoveryManage/NPAManage/NPADailyManage/NPAReturnWayView.jsp","ComponentName=�����ʲ����ʽ&ComponentType=MainWindow&DefaultTVItemName=�����ǹ���&SerialNo="+sSerialNo,"_blank",OpenStyle)
		}
	}
	
	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">
	//��̨ͬ����Ϣ
	function my_ManageView()
	{ 
		//��ͬ��ˮ�š���ͬ��š��ͻ�����,����
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		var sItemMenuNo = "<%=sContractType%>";
		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));  //��ѡ��һ����Ϣ��
		}else
		{
			sObjectType = "NPABook";
			sObjectNo = sSerialNo;
			
			if(sItemMenuNo=="010050") 
				sViewID = "001";
			else
				sViewID = "002";

			openObject(sObjectType,sObjectNo,sViewID);
		}
	}
	
	
	/*~[Describe=�ƽ���ȫ����;InputParam=��;OutPutParam=��;]~*/
	function ShiftRMDepart()
	{
		//��ú�ͬ��ˮ��
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)	
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else
		{       
			sReturnValue = RunMethod("BusinessManage","CheckContractShift",sSerialNo);
			if(parseInt(sReturnValue) == 0) 
			{
				var sTraceInfo = PopPage("/RecoveryManage/Public/NPAShiftDialog.jsp","","dialogWidth=25;dialogHeight=8;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no");
				if(typeof(sTraceInfo)!="undefined" && sTraceInfo.length!=0)
				{
					var sTraceInfo = sTraceInfo.split("@");				
					//����ƽ����͡���ȫ����
					var sShiftType = sTraceInfo[0];
					var sTraceOrgID = sTraceInfo[1];
					var sTraceOrgName = sTraceInfo[2];
					if(typeof(sTraceOrgID)!="undefined" && sTraceOrgID.length!=0)
					{
						var sReturn = PopPageAjax("/RecoveryManage/Public/NPAShiftActionAjax.jsp?SerialNo="+sSerialNo+"&ShiftType="+sShiftType+"&TraceOrgID="+sTraceOrgID+"&Type=1","","");
						if(sReturn == "true") //ˢ��ҳ��
						{
							alert("�ò����ʲ��ɹ��ƽ�����"+sTraceOrgName+"��"); 
							self.location.reload();
						}
					}
				}
			}else
			{
				alert(getBusinessMessage("495")); //��ҵ���Ѿ��ƽ�����ȫ���������ٴ��ƽ���
				return;
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
	init_show();
	my_load_show(2,0,'myiframe0');
</script>
<%/*~END~*/%>

<%@	include file="/IncludeEnd.jsp"%>