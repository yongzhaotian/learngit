<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_list.jspf"%>
<!-- 
本页面通过parentno方式实现树层次
1 dataobject_catalog[可以在页面中设置sql]中需要设置order by 
2 dataobject_library中必须设置TREE_DEPTH的属性：作为深度
3 ASObjectModel需要设置为不可分页:doTemp.setPageSize(-1);//设置为不可分页
4 ASObjectWindow需要设置为TreeTable:dwTemp.TreeTable = true;
 -->
<%	
	ASObjectModel doTemp = new ASObjectModel("TestCustomerInfoForTree");
	//doTemp.setJboOrder("coalesce(PARENTNO,'')||SerialNO");//设置排序方式
	doTemp.setJboOrder("PARENTNO");//设置排序方式
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.setPageSize(-1);//设置为不可分页
	dwTemp.Style="1";      //设置为Grid风格
	dwTemp.TreeTable = true;//设置为树形结构
	dwTemp.ReadOnly = "1";
	dwTemp.genHTMLObjectWindow("");
	

	String sButtons[][] = {
		
	};
%> 
<%@include file="/Frame/resources/include/ui/include_list.jspf"%><%@
 include file="/Frame/resources/include/include_end.jspf"%>
