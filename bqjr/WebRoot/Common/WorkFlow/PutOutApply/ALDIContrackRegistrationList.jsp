<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author: PHE 2015-3-4
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
	String PG_TITLE = "ALDI合同注册"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>



<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info03;Describe=定义数据对象;]~*/%>
	<%
	String sDoWhere  = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("doWhere"));	
	if(sDoWhere==null) sDoWhere="";	
	String BusinessDate = SystemConfig.getBusinessDate();
	
	String sHeaders[][] = { 							
			{"serialNo","合同号"},
			{"CustomerID","客户编号"},
			{"certID","身份证号"},
			{"customerName","客户姓名"},
			{"ApplyType","申请类型"},
			{"SubProductTypeName","产品类型"},
			{"SubProductType","产品类型"},
			{"Stores","门店号"},
			{"businessType","产品代码"},
			{"City","门店城市"},
			{"StoreCityNo","门店城市"},
			{"contractStatus","合同状态"},
			{"contractStatus1","合同状态"},
			{"inputdate","申请日期"},
			{"SignedDate","签署日期"},
			{"salesExecutiveName","销售代表姓名"},
			{"salesExecutive","销售代表"},
			{"operatorMode","运作模式"},
			{"OperatorModeType","运作模式"},
			{"SureType","业务来源"},
			{"SureTypeCode","业务来源"},
			{"landmarkStatus","地标状态"},
			{"landmarkStatus1","地标状态"},
			{"qualityGrade","质量等级"},	
			{"qualityGrade1","质量等级"},
			{"lastCheckTime","检查日期"},
			{"upUserName","检查人"},
			{"TFError","是否曾有关键错误"},
			{"TFErrorCode","是否曾有关键错误"},
			{"salesExecutive","销售代表ID"},
			{"SalesManager","销售经理ID"}
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
	 
	doTemp.multiSelectionEnabled=true;
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
		{"false","","Button","更改地标","更改地标","changeLandmark()",sResourcesPath},
		{"false","","Button","质量标注","质量标注","qualityGrade()",sResourcesPath},
		{"false","","Button","合同详情","合同详情","contractDetail()",sResourcesPath},	
		{"false","","Button","提交注册","提交注册","doSubmit()",sResourcesPath},
		{"true","","Button","提交放款","提交放款","doSubmit()",sResourcesPath},
		{"false","","Button","生成错误短信","生成错误短信","ss()",sResourcesPath},
		{"false","","Button","影像","影像","imageView()",sResourcesPath},
		{"false","","Button","地标信息记录","地标信息记录","sLankStatus()",sResourcesPath},
		{CurUser.getRoleTable().contains("2001")?"true":"false","","Button","导出EXCEL","导出EXCEL","exportExcel()",sResourcesPath},

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
		var sSerialNoS = getItemValueArray(0,"serialNo");
		var sSerialNo = sSerialNoS[0];
		var sCustomerNameS = getItemValueArray(0,"customerName");
		var sLandmarkStatusS = getItemValueArray(0,"customerName");
		if(typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert(getHtmlMessage(1));  //请选择一条记录！
			return;
		}
		if(confirm("您真的确定更改地标吗")){
		for(var i=0;i<sSerialNoS.length;i++){
		sSerialNo = sSerialNoS[i];
		var sCustomerName=sCustomerNameS[i];
		var sLandmarkStatus=sLandmarkStatusS[i];
		
		var landMarkNo=RunMethod("GetElement","GetElementValue","itemNo,code_library,codeno='LandMarkStatus' and itemName='"+sLandmarkStatus+"'");
		RunMethod("ModifyNumber","GetModifyNumber","business_contract,oldLandmarkStatus='"+landMarkNo+"',serialNo='"+sSerialNo+"'");//记录上一次地标状态
		var sLandmarkStatus=RunMethod("GetElement","GetElementValue","landmarkStatus,business_contract,serialNo='"+sSerialNo+"'");//查出当前地标状态
		if(sLandmarkStatus!=null&& sLandmarkStatus!="5"){
			/* if(confirm("您真的确定更改地标吗")){ */
				RunMethod("ModifyNumber","GetModifyNumber","business_contract,landmarkStatus='5',serialNo='"+sSerialNo+"'");
				RunMethod("InsertLandmark","GetLandmark","'<%=CurUser.getUserID()%>','<%=StringFunction.getToday()%>','"+landMarkNo+"','5','"+sSerialNo+"','"+sCustomerName+"','050','"+getSerialNo("EVENT_INFO", "serialno", "")+"'");//向EVENT_INFO表中插入地标记录信息
				
			/* } */
		}/* else if(sLandmarkStatus!=null&& sLandmarkStatus=="5"){
			alert("地标状态已是总部！不需要更改！");
		} */
		}
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
		if(sLandmarkStatus!=null&& sLandmarkStatus=="5"){
			
			AsControl.OpenView("/Common/WorkFlow/PutOutApply/ALDIQualityGradeFrame.jsp","serialNo="+sSerialNo+"&CustomerName="+sCustomerName+"&qualityGrade="+sQualityGrade+"&landmarkStatus="+ssLandmarkStatus+"&doWhere=<%=doTemp.WhereClause%>&oldLandmark="+oldLandmark,"_self");
		}else{
			alert("请先更改地标！谢谢！ ");
		}
	}
	
	function doSubmit(){
		/***********CCS-1041,系统跑批时不能登录系统 huzp 20151217**************************************/
		var sTaskFlag = RunMethod("公用方法","GetColValue","system_setup,taskflag,1=1");
		if(sTaskFlag=="1"){
			alert("系统正在跑批，暂时无法提交放款!");
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
				alert(getHtmlMessage(1));  //请选择一条记录！
				return;
			}
			/*  if(sContractStatus!="审批通过"){
				alert("该合同不是审批通过合同,不允许提交!");
				return;
			} */
		 	for(var i=0;i<sSerialNoS.length;i++){
			sSerialNo = sSerialNoS[i];
			var inputUserID=inputUserIDS[i];
			var sQualityGrade=sQualityGradeS[i];
			var sContractStatus=sContractStatuS[i];
			
			//alert(sContractStatus);
			 if(sContractStatus!="已签署"){
				alert("该合同"+sSerialNo+"不是已签署合同,不允许提交!");
				return;
			} 
			var userType=RunMethod("GetElement","GetElementValue","userType,user_info,userID='"+inputUserID+"' and isCar='02'");
			if(userType=="01"){
				alert("此合同"+sSerialNo+"是内部员工合同，不允许提交！");
				return;
			}
			if(sQualityGrade!=null&&sQualityGrade=="关键错误"){
				alert("此合同"+sSerialNo+"质量等级为关键错误！不允许提交！");
				return;
			}
			} 
			if(confirm("您真的确定提交放款吗？")){
				for(var i=0;i<sSerialNoS.length;i++){
				sSerialNo=sSerialNoS[i];
				RunMethod("ModifyNumber","GetModifyNumber","business_contract,updateUserID='<%=CurUser.getUserID()%>',serialNo='"+sSerialNo+"'");
				RunMethod("ModifyNumber","GetModifyNumber","business_contract,contractStatus='050',serialNo='"+sSerialNo+"'");
				RunMethod("ModifyNumber","GetModifyNumber","business_contract,REGISTRATIONDATE='<%=BusinessDate%>',serialNo='"+sSerialNo+"'");//修改签署日期
				}
				reloadSelf();
				
			}
		}
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
        if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
            alert(getHtmlMessage('1'));//请选择一条信息！
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
			alert("没有更改地标状态记录！");
			return;
		}
		AsControl.OpenView("/Common/WorkFlow/PutOutApply/ALDILookLankStatusList.jsp","doWhere=<%=doTemp.WhereClause%>","right","");
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

