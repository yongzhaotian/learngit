<%@ page language="java" contentType="text/html;charset=GBK" %><%@page import="java.sql.*,java.util.*,com.amarsoft.awe.dw.ui.keyfilter.*"%><%@page import="com.amarsoft.are.ARE"%><%
String sKey = request.getParameter("key")==null?"":request.getParameter("key").toString();
String sDono = request.getParameter("dono")==null?"":request.getParameter("dono").toString();
String sColName = request.getParameter("colname")==null?"":request.getParameter("colname").toString();
String sRand = request.getParameter("rand")==null?"":request.getParameter("rand").toString();
String sResult = "";
if(!sDono.equals("") && !sColName.equals("")){
	//以json格式返回数据
	System.out.println("tradeindex search begine:key=" + sKey + ",dono=" + sDono + ",colname=" + sColName + ",rand=" + sRand);
	TradeKeySearch tradeKeySearch = TradeKeySearch.getInstance(sDono,sColName);//获得缓存对象
	ArrayList list = tradeKeySearch.getCacheOutput(sDono,sColName,sKey);
	sResult += "{";
	sResult += "success:true,";
	sResult += "error:\"\",";
	sResult += "sigleInfo:\"\",";
	sResult += "data:[";
	for(int i=0;i<list.size();i++){
		TradeKey tradeKey = (TradeKey)list.get(i);
		//System.out.println(tradeKey.tradeIndex);	
		sResult += "{";
		sResult += "tradeKey:\"" + tradeKey.key + "\",";
		sResult += "tradeValue:\"" + tradeKey.value + "\",";
		sResult += "tradeTitle:\"" + (tradeKey.title==null?"":tradeKey.title) + "\",";
		sResult += "hitCount:" + tradeKey.hitCount;
		sResult += "}";
		if(i<list.size()-1)sResult += ",";
	}
	sResult += "]";
	sResult += "}";
}
out.print(sResult);
System.out.println(sResult);
%>