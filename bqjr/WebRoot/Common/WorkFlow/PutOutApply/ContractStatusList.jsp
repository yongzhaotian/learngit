<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author: hxli 2005-8-1
		Tester:
		Describe: �޸ĺ�ͬ״̬
		
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
	String PG_TITLE = "�޸ĺ�ͬ״̬"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info02;Describe=�����������ȡ����;]~*/%>
<%

	
	//���ҳ�����
	String sProductID  = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("productID"));	
    if(sProductID==null) sProductID="";
    
    ASResultSet rs = null;
    ASResultSet rs1 = null;
    ASResultSet rs2 = null;
    String roleID="";
    String storeID="";
    String doWhere="";
    String flag="false";
    String vetoFlag="false";
    String sStatus1="false";
    String sStatus2="false";
    String sStatus3="false"; //�����޸ĺ�ͬ״̬��������Ӫ��
    boolean managerStatus=false;
    
    String BusinessDate = SystemConfig.getBusinessDate();
%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/%>
	<%
		
	String userID=CurUser.getUserID();
	StringBuffer sb=new StringBuffer();
	StringBuffer snos=new StringBuffer();//�ŵ� ƴ�� 
	if(CurUser.hasRole("1005")){//�����½��ԱΪ���۾��� 
		managerStatus=true;
		rs1=Sqlca.getASResultSet(new SqlObject("select sno from store_info where salesmanager=:salesmanager").setParameter("salesmanager", userID));
		while(rs1.next()){
	    		snos.append("'"+rs1.getString("sno")+"',");
	    	}
	  	    if(snos.toString().equals("")){
    	   doWhere=" and 1=2 ";
        }else{
 	       doWhere=" and stores in("+snos.toString().substring(0,snos.toString().length()-1)+")" ;
        }
	    rs1.getStatement().close();
        doWhere +=  "  and (bc.isbaimingdan <> '1' or bc.isbaimingdan is null) ";
	}else if(CurUser.hasRole("1006")){
		//�����¼��Ϊ���۴��� 
	    sb.append("'"+userID+"'");
	    doWhere=" and inputuserid in ("+sb.toString()+")"+ " and  (bc.isbaimingdan <> '1' or bc.isbaimingdan is null)";
	}
	
	/* ---1.�޸� *Ϊ�޸ĺ�ͬ״̬��������Ӫ�����"�޸ĺ�ͬ״̬"��ť*  by xiaoqing.fang  20151117--- */
	if(CurUser.hasRole("1111")||CurUser.hasRole("1112")||CurUser.hasRole("1113")){
		flag="true"; //������޸ĺ�ͬ״̬��ɫ ��ʾ��ť 
	}
	if(CurUser.hasRole("1112")){ //�޸ĺ�ͬ״̬����Ӫ��
		sStatus2="true";
	}else if(CurUser.hasRole("1111")){ //�޸ĺ�ͬ״̬�����ۣ�
		sStatus1="true"; 
	}else if(CurUser.hasRole("1113")){ //�޸ĺ�ͬ״̬��������Ӫ��
		sStatus3="true";
	}
	/* ---end xiaoqing.fang--- */
	//����з�������ɫ (�߼����۾������۾���Ⱦ�������) ��ʾ��ť add PRM-477���۾�����Է������е����� by huanghui 20150720
	if(CurUser.hasRole("1005")){
		vetoFlag="true";
	}
	 ASDataObject doTemp = null;
	 String sTempletNo = "ContractStatus";
	 doTemp = new ASDataObject(sTempletNo,Sqlca);//����ģ�ͣ�2013-5-9
	 doTemp.generateFilters(Sqlca);
	 doTemp.parseFilterData(request,iPostChange);
	 CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	//�жϷ��ϸ������Ƿ����ݱȽ϶࣬Ӱ���ѯ����
	boolean myflag = true;
	for(int k=0;k<doTemp.Filters.size();k++){
		if(doTemp.Filters.get(k).sFilterInputs[0][1] != null &&doTemp.Filters.get(k).sFilterInputs[0][1].length()>0 && (("BC.SERIALNO").equals(doTemp.getFilter(k).sFilterColumnID)||("BC.CustomerName").equals(doTemp.getFilter(k).sFilterColumnID))){
			myflag = false;
			break;
		}
	}
	if(doTemp.haveReceivedFilterCriteria()&& myflag)
	{
		%>
		<script type="text/javascript">
			alert("��ͬ���,�ͻ�������������һ�");
		</script>
		<%
		doTemp.WhereClause+=" and 1=2 ";
	
	}
	
	 if(!doTemp.haveReceivedFilterCriteria()){
		 doTemp.WhereClause+=" and 1=2 "; 
	 }else{
		 for(int k=0;k<doTemp.Filters.size();k++){
			 	if(doTemp.Filters.get(k).sFilterInputs[0][1] != null && doTemp.Filters.get(k).sFilterInputs[0][1].indexOf("%")>=0){
			 		%>
					<script type="text/javascript">
						alert("�������ܰ���%��");
					</script>
					<%
					doTemp.WhereClause+=" and 1=2 "; 
					break;
			 	}
				if(doTemp.Filters.get(k).sFilterInputs[0][1] != null && doTemp.Filters.get(k).sFilterInputs[0][1].length()>0 && doTemp.Filters.get(k).sFilterInputs[0][1].length()<8 && (("BC.SERIALNO").equals(doTemp.getFilter(k).sFilterColumnID))){
					%>
					<script type="text/javascript">
						alert("��ͬ��ű�����ڵ���8λ��");
					</script>
					<%
					doTemp.WhereClause+=" and 1=2 "; 
					break;
				}
				if(doTemp.Filters.get(k).sFilterInputs[0][1] != null && doTemp.Filters.get(k).sFilterInputs[0][1].indexOf("%")>=0 && (("BC.CustomerName").equals(doTemp.getFilter(k).sFilterColumnID))){
					%>
					<script type="text/javascript">
						alert("�ͻ���������%��ʼ��");
					</script>
					<%
					doTemp.WhereClause+=" and 1=2 "; 
					break;
				}
			}
		 doTemp.WhereClause+=doWhere;
	 }
	
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
		{"false","","Button","�޸ĺ�ͬ״̬","�޸ĺ�ͬ״̬","editContract()",sResourcesPath},
		{"false","","Button","�������","�������","vetoApply()",sResourcesPath},
		{"true","","Button","�޸ĵر�״̬","�޸ĵر�״̬","editLandMark()",sResourcesPath},	
		{managerStatus? "true":"false","","Button","�ύע��","�ύע��","doSubmit()",sResourcesPath},	
		{"false","","Button","ȡ������","ȡ������","deleteRecord()",sResourcesPath},
		{CurUser.getRoleTable().contains("2001")?"true":"false","","Button","����EXCEL","����EXCEL","exportExcel()",sResourcesPath},

		};
	if(flag.equals("true")){
		sButtons[0][0]="true";
	}
	if(vetoFlag.equals("true")){
		sButtons[1][0]="true";
	}
	%>
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">

	var bReverseTrans = false;
	//---------------------���尴ť�¼�------------------------------------
	
		//Excel����������	
	function exportExcel(){
		amarExport("myiframe0");
	}

	
	/*~[Describe=������¼;InputParam=��;OutPutParam=��;]~*/
	function editContract(){
		var sSerialNo =getItemValue(0,getRow(),"SerialNo");
		var sContractStatus =getItemValue(0,getRow(),"ContractStatus");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert("������ѡ��һ����¼��");
			return;
		}
		if(sContractStatus!="��ǩ��" && sContractStatus!="����ͨ��" && sContractStatus!="��ע��" && sContractStatus!="����δע��"){
			alert("�����޸ķ�Χ�ڣ�");
			return;
		}
		if(sContractStatus=="��ע��" && "<%=sStatus1%>"=="true" && "<%=sStatus2%>"=="false"){
			alert("�Բ�����û���޸�Ȩ�ޣ�");
			return ;
		}
		/*---2.�޸�  *Ϊ���޸ĺ�ͬ״̬��������Ӫ�������ֻ�н�����δע���Ϊ��ǩ���Ȩ��* by xiaoqing.fang  20151117---  */ 
		if(sContractStatus=="��ע��" && "<%=sStatus3%>"=="true"){
			alert("�Բ�����û���޸�Ȩ�ޣ�");
			return ;
		}
		if(sContractStatus=="��ǩ��" && "<%=sStatus3%>"=="true"){
			alert("�Բ�����û���޸�Ȩ�ޣ�");
			return ;
		}
		if(sContractStatus=="����ͨ��" && "<%=sStatus3%>"=="true"){
			alert("�Բ�����û���޸�Ȩ�ޣ�");
			return ;
		}
		/* -- end -- */
		
		if(sContractStatus=="����δע��" && "<%=sStatus1%>"=="true" && "<%=sStatus2%>"=="false"){
			alert("�Բ�����û���޸�Ȩ�ޣ�");
			return;
		}
		//��֤�Ƿ����δ��ɵĽ���
		var returnValue = RunJavaMethodSqlca("com.amarsoft.app.lending.bizlets.PayMentRevisionSchedule","validate","contractSerialNo="+sSerialNo+"");
		if(returnValue!="0"){
			alert(returnValue);
			reloadSelf();
			return;
		}
		var params ="serialNo="+sSerialNo+",userId=<%=CurUser.getUserID()%>";
		if(sContractStatus=="����δע��"){
			if(confirm("��ͬ��������Ϊ����ǩ��״̬���Ƿ�ȷ���޸ģ�")){
				/***********CCS-1041,ϵͳ����ʱ���ܵ�¼ϵͳ huzp 20151217**************************************/
				var sTaskFlag = RunMethod("���÷���","GetColValue","system_setup,taskflag,1=1");
				if(sTaskFlag=="1"){
					alert("ϵͳ������������ʱ�޷�����ͬ����Ϊ����ǩ��״̬!");
					return;
				}else{
				var result = RunJavaMethodSqlca("com.amarsoft.app.lending.bizlets.ContractStatusChange","statusChange",params);
				alert(result.split("@")[1]);
				if("true"==result.split("@")[0]){
					reloadSelf();
				}
			   }
				return;
			}else{
				return;
			}
		}
		
		if(sContractStatus=="��ע��"){
			if(confirm("��ͬ��������Ϊ���ѳ�����״̬���Ƿ�ȷ���޸ģ�")){
				var result = RunJavaMethodSqlca("com.amarsoft.app.lending.bizlets.ContractStatusChange","statusChange",params);
				alert(result.split("@")[1]);
				if("true"==result.split("@")[0]){
					reloadSelf();
				}
				return;
			}else{
				return;
			}
		}
		if(sContractStatus=="����ͨ��"){
			if(confirm("��ͬ��������Ϊ���ѳ�����״̬���Ƿ�ȷ���޸ģ�")){
				var result = RunJavaMethodSqlca("com.amarsoft.app.lending.bizlets.ContractStatusChange","statusChange",params);
				alert(result.split("@")[1]);
				if("true"==result.split("@")[0]){
					reloadSelf();
				}
				return;
			}else{
				return;
			}
		}
		
		if(sContractStatus=="��ǩ��"){
			if(confirm("��ͬ��������Ϊ������ͨ����״̬���Ƿ�ȷ���޸ģ�")){
				var result = RunJavaMethodSqlca("com.amarsoft.app.lending.bizlets.ContractStatusChange","statusChange",params);
				alert(result.split("@")[1]);
				if("true"==result.split("@")[0]){
					reloadSelf();
				}
				return;
			}else{
				return;
			}
		}
	}
	
	// ���"�������"��ť�������׶� PRM-477 ���۾�����Է������е����� add by huanghui 20150722
	/*~[Describe=�������;InputParam=��;OutPutParam=��;]~*/
	function vetoApply(){
		//�ֶ�ȡ�������1020��FT����ֶ�
		//��ú�ͬ��ˮ�š��������͡����̱�š��׶α��
		var sObjectNo = getItemValue(0, getRow(), "SerialNo");//��ͬ��ˮ��
		var sObjectType = RunMethod("���÷���", "GetColValue", "FLOW_OBJECT,ObjectType,ObjectNo='"+sObjectNo+"'");
		var sFlowNo = RunMethod("���÷���", "GetColValue", "FLOW_OBJECT,FlowNo,ObjectNo='"+sObjectNo+"'");
		var sFlowName = RunMethod("���÷���", "GetColValue", "FLOW_OBJECT,FlowName,ObjectNo='"+sObjectNo+"'");
		var sPhaseNo = RunMethod("���÷���", "GetColValue", "FLOW_OBJECT,PhaseNo,ObjectNo='"+sObjectNo+"'");
		var sApplyType = RunMethod("���÷���", "GetColValue", "FLOW_OBJECT,ApplyType,ObjectNo='"+sObjectNo+"'");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
		{
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
		}
		
		if (confirm("��ȷ��Ҫ����ñ�������")) {
			var sContractStatus =getItemValue(0,getRow(),"ContractStatus");
			if(sContractStatus!="�����"){
				var sTemp="ֻ������е�������ܷ����";
				alert(sTemp);
				return;
			}
			
			//��ȡ��ǰҵ������̽׶α��  edit by pli2
			var sTaskNo = RunMethod("���÷���", "GetColValue", "FLOW_TASK,MAX(SerialNo), ObjectNo='"+sObjectNo+"' and ObjectType='"+sObjectType+"'");	
			
			//var OpenStyle = "width=100px,height=60px,top=40,left=80,toolbar=no,scrollbars=yes,resizable=yes,status=yes,menubar=yes,";
			//����ѡ��ȡ���������
			var sReturn = popComp("VetoApplyInfo","/Common/WorkFlow/VetoApplyInfo.jsp","ObjectNo="+sObjectNo+"&ObjectType="+sObjectType+"&PhaseNo="+sPhaseNo+"&FlowNo="+sFlowNo+"&FlowName="+sFlowName+"&TaskNo="+sTaskNo+"&Type=1"+"&ApplyType="+sApplyType,"dialogWidth=600px;dialogHeight=400px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
			window.returnValue = sReturn;
			window.close();
			reloadSelf();
		}
	}
	
	function editLandMark(){
		var sSerialNo =getItemValue(0,getRow(),"SerialNo");
	    if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert("������ѡ��һ����¼��");
			return;
		}
	    var sEntInfoValue = setObjectValue("SelectLandMarkStatus","","",0,0,"");
	    sEntInfoValue = sEntInfoValue.split("@");
		if (typeof(sEntInfoValue)=="undefined" || sEntInfoValue.length==0){
			alert("��ѡ����һ���ر�״̬");
			return;
		}
		//���ѡ��ĵر�״̬Ϊ��ʱ���ܸ��ĵر�״̬add by qizhong.chi
		if(!isNaN(sEntInfoValue[0]) && sEntInfoValue[0] != '_CLEAR_'){
			RunMethod("ModifyNumber","GetModifyNumber","business_contract,LandMarkStatus='"+sEntInfoValue[0]+"',serialNo='"+sSerialNo+"'");
			alert("�޸ĳɹ���");
		}
		reloadSelf();
	}
	
	function deleteRecord(){
		var sTypeNo =getItemValue(0,getRow(),"TypeNo");//��ȡɾ����¼�ĵ�Ԫֵ
		if (typeof(sTypeNo)=="undefined" || sTypeNo.length==0){
			alert("������ѡ��һ����¼��");
			return;
		}
		
		if(confirm("�������ɾ������Ϣ��")){
			as_del("myiframe0");
			as_save("myiframe0");  //�������ɾ������Ҫ���ô����
			 reloadSelf();
		}
	}
	
	function checkCStatus(){
		var sTemp;
		
		var editName='<%=CurUser.getUserID()%>'; //�޸���
		var editDate='<%=DateX.format(new java.util.Date(),"yyyy/MM/dd HH:mm:ss")%>'; //�޸�ʱ��
		var signedDate = '<%=BusinessDate%>'; //ǩ������
		
		var sSerialNo =getItemValue(0,getRow(),"SerialNo");
		var sContractStatus =getItemValue(0,getRow(),"ContractStatus");
		
		if(sContractStatus!="��ǩ��" && sContractStatus!="����ͨ��" && sContractStatus!="��ע��" && sContractStatus!="����δע��"){
			sTemp="�����޸ķ�Χ�ڣ�";
			return sTemp;
		}
		
		if(sContractStatus=="��ע��" && "<%=sStatus1%>"=="true" && "<%=sStatus2%>"=="false"){
			sTemp="�Բ�����û���޸�Ȩ�ޣ�";
			return sTemp;
		}
		
		if(sContractStatus=="����δע��" && "<%=sStatus1%>"=="true" && "<%=sStatus2%>"=="false"){
			sTemp="�Բ�����û���޸�Ȩ�ޣ�";
			return sTemp;
		}
		
		//��ȡ��ͬ��ݺš�ԭ������Ϣ
		var sLoanSerialNo = RunMethod("PublicMethod","GetColValue","SerialNo,ACCT_LOAN,String@PutOutNo@"+sSerialNo);
		
		//var sLoanSerialNo = RunMethod("GetElement","GetElementValue","SerialNo,ACCT_LOAN,PutOutNo='"+sSerialNo+"'");
		var sTransReturn = RunMethod("���÷���","GetColValue","ACCT_TRANSACTION,SerialNo,documentserialno='"+sSerialNo+"' and relativeobjectno='"+sLoanSerialNo.split("@")[1]+"' " );
		var sTransSerialNo = sTransReturn;
		
		if (typeof(sLoanSerialNo) !="undefined" && sLoanSerialNo.length >0 && sLoanSerialNo != "Null" && (sContractStatus=="����ͨ��" || sContractStatus=="��ע��")){
			var relativeObjectType = "<%=BUSINESSOBJECT_CONSTATNTS.loan%>";
			//У���Ƿ����δ��ɵĽ���
			var allowApplyFlag = RunMethod("LoanAccount","GetAllowApplyFlag","00,"+relativeObjectType+","+sLoanSerialNo.split("@")[1]);
			if(allowApplyFlag != "true"){
				return "��ҵ���Ѿ�����һ��δ��Ч�Ľ��׼�¼��������ͬʱ���룡";
			}
			//ִ�г�ſ��
			if(confirm("��ͬ��������Ϊ���ѳ�����״̬���Ƿ�ȷ���޸ģ�")){
				var daysFlag = RunMethod("LoanAccount","GetBusinessContractPutOutDays",sSerialNo);//����15�첻�����ſ�
				if(daysFlag=="true"){
						var returnValue = runTransaction(sLoanSerialNo.split("@")[1],sTransSerialNo);
						bReverseTrans = returnValue;
						if(!returnValue){
							return "��ͬ״̬�޸�ʧ�ܣ�";
						}
					
				}else if(daysFlag=="false"){
					return "��Ϣ����ʮ���첻������������";
				}
			}else{
				sTemp= "��ͬ״̬�޸ķ���!";
				return sTemp;
			}
			
		}
		
// 		1040	����ͨ����ͬ
// 		1045	������ͨ����ͬ
// 		1050	�����ܾ���ͬ
// 		1060	��ȡ����ͬ
// 		1070	��ǩ���ͬ
// 		1080	��ע���ͬ
// 		1090	�ѳ�����ͬ
// 		1100	����δע���ͬ
// 		1110	�ѽ����ͬ
// 		1120	�˻ز�����������
// 		1130	�ѹ鵵����

		var sObjectType = "BusinessContract";
		
		if(sContractStatus=="��ǩ��"){
			if(confirm("��ͬ��������Ϊ������ͨ����״̬���Ƿ�ȷ���޸ģ�")){
				/*update CCS-859��PRM-446 �޸����ݷ�ͬһ�������� start*/
				//����ͨ��
				RunMethod("PublicMethod","UpdateColValue","String@ContractStatus@080@String@editName@"+editName+"@String@editDate@"+editDate+",business_contract,String@serialNo@"+sSerialNo);
				//RunMethod("ModifyNumber","GetModifyNumber","business_contract,ContractStatus='080',serialNo='"+sSerialNo+"'");//����ͨ��
				/*update CCS-859��PRM-446 �޸����ݷ�ͬһ�������� end*/
				
				//edit  by pli2 20141118   ע :������������ͼ�в�����һ���޸�Flow_Object��PhaseType��չʾ������ͬ�б�ķ�ʽ��
				//������޸ĺ�ͬ״̬��ͬʱ��Ҫͬ���޸�
				RunMethod("BusinessManage","UpdateApplyPhaseType",sSerialNo+","+sObjectType+","+"1040");//�޸Ľ׶�����
				sTemp="�޸ĳɹ���";
				return sTemp;
			}else{
				sTemp= "��ͬ״̬�޸ĳ���";
				return sTemp;
			}

		}
		if(sContractStatus=="����ͨ��"){
				//����Ƿ���Ҫ����p2p���   add by dahl 
				RunJavaMethodSqlca("com.amarsoft.proj.action.P2PCredit", "checkReturnP2pSum", "ContractSerialNo="+sSerialNo);
				//end by dahl
				/*update CCS-859��PRM-446 �޸����ݷ�ͬһ�������� start*/
				//�ѳ���
				RunMethod("PublicMethod","UpdateColValue","String@ContractStatus@210@String@editName@"+editName+"@String@editDate@"+editDate+",business_contract,String@serialNo@"+sSerialNo);
				//RunMethod("ModifyNumber","GetModifyNumber","business_contract,ContractStatus='210',serialNo='"+sSerialNo+"'");//�ѳ���
				/*update CCS-859��PRM-446 �޸����ݷ�ͬһ�������� end*/
				
				sTemp="�޸ĳɹ���";
			return sTemp;
		}
		if(sContractStatus=="��ע��" && "<%=sStatus1%>"=="true" && "<%=sStatus2%>"=="false"){
			sTemp="�Բ�����û���޸�Ȩ�ޣ�";
			return sTemp;
			
		}else if(sContractStatus=="��ע��"){	
			//��������ͨ������Ҫ�ٽ���һ���жϡ��жϳ���ʱ���Ƿ񳬹�ע��ʱ��ʮ�������ϡ�������������CCS-730 add huzp 20150513
			//��ú�ͬע��ʱ�䲢�뵱ǰ����ʱ��������
			var Registrationdate =getItemValue(0,getRow(),"Registrationdate");
			var EditDate =getItemValue(0,getRow(),"EditDate");
			//����ע��ʱ��������ͨ��ʱ���޸�ʱ���������жϣ�������ʮ�������ϡ����������� add huzp 20150513
			if(EditDate==null||EditDate==""){
				var d2="<%=DateX.format(new java.util.Date(),"yyyy/MM/dd")%>";//��ȡϵͳ��ǰ����
				EditDate=d2;
			 }
			if(GetDateDiff(Registrationdate,EditDate,'day')>15){
				sTemp="��Ϣ����ʮ���첻������������";
			}else{
				/*update CCS-859��PRM-446 �޸����ݷ�ͬһ�������� start*/
				//�ѳ���
				RunMethod("PublicMethod","UpdateColValue","String@ContractStatus@210@String@editName@"+editName+"@String@editDate@"+editDate+",business_contract,String@serialNo@"+sSerialNo);
				//RunMethod("ModifyNumber","GetModifyNumber","business_contract,ContractStatus='210',serialNo='"+sSerialNo+"'");//�ѳ���
				/*update CCS-859��PRM-446 �޸����ݷ�ͬһ�������� end*/
				
				RunMethod("ModifyNumber","GetModifyNumber","business_contract,biaoshi='<%=sStatus1%><%=sStatus2%>',serialNo='"+sSerialNo+"'");
				sTemp="�޸ĳɹ���";
			}
				return sTemp;
		}
		if(sContractStatus=="����δע��"){
			var sReturnValue = RunMethod("PublicMethod","CheckContractDays",sSerialNo+",10");//ϵͳʱ����ڷ����ռ�һ����-10�첻������
			if(sReturnValue=="false"){
				return "�ñʺ�ͬ��������״̬���ģ�";
			}
			//RunMethod("ModifyNumber","GetModifyNumber","business_contract,ContractStatus='020',serialNo='"+sSerialNo+"'");//��ǩ��
			//�޸ĺ�ͬ״̬Ϊ��ǩ��ʱ���Ѻ�ͬǩ������Ҳ����ȥ��
			if(confirm("��ͬ��������Ϊ����ǩ��״̬���Ƿ�ȷ���޸ģ�")){
				/*update CCS-859��PRM-446 �޸����ݷ�ͬһ�������� start*/
				RunMethod("PublicMethod","UpdateColValue","String@ContractStatus@020@String@editName@"+editName+"@String@editDate@"+editDate+"@String@signedDate@"+signedDate+"@String@shiftdocdescribe@"+editDate+",business_contract,String@serialNo@"+sSerialNo);
				/*update CCS-859��PRM-446 �޸����ݷ�ͬһ�������� end*/
				
				sTemp="�޸ĳɹ���";
				return sTemp;
			}else{
				sTemp= "��ͬ״̬�޸ĳ���";
				return sTemp;
			}

		}
	
		return sTemp;
	}
	
	function runTransaction(sLoanSerialNo,sTransSerialNo){
		var objectType = "";
		var transactionCode = "4015";
		var relativeObjectType = "<%=BUSINESSOBJECT_CONSTATNTS.transaction%>";
		
		var relativeObjectNo = sTransSerialNo;
		var transactionDate = "<%=SystemConfig.getBusinessDate()%>";

		//��������ͬʱ����������Ϣ
		var returnValue = RunMethod("LoanAccount","CreateTransaction",objectType+","+transactionCode+","+relativeObjectType+","+relativeObjectNo+","+transactionDate+",<%=CurUser.getUserID()%>,2");
		if(returnValue.substring(0,5) != "true@") {
			alert("��������ʧ�ܣ�����ԭ��-"+returnValue);
			return;
		}
		//ִ�н���
		var transactionSerialNo = returnValue.split("@")[1];	
		var returnTransValue = RunMethod("LoanAccount","RunTransaction2",transactionSerialNo+",<%=CurUser.getUserID()%>,N");
		if(typeof(returnTransValue)=="undefined"||returnTransValue.length==0||returnTransValue.split("@")[0]=="false"){
			//�������ִ��ʧ����ɾ��������Ϣ�͵�����Ϣ
			var documentserialno = RunMethod("PublicMethod","GetColValue","documentserialno,ACCT_TRANSACTION,String@transcode@4015@String@SerialNo@"+returnValue.split("@")[1]);
			RunMethod("PublicMethod","DeleteAcctPaymentValue",documentserialno.split("@")[1]);//"acct_trans_payment,SerilNo,"
			RunMethod("PublicMethod","DeleteColValue",returnValue.split("@")[1]);//"ACCT_TRANSACTION,SerialNo,"
			alert("ϵͳ�����쳣��");
			return false;
		}
		var message=returnValue.split("@")[1];	
		return true;		
	}
	
	
	function doSubmit(){
		var sSerialNo=getItemValue(0,getRow(),"SerialNo");
		var inputUserID=getItemValue(0,getRow(),"InputUser");
		var sContractStatus=getItemValue(0,getRow(),"ContractStatus"); 
		if(typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
		}
		var userType=RunMethod("GetElement","GetElementValue","userType,user_info,userID='"+inputUserID+"' and isCar='02'");
		if(userType=="01"){
			alert("�˺�ͬ���ڲ�Ա����ͬ���������ύ��");
			return;
		}
		if(sContractStatus!="����ͨ��"){
			alert("�ú�ͬ��������ͨ����ͬ,�������ύ!");
			return;
		}
	
		if(confirm("�����ȷ���ύע����")){
			/***********CCS-1041,ϵͳ����ʱ���ܵ�¼ϵͳ huzp 20151217**************************************/
			var sTaskFlag = RunMethod("���÷���","GetColValue","system_setup,taskflag,1=1");
			if(sTaskFlag=="1"){
				alert("ϵͳ������������ʱ�޷��ύע��!");
				return;
			}else{
			var params ="serialNo="+sSerialNo+",userId=<%=CurUser.getUserID()%>";
			var result = RunJavaMethodSqlca("com.amarsoft.app.lending.bizlets.ContractStatusChange","approvedToRegister",params);
			alert(result.split("@")[1]);
			if("true"==result.split("@")[0]){
				reloadSelf();
			}
			}
			return;
		}
	}
	//���2��ʱ������֮��CCS-730 add huzp 20150424
	 function GetDateDiff(startTime, endTime, diffType) {   
		 //��xxxx-xx-xx��ʱ���ʽ��ת��Ϊ xxxx/xx/xx�ĸ�ʽ          
		 startTime = startTime.replace(/\-/g, "/");          
		 endTime = endTime.replace(/\-/g, "/");             
		 //�������������ַ�ת��ΪСд           
		 diffType = diffType.toLowerCase();           
		 var sTime = new Date(startTime);      //��ʼʱ��           
		 var eTime = new Date(endTime);  //����ʱ��           
		 //��Ϊ����������           
		 var divNum = 1;           
		 switch (diffType) {                
			 case "second":                   
			 	divNum = 1000;                   
			 break;                
			 case "minute":                   
				 divNum = 1000 * 60;                 
				 break;              
			 case "hour":                
					 divNum = 1000 * 3600;             
				 break;              
			 case "day":                
					divNum = 1000 * 3600 * 24;      
				 break;            
					default:                  
					break;         
			 }          
		 return parseInt((eTime.getTime() - sTime.getTime()) / parseInt(divNum));    
		 } 
	
	function doCancel()
	{		
		top.returnValue = "_CANCEL_";
		top.close();
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

<%@	include file="/IncludeEnd.jsp"%>

