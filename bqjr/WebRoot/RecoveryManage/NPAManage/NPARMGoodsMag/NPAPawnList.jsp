<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		ҳ��˵��: ʾ���б�ҳ��
	 */
	String PG_TITLE = "ʾ���б�ҳ��";
	//���ҳ�����
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType")); 
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo")); 
	if(sObjectType == null) sObjectType = "";
	if(sObjectNo == null) sObjectNo = "";
	
	//ͨ��DWģ�Ͳ���ASDataObject����doTemp
	String sTempletNo = "NPAPawnList";//ģ�ͱ��
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);

	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.setPageSize(10);

	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sObjectType+","+sObjectNo);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {			
			{"true","","Button","����","�鿴����Ѻ����Ϣ����","viewAndEdit()",sResourcesPath},
			{"true","","Button","��ֵ���","����Ѻ���ֵ���","valueChange()",sResourcesPath},
			{"true","","Button","������Ϣ���","����Ѻ��������Ϣ���","otherChange()",sResourcesPath},
			{"true","","Button","�ʲ������Ϣ","�ʲ������Ϣ","assetWard()",sResourcesPath}
		};
	
%> 
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
<script type="text/javascript">

//---------------------���尴ť�¼�------------------------------------
/*~[Describe=�ʲ������Ϣ;InputParam=��;OutPutParam=��;]~*/
function assetWard()
{
//��������
sGuarantyID = getItemValue(0,getRow(),"GuarantyID");
sObjectType = "GuarantyInfo";

if(typeof(sGuarantyID)=="undefined" || sGuarantyID.length==0)
{
	alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
	return;
}
else 
{
	OpenComp("AssetWardList","/RecoveryManage/NPAManage/NPARMGoodsMag/AssetWardList.jsp","ObjectNo="+sGuarantyID+"&ObjectType="+sObjectType,"_blank",OpenStyle);
}
}

/*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=��;]~*/
function viewAndEdit()
{
//�������š�������ͬ��
sGuarantyID = getItemValue(0,getRow(),"GuarantyID");
sGuarantyType = getItemValue(0,getRow(),"GuarantyType");		
if(typeof(sGuarantyID)=="undefined" || sGuarantyID.length==0)
{
	alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
}else 
{		
	OpenPage("/RecoveryManage/NPAManage/NPARMGoodsMag/NPAPawnInfo.jsp?GuarantyID="+sGuarantyID+"&PawnType="+sGuarantyType,"_self");
}
}



/*~[Describe=����Ѻ���ֵ���;InputParam=��;OutPutParam=��;]~*/
function valueChange()
{
//�������š�������ͬ��
sGuarantyID = getItemValue(0,getRow(),"GuarantyID");
sObjectNo = getItemValue(0,getRow(),"ObjectNo");
sGuarantyType="050";
if(typeof(sGuarantyID)=="undefined" || sGuarantyID.length==0) 
{
	alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
}else 
{
	OpenComp("NPAValueChangeList","/RecoveryManage/NPAManage/NPARMGoodsMag/NPAValueChangeList.jsp","ChangeType=010&GuarantyID="+sGuarantyID+"&GuarantyType="+sGuarantyType,"_blank",OpenStyle);
	reloadSelf();
}
														
													
}

/*~[Describe=����Ѻ��������Ϣ���;InputParam=��;OutPutParam=��;]~*/
function otherChange()
{
//�������š�������ͬ��
sGuarantyID = getItemValue(0,getRow(),"GuarantyID");
sObjectNo = getItemValue(0,getRow(),"ObjectNo");
sGuarantyType="050";
if(typeof(sGuarantyID)=="undefined" || sGuarantyID.length==0) 
{
	alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
}else 
{
	OpenComp("NPAValueChangeList","/RecoveryManage/NPAManage/NPARMGoodsMag/NPAValueChangeList.jsp","ChangeType=020&GuarantyID="+sGuarantyID+"&GuarantyType="+sGuarantyType,"_blank",OpenStyle);
	reloadSelf();
}
}

</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
<script type="text/javascript">

</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List07;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script type="text/javascript">	
AsOne.AsInit();
init();
my_load(2,0,'myiframe0');
showFilterArea();
</script>	
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>
