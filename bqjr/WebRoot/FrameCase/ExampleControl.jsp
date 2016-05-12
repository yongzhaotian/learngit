<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	//获得页面参数	
	String showText =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ShowText"));
	String flag =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("Flag"));
	if(showText==null) showText="";
	if(flag==null) flag="";
    if(flag.equals("1")){
    	out.write("<table id=\"table0\" border=\"1\" align=\"center\" ><tr><td id=\"text1\" >value1</td><td id=\"text2\" >value2</td></tr>");
    	out.write("<tr><input type=\"button\" value=\"点击调用 PopPageAjax 打开ajax页面获取数据\" onclick=\"run()\" /></tr></table>");
    }
%>
<div>
   	<pre>
   	
   		<%=showText %>
   	</pre>
</div>
<script type="text/javascript">
    	function run(){
    	    var sReturn = PopPageAjax("/FrameCase/ExampleAjax.jsp");
    	    var msg = sReturn.split("@");
    	    document.getElementById("text1").innerHTML = msg[0];
    	    document.getElementById("text2").innerHTML = msg[1];
       	}
</script>
<%@ include file="/IncludeEnd.jsp"%>