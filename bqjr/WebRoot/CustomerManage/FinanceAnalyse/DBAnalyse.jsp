<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>
<%

String sCustomerID  = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("CustomerID"));
String sAccountMonth = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("AccountMonth"));

String str="                                     权益净利率%\n                                    A                   \n                                         │\n                                ┌──────────┐\n                              资产净利率%  ×     权益乘数\n                              B                   C                                \n                                │\n                        ┌────────────┐\n                        销售净利率%   ×    资产周转率%\n                        D                   E                    \n                         │                      │\n                  ┌──────┐            ┌───────────────┐ \n                净利   ÷   销售收入         销售收入    ÷ 　　　      资产总额\n                F           G                G                          H                  \n                  │                                                　　　│\n        ┌────────┬──────┬─────┐             ┌────────┐ \n      销售收入　－　　全部成本　＋　其他利润－　所得税         长期资产＋         流动资产\n      G               I             J           K               L                  M             \n              　　       │                                                       │\n        ┌──────┬──────┬────┐　　　    ┌───────┬────┬──────┐\n    销售成本　+　 管理费用　+  营业费用 + 财务费用       现金及等价物+ 应收款项 + 存货 +  其他流动资产\n    N             O            P          Q              R             S          T       U                   ";
Hashtable ht = new Hashtable();
double[] tempd = new double[21];
String temps[] = {"A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U"};
String sCustomerName;
ASResultSet rs;
rs = Sqlca.getASResultSet(new SqlObject("select CustomerName from CUSTOMER_INFO where CustomerID = :CustomerID").setParameter("CustomerID",sCustomerID));
if(rs.next())
{
	sCustomerName = rs.getString(1);
}
else
{
	sCustomerName = "";
}
rs.getStatement().close();

String tempstr;
//选择最小报表口径的数据用于杜邦分析
rs = Sqlca.getASResultSet(new SqlObject("select FinanceItemNo,Item2Value from FINANCE_DATA where CustomerID = :CustomerID1 and AccountMonth = :AccountMonth1 and scope in ( select min(scope) from FINANCE_DATA where CustomerID = :CustomerID2 and AccountMonth = :AccountMonth2 ) and FinanceItemNo in ('910','909','901','905','517','804','501','506','516','801','502','507','503','508','101','104','110','115')").setParameter("CustomerID1",sCustomerID).setParameter("AccountMonth1",sAccountMonth).setParameter("CustomerID2",sCustomerID).setParameter("AccountMonth2",sAccountMonth));
while(rs.next())
{
	tempstr = rs.getString(2);
	if(tempstr==null) tempstr="";
	ht.put(rs.getString(1),tempstr);
}
rs.getStatement().close();
//rs.close();

tempstr=(String)ht.get("801");
if(tempstr!=null&&!tempstr.equals(""))
{
	 tempd[12] = Double.parseDouble(tempstr);
}
else
{
	tempd[12] = 0;
}
tempstr=(String)ht.get("101");
if(tempstr!=null&&!tempstr.equals(""))
{
	 tempd[17] = Double.parseDouble(tempstr);
}
else
{
	tempd[17] = 0;
}
tempstr=(String)ht.get("104");
if(tempstr!=null&&!tempstr.equals(""))
{
	 tempd[18] = Double.parseDouble(tempstr);
}
else
{
	tempd[18] = 0;
}
tempstr=(String)ht.get("110");
if(tempstr!=null&&!tempstr.equals(""))
{
	 tempd[19] = Double.parseDouble(tempstr);
}
else
{
	tempd[19] = 0;
}
tempd[20] = tempd[12] - tempd[17] - tempd[18] - tempd[19];
tempstr=(String)ht.get("502");
if(tempstr!=null&&!tempstr.equals(""))
{
	 tempd[13] = Double.parseDouble(tempstr);
}
else
{
	tempd[13] = 0;
}
tempstr=(String)ht.get("507");
if(tempstr!=null&&!tempstr.equals(""))
{
	 tempd[14] = Double.parseDouble(tempstr);
}
else
{
	tempd[14] = 0;
}
tempstr=(String)ht.get("503");
if(tempstr!=null&&!tempstr.equals(""))
{
	 tempd[15] = Double.parseDouble(tempstr);
}
else
{
	tempd[15] = 0;
}
tempstr=(String)ht.get("508");
if(tempstr!=null&&!tempstr.equals(""))
{
	 tempd[16] = Double.parseDouble(tempstr);
}
else
{
	tempd[16] = 0;
}
tempd[8] = tempd[13] + tempd[14] + tempd[15] + tempd[16];
tempstr=(String)ht.get("804");
if(tempstr!=null&&!tempstr.equals(""))
{
	 tempd[7] = Double.parseDouble(tempstr);
}
else
{
	tempd[7] = 0;
}
tempd[11] = tempd[7] - tempd[12];
tempstr=(String)ht.get("517");
if(tempstr!=null&&!tempstr.equals(""))
{
	 tempd[5] = Double.parseDouble(tempstr);
}
else
{
	tempd[5] = 0;
}
tempstr=(String)ht.get("501");
if(tempstr!=null&&!tempstr.equals(""))
{
	 tempd[6] = Double.parseDouble(tempstr);
}
else
{
	tempd[6] = 0;
}
tempstr=(String)ht.get("516");
if(tempstr!=null&&!tempstr.equals(""))
{
	 tempd[10] = Double.parseDouble(tempstr);
}
else
{
	tempd[10] = 0;
}
tempd[9] = tempd[5] - tempd[6] + tempd[8] + tempd[10];
tempstr=(String)ht.get("905");
if(tempstr!=null&&!tempstr.equals(""))
{
	 tempd[4] = Double.parseDouble(tempstr);
}
else
{
	tempd[4] = 0;
}
tempstr=(String)ht.get("901");
if(tempstr!=null&&!tempstr.equals(""))
{
	 tempd[3] = Double.parseDouble(tempstr);
}
else
{
	tempd[3] = 0;
}
tempstr=(String)ht.get("909");
if(tempstr!=null&&!tempstr.equals(""))
{
	 tempd[1] = Double.parseDouble(tempstr);
}
else
{
	tempd[1] = 0;
}
tempstr=(String)ht.get("910");
if(tempstr!=null&&!tempstr.equals(""))
{
	 tempd[0] = Double.parseDouble(tempstr);
}
else
{
	tempd[0] = 0;
}
if(tempd[1]==0)
{
	 tempd[2] = 0;
}
else
{
	tempd[2] = tempd[0] / tempd[1];
}

int index,len;
for(int i=0;i<21;i++)
{
	tempstr = String.valueOf(tempd[i]);
	len = tempstr.length();
	while((index=str.indexOf(temps[i])) > 0 )
	{
		str = str.substring(0,index) + tempstr + str.substring(index+len);
	}	
}
%>
<html>
<body bgcolor="#DEDFCE" leftmargin=0 topmargin=0>
<br>
<center>
<table>
<tr><td align=center><h2><%=sCustomerName%> <%=sAccountMonth%>杜邦分析图</h2></td></tr>
<tr valign=top><td>
<pre>

<%=str%>
</pre>
</td>
</tr>
</table>
</center>
</body>
</html>


<%@ include file="/IncludeEnd.jsp"%>