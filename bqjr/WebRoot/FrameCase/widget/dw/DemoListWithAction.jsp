<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	ASObjectModel doTemp = new ASObjectModel("TestCustomerListX");
	doTemp.setVisible("ACTION", true);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.setPageSize(5);
	dwTemp.Style="1";      //����ΪGrid���
	dwTemp.ReadOnly = "1";//ֻ��ģʽ
	dwTemp.genHTMLObjectWindow("");
	
	String sButtons[][] = {
		{"true","","Button","����","����","add()","","","","btn_icon_add",""},
		{"true","","Button","����","����","edit()","","","","btn_icon_detail",""},
		{"true","","Button","�����˵��༭","�����˵��༭","editd()","","","","btn_icon_detail",""},
		{"true","","Button","ɾ��","ɾ��","if(confirm('ȷʵҪɾ����?'))as_delete(0,'alert(getRowCount(0))')","","","","btn_icon_delete",""},
	};
%> 
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	var selfUrl = "/FrameCase/widget/dw/DemoListWithAction.jsp";
	function add(){
		 var sUrl = "/FrameCase/widget/dw/DemoInfoSimple.jsp?PrevUrl="+selfUrl;
		 OpenPage(sUrl,'_self','');
	}
	function edit(){
		 var sUrl = "/FrameCase/widget/dw/DemoInfoSimple.jsp";
		 OpenPage(sUrl+'?SerialNo=' + getItemValue(0,getRow(0),'SerialNo')+'&PrevUrl='+selfUrl,'_self','');
	}function editd(){
		 var sUrl = "/FrameCase/widget/dw/DemoInfoDMenu.jsp";
		 OpenPage(sUrl+'?SerialNo=' + getItemValue(0,getRow(0),'SerialNo')+'&PrevUrl='+selfUrl,'_self','');
	}
	//�ڼ�����������
	function afterSearch(){
		for(var i=0;i<getRowCount(0);i++){
			
			getObj(0,i,"ACTION").innerHTML='<a href=# onclick="javascript:add()">����</a> <a href=# onclick="javascript:edit()">����</a> <a href=# onclick="javascript:if(confirm(\'ȷʵҪɾ����?\'))as_delete(0)">ɾ��</a> ';
		}
		setColumnWidth(0,"ACTION",150);
	}
</script>
<%@include file="/Frame/resources/include/include_end.jspf"%>
