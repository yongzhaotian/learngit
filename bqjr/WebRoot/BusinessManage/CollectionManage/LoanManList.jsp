<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		ҳ��˵��: ʾ���б�ҳ��
	 */
	String PG_TITLE = "�������б�ҳ��";
	//���ҳ�����
	String sTemp =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("temp"));
	if(sTemp==null) sTemp="";
    boolean a=false;
	String ss = CurARC.getAttribute(request.getSession().getId()+"city"); // ����session�е��ŵ���ֵ
	//ͨ��DWģ�Ͳ���ASDataObject����doTemp
	String sTempletNo = "LoanManList";//ģ�ͱ��
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	doTemp.WhereClause+=sTemp.equals("1")? " and not exists (select bc.creditid from business_contract bc where bc.creditattribute='0002' and bc.creditid=Service_Providers.serialNo and bc.creditid is not null group by bc.creditid)" 
    		                                :" and exists (select bc.creditid from business_contract bc where bc.creditattribute='0002' and bc.creditid=Service_Providers.serialNo  and bc.creditid is not null group by bc.creditid)";
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.setPageSize(10);

	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{sTemp.equals("1")?"true":"false","","Button","����","����һ����¼","newRecord()",sResourcesPath},
		{"true","","Button","����","�鿴/�޸�����","viewAndEdit()",sResourcesPath},
		{"false","","Button","ɾ��","ɾ����ѡ�еļ�¼","deleteRecord()",sResourcesPath},
		{"false","","Button","ʹ��ObjectViewer��","ʹ��ObjectViewer��","openWithObjectViewer()",sResourcesPath},
	};
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
	function newRecord(){
		 var sReturn=popComp("","/BusinessManage/CollectionManage/LoanManInfo.jsp","",""); 
		 /* AsControl.OpenView("/BusinessManage/CollectionManage/LoanManInfo.jsp","","_self","");  */
		if(sReturn!=null){
		 AsControl.OpenView("/BusinessManage/CollectionManage/LoanManTab.jsp","LoanNo="+sReturn,"_blank",""); 
		}
	}
	
	function deleteRecord(){

		var sLoanNo = getItemValue(0,getRow(),"serialNo");//�޸�Ϊ wlq 
		if (typeof(sLoanNo)=="undefined" || sLoanNo.length==0){
			alert("��ѡ��һ����¼��");
			return;
		}
		
		if(confirm("�������ɾ������Ϣ��")){
			as_del("myiframe0");
			as_save("myiframe0");  //�������ɾ������Ҫ���ô����
			reloadSelf();
		}
	}
	
	function openXin(){
		var sLoanNo = getItemValue(0,getRow(),"serialNo");//�޸�Ϊ wlq 
		if (typeof(sLoanNo)=="undefined" || sLoanNo.length==0){
			alert("��ѡ��һ����¼��");
			return;
		}
		RunMethod("ModifyNumber","GetModifyNumber","Service_Providers,Status='01',serialNo='"+sLoanNo+"'");
		alert("����ɹ�");
		reloadSelf();
	}
	
	function stopXin(){
		var sLoanNo = getItemValue(0,getRow(),"serialNo");//�޸�Ϊ wlq 
		if (typeof(sLoanNo)=="undefined" || sLoanNo.length==0){
			alert("��ѡ��һ����¼��");
			return;
		}
		RunMethod("ModifyNumber","GetModifyNumber","Service_Providers,Status='02',serialNo='"+sLoanNo+"'");
		alert("���óɹ�");
		reloadSelf();
	}

	function viewAndEdit(){
		
		var sLoanNo = getItemValue(0,getRow(),"serialNo");//�޸�Ϊ wlq
		if (typeof(sLoanNo)=="undefined" || sLoanNo.length==0){
			alert("��ѡ��һ����¼��");
			return;
		}
		AsControl.OpenView("/BusinessManage/CollectionManage/LoanManTab.jsp","LoanNo="+sLoanNo,"_blank","");
		reloadSelf();
	}
	
	<%/*~[Describe=ʹ��ObjectViewer��;InputParam=��;OutPutParam=��;]~*/%>
	function openWithObjectViewer(){
		var sExampleId = getItemValue(0,getRow(),"ExampleId");
		if (typeof(sExampleId)=="undefined" || sExampleId.length==0){
			alert("��ѡ��һ����¼��");
			return;
		}
		
		AsControl.OpenObject("Example",sExampleId,"001");//ʹ��ObjectViewer����ͼ001��Example��
	}

	$(document).ready(function(){
		AsOne.AsInit();
		showFilterArea();
		init();
		my_load(2,0,'myiframe0');
	});
</script>	
<%@ include file="/IncludeEnd.jsp"%>
