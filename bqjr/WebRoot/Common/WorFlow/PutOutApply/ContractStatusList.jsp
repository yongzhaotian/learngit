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
    String roleID="";
    String storeID="";
    String doWhere="";
%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/%>
	<%
		
	String userID=CurUser.getUserID();
	StringBuffer sb=new StringBuffer();
	rs=Sqlca.getASResultSet(new SqlObject("select roleid from user_role where userid=:userid").setParameter("userid", userID));
	while(rs.next()){
		roleID=rs.getString("roleid");
		//�����½��ԱΪ���۾��� 
		if("1005".equals(roleID)){
			storeID=Sqlca.getString(new SqlObject("select stores from business_contract where inputuserid=:inputuserid").setParameter("inputuserid", userID));
/*			rs1=Sqlca.getASResultSet(new SqlObject("select inputuserid from business_contract  where stores=:stores").setParameter("stores", storeID));
			while(rs1.next()){
				sb.append("'"+rs1.getString("inputuserid"));
				sb.append("',");
			}
			sb.append("'"+userID+"'");*/
			
//			rs1.getStatement().close();
//			doWhere=" and inputuserid in ("+sb.toString()+")";
            doWhere=" and stores='"+storeID+"'";
		}
	
		//�����¼��Ϊ���۴��� 
	    if("1006".equals(roleID)){
	    	sb.append("'"+userID+"'");
	    	doWhere=" and inputuserid in ("+sb.toString()+")";
	    }
		
	}
	rs.getStatement().close();
	
	 ASDataObject doTemp = null;
	 String sTempletNo = "ContractStatus";
	 doTemp = new ASDataObject(sTempletNo,Sqlca);//����ģ�ͣ�2013-5-9
	 doTemp.generateFilters(Sqlca);
	 doTemp.parseFilterData(request,iPostChange);
	 CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	 if(!doTemp.haveReceivedFilterCriteria()){
		 doTemp.WhereClause+=" and 1=2"; 
	 }else{
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
		{"true","","Button","�޸ĺ�ͬ״̬","�޸ĺ�ͬ״̬","editContract()",sResourcesPath},
		{"true","","Button","�޸ĵر�״̬","�޸ĵر�״̬","editLandMark()",sResourcesPath},	
		{"true","","Button","ȡ������","ȡ������","deleteRecord()",sResourcesPath},
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
	function editContract(){
		var sSerialNo =getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert("������ѡ��һ����¼��");
			return;
		}
		if(confirm("�����ȷ���޸ĺ�ͬ״̬��")){
			var sTemp=checkCStatus();
			alert(sTemp);
			reloadSelf();
		}
	}
	
	function editLandMark(){
		var sSerialNo =getItemValue(0,getRow(),"SerialNo");
	    if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert("������ѡ��һ����¼��");
			return;
		}
	    var sEntInfoValue=setObjectValue("SelectLandMarkStatus","","",0,0,"");
	    sEntInfoValue=sEntInfoValue.split("@");
		if (typeof(sEntInfoValue)=="undefined" || sEntInfoValue.length==0){
			alert("��ѡ����һ���ر�״̬");
			return;
		}
		RunMethod("ModifyNumber","GetModifyNumber","business_contract,LandMarkStatus='"+sEntInfoValue[0]+"',serialNo='"+sSerialNo+"'");
		alert("�޸ĳɹ���");
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
		var sSerialNo =getItemValue(0,getRow(),"SerialNo");
		var sContractStatus =getItemValue(0,getRow(),"ContractStatus");
		
		if(sContractStatus!="��ǩ��" && sContractStatus!="����ͨ��" && sContractStatus!="��ע��" && sContractStatus!="����δע��"){
			sTemp="�����޸ķ�Χ�ڣ�";
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
			var allowApplyFlag = RunMethod("LoanAccount","GetAllowApplyFlag","00,"+relativeObjectType+","+sLoanSerialNo);
			if(allowApplyFlag != "true"){
				return "��ҵ���Ѿ�����һ��δ��Ч�Ľ��׼�¼��������ͬʱ���룡";
			}
			//ִ�г�ſ��
			var daysFlag = RunMethod("LoanAccount","GetBusinessContractPutOutDays","SerialNo,"+sSerialNo);//����15�첻�����ſ�
			if(daysFlag){
				var returnValue = runTransaction(sLoanSerialNo,sTransSerialNo);
				if(!returnValue){
					return "��ͬ״̬�޸�ʧ�ܣ�";
				}
			}else{
				return "��Ϣ����ʮ���첻������������";
			}
			
		}
			
		if(sContractStatus=="��ǩ��"){
			RunMethod("ModifyNumber","GetModifyNumber","business_contract,ContractStatus='080',serialNo='"+sSerialNo+"'");//����ͨ��
			sTemp="�޸ĳɹ���";
			return sTemp;
		}
		if(sContractStatus=="����ͨ��"){
			//��������ͨ������Ҫ�ٽ���һ���жϡ��жϳ���ʱ���Ƿ񳬹�ע��ʱ��ʮ�������ϡ�������������CCS-730 add huzp 20150423
			//��ú�ͬע��ʱ�䲢�뵱ǰ����ʱ��������
			var Registrationdate =getItemValue(0,getRow(),"Registrationdate");
			var EditDate =getItemValue(0,getRow(),"EditDate");
			//����ע��ʱ��������ͨ��ʱ���޸�ʱ���������жϣ�������ʮ�������ϡ�����������CCS-730 add huzp 20150423
			if(EditDate==null||EditDate==""){
				var d2="<%=DateX.format(new java.util.Date(),"yyyy/MM/dd")%>";//��ȡϵͳ��ǰ����
				EditDate=d2;
			 }
			if(GetDateDiff(Registrationdate,EditDate,'day')>15){
				sTemp="��Ϣ����ʮ���첻������������";
			}else{
				RunMethod("ModifyNumber","GetModifyNumber","business_contract,ContractStatus='210',serialNo='"+sSerialNo+"'");//�ѳ���
				sTemp="�޸ĳɹ���";
			}
			return sTemp;
		}
		if(sContractStatus=="��ע��"){			
			RunMethod("ModifyNumber","GetModifyNumber","business_contract,ContractStatus='210',serialNo='"+sSerialNo+"'");//�ѳ���
			sTemp="�޸ĳɹ���";
			return sTemp;
		}
		if(sContractStatus=="����δע��"){
			RunMethod("ModifyNumber","GetModifyNumber","business_contract,ContractStatus='020',serialNo='"+sSerialNo+"'");//��ǩ��
			sTemp="�޸ĳɹ���";
			return sTemp;
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
			return false;
		}
		//ִ�н���
		var transactionSerialNo = returnValue.split("@")[1];	
		var returnTransValue = RunMethod("LoanAccount","RunTransaction2",transactionSerialNo+",<%=CurUser.getUserID()%>,N");
		if(typeof(returnTransValue)=="undefined"||returnTransValue.length==0||returnTransValue.split("@")[0]=="false"){
			//�������ִ��ʧ����ɾ��������Ϣ�͵�����Ϣ
			RunMethod("PublicMethod","DeleteColValue",returnValue.split("@")[1]);//"ACCT_TRANSACTION,SerialNo,"
			var documentserialno = RunMethod("PublicMethod","GetColValue","documentserialno,ACCT_TRANSACTION,String@transcode@4015@String@SerialNo@"+returnValue.split("@")[1]+"@String@relativeobjectno@"+sLoanSerialNo);
			RunMethod("PublicMethod","DeleteAcctPaymentValue",documentserialno);//"acct_trans_payment,SerilNo,"
			alert("ϵͳ�����쳣��");
			return false;
		}
		var message=returnValue.split("@")[1];	
		return true;		
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

