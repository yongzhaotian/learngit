<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
		/*
		Author:   cwzhan 2004-12-15
		Tester:
		Content:    ע��������
		Input Param:
                    CommentItemID��    ע������
 		Output param:
		                
		History Log: Thong 2005-03-15
            
	 */
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "ע��������"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%
	//�������
	String sSql ="",TempStr="";
	long Value = 0;
	SqlObject so = null;
	String sNewSql = "";
	//����������	
	String sCommentItemID =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("CommentItemID"));
	String sObjectType =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType",10));
	String sObjectNo =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo",10));
	if(sCommentItemID==null) sCommentItemID="";

	String sDefSortNo = "";

	//���û�д���sCommentItemID��������һ��������һ�������
	if(sCommentItemID.equals("") && sObjectType!= null){
		if(sObjectType!=null && sObjectType.equals("ComponentDefinition")){
			sNewSql = "select OrderNo from REG_COMP_DEF where CompID=:CompID";
			so=new SqlObject(sNewSql);
			so.setParameter("CompID",sObjectNo);
			sDefSortNo=Sqlca.getString(so);
		}
		sDefSortNo = "20"+sDefSortNo;

		//�ж�ҳ���Ƿ����
		if (sDefSortNo.equals("20999999")){
			%>
				<script type="text/javascript">
					alert("����ѡ��������δ���࣬�޷��������������Ƚ���������࣡");
					parent.close();
				</script>
		   <%
			   return ;
		}

		//add by thong
		//������ظ���ֵ��ô�ҳ����е����ֵ+10��(��REG_COMMENT_ITEM�е�SortNo��ֵ)
		ASResultSet rsTemp ;
		sNewSql = "select Count(*) from reg_comment_item where SortNo = :SortNo" ;
		so=new SqlObject(sNewSql);
		so.setParameter("SortNo",sDefSortNo);
		rsTemp = Sqlca.getASResultSet(so) ;
		rsTemp.next();
		int iCountTmp = rsTemp.getInt(1);
		if(iCountTmp>0) {
			String tValue = sDefSortNo.substring(0,4) ;
			sNewSql = "select Max(SortNo) from reg_comment_item where Sortno Like :Value";
			so=new SqlObject(sNewSql);
			so.setParameter("Value",tValue);
			ASResultSet rsTemp1 = Sqlca.getASResultSet(so) ;
			if(rsTemp1.next()) {
				String sValue =rsTemp1.getString(1);
				try{
					Value = Long.parseLong(sValue) + 10 ;
				}catch(Exception ex){
					throw new Exception("����������:"+sValue);
				}
			}
			rsTemp1.getStatement().close();
		}
		rsTemp.getStatement().close();
	}
%>
<%/*~END~*/%>



<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%	
   	String sHeaders[][] = {
				{"CommentItemID","ע������"},
				{"CommentItemName","ע�͵���"},
				{"SortNo","�����"},
				{"ChapterNo","�½ں�"},
				{"CommentItemType","ע��������"},
				{"CommentText","ע����������"},
				{"DocNo","ע���ĵ����"},
				{"DoGenDesignSpec","�Ƿ���������ĵ�"},
				{"DoGenHelp","�Ƿ����ɰ����ļ�"},
				{"Remark","��ע"},
				{"InputUserName","������"},
				{"InputUser","������"},
				{"InputOrgName","�������"},
				{"InputOrg","�������"},
				{"InputTime","����ʱ��"},
				{"UpdateUserName","������"},
				{"UpdateUser","������"},
				{"UpdateTime","����ʱ��"}
			       };  

	sSql = " Select  "+
				"CommentItemID,"+
				"CommentItemName,"+
				"SortNo,"+
				"ChapterNo,"+
				"CommentItemType,"+
				"CommentText,"+
				"DocNo,"+
				"DoGenDesignSpec,"+
				"DoGenHelp,"+
				"Remark,"+
				"getUserName(InputUser) as InputUserName,"+
				"InputUser,"+
				"getOrgName(InputOrg) as InputOrgName,"+
				"InputOrg,"+
				"InputTime,"+
				"getUserName(UpdateUser) as UpdateUserName,"+
				"UpdateUser,"+
				"UpdateTime "+
				"From REG_COMMENT_ITEM Where CommentItemID ='"+sCommentItemID+"'";
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.UpdateTable="REG_COMMENT_ITEM";
	doTemp.setKey("CommentItemID",true);
	doTemp.setHeader(sHeaders);

	doTemp.setDDDWCode("CommentItemType","CommentItemType");
	doTemp.setDDDWCodeTable("DoGenDesignSpec","true,��,false,��");
	doTemp.setDDDWCodeTable("DoGenHelp","true,��,false,��");
	doTemp.setHTMLStyle("CommentItemID,CommentItemName"," style={width:200px} ");
	doTemp.setHTMLStyle("SortNo"," style={width:160px} ");
	doTemp.setHTMLStyle("ChapterNo"," style={width:160px} ");
	doTemp.setHTMLStyle("DocNo"," style={width:160px} ");
	doTemp.setHTMLStyle("InputUser,UpdateUser"," style={width:160px} ");
	doTemp.setHTMLStyle("InputOrg"," style={width:160px} ");
	doTemp.setHTMLStyle("InputTime,UpdateTime"," style={width:130px} ");
	doTemp.setEditStyle("CommentText,Remark","3");
	doTemp.setHTMLStyle("CommentText,Remark"," style={height:100px;width:600px;overflow:auto} ");
    doTemp.appendHTMLStyle("CommentText"," onDBLClick=\"parent.editObjectValueWithScriptEditorForComment(this)\" style={width=400px;height=150px;overflow:auto;} ");
 	//doTemp.setLimit("Remark,CommentText",200);
	
	doTemp.setDefaultValue("DoGenDesignSpec","01");
	doTemp.setDefaultValue("DoGenHelp","01");
	doTemp.setDefaultValue("CommentItemType","020");
	if(Value == 0) {
		doTemp.setDefaultValue("SortNo",sDefSortNo);
		doTemp.setDefaultValue("CommentItemID",sDefSortNo);
	}else {
		TempStr = String.valueOf(Value) ;
		doTemp.setDefaultValue("SortNo",TempStr);
		doTemp.setDefaultValue("CommentItemID",TempStr);
	}

	doTemp.setReadOnly("InputUserName,UpdateUserName,InputOrgName,InputTime,UpdateTime",true);
	doTemp.setVisible("InputUser,InputOrg,UpdateUser,DocNo",false);    	
	doTemp.setUpdateable("InputUserName,InputOrgName,UpdateUserName",false);

	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);

	//filter��������
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д

	//��������¼�
	dwTemp.setEvent("AfterInsert","!Configurator.InsertCommRela(#CommentItemID,'"+sObjectType+"','"+sObjectNo+"')");
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
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
		{"true","","Button","���沢����","�����޸Ĳ�������һ����¼","saveRecordAndAdd()",sResourcesPath},
		};
	%> 
<%/*~END~*/%>




<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">
    var sCurCommentItemID=""; //��¼��ǰ��ѡ���еĴ����

	//---------------------���尴ť�¼�------------------------------------
	/*~[Describe=����;InputParam=�����¼�;OutPutParam=��;]~*/
	function saveRecord(){
		var sReturnValue = PopPageAjax("/Common/Configurator/CommentManage/GetBooleanValueAjax.jsp?sTempStr=<%=TempStr%>&rand="+randomNumber(),"", "dialogWidth:280px; dialogHeight:200px; help: no; scroll: no; status: no");
		if(typeof(sReturnValue) == "unedfined" || sReturnValue == "") {
			alert("����ʱ��������ϵͳ����Ա��ϵ��");
			return ;
		}else if(sReturnValue != "" && sReturnValue == '1') {
			setItemValue(0,0,"UpdateUser","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"UpdateTime","<%=StringFunction.getToday()%>");
			as_save("myiframe0","");
		}else {
			setItemValue(0,0,"SortNo",sReturnValue);
			setItemValue(0,0,"CommentItemID",sReturnValue);
			setItemValue(0,0,"UpdateUser","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"UpdateTime","<%=StringFunction.getToday()%>");
			as_save("myiframe0","");
		}
	}
    /*~[Describe=����;InputParam=�����¼�;OutPutParam=��;]~*/
	function saveRecordAndBack(){
        setItemValue(0,0,"UpdateUser","<%=CurUser.getUserID()%>");
        setItemValue(0,0,"UpdateTime","<%=StringFunction.getToday()%>");
        as_save("myiframe0","doReturn('Y');");
	}

    /*~[Describe=����;InputParam=�����¼�;OutPutParam=��;]~*/
	function saveRecordAndAdd(){
        as_save("myiframe0","newRecord()");
	}

    /*~[Describe=����;InputParam=��;OutPutParam=��;]~*/
    function doReturn(sIsRefresh){
		sObjectNo = getItemValue(0,getRow(),"CommentItemID");
        parent.sObjectInfo = sObjectNo+"@"+sIsRefresh;
		parent.closeAndReturn();
	}

    /*~[Describe=����һ����¼;InputParam=��;OutPutParam=��;]~*/
	function newRecord(){
        OpenComp("CommentItemInfo","/Common/Configurator/CommentManage/CommentItemInfo.jsp","","_self","");
	}

    function editObjectValueWithScriptEditorForComment(oObject){
		sInput = oObject.value;
		//alert(sInput);
		sInput = real2Amarsoft(sInput);
		sInput = replaceAll(sInput,"~","$[wave]");
		//alert(sInput);
		oTempObj = oObject;
        saveParaToComp("ScriptText="+sInput,"openScriptEditorForASScriptAndSetText()");
	}
    
    function openScriptEditorForASScriptAndSetText(){
		var oMyobj = oTempObj;
		<%
			if(TempStr != "" || TempStr != null){
				sDefSortNo = TempStr ;
			}
		%>
		sOutPut = popComp("ScriptEditorForComment","/Common/ScriptEditor/ScriptEditorForComment.jsp","CommentItemID=<%=sDefSortNo%>","");
		if(typeof(sOutPut)!="undefined" && sOutPut!="_CANCEL_")
		{
			oMyobj.value = amarsoft2Real(sOutPut);
		}
	}

	function initRow(){
		if (getRowCount(0)==0) //���û���ҵ���Ӧ��¼��������һ�����������ֶ�Ĭ��ֵ
		{
			as_add("myiframe0");//������¼
			setItemValue(0,0,"InputUserName","<%=CurUser.getUserName()%>");
			setItemValue(0,0,"InputOrgName","<%=CurOrg.getOrgName()%>");
			setItemValue(0,0,"InputTime","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"UpdateUserName","<%=CurUser.getUserName()%>");
			setItemValue(0,0,"UpdateTime","<%=StringFunction.getToday()%>");
 
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
