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

    System.out.println("----------------"+sPackNo);

    if(sPackNo==null) sPackNo="";
%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/%>
	<%
	String sHeaders[][] = { 							
			{"SerialNo","��ͬ���"},
			{"Stores","�ŵ��"},
			{"SalesExecutive","���۴���ID"},
			{"SignedDate","ǩ������"},
			{"LandMarkStatus","�ر�"},
			{"QualityGrade","��ͬ�����ȼ�"}
		   }; 
     //��ͬ״̬�ǣ���ǩ����ע��
	 String sSql = "select bc.SerialNo as SerialNo,bc.stores as Stores,bc.salesexecutive as SalesExecutive,bc.SignedDate as SignedDate,getItemName('LandMarkStatus',bc.landmarkstatus) as LandMarkStatus,getItemName('QualityGrade',bc.QualityGrade) as QualityGrade from business_contract bc where bc.landmarkstatus in ('1','6') and bc.contractstatus in ('020','050') ";
		
	 ASDataObject doTemp = null;
	 doTemp = new ASDataObject(sSql);
	 doTemp.setHeader(sHeaders);	
	 doTemp.multiSelectionEnabled=true;
	 doTemp.setKey("SerialNo", true);
	 
	 //doTemp.setHTMLStyle("modelsID", "style={width:50px}");
	 //doTemp.setHTMLStyle("modelsBrand,modelsSeries,carModel,carModelCode", "style={width:100px}");
	 //doTemp.setHTMLStyle("bodyType,manufacturers,salesStartTime,engineSize,color", "style={width:100px}");
// 	 doTemp.setColumnAttribute("SerialNo,Stores,LandMarkStatus","IsFilter","1");
	 doTemp.setFilter(Sqlca, "0020", "SerialNo", "Operators=EqualsString,BeginsWith;");
	 doTemp.setFilter(Sqlca, "0030", "Stores", "Operators=EqualsString,BeginsWith;");
	 doTemp.setFilter(Sqlca, "0040", "SalesExecutive", "Operators=EqualsString");
// 	 doTemp.setFilter(Sqlca, "0050", "LandMarkStatus", "Operators=EqualsString,BeginsWith;");
	 doTemp.generateFilters(Sqlca);
	 doTemp.parseFilterData(request,iPostChange);
// 	 if(CurUser.hasRole("1006")){
// 		 doTemp.WhereClause += " and bc.salesexecutive ='"+ CurUser.getUserID() +"'";
// 	 }
	boolean flag = true;
	for(int k=0;k<doTemp.Filters.size();k++){
		if(doTemp.Filters.get(k).sFilterInputs[0][1] != null && (("0020").equals(doTemp.getFilter(k).sFilterID)||("0030").equals(doTemp.getFilter(k).sFilterID)||("0030").equals(doTemp.getFilter(k).sFilterID)||("0040").equals(doTemp.getFilter(k).sFilterID))){
			flag = false;
			break;
		}
	}
	if(doTemp.haveReceivedFilterCriteria()&& flag)
	{
		%>
		<script type="text/javascript">
			alert("��ͬ���,�ŵ��,���۴���ID��������һ�");
		</script>
		<%
		doTemp.WhereClause+=" and 1=2";
	}	
	 for(int k=0;k<doTemp.Filters.size();k++){
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
			if(("0020").equals(doTemp.getFilter(k).sFilterID) && doTemp.Filters.get(k).sFilterInputs[0][1] != null && doTemp.Filters.get(k).sFilterInputs[0][1].trim().length() < 8){
				%>
				<script type="text/javascript">
					alert("����ĺ�ͬ�ų��ȱ���Ҫ���ڵ���8λ!");
				</script>
				<%
				doTemp.WhereClause+=" and 1=2";
				break; 
			}
			if(("0030").equals(doTemp.getFilter(k).sFilterID) &&  doTemp.Filters.get(k).sFilterInputs[0][1] != null && doTemp.Filters.get(k).sFilterInputs[0][1].trim().length() < 6){
				%>
				<script type="text/javascript">
					alert("������ŵ�ų��ȱ���Ҫ���ڵ���6λ!");
				</script>
				<%
				doTemp.WhereClause+=" and 1=2";
				break; 
			}
	 }
	  if(!doTemp.haveReceivedFilterCriteria()) doTemp.WhereClause+=" and 1=2";
	 
	 CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //����Ϊֻ��
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
		var flag=true;
		var isFlag=true;
		
		for(var i=0;i<sArtificialNo.length;i++){
			var count= RunMethod("Unique","uniques","Shop_Contract,count(1),ContractNo='"+sArtificialNo[i]+"' and PackNo='"+<%=sPackNo%>+"' and packtype='01' ");

			if(count >= "1.0"){
				 temp=temp+sArtificialNo[i]+",";
				 flag=false;
			 }
			//�жϺ�ͬ�Ƿ���������������
			var sum= RunMethod("Unique","uniques","Shop_Contract,count(1),ContractNo='"+sArtificialNo[i]+"' and packtype='01' ");

			if(sum >= "1.0"){
				 temp=temp+sArtificialNo[i]+",";
				 isFlag=false;
			 }
		}
		
		if(isFlag==true && flag==true && sArtificialNo != ""){
			for(var i=0;i<sArtificialNo.length;i++){
				 RunMethod("BusinessManage","addPackRelative",getSerialNo("Shop_Contract","SerialNo"," ")+",<%=sPackNo%>,"+sArtificialNo[i]+","+"01");
			}
			alert("����ɹ�������");
			top.close();
		}else if(flag==false && sArtificialNo != ""){
			alert("��ѡ���еĺ�ͬ���Ѵ��ڼ�¼��������ѡ��лл��");
		}else if (isFlag == false && sArtificialNo != ""){
			alert("��ѡ���еĺ�ͬ���ѱ������������������飡");
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
	showFilterArea();
	init();
	my_load(2,0,'myiframe0');
</script>
<%/*~END~*/%>

<%@	include file="/IncludeEnd.jsp"%>