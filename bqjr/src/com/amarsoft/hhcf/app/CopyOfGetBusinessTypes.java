package com.amarsoft.hhcf.app;

import java.io.IOException;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import com.amarsoft.are.ARE;
import com.amarsoft.are.sql.Connection;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;

/**
 * Author 		��tbzeng
 * Date	   		��2014/10/03 12��55
 * Update by	��
 * ���ݴ����Ʒ���ͣ���Ʒ���룬��Ʒ���׸��������ŵ���
 * ��ȡ��Ʒ����
 */
public class CopyOfGetBusinessTypes extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    public CopyOfGetBusinessTypes() {
        super();
    }

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		this.doPost(request, response);
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		response.setCharacterEncoding("GBK");
		
		String sProductID =  request.getParameter("ProductID");							// ��Ʒ����
		String sProductSum =  request.getParameter("ProductSum");					// 	��Ʒ���	
		String sShoufuratio =  request.getParameter("Shoufuratio");						// �׸�����
		String sProductCategory =  request.getParameter("ProductCategory");		// 	��Ʒ����
		String sSNo =  request.getParameter("SNo");											// �ŵ���
		
		// ��־��ӡ�������
		ARE.getLog("GetBusinessTypes").info("ProductID: " + sProductID + ",ProductSum: " + sProductSum + ",Shoufuratio: " + sShoufuratio + ",ProductCategory: " + sProductCategory + ",SNo: " + sSNo);
		
		Transaction Sqlca=new Transaction(FinalNum.DATASOUTCE);
		JSONArray jsonArray = new JSONArray();
		JSONObject jsonObject=new JSONObject();
		
		Connection conn=null;
		String sql= "SELECT TypeNo,TypeName,Attribute2," +
				  "CASE WHEN Effectiveannualrate=0 THEN ROUND(:Sum  /Term, 0) " +
				  " ELSE ROUND((:Sum * Effectiveannualrate/12 * 0.01) * ROUND(POWER((1 + Effectiveannualrate/12 * 0.01), Term), 6)/(ROUND(POWER((1 + Effectiveannualrate/12 * 0.01),Term), 6) - 1), 0) " +
				  " END AS MONTHLYPAYMENT, Term, ShoufuRatio, :ProductSum-:Sum  AS Downpayment,  (:Sum) AS CreditSum, productCategoryID AS Productcategory " +
				  " FROM business_type bt WHERE ((shoufuratiotype='1' AND shoufuratio=:Shoufuratio) OR (shoufuratiotype='2' " +
				  " AND shoufuratio<=:Shoufuratio )) AND producttype=:ProductID AND ISINUSE='1' " +
				  " AND instr(','||ProductCategory||',',','||:ProductCategory||',',1)>0 " +
				  " AND Term IS NOT NULL AND :Sum BETWEEN lowPrincipal AND tallPrincipal " +
				  " AND (to_date(TO_CHAR(sysdate, 'yyyy/MM/dd'), 'yyyy/mm/dd') BETWEEN to_date(effectivestartdate, 'yyyy/MM/dd') AND to_date(effectiveenddate, 'yyyy/MM/dd')) " +
				  " AND TYPENO IN (SELECT BT.TYPENO FROM BUSINESS_TYPE BT LEFT JOIN PRODUCT_BUSINESSTYPE PB " +
				  " ON BT.TYPENO=PB.BUSTYPEID WHERE PB.PRODUCTSERIESID IN (SELECT PNO FROM STORERELATIVEPRODUCT WHERE SNO=:SNo) )";
		try {
			
			double dProductSum 	= Double.parseDouble(sProductSum);
			double dShoufuratio 	= Double.parseDouble(sShoufuratio);
			
			ASResultSet rs = Sqlca.getASResultSet(new SqlObject(sql).setParameter("Sum", dProductSum*(1-dShoufuratio/100))
					.setParameter("ProductID", sProductID).setParameter("ProductSum", dProductSum).setParameter("ProductCategory", sProductCategory)
					.setParameter("Shoufuratio", dShoufuratio).setParameter("SNo", sSNo));
			while (rs.next()) {
				JSONObject jsonTemp = new JSONObject();
				jsonTemp.put("TypeNo", rs.getString("TypeNo"));
				jsonTemp.put("TypeName", rs.getString("TypeName"));
				jsonTemp.put("Term", rs.getString("Term"));
				jsonArray.add(jsonTemp);
			}
		   
			jsonObject.element("data", jsonArray);
			
			response.getWriter().write(jsonObject.toString());
			response.getWriter().flush();
			response.getWriter().close();
			
			rs.getStatement().close();
		} catch (Exception e) {
			e.printStackTrace();
			throw new RuntimeException("��ȡʧ�ܣ���ȷ�ϴ�������Ƿ���ȷ��");
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
