<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		Content: �����Ŀ�б�
	 */
	String PG_TITLE = "�����Ŀ�б�"; // ��������ڱ��� <title> PG_TITLE </title>
	String sTempletNo = "FinanceItemList"; //ģ����
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
	//��ѯ
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	//if(!doTemp.haveReceivedFilterCriteria()) doTemp.WhereClause+=" and 1=2";
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.setPageSize(50);

	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	
	/*
	String sCriteriaAreaHTML = "<table><form action=''><tr>"
		+"<input type=hidden name=CompClientID value='"+sCompClientID+"'>"
		+"<td>CodeNo:</td><td><input type=text name=CodeNo value='"+sCodeNo+"'></td> "
		+"<td>CodeName:</td><td><input type=text name=CodeName value='"+sCodeName+"'></td> "
		+"<td><input type=submit value=��ѯ></td>"
		+"</tr></form></table>"; 
	*/

	String sButtons[][] = {
		{"true","","Button","����","����һ����¼","newRecord()",sResourcesPath},
		{"true","","Button","����","�鿴/�޸�����","viewAndEdit()",sResourcesPath},
		{"true","","Button","ɾ��","ɾ����ѡ�еļ�¼","deleteRecord()",sResourcesPath}
	};
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
	function newRecord(){
		var sReturn=popComp("FinanceItemInfo","/Common/Configurator/ReportManage/FinanceItemInfo.jsp","","");
		if (typeof(sReturn)!='undefined' && sReturn.length!=0){
            //�������ݺ�ˢ���б�
			if (typeof(sReturn)!='undefined' && sReturn.length!=0){
				sReturnValues = sReturn.split("@");
				if (sReturnValues[0].length !=0 && sReturnValues[1]=="Y"){
					OpenPage("/Common/Configurator/ReportManage/FinanceItemList.jsp","_self","");    
                }
            }
        }
	}
	
	function viewAndEdit(){
		var sItemNo = getItemValue(0,getRow(),"ItemNo");
		if(typeof(sItemNo)=="undefined" || sItemNo.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return ;
		}
		sReturn=popComp("FinanceItemInfo","/Common/Configurator/ReportManage/FinanceItemInfo.jsp","ItemNo="+sItemNo,"");
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
	
	AsOne.AsInit();
	init();
	var bHighlightFirst = true;//�Զ�ѡ�е�һ����¼
	my_load(2,0,'myiframe0');
</script>	
<%@ include file="/IncludeEnd.jsp"%>