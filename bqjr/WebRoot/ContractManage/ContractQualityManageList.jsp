<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%@page import="com.amarsoft.dict.als.cache.CodeCache"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author: daihuafeng 2015-9-30
		Tester:
		Describe: ��ͬ��������
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "��ͬ��������"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info02;Describe=�����������ȡ����;]~*/%>

<%

	//���ҳ�����
	//String sProductID  = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("productID"));	
    //if(sProductID==null) sProductID="";
   
%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/%>
	<%
		
	
	 ASDataObject doTemp = null;
	 String sTempletNo = "ContractQualityManageList";
	 doTemp = new ASDataObject(sTempletNo,Sqlca);
	 //where����
	/*  doTemp.WhereClause += " AND Check_Contract.CheckDocStatus in ('3','5') "
	 	+ " and BUSINESS_CONTRACT.ContractStatus in ('020','050','080') "
		+ " and BUSINESS_CONTRACT.PigeonholeDate is null "
		+ " and BUSINESS_CONTRACT.suretype = 'APP' "; */
	 doTemp.WhereClause += " and BUSINESS_CONTRACT.ContractStatus in ('050','160') "
		+ " and BUSINESS_CONTRACT.PigeonholeDate is null "
		+ " and (BUSINESS_CONTRACT.suretype = 'APP' or BUSINESS_CONTRACT.suretype = 'FC')";
	 
	doTemp.setFilter(Sqlca, "0010", "SerialNo", "Operators=EqualsString,BeginsWith;");
	doTemp.setFilter(Sqlca, "0020", "CustomerName", "Operators=EqualsString,BeginsWith;");
	doTemp.setFilter(Sqlca, "0030", "CheckBeginDate", "Operators=EqualsString,BeginsWith;");
	doTemp.setFilter(Sqlca, "0040", "GetTaskUserName1", "Operators=EqualsString,BeginsWith;");
	doTemp.setFilter(Sqlca, "0050", "CheckAgainBeginDate", "Operators=EqualsString,BeginsWith;");
	doTemp.setFilter(Sqlca, "0060", "GetTaskUserName2", "Operators=EqualsString,BeginsWith;");
	doTemp.parseFilterData(request,iPostChange);
	
	//��Ӳ�ѯ���ƣ��Է���ѯ�����̫��
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
		
		if(doTemp.Filters.get(k).sFilterInputs[0][1] != null  && "BeginsWith".equals(doTemp.Filters.get(k).sOperator)){
			if((("0020").equals(doTemp.getFilter(k).sFilterID) || ("0040").equals(doTemp.getFilter(k).sFilterID) || ("0060").equals(doTemp.getFilter(k).sFilterID)) 
					&& doTemp.Filters.get(k).sFilterInputs[0][1].trim().length() < 2){
				%>
				<script type="text/javascript">
					alert("������ַ����ȱ���Ҫ���ڵ���2λ!");
				</script>
				<%
				doTemp.WhereClause+=" and 1=2";
				break;
			}else if(("0010").equals(doTemp.getFilter(k).sFilterID) && doTemp.Filters.get(k).sFilterInputs[0][1].trim().length() < 8){
				%>
				<script type="text/javascript">
					alert("����ĺ�ͬ�ų��ȱ���Ҫ���ڵ���8λ!");
				</script>
				<%
				doTemp.WhereClause+=" and 1=2";
				break; 
			}
			
		} else if(k==doTemp.Filters.size()-1){
		
			if(!doTemp.haveReceivedFilterCriteria()) doTemp.WhereClause+=" and 1=2";
		
		}
	}
	
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	 
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //����Ϊֻ��
	dwTemp.setPageSize(20);
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");//�����������ݣ�2013-5-9
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	
	//���õ��Ӻ�ͬ��ַ�豣�浽�����ļ���ʹ��
	String sAPPUrl4pdf = CodeCache.getItem("PrintAppUrl","0010").getItemAttribute();
	String sAPPUrl4Sxhpdf = CodeCache.getItem("PrintAppUrl","0014").getItemAttribute();
	System.out.println("sAPPUrl4pdf====================="+sAPPUrl4pdf);

	//�䳲���Ӻ�ͬ�Լ����Ļ����Ӻ�ͬ��ַ
	String sFCUrl4pdf = CodeCache.getItem("PrintAppUrl","0015").getItemAttribute();
	String sFCUrl4Sxhpdf = CodeCache.getItem("PrintAppUrl","0016").getItemAttribute();


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
			{"true","","Button","���Ӻ�ͬ","���Ӻ�ͬ","createPDF()",sResourcesPath},
			{"true","","Button","���Ļ����Ӻ�ͬ","���Ļ����Ӻ�ͬ","createSxhPDF()",sResourcesPath},
			{"true","","Button","Ӱ���ͬ����","Ӱ���ͬ����","imageManage()",sResourcesPath},
			{"true","","Button","�����ļ�����","�����ļ�����","checkImage()",sResourcesPath},
		};
	
	%>
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">

	//---------------------���尴ť�¼�------------------------------------
	 function createPDF(){
        var sObjectNo = getItemValue(0,getRow(),"SerialNo");
	    //alert(sObjectNo);
	    var ssuretype = getItemValue(0,getRow(),"SureType");
	    //alert(ssuretype);
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert("��ѡ��һ����¼��");
			return;
		}
	    if (ssuretype != 'APP' && ssuretype != 'FC') {
	        alert("�ú�ͬ�ǵ��Ӻ�ͬ!");
	        return;
	    }
	    //ͨ����serverlet ��ҳ��
	    var CurOpenStyle = "width=720,height=540,top=20,left=20,toolbar=no,scrollbars=yes,resizable=yes,status=yes,menubar=no,";  
	    if(ssuretype == 'APP'){
		    window.open("<%=sAPPUrl4pdf%>"+sObjectNo,"_blank",CurOpenStyle);
	    }else if(ssuretype == 'FC'){
	    	window.open("<%=sFCUrl4pdf%>"+sObjectNo,"_blank",CurOpenStyle);
	    }
	}
	
	 function createSxhPDF(){
        var sObjectNo = getItemValue(0,getRow(),"SerialNo");
	    var ssuretype = getItemValue(0,getRow(),"SureType");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert("��ѡ��һ����¼��");
			return;
		}
	    if (ssuretype.indexOf("PC", 0) >= 0) {
	        alert("�ú�ͬ�ǵ��Ӻ�ͬ!");
	        return;
	    }
	    var bugpaypkgind = RunMethod("���÷���", "GetColValue", "business_contract,bugpaypkgind,serialno='"+sObjectNo+"'");
		if(typeof(bugpaypkgind)=="undefined" || bugpaypkgind.length==0 || bugpaypkgind == "0"){
	        alert("�ú�ͬû�й������Ļ������!");
	        return;
		}
	    //ͨ����serverlet ��ҳ��
	    var CurOpenStyle = "width=720,height=540,top=20,left=20,toolbar=no,scrollbars=yes,resizable=yes,status=yes,menubar=no,";  
	    if(ssuretype == 'APP'){
	   		window.open("<%=sAPPUrl4Sxhpdf%>"+sObjectNo,"_blank",CurOpenStyle);
	    }else if(ssuretype == 'FC'){
	    	window.open("<%=sFCUrl4Sxhpdf%>"+sObjectNo,"_blank",CurOpenStyle);
	    }
	}
	
	/*~[Describe=Ӱ�����;InputParam=��;OutPutParam=��;]~*/
	function imageManage(){
		var sObjectNo = getItemValue(0,getRow(),"SerialNo"); //��ͬ��ˮ��
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert("��ѡ��һ����¼��");
			return;
		}
		var param = "ObjectType=Business&ObjectNo="+sObjectNo;
		AsControl.OpenView("/ContractManage/ContractQualityImageCheckList.jsp",param,"_blank","");
	}
	
	//�����������
	function checkImage(){
		var sObjectNo = getItemValue(0,getRow(),"SerialNo"); //��ͬ��ˮ��
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert("��ѡ��һ����¼��");
			return;
		}
		//����״̬Ϊ�Ѽ��
		var param = "ObjectType=BusinessLoan&ObjectNo="+sObjectNo;
		AsControl.OpenView("/ContractManage/ContractQualityLoanCheckList.jsp",param,"_blank","");
//	     parent.reloadSelf();
	}
	
	/*~[Describe=������¼;InputParam=��;OutPutParam=��;]~*/
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

