<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author: yxzhang 2010/03/22
		Tester:
		Describe: ��Ϣ������ʷ��ѯ�б�
		Input Param:
	
		Output Param:
			
			
		HistoryLog:
	 */
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "��Ϣ������ʷ��ѯ�б�"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%
    String sSortNo = CurOrg.getSortNo()+"%";

	String sTempletNo = "ReinforceStatisticHistoryList";
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	

	
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	//��ѡ
	doTemp.multiSelectionEnabled = true;
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����ΪGrid���
	dwTemp.ReadOnly = "1"; //����Ϊֻ��
	
	//����datawindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sSortNo);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List04;Describe=���尴ť;]~*/%>
	<%
	String sButtons[][] = {
			{"true","","Button","ҵ�񲹵��������չʾ","ҵ�񲹵��������չʾ","GraphShowCount()",sResourcesPath},	
			{"true","","Button","ҵ�񲹵ǰٷֱ�չʾ","ҵ�񲹵ǰٷֱ�չʾ","GraphShowPercent()",sResourcesPath}	
		  };
	%>
<%/*~END~*/%>




<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
<script type="text/javascript">
    //---------------------���尴ť�¼�------------------------------------
    /*~[Describe=����ͼ��;InputParam=��;OutPutParam=��;]~*/
	function GraphShowCount()
	{  
        sOrgIDArray = getItemValueArray(0,"OrgID");//ȡ�ñ���ѡ������OrgID
        sOrgID = "";
        
        if (sOrgIDArray.length==0){
            alert("��û��ѡ����Ϣ��������Ҫѡ�����Ϣǰ��̣� ");
            return;
        }else if(sOrgIDArray.length > 10){
            alert("ѡ��Ļ�������,�벻Ҫ����10���� ");
            return;
        }else{        	
            for(var i=0; i<sOrgIDArray.length; i++){
            	sOrgID = sOrgID + sOrgIDArray[i] + ";";
            }
            sOrgID = sOrgID.substring(0,sOrgID.length-1);
        }
        
	    sScreenWidth = screen.availWidth-40;
	    sScreenHeight = screen.availHeight-40;
	    
	    sReturn=RunMethod("��Ϣ����","ReinforceStatisticHistory",sOrgID+",Counts");
	    sReturns = sReturn.split(",");
	    OrgNames = sReturns[0];
	    FinishCounts = sReturns[1];
	    ItemName = sReturns[2];
	    PopPage("/InfoManage/DataInput/ReinforceStatisticGraphicShow.jsp?ScreenWidth="+sScreenWidth+"&ScreenHeight="+sScreenHeight+"&hValue="+OrgNames+"&vValue="+FinishCounts+"&ItemName="+ItemName,"_blank",sDefaultDialogStyle);
	}
	
	/*~[Describe=����ͼ��;InputParam=��;OutPutParam=��;]~*/
	function GraphShowPercent()
	{  
        sOrgIDArray = getItemValueArray(0,"OrgID");//ȡ�ñ���ѡ������OrgID
        sOrgID = "";
        
        if (sOrgIDArray.length==0){
            alert("��û��ѡ����Ϣ��������Ҫѡ�����Ϣǰ��̣� ");
            return;
        }else if(sOrgIDArray.length > 10){
        	alert("ѡ��Ļ�������,�벻Ҫ����10���� ");
            return;
        }else{          
            for(var i=0; i<sOrgIDArray.length; i++){
                sOrgID = sOrgID + sOrgIDArray[i] + ";";
            }
            sOrgID = sOrgID.substring(0,sOrgID.length-1);
        }
        
        sScreenWidth = screen.availWidth-40;
        sScreenHeight = screen.availHeight-40;
        
        sReturn=RunMethod("��Ϣ����","ReinforceStatisticHistory",sOrgID+",Percents");
        sReturns = sReturn.split(",");
        OrgNames = sReturns[0];
        FinishCounts = sReturns[1];
        ItemName = sReturns[2];
        PopPage("/InfoManage/DataInput/ReinforceStatisticGraphicShow.jsp?ScreenWidth="+sScreenWidth+"&ScreenHeight="+sScreenHeight+"&hValue="+OrgNames+"&vValue="+FinishCounts+"&ItemName="+ItemName,"_blank",sDefaultDialogStyle);
	}
</script>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List07;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script type="text/javascript">
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>
<%/*~END~*/%>


<%@	include file="/IncludeEnd.jsp"%>
