<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		Content: ����ģ���б�
	 */
	String PG_TITLE = "����ģ���б�";
	
    //����������	
    String sModelNo =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ModelNo"));
	if (sModelNo == null) sModelNo = "";

	String sTempletNo = "EvaluateModelList";
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
	if(sModelNo!=null && !sModelNo.equals("")){
		doTemp.WhereClause+=" and ModelNo='"+sModelNo+"'";
		doTemp.OrderClause = " order by DisplayNo";
	}
	
	doTemp.appendHTMLStyle("","style=\"cursor: pointer;\" ondblclick=\"javascript:parent.viewAndEdit()\"");
	
	//if(!doTemp.haveReceivedFilterCriteria()) doTemp.WhereClause+=" and 1=2";
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.setPageSize(30);
    
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
    var sCurModelNo=""; //��¼��ǰ��ѡ���еĴ����

	function newRecord(){
		sReturn=popComp("EvaluateModelInfo","/Common/Configurator/EvaluateManage/EvaluateModelInfo.jsp","ModelNo=<%=sModelNo%>","");
        //�޸����ݺ�ˢ���б�
		if (typeof(sReturn)!='undefined' && sReturn.length!=0){
			sReturnValues = sReturn.split("@");
			if (sReturnValues[0].length !=0 && sReturnValues[1]=="Y"){
                OpenPage("/Common/Configurator/EvaluateManage/EvaluateModelList.jsp?ModelNo="+sReturnValues[0],"_self","");           
            }
        }
	}
	
	function viewAndEdit(){
		var sModelNo = getItemValue(0,getRow(),"ModelNo");
       var sItemNo = getItemValue(0,getRow(),"ItemNo");
       if(typeof(sModelNo)=="undefined" || sModelNo.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return ;
		}
		sReturn=popComp("EvaluateModelInfo","/Common/Configurator/EvaluateManage/EvaluateModelInfo.jsp","ModelNo="+sModelNo+"&ItemNo="+sItemNo,"");
        //�޸����ݺ�ˢ���б�
       if (typeof(sReturn)!='undefined' && sReturn.length!=0){
			sReturnValues = sReturn.split("@");
			if (sReturnValues[0].length !=0 && sReturnValues[1]=="Y"){
				OpenPage("/Common/Configurator/EvaluateManage/EvaluateModelList.jsp?ModelNo="+sReturnValues[0],"_self","");           
            }
        }
	}

	function deleteRecord(){
		var sItemNo = getItemValue(0,getRow(),"ItemNo");
       if(typeof(sItemNo)=="undefined" || sItemNo.length==0) {
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