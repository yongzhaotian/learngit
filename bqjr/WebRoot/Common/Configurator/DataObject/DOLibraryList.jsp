<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		Content: ���ݶ����б�
	 */
	String PG_TITLE = "���ݶ����б�"; // ��������ڱ��� <title> PG_TITLE </title>

	//����������	��������š��༭Ȩ��
	String sDoNo =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("DoNo"));
   	String sEditRight =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("EditRight"));
	if (sDoNo == null) sDoNo = "";
	if (sEditRight == null) sEditRight = "";
	
	String sTempletNo="DOLibraryList";
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	 
	if(!sDoNo.equals("")){
		doTemp.WhereClause += " and DoNo = '"+sDoNo+"' ";
	} 
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.setPageSize(22);

	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sDoNo);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	
	String sButtons[][] = {
		{"true","","Button","����","����һ����¼","newRecord()",sResourcesPath},
		{"true","","Button","����","�鿴/�޸�����","viewAndEdit()",sResourcesPath},
		{"true","","Button","ɾ��","ɾ����ѡ�еļ�¼","deleteRecord()",sResourcesPath}
		};
   	//��Ʒ�������ӹ����ľ�������Щ����
   	if(sEditRight.equals("01")){
		sButtons[0][0]="false";
		sButtons[1][0]="false";
		sButtons[2][0]="false";
    }
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
	function newRecord(){
		sReturn=popComp("DOLibraryInfo","/Common/Configurator/DataObject/DOLibraryInfo.jsp","DoNo=<%=sDoNo%>","");
		reloadSelf();
        //�������ݺ�ˢ���б�
		if (typeof(sReturn)!='undefined' && sReturn.length!=0){
			sReturnValues = sReturn.split("@");
			if (sReturnValues[0].length !=0 && sReturnValues[1]=="Y"){
				OpenPage("/Common/Configurator/DataObject/DOLibraryList.jsp?DoNo="+sReturnValues[0],"_self","");    
            }
         }
	}
	
	function viewAndEdit(){
		var sDoNo = getItemValue(0,getRow(),"DoNo");
		var sColIndex = getItemValue(0,getRow(),"ColIndex");
       if(typeof(sDoNo)=="undefined" || sDoNo.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return ;
		}
        
       sReturn=popComp("DOLibraryInfo","/Common/Configurator/DataObject/DOLibraryInfo.jsp","DoNo="+sDoNo+"~ColIndex="+sColIndex,"");
       reloadSelf();
        //�޸����ݺ�ˢ���б�
       if (typeof(sReturn)!='undefined' && sReturn.length!=0){
			sReturnValues = sReturn.split("@");
			if (sReturnValues[0].length !=0 && sReturnValues[1]=="Y"){
                OpenPage("/Common/Configurator/DataObject/DOLibraryList.jsp?DoNo="+sReturnValues[0],"_self","");    
            }
        }
	}
	
	function deleteRecord(){
		var sDoNo = getItemValue(0,getRow(),"DoNo");
       if(typeof(sDoNo)=="undefined" || sDoNo.length==0) {
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
</script>	
<%@ include file="/IncludeEnd.jsp"%>