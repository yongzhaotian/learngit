<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author: hxli 2005-8-1
		Tester:
		Describe: ��������Ϣ����
		
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
	String PG_TITLE = "��������Ϣ���� "; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info02;Describe=�����������ȡ����;]~*/%>
<%
	//���ҳ�����
	String sTemp = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("temp"));	   
	String sTypeNo    = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("typeNo"));
	if(sTypeNo==null) sTypeNo="";	
	if(sTemp==null) sTemp="";
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/%>
	<%
			
	 ASDataObject doTemp = null;
	 String sTempletNo = "DistributorList";
	 doTemp = new ASDataObject(sTempletNo,Sqlca);//����ģ�ͣ�2013-5-9
	 if(sTemp.equals("3")){
		 doTemp.multiSelectionEnabled=true;
	 }
	 doTemp.setColumnAttribute("distributorName,distributorType","IsFilter","1");
	 doTemp.generateFilters(Sqlca);
	 doTemp.parseFilterData(request,iPostChange);
	 CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //����Ϊֻ��
	//����HTMLDataWindow
	Vector vTemp=null;
	if(sTemp.equals("3")){
		vTemp = dwTemp.genHTMLDataWindow(sTypeNo);//�����������ݣ�2013-5-9
	}else{
		 vTemp = dwTemp.genHTMLDataWindow("");//�����������ݣ�2013-5-9
	}
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
		{"true","","Button","����������","����������","newRecord()",sResourcesPath},
		{"true","","Button","�鿴/�޸ľ���������","�鿴/�޸ľ���������","modifyDetail()",sResourcesPath},	
		{"true","","Button","�ļ��ϴ���ɨ��","�ļ��ϴ���ɨ��","d()",sResourcesPath},
		{"true","","Button","����������","����������","enable()",sResourcesPath},
		};
	 if(sTemp.equals("2")){
		sButtons[0][3]="ȷ��";
		sButtons[0][4]="ȷ��";
		sButtons[0][5]="determine1()";
		sButtons[1][3]="ȡ��";
		sButtons[1][3]="ȡ��";
		sButtons[1][5]="doCancel()";
		sButtons[2][0]="false";
		sButtons[3][0]="false";
	}else if (sTemp.equals("3")){
		sButtons[0][3]="ȷ��";
		sButtons[0][4]="ȷ��";
		sButtons[0][5]="determine2()";
		sButtons[1][3]="ȡ��";
		sButtons[1][3]="ȡ��";
		sButtons[1][5]="doCancel()";
		sButtons[2][0]="false";
		sButtons[3][0]="false";
	}
	%>
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">
	function newRecord(){
		OpenPage("/DistributorInfo/DistributorInfo.jsp","_self","");
	}
 
	function determine1(){
		var sCustomerID =getItemValue(0,getRow(),"serialNo");
		var sEntErpriseName =getItemValue(0,getRow(),"entErpriseName");
		if (typeof(sCustomerID)=="undefined" || sCustomerID.length==0){
			alert("��ѡ��һ�������̣�");
			return;
		}	
	   	window.close();
	}
	
	function doCancel()
	{		
		top.returnValue = "_CANCEL_";
		top.close();
	}
	
	function determine2(){
		var sCustomerID = getItemValueArray(0,"serialNo");	
		var temp="";//��¼���ô���
		var flag=true;
		for(var i=0;i<sCustomerID.length;i++){
			var count= RunMethod("Unique","uniques","businessType_Car,count(1),customerID='"+sCustomerID[i]+"' and busTypeID=<%=sTypeNo%>");
			if(count>="1.0"){
				 temp=temp+sCustomerID[i]+",";
				 flag=false;
			 }
		}
		if(flag&&sCustomerID!=""){
			for(var i=0;i<sCustomerID.length;i++){
				 RunMethod("BusinessTypeRelative","InsertBusRelative","businessType_Car,busTypeCarID,busTypeID,customerID,"+getSerialNo("businessType_Car", "busTypeCarID", " ")+",<%=sTypeNo%>,"+sCustomerID[i]);
			}
			alert("����ɹ�������");
			top.close();
		}else if(sCustomerID!=""){
			alert("��ѡ��������Ѵ��ڼ�¼��������ѡ��лл��");
		}else{
			alert("��û��ѡ���¼�����ܵ��룡��ѡ��");
		}		
	}
	
	function modifyDetail(){
		var sSerialNo =getItemValue(0,getRow(),"serialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert("��ѡ��һ����¼��");
			return;
		}
		AsControl.OpenView("/DistributorInfo/DistributorDetail.jsp","serialNo="+sSerialNo,"_blank");
		reloadSelf();
	}
	
	function enable(){
		var sSerialNo =getItemValue(0,getRow(),"serialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert("��ѡ��һ����¼��");
			return;
		}
		if(confirm("��������øþ�������")){
			RunMethod("ModifyNumber","GetModifyNumber","Service_Providers,distributorStaus='02',serialNo='"+sSerialNo+"'");
		}
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

