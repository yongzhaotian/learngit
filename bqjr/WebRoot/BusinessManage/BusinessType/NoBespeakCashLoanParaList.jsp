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
	String PG_TITLE = "��ԤԼ�ֽ���ⲿ�ͻ������б�"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info02;Describe=�����������ȡ����;]~*/%>
<%

	//���ҳ�����
	//String sProductID  = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("productID"));	
    //if(sProductID==null) sProductID="";

%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/%>
	<%
		
	String sTempletNo = "NoBespeakCashLoanParaList";
	
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
	//���ɲ�ѯ��
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	
	//��ѯ����Ϊ�ղ���ѯ����
	//if(!doTemp.haveReceivedFilterCriteria()) doTemp.WhereClause+=" and 1=2";
	
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //����Ϊֻ��
	
	dwTemp.setPageSize(10);  //��������ҳ
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");//�������,���ŷָ�
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
		{"true","","Button","����","��������","newRecord()",sResourcesPath},
		{"true","","Button","����","�����¼","myDetail()",sResourcesPath},	
		{"true","","Button","ɾ��","ɾ����ѡ�е�����","deleteRecord()",sResourcesPath},
		};
	%>
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">

	//---------------------���尴ť�¼�------------------------------------
	/**
	 * ��������
	 */
	function newRecord(){
		sCompID = "NoBespeakCashLoanParaInfo";
		sCompURL = "/BusinessManage/BusinessType/NoBespeakCashLoanParaInfo.jsp";
		sCompParam = "serialno="; //��������ֵ����
		
		var left = (window.screen.availWidth-800)/2;
		var top = (window.screen.availHeight-400)/2;
		var features ='left='+left+',top='+top+',width=800,height=400';
		var style = 'toolbar=no,scrollbars=yes,resizable=yes,scroll=no;status=no,menubar=no,'+features;
		
		popComp(sCompID, sCompURL, sCompParam , style);
		//AsControl.PopPage(sCompURL,sCompParam,style); //�򿪣�û��ˢ����
		reloadSelf();
	}
	
	/**
	 * ɾ������
	 */
	function deleteRecord(){
		var serialno =getItemValue(0,getRow(),"serialno");//��ȡɾ����¼�ĵ�Ԫֵ
		if (typeof(serialno)=="undefined" || serialno.length==0){
			alert("������ѡ��һ����¼��");
			return;
		}
		
		if(confirm("�������ɾ������Ϣ��")){
			as_del("myiframe0");
			as_save("myiframe0");  //�������ɾ������Ҫ���ô����
			reloadSelf();
		}
	}
	
	/**
	 * ������
	 */
	function myDetail(){
		var serialno = getItemValue(0,getRow(),"serialno");	
		if(typeof(serialno)=="undefined" || serialno.length==0){
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
		}else{
			sCompID = "NoBespeakCashLoanParaDetail";
			sCompURL = "/BusinessManage/BusinessType/NoBespeakCashLoanParaInfo.jsp";
			sCompParam = "serialno="+serialno; //��ֵ����
			
			var left = (window.screen.availWidth-800)/2;
			var top = (window.screen.availHeight-400)/2;
			var features ='left='+left+',top='+top+',width='+800+',height='+400;
			var style = 'toolbar=no,scrollbars=yes,resizable=yes,scroll:no;status=no,menubar=no,'+features;
			
			popComp(sCompID, sCompURL, sCompParam , style);
			//AsControl.PopPage(sCompURL,sParamString,style); //�򿪣�û��ˢ����
		}
		reloadSelf();
	}
	
	/**
	 * �ر�ҳ��
	 */
	function doCancel(){		
		top.returnValue = "_CANCEL_";
		top.close();
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

