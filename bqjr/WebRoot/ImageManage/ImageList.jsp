<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		ҳ��˵��: ʾ���б�ҳ��
	 */
	String PG_TITLE = "Ӱ���б�";
	//���ҳ�����
	
	//ͨ��DWģ�Ͳ���ASDataObject����doTemp
	String sTempletNo = "ImageList";//ģ�ͱ��
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);

	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.setPageSize(20);

	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow( "" );
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{"true","","Button","�鿴","�鿴��¼","imageManage()",sResourcesPath},
		{"true","","Button","�޸ı�ע","�޸ı�ע","remark()",sResourcesPath},
	};
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
	
    /*~[Describe=Ӱ�����;InputParam=��;OutPutParam=��;]~*/
    function imageManage(){
    	var sObjectType   = getItemValue(0,getRow(),"OBJECTTYPE");
    	var sObjectNo   = getItemValue(0,getRow(),"OBJECTNO");
    	var typeNo = getItemValue(0,getRow(),"TYPENO");
        if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
            alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
            return;
        }
     var param = "ObjectType="+sObjectType+"&ObjectNo="+sObjectNo+"&TypeNo="+typeNo;
     //alert(param);return;
     AsControl.PopView( "/ImageManage/ImageView.jsp", param, "" );
     reloadSelf();
    }
    /*�޸ı�ע*/
    function remark() {
    	var sObjectType   = getItemValue(0,getRow(),"OBJECTTYPE");
    	var sObjectNo   = getItemValue(0,getRow(),"OBJECTNO");
    	var typeNo = getItemValue(0,getRow(),"TYPENO");
    	var pageNum = getItemValue(0,getRow(),"PAGENUM");
        if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
            alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
            return;
        }
        var param = "ObjectType="+sObjectType+"&ObjectNo="+sObjectNo+"&TypeNo="+typeNo+"&PageNum="+pageNum;
        AsControl.PopView( "/ImageManage/ImageInfo.jsp", param, "dialogwidth=500px;dialogheight=600px;" );
        reloadSelf();
    }
	
	$(document).ready(function(){
		AsOne.AsInit();
		init();
		my_load(2,0,'myiframe0');
	});
</script>	
<%@ include file="/IncludeEnd.jsp"%>
