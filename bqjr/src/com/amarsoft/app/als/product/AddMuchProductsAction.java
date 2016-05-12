package com.amarsoft.app.als.product;

import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.HashSet;
import java.util.Iterator;

import com.amarsoft.are.ARE;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.context.ASUser;


/**
 * 批量修改产品种类
 * @author yongxu
 *
 */
public class AddMuchProductsAction {

	private String productTypeID;
	private String productIDs;
	private String action;
	private String userID;
	
	

	public String getProductTypeID() {
		return productTypeID;
	}

	public void setProductTypeID(String productTypeID) {
		this.productTypeID = productTypeID;
	}


	public String getAction() {
		return action;
	}

	public void setAction(String action) {
		this.action = action;
	}

	public String getProductIDs() {
		return productIDs;
	}

	public void setProductIDs(String productIDs) {
		this.productIDs = productIDs;
	}

	public String getUserID() {
		return userID;
	}

	public void setUserID(String userID) {
		this.userID = userID;
	}

	/**
	 * 执行保存/删除/更新等操作,并记录用户角色变更信息
	 * @param Sqlca
	 * @return
	 * @throws Exception
	 */
	public String addMuchProducts(Transaction Sqlca) throws Exception{
		//执行保存/删除/更新等操作,并记录用户角色变更信息
		String sReturn = operateProduct(Sqlca, userID, productTypeID, productIDs, action);
		return sReturn;
	}
	
	public  String operateProduct(Transaction sqlca, String userID, String productTypeID, String productIDList, String action)
	  {
	    String optionMessage = "UNDEFIND";
	    ASResultSet rs = null;
	    SqlObject asql = null;
	    if (productTypeID == null) productTypeID = "";
	    if (productIDList == null) productIDList = "";
	    if (("Add".equalsIgnoreCase(action)) || ("Del".equalsIgnoreCase(action)) || ("UPDATE".equalsIgnoreCase(action)))
	    {
	      String[] productIDs = null;
	      if (productIDList.indexOf("@") != -1)
	    	  productIDs = productIDList.split("@");
	      else {
	    	  productIDs = new String[] { productIDList };
	      }

	      String addProductSQL = "insert into PRODUCT_TYPE_CTYPE(PRODUCT_TYPE_ID,PRODUCT_TYPE_NAME,PRODUCT_ID,PRODUCT_NAME,ISINUSE,INPUTUSER,INPUTTIME,INPUTORG)  values(:ProductTypeID,:ProductTypeName,:ProductID,:ProductName,:IsInUse,:InputUser,:InputTime,:InputOrg)";

	      String updateProductSQL = "update PRODUCT_TYPE_CTYPE set INPUTUSER=:InputUser, INPUTTIME=:InputTime where PRODUCT_TYPE_ID=:ProductTypeID and PRODUCT_ID=:ProductID";
	      String selectProductSQL = "select 1 from PRODUCT_TYPE_CTYPE where PRODUCT_TYPE_ID=:ProductTypeID and PRODUCT_ID=:ProductID";
	      String deleteProductSQL = "delete from PRODUCT_TYPE_CTYPE where PRODUCT_TYPE_ID=:ProductTypeID and PRODUCT_ID=:ProductID";

	      HashSet oldProductIDs = new HashSet();
	      HashSet deleteProductIDs = new HashSet();
	      String[] deleteProducts = null;
	      try
	      {
	        if ("UPDATE".equalsIgnoreCase(action))
	        {
	          asql = new SqlObject("select PRODUCT_ID from PRODUCT_TYPE_CTYPE where PRODUCT_TYPE_ID=:ProductTypeID").setParameter("ProductTypeID", productTypeID);
	          rs = sqlca.getASResultSet(asql);
	          while (rs.next()) {
	        	  oldProductIDs.add(rs.getString(1));
	          }
	          rs.getStatement().close();

	          deleteProductIDs = (HashSet)oldProductIDs.clone();
	          for (int i = 0; i < productIDs.length; i++) {
	            if (deleteProductIDs.contains(productIDs[i])) {
	            	deleteProductIDs.remove(productIDs[i]);
	            }
	          }
	          deleteProducts = new String[deleteProductIDs.size()];
	          Iterator iter = deleteProductIDs.iterator();
	          int mm = 0;
	          while (iter.hasNext()) {
	        	  deleteProducts[mm] = ((String)iter.next());
	            mm++;
	          }

	          for (int i = 0; i < deleteProducts.length; i++) {
	            sqlca.executeSQL(new SqlObject(deleteProductSQL).setParameter("ProductTypeID", productTypeID).setParameter("ProductID", deleteProducts[i]));
	          }

	          for (int i = 0; i < productIDs.length; i++)
	          {
	            if (oldProductIDs.contains(productIDs[i]))
	            {
	              asql = new SqlObject(updateProductSQL);
	              asql.setParameter("InputUser", userID);
	              asql.setParameter("InputTime", getCurrentTime());
	              asql.setParameter("ProductTypeID", productTypeID);
	              asql.setParameter("ProductID", productIDs[i]);
	              sqlca.executeSQL(asql);
	            } else if (productIDs[i].length() > 0)
	            {
	              rs = sqlca.getASResultSet(new SqlObject("select PRODUCT_TYPE_NAME from PRODUCT_TYPE WHERE PRODUCT_TYPE_ID = :ProductTypeID").setParameter("ProductTypeID", productTypeID));
	              String productTypeName = "";
	              String productName = "";
	              if(rs.next()){
	            	  //查询处商品名称
	            	  productTypeName = rs.getString(1);
	              }
	              rs = sqlca.getASResultSet(new SqlObject("select typeName from Business_Type WHERE typeNo = :ProductID").setParameter("ProductID", productIDs[i]));
	              if(rs.next()){
	            	  productName = rs.getString(1);
	              }
	              rs.getStatement().close();
	              asql = new SqlObject(addProductSQL); 
	              asql.setParameter("ProductTypeID", productTypeID);
	              asql.setParameter("ProductTypeName", productTypeName);
	              asql.setParameter("ProductID", productIDs[i]);
	              asql.setParameter("ProductName", productName);
	              asql.setParameter("IsInUse", "1");
	              asql.setParameter("InputUser", userID);
	              asql.setParameter("InputTime", getCurrentTime());
	              asql.setParameter("InputOrg", "");
	              sqlca.executeSQL(asql);
	            }
	          }

	        }

	        if ("DEL".equalsIgnoreCase(action)) {
	          for (int i = 0; i < productIDs.length; i++) {
	            for (int j = 0; j < productIDs.length; j++) {
	              asql = new SqlObject(selectProductSQL).setParameter("ProductTypeID", productTypeID).setParameter("ProductID", deleteProducts[i]);
	              rs = sqlca.getASResultSet(asql);
	              if (rs.next()){
	                sqlca.executeSQL(new SqlObject(selectProductSQL).setParameter("ProductTypeID", productTypeID).setParameter("ProductID", deleteProducts[i]));
	              }
	              rs.getStatement().close();
	            }
	          }

	        }

	        optionMessage = "商品更新成功";
	      } catch (SQLException e) {
	        ARE.getLog().error("数据库异常", e);
	      } catch (Exception e) {
	        ARE.getLog().error("数据库异常", e);
	      }
	    }
	    return optionMessage;
	  }
	
	  protected static String getCurrentTime()
	  {
	    return new SimpleDateFormat("yyyy/MM/dd HH:mm:ss").format(Calendar.getInstance().getTime());
	  }

}

