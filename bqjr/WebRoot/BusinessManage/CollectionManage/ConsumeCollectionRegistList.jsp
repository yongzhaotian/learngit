<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		--ҳ��˵��: ������ʷҳ��--
	 */
	String PG_TITLE = "������ʷҳ��";
	//���ҳ�����

	String sCustomerID = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("CustomerID"));//�ͻ����
	String sPhaseType1 =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("PhaseType1"));//
	String sType =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("type"));//
	String sButtonM1 =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("buttonM1"));
	String sButtonM2 =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("buttonM2"));
	String sButtonM3 =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("buttonM3"));
	if(sButtonM1==null) sButtonM1="";
	if(sButtonM2==null) sButtonM2="";
	if(sButtonM3==null) sButtonM3="";
	System.out.println("---------------"+sCustomerID);
	System.out.println("---------------"+sPhaseType1);
	
	if(sPhaseType1==null) sPhaseType1="";
	if(sCustomerID==null) sCustomerID="";
	
	//ͨ��DWģ�Ͳ���ASDataObject����doTemp
	String sTempletNo = "ConsumeCollectionRegistList";//ģ�ͱ��
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);

	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));

	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.setPageSize(20);

	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sCustomerID);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{"true","","Button","����","����","goBack()",sResourcesPath}
	};
	
	
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
	//����
	function goBack(){
		var sPhaseType1 = "<%=sPhaseType1%>";
		if(sPhaseType1=="0011"){//M1���
			AsControl.OpenView("/BusinessManage/CollectionManage/ConsumeCollectionTelList.jsp","PhaseType1="+sPhaseType1+"&&buttonM1=<%=sButtonM1%>","_self");
		}else if(sPhaseType1=="0012"){//M2���
			AsControl.OpenView("/BusinessManage/CollectionManage/ConsumeCollectionTelList.jsp","PhaseType1="+sPhaseType1+"&&buttonM2=<%=sButtonM2%>","_self");
		}else if(sPhaseType1=="0013"){//M3���
			AsControl.OpenView("/BusinessManage/CollectionManage/ConsumeCollectionTelList.jsp","PhaseType1="+sPhaseType1+"&&buttonM3=<%=sButtonM3%>","_self");
		}else if(sPhaseType1=="0060"){//������
			AsControl.OpenView("/BusinessManage/CollectionManage/ConsumeCollectionGroupList.jsp","PhaseType1="+sPhaseType1,"_self");
		}else if(sPhaseType1=="0020"){//ʵ�ش���
			AsControl.OpenView("/BusinessManage/CollectionManage/ConsumeCollectionLocalList.jsp","PhaseType1="+sPhaseType1,"_self");
		}else if(sPhaseType1=="0030"){//ί�����
			if(<%=sType%> == "4"){
				AsControl.OpenView("/BusinessManage/CollectionManage/ConsumeCollectionProviderList.jsp","PhaseType1="+sPhaseType1+"&type=4","_self");
			}else{
				AsControl.OpenView("/BusinessManage/CollectionManage/ConsumeCollectionProviderList.jsp","PhaseType1="+sPhaseType1,"_self");
			}
			
		}else if(sPhaseType1=="0040"){//�������
			AsControl.OpenView("/BusinessManage/CollectionManage/ConsumeCollectionLawList.jsp","PhaseType1="+sPhaseType1,"_self");
		}else if(sPhaseType1=="0070"){//���ɴ���
			AsControl.OpenView("/BusinessManage/CollectionManage/ConsumeCollectionAffairsList.jsp","PhaseType1="+sPhaseType1,"_self");
		}else{
			AsControl.OpenView("/BusinessManage/CollectionManage/ConsumeCollectionSettleList.jsp","PhaseType1="+sPhaseType1,"_self");
		}
		
	}
	

	$(document).ready(function(){
		AsOne.AsInit();
		init();
		my_load(2,0,'myiframe0');
		
	});
</script>	
<%@ include file="/IncludeEnd.jsp"%>
