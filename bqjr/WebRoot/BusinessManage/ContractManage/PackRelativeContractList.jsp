<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		ҳ��˵��: ʾ���б�ҳ��
	 */
	String PG_TITLE = "ע�Ჿ��������ҳ��";
	//���ҳ�����
	String sPackNo =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("PackNo"));
	String sFlag =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("Flag"));
	String sCreditID =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CreditID"));
	String sCreateUser =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CreateUser"));
	
	System.out.println("-------"+sCreditID);
	if(sPackNo==null) sPackNo="";
	if(sFlag==null) sFlag="";
	if(sCreditID==null) sCreditID="";
	if(sCreateUser==null) sCreateUser="";
	
	//ͨ��DWģ�Ͳ���ASDataObject����doTemp
	String sTempletNo = "RegisterContractList";//ģ�ͱ��
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	doTemp.multiSelectionEnabled=true;//��ʾ��ѡ��
	
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
		{((sFlag.equals("Y") && sCreateUser.equals(CurUser.getUserID()))?"true":"false"),"","Button","ɾ��","ɾ����ѡ�еļ�¼","saveRecord()",sResourcesPath},
		{CurUser.getRoleTable().contains("2001")?"true":"false","","Button","����EXCEL","����EXCEL","exportExcel()",sResourcesPath},

	};
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
    <%/*~[Describe=������Ϣ;InputParam=��;OutPutParam=��;] ~*/%>
    
  //Excel����������	
    function exportExcel(){
    	amarExport("myiframe0");
    }
    //end by pli2 20140417	
	
	function newRecord(){
		sCompID = "PackContractList";
		sCompURL = "/BusinessManage/ContractManage/PackContractList.jsp";
		sString = "PackNo=<%=sPackNo%>"+"&CreditID=<%=sCreditID%>";
	    popComp(sCompID,sCompURL,sString,"dialogWidth=850px;dialogHeight=500px;resizable=no;scrollbars=no;status:yes;maximize:yes;minimize:no;help:no;");
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
			//���º�ͬ�а�������״̬��Ϊ��
			RunMethod("BusinessManage","UpdatePackStatus",sArtificialNo[i]+","+"");
			as_save("myiframe0");  //�������ɾ������Ҫ���ô����
			reloadSelf();
		}
	}
	
	function saveRecord(){
		var sArtificialNo = getItemValueArray(0,"ContractNo");//��ͬ���
		var sSerialNo = getItemValueArray(0,"SerialNo");//�������
        
        if(sArtificialNo != ""){
			for(var i=0;i<sArtificialNo.length;i++){
				 //���º�ͬ�а�������״̬��2
				 RunMethod("BusinessManage","UpdatePackStatus",sArtificialNo[i]+","+"");
				 //ɾ������������ϵ
				 RunMethod("BusinessManage","delPackRelative",sSerialNo[i]);
				 as_save("myiframe0");  //�������ɾ������Ҫ���ô����
				 reloadSelf();
			}
	     }else{
			alert("��û��ѡ���¼,��ѡ��");
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