<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		Content: �������������б�
	 */
	String PG_TITLE = "�������������б�"; // ��������ڱ��� <title> PG_TITLE </title>
	
    //���ҳ�����	
	String sObjectType =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectType"));
	if (sObjectType == null) sObjectType = "";
	
	String sTempletNo = "ObjTypeAttributeList";
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca); 
			
    
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.setPageSize(200);
    
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	
	String sButtons[][] = {
		{"true","","Button","����","����һ����¼","newRecord()",sResourcesPath},
		{"true","","Button","����","�鿴/�޸�����","viewAndEdit()",sResourcesPath},
		{"true","","Button","ɾ��","ɾ����ѡ�еļ�¼","deleteRecord()",sResourcesPath},
	};
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
	function newRecord(){
		sReturn=popComp("ObjTypeAttributeInfo","/Common/Configurator/ObjectManage/ObjTypeAttributeInfo.jsp","ObjectType=<%=sObjectType%>","");
        //�޸����ݺ�ˢ���б�
		if (typeof(sReturn)!='undefined' && sReturn.length!=0){
			sReturnValues = sReturn.split("@");
			if (sReturnValues[0].length !=0 && sReturnValues[1]=="Y"){
				OpenPage("/Common/Configurator/ObjectManage/ObjTypeAttributeList.jsp?ObjectType="+sReturnValues[0],"_self","");           
            }
        }
	}
	
	function viewAndEdit(){
		var sObjectType = getItemValue(0,getRow(),"ObjectType");
		var sAttributeID = getItemValue(0,getRow(),"AttributeID");
		if(typeof(sAttributeID)=="undefined" || sAttributeID.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return ;
		}
		sReturn=popComp("ObjTypeAttributeInfo","/Common/Configurator/ObjectManage/ObjTypeAttributeInfo.jsp","ObjectType="+sObjectType+"&AttributeID="+sAttributeID,"");
        //�޸����ݺ�ˢ���б�
		if (typeof(sReturn)!='undefined' && sReturn.length!=0){
			sReturnValues = sReturn.split("@");
			if (sReturnValues[0].length !=0 && sReturnValues[1]=="Y"){
				OpenPage("/Common/Configurator/ObjectManage/ObjTypeAttributeList.jsp?ObjectType="+sReturnValues[0],"_self","");           
            }
        }
	}

	function deleteRecord(){
		var sAttributeID = getItemValue(0,getRow(),"AttributeID");
		if(typeof(sAttributeID)=="undefined" || sAttributeID.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return ;
		}
		
		if(confirm(getHtmlMessage('2'))){
			as_del("myiframe0");
			as_save("myiframe0");  //�������ɾ������Ҫ���ô����
		}
	}
	
	function doReturn(sIsRefresh){
		sObjectNo = getItemValue(0,getRow(),"ObjectType");
		parent.sObjectInfo = sObjectNo+"@"+sIsRefresh;
		parent.closeAndReturn();
	}

	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>	
<%@ include file="/IncludeEnd.jsp"%>