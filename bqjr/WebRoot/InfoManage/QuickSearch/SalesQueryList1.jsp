<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author:
		Tester:
		Content: �������ݲ�ѯ
		Input Param:
		Output param:
		History Log: 
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "�������ݲ�ѯ"; // ��������ڱ��� <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;�������ݲ�ѯ&nbsp;&nbsp;";
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%
	//�������
	String sSql = "";//--���sql���
	String doWhere="";
    ASResultSet rs = null;
    ASResultSet rs1 = null;
    ASResultSet rs2 = null;
    String roleID="";
	//����������	
	
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%	
	String userID=CurUser.getUserID();
	//String userID="200548";
	StringBuffer sb=new StringBuffer();
	StringBuffer snos=new StringBuffer();//�ŵ� ƴ�� 
	rs=Sqlca.getASResultSet(new SqlObject("select roleid from user_role where userid=:userid order by roleid").setParameter("userid", userID));
	while(rs.next()){
		roleID=rs.getString("roleid");
		//�����½��ԱΪ���о���
		if("1004".equals(roleID)){
			//�ŵ���г��о���ά���������۾�����ϼ�ȡ�� edit by Dahl 2015-3-20
	 	    //doWhere =" and exists (select sno from store_info si where citymanager='"+userID+"' and si.sno=bc.stores)";
	 	    doWhere =" and exists (select sno from store_info si ,user_info ui where si.salesmanager=ui.userId and ui.superid='"+userID+"' and si.sno=bc.stores)  and (bc.isbaimingdan <> '1' or bc.isbaimingdan is null) ";
	//		rs2=Sqlca.getASResultSet(new SqlObject("select sno from store_info where citymanager=:citymanager").setParameter("citymanager", userID));
	//		while(rs2.next()){
	//			snos.append("'"+rs2.getString("sno")+"',");
	//		}
	//		if(snos.toString().equals("")){
    //	        doWhere=" and 1=2 ";
	//       }else{
	//	      doWhere=" and stores in("+snos.toString().substring(0,snos.toString().length()-1)+")";
	//       }
	//		rs2.getStatement().close();
		    break;
		}
		
		//�����½��ԱΪ���۾��� 
		if("1005".equals(roleID)){
			doWhere =" and exists (select sno from store_info si where salesmanager='"+userID+"' and si.sno=bc.stores)    and (bc.isbaimingdan <> '1' or bc.isbaimingdan is null) ";
//			rs1=Sqlca.getASResultSet(new SqlObject("select sno from store_info where salesmanager=:salesmanager").setParameter("salesmanager", userID));
//			while(rs1.next()){
//		    		snos.append("'"+rs1.getString("sno")+"',");
//		    	}
//		  	    if(snos.toString().equals("")){
//	    	        doWhere=" and 1=2 ";
//		        }else{
//		 	       doWhere=" and stores in("+snos.toString().substring(0,snos.toString().length()-1)+")";
//		        }
//			    	rs1.getStatement().close();
		         break;
		}
	
		//�����¼��Ϊ���۴��� 
	    if("1006".equals(roleID)){
	    	sb.append("'"+userID+"'");
	    	doWhere=" and inputuserid in ("+sb.toString()+")" + "   and (bc.isbaimingdan <> '1' or bc.isbaimingdan is null) ";
	    	break;
	    }
		
	}
	rs.getStatement().close();

     
	//����sSql�������ݶ���

	String sTempletNo = "SalesQueryList"; //ģ����
    ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	//�����������ڸ�ʽ
    doTemp.setCheckFormat("InputDate", "3");
	doTemp.setVisible("CityName", false);
	//doTemp.setKeyFilter("SerialNo");
	//���ɲ�ѯ��
	//doTemp.generateFilters(Sqlca);
	//�����ŵ���롢���۴���ID����ͬ���롢�ͻ����롢�ͻ����ơ����֤�����ѯ������by huanghui 20151014
	doTemp.setFilter(Sqlca, "0010", "SerialNo", "Operators=EqualsString,BeginsWith;");
	doTemp.setFilter(Sqlca, "0021", "CustomerID", "Operators=EqualsString;");
	doTemp.setFilter(Sqlca, "0020", "CustomerName", "Operators=EqualsString;");// �����汾  CCS-1314_CCS-1312 V2_20160316   ��Ϊֻ����"����"  doTemp.setFilter(Sqlca, "0020", "CustomerName", "Operators=EqualsString,BeginsWith;");
	doTemp.setFilter(Sqlca, "0022", "CertID", "Operators=EqualsString;");// �����汾 CCS-1314_CCS-1312 V2_20160316  ��Ϊֻ����"����" doTemp.setFilter(Sqlca, "0022", "CertID", "Operators=EqualsString,BeginsWith;");
	
	doTemp.setFilter(Sqlca, "0030", "InputDate", "Operators=EqualsString,BeginsWith;");
	doTemp.setFilter(Sqlca, "0146", "SalesManager", "Operators=EqualsString;");
	doTemp.setFilter(Sqlca, "0141", "Salesexecutive", "Operators=EqualsString;");
	doTemp.setFilter(Sqlca, "0110", "Stores", "Operators=EqualsString;");// �����汾  CCS-1314_CCS-1312 V2_20160316  ��Ϊֻ����"����" doTemp.setFilter(Sqlca, "0110", "Stores", "Operators=EqualsString,BeginsWith;");
	doTemp.setFilter(Sqlca, "0200", "CityName", "Operators=Contains,EqualsString,BeginsWith;");
	doTemp.setFilter(Sqlca, "0243", "ContractStatus", "Operators=EqualsString;");
	doTemp.parseFilterData(request,iPostChange);
	doTemp.WhereClause +=doWhere;
	//�жϷ��ϸ������Ƿ����ݱȽ϶࣬Ӱ���ѯ����
	boolean flag = true;
	for(int k=0;k<doTemp.Filters.size();k++){
		if(doTemp.Filters.get(k).sFilterInputs[0][1] != null && (("0110").equals(doTemp.getFilter(k).sFilterID)||("0141").equals(doTemp.getFilter(k).sFilterID)||("0010").equals(doTemp.getFilter(k).sFilterID)||("0021").equals(doTemp.getFilter(k).sFilterID)||("0020").equals(doTemp.getFilter(k).sFilterID)||("0022").equals(doTemp.getFilter(k).sFilterID)||("0030").equals(doTemp.getFilter(k).sFilterID)||("0146").equals(doTemp.getFilter(k).sFilterID)||("0200").equals(doTemp.getFilter(k).sFilterID)) ){
			flag = false;
			break;
		}
	}
	if(doTemp.haveReceivedFilterCriteria()&& flag)
	{
		%>
		<script type="text/javascript">
			alert("Ϊ�˿��ٲ�ѯ����ͬ״̬��Ҫ��������������ʹ�ã�");
		</script>
		<%
		doTemp.WhereClause+=" and 1=2";
	}
	for(int k=0; k<doTemp.Filters.size(); k++){
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
			if((("0200").equals(doTemp.getFilter(k).sFilterID)) && doTemp.Filters.get(k).sFilterInputs[0][1].trim().length() < 2){
				%>
				<script type="text/javascript">
					alert("������ַ����ȱ���Ҫ���ڵ���2λ!");
				</script>
				<%
				doTemp.WhereClause+=" and 1=2";
				break;
			}
		} else if(k==doTemp.Filters.size()-1){
			
			if(!doTemp.haveReceivedFilterCriteria()){
				 doTemp.WhereClause+=" and 1=2";
			}else{
				doTemp.WhereClause+=doWhere;
			}
			
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
			{(CurUser.hasRole("1005") || CurUser.hasRole("1004") || CurUser.hasRole("1008"))?"true":"false","","Button","����EXCEL","����EXCEL","exportExcel()",sResourcesPath},
	};
	%> 
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">
	//---------------------���尴ť�¼�------------------------------------

	/*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=SerialNo;]~*/
	function viewAndEdit()
	{
		//���ҵ����ˮ��
		sSerialNo =getItemValue(0,getRow(),"SerialNo");	
		
	    sObjectType = "QueryBusinessContract";
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
		}else
		{
			sCompID = "CreditTab";
    		sCompURL = "/InfoManage/QuickSearch/QueryObjectTab.jsp";
    		sParamString = "ObjectType="+sObjectType+"&ObjectNo="+sSerialNo;
    		OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
    		
		}

	}
	
	//Excel��������
	function exportExcel(){
		<%
			//����Excelʱֻ������Ӧ���ֶ�CSS-776
			doTemp.setVisible("CustomerID,CertID,RepaymentNo,MobilePhone,SignedDate,RegistrationDate,RejectedDate,ProductID,BusinessType,BusinessTypeName,BusinessTypeName1,OperateModeName,SubProductType,SubProductTypeName,ProductName,TotalPrice,MonthRepayment,ReplaceAccount,RepaymentWay,CreditAttribute,CreditAttributeName,QualityGrade,QualityGradeName,QualityTagging,RetailID,OrgName,PutoutFlag,SalesManager,CityName,uploadFlag,dayrange,SureType,Totalsum,BusinessSum,Periods,RetailName,BrandType,Area,OperateMode,RetailType", false);
			doTemp.setVisible("SerialNo,CustomerName,InputTime,InputDate,Stores,sStoreName,SalesexecutiveName,Salesexecutive,SaleManagerName,StoreCityName,ContractStatusName",true);
			dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
			dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
			dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
			dwTemp.setPageSize(16);  //��������ҳ
			dwTemp.genHTMLDataWindow("");
		%>
		
		amarExport("myiframe0");
	}
	
	/* function CreditSettle(){
		sObjectNo =getItemValue(0,getRow(),"SerialNo");	
		sObjectType = "CreditSettle";
		sExchangeType = "";
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
		{
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
		}
		//������֪ͨ���Ƿ��Ѿ�����
		var sReturn = PopPageAjax("/FormatDoc/GetReportFile.jsp?ObjectNo="+sObjectNo+"&ObjectType="+sObjectType,"","");
		if (sReturn == "false"){ //δ���ɳ���֪ͨ��
			//���ɳ���֪ͨ��	
			PopPage("/FormatDoc/Report13/7001.jsp?DocID=7001&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType+"&SerialNo="+sObjectNo+"&Method=4&FirstSection=1&EndSection=0&rand="+randomNumber(),"myprint10","dialogWidth=10;dialogHeight=1;status:no;center:yes;help:no;minimize:yes;maximize:no;border:thin;statusbar:no");
		}
		//��ü��ܺ�ĳ�����ˮ��
		var sEncryptSerialNo = PopPageAjax("/PublicInfo/EncryptSerialNoAction.jsp?EncryptionType=MD5&SerialNo="+sObjectNo);
		
		//ͨ����serverlet ��ҳ��
		var CurOpenStyle = "width=720,height=540,top=20,left=20,toolbar=no,scrollbars=yes,resizable=yes,status=yes,menubar=no,";	
		//+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType  add by cdeng 2009-02-17	
		OpenPage("/FormatDoc/POPreviewFile.jsp?EncryptSerialNo="+sEncryptSerialNo+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType,"_blank02",CurOpenStyle); 
		
		
	} */

    
	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List07;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script type="text/javascript">	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	
	// ��д��ѯsubmit��֤����      -- �����汾   CCS-1314_CCS-1312  V2_20160316  ---------------- begin
	var default_checkDOFilterForm = checkDOFilterForm;
	checkDOFilterForm = function(v) {
		// ��ͬ��0010/�ͻ�����0020/�ͻ����0021/���֤����0022/��������0030
		
		// ��ͬ��:��ѯ��������ֵ
		var serialNoObj = document.getElementById("0010_1_INPUT");
		var serialNoVal = "";
		if (serialNoObj) {
			serialNoObj.value = $.trim(serialNoObj.value);
			serialNoVal = serialNoObj.value;
		}
		//�ͻ�����:��ѯ��������ֵ
		var customerNameObj = document.getElementById("0020_1_INPUT");
		var customerNameVal = "";
		if (customerNameObj) {
			customerNameObj.value = $.trim(customerNameObj.value);
			customerNameVal = customerNameObj.value;
		}
		// �ͻ���:��ѯ��������ֵ
		var customerIdObj = document.getElementById("0021_1_INPUT");
		var customerIdVal = "";
		if (customerIdObj) {
			customerIdObj.value = $.trim(customerIdObj.value);
			customerIdVal = customerIdObj.value;
		}
		// ���֤��:��ѯ��������ֵ
		var certIDObj = document.getElementById("0022_1_INPUT");
		var certIDVal = "";
		if (certIDObj) {
			certIDObj.value = $.trim(certIDObj.value);
			certIDVal = certIDObj.value;
		}
		// ��������:��ѯ��������ֵ
		var inputdateObj = document.getElementById("0030_1_INPUT");
		var inputdateVal = "";
		if (inputdateObj) {
			inputdateObj.value = $.trim(inputdateObj.value);
			inputdateVal = inputdateObj.value;
		}

		// ��ͬ�Ų����������»���
		if (serialNoVal.indexOf("_") > -1) {
			alert("��ѯ��������ͬ�š������������»��ߣ�");
			return false;
		}
		// ��ͬ�ų�����֤
		if (serialNoVal.length>0 && serialNoVal.length<8) {
			alert("����ĺ�ͬ�ų��ȱ���Ҫ���ڵ���8λ!");
			return false;
		}
		// ���²�ѯ��������������һ��: (��ͬ��0010/�ͻ�����0020/�ͻ����0021/���֤����0022/��������0030)
		if (serialNoVal.length==0 && customerNameVal.length==0 && customerIdVal.length==0 && certIDVal.length==0 && inputdateVal.length==0) {
			alert("��ѯ��������ͬ��/�ͻ�����/�ͻ����/���֤����/�������ڡ�������������һ�");
			return false;
		}
		// ������֤����ͨ����ִ��ϵͳĬ����֤����
		return default_checkDOFilterForm(v);
	}
	// ��д��ѯsubmit��֤����      -- �����汾   CCS-1314_CCS-1312  V2_20160316  ---------------- end
</script>	
<%/*~END~*/%>


<%@ include file="/IncludeEnd.jsp"%>
