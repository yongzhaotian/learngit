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
		ObjectType:��������
		ObjectNo��������
		
		Output Param:
			
		HistoryLog:
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "����������ͬ"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info02;Describe=�����������ȡ����;]~*/%>
<%
	//���ҳ�����
    String sPackNo    = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("PackNo"));
    String sCreditID  = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CreditID"));
    
    System.out.println("--------�����˱��--------"+sCreditID);

    if(sPackNo==null) sPackNo="";
    if(sCreditID==null) sCreditID="";
%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/%>
	<%
	String sHeaders[][] = { 							
			{"SerialNo","��ͬ���"},
			{"CertID","���֤����"},
			{"CustomerName","�ͻ�����"},
			{"Stores","�ŵ��"},
			{"ContractStatus","��ͬ״̬"},
			{"ContractEffectiveDate","��ͬ��Ч��"},
			{"SalesExecutive","���۴���"},
			{"LandMarkStatus","�ر�״̬"},
			{"QualityGrade","�����ȼ�"}
		   }; 
     //�ر�״̬�ǣ��ܲ�5������Ҫ�����������ˡ�������������ʶ��packstatus�����ܲ�ѯ������
	 String sSql = "select bc.serialno as SerialNo,bc.CertID as CertID,bc.CustomerName as CustomerName,bc.stores as Stores,getItemName('ContractStatus',bc.ContractStatus) as ContractStatus,bc.ContractEffectiveDate as ContractEffectiveDate,bc.salesexecutive as SalesExecutive,getItemName('LandMarkStatus',bc.landmarkstatus) as LandMarkStatus,getItemName('QualityGrade',bc.QualityGrade) as QualityGrade from business_contract bc,Service_Providers sp where bc.creditid=sp.serialno and bc.landmarkstatus='5' and bc.CreditAttribute ='0002' and bc.ContractStatus in('020','080','050') and bc.packstatus is null and bc.creditid='"+sCreditID+"' ";
		
	 ASDataObject doTemp = null;
	 doTemp = new ASDataObject(sSql);
	 doTemp.setHeader(sHeaders);	
	 doTemp.multiSelectionEnabled=true;//��ʾ��ѡ��
	 doTemp.setKey("SerialNo", true);
	 
	 //doTemp.setHTMLStyle("modelsID", "style={width:50px}");
	 //doTemp.setHTMLStyle("modelsBrand,modelsSeries,carModel,carModelCode", "style={width:100px}");
	 //doTemp.setHTMLStyle("bodyType,manufacturers,salesStartTime,engineSize,color", "style={width:100px}");
	 doTemp.setColumnAttribute("SerialNo,Stores,LandMarkStatus","IsFilter","1");
	 
	 doTemp.generateFilters(Sqlca);
	 doTemp.parseFilterData(request,iPostChange);
	 CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //����Ϊֻ��
	dwTemp.setPageSize(10);
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
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
		var sArtificialNo = getItemValueArray(0,"SerialNo");
		var temp="";
		var temps="";
		var flag=true;
		var isFlag=true;
		
		for(var i=0;i<sArtificialNo.length;i++){
			var count= RunMethod("Unique","uniques","Shop_Contract,count(1),ContractNo='"+sArtificialNo[i]+"' and PackNo='"+<%=sPackNo%>+"' and packtype='02' ");
			if(count >= "1.0"){
				 temp=temp+sArtificialNo[i]+",";
				 flag=false;
			 }
			//�жϺ�ͬ�Ƿ���������������
			var sum= RunMethod("Unique","uniques","Shop_Contract,count(1),ContractNo='"+sArtificialNo[i]+"' and packtype='02' ");

			if(sum >= "1.0"){
				 temps=temp+sArtificialNo[i]+",";
				 isFlag=false;
			 }
		}
		
		if(isFlag==true && flag==true && sArtificialNo != ""){
			for(var i=0;i<sArtificialNo.length;i++){
				 RunMethod("BusinessManage","addPackRelative",getSerialNo("Shop_Contract","SerialNo"," ")+",<%=sPackNo%>,"+sArtificialNo[i]+","+"02");
				 //���º�ͬ�а�������״̬��2
				 RunMethod("BusinessManage","UpdatePackStatus",sArtificialNo[i]+","+"2");
			}
			alert("����ɹ�������");
			top.close();
		}else if(flag==false && sArtificialNo != ""){
			alert("��ѡ���е�["+temp+"]��ͬ�Ѵ��ڼ�¼��������ѡ��");
		}else if (isFlag == false && sArtificialNo != ""){
			alert("��ѡ���е�["+temps+"]��ͬ�ѱ������������������飡");
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
    showFilterArea();
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>
<%/*~END~*/%>

<%@	include file="/IncludeEnd.jsp"%>