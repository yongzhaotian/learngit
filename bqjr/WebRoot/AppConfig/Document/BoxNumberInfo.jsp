<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
		/*
		Author:   --fbkang 
		Tester:
		Content:    --��������
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
	String PG_TITLE = "��������"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%	
	String sCabinetID  = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("cabinetID"));
	String sTemp  = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("temp"));	
	if(sTemp==null) sTemp="";	
	if(sCabinetID==null) sCabinetID="";	
	    
	String count=Sqlca.getString(new SqlObject("select count(1) from business_contract where boxNo=:boxNo").setParameter("boxNo", sCabinetID));
	ASDataObject doTemp = new ASDataObject("BoxNumberInfo",Sqlca);
	if(sTemp.equals("modify") && !count.equals("0") ){
		doTemp.setReadOnly("CabinetName,RName", true);
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
    var sFlag=false;

	//---------------------���尴ť�¼�------------------------------------
	/*~[Describe=����;InputParam=�����¼�;OutPutParam=��;]~*/
	function saveRecord()
	{
		var sCabinetName=getItemValue(0,getRow(),"CabinetName");
		var sSNO=getItemValue(0,getRow(),"SNO");
    	var sSNumber=getItemValue(0,getRow(),"SNumber");
    	var sCabinetID=getItemValue(0,getRow(),"CabinetID");
    	xinCabinetName=RunMethod("GetElement","GetElementValue","CabinetName,archives_Warehouse,CabinetID='"+sCabinetID+"'");
    	if(sSNumber=="") {alert("��ѡ�����"); return;}
    	var type=checkNumber(sSNO,sSNumber);
    	if(type=="new") return;
    	var sCount= RunMethod("Unique","uniques","archives_Warehouse,count(1), CabinetName='"+sCabinetName+"' and CreditAttribute='0002' and CodeAttribute='BoxNumberCode'");
    	var editCount= RunMethod("Unique","uniques","archives_Warehouse,count(1), CabinetName='"+sCabinetName+"' and CreditAttribute='0002' and CodeAttribute='BoxNumberCode' and CabinetName<>'"+xinCabinetName+"'");
    	if("<%=sTemp%>"!="modify"){
    		if(sCount>0){
            	alert("�����������Ѵ��ڣ�");
            	return;
            }
    	}else{
    		if(editCount>0){
            	alert("�����������Ѵ��ڣ�");
            	return;
            }
    	}
    	
		bIsInsert = false;
		if(sFlag) return;
		as_save("myiframe0");
	}

    /*~[Describe=����;InputParam=�����¼�;OutPutParam=��;]~*/
	function saveRecordAndBack()
	{
		OpenPage("/AppConfig/Document/BoxNumberList.jsp","_self","");
	}
     
    
    function getRegionCode(){
    	if("<%=sTemp%>"=="modify" && "<%=count%>"!="0") return;
    	var sEntInfoValue=setObjectValue("SelectShelfNumberInfo","","@RName@1",0,0,"");
   		if (typeof(sEntInfoValue)=="undefined" || sEntInfoValue.length==0){
   			return;
   		}
   		sSNO=sEntInfoValue.split("@")[0];
   		sShelfNumber =sEntInfoValue.split("@")[2];
   		setItemValue(0,0,"SNO", sSNO);
   		setItemValue(0,0,"SNumber", sShelfNumber);
   		checkNumber(sSNO,sShelfNumber);
    }
    
	 //������� 
    function checkNumber(sSNO,sShelfNumber){
    	var SNO=getItemValue(0,getRow(),"SNO");
    	var sCabinetID=getItemValue(0,getRow(),"CabinetID");
    	sXinSNO=RunMethod("GetElement","GetElementValue","SNO,archives_Warehouse,CabinetID='"+sCabinetID+"'");
    	//��ѯ�ü��������ӵ����� 
    	var sCount= RunMethod("Unique","uniques","archives_Warehouse,count(1), SNO='"+sSNO+"' and CreditAttribute='0002' and CodeAttribute='BoxNumberCode'"); 
    	sCount=parseFloat(sCount);
    	if("<%=sTemp%>"=="modify" && sXinSNO == SNO){
    		sCount=parseFloat(sCount);
    	}else{
    		sCount=parseFloat(sCount)+1;
    	}
	    if(sShelfNumber<sCount){
	    	alert("�����ü���������");
	    	sFlag=true;
	    	return "new";
	    }
	    sFlag=false;
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
			setItemValue(0,0,"CodeAttribute", "BoxNumberCode");
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
