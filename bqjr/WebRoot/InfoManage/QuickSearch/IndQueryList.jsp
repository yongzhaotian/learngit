<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   FBkang 2005-08-01
		Tester:
		Content: ���˿ͻ����ٲ�ѯ
		Input Param:
		Output param:
		History Log: 
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "���˿ͻ����ٲ�ѯ"; // ��������ڱ��� <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;���˿ͻ����ٲ�ѯ&nbsp;&nbsp;";
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%
	//�������
	String sSql = "";//--���sql���
	//����������	
	
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%	
	//�����ͷ�ļ�
	String sHeaders[][] = { 							
										{"CustomerID","�ͻ����"},
										{"CustomerName","�ͻ�����"},
										{"CustomerType","�ͻ�����"},
										{"CustomerType1","�ͻ�����"},
										{"CertTypeName","֤������"},
										{"CertTypeCode","֤������"},
										{"CertID","֤������"},
										{"SexName","�Ա�"},
										{"Birthday","��������"},
										{"EduExperienceName","���ѧ��"},
										{"EduDegreeName","���ѧλ"},										
										{"NationalityName","����"},
										{"PoliticalFaceName","������ò"},
										{"MarriageName","����״��"},
										{"FamilyTel","סլ�绰"},
										{"FamilyStatusName","��ס״��"},
										{"MobileTelephone","�ֻ�����"},
										{"EmailAdd","��������"},
										{"OccupationName","ְҵ"},
										{"HeadShipName","ְ��"},
										{"PositionName","ְ��"},
										{"UnitKindName","��λ������ҵ"},
										{"WorkCorp","��λ����"},
										{"WorkZip","��λ��ַ�ʱ�"},
										{"WorkTel","��λ�绰"},
										{"UserName","�Ǽ���"},
										{"OrgName","�Ǽǻ���"},
										{"InputDate","�Ǽ�����"},
										{"UpdateDate","��������"},
										{"CityName","����"},
										{"SalesexecutiveName","���۴���"},
										{"Salesexecutive","���۴���ID"},
										{"SaleManagerName","���۾���"},
										{"SalesManager","���۾���ID"}
						   }; 
	
	sSql = 	" select IND_INFO.CustomerID as CustomerID,IND_INFO.CustomerName as CustomerName,getItemName('CustomerType',IND_INFO.CustomerType) as CustomerType, IND_INFO.CustomerType as CustomerType1,getItemName('CertType',IND_INFO.CertType) as CertTypeName, IND_INFO.CertType as CertTypeCode, "+
			" IND_INFO.CertID as CertID,getItemName('Sex',IND_INFO.Sex) as SexName,IND_INFO.Birthday as Birthday, "+
			" getItemName('EducationExperience',IND_INFO.EduExperience) as EduExperienceName, "+
			" getItemName('EducationDegree',IND_INFO.EduDegree) as EduDegreeName, "+
			" getItemName('Nationality',IND_INFO.Nationality) as NationalityName, "+
			" getItemName('PoliticalFace',IND_INFO.PoliticalFace) as PoliticalFaceName, "+
			" getItemName('Marriage',IND_INFO.Marriage) as MarriageName, "+
			" IND_INFO.FamilyTel as FamilyTel,getItemName('FamilyStatus',IND_INFO.FamilyStatus) as FamilyStatusName, "+
			" IND_INFO.MobileTelephone as MobileTelephone,IND_INFO.EmailAdd as EmailAdd, "+
			" getItemName('Occupation',IND_INFO.Occupation) as OccupationName, "+
			" getItemName('HeadShip',IND_INFO.HeadShip) as HeadShipName, "+
			" getItemName('TechPost',IND_INFO.Position) as PositionName, "+
			" getItemName('IndustryType',IND_INFO.UnitKind) as UnitKindName, "+
			" IND_INFO.WorkCorp as WorkCorp,IND_INFO.WorkZip as WorkZip,IND_INFO.WorkTel as WorkTel, "+
			" getUserName(IND_INFO.InputUserID) as UserName,getOrgName(IND_INFO.InputOrgID) as OrgName, "+
			" IND_INFO.InputDate as InputDate,IND_INFO.UpdateDate as UpdateDate, "+
			" getItemName('AreaCode',BUSINESS_CONTRACT.City) as CityName,"+
			" getUserName(BUSINESS_CONTRACT.Salesexecutive) as SalesexecutiveName,"+
			" BUSINESS_CONTRACT.Salesexecutive as Salesexecutive,"+
			" getuserName(STORE_INFO.SalesManager)   as SaleManagerName , STORE_INFO.SalesManager as SalesManager "+
			" from IND_INFO,BUSINESS_CONTRACT,STORE_INFO  "+
//			" where CustomerID in "+
//			"		(select CustomerID from CUSTOMER_BELONG "+
//			" 		where OrgID in (select OrgID from ORG_INFO where SortNo like '"+CurOrg.getSortNo()+"%')) "+
//			" and exists"+
            " where  IND_INFO.Customerid=BUSINESS_CONTRACT.Customerid"+
            " and BUSINESS_CONTRACT.Stores=STORE_INFO.Sno"
					;
	
	//����sSql�������ݶ���
	ASDataObject doTemp = new ASDataObject(sSql);
	//���ñ�ͷ
	doTemp.setHeader(sHeaders);
	//���ùؼ���
	//doTemp.setKeyFilter("CustomerID");
	doTemp.setKey("CustomerID",true);	
	//������ʾ�ı���ĳ��ȼ��¼�����
	doTemp.setHTMLStyle("CustomerName","style={width:250px} ");  
	doTemp.setAlign("FamilyMonthIncome,YearIncome","3");
	doTemp.setVisible("YearIncome,SalesManager,CertTypeCode,CustomerType1",false);
	//����֤����������
	doTemp.setDDDWSql("CertTypeCode", "select itemno,itemname from code_library where codeno='CertType' and IsInUse = '1' ");
	doTemp.setDDDWSql("CustomerType1", "select itemno,itemname from code_library where codeno='CustomerType' and IsInUse = '1'");
	//�����ֶ�
	//doTemp.setVisible("CustomerType",false);
	
	//���ɲ�ѯ��
	//doTemp.generateFilters(Sqlca);
	doTemp.setFilter(Sqlca,"1","CustomerName","Operators=EqualsString,BeginsWith;");
	doTemp.setFilter(Sqlca,"2","CustomerID","Operators=EqualsString,BeginsWith;");
	//doTemp.setFilter(Sqlca,"3","CustomerType1","Operators=EqualsString;");
	doTemp.setFilter(Sqlca,"4","CertTypeCode","Operators=EqualsString;");	
	doTemp.setFilter(Sqlca,"5","CertID","Operators=EqualsString,BeginsWith;");
	doTemp.setFilter(Sqlca,"6","MobileTelephone","Operators=EqualsString,BeginsWith;");
	//doTemp.setFilter(Sqlca,"7","CityName","Operators=EqualsString,BeginsWith;");
	//doTemp.setFilter(Sqlca,"8","Salesexecutive","Operators=EqualsString;");
	//doTemp.setFilter(Sqlca,"9","SalesManager","Operators=EqualsString;");
	doTemp.parseFilterData(request,iPostChange);
	//�жϷ��ϸ������Ƿ����ݱȽ϶࣬Ӱ���ѯ����
	boolean flag = true;
	for(int k=0;k<doTemp.Filters.size();k++){
		if(doTemp.Filters.get(k).sFilterInputs[0][1] != null && (("1").equals(doTemp.getFilter(k).sFilterID)||("2").equals(doTemp.getFilter(k).sFilterID)||("5").equals(doTemp.getFilter(k).sFilterID)||("6").equals(doTemp.getFilter(k).sFilterID)) ){
			flag = false;
			break;
		}
	}
	if(doTemp.haveReceivedFilterCriteria()&& flag)
	{
		%>
		<script type="text/javascript">
			alert("�ͻ�����,�ͻ����,֤������,�ֻ�������������һ�");
		</script>
		<%
		doTemp.WhereClause+=" and 1=2";
	}
	for(int k=0;k<doTemp.Filters.size();k++){
		
		//��������������ܺ���%����
		if(doTemp.Filters.get(k).sFilterInputs[0][1] != null && doTemp.Filters.get(k).sFilterInputs[0][1].contains("%")){
			%>
			<script type="text/javascript">
				alert("������������ܺ���\"%\"����!");
			</script>
			<%
			doTemp.WhereClause+=" and 1=2";
			break;
		}
	
		if(doTemp.Filters.get(k).sFilterInputs[0][1] != null  && "BeginsWith".equals(doTemp.Filters.get(k).sOperator)){
			if(("1").equals(doTemp.getFilter(k).sFilterID) && doTemp.Filters.get(k).sFilterInputs[0][1].trim().length() < 2){
				%>
				<script type="text/javascript">
					alert("������ַ����ȱ���Ҫ���ڵ���2λ!");
				</script>
				<%
				doTemp.WhereClause+=" and 1=2";
				break;
			} else if((("2").equals(doTemp.getFilter(k).sFilterID) || ("5").equals(doTemp.getFilter(k).sFilterID)|| ("6").equals(doTemp.getFilter(k).sFilterID)) && doTemp.Filters.get(k).sFilterInputs[0][1].trim().length() < 8){
				%>
				<script type="text/javascript">
					alert("������ַ����ȱ���Ҫ���ڵ���8λ!");
				</script>
				<%
				doTemp.WhereClause+=" and 1=2";
				break;
			}
			
		} else if(k==doTemp.Filters.size()-1){
		
			if(!doTemp.haveReceivedFilterCriteria()) doTemp.WhereClause+=" and 1=2";
		
		}
	}
	
//	if(!doTemp.haveReceivedFilterCriteria()) doTemp.WhereClause+=" and 1=2";
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));	

	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.setPageSize(16);  //��������ҳ

	//����HTMLDataWindow
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
	String sButtons[][] = {
		{"true","","Button","�ͻ�����","�ͻ���ϸ��Ϣ","viewAndEdit()",sResourcesPath},
		{"true","","Button","��ϵ��ʽ�޸�","��ϵ��ʽ�޸�","getUpdateCustomer()",sResourcesPath},
		{"true","","Button","�绰�ֿ�","�绰�ֿ�","getPhoneCode()",sResourcesPath},
		{"true","","Button","�����¼��ѯ","�����¼��ѯ","withholdRecordQuery()",sResourcesPath},
	};
	%> 
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">
	//---------------------���尴ť�¼�------------------------------//

	/*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=SerialNo;]~*/
	function viewAndEdit()
	{
		//��ø��˿ͻ�����
		sCustomerID=getItemValue(0,getRow(),"CustomerID");	
		
	
		if (typeof(sCustomerID)=="undefined" || sCustomerID.length==0)
		{
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
		}else
		{
			openObject("Customer",sCustomerID,"002");//�򿪸��˿ͻ���ϸ��Ϣ
		}
	}
	
	/*~[Describe=��ϵ��ʽ�޸�;InputParam=��;OutPutParam=SerialNo;]~*/
	function getUpdateCustomer(){
		//��ȡ�ͻ����
		sCustomerID=getItemValue(0,getRow(),"CustomerID");
		
		if (typeof(sCustomerID)=="undefined" || sCustomerID.length==0)
		{
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
		}

		sCompID = "UpdateCustomerInfo";
		sCompURL = "/InfoManage/QuickSearch/UpdateCustomerInfo.jsp";
		sParamString = "CustomerID="+sCustomerID;
		sReturn = popComp(sCompID,sCompURL,sParamString,"dialogWidth=700px;dialogHeight=560px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		reloadSelf();
	}
	
	 /*~[Describe=�绰¼��;InputParam=��;OutPutParam=��;]~*/
	function getPhoneCode()
	{
		var sCustomerID=getItemValue(0,getRow(),"CustomerID");
		if (typeof(sCustomerID)=="undefined" || sCustomerID.length==0)
		{
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
		}
		sCompID = "AddPhoneList";
		sCompURL = "/CustomerManage/AddPhoneList.jsp";	
		sReturn = popComp(sCompID,sCompURL,"CustomerID="+sCustomerID,"dialogWidth=550px;dialogHeight=450px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		
//		if(typeof(sReturn)=="undefined" || sReturn=="" || sReturn=="_CANCEL_") return;
		
		//��ȡ����ֵ
	//	sReturn = sReturn.split("@");
		
	 }
	
	 /*~[Describe=�ͻ����ۼ�¼��ѯ;InputParam=��;OutPutParam=��;]~*/
	function withholdRecordQuery()
	{
		var sCustomerID=getItemValue(0,getRow(),"CustomerID");
		if (typeof(sCustomerID)=="undefined" || sCustomerID.length==0)
		{
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
		}
		sCompID = "withholdRecordQuery";
		sCompURL = "/InfoManage/QuickSearch/WithholdRecordQuery.jsp";
	 	sReturn = popComp(sCompID,sCompURL,"CustomerID="+sCustomerID,"dialogWidth=800px;dialogHeight=450px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");

	 }
 
	function testrule(){
		var sReturn = RunMethod("BusinessManage", "RuleProfaceDate", "10000440001");
		akert(sReturn);
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
