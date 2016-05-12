<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author: zywei 2005-11-27
		Tester:
		Describe: ������Ϣ�б�;
		Input Param:
			GuarantyStatus: ����״̬
		Output Param:
			
		HistoryLog:
			sxjiang 2010/07/14  ���ӳ���ƾ֤����ʱ����ƾ֤
	 */
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "������Ϣ�б�"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>



<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
	String sTempletNo = "";

	//���ҳ�����������״̬
	String sGuarantyStatus = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("GuarantyStatus"));
	if(sGuarantyStatus == null) sGuarantyStatus = "";
	
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%
	//ͨ����ʾģ�����ASDataObject����doTemp
	sTempletNo = "ImpawnList";
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	doTemp.WhereClause += " and GuarantyType like '020%' and GuarantyStatus = '"+sGuarantyStatus+"' " +
						  " and InputOrgID in (select OrgID from ORG_INFO where SortNo like '"+CurOrg.getSortNo()+"%')";
	//					 +" and exists (select 1 from Guaranty_Relative where ObjectType='BusinessContract' and GuarantyID=Guaranty_Info.GuarantyID)";
	//���ӹ�����	
/* 	doTemp.setColumnAttribute("GuarantyID,GuarantyType,OwnerName","IsFilter","1"); */
    doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.setPageSize(30);
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	//out.print(doTemp.SourceSql);//����datawindow��Sql���

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
		{(sGuarantyStatus.equals("01")?"true":"false"),"","Button","����","����������Ϣ","newRecord()",sResourcesPath},
		{(sGuarantyStatus.equals("01")?"true":"false"),"","Button","ɾ��","ɾ��������Ϣ","deleteRecord()",sResourcesPath},
		{"true","","Button","����","�鿴��Ѻ����Ϣ����","viewAndEdit()",sResourcesPath},
		{(sGuarantyStatus.equals("01")?"true":"false"),"","Button","��ӡ���ƾ֤","��ӡ�������ƾ֤","printLoadGuaranty()",sResourcesPath},
		{(sGuarantyStatus.equals("01")&&(CurUser.hasRole("057")||CurUser.hasRole("257")||CurUser.hasRole("457"))?"true":"false"),"","Button","���","�������","loadGuaranty()",sResourcesPath},
		{(sGuarantyStatus.equals("02")?"true":"false"),"","Button","��ֵ���","�����ֵ���","valueChange()",sResourcesPath},
		{(sGuarantyStatus.equals("02")?"true":"false"),"","Button","��Ϣ���","����������Ϣ���","otherChange()",sResourcesPath},
		{(sGuarantyStatus.equals("02")?"true":"false"),"","Button","��ʱ����","������ʱ����","unloadGuaranty1()",sResourcesPath},
		{(sGuarantyStatus.equals("02")?"true":"false"),"","Button","����","�������","unloadGuaranty2()",sResourcesPath},
		{(sGuarantyStatus.equals("02")?"true":"false"),"","Button","��ӡ����ƾ֤","��ӡ�������ƾ֤","printLoadGuaranty1()",sResourcesPath},
		{(sGuarantyStatus.equals("02")?"true":"false"),"","Button","��ӡ��ʱ����ƾ֤","��ӡ��ʱ�������ƾ֤","printLoadGuaranty2()",sResourcesPath},
		{(sGuarantyStatus.equals("03")?"true":"false"),"","Button","�ٻؿ�","�����ٻؿ�","reloadGuaranty()",sResourcesPath},
		{(!sGuarantyStatus.equals("01")?"true":"false"),"","Button","�������ʷ��¼","�鿴�������ʷ��¼","viewGuarantyAudit()",sResourcesPath},
		{(!sGuarantyStatus.equals("01")?"true":"false"),"","Button","������ͬ��Ϣ","�鿴������ͬ��Ϣ","viewGuarantyContract()",sResourcesPath},
		{(!sGuarantyStatus.equals("01")?"true":"false"),"","Button","ҵ���ͬ��Ϣ","�鿴ҵ���ͬ��Ϣ","viewBusinessContract()",sResourcesPath}
	};
		
	%>
<%/*~END~*/%>




<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">

	/*~[Describe=������¼;InputParam=��;OutPutParam=��;]~*/
	function newRecord()
	{
		//��ȡ��������
		sReturn = setObjectValue("SelectImpawnType","","",0,0,"");
		//�ж��Ƿ񷵻���Ч��Ϣ
		if(sReturn == "" || sReturn == "_CANCEL_" || sReturn == "_NONE_" || sReturn == "_CLEAR_" || typeof(sReturn) == "undefined") return;
		sReturn = sReturn.split('@');
		sImpawnType = sReturn[0];	
		OpenPage("/CreditManage/GuarantyManage/ImpawnInfo.jsp?GuarantyStatus=<%=sGuarantyStatus%>&ImpawnType="+sImpawnType,"_self");
	}
	
	/*~[Describe=ɾ����¼;InputParam=��;OutPutParam=��;]~*/
	function deleteRecord()
	{
		sGuarantyID = getItemValue(0,getRow(),"GuarantyID");		
		if(typeof(sGuarantyID)=="undefined" || sGuarantyID.length==0) 
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else if(confirm(getHtmlMessage('2')))//�������ɾ������Ϣ��
		{			
			sReturn=RunMethod("BusinessManage","CheckGuarantyRelative",sGuarantyID);
			if(sReturn > 0) 
			{
				alert(getBusinessMessage('857'));//��������ǩ������ͬ������ɾ����
				return;
			}else
			{
				as_del('myiframe0');
				as_save("myiframe0");  //�������ɾ������Ҫ���ô����	
			}		
		}		
	}
	
	/*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=��;]~*/
	function viewAndEdit()
	{
		sGuarantyID = getItemValue(0,getRow(),"GuarantyID");
		sImpawnType = getItemValue(0,getRow(),"GuarantyType");
		if(typeof(sGuarantyID)=="undefined" || sGuarantyID.length==0) 
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else 
		{
			OpenPage("/CreditManage/GuarantyManage/ImpawnInfo.jsp?GuarantyStatus=<%=sGuarantyStatus%>&GuarantyID="+sGuarantyID+"&ImpawnType="+sImpawnType,"_self");
		}
	}
	
	/*~[Describe=�������;InputParam=��;OutPutParam=��;]~*/
	function loadGuaranty()
	{
		sGuarantyID = getItemValue(0,getRow(),"GuarantyID");
		if(typeof(sGuarantyID)=="undefined" || sGuarantyID.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else if(confirm("ȷ���������������")) 
		{
			sReturn=RunMethod("BusinessManage","InsertGuarantyAudit",sGuarantyID+",02,"+"<%=CurUser.getUserID()%>");
			if(typeof(sReturn) != "undefined" && sReturn != "") 
			{
				alert(getBusinessMessage('859'));//�������ɹ���
				reloadSelf();
			}else
			{
				alert(getBusinessMessage('860'));//�������ʧ�ܣ������²�����
				return;
			}
		}
	}
	
	/*~[Describe=��ӡ�������ƾ֤;InputParam=��;OutPutParam=��;]~*/
	function printLoadGuaranty()
	{
		sGuarantyID = getItemValue(0,getRow(),"GuarantyID");
		if(typeof(sGuarantyID)=="undefined" || sGuarantyID.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else
		{
			PopComp("LoadImpawnSheet","/CreditManage/GuarantyManage/LoadImpawnSheet.jsp","GuarantyID="+sGuarantyID,"dialogWidth:800px;dialogHeight:600px;resizable:yes;scrollbars:no");
		}
	}	

	/*~[Describe=��ӡ�������ƾ֤;InputParam=��;OutPutParam=��;]~*/
	function printLoadGuaranty1()
	{
		sGuarantyID = getItemValue(0,getRow(),"GuarantyID");
		if(typeof(sGuarantyID)=="undefined" || sGuarantyID.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else
		{
			PopComp("EmergeImpawnSheet","/CreditManage/GuarantyManage/EmergeImpawnSheet.jsp","GuarantyID="+sGuarantyID,"dialogWidth:800px;dialogHeight:600px;resizable:yes;scrollbars:no");
		}
	}	

	/*~[Describe=��ӡ������ʱ����ƾ֤;InputParam=��;OutPutParam=��;]~*/
	function printLoadGuaranty2()
	{
		sGuarantyID = getItemValue(0,getRow(),"GuarantyID");
		if(typeof(sGuarantyID)=="undefined" || sGuarantyID.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else
		{
			PopComp("EmergeImpawnSheetTemp","/CreditManage/GuarantyManage/EmergeImpawnSheetTemp.jsp","GuarantyID="+sGuarantyID,"dialogWidth:800px;dialogHeight:600px;resizable:yes;scrollbars:no");
		}
	}	
	
	/*~[Describe=�����ֵ���;InputParam=��;OutPutParam=��;]~*/
	function valueChange()
	{
		sGuarantyID = getItemValue(0,getRow(),"GuarantyID");
		if(typeof(sGuarantyID)=="undefined" || sGuarantyID.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else 
		{
			popComp("ChangeImpawnList","/CreditManage/GuarantyManage/ChangeImpawnList.jsp","ChangeType=010&GuarantyID="+sGuarantyID);
			reloadSelf();
		}
	}

	/*~[Describe=����������Ϣ���;InputParam=��;OutPutParam=��;]~*/
	function otherChange()
	{
		sGuarantyID = getItemValue(0,getRow(),"GuarantyID");
		if(typeof(sGuarantyID)=="undefined" || sGuarantyID.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else 
		{
			popComp("ChangeImpawnList","/CreditManage/GuarantyManage/ChangeImpawnList.jsp","ChangeType=020&GuarantyID="+sGuarantyID);
			reloadSelf();
		}
	}
	
	/*~[Describe=������ʱ����;InputParam=��;OutPutParam=��;]~*/
	function unloadGuaranty1()
	{
		sGuarantyID = getItemValue(0,getRow(),"GuarantyID");
		if(typeof(sGuarantyID)=="undefined" || sGuarantyID.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else
		{			
			popComp("AddGuarantyAudit","/CreditManage/GuarantyManage/GuarantyAuditInfo.jsp","GuarantyID="+sGuarantyID+"&GuarantyStatus=03");
			reloadSelf();	
		}
	}
		
	/*~[Describe=�������;InputParam=��;OutPutParam=��;]~*/
	function unloadGuaranty2()
	{
		sGuarantyID = getItemValue(0,getRow(),"GuarantyID");
		if(typeof(sGuarantyID)=="undefined" || sGuarantyID.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else if(confirm("�Ƿ�ȷ�����⣿"))
		{			
			sReturn=RunMethod("BusinessManage","InsertGuarantyAudit",sGuarantyID+",04,"+"<%=CurUser.getUserID()%>");
			if(typeof(sReturn) != "undefined" && sReturn != "") 
			{
				alert(getBusinessMessage('861'));//�������ɹ���
				reloadSelf();
			}else
			{
				alert(getBusinessMessage('862'));//�������ʧ�ܣ������²�����
				return;
			}			
		}
	}
	
	/*~[Describe=�����ٻؿ�;InputParam=��;OutPutParam=��;]~*/
	function reloadGuaranty()
	{
		sGuarantyID = getItemValue(0,getRow(),"GuarantyID");
		if(typeof(sGuarantyID)=="undefined" || sGuarantyID.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else if(confirm(getBusinessMessage('863'))) //������뽫�������ٻؿ���
		{
			sReturn = PopPage("/FixStat/SelectDate.jsp","_blank","resizable=yes;dialogWidth=20;dialogHeight=16;center:yes;status:no;statusbar:no");
			if(typeof(sReturn) != "undefined" && sReturn != "_CANCEL_" && sReturn != "_NONE_" )
			{
				sSerialNo = RunMethod("BusinessManage","GetGuarantyAuditSerialNo",sGuarantyID);
				sLostDate = RunMethod("PublicMethod","GetColValue","LostDate,GUARANTY_AUDIT,String@SerialNo@"+sSerialNo);
				arr = sLostDate.split("@");
				if(sReturn < arr[1]){
					alert("ʵ�ʻؿ�ʱ�䲻��С����ʱ����ʱ��");
					return false;
				}
				RunMethod("BusinessManage","UpdateGuarantyStatusWithDate",sSerialNo+","+sReturn);
				sReturn = RunMethod("BusinessManage","UpdateGuarantyStatus",sGuarantyID+",02");
				if(typeof(sReturn) != "undefined" && sReturn != "")
				{
					alert("�������ѳɹ��ؿ�!");
				}
			}		
				reloadSelf();
		}
	}
	
	/*~[Describe=�鿴���/������־��Ϣ;InputParam=��;OutPutParam=��;]~*/
	function viewGuarantyAudit()
	{
		sGuarantyID = getItemValue(0,getRow(),"GuarantyID");
		if(typeof(sGuarantyID)=="undefined" || sGuarantyID.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else
		{
			popComp("logGuarantyAudit","/CreditManage/GuarantyManage/GuarantyAuditList.jsp","GuarantyID="+sGuarantyID+"&GuarantyStatus=00");
		}
	}
	
	/*~[Describe=�鿴������ͬ��Ϣ;InputParam=��;OutPutParam=��;]~*/
	function viewGuarantyContract()
	{
		sGuarantyID = getItemValue(0,getRow(),"GuarantyID");
		if(typeof(sGuarantyID)=="undefined" || sGuarantyID.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else 
		{
			popComp("GuarantyContractList","/CreditManage/GuarantyManage/GuarantyContractList.jsp","GuarantyID="+sGuarantyID);
		}
	}
	
	/*~[Describe=�鿴ҵ���ͬ��Ϣ;InputParam=��;OutPutParam=��;]~*/
	function viewBusinessContract()
	{
		sGuarantyID = getItemValue(0,getRow(),"GuarantyID");
		if(typeof(sGuarantyID)=="undefined" || sGuarantyID.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else 
		{
			popComp("BusinessContractList","/CreditManage/GuarantyManage/BusinessContractList.jsp","GuarantyID="+sGuarantyID);
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
	var bHighlightFirst = true;//�Զ�ѡ�е�һ����¼
	my_load(2,0,'myiframe0');
</script>
<%/*~END~*/%>

<%@	include file="/IncludeEnd.jsp"%>