<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author: 
		Tester:
		Describe:�ĵ������б�
		Input Param:
       		�ĵ����:DocNo
		Output Param:

		HistoryLog:
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "�ĵ������б�"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%

	//�������                     
    String sSql = "";   	
	String sSerialNo=  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
	String sRegCode=  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("RegCode"));
	String sType=  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("Type"));
	String sPhaseType =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("PhaseType"));
	String company=Sqlca.getString("select company from store_info where serialno='"+sSerialNo+"'");
	
	if (sPhaseType == null) sPhaseType = "";
	String sObjectType = "RetailApply";
	ARE.getLog().debug("StoreAttachmentList.jsp����    sSerialNo="+sSerialNo+"Type="+sType+" "+sPhaseType+"company"+company);
	
	
%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%
	//������Ϣ���µĵ�Ѻ��	
	

 	String sTempletNo = "AttachmentList"; //ģ����

	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	String sRegCodeString ="";
 	if(sRegCode==null){
 		sRegCode = "";
 	}else{
 		sRegCodeString=sRegCode.replace(",", "','");
 	}
 	doTemp.WhereClause ="  where  Type='"+sType +"' and ObjectNo in ('"+ sRegCodeString+"') and company='"+company+"'";
 	
	//���ɲ�ѯ����
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));

	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.setPageSize(25);//25��һ��ҳ
	
	//ɾ����Ӧ�������ļ�;DelDocFile(����,where���)
	dwTemp.setEvent("BeforeDelete","!DocumentManage.DelDocFile(DOC_ATTACHMENT,DocNo='#DocNo' and AttachmentNo='#AttachmentNo')");
// 	dwTemp.setEvent("AfterInsert","!DocumentManage.InsertDocRelative(#DocNo,"+sObjectType+","+sObjectNo+")");
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");//������ʾģ�����
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
		{CurUser.hasRole("1005")&&((sPhaseType.equals("01"))||(sPhaseType.equals("04")))?"true":"false","","Button","�ϴ�����","�ϴ�����","newRecord()",sResourcesPath},
		{"true","","Button","���ظ���","���ظ���","viewFile()",sResourcesPath},
		{"true","","Button","�������ظ���","�������ظ���","DownAllFile()",sResourcesPath},
		{CurUser.hasRole("1005")&&((sPhaseType.equals("01"))||(sPhaseType.equals("04")))?"true":"false","","Button","ɾ��","ɾ��","deleteRecord()",sResourcesPath},
		//{"true","","Button","����","�����б�ҳ��","goBack()",sResourcesPath}
		};
	





	%>
<%/*~END~*/%>




<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">

	//---------------------���尴ť�¼�------------------------------------
	 function mySelectRow(){
		var sDocNo = getItemValue(0,getRow(),"DocNo");
		var sAttachmentNo = getItemValue(0,getRow(),"AttachmentNo");
		if(typeof(sDocNo)=="undefined" || sDocNo.length==0 || typeof(sAttachmentNo)=="undefined" || sAttachmentNo.length==0) {
			AsControl.OpenView("/Blank.jsp","TextToShow=����ѡ����Ӧ����Ϣ!","rightdown","");
		}else{
			AsControl.OpenView("/BusinessManage/RetailManage/ImageViewInfo.jsp","DocNo="+sDocNo+"&AttachmentNo="+sAttachmentNo,"rightdown","");
		}
	} 
	
	/*~[Describe=������¼;InputParam=��;OutPutParam=��;]~*/	
	function newRecord()
	{
		var sType = "<%=sType%>";
		var sObjectNo = "<%=sRegCode%>";
		var company = "<%=company%>";
		popComp("AttachmentChooseDialog","/BusinessManage/RetailManage/StoreAttachmentChooseDialog.jsp","Type="+sType+"&company="+company+"&ObjectNo="+sObjectNo+"&isNtfs=Y","dialogWidth=650px;dialogHeight=250px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		reloadSelf();
	}

	/*~[Describe=ɾ����¼;InputParam=��;OutPutParam=��;]~*/
	function deleteRecord()
	{
		var sAttachmentNo = getItemValue(0,getRow(),"AttachmentNo");
		
		if (typeof(sAttachmentNo)=="undefined" || sAttachmentNo.length==0)
		{
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
		}else
		{
			if(confirm(getHtmlMessage(2))) //�������ɾ������Ϣ��
			{
        		as_del('myiframe0');
        		as_save('myiframe0'); 
        		reloadSelf();
    		}
		}
		
	}

	/*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=��;]~*/
	function viewFile()
	{
		sAttachmentNo = getItemValue(0,getRow(),"AttachmentNo");
		sDocNo= getItemValue(0,getRow(),"DocNo");
		if (typeof(sAttachmentNo)=="undefined" || sAttachmentNo.length==0)
		{
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
		}
		else
		{
			popComp("AttachmentView","/BusinessManage/RetailManage/AttachmentViewStore.jsp","DocNo="+sDocNo+"&AttachmentNo="+sAttachmentNo);
		}
	}
	/*~[Describe=��������;InputParam=��;OutPutParam=��;]~*/
	function DownAllFile(){
		var sType = "<%=sType%>";
		var sObjectNo = "<%=sRegCode%>";
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
		}
		popComp("AttachmentView","/BusinessManage/RetailManage/DownAllFile.jsp","SerialNo="+sObjectNo+"&Type="+sType+"&Ntfs=S");

	}
	
	function goBack()
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
</script>
<%/*~END~*/%>

<%@	include file="/IncludeEnd.jsp"%>
