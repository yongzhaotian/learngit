<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author: jgao1 2009-10-12
		Tester:
		Content: ���徭Ӫ�����ٲ�ѯ
		Input Param:
		Output param:
		History Log: 
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "���徭Ӫ�����ٲ�ѯ"; // ��������ڱ��� <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;���徭Ӫ�����ٲ�ѯ&nbsp;&nbsp;";
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
										{"CustomerName","����"},
										{"CertTypeName","֤������"},
										{"CertID","֤������"},
										{"SexName","�Ա�"},
										{"Birthday","��������"},
										{"EduExperienceName","���ѧ��"},
										{"EduDegreeName","���ѧλ"},										
										{"SINo","��ᱣ�պ�"},
										{"StaffName","�Ƿ���Ա��"},
										{"NationalityName","����"},
										{"NativePlace","������ַ"},
										{"PoliticalFaceName","������ò"},
										{"MarriageName","����״��"},
										{"FamilyAdd","��ס��ַ"},
										{"FamilyZIP","��ס��ַ�ʱ�"},
										{"FamilyTel","סլ�绰"},
										{"FamilyStatusName","��ס״��"},
										{"MobileTelephone","�ֻ�����"},
										{"EmailAdd","��������"},
										{"CommAdd","ͨѶ��ַ"},
										{"CommZip","ͨѶ��ַ�ʱ�"},
										{"OccupationName","ְҵ"},
										{"HeadShipName","ְ��"},
										{"PositionName","ְ��"},
										{"FamilyMonthIncome","��ͥ������(Ԫ)"},
										{"YearIncome","����������(Ԫ)"},
										{"UnitKindName","��λ������ҵ"},
										{"WorkCorp","��λ����"},
										{"WorkAdd","��λ��ַ"},
										{"WorkZip","��λ��ַ�ʱ�"},
										{"WorkTel","��λ�绰"},
										{"WorkBeginDate","����λ������ʼ��"},
										{"EduRecord","��ҵѧУ(ȡ�����ѧ��)"},
										{"GraduateYear","��ҵ���(ȡ�����ѧ��)"},
										{"UserName","�Ǽ���"},
										{"OrgName","�Ǽǻ���"},
										{"InputDate","�Ǽ�����"},
										{"UpdateDate","��������"}
						   }; 
	
	sSql = 	" select CustomerID,CustomerName,getItemName('CertType',CertType) as CertTypeName, "+
			" CertID,getItemName('Sex',Sex) as SexName,Birthday, "+
			" getItemName('EducationExperience',EduExperience) as EduExperienceName, "+
			" getItemName('EducationDegree',EduDegree) as EduDegreeName, "+
			" SINo,getItemName('YesNo',Staff) as StaffName, "+
			" getItemName('Nationality',Nationality) as NationalityName, "+
			" NativePlace,getItemName('PoliticalFace',PoliticalFace) as PoliticalFaceName, "+
			" getItemName('Marriage',Marriage) as MarriageName,FamilyAdd,FamilyZIP, "+
			" FamilyTel,getItemName('FamilyStatus',FamilyStatus) as FamilyStatusName, "+
			" MobileTelephone,EmailAdd,CommAdd,CommZip, "+
			" getItemName('Occupation',Occupation) as OccupationName, "+
			" getItemName('HeadShip',HeadShip) as HeadShipName, "+
			" getItemName('TechPost',Position) as PositionName,FamilyMonthIncome, "+
			" YearIncome,getItemName('IndustryType',UnitKind) as UnitKindName, "+
			" WorkCorp,WorkAdd,WorkZip,WorkTel,WorkBeginDate,EduRecord,GraduateYear, "+
			" getUserName(InputUserID) as UserName,getOrgName(InputOrgID) as OrgName, "+
			" InputDate,UpdateDate "+
			" from IND_INFO "+
			" where CustomerID in "+
			"		(select CustomerID from CUSTOMER_BELONG "+
			" 		where OrgID in (select OrgID from ORG_INFO where SortNo like '"+CurOrg.getSortNo()+"%')) "+
			" and exists"+
					"(select 1 from CUSTOMER_INFO where IND_INFO.CustomerID=CUSTOMER_INFO.CustomerID and CUSTOMER_INFO.CustomerType='0320')"
					;
	
	//����sSql�������ݶ���
	ASDataObject doTemp = new ASDataObject(sSql);
    doTemp.setKeyFilter("CustomerID");
	//���ñ�ͷ
	doTemp.setHeader(sHeaders);
	//���ùؼ���
	doTemp.setKey("CustomerID",true);	
	//������ʾ�ı���ĳ��ȼ��¼�����
	doTemp.setHTMLStyle("CustomerName","style={width:250px} ");  
	doTemp.setAlign("FamilyMonthIncome,YearIncome","3");
	doTemp.setVisible("YearIncome",false);
	
	//���ɲ�ѯ��
	doTemp.generateFilters(Sqlca);
	doTemp.setFilter(Sqlca,"1","CustomerName","");
	doTemp.setFilter(Sqlca,"2","CustomerID","");
	doTemp.setFilter(Sqlca,"3","CertID","");	
	doTemp.setFilter(Sqlca,"4","OrgName","");	
	doTemp.parseFilterData(request,iPostChange);
	if(!doTemp.haveReceivedFilterCriteria()) doTemp.WhereClause+=" and 1=2";
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
		{"true","","Button","��ϸ��Ϣ","��ϸ��Ϣ","viewAndEdit()",sResourcesPath}
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
