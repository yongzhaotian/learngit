<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/%>
	<%
	/*
		Author: zywei 2005/09/09
		Tester:
		Content: 
		Input Param:
			ObjectType���弶�������("Classify")
			Type������(Single�����ʣ�Batch������)
			ClassifyType: �޸ı�־(010:���ý���ģ�ͷ�����㣬020��ֻ�������ģ�ͷ�����)
			ResultType: ��������(����ͬ��BUSINESS_CONTRACT������ݣ�BUSINESS_DUEBILL)
		Output param:
		History Log: 
			cbsu 2009/10/14  ����ALS6.5���弶����������޸���ҳ���߼�.
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
	
	//�������������������͡�ģ�ͺš����͡��弶�����ݻ��ͬ
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));
	String sType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("Type"));
	String sClassifyType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ClassifyType"));
	String sResultType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ResultType")); 
	
	//����ֵת��Ϊ���ַ���	
	if(sObjectType == null) sObjectType = "";
	if(sType == null) sType = "";
	if(sClassifyType == null) sClassifyType = "";
	if(sResultType == null) sResultType = "";
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/%>
<%	
	String[][] sHeaders1 = {
					{"AccountMonth","���շ����·�"},							
					{"ObjectNo","��ͬ��"} //modify by cbsu 2009-10-13							
			      };
	String[][] sHeaders2 = {
					{"AccountMonth","���շ����·�"},							
					{"ObjectNo","��ݺ�"} //modify by cbsu 2009-10-13							
			      };
	sSql = 	" select AccountMonth,ObjectNo "+	
			" from CLASSIFY_RECORD "+
			" where 1 = 2 ";	
	
	//ͨ��SQL����ASDataObject����doTemp
	ASDataObject doTemp = new ASDataObject(sSql);	
	//���ð���ͬ����ı���  modify by cbsu 2009-10-12
	if(sResultType.equals("BusinessContract"))
		doTemp.setHeader(sHeaders1);
	if(sResultType.equals("BusinessDueBill"))
		doTemp.setHeader(sHeaders2);		
	doTemp.UpdateTable = "CLASSIFY_RECORD";
	//���ñ�����
	doTemp.setRequired("AccountMonth,ObjectNo",true);	
	//����ֻ������
	doTemp.setReadOnly("AccountMonth,ObjectNo",true);
	doTemp.setHTMLStyle("AccountMonth"," style={width:70px} ");
	//����ѡ��ʽ
	doTemp.setUnit("AccountMonth","<input type=button class=inputDate   value=\"...\" name=button1 onClick=\"javascript:parent.getMonth();\"> ");
	doTemp.setUnit("ObjectNo","<input type=button class=inputDate   value=\"...\" name=button1 onClick=\"javascript:parent.getObjectNo();\"> ");
	//������ɼ���
	if(sType.equals("Batch"))
		doTemp.setVisible("ObjectNo",false);
	//����Ĭ��ֵ
	doTemp.setDefaultValue("AccountMonth",StringFunction.getToday().substring(0,7));
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
		var sResultType = "<%=sResultType%>";
		var sType = "<%=sType%>";
		sAccountMonth = getItemValue(0,getRow(),"AccountMonth");//����·�		
		if (typeof(sAccountMonth) == "undefined" || sAccountMonth.length == 0)
		{
			alert(getBusinessMessage('671'));//��ѡ����շ����·ݣ�
			return;
		}
		sObjectNo = getItemValue(0,getRow(),"ObjectNo");//������	
		if(sType != "Batch")	
		{
			if (typeof(sObjectNo) == "undefined" || sObjectNo.length == 0)
			{   //modify by cbsu 2009-10-12
				if(sResultType == "BusinessContract")
					alert(getBusinessMessage('672'));//��ѡ�����ʲ����շ���ĺ�ͬ��ˮ�ţ�
				if(sResultType == "BusinessDueBill")
					alert(getBusinessMessage('673'));//��ѡ�����ʲ����շ���Ľ����ˮ�ţ�
				return;
			}
		}
		//�����ʲ����շ�����Ϣ
	    sReturn = PopPageAjax("/CreditManage/CreditCheck/ConsoleClassifyActionAjax.jsp?AccountMonth="+sAccountMonth+"&ResultType="+sResultType+"&ObjectType="+sObjectType+"&ObjectNo="+sObjectNo+"&Type="+sType+"&ModelNo=Classify1","","");
	    if(typeof(sReturn) == "undefined" || sReturn.length == 0){
	    	alert(getBusinessMessage('674'));//�����ʲ����շ�������ʧ�ܣ�
	    	return;
	    }else if(sReturn == "IsExist"){
	    	alert(getBusinessMessage("665"));//�����ʲ����շ����Ѿ����ڣ�
	    	return;
	    }else{
			alert(getBusinessMessage('675'));//�����ʲ����շ��������ɹ���
			top.returnValue = sReturn;
	        sCompID = "CreditTab";
	        sCompURL = "/CreditManage/CreditApply/ObjectTab.jsp";
	        sParamString = "ComponentName=���շ���ο�ģ��"+
					       "&OpenType=Tab"+ //jschen@20100412 �������ִ򿪷���ģ�ͽ���ķ�ʽ
	            		   "&Action=_DISPLAY_"+
	            		   "&ClassifyType="+"<%=sClassifyType%>"+
	            		   "&ObjectType="+sObjectType+
	            		   "&ObjectNo="+sReturn+
	            		   "&SerialNo="+sObjectNo+
	            		   "&AccountMonth="+sAccountMonth+
	            		   "&ModelNo=Classify1"+
	            		   "&ResultType="+sResultType;
	        popComp(sCompID,sCompURL,sParamString,"");
			self.close();
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
		var sMonth = PopPage("/Common/ToolsA/SelectMonth.jsp","","resizable=yes;dialogWidth=20;dialogHeight=15;center:yes;status:no;statusbar:no");
		if (typeof(sMonth) != "undefined" && sMonth.length > 0)
			setItemValue(0,0,"AccountMonth",sMonth);		
	}
    
    /*~[Describe=����������ѡ���;InputParam=��;OutPutParam=��;]~*/
	function getObjectNo()
	{
		var sReturnValue = "";
		var sObjectNo = "";
		var sResultType = "<%=sResultType%>";
		var sAccountMonth = getItemValue(0,getRow(),"AccountMonth");//--����·�		
		if (typeof(sAccountMonth) == "undefined" || sAccountMonth.length == 0)
		{
			alert(getBusinessMessage('671'));//��ѡ����շ����·ݣ�
			return;
		}
		//������պ�ͬ�����ʲ����շ��࣬��ôѡ���ͬ��ˮ�� modify by cbsu 2009-10-12
		if(sResultType == "BusinessContract")
		{			
			sParaString = "ObjectType,"+sResultType+",AccountMonth"+","+sAccountMonth+",UserID,"+"<%=CurUser.getUserID()%>";
			sReturnValue = setObjectValue("SelectClassifyContractnew",sParaString,"",0,0,"");			
		} else {
			//������ս�ݽ����ʲ����շ��࣬��ôѡ������ˮ��	
			sParaString = "ObjectType,"+sResultType+",AccountMonth"+","+sAccountMonth+",UserID,"+"<%=CurUser.getUserID()%>";
			sReturnValue = setObjectValue("SelectClassifyDueBillnew",sParaString,"",0,0,"");
		}
		if(sReturnValue != "_CLEAR_" && typeof(sReturnValue) != "undefined")
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
		//���û���ҵ���Ӧ��¼��������һ�����������ֶ�Ĭ��ֵ
		if (getRowCount(0)==0) 
		{   
			//����һ���ռ�¼
			as_add("myiframe0");
		}
    }
		
	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info08;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script type="text/javascript">	
	AsOne.AsInit();
	init();	
	my_load(2,0,'myiframe0');
	//ҳ��װ��ʱ����DW��ǰ��¼���г�ʼ��
	initRow(); 
	var bCheckBeforeUnload=false;	
</script>	
<%/*~END~*/%>


<%@ include file="/IncludeEnd.jsp"%>