<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		Content: ��������Ŀ¼�б�
	 */
	String PG_TITLE = "��������Ŀ¼�б�"; // ��������ڱ��� <title> PG_TITLE </title>
 	
	String sTempletNo = "ObjTypeCatalogList";
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca); 
 
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
    dwTemp.setPageSize(200);

	//��������¼�
	dwTemp.setEvent("BeforeDelete","1+!Configurator.DelObjTypeRelative(#ObjectType)");
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	
	String sButtons[][] = {
		{"true","","Button","����","����һ����¼","newRecord()",sResourcesPath},
		{"false","","Button","����","�鿴/�޸�����","as_save('myiframe0')",sResourcesPath},
		{"true","","Button","����","�鿴/�޸�����","viewAndEdit()",sResourcesPath},
		{"false","","Button","�������Ͳ㼶�б�","�鿴/�޸Ķ������Ͳ㼶�б�","viewAndEdit2()",sResourcesPath},
		{"false","","Button","���������б�","�鿴/�޸Ķ��������б�","viewAndEdit3()",sResourcesPath},
		{"true","","Button","ɾ��","ɾ����ѡ�еļ�¼","deleteRecord()",sResourcesPath}
	};
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
	function newRecord(){
		sReturn=popComp("ObjTypeCatalogInfo","/Common/Configurator/ObjectManage/ObjTypeCatalogInfo.jsp","","");
		if (typeof(sReturn)!='undefined' && sReturn.length!=0){
            //�������ݺ�ˢ���б�
			if (typeof(sReturn)!='undefined' && sReturn.length!=0){
				sReturnValues = sReturn.split("@");
				if (sReturnValues[0].length !=0 && sReturnValues[1]=="Y"){
					OpenPage("/Common/Configurator/ObjectManage/ObjTypeCatalogList.jsp","_self","");    
                }
            }
        }
	}
	
    /*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=��;]~*/
	function viewAndEdit(){
		var sObjectType = getItemValue(0,getRow(),"ObjectType");
		if(typeof(sObjectType)=="undefined" || sObjectType.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return ;
		}
       popComp("ObjectTypeView","/Common/Configurator/ObjectManage/ObjTypeCatalogView.jsp","ObjectNo="+sObjectType,"");
	}
    
    /*~[Describe=�鿴���޸Ķ������Ͳ㼶�б�;InputParam=��;OutPutParam=��;]~*/
	function viewAndEdit2(){
		var sObjectType = getItemValue(0,getRow(),"ObjectType");
		if(typeof(sObjectType)=="undefined" || sObjectType.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return ;
		}
       popComp("ObjTypeLevelList","/Common/Configurator/ObjectManage/ObjTypeLevelList.jsp","ObjectType="+sObjectType,"");
	}

    /*~[Describe=�鿴���޸Ķ��������б�;InputParam=��;OutPutParam=��;]~*/
	function viewAndEdit3(){
		var sObjectType = getItemValue(0,getRow(),"ObjectType");
		if(typeof(sObjectType)=="undefined" || sObjectType.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return ;
		}
		popComp("ObjTypeAttributeList","/Common/Configurator/ObjectManage/ObjTypeAttributeList.jsp","ObjectType="+sObjectType,"");
	}
	
	function deleteRecord(){
		var sObjectType = getItemValue(0,getRow(),"ObjectType");
		if(typeof(sObjectType)=="undefined" || sObjectType.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return ;
		}
		
		if(confirm(getHtmlMessage('45'))){
			as_del("myiframe0");
			as_save("myiframe0");  //�������ɾ������Ҫ���ô����
		}
	}
	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>	
<%@ include file="/IncludeEnd.jsp"%>