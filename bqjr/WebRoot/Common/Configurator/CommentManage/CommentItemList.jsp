<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   cwzhan 2004-12-28
		Tester:
		Content: ע�����б�
		Input Param:
                  
		Output param:
		                
		History Log: 
            
	 */
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "ע�����б�"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
	String sSql;
	
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
				"CommentItemID,"+
				"CommentItemName,"+
				"SortNo,"+
				"ChapterNo,"+
				"getItemName('CommentItemType',CommentItemType) as CommentItemType,"+
				"CommentText,"+
				"DocNo,"+
				"DoGenDesignSpec,"+
				"DoGenHelp,"+
				"REMARK,"+
				"getUserName(INPUTUSER) as INPUTUSERNAME,"+
				"INPUTUSER,"+
				"getOrgName(INPUTORG) as INPUTORGNAME,"+
				"INPUTORG,"+
				"INPUTTIME,"+
				"getUserName(UPDATEUSER) as UPDATEUSERNAME,"+
				"UPDATEUSER,"+
				"UPDATETIME "+
				"From REG_COMMENT_ITEM where 1=1";
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.UpdateTable="REG_COMMENT_ITEM";
	doTemp.setKey("CommentItemID",true);
	doTemp.setHeader(sHeaders);

	doTemp.setHTMLStyle("CommentItemID"," style={width:160px} ");
	doTemp.setHTMLStyle("CommentItemName"," style={width:160px} ");
	doTemp.setHTMLStyle("SortNo"," style={width:160px} ");
	doTemp.setHTMLStyle("ChapterNo"," style={width:160px} ");
	doTemp.setHTMLStyle("DocNo"," style={width:160px} ");
	doTemp.setHTMLStyle("DoGenDesignSpec"," style={width:160px} ");
	doTemp.setHTMLStyle("INPUTUSER,UPDATEUSER"," style={width:160px} ");
	doTemp.setHTMLStyle("INPUTORG"," style={width:160px} ");
	doTemp.setHTMLStyle("INPUTTIME,UPDATETIME"," style={width:130px} ");
	doTemp.setHTMLStyle("REMARK"," style={width:400px} ");
	doTemp.setReadOnly("INPUTUSER,UPDATEUSER,INPUTORG,INPUTTIME,UPDATETIME",true);
 
	doTemp.setVisible("CommentText,REMARK,INPUTUSER,INPUTORG,UPDATEUSER,NPUTUSERNAME,INPUTORGNAME,UPDATEUSERNAME",false);    	
	doTemp.setUpdateable("INPUTUSERNAME,INPUTORGNAME,UPDATEUSERNAME",false);

	//��ѯ
 	doTemp.setColumnAttribute("CommentItemID","IsFilter","1");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	//if(!doTemp.haveReceivedFilterCriteria()) doTemp.WhereClause+=" Where 1=2";

	//filter��������
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.setPageSize(200);

	//��������¼�
	dwTemp.setEvent("BeforeDelete","!Configurator.DelCommentRela(#CommentItemID)");
	
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
		{"true","","Button","ע�͹����б�","�鿴/�޸�ע�͹����б�","viewAndEdit2()",sResourcesPath},
		{"true","","Button","ɾ��","ɾ����ѡ�еļ�¼","deleteRecord()",sResourcesPath}
		};
	%> 
<%/*~END~*/%>




<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">
    var sCurCodeNo=""; //��¼��ǰ��ѡ���еĴ����

	//---------------------���尴ť�¼�------------------------------------
	/*~[Describe=������¼;InputParam=��;OutPutParam=��;]~*/
	function newRecord()
	{
        sReturn=popComp("CommentItemInfo","/Common/Configurator/CommentManage/CommentItemInfo.jsp","","");
        if (typeof(sReturn)!='undefined' && sReturn.length!=0) 
        {
            //�������ݺ�ˢ���б�
            if (typeof(sReturn)!='undefined' && sReturn.length!=0) 
            {
                sReturnValues = sReturn.split("@");
                if (sReturnValues[0].length !=0 && sReturnValues[1]=="Y") 
                {
                    OpenPage("/Common/Configurator/CommentManage/CommentItemList.jsp","_self","");    
                }
            }
        }
	}
	
    /*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=��;]~*/
	function viewAndEdit()
	{
        sCommentItemID = getItemValue(0,getRow(),"CommentItemID");
        if(typeof(sCommentItemID)=="undefined" || sCommentItemID.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
            return ;
		}
        //openObject("CommentItemView",sCommentItemID,"001");
        popComp("CommentItemView","/Common/Configurator/CommentManage/CommentItemView.jsp","ObjectNo="+sCommentItemID);
	}
    
    /*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=��;]~*/
	function viewAndEdit2()
	{
        sCommentItemID = getItemValue(0,getRow(),"CommentItemID");
        if(typeof(sCommentItemID)=="undefined" || sCommentItemID.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
            return ;
		}
        popComp("CommentRelaList","/Common/Configurator/CommentManage/CommentRelaList.jsp","CommentItemID="+sCommentItemID,"");
	}

    
	/*~[Describe=ɾ����¼;InputParam=��;OutPutParam=��;]~*/
	function deleteRecord()
	{
		sCommentItemID = getItemValue(0,getRow(),"CommentItemID");
        if(typeof(sCommentItemID)=="undefined" || sCommentItemID.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
            return ;
		}
		
		if(confirm(getHtmlMessage('45'))) 
		{
			as_del("myiframe0");
			as_save("myiframe0");  //�������ɾ������Ҫ���ô����
		}
	}
	
	</script>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">
	
	function mySelectRow()
	{
        
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
