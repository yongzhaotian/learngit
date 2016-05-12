<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
		/*
		Author:   --fbkang 
		Tester:
		Content:    --新增箱子
			未用到的属性字段暂时隐藏，如果需要请展示出来。
		Input Param:
        	TypeNo：    --类型编号
 		Output param:
		                
		History Log: 
            
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "新增箱子"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%	
	String sCabinetID  = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("cabinetID"));
	String sTemp  = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("temp"));	
	if(sTemp==null) sTemp="";	
	if(sCabinetID==null) sCabinetID="";	
	    
	String count=Sqlca.getString(new SqlObject("select count(1) from business_contract where boxNo=:boxNo").setParameter("boxNo", sCabinetID));
	ASDataObject doTemp = new ASDataObject("BoxNumberInfo",Sqlca);
	if(sTemp.equals("modify") && !count.equals("0") ){
		doTemp.setReadOnly("CabinetName,RName", true);
	} 
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写

	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sCabinetID);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	
%>

<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List04;Describe=定义按钮;]~*/%>
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
			{"true","","Button","保存","保存","saveRecord()",sResourcesPath},
			{"true","","Button","返回","返回","saveRecordAndBack()",sResourcesPath}
		    };
	%> 
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
	
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script type="text/javascript">
    var sCurTypeNo=""; //记录当前所选择行的代码号
    var bIsInsert = false; //标记DW是否处于“新增状态”
    var sFlag=false;

	//---------------------定义按钮事件------------------------------------
	/*~[Describe=保存;InputParam=后续事件;OutPutParam=无;]~*/
	function saveRecord()
	{
		var sCabinetName=getItemValue(0,getRow(),"CabinetName");
		var sSNO=getItemValue(0,getRow(),"SNO");
    	var sSNumber=getItemValue(0,getRow(),"SNumber");
    	var sCabinetID=getItemValue(0,getRow(),"CabinetID");
    	xinCabinetName=RunMethod("GetElement","GetElementValue","CabinetName,archives_Warehouse,CabinetID='"+sCabinetID+"'");
    	if(sSNumber=="") {alert("请选择架子"); return;}
    	var type=checkNumber(sSNO,sSNumber);
    	if(type=="new") return;
    	var sCount= RunMethod("Unique","uniques","archives_Warehouse,count(1), CabinetName='"+sCabinetName+"' and CreditAttribute='0002' and CodeAttribute='BoxNumberCode'");
    	var editCount= RunMethod("Unique","uniques","archives_Warehouse,count(1), CabinetName='"+sCabinetName+"' and CreditAttribute='0002' and CodeAttribute='BoxNumberCode' and CabinetName<>'"+xinCabinetName+"'");
    	if("<%=sTemp%>"!="modify"){
    		if(sCount>0){
            	alert("该箱子名称已存在！");
            	return;
            }
    	}else{
    		if(editCount>0){
            	alert("该箱子名称已存在！");
            	return;
            }
    	}
    	
		bIsInsert = false;
		if(sFlag) return;
		as_save("myiframe0");
	}

    /*~[Describe=保存;InputParam=后续事件;OutPutParam=无;]~*/
	function saveRecordAndBack()
	{
		OpenPage("/AppConfig/Document/BoxNumberList.jsp","_self","");
	}
     
    
    function getRegionCode(){
    	if("<%=sTemp%>"=="modify" && "<%=count%>"!="0") return;
    	var sEntInfoValue=setObjectValue("SelectShelfNumberInfo","","@RName@1",0,0,"");
   		if (typeof(sEntInfoValue)=="undefined" || sEntInfoValue.length==0){
   			return;
   		}
   		sSNO=sEntInfoValue.split("@")[0];
   		sShelfNumber =sEntInfoValue.split("@")[2];
   		setItemValue(0,0,"SNO", sSNO);
   		setItemValue(0,0,"SNumber", sShelfNumber);
   		checkNumber(sSNO,sShelfNumber);
    }
    
	 //检查容量 
    function checkNumber(sSNO,sShelfNumber){
    	var SNO=getItemValue(0,getRow(),"SNO");
    	var sCabinetID=getItemValue(0,getRow(),"CabinetID");
    	sXinSNO=RunMethod("GetElement","GetElementValue","SNO,archives_Warehouse,CabinetID='"+sCabinetID+"'");
    	//查询该架子下箱子的数量 
    	var sCount= RunMethod("Unique","uniques","archives_Warehouse,count(1), SNO='"+sSNO+"' and CreditAttribute='0002' and CodeAttribute='BoxNumberCode'"); 
    	sCount=parseFloat(sCount);
    	if("<%=sTemp%>"=="modify" && sXinSNO == SNO){
    		sCount=parseFloat(sCount);
    	}else{
    		sCount=parseFloat(sCount)+1;
    	}
	    if(sShelfNumber<sCount){
	    	alert("超出该架子容量！");
	    	sFlag=true;
	    	return "new";
	    }
	    sFlag=false;
    }
  
	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script type="text/javascript">
	
	function initRow(){
		if (getRowCount(0)==0) //如果没有找到对应记录，则新增一条，并设置字段默认值
		{
			as_add("myiframe0");//新增记录
			setItemValue(0,0,"CabinetID",getSerialNo("archives_Warehouse", "CabinetID", ""));
			setItemValue(0,0,"CreditAttribute", "0002");
			setItemValue(0,0,"CodeAttribute", "BoxNumberCode");
			bIsInsert = true;
		}
	}
	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List07;Describe=页面装载时，进行初始化;]~*/%>
<script type="text/javascript">	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	initRow();
</script>	
<%/*~END~*/%>


<%@ include file="/IncludeEnd.jsp"%>
