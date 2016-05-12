<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author: PHE 2015-3-4
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
	String PG_TITLE = "ALDI��ͬע��"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>



<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/%>
	<%
	String sDoWhere  = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("doWhere"));	
	if(sDoWhere==null) sDoWhere="";	
	String BusinessDate = SystemConfig.getBusinessDate();
	
	String sHeaders[][] = { 							
			{"serialNo","��ͬ��"},
			{"CustomerID","�ͻ����"},
			{"certID","���֤��"},
			{"customerName","�ͻ�����"},
			{"ApplyType","��������"},
			{"SubProductTypeName","��Ʒ����"},
			{"SubProductType","��Ʒ����"},
			{"Stores","�ŵ��"},
			{"businessType","��Ʒ����"},
			{"City","�ŵ����"},
			{"StoreCityNo","�ŵ����"},
			{"contractStatus","��ͬ״̬"},
			{"contractStatus1","��ͬ״̬"},
			{"inputdate","��������"},
			{"SignedDate","ǩ������"},
			{"salesExecutiveName","���۴�������"},
			{"salesExecutive","���۴���"},
			{"operatorMode","����ģʽ"},
			{"OperatorModeType","����ģʽ"},
			{"SureType","ҵ����Դ"},
			{"SureTypeCode","ҵ����Դ"},
			{"landmarkStatus","�ر�״̬"},
			{"landmarkStatus1","�ر�״̬"},
			{"qualityGrade","�����ȼ�"},	
			{"qualityGrade1","�����ȼ�"},
			{"lastCheckTime","�������"},
			{"upUserName","�����"},
			{"TFError","�Ƿ����йؼ�����"},
			{"TFErrorCode","�Ƿ����йؼ�����"},
			{"salesExecutive","���۴���ID"},
			{"SalesManager","���۾���ID"}
		   }; 

	String sSql ="select bc.serialNo as serialNo, bc.CustomerID as CustomerID,certID as certID,customerName as customerName,getItemName('BusinessType', Business_type.productType) as ApplyType,getItemName('SubProductType',bc.SubProductType) as SubProductTypeName,bc.SubProductType as  SubProductType, Stores as Stores,bc.businessType as businessType,"
			   +" getitemname('AreaCode',si.City) as City,bc.City as StoreCityNo,getItemName('ContractStatus',contractStatus) as contractStatus,contractStatus as contractStatus1,"
			   +" getitemname('OperatorModeApply',OperatorMode) as operatorMode,bc.OperatorMode as OperatorModeType,getItemName('SureType', bc.SureType) as SureType,bc.SureType as SureTypeCode,"
			   +" bc.inputdate as inputdate,bc.SignedDate as SignedDate,salesExecutive as salesExecutive, getusername(salesExecutive) as salesExecutiveName,"
			   +" getItemName('LandMarkStatus',landmarkStatus) as landmarkStatus,landmarkStatus as landmarkStatus1,"
			   +" getitemname('QualityGrade',qualityGrade) as qualityGrade, bc.qualityGrade as qualityGrade1,"
			   +" bc.lastCheckTime as lastCheckTime,"
			   +" getusername(upUserName) as upUserName,"
			   +" getitemname('TrueFalse',bc.TFError) as TFError, bc.TFError as TFErrorCode,INPUTUSERID as INPUTUSERID, "
			   +" si.SalesManager as SalesManager "
			   +" from BUSINESS_CONTRACT bc "
			   +" left join Business_type on bc.businesstype = Business_type.typeno,store_info si"
			   +" where bc.stores=si.sno and bc.CreditAttribute ='0002' and ContractStatus in ('020','050','160','120') and LandMarkStatus<>'7' and bc.OPERATORMODE in ('01','05')";
		
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
	 
	doTemp.multiSelectionEnabled=true;
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
		{"false","","Button","���ĵر�","���ĵر�","changeLandmark()",sResourcesPath},
		{"false","","Button","������ע","������ע","qualityGrade()",sResourcesPath},
		{"false","","Button","��ͬ����","��ͬ����","contractDetail()",sResourcesPath},	
		{"false","","Button","�ύע��","�ύע��","doSubmit()",sResourcesPath},
		{"true","","Button","�ύ�ſ�","�ύ�ſ�","doSubmit()",sResourcesPath},
		{"false","","Button","���ɴ������","���ɴ������","ss()",sResourcesPath},
		{"false","","Button","Ӱ��","Ӱ��","imageView()",sResourcesPath},
		{"false","","Button","�ر���Ϣ��¼","�ر���Ϣ��¼","sLankStatus()",sResourcesPath},
		{CurUser.getRoleTable().contains("2001")?"true":"false","","Button","����EXCEL","����EXCEL","exportExcel()",sResourcesPath},

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
		var sSerialNoS = getItemValueArray(0,"serialNo");
		var sSerialNo = sSerialNoS[0];
		var sCustomerNameS = getItemValueArray(0,"customerName");
		var sLandmarkStatusS = getItemValueArray(0,"customerName");
		if(typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
		}
		if(confirm("�����ȷ�����ĵر���")){
		for(var i=0;i<sSerialNoS.length;i++){
		sSerialNo = sSerialNoS[i];
		var sCustomerName=sCustomerNameS[i];
		var sLandmarkStatus=sLandmarkStatusS[i];
		
		var landMarkNo=RunMethod("GetElement","GetElementValue","itemNo,code_library,codeno='LandMarkStatus' and itemName='"+sLandmarkStatus+"'");
		RunMethod("ModifyNumber","GetModifyNumber","business_contract,oldLandmarkStatus='"+landMarkNo+"',serialNo='"+sSerialNo+"'");//��¼��һ�εر�״̬
		var sLandmarkStatus=RunMethod("GetElement","GetElementValue","landmarkStatus,business_contract,serialNo='"+sSerialNo+"'");//�����ǰ�ر�״̬
		if(sLandmarkStatus!=null&& sLandmarkStatus!="5"){
			/* if(confirm("�����ȷ�����ĵر���")){ */
				RunMethod("ModifyNumber","GetModifyNumber","business_contract,landmarkStatus='5',serialNo='"+sSerialNo+"'");
				RunMethod("InsertLandmark","GetLandmark","'<%=CurUser.getUserID()%>','<%=StringFunction.getToday()%>','"+landMarkNo+"','5','"+sSerialNo+"','"+sCustomerName+"','050','"+getSerialNo("EVENT_INFO", "serialno", "")+"'");//��EVENT_INFO���в���ر��¼��Ϣ
				
			/* } */
		}/* else if(sLandmarkStatus!=null&& sLandmarkStatus=="5"){
			alert("�ر�״̬�����ܲ�������Ҫ���ģ�");
		} */
		}
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
		if(sLandmarkStatus!=null&& sLandmarkStatus=="5"){
			
			AsControl.OpenView("/Common/WorkFlow/PutOutApply/ALDIQualityGradeFrame.jsp","serialNo="+sSerialNo+"&CustomerName="+sCustomerName+"&qualityGrade="+sQualityGrade+"&landmarkStatus="+ssLandmarkStatus+"&doWhere=<%=doTemp.WhereClause%>&oldLandmark="+oldLandmark,"_self");
		}else{
			alert("���ȸ��ĵر꣡лл�� ");
		}
	}
	
	function doSubmit(){
		/***********CCS-1041,ϵͳ����ʱ���ܵ�¼ϵͳ huzp 20151217**************************************/
		var sTaskFlag = RunMethod("���÷���","GetColValue","system_setup,taskflag,1=1");
		if(sTaskFlag=="1"){
			alert("ϵͳ������������ʱ�޷��ύ�ſ�!");
			return;
		}else{
			var sSerialNoS = getItemValueArray(0,"serialNo");
			var sSerialNo = sSerialNoS[0];
			//var sSerialNo=getItemValue(0,getRow(),"serialNo");
			/* var inputUserID=getItemValue(0,getRow(),"INPUTUSERID");
			var sQualityGrade=getItemValue(0,getRow(),"qualityGrade"); 
			var sContractStatus=getItemValue(0,getRow(),"contractStatus"); */ 
			var inputUserIDS = getItemValueArray(0,"INPUTUSERID");
			var sQualityGradeS = getItemValueArray(0,"qualityGrade");
			var sContractStatuS = getItemValueArray(0,"contractStatus");
			
			if(typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
				alert(getHtmlMessage(1));  //��ѡ��һ����¼��
				return;
			}
			/*  if(sContractStatus!="����ͨ��"){
				alert("�ú�ͬ��������ͨ����ͬ,�������ύ!");
				return;
			} */
		 	for(var i=0;i<sSerialNoS.length;i++){
			sSerialNo = sSerialNoS[i];
			var inputUserID=inputUserIDS[i];
			var sQualityGrade=sQualityGradeS[i];
			var sContractStatus=sContractStatuS[i];
			
			//alert(sContractStatus);
			 if(sContractStatus!="��ǩ��"){
				alert("�ú�ͬ"+sSerialNo+"������ǩ���ͬ,�������ύ!");
				return;
			} 
			var userType=RunMethod("GetElement","GetElementValue","userType,user_info,userID='"+inputUserID+"' and isCar='02'");
			if(userType=="01"){
				alert("�˺�ͬ"+sSerialNo+"���ڲ�Ա����ͬ���������ύ��");
				return;
			}
			if(sQualityGrade!=null&&sQualityGrade=="�ؼ�����"){
				alert("�˺�ͬ"+sSerialNo+"�����ȼ�Ϊ�ؼ����󣡲������ύ��");
				return;
			}
			} 
			if(confirm("�����ȷ���ύ�ſ���")){
				for(var i=0;i<sSerialNoS.length;i++){
				sSerialNo=sSerialNoS[i];
				RunMethod("ModifyNumber","GetModifyNumber","business_contract,updateUserID='<%=CurUser.getUserID()%>',serialNo='"+sSerialNo+"'");
				RunMethod("ModifyNumber","GetModifyNumber","business_contract,contractStatus='050',serialNo='"+sSerialNo+"'");
				RunMethod("ModifyNumber","GetModifyNumber","business_contract,REGISTRATIONDATE='<%=BusinessDate%>',serialNo='"+sSerialNo+"'");//�޸�ǩ������
				}
				reloadSelf();
				
			}
		}
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
        if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
            alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
            return;
        }
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
		AsControl.OpenView("/Common/WorkFlow/PutOutApply/ALDILookLankStatusList.jsp","doWhere=<%=doTemp.WhereClause%>","right","");
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

