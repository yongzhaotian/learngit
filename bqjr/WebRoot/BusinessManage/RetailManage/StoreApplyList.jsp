<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%
	/*
		--ҳ��˵��: ʾ���б�ҳ��--
	 */
	String PG_TITLE = "ʾ���б�ҳ��";
	//���ҳ�����
	//String sInputUser =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("InputUser"));
	//if(sInputUser==null) sInputUser="";
	
	//ͨ��DWģ�Ͳ���ASDataObject����doTemp
	String sTempletNo = "StoreApplyList";//ģ�ͱ��
	String sType =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("type"));
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	String sUserCity = Sqlca.getString(new SqlObject("select city from user_info where userid=:userid").setParameter("userid", CurUser.getUserID()));
	if(CurUser.hasRole("1004")){
	if(sType.equals("01")){
		   doTemp.WhereClause="where  PrimaryApproveTime is null and AgreementApproveTime is null and AgreementApproveTime is null and PrimaryApproveStatus='3' and  AgreementApproveStatus='3' and SafDepApproveStatus='3' and city='"+sUserCity+"'"; 
				      			

		}else if (sType.equals("02")){
			
			doTemp.WhereClause="where ((PrimaryApproveStatus in ('1','4') and  AgreementApproveStatus in ('1','4') and SafDepApproveStatus='4')or(PrimaryApproveStatus in ('1','4') and  AgreementApproveStatus ='4' and SafDepApproveStatus in ('1','4')))and city='"+sUserCity+"'";
		}else if(sType.equals("03")){
			doTemp.WhereClause="where PrimaryApproveStatus ='1' and  AgreementApproveStatus='1' and SafDepApproveStatus='1' and sno is not null and city='"+sUserCity+"'";
		}else {
			
			doTemp.WhereClause="where (PrimaryApproveStatus ='2' or  AgreementApproveStatus='2' or SafDepApproveStatus='2' )and city='"+sUserCity+"'";
		}
	}else {
		if(sType.equals("01")){
			   doTemp.WhereClause="where  PrimaryApproveTime is null and AgreementApproveTime is null and AgreementApproveTime is null and PrimaryApproveStatus='3' and  AgreementApproveStatus='3' and SafDepApproveStatus='3' and inputuser='"+CurUser.getUserID()+"'"; 
					      			

			}else if (sType.equals("02")){
				
				doTemp.WhereClause="where ((PrimaryApproveStatus in ('1','4') and  AgreementApproveStatus in ('1','4') and SafDepApproveStatus='4')or(PrimaryApproveStatus in ('1','4') and  AgreementApproveStatus ='4' and SafDepApproveStatus in ('1','4')))and inputuser='"+CurUser.getUserID()+"'";
			}else if(sType.equals("03")){
				doTemp.WhereClause="where PrimaryApproveStatus ='1' and  AgreementApproveStatus='1' and SafDepApproveStatus='1' and sno is not null and inputuser='"+CurUser.getUserID()+"'";
			}else {
				
				doTemp.WhereClause="where (PrimaryApproveStatus ='2' or  AgreementApproveStatus='2' or SafDepApproveStatus='2' )and inputuser='"+CurUser.getUserID()+"'";
			}
	}
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.setPageSize(10);

	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
			//0���Ƿ�չʾ 1��	Ȩ�޿���  2�� չʾ���� 3����ť��ʾ���� 4����ť�������� 5����ť�����¼�����	6����ݼ�	7��	8��	9��ͼ�꣬CSS�����ʽ 10�����
			{(sType.equals("01")&&CurUser.hasRole("1005"))?"true":"false","All","Button","����","����һ����¼","newRecord()","","","","btn_icon_add",""},
			{"true","","Button","����","�鿴/�޸�����","viewAndEdit()","","","","btn_icon_detail",""},
			{(sType.equals("01")&&CurUser.hasRole("1005"))?"true":"false","All","Button","ɾ��","ɾ����ѡ�еļ�¼","deleteRecord()","","","","btn_icon_delete",""},
			{((sType.equals("01")||sType.equals("04"))&&CurUser.hasRole("1005"))?"true":"false","All","Button","�ύ","�ύ��ѡ�еļ�¼","doSubmit()","","","","btn_icon_submit",""},
			{(sType.equals("02")&&CurUser.hasRole("1005"))?"true":"false","","Button","����","����","UndoRetailInfo()","","","","btn_icon_detail",""}, //add by tangyb CCS-992
		};
	
	
%>
<%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
	function newRecord(){
		
     	AsControl.PopView("/BusinessManage/RetailManage/StoreInfoDetail.jsp", "", "");
		reloadSelf();
	
	}
	
	function deleteRecord(){
		var sSerialNo = getItemValue(0,getRow(),"SERIALNO");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert("��ѡ��һ����¼��");
			return;
		}
		
		if(confirm("�������ɾ������Ϣ��")){
			as_del("myiframe0");
			as_save("myiframe0");  //�������ɾ������Ҫ���ô����
		}
	}

	function viewAndEdit(){
		var sSerialNo = getItemValue(0,getRow(),"SERIALNO");
		var sRegCode=getItemValue(0,getRow(),"REGCODE");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert("��ѡ��һ����¼��");
			return;
		}
	
		AsControl.OpenView("/BusinessManage/RetailManage/StoreInfoDetail.jsp","SerialNo="+sSerialNo+"&RegCode="+sRegCode+"&PhaseType=<%=sType%>","_blank");
		reloadSelf();
	}
	
	//-- add by ��ӳ������� tangyb 20151223 --//
	function UndoRetailInfo(){
		var sSerialNo = getItemValue(0,getRow(),"SERIALNO");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert("��ѡ��һ����¼��");
			return;
		}
		var sPrimaryApproveStatus = RunMethod("���÷���", "GetColValue", "store_info,PRIMARYAPPROVESTATUS,serialno='"+sSerialNo+"'");
		var sAgreementApproveStatus = RunMethod("���÷���", "GetColValue", "store_info,AGREEMENTAPPROVESTATUS,serialno='"+sSerialNo+"'");
	    var sSafDepApproveStatus = RunMethod("���÷���", "GetColValue", "store_info,SAFDEPAPPROVESTATUS,serialno='"+sSerialNo+"'");
	    if((sPrimaryApproveStatus !="4") || (sAgreementApproveStatus !="4" )|| (sSafDepApproveStatus !="4" ) ){
	    	alert("��������Э���ȫ�������������ܳ�����");
	    }else if(sPrimaryApproveStatus=="4"&&sAgreementApproveStatus=="4" &&sSafDepApproveStatus=="4"){
	    	RunMethod("PublicMethod","UpdateColValue","String@PrimaryApproveStatus@3@String@PrimaryApproveTime@None@String@AgreementApproveStatus@3@String@SafDepApproveStatus@3,store_info,String@SerialNo@"+sSerialNo);
	    	RunJavaMethodSqlca("com.amarsoft.app.billions.UpdateRetailRno", "selectSnoIsBuild", "SerialNo="+sSerialNo);
	    	alert("�����ɹ�");
	    }
	    reloadSelf();
	}
	//-- end --//
	
	function doSubmit(){
		var sSerialNo = getItemValue(0,getRow(),"SERIALNO");
		var sRegCode = getItemValue(0,getRow(),"REGCODE");
	
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		var sCount = RunMethod("���÷���", "GetColValue", "DOC_ATTACHMENT,count(1),OBJECTNO='"+sRegCode+"'");
		if(sCount=="0.0"){
			alert("�����ϴ�������Ϣ��");
			return;
		}
		//�����Ƿ����ŵ�ȷ�Ϻ�
		var sCount = RunMethod("���÷���", "GetColValue", "DOC_ATTACHMENT,count(1), Type='A0002' and OBJECTNO='"+sRegCode+"'");
		if(sCount=="0.0"){
			RunMethod("���÷���", "UpdateColValue", "store_info,ISSTORECONFIRLETTER,2,serialno='"+sSerialNo+"'");
		}else{
			RunMethod("���÷���", "UpdateColValue", "store_info,ISSTORECONFIRLETTER,1,serialno='"+sSerialNo+"'");
		}
		
		var sType = "<%=sType%>";
		if(sType=="04"){
			RunMethod("BusinessManage", "UpdateStorelTime",sSerialNo);
		}

		//�ύ
		RunJavaMethodSqlca("com.amarsoft.app.billions.UpdateRetailRno", "firstSubmitStore", "SerialNo="+sSerialNo);
		
		reloadSelf();
	}
	<%/*~[Describe=ʹ��ObjectViewer��;InputParam=��;OutPutParam=��;]~*/%>
	function openWithObjectViewer(){
		var sExampleId = getItemValue(0,getRow(),"ExampleId");
		if (typeof(sExampleId)=="undefined" || sExampleId.length==0){
			alert("��ѡ��һ����¼��");
			return;
		}
		
		AsControl.OpenObject("Example",sExampleId,"001");//ʹ��ObjectViewer����ͼ001��Example��
	}

	$(document).ready(function(){
		AsOne.AsInit();
		init();
		my_load(2,0,'myiframe0');
	});
</script>	
<%@ include file="/IncludeEnd.jsp"%>
