<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		Content: ��ʽ�����涨���б�
	 */
	String PG_TITLE = "��ʽ�����涨���б�"; // ��������ڱ��� <title> PG_TITLE </title>
	
	//���ҳ�����	
	String sDocID =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("DocID"));
	if(sDocID == null) sDocID = "";
	
	String[][] sHeaders={
			{"DocID","������"},
			{"DirID","�ڵ���"},
			{"DirName","�ڵ�����"},
			{"JspFileName","JSP�ļ�"},
		};

	String sSql =  " select DocID,DirID,DirName,JspFileName from FormatDoc_Def where 1=1";
	if (!sDocID.equals("")){
		sSql += " and DocID='"+sDocID+"'";
	}
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.UpdateTable="FormatDoc_Def";
	doTemp.setKey("DocID,DirID",true);
	doTemp.setHeader(sHeaders);

	doTemp.setHTMLStyle("DocID,DirID"," style={width:50px} ");
	doTemp.setHTMLStyle("DirName,JspFileName"," style={width:180px} ");

	//��ѯ
 	doTemp.setColumnAttribute("DocID,DirID,DirName","IsFilter","1");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	doTemp.OrderClause = "Order by DocID,DirID asc";
	
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
		{"true","","Button","ɾ��","ɾ����ѡ�еļ�¼","deleteRecord()",sResourcesPath}
	};
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
	function newRecord(){
		sReturn=popComp("FormatdocDefInfo","/Common/Configurator/FormatDocManage/FormatdocDefInfo.jsp","DocID=<%=sDocID%>","");
		if (typeof(sReturn)!='undefined' && sReturn.length!=0){
            //�������ݺ�ˢ���б�
			if (typeof(sReturn)!='undefined' && sReturn.length!=0){
				sReturnValues = sReturn.split("@");
				if (sReturnValues[0].length !=0 && sReturnValues[1]=="Y"){
					OpenPage("/Common/Configurator/FormatDocManage/FormatdocDefList.jsp","_self","");    
                }
            }
        }
	}
	
    /*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=��;]~*/
	function viewAndEdit(){
		var sDocID = getItemValue(0,getRow(),"DocID");
		var sDirID = getItemValue(0,getRow(),"DirID");
		if(typeof(sDocID)=="undefined" || sDocID.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return ;
		}
       //openObject("FlowCatalogView",sFlowNo,"001");
       popComp("FormatdocDefInfo","/Common/Configurator/FormatDocManage/FormatdocDefInfo.jsp","DocID="+sDocID+"&DirID="+sDirID,"");
	}

	function deleteRecord(){
		var sDocID = getItemValue(0,getRow(),"DocID");
		if(typeof(sDocID)=="undefined" || sDocID.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
            return ;
		}
		
		if(confirm(getHtmlMessage('68'))){
			as_del("myiframe0");
			as_save("myiframe0");  //�������ɾ������Ҫ���ô����
		}
	}
	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>	
<%@ include file="/IncludeEnd.jsp"%>