<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%
	/* --页面说明: 示例详情页面-- */
	String PG_TITLE = "示例详情页面";

	// 获得页面参数
	String sObjectNO =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
	String sSerialNO =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("TaskNo"));
	String sPhaseNo = DataConvert.toRealString(iPostChange,CurComp.getParameter("PhaseNo"));
	String sFlowNo = DataConvert.toRealString(iPostChange,CurComp.getParameter("FlowNo"));
	String oldContractStatus="";//旧合同状态
	String oldInputDate="";//就申请日期
	String sureType = "";//单据种类
	if(sObjectNO==null) sObjectNO="";
	if(sFlowNo==null) sFlowNo="";
	if(sPhaseNo==null) sPhaseNo="";
	
	//获取最新的字段数据
	String sSql2 = "select Max(SerialNo) as SerialNo from FLow_Task where ObjectNo =:ObjectNo and FlowNo =:FlowNo";
	sSerialNO = Sqlca.getString(new SqlObject(sSql2)
			.setParameter("ObjectNo", sObjectNO).setParameter("FlowNo", sFlowNo));
	sSql2 = "select PhaseNo from Flow_Task where ObjectNo =:ObjectNo and FlowNo =:FlowNo and SerialNo =:SerialNo";
	sPhaseNo = Sqlca.getString(new SqlObject(sSql2)
			.setParameter("ObjectNo", sObjectNO).setParameter("FlowNo", sFlowNo).setParameter("SerialNo", sSerialNO));
	
	String sTempletNo = "NCIICTaskCreditInfo";//模型编号
	
	//-- add by tangyb CCS-1236 PRM-773 手机外呼核查页面增加流程名称 20160114 --//
	String pfname = Sqlca.getString("select PhaseName||','||flowname from Flow_Task where SerialNo = '"+sSerialNO+"'");
	
	String[] pfnames = pfname.split(",");
	
	String sPhaseName = pfnames[0]; //流程节点名称
	String flowname = pfnames[1]; // 流程名称
	//-- end --//
	
	//查出合同的子类型   add by dahl 2015-4-4
	String	SubProductTypesSql = " select SubProductType from BUSINESS_CONTRACT where  SerialNo =:SerialNo ";
	String subProductTypename = Sqlca.getString(new SqlObject(SubProductTypesSql).setParameter("SerialNo", sObjectNO));
	//end by dahl
		
	/* 是否需要弹出页面选择意见 */
	boolean needPage = false;
	
	//暂时把各个阶段的显示业务模板编号配置到PHASEATTRIBUTE字段上(对应流程配置中的'阶段属性')
		/* {DONO:xxxInfo}{NEEDPAGE:true}  */
		ASResultSet rs = Sqlca.getASResultSet(new SqlObject("select PhaseAttribute,PHASEDESCRIBE from FLOW_MODEL where flowNo=:flowNo"
			+ " and PhaseNo=:PhaseNo and PhaseAttribute is not null  ")
				.setParameter("flowNo", sFlowNo).setParameter("PhaseNo", sPhaseNo));
		String str = Sqlca.getString("select PhaseAttribute from FLOW_MODEL where flowNo='"+sFlowNo+"' and PhaseNo='"+sPhaseNo+"' and PhaseAttribute is not null  ");
		System.out.println("*********"+str);
		if( ! StringX.isEmpty(str)){
			String[] strs = StringX.parseArray(str);
			for(String s: strs){
				String tempStr = s.replace(" ", "");
				if(tempStr.substring(0, 4).equalsIgnoreCase("DONO")){
					sTempletNo = tempStr.substring(5);
				}else if(tempStr.substring(0,8).equalsIgnoreCase("NEEDPAGE")){
					needPage = StringX.parseBoolean(tempStr.substring(9));
				}
			}
		}
		
	String sOfficePhoneNum = "";
	String sSelOption = "";
	// 如果办公电话模板，获取上级ID5电话
	if ("OfficePhoneInfo".equals(sTempletNo)) {
		String sOpSql = "SELECT PHASEOPINION,PHASEOPINION3 FROM FLOW_OPINION WHERE SERIALNO=(SELECT SERIALNO FROM FLOW_TASK WHERE OBJECTNO=:ObjectNo AND PHASENO='0014')";
		ASResultSet opResult = Sqlca.getASResultSet(new SqlObject(sOpSql).setParameter("ObjectNo", sObjectNO));
		if (opResult.next()) {
			sOfficePhoneNum = opResult.getString("PHASEOPINION3");
			sSelOption = opResult.getString("PHASEOPINION");
			
			if (sOfficePhoneNum == null) sOfficePhoneNum = "";
			if (sSelOption == null) sSelOption = "";
		}
		if (opResult !=null) opResult.close();
	}
		
	//手机号码外呼核查 并且为学生贷或成人贷，使用模版：CellTelInfoEduAdult edit by Dahl 2015-4-4 
	if("CellTelInfo".equals(sTempletNo) && ("5".equals(subProductTypename) || "4".equals(subProductTypename)) ){
		sTempletNo = "CellTelInfoEduAdult";
	}
	
	if("FamilyMemberPhoneInfo".equals(sTempletNo) && ("5".equals(subProductTypename) ) ){
		sTempletNo = "FamilyMemberPhoneInfoEduAdult";
	}
	if("FamilyMemberPhoneInfo".equals(sTempletNo) && ("4".equals(subProductTypename)) ){
		sTempletNo = "FamilyMemberPhoneInfoedu4";
	}
	if("XuexinChecked".equals(sTempletNo) && "5".equals(subProductTypename)  ){ //学生贷
		sTempletNo = "XuexinCheckedStu";
	}
	//end by dahl
	
	//获取当前客户名称、
	String customerID="";
	rs = Sqlca.getASResultSet("select customerID,suretype from business_contract where SerialNo = '"+sObjectNO+"'");
	if (rs.next()) {
		customerID = rs.getString("customerID");
		sureType = rs.getString("suretype");
	}
	rs.getStatement().close();
	//获取当前合同上一次申请合同号
	String oldSerialNo=Sqlca.getString(new SqlObject("select serialno from business_contract where customerid=:customerid and serialno<:serialno  order by serialno desc")
	                  .setParameter("customerid", customerID).setParameter("serialno", sObjectNO));
	//获取当前合同上一次申请的合同状态和申请日期
	String sSql1="select getitemname('ContractStatus',contractStatus) as contractStatus,inputDate from business_contract where serialno=:serialno";
	ASResultSet rs2=Sqlca.getASResultSet(new SqlObject(sSql1).setParameter("serialno", oldSerialNo));
	if(rs2.next()){
		oldContractStatus=rs2.getString("contractStatus");
		oldInputDate=rs2.getString("inputDate");
	}
	rs2.getStatement().close();
	
	int TotalCount=0;
	ASResultSet rs3 = Sqlca.getResultSet(new SqlObject("select count(1) as TotalCount from store_info where city='440300' and sno=(select stores from business_contract where serialno=:serialno)")
		.setParameter("serialno", sObjectNO));
	if(rs3.next()){
		TotalCount=rs3.getInt("TotalCount");
	}
	rs3.getStatement().close();
	
	// 通过DW模型产生ASDataObject对象doTemp
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	if(sFlowNo.equals("WF_MEDIUM02")&& sPhaseNo.equals("0070")){
		doTemp.setVisible("LOANCARDNO", false);
	}
	
	if(sFlowNo.equals("WF_HARD")&& sPhaseNo.equals("0140")){
		doTemp.setVisible("LOANCARDNO", false);
	}
	if(sFlowNo.equals("WF_MEDIUM")&& sPhaseNo.equals("0120")){
		doTemp.setVisible("LOANCARDNO", false);
	}
	
	// add by dahl ccs-991 如果是“”合影城市则来源标红
	if( "NCIICTaskCreditInfo".equals(sTempletNo) ){
		String sSql = "SELECT 1 FROM pilot_city pc,store_info si,BUSINESS_CONTRACT BC where pc.subproducttype='0' and pc.city=si.city and si.sno=bc.stores and bc.serialno=:serialNo and pc.verifytype='A' ";
		String flag = Sqlca.getString(new SqlObject(sSql).setParameter("serialNo", sObjectNO));
		if( "1".equals(flag) ){
			doTemp.setHTMLStyle("SureType","style={color:red}");
		}
		if(!"NCIIC照片比对".equals(sPhaseName)){
			doTemp.setVisible("isProcessing", false);
		}
	}
	// end by dahl
	
	// add by fangxq CCS-1219 合同有效性检查环节中，来源标红   20160107
	if("APPInfo".equals(sTempletNo)){
		doTemp.setHTMLStyle("SureType","style={color:red}");
	}
	// end by fangxq
	
	// SSISocialty info dispay control
	String sCostNo = "";
	String sAddress = ""; 
	String sTel = "";
	String sLowCost = "";
	String sHighCost = "";
	if ("SSISocialSecurity".equals(sTempletNo)) {
		String sSql = "select SerialNo,Address,Tel,LowCost,HighCost from SocialInfoQuery where substr(City,1,4)=(Select substr(WorkAdd,1,4) from Ind_Info where CustomerId= (SELECT CustomerID FROM Business_Contract WHERE SerialNo=:SerialNo))";
		ASResultSet rs1 = Sqlca.getResultSet(new SqlObject(sSql).setParameter("SerialNo", sObjectNO));
		if (rs1.next()) {
			sCostNo = rs1.getString("SerialNo");
			sAddress = rs1.getString("Address");
			sTel = rs1.getString("Tel");
			sLowCost = rs1.getString("LowCost");
			sHighCost = rs1.getString("HighCost");
		}
		rs1.getStatement().close();
	}
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      // 设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; // 设置是否只读 1:只读 0:可写
	
	//-- add by tangyb CCS-1236 PRM-773 手机外呼核查页面增加流程名称 20160114 --//
	if("WF_OFFICETEST".equals(sFlowNo) && 
			("手机外呼核查".equals(sPhaseName) 
				|| "办公电话外呼核查".equals(sPhaseName)
				|| "其他联系人信息审核".equals(sPhaseName)
				|| "同事联系电话外呼核查".equals(sPhaseName))){
		sPhaseName = sPhaseName + "（" + flowname + "）";
	}
	//-- end --//

	if ("JQM".equals(sureType)) {
		out.print("&nbsp;&nbsp;&nbsp;<b>"+sPhaseName+"</b><b style=\"color: red;\">（借钱么）</b>");
	}else if ("EBF".equals(sureType)) {
		out.print("&nbsp;&nbsp;&nbsp;<b>"+sPhaseName+"</b><b style=\"color: red;\">（易佰分）</b>");
	} else if ("PC".equals(sureType) || "APP".equals(sureType) || "FC".equals(sureType)) {
		out.print("&nbsp;&nbsp;&nbsp;<b>"+sPhaseName+"</b>");
	}else{ //CCS-1280
		String c_sql = "select l.itemname from business_credit c left join code_library l on c.company = l.itemno and l.codeno='Company' where c.contract_no = :SerialNo";
		ASResultSet rs1 = Sqlca.getResultSet(new SqlObject(c_sql).setParameter("SerialNo", sObjectNO));
		String company = "";
		if (rs1.next()) {
			company = rs1.getString("itemname");
			if (company == null) company = "";
			out.print("&nbsp;&nbsp;&nbsp;<b>"+sPhaseName+"</b><b style=\"color: red;\">（"+company+"）</b>");
		}
		rs1.getStatement().close();
	}
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sObjectNO);//传入参数,逗号分割
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	String sButtons[][] = {
			{"false","","Button","查看审核提醒","查看审核提醒","CECreditViewInfo()",sResourcesPath},
			{"false","","Button","查看同盾详情","查看同盾详情","CEShieldPlatInfo()",sResourcesPath},//新增同盾详情界面 add by lgq 20151030
		};
		
		if("CECreditInfo".equals(sTempletNo)){
			sButtons[0][0] = "true";
			sButtons[1][0] = "true";
		}

	
%>
<%@include file="/Resources/CodeParts/Info05.jsp"%>
<script language="javascript" type="text/javascript">
	var bIsInsert = false; // 标记DW是否处于“新增状态”
	function saveRecord(sPostEvents){
	}
	
	function saveAndGoBack(){
	}
	
	function goBack(){
	}

	<%/*~[Describe=执行插入操作前执行的代码;]~*/%>
	function beforeInsert(){
	}
	
	<%/*~[Describe=执行更新操作前执行的代码;]~*/%>
	function beforeUpdate(){
		
	}
	
	<%/*~[Describe=拨打软本地电话;]~*/%>
	function btnMakeCall_Click(label, flag)
	{
		//alert("97"+label+"label"+flag);
		var sRecordName = "手机号";
		var TelNo = "";
		var sTempNo = "<%=sTempletNo%>";
		if (sTempNo=="ID5HomePhoneInfo") {	// 住宅电话
			TelNo = getItemValue(0, 0, "FamilyTel");
			sRecordName = getColLabel(0, "FamilyTel");
			if(TelNo.length == 0){
				alert(sRecordName+"不能为空！");
				return;
			}	
			TelNo="97"+TelNo;
		} else if (sTempNo=="OtherManageInfo") {	// 联系人电话
			TelNo = getItemValue(0, 0, "ContactTel");
			sRecordName = getColLabel(0, "ContactTel");
			if(TelNo.length == 0){
				alert(sRecordName+"不能为空！");
				return;
			}
			TelNo="97"+TelNo;
		} else if (sTempNo=="ID5PhoneInfo") { // 办公电话
			TelNo = getItemValue(0, 0, "WorkTel");
			sRecordName = getColLabel(0, "WorkTel");
			if(TelNo.length == 0){
				alert(sRecordName+"不能为空！");
				return;
			}
			TelNo="97"+TelNo;
		} else if (sTempNo=="DormPhoneInfo") {	// DormPhoneInfo
			TelNo = getItemValue(0, 0, "FamilyTel");
			sRecordName = getColLabel(0, "FamilyTel");
			if(TelNo.length == 0){
				alert(sRecordName+"不能为空！");
				return;
			}
			TelNo="97"+TelNo;
		} else if (sTempNo=="CellTelInfo") { // 
			 if(label=="01"){
				var TelNo = getItemValue(0, 0, "MobileOldPhone");
				sRecordName = getColLabel(0, "MobileOldPhone");
				if(TelNo.length == 0){
					alert(sRecordName+"不能为空！");
					return;
				}
				TelNo="96"+TelNo;
				}else{ 
			TelNo = getItemValue(0, 0, "MobileTelephone");
			sRecordName = getColLabel(0, "MobileTelephone");
			if(TelNo.length == 0){
				alert(sRecordName+"不能为空！");
				return;
			}
			TelNo="96"+TelNo;
				 } 
		} else if (sTempNo=="OfficePhoneInfo") { // 
			 if(label=="01"){
				var ID5Phone = getItemValue(0, 0, "ID5Phone");
					TelNo =ID5Phone.replace("-","");
					TelNo =TelNo.replace("+","");
				sRecordName = getColLabel(0, "ID5Phone");
				if(TelNo.length == 0){
					alert(sRecordName+"不能为空！");
					return;
				}
				 TelNo="97"+TelNo;
			}else{ 
			TelNo = getItemValue(0, 0, "WorkTel");
			sRecordName = getColLabel(0, "WorkTel");
			if(TelNo.length == 0){
				alert(sRecordName+"不能为空！");
				return;
			}
			TelNo="97"+TelNo;
			 } 
		} else if (sTempNo == "FamilyMemberPhoneInfo") {
			TelNo = getItemValue(0, 0, "FamilyTel");
			sRecordName = getColLabel(0, "FamilyTel");
			if(TelNo.length == 0){
				alert(sRecordName+"不能为空！");
				return;
			}
			TelNo="97"+TelNo;
		}
		
		window.location.href="http://HiAgentHost.com/Command.htm?InvokeId=123&CommandName=Letsgo&ContractID=<%=sObjectNO%>&RecordName="+sRecordName;
	    window.location.href="http://HiAgentHost.com/Command.htm?InvokeId=123&CommandName=ecMakeCall&CustomerNumber="+TelNo+"&CallerParty=";

	}
	//btnMakeCall_Click_Out(label, flag)
	<%/*~[Describe=拨打软外地电话;]~*/%>
	function btnMakeCall_Click_Out(label, flag)
	{
		//alert("970");
		var sRecordName = "手机号";
		var TelNo = "";
		var sTempNo = "<%=sTempletNo%>";
		if (sTempNo=="ID5HomePhoneInfo") {	// 住宅电话
			TelNo = getItemValue(0, 0, "FamilyTel");
			sRecordName = getColLabel(0, "FamilyTel");
			if(TelNo.length == 0){
				alert(sRecordName+"不能为空！");
				return;
			}
			TelNo="970"+TelNo;
		} else if (sTempNo=="OtherManageInfo") {	// 联系人电话
			TelNo = getItemValue(0, 0, "ContactTel");
			sRecordName = getColLabel(0, "ContactTel");
			if(TelNo.length == 0){
				alert(sRecordName+"不能为空！");
				return;
			}
			TelNo="970"+TelNo;
		} else if (sTempNo=="ID5PhoneInfo") { // 办公电话
			TelNo = getItemValue(0, 0, "WorkTel");
			sRecordName = getColLabel(0, "WorkTel");
			if(TelNo.length == 0){
				alert(sRecordName+"不能为空！");
				return;
			}
			TelNo="970"+TelNo;
		} else if (sTempNo=="DormPhoneInfo") {	// DormPhoneInfo
			TelNo = getItemValue(0, 0, "FamilyTel");
			sRecordName = getColLabel(0, "FamilyTel");
			if(TelNo.length == 0){
				alert(sRecordName+"不能为空！");
				return;
			}
			TelNo="970"+TelNo;
		} else if (sTempNo=="CellTelInfo") { // 
			if(label=="01"){
				var TelNo = getItemValue(0, 0, "MobileOldPhone");
				sRecordName = getColLabel(0, "MobileOldPhone");
				if(TelNo.length ==0){
					alert(sRecordName+"不能为空！");
					return;
				}
				TelNo="960"+TelNo;
				}else{
			TelNo = getItemValue(0, 0, "MobileTelephone");
			
			sRecordName = getColLabel(0, "MobileTelephone");
			if(TelNo.length == 0){
				alert(sRecordName+"不能为空！");
				return;
			}
			TelNo="960"+TelNo;
			//alert(TelNo);
				}
		} else if (sTempNo=="OfficePhoneInfo") { // 
			if(label=="01"){
				var ID5Phone = getItemValue(0, 0, "ID5Phone");
					TelNo =ID5Phone.replace("-","");
					TelNo =TelNo.replace("+","");
				sRecordName = getColLabel(0, "ID5Phone");
				if(TelNo.length == 0){
					alert(sRecordName+"不能为空！");
					return;
				}
				TelNo="970"+TelNo;
			}else{
			TelNo = getItemValue(0, 0, "WorkTel");
			sRecordName = getColLabel(0, "WorkTel");
			if(TelNo.length == 0){
				alert(sRecordName+"不能为空！");
				return;
			}
			TelNo="970"+TelNo;
			}
		} else if (sTempNo == "FamilyMemberPhoneInfo") {
			TelNo = getItemValue(0, 0, "FamilyTel");	
			sRecordName = getColLabel(0, "FamilyTel");
			if(TelNo.length == 0){
				alert(sRecordName+"不能为空！");
				return;
			}
			TelNo="970"+TelNo;
		}
		//alert("970"+TelNo);
		//alert(TelNo + "|" + sRecordName);
		
		window.location.href="http://HiAgentHost.com/Command.htm?InvokeId=123&CommandName=Letsgo&ContractID=<%=sObjectNO%>&RecordName="+sRecordName;
	    window.location.href="http://HiAgentHost.com/Command.htm?InvokeId=123&CommandName=ecMakeCall&CustomerNumber="+TelNo+"&CallerParty=";

	}
	
	/*~[Describe=开始录音方法;]~*/
	function HiBrowserNotify(szMsg){
		var szMsg;
		szMsg="接收到的HiBrowserNotify事件参数为["+szMsg;
		szMsg=szMsg+"]";
		alert(szMsg);
		
		if(szMsg.indexOf("NotifyType=StartRec") >= 0 ){  
		    var s; var k; var v; var d; var dd; var u;
			s=szMsg.split(";");
			k=s[2].split("=");
			v=s[3].split('=');
			d=v[1].substring(2,10);
			dd=s[4].split("="); 
			u="http:"+"\\\\"+k[1]+d+dd[1];
			alert(u);
	     }
    }
	//检查手机号码归属地  add by phe 
	function checkPhone(id,phone){
		var out="";
		var put="";
		if(id==1){
			put = document.all("myiframe0").contentWindow.document.getElementById("put");
			out = document.all("myiframe0").contentWindow.document.getElementById("out");
		}else{
			put = document.all("myiframe0").contentWindow.document.getElementById("oput");
			out = document.all("myiframe0").contentWindow.document.getElementById("oout");
		}
	
		/* var sReturn = RunJavaMethodSqlca("demo.AddressUtils","checkPhone","phone="+phone);
		if(sReturn==""||sReturn==null||sReturn.length<=0||typeof(sReturn)=="undefined"||sReturn=="Exception"){//添加一次验证
			sReturn = RunJavaMethodSqlca("demo.AddressUtils","checkBy138","phone="+phone);
		} */
		/* var sReturn = RunJavaMethodSqlca("demo.AddressUtils","checkBy138","phone="+phone); */
		var sReturn = "";//暂时不调用接口判断电话号码归属地
		if(sReturn=="true"){
			out.style.display="none";
		}else if(sReturn=="false"){
			put.style.display="none";
		}else{
			return;
		}
	}
	//end by phe
	function initRow(){
		if (getRowCount(0)==0){//如当前无记录，则新增一条
			bIsInsert = true;
		}
		setItemValue(0, 0, "OldApplyFlag", "<%=oldContractStatus%>");
		setItemValue(0, 0, "OldApplyDate", "<%=oldInputDate%>");
		
		setItemValue(0, 0, "CostNo", "<%=sCostNo%>");
		setItemValue(0, 0, "Address", "<%=sAddress%>");
		setItemValue(0, 0, "Tel", "<%=sTel%>");
		setItemValue(0, 0, "LowCost", "<%=sLowCost%>");
		setItemValue(0, 0, "HighCost", "<%=sHighCost%>");
		
		if ("<%=sOfficePhoneNum%>" && "OfficePhoneInfo"==="<%=sTempletNo%>" && "060"==="<%=sSelOption%>") {
			setItemValue(0, 0, "ID5Phone", "<%=sOfficePhoneNum%>");
		}
		
		
		FamilyTel=getItemValue(0, 0, "FamilyTel");
		ContactTel=getItemValue(0, 0, "ContactTel");
		WorkTel=getItemValue(0, 0, "WorkTel");//办公电话
		MobileOldPhone=getItemValue(0, 0, "MobileOldPhone");//旧手机号码
		MobileTelephone=getItemValue(0, 0, "MobileTelephone");//客户手机号码
		ID5Phone=getItemValue(0, 0, "ID5Phone");//ID5补充号码
		
		if(FamilyTel == null){
			FamilyTel = "";
		}else{
			checkPhone(1,FamilyTel);
		}
		if(ContactTel == null){
			ContactTel = "";
		}else{
			checkPhone(1,ContactTel);
		}
		if(MobileOldPhone == null){ 
			MobileOldPhone = "";
		}else{
			checkPhone(2,MobileOldPhone);
		}
		if(MobileTelephone == null){
			MobileTelephone = "";
		}else{
			checkPhone(1,MobileTelephone);
		}
		if(WorkTel == null) WorkTel = "";
		if(ID5Phone == null) ID5Phone = "";
		
		FamilyTel=FamilyTel.replace("-","");
		ContactTel=ContactTel.replace("-","");
		WorkTel=WorkTel.replace("-","");
		ID5Phone=ID5Phone.replace("-","");
		
		if(FamilyTel.length != 0) setItemValue(0, 0, "FamilyTel", FamilyTel);
		if(ContactTel.length != 0) setItemValue(0, 0, "ContactTel",ContactTel);
		if(WorkTel.length != 0) setItemValue(0, 0, "WorkTel",WorkTel);
		if(ID5Phone.length != 0) setItemValue(0, 0, "ID5Phone",ID5Phone);
		
		<%-- TotalCount=<%=TotalCount%>;
		
		
 		if(TotalCount>0){
			if(MobileOldPhone.length != 0) setItemValue(0, 0, "MobileOldPhone", "96"+MobileOldPhone);
			if(MobileTelephone.length != 0) setItemValue(0, 0, "MobileTelephone", "96"+MobileTelephone);
			if(FamilyTel.length != 0 && FamilyTel.substring(0, 1)=="1") {
					setItemValue(0, 0, "FamilyTel", "97"+FamilyTel);
			}
			if(ContactTel.length != 0 && ContactTel.substring(0, 1)=="1") {
					setItemValue(0, 0, "ContactTel", "97"+ContactTel);
			}
			if(WorkTel.length != 0 && WorkTel.substring(0, 1)=="1") {
					setItemValue(0, 0, "WorkTel", "97"+WorkTel);
			}
			if(ID5Phone.length != 0 && ID5Phone.substring(0, 1)=="1") {
					setItemValue(0, 0, "ID5Phone", "97"+ID5Phone);
			}
		}else{
			if(MobileOldPhone.length != 0) setItemValue(0, 0, "MobileOldPhone", "960"+MobileOldPhone);
			if(MobileTelephone.length != 0) setItemValue(0, 0, "MobileTelephone", "960"+MobileTelephone);
			if(FamilyTel.length != 0 && FamilyTel.substring(0, 1)=="1") {
				setItemValue(0, 0, "FamilyTel", "970"+FamilyTel);
			}
			if(ContactTel.length != 0 && ContactTel.substring(0, 1)=="1") {
					setItemValue(0, 0, "ContactTel", "970"+ContactTel);
			}
			if(WorkTel.length != 0 && WorkTel.substring(0, 1)=="1") {
					setItemValue(0, 0, "WorkTel", "970"+WorkTel);
			}
			if(ID5Phone.length != 0 && ID5Phone.substring(0, 1)=="1") {
					setItemValue(0, 0, "ID5Phone", "970"+ID5Phone);
			}
		}
		// 非手机号，电话号码加97
		if(FamilyTel.length != 0 && FamilyTel.substring(0, 1)!="1") {
			setItemValue(0, 0, "FamilyTel", "97"+FamilyTel);
		}
		if(ContactTel.length != 0 && ContactTel.substring(0, 1)!="1") {
				setItemValue(0, 0, "ContactTel", "97"+ContactTel);
		}
		if(WorkTel.length != 0 && WorkTel.substring(0, 1)!="1") {
				setItemValue(0, 0, "WorkTel", "97"+WorkTel);
		}
		if(ID5Phone.length != 0 && ID5Phone.substring(0, 1)!="1") {
				setItemValue(0, 0, "ID5Phone", "97"+ID5Phone);
		}  --%>
		
    }
	
	/*~[Describe=查看审核提醒;]~*/
	function CECreditViewInfo(){
		sCompID = "CECreditViewInfo";
		sCompURL = "/Common/WorkFlow/CECreditViewInfo.jsp";
		var sTempletNo = 'CECreditViewInfo';
		sCompParam = "serialNo=<%=sObjectNO%>&sTempletNo="+sTempletNo; //新增不赋值参数
		var left = (window.screen.availWidth-800)/2;
		var top = (window.screen.availHeight-400)/2;
		var features ='left='+left+',top='+top+',width=800,height=400';
		var style = 'toolbar=no,scrollbars=yes,resizable=yes,scroll=no;status=no,menubar=no,'+features;
		
		popComp(sCompID, sCompURL, sCompParam , style);

		//AsControl.OpenView("/Common/WorkFlow/LookMessage.jsp","","right");
	}
	
	//新增同盾详情界面 add by lgq 20151030
	function CEShieldPlatInfo(){
		sCompID = "FraudMetrix";
		sCompURL = "/Common/WorkFlow/FraudMetrix.jsp";
		var sTempletNo = 'FraudMetrix';
		sCompParam = "serialNo=<%=sObjectNO%>&sTempletNo="+sTempletNo; //新增不赋值参数
		var left = window.screen.availWidth;
		var top = window.screen.availHeight;
		var features ='left='+left+',top='+top+',width=800,height=400';
		var style = 'toolbar=no,scrollbars=yes,resizable=yes,scroll=no;status=no,menubar=no,'+features;
		
		popComp(sCompID, sCompURL, sCompParam , "");
	}
	
	$(document).ready(function(){
		AsOne.AsInit();
		init();
		bFreeFormMultiCol = true;
		my_load(2,0,'myiframe0');
		initRow();
	});
</script>
<%@ include file="/IncludeEnd.jsp"%>
