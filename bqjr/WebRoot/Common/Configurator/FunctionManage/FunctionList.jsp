<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   cwzhan 2004-12-20
		Tester:
		Content: ���ܶ����б�
		Input Param:
                  
		Output param:
		                
		History Log: 
            
	 */
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "���ܶ����б�"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
	String sSql;
	
	//����������	
	String sCompID = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CompID"));
	if(sCompID == null) sCompID = "";
	
%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%	
   	String sHeaders[][] = {
					{"FunctionID","FunctionID"},
					{"CompID","CompID"},
					{"PageID","PageID"},
					{"FunctionName","FunctionName"},
					{"RightID","RightID"},
					{"TargetComp","TargetComp"},
					{"InfoRightType","InfoRightType"},
					{"DefaultForm","DefaultForm"},
					{"TargetPage","TargetPage"},
					{"Remark","��ע"},
					{"InputUserName","������"},
					{"InputUser","������"},
					{"InputOrgName","�������"},
					{"InputOrg","�������"},
					{"InputTime","����ʱ��"},
					{"UpdateTimeName","������"},
					{"UpdateUser","������"},
					{"UpdateTime","����ʱ��"}
			       };  

	sSql = 	" Select  "+
			"FunctionID,"+
			"CompID,"+
			"PageID,"+
			"FunctionName,"+
			"RightID,"+
			"TargetComp,"+
			"InfoRightType,"+
			"DefaultForm,"+
			"TargetPage,"+
			"Remark,"+
			"getUserName(InputUser) as InputUserName,"+
			"InputUser,"+
			"getOrgName(InputOrg) as InputOrgName,"+
			"InputOrg,"+
			"InputTime,"+
			"getUserName(UpdateUser) as UpdateUserName,"+
			"UpdateUser,"+
			"UpdateTime "+
			"From REG_FUNCTION_DEF where 1=1 ";
	if(!sCompID.equals("")) sSql = sSql + " and CompID = '"+sCompID+"' ";
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.UpdateTable="REG_FUNCTION_DEF";
	doTemp.setKey("FunctionID",true);
	doTemp.setHeader(sHeaders);

	doTemp.setHTMLStyle("FunctionID"," style={width:160px} ");
	doTemp.setHTMLStyle("CompID"," style={width:160px} ");
	doTemp.setHTMLStyle("PageID"," style={width:160px} ");
	doTemp.setHTMLStyle("FunctionName"," style={width:160px} ");
	doTemp.setHTMLStyle("RightID"," style={width:160px} ");
	doTemp.setHTMLStyle("TargetComp"," style={width:160px} ");
	doTemp.setHTMLStyle("InfoRightType"," style={width:160px} ");
	doTemp.setHTMLStyle("DefaultForm"," style={width:160px} ");
	doTemp.setHTMLStyle("TargetPage"," style={width:160px} ");
	doTemp.setHTMLStyle("InputUser,UpdateUser"," style={width:160px} ");
	doTemp.setHTMLStyle("InputOrg"," style={width:160px} ");
	doTemp.setHTMLStyle("InputTime,UpdateTime"," style={width:130px} ");
	doTemp.setHTMLStyle("Remark"," style={width:400px} ");
	
	doTemp.setReadOnly("InputUser,UpdateUser,InputOrg,InputTime,UpdateTime",true);
	doTemp.setVisible("CommentText,Remark,InputUser,InputOrg,UpdateUser,InputUserName,InputOrgName,UpdateUserName",false);    	
	doTemp.setUpdateable("InputUserName,InputOrgName,UpdateUserName",false);

	//��ѯ
 	doTemp.setColumnAttribute("FunctionID","IsFilter","1");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	//if(!doTemp.haveReceivedFilterCriteria()) doTemp.WhereClause+=" and 1=2";
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.setPageSize(200);
	
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
		{"true","","Button","ɾ��","ɾ����ѡ�еļ�¼","deleteRecord()",sResourcesPath}
		};
	%> 
<%/*~END~*/%>




<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">
    var sCurFunctionID=""; //��¼��ǰ��ѡ���еĴ����

	//---------------------���尴ť�¼�------------------------------------
	/*~[Describe=������¼;InputParam=��;OutPutParam=��;]~*/
	function newRecord()
	{
        sReturn=popComp("FunctionInfo","/Common/Configurator/FunctionManage/FunctionInfo.jsp","","");
        if (typeof(sReturn)!='undefined' && sReturn.length!=0) 
        {
            //�������ݺ�ˢ���б�
            if (typeof(sReturn)!='undefined' && sReturn.length!=0) 
            {
                sReturnValues = sReturn.split("@");
                if (sReturnValues[0].length !=0 && sReturnValues[1]=="Y") 
                {
                    OpenPage("/Common/Configurator/FunctionManage/FunctionList.jsp","_self","");    
                }
            }
        }
        
	}
	
    /*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=��;]~*/
	function viewAndEdit()
	{
        sFunctionID = getItemValue(0,getRow(),"FunctionID");
        if(typeof(sFunctionID)=="undefined" || sFunctionID.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
            return ;
		}
        
        sReturn=popComp("FunctionInfo","/Common/Configurator/FunctionManage/FunctionInfo.jsp","FunctionID="+sFunctionID,"");
        //�޸����ݺ�ˢ���б�
        if (typeof(sReturn)!='undefined' && sReturn.length!=0) 
        {
            sReturnValues = sReturn.split("@");
            if (sReturnValues[0].length !=0 && sReturnValues[1]=="Y") 
            {
                OpenPage("/Common/Configurator/FunctionManage/FunctionList.jsp?FunctionID="+sFunctionID,"_self","");           
            }
        }
	}
    
    /*~[Describe=�鿴���޸��������;InputParam=��;OutPutParam=��;]~*/
	function viewAndEditComp()
	{
        sFunctionID = getItemValue(0,getRow(),"FunctionID");
        if(typeof(sFunctionID)=="undefined" || sFunctionID.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
            return ;
		}
        OpenPage("/Common/Configurator/CompManage/CompList.jsp?FunctionID="+sFunctionID,"_self","");    
	}

	/*~[Describe=ɾ����¼;InputParam=��;OutPutParam=��;]~*/
	function deleteRecord()
	{
		sFunctionID = getItemValue(0,getRow(),"FunctionID");
        if(typeof(sFunctionID)=="undefined" || sFunctionID.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
            return ;
		}
		
		if(confirm(getHtmlMessage('2'))) 
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
