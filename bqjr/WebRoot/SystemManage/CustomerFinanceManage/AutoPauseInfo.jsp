<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
		/*
		Author:   --fbkang 
		Tester:
		Content:    --ȫ�ֱ���ά��
			δ�õ��������ֶ���ʱ���أ������Ҫ��չʾ������
		Input Param:
        	TypeNo��    --���ͱ��
 		Output param:
 			
		History Log: 
            
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%//CCS-769 ����ȫ�ֱ����޸�Ϊ�Զ���ͣʱ�����õ����� update huzp 20150520
	String PG_TITLE = "�Զ���ͣʱ������"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%	
    String AUTOPAUSE_CODE="AutoPause";
	ASDataObject doTemp = new ASDataObject("AutoPauseInfo",Sqlca); 
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д

	//��һ��������"BeforeInsert","AfterInsert","BeforeDelete","AfterDelete","BeforeUpdate","AfterUpdate"

	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(AUTOPAUSE_CODE);
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
			{"true","","Button","����","����","saveAndGoBack()",sResourcesPath},
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
    
	function saveRecord(sPostEvents){
		if(bIsInsert){
			beforeInsert();
		}
		beforeUpdate();
		as_save("myiframe0",sPostEvents);
	}
	
	function saveAndGoBack(){
		saveRecord("goBack()");
	}
	function goBack(){
		AsControl.OpenView("/SystemManage/CustomerFinanceManage/AutoPauseInfo.jsp","","right","");
		var SERIALNO = getSerialNo("AutoPause_Info","SERIALNO","");
		var AUTOPAUSE_CODE="<%=AUTOPAUSE_CODE%>";
		var A_CLASS= getItemValue(0,getRow(),"A_CLASS");
		var B_CLASS= getItemValue(0,getRow(),"B_CLASS");
		var C_CLASS= getItemValue(0,getRow(),"C_CLASS");
		var D_CLASS= getItemValue(0,getRow(),"D_CLASS");
		var OK_CLASS= getItemValue(0,getRow(),"OK_CLASS");
		var UPDATEORG="<%=CurUser.getOrgID()%>";
		var UPDATEUSER="<%=CurUser.getUserID()%>";
		var UPDATEDATE="<%=DateX.format(new java.util.Date(),"yyyy/MM/dd HH:mm:ss")%>";
		
		var args ="SERIALNO="+SERIALNO+",AUTOPAUSE_CODE="+AUTOPAUSE_CODE+",A_CLASS="+A_CLASS+",B_CLASS="+B_CLASS+",C_CLASS="+C_CLASS+",D_CLASS="+D_CLASS+",OK_CLASS="+OK_CLASS+",UPDATEORG="+UPDATEORG+",UPDATEUSER="+UPDATEUSER+",UPDATEDATE="+UPDATEDATE;
		RunJavaMethodSqlca("com.amarsoft.app.billions.InsertAutoPauseHistoryInfo","addAutoPauseHistoryInfo",args);
	}

	
	
	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">
	<%/*~[Describe=ִ�в������ǰִ�еĴ���;]~*/%>
	
	function beforeInsert(){
		var SERIALNO = getSerialNo("basedataset_info","SERIALNO","");
		setItemValue(0,0,"SERIALNO", SERIALNO);
		setItemValue(0,0,"AUTOPAUSE_CODE", "<%=AUTOPAUSE_CODE%>");
		setItemValue(0,0,"UPDATEORG","<%=CurUser.getOrgID()%>");
		setItemValue(0,0,"UPDATEUSER","<%=CurUser.getUserID()%>");
		setItemValue(0,0,"UPDATEDATE","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd HH:mm:ss")%>");
		bIsInsert = false;
	}
	
	<%/*~[Describe=ִ�и��²���ǰִ�еĴ���;]~*/%>
	function beforeUpdate(){
		setItemValue(0,0,"UPDATEUSER","<%=CurUser.getUserID()%>");
		setItemValue(0,0,"UPDATEDATE","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd HH:mm:ss")%>");
		setItemValue(0,0,"UPDATEORG","<%=CurUser.getOrgID()%>");
	}
	
	function initRow(){
		if (getRowCount(0)==0) //���û���ҵ���Ӧ��¼��������һ�����������ֶ�Ĭ��ֵ
		{
			as_add("myiframe0");//������¼
			setItemValue(0,0,"AUTOPAUSE_CODE", "<%=AUTOPAUSE_CODE%>");
			setItemValue(0,0,"UPDATEUSER","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"UPDATEORG","<%=CurUser.getOrgName() %>");
			setItemValue(0,0,"UPDATEDATE","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd HH:mm:ss")%>");
			bIsInsert = true;
		}else{
			setItemValue(0,0,"AUTOPAUSE_CODE", "<%=AUTOPAUSE_CODE%>");
			setItemValue(0,0,"UPDATEUSER","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"UPDATEORG","<%=CurUser.getOrgName() %>");
			setItemValue(0,0,"UPDATEDATE","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd HH:mm:ss")%>");
		}
	}
	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List07;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script type="text/javascript">	
	$(document).ready(function(){
		AsOne.AsInit();
		init();
		bFreeFormMultiCol = true;
		my_load(2,0,'myiframe0');
		initRow();
	});
	
</script>	
<%/*~END~*/%>


<%@ include file="/IncludeEnd.jsp"%>
