<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author:    hxli 2005-8-3
		Tester:
		Content: ���ϰ����б�
		Input Param:
			   CasePhase������״̬     
		Output param:
				 
		History Log: zywei 2005/09/06 �ؼ����
		                  
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "���ϰ����б�"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%
	//�������
	String sContext = CurOrg.getOrgID() + "," + CurUser.getUserID();
	String sWhereClause = ""; //Where����
	
	//����������	������״̬	
	String sCasePhase =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ItemID"));
	if(sCasePhase == null) sCasePhase = "";	
%>
<%/*~END~*/%>


<%
	//ͨ��DWģ�Ͳ���ASDataObject����doTemp
	String sTempletNo = "LawCaseManageList";//ģ�ͱ��
	
	//���ս᰸��֮����������а����б���������սᣬ��ô���б����޷���ʾ�ս��־��������ᣬ
	//��Ϊ��ͨ�����ս��������ж��Ƿ��ս�ģ��䰸���׶���Ȼ���ս�ǰ�Ľ׶Ρ������׶��в�û���ս�׶ε�˵��
	if(sCasePhase.equals("010") || sCasePhase.equals("020") || sCasePhase.equals("025") || sCasePhase.equals("030")){	//��ǰ�����б�
		sTempletNo = "LawCaseManageDetailList";
		sContext += "," + sCasePhase;
	}
	if(sCasePhase.equals("040")){	//�ս�鵵�����б�
		sTempletNo = "LawCaseManageFileList";
	}			

	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.setPageSize(20);  //��������ҳ
    
    //ɾ��������ɾ��������Ϣ
    dwTemp.setEvent("AfterDelete","!WorkFlowEngine.DeleteTask(LawcaseInfo,#SerialNo,DeleteBusiness)");
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sContext);
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
	
		//���Ϊ��ǰ���������б���ʾ���°�ť
		String sButtons[][] = {
					{"true","","Button","����","����һ����¼","newRecord()",sResourcesPath},
					{"true","","Button","��������","�鿴/�޸İ�������","viewAndEdit()",sResourcesPath},
					{"true","","Button","ת���½׶�","ת���½׶�","my_NextPhase()",sResourcesPath},
					{"true","","Button","�鵵","ת�������ս᰸��","my_Pigeonhole()",sResourcesPath},
					{"true","","Button","ȡ���鵵","ȡ��ת�������ս᰸��","my_CancelPigeonhole()",sResourcesPath},
					{"true","","Button","ȡ��","ɾ����ѡ�еļ�¼","deleteRecord()",sResourcesPath},
				};
				
		//���Ϊ�����ճ�ת�룬��ô��
		if(sCasePhase.equals("000"))			
		{
			sButtons[4][0]="false";			
		}

		//���Ϊ��ǰ���������Ӧ�б���ʾȡ���鵵�Ȱ�ť
		if(sCasePhase.equals("010"))			
		{
			sButtons[4][0]="false";			
		}
		
		//���Ϊ�����а��������Ӧ�б���ʾ������ɾ���Ȱ�ť
		if(sCasePhase.equals("020"))			
		{
			sButtons[0][0]="false";
			sButtons[4][0]="false";
			sButtons[5][0]="false";			
		}
		
		//���Ϊ��ִ�а�����ִ���а��������Ӧ�б���ʾ������ɾ���Ȱ�ť
		if(sCasePhase.equals("025"))			
		{
			sButtons[0][0]="false";
			sButtons[4][0]="false";
			sButtons[5][0]="false";			
		}
		
		//���Ϊִ���а��������Ӧ�б���ʾ������ɾ���Ȱ�ť
		if(sCasePhase.equals("030") )			
		{
			sButtons[0][0]="false";
			sButtons[4][0]="false";
			sButtons[5][0]="false";			
		}
		
		//���Ϊ���ս᰸�������Ӧ�б���ʾ������ɾ�����鵵�Ȱ�ť
		if(sCasePhase.equals("040"))			
		{
			sButtons[0][0]="false";
			sButtons[2][0]="false";
			sButtons[3][0]="false";			
			sButtons[5][0]="false";
		}
	
	
%> 
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">

	//---------------------���尴ť�¼�------------------------------------
	/*~[Describe=������¼;InputParam=��;OutPutParam=SerialNo;]~*/
	function newRecord()
	{				
		//���ѡ��İ�������
		var sLawCaseType = PopPage("/RecoveryManage/LawCaseManage/LawCaseDailyManage/LawCaseTypeDialog.jsp","","resizable=yes;dialogWidth=21;dialogHeight=15;center:yes;status:no;statusbar:no");
		if(typeof(sLawCaseType) != "undefined" && sLawCaseType.length != 0 && sLawCaseType != '')
		{	
			//��ȡ��ˮ��
			var sTableName = "LAWCASE_INFO";//����
			var sColumnName = "SerialNo";//�ֶ���
			var sPrefix = "";//ǰ׺
			var sSerialNo = getSerialNo(sTableName,sColumnName,sPrefix);		
			var sReturn=PopPageAjax("/RecoveryManage/LawCaseManage/LawCaseDailyManage/AddLawCaseActionAjax.jsp?SerialNo="+sSerialNo+"&LawCaseType="+sLawCaseType+"","","resizable=yes;dialogWidth=25;dialogHeight=15;center:yes;status:no;statusbar:no");
			if(typeof(sReturn)!="undefined" && sReturn=="true"){
				self.close();
				sObjectType = "LawCase";
				sObjectNo = sSerialNo;
				sViewID = "001";
				openObject(sObjectType,sObjectNo,sViewID);			
				reloadSelf();
			}
		} 		
	}
	
	/*~[Describe=ɾ����¼;InputParam=��;OutPutParam=��;]~*/
	function deleteRecord()
	{
		sSerialNo=getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
		}
		
		if(confirm(getHtmlMessage(2))) //�������ɾ������Ϣ��
		{
			as_del("myiframe0");
			as_save("myiframe0");  //�������ɾ������Ҫ���ô����
		}
	}

	
	/*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=SerialNo;]~*/
	function viewAndEdit()
	{
		//��ð�����ˮ��
		var sSerialNo=getItemValue(0,getRow(),"SerialNo");	
		var sCasePhase = "<%=sCasePhase%>";
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
		}else
		{
			sObjectType = "LawCase";
			sObjectNo = sSerialNo;			
			if(sCasePhase=="040")
				sViewID = "002"
			else
				sViewID = "001"
			
			openObject(sObjectType,sObjectNo,sViewID);	
			reloadSelf();		
		}
	}
	
	
	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">

	/*~[Describe=ת���½׶�;InputParam=��;OutPutParam=SerialNo;]~*/
	function my_NextPhase()
	{		
		//��ð�����ˮ��
		var sSerialNo=getItemValue(0,getRow(),"SerialNo");		
		if (typeof(sSerialNo) == "undefined" || sSerialNo.length == 0)
		{
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
		}else
		{
			//���ѡ��׶�
			var sLawCasePhase = PopPage("/RecoveryManage/LawCaseManage/LawCaseDailyManage/LawCasePhaseDialog.jsp","","resizable=yes;dialogWidth=21;dialogHeight=15;center:yes;status:no;statusbar:no");
			if(typeof(sLawCasePhase) != "undefined" && sLawCasePhase.length != 0 && sLawCasePhase != '')
			{			
				if(sLawCasePhase == '<%=sCasePhase%>')
				{
					alert(getBusinessMessage("779"));  //ת��׶��뵱ǰ�׶���ͬ��
					return;
				}else if(confirm(getBusinessMessage("777"))) //������뽫�ð���ת���½׶���
				{
					sReturnValue = RunMethod("PublicMethod","UpdateColValue","String@CasePhase@"+sLawCasePhase+",LAWCASE_INFO,String@SerialNo@"+sSerialNo);
					if(sReturnValue == "TRUE")
					{
						alert(getBusinessMessage("772"));//ת���½׶γɹ���
						reloadSelf();
					}else
					{
						alert(getBusinessMessage("773")); //ת���½׶�ʧ�ܣ�
						return;
					}						
				}
			}
        }    
	}
			
	/*~[Describe=�鵵;InputParam=��;OutPutParam=SerialNo;]~*/
	function my_Pigeonhole()
	{		
		//��ð�����ˮ��
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");		
		if (typeof(sSerialNo) == "undefined" || sSerialNo.length == 0)
		{
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
		}else
		{
			if(confirm(getHtmlMessage('56'))) //������뽫����Ϣ�鵵��
			{				
				sPigeonholeDate = "<%=StringFunction.getToday()%>";
				sReturnValue = RunMethod("PublicMethod","UpdateColValue","String@PigeonholeDate@"+sPigeonholeDate+",LAWCASE_INFO,String@SerialNo@"+sSerialNo);
				if(sReturnValue == "TRUE")
				{
					alert(getHtmlMessage('57'));//�鵵�ɹ���
					reloadSelf();
				}else
				{
					alert(getHtmlMessage('60'));//�鵵ʧ�ܣ�
					return;
				}
			}
        }    
	}
	
	/*~[Describe=ȡ���鵵;InputParam=��;OutPutParam=SerialNo;]~*/
	function my_CancelPigeonhole()
	{		
		//��ð�����ˮ��
		var sSerialNo=getItemValue(0,getRow(),"SerialNo");		
		if (typeof(sSerialNo) == "undefined" || sSerialNo.length == 0)
		{
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
		}else
		{
			if(confirm(getHtmlMessage('58'))) //������뽫����Ϣ�鵵ȡ����
			{
				sReturnValue = RunMethod("PublicMethod","UpdateColValue","String@PigeonholeDate@None,LAWCASE_INFO,String@SerialNo@"+sSerialNo);
				if(sReturnValue == "TRUE")
				{
					alert(getHtmlMessage('59'));//ȡ���鵵�ɹ���
					reloadSelf();
				}else
				{
					alert(getHtmlMessage('61'));//ȡ���鵵ʧ�ܣ�
					return;
				}				
        	}
        }    
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

<%@ include file="/IncludeEnd.jsp"%>
