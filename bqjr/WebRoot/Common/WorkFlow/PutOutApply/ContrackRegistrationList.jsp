<%@page import="org.bouncycastle.asn1.cms.SignedData"%>
<%@page import="com.amarsoft.dict.als.cache.CodeCache"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author: hxli 2005-8-1
		Tester:
		Describe: 合同注册
		
		Input Param:
		SerialNo:流水号
		ObjectType:对象类型
		ObjectNo：对象编号
		
		Output Param:
			
		HistoryLog:
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "合同注册"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


 
<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info03;Describe=定义数据对象;]~*/%>
	<%
	String sDoWhere  = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("doWhere"));	
	if(sDoWhere==null) sDoWhere="";	
	
	String sHeaders[][] = { 							
			{"serialNo","合同号"},
			{"CustomerID","客户编号"},
			{"certID","身份证号"},
			{"customerName","客户姓名"},
			{"ApplyType","申请类型"},
			{"SubProductTypeName","产品类型"},
			{"SubProductType","产品类型"},
			{"CreditPerson","信托公司"},
			{"Stores","门店号"},
			{"businessType","产品代码"},
			{"City","门店城市"},
			{"StoreCityNo","门店城市"},
			{"contractStatus","合同状态"},
			{"contractStatus1","合同状态"},
			{"inputdate","申请日期"},
			{"SignedDate","签署日期"},
			{"salesExecutiveName","销售代表姓名"},
			{"SalesManager","销售经理ID"},
			{"operatorMode","运作模式"},
			{"OperatorModeType","运作模式"},
			{"SureType","业务来源"},
			{"SureTypeCode","业务来源"},
			{"fundSource","是否P2P"},
			{"landmarkStatus","地标状态"},
			{"landmarkStatus1","地标状态"},
			{"qualityGrade","质量等级"},	
			{"qualityGrade1","质量等级"},
			{"lastCheckTime","检查日期"},
			{"upUserName","检查人"},
			{"TFError","是否曾有关键错误"},
			{"TFErrorCode","是否曾有关键错误"},
			{"salesExecutive","销售代表ID"},
			{"uploadFlag","贷后资料上传状态"},
			{"uploadFlagName","贷后资料上传状态"},
			{"checkstatus","贷后资料检查状态"},
			{"checkStatusName","贷后资料检查状态"}
			
		   }; 

	String sSql ="select bc.serialNo as serialNo, bc.CustomerID as CustomerID,bc.certID as certID,bc.customerName as customerName,getItemName('BusinessType', Business_type.productType) as ApplyType,getItemName('SubProductType',bc.SubProductType) as SubProductTypeName,bc.SubProductType as SubProductType, "
			   +" bc.creditperson as CreditPerson,"
			   +" bc.Stores as Stores,bc.businessType as businessType,"
			   +" getitemname('AreaCode',bc.StoreCityCode) as City,bc.City as StoreCityNo,getItemName('ContractStatus',bc.contractStatus) as contractStatus,bc.contractStatus as contractStatus1,"
			   +" getitemname('OperatorModeApply',bc.OperatorMode) as operatorMode, bc.OperatorMode as OperatorModeType,getItemName('SureType',bc.SureType) as SureType,decode(bc.isp2p,'1','是','否') as fundSource,bc.SureType as SureTypeCode,"
			   +" bc.inputdate as inputdate,bc.SignedDate as SignedDate,bc.salesExecutive as salesExecutive, getusername(bc.salesExecutive) as salesExecutiveName,"
			   +" getItemName('LandMarkStatus',bc.landmarkStatus) as landmarkStatus,landmarkStatus as landmarkStatus1,"
			   +" getitemname('QualityGrade',qualityGrade) as qualityGrade, bc.qualityGrade as qualityGrade1,"
			   +" bc.lastCheckTime as lastCheckTime,"
			   +" getusername(bc.upUserName) as upUserName,"
			   +" getitemname('TrueFalse',bc.TFError) as TFError, bc.TFError as TFErrorCode,INPUTUSERID as INPUTUSERID, "
			   +" STORE_INFO.SalesManager as SalesManager "
			   //添加贷后资料上传、检查状态查询字段
			   +" , bc.checkstatus as checkstatus, getItemName('checkstatus', bc.checkstatus) as checkStatusName, bc.uploadFlag as uploadFlag, getItemName('uploadFlag', bc.uploadFlag) as uploadFlagName "
			   +"from BUSINESS_CONTRACT bc "
			   +" left join STORE_INFO on STORE_INFO.SNo = bc.Stores "
			   +" left join Business_type on bc.businesstype = Business_type.typeno "
			   +" where bc.CreditAttribute ='0002' and ContractStatus not in('060','210','100','030','010','070','230','140','150','170') and LandMarkStatus<='6'"
			   // add by xswang 20150831 CRA-340 PAD合同数据与现有纸质合同数据混淆:PAD全流程上线后，PC合同注册界面只显示PC数据和PAD上线之前的数据 
	   		   +" and (bc.suretype <> 'APP'  or (bc.suretype = 'APP' and bc.inputdate < '2015/08/04 00:00:00')) ";
	   		   // end by xswang
	 ASDataObject doTemp = null;
	 doTemp = new ASDataObject(sSql);//新增模型：2013-5-9
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
	 doTemp.setDDDWCodeTable("TFErrorCode", "0,否,1,是");
		//设置贷后资料检查状态列
	 //doTemp.setDDDWSql("checkstatus", " select itemno,itemname from code_library where codeno='checkstatus' and IsInUse = '1' ");
	 //doTemp.setDDDWSql("uploadFlag", " select itemno,itemname from code_library where codeno='uploadFlag' and IsInUse = '1' ");
	 
	 doTemp.setVisible("INPUTUSERID,contractStatus1,SubProductType,SureTypeCode,landmarkStatus1,qualityGrade1,TFErrorCode,StoreCityNo,OperatorModeType,uploadFlag,checkstatus", false);
//	 ASDataObject doTemp = null;
//	 String sTempletNo = "ContrackRegistrationList";
//	 doTemp = new ASDataObject(sTempletNo,Sqlca);//新增模型：2013-5-9
//	 doTemp.setHeader("serialNo", "合同号");
//	 doTemp.setColumnAttribute("serialNo,CustomerID,certID,SubProductType,customerName,City,Stores,operatorMode,SureType,contractStatus1,inputdate,salesExecutive,landmarkStatus1,qualityGrade1,upUserName,lastCheckTime,ApplyType,businessType,SalesManager,uploadFlag,checkstatus","IsFilter","1");
	 //优化后删除的一些查询条件
	 doTemp.setColumnAttribute("serialNo,CustomerID,certID,SubProductType,customerName,City,operatorMode,SureType,contractStatus1,inputdate,salesExecutive,landmarkStatus1,qualityGrade1,upUserName,lastCheckTime,SalesManager,uploadFlag,checkstatus","IsFilter","1");
//	 doTemp.generateFilters(Sqlca);
	 
	 /**
	  *由于查询条件过于模糊导致查询速度太慢
	  *重新设定查询的条件 @author qizhong.chi
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
	 //设置贷后资料上传状态查询条件
	 //doTemp.setFilter(Sqlca, "024", "uploadFlag", "Operators=EqualsString;");
	 //设置贷后资料检查状态查询条件
	 //doTemp.setFilter(Sqlca, "026", "checkstatus", "Operators=EqualsString;");

	 /**end**/
	 
	 doTemp.parseFilterData(request,iPostChange);
	 
	 if(doTemp.haveReceivedFilterCriteria()){
		 
		 //必输项查询限制
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
					alert("合同号、客户编号、省份证、客户姓名、申请日期、检查日期必须输入一项!");
				</script>
			<%
				doTemp.WhereClause+=" and 1=2";
		 }
		 
		 
		 for(int k=0; k<doTemp.Filters.size(); k++){
			//输入的条件都不能含有%符号
			if(doTemp.Filters.get(k).sFilterInputs[0][1] != null && doTemp.Filters.get(k).sFilterInputs[0][1].contains("%")){
				%>
				<script type="text/javascript">
					alert("输入的条件不能含有\"%\"符号!");
				</script>
				<%
				doTemp.WhereClause+=" and 1=2";
				break;
			}
			
			if(doTemp.Filters.get(k).sFilterInputs[0][1] != null  && "BeginsWith".equals(doTemp.Filters.get(k).sOperator)){
				if((("0030").equals(doTemp.getFilter(k).sFilterID) || ("0040").equals(doTemp.getFilter(k).sFilterID)|| ("0070").equals(doTemp.getFilter(k).sFilterID)) && doTemp.Filters.get(k).sFilterInputs[0][1].trim().length() < 2){
					%>
					<script type="text/javascript">
						alert("输入的字符长度必须要大于等于2位!");
					</script>
					<%
					doTemp.WhereClause+=" and 1=2";
					break;
				} else if((("0010").equals(doTemp.getFilter(k).sFilterID)||("0011").equals(doTemp.getFilter(k).sFilterID)||("0020").equals(doTemp.getFilter(k).sFilterID) || ("0050").equals(doTemp.getFilter(k).sFilterID)) && doTemp.Filters.get(k).sFilterInputs[0][1].trim().length() < 8){
					%>
					<script type="text/javascript">
						alert("输入的字符长度必须要大于等于8位!");
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
	//当查询条件不是合同号，合同状态时，默认查询合同状态为已签署、审批通过，已注册、退货、超期未注册、已结清、退货结清、提前还款结清
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
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置为只读
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");//新增参数传递：2013-5-9
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	
	String AppUrl = CodeCache.getItem("PrintAppUrl","0010").getItemAttribute();
	String JQMUrl = CodeCache.getItem("PrintAppUrl","0013").getItemAttribute();
	String FCUrl = CodeCache.getItem("PrintAppUrl","0015").getItemAttribute();

	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List04;Describe=定义按钮;]~*/%>
	<%
	//依次为：
		//0.是否显示
		//1.注册目标组件号(为空则自动取当前组件)
		//2.类型(Button/ButtonWithNoAction/HyperLinkText/TreeviewItem/PlainText/Blank)
		//3.按钮文字
		//4.说明文字
		//5.事件
		//6.资源图片路径

	String sButtons[][] = {
		{"true","","Button","更改地标","更改地标","changeLandmark()",sResourcesPath},
		{"true","","Button","快递签收","快递签收","receivePackage()",sResourcesPath},
		{"true","","Button","质量标注","质量标注","qualityGrade()",sResourcesPath},
		{"true","","Button","合同详情","合同详情","contractDetail()",sResourcesPath},	
		{"false","","Button","提交注册","提交注册","doSubmit()",sResourcesPath},
		{"true","","Button","电子合同调阅","电子合同调阅","viewApplyReport()",sResourcesPath},
		{"true","","Button","第三方协议调阅","第三方协议调阅","creatThirdTable()",sResourcesPath},
		{"false","","Button","生成错误短信","生成错误短信","ss()",sResourcesPath},
		{"true","","Button","影像","影像","imageView()",sResourcesPath},
		{"true","","Button","地标信息记录","地标信息记录","sLankStatus()",sResourcesPath},
		{CurUser.getRoleTable().contains("2001")?"true":"false","","Button","导出EXCEL","导出EXCEL","exportExcel()",sResourcesPath},
		{"true","","Button","快递签收管理","快递签收管理","expressManage()",sResourcesPath},
	};
	
	%>
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script type="text/javascript">

	//---------------------定义按钮事件------------------------------------
	/*~[Describe=新增记录;InputParam=无;OutPutParam=无;]~*/
	var  temp=false;
	
	//Excel导出功能呢	
	function exportExcel(){
		amarExport("myiframe0");
	}
	//end by pli2 20140417	
	
	function changeLandmark(){
		var sSerialNo=getItemValue(0,getRow(),"serialNo");
		var sCustomerName=getItemValue(0,getRow(),"customerName");
		var sLandmarkStatus=getItemValue(0,getRow(),"landmarkStatus1");
		if(typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert(getHtmlMessage(1));  //请选择一条记录！
			return;
		}
		//var landMarkNo=RunMethod("GetElement","GetElementValue","itemNo,code_library,codeno='LandMarkStatus' and itemName='"+sLandmarkStatus+"'");
		//RunMethod("ModifyNumber","GetModifyNumber","business_contract,oldLandmarkStatus='"+landMarkNo+"',serialNo='"+sSerialNo+"'");//记录上一次地标状态
		//var sLandmarkStatus=RunMethod("GetElement","GetElementValue","landmarkStatus,business_contract,serialNo='"+sSerialNo+"'");//查出当前地标状态
		if(sLandmarkStatus!=null&& sLandmarkStatus!="5"){
			if(confirm("您真的确定更改地标吗")){
				RunMethod("PublicMethod","UpdateColValue","String@LandMarkStatus@"+'5'+"@String@oldLandmarkStatus@"+sLandmarkStatus+",business_contract,String@serialNo@"+sSerialNo);
				RunMethod("InsertLandmark","GetLandmark","'<%=CurUser.getUserID()%>','<%=StringFunction.getToday()%>','"+sLandmarkStatus+"','5','"+sSerialNo+"','"+sCustomerName+"','050','"+getSerialNo("EVENT_INFO", "serialno", "")+"'");//向EVENT_INFO表中插入地标记录信息
			}
		}else if(sLandmarkStatus!=null&& sLandmarkStatus=="5"){
			alert("地标状态已是总部！不需要更改！");
		}
		reloadSelf();
	}
	
	function qualityGrade(){
		var sSerialNo=getItemValue(0,getRow(),"serialNo");	
		var sQualityGrade=getItemValue(0,getRow(),"qualityGrade"); //质量登记
		var ssLandmarkStatus=getItemValue(0,getRow(),"landmarkStatus");//地标状态
		var sCustomerName = getItemValue(0,getRow(),"customerName");//客户名称
		if(typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert(getHtmlMessage(1));  //请选择一条记录！
			return;
		}
	
		var oldLandmark=RunMethod("GetElement","GetElementValue","oldLandmarkStatus,business_contract,serialNo='"+sSerialNo+"'");//查出上一次地标状态 
		if(oldLandmark==""){
			oldLandmark="总部";
		}else{
			oldLandmark=RunMethod("GetElement","GetElementValue","itemName,code_library,codeno='LandMarkStatus' and itemNo='"+oldLandmark+"'");//找到对应的名称
		}
		var sLandmarkStatus=RunMethod("GetElement","GetElementValue","landmarkStatus,business_contract,serialNo='"+sSerialNo+"'");
		var sContractStatus=RunMethod("GetElement","GetElementValue","ContractStatus,business_contract,serialNo='"+sSerialNo+"'");//查询合同的状态
		//add by phe 2015/05/05 CCS-529 PRM-211 增加合同质量标注的条件
		var sOperatorMode=RunMethod("GetElement","GetElementValue","OperatorMode,business_contract,serialNo='"+sSerialNo+"'");//查询合同的运作模式
		
		if(sOperatorMode=='01'||sOperatorMode=='05'){//CCS-971,添加sContractStatus=='160'提前还款结清状态 20150720 huzp
			if(!(sContractStatus=='020'||sContractStatus=='050'||sContractStatus=='160'||sContractStatus=='110'||sContractStatus=='120')){
				alert("中域ALDI或教育ALDI的合同只有已注册、已签署、已结清、退货结清、提前还款结清才可以质量标注！");
				return;
			}		
		}else{//CCS-971,添加sContractStatus=='160'提前还款结清状态 20150720 huzp
			if(!(sContractStatus=='050'||sContractStatus=='160'||sContractStatus=='110'||sContractStatus=='120')){
				alert("除中域ALDI或教育ALDI以外的合同只有已注册、已结清、退货结清、提前还款结清才可以质量标注！");
				return;
			}
		}
		//end by phe 2015/05/05
		if(sLandmarkStatus!=null&& sLandmarkStatus=="5"){
			AsControl.OpenView("/Common/WorkFlow/PutOutApply/QualityGradeFrame.jsp","serialNo="+sSerialNo+"&CustomerName="+sCustomerName+"&qualityGrade="+sQualityGrade+"&landmarkStatus="+ssLandmarkStatus+"&doWhere=<%=doTemp.WhereClause%>&oldLandmark="+oldLandmark,"_self");
		}else{
			alert("请先更改地标！谢谢！ ");
		}
	}
	
	function doSubmit(){
		var sSerialNo=getItemValue(0,getRow(),"serialNo");
		var inputUserID=getItemValue(0,getRow(),"INPUTUSERID");
		var sQualityGrade=getItemValue(0,getRow(),"qualityGrade"); 
		var sContractStatus=getItemValue(0,getRow(),"contractStatus"); 
		if(typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert(getHtmlMessage(1));  //请选择一条记录！
			return;
		}
		if(sContractStatus!="审批通过"){
			alert("该合同不是审批通过合同,不允许提交!");
			return;
		}
		var userType=RunMethod("GetElement","GetElementValue","userType,user_info,userID='"+inputUserID+"' and isCar='02'");
		if(userType=="01"){
			alert("此合同是内部员工合同，不允许提交！");
			return;
		}
		if(sQualityGrade!=null&&sQualityGrade=="关键错误"){
			alert("质量等级为关键错误！不允许提交！");
			return;
		}
		if(confirm("您真的确定提交注册吗？")){
			RunMethod("ModifyNumber","GetModifyNumber","business_contract,upUserName='<%=CurUser.getUserID()%>',serialNo='"+sSerialNo+"'");
			RunMethod("ModifyNumber","GetModifyNumber","business_contract,contractStatus='020',serialNo='"+sSerialNo+"'");
			RunMethod("ModifyNumber","GetModifyNumber","business_contract,SignedDate='<%=StringFunction.getToday()%>',serialNo='"+sSerialNo+"'");//修改签署日期
			reloadSelf();
		}
	}
//  ==============================  打印格式化报告  公共方法  add by phe   ============================================================
	
	/*~[Describe=打印格式化报告;InputParam=无;OutPutParam=无;]~*/
	function printTable(type){
			var sObjectNo = getItemValue(0,getRow(),"serialNo");
			var sUserID = "<%=CurUser.getUserID()%>";
			var sOrgID = "<%=CurOrg.getOrgID()%>";
			if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
				alert(getHtmlMessage('1'));//请选择一条信息！
				return;
			}		
			//打印APP端的合同
			var sSureType = getItemValue(0,getRow(),"SureTypeCode");
			var url = "";  
			if(sSureType=="app"||sSureType=="APP"){
				//sObjectNo="19151136003";
				alert("此合同来源于APP!");
				url="<%=AppUrl%>"+sObjectNo;
				window.open(url);
				return;
			}else if(sSureType=="JQM"){
				alert("此合同来源于借钱么!");
				url="<%=JQMUrl%>"+sObjectNo;
				window.open(url);
				return;
			}else if(sSureType=="FC"){
				alert("此合同来源于蜂巢!");
				url="<%=FCUrl%>"+sObjectNo;
				window.open(url);
				return;
			}
			
			var sObjectType = type;
			//alert(sObjectNo+"sObjectNo,sSerialNo="+sSerialNo);
			if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
				alert(getHtmlMessage('1'));//请选择一条信息！
				return;
			}else{
				//检查出帐通知单是否已经生成
				var sReturn = PopPageAjax("/FormatDoc/GetReportFile.jsp?DocID="+sDocID+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType,"","");
				if(sReturn == "move"){
					//alert("以前生成的文件已经被移动了，无法展示，也不可重新生成");
					return;
				}else if (sReturn == "false"){ //未生成出帐通知单
					var  returnValue = RunJavaMethodSqlca("com.amarsoft.app.billions.DocCommon","getDocIDAndUrl","serialNo="+sObjectNo+",type="+type);
					if(returnValue=="False"||typeof(returnValue)=="undefined"||returnValue.length==0){
						alert("请联系系统管理员检查合同模板配置和合同信息!");
						return;
					}
					var sDocID = 	returnValue.split("@")[0];
					var sUrl = returnValue.split("@")[1];
					var sSerialNo = getSerialNo("FORMATDOC_RECORD", "serialNo", "TS");
					//生成出帐通知单	
						PopPage(sUrl+"?DocID="+sDocID+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType+"&SerialNo="+sSerialNo+"&Method=4&FirstSection=1&EndSection=0&rand="+randomNumber(),"myprint10","dialogWidth=10;dialogHeight=1;status:no;center:yes;help:no;minimize:yes;maximize:no;border:thin;statusbar:no");
					//记录生成动作
					RunJavaMethodSqlca("com.amarsoft.app.billions.InsertFormatDocLog", "recordFormatDocLog", "serialNo="+sSerialNo+",orgID="+sOrgID+",userID="+sUserID+",occurType=produce");
				}else{
					//记录查看动作
					RunJavaMethodSqlca("com.amarsoft.app.billions.InsertFormatDocLog", "recordFormatDocLog", "serialNo="+sReturn+",orgID="+sOrgID+",userID="+sUserID+",occurType=view");
				}
				//获得加密后的出帐流水号
				var sEncryptSerialNo = PopPageAjax("/PublicInfo/EncryptSerialNoAction.jsp?EncryptionType=MD5&SerialNo="+sObjectNo);
				//通过　serverlet 打开页面
				var CurOpenStyle = "width=720,height=540,top=20,left=20,toolbar=no,scrollbars=yes,resizable=yes,status=yes,menubar=no,";	
				//+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType  add by cdeng 2009-02-17	
				OpenPage("/FormatDoc/POPreviewFile.jsp?EncryptSerialNo="+sEncryptSerialNo+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType,"_blank02",CurOpenStyle); 
			}
	}
	//   ============================== end  打印格式化报告 ============================================================
	
		
	/*~[Describe= 查看电子合同;]~*/
    function viewApplyReport(){
    		printTable("ApplySettle");
    }
	
	/*~[Describe=打印第三方协议;]~*/
	function creatThirdTable(){
			printTable("ThirdSettle");
	}
	
	function contractDetail(){
		var sSerialNo = getItemValue(0,getRow(),"serialNo");
		sObjectType="BusinessContract";
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert(getHtmlMessage('1'));//请选择一条信息！
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
            alert(getHtmlMessage('1'));//请选择一条信息！
            return;
        }
        var checkStatu = "2";
        if(uploadFlag == '已上传' || uploadFlag == '未上传'){
        	checkStatu ="1";
        }
        if(uploadFlag == '无需上传'){
        	checkStatu ="3";
        }
        RunMethod("公用方法","UpdateColValue","BUSINESS_CONTRACT,checkstatus,"+checkStatu+",serialNo='"+sObjectNo+"'");
//	     var param = "ObjectType=Business&TypeNo=20&ObjectNo="+sObjectNo;
//	     AsControl.PopView( "/ImageManage/ImageViewNew.jsp", param, "" );

	     var param = "ObjectType=Business&TypeNo=20&RightType=100&ObjectNo="+sObjectNo;
	     AsControl.PopView( "/ImageManage/ImageView.jsp", param, "" );
    }
    
    function sLankStatus(){
    	var sCount=RunMethod("Unique","uniques","EVENT_INFO,SERIALNO,type='050'");
		if(sCount=="Null"){
			alert("没有更改地标状态记录！");
			return;
		}
		AsControl.OpenView("/Common/WorkFlow/PutOutApply/LookLankStatusList.jsp","doWhere=<%=doTemp.WhereClause%>","right","");
    }
    
  	//快递签收
    function receivePackage(){
    	AsControl.PopPage("/Common/WorkFlow/PutOutApply/receivePackage.jsp","","dialogWidth=40;dialogheight=auto;scrollbars:yes;");
    	
    }
    
    /**[@description=快递签收管理  @param=null @return=nulll]**/
    function expressManage(){
    	AsControl.OpenView("/Common/WorkFlow/PutOutApply/ExpressManageList.jsp","","right");
    }
    
	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List07;Describe=页面装载时，进行初始化;]~*/%>
<script type="text/javascript">
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	showFilterArea();
</script>
<%/*~END~*/%>

<%@	include file="/IncludeEnd.jsp"%>

