<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author: ��ҵ� 2005-08-17
		Tester:
		Describe:�ĵ���Ϣ�б�
		Input Param:
       		    ObjectNo: ������
       		    ObjectType: ��������           		
        Output Param:

		HistoryLog:zywei 2005/09/03 �ؼ����
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "�ĵ���Ϣ�б�"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%

	//�������                     
	String sObjectNo = "";//--������
	//���ҳ�����
	
	//����������
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));
	String sRightType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("RightType"));//Ȩ��
	if(sObjectType == null) sObjectType = "";
	if(sRightType == null) sRightType = "";
	if(sObjectType.equals("Customer"))
	 	sObjectNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerID"));
	else							
		sObjectNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	if(sObjectNo == null) sObjectNo = "";
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%
	

	//���ݶ������ͽ��в�ѯ			  
	if(sObjectType.equals("Other")) //�����ĵ�
		sObjectType = "'ClassifyCreditLineApplyPutOutApplyReserveSMEApplyTransformApply'";
	else
		;
	
	String sTempletNo = "DocumentList"; //ģ����
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);

	//���ɲ�ѯ����
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));

	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.setPageSize(25);//25��һ��ҳ
	
	//ɾ����Ӧ�������ļ�;DelDocFile(����,where���)
	dwTemp.setEvent("BeforeDelete","!DocumentManage.DelDocFile(DOC_ATTACHMENT,DocNo='#DocNo')");
	dwTemp.setEvent("AfterDelete","!DocumentManage.DelDocRelative(#DocNo)");

	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sObjectType+","+sObjectNo);//������ʾģ�����
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
		{"true","All","Button","����","�����ĵ���Ϣ","newRecord()",sResourcesPath},
		{"true","","Button","�ĵ�����","�鿴�ĵ�����","viewAndEdit_doc()",sResourcesPath},
		{"true","","Button","��������","�鿴��������","viewAndEdit_attachment()",sResourcesPath},
		{"true","All","Button","ɾ��","ɾ���ĵ���Ϣ","deleteRecord()",sResourcesPath},
		{"false","","Button","��������","���������ĵ���Ϣ","exportFile()",sResourcesPath},
		};
	if(sObjectNo.equals(""))
	{
		sButtons[0][0]="false";
		sButtons[3][0]="false";
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
	function newRecord()
	{
		OpenPage("/Common/Document/DocumentInfo.jsp?UserID="+"<%=CurUser.getUserID()%>","_self","");
	}

	/*~[Describe=ɾ����¼;InputParam=��;OutPutParam=��;]~*/
	function deleteRecord()
	{
		sUserID=getItemValue(0,getRow(),"UserID");//ȡ�ĵ�¼����	
		sDocNo = getItemValue(0,getRow(),"DocNo");
		if (typeof(sDocNo)=="undefined" || sDocNo.length==0)
		{
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
		}else if(sUserID=='<%=CurUser.getUserID()%>')
		{ 
			if(confirm(getHtmlMessage(2))) //�������ɾ������Ϣ��
			{
				as_del('myiframe0');
				as_save('myiframe0') //�������ɾ������Ҫ���ô����             
			} 
		}else 
		{
			alert(getHtmlMessage('3'));
			return;
		}
	}

	/*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=��;]~*/
	function viewAndEdit_doc()
	{
		sDocNo=getItemValue(0,getRow(),"DocNo");
		sUserID=getItemValue(0,getRow(),"UserID");//ȡ�ĵ�¼����		     	
    	if (typeof(sDocNo)=="undefined" || sDocNo.length==0)
    	{
        	alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
    	}
    	else
    	{
    		OpenPage("/Common/Document/DocumentInfo.jsp?DocNo="+sDocNo+"&UserID="+sUserID,"_self","");
        }
	}
	
	/*~[Describe=�鿴���޸ĸ�������;InputParam=��;OutPutParam=��;]~*/
	function viewAndEdit_attachment()
	{    
    	sDocNo=getItemValue(0,getRow(),"DocNo");
    	sUserID=getItemValue(0,getRow(),"UserID");//ȡ�ĵ�¼����
    	sRightType="<%=sRightType%>";
    	if (typeof(sDocNo)=="undefined" || sDocNo.length==0)
    	{        
        	alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;         
    	}
    	else
    	{
    		popComp("AttachmentList","/Common/Document/AttachmentList.jsp","DocNo="+sDocNo+"&UserID="+sUserID+"&RightType="+sRightType);
      		reloadSelf();
      	}
	}
	
	/*~[Describe=��������;InputParam=��;OutPutParam=��;]~*/
	function exportFile()
	{
		//����������Ϣ       
    	OpenPage("/Common/Document/ExportFile.jsp","_self","");
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
</script>
<%/*~END~*/%>


<%@	include file="/IncludeEnd.jsp"%>
