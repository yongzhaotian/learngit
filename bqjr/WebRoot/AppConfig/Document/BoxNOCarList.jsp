<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author: hxli 2005-8-1
		Tester:
		Describe: δ�鵵�ĳ����Ǽ�֤
		
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
	String PG_TITLE = "δ�鵵�ĳ����Ǽ�֤"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>



<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/%>
	<%
	String sCurItemID =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("curItemID"));
	if(sCurItemID == null) sCurItemID = "";
		
		
	String sTempletNo="";
	 ASDataObject doTemp = null;
	 if(sCurItemID.equals("3")){
		 sTempletNo = "BoxNOCarList";
	 }else if(sCurItemID.equals("4")) {
		 sTempletNo = "BoxYesCarList";
	 }else if(sCurItemID.equals("5")){
		 sTempletNo = "BoxNoLendCarList";
	 }
	 else if(sCurItemID.equals("6")){
		 sTempletNo = "BoxLendCarList";
	 }else if(sCurItemID.equals("7")){
		 sTempletNo = "BoxStayOutCarList";
	 }else if(sCurItemID.equals("8")){
		 sTempletNo = "BoxOutCarList";
	 }
	 doTemp = new ASDataObject(sTempletNo,Sqlca);//����ģ�ͣ�2013-5-9
	 if(sCurItemID.equals("3")){
		 doTemp.setColumnAttribute("customerName,contractEffectiveDate","IsFilter","1");
	 }else if (sCurItemID.equals("4")){
		 doTemp.setColumnAttribute("customerName,CarFrame,carNumber","IsFilter","1");
	 }else{
		 doTemp.setColumnAttribute("customerName,CarFrame","IsFilter","1");
	 }
	 doTemp.generateFilters(Sqlca);
	 doTemp.parseFilterData(request,iPostChange);
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
		{"true","","Button","�����ھ����ʼ�","�����ھ����ʼ�","newRecord()",sResourcesPath},		
		};
	   if(sCurItemID.equals("4")){
		   sButtons[0][0]="false";
	   }else if(sCurItemID.equals("5")){
		   sButtons[0][3]="��ʱ���";
		   sButtons[0][4]="��ʱ���";
		   sButtons[0][5]="lendCar()";
	   }else if(sCurItemID.equals("6")){
		   sButtons[0][3]="�黹�Ǽ�֤";
		   sButtons[0][4]="�黹�Ǽ�֤";
	   }else if(sCurItemID.equals("7")){
		   sButtons[0][3]="�Ǽ�֤����";
		   sButtons[0][4]="�Ǽ�֤����";
		   sButtons[0][5]="outCar()";
	   }else if(sCurItemID.equals("8")){
		   sButtons[0][0]="false";
	   }
	%>
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">

	//---------------------���尴ť�¼�------------------------------------
	/*~[Describe=������¼;InputParam=��;OutPutParam=��;]~*/
	function newRecord(){
	}
	
	function lendCar(){
		var sRetVal = setObjectValue("SelectContractCarInfo", "", "", 0, 0, "");
		if (typeof(sRetVal)=="undefined" || sRetVal=="_CLEAR_" || sRetVal.length==0) {
			alert("��ѡ��һ����¼!");
			return;
		}
		var sTypeArry = sRetVal.substring(0, sRetVal.length-1).split("@");
		sSerialNo=sTypeArry[0];
		sCustomerID=sTypeArry[1];
		sCompID = "BoxNoLendCarInfo";
		sCompURL = "/AppConfig/Document/BoxNoLendCarInfo.jsp";
	    popComp(sCompID,sCompURL,"serialNo="+sSerialNo,"dialogWidth=300px;dialogHeight=360px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
	    reloadSelf();
	}
	
	function myDetail(){
		sTypeNo=getItemValue(0,getRow(),"TypeNo");	
		if(typeof(sTypeNo)=="undefined" || sTypeNo.length==0){
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return
		}else{
			AsControl.OpenView("/BusinessManage/BusinessType/BusinessTypeDetail.jsp","typeNo="+sTypeNo,"_blank");		
		}
	}
	
	function outCar(){
		var sSerialNo=getItemValue(0,getRow(),"serialNo");	
		if(typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
		}
		RunMethod("ModifyNumber","GetModifyNumber","business_contract,CarStatus='06',serialNo='"+sSerialNo+"'");
		reloadSelf();
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

