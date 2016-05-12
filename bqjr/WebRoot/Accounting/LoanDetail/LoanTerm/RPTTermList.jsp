<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

  
<%
	String PG_TITLE = "�����򻹿�ƻ���Ϣ����"; // ��������ڱ��� <title> PG_TITLE </title>
	//�������
	String businessType = "";
	String projectVersion = "";
	
	//����������	
	
	//���ҳ�����
	String sObjectNo = DataConvert.toRealString(iPostChange,CurPage.getParameter("ObjectNo"));
	String sObjectType = DataConvert.toRealString(iPostChange,CurPage.getParameter("ObjectType"));
	String sTermMonth = DataConvert.toRealString(iPostChange,CurPage.getParameter("TermMonth"));
	double dBusinessSum = Double.parseDouble(DataConvert.toRealString(iPostChange,CurPage.getParameter("BusinessSum")));
	String sMaturity = DataConvert.toRealString(iPostChange,CurPage.getParameter("Maturity"));
	String sPutoutDate = DataConvert.toRealString(iPostChange,CurPage.getParameter("PutOutDate"));
	String status = DataConvert.toRealString(iPostChange,CurPage.getParameter("Status"));
	String sRPTTermID = DataConvert.toString(DataConvert.toRealString(iPostChange,CurPage.getParameter("TermID")));//���ID
	String right=DataConvert.toString(DataConvert.toRealString(iPostChange,CurPage.getParameter("RightType")));
	if(sObjectNo == null) sObjectNo = "";
	if(sObjectType == null) sObjectType = "";
	if(status == null) status = "";
	
	AbstractBusinessObjectManager boManager = new DefaultBusinessObjectManager(Sqlca);
	BusinessObject businessObject = AbstractBusinessObjectManager.getBusinessObject(sObjectType, sObjectNo,Sqlca);
	
	if(businessObject==null){
		throw new Exception("δȡ��ҵ��������ObjectType="+sObjectType+",ObjectNo="+sObjectNo+"�����飡");
	}
	sObjectType = businessObject.getObjectType();
	
	
	//��ʼ��ҵ��������
	String productVersion = businessObject.getString("ProductVersion");
	String productID = businessObject.getString("BusinessType");
	if("".equalsIgnoreCase(productVersion))
		throw new Exception("ȡ���Ĳ�Ʒ�汾Ϊ�գ����飡");
	if("".equalsIgnoreCase(productID)) 
		throw new Exception("ȡ���Ĳ�Ʒ���Ϊ�գ����飡");
	businessObject.setAttributeValue("RPTTermID", sRPTTermID);
	boManager.setBusinessObject(AbstractBusinessObjectManager.operateflag_update,businessObject);
	
	//���ػ��ʽ��Ϣ
	String whereClauseSql ="";
	ASValuePool as = new ASValuePool();	
	whereClauseSql =" ObjectType=:ObjectType and ObjectNo=:ObjectNo and Status=:Status " ;
	as = new ASValuePool();
	as.setAttribute("ObjectType", businessObject.getObjectType());
	as.setAttribute("ObjectNo", businessObject.getObjectNo());
	as.setAttribute("Status", "0");
	List<BusinessObject> rptList = boManager.loadBusinessObjects(BUSINESSOBJECT_CONSTATNTS.loan_rpt_segment, whereClauseSql,as);
		
	if (rptList!=null&&!rptList.isEmpty()){
		for(BusinessObject rpt:rptList){
			if(!rpt.getString("RPTTERMID").startsWith("RPT20-")){
			   boManager.setBusinessObject(AbstractBusinessObjectManager.operateflag_delete,rpt);
			}
		}
	}
	boManager.updateDB();
	boManager.commit();
	
	ASValuePool term = ProductConfig.getProductTerm(productID, productVersion, sRPTTermID);
	if(term == null || term.isEmpty()) term = ProductConfig.getTerm(sRPTTermID);
	
	//��ʾģ����
	String sTempletNo = "RPTTermList";
	String sTempletFilter = "1=1";
	
	ASDataObject doTemp = new ASDataObject(sTempletNo,sTempletFilter,Sqlca);
	
	//�Ƿ�ѡ����������
	String termInput = ProductConfig.getProductTermParameterAttribute(productID, productVersion, sRPTTermID, "TermInput","DefaultValue");//�Ƿ�ѡ����������
	if("2".equals(termInput)){//��������
		doTemp.setVisible("SegStages", false);
		doTemp.setRequired("SegStages", false);
	}else{//��������
		doTemp.setVisible("SegFromDate",false);
		doTemp.setVisible("SegToDate", false);
		doTemp.setRequired("SegFromDate",false);
		doTemp.setRequired("SegToDate", false);
	}
	
	doTemp.WhereClause += " and Status in('"+status.replaceAll("@","','")+"')";
	ASDataWindow dwTemp = new ASDataWindow(CurPage, doTemp, Sqlca);
	
	dwTemp.Style = "1"; //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sObjectNo+","+businessObject.getObjectType());
	for(int i=0;i < vTemp.size();i++)out.print((String) vTemp.get(i));
	
	
	String sButtons[][] = {
			{"true","","Button","����","����","newRecord()",sResourcesPath}, 
			{"true", "", "Button", "ɾ��", "ɾ��","deleteRecord()",sResourcesPath},
			/* {"true","","Button","����","����","saveRecord()",sResourcesPath}, */};
%>
<%@include file="/Resources/CodeParts/List05.jsp"%>
<script language=javascript>
	/*~[Describe=����;InputParam=��;OutPutParam=��;]~*/
	function newRecord()
	{
		//���������򻹿�����
		var returnValue = setObjectValue("SelectTermLibrary1","TermID,<%=sRPTTermID+"-"%>,ObjectType,Product,ObjectNo,<%=productID+"-"+productVersion%>","",0,0,"");
		if(typeof(returnValue)=="undefined" || returnValue=="" || returnValue=="_CANCEL_" || returnValue=="_CLEAR_") 
		{
			return;
		}
		var sTermID = returnValue.split("@")[0];
		RunMethod("ProductManage","initObjectWithProduct","initObjectWithProduct,"+sTermID+",<%=businessObject.getObjectType()%>,<%=sObjectNo%>");
		setNoCheckRequired(0);
		 as_save("myiframe0","reloadSelf()");
	}
	
	
	function saveRecord(){
		//����¼��Ļ���ƻ�
		var dBusinessSum="<%=dBusinessSum%>";
		var termInput="<%=termInput%>";
		var sPutoutDate="<%=sPutoutDate%>";
		var sMaturity="<%=sMaturity%>"; 
		var sSegBusinessSum=0;
		//У������Ļ���ƻ����
		for(var i=0;i<getRowCount(0);i++){
			sSegBusinessSum=sSegBusinessSum+getItemValue(0,i,"SegRPTAmount");
		} 
		if (Math.abs(dBusinessSum-sSegBusinessSum)>0.01){
			alert("����ƻ����¼�벻��ȷ!");
			return false;
		} 
		//������Ļ����ս���У��
		var day=0;
		var countday1=0;
		for(var i=0;i<getRowCount(0);i++){
			 day = getItemValue(0,i,"DefaultDueDay");	
				if(!(typeof(day)=="undefined" || day.length==0)&&(day>28||day<1)) countday1++;			
			}
		if(countday1>0) {
			alert("������ֻ��¼��1-28��֮��,������¼��!");
			return false;		
		}
		//����������ڻ����޽���У��
		 if (termInput==2){//¼������
			 var sSegToDate="";
			 var sSegToDate2="";
			 var sSegFromDate="";
			 if(getRowCount(0)==1){//������һ����¼
			    	setItemValue(0,0,"SegFromDate",sPutoutDate);
			    	sSegToDate=getItemValue(0,0,"SegToDate");
			    	if(sSegToDate<sMaturity&&!(sSegToDate==""||sSegToDate==null||sSegToDate.length==0)){//�жϲ��������һ����¼�Ľ�������
				   	 	   alert("���һ����������С�ڴ������");
					       return false;
				    }else{
				    	setItemValue(0,0,"SegToDate","");
			        } 
			    }else{
			    	for(var i=0;i<getRowCount(0);i++)              
					{
			    		if(i==0){setItemValue(0,i,"SegFromDate",sPutoutDate);}
					    sSegToDate=getItemValue(0,i,"SegToDate");
						if(i>0){
						sSegToDate2=getItemValue(0,i-1,"SegToDate");//ȡ��һ������ƻ��Ľ�������
						setItemValue(0,i,"SegFromDate",sSegToDate2);
						}
						if(sSegFromDate>sSegToDate){
							alert("����ƻ�����¼�벻��ȷ");
						    return false;
						}
					    if(i<(getRowCount(0)-1)&&sSegToDate>sMaturity){
					        alert("��"+(i+1)+"������ƻ���������¼�����");
					        return false;
					    } 
					    if(i<(getRowCount(0)-1)&&(sSegToDate==""||sSegToDate==null||sSegToDate.length==0)){
					        alert("��"+(i+1)+"������ƻ�δ¼���������");
					        return false;
					    }
					}
			    	if(sSegToDate<sMaturity&&!(sSegToDate==""||sSegToDate==null||sSegToDate.length==0)){//�жϲ��������һ����¼�Ľ�������
				   	 	   alert("���һ����������С�ڴ������");
					       return false;
				    }else{
				    	setItemValue(0,(getRowCount(0)-1),"SegToDate","");
				    }	
			    }  
		}else{//¼������
			var sSegTermDate=sPutoutDate;
			var segStages="";
			var segTermUnit="020";
			for(var i=0;i<getRowCount(0);i++)              
			{
				segStages=getItemValue(0,i,"SegStages");
				if(typeof(segStages) == "undefined" || segStages.length == 0)
				{
					alert("��"+(i+1)+"������ƻ�δ¼�����ޣ�");
					return false;
				}
			    sSegTermDate = RunMethod("BusinessManage","CalcMaturity",segTermUnit+","+segStages+","+sSegTermDate);
			    if(i<getRowCount(0)-1&&sSegTermDate>=sMaturity){
			    	alert("��"+(i+1)+"������ƻ��ѳ����������ޣ�");
					return false;
			    } 	
			}
			if (sSegTermDate<sMaturity){
			  alert("����ƻ�����С�ڴ�������");
			  return false;
			} 
		}
	 as_save("myiframe0","reloadSelf()");
	 return true;
	}
	/*~[Describe=ɾ��;InputParam=��;OutPutParam=��;]~*/
	function deleteRecord(){
		setNoCheckRequired(0);  //���������б���������
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert("��ѡ��һ����¼��");
			return;
		}
		
		if(confirm("ȷ��ɾ������Ϣ��")){
			as_del("myiframe0");
			as_save("myiframe0");  //�������ɾ������Ҫ���ô����
		}
	}
	
	//��ʼ��
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>