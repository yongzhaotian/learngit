<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
		/*
		Author:   --fbkang 
		Tester:
		Content:    --��������������
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
	String PG_TITLE = "��������������"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%	
	String sCabinetID  = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("cabinetID"));
	String sTemp  = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("temp"));	
	if(sTemp==null) sTemp="";	
	if(sCabinetID==null) sCabinetID="";	
	String sql="";
	
	String count=Sqlca.getString(new SqlObject("select count(1) from business_contract where roomNo=:roomNo").setParameter("roomNo", sCabinetID));
	ASDataObject doTemp = new ASDataObject("RecordRoomInfo",Sqlca);
	if(sTemp.equals("modify")){
		doTemp.appendHTMLStyle("RecordRoom"," onBlur=\"javascript:parent.getDoChange()\" ");
		if(!count.equals("0")) doTemp.setReadOnly("CabinetName,RName", true);
	}
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
		var sCabinetName=getItemValue(0,getRow(),"CabinetName");
    	var sCabinetID=getItemValue(0,getRow(),"CabinetID");
    	xinCabinetName=RunMethod("GetElement","GetElementValue","CabinetName,archives_Warehouse,CabinetID='"+sCabinetID+"'");
    	var sCount= RunMethod("Unique","uniques","archives_Warehouse,count(1), CabinetName='"+sCabinetName+"' and CreditAttribute='0002' and CodeAttribute='RecordRoomCode'");
    	var editCount= RunMethod("Unique","uniques","archives_Warehouse,count(1), CabinetName='"+sCabinetName+"' and CreditAttribute='0002' and CodeAttribute='RecordRoomCode' and CabinetName<>'"+xinCabinetName+"'");
    	if("<%=sTemp%>"!="modify"){
	    	if(sCount>0){
	        	alert("�õ����������Ѵ��ڣ�");
	        	return;
	        }
    	}else{
    		if(editCount>0){
            	alert("�õ����ҵ������Ѵ��ڣ�");
            	return;
            }
    	}
		bIsInsert = false;
	    as_save("myiframe0");
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
