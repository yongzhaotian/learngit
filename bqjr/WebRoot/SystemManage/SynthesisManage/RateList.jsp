<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%
	String PG_TITLE = "���ʹ���";

	String sRateType = DataConvert.toRealString(iPostChange,(String)request.getParameter("RateType"));  
	if(sRateType == null) sRateType = "";	
	
	//ͨ��sql�������ݴ������		
	ASDataObject doTemp = new ASDataObject("RateList","",Sqlca);
	//���ñ�ͷ
	if(sRateType != null && !"".equals(sRateType))
	{
		doTemp.WhereClause += " and RateType = '"+sRateType+"' ";
	}
	
	//���ӹ�����
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	
	//����ASDataWindow���󣬲���һ���ڱ�ҳ��������������ASDataWindow����������ASDataObject����	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����ΪGrid���
	dwTemp.ReadOnly = "1"; //����Ϊֻ��
	
	Vector vTemp = dwTemp.genHTMLDataWindow("%");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
		

	String sButtons[][] = {
			{"true","","Button","����","����","newRecord()",sResourcesPath},
			{"true","","Button","�鿴/�޸�","�鿴/�޸�","viewAndEdit()",sResourcesPath},
			{"true","","Button","ˢ�����ʶ���","ˢ�����ʶ���","reloadCache()",sResourcesPath},
		};
	%> 


	<%@include file="/Resources/CodeParts/List05.jsp"%>


	<script type="text/javascript">
	//---------------------���尴ť�¼�------------------------------------
	/*~[Describe=������¼;InputParam=��;OutPutParam=��;]~*/
	function newRecord(){
		AsControl.PopView("/SystemManage/SynthesisManage/RateInfo.jsp","",
				"dialogWidth="+(screen.availWidth*0.3)+"px;dialogHeight="+(screen.availHeight*0.4)+"px;resizable=yes;maximize:yes;help:no;status:no;"); 
		self.reloadSelf();
	}

	/*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=��;]~*/
	function viewAndEdit(){
	    var sRateType = getItemValue(0,getRow(),"RateType");
	    var sTermUnit = getItemValue(0,getRow(),"TermUnit");
	    var sTerm = getItemValue(0,getRow(),"Term");
	    var sRateUnit = getItemValue(0,getRow(),"RateUnit");
	    var sEffectDate = getItemValue(0,getRow(),"EffectDate");
		if (typeof(sRateType)=="undefined" || sRateType.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}

		AsControl.PopView("/SystemManage/SynthesisManage/RateInfo.jsp",
				"RateType="+sRateType+"&TermUnit="+sTermUnit+"&Term="+sTerm+"&RateUnit="+sRateUnit+"&EffectDate="+sEffectDate,
				"dialogWidth="+(screen.availWidth*0.5)+"px;dialogHeight="+(screen.availHeight*0.6)+"px;resizable=yes;maximize:yes;help:no;status:no;");
		self.reloadSelf();
	}

	function reloadCache(){
		AsDebug.reloadCache('RateSet');
		reloadSelf();
	}
	</script>


<script type="text/javascript">	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>	


<%@ include file="/IncludeEnd.jsp"%>
