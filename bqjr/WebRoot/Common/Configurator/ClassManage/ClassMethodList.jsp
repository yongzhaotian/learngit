<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		Content:�༰�����б�
	 */
	String PG_TITLE = "�༰�����б�"; // ��������ڱ��� <title> PG_TITLE </title>
    //����������	
	String sClassName =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ClassName"));
    if (sClassName == null) sClassName = "";
 
//ͨ��DWģ�Ͳ���ASDataObject����doTemp
	String sTempletNo = "ClassMethodList";//ģ�ͱ��
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	//��ѯ
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	if(sClassName!=null && !sClassName.equals("")){
		doTemp.WhereClause  += " And ClassName='"+sClassName+"'";
	}
	/*
	else{
		if(!doTemp.haveReceivedFilterCriteria()) doTemp.WhereClause  += " And 1=2";
	}*/
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.setPageSize(200);

	//��������¼�
	dwTemp.setEvent("BeforeDelete","!Configurator.DelClassMethod(#ClassName)");
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{(sClassName.equals("")?"false":"true"),"","Button","����","����һ����¼","newRecord()",sResourcesPath},
		{"true","","Button","����","�鿴/�޸�����","viewAndEdit()",sResourcesPath},
		{"true","","Button","ɾ��","ɾ����ѡ�еļ�¼","deleteRecord()",sResourcesPath}
	};
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
	var sCurCodeNo=""; //��¼��ǰ��ѡ���еĴ����

	function newRecord(){
		sReturn=popComp("ClassMethodInfo","/Common/Configurator/ClassManage/ClassMethodInfo.jsp","","");
		reloadSelf();
	}
	
	function viewAndEdit(){
       var sClassName = getItemValue(0,getRow(),"ClassName");
       var sMethodName = getItemValue(0,getRow(),"MethodName");
       if(typeof(sClassName)=="undefined" || sClassName.length==0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return ;
		}
    	popComp("ClassMethodInfo","/Common/Configurator/ClassManage/ClassMethodInfo.jsp","ClassName="+sClassName+"&MethodName="+sMethodName,"");
		reloadSelf();
	}
    
	function saveRecord(){
		as_save("myiframe0","");
	}

    /*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=��;]~*/
	function viewAndEdit2(){
       var sClassName = getItemValue(0,getRow(),"ClassName");
       var sClassDescribe = getItemValue(0,getRow(),"ClassDescribe");
       if(typeof(sClassName)=="undefined" || sClassName.length==0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return ;
		}
	    popComp("ClassMethodList","/Common/Configurator/ClassManage/ClassMethodList.jsp","ClassName="+sClassName+"&ClassDescribe="+sClassDescribe,"");        
	}

	function deleteRecord(){
		var sClassName = getItemValue(0,getRow(),"ClassName");
       if(typeof(sClassName)=="undefined" || sClassName.length==0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return ;
		}
		
		if(confirm(getHtmlMessage('54'))){
			as_del("myiframe0");
			as_save("myiframe0");  //�������ɾ������Ҫ���ô����
		}
	}
	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>	
<%@ include file="/IncludeEnd.jsp"%>