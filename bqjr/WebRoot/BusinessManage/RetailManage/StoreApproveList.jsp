<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%
	/*
		--ҳ��˵��: ʾ���б�ҳ��--
	 */
	String PG_TITLE = "�ŵ�׼������";
	//���ҳ�����
	String sType =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("type"));
	if(sType==null) sType="";
	System.out.println("----------------------"+sType);
	//ͨ��DWģ�Ͳ���ASDataObject����doTemp
	String sTempletNo = "StoreApproveList";//ģ�ͱ��
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	doTemp.WhereClause="where SI.PrimaryApproveStatus='4' and SI.PrimaryApproveTime is null";
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	doTemp.multiSelectionEnabled=true;
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.setPageSize(10);
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sType);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
			//0���Ƿ�չʾ 1��	Ȩ�޿���  2�� չʾ���� 3����ť��ʾ���� 4����ť�������� 5����ť�����¼�����	6����ݼ�	7��	8��	9��ͼ�꣬CSS�����ʽ 10�����
			
			{"true","","Button","����","����","PrimaryApprove()","","","","btn_icon_detail",""},
			
			
			
		};
%>
<%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
	function PrimaryApprove(){
		var sSeriaslNo = getItemValueArray(0,"SERIALNO");
		var sRegCode =  getItemValueArray(0,"SREGCODE");
	
		var  sSerialNo=sSeriaslNo[0];
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert("��ѡ��һ����¼��");
			return;
		}
		
		//-- add by �ŵ������ʱ���ж��̻����������Ƿ�ͨ�� tangyb 20151223 --//
		var sRSerialNo = RunMethod("���÷���", "GetColValue", "store_info,rserialno,serialno='"+sSeriaslNo+"'"); //��ѯ�����̱��
		var isApp = RunMethod("���÷���", "GetColValue", "retail_info,primaryapprovestatus,serialno='"+sRSerialNo+"'"); // ��ѯ�����̳���״̬
		
		if(isApp != "1"){
			alert("�ŵ������������["+sRSerialNo+"]��δͨ����������");
			return;
		}
		//-- end --//
	
		AsControl.OpenView("/BusinessManage/RetailManage/StoreInfoDetailPrimary.jsp","SerialNo="+sSeriaslNo+"&RegCode="+sRegCode,"_blank");
		
		reloadSelf();
	}
	
	$(document).ready(function(){
		AsOne.AsInit();
		init();
		my_load(2,0,'myiframe0');
	});
</script>	
<%@ include file="/IncludeEnd.jsp"%>
