<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   --fmwu
		Tester:
		Content: --���Ӻ�ͬģ������б�
		Input Param:
                  
		Output param:
		                
		History Log: 
            
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "�����ĵ�ģ������б�"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
	String sSql="";//--���sql���
	//���ҳ�����	
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%	
	String[][] sHeaders = {
								{"EDocNo","�ĵ����"},
								{"EDocName","�ĵ�����"},
								{"EDocType","�ĵ�����"},
								{"StamperType","ǩ��ҳ����"},
								{"IsInUse","�Ƿ���Ч"},
								{"FileNameFmt","��ʽ�ļ�"},
								{"FileNameDef","���ݶ����ļ�"},
								{"InputUserName","�Ǽ���"},
								{"InputOrgName","�Ǽǻ���"},
								{"InputTime","�Ǽ�ʱ��"},
								{"UpdateUserName","������"},
								{"UpdateTime","����ʱ��"}
				             };
	sSql =  " select EDocNo,EDocName,FileNameFmt,FileNameDef,"+
	        " getItemName('YesNo',IsInUse) as IsInUse,"+
	        " getItemName('StamperType',StamperType) as StamperType,"+
	        " getItemName('EDocType',EDocType) as EDocType,"+
			" getUserName(InputUser) as InputUserName, "+
			" getOrgName(InputOrg) as InputOrgName,InputTime, "+
			" getUserName(UpdateUser) as UpdateUserName,UpdateTime "+
			" from EDOC_DEFINE "+
			" order by EDocNo ";

	//���ݴ�����ж��Ƿ���ڲ����ڵ�ģ�壬���г�ʼ��
	String sSql1="select itemno from code_library a where  codeno='ElectronicContractType' and not exists (select 'X' from edoc_define b where a.itemno=b.edocno)";
	String itemno = Sqlca.getString(sSql1);
	if (itemno != null) {
		String sSql2="insert into EDOC_DEFINE(EDocNo,EDocName,IsInUse,EdocType,StamperType) select itemno,itemname,IsInUse,'010','020' from code_library a where codeno='ElectronicContractType' and not exists (select 'X' from edoc_define b where a.itemno=b.edocno)";
		Sqlca.executeSQL(sSql2);
	}

	//����ASDataObject����doTemp		
	ASDataObject doTemp = new ASDataObject(sSql);
	//���ñ�ͷ
	doTemp.setHeader(sHeaders);
	//�����޸ı���
	doTemp.UpdateTable = "EDOC_DEFINE";
	//��������
	doTemp.setKey("EDocNo",true);
	//�����п��
	doTemp.setHTMLStyle("EDocNo"," style={width:100px} ");
	doTemp.setHTMLStyle("EDocType,IsInUse"," style={width:60px} ");
 	doTemp.setHTMLStyle("TypeName,InputOrg"," style={width:160px} ");
	doTemp.setHTMLStyle("InputTime,UpdateTime"," style={width:130px} ");
	
	//���˲�ѯ
 	doTemp.setColumnAttribute("TypeNo,TypeName","IsFilter","1");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
    
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	//����ҳ����ʾ������
	dwTemp.setPageSize(20);
  	
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
			{"true","","Button","��ʽ�ļ��ϴ�","�����ĵ���ʽ�ļ��ϴ�","TemplateUploadFmt()",sResourcesPath},			
			{"true","","Button","���ݶ����ļ��ϴ�","�����ĵ����ݶ����ļ��ϴ�","TemplateUploadDef()",sResourcesPath},			
			{"true","","Button","�����ĵ�״̬�鿴","�����ĵ�״̬�鿴","TemplateView()",sResourcesPath},				
			{"true","","Button","��ӡ����ͬ����","��ӡ����ͬ����","BCSample()",sResourcesPath},	//����������ǰ��ɾ��		
			{"true","","Button","��ӡ������ͬ����","��ӡ������ͬ����","GCSample()",sResourcesPath}	//����������ǰ��ɾ��			
		   };
	%> 
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
	
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script language=javascript>
    
	//---------------------���尴ť�¼�------------------------------------
	/*~[Describe=������¼;InputParam=��;OutPutParam=��;]~*/
	function newRecord()
	{
        sReturn = popComp("EDOCTemplateInfo","/Common/EDOC/TemplateInfo.jsp","","");
        reloadSelf();
	}
	
	/*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=��;]~*/
	function viewAndEdit()
	{
	    sEDocNo = getItemValue(0,getRow(),"EDocNo");//--�������ͱ��
	    if(typeof(sEDocNo)=="undefined" || sEDocNo.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
	        return ;
		}
	    sReturn=popComp("EDOCTemplateInfo","/Common/EDOC/TemplateInfo.jsp","EDocNo="+sEDocNo,"");
	    if (typeof(sReturn)!='undefined' && sReturn.length!=0) 
	    {
        	reloadSelf();
  	    }
	}
	
	/*~[Describe=�����ĵ���ʽ�ļ��ϴ�;InputParam=��;OutPutParam=��;]~*/
	function TemplateUploadFmt()
	{
		sEDocNo = getItemValue(0,getRow(),"EDocNo");//--�������ͱ��
	    if(typeof(sEDocNo)=="undefined" || sEDocNo.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
	        return ;
		}
		sFileName = getItemValue(0,getRow(),"FileNameFmt");//ģ���ļ�����
	    if(typeof(sFileName)!="undefined" &&  sFileName.length!=0) {
			if(!confirm("�����ĵ���ʽ�ļ��Ѿ����ڣ�ȷ��Ҫ�����ϴ���"))
			{
			    return;
			}
		}
		popComp("EDocTemplateChooseDialog","/Common/EDOC/TemplateChooseDialog.jsp","EDocNo="+sEDocNo+"&DocType=Fmt","dialogWidth=650px;dialogHeight=250px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		reloadSelf();
	}

	/*~[Describe=�����ĵ�ģ���ϴ�;InputParam=��;OutPutParam=��;]~*/
	function TemplateUploadDef()
	{
		sEDocNo = getItemValue(0,getRow(),"EDocNo");//--�������ͱ��
	    if(typeof(sEDocNo)=="undefined" || sEDocNo.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
	        return ;
		}
		sFileName = getItemValue(0,getRow(),"FileNameDef");//ģ���ļ�����
	    if(typeof(sFileName)!="undefined" &&  sFileName.length!=0) {
			if(!confirm("�����ĵ����ݶ����ļ��Ѿ����ڣ�ȷ��Ҫ�����ϴ���"))
			{
			    return;
			}
		}
		popComp("EDocTemplateChooseDialog","/Common/EDOC/TemplateChooseDialog.jsp","EDocNo="+sEDocNo+"&DocType=Def","dialogWidth=650px;dialogHeight=250px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		reloadSelf();
	}

	/*~[Describe=�����ĵ�״̬�鿴;InputParam=��;OutPutParam=��;]~*/
	function TemplateView()
	{
		sEDocNo = getItemValue(0,getRow(),"EDocNo");//--�������ͱ��
	    if(typeof(sEDocNo)=="undefined" || sEDocNo.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
	        return ;
		}

		popComp("TemplateState","/Common/EDOC/TemplateState.jsp","EDocNo="+sEDocNo);
	}

	/*~[Describe=ɾ����¼;InputParam=��;OutPutParam=��;]~*/
	function deleteRecord()
	{
		sEDocNo = getItemValue(0,getRow(),"EDocNo");//--�������ͱ��
        if(typeof(sEDocNo)=="undefined" || sEDocNo.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
            return ;
		}
		
		if(confirm("ȷ��Ҫɾ����ģ���������ģ���ڴ�����д��ڶ��壡�´ν����ҳ����Զ���ʼ���ü�¼��")) 
		{
			RunMethod("Configurator","DeleteEDocRelative",sEDocNo);
			sReturn = RunMethod("Configurator","DeleteEDocPath",sEDocNo);
			if(sReturn != "1") {
				alert("���Ӻ�ͬģ���ļ�·�������ڣ�ɾ���ļ�ʧ�ܣ�");
			}
			as_del("myiframe0");
			as_save("myiframe0");  //�������ɾ������Ҫ���ô����
		}
	}
	
	/*~[Describe=����������ǰ��ɾ��;InputParam=��;OutPutParam=��;]~*/
	function BCSample()
	{
		var sManageUserID = "test11";
		sParaString = "ManageUserID," +sManageUserID;
		var sReturns = setObjectValue("SelectEDocContract",sParaString,"",0,0,"");
		var sReturn = sReturns.split("@");
		sObjectNo = sReturn[0];
		sObjectType = sReturn[1];
		sEDocNo = PopPage("/Common/EDOC/EDocNo.jsp?ObjectType="+sObjectType,"","resizable=yes;dialogWidth=0;dialogHeight=0;center:no;status:no;statusbar:no");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		sReturn = PopPage("/Common/EDOC/EDocCreateCheckAll.jsp?ObjectType="+sObjectType+"&ObjectNo="+sObjectNo+"&EDocNo="+sEDocNo,"","resizable=yes;dialogWidth=0;dialogHeight=0;center:no;status:no;statusbar:no");
		
		if(sReturn == "nodef")
		{
			alert("û�ж�Ӧ��ģ�壬���Ӻ�ͬ����ʧ�ܣ�");
			return;
		}
		if(sReturn == "nodoc")
		{
			sReturn = PopPage("/Common/EDOC/EDocCreateActionAll.jsp?ObjectType="+sObjectType+"&ObjectNo="+sObjectNo+"&EDocNo="+sEDocNo,"","resizable=yes;dialogWidth=150;dialogHeight=100;center:no;status:no;statusbar:no");
		}
		sSerialNo = sReturn;
		OpenComp("ViewEDOC","/Common/EDOC/EDocView.jsp","SerialNo="+sSerialNo,"_blank",OpenStyle);
		
		reloadSelf();
	}
	
	/*~[Describe=����������ǰ��ɾ��;InputParam=��;OutPutParam=��;]~*/
	function GCSample()
	{
		alert("123123");
	}
	
	
	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script language=javascript>
	
	function mySelectRow()
	{
        
	}
	
	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List07;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script language=javascript>	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
    
</script>	
<%/*~END~*/%>


<%@ include file="/IncludeEnd.jsp"%>
