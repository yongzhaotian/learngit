<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author:
		Tester:
		Describe: 
		
		Input Param:
		SerialNo:��ˮ��
		
		Output Param:
			
		HistoryLog:
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "�Ե�����б� "; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info02;Describe=�����������ȡ����;]~*/%>
<%
	//���ҳ�����
//	String sSerialNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("LoanNo"));
//	if(sSerialNo == null) sSerialNo = "";
%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/%>
	<%
		
	
	 ASDataObject doTemp = null;
	 String sTempletNo = "LoanPilotCityList";
	 doTemp = new ASDataObject(sTempletNo,Sqlca);//����ģ�ͣ�2013-5-9
	
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	doTemp.multiSelectionEnabled=true;
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
		
	 
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //����Ϊֻ��
	dwTemp.setPageSize(100);  //��������ҳ
	
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
		{"true","","Button","�����Ե����","����","newRecord()",sResourcesPath},
		{"true","","Button","ɾ��","ɾ����ѡ�еĳ���","deleteRecord()",sResourcesPath}
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
	function newRecord(){
		
		var sParaString = "CodeNo"+","+"SubProductType";
		var sSubProductType =setObjectValue("SelectCode",sParaString,"",0,0,"");//SelectCode_Grad  SelectCode
		sSubProductType = sSubProductType.split("@")[0];
		
		sParaString = "CodeNo"+","+"PilotType";
		var vPilotType =setObjectValue("SelectCode",sParaString,"",0,0,"");//SelectCode_Grad  SelectCode
		vPilotType = vPilotType.split("@")[0];
		
 		var sReturn = RunMethod("SystemManage", "selectPilotCityIsNotNull", vPilotType+","+sSubProductType);
 		if(sReturn==0){
 			alert("�ò�Ʒ�������Ѿ�û�пɹ����ĳ����ˣ�");
 			return;
 		}
 		
	    var sCityName = PopPage("/SystemManage/PilotCityManage/AddPilotCity.jsp?SubProductType="+sSubProductType+"&PilotType="+vPilotType,"","400px;dialogHeight=540px;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;");
	    if(typeof(sCityName)=="undefined" || sCityName.length==0 || sCityName=="_none_"){
	    	return;
	    }
	    reloadSelf();
	}
	
	
	function deleteRecord(){

		var sCitys = getItemValueArray(0,"city");
		var sSubProductTypes = getItemValueArray(0,"SUBPRODUCTTYPE");
		var sVerifyTypes = getItemValueArray(0,"VERIFYTYPE");
		var sCity = sCitys[0];
		var sSubProductType = sSubProductTypes[0];
		var sVerifyType = sVerifyTypes[0];
		
		if(typeof(sCity)=="undefined" || sCity.length==0 || typeof(sSubProductType)=="undefined" || sSubProductType.length==0 ||typeof(sVerifyType)=="undefined" || sVerifyType.length==0){
			alert("������ѡ��һ����¼��");
			return;
		}
		
		if(confirm("�������ɾ������Ϣ��")){
			for(var i=0;i<sCitys.length;i++){
				RunMethod("SystemManage", "deletePilotCity", sVerifyTypes[i]+","+sCitys[i]+","+sSubProductTypes[i]);
			}
			as_save("myiframe0");  //�������ɾ������Ҫ���ô����
			reloadSelf();
		}
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

