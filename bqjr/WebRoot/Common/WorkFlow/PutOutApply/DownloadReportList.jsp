<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
		/*
		Author:   --fbkang 
		Tester:
		Content:    -- �����ͬ��ϸ��
			δ�õ��������ֶ���ʱ���أ������Ҫ��չʾ������
		Input Param:
        	TypeNo��    --���ͱ��
 		Output param:
		                
		History Log: 
            
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = " �����ͬ��ϸ��"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info02;Describe=�����������ȡ����;]~*/%>
<%
	
	//���ҳ�����
		// ���ҳ�����
	String sCurItemID =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("curItemID"));
	if(sCurItemID==null) sCurItemID = "";
	
	//�����������ѯ�����
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


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%	
	String sSNo= CurUser.getAttribute8();
	System.out.println(sSNo+"------------------------");
    StringBuffer sb=new StringBuffer();//��¼��ƴ��
    StringBuffer snos=new StringBuffer();//�ŵ� ƴ�� 
    String userID=CurUser.getUserID();
    rs4=Sqlca.getASResultSet(new SqlObject("select roleID from role_info ri where ri.ROLEID in (select ROLEID from user_role ur where ur.userid=:userid) order by roleID").setParameter("userid", userID));
    while(rs4.next()){
    	roleID=rs4.getString("roleID");
  	    System.out.println(roleID+"============");
  	   //�����½��Ա�������ܾ���
  	    if("1002".equals(roleID)){
  	    	sAreaID=Sqlca.getString(new SqlObject("select attr1 from BaseDataSet_Info where TypeCode='AreaCode' and attr3=:attr3").setParameter("attr3", userID));//�������
  	    	rs=Sqlca.getASResultSet(new SqlObject("select attr1,attr3 from BaseDataSet_Info where TypeCode='ProvinceCode' and AttrStr1=:AttrStr1").setParameter("AttrStr1", sAreaID));//ʡ�ݴ��룬ʡ�ݸ�����
  	    	while(rs.next()){
  	    		rs1=Sqlca.getASResultSet(new SqlObject("select Attr2,Attr3 from BaseDataSet_Info where TypeCode='CityCode' and  AttrStr1=:AttrStr1 and AttrStr2=:AttrStr2 and Attr1=:Attr1")
  	    		.setParameter("AttrStr1", rs.getString("attr1")).setParameter("AttrStr2", sAreaID).setParameter("Attr1", rs.getString("attr3")));//���д��룬���и�����
  	    		while(rs1.next()){
  	    			//�ŵ���г��о���ά���������۾�����ϼ�ȡ�� edit by Dahl 2015-3-20
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
  	
  	   
  	   
  	   //�����½��Ա��ʡ�ݸ�����
  	    if("1003".equals(roleID)){
  	    	sProvinceID=Sqlca.getString(new SqlObject("select attr1 from BaseDataSet_Info where TypeCode='ProvinceCode' and attr3=:attr3").setParameter("attr3", userID));//ʡ�ݴ���
  	    	rs1=Sqlca.getASResultSet(new SqlObject("select Attr2,Attr3 from BaseDataSet_Info where TypeCode='CityCode' and  AttrStr1=:AttrStr1")
  	    		.setParameter("AttrStr1", sProvinceID));//���д��룬���и�����
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
  	 
  	   
  	    //�����½��Ա�ǳ��и�����
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
  	
  	   
  	    //�����½��Ա�����۾���
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
  	    
  	    //�����½��Ա�����۴���
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
	//add by ybpan at 20150316 CCS-359  ֻ�в�ѯ����ʾ���ݣ����ϵͳ��Ӧ�ٶ�
	if(!doTemp.haveReceivedFilterCriteria()){
		doTemp.WhereClause =" where 1=2 ";
	}
	//add by ybpan at 20150316 CCS-359 
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));

	
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д

	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	
%>

<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List04;Describe=���尴ť;]~*/%>
	<%
	//����Ϊ��
		//0.�Ƿ���ʾ
		//1.ע��Ŀ�������(Ϊ�����Զ�ȡ��ǰ���)
		//2.����(Button/ButtonWithNoAction/HyperLinkText/TreeviewItem/PlainText/Blank)
		//3.��ť����
		//4.˵������
		//5.�¼�
		//6.��ԴͼƬ·��
	String sButtons[][] = {
			{CurUser.getRoleTable().contains("2001")?"true":"false","","Button","����EXCEL","����EXCEL","exportExcel()",sResourcesPath},
		    };
	%> 
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
	
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">
    var sCurTypeNo=""; //��¼��ǰ��ѡ���еĴ����
    var bIsInsert = false; //���DW�Ƿ��ڡ�����״̬��
    
  //Excel����������	
    function exportExcel(){
    	amarExport("myiframe0");
    }
    //end by pli2 20140417	

	</script>

<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List07;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script type="text/javascript">	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	initRow();
	
</script>	
<%/*~END~*/%>


<%@ include file="/IncludeEnd.jsp"%>
