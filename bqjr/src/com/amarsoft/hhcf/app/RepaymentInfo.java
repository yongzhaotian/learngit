package com.amarsoft.hhcf.app;

import java.io.IOException;
import java.math.BigDecimal;
import java.net.URLDecoder;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import com.amarsoft.are.ARE;
import com.amarsoft.are.sql.Connection;
import com.amarsoft.are.util.DataConvert;

/**
 * Servlet implementation class SelContractStatus
 */
public class RepaymentInfo extends HttpServlet {
       
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

		String ssCertID =  request.getParameter("CertID");//身份证号码
		String ssMobilePhone =  request.getParameter("MobilePhone");//手机号
		String ssCustomerName =null;//客户姓名
		if(request.getParameter("CustomerName")!=null){
			
			ssCustomerName=new String(request.getParameter("CustomerName").getBytes("ISO-8859-1"), "UTF-8");
			ssCustomerName=URLDecoder.decode(ssCustomerName, "UTF-8");
		}
		
		if(ssCertID==null||ssMobilePhone==null||ssCustomerName==null){
			return ;
		}
		
		JSONObject jsonObject1 = new JSONObject();
		JSONArray jsonArray = new JSONArray();
		boolean flag=false;
		
		Connection conn=null;
		String sSql="";
		try {
			conn=ARE.getDBConnection(FinalNum.DATASOUTCE);
			Statement st=conn.createStatement();
			
			String billDate=null;//账单日期
			String lastBillDate=null;//到期还款日
			String periods=null;//期数
			String monthlyAmt=null;//每月还款额
			String bankInfo=null;
			String productName=null;
			int payTime=0;
			int remainPayTime=0;
			/*String monthlyAmt="";//代扣银行卡号（已还16 剩余8期）

			分期产品
			期数
			每月还款额
			代扣银行卡号（已还16 剩余8期）

			还款记录：
			日期  成功还款 499*/
	
			sSql = " select b.serialno,bc.REPLACEACCOUNT,bc.PERIODS,bc.ProductName,bc.Periods from business_contract bc,acct_loan b where rownum=1 and bc.serialno=b.putoutno and " +
	                 " bc.CUSTOMERID in(select CUSTOMERID from IND_INFO where CUSTOMERNAME='"+ssCustomerName+"' and "+
					"CERTID='"+ssCertID+"' and MOBILETELEPHONE='"+ssMobilePhone+"') order by inputdate desc";
			List<String> sSerialno=new ArrayList<String>();

			ResultSet rs=st.executeQuery(sSql);
			while(rs.next()){
				periods= rs.getString("Periods");
				bankInfo=rs.getString("REPLACEACCOUNT");
				productName=rs.getString("ProductName");
				
				if(bankInfo!=null&&bankInfo.length()>8){
					bankInfo=bankInfo.substring(0,4)+"********"+bankInfo.substring(bankInfo.length()-4,bankInfo.length());
				}
				
				sSerialno.add( rs.getString("serialno"));
			}

			if(sSerialno!=null&&sSerialno.size()>0){
				for(int i=0;i<sSerialno.size();i++){
					sSql ="SELECT aps.seqid as SeqID,aps.paydate as PayDate,sum(case when aps.settledate is null then 0 else 1 end ) as  settledate, "+
							   "sum(nvl(aps.payprincipalamt,0)+nvl(aps.payinteamt,0)) as TotalAmt, "+//--应还总金额
				               "sum(nvl(aps.actualpayprincipalamt,0)+nvl(aps.actualpayinteamt,0)) as ActualTotalAmt, "+//--实还总金额
						       "sum(case when aps.paytype='1' or aps.paytype='5' then nvl(aps.payprincipalamt,0) else 0 end) as PayprincipalAmt, "+//--应还本金
						       "sum(case when aps.paytype='1' or aps.paytype='5' then nvl(aps.actualpayprincipalamt,0) else 0 end) as ActualPayPrincipalAmt, "+//--实还本金
						       "sum(case when aps.paytype='1' or aps.paytype='5' then nvl(aps.payinteamt,0) else 0 end) as InteAmt, "+//--应还利息
						       "sum(case when aps.paytype='1' or aps.paytype='5' then nvl(aps.actualpayinteamt,0) else 0 end) as ActualPayInteAmt, "+//--实还利息
						       "sum(case when aps.paytype='A2' then nvl(aps.payprincipalamt,0) else 0 end) as CustomerServeFee, "+//--应还客户服务费
						       "sum(case when aps.paytype='A2' then nvl(aps.actualpayprincipalamt,0) else 0 end) as ActualCustomerServeFee, "+//--实还客户服务费
						       "sum(case when aps.paytype='A7' then nvl(aps.payprincipalamt,0) else 0 end) as AccountManageFee, "+//--应还财务管理费
						       "sum(case when aps.paytype='A7' then nvl(aps.actualpayprincipalamt,0) else 0 end) as ActualAccountManageFee, "+//--实还财务管理费
						       "sum(case when aps.paytype='A11' then nvl(aps.payprincipalamt,0) else 0 end) as StampTax, "+//--印花税
						       "sum(case when aps.paytype='A11' then nvl(aps.actualpayprincipalamt,0) else 0 end) as ActualStampTax, "+//--实还印花税
						       "sum(case when aps.paytype='A12' then nvl(aps.payprincipalamt,0) else 0 end) as PayInsuranceFee, "+//--保险费
						       "sum(case when aps.paytype='A12' then nvl(aps.actualpayprincipalamt,0) else 0 end) as ActualPayInsuranceFee, "+//--实还保险费
						       "sum(case when aps.paytype='A10' then nvl(aps.payprincipalamt,0) else 0 end) as OverDueAmt, "+//--滞纳金
						       "sum(case when aps.paytype='A10' then nvl(aps.actualpayprincipalamt,0) else 0 end) as ActualOverDueAmt, "+//--实还滞纳金
						       "sum(case when aps.paytype='A9' then nvl(aps.payprincipalamt,0) else 0 end) as AdvanceFee, "+//--应还提前还款手续费
						       "sum(case when aps.paytype='A9' then nvl(aps.actualpayprincipalamt,0) else 0 end) as ActualAdvanceFee "+//--实收提前还款手续费			     
							   "FROM acct_payment_schedule aps where (aps.objectno='"+sSerialno.get(i)+"' and aps.objecttype='jbo.app.ACCT_LOAN') or (aps.relativeobjectno='"+sSerialno.get(i)+"' and aps.relativeobjecttype='jbo.app.ACCT_LOAN') "+// 关联的借据
							   "group by SeqID,PayDate  order by SeqID,PayDate ";
					
						rs=st.executeQuery(sSql);
						while(rs.next()){
							
							JSONObject jsonObject2 = new JSONObject();
							jsonObject2.put("SeqID", rs.getString("SeqID"));
							jsonObject2.put("PayDate", rs.getString("PayDate"));
							jsonObject2.put("TotalAmt", rs.getString("TotalAmt"));
							jsonObject2.put("ActualTotalAmt", rs.getString("ActualTotalAmt"));
							jsonObject2.put("PayprincipalAmt", rs.getString("PayprincipalAmt"));
							jsonObject2.put("ActualPayPrincipalAmt", rs.getString("ActualPayPrincipalAmt"));
							jsonObject2.put("InteAmt", rs.getString("InteAmt"));
							jsonObject2.put("ActualPayInteAmt", rs.getString("ActualPayInteAmt"));
							jsonObject2.put("CustomerServeFee", rs.getString("CustomerServeFee"));
							jsonObject2.put("ActualCustomerServeFee", rs.getString("ActualCustomerServeFee"));
							jsonObject2.put("AccountManageFee", rs.getString("AccountManageFee"));
							jsonObject2.put("ActualAccountManageFee", rs.getString("ActualAccountManageFee"));
							jsonObject2.put("StampTax", rs.getString("StampTax"));
							jsonObject2.put("ActualStampTax", rs.getString("ActualStampTax"));
							jsonObject2.put("PayInsuranceFee", rs.getString("PayInsuranceFee"));
							jsonObject2.put("ActualPayInsuranceFee", rs.getString("ActualPayInsuranceFee"));
							jsonObject2.put("OverDueAmt", rs.getString("OverDueAmt"));
							jsonObject2.put("ActualOverDueAmt", rs.getString("ActualOverDueAmt"));
							jsonObject2.put("AdvanceFee", rs.getString("AdvanceFee"));
							jsonObject2.put("ActualAdvanceFee", rs.getString("ActualAdvanceFee"));
							jsonObject2.put("SettleDate", rs.getString("settledate"));
						
							double totalFee=
									Double.parseDouble(rs.getString("CustomerServeFee"))+
									Double.parseDouble(rs.getString("AccountManageFee"))+
									Double.parseDouble(rs.getString("StampTax"))+
									Double.parseDouble(rs.getString("PayInsuranceFee"))+
									Double.parseDouble(rs.getString("OverDueAmt"))+
									Double.parseDouble(rs.getString("AdvanceFee"));
								
							jsonObject2.put("TotalFee", String.valueOf(totalFee));
							
							if(rs.getString("settledate")!=null&&!"0".equals(rs.getString("settledate"))){
								payTime++;
							}else {
								
								if(billDate==null){
									billDate=rs.getString("PayDate");
									lastBillDate=rs.getString("PayDate");
									double   f   =   totalFee; 
									BigDecimal   b   =   new   BigDecimal(f); 
									double   f1   =   b.setScale(2,   BigDecimal.ROUND_UP).doubleValue();  
									monthlyAmt=rs.getString("TotalAmt")+"元 (含"+f1+"元服务费)";
								}
								 
							}
							
							
						
							
							
							jsonArray.add(jsonObject2);
							flag=true;

						}
				}
				
			}
			
			if(periods!=null){
				remainPayTime=Integer.parseInt(periods)-payTime;
			}
			
			
			if(!flag){
				response.getWriter().write("{[]}");
			}else{
				jsonObject1.element("RepaymentInfoList", jsonArray);
				jsonObject1.element("billDate", billDate);
				jsonObject1.element("lastBillDate", lastBillDate);
				jsonObject1.element("monthlyAmt", monthlyAmt);//每月还款额
				jsonObject1.element("periods", periods);//期数
				jsonObject1.element("bankInfo", bankInfo+"  (已还款"+payTime+"期,剩余"+remainPayTime+"期)");//银行信息
				jsonObject1.element("productName", productName);//期数
				response.getWriter().write(jsonObject1.toString());
			}
			rs.close();
			//System.out.println("------------------------------------------------->"+jsonObject1.toString());
			response.getWriter().flush();
			response.getWriter().close();
			st.close();
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
		
	}
}
