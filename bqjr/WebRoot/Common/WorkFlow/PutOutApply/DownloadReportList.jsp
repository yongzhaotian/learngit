<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
		/*
		Author:   --fbkang 
		Tester:
		Content:    -- 错误合同明细表
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
	String PG_TITLE = " 错误合同明细表"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info02;Describe=定义变量，获取参数;]~*/%>
<%
	
	//获得页面参数
		// 获得页面参数
	String sCurItemID =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("curItemID"));
	if(sCurItemID==null) sCurItemID = "";
	
	//定义变量：查询结果集
	ASResultSet rs = null;
	ASResultSet rs1 = null;
	ASResultSet rs2 = null;
	ASResultSet rs3 = null;
	ASResultSet rs4 = null;
	String sAreaID="",sProvinceID="",sSaleID="";
    String sUserID="";
    String roleID="";
    String doWhere=" and 1=1";
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%	
	String sSNo= CurUser.getAttribute8();
	System.out.println(sSNo+"------------------------");
    StringBuffer sb=new StringBuffer();//登录人拼接
    StringBuffer snos=new StringBuffer();//门店 拼接 
    String userID=CurUser.getUserID();
    rs4=Sqlca.getASResultSet(new SqlObject("select roleID from role_info ri where ri.ROLEID in (select ROLEID from user_role ur where ur.userid=:userid) order by roleID").setParameter("userid", userID));
    while(rs4.next()){
    	roleID=rs4.getString("roleID");
  	    System.out.println(roleID+"============");
  	   //如果登陆人员是区域总经理
  	    if("1002".equals(roleID)){
  	    	sAreaID=Sqlca.getString(new SqlObject("select attr1 from BaseDataSet_Info where TypeCode='AreaCode' and attr3=:attr3").setParameter("attr3", userID));//区域代码
  	    	rs=Sqlca.getASResultSet(new SqlObject("select attr1,attr3 from BaseDataSet_Info where TypeCode='ProvinceCode' and AttrStr1=:AttrStr1").setParameter("AttrStr1", sAreaID));//省份代码，省份负责人
  	    	while(rs.next()){
  	    		rs1=Sqlca.getASResultSet(new SqlObject("select Attr2,Attr3 from BaseDataSet_Info where TypeCode='CityCode' and  AttrStr1=:AttrStr1 and AttrStr2=:AttrStr2 and Attr1=:Attr1")
  	    		.setParameter("AttrStr1", rs.getString("attr1")).setParameter("AttrStr2", sAreaID).setParameter("Attr1", rs.getString("attr3")));//城市代码，城市负责人
  	    		while(rs1.next()){
  	    			//门店表中城市经理不维护，从销售经理的上级取。 edit by Dahl 2015-3-20
  	    			rs2=Sqlca.getASResultSet(new SqlObject("select sno from store_info si ,user_info ui where si.salesmanager=ui.userId and ui.superid=:citymanager").setParameter("citymanager", rs1.getString("Attr3")));
  	    			while(rs2.next()){
  	    				snos.append("'"+rs2.getString("sno")+"',");
  	    			}
//  	    			rs2=Sqlca.getASResultSet(new SqlObject("select userid from user_info where superid=:superid").setParameter("superid", rs1.getString("Attr3")));
//  	    			while(rs2.next()){
//  	    				rs3=Sqlca.getASResultSet(new SqlObject("select userid from user_info where superid=:superid").setParameter("superid", rs2.getString("userid")));
//  	    				while(rs3.next()){
//  	    					sUserID=rs3.getString("userid");
//  	    					sb.append("'"+sUserID+"',");
//  	    				}
//  	    				sb.append("'"+rs2.getString("userid")+"',");
//  	    			}

//  	    			sb.append("'"+rs1.getString("Attr3")+"',");
  	    		}
//  	    		sb.append("'"+rs.getString("attr3")+"',");
  	    	}
  	       if(snos.toString().equals("")){
	    	   doWhere=" and 1=2 ";
  	       }else{
  	 	       doWhere=" and stores in("+snos.toString().substring(0,snos.toString().length()-1)+")";
  	       }
  	   	   rs.getStatement().close();
  	   	   rs1.getStatement().close();
  	   	   rs2.getStatement().close();
  	   	   break;
  	    }
  	
  	   
  	   
  	   //如果登陆人员是省份负责人
  	    if("1003".equals(roleID)){
  	    	sProvinceID=Sqlca.getString(new SqlObject("select attr1 from BaseDataSet_Info where TypeCode='ProvinceCode' and attr3=:attr3").setParameter("attr3", userID));//省份代码
  	    	rs1=Sqlca.getASResultSet(new SqlObject("select Attr2,Attr3 from BaseDataSet_Info where TypeCode='CityCode' and  AttrStr1=:AttrStr1")
  	    		.setParameter("AttrStr1", sProvinceID));//城市代码，城市负责人
  	    	while(rs1.next()){
      			rs2=Sqlca.getASResultSet(new SqlObject("select sno from store_info si ,user_info ui where si.salesmanager=ui.userId and ui.superid=:citymanager").setParameter("citymanager", rs1.getString("Attr3")));
      			while(rs2.next()){
      				snos.append("'"+rs2.getString("sno")+"',");
      			}
  	    		
//  	    	rs2=Sqlca.getASResultSet(new SqlObject("select userid from user_info where superid=:superid").setParameter("superid", rs1.getString("Attr3")));
//  	    	while(rs2.next()){
//  	    		rs3=Sqlca.getASResultSet(new SqlObject("select userid from user_info where superid=:superid").setParameter("superid", rs2.getString("userid")));
//  	    		while(rs3.next()){
//  	    			sUserID=rs3.getString("userid");
//  	    			sb.append("'"+sUserID+"',");
//  	    		}
//  	    		sb.append("'"+rs2.getString("userid")+"',");
// 	    		}


//  	    		sb.append("'"+rs1.getString("Attr3")+"',");
  	    	}
  	    	if(snos.toString().equals("")){
 	    	   doWhere=" and 1=2 ";
   	        }else{
   	 	       doWhere=" and stores in("+snos.toString().substring(0,snos.toString().length()-1)+")";
   	        }
  	    	rs1.getStatement().close();
  	    	rs2.getStatement().close();
  	    	break;
  	    }
  	 
  	   
  	    //如果登陆人员是城市负责人
  	    if("1004".equals(roleID)){
  			rs2=Sqlca.getASResultSet(new SqlObject("select sno from store_info si ,user_info ui where si.salesmanager=ui.userId and ui.superid=:citymanager").setParameter("citymanager", userID));
              while(rs2.next()){
              	snos.append("'"+rs2.getString("sno")+"',");
              }
  			
//  	    rs2=Sqlca.getASResultSet(new SqlObject("select userid from user_info where superid=:superid").setParameter("superid", userID));
//  	    while(rs2.next()){
//  	    	rs3=Sqlca.getASResultSet(new SqlObject("select userid from user_info where superid=:superid").setParameter("superid", rs2.getString("userid")));
//  	    	while(rs3.next()){
//  	    		sUserID=rs3.getString("userid");
//  	    		sb.append("'"+sUserID+"',");
//  	    	}
//  	    	sb.append("'"+rs2.getString("userid")+"',");
//  	    }
            if(snos.toString().equals("")){
 	    	   doWhere=" and 1=2 ";
   	        }else{
   	 	       doWhere=" and stores in("+snos.toString().substring(0,snos.toString().length()-1)+")";
   	        }
  	        rs2.getStatement().close();
  	        break;
  	    }
  	
  	   
  	    //如果登陆人员是销售经理
  	    if("1005".equals(roleID)){
 	    	rs3=Sqlca.getASResultSet(new SqlObject("select sno from store_info where salesmanager=:salesmanager ").setParameter("salesmanager", userID));
  	    	while(rs3.next()){
  	    		snos.append("'"+rs3.getString("sno")+"',");
 	    	}
  	  	    if(snos.toString().equals("")){
	    	   doWhere=" and 1=2 ";
	        }else{
	 	       doWhere=" and stores in("+snos.toString().substring(0,snos.toString().length()-1)+")";
	        }
 	    	rs3.getStatement().close();
 	    	break;
  	    }
  	    
  	    //如果登陆人员是销售代表
  	    if("1006".equals(roleID)||"1620".equals(roleID)||"1622".equals(roleID)||"1624".equals(roleID)||"1626".equals(roleID)||"1628".equals(roleID)||"1630".equals(roleID)||"3008".equals(roleID)){
  	    	doWhere=" and bc.InputUserID='"+userID+"' and stores='"+sSNo+"'";
  	    	break;
  	    }
    }
    rs4.getStatement().close();
    
    String sTempletNo="";
	sTempletNo="DownloadReportList";
    if(sCurItemID.equals("01")){
    	sTempletNo="DownloadReportList";
    }else if(sCurItemID.equals("02")){
    	sTempletNo="DownloadReportNoList";
    }else if(sCurItemID.equals("03")){
    	sTempletNo="DownloadReportYesList";
    }else if(sCurItemID.equals("04")){
    	
    	sTempletNo="DownloadReportList";
    	//add by ybpan at 20150316   CCS-359
    }else if(sCurItemID.equals("06")){
    	
    	sTempletNo="ContractQualityDetailList";
    	//end by ybpan at 20150316   CCS-359
    }else{
    	sTempletNo="DownloadHeGeList";
    }
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
	doTemp.WhereClause+=doWhere;
	
	doTemp.setColumnAttribute("ArtificialNo,customerName","IsFilter","1");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	//add by ybpan at 20150316 CCS-359  只有查询才显示数据，提高系统反应速度
	if(!doTemp.haveReceivedFilterCriteria()){
		doTemp.WhereClause =" where 1=2 ";
	}
	//add by ybpan at 20150316 CCS-359 
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));

	
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写

	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
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
			{CurUser.getRoleTable().contains("2001")?"true":"false","","Button","导出EXCEL","导出EXCEL","exportExcel()",sResourcesPath},
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
    
  //Excel导出功能呢	
    function exportExcel(){
    	amarExport("myiframe0");
    }
    //end by pli2 20140417	

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
