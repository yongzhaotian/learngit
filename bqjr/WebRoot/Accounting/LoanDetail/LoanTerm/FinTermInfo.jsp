<%@page contentType="text/html; charset=GBK"%>
<%@include file="/IncludeBegin.jsp"%>

<%
	String PG_TITLE = "��Ϣ���"; // ��������ڱ��� <title> PG_TITLE </title>
	//�������
	String sObjectType = "";
	String sObjectNo = "";
	String productID = "";
	String productVersion = "";
	
	//����������	
	
	//���ҳ�����
	String sSerialNo = DataConvert.toRealString(iPostChange,CurPage.getParameter("SerialNo"));
	sObjectType = DataConvert.toRealString(iPostChange,CurPage.getParameter("ObjectType"));
	if(sSerialNo == null) sSerialNo = "";
	if(sObjectType == null) sObjectType = "";
	AbstractBusinessObjectManager bom = new DefaultBusinessObjectManager(Sqlca);
	BusinessObject rateSegmentBusinessObject = bom.loadObjectWithKey(BUSINESSOBJECT_CONSTATNTS.loan_rate_segment, sSerialNo);
	if(rateSegmentBusinessObject != null)
	{
		sObjectType = rateSegmentBusinessObject.getString("ObjectType");
		sObjectNo = rateSegmentBusinessObject.getString("ObjectNo");
	}else
	{
		throw new Exception("����"+BUSINESSOBJECT_CONSTATNTS.loan_rate_segment+"."+sSerialNo+"�������ڣ�");
	}
	BusinessObject businessObject = AbstractBusinessObjectManager.getBusinessObject(sObjectType, sObjectNo,Sqlca);
	if(businessObject != null)
	{
		productID = businessObject.getString("BusinessType");
		productVersion = businessObject.getString("ProductVersion");
	}else
	{
		throw new Exception("����"+sObjectType+".+"+sObjectNo+"�������ڣ�");
	}
	
	//��ʾģ����
	String sTempletNo = "FinRateSegmentInfo";
	String sTempletFilter = "1=1";
	String sIsSegEdit = "1";
	
	ASDataObject doTemp = new ASDataObject(sTempletNo, sTempletFilter, Sqlca);
	
	doTemp.setHTMLStyle("RateFloat","onChange=parent.calcBaseRate()");
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	
	
	ASValuePool term = ProductConfig.getProductTerm(productID, productVersion, rateSegmentBusinessObject.getString("RateTermID"));
	String dwControl = DWExtendedFunctions.genDataWindowControlScript(term,dwTemp);
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sSerialNo);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	
	//����Ϊ��
	//0.�Ƿ���ʾ
	//1.ע��Ŀ�������(Ϊ�����Զ�ȡ��ǰ���)
	//2.����(Button/ButtonWithNoAction/HyperLinkText/TreeviewItem/PlainText/Blank)
	//3.��ť����
	//4.˵������
	//5.�¼�
	//6.��ԴͼƬ·��
	String sButtons[][] = 
	{
			{"true", "All", "Button", "����", "����","saveRecord()",sResourcesPath},
	};
%>
<%@ include file="/Resources/CodeParts/List05.jsp"%>
<script language=javascript>	
	function saveRecord()
	{
		if(!calcBaseRate())
		{
			return;
		}
		as_save("myiframe0","reloadSelf()");
	}
	
	function calcBaseRate()
	{
		var rateMode = getItemValue(0,getRow(),"RateMode");
		var baseRateType = getItemValue(0,getRow(),"BaseRateType");
		var baseRate = getItemValue(0,getRow(),"BaseRate");
		var rateFloatType = getItemValue(0,getRow(),"RateFloatType");
		var rateFloat = getItemValue(0,getRow(),"RateFloat");
		//add by bhxiao 20120913 
		//�޸�ԭ�򣬵�rateFloatΪ��ʱ��parseInt()���ú�rateFloat=NaN,ִ��Methodʱ������Ϊ��ʱ����Ϊ0
		if(typeof(rateFloat)=="undefined" || rateFloat==null ||rateFloat.length==0){
			rateFloat = 0.0;
		}
		if(rateMode != "2")
		{
			if(baseRate == "")
			{
				alert("��׼�����ʲ���Ϊ�գ�ȷ�ϴ��������Ϣ�е�������Ϣ�Ƿ�¼�롣");
				return false;
			}
			if(rateFloatType == "")
			{
				alert("�����������Ͳ���Ϊ�գ�");
				return false;
			}
			rateFloat = parseInt(rateFloat);
			if(rateFloat == 0)
			{
				setItemValue(0,0,"RateFloat",0);
			}
			
			var rateTermID = getItemValue(0,0,"RateTermID");
    		var flag = RunMethod("BusinessManage","FinFloatRateCheck","<%=productID+"-"+productVersion%>,"+rateTermID+","+rateFloat);
    		if(flag != "true")
    		{
    			alert(flag);
    			return false;
    		}
    		
			if(rateFloatType == "0")
			{
				setItemValue(0,0,"BusinessRate",parseFloat(baseRate)*(1+parseFloat(rateFloat)/100));
			}else
			{
				setItemValue(0,0,"BusinessRate",parseFloat(baseRate)+parseFloat(rateFloat));
			}
		}else{
			var businessRate = getItemValue(0,getRow(),"BusinessRate");
			if(typeof(businessRate)=="undefined"||businessRate.length==0){
				alert("ִ�����ʲ���Ϊ�գ�");
				return false;
			}
		}
    	
    	return true;
    }
	
	function initRow(){
		if (getRowCount(0)==0) //���û���ҵ���Ӧ��¼��������һ�����������ֶ�Ĭ��ֵ
		{
			as_add("myiframe0");//������¼
		}
		//����ǹ̶�����
		var rateMode = getItemValue(0,getRow(),"RateMode");
    	if(rateMode == "2")
    	{
			calcBaseRate();
		}else{//modify begin add by bhxiao 20120827 �Ż�������һ�δ�����ҳ��ʱ�������׼��������ֻ��������׼����Ϊ��ʱ����Ҫ������Ӧ��׼����ֵ
			var baseRateType = getItemValue(0,getRow(),"BaseRateType");
			var rateUnit = getItemValue(0,getRow(),"RateUnit");
			var sBaseRate = getItemValue(0,getRow(),"BaseRate");
			if(typeof(sBaseRate)!="undefined"&&sBaseRate>0.0){
				return;
			}
			var baseRate = RunMethod("BusinessManage","GetBaseRateByTerm","<%=sObjectType%>,<%=sObjectNo%>,"+baseRateType+","+rateUnit+",,<%=businessObject.getString("Currency")%>");
	    	if(baseRate.length == 0)
	    	{
	    		if(baseRateType == "100")
	    		{
	    			alert("�����Ƿ��Ѿ�¼��������Ϣ��");
	    		}else
	    		{
	    			if(baseRateType != "060")
	    			{
	    				alert("�����Ƿ��Ѿ�ά����׼���ʣ�");
	    				setItemValue(0,0,"BaseRate","");
	    			}	
	    		}
	    	}
	    	setItemValue(0,getRow(),"BaseRate",baseRate);
		}//modify end 
	}
	
	
	
</script>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List07;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script language=javascript>	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	initRow();
	<%=dwControl%>
</script>
<%/*~END~*/%>

<%@include file="/IncludeEnd.jsp"%>