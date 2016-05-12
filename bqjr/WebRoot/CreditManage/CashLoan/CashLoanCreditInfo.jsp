<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%
	/* --ҳ��˵��: ʾ������ҳ��-- */
	String PG_TITLE = "ʾ������ҳ��";

	// ���ҳ�����
	String sObjectNO =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
	String sSerialNO =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("TaskNo"));
	String sPhaseNo = DataConvert.toRealString(iPostChange,CurComp.getParameter("PhaseNo"));
	String sFlowNo = DataConvert.toRealString(iPostChange,CurComp.getParameter("FlowNo"));
	String oldContractStatus="";//�ɺ�ͬ״̬
	String oldInputDate="";//����������
	String sureType = "";
	if(sObjectNO==null) sObjectNO="";
	if(sFlowNo==null) sFlowNo="";
	if(sPhaseNo==null) sPhaseNo="";
	
	//��ȡ���µ��ֶ�����
	String sSql2 = "select Max(SerialNo) as SerialNo from FLow_Task where ObjectNo =:ObjectNo and FlowNo =:FlowNo";
	sSerialNO = Sqlca.getString(new SqlObject(sSql2)
			.setParameter("ObjectNo", sObjectNO).setParameter("FlowNo", sFlowNo));
	sSql2 = "select PhaseNo from Flow_Task where ObjectNo =:ObjectNo and FlowNo =:FlowNo and SerialNo =:SerialNo";
	sPhaseNo = Sqlca.getString(new SqlObject(sSql2)
			.setParameter("ObjectNo", sObjectNO).setParameter("FlowNo", sFlowNo).setParameter("SerialNo", sSerialNO));
	int sBusinessCprincipal=0;
	int sCprincipal=0;
	int sBusinessCperiod=0;
	int sCperiod=0;
	if("0080".equals(sPhaseNo)){
			//�������淵�ؽ��
			String sCprincipalSql = "select cprincipal from cashpost_data where applyno = :ObjectNo";
			String  ssCprincipal = Sqlca.getString(new SqlObject(sCprincipalSql).setParameter("ObjectNo", sObjectNO));
			if(ssCprincipal==null||"".equals(ssCprincipal))   ssCprincipal="0";
			sCprincipal=  Integer.valueOf(ssCprincipal).intValue();
			//�������淵������
			String sCperiodSql = "select cperiods from cashpost_data where applyno = :ObjectNo";
			String ssCperiod = Sqlca.getString(new SqlObject(sCperiodSql).setParameter("ObjectNo", sObjectNO));
			if(ssCperiod==null||"".equals(ssCperiod))    ssCperiod="0";
			 sCperiod = Integer.valueOf(ssCperiod).intValue();
			//�ÿͻ��ں�ͬ���е�����
			String sBusinessCperiodSql = "select Periods from business_contract where serialno = :ObjectNo";
			String ssBusinessCperiod = Sqlca.getString(new SqlObject(sBusinessCperiodSql).setParameter("ObjectNo", sObjectNO));
			if(ssBusinessCperiod==null||"".equals(ssBusinessCperiod))  ssBusinessCperiod="0";
			 sBusinessCperiod =  Integer.valueOf(ssBusinessCperiod).intValue();
			//�ÿͻ��ں�ͬ���еĽ��
			String sBusinessCprincipalSql = "select BusinessSum from business_contract where serialno= :ObjectNo";
			String ssBusinessCprincipal = Sqlca.getString(new SqlObject(sBusinessCprincipalSql).setParameter("ObjectNo", sObjectNO));
			if(ssBusinessCprincipal==null||"".equals(ssBusinessCprincipal))  ssBusinessCprincipal="0";
			 sBusinessCprincipal = Integer.valueOf(ssBusinessCprincipal).intValue();
		}
		
	String sTempletNo = "NCIICTaskCreditInfo";//ģ�ͱ��
	
	//-- add by tangyb CCS-1236 PRM-773 �ֻ�����˲�ҳ�������������� 20160114 --//
	String pfname = Sqlca.getString("select PhaseName||','||flowname from Flow_Task where SerialNo = '"+sSerialNO+"'");
	
	String[] pfnames = pfname.split(",");
	
	String sPhaseName = pfnames[0]; //���̽ڵ�����
	String flowname = pfnames[1]; // ��������
	//-- end --//
	
	/* �Ƿ���Ҫ����ҳ��ѡ����� */
	boolean needPage = false;
	
	//��ʱ�Ѹ����׶ε���ʾҵ��ģ�������õ�PHASEATTRIBUTE�ֶ���(��Ӧ���������е�'�׶�����')
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
	// ����칫�绰ģ�壬��ȡ�ϼ�ID5�绰
	if ("OfficePhoneInfo".equals(sTempletNo)) {
		String sOpSql = "SELECT PHASEOPINION,PHASEOPINION3 FROM FLOW_OPINION WHERE SERIALNO=(SELECT SERIALNO FROM FLOW_TASK WHERE OBJECTNO=:ObjectNo AND PHASENO='0014')";
		ASResultSet opResult = Sqlca.getASResultSet(new SqlObject(sOpSql).setParameter("ObjectNo", sObjectNO));
		if (opResult.next()) {
			sOfficePhoneNum = opResult.getString("PHASEOPINION3");
			sSelOption = opResult.getString("PHASEOPINION");
			
			if (sOfficePhoneNum == null) sOfficePhoneNum = "";
			if (sSelOption == null) sSelOption = "";
		}
		if (opResult !=null) opResult.getStatement().close();
	}
		
	//��ȡ��ǰ�ͻ����ơ�
	String customerID="";
	rs = Sqlca.getASResultSet("select customerID,suretype from business_contract where SerialNo = '"+sObjectNO+"'");
	if (rs.next()) {
		customerID = rs.getString("customerID");
		sureType = rs.getString("suretype");
	}
	rs.getStatement().close();
	//��ȡ��ǰ��ͬ��һ�������ͬ��
	String oldSerialNo=Sqlca.getString(new SqlObject("select serialno from business_contract where customerid=:customerid and serialno<:serialno  order by serialno desc")
	                  .setParameter("customerid", customerID).setParameter("serialno", sObjectNO));
	//��ȡ��ǰ��ͬ��һ������ĺ�ͬ״̬����������
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
	
	// ͨ��DWģ�Ͳ���ASDataObject����doTemp
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
	
	//-- CCS-1208��ʶ����photo shop �޸Ĺ���ͼƬ zty--//
	if("NCIICTaskCreditInfo".equals(sTempletNo)){
		if(!"NCIIC��Ƭ�ȶ�".equals(sPhaseName)){
			doTemp.setVisible("isProcessing", false);
		}
	}
	//-- end--//
	
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
	
	/*add ���ֽ������ˣ����ֻ���������˲�����У�����һ�������ڴ����1�Ŀ򴦴����ͻ����ֽ���Ĵ����
		  ps:��ҳ��Ϊ�ֽ������ʹ�õ�ҳ�棬��˴˴������жϲ�Ʒ����
	*/
	if("CellTelInfo".equals(sTempletNo))
	{
		doTemp.setVisible("BusinessSum",true);
		doTemp.setVisible("BusinessSum1",false);
	}
	//end
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      // ����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; // �����Ƿ�ֻ�� 1:ֻ�� 0:��д
	
	//-- add by tangyb CCS-1236 PRM-773 �ֻ�����˲�ҳ�������������� 20160114 --//
	if("WF_OFFICETEST".equals(sFlowNo) && 
			("�ֻ�����˲�".equals(sPhaseName) 
				|| "�칫�绰����˲�".equals(sPhaseName)
				|| "������ϵ����Ϣ���".equals(sPhaseName)
				|| "ͬ����ϵ�绰����˲�".equals(sPhaseName))){
		sPhaseName = sPhaseName + "��"+flowname+"��";
	}
	//-- end --//
	
	if ("JQM".equals(sureType)) {
		out.print("&nbsp;&nbsp;&nbsp;<b>"+sPhaseName+"</b><b style=\"color: red;\">����Ǯô��</b>");
	}else if("EBF".equals(sureType)) {
		out.print("&nbsp;&nbsp;&nbsp;<b>"+sPhaseName+"</b><b style=\"color: red;\">���װ۷֣�</b>");
	}else {
		out.print("&nbsp;&nbsp;&nbsp;<b>"+sPhaseName+"</b>");
	}
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sObjectNO);//�������,���ŷָ�
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	String sButtons[][] = {
		{"false","","Button","�鿴�������","�鿴�������","CECreditViewInfo()",sResourcesPath},
		{"false","","Button","�鿴ͬ������","�鿴ͬ������","CEShieldPlatInfo()",sResourcesPath},//����ͬ��������� add by zty 20151127
	};
	
	if("CECashLoanInfo".equals(sTempletNo)){
		sButtons[0][0] = "true";
		sButtons[1][0] = "true";
	}
	if("CECreditInfo".equals(sTempletNo)){
		sButtons[1][0] = "true";
	}
%>
<%@include file="/Resources/CodeParts/Info05.jsp"%>
<script language="javascript" type="text/javascript">
	var bIsInsert = false; // ���DW�Ƿ��ڡ�����״̬��
	function saveRecord(sPostEvents){
	}
	
	function saveAndGoBack(){
	}
	
	function goBack(){
	}

	<%/*~[Describe=ִ�в������ǰִ�еĴ���;]~*/%>
	function beforeInsert(){
	}
	
	<%/*~[Describe=ִ�и��²���ǰִ�еĴ���;]~*/%>
	function beforeUpdate(){
		
	}
	
	<%-- <%/*~[Describe=������绰;]~*/%>
	function btnMakeCall_Click(label, flag)
	{
		var sRecordName = "�ֻ���";
		var TelNo = "";
		var sTempNo = "<%=sTempletNo%>";
		if (sTempNo=="ID5HomePhoneInfo") {	// סլ�绰
			TelNo = getItemValue(0, 0, "FamilyTel");
			sRecordName = getColLabel(0, "FamilyTel");
		} else if (sTempNo=="OtherManageInfo") {	// ��ϵ�˵绰
			TelNo = getItemValue(0, 0, "ContactTel");
			sRecordName = getColLabel(0, "ContactTel");
		} else if (sTempNo=="ID5PhoneInfo") { // �칫�绰
			TelNo = getItemValue(0, 0, "WorkTel");
			sRecordName = getColLabel(0, "WorkTel");
		} else if (sTempNo=="DormPhoneInfo") {	// DormPhoneInfo
			TelNo = getItemValue(0, 0, "FamilyTel");
			sRecordName = getColLabel(0, "FamilyTel");
		} else if (sTempNo=="CellTelInfo") { // 
			TelNo = getItemValue(0, 0, "MobileTelephone");
			sRecordName = getColLabel(0, "MobileTelephone");
		} else if (sTempNo=="OfficePhoneInfo") { // 
			TelNo = getItemValue(0, 0, "WorkTel");
			sRecordName = getColLabel(0, "WorkTel");
		} else if (sTempNo == "FamilyMemberPhoneInfo") {
			TelNo = getItemValue(0, 0, "FamilyTel");
			sRecordName = getColLabel(0, "FamilyTel");
		}
		//alert(TelNo + "|" + sRecordName);
		window.location.href="http://HiAgentHost.com/Command.htm?InvokeId=123&CommandName=Letsgo&ContractID=<%=sObjectNO%>&RecordName="+sRecordName;
	    window.location.href="http://HiAgentHost.com/Command.htm?InvokeId=123&CommandName=ecMakeCall&CustomerNumber="+TelNo+"&CallerParty=";

	} --%>
	
	<%/*~[Describe=�������ص绰;]~*/%>
	function btnMakeCall_Click(label, flag)
	{
		//alert("97"+label+"label"+flag);
		var sRecordName = "�ֻ���";
		var TelNo = "";
		var sTempNo = "<%=sTempletNo%>";
		if (sTempNo=="ID5HomePhoneInfo") {	// סլ�绰
			TelNo = getItemValue(0, 0, "FamilyTel");
			sRecordName = getColLabel(0, "FamilyTel");
			if(TelNo.length == 0){
				alert(sRecordName+"����Ϊ�գ�");
				return;
			}	
			TelNo="97"+TelNo;
		} else if (sTempNo=="OtherManageInfo") {	// ��ϵ�˵绰
			TelNo = getItemValue(0, 0, "ContactTel");
			sRecordName = getColLabel(0, "ContactTel");
			if(TelNo.length == 0){
				alert(sRecordName+"����Ϊ�գ�");
				return;
			}
			TelNo="97"+TelNo;
		} else if (sTempNo=="ID5PhoneInfo") { // �칫�绰
			TelNo = getItemValue(0, 0, "WorkTel");
			sRecordName = getColLabel(0, "WorkTel");
			if(TelNo.length == 0){
				alert(sRecordName+"����Ϊ�գ�");
				return;
			}
			TelNo="97"+TelNo;
		} else if (sTempNo=="DormPhoneInfo") {	// DormPhoneInfo
			TelNo = getItemValue(0, 0, "FamilyTel");
			sRecordName = getColLabel(0, "FamilyTel");
			if(TelNo.length == 0){
				alert(sRecordName+"����Ϊ�գ�");
				return;
			}
			TelNo="97"+TelNo;
		} else if (sTempNo=="CellTelInfo") { // 
			 if(label=="01"){
				var TelNo = getItemValue(0, 0, "MobileOldPhone");
				sRecordName = getColLabel(0, "MobileOldPhone");
				if(TelNo.length == 0){
					alert(sRecordName+"����Ϊ�գ�");
					return;
				}
				TelNo="96"+TelNo;
				}else{ 
			TelNo = getItemValue(0, 0, "MobileTelephone");
			sRecordName = getColLabel(0, "MobileTelephone");
			if(TelNo.length == 0){
				alert(sRecordName+"����Ϊ�գ�");
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
					alert(sRecordName+"����Ϊ�գ�");
					return;
				}
				 TelNo="97"+TelNo;
			}else{ 
			TelNo = getItemValue(0, 0, "WorkTel");
			sRecordName = getColLabel(0, "WorkTel");
			if(TelNo.length == 0){
				alert(sRecordName+"����Ϊ�գ�");
				return;
			}
			TelNo="97"+TelNo;
			 } 
		} else if (sTempNo == "FamilyMemberPhoneInfo") {
			TelNo = getItemValue(0, 0, "FamilyTel");
			sRecordName = getColLabel(0, "FamilyTel");
			if(TelNo.length == 0){
				alert(sRecordName+"����Ϊ�գ�");
				return;
			}
			TelNo="97"+TelNo;
		}
		
		window.location.href="http://HiAgentHost.com/Command.htm?InvokeId=123&CommandName=Letsgo&ContractID=<%=sObjectNO%>&RecordName="+sRecordName;
	    window.location.href="http://HiAgentHost.com/Command.htm?InvokeId=123&CommandName=ecMakeCall&CustomerNumber="+TelNo+"&CallerParty=";

	}
	//btnMakeCall_Click_Out(label, flag)
	<%/*~[Describe=��������ص绰;]~*/%>
	function btnMakeCall_Click_Out(label, flag)
	{
		//alert("970");
		var sRecordName = "�ֻ���";
		var TelNo = "";
		var sTempNo = "<%=sTempletNo%>";
		if (sTempNo=="ID5HomePhoneInfo") {	// סլ�绰
			TelNo = getItemValue(0, 0, "FamilyTel");
			sRecordName = getColLabel(0, "FamilyTel");
			if(TelNo.length == 0){
				alert(sRecordName+"����Ϊ�գ�");
				return;
			}
			TelNo="970"+TelNo;
		} else if (sTempNo=="OtherManageInfo") {	// ��ϵ�˵绰
			TelNo = getItemValue(0, 0, "ContactTel");
			sRecordName = getColLabel(0, "ContactTel");
			if(TelNo.length == 0){
				alert(sRecordName+"����Ϊ�գ�");
				return;
			}
			TelNo="970"+TelNo;
		} else if (sTempNo=="ID5PhoneInfo") { // �칫�绰
			TelNo = getItemValue(0, 0, "WorkTel");
			sRecordName = getColLabel(0, "WorkTel");
			if(TelNo.length == 0){
				alert(sRecordName+"����Ϊ�գ�");
				return;
			}
			TelNo="970"+TelNo;
		} else if (sTempNo=="DormPhoneInfo") {	// DormPhoneInfo
			TelNo = getItemValue(0, 0, "FamilyTel");
			sRecordName = getColLabel(0, "FamilyTel");
			if(TelNo.length == 0){
				alert(sRecordName+"����Ϊ�գ�");
				return;
			}
			TelNo="970"+TelNo;
		} else if (sTempNo=="CellTelInfo") { // 
			if(label=="01"){
				var TelNo = getItemValue(0, 0, "MobileOldPhone");
				sRecordName = getColLabel(0, "MobileOldPhone");
				if(TelNo.length ==0){
					alert(sRecordName+"����Ϊ�գ�");
					return;
				}
				TelNo="960"+TelNo;
				}else{
			TelNo = getItemValue(0, 0, "MobileTelephone");
			
			sRecordName = getColLabel(0, "MobileTelephone");
			if(TelNo.length == 0){
				alert(sRecordName+"����Ϊ�գ�");
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
					alert(sRecordName+"����Ϊ�գ�");
					return;
				}
				TelNo="970"+TelNo;
			}else{
			TelNo = getItemValue(0, 0, "WorkTel");
			sRecordName = getColLabel(0, "WorkTel");
			if(TelNo.length == 0){
				alert(sRecordName+"����Ϊ�գ�");
				return;
			}
			TelNo="970"+TelNo;
			}
		} else if (sTempNo == "FamilyMemberPhoneInfo") {
			TelNo = getItemValue(0, 0, "FamilyTel");	
			sRecordName = getColLabel(0, "FamilyTel");
			if(TelNo.length == 0){
				alert(sRecordName+"����Ϊ�գ�");
				return;
			}
			TelNo="970"+TelNo;
		}
		//alert("970"+TelNo);
		//alert(TelNo + "|" + sRecordName);
		
		window.location.href="http://HiAgentHost.com/Command.htm?InvokeId=123&CommandName=Letsgo&ContractID=<%=sObjectNO%>&RecordName="+sRecordName;
	    window.location.href="http://HiAgentHost.com/Command.htm?InvokeId=123&CommandName=ecMakeCall&CustomerNumber="+TelNo+"&CallerParty=";

	}
	
	
	/*~[Describe=��ʼ¼������;]~*/
	function HiBrowserNotify(szMsg){
		var szMsg;
		szMsg="���յ���HiBrowserNotify�¼�����Ϊ["+szMsg;
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
	//����ֻ����������  add by phe 
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
		if(sReturn==""||sReturn==null||sReturn.length<=0||typeof(sReturn)=="undefined"||sReturn=="Exception"){//���һ����֤
			sReturn = RunJavaMethodSqlca("demo.AddressUtils","checkBy138","phone="+phone);
		} */
		/* var sReturn = RunJavaMethodSqlca("demo.AddressUtils","checkBy138","phone="+phone); */
		var sReturn = "";//��ʱ�����ýӿ��жϵ绰���������
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
		if (getRowCount(0)==0){//�統ǰ�޼�¼��������һ��
			bIsInsert = true;
		}
		setItemValue(0, 0, "OldApplyFlag", "<%=oldContractStatus%>");
		setItemValue(0, 0, "OldApplyDate", "<%=oldInputDate%>");
		
		setItemValue(0, 0, "CostNo", "<%=sCostNo%>");
		setItemValue(0, 0, "Address", "<%=sAddress%>");
		setItemValue(0, 0, "Tel", "<%=sTel%>");
		setItemValue(0, 0, "LowCost", "<%=sLowCost%>");
		setItemValue(0, 0, "HighCost", "<%=sHighCost%>");
		setItemValue(0, 0, "BusinessSum", <%=sBusinessCprincipal%>+<%=sCprincipal%>);//�������޸ĺ�ı���  ybpan  CCS-485  ��ԤԼ��������׼
		setItemValue(0, 0, "Periods", <%=sBusinessCperiod%>+<%=sCperiod%>);//�������޸ĺ������  ybpan  CCS-485 ��ԤԼ��������׼
		
		if ("<%=sOfficePhoneNum%>" && "OfficePhoneInfo"==="<%=sTempletNo%>" && "060"==="<%=sSelOption%>") {
			setItemValue(0, 0, "ID5Phone", "<%=sOfficePhoneNum%>");
		}
		
		
		FamilyTel=getItemValue(0, 0, "FamilyTel");
		ContactTel=getItemValue(0, 0, "ContactTel");
		WorkTel=getItemValue(0, 0, "WorkTel");
		MobileOldPhone=getItemValue(0, 0, "MobileOldPhone");
		MobileTelephone=getItemValue(0, 0, "MobileTelephone");
		ID5Phone=getItemValue(0, 0, "ID5Phone");
		
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
		
		//if(FamilyTel.length != 0) setItemValue(0, 0, "FamilyTel", "97"+FamilyTel);
		//if(ContactTel.length != 0) setItemValue(0, 0, "ContactTel", "97"+ContactTel);
		//if(WorkTel.length != 0) setItemValue(0, 0, "WorkTel", "97"+WorkTel);
		//if(ID5Phone.length != 0) setItemValue(0, 0, "ID5Phone", "97"+ID5Phone);
		
	<%-- 	TotalCount=<%=TotalCount%>;
		
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
		// ���ֻ��ţ��绰�����97
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
		}
		  --%>
    }
	
	/*~[Describe=�鿴�������;]~*/
	function CECreditViewInfo(){
		sCompID = "CECreditViewInfo";
		sCompURL = "/Common/WorkFlow/CECreditViewInfo.jsp";
		var sTempletNo = 'CECashLoanViewInfo';
		sCompParam = "serialNo=<%=sObjectNO%>&sTempletNo="+sTempletNo; //��������ֵ����
		var left = (window.screen.availWidth-800)/2;
		var top = (window.screen.availHeight-400)/2;
		var features ='left='+left+',top='+top+',width=800,height=400';
		var style = 'toolbar=no,scrollbars=yes,resizable=yes,scroll=no;status=no,menubar=no,'+features;
		
		popComp(sCompID, sCompURL, sCompParam , style);

		//AsControl.OpenView("/Common/WorkFlow/LookMessage.jsp","","right");
	}
	
	//����ͬ��������� add by zty 20151127
	function CEShieldPlatInfo(){
		sCompID = "FraudMetrix";
		sCompURL = "/Common/WorkFlow/FraudMetrix.jsp";
		var sTempletNo = 'FraudMetrix';
		sCompParam = "serialNo=<%=sObjectNO%>&sTempletNo="+sTempletNo; //��������ֵ����
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
