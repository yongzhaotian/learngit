<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
		/*
		Author:   cwzhan 2004-12-15
		Tester:
		Content: �����Ϣ����
		Input Param:
                    CompID��    ������
 		Output param:
		                
		History Log: 
            
	 */
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "�������"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
	String sSql;
	String sSortNo; //������
	
	//����������	
	String sCompID =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CompID"));
	if(sCompID==null) sCompID="";

%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%	

   	String sHeaders[][] = {
				{"CompID","���ID"},
				{"CompName","�������"},
				{"AppID","Ӧ��ID"},
				{"OrderNo","�����"},
				{"CompType","�������"},
				{"DefaultPage","ȱʡҳ��"},
				{"CompURL","���URL"},
				{"CompPath","���·��"},
				{"RightID","Ȩ��ID"},
				{"REMARK","��ע"},
				{"INPUTUSERNAME","������"},
				{"INPUTUSER","������"},
				{"INPUTORGNAME","�������"},
				{"INPUTORG","�������"},
				{"INPUTTIME","����ʱ��"},
				{"UPDATEUSERNAME","������"},
				{"UPDATEUSER","������"},
				{"UPDATETIME","����ʱ��"}
			       };  

	sSql = " Select  "+
				"CompID,"+
				"CompName,"+
				"AppID,"+
				"OrderNo,"+
				"CompType,"+
				"DefaultPage,"+
				"CompURL,"+
				"CompPath,"+
				"RightID,"+
				"REMARK,"+
				"getUserName(INPUTUSER) as INPUTUSERNAME,"+
				"INPUTUSER,"+
				"getOrgName(INPUTORG) as INPUTORGNAME,"+
				"INPUTORG,"+
				"INPUTTIME,"+
				"getUserName(UPDATEUSER) as UPDATEUSERNAME,"+
				"UPDATEUSER,"+
				"UPDATETIME "+
				"From REG_COMP_DEF Where CompID = '"+sCompID+"'";
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.UpdateTable="REG_COMP_DEF";
	doTemp.setKey("CompID",true);
	doTemp.setHeader(sHeaders);

	//������������Դ
	doTemp.setDDDWCode("CompType","ComponentType");	
	doTemp.setDDDWSql("AppID","select AppID,AppID ||'--'|| AppName from REG_APP_DEF");

	doTemp.setUnit("OrderNo","<input type=button class=inputDate value=\"..\" onClick=\"parent.setSortNo()\"> ");
	doTemp.setRequired("CompID,CompName,OrderNo",true);
	doTemp.setHTMLStyle("CompPath,CompURL"," style={width:600px} ");
	doTemp.setHTMLStyle("DefaultPage,RightID"," style={width:200px} ");
	doTemp.setEditStyle("REMARK","3");
	doTemp.setHTMLStyle("REMARK"," style={height:100px;width:600px;overflow:auto} ");
 	doTemp.setLimit("REMARK",120);
	doTemp.setReadOnly("IINPUTUSERNAME,INPUTORGNAME,UPDATEUSERNAME,INPUTTIME,UPDATETIME",true);
 
	doTemp.setVisible("INPUTUSER,INPUTORG,UPDATEUSER",false);    	
	doTemp.setUpdateable("INPUTUSERNAME,INPUTORGNAME,UPDATEUSERNAME",false);

	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
   
    	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);

			
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	//dwTemp.harbor.getDock(0).setAttribute("DefaultColspan","3");

	//��������¼�
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sCompID);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	

	String sCriteriaAreaHTML = ""; 
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
		{"true","","Button","����","�����޸�","saveRecord()",sResourcesPath},
		};
	%> 
<%/*~END~*/%>




<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">
    var sCurCompID=""; //��¼��ǰ��ѡ���еĴ����

	//---------------------���尴ť�¼�------------------------------------
	/*~[Describe=����;InputParam=�����¼�;OutPutParam=��;]~*/
	function saveRecord(){
		var sOrderNo=getItemValue(0,0,"OrderNo");
		if(sOrderNo.length!=2 && sOrderNo.length!=6 && sOrderNo.length!=10 && sOrderNo.length!=14 && sOrderNo.length!=18){
			alert("�Ƿ�������ų��ȣ�"+sOrderNo.length+"\n\n����ų��Ƚ�����\n2λ\n6λ\n10λ\n14λ\n18λ");
			return;
		}
		if(sOrderNo.indexOf("0")==0){
			alert("���������벻Ҫ�ԡ�0����ʼ��");
			return;
		}
        setItemValue(0,0,"UpdateUser","<%=CurUser.getUserID()%>");
        setItemValue(0,0,"UpdateTime","<%=StringFunction.getToday()%>");
        as_save("myiframe0","reloadCache()");
	}
    
    function reloadCache(){
    	if(confirm("���Ѷ����ע����Ϣ�������޸ģ�����ˢ��������建����")){
    		AsDebug.reloadCache("ASCompSet");
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
			setItemValue(0,0,"INPUTUSER","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"INPUTUSERNAME","<%=CurUser.getUserName()%>");
			setItemValue(0,0,"INPUTORG","<%=CurOrg.getOrgID()%>");
			setItemValue(0,0,"INPUTORGNAME","<%=CurOrg.getOrgName()%>");
			setItemValue(0,0,"INPUTTIME","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"UPDATEUSER","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"UPDATEUSERNAME","<%=CurUser.getUserName()%>");
			setItemValue(0,0,"UPDATETIME","<%=StringFunction.getToday()%>");
		        bIsInsert = true;
		}
	}
	
	function setSortNo(){
		var sCurCompID = getItemValue(0,0,"CompID");
		var sReturn="";
		sReturn = popComp("SelectComp","/Common/Configurator/CompManage/CompSelectTree.jsp","","");
		if(typeof(sReturn)=="undefined" || sReturn=="") return;
		var sReturns = sReturn.split("@");
		var sTargetCompID = sReturns[0];
		var sTargetCompName = sReturns[1];
		var sTargetOrderNo = sReturns[2];
		var sInjectionType = PopPage("/Common/Configurator/CompManage/SelectInjectionTypeDialog.jsp","","dialogwidth:200px;dialogheight:150px");
		if(typeof(sInjectionType)=="undefined" || sInjectionType=="") return;
		sReturn  = PopPage("/Common/Configurator/CompManage/InjectOrderNo.jsp?CurCompID="+sCurCompID+"&TargetCompID="+sTargetCompID+"&TargetOrderNo="+sTargetOrderNo+"&InjectionType="+sInjectionType,"","dialogwidth:400px;dialogheight:300px");
		if(typeof(sReturn)!="undefined" && sReturn!="failed"){
			setItemValue(0,0,"OrderNo",sReturn);
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
