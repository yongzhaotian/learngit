<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%
	ASObjectModel doTemp = new ASObjectModel("AppBizObjectList");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.setPageSize(20);
	//����HTMLDataWindow
	dwTemp.genHTMLObjectWindow("");

	String sButtons[][] = {
		{"true","All","Button","����","����һ����¼","newRecord()","","","","btn_icon_add"},
		{"true","All","Button","ɾ��","ɾ����ѡ�еļ�¼","deleteRecord()","","","","btn_icon_delete"},
		{"true","All","Button","���ö������","���ö������","configObjectRela()","","","",""},
		{"false","All","Button","ˢ�¶���","ˢ�¶���","reloadCache('ҵ�����')","","","",""},
	};
%><%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	<%/*[Describe=������¼;]*/%>
	function newRecord(){
        OpenPage("/AppConfig/AppBizManage/AppBizObjectInfo.jsp","frameright","");  
	}

    <%/*[Describe=�鿴���޸�����;]*/%>
	function mySelectRow(){
		var sObjectType = getItemValue(0,getRow(),"ObjectType");
        if(typeof(sObjectType)=="undefined" || sObjectType.length==0){
			OpenPage("/AppMain/Blank.jsp","frameright");
		}else{
	      	OpenPage("/AppConfig/AppBizManage/AppBizObjectInfo.jsp?ObjectType="+sObjectType,"frameright"); 
		}
	}
    
	<%/*[Describe=ɾ����¼;]*/%>
	function deleteRecord(){
		var sObjectType = getItemValue(0,getRow(),"ObjectType");
        if(typeof(sObjectType)=="undefined" || sObjectType.length==0){
			alert(getMessageText('AWEW1001'));//��ѡ��һ����Ϣ��
	      	return ;
		}
		if(confirm("ɾ���ü�¼��ͬʱɾ���������ϵ��\n��ȷ��ɾ����")){
			as_delete("myiframe0","");
		}
	}
	
	<%/*[Describe=���ö������;]*/%>
	function configObjectRela(){
		var sObjectType = getItemValue(0,getRow(),"ObjectType");
        if(typeof(sObjectType)=="undefined" || sObjectType.length==0){
            alert(getMessageText('AWEW1001'));//��ѡ��һ����Ϣ��
        }else{
           sReturn=AsControl.PopView("/AppConfig/AppBizManage/AppBizObjectRelaFrame.jsp","ObjectType="+sObjectType,"");
        }
    }
	mySelectRow();
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>