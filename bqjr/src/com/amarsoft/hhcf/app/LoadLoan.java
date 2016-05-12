package com.amarsoft.hhcf.app;

import java.io.IOException;
import java.security.NoSuchAlgorithmException;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import com.amarsoft.app.accounting.businessobject.BUSINESSOBJECT_CONSTATNTS;
import com.amarsoft.app.accounting.businessobject.BusinessObject;
import com.amarsoft.app.accounting.businessobject.DefaultBusinessObjectManager;
import com.amarsoft.app.accounting.config.SystemConfig;
import com.amarsoft.are.ARE;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.sql.Connection;
import com.amarsoft.are.util.ASValuePool;
import com.amarsoft.are.util.DataConvert;
import com.amarsoft.awe.Configure;
import com.amarsoft.awe.util.Transaction;

/**
 * Servlet implementation class UserSotreInfo
 */
public class LoadLoan extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private static String OUT_PUT_LOG="[APP INTERFACE==========][=======METHOD:LoadLoan=========]:";
	 
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
		ARE.getLog().debug(OUT_PUT_LOG+"loadLoan dopost begin ");
		
		String SerialNo =  request.getParameter("SerialNo");
		String Type =  request.getParameter("Type");
		ARE.getLog().debug(OUT_PUT_LOG+"input parameter 1:"+SerialNo);
		ARE.getLog().debug(OUT_PUT_LOG+"input parameter 2:"+Type);
		JSONArray jsonArray = new JSONArray();
		Transaction Sqlca=null;
		//创建数据库连接
		JBOTransaction tx = null;
		if(SerialNo!=null){
		    try {
		    	Sqlca=new Transaction(FinalNum.DATASOUTCE);
		    	tx = JBOFactory.createJBOTransaction();
	       		tx.join(Sqlca);
	       		SystemConfig.loadBusinessDate(tx.getConnection(Sqlca));
		    	
		    	DefaultBusinessObjectManager boManager=new DefaultBusinessObjectManager(Sqlca);
		    	BusinessObject loan = boManager.loadObjectWithKey(BUSINESSOBJECT_CONSTATNTS.loan, SerialNo);
		    	//加载Loan利率信息
		    	ASValuePool as = new ASValuePool();
		    	as.setAttribute("ObjectType", loan.getObjectType());
		    	as.setAttribute("ObjectNo", loan.getObjectNo());
		    	as.setAttribute("Status", "1");
		    	List<BusinessObject> rateList = boManager.loadBusinessObjects(BUSINESSOBJECT_CONSTATNTS.loan_rate_segment, "ObjectType=:ObjectType and ObjectNo=:ObjectNo and Status=:Status",as);
		    	loan.setRelativeObjects(rateList);
		    	//加载Loan还款信息
		    	List<BusinessObject> rptList = boManager.loadBusinessObjects(BUSINESSOBJECT_CONSTATNTS.loan_rpt_segment, "ObjectType=:ObjectType and ObjectNo=:ObjectNo and Status=:Status",as);
		    	loan.setRelativeObjects(rptList);
		    	//加载Loan贴息信息
		    	List<BusinessObject> sptList = boManager.loadBusinessObjects(BUSINESSOBJECT_CONSTATNTS.loan_spt_segment, "ObjectType=:ObjectType and ObjectNo=:ObjectNo and Status=:Status",as);
		    	loan.setRelativeObjects(sptList);
		    	//加载Loan还款计划
		    	List<BusinessObject> paymentScheduleList = boManager.loadBusinessObjects(BUSINESSOBJECT_CONSTATNTS.payment_schedule," ObjectType=:ObjectType and ObjectNo=:ObjectNo and FinishDate is null order by paydate",as);
		    	loan.setRelativeObjects(paymentScheduleList);
		    	//加载Loan的余额信息
		    	List<BusinessObject> subLedgerList = boManager.loadBusinessObjects(BUSINESSOBJECT_CONSTATNTS.subsidiary_ledger, " ObjectType=:ObjectType and ObjectNo=:ObjectNo ",as);
		    	loan.setRelativeObjects(subLedgerList);
		    	//加载费用方案
		    	List<BusinessObject> feeList = boManager.loadBusinessObjects(BUSINESSOBJECT_CONSTATNTS.fee, " ObjectType=:ObjectType and ObjectNo=:ObjectNo and Status=:Status ",as);
		    	loan.setRelativeObjects(feeList);
		    	
		    	as = new ASValuePool();
		    	as.setAttribute("RelativeObjectType", loan.getObjectType());
		    	as.setAttribute("RelativeObjectNo", loan.getObjectNo());
		    	//取计息信息
		    	List<BusinessObject> interestLogList = boManager.loadBusinessObjects(BUSINESSOBJECT_CONSTATNTS.interest_log,"RelativeObjectType=:RelativeObjectType and RelativeObjectNo=:RelativeObjectNo and SettleDate is null",as);
		    	loan.setRelativeObjects(interestLogList);
	
		    	for(BusinessObject interestLog:interestLogList){
		    		String interestObjectType=interestLog.getString("ObjectType");
		    		String interestObjectNo=interestLog.getString("ObjectNo");
		    		if(!interestObjectType.equals(BUSINESSOBJECT_CONSTATNTS.payment_schedule)) continue;
		    		
		    		BusinessObject paymentSchedule = loan.getRelativeObject(interestObjectType, interestObjectNo);
		    		if(paymentSchedule==null) continue;
		    		if(interestLog.getString("PSSerialNo").equals(paymentSchedule.getString("SerialNo"))) 
		    			paymentSchedule.setRelativeObject(interestLog);
		    	}
	
		    	Sqlca.commit();
		    	
		    	JSONObject jsonObject1 = new JSONObject();
		    	jsonObject1.element("ContractList", jsonArray);
				response.getWriter().write(jsonObject1.toString());
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				
				e.printStackTrace();
			} catch (JBOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}finally{
				try {
					if(tx!=null)
					
						tx.commit();
					
				} catch (JBOException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
				try {
		            if(Sqlca!=null)
		            {
		                Sqlca.commit();
		                Sqlca.disConnect();
		                Sqlca = null;
		            }
	            } catch (SQLException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
		       
				
		    }
			ARE.getLog().debug(OUT_PUT_LOG+"loadLoan dopost end ");
		}

	}
    

		
}
