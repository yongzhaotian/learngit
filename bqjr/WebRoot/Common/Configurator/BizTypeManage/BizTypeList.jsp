<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		Content: ��Ʒ�����б�
	 */
	String PG_TITLE = "��Ʒ�����б�";
	String[][] sHeaders = {
				{"TypeNo","���ͱ�ţ����ã�"},
				{"SortNo","������"},
				{"TypeName","��������"},
				{"IsInUse","�Ƿ���Ч"},
				{"TypesortNo","�������"},
				{"SubtypeCode","������"},
				{"InfoSet","��Ϣ����"},
				{"ApplyDetailNo","������ʾģ��"},	
				{"ApproveDetailNo","�������������ʾģ��"},	
				{"ContractDetailNo","��ͬ��ʾģ��"},
				{"DisplayTemplet","������ʾģ��"},	
				{"Attribute1","����1"},
				{"Attribute2","����2"},
				{"Attribute3","����3"},
				{"Attribute4","����4"},
				{"Attribute5","����5"},
				{"Attribute6","����6"},
				{"Attribute7","����7"},
				{"Attribute8","����8"},
				{"Attribute9","����9"},
				{"Attribute10","����10"},
				{"Remark","��ע"},
				{"InputUserName","�Ǽ���"},
				{"InputUser","�Ǽ���"},
				{"InputORGName","�Ǽǻ���"},
				{"InputORG","�Ǽǻ���"},
				{"InputTime","�Ǽ�ʱ��"},
				{"UpdateUserName","������"},
				{"UpdateUser","������"},
				{"UpdateTime","����ʱ��"},
				};
	String sSql = "select "+
			"TypeNo,SortNo,TypeName,getItemName('IsInUse',IsInUse) as IsInUse,TypesortNo,SubtypeCode,InfoSet,"+
			"ApplyDetailNo,ApproveDetailNo,ContractDetailNo,DisplayTemplet,"+
			"Attribute1,Attribute2,Attribute3,Attribute4,Attribute5,"+
			"Attribute6,Attribute7,Attribute8,Attribute9,Attribute10,Remark,"+
			"getUserName(InputUser) as InputUserName,InputUser,"+
			"getOrgName(InputORG) as InputORGName,InputORG,InputTime,"+
			"getUserName(UpdateUser) as UpdateUserName,UpdateUser,UpdateTime "+
			"from BUSINESS_TYPE where 1=1";
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.UpdateTable = "BUSINESS_TYPE";
	doTemp.setKey("TypeNo",true);
	doTemp.setHeader(sHeaders);
	//��ѯ
 	doTemp.setColumnAttribute("TypeNo","IsFilter","1");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));

	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.setPageSize(200);
 
 	doTemp.setHTMLStyle("InputORG"," style={width:160px} ");
	doTemp.setHTMLStyle("InputTime,UpdateTime"," style={width:130px} ");
	doTemp.setReadOnly("InputUser,UpdateUser,InputORG,InputUserName,UpdateUserName,InputORGName,InputTime,UpdateTime",true);
	doTemp.setVisible("InputUser,InputORG,UpdateUser",false);    	

	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	
	String sButtons[][] = {
		{"true","","Button","����","����һ����¼","newRecord()",sResourcesPath},
		{"true","","Button","����","�鿴/�޸�����","viewAndEdit()",sResourcesPath},
		{"true","","Button","ɾ��","ɾ����ѡ�еļ�¼","deleteRecord()",sResourcesPath}
	};
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
	function newRecord(){
		var sReturn=popComp("BizTypeInfo","/Common/Configurator/BizTypeManage/BizTypeInfo.jsp","","");
       if (typeof(sReturn)!='undefined' && sReturn.length!=0){
            //�������ݺ�ˢ���б�
			if (typeof(sReturn)!='undefined' && sReturn.length!=0){
				sReturnValues = sReturn.split("@");
              if (sReturnValues[0].length !=0 && sReturnValues[1]=="Y"){
					OpenPage("/Common/Configurator/BizTypeManage/BizTypeList.jsp","_self","");    
                }
            }
        }
	}
	
	function viewAndEdit(){
		var sTypeNo = getItemValue(0,getRow(),"TypeNo");
       if(typeof(sTypeNo)=="undefined" || sTypeNo.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return ;
		}
		sReturn=popComp("BizTypeInfo","/Common/Configurator/BizTypeManage/BizTypeInfo.jsp","TypeNo="+sTypeNo,"");
		if (typeof(sReturn)!='undefined' && sReturn.length!=0){
            //�������ݺ�ˢ���б�
			if (typeof(sReturn)!='undefined' && sReturn.length!=0){
				sReturnValues = sReturn.split("@");
				if (sReturnValues[0].length !=0 && sReturnValues[1]=="Y"){
					OpenPage("/Common/Configurator/BizTypeManage/BizTypeList.jsp","_self","");    
                }
            }
        }
	}

	function deleteRecord(){
		var sTypeNo = getItemValue(0,getRow(),"TypeNo");
		if(typeof(sTypeNo)=="undefined" || sTypeNo.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return ;
		}
		
		if(confirm(getHtmlMessage('2'))){
			as_del("myiframe0");
			as_save("myiframe0");  //�������ɾ������Ҫ���ô����
		}
	}
	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>	
<%@ include file="/IncludeEnd.jsp"%>