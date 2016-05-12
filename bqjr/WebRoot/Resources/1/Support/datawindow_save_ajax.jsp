<%@page contentType="text/html; charset=GBK"%><%@
include file="/Resources/Include/IncludeBeginDWAJAX.jspf"%><%@
page import="com.amarsoft.web.koal.VerifySignature,com.amarsoft.awe.dw.ui.validator.server.ServerValidator" %><%@
page import="com.amarsoft.awe.util.ObjectConverts" %><%
	int curSuccess=0; //如果保存失败，则返回0
	String sMessage="",myIndex="";

	iPostChange = 5;

	String sAfterAction = "";
	sAfterAction = DataConvert.toRealString(iPostChange,(String)request.getParameter("afteraction"));  
	if(sAfterAction==null) 	sAfterAction="";
	ARE.getLog().info("sAfterAction====："+sAfterAction);
	
	String bNeedCA = request.getParameter("bNeedCA");  //no need convert
	ARE.getLog().info("bNeedCA====："+bNeedCA);
	
	boolean bresult = false;
	if( bNeedCA!=null && bNeedCA.equals("Yes") ){
		String szSignature = DataConvert.toRealString(iPostChange,(String)request.getParameter("Signature"));	
		String szModulus = DataConvert.toRealString(iPostChange,(String)request.getParameter("Modulus"));  		
		bresult = VerifySignature.Verify("123",szModulus,szSignature);	
	}
	if(bNeedCA!=null && bNeedCA.equals("Yes") && !bresult){ //签名未通过
		curSuccess = 0;
		sMessage = "签名未通过";
	}else{
		ASDataWindow dwTemp = Component.getDW(sSessionID);
		ARE.getLog().info("sSessionID======"+sSessionID);
		/*校验暂时不做，取值太复杂了,有部分值也不会传到服务器端
		Vector rules = dwTemp.DataObject.getValidations();
		ServerValidator sv = new ServerValidator(rules, request);
		boolean validResult = (rules==null || sv.validateAll());
		validResult=true;
		if(validResult==false){
			out.print("{error:\"1\",message:\""+SpecialTools.amarsoft2Real(sv.getErrorStrings())+"\"}");
			return;
		}
		*/
		try{
			ARE.getLog().info("request======"+request.toString());
			dwTemp.update(request,Sqlca);
		}catch(Exception ex){
			curSuccess = 0;
			ARE.getLog().info("curSuccess======"+curSuccess);
			sMessage = ex.getMessage();
		}
	
		myIndex=DataConvert.toRealString(iPostChange,(String)request.getParameter("myIndex"));
	
		if (sMessage.equals(""))
			curSuccess=1;
		else{
			curSuccess=0;
			sMessage = sMessage.replace('"','^');
			sMessage = sMessage.replace('(','（');
			sMessage = sMessage.replace(')','）');
			sMessage = sMessage.replace('\n',' ');
			sMessage = sMessage.replace('\r',' ');
			sMessage = StringFunction.replace(sMessage,"<br>","\\\\n");
		}
	}	
	out.print("{success:\""+curSuccess+"\",index:\""+myIndex+"\",message:\""+SpecialTools.amarsoft2Real(sMessage)+"\"}");
%><%@ include file="/Resources/Include/IncludeTail.jspf"%>
