<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
		/*
		Author:   --fbkang 
		Tester:
		Content:    --��ַ���
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
	String PG_TITLE = "��ַ���"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%	
	String sCabinetID  = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("cabinetID"));
	if(sCabinetID==null) sCabinetID="";	
	
	ASDataObject doTemp = new ASDataObject("UpdateAddressInfo",Sqlca);
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д

	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sCabinetID);
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
			{"true","","Button","�޸�","�޸�","saveRecord()",sResourcesPath},
			{"false","","Button","����","����","saveRecordAndBack()",sResourcesPath}
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
    var sTemp=false;

	//---------------------���尴ť�¼�------------------------------------
	/*~[Describe=����;InputParam=�����¼�;OutPutParam=��;]~*/
	function saveRecord()
	{
		var sCabinetID1=getItemValue(0,getRow(),"cabinetID1");
		var sCabinetID2=getItemValue(0,getRow(),"cabinetID2");
	    if (typeof(sCabinetID1)=="undefined" || sCabinetID1.length==0){
            alert("��ѡ��һ��ԭ���ӣ�");
            return;
        }
	    if (typeof(sCabinetID2)=="undefined" || sCabinetID2.length==0){
            alert("��ѡ��һ�������ӣ�");
            return;
        }
		var sSerialNo = RunJavaMethodSqlca("com.amarsoft.app.lending.bizlets.ContractFile", "updateAdderss","CabinetID1="+sCabinetID1+",CabinetID2="+sCabinetID2);
		alert(sSerialNo);
		reloadSelf();

	}

	/*~[Describe=����;InputParam=�����¼�;OutPutParam=��;]~*/
	function saveRecordAndBack()
	{
		OpenPage("/AppConfig/Document/RecordRoomList.jsp","_self","");
	}
	   
    function getDoChange(){
    	var sRecordRoom=getItemValue(0,getRow(),"RecordRoom");
    	var sCabinetID=getItemValue(0,getRow(),"CabinetID");
    	var sCount= RunMethod("Unique","uniques","archives_Warehouse,count(1), SNO='"+sCabinetID+"' and CreditAttribute='0002' and CodeAttribute='LineNumberCode'");
    	if(sRecordRoom<sCount){
    		alert("�Ѵ��г������޸ĵ������������޸ģ�");
    		sTemp=true;
    		return;
    	}
    	sTemp=false;
    }
    
    function selectOldBox(){
    	var sRetVal = setObjectValue("SelectOldBox", "", "@cabinetName1@1", 0, 0, "");
    	if (typeof(sRetVal)=="undefined" || sRetVal.length==0){
			alert("��ѡ��һ������");
			return;
		}
    	setItemValue(0,0,"cabinetID1", sRetVal.split("@")[0]);
    }
    function selectNewBox(){
    	var sRetVal = setObjectValue("SelectNewBox", "", "@cabinetName2@1", 0, 0, "");
    	if (typeof(sRetVal)=="undefined" || sRetVal.length==0){
			alert("��ѡ��һ������");
			return;
    	}
    	setItemValue(0,0,"cabinetID2", sRetVal.split("@")[0]);
    }
	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">
	
	function initRow(){
		if (getRowCount(0)==0) //���û���ҵ���Ӧ��¼��������һ�����������ֶ�Ĭ��ֵ
		{
			as_add("myiframe0");//������¼
			setItemValue(0,0,"CabinetID",getSerialNo("archives_Warehouse", "CabinetID", ""));
			setItemValue(0,0,"CreditAttribute", "0002");
			setItemValue(0,0,"CodeAttribute", "RecordRoomCode");
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
