<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		Content: �༰����Ŀ¼�б�
	 */
	String PG_TITLE = "�༰����Ŀ¼�б�"; // ��������ڱ��� <title> PG_TITLE </title>
	//�������
	String sSql;
  	//����������	
	String sClassName =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ClassName"));   //����
	String sClassDescribe =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ClassDescribe"));  //������
	if (sClassName == null) sClassName = "";
	if (sClassName == null) sClassDescribe = "";
 	
 	
	//ͨ��DWģ�Ͳ���ASDataObject����doTemp
	String sTempletNo = "ClassCatalogList";//ģ�ͱ��
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));

	if(sClassName!=null && !sClassName.equals("")){
		doTemp.WhereClause+=" AND ClassName='"+sClassName+"'";
	}
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.setPageSize(200);

	//��������¼�
	dwTemp.setEvent("BeforeDelete","!Configurator.DelClassMethod(#ClassName)");
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sClassName+","+sClassDescribe);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	
	String sButtons[][] = {
		{"true","","Button","����","����һ����¼","newRecord()",sResourcesPath},
		{"true","","Button","����","�鿴/�޸�����","viewAndEdit()",sResourcesPath},
		{"false","","Button","����","�����޸�","saveRecord()",sResourcesPath},
		{"true","","Button","�����б�","�鿴/�޸ĸ����Ӧ�����б�","viewAndEdit2()",sResourcesPath},
		{"true","","Button","ɾ��","ɾ����ѡ�еļ�¼","deleteRecord()",sResourcesPath}
	};
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
	function newRecord(){
       sReturn=popComp("ClassCatalogInfo","/Common/Configurator/ClassManage/ClassCatalogInfo.jsp","","");
       if (typeof(sReturn)!='undefined' && sReturn.length!=0){
			//�������ݺ�ˢ���б�
			if (typeof(sReturn)!='undefined' && sReturn.length!=0){
				sReturnValues = sReturn.split("@");
				if (sReturnValues[0].length !=0 && sReturnValues[1]=="Y"){
					OpenPage("/Common/Configurator/ClassManage/ClassCatalogList.jsp","_self","");    
		        }
			}
        }
	}
	
    /*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=��;]~*/
	function viewAndEdit(){
       var sClassName = getItemValue(0,getRow(),"ClassName");
       var sClassDescribe = getItemValue(0,getRow(),"ClassDescribe");
       if(typeof(sClassName)=="undefined" || sClassName.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return ;
		}
       sReturn=popComp("ClassCatalogInfo","/Common/Configurator/ClassManage/ClassCatalogInfo.jsp","ClassName="+sClassName+"&ClassDescribe="+sClassDescribe,"");
       if (typeof(sReturn)!='undefined' && sReturn.length!=0){
			//�������ݺ�ˢ���б�
			if (typeof(sReturn)!='undefined' && sReturn.length!=0){
				sReturnValues = sReturn.split("@");
				if (sReturnValues[0].length !=0 && sReturnValues[1]=="Y"){
					OpenPage("/Common/Configurator/ClassManage/ClassCatalogList.jsp","_self","");    
				}
			}
		}       
	}
    
	function saveRecord(){
		as_save("myiframe0","");
	}

    /*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=��;]~*/
	function viewAndEdit2(){
       var sClassName = getItemValue(0,getRow(),"ClassName");
       var sClassDescribe = getItemValue(0,getRow(),"ClassDescribe");
       if(typeof(sClassName)=="undefined" || sClassName.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return ;
		}
		popComp("ClassMethodList","/Common/Configurator/ClassManage/ClassMethodList.jsp","ClassName="+sClassName+"&ClassDescribe="+sClassDescribe,"");        
	}

	function deleteRecord(){
		var sClassName = getItemValue(0,getRow(),"ClassName");
		if(typeof(sClassName)=="undefined" || sClassName.length==0) {
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