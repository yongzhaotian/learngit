<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author:thong 2005
		Tester:
		Content: ��������޶�
		Input Param:
		Output param:
		History Log: 

	 */
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "��������޶�"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%
	//�������
	String sSql;
	String sInputUser; 
	String sLimitSerialNo; 
	String sCombiType1 = "",sCombiType2 = "",sCombiType3 = "";
	//����������	
	sLimitSerialNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("LimitSerialNo"));

	sInputUser =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("InputUser"));
	if(sInputUser==null) sInputUser="";
	//���ҳ�����	
	//sCustomerID =  DataConvert.toRealString(iPostChange,(String)request.getParameter("CustomerID"));
%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%	
	String sTempletFilter = "1=1"; //�й�������ע�ⲻҪ�����ݹ���������
	//ͨ����ʾģ�����ASDataObject����doTemp
	String sHeaders[][] = { 
				{"KindCode1","�������һ"},
				{"KindCode2","������Ͷ�"},
				{"KindCode3","���������"},
				{"TotalSum","�޶�����(Ԫ)"},
				
				{"Limit","Ŀ���޶�(Ԫ)"},
				{"Rate","Ŀ��ռ��(%)"},
				{"ECLimit","�����ʱ�������(Ԫ)"},
				{"ECRate","������ռ��(%)"},
				
				{"AlertRate","��ʾ����(%)"},
				{"LimitLevel","���Ƽ���"},
				{"BeginDate","��Ч����"},
				{"EndDate","ʧЧ����"},
				{"Useflg","�Ƿ�ʹ��"},
				{"UserName","������Ա"}
			       };   				   		
	
	sSql = "select getItemDescribe('CombiType',CombiType1) as CombiType1,"+
		   "getItemDescribe('CombiType',CombiType2) as CombiType2,"+
		   "getItemDescribe('CombiType',CombiType3) as CombiType3 "+
		   "from XLIMIT_DEF where SerialNo = '"+sLimitSerialNo+"'";
	ASResultSet rs = SqlcaRepository.getResultSet(sSql);
	if(rs.next()){
		sCombiType1 = DataConvert.toRealString(rs.getString(1));
		sCombiType2 = DataConvert.toRealString(rs.getString(2));
		sCombiType3 = DataConvert.toRealString(rs.getString(3));
	}
	rs.getStatement().close();

	sSql = "select XL.SerialNo,XL.LimitType,XL.KindCode1,XL.KindCode2";
	if(sCombiType3!=null&&!sCombiType3.equals("null")&&!"".equals(sCombiType3)){
		sSql = sSql + ",XL.KindCode3";
	}
	sSql = sSql + "	,XL.TotalSum,XL.Limit,XL.Rate,XL.ECLimit"
			+",XL.ECRate,XL.BeginDate,XL.EndDate,XL.AlertRate,getItemName('YesOrNo2',XL.Useflg) as Useflg"
			+",getUserName(XL.UserID) as UserName  "
			+" from XLIMIT_INFO XL,XLIMIT_DEF XD "
			+" where XL.LimitType = '"+sLimitSerialNo+"' and XD.SerialNo = XL.LimitType "
			+" order by XL.SerialNo";
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders);

	doTemp.UpdateTable = "XLIMIT_INFO";           //for delete        		
	doTemp.setKey("SerialNo",true);
					
	doTemp.setColumnAttribute("KindCode1","IsFilter","1");
	
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	doTemp.setReadOnly("SerialNo",true);
	doTemp.setVisible("SerialNo,LimitType,",false);

	doTemp.setDDDWCode("KindCode1","CombiType");
	doTemp.setDDDWSql("KindCode2","select ItemNo,ItemName from CODE_LIBRARY where CodeNo='VouchTyped'");
	//doTemp.setDDDWSql("KindCode1",sCombiType1);
	//doTemp.setDDDWSql("KindCode2",sCombiType2);	
	
	if(sCombiType3!=null&&!sCombiType3.equals("null"))
	doTemp.setDDDWCode("KindCode3","CombiType");	
	//doTemp.setDDDWSql("KindCode3",sCombiType3);

	doTemp.setAlign("TotalSum,Limit,ECLimit,Rate,AlertRate,ECRate","3");
	doTemp.setCheckFormat("TotalSum,Limit,ECLimit","2");
	
	doTemp.setHTMLStyle("LimitType,BeginDate,EndDate,Useflg,UserName,Rate,AlertRate,"," style={width:70px}");
	doTemp.setHTMLStyle("TotalSum,Limit,ECRate,ECLimit"," style={width:130px}");	
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));

	if(!sInputUser.equals("")) doTemp.WhereClause += " and InputUser = '"+sInputUser+"'";
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д

	//��������¼�
	//dwTemp.setEvent("AfterDelete","!CustomerManage.DeleteRelation(#CustomerID,#RelativeID,#RelationShip)");
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("%");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	
	//out.println(doTemp.SourceSql); //������仰����datawindow
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
		{"true","","Button","���沢����","���������޸�,�������б�ҳ��","saveAndGoBack()",sResourcesPath},
		{"true","","Button","���沢����","���沢����һ����¼","saveAndNew()",sResourcesPath},
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
		}

		beforeUpdate();
		as_save("myiframe0",sPostEvents);
	}
	
	/*~[Describe=���������޸�,�������б�ҳ��;InputParam=��;OutPutParam=��;]~*/
	function saveAndGoBack(){
		saveRecord("goBack()");
	}
	
	/*~[Describe=�����б�ҳ��;InputParam=��;OutPutParam=��;]~*/
	function goBack(){
		OpenPage("/LimitManage/XCombiDef.jsp","_self","");
	}

	/*~[Describe=���沢����һ����¼;InputParam=��;OutPutParam=��;]~*/
	function saveAndNew(){
		saveRecord("newRecord()");
	}
	
	</script>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info07;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">
	/*~[Describe=����һ����¼;InputParam=��;OutPutParam=��;]~*/
	function newRecord(){
		OpenPage("/LimitManage/XCombiDef.jsp","_self","");
	}

	/*~[Describe=ִ�в������ǰִ�еĴ���;InputParam=��;OutPutParam=��;]~*/
	function beforeInsert(){
		initSerialNo();//��ʼ����ˮ���ֶ�
		setItemValue(0,0,"InputUser","<%=CurUser.getUserID()%>");
		setItemValue(0,0,"InputUserName","<%=CurUser.getUserName()%>");
		setItemValue(0,0,"InputOrg","<%=CurUser.getOrgID()%>");
		setItemValue(0,0,"InputTime","<%=StringFunction.getTodayNow()%>");
		bIsInsert = false;
	}
	/*~[Describe=ִ�и��²���ǰִ�еĴ���;InputParam=��;OutPutParam=��;]~*/
	function beforeUpdate(){
		setItemValue(0,0,"UpdateUser","<%=CurUser.getUserID()%>");
		setItemValue(0,0,"UpdateUserName","<%=CurUser.getUserName()%>");
		setItemValue(0,0,"UpdateTime","<%=StringFunction.getTodayNow()%>");
	}

	/*~[Describe=ҳ��װ��ʱ����DW���г�ʼ��;InputParam=��;OutPutParam=��;]~*/
	function initRow(){
		if (getRowCount(0)==0){ //���û���ҵ���Ӧ��¼��������һ�����������ֶ�Ĭ��ֵ
			as_add("myiframe0");//������¼
			bIsInsert = true;
		}
    }
	
	/*~[Describe=��ʼ����ˮ���ֶ�;InputParam=��;OutPutParam=��;]~*/
	function initSerialNo(){
		var sTableName = "XLIMIT_DEF";//����
		var sColumnName = "SerialNo";//�ֶ���
		var sPrefix = "";//ǰ׺

		//��ȡ��ˮ��
		var sSerialNo = getSerialNo(sTableName,sColumnName,sPrefix);
		//����ˮ�������Ӧ�ֶ�
		setItemValue(0,getRow(),"SerialNo",sSerialNo);
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
