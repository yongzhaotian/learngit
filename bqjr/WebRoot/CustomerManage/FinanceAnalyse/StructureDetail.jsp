<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>
<%@page import="com.amarsoft.biz.finance.*" %>



<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author: -- 
		Tester:	
		Content:-- �ͻ����񱨱����
		Input Param:
			                 --CustomerID���ͻ���
			                 --ReportCount ����������
			                 --EntityCount ���ͻ���
			                 --ReportNo    :�����
		Output param:
			                
			               
		History Log: 
			DATE	CHANGER		CONTENT
			2005-7-21 fbkang	�°汾�ĸ�д
			
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "�ṹ����"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>

<%
    //�������
    String sAccountMonths = "" ;//--�������� 
    String sScopes = "" ; //--����Χ
    String sMonthsScopes = "";//�������¼ӿھ�
	String sReportName = "";//--��������
	String sCustomerName = "";//--�ͻ�����
	String sSql="";//--���sql���
	double dTemp;//--�����������
	double dTempIndustry ;//--�����ҵ����
    String sTemp="";//--��ŵ��ַ�������
    String sTempsIndustry="";//--��ŵ��ַ�����ҵ����
    String sTrueFlag="FALSE" ;//--��־�ж�
    int iSubTitleSpan = 0;//--������
    int iTitleSpan = 0;//--������
    String sTempNumber="";//--��ʾ�ַ���ֵ
    String aMonth[]=null;//--�������·ݵ�����
    String aScope[]=null;//--�����ŷ�Χ������
    
    //���ҳ�����,����������ҵ�����ͻ����롢�����
    String sReportCount = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ReportCount"));
	String sEntityCount = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("EntityCount"));
	String sCustomerID  = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("CustomerID"));
	String sReportNo    = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ReportNo"));
    //����������
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=��ñ���ֵ;]~*/%>
<%
	sSql = "select ReportName from FINANCE_CATALOG where ReportNo = :ReportNo";
	ASResultSet rsTemp = Sqlca.getResultSet(new SqlObject(sSql).setParameter("ReportNo",sReportNo));
	if(rsTemp.next())
		sReportName = rsTemp.getString("ReportName");
	rsTemp.getStatement().close();

	sSql = "select CustomerName from CUSTOMER_INFO where CustomerID = :CustomerID";
	rsTemp = Sqlca.getResultSet(new SqlObject(sSql).setParameter("CustomerID",sCustomerID));
	if(rsTemp.next())
		sCustomerName = rsTemp.getString(1);
	rsTemp.getStatement().close();
	
	iSubTitleSpan = Integer.parseInt(sEntityCount) + 2;
	iTitleSpan = iSubTitleSpan * Integer.parseInt(sReportCount) + 1;

	
	//ʱ������(����
	//���贫������˳�����еģ�CurPage:AccountMonth1=2001/12,AccountMonth2=2002/12,AccountMonth3=2003/12
	//�����ݽ�������ʾ���ǵ���,��ǰһ��(2003/12)��ǰ����(2002/12)��ǰ����(2001/12)
	//��ͼ�ν�������ʾ����˳�򣬼�2001/12,2002/12,2003/12
	//aMonth�ŵ��ǵ���,�������ݽ���, 2003/12 2002/21 2001/12
	
	aMonth = new String[Integer.parseInt(sReportCount)+1];
	aScope = new String[Integer.parseInt(sReportCount)+1];
	for(int i=Integer.parseInt(sReportCount); i>=1; i--)
	{
		aMonth[Integer.parseInt(sReportCount)-i+1] = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("AccountMonth" + i));
		aScope[Integer.parseInt(sReportCount)-i+1] = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("Scope" + i));
	}
	//��һ������"1"��ʾ�ṹ����,�������ReportAnalyse��Ϊ����߽ṹ������Ч��
	ReportAnalyse reportAnalyse = new ReportAnalyse("1",sCustomerID,sReportNo,sReportCount,aMonth,aScope,Sqlca);//@jlwu
%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List04;Describe=��ҳ��ı�д;]~*/%>


<HEAD>
	<title>�ṹ����</title>
</HEAD>
<body class="ReportPage" leftmargin="0" topmargin="0" onload="" style="overflow:auto" oncontextmenu="return true">
<form name="form0">
<table border="0" width="100%" height="100%" cellspacing="0" cellpadding="0" >
	<tr id="DetailTitle" class="DetailTitle" >
		<td ></td>
	</tr>
	<tr height=1 valign=top id="buttonback" >
		<td>
			<table width="100%" >
			<tr>
				<td>
					<%=HTMLControls.generateButton("ת�������ӱ��","ת�������ӱ��","javascript:excelShow();",sResourcesPath)%>
				</td>
				<td align=left>
					<span >
					<table width="100%" ><tr></td>
						ѡȡͼ��չ�ַ�ʽ��
						<select id="GraphType">
							<option value=0 >��״ͼ</option>
							<option value=6 >����ͼ</option>
						</select>
					</td></tr></table>
					</span>
				</td>
				<td align=left>
					<%=HTMLControls.generateButton("ͼ��չ��","ͼ��չ��","javascript:graphShow();",sResourcesPath)%>
				</td>
			</tr>
			</table>
		</td>
	</tr>
	<tr valign="top" >
		<td style='BORDER-bottom: #000000 1px solid;' id="reporttable">
			<script type="text/javascript">
				var aValues = new Array();
				var aNames = new Array();
			</script>
			<table border=1 cellpadding=0 cellspacing=0 width="100%" align="center" bgcolor="#F0F0F0">
			<%
				String sTempValues = "",sTempNames = "";
				String sTempValue = "";
				//��ͷ
				String sAccountMonth = "", sScope = "", sUnit = "";
				sAccountMonth = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("AccountMonth1"));
				sScope = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("Scope1"));				
				
				//FinanceAnalyse financeReport = new FinanceAnalyse(0, sCustomerID, sAccountMonth, sReportNo, sScope, Sqlca);@jlwu
				//sUnit = financeReport.FinanceUnit;@jlwu				

			%>
				<tr>
					<td colspan="<%=iTitleSpan%>" align="center"><%=sReportName + "����ṹ����"%></td>
				</tr>
				<tr>
					<td colspan="<%=Math.floor(iTitleSpan/2)%>" align="left"><%="�ͻ����ƣ�" + sCustomerName%></td>
					<td colspan="<%=iTitleSpan - Math.floor(iTitleSpan/2)%>" align="right"><%="��λ������� Ԫ"%> </td>
				</tr>
				<tr>
					<td rowspan="2" align="center" valign="center" nowrap>��Ŀ����</td>
			<%
				for(int i=Integer.parseInt(sReportCount); i>=1; i--)
				{
					sAccountMonth = aMonth[Integer.parseInt(sReportCount)-i+1];
					sScope = aScope[Integer.parseInt(sReportCount)-i+1];

					if(i!=1) sAccountMonths = sAccountMonths + sAccountMonth + "@";
					else     sAccountMonths = sAccountMonths + sAccountMonth ;

					if(i!=1) sScopes = sScopes + sScope + "@";
					else     sScopes = sScopes + sScope ;
					//�·ݼӿھ����������ڶ�ھ���չ	
					if(i!=1) sMonthsScopes = sMonthsScopes + sAccountMonth+" "+((sScope.equals("01"))?"�ϲ�":(sScope.equals("02")?"����":"����"))+"@";
					else 	sMonthsScopes = sMonthsScopes + sAccountMonth+" "+((sScope.equals("01"))?"�ϲ�":(sScope.equals("02")?"����":"����"));
			%>
					<td colspan="<%=iSubTitleSpan%>" align="center">
						<%=StringFunction.getSeparate(sAccountMonth,"/",1) + "��" + StringFunction.getSeparate(sAccountMonth,"/",2) + "��  "+((sScope.equals("01"))?"�ϲ�":(sScope.equals("02")?"����":"����"))%>
					</td>
			<%
				}
			%>
				</tr>
				<tr>
			<%
				String sEntityType = "", sEntityID = "", sEntityName = "";
				for(int i=1; i<=Integer.parseInt(sReportCount); i++)
				{
			%>
					<td align="center" nowrap>���</td>
					<td align="center" nowrap>ռ��(%)</td>
			<%
					for(int j=1; j<=Integer.parseInt(sEntityCount); j++)
					{
						sEntityType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("EntityType" + j));
						sEntityID = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("EntityID" + j));
						if(sEntityType.equals("Industry"))
							sSql = "select getIndustryName(:EntityID) from dual";
						else
							sSql = "select CustomerName from CUSTOMER_INFO where CustomerID = :EntityID ";
						rsTemp = Sqlca.getResultSet(new SqlObject(sSql).setParameter("EntityID",sEntityID));
						if(rsTemp.next())
							sEntityName = rsTemp.getString(1);
						rsTemp.getStatement().close();
			%>
						<td align="center"><%=sEntityName + "(%)"%></td>
			<%
					}
				}

				//����
				String sFinanceItemNo = "", sDisplayName = "", sTotalItem = "",sFormatType = "";
				sTotalItem = FinanceAnalyse.getTotalItem(sReportNo, Sqlca);
				//����ֵת��Ϊ���ַ���
				if(sTotalItem == null) sTotalItem = "";
				sAccountMonth = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("AccountMonth" + sReportCount));
				sScope = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("Scope" + sReportCount));
				//����ֵת��Ϊ���ַ���
				if(sAccountMonth == null) sAccountMonth = "";
				if(sScope == null) sScope = "";
				//��ʱδ���� DisplayAttribute		//"1":������,"2":�ٷֱ�,"3":������		
				
				String sNewSql = "select FD.FinanceItemNo,FD.DisplayName from Finance_Data FD where  FD.CustomerID = :CustomerID and FD.AccountMonth = :AccountMonth and FD.ModelNo = :ModelNo and FD.Scope = :Scope  order by FD.DisplayNo";
				SqlObject so = new SqlObject(sNewSql);
				so.setParameter("CustomerID",sCustomerID);
				so.setParameter("AccountMonth",sAccountMonth);
				so.setParameter("ModelNo",sReportNo);
				so.setParameter("Scope",sScope);
				rsTemp = Sqlca.getResultSet(so);
				int icount=0;

				while(rsTemp.next()){
					icount++;
					sFinanceItemNo = DataConvert.toString(rsTemp.getString(1));
					sDisplayName = DataConvert.toString(rsTemp.getString(2));
					sTempNames = sDisplayName+"@";

					//sFormatType = DataConvert.toString(rsTemp.getString(3));
					//if(sFormatType == null || sFormatType.equals(""))
						sFormatType = "1";

				if(sFinanceItemNo.length() > 0 && sDisplayName.length() > 0)
				{
				  sTempValues = "";
				  sDisplayName  = StringFunction.replace(sDisplayName," ","&nbsp;");
			%>
				<tr  bgcolor=<%=(icount%2==0)?"#F6F5FA":"#EDEBF6"%>>
					<td align="left" nowrap>
						<input type=checkbox name ="checkbox<%=icount%>"  value=<%=sFinanceItemNo%> >
						<%=sDisplayName%>
					</td>
			<%
					for(int i=Integer.parseInt(sReportCount); i>=1; i--)
					{
						sTemp="";
						sTempsIndustry="";
						sTrueFlag="FALSE" ;
						sAccountMonth = aMonth[Integer.parseInt(sReportCount)-i+1];
						sScope = aScope[Integer.parseInt(sReportCount)-i+1];						
                        //sTemp = FinanceAnalyse.getProportion(FinanceAnalyse.getItemValue(0,sCustomerID, sAccountMonth, sReportNo, sScope, sTotalItem, Sqlca),FinanceAnalyse.getItemValue(0,sCustomerID, sAccountMonth, sReportNo, sScope, sFinanceItemNo, Sqlca));@jlwu
                        sTemp = reportAnalyse.reportData[Integer.parseInt(sReportCount)-i].PercentValue.getAttribute(sFinanceItemNo).toString();//@jlwu
                        if(sTemp!=null && !sTemp.equals(""))
                        {
                          dTemp=Double.parseDouble(sTemp);
                        }
                        else
                        {
                          dTemp=Double.parseDouble("0");
                        }
                       
                        if (i==Integer.parseInt(sReportCount))
                        {
                          //��Ϊ�����ѡ��һ��ʱҪ�ȽϺ���ѡ��ҵֵ�Ĳ����Ƿ����30��
                          for(int j=1; j<=Integer.parseInt(sEntityCount); j++)
						  {
							sEntityType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("EntityType" + j));
							sEntityID = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("EntityID" + j));
							String sValue = "";
							if(sEntityType.equals("Industry"))
							{
							   //sTempsIndustry = FinanceAnalyse.getProportion(FinanceAnalyse.getItemValue(0,sEntityID, StringFunction.getSeparate(sAccountMonth,"/",1), "0001", "01", sTotalItem, Sqlca),FinanceAnalyse.getItemValue(0,sEntityID, StringFunction.getSeparate(sAccountMonth,"/",1), "0001", "01", sFinanceItemNo, Sqlca));@jlwu
								sTempsIndustry = ReportAnalyse.getProportion(FinanceAnalyse.getItemValue(0,sEntityID, StringFunction.getSeparate(sAccountMonth,"/",1), "0001", "01", sTotalItem, Sqlca),ReportAnalyse.getItemValue(0,sEntityID, StringFunction.getSeparate(sAccountMonth,"/",1), "0001", "01", sFinanceItemNo, Sqlca));
							}
							if(sTempsIndustry!=null&&!sTempsIndustry.equals(""))
							{
								dTempIndustry=Double.parseDouble(sTempsIndustry);
								if (dTempIndustry!=0)
								{
									if(((dTemp-dTempIndustry)/dTempIndustry)>0.3||((dTemp-dTempIndustry)/dTempIndustry)<-0.3)
									{
									   sTrueFlag="TRUE";
									   continue;
									}
								}
							}
						  }
						}

						//sTempValue = FinanceAnalyse.convertByUnit(FinanceAnalyse.getItemValue(0,sCustomerID, sAccountMonth, sReportNo, sScope, sFinanceItemNo, Sqlca), "01");@jlwu
						sTempValue = ReportAnalyse.convertByUnit(reportAnalyse.reportData[Integer.parseInt(sReportCount)-i].ParaValue.getAttribute(sFinanceItemNo).toString(), "01");//@jlwu
						sTempNumber = ReportAnalyse.formatNumber(sTempValue);
						//Ҫ��ʾ��Ԫ
						//sTempValues = sTempValues + StringFunction.replace(FinanceAnalyse.formatNumber(Double.parseDouble(sTempValue)/10000),",","") + "@";
						//"1":������,"2":�ٷֱ�,"3":������
						sTempNumber = ReportAnalyse.applyFormat(sTempValue,sFormatType);
						if(sTempNumber!=null&&!sTempNumber.equals(""))
						{
							if(sFormatType.equals("3"))
								sTempValues = sTempValues + StringFunction.replace(FinanceAnalyse.formatNumber(Double.parseDouble(sTempValue)),",","") + "@";				
							else if(sFormatType.equals("2"))
								sTempValues = sTempValues + StringFunction.replace(FinanceAnalyse.formatNumber(Double.parseDouble(sTempValue)*100),",","") + "@";				
							else
								sTempValues = sTempValues + StringFunction.replace(FinanceAnalyse.formatNumber(Double.parseDouble(sTempValue)/10000),",","") + "@";				
						}
						else
							sTempValues = sTempValues + "@";
						
						//sTempNumber.equals("0.00")?"":sTempNumber
						//FinanceAnalyse.formatPercent1(sTemp).equals("0.0%")?"":FinanceAnalyse.formatPercent1(sTemp)
			%>
						<td align="right" nowrap>
						     &nbsp;<%=sTempNumber%> </font>
						</td>
						<td align="right" nowrap>
						 	<font color=<%=(!sTotalItem.equals(sFinanceItemNo))?(i==Integer.parseInt(sReportCount))?(dTemp>0.2||dTemp<-0.2)?"red":(sTrueFlag.equals("TRUE"))?"red":"black":"black":"black"%>> &nbsp;<%=ReportAnalyse.formatPercent1(sTemp)%>
						</td>
			<%	
						for(int j=1; j<=Integer.parseInt(sEntityCount); j++)
						{
							sEntityType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("EntityType" + j));
							sEntityID = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("EntityID" + j));
							String sValue = "";
							if(sEntityType.equals("Industry"))
							{
								sValue = FinanceAnalyse.formatPercent1(FinanceAnalyse.getProportion(FinanceAnalyse.getItemValue(0,sEntityID, StringFunction.getSeparate(sAccountMonth,"/",1), "0001", "01", sTotalItem, Sqlca),FinanceAnalyse.getItemValue(0,sEntityID, StringFunction.getSeparate(sAccountMonth,"/",1), "0001", "01", sFinanceItemNo, Sqlca)));
							}
							else
							{
								sValue = FinanceAnalyse.formatPercent1(FinanceAnalyse.getProportion(FinanceAnalyse.getItemValue(0,sEntityID, sAccountMonth, sReportNo, sScope, sTotalItem, Sqlca),FinanceAnalyse.getItemValue(0,sEntityID, sAccountMonth, sReportNo, sScope, sFinanceItemNo, Sqlca)));
							}
							
							//sValue.equals(" 0.0%")?"":sValue
			%>
							<td align="right" nowrap>
								&nbsp;<%=sValue%>
							</td>
			<%
						}
					}//for i
			%>
				<script type="text/javascript">
					aValues[<%=icount%>] = "<%=sTempValues%>";
					aNames[<%=icount%>] = "<%=StringFunction.replace(sTempNames,"\"","��")%>";
				</script>
				</tr>
			<%
				}

				}
				rsTemp.getStatement().close();
			%>
				</tr>
			</table>
		</td>
	</tr>
</table>
</form>
</body>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=�Զ��庯��;]~*/%>

<script>
//---------------------���尴ť�¼�------------------------------------
/*~[Describe=����excel;InputParam=��;OutPutParam=��;]~*/
function excelShow()
{
	var mystr = document.getElementById('reporttable').innerHTML;
	spreadsheetTransfer(mystr.replace(/type=checkbox/g,"type=hidden"));
}

/*~[Describe=����ͼ��;InputParam=��;OutPutParam=��;]~*/

function graphShow()
{
	var sChecked = "",iChecked = 0,sItemNames="",sItemValues="";

	var cForms = document.forms["form0"];

	//ѭ��ȡ������ѡ�еĸ�ѡ�򣬷�������valueֵ��ɵķ��ش�
	for(var k=0;k<cForms.elements.length;k++)
	{
		if (cForms.elements[k].checked)
		{
			sChecked += cForms.elements[k].value+"@";
			sItemNames  += aNames[parseInt(cForms.elements[k].name.substr(8,cForms.elements[k].name.length-1),10)];
			sItemValues += aValues[parseInt(cForms.elements[k].name.substr(8,cForms.elements[k].name.length-1),10)];
 
			iChecked ++ ;
		}
	}

	if(iChecked==0)
	{
		alert(getBusinessMessage('174'));//����Ҫѡһ��ָ�����ͼ��չ�֣�
		return;
	}

	if(iChecked>6)
	{
		alert(getBusinessMessage('175'));//һ�ε�ѡ������6����Ŀ,��ȥ��һЩ��Ŀ�ٽ���ͼ��չ�֣�
		return;
	}

	sChecked = sChecked.substr(0,sChecked.length-1);
	sItemNames = sItemNames.substr(0,sItemNames.length-1);
	sItemValues = sItemValues.substr(0,sItemValues.length-1);
	sGraphType = document.getElementById("GraphType").value;
	sScreenWidth = screen.availWidth-40;
	sScreenHeight = screen.availHeight-40;
    PopPage("/CustomerManage/FinanceAnalyse/ShowGraph.jsp?GraphType="+sGraphType+"&MonthsScopes=<%=sMonthsScopes%>&ItemNames="+sItemNames+"&ItemValues="+sItemValues+"&ScreenWidth="+sScreenWidth+"&ScreenHeight="+sScreenHeight+"&rand="+randomNumber(),"_blank",sDefaultDialogStyle);
}
function chartGraphShow()
{
	var sChecked = "",iChecked = 0,sItemNames="",sItemValues="";

	var cForms = document.forms["form0"];

	//ѭ��ȡ������ѡ�еĸ�ѡ�򣬷�������valueֵ��ɵķ��ش�
	for(var k=0;k<cForms.elements.length;k++)
	{
		if (cForms.elements[k].checked)
		{
			sChecked += cForms.elements[k].value+"@";
			sItemNames  += aNames[parseInt(cForms.elements[k].name.substr(8,cForms.elements[k].name.length-1),10)];
			sItemValues += aValues[parseInt(cForms.elements[k].name.substr(8,cForms.elements[k].name.length-1),10)];
 
			iChecked ++ ;
		}
	}

	if(iChecked==0)
	{
		alert(getBusinessMessage('174'));//����Ҫѡһ��ָ�����ͼ��չ�֣�
		return;
	}

	if(iChecked>6)
	{
		alert(getBusinessMessage('175'));//һ�ε�ѡ������6����Ŀ,��ȥ��һЩ��Ŀ�ٽ���ͼ��չ�֣�
		return;
	}

	sChecked = sChecked.substr(0,sChecked.length-1);
	sItemNames = sItemNames.substr(0,sItemNames.length-1);
	sItemValues = sItemValues.substr(0,sItemValues.length-1);

    PopPage("/CustomerManage/FinanceAnalyse/ShowGraphExcel.jsp?GraphType="+document.getElementById("GraphType").value+"&MonthsScopes=<%=sMonthsScopes%>&ItemNames="+sItemNames+"&ItemValues="+sItemValues+"&rand="+randomNumber(),"_blank",sDefaultDialogStyle);
}
</script>
<%/*~END~*/%>


<%@ include file="/IncludeEnd.jsp"%>
