<%@page import="com.amarsoft.app.lending.bizlets.GetBugPayPkgindFee"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main00;Describe=ע����;]~*/%>
	<%
	/*
		��ӡ�۱�����ͬ
		Author:   fangxq  2016.02.14
		Tester:
		Content: ����ĵ�0ҳ
		Input Param:
			���봫��Ĳ�����
				DocID:	  �ĵ�template
				ObjectNo��ҵ���
				SerialNo: ���鱨����ˮ��
			��ѡ�Ĳ�����
				Method:   ���� 1:display;2:save;3:preview;4:export
				FirstSection: �ж��Ƿ�Ϊ����ĵ�һҳ
		Output param:

		History Log: 
	 */
	%>
<%/*~END~*/%>

<%
	int iDescribeCount = 30;	//�����ҳ����Ҫ����ĸ���������д�ԣ��ͻ���1
	int iCount = 1;
	int iCountNew = 20 ;
%>

<%@include file="/FormatDoc/IncludePOHeader.jsp"%>

<%
	//String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectNo")); 
	
	String sql="select bc.customername,bc.brandtype1,bc.manufacturer1,bc.price1,bc.price2,bc.salesubmittime, "+
		"bc.InputUserID"+ //add by fangxq 20160317 �۱�������ȡ���۹�������/����
		" from business_contract bc where bc.serialno='"+sObjectNo+"'";
		
	String sCustomerName = "";	//�˿�����
	String sBrandType1 = "";	//�ֻ�Ʒ��
	String sManufacturer1 = "";	//�ֻ��ͺ�
	String sPrice1 = "";		//�����۸�
	String sPrice2 = "";		//�ӱ��۸�
	String sSalesubmittime = "";	//��ͬ�ύ���� 
	String sCity = ""; //����ID
	
	//add by fangxq  CCS-1320 ����������� 20160317 
	String sInputDate = ""; //������ڼ�ʱ��
	String sInputUserID = "";//���۹�������/����
	//end 
	
	ASResultSet rs = Sqlca.getASResultSet(sql);
	if(rs.next()){
		sCustomerName = rs.getString("customername");
		sBrandType1 = rs.getString("brandtype1");
		sManufacturer1 = rs.getString("manufacturer1");
		sPrice1 = rs.getString("price1");
		sPrice2 = rs.getString("price2");
		sSalesubmittime = rs.getString("salesubmittime");	
		sInputUserID = rs.getString("InputUserID"); //add by fangxq  CCS-1320 ����������� 20160317
	}	
	
	//����id
	String sql3 = "select si.city from store_info si where si.sno in("
		+"select bc.stores from business_contract bc where bc.serialno='"+sObjectNo+"')";
	
	ASResultSet rs3 = Sqlca.getASResultSet(sql3);
	if(rs3.next()){
		sCity = rs3.getString("city");
	}
	if(sCity == null) sCity="";
	rs3.getStatement().close(); 	

	if(sCustomerName == null) sCustomerName="";
	if(sBrandType1 == null) sBrandType1="";
	if(sManufacturer1 == null) sManufacturer1="";
	if(sPrice1 == null) sPrice1="";
	if(sPrice2 == null) sPrice2="";
	if(sSalesubmittime == null) sSalesubmittime="";
	if(sInputUserID == null) sInputUserID ="&nbsp;"; //add by fangxq  CCS-1320 ����������� 20160317
	String sDate = "";
	sDate = sSalesubmittime.substring(0,10);//�������� 
	
	rs.getStatement().close(); 
	
	String sql1 = " select bpi.service_tel,bpi.provider_name,bpi.abbreviate from bbd_provider_info bpi"+
			  " where bpi.provider_id in (select prc.provider_id from bbd_provider_relative_city prc where prc.city_id ='"+sCity+"')";
	String sql2 = "select bti.mobile_serial_number,bti.serveyear from bbd_treasurebag_info bti where bti.serialno='"+sObjectNo+"'";
	
	String sService_tel = "";	//��Ӧ�̵绰
	String sProvider_name = "";	//��Ӧ������
	String sMobile_serial_number = "";	//�ֻ�����
	String sServeyear = "";	//�ӱ�����
	String sAbbreviate = "";//��Ӧ��������д 
	String sVersion = "";//�汾�� 
	
	ASResultSet rs1 = Sqlca.getASResultSet(sql1);
	ASResultSet rs2 = Sqlca.getASResultSet(sql2);
	
	//��Ӧ�����ơ���Ӧ�̵绰 ����Ӧ��������д 
	if(rs1.next()){
		sService_tel = rs1.getString("service_tel");
		sProvider_name = rs1.getString("provider_name");
		sAbbreviate = rs1.getString("abbreviate");
	}
	if(sService_tel == null) sService_tel="";
	if(sProvider_name == null) sProvider_name=""; 
	if(sAbbreviate == null) sAbbreviate=""; 
	rs1.getStatement().close();
	sVersion = sAbbreviate+"-BBD-2016031601"; //update by fangxq CCS-1320 20160318
		
	//�ֻ����� ���ӱ�����  
	if(rs2.next()){
		sMobile_serial_number = rs2.getString("mobile_serial_number");
		sServeyear = rs2.getString("SERVEYEAR");
	}
	if(sMobile_serial_number == null) sMobile_serial_number=""; 
	if(sServeyear == null) sServeyear="";
	rs2.getStatement().close();
	
	//add by fangxq CCS-1320 �۱�������������� 20160318
	//ȡ��ͬ״̬
	String sContractStatus = Sqlca.getString(new SqlObject("select phasename from flow_object where objectno =:ObjectNo").setParameter("ObjectNo", sObjectNo));
	sInputDate = Sqlca.getString(new SqlObject("SELECT PHASEOPINION3 FROM FLOW_TASK WHERE RELATIVESERIALNO=(SELECT SERIALNO FROM FLOW_TASK WHERE OBJECTNO=:OBJECTNO AND RELATIVESERIALNO IS NULL)").setParameter("OBJECTNO", sObjectNo));
	if (sInputDate == null) {
		sInputDate = Sqlca.getString(new SqlObject("SELECT endtime FROM FLOW_TASK WHERE RELATIVESERIALNO=(SELECT SERIALNO FROM FLOW_TASK WHERE OBJECTNO=:OBJECTNO AND RELATIVESERIALNO IS NULL)").setParameter("OBJECTNO", sObjectNo));
	}
	if(sInputDate == null) sInputDate ="&nbsp;";
	//end

%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=ReportInfo;Describe=���ɱ�����Ϣ;�ͻ���2;]~*/%>
<%
		StringBuffer sTemp=new StringBuffer();
		sTemp.append("<form method='post' action='ApplyBaiBaoDai.jsp' name='BaiBaoDaiReportInfo'>");	
		sTemp.append("<div id=reporttable style='position:relative;'>");
		
		//add by fangxq CCS-1320 �۱�����ͬ����������� 20160318
		sTemp.append("<table class=table1 width='690' align=center border=0 cellspacing=0 cellpadding=0 >	");
		sTemp.append("   <tr>");
		sTemp.append("   <td align=left colspan=5 class=td1 ><b>��Ǫ�������Ѵ����������顪�۱�������ר��</b></td>");
		sTemp.append("   <td colspan=1 align=left class=td1 ><b>��ͬ��ţ�</b>"+sObjectNo+"&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td colspan=4 align=left class=td1 ><b>�̼ң�</b>"+sProvider_name+"&nbsp;</td>");
		sTemp.append("   <td colspan=3 align=left class=td1 >�ͻ�������"+sCustomerName+"&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td colspan=3 align=left class=td1 >�ֻ�Ʒ�ƣ�"+sBrandType1+"&nbsp;</td>");
		sTemp.append("   <td colspan=2 align=left class=td1 >�ֻ��ͺţ�"+sManufacturer1+"&nbsp;</td>");
		sTemp.append("   <td colspan=2 align=left class=td1 >�ֻ����ţ�"+sMobile_serial_number+"&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td colspan=5 align=left class=td1 >�ӱ����ޣ�<u>&nbsp;"+sServeyear+"&nbsp;</u>����</td>");
		sTemp.append("   <td colspan=2 align=left class=td1 >����۸�Ԫ��:"+sPrice2+"&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td colspan=6 align=left class=td1 ><b>I.������� :  "+sContractStatus+"&nbsp;</b>&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td colspan=6 align=left class=td1 bgcolor=#aaaaaa ><b>II.���Ѵ�������ժҪ</b>&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td colspan=3 align=left class=td1 >�Ը���Ԫ����0.00&nbsp;</td>");
		sTemp.append("   <td colspan=2 align=left class=td1 >δ�����Ԫ����"+sPrice2+"&nbsp;</td>");
		sTemp.append("   <td colspan=2 align=left class=td1 >�����Ԫ����"+sPrice2+"&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td align=left colspan=6 class=td1 ><font style=' font-size: 6pt;' FONT-FAMILY:����;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >�ͻ�ǩ���ļ���ȷ�ϣ��Ա��ļ�ǩ��ʱ����1����������׼ȷ����2������Э���롶�ֻ����۱������޶��ӱ������ͬ���Ƕ����ķ��ɹ�ϵ�������˲����̼����ṩ�ķ��������е��κ����Σ���3�����ۿͻ��Ƿ����ӱ���Χ�ڵĹ��ϣ��ͻ����谴�մ���Э�鳥�������5��Ϊ����ͻ������ļ��롶�ֻ����۱������޶��ӱ������ͬ���ɺϲ�ǩ�𣬿ͻ�ǩ��һ�μ���Ϊ�Ա��ļ������ֻ����۱������޶��ӱ������ͬ����ȷ�ϡ�</font></td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td colspan=6 align=left class=td1 bgcolor=#aaaaaa ><b>III.ϵͳʹ��&nbsp;</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td colspan=4 align=left class=td1 >������ڼ�ʱ�䣺"+sInputDate+"&nbsp;</td>");
		sTemp.append("   <td colspan=4 align=left class=td1 >���۹�������/���룺"+sInputUserID+"&nbsp</td>");
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
		sTemp.append("   <td colspan=6 align=left class=td1 >���۹���ǩ����________________</td>");
		sTemp.append("   </tr>");
		sTemp.append("</table>");
		//end 
		
		sTemp.append("<table  style='border:1px;' width='690' align=center>");
		sTemp.append("<tr>");   
		sTemp.append("<td style='border:0px;text-align:center; font-size: 15pt;FONT-FAMILY:����;FONT-WEIGHT: bolder;color:black;background-color:white' colspan=6>�ֻ����۱������޶��ӱ������ͬ<br/></td>");
		sTemp.append("</tr>");
		//sTemp.append("<tr><td colspan=6 style='border:0px;'>&nbsp;</td></tr>");
		sTemp.append("</table>");
		

		sTemp.append("<table  width='690' align=center>");
		 sTemp.append("<tr>");
		 sTemp.append("<td style='border:0px;text-align:left; font-size: 9pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black; colspan=5 '>�˿�����:<u>&nbsp;&nbsp;&nbsp;&nbsp;"+sCustomerName+"&nbsp;&nbsp;&nbsp;&nbsp;</u></td>");
		 sTemp.append("<td style='border:0px;text-align:left; font-size: 9pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black; colspan=5 '>����:<u>&nbsp;&nbsp;&nbsp;&nbsp;"+sMobile_serial_number+"&nbsp;&nbsp;&nbsp;&nbsp;</u></td>");
		 sTemp.append("<td style='border:0px;text-align:left; font-size: 9pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black; colspan=5 '>��ͬ��:<u>&nbsp;&nbsp;&nbsp;"+sObjectNo+"&nbsp;&nbsp;&nbsp;</u></td>");
		 sTemp.append("</tr>");
		 sTemp.append("<tr>");
		 sTemp.append("<td style='border:0px;text-align:left; font-size: 9pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black; colspan=5 '>�ֻ�Ʒ��:<u>&nbsp;&nbsp;&nbsp;&nbsp;"+sBrandType1+"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</u></td>");
		 sTemp.append("<td style='border:0px;text-align:left; font-size: 9pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black; colspan=5 '>�ֻ��ͺ�:<u>&nbsp;&nbsp;&nbsp;&nbsp;"+sManufacturer1+"&nbsp;&nbsp;&nbsp;&nbsp;</u></td>");
		 sTemp.append("<td style='border:0px;text-align:left; font-size: 9pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black; colspan=5 '>�����۸�:<u>&nbsp;&nbsp;&nbsp;&nbsp;"+sPrice1+"&nbsp;&nbsp;&nbsp;&nbsp;</u>Ԫ</td>");
		 sTemp.append("</tr>");
		 sTemp.append("<tr>");
		 sTemp.append("<td style='border:0px;text-align:left; font-size: 9pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black; colspan=5 '>�ӱ��۸�:<u>&nbsp;&nbsp;&nbsp;"+sPrice2+"&nbsp;&nbsp;&nbsp;</u>Ԫ</td>");
		 sTemp.append("<td style='border:0px;text-align:left; font-size: 9pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black; colspan=5 '>��������:<u>&nbsp;&nbsp;"+sDate+"&nbsp;&nbsp;</u></td>");
		 sTemp.append("<td style='border:0px;text-align:left; font-size: 9pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black; colspan=5 '>�ӱ�����:<u>&nbsp;&nbsp;&nbsp;&nbsp;"+sServeyear+"&nbsp;&nbsp;&nbsp;&nbsp;</u>����</td>");
		 sTemp.append("</tr>");
		 sTemp.append("</table>");

		sTemp.append("<table  width='690' align=center>");
		sTemp.append("<tr><td style='border:0px;text-align:left; font-size: 9pt;FONT-FAMILY:����;FONT-WEIGHT: normal;color:black;>&nbsp;</td></tr>");
		sTemp.append("<tr><td style='border:0px;text-align:left; font-size: 9pt;FONT-FAMILY:����;FONT-WEIGHT: bold;color:black; colspan=6 colspan=6 style='border:0px; '>&nbsp;&nbsp;&nbsp;���ֻ����۱������������¼�ơ����񡱣���"+sProvider_name+"����ƽ�Ȼ�������ƽ��Ը��ԭ���������ֻ����������¹ʵ�����Ļ����ʱ��Ϊ�����ֻ��ṩά�ޱ��Ϸ���</td></tr>");
		sTemp.append("<tr><td style='border:0px;text-align:left; font-size: 9pt;FONT-FAMILY:����;FONT-WEIGHT: normal;color:black; colspan=6 colspan=6 style='border:0px;'>&nbsp;&nbsp;&nbsp;��������������£�</td></tr>");
		sTemp.append("<tr><td style='border:0px;text-align:left; font-size: 9pt;FONT-FAMILY:����;FONT-WEIGHT: normal;color:black; colspan=6 colspan=6 style='border:0px;'><b>��һ��������</b></td></tr>");
		sTemp.append("<tr><td style='border:0px;text-align:left; font-size: 9pt;FONT-FAMILY:����;FONT-WEIGHT: normal;color:black; colspan=6 colspan=6 style='border:0px;'>1.����ϵָ���ֻ��������޷���</td></tr>");
		sTemp.append("<tr><td style='border:0px;text-align:left; font-size: 9pt;FONT-FAMILY:����;FONT-WEIGHT: normal;color:black; colspan=6 colspan=6 style='border:0px;'>2.��Ʒ��ϵָ����������ڱ����۱���������Χ���ֻ���</td></tr>");
		
		sTemp.append("<tr><td style='border:0px;text-align:left; font-size: 9pt;FONT-FAMILY:����;FONT-WEIGHT: normal;color:black; colspan=6 colspan=6 style='border:0px;'><b>�ڶ����������ֻ�</b></td></tr>");
		sTemp.append("<tr><td style='border:0px;text-align:left; font-size: 9pt;FONT-FAMILY:����;FONT-WEIGHT: normal;color:black; colspan=6 colspan=6 style='border:0px;'>&nbsp;&nbsp;&nbsp;����ͬ�����ڣ�1���й���½���۵ľ߱��л����񹲺͹���ҵ����Ϣ�����䷢���������֤�ģ��ң�2��ͨ�����Ǫ���ڡ����й�˾ǩ������Э����ڹ�����ֻ���</td></tr>");
		sTemp.append("<tr><td style='border:0px;text-align:left; font-size: 9pt;FONT-FAMILY:����;FONT-WEIGHT: normal;color:black; colspan=6 colspan=6 style='border:0px;'><b>�����������޷���Χ��</b></td></tr>");
		sTemp.append("<tr><td style='border:0px;text-align:left; font-size: 9pt;FONT-FAMILY:����;FONT-WEIGHT: normal;color:black; colspan=6 colspan=6 style='border:0px;'>&nbsp;&nbsp;&nbsp;�ڱ�������Ч���ڣ������ֻ�����<b>��������ײ���������Ļ����ʱ���ڷ��ϱ���ͬԼ���������ڣ����ǳе������޶��ڵ�ά�޷��ã�Ϊ���ṩһ����Ļά�޻���Ļ�����ı��޷��񣨽���һ�Σ���ά�޸����������ľ��㲿��������Ȩ��ά�޷����ṩ�����У�</b>, ��ȷ�������ֻ���Ļ�ָ�����ʹ��״̬��<b>�������ֻ�����ԭ���������ڣ�����Ϊ���ṩ��Ļ�޸���������ǲ���ŵ���ֻ�������ԭ�����޷���</b></td></tr>");
		sTemp.append("<tr><td style='border:0px;text-align:left; font-size: 9pt;FONT-FAMILY:����;FONT-WEIGHT: normal;color:black; colspan=6 colspan=6 style='border:0px;'><b>���������������̣�</b></td></tr>");
		sTemp.append("<tr><td style='border:0px;text-align:left; font-size: 9pt;FONT-FAMILY:����;FONT-WEIGHT: normal;color:black; colspan=6 colspan=6 style='border:0px;'>&nbsp;&nbsp;&nbsp;���ֻ�������������涨�ı��޷�Χ�ڵĹ���ʱ������Ҫ�µ��������"+sService_tel+"���Ի�����߷�����Ա��Э�����������Ҫ�ṩ����������ϵ�绰����ַ���ֻ�Ʒ�Ƽ��ͺš��ֻ����š����ϵ���������Ҫ����Ϣ����<b>ά��ʱ�����ṩ�������ͬ��</b>�Ա����ݵ�Ϊ���ṩ�����������ֻ��ڳ����ڼ侭�����Ҵ�������´����б䶯�ģ�����Ҫ�ṩά�޹����򻻻�������Чƾ֤�����������������ӱ����񣩡�</td></tr>");
		sTemp.append("<tr><td style='border:0px;text-align:left; font-size: 9pt;FONT-FAMILY:����;FONT-WEIGHT: normal;color:black; colspan=6 colspan=6 style='border:0px;'><b>�������������޶�</b></td></tr>");
		sTemp.append("<tr><td style='border:0px;text-align:left; font-size: 9pt;FONT-FAMILY:����;FONT-WEIGHT: normal;color:black; colspan=6 colspan=6 style='border:0px;'>&nbsp;&nbsp;&nbsp;��������Ч���ڣ����ǳе�һ�λ�����ά����Ļ�����ܶ���������ҼǪ��ۣ�1500��Ԫ��</td></tr>");

	 	sTemp.append("<tr><td style='border:0px;text-align:left; font-size: 9pt;FONT-FAMILY:����;FONT-WEIGHT: normal;color:black; colspan=6 colspan=6 style='border:0px;'><b>�������� ��������</b></td></tr>");
		sTemp.append("<tr><td style='border:0px;text-align:left; font-size: 9pt;FONT-FAMILY:����;FONT-WEIGHT: normal;color:black; colspan=6 colspan=6 style='border:0px;'><b>&nbsp;&nbsp;&nbsp;�����񲻰�������������µ�ά�ޡ��������ʧ��</b></td></tr>");
		sTemp.append("<tr><td style='border:0px;text-align:left; font-size: 9pt;FONT-FAMILY:����;FONT-WEIGHT: normal;color:black; colspan=6 colspan=6 style='border:0px;'><b><ol><li>�ֻ����Һ����������ܹ��ϵ�ԭ���µ��𻵡�<br/></li>"
		+"<li>���ԡ����١�������ʧ�ٻ�����<br/></li>"
		+"<li>���ڳ��ұ��޷�Χ�ڵ��ֻ����ϣ��Լ��ֻ����ճ����������ޡ���ࡢ�ⲿ���ڡ�<br/></li>"
		+"<li>�ֻ���ǡ�װ���Բ��������������������ء�������������������ߵȣ����ߺĲģ������洢���ȣ���<br/></li>"
		+"<li>���ɿ����������������ڵ����׵硢���֡����֡�ս���ȣ�����ͨ���⣨�糵����ѹ�ȣ��������˺��ȡ�<br/></li>"
		+"<li>�ֻ����ŵ�Ϳ�Ļ�ȱʧ�����ֻ�������Ρ�Ť�������ѡ�����ICԪ�������ѻ�ȱʧ��<br/></li>"
		+"<li>���ֻ����϶����µ��κ���Ϣ�����ݶ�ʧ��������ʧ�򸽴���ʧ���������������޷�ʹ�á�ҵ����ʧ��������ʧ��������ʧ������ʱ����ʧ���󹤷ѣ������Ρ�<br/></li>"
		+"<li>������ٵĹ���ԭ����򽫸��ֻ��������ޡ����������ʹ������ֻ����ϵġ�<br/></li>"
		+"<li>��Ӱ���ֻ���Ļʹ�ù��ܵ���ۻ��ۡ�ĥ���ɫ���︽�š�<br/></li></ol></b></td></tr>");
		
		sTemp.append("<tr><td style='border:0px;text-align:left; font-size: 9pt;FONT-FAMILY:����;FONT-WEIGHT: normal;color:black; colspan=6 colspan=6 style='border:0px;'><b>�������� ���������Ч�ڣ�</b></td></tr>"); 
		sTemp.append("<tr><td style='border:0px;text-align:left; font-size: 9pt;FONT-FAMILY:����;FONT-WEIGHT: normal;color:black; colspan=6 colspan=6 style='border:0px;'>&nbsp;&nbsp;1����Ч���ڣ����򱾡��۱���������֮����15���ʼ��Ч��</td></tr>");
		sTemp.append("<tr><td style='border:0px;text-align:left; font-size: 9pt;FONT-FAMILY:����;FONT-WEIGHT: normal;color:black; colspan=6 colspan=6 style='border:0px;'>&nbsp;&nbsp;2����ֹ���ڣ����򱾡��۱���������֮����˳��1�꣨һ���ڣ�/ 2�꣨�����ڣ�֮��ʱֹ��</td></tr>");
		sTemp.append("<tr><td style='border:0px;text-align:left; font-size: 9pt;FONT-FAMILY:����;FONT-WEIGHT: normal;color:black; colspan=6 colspan=6 style='border:0px;'><b>�ڰ�����</b>��������Ч���ڣ������ӱ�����Χ�ڵĹ���ʱ������ά�޷ѣ�����������á���ݷ��ü�����ѣ�δ���������޶�Ľ�������֧���κη��ã����ܷ��ó����޶����Ҫ�����ге���������֧�ֵ����˻���������������Ʒ�򳧱����ϻ�����ԭ���˻��ģ�����ͬҲһ������</td></tr>");
		sTemp.append("<tr><td style='border:0px;text-align:left; font-size: 9pt;FONT-FAMILY:����;FONT-WEIGHT: normal;color:black; colspan=6 colspan=6 style='border:0px;'><b>�ھ����� ���������ֹ��</b></td></tr>");
		sTemp.append("<tr><td style='border:0px;text-align:left; font-size: 9pt;FONT-FAMILY:����;FONT-WEIGHT: normal;color:black; colspan=6 colspan=6 style='border:0px;'>&nbsp;&nbsp;&nbsp;����������֮һ�ģ����۱���������Ȼ��ֹ��</td></tr>");
		sTemp.append("<tr><td style='border:0px;text-align:left; font-size: 9pt;FONT-FAMILY:����;FONT-WEIGHT: normal;color:black; colspan=6 colspan=6 style='border:0px;'>1.	�Ѵﵽ����ͬԼ�����ӱ���Ч�ڻ��ͬ��Ч�����ֻ�������һ����Ļ������ά�޷���ģ���������黹����Э��Լ���Ŀ����<br/>"
		+"2.	������Ʒ�Ǿ������ǻ�ͬƷ�Ƴ�����Ȩ��ά�޻�������������û��ġ�<br/>"
		+"3.	�����������ֻ��������ٹ���������ƭȡ�������ά�޵ģ�һ��֤ʵ��������Ȩ������������񣬲����˻�����ȡ���ӱ�����ѣ�����ȨҪ���������Ѿ�������ά�޷��ü�������ط��ã��������������㲿���ɱ�����ʱ���á��������á�</td></tr>");
		
		sTemp.append("<tr><td style='border:0px;text-align:left; font-size: 9pt;FONT-FAMILY:����;FONT-WEIGHT: normal;color:black; colspan=6 colspan=6 style='border:0px;'><b>��ʮ�� ���鴦��</b></td></tr>");
		sTemp.append("<tr><td style='border:0px;text-align:left; font-size: 9pt;FONT-FAMILY:����;FONT-WEIGHT: normal;color:black; colspan=6 colspan=6 style='border:0px;'>&nbsp;&nbsp;&nbsp;��������ִ�й����д�������ģ�˫�����Ѻ�Э�̽�������Ѻ�Э����δ�ܴ��һ�µģ�˫���������������ٲ�ίԱ���ٲá�</td></tr>");
		sTemp.append("<tr><td style='border:0px;text-align:left; font-size: 9pt;FONT-FAMILY:����;FONT-WEIGHT: normal;color:black; colspan=6 colspan=6 style='border:0px;'><b>�˿��������˿�ȷ���Ѿ������Ķ�����ȫ��Ȿ��ͬ�еĸ�������ҶԺ�ͬ����������������ε��������յ�����ע����ر�˵����</b></td></tr>");
		
		sTemp.append("<tr><td style='border:0px;text-align:left; font-size: 9pt;FONT-FAMILY:����;FONT-WEIGHT: normal;color:black; colspan=6 colspan=6 style='border:0px;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"
		+"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<b>�˿ͣ�ǩ������  </b></td></tr>");	
		sTemp.append("<tr><td style='border:0px;text-align:left; font-size: 8pt;FONT-FAMILY:����;FONT-WEIGHT: normal;color:black; colspan=6 colspan=6 style='border:0px;'>�汾�ţ�"+sVersion+"</td></tr>");	


		sTemp.append("</table>");	
		sTemp.append("</div>");	
		sTemp.append("<input type='hidden' name='Method' value='1'>");
		sTemp.append("<input type='hidden' name='SerialNo' value='"+sSerialNo+"'>");
		sTemp.append("<input type='hidden' name='ObjectNo' value='"+sObjectNo+"'>");
		sTemp.append("<input type='hidden' name='ObjectType' value='"+sObjectType+"'>");
		sTemp.append("<input type='hidden' name='Rand' value=''>");
		sTemp.append("<input type='hidden' name='CompClientID' value='"+CurComp.getClientID()+"'>");
		sTemp.append("<input type='hidden' name='PageClientID' value='"+CurPage.getClientID()+"'>");
		sTemp.append("</form>");	
			

	String sReportInfo = sTemp.toString();
	String sPreviewContent = "pvw"+java.lang.Math.random();
%>
<%/*~END~*/%>

<%@include file="/FormatDoc/IncludeFDFooter.jsp"%>

<script type="text/javascript">
<%	
	if(sMethod.equals("1"))  //1:display
	{
%>
	//�ͻ���3
	var config = new Object();  
<%
	}
%>	
</script>	
	
<%@ include file="/IncludeEnd.jsp"%>
