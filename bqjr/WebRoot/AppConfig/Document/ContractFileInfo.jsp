<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
		/*
		Author:   --fbkang 
		Tester:
		Content:    --�����ӵǼ�
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
	String PG_TITLE = "�����ӵǼ�"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%	
	ASDataObject doTemp = new ASDataObject("ContractFileInfo",Sqlca);
	doTemp.setDDDWSql("cabinetID", "select cabinetID,cabinetID from archives_Warehouse");
	doTemp.appendHTMLStyle("cabinetID"," onBlur=\"javascript:parent.getDoChange()\" ");
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
    var sTemp=false;

	//---------------------���尴ť�¼�------------------------------------
	/*~[Describe=����;InputParam=�����¼�;OutPutParam=��;]~*/
	function saveRecord()
	{
		var sBoxID =getItemValue(0,getRow(),"boxID");
		var sCabinetID =getItemValue(0,getRow(),"cabinetID");
		var sBoxName =getItemValue(0,getRow(),"boxName");
		checkNumber();
		if(sTemp) {sTemp=false; return;}
		var sUnique = RunMethod("Unique","uniques","Box,count(1),boxID='"+sBoxID+"'");
		var sBoxNameCount = RunMethod("Unique","uniques","Box,count(1),boxName='"+sBoxName+"'");
		if(bIsInsert && sUnique>="1.0"){
			alert("�����ӱ���Ѿ���ռ��,�������µ����ӱ�� ");
			return;
		}
		if(sBoxNameCount>="1.0"){
			alert("�����������Ѿ���ռ��,�������µ��������� ");
			return;
		}
		bIsInsert = false;
		
		if(isNaN(sBoxID)==true){
			alert("���ӱ�ű���������!");
			return false;
		}
	    as_save("myiframe0");
	    var sSCount= RunMethod("Unique","uniques","box,count(1),cabinetID='"+sCabinetID+"'");
		RunMethod("ModifyNumber","GetModifyNumber","archives_Warehouse,boxNumber='"+sSCount+"',cabinetID='"+sCabinetID+"'");
	}

    /*~[Describe=����;InputParam=�����¼�;OutPutParam=��;]~*/
	function saveRecordAndBack()
	{
		//OpenPage("/AppConfig/Document/ContractFileList.jsp?curItemID=1","_self","");
		AsControl.OpenView("/AppConfig/Document/ContractFileList.jsp","curItemID=1","right");
	}
    
    function getDoChange(){
		var sCabinetID =getItemValue(0,getRow(),"cabinetID");
		checkNumber();
		var cabinetAddress=RunMethod("GetElement","GetElementValue","cabinetAddress,archives_Warehouse,cabinetID='"+sCabinetID+"'");
		if ((typeof(sCabinetID)!="undefined" || sCabinetID.length!=0)&&sCabinetID!=""){
			setItemValue(0,0,"cabinetAddress", cabinetAddress);
		}else{
			setItemValue(0,0,"cabinetAddress", " ");
		}
    }
   
    //�������е����������Ƿ����ʵ�ʴ������������ 
    function checkNumber(){
    	var sCabinetID =getItemValue(0,getRow(),"cabinetID");
    	var sCabinetBoxCapacity= RunMethod("Unique","uniques","archives_Warehouse,cabinetBoxCapacity, cabinetID='"+sCabinetID+"'"); //��ѯ���ù��������ӵ�����
		var sSCount= RunMethod("Unique","uniques","box,count(1), cabinetID='"+sCabinetID+"'");      //��ѯ�ù������г����Ǽ�֤�򵵰��Ǽ�֤�����ӹ���
		sSCount=parseFloat(sSCount)+1.0;
		if(sCabinetBoxCapacity<sSCount){
			alert("�������ӵ�������");
			sTemp=true;
			return;
		}
    }
	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">
	
	function initRow(){
		if (getRowCount(0)==0) //���û���ҵ���Ӧ��¼��������һ�����������ֶ�Ĭ��ֵ
		{
			as_add("myiframe0");//������¼
			setItemValue(0,0,"boxFile", "02");
			setItemValue(0,0,"inputOrg", "<%=CurOrg.orgID %>");
			setItemValue(0, 0, "inputOrgName", "<%=CurOrg.orgName %>");
			setItemValue(0,0,"inputUser", "<%=CurUser.getUserName()%>");
			setItemValue(0,0,"inputTime", "<%=StringFunction.getToday()%>");
			setItemValue(0,0,"updateOrg", "<%=CurOrg.orgID %>");
			setItemValue(0, 0, "updateOrgName", "<%=CurOrg.orgName %>");
			setItemValue(0,0,"updateUser", "<%=CurUser.getUserName()%>");
			setItemValue(0,0,"updateTime", "<%=StringFunction.getToday()%>");
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
