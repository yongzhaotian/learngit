<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   cwzhan 2004-12-22
		Tester:
		Content: ��������б�
		Input Param:
                  
		Output param:
		                
		History Log: 
            
	 */
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "��������б�"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%
	//�������
	String sSql;
	
	//����������	
	String sAppID =  DataConvert.toRealString(iPostChange,(String)request.getParameter("AppID"));
	if(sAppID==null) sAppID="";
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
				"getItemName('ComponentType',CompType) as CompType,"+
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
				"From REG_COMP_DEF where 1=1 order by OrderNo";
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.UpdateTable="REG_COMP_DEF";
	doTemp.setKey("CompID",true);
	doTemp.setHeader(sHeaders);

	//doTemp.setDDDWSql("AppID","select AppID,AppID ||'--'|| AppName from REG_APP_DEF");

	doTemp.setHTMLStyle("CompID"," style={width:160px} ");
	doTemp.setHTMLStyle("CompName"," style={width:160px} ");
	doTemp.setHTMLStyle("AppID"," style={width:160px} ");
	doTemp.setHTMLStyle("OrderNo"," style={width:140px} ");
	doTemp.setHTMLStyle("CompType"," style={width:80px} ");
	doTemp.setHTMLStyle("DefaultPage,CompPath,CompURL"," style={width:600px} ");
	doTemp.setHTMLStyle("RightID"," style={width:260px} ");
	doTemp.setHTMLStyle("INPUTUSER,UPDATEUSER"," style={width:160px} ");
	doTemp.setHTMLStyle("INPUTORG"," style={width:160px} ");
	doTemp.setHTMLStyle("INPUTTIME,UPDATETIME"," style={width:130px} ");
	doTemp.setHTMLStyle("REMARK"," style={width:400px} ");
	doTemp.setReadOnly("INPUTUSER,UPDATEUSER,INPUTORG,INPUTTIME,UPDATETIME",true);
 
	doTemp.setVisible("CommentText,REMARK,INPUTUSER,INPUTORG,UPDATEUSER,NPUTUSERNAME,INPUTORGNAME,UPDATEUSERNAME",false);    	
	doTemp.setUpdateable("INPUTUSERNAME,INPUTORGNAME,UPDATEUSERNAME",false);

	//��ѯ
 	doTemp.setColumnAttribute("CompID,CompPath,OrderNo","IsFilter","1");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	//if(!doTemp.haveReceivedFilterCriteria()) doTemp.WhereClause+=" And 1=2";
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
    dwTemp.setPageSize(30);

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
		{"true","","Button","����","����һ����¼","newRecord()",sResourcesPath},
		{"true","","Button","����","�鿴/�޸�����","viewAndEdit()",sResourcesPath},
		{"true","","Button","ɾ��","ɾ����ѡ�еļ�¼","deleteRecord()",sResourcesPath},
		{"true","","Button","���ɰ�����","Ϊ����û�й���˵����������ɰ�����","genComment()",sResourcesPath}
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
	/*~[Describe=������¼;InputParam=��;OutPutParam=��;]~*/
	function newRecord(){
        sReturn=popComp("CompInfo","/Common/Configurator/CompManage/CompInfo.jsp","","");
        if (typeof(sReturn)!='undefined' && sReturn.length!=0){
			//�������ݺ�ˢ���б�
			if (typeof(sReturn)!='undefined' && sReturn.length!=0){
				sReturnValues = sReturn.split("@");
				if (sReturnValues[0].length !=0 && sReturnValues[1]=="Y"){
					OpenPage("/Common/Configurator/CompManage/CompList.jsp","_self","");    
				}
			}
		}
	}
	
    /*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=��;]~*/
	function viewAndEdit(){
        var sCompID = getItemValue(0,getRow(),"CompID");
        if(typeof(sCompID)=="undefined" || sCompID.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return ;
		}
        //openObject("ComponentDefinition",sCompID,"001");
        popComp("CompView","/Common/Configurator/CompManage/CompView.jsp","ObjectNo="+sCompID,"","");
        if(confirm("�Ƿ�ˢ���б�")) reloadSelf();

	/*
	sReturn=popComp("CompInfo","/Common/Configurator/CompManage/CompInfo.jsp","CompID="+sCompID,"");
        //�޸����ݺ�ˢ���б�
        if (typeof(sReturn)!='undefined' && sReturn.length!=0) 
        {
		sReturnValues = sReturn.split("@");
		if (sReturnValues[0].length !=0 && sReturnValues[1]=="Y") 
		{
			OpenPage("/Common/Configurator/CompManage/CompList.jsp?CompID="+sCompID,"_self","");           
 		}
}
	*/
	}
    
	/*~[Describe=���ɰ�����;InputParam=��;OutPutParam=��;]~*/
	function genComment(){
		RunMethod("Configurator","GenerateCompComment","");
	}
	/*~[Describe=ɾ����¼;InputParam=��;OutPutParam=��;]~*/
	function deleteRecord(){
		var CompID = getItemValue(0,getRow(),"CompID");
		if(typeof(CompID)=="undefined" || CompID.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return ;
		}
		
		if(confirm(getHtmlMessage('2'))){
			as_del("myiframe0");
			as_save("myiframe0");  //�������ɾ������Ҫ���ô����
		}
	}
	
	</script>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List07;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script type="text/javascript">	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
    
</script>	
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>
