<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	ASObjectModel doTemp = new ASObjectModel("TestCustomerList");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      //����ΪGrid���
	dwTemp.setPageSize(5);
	dwTemp.ReadOnly = "1";//ֻ��ģʽ
	dwTemp.genHTMLObjectWindow("");
	
	String sButtons[][] = {
	};
%> 
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	var sDateAreaHtml = "<input type='radio' onclick='setDateArea(6,0)' name='monthsetting'>������<input type='radio' onclick='setDateArea(3,1)' name='monthsetting'>��������<input type='radio' onclick='setDateArea(1,2)' name='monthsetting'>һ������";
	var iDateAreaSelectedIndex = -1;
	var sSerialNoHtml = "<input type='radio' onclick='setSerialNo(0,0)' name='serialnosetting'>201206��ǰ����<input type='radio' onclick='setSerialNo(1,1)' name='serialnosetting'>201206�Ժ�����";
	var iSerialNoSelectedIndex = -1;
	
	function validFilter(){
		return true;
	}
	//�ύ�Ժ�Ĵ������滻ԭʼ�ؼ�ʱ��Ҫ���ж�������
	function afterSubmitFilter(){
		//���ز�������ԭʼ�ؼ�
		hideFilterforSelection(0,"ADDRESS");
		//�滻Ҫ��ʾ�Ŀؼ�
		setFilterExtHtml(0,"ADDRESS",sDateAreaHtml);
		//����ѡ����Ŀ
		var objs = document.getElementsByName("monthsetting");
		for(var i=0;i<objs.length;i++){
			if(i==iDateAreaSelectedIndex){
				objs[i].checked = true;
			}
		}
		if(iSerialNoSelectedIndex==1)
			resetSerialNo('BigEqualsThan');
		else
			resetSerialNo('LessEqualsThan');
	}
	function setDateArea(month,selectedIndex){
		var day0 = new Date();
		day0.setMonth(day0.getMonth()-month); 
		setFilterAreaValue(0,"ADDRESS",getFormatedDateString(day0,"/"),0);
		setFilterAreaValue(0,"ADDRESS",getFormatedDateString(new Date(),"/"),1);
		iDateAreaSelectedIndex= selectedIndex;
	}
	function setSerialNo(value,selectedIndex){
		if(value==1){
			setFilterAreaOption(0,"SERIALNO","BigEqualsThan");
			setFilterAreaValue(0,"SERIALNO","201206");
		}
		else{
			setFilterAreaOption(0,"SERIALNO","LessEqualsThan");
			setFilterAreaValue(0,"SERIALNO","201206");
		}
		iSerialNoSelectedIndex= selectedIndex;
	}
	function initFilter(){
		//���ò������� ������Ϊ ���ڡ�����֮�䡱
		setFilterAreaOption(0,"ADDRESS","Area");
		//���ز�������ԭʼ�����ؼ�
		hideFilterforSelection(0,"ADDRESS");
		//�滻Ҫ��ʾ�Ŀؼ�
		setFilterExtHtml(0,"ADDRESS",sDateAreaHtml);
		//���¶����Ƿ�ʹ�ù��˿�
		resetSerialNo("BigEqualsThan");
		//��ʾ�߼���ѯ��
		showFilterArea();
		//�ύ��ѯ
		//submitFilterArea();
	}
	function resetSerialNo(option){
		//���ò������� ������Ϊ ���ڡ�����֮�䡱
		setFilterAreaOption(0,"SERIALNO",option);
		//���ز�������ԭʼ�����ؼ�
		hideFilterforSelection(0,"SERIALNO");
		//�滻Ҫ��ʾ�Ŀؼ�
		setFilterExtHtml(0,"SERIALNO",sSerialNoHtml);
		//����ѡ����Ŀ
		var objs = document.getElementsByName("serialnosetting");
		for(var i=0;i<objs.length;i++){
			if(i==iSerialNoSelectedIndex){
				objs[i].checked = true;
			}
		}
	}
	window.onload= initFilter;
</script>
<%@include file="/Frame/resources/include/include_end.jspf"%>
