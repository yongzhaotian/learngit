<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
		/*
		Author:   --fbkang 
		Tester:
		Content:    --��Ʒ��������
			δ�õ��������ֶ���ʱ���أ������Ҫ��չʾ������
		Input Param:
        	TypeNo��    --���ͱ��
 		Output param:
		                
		History Log: 
            
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "������Ʒ��������"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info02;Describe=�����������ȡ����;]~*/%>
<%
	//��Ʒ����
	String sProductType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ProductType"));
	String sSubProductType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("SubProductType"));
	if(null == sProductType) sProductType = "";
	if(null == sSubProductType) sSubProductType = "";
    
%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%	
	ASDataObject doTemp = new ASDataObject("BusinessTypeInfo",Sqlca);
	
	//add �ֽ������
	doTemp.setReadOnly("productType",true);
	if("020".equals(sProductType)){ 
		doTemp.setVisible("productCategoryID",false);
		doTemp.setRequired("productCategoryID",false);
	}
	//end
	
	if( "7".equals(sSubProductType) ){	//ѧ�����Ѵ���ʾ��Ʒ�����ͣ� add by dahl 
		doTemp.setVisible("SubProductType",true);
		doTemp.setVisible("ProductType",false);
	}
	
	doTemp.appendHTMLStyle("TypeNo"," onBlur=\"javascript:parent.checkTypeNo()\" ");
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д

	//��һ��������"BeforeInsert","AfterInsert","BeforeDelete","AfterDelete","BeforeUpdate","AfterUpdate"
	dwTemp.setEvent("AfterInsert","!ProductManage.CreateProductVersion(#TypeNo,V1.0,"+CurUser.getUserID()+")+!ProductManage.StartNewVersion(#TypeNo,V1.0,1)");//

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
			{"true","","Button","����","����","saveRecord()",sResourcesPath},
			{"true","","Button","����","����","saveRecordAndBack()",sResourcesPath}
		    };
	%> 
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
	
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">
    var sCurTypeNo=""; //��¼��ǰ��ѡ���еĴ����
    var bIsInsert = false; //���DW�Ƿ��ڡ�����״̬��

	//---------------------���尴ť�¼�------------------------------------
	/*~[Describe=����;InputParam=�����¼�;OutPutParam=��;]~*/
	function saveRecord()
	{
		var sTypeNo =getItemValue(0,getRow(),"TypeNo");
		var sUnique = RunMethod("Unique","uniques","business_type,count(1),typeNo='"+sTypeNo+"'");
		var sFlag=checkTypeNo(sTypeNo);
		if(!sFlag) return;
		if(bIsInsert && sUnique=="1.0"){
			alert("�ò�Ʒ�����Ѿ���ռ��,�������µĲ�Ʒ����");
			return;
		}
		bIsInsert = false;
	    as_save("myiframe0");
	}

    /*~[Describe=����;InputParam=�����¼�;OutPutParam=��;]~*/
	function saveRecordAndBack()
	{
		OpenPage("/BusinessManage/BusinessType/BusinessTypeList.jsp","_self","");

	}
     
    function checkTypeNo(sTypeNo){
    	var sTypeNo =getItemValue(0,getRow(),"TypeNo");
    	 var strExp=/^[A-Za-z0-9]+$/;
		 if(strExp.test(sTypeNo)){
		    return true;
		}else{
			alert("��Ʒ������������ֻ���ĸ��");
		    return false;
		}
    }
	/*~[Describe=������ѡ��ѡ����Ʒ����;InputParam=��;OutPutParam=��;]~*/
	function selectProductCategoryMulti() {
		var sRetVal = setObjectValue("SelectProductCategoryMulti", "", "", 0, 0, "");
		if (typeof(sRetVal)=="undefined" || sRetVal=="_CLEAR_" || sRetVal.length==0) {
			alert("��ѡ����Ʒ���룡");
			return;
		}
		var sTypeArry = sRetVal.substring(0, sRetVal.length-1).split("@");
		var sCTypeIds = "";
		var SCTypeNames = "";
		for (var i=0;i<sTypeArry.length;i=i+2) {
			sCTypeIds += sTypeArry[i] + ",";
			SCTypeNames += sTypeArry[i+1] + ",";
		}
		setItemValue(0, 0, "productCategory", sCTypeIds.substring(0, sCTypeIds.length-1));  //��Ʒ����ID
		setItemValue(0, 0, "productCategoryID", SCTypeNames.substring(0, SCTypeNames.length-1));//��Ʒ��������
		return;
	}
	
   
	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">
	
	function initRow(){
		if (getRowCount(0)==0) //���û���ҵ���Ӧ��¼��������һ�����������ֶ�Ĭ��ֵ
		{
			as_add("myiframe0");//������¼
			setItemValue(0,0,"productType","<%=sProductType%>");//add �ֽ������
			setItemValue(0,0,"CreditAttribute", "0002");
			setItemValue(0,0,"Attribute3", "1");
			//update �ֽ������
			if("020" == "<%=sProductType%>")
			{
				setItemValue(0,0,"ContractDetailNo", "ContractInfo1212");
			}else
			{
				setItemValue(0,0,"ContractDetailNo", "ContractInfo1210");
			}
			//end
			//ccs-733 ѧ�����Ѵ�  add by dahl
			if( "7" == "<%=sSubProductType%>"){
				setItemValue(0,0,"SubProductType", "7");
			}
			//end by dahl
			setItemValue(0,0,"SortNo", getSerialNo("business_type", "SortNo", " "));
			bIsInsert = true;
		}
	}
	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List07;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script type="text/javascript">	
	AsOne.AsInit();
	init();
	var bCheckBeforeUnload = false;
	my_load(2,0,'myiframe0');
	initRow();
	
</script>	
<%/*~END~*/%>


<%@ include file="/IncludeEnd.jsp"%>
