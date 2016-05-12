package com.amarsoft.hhcf.app;

import java.io.IOException;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import com.amarsoft.app.lending.bizlets.GetMonthPayment;
import com.amarsoft.are.ARE;
import com.amarsoft.are.sql.Connection;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;

/**
 * Author 		：tbzeng
 * Date	   		：2014/10/03 12：55
 * Update by	：
 * 根据传入产品类型，商品范畴，商品金额，首付比例，门店编号
 * 获取产品名称
 */
public class GetBusinessTypes extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private static String OUT_PUT_LOG="[APP INTERFACE==========][=======METHOD:GetBusinessTypes=========]:";
	  
    public GetBusinessTypes() {
        super();
    }

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		this.doPost(request, response);
	}
	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		response.setCharacterEncoding("GBK");
		
		String sProductID =  request.getParameter("ProductID");							// 产品类型-->030
		String sProductSum =  request.getParameter("ProductSum");					// 	产品金额-->5000
		String sShoufuratio =  request.getParameter("Shoufuratio");						// 首付比例-->20
		String sProductCategory =  request.getParameter("ProductCategory");		// 	商品范畴  --->7
		String sSNo =  request.getParameter("SNo");											// 门店编号-->33010000001
		ARE.getLog().debug(OUT_PUT_LOG+"inputput parameter 1:"+sProductID);
		ARE.getLog().debug(OUT_PUT_LOG+"input parameter 2:"+sProductSum);
		ARE.getLog().debug(OUT_PUT_LOG+"input parameter 3:"+sShoufuratio);
		ARE.getLog().debug(OUT_PUT_LOG+"input parameter 4:"+sProductCategory);
		ARE.getLog().debug(OUT_PUT_LOG+"input parameter 5:"+sSNo);
		// 日志打印传入参数
		ARE.getLog("GetBusinessTypes").info("ProductID: " + sProductID + ",ProductSum: " + sProductSum + ",Shoufuratio: " + sShoufuratio + ",ProductCategory: " + sProductCategory + ",SNo: " + sSNo);
		
		Transaction Sqlca=new Transaction(FinalNum.DATASOUTCE);
		JSONArray jsonArray = new JSONArray();
		JSONObject jsonObject=new JSONObject();
		
		//Connection conn=null;
		String sql= "SELECT TypeNo,TypeName,Attribute2," +
				  "CASE WHEN Effectiveannualrate=0 THEN ROUND(:Sum  /Term, 0) " +
				  " ELSE ROUND((:Sum * Effectiveannualrate/12 * 0.01) * ROUND(POWER((1 + Effectiveannualrate/12 * 0.01), Term), 6)/(ROUND(POWER((1 + Effectiveannualrate/12 * 0.01),Term), 6) - 1), 0) " +
				  " END AS MONTHLYPAYMENT, Term, ShoufuRatio, :ProductSum-:Sum  AS Downpayment,  (:Sum) AS CreditSum, productCategoryID AS Productcategory ,Effectiveannualrate,Defaultvalue" +
				  " FROM business_type bt,product_term_library ptl, product_term_para ptp"+
				 // " left outer join product_term_library ptl on ptl.objectno=bt.typeno and subtermtype = 'A12' and objecttype = 'Product' "+
				  //" left outer join product_term_para ptp on bt.typeno=ptp.objectno and ptp.termid=ptl.termid "+
				  " WHERE ptl.objectno = (bt.typeno || '-V1.0') "+
				  " and ptl.subtermtype = 'A12' " +
				  " and ptl.objecttype = 'Product' " +
				  " and (bt.typeno || '-V1.0') = ptp.objectno " +
				  " AND PTP.PARAID = 'FeeRate' " +
				  " and ptl.termid = ptp.termid " +
				  " AND ((shoufuratiotype='1' AND shoufuratio=:Shoufuratio) OR (shoufuratiotype='2' " +
				  " AND shoufuratio<=:Shoufuratio )) AND producttype=:ProductID AND ISINUSE='1' " +
				  " AND instr(','||ProductCategory||',',','||:ProductCategory||',',1)>0 " +
				  " AND Term IS NOT NULL AND ROUND(:Sum,2) BETWEEN lowPrincipal AND tallPrincipal " +
				  " AND (to_date(TO_CHAR(sysdate, 'yyyy/MM/dd'), 'yyyy/mm/dd') BETWEEN to_date(effectivestartdate, 'yyyy/MM/dd') AND to_date(effectiveenddate, 'yyyy/MM/dd')) " +
				  " AND TYPENO IN (SELECT BT.TYPENO FROM BUSINESS_TYPE BT LEFT JOIN PRODUCT_BUSINESSTYPE PB " +
				  " ON BT.TYPENO=PB.BUSTYPEID WHERE PB.PRODUCTSERIESID IN (SELECT PNO FROM STORERELATIVEPRODUCT WHERE SNO=:SNo) )";
		try {
			//追加试算
			String MonthPayment="";//每月还款
			GetMonthPayment getMonthPayment=new GetMonthPayment();
			//getMon
			double dProductSum 	= Double.parseDouble(sProductSum);
			double dShoufuratio 	= Double.parseDouble(sShoufuratio);
			ARE.getLog().debug(OUT_PUT_LOG+"dopost sql1:"+sql);
			ASResultSet rs = Sqlca.getASResultSet(new SqlObject(sql).setParameter("Sum", dProductSum*(1-dShoufuratio/100))
					.setParameter("ProductID", sProductID).setParameter("ProductSum", dProductSum).setParameter("ProductCategory", sProductCategory)
					.setParameter("Shoufuratio", dShoufuratio).setParameter("SNo", sSNo));
			while (rs.next()) {
				JSONObject jsonTemp = new JSONObject();
				jsonTemp.put("TypeNo", rs.getString("TypeNo"));
				jsonTemp.put("TypeName", rs.getString("TypeName"));
				jsonTemp.put("Term", rs.getString("Term"));
				jsonTemp.put("Effectiveannualrate", rs.getString("Effectiveannualrate"));
				
				System.out.println("##################################"+rs.getString("Defaultvalue"));
				
				jsonTemp.put("Defaultvalue", rs.getString("Defaultvalue"));
				
				
				jsonArray.add(jsonTemp);
			}
		  
			jsonObject.element("data", jsonArray);
			ARE.getLog().debug(OUT_PUT_LOG+"output parameter:"+jsonObject.toString());
			response.getWriter().write(jsonObject.toString());
			response.getWriter().flush();
			response.getWriter().close();
			//conn.commit();
			if(rs!=null)
				rs.close();
			Sqlca.disConnect();
			ARE.getLog().debug(OUT_PUT_LOG+"dopost end");
			
		} catch (Exception e) {
			e.printStackTrace();
			throw new RuntimeException("获取失败，请确认传入参数是否正确！");
		}finally{
			if(Sqlca!=null)
				try {
					Sqlca.disConnect();
				} catch (SQLException e) {
					e.printStackTrace();
				}
			
			
	    }
	}

}
