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
	String sType=  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("Type"));
	
	String sObjectType = "MobilePosApply";
	ARE.getLog().debug("RetailAttachmentList.jsp����    sSerialNo="+sSerialNo+"Type="+sType);
	
%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%
	//������Ϣ���µĵ�Ѻ��	
	

 	String sTempletNo = "AttachmentList"; //ģ����

	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);

 	doTemp.WhereClause ="  where  Type='"+sType +"' and ObjectNo = '"+ sSerialNo+"'";
 
    String sSqlS = "";
    String sStatusCode = "";
 	ASResultSet rs = null;//-- ��Ž����
 	sSqlS = "select Status as StatusCode  from MOBILEPOS_INFO where SerialNo=:SerialNo ";
 	rs = Sqlca.getASResultSet(new SqlObject(sSqlS).setParameter("SerialNo",sSerialNo));
 	if(rs.next()){
 		sStatusCode = rs.getString("StatusCode");
      }
 	rs.getStatement().close();
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
		{((sStatusCode.equals("02"))||(sStatusCode.equals("03"))||(sStatusCode.equals("04")))?"false":"true","","Button","�ϴ�����","�ϴ�����","newRecord()",sResourcesPath},
		{"true","","Button","���ظ���","���ظ���","viewFile()",sResourcesPath},
		{((sStatusCode.equals("02"))||(sStatusCode.equals("03"))||(sStatusCode.equals("04")))?"false":"true","","Button","ɾ��","ɾ��","deleteRecord()",sResourcesPath},
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
			AsControl.OpenView("/BusinessManage/PosManage/MobilePosApplyFlow/ImageViewInfoPos.jsp","DocNo="+sDocNo+"&AttachmentNo="+sAttachmentNo,"rightdown","");
		}
	}
	
	/*~[Describe=������¼;InputParam=��;OutPutParam=��;]~*/	
	function newRecord()
	{
		var sType = "<%=sType%>";
		var sObjectNo = "<%=sSerialNo%>";
		popComp("AttachmentChooseDialog","/BusinessManage/RetailManage/RetailAttachmentChooseDialog.jsp","Type="+sType+"&ObjectNo="+sObjectNo,"dialogWidth=650px;dialogHeight=250px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
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
			popComp("AttachmentView","/BusinessManage/PosManage/MobilePosApplyFlow/AttachmentViewPos.jsp","DocNo="+sDocNo+"&AttachmentNo="+sAttachmentNo);
		}
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
