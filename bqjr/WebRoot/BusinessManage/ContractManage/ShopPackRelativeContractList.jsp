<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		ҳ��˵��: ʾ���б�ҳ��
	 */
	String PG_TITLE = "�ŵ��������ҳ��";
	//���ҳ�����
	String sPackNo =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("PackNo"));
	String sFlag =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("Flag"));
	String sCreateUser =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CreateUser"));
	
	System.out.println("------"+sPackNo+"-----"+sFlag+"------"+sCreateUser);
	if(sPackNo==null) sPackNo="";
	if(sFlag==null) sFlag="";
	if(sCreateUser==null) sCreateUser="";
	
	//ͨ��DWģ�Ͳ���ASDataObject����doTemp
	String sTempletNo = "ShopContractList";//ģ�ͱ��
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);

	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.setPageSize(10);

	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sPackNo);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{((sFlag.equals("Y") && sCreateUser.equals(CurUser.getUserID()))?"true":"false"),"","Button","����","����һ����¼","newRecord()",sResourcesPath},
		{((sFlag.equals("Y") && sCreateUser.equals(CurUser.getUserID()))?"true":"false"),"","Button","ɾ��","ɾ����ѡ�еļ�¼","deleteRecord()",sResourcesPath},
	};
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
    <%/*~[Describe=������Ϣ;InputParam=��;OutPutParam=��;] ~*/%>
	function newRecord(){
		sCompID = "ShopPackContractList";
		sCompURL = "/BusinessManage/ContractManage/ShopPackContractList.jsp";
		sString = "PackNo=<%=sPackNo%>";
	    popComp(sCompID,sCompURL,sString,"dialogWidth=660px;dialogHeight=460px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
	    reloadSelf();
	}
	
	<%/*~[Describe=ɾ����Ϣ;InputParam=��;OutPutParam=��;] ~*/%>
	function deleteRecord(){
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert("��ѡ��һ����¼��");
			return;
		}
		
		if(confirm("�������ɾ������Ϣ��")){
			//as_del("myiframe0");
			RunMethod("BusinessManage","delPackRelative",sSerialNo);
			as_save("myiframe0");  //�������ɾ������Ҫ���ô����
			reloadSelf();
		}
	}


	$(document).ready(function(){
		showFilterArea();
		AsOne.AsInit();
		init();
		my_load(2,0,'myiframe0');
	});
</script>	
<%@ include file="/IncludeEnd.jsp"%>