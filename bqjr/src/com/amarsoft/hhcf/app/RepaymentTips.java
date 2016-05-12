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

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import com.amarsoft.are.ARE;
import com.amarsoft.are.sql.Connection;
import com.amarsoft.are.util.DataConvert;

/**
 * Servlet implementation class SelContractStatus
 */
public class RepaymentTips extends HttpServlet {
       
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
			ssCustomerName=URLDecoder.decode(request.getParameter("CustomerName"), "UTF-8");
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
			sSql = "SELECT bc.CreditCycle as CreditCycle,(bc.businesssum*bc.insurancesum*0.01) as CreditFeeRate,bc.FIRSTDRAWINGDATE,bc.customerid,bc.customername,bc.businesssum,bt.Monthlyinterestrate as creditrate,bc.repaymentno,"+
	                 "getItemName('BankCode',bc.repaymentbank) as repaymentbank,bc.repaymentname,bc.monthrepayment,bc.periods,"+
	                 "bt.monthlyInterestRate,(bc.businesssum*bt.CUSTOMERSERVICERATES * 0.01) as serviceFee,bc.PutOutDate,"+
	                 "(bc.businesssum*bt.MANAGEMENTFEESRATE * 0.01) as manageFee from business_type bt,business_contract bc where bc.BusinessType=bt.TypeNo " +
	                 " and bc.CUSTOMERID in(select CUSTOMERID from IND_INFO where CUSTOMERNAME='"+ssCustomerName+"' and CERTID='"+ssCertID+"' and MOBILETELEPHONE='"+ssMobilePhone+"')  order by bc.inputdate asc";
			String sCustomerID="";
		    String sServiceFee="";
			String sManageFee = "";
			String sCustomerName = "";
			String sBusinessSum="";
			String sPaymentSum = "";
			String sCreditRate = "";
			String sRepaymentNo="";
			String sRepaymentBank="";
			String sRepaymentName="";
			String sMonthRepayment="";
			String sPeriods="";
			String sContractNum="";
			String sPutOutDate = "";
			String sFirstPayAmt = "";
			String sCreditFeeRate = "";
			String CreditCycle = "";
			
			ResultSet rs=st.executeQuery(sSql);
			while(rs.next()){
				
				sCreditFeeRate = DataConvert.toMoney(rs.getDouble("CreditFeeRate"));
				//if (sCreditFeeRate == null) sCreditFeeRate  = "&nbsp;";	
				sFirstPayAmt = DataConvert.toMoney(rs.getDouble("FIRSTDRAWINGDATE"));
				//if (sFirstPayAmt == null) sFirstPayAmt  = "&nbsp;";	
				sCustomerID = rs.getString("CustomerID");
				//if (sCustomerID == null) sCustomerID  = "&nbsp;";
				sCustomerName = rs.getString("CustomerName");
				//if (sCustomerName == null) sCustomerName  = "&nbsp;";	
				sBusinessSum = DataConvert.toMoney(rs.getDouble("BusinessSum"));
				//if (sBusinessSum == null) sBusinessSum  = "&nbsp;";	
				// sPaymentSum = DataConvert.toMoney(rs.getDouble("PaymentSum"));
				//if (sPaymentSum == null) sPaymentSum  = "&nbsp;";		
				sCreditRate = rs.getString("CreditRate");
				//if (sCreditRate == null) sCreditRate  = "&nbsp;";
				sRepaymentNo=rs.getString("RepaymentNo");
				//if (sRepaymentNo == null) sRepaymentNo  = "&nbsp;";
				sRepaymentBank = rs.getString("RepaymentBank");
				//if (sRepaymentBank == null) sRepaymentBank  = "&nbsp;";
				sRepaymentName=rs.getString("RepaymentName");
				//if(sRepaymentName == null) sRepaymentName="&nbsp;";
				sMonthRepayment = rs.getString("MonthRepayment");
				//if(sMonthRepayment == null) sMonthRepayment="&nbsp;";
				sPeriods = rs.getString("Periods");
				//if(sPeriods == null) sPeriods="&nbsp;";
				sServiceFee = DataConvert.toMoney(rs.getDouble("ServiceFee"));
				//if(sServiceFee == null) sServiceFee="&nbsp;";
				sManageFee = DataConvert.toMoney(rs.getDouble("ManageFee"));
				//if(sManageFee == null) sManageFee="&nbsp;";
				sPutOutDate = rs.getString("PutOutDate");
				//if(sPutOutDate == null) sPutOutDate = "&nbsp;";
				CreditCycle = rs.getString("CreditCycle");
				//if(CreditCycle == null) CreditCycle = "&nbsp;";
				if(!"1".equals(CreditCycle)) sCreditFeeRate = "0.0";
				
				JSONObject jsonObject2 = new JSONObject();
				jsonObject2.put("CreditFeeRate", sCreditFeeRate);
				jsonObject2.put("FirstPayAmt", sFirstPayAmt);
				jsonObject2.put("CustomerID", sCustomerID);
				jsonObject2.put("CustomerName", sCustomerName);
				jsonObject2.put("BusinessSum", sBusinessSum);
				jsonObject2.put("PaymentSum", sPaymentSum);
				jsonObject2.put("CreditRate", sCreditRate);
				jsonObject2.put("RepaymentNo", sRepaymentNo);
				jsonObject2.put("RepaymentBank", sRepaymentBank);
				jsonObject2.put("RepaymentName", sRepaymentName);
				jsonObject2.put("MonthRepayment", sMonthRepayment);
				jsonObject2.put("Periods", sPeriods);
				jsonObject2.put("ServiceFee", sServiceFee);
				jsonObject2.put("ManageFee", sManageFee);
				jsonObject2.put("PutOutDate", sPutOutDate);
				jsonObject2.put("CreditCycle", CreditCycle);
				
				jsonArray.add(jsonObject2);
				flag=true;
			}
		
			if(!flag){
				response.getWriter().write("{[]}");
			}else{
				jsonObject1.element("TipsList", jsonArray);
				response.getWriter().write(jsonObject1.toString());
			}
			rs.close();
			
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
