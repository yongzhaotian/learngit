<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%
	//��ò���	
	String sObjectType =  CurPage.getParameter("ObjectType");
	if(sObjectType==null) sObjectType="";
	
	ASObjectModel doTemp = new ASObjectModel("AppBizObjectRelaList");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.setPageSize(20);
	
	//����HTMLDataWindow
	dwTemp.genHTMLObjectWindow(sObjectType);

	String sButtons[][] = {
		{"true","All","Button","����","����һ����¼","newRecord()","","","","btn_icon_add"},
		{"true","All","Button","ɾ��","ɾ����ѡ�еļ�¼","deleteRecord()","","","","btn_icon_delete"},
	};
%><%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	/*~[Describe=������¼;]~*/
	function newRecord(){
        OpenPage("/AppConfig/AppBizManage/AppBizObjectRelaInfo.jsp?ObjectType=<%=sObjectType%>","frameright","");  
	}

    /*~[Describe=�鿴���޸�����;]~*/
	function mySelectRow(){
		var sRelationShip = getItemValue(0,getRow(),"RelationShip");
		if(typeof(sRelationShip)=="undefined" || sRelationShip.length==0){
			OpenPage("/AppMain/Blank.jsp","frameright");
		}else{
	      	OpenPage("/AppConfig/AppBizManage/AppBizObjectRelaInfo.jsp?ObjectType=<%=sObjectType%>&RelationShip="+sRelationShip,"frameright"); 
		}
	}
    
	/*~[Describe=ɾ����¼;]~*/
	function deleteRecord(){
		var sRelationShip = getItemValue(0,getRow(),"RelationShip");
		if(typeof(sRelationShip)=="undefined" || sRelationShip.length==0){
			alert(getMessageText('AWEW1001'));//��ѡ��һ����Ϣ��
	      return ;
		}
		if(confirm("��ȷ��ɾ���ü�¼��")){
			as_delete("myiframe0","");
		}
		
	}
	mySelectRow();
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>