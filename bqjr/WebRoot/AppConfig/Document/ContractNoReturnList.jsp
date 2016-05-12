<%@ page contentType="text/html; charset=GBK"%>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>
<%@ include file="/IncludeBegin.jsp"%><%
	/*
		--ҳ��˵��: ʾ���б�ҳ��--
	 */
	String PG_TITLE = "ʾ���б�ҳ��";
	//���ҳ�����
	//String sInputUser =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("InputUser"));
	//if(sInputUser==null) sInputUser="";
	
	SimpleDateFormat forMat=new SimpleDateFormat("yyyy/MM/dd");
	String nowDate=forMat.format(new Date());
	//ͨ��DWģ�Ͳ���ASDataObject����doTemp
	String sTempletNo = "ContractNoReturnList";//ģ�ͱ��
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);

	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	doTemp.WhereClause+=" and ACCESSTYPE='01' and ISARCHIVE='01' and RENTURNDATE<'"+nowDate+"'";
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.setPageSize(10);

	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
			{CurUser.getRoleTable().contains("2001")?"true":"false","","Button","����EXCEL","����EXCEL","exportExcel()",sResourcesPath},
	};
	
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">

		//Excel����������	
		function exportExcel(){
			amarExport("myiframe0");
		}
		//end by pli2 20140417	

	function viewtab(){
		//����������͡�������ˮ��
		var sObjectType = "BusinessContract";
		var sObjectNo = getItemValue(0,getRow(),"SERIALNO");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		sCompID = "CreditTab";
		sCompURL = "/CreditManage/CreditApply/ObjectTab.jsp";
		sParamString = "ObjectType="+sObjectType+"&ObjectNo="+sObjectNo;
		OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
		reloadSelf();
	}
	
	function elecContractView(){
		var sExampleId = getItemValue(0,getRow(),"ExampleId");
		if (typeof(sExampleId)=="undefined" || sExampleId.length==0){
			alert("��ѡ��һ����¼��");
			return;
		}
		
		if(confirm("�������ɾ������Ϣ��")){
			as_del("myiframe0");
			as_save("myiframe0");  //�������ɾ������Ҫ���ô����
		}
	}

	function imageView(){
		 var sObjectNo   = getItemValue(0,getRow(),"SERIALNO");
	        if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
	            alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
	            return;
	        }
	     var param = "ObjectType=Business&TypeNo=20&ObjectNo="+sObjectNo;
	     AsControl.PopView( "/ImageManage/ImageView.jsp", param, "" );
	}
	
	function contractView() {
		var sSerialNo = getItemValue(0,getRow(),"SERIALNO");
		 if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
	            alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
	            return;
	        }
		sCompID = "AccessTypeInfo";
		sCompURL = "/AppConfig/Document/AccessTypeInfo.jsp";
	    popComp(sCompID,sCompURL,"serialNo="+sSerialNo,"dialogWidth=300px;dialogHeight=360px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
	    reloadSelf();
	}
	
	function tackbackContract() {
		var sSerialNo = getItemValue(0,getRow(),"SERIALNO");
		var sAccessType = getItemValue(0,getRow(),"AccessType");
		 if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
	            alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
	            return;
	     }
		 if (typeof(sAccessType)=="undefined" || sAccessType.length==0){
	            alert("�ú�ͬû�б�����,����Ҫ�黹��");//��ѡ��һ����Ϣ��
	            return;
	     }
	    if(confirm("�����Ҫ�黹��")){
	    	RunMethod("ModifyNumber","GetModifyNumber","business_contract,AccessType='02',serialNo='"+sSerialNo+"'");
			reloadSelf();
		}
		 
	}
	
	function destroyContract() {
		var sSerialNo = getItemValue(0,getRow(),"SERIALNO");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
	           alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
	           return;
	    }
		if(confirm("�����Ҫ������")){
		    RunMethod("ModifyNumber","GetModifyNumber","business_contract,AccessType='03',serialNo='"+sSerialNo+"'");
			reloadSelf();
		}
	}
	
	$(document).ready(function(){
		AsOne.AsInit();
		init();
		my_load(2,0,'myiframe0');
	});
</script>	
<%@ include file="/IncludeEnd.jsp"%>
