<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   qfang 2011-06-01
		Tester:	  
		Content:  ҵ��Ʒ�ַ���Listҳ��
		Input Param:
                  
		Output param:
		    
		                
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
	
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%	

	//ͨ����ʾģ�����ASDataObject����doTemp
	String sTempletNo = "ProductTypeSortList"; //ģ����
	String sTempletFilter = "1=1"; //�й�������ע�ⲻҪ�����ݹ�������
	ASDataObject doTemp = new ASDataObject(sTempletNo,sTempletFilter,Sqlca);
	
	//���˲�ѯ
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
    
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	//����ҳ����ʾ������
	dwTemp.setPageSize(20);
  	

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
			{"true","","Button","����","����һ����¼","newRecord()",sResourcesPath},
			{"true","","Button","����","�鿴/�޸�����","viewAndEdit()",sResourcesPath},
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
	function newRecord()
	{		
		sParaString = "ManageUserID"+","+"<%=CurUser.getUserID()%>"+","+"PutOutDate"+","+"<%=StringFunction.getToday()%>"+","+"Maturity"+","+"<%=StringFunction.getToday()%>";
		//ѡ��Ի���Grid��
		sReturn = setObjectValue("SelectBusinessType",sParaString,"",0,0,"");
		if(typeof(sReturn) == "undefined" || sReturn == "" || sReturn == "_NONE_" || sReturn == "_CLEAR_" || sReturn == "_CANCEL_") return;
		//��ȡ ����:TypeNo(��Ʒ���),TypeName(��Ʒ����)
		var sReturn = sReturn.split("@");
		var sTypeNo = sReturn[0];
		var STypeName = sReturn[1];
		sCompID = "ProductTypeSortInfo";
		sCompURL = "/Common/Configurator/SortPolicy/ProductTypeSortInfo.jsp";
		sParamString = "TypeNo="+sTypeNo+"&TypeName="+STypeName;
		OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
		reloadSelf();
	}

	/*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=��;]~*/
	function viewAndEdit()
	{
	    sTypeNo = getItemValue(0,getRow(),"TypeNo");//--�������ͱ��
	    if(typeof(sTypeNo)=="undefined" || sTypeNo.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
	        return ;
		}
	    sReturn=popComp("ProductTypeSortInfo","/Common/Configurator/SortPolicy/ProductTypeSortInfo.jsp","TypeNo="+sTypeNo,"");
	    reloadSelf();
	    if (typeof(sReturn)!='undefined' && sReturn.length!=0) 
	    {
			//�������ݺ�ˢ���б�
			if (typeof(sReturn)!='undefined' && sReturn.length!=0) 
			{
				sReturnValues = sReturn.split("@");
				if (sReturnValues[0].length !=0 && sReturnValues[1]=="Y") 
				{
				    OpenPage("/Common/Configurator/SortPolicy/ProductTypeSortList.jsp","_self","");    
				}
			}
	    }  
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


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List07;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script type="text/javascript">	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
    
</script>	
<%/*~END~*/%>


<%@ include file="/IncludeEnd.jsp"%>
