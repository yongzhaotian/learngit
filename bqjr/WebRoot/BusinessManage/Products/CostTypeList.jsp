<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author: hxli 2005-8-1
		Tester:
		Describe: �ÿ��¼�б�
		
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
	String PG_TITLE = "����ά��"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>



<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/%>
	<%
		
	//���ҳ�����,��Ʒ���
	String sTypeNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("typeNo"));
	if(sTypeNo == null) sTypeNo = "";
	
	 ASDataObject doTemp = null;
	 String sTempletNo = "CostType1";
	 doTemp = new ASDataObject(sTempletNo,Sqlca);//����ģ�ͣ�2013-5-9
	 if(!sTypeNo.equals("")){
		 doTemp.multiSelectionEnabled=true;
	 }
	 doTemp.setColumnAttribute("costNo,feeType","IsFilter","1");
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
		{"true","","Button","����","��������¼","newRecord()",sResourcesPath},
		{"true","","Button","����","�����¼","myDetail()",sResourcesPath},
		{"true","","Button","ɾ��","ɾ����ѡ�еļ�¼","deleteRecord()",sResourcesPath}
		};
	if(!sTypeNo.equals("")){
		sButtons[0][3]="ȷ��";
		sButtons[0][4]="ȷ��";
		sButtons[0][5]="determine()";
		sButtons[1][3]="ȡ��";
		sButtons[1][4]="ȡ��";
		sButtons[1][5]="doCancel()";
		sButtons[2][0]="false";
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
		sCompID = "CostType";
		sCompURL = "/BusinessManage/Products/CostTypeInfo.jsp";
	    popComp(sCompID,sCompURL," ","dialogWidth=320px;dialogHeight=430px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
	    reloadSelf();
	}
	
	function myDetail(){
		var sSerialNo =getItemValue(0,getRow(),"serialNo");
		var sFeeType =getItemValue(0,getRow(),"feeType");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert("������ѡ��һ����¼��");
			return;
		}else{
			AsControl.OpenView("/BusinessManage/Products/CostTypeDetailInfo.jsp","serialNo="+sSerialNo+"&feeType="+sFeeType,"_self");
			
		}
	}
	
	function deleteRecord(){
		var sSerialNo =getItemValue(0,getRow(),"serialNo");//��ȡɾ����¼�ĵ�Ԫֵ
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert("������ѡ��һ����¼��");
			return;
		}
		
		if(confirm("�������ɾ������Ϣ��")){
			as_del("myiframe0");
			as_save("myiframe0");  //�������ɾ������Ҫ���ô����
			 reloadSelf();
		}
	}
	
	function determine(){
		var sSerialNo = getItemValueArray(0,"serialNo");
		var temp="";//��¼���ô���
		var flag=true;
		for(var i=0;i<sSerialNo.length;i++){
			var count= RunMethod("Unique","uniques","businessType_Cost,count(1),costNo='"+sSerialNo[i]+"' and busTypeID=<%=sTypeNo%>");
			if(count>="1.0"){
				 temp=temp+sSerialNo[i]+",";
				 flag=false;
			 }
		}
		if(flag&&sSerialNo!=""){
			for(var i=0;i<sSerialNo.length;i++){
				 RunMethod("BusinessTypeRelative","InsertBusRelative","businessType_Cost,busTypeCostID,busTypeID,costNo,"+getSerialNo("businessType_Cost", "busTypeCostID", " ")+",<%=sTypeNo%>,"+sSerialNo[i]);
			}
			alert("����ɹ�������");
			top.close();
		}else if(sSerialNo!=""){
			alert("��ѡ�������Ѵ��ڼ�¼��������ѡ��лл��");
		}else{
			alert("��û��ѡ���¼�����ܵ��룡��ѡ��");
		}		
		
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

