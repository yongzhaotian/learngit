package com.amarsoft.hhcf.app;

import java.io.IOException;
import java.net.URLDecoder;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONObject;

import com.amarsoft.app.billions.GenerateSerialNo;
import com.amarsoft.are.ARE;
import com.amarsoft.are.sql.Connection;
import com.amarsoft.awe.util.DBKeyHelp;
import com.amarsoft.awe.util.Transaction;

/**
 * Servlet implementation class SelCustomer
 */
public class SelCustomer extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private static String OUT_PUT_LOG="[APP INTERFACE==========][=======METHOD:SelCustomer=========]:";
	  
	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		this.doPost(request, response);
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		request.setCharacterEncoding("GBK");
		response.setCharacterEncoding("GBK");
		
		
		String sCustmerName = new String(request.getParameter("CustmerName").getBytes("ISO-8859-1"));    
		ARE.getLog().debug(OUT_PUT_LOG+"SelCustomer dopost begin ");
		System.out.println("----------------取得客户姓名--------------------");
		System.out.println("客户姓名:"+sCustmerName);
		System.out.println("--------------------------------------------");
		ARE.getLog().debug(OUT_PUT_LOG+"input parameter 1: "+sCustmerName);
		String sCertID =  request.getParameter("CertID");
		
		System.out.println("----------------取得客户证件号码--------------------");
		System.out.println("证件号码:"+sCertID);
		ARE.getLog().debug(OUT_PUT_LOG+"input parameter 2: "+sCertID);
		System.out.println("--------------------------------------------");
		
		
		
		JSONObject jsonObject=new JSONObject();
		
		String sCustmerID="";
		String appCustmerID=null;
		String newCustmer="";
		boolean flag= toCustomerID(sCertID,sCustmerName);
		System.out.println("是否老客户-"+flag);
	
		Connection conn=null;
		String sql="";
		try {
			//如有app客户信息，插入客户信息
			if(flag){
				
				System.out.println("----------------老客户--------------------");
				System.out.println("-------------开始插入数据---------------------");
				
				conn=ARE.getDBConnection(FinalNum.DATASOUTCE);
				Statement st=conn.createStatement();
				sql="select customerid from Customer_Info  where customername='"+sCustmerName+"' and certid='"+sCertID+"'";
				ARE.getLog().debug(OUT_PUT_LOG+"sql 1: "+sql);
				ResultSet rs=st.executeQuery(sql);
				while(rs.next()){
					sCustmerID=rs.getString("customerid");
				}
				rs.close();
				
				System.out.println("----------------APP 是否有该用户--------------------");
				
				sql="select customerID from IND_INFO@APPLINK where customerID='"+sCustmerID+"'";
				ARE.getLog().debug(OUT_PUT_LOG+"sql 2: "+sql);
				rs=st.executeQuery(sql);
				while(rs.next()){
					appCustmerID=rs.getString("customerid");
				}
				rs.close();
				if(appCustmerID==null){
				//向开发CUSTOMER_INFO插入数据
					conn=ARE.getDBConnection(FinalNum.DATASOUTCE);
					Statement st1=conn.createStatement();
					
					sql="insert into IND_INFO@APPLINK (select * from IND_INFO where customerID='"+sCustmerID+"')";
					ARE.getLog().debug(OUT_PUT_LOG+"sql 3: "+sql);
					st1.executeQuery(sql);
					st.close();
					st1.close();
				}else {
					//向开发CUSTOMER_INFO更新数据
					conn=ARE.getDBConnection(FinalNum.DATASOUTCE);
					Statement st1=conn.createStatement();
					 sql="UPDATE ind_info@APPLINK set( "+
								"sex,birthday,certtype,certid,sino,country,nationality,nativeplace,politicalface,marriage,relativetype,familyadd,  "+     
								" familyzip,emailadd,familytel,mobiletelephone,unitkind,workcorp,workadd,worktel,occupation,position,employrecord,   "+ 
								" edurecord,eduexperience,edudegree,graduateyear,financebelong,creditlevel,evaluatedate,balancesheet,intro,          "+   
								" selfmonthincome,familymonthincome,incomesource,population,loancardno,loancardinsyear,farmersort,regionalism,staff,   "+          
								" creditfarmer,riskinclination,character,dataquality,inputorgid,inputuserid,inputdate,updatedate,remark,updateorgid,   "+    
								" updateuserid,commadd,commzip,nativeadd,workzip,headship,workbegindate,yearincome,payaccount,payaccountbank,familystatus,  "+    
								" tempsaveflag,certid18,customername,issueinstitution,maturitydate,street,community,cellno,flag2,newadd,villagetown,countryside,  "+     
								" villagecenter,plot,room,cellproperty,flag3,unitcountryside,unitstreet,unitroom,unitno,phoneman,cellphoneverify,qqno,wechat,   "+         
								" childrentotal,spousename,spousetel,house,houserent,alimony,kinshipname,kinshiptel,kinshipadd,jobtime,jobtotal,otherrevenue,   "+   
								" severaltimes,falg4,othercontact,contactrelation,contacttel,emailcountryside,emailstreet,emailplot,emailroom,englishname,awarddate, "+        
								" age,livedate,applytype,companyname,employeetype,jobbegindate,faxnumber,flag5,housedate,startroomdate,liveduration,liveroom,livetype, "+         
								" spouseincome,ageincome,monthexpend,rentexpend,creditmonth,monthtotal,netmargin,quarterearning,flag6,oneselfincome,legalperson, "+      
								" organizationcode,businesslicense,creditcard,creditpassword,employeenumber,registeredassets,shareratio,lastyearincome,lastcost,  "+        
								" lastprofit,totalassets,lasttotalassets,companyenglishname,licensedate,organizationnature,registertype,registeradd,nationaltaxno,landtaxno,  "+       
								" setupdate,continuemonth,flag7,degression,profit,lastdegression,ownerequity,lastownerequity,flag8,relevanceid,customertype,socialno, "+
								" mobileoldphone,customerstatus,flag10 "+  
								" )=(select sex,birthday,certtype,certid,sino,country,nationality,nativeplace,politicalface,marriage,relativetype,familyadd, "+      
								" familyzip,emailadd,familytel,mobiletelephone,unitkind,workcorp,workadd,worktel,occupation,position,employrecord, "+   
								" edurecord,eduexperience,edudegree,graduateyear,financebelong,creditlevel,evaluatedate,balancesheet,intro,      "+       
								" selfmonthincome,familymonthincome,incomesource,population,loancardno,loancardinsyear,farmersort,regionalism,staff,   "+          
								" creditfarmer,riskinclination,character,dataquality,inputorgid,inputuserid,inputdate,updatedate,remark,updateorgid,   "+    
								" updateuserid,commadd,commzip,nativeadd,workzip,headship,workbegindate,yearincome,payaccount,payaccountbank,familystatus,  "+    
								" tempsaveflag,certid18,customername,issueinstitution,maturitydate,street,community,cellno,flag2,newadd,villagetown,countryside,  "+     
								" villagecenter,plot,room,cellproperty,flag3,unitcountryside,unitstreet,unitroom,unitno,phoneman,cellphoneverify,qqno,wechat,  "+          
								" childrentotal,spousename,spousetel,house,houserent,alimony,kinshipname,kinshiptel,kinshipadd,jobtime,jobtotal,otherrevenue,     "+ 
								" severaltimes,falg4,othercontact,contactrelation,contacttel,emailcountryside,emailstreet,emailplot,emailroom,englishname,awarddate,   "+      
								" age,livedate,applytype,companyname,employeetype,jobbegindate,faxnumber,flag5,housedate,startroomdate,liveduration,liveroom,livetype, "+         
								" spouseincome,ageincome,monthexpend,rentexpend,creditmonth,monthtotal,netmargin,quarterearning,flag6,oneselfincome,legalperson,       "+
								" organizationcode,businesslicense,creditcard,creditpassword,employeenumber,registeredassets,shareratio,lastyearincome,lastcost,  "+        
								" lastprofit,totalassets,lasttotalassets,companyenglishname,licensedate,organizationnature,registertype,registeradd,nationaltaxno,landtaxno,  "+       
								" setupdate,continuemonth,flag7,degression,profit,lastdegression,ownerequity,lastownerequity,flag8,relevanceid,customertype,socialno, "+
								" mobileoldphone,customerstatus,flag10 from  ind_info where customerID='"+sCustmerID+"')  where customerID='"+sCustmerID+"'";
					 ARE.getLog().debug(OUT_PUT_LOG+"sql 4: "+sql);
						st1.executeQuery(sql);
						st.close();
						st1.close();
				}
				newCustmer="false";
				System.out.println("-------------插入数据完成---------------------");
				
			}else{//如没有，则生成新的客户号
				newCustmer="true";
				System.out.println("----------------新客户--------------------");
				//sCustmerID=gs.getCustomerId(Sqlca);  //得到新的客户号
			}
			
			jsonObject.put("IsNewCustomer", newCustmer);
			jsonObject.put("CustomerId", sCustmerID);
			ARE.getLog().debug(OUT_PUT_LOG+"output parameter : "+jsonObject.toString());
			response.getWriter().write(jsonObject.toString());
			response.getWriter().flush();
			response.getWriter().close();
			ARE.getLog().debug(OUT_PUT_LOG+"dopost end ");
		} catch (Exception e) {
			e.printStackTrace();
			
		}finally{
			if(conn!=null){
				try {
					conn.close();
				} catch (SQLException e) {
					e.printStackTrace();
				}
			}
			
	    }
	}
	
	
	//判断开发库是否有合同信息或客户
	public  boolean  toCustomerID(String CertID,String sCustmerName){
		boolean flag=false;
		Connection conn=null;
		String sql="";
		String temp="";
		try {
			conn = ARE.getDBConnection(FinalNum.DATASOUTCE);
			Statement st=conn.createStatement();
			sql="select count(1) as count from customer_info where customerName='"+sCustmerName+"' and certID='"+CertID+"'";
			ResultSet rs=st.executeQuery(sql);
			if(rs.next()){
			    temp=rs.getString("count");
			    if(temp.equals("1")){
			    	flag=true;
			    }
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}finally{
			if(conn!=null)
				try {
					conn.close();
				} catch (SQLException e) {
					e.printStackTrace();
				}
	    }
		return flag;
	}

}
