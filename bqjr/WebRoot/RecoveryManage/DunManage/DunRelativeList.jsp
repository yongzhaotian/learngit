<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   	FSGong  2004.12.05
		Tester:
		Content:  	���պ��б�
		Input Param:
				���в�����Ϊ�����������
				ObjectType	�������ͣ�BUSINESS_CONTRACT
				ObjectNo	�����ţ���ͬ���
						��������������Ŀ���Ǳ�����չ��,�������ܲ������û������ʲ��Ĵ��պ�����.
			        
		Output param:
		                	
		History Log: 
		               
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "���պ��б�"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
	String sSql 	="";
		
	
	String sObjectType; //��������
	String sObjectNo; //�����ţ���ͬ��š�
	
	//����������	
	sObjectType	=DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));
	sObjectNo	=DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%	
	sSql = 		" select SerialNo,"+
				" DunLetterNo,"+
				" DunDate,"+
				" getItemName('DunForm',DunForm) as DunForm, " +	
				" getItemName('DunMode',ServiceMode) as ServiceMode, " +	
				" DunObjectName,"+
				" getItemName('Currency',DunCurrency) as DunCurrency, " +	
				" DunSum,"+			
				" Corpus,"+			
				" InterestInSheet,"+			
				" InterestOutSheet,"+
				" ElseFee "+			
	       		" from DUN_INFO" +
	       		" where ObjectType='"+sObjectType+"' AND ObjectNo='"+sObjectNo+"' order by DunDate desc ";
	       			
   	String sHeaders[][] = {
				{"SerialNo","���պ���ˮ��"},
				{"DunLetterNo","���պ����"},
				{"DunDate","��������"},
				{"DunForm","������ʽ"},
				{"ServiceMode","�ʹ﷽ʽ"},
				{"DunObjectName","���ն�������"},
				{"DunCurrency","���ձ���"},
				{"DunSum","���ս��(Ԫ)"},	
				{"Corpus","����(Ԫ)"},	
				{"InterestInSheet","����Ϣ(Ԫ)"},	
				{"InterestOutSheet","����Ϣ(Ԫ)"},
				{"ElseFee","����(Ԫ)"}	
			       };  
			       			       

    //��sSql�������ݴ������
	ASDataObject doTemp = new ASDataObject(sSql);
	//���ñ�ͷ
	doTemp.setHeader(sHeaders);
	doTemp.UpdateTable = "DUN_INFO";
	doTemp.setKey("SerialNo",true);	 
	//���ò��ɼ���
	doTemp.setVisible("SerialNo,DunForm",false);	    
	//������ʾ�ı���ĳ���
	doTemp.setHTMLStyle("DunLetterNo"," style={width:70px} ");
	doTemp.setHTMLStyle("DunObjectName"," style={width:100px} ");
	doTemp.setHTMLStyle("DunDate,DunForm,ServiceMode,DunDate"," style={width:70px} ");
	doTemp.setHTMLStyle("DunCurrency"," style={width:60px} ");
	doTemp.setHTMLStyle("DunSum,Corpus,InterestInSheet,InterestOutSheet,ElseFee"," style={width:80px} ");
	//����С����ʾ״̬,
	doTemp.setAlign("DunSum,Corpus,InterestInSheet,InterestOutSheet,ElseFee","3");
	doTemp.setType("DunSum,Corpus,InterestInSheet,InterestOutSheet,ElseFee","Number");
	//С��Ϊ2������Ϊ5
	doTemp.setCheckFormat("DunSum,Corpus,InterestInSheet,InterestOutSheet,ElseFee","2");
	
	
	//ָ��˫���¼�
	//doTemp.setHTMLStyle("DunLetterNo,DunObjectName,DunDate,DunForm,ServiceMode,DunCurrency,DunSum,Corpus,InterestInSheet,InterestOutSheet"," style={width:100px} ondblclick=\"javascript:parent.onDBLClick()\" ");  	
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����ΪGrid���
	dwTemp.ReadOnly = "1"; //����Ϊֻ��
	dwTemp.setPageSize(16);  //��������ҳ
	
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
//		{"true","","Button","����","�鿴/�޸�����","viewAndEdit()",sResourcesPath}
		};
	%> 
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">

	//---------------------���尴ť�¼�------------------------------------
	/*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=��;]~*/
	function viewAndEdit()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else
		{
			OpenPage("/RecoveryManage/DunManage/DunInfo.jsp?SerialNo="+sSerialNo,"_self","");
		}
	}
	
	//Doubleclick a certain item of list, calling this event.
	function onDBLClick()
    	{
    		viewAndEdit();
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

<%@ include file="/IncludeEnd.jsp"%>