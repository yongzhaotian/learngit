<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		ҳ��˵��: ʾ���б�ҳ��
	 */
	String PG_TITLE = "����������";
	
	//ͨ��DWģ�Ͳ���ASDataObject����doTemp
	String sTempletNo = "NoticeList";//����ģ�ͱ��
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
	//��������ʱ��Ϊ�����ؼ�	add by byang CCS-1252������  
	doTemp.setCheckFormat("NoticeDate", "3");
	
	//add by byang CCS-1252	���Ʋ鿴���Ĺ�����Ϊ�����ŵķ����Ĺ���
	doTemp.WhereClause += " and InputOrg = '"+CurUser.getOrgID()+"'";
	
    //doTemp.WhereClause = " where SI.Status not in ('01','02','04')";

	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
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
		{"true","","Button","����","�鿴/�޸�����","viewAndEdit()",sResourcesPath},
		{"true","","Button","ɾ��","ɾ����ѡ�еļ�¼","deleteRecord()",sResourcesPath},
	};
	
	//���ڿ��Ƶ��а�ť��ʾ��������  
	String iButtonsLineMax = "5";
	CurPage.setAttribute("ButtonsLineMax",iButtonsLineMax);
			
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">

	<%/*~[Describe=���� */%>
	function newRecord(){//CCS-960,����jsp�����ı��༭��  update huzp 20150804
		//AsControl.OpenView("/Common/WorkFlow/NoticeInfo.jsp","","_self","");
		AsControl.OpenView("/Common/WorkFlow/EditorNoticeInfo.jsp","","_self","");
	}
	<%/*~[Describe=�鿴�޸�  */%>
	function viewAndEdit(){
		var sNoticeId = getItemValue(0,getRow(),"NoticeId");
		if (typeof(sNoticeId)=="undefined" || sNoticeId.length==0){
			alert("��ѡ��һ����¼��");
			return;
		}//CCS-960,����jsp�����ı��༭��  update huzp 20150804
		//AsControl.OpenView("/Common/WorkFlow/NoticeInfo.jsp","NoticeId="+sNoticeId,"_self","");
		  AsControl.OpenView("/Common/WorkFlow/EditorNoticeInfo.jsp","NoticeId="+sNoticeId,"_self","");

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