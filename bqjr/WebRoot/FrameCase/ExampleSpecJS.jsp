<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		ҳ��˵��: ʾ��У��ҳ��
	 */
	String PG_TITLE = "ʾ��У��ҳ��";

	//���ҳ�����
	String sExampleID =  CurPage.getParameter("ExampleID");
	if(sExampleID==null) sExampleID="";
	
	//ͨ��DWģ�Ͳ���ASDataObject����doTemp
	String sTempletNo = "ExampleInfo";//ģ�ͱ��
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sExampleID);//�������,���ŷָ�
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
			{"true","","Button","����","���������޸�","saveRecord()",sResourcesPath},
			{"true","All","Button","����ֶ�ֵ","getItemValue","getAllItemValue()","","","",""},
			{"true","All","Button","�����ֶ�BeginDate","hide BeginDate","hideItem(0,0,'BeginDate')","","","",""},
			{"true","All","Button","��ʾ�ֶ�BeginDate","show BeginDate","showItem(0,0,'BeginDate')","","","",""},
			{"true","All","Button","�������ֶ�","lockall","lockall()","","","",""},
			{"true","All","Button","�������ֶ�","unlockall","unlockall()","","","",""},
			{"true","All","Button","����ApplySum*","require","setItemRequired(0,0,'ApplySum',true)","","","",""},
			{"true","All","Button","ȡ��ApplySum*","unrequire","setItemRequired(0,0,'ApplySum',false)","","","",""},
			{"true","All","Button","���ApplySum����","getTitle","alert(getItemHeader(0,0,'ApplySum'))","","","",""},
			{"true","All","Button","����ApplySum����","setTitle","setTitle()","","","",""},
			{"false","All","Button","���ApplySum unit","getUnit","alert(getItemUnit(0,0,'ApplySum'))","","","",""},
			{"false","All","Button","����ApplySum unit","setUnit","setItemUnit(0,0,'ApplySum',prompt('����Unit','Unit'));","","","",""}
		};
%><%@include file="/Resources/CodeParts/Info05.jsp"%>
<script type="text/javascript">
	function getAllItemValue(){
		var fields = "ExampleName,BeginDate,ApplySum";
		var aFields = fields.split(",");
		var sResult = "";
		for(var i=0;i<aFields.length;i++){
			sResult += aFields[i] + ".value = " + getItemValue(0,0,aFields[i]) + "\n";
		}
		alert(sResult);
	}
	function unlockall(){
		var fields = "ExampleName,BeginDate";
		var aFields = fields.split(",");
		for(var i=0;i<aFields.length;i++){
			setItemDisabled(0,0,aFields[i],false);
		}
	}
	function lockall(){
		var fields = "ExampleName,BeginDate";
		var aFields = fields.split(",");
		for(var i=0;i<aFields.length;i++){
			setItemDisabled(0,0,aFields[i],true);
		}
	}
	
	function setTitle(){
		var sTitle = prompt("�������",'����');
		setItemHeader(0,0,"ApplySum",sTitle);
	}

	var bIsInsert = false; //���DW�Ƿ��ڡ�����״̬��
	function saveRecord(sPostEvents){
		if(bIsInsert){
			beforeInsert();
		}
		beforeUpdate();
		as_save("myiframe0",sPostEvents);
	}

	<%/*~[Describe=ִ�в������ǰִ�еĴ���;]~*/%>
	function beforeInsert(){
		var serialNo = getSerialNo("EXAMPLE_INFO","ExampleId");//��ȡ��ˮ��
		setItemValue(0,getRow(),"ExampleId",serialNo);
		setItemValue(0,0,"InputUser","<%=CurUser.getUserID()%>");
		setItemValue(0,0,"InputUserName","<%=CurUser.getUserName()%>");
		setItemValue(0,0,"InputTime","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd hh:mm:ss")%>");
		bIsInsert = false;
	}
	
	<%/*~[Describe=ִ�и��²���ǰִ�еĴ���;]~*/%>
	function beforeUpdate(){
		setItemValue(0,0,"UpdateUser","<%=CurUser.getUserID()%>");
		setItemValue(0,0,"UpdateUserName","<%=CurUser.getUserName()%>");
		setItemValue(0,0,"UpdateTime","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd hh:mm:ss")%>");
	}
	function initRow(){
		if (getRowCount(0)==0){//�統ǰ�޼�¼��������һ��
			as_add("myiframe0");
			bIsInsert = true;
		}
    }
	
	$(document).ready(function(){
		AsOne.AsInit();
		init();
		my_load(2,0,'myiframe0');
		initRow();
	});
</script>
<%@ include file="/IncludeEnd.jsp"%>