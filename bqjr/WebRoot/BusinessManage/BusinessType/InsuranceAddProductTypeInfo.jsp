<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "��Ʒ��������"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info02;Describe=�����������ȡ����;]~*/%>
<%
	//��Ʒ����
	String sInsuranceNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
    String sFlag =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("sFlag"));

	if(null == sInsuranceNo) sInsuranceNo = "";
	if(null == sFlag) sFlag = "";

	String sSerialNo = DBKeyHelp.getSerialNo("INSURANCECITY_INFO","SerialNo",Sqlca);

%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%	
	ASDataObject doTemp = new ASDataObject("InsuranceAddProductType",Sqlca);
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	if("addProduct".equals(sFlag)){
		doTemp.WhereClause += " and itemno not in (select distinct(subproducttype) from insurancecity_info where insuranceno ='"+sInsuranceNo+"' and subproducttype is not null)";
	}
	if("addCity".equals(sFlag)){
		doTemp.WhereClause += " and itemno in (select distinct(subproducttype) from insurancecity_info where insuranceno ='"+sInsuranceNo+"' and subproducttype is not null)";
	}
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
			{"true","","Button","�ύ����","�ύ����","doSubmitAddProduct()",sResourcesPath},
			{"true","","Button","����","���ز�Ʒ����","saveRecordAndBackProduct()",sResourcesPath},
			{"true","","Button","��Ӳ�Ʒ��������","��Ӳ�Ʒ��������","doAddCity()",sResourcesPath},
			{"true","","Button","����","���س�������","BackCity()",sResourcesPath}

		    };
    if("addProduct".equals(sFlag)){
	    sButtons[2][0]="false";
	    sButtons[3][0]="false";   
    }else if("addCity".equals(sFlag)){
	    sButtons[0][0]="false";
	    sButtons[1][0]="false";  
    }
	%> 
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
	
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">
	//---------------------���尴ť�¼�------------------------------------
	/*~[Describe=����;InputParam=�����¼�;OutPutParam=��;]~*/
	function doSubmitAddProduct(){
	    var	sItemNo=getItemValue(0,getRow(),"ItemNo");
		var sInsuranceNo = <%=sInsuranceNo%>;
		var sSerialNo = <%=sSerialNo%>;

		if(typeof(sItemNo)=="undefined" || sItemNo.length==0){
			alert("��ѡ��Ҫ��ӵĲ�Ʒ���ͣ�");
			return;
		}
		if(confirm("��ȷ��������")){
			RunMethod("InsertInsuranceProduct","DoInsert",sSerialNo+","+sInsuranceNo+","+sItemNo); 
			as_save("myiframe0"); 
		}
		saveRecordAndBackProduct();
	}
	function doAddCity(){
		var sItemNo = getItemValue(0,getRow(),"ItemNo");
		var sInsuranceNo = <%=sInsuranceNo%>;
		if(typeof(sItemNo)=="undefined" || sItemNo.length==0){
			alert("��ѡ��Ҫ��ӵĲ�Ʒ���ͣ�");
			return;
		}
		PopPage("/BusinessManage/BusinessType/AddInsuranceCity.jsp?insuranceNo="+sInsuranceNo+"&subproductType="+sItemNo,"","400px;dialogHeight=540px;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;");      
		self.close();
	}
    /*~[Describe=����;InputParam=�����¼�;OutPutParam=��;]~*/
	function saveRecordAndBackProduct()
	{
		OpenPage("/BusinessManage/BusinessType/InsuranceProductList.jsp","_self","");
	}   
	function BackCity()
	{
		self.close();
	}   
	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">
	

	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List07;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script type="text/javascript">	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	initRow();
	
</script>	
<%/*~END~*/%>


<%@ include file="/IncludeEnd.jsp"%>
