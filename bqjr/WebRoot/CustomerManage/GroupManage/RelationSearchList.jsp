<%@ page contentType="text/html; charset=GBK"%>
<%@ page import="com.amarsoft.app.lending.bizlets.*,java.util.*"%>
<%@ include file="/IncludeBeginMD.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main01;Describe=注释区;]~*/%>
<%
/* 
  author:  pwang 2009/10/15 
  Tester:
  Content:  集团客户搜索
  Input Param:
			CustomerID：客户编号
  Output param:
 			
  History Log:
               
 */
 %>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=View01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "集团关联搜索"; // 浏览器窗口标题 <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;详细信息&nbsp;&nbsp;"; //默认的内容区标题
	String PG_CONTNET_TEXT = "请点击左侧列表";//默认的内容区文字
	String PG_LEFT_WIDTH = "2000";//默认的treeview宽度
	%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info02;Describe=定义变量，获取参数;]~*/%>
<%
	//获得组件参数	：客户编号
	String sCustomerID  = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerID"));
	
	//将空值转化成空字符串
	if(sCustomerID == null ) sCustomerID="";
	
	//定义变量：SQL语句
	String sSql = "";
	ASResultSet rs = null;//-- 存放结果集
	
	String sCustomerName ="";
	String sCustomerType ="";
	String sCertType ="";
	String sCertID ="";
	String sSerialNo ="";
	
	Hashtable sGroupRelaCustomerHt = new Hashtable();
	String sGroupRelaCustStr1 = "";//存关联客户。
	String sGroupRelaCustStr2 = "";//存关联关系。
	Vector sGroupRelaCustomerVr = new Vector();//存储从关联搜索后得到的Vector,其中存有关联客户名及其他信息.
	String keys ="";//存储从关联搜索后得到的Vector中取的关联客户ID
	String value ="";//存储从搜索得到的HashTable中取的值.
	String sCustomerStr ="";//存储从搜索得到的CustoemrResult中取的值.

%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info04;Describe=定义按钮;]~*/%>
	<%
	    //依次为：
		//0.是否显示
		//1.注册目标组件号(为空则自动取当前组件)
		//2.类型(Button/ButtonWithNoAction/HyperLinkText/TreeviewItem/PlainText/Blank)
		//3.按钮文字
		//4.说明文字
		//5.事件
		//6.资源图片路径
	String sButtons[][] = {	
		{"true","","Button","确认","保存集团关联搜索","save()",sResourcesPath},
		{"true","","Button","生成申请认定书","生成申请认定书","nextStep()",sResourcesPath},		
	};
	%> 
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info03;Describe=定义数据对象;]~*/%>
<%
	//获取关联搜索源客户的客户信息.
	sSql = "select CustomerName,CustomerType,getItemName('CertType',CertType) as CertType1,CertID from CUSTOMER_INFO where CustomerID = :CustomerID ";
	rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("CustomerID",sCustomerID));
	while(rs.next()){
		sCustomerName = rs.getString("CustomerName");
		sCustomerType = rs.getString("CustomerType");
		sCertType = rs.getString("CertType1");
		sCertID = rs.getString("CertID");
	}
	rs.getStatement().close();
	
	//定义Treeview
	HTMLTreeView tviTemp = new HTMLTreeView("※关联关系图※","_top");
	tviTemp.ImageDirectory = sResourcesPath; //设置资源文件目录（图片、CSS）
	tviTemp.toRegister = false; //设置是否需要将所有的节点注册为功能点及权限点 
	tviTemp.TriggerClickEvent=true; //是否自动触发选中事件

	//实例化关联搜索类
	GroupRelaSearch	groupSearch = new GroupRelaSearch(sCustomerID);
	try{
		groupSearch.SearchAction(Sqlca);//进行关联客户关联关系搜索.
		sGroupRelaCustomerVr =groupSearch.getVSearchCustomer();//获取搜索完成后保存关联客户CustomerID值.
		sGroupRelaCustomerHt =groupSearch.getMyHashtable();//获取搜索完成后保存关联客户的客户名及其他信息.
		sCustomerStr =groupSearch.getCustomerResult();//获取搜索完成后用$符号分割分类五类保存的关联客户的CustomerID的用@分割的长串结果字符串sCustomerStr.
	}
	catch(Exception e){
		ARE.getLog().error(e.getMessage());	
	}

	String[] terms = sCustomerStr.split("$");//由于split方法本身设计,sCustomerStr分割后的长度未知.
	String termResult ="";//只做搜索结果保存于数据库前的参数字符串的预拼接.	
	for(int ii=0;ii<terms.length;ii++){		
		termResult +=terms[ii];
		termResult +=",";
	}

	//生成树图
	//生成Root树根部.
	String sRoot=tviTemp.insertFolder("root",sCustomerName+"    "+sCertType+":"+sCertID,"",1);
	
	String[] values = new String[3];
	Enumeration enumer= sGroupRelaCustomerVr.elements() ;
	
	int num = 2,num0 =0;
	String temp ="00";
	String[] tmp= new String[5];

	while(enumer.hasMoreElements())
	{		
		keys=(String)enumer.nextElement();
		value=(String)sGroupRelaCustomerHt.get(keys);	
		values = value.split("@");//参数一:分类类型;参数二:客户名称;参数三:其他参数;可以扩展存更多信息.
		//生成五类结点.
		if(!temp.equals(values[0])){			
			temp= values[0];
			if(values[0].equals("0100")){
				tmp[0]= tviTemp.insertFolder(sRoot,"共同法人代表的关联客户","",num); 			
			}				
			if(values[0].equals("0200")){
				tmp[1]= tviTemp.insertFolder(sRoot,"控股其他关联公司客户","",num); num++;	
			}				
			if(values[0].equals("5200")){
				tmp[2]= tviTemp.insertFolder(sRoot,"被控股关联公司客户","",num); num++;
			}				
			if(values[0].equals("0250")){
				tmp[3]= tviTemp.insertFolder(sRoot,"同被一家股东公司控股的关联公司客户","",num); num++;
			}				
			if(values[0].equals("0300")){
				tmp[4]= tviTemp.insertFolder(sRoot,"亲属关联公司","",num); num++;
			}				
		}
		sGroupRelaCustStr1 +=keys;sGroupRelaCustStr1 +="@";//拼接字符串
		sGroupRelaCustStr2 +=values[0];sGroupRelaCustStr2 +="@";//拼接字符串
		
		if(values[0].equals("0100")){
			tviTemp.insertPage(sCustomerID+"@"+values[1]+"@"+values[2]+"@"+keys,tmp[0],values[1],"","",num);num++;
		}
		if(values[0].equals("0200")){
			tviTemp.insertPage(sCustomerID+"@"+values[1]+"@"+values[2]+"@"+keys,tmp[1],values[1],"","",num);num++;
		}
		if(values[0].equals("5200")){
			tviTemp.insertPage(sCustomerID+"@"+values[1]+"@"+values[2]+"@"+keys,tmp[2],values[1],"","",num);num++;
		}
		if(values[0].equals("0250")){
			tviTemp.insertPage(sCustomerID+"@"+values[1]+"@"+values[2]+"@"+keys,tmp[3],values[1],"","",num);num++;
		}
		if(values[0].equals("0300")){
			tviTemp.insertPage(sCustomerID+"@"+values[1]+"@"+values[2]+"@"+keys,tmp[4],values[1],"","",num); num++;
		}					

	}
	
	
	%>
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区[Editable=false;CodeAreaID=View04;Describe=主体页面]~*/%>
	<%@include file="/Resources/CodeParts/View07.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info07;Describe=自定义函数;]~*/%>

	<script type="text/javascript">
	var boolvalue ="" ;
	var curUser ="";
	
	/*~[Describe=进入生成申请认定书管理页面;InputParam=无;OutPutParam=无;]~*/	
	function nextStep(){
		//弹出生成申请认定书管理页面.
		//传入GROUP_RESULT流水号
		var curUser2="<%=CurUser.getUserID()%>";
		var CurNum ="<%=sGroupRelaCustomerVr.size()%>";

		if(CurNum<=1)
			alert("无关联客户，无法生成“申请认定书”.");
		else{	
			if(boolvalue=="")
				alert("请您先确认搜索结果信息.");		
			else{
				if(curUser2 !=curUser){
					//确认点击“生成申请认定书”按钮前，已保存搜索信息。
					if(confirm("由于保存客户并不是当前客户.请您先确认保存搜索信息.")){
						popComp("GroupApplyManage","/CustomerManage/GroupManage/GroupApplyManage.jsp","SerialNo="+boolvalue,"");
					}
				}else{
					popComp("GroupApplyManage","/CustomerManage/GroupManage/GroupApplyManage.jsp","SerialNo="+boolvalue,"");
				}				
			}
		}																								
	}
	
	//treeview单击选中事件
	function TreeViewOnClick(){
		var sCurItemID = getCurTVItem().id;		
		if(sCurItemID == "root" ||sCurItemID.length <= 6)	//6,表示获取的结点ID值长度小于6,否则为CustomerID值长度,一般大于6,除了一些历史数据.	
			return;
		
		var sCurItemName = getCurTVItem().name;
		var sCurItemValue = getCurTVItem().value;
		if (sCurItemValue.length == 1) {
			alert("该客户无详细信息！");
			return;
		}
		var sss = sCurItemID.split("@");
		var sCustomerID=sss[3];		
		openObject("Customer",sCustomerID,"002");
	}		

	/*~[Describe=保存更新关联关系结果;InputParam=无;OutPutParam=无;]~*/
	function save(){
		var sCustomerID = "<%=sCustomerID%>";
		if(boolvalue!= "")
			alert("您已经重复确认!当前的搜索流水号为"+boolvalue);
		else{
			boolvalue = RunMethod("CustomerManage","SaveRelaResult",sCustomerID+","+"<%=sGroupRelaCustStr1%>"+","+"<%=sGroupRelaCustStr2%>"+","+"<%=sCustomerStr%>"+","+"<%=CurUser.getUserID()%>");
			if(boolvalue != null && boolvalue!= "" ){
				alert("保存成功");
				curUser="<%=CurUser.getUserID()%>";	
			}		
			else{
				alert("保存不成功");boolvalue="";		
			}
		}					
	}
	
	function startMenu(){
		<%=tviTemp.generateHTMLTreeView()%>
	}
	</script>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info08;Describe=页面装载时，进行初始化;]~*/%>
<script type="text/javascript">	
	startMenu();
	expandNode('root');
</script>	
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>