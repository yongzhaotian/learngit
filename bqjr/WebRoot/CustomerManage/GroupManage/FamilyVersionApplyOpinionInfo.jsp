<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   lyin 2012-12-20
		Tester:
		Content:  ���ż����ύ����ҳ��
		Input Param:	  
		Output param:
	 */
	%>
<%/*~END~*/%> 


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "���ż��׸����ύ"; // ��������ڱ���
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
	String sTempletNo = "";
	String sTempletFilter = "1=1";
	
	//��ȡ������������ſͻ�ID���汾���
	String sGroupID = CurPage.getParameter("GroupID");
	String sVersionSeq = CurPage.getParameter("VersionSeq");
	String sOldVersionSeq = CurPage.getParameter("CurrentVersionSeq");
	String sEditRight = CurPage.getParameter("EditRight");
	//����ֵת��Ϊ���ַ���
	if(sGroupID == null) sGroupID = "";
	if(sVersionSeq == null) sVersionSeq = "";
	if(sEditRight == null) sEditRight = "";
%>
<%/*~END~*/%> 


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/%>
<%	
		sTempletNo = "FamilyVersionApplyInfo";

		ASDataObject doTemp = new ASDataObject(sTempletNo,sTempletFilter,Sqlca);
		ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
		
	    doTemp.setDefaultValue("GroupID",sGroupID); //���ü��ſͻ�ID
	    doTemp.setDefaultValue("FamilySeq",sVersionSeq); 
	    doTemp.setDefaultValue("OldFamilySeq",sOldVersionSeq); 
		
		dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
		dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	    //dwTemp.setEvent("BeforeInsert","!CustomerManage.FamilyVersionApplyOpinionAction("+sGroupID+","+sVersionSeq+","+CurUser.getUserID()+")");
		
	    //����HTMLDataWindow
	    Vector vTemp = dwTemp.genHTMLDataWindow(sGroupID+","+sVersionSeq);
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
			{("Readonly".equals(sEditRight)?"false":"true"),"All","Button","���沢�ύ����","���沢�ύ����","saveRecord()","","","",""},
			{"false","All","Button","����","����","returnBack()","","","",""}
		};
	%> 
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=Info05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/Info05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info06;Describe=���尴ť�¼�;]~*/%>
<script type="text/javascript">
	var bIsInsert = false; //���DW�Ƿ��ڡ�����״̬��
	
	/*~[Describe=����ͨ��or�����˻�;InputParam=��;OutPutParam=��;]~*/
	function saveRecord()	
	{	
		var sGroupID= getItemValue(0,0,"GROUPID");
		var sVersionSeq=getItemValue(0,0,"FAMILYSEQ");
		var sSubmitOpinion=getItemValue(0,0,"SubmitOpinion");
		initSerialNo();
		as_save("myiframe0");
		if(typeof(sSubmitOpinion) != "undefined" && sSubmitOpinion != "") 
		{
			self.returnValue=checkApplyAction();
			self.close();
		}
		
	}
	
	/*~[Describe=���ż����ύ����ǰ����GROUP_FAMILY_VERSION��GROUP_INFO;InputParam=��;OutPutParam=String;]~*/
	function checkApplyAction(){
		var sGroupID = "<%=sGroupID%>";
		var sVersionSeq = "<%=sVersionSeq%>";
		var sUserID = "<%=CurUser.getUserID()%>";
		var sReturn = RunMethod("CustomerManage","FamilyVersionApplyOpinionAction",sGroupID+","+sVersionSeq+","+sUserID);
		if(typeof(sReturn) == "undefined" && sReturn == "") 
		{
			alert("���ż����ύ���˴���");
			return "failed";
		}else
		{
			return "successed";
		}
	}

 	/*~[Describe=����;InputParam=��;OutPutParam=��;]~*/
    function returnBack()
    {
    	self.close();
	} 
 	 	
</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info07;Describe=�Զ��庯��;]~*/%>
<script type="text/javascript">
	/*~[Describe=��ʼ����ˮ���ֶ�;InputParam=��;OutPutParam=��;]~*/
	function initSerialNo(){
		var sTableName = "GROUP_FAMILY_OPINION";//����
		var sColumnName = "SerialNo";//�ֶ���
		var sPrefix = "";//ǰ׺

		//��ȡ��ˮ��
		var sSerialNo = getSerialNo(sTableName,sColumnName,sPrefix);
		//����ˮ�������Ӧ�ֶ�
		setItemValue(0,getRow(),sColumnName,sSerialNo);
	}
	
	/*~[Describe=ҳ��װ��ʱ����DW���г�ʼ��;InputParam=��;OutPutParam=��;]~*/
	function initRow(){
		if (getRowCount(0)==0){ //���û���ҵ���Ӧ��¼��������һ�����������ֶ�Ĭ��ֵ
			as_add("myiframe0");//������¼
			bIsInsert = true;
		}
		setItemValue(0,getRow(),"SubmitUserID","<%=CurUser.getUserID()%>");
		setItemValue(0,getRow(),"SubmitUserName","<%=CurUser.getUserName()%>");
		setItemValue(0,getRow(),"SubmitDate","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd")%>");
    }
</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info08;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script type="text/javascript">	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	initRow(); //ҳ��װ��ʱ����DW��ǰ��¼���г�ʼ��
</script>	
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>