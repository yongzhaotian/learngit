<%@ page contentType="text/html; charset=GBK"%>
<%@page import="com.amarsoft.app.awe.framecase.dw.*"%>
<%@
 include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	ASObjectModel doTemp = new ASObjectModel("TestCustomerList");
	doTemp.setFilterCustomWhereClauses(new DemoFilterCustomWhereClauses());;
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      //����ΪGrid���
	dwTemp.setPageSize(5);
	dwTemp.ReadOnly = "1";//ֻ��ģʽ
	dwTemp.genHTMLObjectWindow("");
	String sButtons[][] = {
			{"true","","Button","����Txt","����Txt","exportPage('"+sWebRootPath+"',0,'txt','"+dwTemp.getArgsValue()+"',getExtendParams())","","","",""},
	};
%> 
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	
	var sFilterCustomWhereClauses = undefined;
	function validFilter(){//���ύ֮ǰ�ȱ����ѯ��Ϣ
		sFilterCustomWhereClauses = getFilterCustomWhereClauses(0);
		return true;
	}
	function afterSubmitFilter(){//�ύ��ѯ֮��ָ���ѯ��Ϣ
		setFilterCustomWhereClauses(0,sFilterCustomWhereClauses);
	}
	function tableSearchFromInput(obj,from,params,clearSort){//�������ò�ѯ
		params += "&" + getExtendParams();
		return  tableSearchFromInput0(obj,from,params,clearSort);
	}
	function getExtendParams(){
		return  "f_serialno=" + encodeURI(document.getElementById("f_serialno").value);//����ʹ��encodeURIת�룬��������������������
	}
	function afterOpenFilterArea(){//ÿ�δ򿪲�ѯ��֮��ִ�в���
		if(sFilterCustomWhereClauses==undefined)
			sFilterCustomWhereClauses = "�ͻ���� like <input type='text' name='f_serialno' id='f_serialno' value=''>"; 
		setFilterCustomWhereClauses(0,sFilterCustomWhereClauses);
		TableFactory.hideAllSearchIcon();
		TableFactory.showSearchIcon("SERIALNO");
	}
	TableFactory.clearFilter = function(tableIndex){//����������շ���
		sFilterCustomWhereClauses = undefined;
	}
</script>
<%@include file="/Frame/resources/include/include_end.jspf"%>
