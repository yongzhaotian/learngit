<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


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
	String PG_TITLE = "RPM��ͬ��Ϣ���ٲ�ѯ"; // ��������ڱ��� <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;RPM��ͬ��Ϣ���ٲ�ѯ&nbsp;&nbsp;";
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
	/**
	Map<String, String> roleClauseMap = new HashMap<String, String>();
	//�ŵ���г��о���ά���������۾�����ϼ�ȡ�� edit by Dahl 2015-3-20
	roleClauseMap.put("1003", " stores in (select sno from store_info si ,user_info ui where si.salesmanager=ui.userId and ui.superid IN (SELECT ATTR3 FROM BASEDATASET_INFO WHERE TYPECODE='CityCode' AND ATTRSTR2 IN (SELECT ACBI.ATTR1 FROM BASEDATASET_INFO ACBI WHERE TYPECODE='AreaCode' AND ATTR3='"+CurUser.getUserID()+"'))) ");
	//roleClauseMap.put("1004", " stores in (select sno from store_info where citymanager='"+CurUser.getUserID()+"') ");
	roleClauseMap.put("1004", " stores in (select sno from store_info si ,user_info ui where si.salesmanager=ui.userId and ui.superid='"+CurUser.getUserID()+"') ");
	roleClauseMap.put("1005", " stores in (select sno from store_info where salesmanager='"+CurUser.getUserID()+"') ");
	roleClauseMap.put("1006", " SALESEXECUTIVE='"+ CurUser.getUserID() +"' ");
	List roleList = CurUser.getRoleTable();
	String sRoleWhereClause = "";
	boolean isBaimingdan = false;
	for (int i=0; i<roleList.size(); i++) {
		String sAndOr = "".equals(sRoleWhereClause)? " and ( ": " or ";
		if (roleClauseMap.containsKey(roleList.get(i))) {
			sRoleWhereClause += sAndOr + roleClauseMap.get(roleList.get(i));
		}
		if("1005".equals(roleList.get(i))||"1006".equals(roleList.get(i))){
			isBaimingdan = true;
		}
	}
	if(isBaimingdan){
		doTemp.WhereClause +=   " and (bc.isbaimingdan <> '1' or bc.isbaimingdan is null) ";
	}
	**/
	//��������ʱ��Ϊ�����ؼ�
	doTemp.setCheckFormat("InputTime", "3");
	//�����ᵥʱ��Ϊ�����ؼ�
	doTemp.setCheckFormat("SALESUBMITTIME", "3");
	//���ش��������ϴ�״̬
	doTemp.setVisible("uploadFlag", false);
	/**
	if (!"".equals(sRoleWhereClause)) {
		doTemp.WhereClause += sRoleWhereClause + ")";
	}
	**/
	doTemp.WhereClause +=  " and  bc.OperatorMode = '02'";
	
	//���ɲ�ѯ��
	doTemp.setFilter(Sqlca, "0010", "SerialNo", "Operators=EqualsString,BeginsWith;");
	doTemp.setFilter(Sqlca, "0020", "CustomerID", "Operators=EqualsString;");
	doTemp.setFilter(Sqlca, "0030", "CustomerName", "Operators=EqualsString,BeginsWith;");
	doTemp.setFilter(Sqlca, "0033", "CertID", "Operators=EqualsString,BeginsWith;");
	doTemp.setFilter(Sqlca, "003310", "MobilePhone", "Operators=EqualsString,BeginsWith;");
	//����ᵥʱ����Ϊ��ѯ����CCS-776
	doTemp.setFilter(Sqlca, "003313", "SALESUBMITTIME", "Operators=BeginsWith;");
	//doTemp.setFilter(Sqlca, "003314", "InputTime", "Operators=BetweenString,BeginsWith;");
	doTemp.setFilter(Sqlca, "003315", "SignedDate", "Operators=EqualsString,BeginsWith;");
	doTemp.setFilter(Sqlca, "003320", "RegistrationDate", "Operators=EqualsString,BeginsWith;");
	doTemp.setFilter(Sqlca, "0035", "SubProductType", "Operators=EqualsString;");
	//doTemp.setFilter(Sqlca, "0040", "BusinessType", "Operators=EqualsString;");
	doTemp.setFilter(Sqlca, "0044", "ProductID", "Operators=EqualsString;");
	//doTemp.setFilter(Sqlca, "0045", "OperateModeName", "Operators=EqualsString,BeginsWith;");
	doTemp.setFilter(Sqlca, "0180", "ContractStatus", "Operators=EqualsString;");
	//doTemp.setFilter(Sqlca, "019001", "QualityGrade", "Operators=EqualsString;");
// 	doTemp.setFilter(Sqlca, "0200", "RetailID", "Operators=EqualsString,BeginsWith;");
 	//doTemp.setFilter(Sqlca, "0210", "Stores", "Operators=EqualsString,BeginsWith;");
 	//doTemp.setFilter(Sqlca, "0235", "Salesexecutive", "Operators=EqualsString;");
// 	doTemp.setFilter(Sqlca, "0241", "SalesManager", "Operators=EqualsString;");
// 	doTemp.setFilter(Sqlca, "0256", "StoreCityCode", "Operators=EqualsString;");
	//doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	//�жϷ��ϸ������Ƿ����ݱȽ϶࣬Ӱ���ѯ����
		boolean flag = false;
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
			{"true","","Button","��ӡ���Ӻ�ͬ","��ӡ���Ӻ�ͬ����","viewApplyReport()",sResourcesPath},
			{"true","","Button","��ӡ������Э��","��ӡ������Э��","creatThirdTable()",sResourcesPath},
			{"true","","Button","��ӡ����С��ʿ","��ӡ����С��ʿ","printRemind()",sResourcesPath},
			{"true","","Button","��ӡ������","��ӡ������","printApprove()",sResourcesPath},
			{"true","","Button","��ӡ����թ��ʾ","��ӡ����թ��ʾ","printRishTip()",sResourcesPath},
			{"true","","Button","���Ļ�����������","���Ļ�����������","printSuiXinHuan()",sResourcesPath},
			{"true","","Button","��ӡ�۱�����ͬ","��ӡ�۱�����ͬ","printBaiBaoDai()",sResourcesPath},
			{"true","","Button","����EXCEL","����EXCEL","exportExcel()",sResourcesPath},

	};
	%> 
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">
	//---------------------���尴ť�¼�------------------------------------
	
	//Excel����������	
	function exportExcel(){
		<%
			//����Excelʱֻ������Ӧ���ֶ�CSS-776
			doTemp.setVisible("CustomerID,CertID,RepaymentNo,MobilePhone,SignedDate,RegistrationDate,RejectedDate,ProductID,BusinessType,BusinessTypeName,BusinessTypeName1,OperateModeName,SubProductType,SubProductTypeName,ProductName,TotalPrice,MonthRepayment,ReplaceAccount,RepaymentWay,CreditAttribute,CreditAttributeName,QualityGrade,QualityGradeName,QualityTagging,RetailID,OrgName,PutoutFlag,SalesManager,CityName,uploadFlag,dayrange,SureType", false);
			doTemp.setVisible("SerialNo,CustomerName,InputTime,InputDate,TotalSum,BusinessSum,Periods,Stores,sStoreName,SalesexecutiveName,Salesexecutive,SaleManagerName,StoreCityName,ContractStatusName",true);
			dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
			dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
			dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
			dwTemp.setPageSize(16);  //��������ҳ
			dwTemp.genHTMLDataWindow("");
		%>
		
		amarExport("myiframe0");
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
	
	/*~[Describe= ��ӡ�۱�����ͬ;]~*/
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
	
	/*~[Describe=��ӡ�����պ�;InputParam=��;OutPutParam=��;]~*/
	function printRishTip(){

		var sObjectNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		var CurOpenStyle = "width=720,height=540,top=20,left=20,toolbar=no,scrollbars=yes,resizable=yes,status=yes,menubar=no,";	
		var  returnValue = RunJavaMethodSqlca("com.amarsoft.app.billions.DocCommon","getDocIDAndUrl","serialNo="+sObjectNo+",type=RishSettle");
		if(returnValue=="False"||typeof(returnValue)=="undefined"||returnValue.length==0){
			alert("����ϵϵͳ����Ա����ͬģ�����úͺ�ͬ��Ϣ!");
			return;
		}
		var sDocID = returnValue.split("@")[0];
		var sUrl = returnValue.split("@")[1];
		//add by daihuafeng 20150708 ----begin �ഫһ�����������Ƶ�ҵ����Դ��APPʱ�ͻ�ǩ����URLǩ��
		sUrl = sUrl+"?ObjectNo="+sObjectNo;
		//add by daihuafeng 20150708 ----end
		
		OpenPage(sUrl,"_blank02",CurOpenStyle); 

	}
	
//  ==============================  ��ӡ��ʽ������  ��������  add by yzhang9    ============================================================
	
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
			 
		    if(!(sContractStatus == "020" || sContractStatus == "050" || sContractStatus == "080")){ 
		    	alert("ֻ������ͨ������ǩ�����ע��ĺ�ͬ���ܵ��ģ�");
	    		return;
		    }
			
			var  returnValue = RunJavaMethodSqlca("com.amarsoft.app.billions.DocCommon","getDocIDAndUrl","serialNo="+sObjectNo+",type="+type);
				if(returnValue=="False"||typeof(returnValue)=="undefined"||returnValue.length==0){
					alert("����ϵϵͳ����Ա����ͬģ�����úͺ�ͬ��Ϣ!");
					return;
				}
				var sDocID = returnValue.split("@")[0];
				var sUrl = returnValue.split("@")[1];
				var sObjectType = type;
			var sSerialNo = getSerialNo("FORMATDOC_RECORD", "SerialNo", "TS");
			if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
				alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
				return;
			}else{
				//������֪ͨ���Ƿ��Ѿ�����
				var sReturn = PopPageAjax("/FormatDoc/GetReportFile.jsp?DocID="+sDocID+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType,"","");
				if (sReturn == "false"){ //δ���ɳ���֪ͨ��
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