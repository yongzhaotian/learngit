<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		ҳ��˵��: ʾ���б�ҳ��
	 */
	String PG_TITLE = "�˱�����ҳ��";
    //�������
    String sTempletNoType="";
    String sBusinessDate=SystemConfig.getBusinessTime();
    
	//���ҳ�����
	String sApplyType =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ApplyType"));
	if(sApplyType==null) sApplyType="";
		sTempletNoType = "CancelInsuranceListRealTime";
	
	//ͨ��DWģ�Ͳ���ASDataObject����doTemp
	String sTempletNo = sTempletNoType;//ģ�ͱ��
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);

	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	doTemp.multiSelectionEnabled=true;//���ÿɶ�ѡ
	//if(!doTemp.haveReceivedFilterCriteria()) doTemp.WhereClause = " where 1=2";
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	 if(!doTemp.haveReceivedFilterCriteria()){
		 doTemp.WhereClause+="  and mi.status='3' "; 
	 }
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.setPageSize(15);
	
//	doTemp.WhereClause+=" and mi.status in ('3','4','5') ) ";
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	
	String sButtons[][] = {
			{"false","","Button","�˱�����","ȷ���˱�","httpPostSend()",sResourcesPath},
			{"false","","Button","ȡ���˱�","ȡ���˱�","canhttpPostSend()",sResourcesPath},
			{"true","","Button","����","����","exportAll()",sResourcesPath},
		};
    
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
  function httpPostSend(){
	  var sAlertIDString="";
		if(!confirm("�˱���ú�ͬ���޷��ٴ�����Ͷ����ȷ��Ҫ�˱���")){
			return;
		}else{
			var policyno = getItemValueArray(0,"policyno");// ��ѡ
			var policynos="";
			for(var i=0;i<policyno.length;i++){
				if(i==0){
					policynos=policyno[i];
				}else{
					policynos=policynos+"@"+policyno[i];
				}
			}
			
			if(	typeof(policynos)=="undefined" || policynos.length==0){//��ѡ
		    	//������
		    	policynos =getItemValue(0,getRow(),"policyno");
					if (typeof(policynos)=="undefined" || policynos.length==0){
						alert(getHtmlMessage(1));  //��ѡ��һ����¼��
					
						return;
					}
				}
			
				if(policynos){
					var sUserID = "<%=CurUser.getUserID()%>";
					ShowMessage("�˱�һ����¼��Լ3�룬��ȴ�....",true,false);
				var str=	RunJavaMethodSqlca("com.amarsoft.app.billions.UpdateMinanSerialNo", "httpPostPolicynoRealTime","policyno="+policynos+",updateBy="+sUserID);
				hideMessage();
				if(str=="S"){
						alert("�˱������������ݶԽӳɹ���");
					}else{
						alert(str);
					}
					
				}
			reloadSelf();// ˢ��
		}
  }
  
  
  function canhttpPostSend(){
	  var sAlertIDString="";
		if(!confirm("�Ƿ�Ҫȡ���ñ��˱����룿")){
			return;
		}else{

			
			var policyno = getItemValueArray(0,"policyno");
			var policynos="";
			for(var i=0;i<policyno.length;i++){
				if(i==0){
					policynos=policyno[i];
				}else{
					policynos=policynos+"@"+policyno[i];
				}
			}
			if(	typeof(policynos)=="undefined" || policynos.length==0){
	    	//������
	    	policynos =getItemValue(0,getRow(),"policyno");
				if (typeof(policynos)=="undefined" || policynos.length==0){
					alert(getHtmlMessage(1));  //��ѡ��һ����¼��
					return;
				}
			}
			
				if(policynos){
					var sUserID = "<%=CurUser.getUserID()%>";
				var str=	RunJavaMethodSqlca("com.amarsoft.app.billions.UpdateMinanSerialNo", "updateMinanSerialN1RealTime","policyno="+policynos+",updateBy="+sUserID);
					if(str=="S"){
						alert("ȡ���˱��ɹ���");
					}
				}
			reloadSelf();// ˢ��
		}
}
	  
	  
  
	function exportAll(){
		amarExport("myiframe0");
	}

	$(document).ready(function(){
		AsOne.AsInit();
		//showFilterArea();//��ѯ����չ������
		init();
		my_load(2,0,'myiframe0');
	});
</script>	
<%@ include file="/IncludeEnd.jsp"%>