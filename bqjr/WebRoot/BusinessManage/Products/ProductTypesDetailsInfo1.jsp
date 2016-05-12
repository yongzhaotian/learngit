<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/%>
	<%
	/*
		Author: lwang 20140220 
		Tester:
		Describe:��������ҳ��
		Input Param:
			SerialNo:
		Output Param:

		HistoryLog:
			
	 */
	%>
<%/*~END~*/%>



<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "��Ʒ���� "; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>



<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info02;Describe=�����������ȡ����;]~*/%>
<%

	//���ҳ�����
	String sProductID    = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("productID"));	
	if(sProductID==null){
		sProductID=" ";
	}
	
	//��Ʒ����
	String sProductType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ProductType"));
	if(null == sProductType) sProductType = "";
	//��Ʒ������
	String sSubProductType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("SubProductType"));
	if(null == sSubProductType) sSubProductType = "";
%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/%>
	<%
	//ͨ����ʾģ�����ASDataObject����doTemp
	String sTempletNo = "ProductTypesDetailsInfo1";

	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
	//doTemp.WhereClause = " where attribute2='"+sProductID+"'";
	
	 doTemp.setColumnAttribute("typeNo,typeName","IsFilter","1");
	 doTemp.generateFilters(Sqlca);
	 doTemp.parseFilterData(request,iPostChange);
	 CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sProductID);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info04;Describe=���尴ť;]~*/%>
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
        {"true","","Button","ɾ��","ɾ����ѡ�еļ�¼","deleteRecord()",sResourcesPath}, 
		{"true","","Button","����","�����¼","myDetail()",sResourcesPath},	
		};
	
	%> 
<%/*~END~*/%>




<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=Info05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/Info05.jsp"%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info06;Describe=���尴ť�¼�;]~*/%>
	<script type="text/javascript">
	/*~[Describe=������¼;InputParam=��;OutPutParam=��;]~*/
	function newRecord(){
		sCompID = "BusinessTypeList";
		sCompURL = "/BusinessManage/BusinessType/BusinessTypeList.jsp";
	    popComp(sCompID,sCompURL,"productID=<%=sProductID%>&ProductType=<%=sProductType%>&SubProductType=<%=sSubProductType%>","dialogWidth=760px;dialogHeight=490px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
	    reloadSelf();
	}
	
	function deleteRecord(){
		var sTypeNo =getItemValue(0,getRow(),"typeNo");//��ȡɾ����¼�ĵ�Ԫֵ
		if (typeof(sTypeNo)=="undefined" || sTypeNo.length==0){
			alert("������ѡ��һ����¼��");
			return;
		}
		
		if(confirm("�������ɾ������Ϣ��")){
			RunMethod("DeleteNumber","GetDeleteNumber","product_businessType,bustypeid,"+sTypeNo); 
			as_save("myiframe0");  //�������ɾ������Ҫ���ô����
			 reloadSelf();
		}
	}
	
	function myDetail(){
		var sTypeNo =getItemValue(0,getRow(),"typeNo");
		if(typeof(sTypeNo)=="undefined" || sTypeNo.length==0){
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
		}else{
			AsControl.OpenView("/BusinessManage/BusinessType/BusinessTypeDetailsInfo.jsp","temp=1&typeNo="+sTypeNo,"_self");		
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