<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		Content: ������б�
		Input Param:
                    CodeNo��    �������
	 */
	String PG_TITLE = "������б�"; // ��������ڱ��� <title> PG_TITLE </title>
	
	//����������	
	String sCodeNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("CodeNo"));   
	if(sCodeNo==null) sCodeNo="";
	String sCodeName =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("CodeName"));   
	if(sCodeName==null) sCodeName="";
	String sDiaLogTitle = "��"+sCodeName+"�����룺��"+sCodeNo+"������";

	
	
	//ͨ��DWģ�Ͳ���ASDataObject����doTemp
	String sTempletNo = "CodeItemList";//ģ�ͱ��
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));

	if(sCodeNo!=null && !sCodeNo.equals("")){
		doTemp.WhereClause+=" And CodeNo='"+sCodeNo+"'";
	}
	/*
	else{
		if(!doTemp.haveReceivedFilterCriteria()) doTemp.WhereClause  += " And 1=2";
	}
	*/
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.setPageSize(200);
	dwTemp.setEvent("AfterUpdate","!Configurator.UpdateCodeCatalogUpdateTime("+StringFunction.getTodayNow()+","+CurUser.getUserID()+",#CodeNo)");
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));	
	//out.println(doTemp.SourceSql);

	String sButtons[][] = {
		{(sCodeNo.equals("")?"false":"true"),"","Button","����","����һ����¼","newRecord()",sResourcesPath},
		{"true","","Button","����","�鿴/�޸�����","viewAndEdit()",sResourcesPath},		
		{"true","","Button","ɾ��","ɾ����ѡ�еļ�¼","deleteRecord()",sResourcesPath}
	};
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
	function newRecord(){
       sReturn=popComp("CodeItemInfo","/Common/Configurator/CodeManage/CodeItemInfo.jsp","CodeNo=<%=sCodeNo%>&CodeName=<%=sCodeName%>","");
       if (typeof(sReturn)!='undefined' && sReturn.length!=0){
            //�������ݺ�ˢ���б�
			sReturnValues = sReturn.split("@");
			if (sReturnValues[0].length !=0 && sReturnValues[1]=="Y"){
				reloadSelf();
            }
        }
	}
	
	function viewAndEdit(){
		var sCodeNo = getItemValue(0,getRow(),"CodeNo");
		var sItemNo = getItemValue(0,getRow(),"ItemNo");
       if(typeof(sCodeNo)=="undefined" || sCodeNo.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return ;
		}
        
       popComp("CodeItemInfo","/Common/Configurator/CodeManage/CodeItemInfo.jsp","CodeName=<%=sCodeName%>&CodeNo="+sCodeNo+"~ItemNo="+sItemNo,"");
		reloadSelf();
	}
	
	function deleteRecord(){
		var sCodeNo = getItemValue(0,getRow(),"CodeNo");
       if(typeof(sCodeNo)=="undefined" || sCodeNo.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return ;
		}
		
		if(confirm(getHtmlMessage('2'))){
			as_del("myiframe0");
			as_save("myiframe0");  //�������ɾ������Ҫ���ô����
		}
	}
	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	ssCodeNo = "<%=sCodeNo%>"
	if(typeof(ssCodeNo)=="undefined" || ssCodeNo.length==0){
    //��sCodeNo ��ʱ��ҳ��δ����ģ̬���� Remark by wuxiong 2005-02-23
	}else{
     	setDialogTitle("<%=sDiaLogTitle%>");
    }
//add by byhu Ĭ����ʾfilter������ѯ����ʾ
<%
    if(!doTemp.haveReceivedFilterCriteria()) {
%>
	showFilterArea();
<%
	}	
%>
</script>
<%@ include file="/IncludeEnd.jsp"%>
