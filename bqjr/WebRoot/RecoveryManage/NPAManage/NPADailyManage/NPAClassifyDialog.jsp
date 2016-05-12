<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/%>
	<%
	/*
		Author:  zywei 2005/09/09
		Tester:
		Content: 
		Input Param:
			ObjectType���������ͣ�����ͬ��BUSINESS_CONTRACT������ݣ�BUSINESS_DUEBILL��
			ContractSerialNo����ͬ��ˮ��
			ModelNo��ģ�ͱ��			
		Output param:
		History Log: 
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = ""; // ��������ڱ��� <title> PG_TITLE </title>	
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info02;Describe=�����������ȡ����;]~*/%>
<%
	//���������SQL���
	String sSql = "";
	
	//����������	���������͡���ͬ��ˮ�š�ģ�ͺ�
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));
	String sContractSerialNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	String sModelNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ModelNo"));
	
	//����ֵת��Ϊ���ַ���	
	if(sObjectType == null) sObjectType = "";
	if(sContractSerialNo == null) sContractSerialNo = "";
	if(sModelNo == null) sModelNo = "";
		
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/%>
<%
	
	String[][] sHeaders1 = {
					{"AccountMonth","���շ����·�"},							
					{"ObjectNo","��ͬ��ˮ��"}							
			      };
	String[][] sHeaders2 = {
					{"AccountMonth","���շ����·�"},							
					{"ObjectNo","�����ˮ��"}							
			      };
	sSql = 	" select AccountMonth,ObjectNo "+	
			" from CLASSIFY_RECORD "+
			" where 1 = 2 ";	
	
	//ͨ��SQL����ASDataObject����doTemp
	ASDataObject doTemp = new ASDataObject(sSql);	
	//���ð���ͬ����ı���
	if(sObjectType.equals("BusinessContract"))
		doTemp.setHeader(sHeaders1);
	if(sObjectType.equals("BusinessDueBill"))
		doTemp.setHeader(sHeaders2);
		
	doTemp.UpdateTable = "CLASSIFY_RECORD";
	//���ñ�����
	doTemp.setRequired("AccountMonth,ObjectNo",true);
	
	//����ֻ������
	doTemp.setReadOnly("AccountMonth,ObjectNo",true);
	doTemp.setHTMLStyle("AccountMonth"," style={width:70px} ");
	//����ѡ��ʽ
	doTemp.setUnit("AccountMonth","<input type=button class=inputDate   value=\"...\" name=button1 onClick=\"javascript:parent.getMonth();\"> ");
	if(sObjectType.equals("BusinessDueBill")) //һ��ҵ���ͬ���ܶ�Ӧ������
		doTemp.setUnit("ObjectNo","<input type=button class=inputDate   value=\"...\" name=button1 onClick=\"javascript:parent.getObjectNo();\"> ");
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style = "2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д

	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
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
		{"true","","Button","ȷ��","�����ʲ����շ���","doSubmit()",sResourcesPath},
		{"true","","Button","ȡ��","ȡ���ʲ����շ���","doCancel()",sResourcesPath}		
	};
	%> 
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=Info05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/Info05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info06;Describe=���尴ť�¼�;]~*/%>
	<script type="text/javascript">
	
	//---------------------���尴ť�¼�------------------------------------
	
	/*~[Describe=�����ʲ����շ���;InputParam=��;OutPutParam=��;]~*/	
	function doSubmit()
	{
		var sObjectType = "<%=sObjectType%>";
		sAccountMonth = getItemValue(0,getRow(),"AccountMonth");//--���շ����·�	
		if (typeof(sAccountMonth) == "undefined" || sAccountMonth.length == 0)
		{
			alert(getBusinessMessage('671'));//��ѡ����շ����·ݣ�
			return;
		}
		sObjectNo = getItemValue(0,getRow(),"ObjectNo");//--������	
		
		if (typeof(sObjectNo) == "undefined" || sObjectNo.length == 0)
		{
			if(sObjectType == "BusinessContract")
				alert(getBusinessMessage('672'));//��ѡ�����ʲ����շ���ĺ�ͬ��ˮ�ţ�
			if(sObjectType == "BusinessDueBill")
				alert(getBusinessMessage('673'));//��ѡ�����ʲ����շ���Ľ����ˮ�ţ�
			return;
		}
		
		//�����ʲ����շ�����Ϣ
	    sReturn = PopPageAjax("/CreditManage/CreditCheck/AddClassifyActionAjax.jsp?AccountMonth="+sAccountMonth+"&ObjectType="+sObjectType+"&ObjectNo="+sObjectNo+"&Type=Single&ModelNo=<%=sModelNo%>","","");
	    if(typeof(sReturn) == "undefined" || sReturn.length == 0)
	    {
	    	alert(getBusinessMessage('674'));//�����ʲ����շ�������ʧ�ܣ�
	    	return;
	    }else
	    {
			alert(getBusinessMessage('675'));//�����ʲ����շ��������ɹ���
			top.returnValue = sReturn;
			top.close();	
		}	
    }
    
	/*~[Describe=ȡ�������ʲ����շ���;InputParam=��;OutPutParam=ȡ����־;]~*/
	function doCancel()
	{		
		top.returnValue = "_CANCEL_";
		top.close();
	}
	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info07;Describe=�Զ��庯��;]~*/%>	
	<script type="text/javascript">
	
	/*~[Describe=ѡ�����·�;InputParam=��;OutPutParam=ȡ����־;]~*/
    function getMonth()
	{
		var sMonth = PopPage("/Common/ToolsA/SelectMonth.jsp","","resizable=yes;dialogWidth=20;dialogHeight=15;center:no;status:no;statusbar:no");
		if (typeof(sMonth) != "undefined" && sMonth.length > 0)
			setItemValue(0,0,"AccountMonth",sMonth);		
	}
    
    /*~[Describe=����������ѡ���;InputParam=��;OutPutParam=��;]~*/
	function getObjectNo()
	{
		var sReturnValue = "";
		var sObjectNo = "";
		var sObjectType = "<%=sObjectType%>";
		sAccountMonth = getItemValue(0,getRow(),"AccountMonth");//--���շ����·�	
		if (typeof(sAccountMonth) == "undefined" || sAccountMonth.length == 0)
		{
			alert(getBusinessMessage('671'));//��ѡ����շ����·ݣ�
			return;
		}
		
		//������ս�ݽ����ʲ����շ��࣬��ôѡ������ˮ��
		if(sObjectType == "BusinessDueBill")
		{				
			sParaString = "ObjectType,"+sObjectType+",AccountMonth"+","+sAccountMonth+",RelativeSerialNo2"+","+"<%=sContractSerialNo%>";
			sReturnValue = setObjectValue("SelectNPAClassifyDueBill",sParaString,"",0,0,"");			
		}
			
		if(sReturnValue != "_CANCEL_" && typeof(sReturnValue) != "undefined")
		{
			sReturnValue = sReturnValue.split('@');
			for(i = 0;i < sReturnValue.length;i++)
			{
				sObjectNo += sReturnValue[i];
			}
			setItemValue(0,getRow(),"ObjectNo",sObjectNo);
		}	
	}		
	
	/*~[Describe=ҳ��װ��ʱ����DW���г�ʼ��;InputParam=��;OutPutParam=��;]~*/
	function initRow()
	{
		if (getRowCount(0)==0) //���û���ҵ���Ӧ��¼��������һ�����������ֶ�Ĭ��ֵ
		{
			sObjectType = "<%=sObjectType%>";
			sContractSerialNo = "<%=sContractSerialNo%>";
			as_add("myiframe0");//����һ���ռ�¼	
			if(sObjectType == "BusinessContract")
				setItemValue(0,getRow(),"ObjectNo",sContractSerialNo);		
		}
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