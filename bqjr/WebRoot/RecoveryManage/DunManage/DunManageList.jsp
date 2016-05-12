<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   	FSGong  2004.12.05
		Tester:
		Content:  	�����ʲ��б�(Listҳ��)
		Input Param:
				���в�����Ϊ�����������
				PropertyType	�ʲ����ͣ������ʲ�/�����ʲ�								
				ObjectType	�������ͣ�BUSINESS_CONTRACT
						��������������Ŀ���Ǳ�����չ��,�������ܲ������û������ʲ��Ĵ��պ�����.
			        
		Output param:
		                ContractID	�ʲ����
		History Log: 		               
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "�����ʲ��б�"; // ��������ڱ��� <title> PG_TITLE </title>
	CurPage.setAttribute("ShowDetailArea","true");
	CurPage.setAttribute("DetailAreaHeight","125");
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%

	//�������	
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%	
	String sSql ="";
	
	String sDBName = Sqlca.getConnection().getMetaData().getDatabaseProductName().toUpperCase();
	String sTempletNo = "DunManageList";
	
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);

	if(sDBName.startsWith("INFORMIX"))
	{
			doTemp.FromClause = " from  BUSINESS_CONTRACT bc,outer Dun_Info di ";
			doTemp.WhereClause =" where bc.RecoveryUserID='"+CurUser.getUserID()+"' and bc.Balance >0 "+
						  							  " and (bc.FinishDate is NULL or bc.FinishDate =' ' or bc.FinishType='060') and bc.ShiftType='02' "+
													  " and bc.SerialNo=di.ObjectNo ";
	}else if(sDBName.startsWith("ORACLE")) 
	{
			doTemp.FromClause = " from  BUSINESS_CONTRACT bc,Dun_Info di ";
			doTemp.WhereClause = " where bc.RecoveryUserID='"+CurUser.getUserID()+"' and bc.Balance >0 "+
													   " and (bc.FinishDate is NULL or bc.FinishDate =' ' or bc.FinishType='060') and bc.ShiftType='02' "+
													   " and bc.SerialNo=di.ObjectNo(+) ";	
	}else if(sDBName.startsWith("DB2")) 
	{ 
		   doTemp.FromClause = " from BUSINESS_CONTRACT bc left outer join  Dun_Info di on (bc.SerialNo=di.ObjectNo) ";
		   doTemp.WhereClause = "where bc.RecoveryUserID='"+CurUser.getUserID()+"' and bc.Balance>0"+
		                                              " and (bc.FinishDate is NULL or bc.FinishDate =' ' or bc.FinishType='060') and bc.ShiftType='02' ";
	}

	//���ɲ�ѯ����
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));

	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.setPageSize(20);//20��һ��ҳ

	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");//������ʾģ�����
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
		{"true","","Button","��ͬ����","��ͬ����","viewTab()",sResourcesPath},
	};
	%> 
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">
	
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
	
	/*~[Describe=ѡ��ĳ�ʺ�ͬ,�Զ���ʾ��صĴ����б�;InputParam=��;OutPutParam=��;]~*/
	function mySelectRow()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");//��ͬ���
		sCurrency = getItemValue(0,getRow(),"Currency");
		if(typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			//alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else 
		{
			OpenComp("DunList","/RecoveryManage/DunManage/DunList.jsp","ObjectType=BusinessContract&ObjectNo="+sSerialNo+"&Currency="+sCurrency,"DetailFrame");
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
	my_load(2,0,'myiframe0');
	OpenPage("/Blank.jsp?TextToShow=����ѡ����Ӧ�ĺ�ͬ��Ϣ!","DetailFrame","");
</script>	
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>