<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%
	/* --ҳ��˵��: ʾ������ҳ��-- */
	String PG_TITLE = "ʾ������ҳ��";

	// ���ҳ�����
	String sType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("Type"));
    String sSerialNo=DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
	String sSql = "";
	
	// ͨ��DWģ�Ͳ���ASDataObject����doTemp
	String sTempletNo = "CancelApplyInfo";//ģ�ͱ��
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
	if(sType.equals("1")){
		sSql = "select ItemNo,ItemName from Code_Library where CodeNo = 'CancelApplyCode' and Attribute1 = '1'";
	}
	if(sType.equals("2")){
		sSql = "select ItemNo,ItemName from Code_Library where CodeNo = 'CancelApplyCode' and Attribute2 = '1'";
	}
	if(sType.equals("3")){
		sSql = "select ItemNo,ItemName from Code_Library where CodeNo = 'CancelApplyCode' and Attribute3 = '1'";
	}
	if(sType.equals("4")){
		sSql = "select ItemNo,ItemName from Code_Library where CodeNo = 'CancelApplyCode' and Attribute4 = '1'";
	}
	if(sType.equals("5")){
		sSql = "select ItemNo,ItemName from Code_Library where CodeNo = 'CancelApplyCode' and Attribute5 = '1'";
	}
	if(sType.equals("6")){
		sSql = "select ItemNo,ItemName from Code_Library where CodeNo = 'CancelApplyCode' and Attribute6 = '1'";
	}
	//���۴���ʹ�õ�ȡ��ԭ��     add by awang 2014/12/29
	if(sType.equals("7")){
		sSql = "select ItemNo,ItemName from Code_Library where CodeNo = 'CancelApplyCode' and Attribute7='1'";
	}
	//���ר��ʹ�õ�ȡ��ԭ��
	if(sType.equals("8")){
		sSql="select ItemNo,ItemName from Code_Library where CodeNo = 'CancelApplyCode' and Attribute8='1'";
	}
	//�������ѡ��Ϊ��ѡ��
	doTemp.setVRadioSql("PhaseOpinion1", sSql);
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      // ����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; // �����Ƿ�ֻ�� 1:ֻ�� 0:��д
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sSerialNo);//�������,���ŷָ�
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{"true","","Button","ȷ��","���������޸�","saveRecord()",sResourcesPath},
		{"true","","Button","ȡ��","�����б�ҳ��","goBack()",sResourcesPath}
	};
	
%>
<%@include file="/Resources/CodeParts/Info05.jsp"%>
<script type="text/javascript">
	var bIsInsert = false; // ���DW�Ƿ��ڡ�����״̬��
	
	
	function saveRecord(sPostEvents){
		var sPhaseOpinion1=getItemValue(0,0,"PhaseOpinion1");
		var sSerialNo=getItemValue(0,0,"SerialNo");
		var sInputOrg=getItemValue(0,0,"InputOrg");
		var sInputOrgName=getItemValue(0,0,"InputOrgName");
		var sInputUser=getItemValue(0,0,"InputUser");
		var sInputUserName=getItemValue(0,0,"InputUserName");
		var sInputTime=getItemValue(0,0,"InputTime");
		var sRemark=getItemValue(0,0,"Remark");
		
		if(typeof(sPhaseOpinion1)=="undefined" || sPhaseOpinion1.length==0){
			alert("��ѡ��ȡ��ԭ���ٵ��ȷ��");
			return;
		}

		if(sPhaseOpinion1=="0180"){
			var sRemark=getItemValue(0,0,"Remark");
			if(typeof(sRemark)=="undefined" || sRemark.length==0){
				alert("ѡ��ԭ��Ϊ����ʱ����עΪ������");
				return;
			}
		}

		var sCount=RunMethod("BusinessManage","selectOpinoinCount",sSerialNo);
		if(sCount!=0.0){
			alert("�˺�ͬ�˽׶��Ѵ���");
			self.close();
		}
		if(bIsInsert){
			beforeInsert();
		}
		var sOpinionNo=getItemValue(0,0,"OpinionNo");
		as_save("myiframe0",sPostEvents);
		alert("ȡ����ͬ�ɹ���");
		self.returnValue="SUCCESS";
		self.close();
	}
	
	function goBack(){
		self.returnValue = "_CANCEL_";
		self.close();
	}

	<%/*~[Describe=ִ�в������ǰִ�еĴ���;]~*/%>
	function beforeInsert(){
		/** --update Object_Maxsnȡ���Ż� tangyb 20150817 start-- 
		var serialNo = getSerialNo("FLOW_OPINION","OpinionNo");// ��ȡ��ˮ��*/
		var serialNo = '<%=DBKeyUtils.getSerialNo("FO")%>';
		/** --end --*/
		
		setItemValue(0,getRow(),"OpinionNo",serialNo);
		
		bIsInsert = false;
	}
	
	
	
	
	function initRow(){
		if (getRowCount(0)==0){//�統ǰ�޼�¼��������һ��
			as_add("myiframe0");
			setItemValue(0,getRow(),"SerialNo","<%=sSerialNo%>");
			setItemValue(0,getRow(),"InputOrg","<%=CurUser.getOrgID()%>");
			setItemValue(0,getRow(),"InputOrgName","<%=CurUser.getOrgName()%>");
			setItemValue(0,getRow(),"InputUser","<%=CurUser.getUserID()%>");
			setItemValue(0,getRow(),"InputUserName","<%=CurUser.getUserName()%>");
			setItemValue(0,getRow(),"InputTime","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd")%>");
			bIsInsert = true;
		}
    }
	
	$(document).ready(function(){
		AsOne.AsInit();
		init();
		bFreeFormMultiCol = false;
		bCheckBeforeUnload = false;
		my_load(2,0,'myiframe0');
		initRow();
	});
	
    function getValue(obj){      //ȡ��ԭ����ѡ����Ϊ��������ʱ����עΪ����� edit by awang 2014-12-09
    	if(obj.value=="0180"){
    		setItemRequired(0, 0, "Remark", true);
    	}else{
    		setItemRequired(0, 0, "Remark", false);
    	}
    }
</script>
<%@ include file="/IncludeEnd.jsp"%>
