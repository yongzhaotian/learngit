<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author: hxli 2005-8-1
		Tester:
		Describe: ��Ʒϵ��
		
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
	String PG_TITLE = "��Ʒϵ��"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info02;Describe=�����������ȡ����;]~*/%>
<%
    //��Ʒ����
    String sProductType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ProductType"));
	if(null == sProductType) sProductType = "";
	//��Ʒ������
	String sSubProductType  = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("SubProductType"));	
    if(null == sSubProductType) sSubProductType = "";
%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/%>
	<%
		
	
	 ASDataObject doTemp = null;
	 String sTempletNo = "ProductTypes";
	 doTemp = new ASDataObject(sTempletNo,Sqlca);//����ģ�ͣ�2013-5-9
	 
	 //add by ybpan at 20150411 CCS-583  ----��������ԤԼ�ֽ�������ҵ��Ա�󶨲�Ʒ/���۴������ܳ���
	 //�������Ͳ�Ϊ�գ���List�б���ʾʱ��ʾ��ʾ�����ĳ�������͵������б�
	 if(!sSubProductType.equals("")){
		 doTemp.WhereClause +=" and SubProductType = '"+sSubProductType+"'";
	 }else if( "030".equals(sProductType) && "".equals(sSubProductType) ){//���Ѵ���Ʒ������ѧ�����Ѵ���Ʒ	add by dahl 
		doTemp.WhereClause += " and (SubProductType is null or SubProductType <> '7') ";
	 }
	//end  by ybpan CCS-583
	 doTemp.setColumnAttribute("productName","IsFilter","1");
	 doTemp.generateFilters(Sqlca);
	 doTemp.parseFilterData(request,iPostChange);
	 CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //����Ϊֻ��
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sProductType);//�����������ݣ�2013-5-9
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
        {"true","","Button","ɾ��","ɾ����ѡ�еļ�¼","deleteRecord()",sResourcesPath}, 		
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
		OpenPage("/BusinessManage/Products/ProductTypesInfo.jsp?ProductType=<%=sProductType%>","_self","");//update �ֽ������
	}
	
	function deleteRecord(){
		var sProductID =getItemValue(0,getRow(),"productID");//��ȡɾ����¼�ĵ�Ԫֵ
		if (typeof(sProductID)=="undefined" || sProductID.length==0){
			alert("������ѡ��һ����¼��");
			return;
		}
		
		if(confirm("�������ɾ������Ϣ��")){
			as_del("myiframe0");
			as_save("myiframe0");  //�������ɾ������Ҫ���ô����
			RunMethod("DeleteNumber","GetDeleteNumber","product_businessType,productseriesid,"+sProductID);
			 reloadSelf();
		}
	}
	
	function myDetail(){
		var sProductID =getItemValue(0,getRow(),"productID");
		if(typeof(sProductID)=="undefined" || sProductID.length==0){
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
		}else{
			AsControl.OpenView("/BusinessManage/Products/ProductTypesDetail.jsp","productID="+sProductID+"&ProductType=<%=sProductType%>&SubProductType=<%=sSubProductType%>","_blank");//update �ֽ������
			
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

