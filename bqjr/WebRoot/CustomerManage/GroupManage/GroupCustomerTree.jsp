<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%@ page import="com.amarsoft.app.als.customer.group.tree.DefaultContextLoader" %>
<%@ page import="com.amarsoft.app.als.customer.group.tree.component.*" %>
<%@ page import="com.amarsoft.are.jbo.JBOFactory"%>
<%@ page import="com.amarsoft.are.jbo.BizObject"%>
<%
/***************************************************
 * Module: GroupCustomerTree.jsp
 * Author: syang
 * Modified: 2010/09/26 16:15
 * Purpose: �������������ҳ��
 ***************************************************/
%>
<%
    String sGroupID=CurPage.getParameter("GroupID");
    String sGroupName=CurPage.getParameter("GroupName");
    //ĸ��˾�ͻ����(������ϵ������)
    String sKeyMemberCustomerID=CurPage.getParameter("KeyMemberCustomerID");
    //����ά���ļ��װ汾���
    String sRefVersionSeq=CurPage.getParameter("RefVersionSeq");
    //����ʹ�õļ��װ汾���
    String sCurrentVersionSeq=CurPage.getParameter("CurrentVersionSeq");
    //���ż��װ汾״̬
    String sFamilyMapStatus = CurComp.getParameter("FamilyMapStatus");
    //���ſͻ�����(�����/������):����"���ſͻ�����"��ť
    String sGroupType1 = CurComp.getParameter("GroupType1");
    //��ǰ�����ⲿ��Ϣ:���ڵ����ά���µļ��ס���ť����������ҳ����
    String sExternalVersionSeq = CurComp.getParameter("ExternalVersionSeq");
    //���ڿ�����ʾģʽ(����/�޶�),����ذ�ť
    String sRightType=CurComp.getParameter("RightType");
    String sInsertTreeNode=CurComp.getParameter("InsertTreeNode");  
    String groupCustomerID=CurComp.getParameter("GroupCustomerID");
    
    //ҳ����ʾ��Ϣ����ǰһҳ�洫���Ĺ��������������⣬�ʽ��ռ���״̬���ڱ�ҳ��ת��Ϊ���ģ�
    String treeViewDetail1 = CurComp.getParameter("TreeViewDetail1");
    String treeViewDetail2 = CurComp.getParameter("TreeViewDetail2");
    //���ż��װ汾״̬��������
    String sFamilyMapStatusName="";
    if("0".equals(treeViewDetail1)){
		sFamilyMapStatusName="�ݸ�";
	}else if("3".equals(treeViewDetail1)){
		sFamilyMapStatusName="����˻�";
	}else if("1".equals(treeViewDetail1)){
		sFamilyMapStatusName="�����";
	}else if("2".equals(treeViewDetail1)){
		sFamilyMapStatusName="���϶�";
	}
    
    //��ͼ˵��
    if(sGroupID==null) sGroupID=""; 
    if(sGroupName==null) sGroupName=""; 
    if(sKeyMemberCustomerID==null) sKeyMemberCustomerID=""; 
    if(sRefVersionSeq==null) sRefVersionSeq=""; 
    if(sCurrentVersionSeq==null) sCurrentVersionSeq=""; 
    if(sRightType == null) sRightType = "";
    if(sGroupType1 == null) sGroupType1 = "";
    if(sExternalVersionSeq == null) sExternalVersionSeq = "";
    if(treeViewDetail1 == null) treeViewDetail1 = "";
    if(sInsertTreeNode == null) sInsertTreeNode = "false";
    if(groupCustomerID == null) groupCustomerID = "";
    if(sFamilyMapStatus == null) sFamilyMapStatus = "";
    
    String TreeViewDetail="ϵͳ��Ϣ-���׸���״̬:["+sFamilyMapStatusName+"]-�汾���:["+treeViewDetail2+"]";//�汾�����Ϣ�ݲ���ʾ
    //String TreeViewDetail="Ŀǰ���װ汾״̬:��"+sFamilyMapStatusName+"��";
    
    //�жϵ�ǰ�����Ƿ��� ���϶� �ļ��װ汾���ָ������Ѹ��˰汾ʱʹ��
	int icount=JBOFactory.getBizObjectManager("jbo.app.GROUP_MEMBER_RELATIVE").createQuery("O.GroupID =:GroupID").setParameter("GroupID",sGroupID).getTotalCount();
	
    ASResultSet rsTemp = null;
    String sSql="";
    String sOldMemberCustomerID="";//���϶��ĺ�����ҵ�ͻ����
	sSql = "select MemberCustomerID from GROUP_MEMBER_RELATIVE where GroupID = :GroupID and ParentMemberID=:ParmentMemberID";
	rsTemp = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("GroupID",sGroupID).setParameter("ParmentMemberID","None"));
	if (rsTemp.next()){
		sOldMemberCustomerID  = DataConvert.toString(rsTemp.getString("MemberCustomerID"));
		//����ֵת���ɿ��ַ���
		if(sOldMemberCustomerID == null) sOldMemberCustomerID = "";
	}
    rsTemp.getStatement().close();    
	
    
    //���Ź����ά�����׿���ֱ����Ч 
    //String EditRight="2";
  
    /*=================================Ȩ��˵��==================================*/
    //������Ȩ�ޣ������¼���ȡֵ��All,Readonly,ViewOnly,None
    //All������Ȩ��;
    //Readonlyֻ�ܲ鿴�޶�ģʽ�����ݣ��������޸��޶�ģʽ������;
    //ViewOnlyֻ�ܲ鿴����ģʽ�����ݣ����ܲ鿴�޶�ģʽ������;
    //None����ʾ�κ���ģʽ�йصİ�ť
    String RIGHT_TYPE=sRightType;
    //-----------------------������������Ϊ�����������������������ҳ��ᱨ��-------------------
    String groupId = sGroupID;        //���ſͻ����
    String versionSeq=sRefVersionSeq;         //�汾��
    
    //-----------TreeTable��ʾ����������-------------
    String sButtons[][] = {
        {((sRightType.equals("All")&&sFamilyMapStatus.equals("2"))||((sRightType.equals("All")&&sFamilyMapStatus.equals("3")))?"true":"false"),"All","Button","ά���µİ汾 ","","NewVersionSeq()",sResourcesPath},
        {"false","All","Button","��ɼ���ά��","","save()",sResourcesPath},
        {(sFamilyMapStatus.equals("0")&&sRightType.equals("All")?"true":"false"),"All","Button","�ύ����","","doSubmit()",sResourcesPath},
        {((sRightType.equals("All")&&sFamilyMapStatus.equals("0")&&icount>0)?"true":"false"),"All","Button","ȡ������ά�� ","","cancel()",sResourcesPath},
    };
%>
<!DOCTYPE>
<script type="text/javascript" src="<%=sWebRootPath%>/CustomerManage/GroupManage/resources/js/jquery/jquery.treeTable.js"></script>
<script type="text/javascript" src="<%=sWebRootPath%>/CustomerManage/GroupManage/resources/js/jquery/jquery.treeTable.extends.js"></script>
<link rel="stylesheet" type="text/css" href="<%=sWebRootPath%>/CustomerManage/GroupManage/resources/css/jquery.treeTable.css"></link>
<link rel="stylesheet" type="text/css" href="<%=sWebRootPath%>/CustomerManage/GroupManage/resources/css/jquery.treeTable.extends.css"></link>
<style type="text/css">
 body{font-size:14px;}
 .treetable{font-size:12px;margin:10px;width:99%;border:none;}
 .treetable thead tr th{padding:6px 20px 6px auto;font-size:14px;font-weight: bold;border:none;border-top: 1px solid #369;border-bottom: 1px solid #369;}
 .treetable tbody tr td{padding:3px 20px 3px auto;border-bottom: 1px dotted #369;}
/*���Ƴ�*/
.treetable tbody tr.removed td{text-decoration:line-through;color: #F00;}
/*�ڱ�ɾ�������ȥ���õ�Ԫ���ɾ����*/
.treetable tbody tr.removed .noremoved{text-decoration:none;}
/*�޸Ĺ�*/
.treetable tbody tr.changed td{color: #00F;}
/*�½���*/
.treetable tbody tr.new td{color:#008000;}
.newbutton{padding:2px;text-decoration: none;}
.newbutton:hover{color:#F00;}

/*-------------------------------------*/
.mydiv{font-size:14px;padding:3px;}
#normalAction,#revisionAction{text-decoration: none;padding:2px;}
#normalAction:hover,#revisionAction:hover{color:#DAA520;}
.actived{border:1px solid #B0C4DE;background-color: #FAFAD2;}
</style>
<body>
<div class="mydiv" ><%=TreeViewDetail%></div>
<div id="buttonBar">
<table>
	<tr height=1 id="ButtonTR">
		<td id="ListButtonArea" class="ListButtonArea" valign=top>
			<%@ include file="/Resources/CodeParts/ButtonSet.jsp"%>
		</td>
	</tr>
</table>
</div>
<% if(RIGHT_TYPE.equals("All") && sFamilyMapStatus.equals("0")){ %>
<div class="mydiv"><span class="mylabel">��ʾģʽ��</span><a href="javascript:void(0)" id="normalAction">����</a><a href="javascript:void(0)" id="revisionAction">�޶�ģʽ</a></div>
<%} %>
<div class="mydiv"><span class="mylabel">��&nbsp;&nbsp;�ң�</span><input type="text" id="searchText"></input></div>
<%
    response.setHeader("Cache-Control","no-store");
    response.setHeader("Pragma","no-cache");
    response.setDateHeader("Expires",0);
    //��ȫ�ֱ����Ǳ���ģ����ڿ��ƾ���ʹ���ĸ��ڵ��࣬���������ҳ�淴�����
    String treeNodeClassName = "";
    //����ʵ��
    DefaultContextLoader loader = new DefaultContextLoader(CurUser,sGroupID,versionSeq) ;
    FacesContext context = loader.getContext();
    
    context.setAttribute("Header","���ſͻ�������ά��");
    //������Ⱦ����
    HTMLRenderer<FamilyTreeNode> renderer = new TreeTableRenderer<FamilyTreeNode>();
    ((TreeTableRenderer<FamilyTreeNode>)renderer).setHeaderSetting("{memberName=����,shareValue=�ֹɱ���}");
    ((TreeTableRenderer<FamilyTreeNode>)renderer).setCodeSetting("{{id=root:��,1010:��һ��}}");
    treeNodeClassName = FamilyTreeNode.class.getName();
    //��ʼ����
    renderer.encodeBegin(context, (FamilyTreeNode)context.getRootComponent());
    renderer.encodeBody(context, (FamilyTreeNode)context.getRootComponent());
    renderer.encodeEnd(context, (FamilyTreeNode)context.getRootComponent());
    //���
    out.println(renderer.getHTML());
%>
</body>
</html>
<!-- ************************************************ -->
<!--                   ��ť����                                                              -->
<!-- ************************************************ -->
<script type="text/javascript"> 
	function save(){
		var sGroupID = "<%=sGroupID%>";//���ſͻ����
	    if (typeof(sGroupID) == "undefined" || sGroupID.length == 0){
	        alert("ά���µļ���ʧ��,���ſͻ����Ϊ��!");
	        return;
	    }
		
    	var sRefVersionSeq = "<%=sRefVersionSeq%>";//����ά���ļ��װ汾���
       if(confirm("���ȷ��,�������µļ��ײ��Ե�ǰ����ͨ���ļ��׽���ʧЧ����!")){
			var sReturn=RunJavaMethodTrans("com.amarsoft.app.als.customer.group.model.UpdateFamilyApproveStatus","updateFamilyApproveStatus","userID=<%=CurUser.getUserID()%>,groupID="+sGroupID+",versionSeq="+sRefVersionSeq+",effectiveStatus=2");
			if(sReturn=="SUCCEEDED"){
				alert("��ǰ�����Ѿ���Ч��");	
				parent.parent.amarTab.refreshWidgetTab('���ż��׸ſ�');
			}else{
				alert("��ǰ����ά��ʧ�ܣ�");	
			}
		}
	}
	function doSubmit(){
    	var sGroupID = "<%=sGroupID%>";//���ſͻ����
    	var sCurrentVersionSeq="<%=sCurrentVersionSeq%>";
    	var sRefVersionSeq = "<%=sRefVersionSeq%>";//����ά���ļ��װ汾���
    	//�����г�Ա���и��ˣ����ż��׳�Ա������2���ſɽ��������ύ����
    	var sReturn = RunJavaMethod("com.amarsoft.app.als.customer.group.action.CheckGroupMemberCount","checkGroupMemberCount","groupId="+sGroupID+",VersionSeq="+sRefVersionSeq);
    	if(sReturn == "No"){
			alert("�ü��ų�Ա����2���������ύ���ˣ�");
			return;
        }
    	//�����г�Ա���и��ˣ������Ա�����������д��ڣ��������ύ����  
		sReturn = RunJavaMethod("com.amarsoft.app.als.customer.group.action.GroupCustomerManage","checkAllGroupMember","GroupID="+sGroupID);
		if(sReturn!="true"){
			alert(sReturn);
			return ;
		}
		var sReturn = AsControl.PopView("/CustomerManage/GroupManage/FamilyVersionApplyOpinionInfo.jsp","GroupID="+sGroupID+"&VersionSeq="+sRefVersionSeq+"&CurrentVersionSeq="+sCurrentVersionSeq+"&EditRight=1&GroupType1=<%=sGroupType1%>","dialogWidth=40;dialogHeight=30;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
    	if(sReturn=="successed"){
			alert("�ύ���˳ɹ�");
			var sParam="TreeViewDetail1=1&TreeViewDetail2=<%=treeViewDetail2%>&RightType=<%=sRightType%>&FamilyMapStatus=1&GroupID=<%=sGroupID%>&KeyMemberCustomerID=<%=sKeyMemberCustomerID%>&RefVersionSeq=<%=sRefVersionSeq%>&CurrentVersionSeq=<%=sCurrentVersionSeq%>&GroupType1=<%=sGroupType1%>&InsertTreeNode=<%=sInsertTreeNode%>&GroupCustomerID=<%=groupCustomerID%>";
			OpenComp("GroupCustomerTree","/CustomerManage/GroupManage/GroupCustomerTree.jsp",sParam,"_self");
 	 	}
	}

	function NewVersionSeq(){
        var sGroupID = "<%=sGroupID%>";
	    if (typeof(sGroupID) == "undefined" || sGroupID.length == 0){
	        alert("ά���µļ���ʧ��,���ſͻ����Ϊ��!");// 
	        return;
	    }
		if(confirm("���ȷ��,�������µļ��ײ��Ե�ǰ����ͨ���ļ��׽���ʧЧ����!")){
		  	//���³�ʼ�����װ汾�����׳�Ա��,�������µ�����ά�����װ汾���
			var sRefVersionSeq=RunJavaMethodTrans("com.amarsoft.app.als.customer.group.action.FamilyMaintain","getNewRefVersionSeq","userID=<%=CurUser.getUserID()%>,groupID="+sGroupID+",currentVersionSeq=<%=sCurrentVersionSeq%>");
		  	if(typeof(sRefVersionSeq)!="undefined" && sRefVersionSeq.length !=0 && sRefVersionSeq!="ERROR"){
				var sParam="TreeViewDetail1=0&TreeViewDetail2="+sRefVersionSeq+"&RightType=<%=sRightType%>&FamilyMapStatus=0&GroupID=<%=sGroupID%>&KeyMemberCustomerID=<%=sKeyMemberCustomerID%>&RefVersionSeq="+sRefVersionSeq+"&CurrentVersionSeq=<%=sCurrentVersionSeq%>&GroupType1=<%=sGroupType1%>&InsertTreeNode=<%=sInsertTreeNode%>&GroupCustomerID=<%=groupCustomerID%>";
				OpenComp("GroupCustomerTree","/CustomerManage/GroupManage/GroupCustomerTree.jsp",sParam,"_self");
			}
		}
	}
	
	//ȡ���Ե�ǰ���׵�ά�������������׻ָ������µ��Ѹ��˹��İ汾
	function cancel(){
		var sGroupID = "<%=sGroupID%>";
		if (typeof(sGroupID) == "undefined" || sGroupID.length == 0){
	        alert("����ʧ��,���ſͻ����Ϊ��!");
	        return;
	    }
		var sRefVersionSeq="<%=sRefVersionSeq%>";//��ǰ����ά���ļ��װ汾
		var sCurrentVersionSeq="<%=sCurrentVersionSeq%>";//�������϶��ļ��װ汾���
        
		if(confirm("�Ƿ�ȡ���Լ��׵�ά�����������׻ָ����������϶�״̬!")){
			var sReturn=RunJavaMethodTrans("com.amarsoft.app.als.customer.group.action.FamilyMaintain","deleteRefVersion","userID=<%=CurUser.getUserID()%>,groupID="+sGroupID+",refVersionSeq="+sRefVersionSeq+",currentVersionSeq="+sCurrentVersionSeq+",oldMemberCustomerID=<%=sOldMemberCustomerID%>");
		  	if(sReturn="true"){
				alert("�ָ����ż��׳ɹ�!");
				var sParam="TreeViewDetail1=2&TreeViewDetail2=<%=sCurrentVersionSeq%>&RightType=<%=sRightType%>&FamilyMapStatus=2&GroupID=<%=sGroupID%>&KeyMemberCustomerID=<%=sKeyMemberCustomerID%>&RefVersionSeq="+sCurrentVersionSeq+"&CurrentVersionSeq=<%=sCurrentVersionSeq%>&GroupType1=<%=sGroupType1%>&InsertTreeNode=<%=sInsertTreeNode%>&GroupCustomerID=<%=groupCustomerID%>";
				OpenComp("GroupCustomerTree","/CustomerManage/GroupManage/GroupCustomerTree.jsp",sParam,"_self");
			}
		}
	}
</script>

<!-- ************************************************ -->
<!--                   ��ͼ����                                                              -->
<!-- ************************************************ -->
<script type="text/javascript"> 
//����ʵ����ʵ��ҵ���߼��߶ȹ�����javascript�߼�
    var sKeyMemberCustomerID="<%=sKeyMemberCustomerID%>";
    var table = null;
    var normalModel = true;
    $(document).ready(function() {
        table = $("table.treetable");
        //����treeTable
        table.treeTable({initialState:"expanded"});
        //���������ı䱳�������������¼�
        table.tableLight();
        
        //��������
        $("#searchText").keyup(function(){
            var text = $("#searchText").val();
            var searchResult = table.searchText({
                keyWord:text,             //����text����
                excludeColumn:"editCol"   //���ò���������
            });
        });
        //ģʽת����ť
        $("#normalAction").click(normalModelHandler);//����ģʽ
        $("#revisionAction").click(revisionModelHandler);//�޶�ģ��
        normalModelHandler();//Ĭ��Ϊ����ģʽ
        return;
    });
    //����ģʽ
    function normalModelHandler(){
        //������ʾ
        $("#normalAction").addClass("actived");
        $("#revisionAction").removeClass("actived");
        
        $("tbody tr",table).each(function(){
            $(this).removeClass("new changed removed");
            if($(this).getValue("state")=="REMOVED"){
                $(this).hide();
                $(this).attr("hidden",true);
            }
        });
        //ɾ��������
        try{table.removeColumn({name:"editCol"});}catch(e){};
        normalModel = true;
    }
    //�޶�ģʽ
    function revisionModelHandler(){
        //ֻ��ӵ������Ȩ�޲ſ����޸� 
    	  <% if(sRightType.equals("All")){%>
        //��Ӳ�����
        var buttonClass="newbutton";
        table.addExecuteColumn({
            headerText:"����",  //������
            name:"editCol",  //��ť������
            colClass:"noremoved",//��ť��ʹ�õ���ʽ����Ҫ����ȥ��ɾ��ʱ�����ӵ�ɾ����
            buttons:[
                    {buttonClass:buttonClass,text : "����",title:"����һ����Ա",execute : insertHandler}
                    ,{buttonClass:buttonClass,text : "�޸�",execute : editHandler,filter : editActionFilter}
                    ,{buttonClass:buttonClass,text : "ɾ��",title:"���Ϊɾ��",execute : deleteHandler,filter : deleteActionFilter}
                    //,{buttonClass:buttonClass,text : "����",execute : undoHandler,filter : undoActionFilter}
                    ]
        });   
        <% }%>      
        //������ʾ
        $("#normalAction").removeClass("actived");
        $("#revisionAction").addClass("actived");
        
        $("tbody tr",table).each(function(){
            $(this).attr("hidden",false);//ȡ������
            if($(this).getValue("state")=="NEW"){
                $(this).addClass("new");
            }else if($(this).getValue("state")=="CHANGED"){
                $(this).addClass("changed");
            }if($(this).getValue("state")=="REMOVED"){
                //������ڵ�û��չ��������Ҫ��ʾ
                //if($(this).parent().hasClass("expanded"))$(this).show();
                //$(this).addClass("removed");
            	 $(this).hide();
                 $(this).attr("hidden",true);
            }
        });
       //�޶���־
        normalModel = false;
    }
    //���尴ť������
    //-----------------------------------------------
    //�༭��ť������ ɾ����ť
    function deleteActionFilter(tr){
        if(tr&&tr.attr&&(tr.attr("id")==sKeyMemberCustomerID)) return false;//���ڵ㲻��ɾ����ť
        else return true;
    }
    //��ʽ��Ա�����޸�
    function editActionFilter(tr){
        if(tr&&tr.attr&&(tr.attr("id")==sKeyMemberCustomerID|| tr.getValue("state")=="CHECKED"))return false;//���ڵ㡢��ʽ��Ա ֻ��ɾ�������ܱ༭���߳���
        else return true;
    }

  //�༭��ť������  ������ť
    function undoActionFilter(tr){
        if(tr&&tr.attr&&tr.attr("id")==sKeyMemberCustomerID) return false;//���ڵ㡢��ʽ��Ա���ܳ���
        else return true;
    }
    
    //���尴ť����
    //----------------------------------------------------------
    //�����½ڵ㣬�������ų�Ա
	function insertHandler(){
		var currentRow = $(this).parents("tr");
       var newRow = currentRow.clone(true);
		var sRefVersionSeq ="<%=sRefVersionSeq%>";
		var sGroupID="<%=sGroupID%>";
		var parentId = currentRow.getValue("id");
		var dialogStyle = "dialogWidth=600px;dialogHeight=400px;status:no;center:yes;help:no;minimize:yes;maximize:no;border:thin;statusbar:no";
		var pageURL="/CustomerManage/MemberInfoViewer.jsp";
		var oReturn= AsControl.PopView(pageURL,"GroupID="+sGroupID+"&ParentMemberID="+parentId+"&RefVersionSeq="+sRefVersionSeq,dialogStyle);
       if(typeof(oReturn) != "undefined"){
         	fillRow(newRow,oReturn,"NEW");
        	var ret = TreeTableContext.addNode(newRow.nodeJSON());
      	 	if(ret){
      	 		applyCSS(newRow,"new");
            	newRow.appendNewBranchTo(currentRow);//�ɹ��󣬲���ӽڵ�
           		//���¼��������
            	normalModelHandler();
            	revisionModelHandler();
       		}
		}
    }

    function fillRow(row,json,state){
    	row.setValue("id",json["MemberCustomerID"]);
    	row.setValue("memberName",json["MemberName"]);
    	row.setValue("memberCertType",json["MemberCertType"]);
     	row.setValue("memberCertID",json["MemberCertID"]);
     	row.setValue("memberType",json["MemberType"]);
     	if(json["ShareValue"] != null){
         	if(typeof json["ShareValue"] != "string") json["ShareValue"] = json["ShareValue"].toString();
	     	row.setValue("shareValue",json["ShareValue"]);
        }
    	row.setValue("parentId",json["ParentMemberID"]);
    	row.setValue("parentRelationType",json["ParentRelationType"]);
    	row.setValue("addReason",json["AddReason"]);
    	row.setValue("state",state);
    }
    //�༭���ų�Ա��Ϣ
    function editHandler(){
        var currentRow = $(this).parents("tr");
        var state = currentRow.getValue("state");
        if(state=="REMOVED"){
            alert("��ǰ�ڵ�Ϊɾ��״̬�����ȳ���");
            return;
        }
        var memberJson = viewMemberInfo(currentRow.nodeJSON());
        if(memberJson){
        	fillRow(currentRow,memberJson,"CHANGED");
        }
    }
	//ɾ�����ų�Ա
	function deleteHandler(){
		 var currentRow = $(this).parents("tr"); 
		 var sRefVersionSeq ="<%=sRefVersionSeq%>";
        var sGroupID="<%=sGroupID%>";
        var parentId = currentRow.getValue("id");
        var sReturn = RunJavaMethod("com.amarsoft.app.als.customer.group.action.CheckSubMemberFamilyTree","subMemberExist","GroupId="+sGroupID+",ParentMemberID="+parentId+",VersionSeq="+sRefVersionSeq);
		 if(sReturn == "EXIST"){
			alert("�ó�Ա�´����ӽڵ㣬����ɾ���ӽڵ���ִ�д˲�����");
			return;
		 }
    	 if(!confirm("��ȷ��Ҫɾ���ó�Ա��"))return;
    	 //ִ��ɾ��
         var ret = TreeTableContext.removeNode(currentRow.nodeJSON());
         if(ret)currentRow.removeBranch();
    }

    //ɾ��
    function deleteHandler2(){
		var currentRow = $(this).parents("tr");
		var state = currentRow.getValue("state");
		if(state=="NEW"){
			alert("״̬Ϊ�����Ľڵ㣬����ɾ����ֻ�ܳ���");
			return;
        }
		var nodes = [];
		nodes[0] = currentRow;
		currentRow.progeny().each(function(){
			nodes.push($(this));
        });
        applyState(nodes,"removed");
    }
    //����
    function undoHandler(){
        var currentRow = $(this).parents("tr");
        var state=currentRow.getValue("state");
        if(state=="NEW"){//Ϊ�½ڵ�ʱ����������Ϊɾ���½ڵ�
            if(!confirm("��ǰ�ڵ�Ϊ�½ڵ㣬������ɾ���ýڵ㣬ȷ��������"))return;
            //ִ��ɾ��
            var ret = TreeTableContext.removeNode(currentRow.nodeJSON());
            if(ret)currentRow.removeBranch();
        }else if(state=="REMOVED"){
            var parentNode = currentRow.parent();
            if(parentNode.getValue("state")=="REMOVED"){
                alert("���ȳ������ڵ��ɾ��״̬");
                return;
            }
            applyState(currentRow,"CHANGED");
        }else if(state=="CHANGED"){
            applyState(currentRow,"CHECKED");
        }
    }
    function deleteData(){
        var currentRow = $(this).parents("tr");
        var ret = TreeTableContext.removeNode(currentRow.nodeJSON());
        if(ret)currentRow.removeBranch();
    }
    //�޸�״̬
    function applyState(node,stateValue){
        stateValue = stateValue.toUpperCase();//תΪ��д
        //�ȸ��·��������
        if($.isArray(node)){//Ϊ��������,����ҳ�����������
            var nodes = [];
            for(var i=0;i<node.length;i++){//�ҳ�����������JSON����
                var item = node[i];
                if(item.getValue("state")==stateValue)continue;//���״̬û�иı䣬����Ҫ����
                item.setValue("state",stateValue);
                nodes[i] = item.nodeJSON();
            }
            if(nodes.length==0)return false;  //���û����Ҫ�ĸı�ģ�ֱ�ӷ���
            var ret = TreeTableContext.setValue(nodes);//��������
            if(ret>0){                        //�ɹ����޸Ŀͻ�����ʾ
                for(var i=0;i<node.length;i++){
                    applyCSS(node[i],stateValue.toLowerCase());
                }
                return true;
            }
            return false;
        }else if(typeof(node)=="object"){//������������
            if(node.getValue("state")==stateValue)return false;//���״̬һ���������޸���
            node.setValue("state",stateValue);
            var ret = TreeTableContext.setValue(node.nodeJSON());
            if(ret){//���������޸Ŀͻ�����ʾ
                applyCSS(node,stateValue.toLowerCase());
                return true;
            };
            return false;
        }
    }
    function applyCSS(node,cssName){
        var removedClassName = "new changed removed";
        node.removeClass(removedClassName);
        node.addClass(cssName);
    }

    //���һ���³�Ա
    function addMember(member){
		if(normalModel){
            alert("��ǰģʽ��Ϊ�޶�ģʽ��������ӽڵ�");
            return;
        }
		var selectedRecord = getSelected();
		if(selectedRecord.size()==0){
            alert("�����Ҳ���ѡ��һ����¼");
            return;
        } 
        
		var memberid=member["id"];//ѡ�нڵ��Ա�ͻ����
		var sReturn=RunJavaMethod("com.amarsoft.app.als.customer.group.action.GroupCustomerManage","isGroupCustomer","MemberCustomerID="+memberid+",GroupID="+<%=sGroupID%>);
 		if(sReturn!="true"){//��ó�Ա�������������Ų�������ӣ�ϵͳ������ʾ��Ϣ
			alert(sReturn);
			return;
		}
        
		try{ 
			var bexists=false;
			$("tbody tr",table).each(function(){ 
				myNode=$(this);
				if(myNode.getValue("memberName")==member["memberName"]){
					bexists=true;
				}
			});
        	 
			if(member && !bexists){ 
				var newNode = selectedRecord.clone(true);
				newNode.setValue("state","NEW");
				newNode.setValue("id",member["id"]);
          		newNode.setValue("shareValue","0.0");
          		newNode.setValue("memberCertType",member["memberCertType"]);
          		newNode.setValue("memberCertID",member["memberCertID"]);
          		newNode.setValue("memberName",member["memberName"]);
          		newNode.setValue("parentId",selectedRecord.getValue("id"));
          		newNode.setValue("parentRelationType","01");
          		selectedRecord.removeClass("selected");
          		var ret = TreeTableContext.addNode(newNode.nodeJSON());
          		if(ret){
              	applyCSS(newNode,"new");
              	newNode.appendNewBranchTo(selectedRecord);//�ɹ��󣬲���ӽڵ�
          		}
          		//���¼��������
          		normalModelHandler();
          		revisionModelHandler(); 
 			}else{
    			if(!member) alert("û�д���ͻ�����");
      			if(bexists){
					alert("["+member["memberName"]+"]"+"�����ڵ�ǰ���ų�Ա,����Ҫ�ٴ����!");
					return ;
        		}
	        }
        }catch(e){
			alert("�Բ���ýڵ�["+member["memberName"]+"]�Ѵ���");
        }
    }
    //��ȡ��ѡ�еļ�¼
    function getSelected(){
        return $("tr.selected",table);
    }

    //�鿴����
    function viewMemberInfo(json){
        var MemberCustomerID = json["id"];
        var param = [
                     "MemberCustomerID="+MemberCustomerID
                     ,"GroupID=<%=sGroupID%>"
                     ,"RefVersionSeq=<%=sRefVersionSeq%>"
                     ];
        var dialogStyle = "dialogWidth=600px;dialogHeight=400px;status:no;center:yes;help:no;minimize:yes;maximize:no;border:thin;statusbar:no";
        var pageURL="/CustomerManage/MemberInfoViewer.jsp";
        return AsControl.PopView(pageURL,param.join("&"),dialogStyle);
    }
</script>
<!-- ************************************************ -->
<!--                   �������                                                              -->
<!-- ************************************************ -->
<script language="javascript">
//������ͼ�ڵ�ʵ����
TreeTableContext.treeNodeClassName="<%=treeNodeClassName%>";
TreeTableContext.redirector=sWebRootPath + "/Redirector";
TreeTableContext.contextHelperURL="/CustomerManage/GroupManage/Component/TreeTableContextHelper.jsp";
</script>

<script language="javascript" type="text/javascript">
<%if("".equals(sGroupID) || "".equals(sRefVersionSeq)){ %>
    alert("����������,��ͼ�޷�չ��!");
<% }%>
</script>

<%@ include file="/IncludeEnd.jsp"%>