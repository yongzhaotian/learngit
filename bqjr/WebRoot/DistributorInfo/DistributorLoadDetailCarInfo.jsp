<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
		/*
		Author:   --fbkang 
		Tester:
		Content:    --����������Ϣ
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
	String PG_TITLE = "����������Ϣ"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info02;Describe=�����������ȡ����;]~*/%>
<%
	//���ҳ�����
	String sSerialNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("serialNo"));	//�ϼ���ˮ��
	String cSerialNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("cSerialNo"));	//
	String sTemp = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("temp"));	
	if(sSerialNo==null) sSerialNo="";   
	if(cSerialNo==null) cSerialNo="";  
	if(sTemp==null) sTemp="";
%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%	
	String sTempletNo = "";
    if(sTemp.equals("modify")){
    	 sTempletNo = "DistributorCarInfo1";
    }else{
    	sTempletNo = "DistributorCarInfo";
    }
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
    
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	//����HTMLDataWindow
	Vector vTemp = null;
	if(sTemp.equals("modify")){
		vTemp=dwTemp.genHTMLDataWindow(cSerialNo);
	}else{
		vTemp=dwTemp.genHTMLDataWindow("");
	}
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
			{"true","","Button","����","�����б�","backList()",sResourcesPath},
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
		bIsInsert = false;
	    as_save("myiframe0");
	    sCarPrice= RunMethod("GetElement","GetElementValue","sum(carPrice),car_info,relativeSerialno='<%=sSerialNo %>' and carStatus='010'");
	    RunMethod("ModifyNumber","GetModifyNumber","business_contract,BusinessSum='"+sCarPrice+"',serialNo='<%=sSerialNo %>'");
	}
   
    function backList(){
    	AsControl.OpenView("/DistributorInfo/DistributorLoadDetailCarList.jsp","","_self");		
    }
    
    function getRegionCode(){
    	var sRetVal = setObjectValue("SelectCarFactoryInfo", "", "@carFactory@1", 0, 0, "");
    	if (typeof(sRetVal)=="undefined" || sRetVal.length==0){
			alert("��ѡ������������");
			return;
		}
    	sRetVal=sRetVal.split("@");
    	setItemValue(0, 0, "carFactoryID", sRetVal[0]);  //��������ID
		setItemValue(0, 0, "carFactory", sRetVal[1]);    //��������
    }
	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">
	
	function initRow(){
		if (getRowCount(0)==0) //���û���ҵ���Ӧ��¼��������һ�����������ֶ�Ĭ��ֵ
		{
			as_add("myiframe0");//������¼
			setItemValue(0, 0, "serialNo", getSerialNo("car_info", "serialNo", " "));
			setItemValue(0, 0, "carStatus", "010");
			setItemValue(0, 0, "relativeSerialno", "<%=sSerialNo %>");
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
