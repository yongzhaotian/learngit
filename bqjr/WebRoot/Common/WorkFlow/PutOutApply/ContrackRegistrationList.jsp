<%@page import="org.bouncycastle.asn1.cms.SignedData"%>
<%@page import="com.amarsoft.dict.als.cache.CodeCache"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author: hxli 2005-8-1
		Tester:
		Describe: ��ͬע��
		
		Input Param:
		SerialNo:��ˮ��
		ObjectType:��������
		ObjectNo��������
		
		Output Param:
			
		HistoryLog:
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "��ͬע��"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


 
<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/%>
	<%
	String sDoWhere  = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("doWhere"));	
	if(sDoWhere==null) sDoWhere="";	
	
	String sHeaders[][] = { 							
			{"serialNo","��ͬ��"},
			{"CustomerID","�ͻ����"},
			{"certID","���֤��"},
			{"customerName","�ͻ�����"},
			{"ApplyType","��������"},
			{"SubProductTypeName","��Ʒ����"},
			{"SubProductType","��Ʒ����"},
			{"CreditPerson","���й�˾"},
			{"Stores","�ŵ��"},
			{"businessType","��Ʒ����"},
			{"City","�ŵ����"},
			{"StoreCityNo","�ŵ����"},
			{"contractStatus","��ͬ״̬"},
			{"contractStatus1","��ͬ״̬"},
			{"inputdate","��������"},
			{"SignedDate","ǩ������"},
			{"salesExecutiveName","���۴�������"},
			{"SalesManager","���۾���ID"},
			{"operatorMode","����ģʽ"},
			{"OperatorModeType","����ģʽ"},
			{"SureType","ҵ����Դ"},
			{"SureTypeCode","ҵ����Դ"},
			{"fundSource","�Ƿ�P2P"},
			{"landmarkStatus","�ر�״̬"},
			{"landmarkStatus1","�ر�״̬"},
			{"qualityGrade","�����ȼ�"},	
			{"qualityGrade1","�����ȼ�"},
			{"lastCheckTime","�������"},
			{"upUserName","�����"},
			{"TFError","�Ƿ����йؼ�����"},
			{"TFErrorCode","�Ƿ����йؼ�����"},
			{"salesExecutive","���۴���ID"},
			{"uploadFlag","���������ϴ�״̬"},
			{"uploadFlagName","���������ϴ�״̬"},
			{"checkstatus","�������ϼ��״̬"},
			{"checkStatusName","�������ϼ��״̬"}
			
		   }; 

	String sSql ="select bc.serialNo as serialNo, bc.CustomerID as CustomerID,bc.certID as certID,bc.customerName as customerName,getItemName('BusinessType', Business_type.productType) as ApplyType,getItemName('SubProductType',bc.SubProductType) as SubProductTypeName,bc.SubProductType as SubProductType, "
			   +" bc.creditperson as CreditPerson,"
			   +" bc.Stores as Stores,bc.businessType as businessType,"
			   +" getitemname('AreaCode',bc.StoreCityCode) as City,bc.City as StoreCityNo,getItemName('ContractStatus',bc.contractStatus) as contractStatus,bc.contractStatus as contractStatus1,"
			   +" getitemname('OperatorModeApply',bc.OperatorMode) as operatorMode, bc.OperatorMode as OperatorModeType,getItemName('SureType',bc.SureType) as SureType,decode(bc.isp2p,'1','��','��') as fundSource,bc.SureType as SureTypeCode,"
			   +" bc.inputdate as inputdate,bc.SignedDate as SignedDate,bc.salesExecutive as salesExecutive, getusername(bc.salesExecutive) as salesExecutiveName,"
			   +" getItemName('LandMarkStatus',bc.landmarkStatus) as landmarkStatus,landmarkStatus as landmarkStatus1,"
			   +" getitemname('QualityGrade',qualityGrade) as qualityGrade, bc.qualityGrade as qualityGrade1,"
			   +" bc.lastCheckTime as lastCheckTime,"
			   +" getusername(bc.upUserName) as upUserName,"
			   +" getitemname('TrueFalse',bc.TFError) as TFError, bc.TFError as TFErrorCode,INPUTUSERID as INPUTUSERID, "
			   +" STORE_INFO.SalesManager as SalesManager "
			   //��Ӵ��������ϴ������״̬��ѯ�ֶ�
			   +" , bc.checkstatus as checkstatus, getItemName('checkstatus', bc.checkstatus) as checkStatusName, bc.uploadFlag as uploadFlag, getItemName('uploadFlag', bc.uploadFlag) as uploadFlagName "
			   +"from BUSINESS_CONTRACT bc "
			   +" left join STORE_INFO on STORE_INFO.SNo = bc.Stores "
			   +" left join Business_type on bc.businesstype = Business_type.typeno "
			   +" where bc.CreditAttribute ='0002' and ContractStatus not in('060','210','100','030','010','070','230','140','150','170') and LandMarkStatus<='6'"
			   // add by xswang 20150831 CRA-340 PAD��ͬ����������ֽ�ʺ�ͬ���ݻ���:PADȫ�������ߺ�PC��ͬע�����ֻ��ʾPC���ݺ�PAD����֮ǰ������ 
	   		   +" and (bc.suretype <> 'APP'  or (bc.suretype = 'APP' and bc.inputdate < '2015/08/04 00:00:00')) ";
	   		   // end by xswang
	 ASDataObject doTemp = null;
	 doTemp = new ASDataObject(sSql);//����ģ�ͣ�2013-5-9
	 doTemp.setHeader(sHeaders);	
	 doTemp.setKey("serialNo", true);
	 
	 doTemp.setDDDWSql("contractStatus1", "select itemno,itemname from code_library where codeno='ContractStatus' and itemno in ('020','080','050','040','090','110','120','160') and IsInUse = '1' ");
	 doTemp.setDDDWSql("landmarkStatus1", "select itemno,itemname from code_library where codeno='LandMarkStatus' and itemno<='6' and IsInUse = '1' ");
	 doTemp.setDDDWSql("qualityGrade1", " select itemno,itemname from code_library where codeno='QualityGrade' and IsInUse = '1' ");
	 doTemp.setDDDWSql("OperatorModeType", " select itemno,itemname from code_library where codeno='OperatorModeApply' and IsInUse = '1' ");
	 //doTemp.setDDDWSql("StoreCityNo", " select itemno,itemname from code_library where codeno='AreaCode' and IsInUse = '1' ");
	 doTemp.setDDDWSql("SubProductType", " select itemno,itemname from code_library where codeno='SubProductType' and IsInUse = '1' ");
	 doTemp.setCheckFormat("inputdate", "3");
	 doTemp.setCheckFormat("SignedDate", "3");
	 doTemp.setCheckFormat("lastCheckTime", "3");
	 doTemp.setDDDWSql("SureTypeCode", "select itemno,itemname from code_library where codeno='SureType' and IsInUse = '1' ");
	 doTemp.setDDDWCodeTable("TFErrorCode", "0,��,1,��");
		//���ô������ϼ��״̬��
	 //doTemp.setDDDWSql("checkstatus", " select itemno,itemname from code_library where codeno='checkstatus' and IsInUse = '1' ");
	 //doTemp.setDDDWSql("uploadFlag", " select itemno,itemname from code_library where codeno='uploadFlag' and IsInUse = '1' ");
	 
	 doTemp.setVisible("INPUTUSERID,contractStatus1,SubProductType,SureTypeCode,landmarkStatus1,qualityGrade1,TFErrorCode,StoreCityNo,OperatorModeType,uploadFlag,checkstatus", false);
//	 ASDataObject doTemp = null;
//	 String sTempletNo = "ContrackRegistrationList";
//	 doTemp = new ASDataObject(sTempletNo,Sqlca);//����ģ�ͣ�2013-5-9
//	 doTemp.setHeader("serialNo", "��ͬ��");
//	 doTemp.setColumnAttribute("serialNo,CustomerID,certID,SubProductType,customerName,City,Stores,operatorMode,SureType,contractStatus1,inputdate,salesExecutive,landmarkStatus1,qualityGrade1,upUserName,lastCheckTime,ApplyType,businessType,SalesManager,uploadFlag,checkstatus","IsFilter","1");
	 //�Ż���ɾ����һЩ��ѯ����
	 doTemp.setColumnAttribute("serialNo,CustomerID,certID,SubProductType,customerName,City,operatorMode,SureType,contractStatus1,inputdate,salesExecutive,landmarkStatus1,qualityGrade1,upUserName,lastCheckTime,SalesManager,uploadFlag,checkstatus","IsFilter","1");
//	 doTemp.generateFilters(Sqlca);
	 
	 /**
	  *���ڲ�ѯ��������ģ�����²�ѯ�ٶ�̫��
	  *�����趨��ѯ������ @author qizhong.chi
	  *************** begin
	 **/
	 doTemp.setFilter(Sqlca, "0010", "serialNo", "Operators=EqualsString,BeginsWith;");
	 doTemp.setFilter(Sqlca, "0011", "CustomerID", "Operators=EqualsString,BeginsWith;");
	 doTemp.setFilter(Sqlca, "0020", "certID", "Operators=EqualsString,BeginsWith;");
	 doTemp.setFilter(Sqlca, "0030", "customerName", "Operators=EqualsString,BeginsWith;");
	 //doTemp.setFilter(Sqlca, "0040", "ApplyType", "Operators=EqualsString,BeginsWith;");
	 doTemp.setFilter(Sqlca, "0045", "SubProductType", "Operators=EqualsString;");
	 //doTemp.setFilter(Sqlca, "0050", "Stores", "Operators=EqualsString,BeginsWith;");
	 //doTemp.setFilter(Sqlca, "0060", "businessType", "Operators=EqualsString,BeginsWith;");
	 //doTemp.setFilter(Sqlca, "0070", "StoreCityNo", "Operators=EqualsString;");
	 doTemp.setFilter(Sqlca, "0090", "contractStatus1", "Operators=EqualsString;");
	 doTemp.setFilter(Sqlca, "0100", "inputdate", "Operators=BeginsWith;");
	 //doTemp.setFilter(Sqlca, "0110", "SignedDate", "Operators=EqualsString,BeginsWith;");
	 doTemp.setFilter(Sqlca, "0120", "salesExecutive", "Operators=EqualsString,BeginsWith;");
	 doTemp.setFilter(Sqlca, "0140", "OperatorModeType", "Operators=EqualsString;");
	 doTemp.setFilter(Sqlca, "0160", "SureTypeCode", "Operators=EqualsString;");
	 doTemp.setFilter(Sqlca, "0170", "landmarkStatus1", "Operators=EqualsString;");
	 doTemp.setFilter(Sqlca, "0180", "qualityGrade1", "Operators=EqualsString;");
	 doTemp.setFilter(Sqlca, "0190", "lastCheckTime", "Operators=EqualsString,BeginsWith;");
	 doTemp.setFilter(Sqlca, "0200", "upUserName", "Operators=EqualsString,BeginsWith;");
	 doTemp.setFilter(Sqlca, "0210", "TFErrorCode", "Operators=EqualsString;");
	 doTemp.setFilter(Sqlca, "0220", "SalesManager", "Operators=EqualsString,BeginsWith;");
	 //���ô��������ϴ�״̬��ѯ����
	 //doTemp.setFilter(Sqlca, "024", "uploadFlag", "Operators=EqualsString;");
	 //���ô������ϼ��״̬��ѯ����
	 //doTemp.setFilter(Sqlca, "026", "checkstatus", "Operators=EqualsString;");

	 /**end**/
	 
	 doTemp.parseFilterData(request,iPostChange);
	 
	 if(doTemp.haveReceivedFilterCriteria()){
		 
		 //�������ѯ����
		 boolean flag = true;
		 for(int k=0; k<doTemp.Filters.size(); k++){
			if((("0010").equals(doTemp.getFilter(k).sFilterID)||("0011").equals(doTemp.getFilter(k).sFilterID)||("0020").equals(doTemp.getFilter(k).sFilterID)||("0030").equals(doTemp.getFilter(k).sFilterID)||("0100").equals(doTemp.getFilter(k).sFilterID)||("0190").equals(doTemp.getFilter(k).sFilterID))&&doTemp.Filters.get(k).sFilterInputs[0][1] != null){
				flag = false;
				break;
			}
		 }
		 
		 if(flag){
			 %>
			<script type="text/javascript">
					alert("��ͬ�š��ͻ���š�ʡ��֤���ͻ��������������ڡ�������ڱ�������һ��!");
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
				if((("0030").equals(doTemp.getFilter(k).sFilterID) || ("0040").equals(doTemp.getFilter(k).sFilterID)|| ("0070").equals(doTemp.getFilter(k).sFilterID)) && doTemp.Filters.get(k).sFilterInputs[0][1].trim().length() < 2){
					%>
					<script type="text/javascript">
						alert("������ַ����ȱ���Ҫ���ڵ���2λ!");
					</script>
					<%
					doTemp.WhereClause+=" and 1=2";
					break;
				} else if((("0010").equals(doTemp.getFilter(k).sFilterID)||("0011").equals(doTemp.getFilter(k).sFilterID)||("0020").equals(doTemp.getFilter(k).sFilterID) || ("0050").equals(doTemp.getFilter(k).sFilterID)) && doTemp.Filters.get(k).sFilterInputs[0][1].trim().length() < 8){
					%>
					<script type="text/javascript">
						alert("������ַ����ȱ���Ҫ���ڵ���8λ!");
					</script>
					<%
					doTemp.WhereClause+=" and 1=2";
					break;
				}
					
			} else if(k==doTemp.Filters.size()-1){
				
				if(!doTemp.haveReceivedFilterCriteria()) {
					if(!sDoWhere.equals("")){
						doTemp.WhereClause=sDoWhere;
					}else{
						doTemp.WhereClause+=" and 1=2 ";
					}
				}
				
			}
		}
	}else {
		if(!sDoWhere.equals("")){
			doTemp.WhereClause=sDoWhere;
		}else{
			doTemp.WhereClause+=" and 1=2 ";
		}
	}
	//����ѯ�������Ǻ�ͬ�ţ���ͬ״̬ʱ��Ĭ�ϲ�ѯ��ͬ״̬Ϊ��ǩ������ͨ������ע�ᡢ�˻�������δע�ᡢ�ѽ��塢�˻����塢��ǰ�������
	if(doTemp.haveReceivedFilterCriteria()){
		if(doTemp.Filters.get(0).sFilterInputs[0][1]==null && doTemp.Filters.get(9).sFilterInputs[0][1]==null){
			doTemp.WhereClause+=" and bc.contractStatus in ('020','080','050','040','090','110','120','160') ";
		}
	}
	 
//	if(!doTemp.haveReceivedFilterCriteria()) doTemp.WhereClause+=" and 1=2 ";
//	if(!sDoWhere.equals("")) {
//		if(!doTemp.haveReceivedFilterCriteria()){
//			doTemp.WhereClause=sDoWhere;
//		}
//	}
	
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //����Ϊֻ��
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");//�����������ݣ�2013-5-9
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	
	String AppUrl = CodeCache.getItem("PrintAppUrl","0010").getItemAttribute();
	String JQMUrl = CodeCache.getItem("PrintAppUrl","0013").getItemAttribute();
	String FCUrl = CodeCache.getItem("PrintAppUrl","0015").getItemAttribute();

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
		{"true","","Button","���ĵر�","���ĵر�","changeLandmark()",sResourcesPath},
		{"true","","Button","���ǩ��","���ǩ��","receivePackage()",sResourcesPath},
		{"true","","Button","������ע","������ע","qualityGrade()",sResourcesPath},
		{"true","","Button","��ͬ����","��ͬ����","contractDetail()",sResourcesPath},	
		{"false","","Button","�ύע��","�ύע��","doSubmit()",sResourcesPath},
		{"true","","Button","���Ӻ�ͬ����","���Ӻ�ͬ����","viewApplyReport()",sResourcesPath},
		{"true","","Button","������Э�����","������Э�����","creatThirdTable()",sResourcesPath},
		{"false","","Button","���ɴ������","���ɴ������","ss()",sResourcesPath},
		{"true","","Button","Ӱ��","Ӱ��","imageView()",sResourcesPath},
		{"true","","Button","�ر���Ϣ��¼","�ر���Ϣ��¼","sLankStatus()",sResourcesPath},
		{CurUser.getRoleTable().contains("2001")?"true":"false","","Button","����EXCEL","����EXCEL","exportExcel()",sResourcesPath},
		{"true","","Button","���ǩ�չ���","���ǩ�չ���","expressManage()",sResourcesPath},
	};
	
	%>
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">

	//---------------------���尴ť�¼�------------------------------------
	/*~[Describe=������¼;InputParam=��;OutPutParam=��;]~*/
	var  temp=false;
	
	//Excel����������	
	function exportExcel(){
		amarExport("myiframe0");
	}
	//end by pli2 20140417	
	
	function changeLandmark(){
		var sSerialNo=getItemValue(0,getRow(),"serialNo");
		var sCustomerName=getItemValue(0,getRow(),"customerName");
		var sLandmarkStatus=getItemValue(0,getRow(),"landmarkStatus1");
		if(typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
		}
		//var landMarkNo=RunMethod("GetElement","GetElementValue","itemNo,code_library,codeno='LandMarkStatus' and itemName='"+sLandmarkStatus+"'");
		//RunMethod("ModifyNumber","GetModifyNumber","business_contract,oldLandmarkStatus='"+landMarkNo+"',serialNo='"+sSerialNo+"'");//��¼��һ�εر�״̬
		//var sLandmarkStatus=RunMethod("GetElement","GetElementValue","landmarkStatus,business_contract,serialNo='"+sSerialNo+"'");//�����ǰ�ر�״̬
		if(sLandmarkStatus!=null&& sLandmarkStatus!="5"){
			if(confirm("�����ȷ�����ĵر���")){
				RunMethod("PublicMethod","UpdateColValue","String@LandMarkStatus@"+'5'+"@String@oldLandmarkStatus@"+sLandmarkStatus+",business_contract,String@serialNo@"+sSerialNo);
				RunMethod("InsertLandmark","GetLandmark","'<%=CurUser.getUserID()%>','<%=StringFunction.getToday()%>','"+sLandmarkStatus+"','5','"+sSerialNo+"','"+sCustomerName+"','050','"+getSerialNo("EVENT_INFO", "serialno", "")+"'");//��EVENT_INFO���в���ر��¼��Ϣ
			}
		}else if(sLandmarkStatus!=null&& sLandmarkStatus=="5"){
			alert("�ر�״̬�����ܲ�������Ҫ���ģ�");
		}
		reloadSelf();
	}
	
	function qualityGrade(){
		var sSerialNo=getItemValue(0,getRow(),"serialNo");	
		var sQualityGrade=getItemValue(0,getRow(),"qualityGrade"); //�����Ǽ�
		var ssLandmarkStatus=getItemValue(0,getRow(),"landmarkStatus");//�ر�״̬
		var sCustomerName = getItemValue(0,getRow(),"customerName");//�ͻ�����
		if(typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
		}
	
		var oldLandmark=RunMethod("GetElement","GetElementValue","oldLandmarkStatus,business_contract,serialNo='"+sSerialNo+"'");//�����һ�εر�״̬ 
		if(oldLandmark==""){
			oldLandmark="�ܲ�";
		}else{
			oldLandmark=RunMethod("GetElement","GetElementValue","itemName,code_library,codeno='LandMarkStatus' and itemNo='"+oldLandmark+"'");//�ҵ���Ӧ������
		}
		var sLandmarkStatus=RunMethod("GetElement","GetElementValue","landmarkStatus,business_contract,serialNo='"+sSerialNo+"'");
		var sContractStatus=RunMethod("GetElement","GetElementValue","ContractStatus,business_contract,serialNo='"+sSerialNo+"'");//��ѯ��ͬ��״̬
		//add by phe 2015/05/05 CCS-529 PRM-211 ���Ӻ�ͬ������ע������
		var sOperatorMode=RunMethod("GetElement","GetElementValue","OperatorMode,business_contract,serialNo='"+sSerialNo+"'");//��ѯ��ͬ������ģʽ
		
		if(sOperatorMode=='01'||sOperatorMode=='05'){//CCS-971,���sContractStatus=='160'��ǰ�������״̬ 20150720 huzp
			if(!(sContractStatus=='020'||sContractStatus=='050'||sContractStatus=='160'||sContractStatus=='110'||sContractStatus=='120')){
				alert("����ALDI�����ALDI�ĺ�ֻͬ����ע�ᡢ��ǩ���ѽ��塢�˻����塢��ǰ�������ſ���������ע��");
				return;
			}		
		}else{//CCS-971,���sContractStatus=='160'��ǰ�������״̬ 20150720 huzp
			if(!(sContractStatus=='050'||sContractStatus=='160'||sContractStatus=='110'||sContractStatus=='120')){
				alert("������ALDI�����ALDI����ĺ�ֻͬ����ע�ᡢ�ѽ��塢�˻����塢��ǰ�������ſ���������ע��");
				return;
			}
		}
		//end by phe 2015/05/05
		if(sLandmarkStatus!=null&& sLandmarkStatus=="5"){
			AsControl.OpenView("/Common/WorkFlow/PutOutApply/QualityGradeFrame.jsp","serialNo="+sSerialNo+"&CustomerName="+sCustomerName+"&qualityGrade="+sQualityGrade+"&landmarkStatus="+ssLandmarkStatus+"&doWhere=<%=doTemp.WhereClause%>&oldLandmark="+oldLandmark,"_self");
		}else{
			alert("���ȸ��ĵر꣡лл�� ");
		}
	}
	
	function doSubmit(){
		var sSerialNo=getItemValue(0,getRow(),"serialNo");
		var inputUserID=getItemValue(0,getRow(),"INPUTUSERID");
		var sQualityGrade=getItemValue(0,getRow(),"qualityGrade"); 
		var sContractStatus=getItemValue(0,getRow(),"contractStatus"); 
		if(typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
		}
		if(sContractStatus!="����ͨ��"){
			alert("�ú�ͬ��������ͨ����ͬ,�������ύ!");
			return;
		}
		var userType=RunMethod("GetElement","GetElementValue","userType,user_info,userID='"+inputUserID+"' and isCar='02'");
		if(userType=="01"){
			alert("�˺�ͬ���ڲ�Ա����ͬ���������ύ��");
			return;
		}
		if(sQualityGrade!=null&&sQualityGrade=="�ؼ�����"){
			alert("�����ȼ�Ϊ�ؼ����󣡲������ύ��");
			return;
		}
		if(confirm("�����ȷ���ύע����")){
			RunMethod("ModifyNumber","GetModifyNumber","business_contract,upUserName='<%=CurUser.getUserID()%>',serialNo='"+sSerialNo+"'");
			RunMethod("ModifyNumber","GetModifyNumber","business_contract,contractStatus='020',serialNo='"+sSerialNo+"'");
			RunMethod("ModifyNumber","GetModifyNumber","business_contract,SignedDate='<%=StringFunction.getToday()%>',serialNo='"+sSerialNo+"'");//�޸�ǩ������
			reloadSelf();
		}
	}
//  ==============================  ��ӡ��ʽ������  ��������  add by phe   ============================================================
	
	/*~[Describe=��ӡ��ʽ������;InputParam=��;OutPutParam=��;]~*/
	function printTable(type){
			var sObjectNo = getItemValue(0,getRow(),"serialNo");
			var sUserID = "<%=CurUser.getUserID()%>";
			var sOrgID = "<%=CurOrg.getOrgID()%>";
			if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
				alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
				return;
			}		
			//��ӡAPP�˵ĺ�ͬ
			var sSureType = getItemValue(0,getRow(),"SureTypeCode");
			var url = "";  
			if(sSureType=="app"||sSureType=="APP"){
				//sObjectNo="19151136003";
				alert("�˺�ͬ��Դ��APP!");
				url="<%=AppUrl%>"+sObjectNo;
				window.open(url);
				return;
			}else if(sSureType=="JQM"){
				alert("�˺�ͬ��Դ�ڽ�Ǯô!");
				url="<%=JQMUrl%>"+sObjectNo;
				window.open(url);
				return;
			}else if(sSureType=="FC"){
				alert("�˺�ͬ��Դ�ڷ䳲!");
				url="<%=FCUrl%>"+sObjectNo;
				window.open(url);
				return;
			}
			
			var sObjectType = type;
			//alert(sObjectNo+"sObjectNo,sSerialNo="+sSerialNo);
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
					var  returnValue = RunJavaMethodSqlca("com.amarsoft.app.billions.DocCommon","getDocIDAndUrl","serialNo="+sObjectNo+",type="+type);
					if(returnValue=="False"||typeof(returnValue)=="undefined"||returnValue.length==0){
						alert("����ϵϵͳ����Ա����ͬģ�����úͺ�ͬ��Ϣ!");
						return;
					}
					var sDocID = 	returnValue.split("@")[0];
					var sUrl = returnValue.split("@")[1];
					var sSerialNo = getSerialNo("FORMATDOC_RECORD", "serialNo", "TS");
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
	//   ============================== end  ��ӡ��ʽ������ ============================================================
	
		
	/*~[Describe= �鿴���Ӻ�ͬ;]~*/
    function viewApplyReport(){
    		printTable("ApplySettle");
    }
	
	/*~[Describe=��ӡ������Э��;]~*/
	function creatThirdTable(){
			printTable("ThirdSettle");
	}
	
	function contractDetail(){
		var sSerialNo = getItemValue(0,getRow(),"serialNo");
		sObjectType="BusinessContract";
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		sCompID = "CreditTab";
		sCompURL = "/CreditManage/CreditApply/ObjectTab.jsp";
		sParamString = "ObjectType="+sObjectType+"&ObjectNo="+sSerialNo;
		OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
//		popComp("PutOutApplyTab","/Common/WorkFlow/PutOutApply/PutOutApplyTab.jsp","ObjectNo="+sSerialNo+"&CustomerID="+sCustomerID+"&temp=0002");
	}
	
    function imageView(){
        var sObjectNo   = getItemValue(0,getRow(),"serialNo");
        var uploadFlag   = getItemValue(0,getRow(),"uploadFlag");
        if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
            alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
            return;
        }
        var checkStatu = "2";
        if(uploadFlag == '���ϴ�' || uploadFlag == 'δ�ϴ�'){
        	checkStatu ="1";
        }
        if(uploadFlag == '�����ϴ�'){
        	checkStatu ="3";
        }
        RunMethod("���÷���","UpdateColValue","BUSINESS_CONTRACT,checkstatus,"+checkStatu+",serialNo='"+sObjectNo+"'");
//	     var param = "ObjectType=Business&TypeNo=20&ObjectNo="+sObjectNo;
//	     AsControl.PopView( "/ImageManage/ImageViewNew.jsp", param, "" );

	     var param = "ObjectType=Business&TypeNo=20&RightType=100&ObjectNo="+sObjectNo;
	     AsControl.PopView( "/ImageManage/ImageView.jsp", param, "" );
    }
    
    function sLankStatus(){
    	var sCount=RunMethod("Unique","uniques","EVENT_INFO,SERIALNO,type='050'");
		if(sCount=="Null"){
			alert("û�и��ĵر�״̬��¼��");
			return;
		}
		AsControl.OpenView("/Common/WorkFlow/PutOutApply/LookLankStatusList.jsp","doWhere=<%=doTemp.WhereClause%>","right","");
    }
    
  	//���ǩ��
    function receivePackage(){
    	AsControl.PopPage("/Common/WorkFlow/PutOutApply/receivePackage.jsp","","dialogWidth=40;dialogheight=auto;scrollbars:yes;");
    	
    }
    
    /**[@description=���ǩ�չ���  @param=null @return=nulll]**/
    function expressManage(){
    	AsControl.OpenView("/Common/WorkFlow/PutOutApply/ExpressManageList.jsp","","right");
    }
    
	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List07;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script type="text/javascript">
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	showFilterArea();
</script>
<%/*~END~*/%>

<%@	include file="/IncludeEnd.jsp"%>

