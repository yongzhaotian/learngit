<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		ҳ��˵��: ʾ���б�ҳ��
	 */
	String PG_TITLE = "Ԥ����Ϣ";
	
	//ͨ��DWģ�Ͳ���ASDataObject����doTemp
	String sTempletNo = "PretrialInfoList";//ģ�ͱ��
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
    doTemp.WhereClause = " where State ='001' and inputuserid='"+CurUser.getUserID()+"'";
    
  	
    
	doTemp.generateFilters(Sqlca);
	//���ƵǼ����ڲ�ѯ����ѡ��
  	doTemp.setFilter(Sqlca, "0350", "InputDate", "Operators=BetweenString,BeginsWith;");
	doTemp.parseFilterData(request,iPostChange);

	// û�������κ�������ֻ�ܲ�ѯ��ѯ��������
	if(!doTemp.haveReceivedFilterCriteria()) {
		doTemp.WhereClause += " and (to_date(to_char(SYSDATE,'YYYY/MM/DD'),'YYYY/MM/DD')-to_date(to_char(to_date(InputDate,'YYYY/MM/DD HH24:MI:SS'),'YYYY/MM/DD'),'YYYY/MM/DD'))=0";
	} else {
		//�������κ�������ֻ�ܲ�ѯ3�����ڵ�����
	    doTemp.WhereClause += " and months_between(to_date(to_char(SYSDATE,'YYYY/MM/DD'),'YYYY/MM/DD'),to_date(to_char(to_date(InputDate,'YYYY/MM/DD HH24:MI:SS'),'YYYY/MM/DD'),'YYYY/MM/DD'))<=3";
	}
	
	//���������ַ�����
	for(int k=0;k<doTemp.Filters.size();k++){
		
		//��������������ܺ���%��_����
		if(doTemp.Filters.get(k).sFilterInputs[0][1] != null 
				&& (doTemp.Filters.get(k).sFilterInputs[0][1].contains("%") 
				|| doTemp.Filters.get(k).sFilterInputs[0][1].contains("_")
				|| doTemp.Filters.get(k).sFilterInputs[0][1].contains("#")
				|| doTemp.Filters.get(k).sFilterInputs[0][1].contains("$"))){
			%>
			<script type="text/javascript">
				alert("������������ܺ���['%'��'_'��'#'��'$']����!");
			</script>
			<%
			doTemp.WhereClause+=" and 1=2";
			break;
		}
	}
	
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.setPageSize(10);//���÷�ҳ����
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{"true","","Button","����","����һ����¼","newRecord()",sResourcesPath},
		{"false","","Button","����","�鿴/�޸�����","viewAndEdit()",sResourcesPath},
		{"false","","Button","ɾ��","ɾ����ѡ�еļ�¼","deleteRecord()",sResourcesPath},
	};
	
	//���ڿ��Ƶ��а�ť��ʾ��������  
	String iButtonsLineMax = "5";
	CurPage.setAttribute("ButtonsLineMax",iButtonsLineMax);
			
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">

	<%/*~[Describe=���� */%>
	function newRecord(){
		AsControl.OpenView("/Common/WorkFlow/PretrialInfo.jsp","","_self","");
	}
	<%/*~[Describe=�鿴�޸�  */%>
	function viewAndEdit(){

	}
	<%/*~[Describe=ɾ��  */%>
	function deleteRecord(){
		var sNoticeId = getItemValue(0,getRow(),"NoticeId");
		if (typeof(sNoticeId)=="undefined" || sNoticeId.length==0){
			alert("��ѡ��һ����¼��");
			return;
		}
		
		if(confirm("�������ɾ������Ϣ��")){
			as_del("myiframe0");
			as_save("myiframe0");  //�������ɾ������Ҫ���ô����
		}
		reloadSelf();
	}
	
	<%/*~[Describe=ʹ��ObjectViewer��;InputParam=��;OutPutParam=��;]~*/%>
	$(document).ready(function(){
		AsOne.AsInit();
		showFilterArea();
		init();
		my_load(2,0,'myiframe0');
	});
</script>	
<%@ include file="/IncludeEnd.jsp"%>