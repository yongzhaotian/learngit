<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   --fbkang
		Tester:
		Content: --��Ʒ�����б�
		Input Param:
                  
		Output param:
		       DoNo:--ģ�����
		       EditRight: --�༭Ȩ��
		                
		History Log: 
            
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "��Ʒ�����б�"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
	String sSql="";//--���sql���
	String sSortNo=""; //--������
	//���ҳ�����ҵ��Ʒ�ֱ��
	String sParentTypeNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ParentTypeNo"));
	if(sParentTypeNo == null) sParentTypeNo = "";
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%	
    ASDataObject doTemp = new ASDataObject("ProductTypeList",Sqlca);
    if("ENT".equals(sParentTypeNo)){//��˾ҵ��
    	doTemp.WhereClause+=" and (TypeNo like '1%' or TypeNo like '2%') and  TypeNo not like '111%'";
	}else {
		doTemp.WhereClause+=" and TypeNo like '"+sParentTypeNo+"%' ";
	}
    
    //���˲�ѯ
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));

	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	//����ҳ����ʾ������
	dwTemp.setPageSize(20);

	//����HTMLDataWindow
	Vector	vTemp = dwTemp.genHTMLDataWindow("");
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
			{"true","","Button","����","����һ����¼","newRecord()",sResourcesPath},
			{"true","","Button","����","�鿴/�޸�����","viewAndEdit()",sResourcesPath},
			{"true","","Button","ɾ��","ɾ����ѡ�еļ�¼","deleteRecord()",sResourcesPath},
			{"true","","Button","����ģ������","�鿴/�༭������ʾģ������","DataObjectview1()",sResourcesPath},
			{"true","","Button","����ģ������","�鿴/�༭�������������ʾģ������","DataObjectview2()",sResourcesPath},
			{"true","","Button","��ͬģ������","�鿴/�༭��ͬ��ʾģ������","DataObjectview3()",sResourcesPath},
			{"true","","Button","����ģ������","�鿴/�༭����ģ������","DataObjectview4()",sResourcesPath},
			{"false","","Button","������������","�鿴/�༭������������","DataObjectview5()",sResourcesPath},
			{"true","","Button","����ҵ���������","����ҵ���������","TermEdit()",sResourcesPath,"btn_icon_detail"}
		   };
	%> 
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
	
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">
    
	//---------------------���尴ť�¼�------------------------------------
	/*~[Describe=�鿴/�༭��Ʒ��ؽڵ�����;InputParam=��;OutPutParam=��;]~*/
	function PRDNodeInfoConfig()
	{
		var sTypeNo = getItemValue(0,getRow(),"TypeNo");//--���ò�Ʒ���ͱ��
		var sTypeName = getItemValue(0,getRow(),"TypeName");//--���ò�Ʒ��������
		if(typeof(sTypeNo)=="undefined" || sTypeNo.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
	        return ;
		}

		var sPara = "ProductID=" + sTypeNo;
		var sNodeIDArr =  RunJavaMethodSqlca("com.amarsoft.app.als.product.CVNodeDBManipulateController", "checkPRDNode", sPara);
		
		AsControl.OpenView("/SystemManage/SynthesisManage/HTMLGridDrawing.jsp","ProductID=" + sTypeNo + "&NodeIDArr=" + sNodeIDArr + "&TypeName=" + sTypeName, "right");
	}
	
	/*~[Describe=������¼;InputParam=��;OutPutParam=��;]~*/
	function newRecord()
	{
        sReturn=popComp("ProductTypeInfo","/Common/Configurator/CreditPolicy/ProductTypeInfo.jsp","","");
        if (typeof(sReturn)!='undefined' && sReturn.length!=0) 
        {
            //�������ݺ�ˢ���б�
            if (typeof(sReturn)!='undefined' && sReturn.length!=0) 
            {
                sReturnValues = sReturn.split("@");
                if (sReturnValues[0].length !=0 && sReturnValues[1]=="Y") 
                {
                    OpenPage("/Common/Configurator/CreditPolicy/ProductTypeList.jsp","_self","");    
                }
            }
        }
        
	}
	
	/*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=��;]~*/
	function viewAndEdit()
	{
	    sTypeNo = getItemValue(0,getRow(),"TypeNo");//--�������ͱ��
	    if(typeof(sTypeNo)=="undefined" || sTypeNo.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
	        return ;
		}
	    sReturn=popComp("ProductTypeInfo","/Common/Configurator/CreditPolicy/ProductTypeInfo.jsp","TypeNo="+sTypeNo,"");
	    if (typeof(sReturn)!='undefined' && sReturn.length!=0) 
	    {
			//�������ݺ�ˢ���б�
			if (typeof(sReturn)!='undefined' && sReturn.length!=0) 
			{
				sReturnValues = sReturn.split("@");
				if (sReturnValues[0].length !=0 && sReturnValues[1]=="Y") 
				{
				    OpenPage("/Common/Configurator/CreditPolicy/ProductTypeList.jsp","_self","");    
				}
			}
	    }
	}
	
	/*~[Describe=����ҵ���������;InputParam=��;OutPutParam=��;]~*/
	function TermEdit()
	{
		sTypeNo = getItemValue(0,getRow(),"TypeNo");
		AsControl.OpenView("/Accounting/Product/ProductVersionList.jsp","TypeNo="+sTypeNo,"_blank",OpenStyle);
	}

	/*~[Describe=�鿴������ʾģ������;InputParam=��;OutPutParam=��;]~*/
	function DataObjectview1()
	{
		sTypeNo = getItemValue(0,getRow(),"TypeNo");//--�������ͱ��
	    if(typeof(sTypeNo)=="undefined" || sTypeNo.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
	        return ;
		}
		sDisplayTemplet = getItemValue(0,getRow(),"ApplyDetailNo");//--ģ��ű��
		sEditRight="01";//�༭Ȩ��
		if(typeof(sDisplayTemplet)=="undefined" || sDisplayTemplet.length==0) 
		{
			alert("��ѡ��Ĳ�Ʒû������������ʾģ�棬������ѡ��");
		    return ;
		}
		//����ģ��Ŵ�ģ������
		popComp("DataObjectList","/Common/Configurator/DataObject/DOLibraryList.jsp","DoNo="+sDisplayTemplet+"&EditRight="+sEditRight,"");
	}
	
	/*~[Describe=�鿴�������������ʾģ������;InputParam=��;OutPutParam=��;]~*/
	function DataObjectview2()
	{
		sTypeNo = getItemValue(0,getRow(),"TypeNo");//--�������ͱ��
	    if(typeof(sTypeNo)=="undefined" || sTypeNo.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
	        return ;
		}
		sDisplayTemplet = getItemValue(0,getRow(),"ApproveDetailNo");//--ģ��ű��
		sEditRight="01";//
		if(typeof(sDisplayTemplet)=="undefined" || sDisplayTemplet.length==0) 
		{
			alert("��ѡ��Ĳ�Ʒû�������������������ʾģ�棬������ѡ��");
		    return ;
		}
		//����ģ��Ŵ�ģ������
		popComp("DataObjectList","/Common/Configurator/DataObject/DOLibraryList.jsp","DoNo="+sDisplayTemplet+"&EditRight="+sEditRight,"");
	}
	
	/*~[Describe=�鿴��ͬ��ʾģ������;InputParam=��;OutPutParam=��;]~*/
	function DataObjectview3()
	{
		sTypeNo = getItemValue(0,getRow(),"TypeNo");//--�������ͱ��
	    if(typeof(sTypeNo)=="undefined" || sTypeNo.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
	        return ;
		}
		sDisplayTemplet = getItemValue(0,getRow(),"ContractDetailNo");//--ģ��ű��
		sEditRight="01";//�༭Ȩ��
		if(typeof(sDisplayTemplet)=="undefined" || sDisplayTemplet.length==0) 
		{
			alert("��ѡ��Ĳ�Ʒû�����ú�ͬ��ʾģ�棬������ѡ��");
		    return ;
		}
		//����ģ��Ŵ�ģ������
		popComp("DataObjectList","/Common/Configurator/DataObject/DOLibraryList.jsp","DoNo="+sDisplayTemplet+"&EditRight="+sEditRight,"");
	}
   
	/*~[Describe=�鿴������ʾģ������;InputParam=��;OutPutParam=��;]~*/
	function DataObjectview4()
	{
		sTypeNo = getItemValue(0,getRow(),"TypeNo");//--�������ͱ��
	    if(typeof(sTypeNo)=="undefined" || sTypeNo.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
	        return ;
		}
		sDisplayTemplet = getItemValue(0,getRow(),"DisplayTemplet");//--ģ��ű��
		sEditRight="01";//�༭Ȩ��
		if(typeof(sDisplayTemplet)=="undefined" || sDisplayTemplet.length==0) 
		{
			alert("��ѡ��Ĳ�Ʒû�����ó�����ʾģ�棬������ѡ��");
		    return ;
		}
		//����ģ��Ŵ�ģ������
		popComp("DataObjectList","/Common/Configurator/DataObject/DOLibraryList.jsp","DoNo="+sDisplayTemplet+"&EditRight="+sEditRight,"");
	}
	
   /*~[Describe=�鿴������������;InputParam=��;OutPutParam=��;]~add by wlu 2009-02-19*/
	function DataObjectview5()
	{
        sFlowNo = getItemValue(0,getRow(),"Attribute9");
        if(typeof(sFlowNo)=="undefined" || sFlowNo.length==0)
        {
			alert("��ѡ��Ĳ�Ʒû�������������̣�������ѡ��");//��ѡ��Ĳ�Ʒû�������������̣�������ѡ��
            return ;
		}
        popComp("FlowCatalogView","/Common/Configurator/FlowManage/FlowCatalogView.jsp","ObjectNo="+sFlowNo,"");
    }
    
	/*~[Describe=ɾ����¼;InputParam=��;OutPutParam=��;]~*/
	function deleteRecord()
	{
		sTypeNo = getItemValue(0,getRow(),"TypeNo");//--�������ͱ��
        if(typeof(sTypeNo)=="undefined" || sTypeNo.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
            return ;
		}
		
		if(confirm(getHtmlMessage('2'))) 
		{
			as_del("myiframe0");
			as_save("myiframe0");  //�������ɾ������Ҫ���ô����
		}
	}
	
	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">
	
	function mySelectRow()
	{
        
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


<%@ include file="/IncludeEnd.jsp"%>
