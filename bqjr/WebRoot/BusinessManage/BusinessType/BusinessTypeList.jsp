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
	String PG_TITLE = "��������"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info02;Describe=�����������ȡ����;]~*/%>
<%

	
	//���ҳ�����
	String sProductID  = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("productID"));	
    if(sProductID==null) sProductID="";
    //��Ʒ����
    String sProductType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ProductType"));
    if(null == sProductType) sProductType = "";
 	 //��Ʒ������
	String sSubProductType  = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("SubProductType"));	
    if(null == sSubProductType) sSubProductType = "";
    
   //add by clhuang 2015/06/17 CCS-839 ��Ʒ����ɾ����ťȱ�� 
     String sBusinessType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("businesstype"));
    if(null == sBusinessType) sBusinessType = "";
   //end by clhuang
   
/*     String sNo = Sqlca.getString(new SqlObject("select count(1) from business_contract  where contractstatus not in('010','020','030','040','110') and businesstype=:businesstype ").setParameter("businesstype", sBusinessType));

    if(sNo == null) sNo = "";  */
    
%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/%>
	<%
		
	
	 ASDataObject doTemp = null;
	 String sTempletNo = "BusinessTypeList";
	 doTemp = new ASDataObject(sTempletNo,Sqlca);//����ģ�ͣ�2013-5-9
	 if(!sProductID.equals("")){
		 doTemp.multiSelectionEnabled=true;
	 }
	 doTemp.setColumnAttribute("TypeNo,typename,productType","IsFilter","1");
	 doTemp.generateFilters(Sqlca);
	 doTemp.parseFilterData(request,iPostChange);
	 CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	 
	 
	
	 //add �ֽ������
	 if("020".equals(sProductType) || "030".equals(sProductType)){
		 doTemp.WhereClause += " and ProductType = '"+sProductType+"' ";
	 }
	 
	// add by dahl ccs-733
	 if( "030".equals(sProductType) && "".equals(sSubProductType) ){	//���Ѵ���Ʒ������ѧ�����Ѵ���Ʒ	add by dahl 
		 doTemp.WhereClause += " and (SubProductType is null or SubProductType <> '7') ";
	 }else if( "030".equals(sProductType) && "7".equals(sSubProductType) ){	//ѧ�����Ѵ���Ʒ	add by dahl 
		 doTemp.WhereClause += " and SubProductType = '"+sSubProductType+"' ";
	 }
	//end add by dahl
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //����Ϊֻ��
	
	dwTemp.setEvent("BeforeDelete","!ProductManage.DeleteVersionInfo(#TypeNo,V1.0)");//ɾ���汾
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
		{"true","","Button","ɾ��","ɾ����ѡ�еļ�¼","deleteRecord()",sResourcesPath},
		{"true","","Button","���ػ���","��Ʒ���������ϵͳ����������","reloadCacheRole()",sResourcesPath},
		};
	if(!sProductID.equals("")){
		sButtons[0][3]="ȷ��";
		sButtons[0][4]="ȷ��";
		sButtons[0][5]="determine()";
		sButtons[1][3]="ȡ��";
		sButtons[1][4]="ȡ��";
		sButtons[1][5]="doCancel()";
		sButtons[2][0]="false";
	}
	
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
		OpenPage("/BusinessManage/BusinessType/BusinessTypeInfo.jsp?ProductType=<%=sProductType%>&SubProductType=<%=sSubProductType%>","_self","");//update �ֽ���������Ӳ�Ʒ���Ͳ�����
	}
	
	function deleteRecord(){
		var sTypeNo =getItemValue(0,getRow(),"TypeNo");//��ȡɾ����¼�ĵ�Ԫֵ
		if (typeof(sTypeNo)=="undefined" || sTypeNo.length==0){
			alert("������ѡ��һ����¼��");
			return;
		}
		   //add by clhuang 2015/06/17 CCS-839 ��Ʒ����ɾ����ťȱ�� 
		var sNo = RunMethod("BusinessManage", "SelectBusinessType", sTypeNo);
		if(sNo != "0.0"){
		   return alert("�ò�Ʒ������Ч��ͬ��������ɾ��");
		}
		//end by clhuang
		if(confirm("�������ɾ������Ϣ��")){
			as_del("myiframe0");
			as_save("myiframe0");  //�������ɾ������Ҫ���ô����
			 reloadSelf();
		}
	}
	function myDetail(){
		sTypeNo=getItemValue(0,getRow(),"TypeNo");	
		if(typeof(sTypeNo)=="undefined" || sTypeNo.length==0){
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
		}else{
			AsControl.OpenView("/BusinessManage/BusinessType/BusinessTypeDetail.jsp","typeNo="+sTypeNo+"&ProductType=<%=sProductType%>&SubProductType=<%=sSubProductType%>","_blank");//update �ֽ������		
		}
		reloadSelf();
	}
	
	function determine(){
		var sTypeNo = getItemValueArray(0,"TypeNo");
		var temp="";//��¼���ô���
		var flag=true;
		for(var i=0;i<sTypeNo.length;i++){
			var count= RunMethod("Unique","uniques","product_businessType,count(1),busTypeID='"+sTypeNo[i]);
			if(count>="1.0"){
				 temp=temp+sTypeNo[i]+",";
				 flag=false;
			 }
		}
		if(flag&&sTypeNo!=""){
			for(var i=0;i<sTypeNo.length;i++){
				 RunMethod("BusinessTypeRelative","InsertBusRelative","product_businessType,productBusTypeID,busTypeID,productSeriesid,"+getSerialNo("product_businessType", "productBusTypeID", " ")+","+sTypeNo[i]+",<%=sProductID%>");
			}
			alert("����ɹ�������");
			top.close();
		}else if(sTypeNo!=""){
			alert("��ѡ���в�Ʒ�ڸò�Ʒϵ�л�������Ʒϵ�����Ѵ��ڣ�������ѡ��лл��");
		}else{
			alert("��û��ѡ���¼�����ܵ��룡��ѡ��");
		}		
		
	}
	function doCancel()
	{		
		top.returnValue = "_CANCEL_";
		top.close();
	}
	
	<%/*~[Describe=ˢ�»���;]~*/%>
	function reloadCacheRole(){
		//AsDebug.reloadCacheAll();
		var sReturn = RunJavaMethod("com.amarsoft.app.util.ReloadCacheConfigAction","reloadCacheAll","");
		if(sReturn=="SUCCESS") alert("���ز�������ɹ���");
		else alert("���ز�������ʧ�ܣ�");
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

