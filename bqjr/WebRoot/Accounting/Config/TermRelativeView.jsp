<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%
	String PG_TITLE = "���������ϵ�б�"; // ��������ڱ��� <title> PG_TITLE </title>

	//�������
	
	//����������
	
	//���ҳ�����	
	String sObjectType =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectType")); 
	String sObjectNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectNo")); 
	String sTermID =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("TermID"));
	if(sObjectType==null) sObjectType="";
	if(sObjectNo==null) sObjectNo="";
	if(sTermID==null) sTermID="";
	
	//ͨ����ʾģ�����ASDataObject����doTemp
	String sTempletNo = "TermRelativeView";
	String sTempletFilter = "1=1";

	ASDataObject doTemp = new ASDataObject(sTempletNo,sTempletFilter,Sqlca);
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sTermID+","+sObjectNo+","+sObjectType);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	
	String sButtons[][] = {
			{"true","","Button","��ӻ������","��ӻ������","addExclusiveRelative()",sResourcesPath},
			{"true","","Button","��Ӱ󶨹���","��Ӱ󶨹���","addBindRelative()",sResourcesPath},
			{"true","","Button","ɾ��","ɾ���������","deleterelative()",sResourcesPath}
		};

	%>

	<%@include file="/Resources/CodeParts/List05.jsp"%>




	<script type="text/javascript">
	var bIsInsert = false; //���DW�Ƿ��ڡ�����״̬��
	//---------------------���尴ť�¼�------------------------------------
	var s="";
	/*~[Describe=����;InputParam=�����¼�;OutPutParam=��;]~*/
	function saveRecord(sPostEvents)
	{
		if(bIsInsert){
			beforeInsert();
		}

		beforeUpdate();
		as_save("myiframe0",sPostEvents);
	}
	
	function addExclusiveRelative()
	{	
		var returnValue=setObjectValue("SelectAllTerms","termId,<%=sTermID%>","",0,0,"");
		if(typeof(returnValue) != "undefined" && returnValue != "" && returnValue != "_NONE_" && returnValue != "_CLEAR_" && returnValue != "_CANCEL_")
		{
			RunMethod("ProductManage","addExclusiveRelative","addExclusiveRelative,<%=sTermID%>,"+returnValue+","+"<%=sObjectType%>,"+"<%=sObjectNo%>");
			reloadSelf();
		} 
	}

	function addBindRelative()
	{
		var returnValue=setObjectValue("SelectAllTerms","termId,<%=sTermID%>","",0,0,"");
		if(typeof(returnValue) != "undefined" && returnValue != "" && returnValue != "_NONE_" && returnValue != "_CLEAR_" && returnValue != "_CANCEL_")
		{
			RunMethod("ProductManage","addBindRelative","addBindRelative,<%=sTermID%>,"+returnValue+","+"<%=sObjectType%>,"+"<%=sObjectNo%>");
			reloadSelf();
		} 

	}

	function deleterelative()
	{
		var sTermId = getItemValue(0,getRow(),"TERMID");	//���ID
		var sRelativeTermID = getItemValue(0,getRow(),"RELATIVETERMID");//�������ID
        if(typeof(sTermId) == "undefined" || sTermId.length == 0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
            return ;
		}
		
		if(confirm(getHtmlMessage('2'))) //�������ɾ������Ϣ��
		{
			//as_del("myiframe0");
			//as_save("myiframe0");  //�������ɾ������Ҫ���ô����
			RunMethod("ProductManage","deleteRelative","deleteRelative,"+sTermId+","+sRelativeTermID);
			reloadSelf();
		}
	}

</script>
	


<script type="text/javascript">	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>	


<%@ include file="/IncludeEnd.jsp"%>
