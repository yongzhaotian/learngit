<%
/* Copyright 2001-2005 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.  
 * Use is subject to license terms.
 * Author:fhhao 2003.09.02
 * Tester:
 * Content:      ��ӡ���õȼ�������
 * Input Param:
 *			ObjectType  :  ��������
 *		    ObjectNo    :  ������
 *          SerialNo    :  ������ˮ��
 * Output param:
 *
 *	History Log:   2003.02.12 FXie  �޸ĸ���ʾ���ݣ�ȥ����Ȩ�����ɾ���������fTitle2,fvalue1,dPowerScore,sPowerResult
 *                                  preevaluate.Data.getString("ItemValue")��evaluate.Data.getString("ItemValue")���ص�Nullֵ���ַ���
 *                                  �����б�����sTitle.equalsIgnoreCase("null")
 */
%>

<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%@page import=" java.math.BigDecimal,com.amarsoft.biz.evaluate.*" %>
<%
	String sObjectType,sObjectNo,sSerialNo;
	String sAccountMonth="",sModelNo="",sModelName="";
	String sItemName,sValueCode,sValueMethod,sValueType;	
	String sEvaluateResult="",sEvaluateDate="",sOrgName="",sUserName="";
	String sCognDate="",sCognResult="",sCognOrgName="",sCognUserName="",sRemark="";
	String sCustomerName="",sSetupDate="",sPreAccountMonth="",CurYear="",sIndustryType="";
	float  dEvaluateScore=0.0f,dPreScore=0.0f;
	boolean  PreEvaluateabsent;  //�ж�ǰһ�����õȼ��Ƿ����  
	int  iYear=0;
	ASResultSet rs;
	Evaluate evaluate,preevaluate;
		
	sObjectType = DataConvert.toRealString(iPostChange,(String)request.getParameter("ObjectType"));
	sObjectNo   = DataConvert.toRealString(iPostChange,(String)request.getParameter("ObjectNo"));
	sSerialNo   = DataConvert.toRealString(iPostChange,(String)request.getParameter("SerialNo"));
	evaluate    = new Evaluate(sObjectType,sObjectNo,sSerialNo,Sqlca);	

	rs = Sqlca.getASResultSet(new SqlObject("select AccountMonth,ModelNo,EvaluateDate,EvaluateScore,EvaluateResult,getOrgName(OrgID) as OrgName,getUserName(UserID) as UserName,CognDate,"+
			" CognResult,getOrgName(CognOrgID) as CognOrgName,getUserName(CognUserID) as CognUserName,Remark,PowerScore,PowerResult from EVALUATE_RECORD where ObjectType=:ObjectType and ObjectNo=:ObjectNo and SerialNo=:SerialNo")
	.setParameter("ObjectType",sObjectType).setParameter("ObjectNo",sObjectNo).setParameter("SerialNo",sSerialNo));
	if (rs.next())
	{	
		sAccountMonth   = DataConvert.toString(rs.getString(1));
		sModelNo        = DataConvert.toString(rs.getString(2));
		sEvaluateDate   = DataConvert.toString(rs.getString(3));
		dEvaluateScore  = rs.getFloat(4);
		sEvaluateResult = DataConvert.toString(rs.getString(5));
		sOrgName        = DataConvert.toString(rs.getString(6));
		sUserName       = DataConvert.toString(rs.getString(7));
		sCognDate       = DataConvert.toString(rs.getString(8));
		sCognResult     = DataConvert.toString(rs.getString(9));
		sCognOrgName    = DataConvert.toString(rs.getString(10));
		sCognUserName   = DataConvert.toString(rs.getString(11));
		sRemark         = DataConvert.toString(rs.getString(12));
	}
	rs.getStatement().close();
	
	
	if ((sRemark!=null) && !sRemark.equals("")&& !sRemark.equalsIgnoreCase("null"))
	{
		sRemark = StringFunction.replace(sRemark,"\\r\\n","");
	}
	//ȡ�����õȼ�ģ������
	rs = Sqlca.getASResultSet(new SqlObject("select ModelName from EVALUATE_CATALOG where ModelType='010' and ModelNo=:ModelNo").setParameter("ModelNo",sModelNo));
	if (rs.next()) sModelName = rs.getString(1);
	rs.getStatement().close();	
	//ȡ�ÿͻ����ơ��ͻ���������
	rs = Sqlca.getASResultSet(new SqlObject("select EnterpriseName,SetupDate,getItemName('IndustryType',IndustryType) as IndustryType from ENT_INFO where CustomerID=:CustomerID").setParameter("CustomerID",sObjectNo));
	if (rs.next())
	{   sCustomerName = DataConvert.toString(rs.getString(1));  
		sSetupDate    = DataConvert.toString(rs.getString(2));  
		sIndustryType = DataConvert.toString(rs.getString(3));  
	}
	rs.getStatement().close();	
	
	//ȡ��
	
	//�������ڻ���·�
	CurYear = sAccountMonth.substring(0,4);
	iYear = Integer.parseInt(CurYear) - 1;
	sPreAccountMonth = String.valueOf(iYear) + "/12";

	//ȡ����������
	rs = Sqlca.getASResultSet(new SqlObject("select SerialNo,EvaluateScore from EVALUATE_RECORD where ObjectType='Customer' and ObjectNo=:ObjectNo and AccountMonth=:AccountMonth").setParameter("ObjectNo",sObjectNo).setParameter("AccountMonth",sPreAccountMonth));
	if (rs.next())
	{   sSerialNo = DataConvert.toString(rs.getString(1));  
		dPreScore = rs.getFloat(2);  
	              
		PreEvaluateabsent = true;
	}else
	{
		PreEvaluateabsent = false;
	}
	rs.getStatement().close();
	
	preevaluate = new Evaluate(sObjectType,sObjectNo,sSerialNo,Sqlca);	

	dPreScore      = Round(dPreScore,2);
	dEvaluateScore = Round(dEvaluateScore,2);
				
%>
<html>
<head>
<title>��ӡ���õȼ�������</title>
<script type="text/javascript">
		
		function doprint()
		{
			window.print();
		}
		
		function goBack()
		{
			self.close();
		}	
		
        function beforePrint()
		{
			document.getElementById('PrintButton').style.display='none';
		}
		
		function afterPrint()
		{
			document.getElementById('PrintButton').style.display="";
		}		
</script>
</head>

<body onbeforeprint="beforePrint()"  onafterprint="afterPrint()" >

<body>
<center>
<b1>��ҵ���й�˾�ͻ����õȼ�������</b1>
<P>
<table width="80%"% style='font-family:����,arial,sans-serif;font-size: 8pt;align=center'  bordercolordark='#EEEEEE' bordercolorlight='#CCCCCC'>

<tr><td>�ͻ�����:<%=sCustomerName%></td><td>����ʱ��:<%=DataConvert.toString(sEvaluateDate)%></td><td>�������:<%=sEvaluateResult%></td></tr>
<tr><td>��������:<%=sOrgName%></td><td>������Ա:<%=sUserName%></td></tr>
<tr><td>������ҵ����:<%=sIndustryType%></td><td>���õȼ�����ģ��:<%=sModelName%></td></tr>
<tr><td>���ڱ�������:<%=sPreAccountMonth%></td><td>���ڱ�������:<%=sAccountMonth%></td></tr>
<tr><td>�����ܵ÷�:<%=dPreScore%></td><td>�����ܵ÷�:<%=dEvaluateScore%></td></tr>
<tr><td>������������:<%=sRemark%></td></tr>
</table>
</center>
<style type="text/css">
<!--
.thistable {  border: solid; border-width: 0px 0px 1px 1px; border-color: #000000 black #000000 #000000}
.thistd {  border-color: #000000; border-style: solid; border-top-width: 1px; border-right-width: 1px; border-bottom-width: 0px; border-left-width: 0px}
-->
</style>
<div id="Layer1" style="position:absolute; left:24px; top:9px; width:26px; height:20px; z-index:1" bordercolordark='#EEEEEE' bordercolorlight='#CCCCCC'></div>
<table align="center">
	<tr>
	<td>
	<form name="report" method="post">
		<table width="100%" cellspacing="0" border="1"  height="1" cellpadding="0" class="thistable" align="center">
			<tr bgcolor="#CCCCCC"> 
				<td  width="50"  align="center" class="thistd">���</font></td>
				<td  width="100" align="center" class="thistd">ָ������</font></td>
				<td  width="50" align="center"  class="thistd">���ڽ��</font></td>
				<td  width="50"  align="center" class="thistd">���ڵ÷�</font></td>
				<td  width="50" align="center"  class="thistd">���ڽ��</font></td>
				<td  width="50"  align="center" class="thistd">���ڵ÷�</font></td>
			</tr>
<%!     
	//�����ֵ�С��λ������λ
	float Round(float value,int l)
	{
		BigDecimal bigvalue = new BigDecimal(value);
		String str = bigvalue.toString();
		int p = str.indexOf(".");         //С����λ��
		int q = str.length() - p - 1;     //С�����λ��

		if (q > l)
       	{
			//Ҫ����������
			String s1 = str.substring(0, p + l + 1);
			//Ҫ�����������������
			String s2 = str.substring(p + l + 1, p + l + 2);

			//ת��Ϊ���ֽ��д���
			BigDecimal bigs1 = new BigDecimal(s1);
			int ints2 = Integer.parseInt(s2);

			//������ڵ���5���1
			if (ints2 >= 5)
			{
				BigDecimal addvalue = new BigDecimal(Math.pow(10, -l));
				bigs1 = bigs1.add(addvalue);
			}
			str = bigs1.toString();
		} 
		return Float.parseFloat(str);
	} 
%>

<%
	int    i = 0 ;
	float  fTitle=0.00f,fTitle1=0.00f; 
	String sTitle="",sTitle1="";
	String myS="",myItemName="",sItem="",sItName="";
	String sPreItem="",sPreItName="",sPreValueCode="",sPreValueMethod="",sPreValueType="";
	String myPre="",myPreItemName="",sDisplayNo="";

	if(PreEvaluateabsent && evaluate.Data.first())
	{
		do
		{
		i ++;
     	sItemName = "R" + String.valueOf(i);          
     	myItemName=DataConvert.toString(evaluate.Data.getString("ItemName"));
     	if (myItemName.equals("ʵ�о��ʲ�") || myItemName.equals("���γ����ʲ�"))
		{
		%> 
          <tr> 
            <td class="thistd" nowrap ><%=DataConvert.toString(evaluate.Data.getString("DisplayNo"))%></td>
            <td class="thistd" nowrap ><%=myItemName%>(��Ԫ)</td>
		<%
		}else
		{
		%>
          <tr> 
            <td class="thistd" nowrap ><%=DataConvert.toString(evaluate.Data.getString("DisplayNo"))%></td>
            <td class="thistd" nowrap ><%=myItemName%></td>		
		<%
		}
	 	sValueCode   = evaluate.Data.getString("ValueCode"); 
	 	sValueMethod = evaluate.Data.getString("ValueMethod"); 
	 	sValueType   = evaluate.Data.getString("ValueType"); 

	 	sPreValueCode   = preevaluate.Data.getString("ValueCode"); 
	 	sPreValueMethod = preevaluate.Data.getString("ValueMethod"); 
	 	sPreValueType   = preevaluate.Data.getString("ValueType"); 
	    
	    
	    
	 	if (sValueCode != null && sValueCode.trim().length() > 0 && !sValueCode.equalsIgnoreCase("null")) //����д�������ʾ�����б�
	 	{
	 		sItName = DataConvert.toString(evaluate.Data.getString("ItemValue"));
	 		rs = Sqlca.getASResultSet(new SqlObject("select ItemName from CODE_LIBRARY where CodeNo = :CodeNo and ItemNo=:ItemNo").setParameter("CodeNo",sValueCode).setParameter("ItemNo",sItName));
			if (rs.next()) sItem = rs.getString(1);
			rs.getStatement().close();		

	 		sPreItName = DataConvert.toString(preevaluate.Data.getString("ItemValue"));
	 		rs = Sqlca.getASResultSet(new SqlObject("select ItemName from CODE_LIBRARY where CodeNo = :CodeNo and ItemNo=:ItemNo").setParameter("CodeNo",sPreValueCode).setParameter("ItemNo",sPreItName));
			if (rs.next()) sPreItem = rs.getString(1);
			rs.getStatement().close();				
			 		
	 	%> 
            <td nowrap align="right" class="thistd">&nbsp;<%=sPreItem%></td>
            <td nowrap  align="right"class="thistd">&nbsp;<%=preevaluate.Data.getFloat("EvaluateScore")%></td>
            <td nowrap align="right" class="thistd">&nbsp;<%=sItem%></td>
            <td nowrap  align="right"class="thistd">&nbsp;<%=evaluate.Data.getFloat("EvaluateScore")%></td>
		<%
	 	}else if ((sValueMethod != null && sValueMethod.trim().length() > 0 && !sValueMethod.equalsIgnoreCase("null")) || sValueType==null || sValueType.trim().length() == 0 || sValueType.equalsIgnoreCase("null")) //�����ȡֵ�������ܽ����޸�
	 	{
	 		myS=DataConvert.toString(evaluate.Data.getString("ItemValue"));
	 		if(myS==null || myS.equalsIgnoreCase("null") || myS.equals(""))
	 		{
				myS="0.00";
	 		}

	 		myPre=DataConvert.toString(preevaluate.Data.getString("ItemValue"));
	 		if(myPre==null || myPre.equalsIgnoreCase("null") || myPre.equals(""))
	 		{
				myPre="0.00";
	 		}
	 		
	 		if (sValueType != null && !sValueType.equalsIgnoreCase("null"))
			{
				if (myItemName.equals("ʵ�о��ʲ�") || myItemName.equals("���γ����ʲ�"))
				{
		%> 
           
            <td nowrap  height='22' align="right" class="thistd">&nbsp;<%=preevaluate.Data.getFloat("ItemValue")/10000%></td>
            <td nowrap  align="right" class="thistd">&nbsp;<%=Round(preevaluate.Data.getFloat("EvaluateScore"),2)%></td>
            <td nowrap  height='22' align="right" class="thistd" name=<%=sItemName%>>&nbsp;<%=evaluate.Data.getFloat("ItemValue")/10000%></td>
            <td nowrap  align="right" class="thistd">&nbsp;<%=Round(evaluate.Data.getFloat("EvaluateScore"),2)%></td>
		<%
				}else
				{
					sDisplayNo=DataConvert.toString(evaluate.Data.getString("DisplayNo"));
					if (sDisplayNo.length()>1)
					{
				%>
            <td nowrap  height='22' align="right" class="thistd">&nbsp;<%=Round(Float.parseFloat(myPre),2)%></td>
            <td nowrap  align="right" class="thistd">&nbsp;<%=Round(preevaluate.Data.getFloat("EvaluateScore"),2)%></td>
            <td nowrap  height='22' align="right" class="thistd" name=<%=sItemName%>>&nbsp;<%=Round(Float.parseFloat(myS),2)%></td>
            <td nowrap  align="right" class="thistd">&nbsp;<%=Round(evaluate.Data.getFloat("EvaluateScore"),2)%></td>
				<%
					}else //��ʾ�����ķ���
					{
						sTitle=DataConvert.toString(preevaluate.Data.getString("ItemValue"));
						sTitle1=DataConvert.toString(evaluate.Data.getString("ItemValue"));
						if (sTitle==null || sTitle.equals("")||sTitle.equalsIgnoreCase("null"))
							sTitle="0.00";
						if (sTitle1==null || sTitle1.equals("")||sTitle.equalsIgnoreCase("null"))
							sTitle1="0.00";
							
						fTitle=Float.parseFloat(sTitle);
						fTitle1=Float.parseFloat(sTitle1);
					%>
            		<td nowrap  height='22' align="right" class="thistd">&nbsp;</td>
            		<td nowrap  align="right" class="thistd">&nbsp;<%=Round(fTitle,2)%></td>
            		<td nowrap  height='22' align="right" class="thistd" name=<%=sItemName%>>&nbsp;</td>
            		<td nowrap  align="right" class="thistd">&nbsp;<%=Round(fTitle1,2)%></td>
					<%					
					}
				}
			}else
			{
			%>
            <td nowrap  height='22' align="right" class="thistd">&nbsp; </td>
            <td nowrap  align="right" class="thistd">&nbsp;</td>
            <td nowrap  height='22' align="right" class="thistd">&nbsp; </td>
            <td nowrap  align="right" class="thistd">&nbsp; </td>        			
		<%
			}
	 	}else
	 	{
		%> 
            <td nowrap  height='22' align="right" class="thistd">&nbsp;<%=preevaluate.Data.getFloat("ItemValue")%></td>
            <td nowrap  align="right" class="thistd">&nbsp;<%=preevaluate.Data.getFloat("EvaluateScore")%></td>
            <td nowrap  height='22' align="right" class="thistd">&nbsp;<%=evaluate.Data.getFloat("ItemValue")%></td>
            <td nowrap  align="right" class="thistd">&nbsp;<%=evaluate.Data.getFloat("EvaluateScore")%></td>
		<%	 	
	 	
	 	}
            %>
		</tr>
          <%
		}while(evaluate.Data.next()&& preevaluate.Data.next());
	}else
	{
		do
		{
		i ++;
     	sItemName = "R" + String.valueOf(i);          
     	myItemName=DataConvert.toString(evaluate.Data.getString("ItemName"));
     	if (myItemName.equals("ʵ�о��ʲ�") || myItemName.equals("���γ����ʲ�"))
		{     	
		%> 
          <tr> 
            <td nowrap class="thistd"><%=DataConvert.toString(evaluate.Data.getString("DisplayNo"))%></td>
            <td nowrap class="thistd"><%=myItemName%>(��Ԫ)</td>
		<%
		}else
		{
		%>
          <tr> 
            <td nowrap class="thistd"><%=DataConvert.toString(evaluate.Data.getString("DisplayNo"))%></td>
            <td nowrap class="thistd"><%=myItemName%></td>		
		<%
		}
	 	sValueCode   = evaluate.Data.getString("ValueCode"); 
	 	sValueMethod = evaluate.Data.getString("ValueMethod"); 
	 	sValueType   = evaluate.Data.getString("ValueType"); 

	 	if (sValueCode != null && sValueCode.trim().length() > 0) //����д�������ʾ�����б�
	 	{
	 		sItName = DataConvert.toString(evaluate.Data.getString("ItemValue"));
	 		rs = Sqlca.getASResultSet(new SqlObject("select ItemName from CODE_LIBRARY where CodeNo = :CodeNo and ItemNo=:ItemNo").setParameter("CodeNo",sValueCode).setParameter("ItemNo",sItName));
			if (rs.next()) sItem = rs.getString(1);
			rs.getStatement().close();		
	 		
	 	%> 
            <td nowrap align="right" class="thistd">&nbsp;</td>
            <td nowrap  align="right"class="thistd">&nbsp;</td>
            <td nowrap align="right" class="thistd">&nbsp;<%=sItem%></td>
            <td nowrap  align="right" class="thistd">&nbsp;<%=evaluate.Data.getFloat("EvaluateScore")%></td>
		<%
	 	}else if ((sValueMethod != null && sValueMethod.trim().length() > 0) || sValueType == null || sValueType.trim().length() == 0) //�����ȡֵ�������ܽ����޸�
	 	{
	 		myS=DataConvert.toString(evaluate.Data.getString("ItemValue"));
	 		if(myS==null || myS.equalsIgnoreCase("null") || myS.equals(""))
	 		{
				 myS="0.00";
	 		}

			if (sValueType != null)
			{
				float fvalue = Round(evaluate.Data.getFloat("EvaluateScore"),2);

				if (myItemName.equals("ʵ�о��ʲ�") || myItemName.equals("���γ����ʲ�"))
				{
			%> 
            <td nowrap  height='22' align="right" class="thistd">&nbsp;</td>
            <td nowrap  align="right" class="thistd">&nbsp;</td>
            <td nowrap  height='22' align="right" class="thistd" name=<%=sItemName%>>&nbsp;<%=evaluate.Data.getFloat("ItemValue")/10000%></td>
            <td nowrap  align="right" class="thistd">&nbsp;<%=fvalue%></td>          
			<%
				}else
				{
					sDisplayNo=DataConvert.toString(evaluate.Data.getString("DisplayNo"));
					if (sDisplayNo.length()>1)
					{
				%>
            <td nowrap  height='22' align="right" class="thistd">&nbsp;</td>
            <td nowrap  align="right" class="thistd">&nbsp;</td>
            <td nowrap  height='22' align="right" class="thistd" name=<%=sItemName%>>&nbsp;<%=Round(Float.parseFloat(myS),2)%></td>
            <td nowrap  align="right" class="thistd">&nbsp;<%=fvalue%></td>          				
					<%
					}else //��ʾ������С�Ʒ���
					{		
						sTitle=DataConvert.toString(evaluate.Data.getString("ItemValue"));
						if (sTitle==null || sTitle.equals("")||sTitle.equalsIgnoreCase("null"))
							sTitle="0.00";
						fTitle=Float.parseFloat(sTitle);
						if (sDisplayNo.equals("1") || sDisplayNo.equals("7") || sDisplayNo.equals("8"))
						{
							fTitle1=fTitle;
						}else
						{
							fTitle1=fTitle*7/10;
						}
					%>
            		<td nowrap  height='22' align="right" class="thistd">&nbsp; </td>
            		<td nowrap  align="right" class="thistd">&nbsp;</td>
            		<td nowrap  height='22' align="right" class="thistd">&nbsp; </td>
            		<td nowrap  align="right" class="thistd">&nbsp;<%=Round(fTitle,2)%> </td>
					<%
					}				
				}
			}else
			{
			%>
            <td nowrap  height='22' align="right" class="thistd">&nbsp; </td>
            <td nowrap  align="right" class="thistd">&nbsp;</td>
            <td nowrap  height='22' align="right" class="thistd">&nbsp; </td>
            <td nowrap  align="right" class="thistd">&nbsp;</td>
			<%
			}
	 	}else
	 	{	 	
		%> 
            <td nowrap  height='22' align="right" class="thistd">&nbsp;</td>
            <td nowrap  align="right" class="thistd">&nbsp;</td>
            <td nowrap  height='22' align="right" class="thistd">&nbsp;<%=evaluate.Data.getFloat("ItemValue")%></td>
            <td nowrap  align="right" class="thistd">&nbsp;<%=evaluate.Data.getFloat("EvaluateScore")%></td>
		<%
	 	}
            %>
		</tr>
          <%
		}while(evaluate.Data.next()); 
 	}
 
%> 
        </table>
      </form>
	</td>
	</tr>
</table>

    <div id='PrintButton'> 
	<table border="0" width="80%" align="center">
		<tr> 
			<td align=center width="25%"> 
				<p class="orange9pt"><a href="javascript:doprint()">��ӡ</a></p>
			</td>
			<td align=center width="25%"> 
				<p class="orange9pt"><a href="javascript:goBack()">�ر�</a></p>
			</td>
		</tr>
	</table>
</div>

<%
evaluate.close();
preevaluate.close();
%> 
</body>
</html>
<%@ include file="/IncludeEnd.jsp"%>