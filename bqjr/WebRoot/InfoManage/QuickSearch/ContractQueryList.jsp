<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%@page import="com.amarsoft.dict.als.cache.CodeCache"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   CYHui 2005-1-25
		Tester:
		Content: ��ͬ��Ϣ���ٲ�ѯ
		Input Param:
		Output param:
		History Log: 
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "��ͬ��Ϣ���ٲ�ѯ"; // ��������ڱ��� <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;��ͬ��Ϣ���ٲ�ѯ&nbsp;&nbsp;";
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

	//����sSql�������ݶ���
	String sTempletNo = "ContractQueryList1"; //ģ����
    ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	doTemp.setKeyFilter("BC.SerialNo");
	
	Map<String, String> roleClauseMap = new HashMap<String, String>();
	//�ŵ���г��о���ά���������۾�����ϼ�ȡ�� edit by Dahl 2015-3-20
	//roleClauseMap.put("1003", " stores in (SELECT SNO FROM STORE_INFO WHERE CITYMANAGER IN (SELECT ATTR3 FROM BASEDATASET_INFO WHERE TYPECODE='CityCode' AND ATTRSTR2 IN (SELECT ACBI.ATTR1 FROM BASEDATASET_INFO ACBI WHERE TYPECODE='AreaCode' AND ATTR3='"+CurUser.getUserID()+"'))) ");
	roleClauseMap.put("1003", " stores in (select sno from store_info si ,user_info ui where si.salesmanager=ui.userId and ui.superid in (SELECT ATTR3 FROM BASEDATASET_INFO WHERE TYPECODE='CityCode' AND ATTRSTR2 IN (SELECT ACBI.ATTR1 FROM BASEDATASET_INFO ACBI WHERE TYPECODE='AreaCode' AND ATTR3='"+CurUser.getUserID()+"'))) ");
	//roleClauseMap.put("1004", " stores in (select sno from store_info where citymanager='"+CurUser.getUserID()+"') ");
	roleClauseMap.put("1004", " stores in (select sno from store_info si ,user_info ui where si.salesmanager=ui.userId and ui.superid='"+CurUser.getUserID()+"') ");
	roleClauseMap.put("1005", " stores in (select sno from store_info where salesmanager='"+CurUser.getUserID()+"') ");
	roleClauseMap.put("1006", " SALESEXECUTIVE='"+ CurUser.getUserID() +"' ");
	List roleList = CurUser.getRoleTable();
	String sRoleWhereClause = "";
	for (int i=0; i<roleList.size(); i++) {
		String sAndOr = "".equals(sRoleWhereClause)? " and ( ": " or ";
		if (roleClauseMap.containsKey(roleList.get(i))) {
			sRoleWhereClause += sAndOr + roleClauseMap.get(roleList.get(i));
		}
	}
	
	//��������ʱ��Ϊ�����ؼ�
	doTemp.setCheckFormat("InputTime", "3");
	//���ش��������ϴ�״̬
	doTemp.setVisible("uploadFlag", false);
		
	if (!"".equals(sRoleWhereClause)) {
		doTemp.WhereClause += sRoleWhereClause + ")";
	}
		
	//���ɲ�ѯ��
	doTemp.setFilter(Sqlca, "0010", "SerialNo", "Operators=EqualsString,BeginsWith;");
	doTemp.setFilter(Sqlca, "0020", "CustomerID", "Operators=EqualsString;");
	doTemp.setFilter(Sqlca, "0030", "CustomerName", "Operators=EqualsString,BeginsWith;");
	//CCS-1312:ͳ�Ʋ�ѯ-��ͬ���ٲ�ѯ�����֤�š��ֻ���Ҫ��Ϊֻ���õ�������ѯ
	//doTemp.setFilter(Sqlca, "0033", "CertID", "Operators=EqualsString,BeginsWith;");
	//doTemp.setFilter(Sqlca, "003310", "MobilePhone", "Operators=EqualsString,BeginsWith;");
	doTemp.setFilter(Sqlca, "0033", "CertID", "Operators=EqualsString;");
	doTemp.setFilter(Sqlca, "003310", "MobilePhone", "Operators=EqualsString;");
	//End CCS-1312:ͳ�Ʋ�ѯ-��ͬ���ٲ�ѯ�����֤�š��ֻ���Ҫ��Ϊֻ���õ�������ѯ
	doTemp.setFilter(Sqlca, "003314", "InputTime", "Operators=BeginsWith;");
	doTemp.setFilter(Sqlca, "003315", "SignedDate", "Operators=EqualsString,BeginsWith;");
	doTemp.setFilter(Sqlca, "003320", "RegistrationDate", "Operators=EqualsString,BeginsWith;");
	doTemp.setFilter(Sqlca, "0035", "SubProductType", "Operators=EqualsString;");
	doTemp.setFilter(Sqlca, "0040", "BusinessType", "Operators=EqualsString;");
	doTemp.setFilter(Sqlca, "0044", "ProductID", "Operators=EqualsString;");
	doTemp.setFilter(Sqlca, "0045", "OperateModeName", "Operators=EqualsString,BeginsWith;");
	doTemp.setFilter(Sqlca, "0180", "ContractStatus", "Operators=EqualsString;");
	doTemp.setFilter(Sqlca, "019001", "QualityGrade", "Operators=EqualsString;");
// 	doTemp.setFilter(Sqlca, "0200", "RetailID", "Operators=EqualsString,BeginsWith;");
// 	doTemp.setFilter(Sqlca, "0210", "Stores", "Operators=EqualsString,BeginsWith;");
// 	doTemp.setFilter(Sqlca, "0235", "Salesexecutive", "Operators=EqualsString;");
// 	doTemp.setFilter(Sqlca, "0241", "SalesManager", "Operators=EqualsString;");
// 	doTemp.setFilter(Sqlca, "0256", "StoreCityCode", "Operators=EqualsString;");
	//doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	//�жϷ��ϸ������Ƿ����ݱȽ϶࣬Ӱ���ѯ����
	boolean flag = true;
	for(int k=0;k<doTemp.Filters.size();k++){
		if(doTemp.Filters.get(k).sFilterInputs[0][1] != null && (("0010").equals(doTemp.getFilter(k).sFilterID)||("0020").equals(doTemp.getFilter(k).sFilterID)||("0030").equals(doTemp.getFilter(k).sFilterID)||("0033").equals(doTemp.getFilter(k).sFilterID)||("003310").equals(doTemp.getFilter(k).sFilterID)) ){
			flag = false;
			break;
		}
	}
	if(doTemp.haveReceivedFilterCriteria()&& flag)
	{
		%>
		<script type="text/javascript">
			alert("Ϊ�˿��ٲ�ѯ����ͬ���,�ͻ����,�ͻ�����,���֤����,�ֻ�������������һ�");
		</script>
		<%
		doTemp.WhereClause+=" and 1=2";
	}	
	for(int k=0;k<doTemp.Filters.size();k++){
		//��������������ܺ���%��_����
		//if(doTemp.Filters.get(k).sFilterInputs[0][1] != null && doTemp.Filters.get(k).sFilterInputs[0][1].contains("%")){//commented by NQ, CCS-1312:ͳ�Ʋ�ѯ-��ͬ���ٲ�ѯ�����֤�š��ֻ���Ҫ��Ϊֻ���õ�������ѯ
		if(doTemp.Filters.get(k).sFilterInputs[0][1] != null && (doTemp.Filters.get(k).sFilterInputs[0][1].contains("%") || 
				doTemp.Filters.get(k).sFilterInputs[0][1].contains("_"))){//updated by NQ, CCS-1312:ͳ�Ʋ�ѯ-��ͬ���ٲ�ѯ�����֤�š��ֻ���Ҫ��Ϊֻ���õ�������ѯ
			%>
			<script type="text/javascript">
				alert("������������ܺ���\"%\"����\"_\"����!"); //updated by NQ, CCS-1312:ͳ�Ʋ�ѯ-��ͬ���ٲ�ѯ�����֤�š��ֻ���Ҫ��Ϊֻ���õ�������ѯ
			</script>
			<%
			doTemp.WhereClause+=" and 1=2";
			break;
		}
		
		if(doTemp.Filters.get(k).sFilterInputs[0][1] != null  && "BeginsWith".equals(doTemp.Filters.get(k).sOperator)){
			if(("0030").equals(doTemp.getFilter(k).sFilterID) && doTemp.Filters.get(k).sFilterInputs[0][1].trim().length() < 2){
				%>
				<script type="text/javascript">
					alert("������ַ����ȱ���Ҫ���ڵ���2λ!");
				</script>
				<%
				doTemp.WhereClause+=" and 1=2";
				break;
			} else if(("0033").equals(doTemp.getFilter(k).sFilterID) && doTemp.Filters.get(k).sFilterInputs[0][1].trim().length() < 8){
				%>
				<script type="text/javascript">
					alert("��������֤���ȱ���Ҫ���ڵ���8λ!");
				</script>
				<%
				doTemp.WhereClause+=" and 1=2";
				break;
			}else if(("0010").equals(doTemp.getFilter(k).sFilterID) && doTemp.Filters.get(k).sFilterInputs[0][1].trim().length() < 8){
				%>
				<script type="text/javascript">
					alert("����ĺ�ͬ�ų��ȱ���Ҫ���ڵ���8λ!");
				</script>
				<%
				doTemp.WhereClause+=" and 1=2";
				break; 
			}else if(("003310").equals(doTemp.getFilter(k).sFilterID) && doTemp.Filters.get(k).sFilterInputs[0][1].trim().length() < 8){
				%>
				<script type="text/javascript">
					alert("������ֻ��ų��ȱ���Ҫ���ڵ���8λ!");
				</script>
				<%
				doTemp.WhereClause+=" and 1=2";
				break;
			}
			
		} else if(k==doTemp.Filters.size()-1){
		
			if(!doTemp.haveReceivedFilterCriteria()) doTemp.WhereClause+=" and 1=2";
		
		}
	}
	
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));

	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.setPageSize(16);  //��������ҳ

	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	
	//CCS-857-�����е��õ��Ӻ�ͬ��ַ�豣�浽�����ļ���ʹ��
	String sAPPUrl4pdf = CodeCache.getItem("PrintAppUrl","0010").getItemAttribute();
	String sAPPUrl4photo = CodeCache.getItem("PrintAppUrl","0011").getItemAttribute();
	String sAPPUrl4record = CodeCache.getItem("PrintAppUrl","0012").getItemAttribute();
	String sAPPUrl4Sxhpdf = CodeCache.getItem("PrintAppUrl","0014").getItemAttribute();
	
	//��Ǯô���뱻����,���������
	String sJQMUrl4pdf = CodeCache.getItem("PrintAppUrl","0013").getItemAttribute();
	String sFCUrl4pdf = CodeCache.getItem("PrintAppUrl","0015").getItemAttribute();
	String sFCUrl4Sxhpdf = CodeCache.getItem("PrintAppUrl","0016").getItemAttribute();

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
			{"true","","Button","��ϸ��Ϣ","��ϸ��Ϣ","viewAndEdit()",sResourcesPath},
			{((CurUser.hasRole("1035") || CurUser.hasRole("1036") || CurUser.hasRole("1039"))?"true":"false"),"","Button","�����˺ű��","�����˺ű��","withholdChange()",sResourcesPath},
			{((CurUser.hasRole("1036") || CurUser.hasRole("1039")||CurUser.hasRole("1044") || CurUser.hasRole("1051")||CurUser.hasRole("1052") || CurUser.hasRole("1035"))?"true":"false"),"","Button","�����ٴδ���","�����ٴδ���","sponsorAgainWithhold()",sResourcesPath},
			{((CurUser.hasRole("1035") || CurUser.hasRole("1036") || CurUser.hasRole("1039"))?"true":"false"),"","Button","�˿��ѯ","��ѯ�˿��ѯ��Ϣ","RefundFind()",sResourcesPath},
			{((CurUser.hasRole("1035") || CurUser.hasRole("1036") || CurUser.hasRole("1039"))?"true":"false"),"","Button","�������֤������","�������֤������","CreditSettle()",sResourcesPath},
			{"true","","Button","���Ӻ�ͬ����","���Ӻ�ͬ����","viewApplyReport()",sResourcesPath},
			{"true","","Button","������Э�����","������Э�����","creatThirdTable()",sResourcesPath},
			{"true","","Button","���Ļ�����������","���Ļ�����������","printSuiXinHuan()",sResourcesPath},
			{"true","","Button","��ӡ�۱�����ͬ","��ӡ�۱�����ͬ","printBaiBaoDai()",sResourcesPath},
			{"true","","Button","Ӱ���ͬ����","Ӱ���ͬ����","imageManage()",sResourcesPath},
			{((CurUser.hasRole("1035") || CurUser.hasRole("1036")||CurUser.hasRole("1039"))?"true":"false"),"","Button","��ǰ�����ѯ","��ѯ��ǰ������Ϣ","SelectPrepayment()",sResourcesPath},
			{"true","","Button","�˻�����","�˻�����","returnApply()",sResourcesPath},
			{"true","","Button","�˱�����","�˱�����","cancellationInsurance()",sResourcesPath},
			{((CurUser.hasRole("1035") || CurUser.hasRole("1036")||CurUser.hasRole("1039"))?"true":"false"),"","Button","��ӡ����С��ʿ","��ӡ����С��ʿ","printRemind()",sResourcesPath},
			{((CurUser.hasRole("1035") || CurUser.hasRole("1036")||CurUser.hasRole("1039"))?"true":"false"),"","Button","��ӡ������","��ӡ������","printApprove()",sResourcesPath},
			{CurUser.getRoleTable().contains("2001")?"true":"false","","Button","����EXCEL","����EXCEL","exportExcel()",sResourcesPath},
			{(CurUser.getRoleTable().contains("1000")||CurUser.getRoleTable().contains("1038"))?"true":"false","","Button","���Ӻ�ͬ","���Ӻ�ͬ","createPDF()",sResourcesPath},
			{(CurUser.getRoleTable().contains("1000")||CurUser.getRoleTable().contains("1038"))?"true":"false","","Button","���Ļ����Ӻ�ͬ","���Ļ����Ӻ�ͬ","createSxhPDF()",sResourcesPath},
			{(CurUser.getRoleTable().contains("1000")||CurUser.getRoleTable().contains("1038"))?"true":"false","","Button","ǩ����Ƭ","ǩ����Ƭ","createPhoto()",sResourcesPath},
			{(CurUser.getRoleTable().contains("1000")||CurUser.getRoleTable().contains("1038"))?"true":"false","","Button","ǩ��¼��","ǩ��¼��","createAudio()",sResourcesPath},
			{"true","","Button","�Ƽ�����","�Ƽ�����","showWeChatResult()",sResourcesPath}
	};
	%> 
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">
	//---------------------���尴ť�¼�------------------------------------
	
	
	//  ==============================  ��ӡ��ʽ������  ��������  add by yzhang9    ============================================================
	
	//Excel����������	
	function exportExcel(){
		amarExport("myiframe0");
	}
	//end by pli2 20140417	
	
	function createPDF(){
        var sObjectNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert("��ѡ��һ����¼��");
			return;
		}
		var ssuretype = RunMethod("���÷���", "GetColValue", "Business_Contract,SureType,SerialNo='"+sObjectNo+"'");
	    if (ssuretype.indexOf("PC", 0) >= 0) {
	        alert("�ú�ͬ�ǵ��Ӻ�ͬ!");
	        return;
	    }
	    //ͨ����serverlet ��ҳ��
	    var CurOpenStyle = "width=720,height=540,top=20,left=20,toolbar=no,scrollbars=yes,resizable=yes,status=yes,menubar=no,";  
	    if(ssuretype == 'APP'){
		    window.open("<%=sAPPUrl4pdf%>"+sObjectNo,"_blank",CurOpenStyle);
	    }else if(ssuretype == 'JQM'){
		    window.open("<%=sJQMUrl4pdf%>"+sObjectNo,"_blank",CurOpenStyle);
	    }else if(ssuretype == 'FC'){
	    	window.open("<%=sFCUrl4pdf%>"+sObjectNo,"_blank",CurOpenStyle);
	    }
	 }
		
	 function createSxhPDF(){
        var sObjectNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert("��ѡ��һ����¼��");
			return;
		}
        var ssuretype = RunMethod("���÷���", "GetColValue", "Business_Contract,SureType,SerialNo='"+sObjectNo+"'");
	    if (ssuretype.indexOf("PC", 0) >= 0) {
	        alert("�ú�ͬ�ǵ��Ӻ�ͬ!");
	        return;
	    }
	    var bugpaypkgind = RunMethod("���÷���", "GetColValue", "business_contract,bugpaypkgind,serialno='"+sObjectNo+"'");
		if(typeof(bugpaypkgind)=="undefined" || bugpaypkgind.length==0 || bugpaypkgind == "0"){
	        alert("�ú�ͬû�й������Ļ������!");
	        return;
		}
	    //ͨ����serverlet ��ҳ��
	    var CurOpenStyle = "width=720,height=540,top=20,left=20,toolbar=no,scrollbars=yes,resizable=yes,status=yes,menubar=no,";  
	    if(ssuretype == 'APP'){
	    	window.open("<%=sAPPUrl4Sxhpdf%>"+sObjectNo,"_blank",CurOpenStyle);
	    }else if(ssuretype == 'FC'){
	    	window.open("<%=sFCUrl4Sxhpdf%>"+sObjectNo,"_blank",CurOpenStyle);
	    }
	}
	 
	function createPhoto(){
   		var sObjectNo = getItemValue(0,getRow(),"SerialNo");
	    var ssuretype = getItemValue(0,getRow(),"SureType");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert("��ѡ��һ����¼��");
			return;
		}
	   	if (ssuretype.indexOf("PC", 0) >= 0) {
	        alert("�ú�ͬ�ǵ��Ӻ�ͬ!");
	        return;
	    }
	    //ͨ����serverlet ��ҳ��
	    var CurOpenStyle = "width=720,height=540,top=20,left=20,toolbar=no,scrollbars=yes,resizable=yes,status=yes,menubar=no,";  
	    window.open("<%=sAPPUrl4photo%>"+sObjectNo,"_blank",CurOpenStyle);
	}
	  
	function createAudio(){
		var sObjectNo = getItemValue(0,getRow(),"SerialNo");
		var ssuretype = getItemValue(0,getRow(),"SureType");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert("��ѡ��һ����¼��");
			return;
		}
		if (ssuretype.indexOf("PC", 0) >= 0) {
	        alert("�ú�ͬ�ǵ��Ӻ�ͬ!");
	        return;
	    }
	    //ͨ����serverlet ��ҳ��
	    var CurOpenStyle = "width=720,height=540,top=20,left=20,toolbar=no,scrollbars=yes,resizable=yes,status=yes,menubar=no,";  
	    window.open("<%=sAPPUrl4record%>"+sObjectNo,"_blank",CurOpenStyle);
	}
	/*~[Describe=��ӡ��ʽ������;InputParam=��;OutPutParam=��;]~*/
	function printTable(type){
		
			var sObjectNo = getItemValue(0,getRow(),"SerialNo");
			var sUserID = "<%=CurUser.getUserID()%>";
			var sOrgID = "<%=CurOrg.getOrgID()%>";
			if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
				alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
				return;
			}
			//CCS-316 ��Ҫ���ݺ�ͬ״̬���ƿ��ٲ�ѯ��İ�ť     add by Roger 2015/03/09
			var sContractStatus=getItemValue(0,getRow(),"ContractStatus");
			    if(sContractStatus == "060" || sContractStatus == "070"){   //�·���������к�ͬ����admin�������˶����ܴ�ӡ��ͬ
			    	//������Ա��ɫ�����Ȩ 
			    	if(!<%=CurUser.hasRole(new String[]{"000","099","1000"})%>){
			    		alert("ֻ�й���Ա���ܵ��ĸñʺ�ͬ");
			    		return;
			    	}
		    }
			
			/* var  returnValue = RunJavaMethodSqlca("com.amarsoft.app.billions.DocCommon","getDocID","serialNo="+sObjectNo+",type="+type);
			if (typeof(returnValue)=="undefined" || sObjectNo.returnValue==0){
				alert("����ϵϵͳ����Ա����ͬģ������");
				return;
			} */
			var sObjectType = type;
			if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
				alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
				return;
			}else{
				//������֪ͨ���Ƿ��Ѿ�����
				var sReturn = PopPageAjax("/FormatDoc/GetReportFile.jsp?DocID="+sDocID+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType,"","");
				if(sReturn == "move"){
					//alert("��ǰ���ɵ��ļ��Ѿ����ƶ��ˣ��޷�չʾ��Ҳ������������");
					return;
				}else if (sReturn == "false"){ //δ���ɳ���֪ͨ��
					var returnValue = RunJavaMethodSqlca("com.amarsoft.app.billions.DocCommon","getDocIDAndUrl","serialNo="+sObjectNo+",type="+type);
					if(returnValue=="False"||typeof(returnValue)=="undefined"||returnValue.length==0){
						alert("����ϵϵͳ����Ա����ͬģ�����úͺ�ͬ��Ϣ!");
						return;
					}
					var sDocID = 	returnValue.split("@")[0];
					var sUrl = returnValue.split("@")[1];
					var sSerialNo = getSerialNo("FORMATDOC_RECORD", "SerialNo", "TS");
					//���ɳ���֪ͨ��	
						PopPage(sUrl+"?DocID="+sDocID+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType+"&SerialNo="+sSerialNo+"&Method=4&FirstSection=1&EndSection=0&rand="+randomNumber(),"myprint10","dialogWidth=10;dialogHeight=1;status:no;center:yes;help:no;minimize:yes;maximize:no;border:thin;statusbar:no");
					//��¼���ɶ���
					RunJavaMethodSqlca("com.amarsoft.app.billions.InsertFormatDocLog", "recordFormatDocLog", "serialNo="+sSerialNo+",orgID="+sOrgID+",userID="+sUserID+",occurType=produce");
				}else{
					//��¼�鿴����
					RunJavaMethodSqlca("com.amarsoft.app.billions.InsertFormatDocLog", "recordFormatDocLog", "serialNo="+sReturn+",orgID="+sOrgID+",userID="+sUserID+",occurType=view");
				}
				//��ü��ܺ�ĳ�����ˮ��
				var sEncryptSerialNo = PopPageAjax("/PublicInfo/EncryptSerialNoAction.jsp?EncryptionType=MD5&SerialNo="+sObjectNo);
				//ͨ����serverlet ��ҳ��
				var CurOpenStyle = "width=720,height=540,top=20,left=20,toolbar=no,scrollbars=yes,resizable=yes,status=yes,menubar=no,";	
				//+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType  add by cdeng 2009-02-17	
				OpenPage("/FormatDoc/POPreviewFile.jsp?EncryptSerialNo="+sEncryptSerialNo+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType,"_blank02",CurOpenStyle); 
			}
	}
	
	/*~[Describe=��ӡ���Ļ�����������;InputParam=��;OutPutParam=��;]~*/
	function printSuiXinHuan(){

		var sObjectNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		
		var sContractStatus=getItemValue(0,getRow(),"ContractStatus");
	    if(!(sContractStatus == "020" || sContractStatus == "050" || sContractStatus == "080")){ 
	    	alert("ֻ������ͨ������ǩ�����ע��ĺ�ͬ���ܵ��ģ�");
    		return;
	    }
	    
	    var sBugPayPkgind = RunMethod("���÷���", "GetColValue", "business_contract,BugPayPkgind,serialno='"+sObjectNo+"'");
		if (typeof(sBugPayPkgind)=="undefined" || sBugPayPkgind.length==0 || (sBugPayPkgind!="1" && sBugPayPkgind!="2")){
			alert("�ú�ͬδ�������Ļ������!");
			return;
		}
		
		var sUrl = "/FormatDoc/Report17/ApplySuiXinHuan.jsp?ObjectNo="+sObjectNo;
		var CurOpenStyle = "width=720,height=540,top=20,left=20,toolbar=no,scrollbars=yes,resizable=yes,status=yes,menubar=no,";	
		OpenPage(sUrl,"_blank02",CurOpenStyle); 

	}
	//   ============================== end  ��ӡ��ʽ������ ============================================================
	
		
	/*~[Describe= �鿴���Ӻ�ͬ;]~*/
    function viewApplyReport(){
    		printTable("ApplySettle");
    }
	
	/*~[Describe=��ӡ������Э��;]~*/
	function creatThirdTable(){
			printTable("ThirdSettle");
	}
	
	/*~[Describe=��ӡ���������;]~*/
	function printApprove(){
			printTable("ApproveSettle");
	}
	
	/*~[Describe= ��ӡ����С��ʿ;]~*/
	function printRemind(){
			printTable("CreditSettle");
	}
	
	/*~[Describe= ��ӡ�۱�������;]~*/
	function printBaiBaoDai(){
		var sObjectNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		
		var sBusinessType2 = RunMethod("���÷���", "GetColValue", "business_contract,BusinessType2,serialno='"+sObjectNo+"'");
		if (typeof(sBusinessType2)=="undefined" || sBusinessType2.length==0 || sBusinessType2!="2015061500000017"){
			alert("�ú�ͬδ����۱���!");
			return; 
		}
		printTable("BaiBaoDai");
	}
	

	/*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=SerialNo;]~*/
	function viewAndEdit()
	{
		//���ҵ����ˮ��
		sSerialNo =getItemValue(0,getRow(),"SerialNo");	
		
	    sObjectType = "BusinessContract";
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
		}else
		{
			sCompID = "CreditTab";
    		sCompURL = "/CreditManage/CreditApply/ObjectTab.jsp";
    		sParamString = "ObjectType="+sObjectType+"&ObjectNo="+sSerialNo;
    		OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
		}

	}
	
	function CreditSettle(){
		sObjectNo =getItemValue(0,getRow(),"SerialNo");	
		sObjectType = "CreditSettle";
		sContractStatus = getItemValue(0,getRow(),"ContractStatus");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
		{
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
		}else if(sContractStatus!='160'){
			alert("�ñʺ�ͬδ���壡");
			return;
		} 
		sCompID = "CreditSettleApplyInfo";
		sCompURL = "/InfoManage/QuickSearch/CreditSettleApplyInfo.jsp";
		//sCompURL = "/SystemManage/SynthesisManage/ChangeCustomerInfo.jsp";
		sParamString = "SerialNo="+sObjectNo;
		sReturn = popComp(sCompID,sCompURL,sParamString,"dialogWidth=700px;dialogHeight=560px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		
	}
 
    //�˿��ѯ
    function RefundFind(){
    	//������
    	sCustomerID =getItemValue(0,getRow(),"CustomerID");
		
		if (typeof(sCustomerID)=="undefined" || sCustomerID.length==0)
		{
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
		}
    	var sReturn=RunMethod("BusinessManage","CustomerDeposits",sCustomerID);
		if(sReturn<=0 || sReturn=="Null"){
			alert("�ÿͻ�����ûԤ���,�����˿�");
			return;
		}		
		
		sCompID = "RefundApplyList";
		sCompURL = "/InfoManage/QuickSearch/RefundApplyList.jsp";
		popComp(sCompID,sCompURL,"CustomerID="+sCustomerID,"dialogWidth=700px;dialogHeight=560px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");

    }
    
    //�����˺ű��
    function withholdChange(){
    	//������
    	sSerialNo = getItemValue(0,getRow(),"SerialNo");
    	//�ͻ�����
    	sCustomerName = getItemValue(0,getRow(),"CustomerName");
    	sCustomerID = getItemValue(0,getRow(),"CustomerID");//�ͻ���
    	//���֤��
    	sCertID = getItemValue(0,getRow(),"CertID");
    	//�ֻ���
    	sMobilePhone = getItemValue(0,getRow(),"MobilePhone");
    	//�����˻�����
    	sReplaceName = getItemValue(0,getRow(),"ReplaceName");
    	//�����˺�
    	sReplaceAccount = getItemValue(0,getRow(),"ReplaceAccount");
    	//�����˻�������
    	sOpenBank = getItemValue(0,getRow(),"OpenBank");
    	
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
		}else if (confirm("ȷ���Ѿ��յ��ͻ���Ȩ�ĸ��Ļ����������˻���Ȩ�飿"))
    	{			
			//add by huanghui ccs-789 withhold_charge_info����ֻҪcount�м�¼���Ϳ��Է��������
		 	var count = RunMethod("BusinessManage","CheckChangeBusiness",sSerialNo);
			var sReturn;
			if(count == 0){
				//withhold_charge_info����
				sReturn = RunMethod("BusinessManage","InsertChangeInfo4Dkzhbg",sSerialNo+","+sMobilePhone);
			}else{
				/* alert("��ǰ�ͻ���ͬ������;�Ĵ����˻���������������ٴη��������룡");
				return; */
				sReturn = RunMethod("���÷���","GetColValue","withhold_charge_info,SerialNo,contractserialno='"+sSerialNo+"' and applicationtype = '01' and status = '01' " );//��ˮ��
			}		 
			if( typeof(sReturn)!="undefined"&&sReturn != null){
				<%-- if(<%=CurUser.hasRole(new String[]{"000","099","1000","1036","1039"})%>){ --%>
					sCompID = "ChargeApplyInfo";
	                sCompURL = "/InfoManage/QuickSearch/ChargeApplyInfo.jsp";
	                sParamString = "SerialNo="+sReturn+"&ContractSerialNo="+sSerialNo;
					sReturn = popComp(sCompID,sCompURL,sParamString,"dialogWidth=700px;dialogHeight=560px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
				/* }else{
					alert("��������ѷ����뵽�ͻ���Ϣ��ѯ�н��д����˻����������");
				} */
			}
		} 
    }
    
    
    
    
    /*~[Describe=Ӱ�����;InputParam=��;OutPutParam=��;]~*/
    function imageManage(){
        var sObjectNo   = getItemValue(0,getRow(),"SerialNo");
        if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
            alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
            return;
        }
        //��֤��ͬ��Ʒ�Ƿ��Ѿ���Ӱ������������
		var sBusinessType = RunMethod("���÷���", "GetColValue", "Business_Contract,BusinessType,SerialNo='"+sObjectNo+"'");
     	var sAmount = RunMethod("���÷���","GetColValueTables","product_ecm_type,product_type_ctype,count(1),product_ecm_type.PRODUCT_TYPE_ID = product_type_ctype.PRODUCT_TYPE_ID and product_type_ctype.PRODUCT_ID ='"+sBusinessType+"' ");
		if(sAmount == 0){
			alert("��������ƷӰ�����������øò�Ʒ��Ӧ��Ӱ���ļ���");
			return false;
		}
   var param = "ObjectType=Business&TypeNo=20&ObjectNo="+sObjectNo+"&uploadPeriod=2";
   AsControl.PopView( "/ImageManage/ImageViewNew.jsp", param, "" );
    }
    
    /*~[Describe=��ǰ�����ѯ;InputParam=��;OutPutParam=SerialNo;]~*/
	function SelectPrepayment()
	{
		//��ȡ��ͬ�ţ����֤��
		sSerialNo =getItemValue(0,getRow(),"SerialNo");	
		sCertID =getItemValue(0,getRow(),"CertID");	
		sCustomerID =getItemValue(0,getRow(),"CustomerID");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
		}else
		{
			 var sReturn=RunMethod("BusinessManage","PrepaymentLoanCount",sSerialNo);
			if(sReturn==0){
				alert("�ñʺ�ͬ��������ǰ����");
				return;
			}
			
			 var sReturn=RunMethod("BusinessManage","PrepaymentLoanCount1",sCustomerID);
				if(sReturn>0){
					alert("�ÿͻ����������ں�ͬ,��������ǰ����");
					return;
				}
			AsControl.OpenView("/CustomService/BusinessConsult/PaymentApplyList.jsp","SerialNo="+sSerialNo+"&CertID="+sCertID,"_blank","dialogWidth=200px;dialogHeight=200px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		}

	}
    
	
	
	/*********************************�˱�����************/
	function cancellationInsurance(){
		sSerialNo =getItemValue(0,getRow(),"SerialNo");	
		sCustomerName = getItemValue(0,getRow(),"CustomerName");
		sBusinessSum = getItemValue(0,getRow(),"BusinessSum");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
		}else{
				var status=	RunJavaMethodSqlca("com.amarsoft.app.billions.UpdateMinanSerialNo", "selctMinanSerialNo","serialNo="+sSerialNo);
				//�ж��Ƿ�Ͷ��״̬
				if(status =='F' ){
						alert("�ú�ͬ�������˱�����");
						return ;
				}
				//�ж��Ƿ�Ͷ��״̬
				if(status =='F1' ){
						alert("�ú�ͬ������ǰ��� �����˱�");
						return ;
				}
				//�ж��Ƿ�Ͷ��״̬
				if(status =='F2' ){
						alert("�����˻��еĺ�ͬ�������˱�");
						return ;
				}			
				//�ж��Ƿ�Ͷ��״̬
				if(status =='F3' ){
						alert("���ڳ���90�첢��ϵͳ�Ѿ����ܷ��õĺ�ͬ�������˱�");
						return ;
				}	
				//�ж��Ƿ�Ͷ��״̬
				if(status =='F4' ){
						alert("�ú�ͬ�Ѿ����壬�����˱�");
						return ;
				}
				//�ж��Ƿ��Ѿ��˱�
				if(status =='F5' ){
						alert("�ú�ͬ�Ѿ��˱����������˱�");
						return ;
				}
				//CCS-953 ��ǰ����˻������ü����໥�ж��Ƿ��н��׽�����
				var returnValue = RunJavaMethodSqlca("com.amarsoft.app.lending.bizlets.PayMentRevisionSchedule","validate","contractSerialNo="+sSerialNo+"");
				if(returnValue!="0"){
					alert(returnValue);
					return;
				}//CCS-953 end
			   var sCompID = "CancellationInsuranceInfo";
			    // ����һ��ҳ��  �������»���ƻ���ֵ��
				var sCompURL = "/InfoManage/QuickSearch/CancellationInsurance.jsp";	 
				popComp(sCompID,sCompURL,"sSerialNo="+sSerialNo,"dialogWidth=550px;dialogHeight=450px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		}
	}
	
	
	/*~[Describe= �˻�����;InputParam=��;OutPutParam=SerialNo;]~*/
	function returnApply()
	{
		//���ҵ����ˮ��
		sSerialNo =getItemValue(0,getRow(),"SerialNo");	
		sCustomerName = getItemValue(0,getRow(),"CustomerName");
		sBusinessSum = getItemValue(0,getRow(),"BusinessSum");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
		}else
		{
			//�Ƿ����Ѵ�
		   var sResult=RunMethod("BusinessManage","LoanProductType",sSerialNo);
			if(sResult==0){
				alert("�ñʺ�ͬ�������Ѵ���Ʒ���������˻�����");
				return;
			} 
			var sReturn=RunMethod("BusinessManage","LoanCount",sSerialNo);
			if(sReturn==0){
				alert("�ñʺ�ͬ�������˻�����");
				return;
			}
			//�Ƿ�����ԥ����
			var sReturn=RunMethod("BusinessManage","HesitateDay",sSerialNo);
			if(sReturn==0){
				alert("�ñʺ�ͬ�ѳ�����ԥ����,�������˻�����");
				return;
			}  
			var sLoanSerialNo = RunMethod("PublicMethod","GetColValue","SerialNo,ACCT_LOAN,String@PutOutNo@"+sSerialNo);
			var relativeObjectType = "jbo.app.ACCT_LOAN";
			//CCS-953 ��ǰ����˻������ü����໥�ж��Ƿ��н��׽�����
			var returnValue = RunJavaMethodSqlca("com.amarsoft.app.lending.bizlets.PayMentRevisionSchedule","validate","contractSerialNo="+sSerialNo+"");
			if(returnValue!="0"){
				alert(returnValue);
				return;
			}//CCS-953 end
			
			sCompID = "BusinessRefundCargo";
			sCompURL = "/InfoManage/QuickSearch/BusinessRefundCargo.jsp";
			sParamString = "SerialNo="+sSerialNo+"&CustomerName="+sCustomerName+"&BusinessSum="+sBusinessSum+"&";
			OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
			reloadSelf();
		}

	} 
	
	
	/*~[Describe= �����ٴδ���;InputParam=��;OutPutParam=SerialNo;]~*/
	function sponsorAgainWithhold()
	{
		//��ͬ���
    	sSerialNo = getItemValue(0,getRow(),"SerialNo");
    	sCustomerID = getItemValue(0,getRow(),"CustomerID");
    	sCustomerName = getItemValue(0,getRow(),"CustomerName");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
		}
		
		var sparas = "sContractSerialNo="+sSerialNo;
		var sReturnValue = RunJavaMethodSqlca("com.amarsoft.app.lending.bizlets.AgainWithholdCheck", "runTransaction",sparas);
		
		if(sReturnValue.split("@")[0]=="false"){
			alert(sReturnValue.split("@")[1]);
			return;
		}else{
			var payAmount = sReturnValue.split("@")[1];
			var sLoanSerialNo = sReturnValue.split("@")[2];
			var outsourcingCollection=sReturnValue.split("@")[3];
			
			sCompID = "SponsorAgainWithhold";
			sCompURL = "/InfoManage/QuickSearch/SponsorAgainWithhold.jsp";
    	 	sReturn = popComp(sCompID,sCompURL,"PayAmount="+payAmount+"&LoanSerialNo="+sLoanSerialNo+"&CustomerID="+sCustomerID+"&CustomerName="+sCustomerName+"&PutOutNo="+sSerialNo+"&OutsourcingCollection="+outsourcingCollection,"dialogWidth=550px;dialogHeight=450px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		}
	}
	
	function ShowMessage1(str,showGb,clickHide){
		
		//����ͨ�����������жϴ����Ƿ��Ѵ�
		//��ȡ�滻����ȡ���Ĳ����������ظ���
		//��ʾ���־����𳬹�2��,��Ϊ����iframe��̬�߶Ȳ�֪����ôŪ��
//		alert(1);
	 	if(document.getElementById("msgDiv"))
			return ;	 	

		var msgw=300;//��Ϣ��ʾ���ڵĿ��
		var msgh=125;//��Ϣ��ʾ���ڵĸ߶�
		var scrollTop = document.body.scrollTop+document.body.clientHeight*0.4+"px";
		
		//**���Ʊ�����**/	
		var bgObj=document.createElement("div");
		bgObj.setAttribute('id','bgDiv');
		bgObj.className = "message_bg";

		//�����㶯�� ����ر�
		if(clickHide)
			bgObj.onclick=hideMessage;
		if(showGb)
			document.body.appendChild(bgObj);
		
		//**������Ϣ��**/
		var msgObj=document.createElement("div");
		msgObj.setAttribute("id","msgDiv");
		msgObj.setAttribute("align","center");
		msgObj.className = "message_div";
		
		msgObj.style.top= scrollTop; //"40%";
		msgObj.style.marginTop = -75+document.documentElement.scrollTop+"px";
		msgObj.style.width = msgw + "px";
		msgObj.style.height =msgh + "px";
		
		document.body.appendChild(msgObj);
		
		//**���Ʊ����**/ ����ر�
		var title=document.createElement("h4");
		title.setAttribute("id","msgTitle");
		title.setAttribute("align","left");
		title.className = "message_title";
		
		title.innerHTML="ϵͳ������...";
		if(clickHide){
			title.innerHTML="�ر�";
			title.style.cursor="pointer";			
			title.onclick = hideMessage;
		}	
		
		document.getElementById("msgDiv").appendChild(title);
		
		//**�����ʾ��Ϣ**/
		str = "<br>"+str.replace(/\n/g,"<br>");
		var txt=document.createElement("p");
		txt.style.margin="1em 0";
		txt.setAttribute("id","msgTxt");
		txt.innerHTML=str;
		document.getElementById("msgDiv").appendChild(txt);
	}	
	
	//΢�Ž��������ѯ
    function showWeChatResult(){
    	//������
    	sCustomerID =getItemValue(0,getRow(),"CustomerID");
		
		if (typeof(sCustomerID)=="undefined" || sCustomerID.length==0)
		{
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
		}
		
		sCompID = "WeChatResultList";
		sCompURL = "/InfoManage/QuickSearch/WeChatResultList.jsp";
		popComp(sCompID,sCompURL,"CustomerID="+sCustomerID,"dialogWidth=1020px;dialogHeight=600px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");

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