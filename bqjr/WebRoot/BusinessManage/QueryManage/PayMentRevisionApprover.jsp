<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author: jiangyuanlin 2015 06 01
		Tester:
		Describe: ����ƻ����������˽���
		
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
	String PG_TITLE = "����ƻ�����������"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/%>
	<%
	String sDoWhere  = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("doWhere"));	
	if(sDoWhere==null) sDoWhere="";	
	String BusinessDate = SystemConfig.getBusinessDate();
	
	String sHeaders[][] = { 							
			{"serialno","������ˮ��"},
			{"contractSerialno","��ͬ��"},
			{"customerId","�ͻ����"},
			{"customerName","�ͻ�����"},
			{"statusName","״̬"},
			{"status","״̬"},
			{"applicant","����ԱID"},
			{"applicantName","����Ա����"},
			{"inputeBy","������ID"},
			{"inputeByName","������"},
			{"applicantDate","����ʱ��"},
			{"approver","������"},
			{"approverName","������"},
			{"approverDate","����ʱ��"}
		   }; 

	String sSql ="select r.serialno as serialno,r.contract_serialno as contractSerialno,r.customer_id as customerId, "
		    +" r.customer_name as customerName,r.applicant as applicant,getusername(r.applicant) as applicantName,  "
			+"r.inpute_by as inputeBy,getusername(r.inpute_by) as inputeByName, r.applicant_date as applicantDate, "
		    +" r.status as status ,decode(r.status,'1','������','2','������','3','������',4,'�ܾ�')  as statusName,r.approver as approver ,getusername(r.approver) as approverName,r.approver_date as approverDate "
		    +" from Acct_Payment_Reversion r "
		    +" ";
	 ASDataObject doTemp = null;
	 doTemp = new ASDataObject(sSql);
	 doTemp.setHeader(sHeaders);	
	 doTemp.setKey("serialNo", true);
	 doTemp.setVisible("serialno,status,approver,inputeBy", false);
	 doTemp.setCheckFormat("applicantDate,approverDate", "3");
	 doTemp.setHTMLStyle("applicantDate,approverDate"," style={width:140px} "); 
	 doTemp.setColumnAttribute("contractSerialno,customerId,customerName,status,applicant,applicantName,applicantDate,approver,approverDate","IsFilter","1");
	 
	 doTemp.setDDDWCodeTable("status", "2,�����,3,�����,4,�ܾ�");
	 
	 doTemp.setFilter(Sqlca, "0010", "status", "Operators=EqualsString;");
     doTemp.setFilter(Sqlca, "0020", "contractSerialno", "Operators=EqualsString,BeginsWith;");
	 doTemp.setFilter(Sqlca, "0031", "applicant", "Operators=EqualsString;");
	 doTemp.setFilter(Sqlca, "0030", "applicantName", "Operators=EqualsString,BeginsWith;");
	 doTemp.setFilter(Sqlca, "0040", "customerId", "Operators=EqualsString;");
	 doTemp.setFilter(Sqlca, "0041", "customerName", "Operators=EqualsString,BeginsWith;");
	 doTemp.setFilter(Sqlca, "0050", "applicantDate", "Operators=EqualsString,BeginsWith;");
	 
	 
	 doTemp.parseFilterData(request,iPostChange);
	 
	 doTemp.multiSelectionEnabled=true;
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
			
	 }
	 if(!doTemp.haveReceivedFilterCriteria()) doTemp.WhereClause+=" and r.status='2' ";
	 
	 CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //����Ϊֻ��
	dwTemp.setPageSize(10);
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
				{"true","","Button","Ԥ��","Ԥ��","view()",sResourcesPath},
				{"true","","Button","ͬ��","ͬ��","approver(3)",sResourcesPath},
				{"true","","Button","�ܾ�","�ܾ�","approver(4)",sResourcesPath},
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
	/*~[Describe=������¼;InputParam=��;OutPutParam=��;]~*/
	function approver(submitType){
		var sSerialNo = getItemValueArray(0,"serialno");
// 		sSerialNoS = sSerialNoS.split(",");
		if(typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
		}
		var status = getItemValueArray(0,"status");
		for(var j=0;j<status.length;j++){
			if(status[j]!="2"){
				alert("ѡ�����������������ܾ������룬������ѡ��");
				return;
			}
		}
		if(!confirm("�����ȷ��ִ������ѡ�е�������")){
			return;
		}
		var userId = '<%=CurUser.getUserID() %>';
		var revisionSerialnos ="userId="+userId+",submitType="+submitType+",revisionSerialnos=";
		for(var i=0;i<sSerialNo.length;i++){
			revisionSerialnos+= sSerialNo[i]+"|";
		}
		 revisionSerialnos = revisionSerialnos.substring(0,revisionSerialnos.length-1)
		 RunJavaMethodSqlca("com.amarsoft.app.lending.bizlets.PayMentRevisionSchedule","approver",revisionSerialnos);
		 if(submitType==3){
		  alert("����ͨ����");
		 }else if(submitType==4){
		  alert("�����ɹ���");
		 }
		 reloadSelf();
	}
	
	function view(){
		var sSerialNo = getItemValueArray(0,"serialno");
		var contractSerialno = getItemValueArray(0,"contractSerialno");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length!=1){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		var sCompID = "CreditTab";
		var sCompURL = "/BusinessManage/QueryManage/PayMentRevisionScheduleView.jsp";
		var sParamString = "revisionSerialNo="+sSerialNo+"&ObjectNo="+contractSerialno;
		openComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
	}
	
	function exportExcel(){
		amarExport("myiframe0");
	}
	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List07;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script type="text/javascript">
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
// 	showFilterArea();
</script>
<%/*~END~*/%>

<%@	include file="/IncludeEnd.jsp"%>

