<%@page import="java.net.URLEncoder"%>
<%@page import="java.net.URLDecoder"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<!DOCTYPE html>
<html>
<head>
</head>
<body>
<%
	String phoneNum = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("phoneNumber"));
	String customerName = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("customerName"));
	String idCard = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("idCard"));
	String KinshipName = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("KinshipName"));
	String KinshipTel = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("KinshipTel"));
	String RelativeType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("RelativeType"));
	String OtherContact = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("OtherContact"));
	String ContactTel = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ContactTel"));
	String Contactrelation = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("Contactrelation"));
	customerName = URLDecoder.decode(customerName, "UTF-8");
	KinshipName = URLDecoder.decode(KinshipName, "UTF-8");
	RelativeType = URLDecoder.decode(RelativeType, "UTF-8");
	OtherContact = URLDecoder.decode(OtherContact, "UTF-8");
	Contactrelation = URLDecoder.decode(Contactrelation, "UTF-8");
%>
      <iframe id="myIframe" width="700px" height="500px" src='https://www.juxinli.com/org/apply/getApplyByUrl?args={"orgInfo":{"distribute_api_token":"e2262dfa19ef45c5b1dff1b48cc2dadf","customized":[2]},"applyInfo":{"applicant":{"name":"<%=URLEncoder.encode(customerName, "UTF-8") %>","id_card_num":"<%=URLDecoder.decode(idCard) %>","cell_phone_num":"<%=URLEncoder.encode(phoneNum, "UTF-8") %>","home_addr":"shanghaishiyangpuqu","work_tel":"","work_addr":"","home_tel":"","cell_phone_num2":""},"contact":[{"contact_name":"<%=URLEncoder.encode(KinshipName, "UTF-8") %>","contact_tel":"<%=URLDecoder.decode(KinshipTel) %>","contact_type":"<%=URLEncoder.encode(RelativeType, "UTF-8") %>"},{"contact_name":"<%=URLEncoder.encode(OtherContact, "UTF-8") %>","contact_tel":"<%=URLDecoder.decode(ContactTel) %>","contact_type":"<%=URLEncoder.encode(Contactrelation, "UTF-8") %>"}],"loan":{"amount":"","term":"","purpose":""},"question":{"marital_status":"1","kid_cnt":"1","income":"1","own_house":"1","own_car":"1","credit_card":"2","work_time":"2","work_type":"2","live_time":"2","province_travel":"0","oversea_travel":"0","couple_phone_num":""}}}'>
     </iframe> 
     

     
</body>
</html>
<%@ include file="/IncludeEnd.jsp"%>