<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		Content: ������ģ���б�
	 */
	String PG_TITLE = "������ģ���б�"; // ��������ڱ��� <title> PG_TITLE </title>
	
    //����������	
	String sModelNo =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ModelNo"));
    if (sModelNo == null)	sModelNo = "";

 	
 	//ͨ��DWģ�Ͳ���ASDataObject����doTemp
 	String sTempletNo = "ClassifyModelList";//ģ�ͱ��
 	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
 		
	//��ѯ
 //	doTemp.setColumnAttribute("ModelNo","IsFilter","1");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	//if(!doTemp.haveReceivedFilterCriteria()) doTemp.WhereClause+=" and 1=2";
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.setPageSize(200);
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sModelNo);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	
	String sButtons[][] = {
		{"true","","Button","����","����һ����¼","newRecord()",sResourcesPath},
		{"true","","Button","����","�鿴/�޸�����","viewAndEdit()",sResourcesPath},
		{"true","","Button","ɾ��","ɾ����ѡ�еļ�¼","deleteRecord()",sResourcesPath},
	};
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
	function newRecord(){
		var sReturn=popComp("ClassifyModelInfo","/Common/Configurator/ClassifyManage/ClassifyModelInfo.jsp","ModelNo=<%=sModelNo%>","");
        //�޸����ݺ�ˢ���б�
		if (typeof(sReturn)!='undefined' && sReturn.length!=0){
			sReturnValues = sReturn.split("@");
			if (sReturnValues[0].length !=0 && sReturnValues[1]=="Y"){
				OpenPage("/Common/Configurator/ClassifyManage/ClassifyModelList.jsp?ModelNo="+sReturnValues[0],"_self","");           
            }
        }
	}
	
	function viewAndEdit(){
		var sModelNo = getItemValue(0,getRow(),"ModelNo");
		var sGroupNo = getItemValue(0,getRow(),"GroupNo");
		var sConditionNo = getItemValue(0,getRow(),"ConditionNo");
		var sStatus = getItemValue(0,getRow(),"Status");
       if(typeof(sGroupNo)=="undefined" || sGroupNo.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return ;
		}
		sReturn=popComp("ClassifyModelInfo","/Common/Configurator/ClassifyManage/ClassifyModelInfo.jsp","ModelNo="+sModelNo+"~GroupNo="+sGroupNo+"~ConditionNo="+sConditionNo+"~Status="+sStatus,"");
        //�޸����ݺ�ˢ���б�
		if (typeof(sReturn)!='undefined' && sReturn.length!=0){
			sReturnValues = sReturn.split("@");
			if (sReturnValues[0].length !=0 && sReturnValues[1]=="Y"){
				OpenPage("/Common/Configurator/ClassifyManage/ClassifyModelList.jsp?ModelNo="+sReturnValues[0],"_self","");           
            }
        }
	}

	function deleteRecord(){
		var sGroupNo = getItemValue(0,getRow(),"GroupNo");
		if(typeof(sGroupNo)=="undefined" || sGroupNo.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return ;
		}
		
		if(confirm(getHtmlMessage('2'))){
			as_del("myiframe0");
			as_save("myiframe0");  //�������ɾ������Ҫ���ô����
		}
	}
	
    function doReturn(sIsRefresh){
		sObjectNo = getItemValue(0,getRow(),"ModelNo");
       parent.sObjectInfo = sObjectNo+"@"+sIsRefresh;
		parent.closeAndReturn();
	}

	AsOne.AsInit();
	init();
	var bHighlightFirst = true;//�Զ�ѡ�е�һ����¼
	my_load(2,0,'myiframe0');
</script>	
<%@ include file="/IncludeEnd.jsp"%>