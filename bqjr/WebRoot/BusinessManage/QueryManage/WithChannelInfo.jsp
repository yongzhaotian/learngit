<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%
	/* --ҳ��˵��: ʾ������ҳ��-- */
	String PG_TITLE = "ʾ������ҳ��";

	// ���ҳ�����
	String sExampleId =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNO"));
	if(sExampleId==null) sExampleId="";
	
	// ͨ��DWģ�Ͳ���ASDataObject����doTemp
	String sTempletNo = "WithChannelInfo";//ģ�ͱ��
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      // ����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; // �����Ƿ�ֻ�� 1:ֻ�� 0:��д
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sExampleId);//�������,���ŷָ�
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{"true","","Button","����","���������޸�","saveRecord()",sResourcesPath},
		{"true","","Button","���沢����","���沢�����б�","saveAndGoBack()",sResourcesPath},
		{"true","","Button","����","�����б�ҳ��","goBack()",sResourcesPath}
	};
%>
<%@include file="/Resources/CodeParts/Info05.jsp"%>
<script type="text/javascript">

    //add by ybpanCCS-608   --���Ĵ�����������ʱ����    20150413
    var sWithCity ="";//����ʡ��
    
	function ClearProvice(){
		var sWithLevel = getItemValue(0,getRow(),"WITHLEVEL");//���ۼ���
		//�����ۼ���Ϊȫ�еĻ��Ѵ���ʡ����Ϊ��
		if(sWithLevel=="010"){
			setItemValue(0,getRow(),"CITYNAME","");
		}else if(sWithLevel=="020"){
			setItemValue(0,getRow(),"CITYNAME",sWithCity);
		}
	}
	//end by ybpanCCS-608   --���Ĵ�����������ʱ����    20150413

	var bIsInsert = false; // ���DW�Ƿ��ڡ�����״̬��
	function saveRecord(sPostEvents){
		var sWithLevel = getItemValue(0,getRow(),"WITHLEVEL");//���ۼ���
		var sWithRange = getItemValue(0,getRow(),"WITHRANGE");//���۷�Χ
		var sWithCity = getItemValue(0,getRow(),"WITHCITY");//����ʡ��
		var sWithChannel = getItemValue(0,getRow(),"WITHCHANNEL");//��������
		var sBankNo = getItemValue(0,getRow(),"BANKNO");//���б��

		//ע�� by ybpan at 20150323  CCS-608  --���Ĵ�����������ʱ����
		/* var count = RunMethod("BusinessManage","CheckWithLevel",sBankNo);
		if(count > 0){
			alert("��ǰ�����Ѵ��ڴ��ۼ��𣬲���������ȫ�л��ȫ�е�������Ϣ��");
			return;
		} */
	 
		if(sWithLevel == "020" && (typeof(sWithRange) == "undefined" || sWithRange.length==0)){
			alert("���ۼ���ѡ���ȫ�У���ѡ����۷�Χ��");
			return;
		}
		if(sWithLevel == "020" && (typeof(sWithCity) == "undefined" || sWithCity.length==0)){
			alert("���ۼ���ѡ���ȫ�У���ѡ�����ʡ�У�");
			return;
		}
		if(sWithLevel == "010" && (typeof(sWithRange) != "undefined" && sWithRange.length!=0 && sWithRange!= null)){
			alert("���ۼ���Ϊȫ�У�����Ҫѡ����۷�Χ��");
			return;
		}  	
		
		if(bIsInsert){
			beforeInsert();
		}
		as_save("myiframe0",sPostEvents);
	}
	
	function saveAndGoBack(){
		saveRecord("goBack()");
	}
	
	function goBack(){
		AsControl.OpenView("/BusinessManage/QueryManage/WithChannelList.jsp","","_self");
	}

	<%/*~[Describe=ִ�в������ǰִ�еĴ���;]~*/%>
	function beforeInsert(){
		var serialNo = getSerialNo("WITHCHANNEL_INFO","SERIALNO");// ��ȡ��ˮ��
		setItemValue(0,getRow(),"SERIALNO",serialNo);
		bIsInsert = false;
	}
	
	<%/*~[Describe=ִ�и��²���ǰִ�еĴ���;]~*/%>
	function beforeUpdate(){
	}
	
	function initRow(){
		sWithCity = getItemValue(0,getRow(),"CITYNAME");//����ʡ��  add by ybpan CCS-608
		if (getRowCount(0)==0){//�統ǰ�޼�¼��������һ��
			as_add("myiframe0");
			setItemValue(0,0,"INPUTUSERID","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"USERNAME","<%=CurUser.getUserName()%>");
			setItemValue(0,0,"INPUTORGID","<%=CurUser.getOrgID()%>");
			setItemValue(0,0,"ORGNAME","<%=CurUser.getOrgName()%>");
			setItemValue(0,0,"INPUTDATE","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd")%>");
			bIsInsert = true;
		}
    }
	
	/*~[Describe=���������滮ѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/
	function getCellRegionCode()
	{
		var sSelName = "";
		var sWithRange = getItemValue(0,getRow(),"WITHRANGE");
		if(sWithRange == "020"){
			sSelName = "SelectCityCodeSingle";
		}else if(sWithRange == "010"){
			sSelName = "SelectProvinceCodeSingle";
		}
		//�жϴ��ۼ���
		var sWithRange = getItemValue(0,getRow(),"WITHLEVEL");
		if(sWithRange == "010"){
			alert("���ۼ���Ϊȫ�У�����Ҫѡ��ʡ�У�");
			return;
		}
		
		var sAreaCode = getItemValue(0,getRow(),"WITHCITY");
		//sAreaCodeInfo = PopComp("AreaVFrame","/Common/ToolsA/AreaVFrame.jsp","AreaCode="+sAreaCode,"dialogWidth=650px;dialogHeight=450px;center:yes;status:no;statusbar:no","");
		var sAreaCodeInfo = setObjectValue(sSelName,"","",0,0,"");
		//������չ��ܵ��ж�
		if(sAreaCodeInfo == "NO" || sAreaCodeInfo == '_CLEAR_'){
			setItemValue(0,getRow(),"WITHCITY","");
			setItemValue(0,getRow(),"CITYNAME","");
		}else{
			 if(typeof(sAreaCodeInfo) != "undefined" && sAreaCodeInfo != ""){
					sAreaCodeInfo = sAreaCodeInfo.split('@');
					sAreaCodeValue = sAreaCodeInfo[0];//-- ������������
					sAreaCodeName = sAreaCodeInfo[1];//--������������
					setItemValue(0,getRow(),"WITHCITY",sAreaCodeValue);
					setItemValue(0,getRow(),"CITYNAME",sAreaCodeName);				
			}
		}
	}
	
	
	$(document).ready(function(){
		AsOne.AsInit();
		init();
		bFreeFormMultiCol = false;
		my_load(2,0,'myiframe0');
		initRow();
	});
</script>
<%@ include file="/IncludeEnd.jsp"%>
