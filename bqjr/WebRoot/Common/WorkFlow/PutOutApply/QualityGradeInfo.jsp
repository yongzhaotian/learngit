<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
		/*
		Author:   --fbkang 
		Tester:
		Content:    --������������ȼ�
			δ�õ��������ֶ���ʱ���أ������Ҫ��չʾ������
		Input Param:
        	TypeNo��    --���ͱ��
 		Output param:
		                
		History Log: 
            
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "������������ȼ�"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%	
	String sSerialNo  = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("serialNo"));	
	String sQualityGrade  = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("qualityGrade"));
	String sCustomerName =DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerName"));
	if(sSerialNo==null) sSerialNo="";
	if(sQualityGrade==null) sQualityGrade="";	
	if(sCustomerName==null) sCustomerName="";	

	ASDataObject doTemp = new ASDataObject("QualityGradeInfo",Sqlca);
	//doTemp.setDDDWSql("errorType", "select distinct ErrorType,getitemname('ErrorType',ErrorType) from ErrorTypeCode_Info");
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д

	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	
%>

<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List04;Describe=���尴ť;]~*/%>
	<%
	//����Ϊ��
		//0.�Ƿ���ʾ
		//1.ע��Ŀ�������(Ϊ�����Զ�ȡ��ǰ���)
		//2.����(Button/ButtonWithNoAction/HyperLinkText/TreeviewItem/PlainText/Blank)
		//3.��ť����
		//4.˵������
		//5.�¼�
		//6.��ԴͼƬ·��
	String sButtons[][] = {
			{"true","","Button","����","����","saveRecord()",sResourcesPath},
			{"true","","Button","����","����","saveRecordAndBack()",sResourcesPath}
		    };
	%> 
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
	
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">
    var sCurTypeNo=""; //��¼��ǰ��ѡ���еĴ����
    var bIsInsert = false; //���DW�Ƿ��ڡ�����״̬��

	//---------------------���尴ť�¼�------------------------------------
	/*~[Describe=����;InputParam=�����¼�;OutPutParam=��;]~*/
	function saveRecord()
	{
		var qualityGrade =getItemValue(0,getRow(),"qualityGrade");//�����ȼ�
		var qualityTagging =getItemValue(0,getRow(),"qualityTagging"); //������ע
		var errorType =getItemValue(0,getRow(),"errorType"); // ��������
		var qualityFile = getItemValue(0,getRow(),"QualityFile"); //�ļ�����
		//var serialNoss = getSerialNo("record_Data", "recordID", ""); // ��ǰ�����к�
		var serialNoss = '<%=DBKeyUtils.getSerialNo("rd")%>'; // ��ǰ�����к�
		var contractNo = '<%=sSerialNo%>';
		var upUserName = '<%=CurUser.getUserID()%>';
		bIsInsert = false;
		if(!vI_all("myiframe0")){
			return;
		}
		
		//�Ƿ�ִ�б������״̬(modified by chiqizhong)
		var flag = true;
		//�йؼ���ǹؼ����������
		var errorCount = RunMethod("Unique","uniques","quality_grade,count(1),artificialNo='<%=sSerialNo%>' and qualityGrade<>'3' ");
		//�кϸ������
		var qualityCount = RunMethod("Unique","uniques","quality_grade,count(1),artificialNo='<%=sSerialNo%>' and qualityGrade='3' ");
		//��¼��������ȼ�Ϊ�ϸ�ʱ
		if('3' == qualityGrade && errorCount > 0){
			flag = false;
			alert("���ã��������'�ϸ�'��ע�������Ȱ�'�ؼ�����'��'�ǹؼ�����'ɾ����");
		}
		//��¼��������ȼ�Ϊ�ؼ���ǹؼ�������ذ�
		if(qualityGrade != '3' && qualityCount > 0){
			flag = false;
			alert("���ã��Ѿ��кϸ�������ȼ���������ӱ�������ȼ���");
		}
		
		//�Ƿ�ִ�б���
		if(flag){
			var args = "contractNo="+contractNo+",reSerialNo=" + serialNoss + ",upUserName="+upUserName+",errorType="+errorType+",qualityTagging="+qualityTagging+",qualityFile="+qualityFile+",currentQG="+qualityGrade;
			var result = RunJavaMethodSqlca("com.amarsoft.app.billions.RunInTransaction", "insQualityGrade", args)
			if(result=="success"){
				as_save("myiframe0");
			}else if(result=="sysBusy"){
				alert("ϵͳ��æɾ��ʧ�ܣ����Ժ����²���");
			}else if(result=="sysException"){
				alert("ϵͳ�쳣�����Ժ�����");
			}
		}
		parent.reloadSelf();
	}
    
    
    
    /*~[Describe=����;InputParam=�����¼�;OutPutParam=��;]~*/
	function saveRecordAndBack()
	{
		OpenPage("/Common/WorkFlow/PutOutApply/QualityGradeList.jsp","_self","");
	}
   
	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
<script type="text/javascript">
		
	/***********CCS-871 ������ע�����ֶ��߼����� add huzp 20150610******************************/
	function changeValue(object)//����ҳ�������������
	{
		var a =object.value;//����������б���ֵ��1���ؼ�����2���ǹؼ�����3���ϸ�4������
		if(a==1||a==2){//alert("Ϊ�ؼ���ǹؼ�ʱ������3����������");
			setItemValue(0, getRow(), "errorTypeName", "");//�����ѡ��
			setItemValue(0, getRow(), "QualityFileName", "");//�����ѡ��
			setItemValue(0, getRow(), "qualityTaggingName", "");//�����ѡ��
			
			setItemRequired(0,getRow(),"qualityTaggingName",1);
			setItemRequired(0,getRow(),"errorTypeName",1);
			setItemRequired(0,getRow(),"QualityFileName",1);
		}else if(a==3){//alert("Ϊ�ϸ�ʱ������3�������򲻿��");
			setItemRequired(0,getRow(),"qualityTaggingName",0);
			setItemRequired(0,getRow(),"errorTypeName",0);
			setItemRequired(0,getRow(),"QualityFileName",0);

			setItemValue(0, getRow(), "errorTypeName", "");//�����ѡ��
			setItemValue(0, getRow(), "QualityFileName", "");//�����ѡ��
			setItemValue(0, getRow(), "qualityTaggingName", "");//�����ѡ��
		}else{//alert("Ϊ�ذ�ʱ������3�����������ɲ��");
			setItemRequired(0,getRow(),"qualityTaggingName",0);
			setItemRequired(0,getRow(),"errorTypeName",0);
			setItemRequired(0,getRow(),"QualityFileName",0);
			
			setItemValue(0, getRow(), "errorTypeName", "");//�����ѡ��
			setItemValue(0, getRow(), "QualityFileName", "");//�����ѡ��
			setItemValue(0, getRow(), "qualityTaggingName", "");//�����ѡ��
		}
	}
	/*~[Describe=������ѡ��ѡ���������;InputParam=��;OutPutParam=��;]~*/
	function selectErrorTypeMulti() {
		var qualityGrade= getItemValue(0,getRow(),"qualityGrade");
		if(qualityGrade==""){
			alert("��ѡ���Ӧ�����ȼ�!");
			return;
		}
		var qualitygradecodeno ="qualitygradecodeno,"+qualityGrade;
		
		var sRetVal = setObjectValue("SelectErrorType", qualitygradecodeno,"@qualitygradecodeno@0" , 0, 0, "");
		if (typeof(sRetVal)=="undefined" || sRetVal=="_CLEAR_" || sRetVal.length==0) {
			alert("��ѡ���������");
			return;
		}
		var sTypeArry = sRetVal.substring(0, sRetVal.length-1).split("@");
		var sCTypeIds = "";
		var SCTypeNames = "";
		for (var i=0;i<sTypeArry.length;i=i+2) {
			sCTypeIds += sTypeArry[i] + ",";
			SCTypeNames += sTypeArry[i+1] + ",";
		}
		setItemValue(0, 0, "errorType", sCTypeIds.substring(0, sCTypeIds.length-1));  
		setItemValue(0, 0, "errorTypeName", SCTypeNames.substring(0, SCTypeNames.length-1));

		return;
	}
	
	/*~[Describe=������ѡ��ѡ���ļ�����;InputParam=��;OutPutParam=��;]~*/
	function selectFileNameMulti() {
		var qualityGrade= getItemValue(0,getRow(),"qualityGrade");//�����ȼ�
		var errorType= getItemValue(0,getRow(),"errorType");//��������
		if(qualityGrade==""){
			alert("��ѡ���Ӧ�����ȼ�!");
			return;
		}
		if(errorType==""){
			alert("��ѡ���Ӧ��������!");
			return;
		}
		var sParaString ="ATTRIBUTE7"+","+qualityGrade+","+"ATTRIBUTE8"+","+errorType;
		var sRetVal = setObjectValue("SelectFileName", sParaString,"@itemno@0@itemname@1" , 0, 0, "");
		if (typeof(sRetVal)=="undefined" || sRetVal=="_CLEAR_" || sRetVal.length==0) {
			alert("��ѡ��������ͻ��ļ�����");
			return;
		}
		var sTypeArry = sRetVal.substring(0, sRetVal.length-1).split("@");
		var sCTypeIds = "";
		var SCTypeNames = "";
		for (var i=0;i<sTypeArry.length;i=i+2) {
			sCTypeIds += sTypeArry[i] + ",";
			SCTypeNames += sTypeArry[i+1] + ",";
		}
		setItemValue(0, 0, "QualityFile", sCTypeIds.substring(0, sCTypeIds.length-1));  
		setItemValue(0, 0, "QualityFileName", SCTypeNames.substring(0, SCTypeNames.length-1));
		return;
	}
	/*~[Describe=������ѡ��ѡ��������ע;InputParam=��;OutPutParam=��;]~*/
	function selectQualityGradeMulti() {
		var qualityGrade= getItemValue(0,getRow(),"qualityGrade");//�����ȼ�
		var errorType= getItemValue(0,getRow(),"errorType");//��������
		var QualityFile= getItemValue(0,getRow(),"QualityFile");//�ļ�����
		if(qualityGrade==""){
			alert("��ѡ���Ӧ�����ȼ�!");
			return;
		}
		if(errorType==""){
			alert("��ѡ���Ӧ��������!");
			return;
		}
		if(QualityFile==""){
			alert("��ѡ���Ӧ�ļ�����!");
			return;
		}
		var sParaString ="ATTRIBUTE7"+","+qualityGrade+","+"ATTRIBUTE8"+","+errorType+","+"ATTRIBUTE6"+","+QualityFile;
		var sRetVal = setObjectValue("SelectQualityGrade", sParaString,"@itemno@0@itemname@1" , 0, 0, "");
		if (typeof(sRetVal)=="undefined" || sRetVal=="_CLEAR_" || sRetVal.length==0) {
			alert("��ѡ��������ͻ��ļ�����");
			return;
		}
		var sTypeArry = sRetVal.substring(0, sRetVal.length-1).split("@");
		var sCTypeIds = "";
		var SCTypeNames = "";
		for (var i=0;i<sTypeArry.length;i=i+2) {
			sCTypeIds += sTypeArry[i] + ",";
			SCTypeNames += sTypeArry[i+1] + ",";
		}
		setItemValue(0, 0, "qualityTagging", sCTypeIds.substring(0, sCTypeIds.length-1));  
		setItemValue(0, 0, "qualityTaggingName", SCTypeNames.substring(0, SCTypeNames.length-1));

		return;
	}
	/********************end**********************************************************/
	
	
	function initRow(){
		if (getRowCount(0)==0) //���û���ҵ���Ӧ��¼��������һ�����������ֶ�Ĭ��ֵ
		{
			as_add("myiframe0");//������¼
			setItemValue(0,0,"artificialNo", "<%=sSerialNo%>");
			//ֱ��ͨ���������ȡ��ˮ��
			setItemValue(0,0,"serialNo", "<%=DBKeyUtils.getSerialNo("qg")%>");
			//�Ǽ�����			
			setItemValue(0,0,"INPUTTIME","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd HH:mm:ss")%>");
			//�Ǽ���
			setItemValue(0,0,"INPUTUSERID","<%=CurUser.getUserID()%>");
			//�Ǽǻ���
			setItemValue(0,0,"INPUTORGID","<%=CurUser.getOrgID()%>");
			bIsInsert = true;
		}
	}
	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List07;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script type="text/javascript">	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	initRow();
</script>	
<%/*~END~*/%>


<%@ include file="/IncludeEnd.jsp"%>
