<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		Content: ���񱨱�ģ���б�
	 */
	String PG_TITLE = "���񱨱�ģ���б�"; // ��������ڱ��� <title> PG_TITLE </title>
	
	String sModelNo =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ModelNo"));
	if (sModelNo == null) 	sModelNo = "";
	
	String sTempletNo = "ReportModelList"; //ģ����
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
    doTemp.appendHTMLStyle("Col1Def,Col2Def,Col3Def,Col4Def","style=\"cursor: pointer;\" onDBLClick=\"parent.myDBLClick(this)\"");
	//doTemp.appendHTMLStyle("RowSubjectName","style=\"cursor: pointer;\" onDBLClick=\"parent.SelectSubject()\"");
	
	//��ѯ
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.setPageSize(50);
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sModelNo);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	
	String sButtons[][] = {
		{"true","","Button","����","����һ����¼","newRecord()",sResourcesPath},
		{"true","","Button","����","�鿴/�޸�����","viewAndEdit()",sResourcesPath},
		{"true","","Button","����","�����޸�","saveRecord()",sResourcesPath},
		{"true","","Button","ɾ��","ɾ����ѡ�еļ�¼","deleteRecord()",sResourcesPath},
		{"true","","Button","����/���¹�ʽ����","��ʽ�����Ľ�������/���µ�formulaexp�ֶ���","genExplain()",sResourcesPath}
	};
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
	function newRecord(){
		var sReturn=popComp("ReportModelInfo","/Common/Configurator/ReportManage/ReportModelInfo.jsp","ModelNo=<%=sModelNo%>","");
        //�޸����ݺ�ˢ���б�
		if (typeof(sReturn)!='undefined' && sReturn.length!=0){
			sReturnValues = sReturn.split("@");
			if (sReturnValues[0].length !=0 && sReturnValues[1]=="Y"){
				OpenPage("/Common/Configurator/ReportManage/ReportModelList.jsp?ModelNo="+sReturnValues[0],"_self","");           
            }
        }
	}
    
	function saveRecord(){
		as_save("myiframe0","");
	}

	function myDBLClick(myobj){
        editObjectValueWithScriptEditorForAFS(myobj,'<%=sModelNo%>');
    }

	function viewAndEdit(){
		var sModelNo = getItemValue(0,getRow(),"ModelNo");
		var sRowNo = getItemValue(0,getRow(),"RowNo");
		if(typeof(sModelNo)=="undefined" || sModelNo.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return ;
		}
		sReturn=popComp("ReportModelInfo","/Common/Configurator/ReportManage/ReportModelInfo.jsp","ModelNo="+sModelNo+"&RowNo="+sRowNo,"");
        //�޸����ݺ�ˢ���б�
		if (typeof(sReturn)!='undefined' && sReturn.length!=0){
			sReturnValues = sReturn.split("@");
			if (sReturnValues[0].length !=0 && sReturnValues[1]=="Y"){
				OpenPage("/Common/Configurator/ReportManage/ReportModelList.jsp?ModelNo="+sReturnValues[0],"_self","");           
            }
        }
	}

	function deleteRecord(){
		var sRowNo = getItemValue(0,getRow(),"RowNo");
		if(typeof(sRowNo)=="undefined" || sRowNo.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return ;
		}
		
		if(confirm(getHtmlMessage('2'))){
			as_del("myiframe0");
			as_save("myiframe0");  //�������ɾ������Ҫ���ô����
		}
	}
	
	function genExplain(){
		var sReturn = RunMethod("Configurator","GenFinStmtExplain","<%=sModelNo%>");
		if(typeof(sReturn)!="undefined" && sReturn=="succeeded"){
			alert("�ѽ���ʽ�����Ľ�������/���µ�formulaexp1��formulaexp2�ֶ��С�");
		}else{
			alert(sReturn);
		}
	}

	function SelectSubject(){
		setObjectValue("SelectAllSubject","","@RowSubject@0@RowSubjectName@1",0,0,"");			
	}
	
	AsOne.AsInit();
	init();
	var bHighlightFirst = true;//�Զ�ѡ�е�һ����¼
	my_load(2,0,'myiframe0');
</script>	
<%@ include file="/IncludeEnd.jsp"%>