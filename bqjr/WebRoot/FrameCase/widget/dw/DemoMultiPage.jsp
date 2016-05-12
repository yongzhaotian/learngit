<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_multi.jspf"%>
 <input type="button" name="submit" value="Ìá½»" onclick="as_save('frame_info,frame_list')">
<iframe name="frame_info" width="100%" height="270" frameborder="0"></iframe>
<hr class="list_hr">
<iframe name="frame_list" width="100%" height="350" frameborder="0"></iframe>
<%@include file="/Frame/resources/include/ui/include_multi.jspf"%>
<script>
var sUrl = "/FrameCase/widget/dw/DemoInfoSimple.jsp";
OpenPage(sUrl+'?SerialNo=2012011000000009','frame_info','');
sUrl = "/FrameCase/widget/dw/DemoListEdit.jsp";
OpenPage(sUrl,'frame_list','');
</script>
<%@include file="/Frame/resources/include/include_end.jspf"%>