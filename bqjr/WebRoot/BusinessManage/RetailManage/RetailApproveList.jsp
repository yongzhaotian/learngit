<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%
	/*
		--ҳ��˵��: ʾ���б�ҳ��--
	 */
	String PG_TITLE = "������׼������";
	//���ҳ�����
	String sType =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("type"));
	if(sType==null) sType="";
	System.out.println("----------------------"+sType);
	//ͨ��DWģ�Ͳ���ASDataObject����doTemp
	String sTempletNo = "RetailApplyModel";//ģ�ͱ��
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	doTemp.WhereClause="where PrimaryApproveStatus='4' and PrimaryApproveTime is null";
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
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
		var sSerialNo = getItemValue(0,getRow(),"SERIALNO");
		var sRegCode=getItemValue(0,getRow(),"REGCODE");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert("��ѡ��һ����¼��");
			return;
		}
		AsControl.OpenView("/BusinessManage/RetailManage/RetailInfoDetailPrimary.jsp","SerialNo="+sSerialNo+"&RegCode="+sRegCode,"_blank");
		reloadSelf();
	}
	
	$(document).ready(function(){
		AsOne.AsInit();
		init();
		my_load(2,0,'myiframe0');
	});
</script>	
<%@ include file="/IncludeEnd.jsp"%>
