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
	String PG_TITLE = "�����ò�Ʒ�µĳ���"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info02;Describe=�����������ȡ����;]~*/%>
<%

	//���ҳ�����
    String sTypeNo    = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("typeNo"));
    if(sTypeNo==null) sTypeNo="";
    System.out.println(sTypeNo+"----------------");
%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/%>
	<%
	String sHeaders[][] = { 							
			{"StatisticDate","ͳ������"},
			{"modelsID","���ͱ��"},
			{"modelsBrand","Ʒ��"},
			{"modelsSeries","ϵ��"},
			{"carModel","�����ͺ�"},
			{"carModelCode","�����ͺŴ���"},
			{"bodyType","��������"},
			{"manufacturers","��������"},
			{"salesStartTime","����/������ʼʱ��"},
			{"engineSize","����������"},										
			{"color","��ɫ"},
			{"price","����������"},
			{"inputOrg","�Ǽǻ���"},
			{"inputTime","�Ǽ�ʱ��"},
			{"inputUser","�Ǽ���"},
			{"updateOrg","���»���"},
			{"updateTime","����ʱ��"},
			{"updateUser","������"}
		   }; 

	String sSql ="select modelsID,modelsBrand,modelsSeries,carModel,carModelCode,bodyType,manufacturers,salesStartTime,"
			     +"engineSize,color,price,inputOrg,inputTime,inputUser,updateOrg,updateTime,updateUser from car_model_info ";
		
	 ASDataObject doTemp = null;
	 doTemp = new ASDataObject(sSql);//����ģ�ͣ�2013-5-9
	 doTemp.setHeader(sHeaders);	
	 doTemp.multiSelectionEnabled=true;
	 doTemp.setKey("modelsID", true);
	 doTemp.setHTMLStyle("modelsID", "style={width:50px}");
	 doTemp.setHTMLStyle("modelsBrand,modelsSeries,carModel,carModelCode", "style={width:100px}");
	 doTemp.setHTMLStyle("bodyType,manufacturers,salesStartTime,engineSize,color", "style={width:100px}");
	 doTemp.setColumnAttribute("modelsID,modelsBrand","IsFilter","1");
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
			{"true","","Button","ȷ��","ȷ��","doCreation()",sResourcesPath},
			{"true","","Button","ȡ��","ȡ��","doCancel()",sResourcesPath}	
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
	function doCreation() {
		
		saveRecord("doReturn()");
		
	}
	function saveRecord(sPostEvents)
	{		
		var sModelsID = getItemValueArray(0,"modelsID");	
		var temp="";//��¼���ô���
		var flag=true;
		for(var i=0;i<sModelsID.length;i++){
			var count= RunMethod("Unique","uniques","businessType_Car,count(1),carID='"+sModelsID[i]+"' and busTypeID=<%=sTypeNo%>");
			if(count>="1.0"){
				 temp=temp+sModelsID[i]+",";
				 flag=false;
			 }
		}
		if(flag&&sModelsID!=""){
			for(var i=0;i<sModelsID.length;i++){
				 RunMethod("BusinessTypeRelative","InsertBusRelative","businessType_Car,busTypeCarID,busTypeID,carID,"+getSerialNo("businessType_Car", "busTypeCarID", " ")+",<%=sTypeNo%>,"+sModelsID[i]);
			}
			alert("����ɹ�������");
			self.close();
			top.close();
		}else if(sModelsID!=""){
			alert("��ѡ��������Ѵ��ڼ�¼��������ѡ��лл��");
		}else{
			alert("��û��ѡ���¼�����ܵ��룡��ѡ��");
		}	
	}
	
	function doReturn(){
		top.close();
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

