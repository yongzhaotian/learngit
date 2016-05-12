<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
    <%
    /*
        Author: lwang 20140221
        Tester:
        Describe: 合同下的费率信息列表
        Input Param:
        Output Param:       
        HistoryLog:
     */
    %>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
    <%
    String PG_TITLE = "费率信息"; // 浏览器窗口标题 <title> PG_TITLE </title>
    %>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%

    //定义变量

    //获得页面参数SELECT defaultvalue FROM product_term_para where paraid='FeeRate' and objectno='';

    //获得组件参数
    String sObjectType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));
    String sContractSerialNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
    if(sContractSerialNo == null ) sContractSerialNo = "";
    if(sObjectType == null ) sObjectType = "";
    //是否投保
    String sCreditCycle = Sqlca.getString(new SqlObject("SELECT CreditCycle FROM BUSINESS_CONTRACT where serialno='"+sContractSerialNo+"' "));
    if(sCreditCycle == null)sCreditCycle="2";
    
    String bxFeeRate = "0.0";
	String bxFeeAmt = "";
	double bxFeeAmount = 0.0;
	
	String bxFeeAmounts = "0.0";
	double yearbxFeeRate = 0.0;
	String YearSecurety = "0.0";
	double yearbxFeeamt = 0.0;
	String YearSecure = "0.0";
    if(sCreditCycle.equals("1")){
   
	    String BusinessSum = Sqlca.getString(new SqlObject("SELECT BusinessSum FROM BUSINESS_CONTRACT where serialno='"+sContractSerialNo+"' "));
	    if(BusinessSum == null)BusinessSum="0.0";
	    
	    String Periods = Sqlca.getString(new SqlObject("SELECT PERIODS FROM BUSINESS_CONTRACT where serialno='"+sContractSerialNo+"' "));
	    String BusinessType = Sqlca.getString(new SqlObject("SELECT businesstype FROM BUSINESS_CONTRACT where serialno='"+sContractSerialNo+"' "));
		String ObjectNo = BusinessType+"-V1.0";
		String bxftermid = Sqlca.getString(new SqlObject("SELECT termid FROM product_term_library where subtermtype='A12' and objectno='"+ObjectNo+"' "));
		if(bxftermid == null ) bxftermid = "";
		
		String bxFeeCalType = Sqlca.getString(new SqlObject("SELECT defaultvalue FROM product_term_para where termid='"+bxftermid+"' and paraid='FeeCalType' and objectno='"+ObjectNo+"' "));
		if(bxFeeCalType == null ) bxFeeCalType = "";
		
		if(!bxFeeCalType.equals("")){
			if("01".equals(bxFeeCalType)){//固定金额
				bxFeeAmt = Sqlca.getString(new SqlObject("SELECT defaultvalue FROM product_term_para where termid='"+bxftermid+"' and paraid='FeeAmount' and objectno='"+ObjectNo+"' "));
				if(bxFeeAmt == null ) bxFeeAmt = "";
				bxFeeAmount = Double.parseDouble(bxFeeAmt);
			}else if("02".equals(bxFeeCalType)){//贷款金额*费率
				bxFeeRate = Sqlca.getString(new SqlObject("SELECT defaultvalue FROM product_term_para where termid='"+bxftermid+"' and paraid='FeeRate' and objectno='"+ObjectNo+"' "));
				if(bxFeeRate == null ) bxFeeRate = "";
				bxFeeAmount = Double.parseDouble(BusinessSum)*(Double.parseDouble(bxFeeRate)*0.01);//每月保险费
			}
			
			bxFeeAmounts = String.valueOf(bxFeeAmount);
			yearbxFeeRate = Double.parseDouble(bxFeeRate)*12;
			YearSecurety = String.valueOf(yearbxFeeRate);
			yearbxFeeamt = bxFeeAmount*12;
			YearSecure = String.valueOf(yearbxFeeamt);
		}
    }
	
%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%
    //通过DW模型产生ASDataObject对象doTemp
  	String sTempletNo = "BusinessRateList";//模型编号
  	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);

    //生成datawindow
    ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
    dwTemp.Style="1";      //设置为Grid风格
    dwTemp.ReadOnly = "1"; //设置为只读
    
    Vector vTemp = dwTemp.genHTMLDataWindow(sContractSerialNo);
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
        {"false","","Button","费率详情","查看费率详情","viewDetail()",sResourcesPath},
        };  
    %>
<%/*~END~*/%>

<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
    <%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
    <script type="text/javascript">
    /*~[Describe=查看及修改详情;InputParam=无;OutPutParam=无;]~*/
     function viewDetail()
    {
        sObejctType = "BusinessRate";
      // sObejctType = "BusinessContract";
        sSerialNo = getItemValue(0,getRow(),"SerialNo");
        if(typeof(sSerialNo)=="undefined" || sSerialNo.length==0) {
            alert(getHtmlMessage('1'));//请选择一条信息！
        }
        else
        {
        	//alert(sObejctType+"======="+sSerialNo);
            openObject(sObejctType,sSerialNo,"003");
        }
    } 

    function initRow()
    {
    	var MonthSecure = "<%=bxFeeAmounts%>";
    	var MonthSecurety = "<%=bxFeeRate%>";
    	var YearSecure = "<%=YearSecure%>";
    	var YearSecurety = "<%=YearSecurety%>";
		setItemValue(0,0,"MonthSecure",parseFloat(MonthSecure).toFixed(2)+"");	//合同贷款月保险费(元)
		setItemValue(0,0,"MonthSecurety",parseFloat(MonthSecurety).toFixed(2)+"");//合同贷款月保险费率(%)
		setItemValue(0,0,"YearSecure",parseFloat(YearSecure).toFixed(2)+"");	//合同贷款年保险费(元)
		setItemValue(0,0,"YearSecurety",parseFloat(YearSecurety).toFixed(2)+"");//合同贷款年保险费率(%)
    }
    </script>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
    <script type="text/javascript">
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