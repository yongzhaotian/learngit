<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		Author:zywei 20050826
		Tester:
		Content: ѡ��Ի���ҳ��
		Input Param:
		Output param:
		History Log: 
			zywei 2007/10/11 �������������ѯ�������Ӧ�ӳ�
			xhgao 2009/04/09 ����KeyFilter�ӿ��ѯ�ٶȣ�����˫��ȷ��
			fwang 2009/08/26 ���ӹ���ҳ�����������û�
	 */
	String PG_TITLE = "ѡ����Ϣ"; // ��������ڱ��� <title> PG_TITLE </title>

	//��ȡ��������ѯ���ƺͲ���
	String sSelName  = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SelName"));
	String sParaString = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ParaString"));
	sParaString = (sParaString == null)?"":java.net.URLDecoder.decode(sParaString, "UTF-8");
	//����ֵת��Ϊ���ַ���
	if(sSelName == null) sSelName = "";
	if(sParaString == null) sParaString = "";
		
	//�����������ѯ���͡�չ�ַ�ʽ��������������
	String sSelType = "",sSelBrowseMode = "",sSelArgs = "",sSelHideField = "";
	//������������롢�ֶ���ʾ�������ơ�����������
	String sSelCode = "",sSelFieldName = "",sSelTableName = "",sSelPrimaryKey = "";
	//����������ֶ���ʾ��񡢷���ֵ�������ֶΡ�ѡ��ʽ
	String sSelFieldDisp = "",sSelReturnValue = "",sSelFilterField = "",sMutilOrSingle = "";
	//�����������ʾ�ֶζ��뷽ʽ����ʾ�ֶ����͡���ʾ�ֶμ��ģʽ���Ƿ���ݼ���������ѯ������5����ҳ��ʾ
	String sAttribute1 = "",sAttribute2 = "",sAttribute3 = "",sAttribute4 = "",sAttribute5 = "",sRemark = "";
	//������������鳤��
	int l = 0;
	//��������������ֶεĸ���
	int iReturnFiledNum = 0;
	
	String sSql =  " select SelType,SelTableName,SelPrimaryKey,SelBrowseMode,SelArgs,SelHideField,SelCode, "+
			" SelFieldName,SelFieldDisp,SelReturnValue,SelFilterField,MutilOrSingle, "+
			" Attribute1,Attribute2,Attribute3,Attribute4,Attribute5,Remark "+
			" from SELECT_CATALOG "+
			" where SelName =:SelName and IsInUse = '1' ";
	ASResultSet rs = Sqlca.getResultSet(new SqlObject(sSql).setParameter("SelName",sSelName));
	if(rs.next()){
		sSelType = rs.getString("SelType");
		sSelTableName = rs.getString("SelTableName");
		sSelPrimaryKey = rs.getString("SelPrimaryKey");
		sSelBrowseMode = rs.getString("SelBrowseMode");
		sSelArgs = rs.getString("SelArgs");
		sSelHideField = rs.getString("SelHideField");
		sSelCode = rs.getString("SelCode");
		sSelFieldName = rs.getString("SelFieldName");
		sSelFieldDisp = rs.getString("SelFieldDisp");
		sSelReturnValue = rs.getString("SelReturnValue");
		sSelFilterField = rs.getString("SelFilterField");
		sMutilOrSingle = rs.getString("MutilOrSingle");
		sAttribute1 = rs.getString("Attribute1");
		sAttribute2 = rs.getString("Attribute2");
		sAttribute3 = rs.getString("Attribute3");
		sAttribute4 = rs.getString("Attribute4");
		sAttribute5 = rs.getString("Attribute5");
		sRemark = rs.getString("Remark");
	}
	rs.getStatement().close();

	//����ֵת��Ϊ���ַ���
	if(sSelType == null) sSelType = "";
	if(sSelTableName == null) sSelTableName = "";
	if(sSelPrimaryKey == null) sSelPrimaryKey = "";
	if(sSelBrowseMode == null) sSelBrowseMode = "";
	if(sSelArgs == null) sSelArgs = "";
	else sSelArgs = sSelArgs.trim();
	if(sSelHideField == null) sSelHideField = "";
	else sSelHideField = sSelHideField.trim();
	if(sSelCode == null) sSelCode = "";
	else sSelCode = sSelCode.trim();	
	if(sSelFieldName == null) sSelFieldName = "";
	else sSelFieldName = sSelFieldName.trim();
	if(sSelFieldDisp == null) sSelFieldDisp = "";
	else sSelFieldDisp = sSelFieldDisp.trim();
	if(sSelReturnValue == null) sSelReturnValue = "";
	else sSelReturnValue = sSelReturnValue.trim();
	if(sSelFilterField == null) sSelFilterField = "";
	else sSelFilterField = sSelFilterField.trim();
	if(sMutilOrSingle == null) sMutilOrSingle = "";
	if(sAttribute1 == null) sAttribute1 = "";
	if(sAttribute2 == null) sAttribute2 = "";
	if(sAttribute3 == null) sAttribute3 = "";
	if(sAttribute4 == null) sAttribute4 = "";
	if(sAttribute5 == null) sAttribute5 = "";
	if(sRemark == null) sRemark = "";
	
	//��ȡ����ֵ
	StringTokenizer st = new StringTokenizer(sSelReturnValue,"@");
	String [] sReturnValue = new String[st.countTokens()];  
	while (st.hasMoreTokens()) {
		sReturnValue[l] = st.nextToken();                
		l ++;
	}
	iReturnFiledNum = sReturnValue.length;
	//������ʾ����
	String sHeaders = sSelFieldName;
	
	//��Sql�еı��������Ӧ��ֵ�滻	
	StringTokenizer stArgs = new StringTokenizer(sParaString,",");
	while (stArgs.hasMoreTokens()) {
		try{
			String sArgName  = stArgs.nextToken().trim();
			String sArgValue  = stArgs.nextToken().trim();		
			sSelCode = StringFunction.replace(sSelCode,"#"+sArgName,sArgValue );		
		}catch(NoSuchElementException ex){
			throw new Exception("���������ʽ����");
		}
	}	
	
	//ʵ����DataObject	
	ASDataObject doTemp = new ASDataObject(sSelCode);
	doTemp.UpdateTable = sSelTableName;
	doTemp.setKey(sSelPrimaryKey,true);
	doTemp.setHeader(sHeaders);	
	
	//���������ֶ�	
	if(!sSelHideField.equals("")) doTemp.setVisible(sSelHideField,false);	
	
	//���ö����ʽ
	StringTokenizer stAlign = new StringTokenizer(sAttribute1,"@");
	while (stAlign.hasMoreTokens()) {
		String sAlignName  = stAlign.nextToken().trim();
		String sAlignValue  = stAlign.nextToken().trim();		
		doTemp.setAlign(sAlignName,sAlignValue);  	
	}
	
	//��������
	StringTokenizer stType = new StringTokenizer(sAttribute2,"@");
	while (stType.hasMoreTokens()) {
		String sTypeName  = stType.nextToken().trim();
		String sTypeValue  = stType.nextToken().trim();		
		doTemp.setType(sTypeName,sTypeValue);  	
	}
	
	//���ü��ģʽ
	StringTokenizer stCheck = new StringTokenizer(sAttribute3,"@");
	while (stCheck.hasMoreTokens()) {
		String sCheckName  = stCheck.nextToken().trim();
		String sCheckValue  = stCheck.nextToken().trim();		
		doTemp.setCheckFormat(sCheckName,sCheckValue);  	
	}	
	
	//KeyFilter�ӿ��ѯ�ٶ�
	StringTokenizer stFilter = new StringTokenizer(sAttribute4,"@");
	String sFilter="";
	while (stFilter.hasMoreTokens()) {
		String sFilterValue  = stFilter.nextToken().trim();	
		sFilter=sFilter+"||"+sFilterValue;
	}
	if(sFilter.length()>2){
		doTemp.setKeyFilter(sSelPrimaryKey);
	}
	
	//������������Դ
	StringTokenizer sDrawDownList = new StringTokenizer(sAttribute5,"@");
	ArrayList ddwColumn = new ArrayList();
	while (sDrawDownList.hasMoreTokens()) {
		String sFilterOptions = null;
		String sColumnList = sDrawDownList.nextToken().trim();
		String sSourceType = sDrawDownList.nextToken().trim();
		String sSource = sDrawDownList.nextToken().trim();
		if(sDrawDownList.hasMoreTokens())
			sFilterOptions = sDrawDownList.nextToken().trim(); 
		if("Code".equalsIgnoreCase(sSourceType)){
			doTemp.setDDDWCode(sColumnList,sSource);
		}else if("Sql".equalsIgnoreCase(sSourceType)){
			doTemp.setDDDWSql(sColumnList,sSource);
		}else if("CodeTable".equalsIgnoreCase(sSourceType)){
			doTemp.setDDDWCodeTable(sColumnList,sSource);
		}
		if(sFilterOptions == null) sFilterOptions = " ";
		ddwColumn.add(sColumnList+"@"+sFilterOptions);
	}	
	
	//������ʾ��ʽ
	StringTokenizer stDisp = new StringTokenizer(sSelFieldDisp,"@");
	while (stDisp.hasMoreTokens()) {
		String sDispName  = stDisp.nextToken().trim();
		String sDispValue  = stDisp.nextToken().trim();		
		doTemp.setHTMLStyle(sDispName,sDispValue);  
	}		
	
	//���ü�����
	if(!sSelFilterField.equals("")){
		String[] sColName= sSelFilterField.split(",");
		for(int i=0;i<sColName.length;i++){
			boolean executed = false;
			for(int j=0;j<ddwColumn.size();j++){
				String stColumn = ddwColumn.get(j).toString().split("@")[0].trim();
				String stOptions = "Operators="+ddwColumn.get(j).toString().split("@")[1].trim();
				
				if(stColumn.equals(sColName[i].toString())){
					doTemp.setFilter(Sqlca,"DF"+i,sColName[i],stOptions);
					executed = true;
				}
			}
			if(!executed){
				doTemp.setFilter(Sqlca,"DF"+i,sColName[i],"");
			}
		}
		doTemp.parseFilterData(request,iPostChange);
		CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	}
	
	doTemp.appendHTMLStyle(""," style=\"cursor:pointer;\" ondblclick=javascript:parent.parent.returnSelection() ");
	//���ü�������--�����������Ĭ�ϲ���ѯ
	if(sSelName.equals("SelectWaiveFee")){
		if(!doTemp.haveReceivedFilterCriteria()){
			doTemp.WhereClause+=" and 1=2";
		}else{
			if((doTemp.Filters.get(0).sFilterInputs[0][1] != null && doTemp.Filters.get(0).sFilterInputs[0][1] != "") && (doTemp.Filters.get(0).sFilterInputs[0][1].contains("%")||doTemp.Filters.get(0).sFilterInputs[0][1].trim().length() < 8) ){
				%>
				<script type="text/javascript">
					alert("��ͬ�Ų��ܺ���\"%\"�����ҳ��Ȳ�������8λ!");
				</script>
				<%
				doTemp.WhereClause+=" and 1=2";
			}
			if((doTemp.Filters.get(1).sFilterInputs[0][1] != null && doTemp.Filters.get(1).sFilterInputs[0][1] != "") && (doTemp.Filters.get(1).sFilterInputs[0][1].contains("%")) ){
				%>
				<script type="text/javascript">
					alert("�ͻ����Ʋ��ܺ���\"%\"����!");
				</script>
				<%
				doTemp.WhereClause+=" and 1=2";
			}
		}
	}
	
	//���������--�����������˻�����Ϣ����Ĭ�ϲ���ѯ
	 if(sSelName.equals("SelectPayableLoan1")||sSelName.equals("SelectPayableLoan")){
			if(!doTemp.haveReceivedFilterCriteria()){
				doTemp.WhereClause+=" and 1=2";
			}else{
				if((doTemp.Filters.get(0).sFilterInputs[0][1] != null && doTemp.Filters.get(0).sFilterInputs[0][1] != "") && (doTemp.Filters.get(0).sFilterInputs[0][1].contains("%")||doTemp.Filters.get(0).sFilterInputs[0][1].trim().length() < 8) ){
					%>
					<script type="text/javascript">
						alert("��ͬ�Ų��ܺ���\"%\"�����ҳ��Ȳ�������8λ!");
					</script>
					<%
					doTemp.WhereClause+=" and 1=2";
				}
				if((doTemp.Filters.get(1).sFilterInputs[0][1] != null && doTemp.Filters.get(1).sFilterInputs[0][1] != "") && (doTemp.Filters.get(1).sFilterInputs[0][1].contains("%")||doTemp.Filters.get(1).sFilterInputs[0][1].trim().length() < 8) ){
					%>
					<script type="text/javascript">
						alert("��ݺŲ��ܺ���\"%\"�����ҳ��Ȳ�������8λ!");
					</script>
					<%
					doTemp.WhereClause+=" and 1=2";
				}
				if((doTemp.Filters.get(2).sFilterInputs[0][1] != null && doTemp.Filters.get(2).sFilterInputs[0][1] != "") && (doTemp.Filters.get(2).sFilterInputs[0][1].contains("%")||doTemp.Filters.get(2).sFilterInputs[0][1].trim().length() < 2) ){
					%>
					<script type="text/javascript">
						alert("�ͻ����Ʋ��ܺ���\"%\"�����ҳ��Ȳ�������2λ!");
					</script>
					<%
					doTemp.WhereClause+=" and 1=2";
				}
			}
		}
	
	//�����Ҫ���ݼ���������ѯ�������Ĭ�ϲ�ѯΪ��
	if(sAttribute4.equals("1") && !doTemp.haveReceivedFilterCriteria())
		doTemp.WhereClause += " and 1=2 ";
	
	if(!sMutilOrSingle.equals("Single"))
		doTemp.multiSelectionEnabled=true;
	//ʵ����DataWindow
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	
	int setPageSize = 15;
	if(!"".equals(sRemark)) setPageSize = Integer.parseInt(sRemark, 10);
	
	dwTemp.setPageSize(setPageSize);  //��������ҳ

	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("%");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	
	String sButtons[][] = {};
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
	<%/*~[Describe=�ύ;]~*/%>	
	function doSearch(){
		document.forms["form1"].submit();
	}
	
	<%/*~[Describe=��ѡ���е���Ϣƴ���ַ���������;]~*/%>	
	function mySelectRow(){
		if (getRow()<0) return;
		var sReturnValue = "";
		try{
			<%for(int j = 0 ; j < sReturnValue.length ; j ++){%>
				sReturnValue += getItemValue(0,getRow(),"<%=sReturnValue[j]%>") + "@";
			<%}%>
		}catch(e){
			return;
		}
		parent.sObjectInfo = sReturnValue; 
	}
	
	<%/*~[Describe=��ѡ���е���Ϣƴ���ַ���������;]~*/%>	
	function returnValue(){
		var sReturnValue = "";
		var sMutilOrSingle = "<%=sMutilOrSingle%>";		
		if(sMutilOrSingle == "Multi")		//��ѡ
			sReturnValue = myMultiSelectRow();
		else
			sReturnValue = mySingleSelectRow();
		
		sReturnSplit = sReturnValue.split("@"); //�ڷ���ʱ��ֻҪ�жϵ�һ����undefined���Ϳ���˵����û��ѡ���κ�����
		if(sReturnSplit[0]=="undefined"){		//���������undefied�ġ�
			parent.sObjectInfo="";
		}else{
			parent.sObjectInfo = sReturnValue;
		}		
	}
	
	<%/*~[Describe=��ѡ���е���Ϣƴ���ַ���������;]~*/%>	
	function mySingleSelectRow(){
		try{			
			var sReturnValue = "";			
			<%for(int j = 0 ; j < iReturnFiledNum ; j ++){%>
				sReturnValue += getItemValue(0,getRow(),"<%=sReturnValue[j]%>") + "@";
			<%}%>
		}catch(e){
			return;
		}				
		return (sReturnValue); 
	}
	
	<%/*~[Describe=��ѡ���е���Ϣƴ���ַ���������;]~*/%>	
	function myMultiSelectRow(){
		try{
			var b = getRowCount(0);
			var sReturnValue = "";				
			for(var iMSR = 0 ; iMSR < b ; iMSR++){
				var a = getItemValue(0,iMSR,"MultiSelectionFlag");				
				if(a == "��"){
					<%for(int j = 0 ; j < iReturnFiledNum ; j ++){%>
						sReturnValue += getItemValue(0,iMSR,"<%=sReturnValue[j]%>") + "@";
					<%}%>
				}
			}
		}catch(e){
			return;
		}				
		return (sReturnValue); 
	}
			
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');		
</script>	
<%@ include file="/IncludeEnd.jsp"%>