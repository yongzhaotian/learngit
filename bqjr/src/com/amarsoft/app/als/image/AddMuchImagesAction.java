package com.amarsoft.app.als.image;

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
 * 批量修改商品对应影像文件
 * @author yongxu
 *
 */
public class AddMuchImagesAction {

	private String productTypeID;
	private String iamgeTypeNo;
	private String action;
	private String userID;
	private String compNo;
	
	

	public String getProductTypeID() {
		return productTypeID;
	}

	public void setProductTypeID(String productTypeID) {
		this.productTypeID = productTypeID;
	}

	public String getIamgeTypeNo() {
		return iamgeTypeNo;
	}

	public void setIamgeTypeNo(String iamgeTypeNo) {
		this.iamgeTypeNo = iamgeTypeNo;
	}

	public String getAction() {
		return action;
	}

	public void setAction(String action) {
		this.action = action;
	}

	public String getUserID() {
		return userID;
	}

	public void setUserID(String userID) {
		this.userID = userID;
	}

	public String getCompNo() {
		return compNo;
	}

	public void setCompNo(String compNo) {
		this.compNo = compNo;
	}

	/**
	 * 执行保存/删除/更新等操作,并记录用户角色变更信息
	 * @param Sqlca
	 * @return
	 * @throws Exception
	 */
	public String addMuchImages(Transaction Sqlca) throws Exception{
		//执行保存/删除/更新等操作,并记录用户角色变更信息
		String sReturn = operateImage(Sqlca, userID, productTypeID, iamgeTypeNo, action, compNo);
		return sReturn;
	}
	
	public  String operateImage(Transaction sqlca, String userID, String productTypeID, String imagesIDList, String action, String compNo)
	  {
	    String optionMessage = "UNDEFIND";
	    ASResultSet rs = null;
	    SqlObject asql = null;
	    //区分贷前和贷后
	    String tableName = " PRODUCT_ECM_TYPE ";
	    if("2".equals(compNo)){
	    	tableName = " PRODUCT_ECM_TYPE ";
	    }else if("3".equals(compNo)){
	    	tableName = " PRODUCT_ECM_UPLOAD ";
	    }
	    if (productTypeID == null) productTypeID = "";
	    if (imagesIDList == null) imagesIDList = "";
	    if (("Add".equalsIgnoreCase(action)) || ("Del".equalsIgnoreCase(action)) || ("UPDATE".equalsIgnoreCase(action)))
	    {
	      String[] iamgeIDs = null;
	      if (imagesIDList.indexOf("@") != -1)
	    	  iamgeIDs = imagesIDList.split("@");
	      else {
	    	  iamgeIDs = new String[] { imagesIDList };
	      }

	      String addImagesSQL = "insert into "+tableName+"(PRODUCT_TYPE_ID,PRODUCT_TYPE_NAME,IMAGE_TYPE_NO,IMAGE_TYPE_NAME,ISINUSE,INPUTUSER,INPUTTIME,INPUTORG)  values(:ProductTypeID,:ProductTypeName,:ImageTypeNo,:ImageTypeName,:IsInUse,:InputUser,:InputTime,:InputOrg)";

	      String updateImagesSQL = "update "+tableName+" set INPUTUSER=:InputUser, INPUTTIME=:InputTime where PRODUCT_TYPE_ID=:ProductTypeID and IMAGE_TYPE_NO=:ImageTypeID";
	      String selectImagesSQL = "select 1 from "+tableName+" where PRODUCT_TYPE_ID=:ProductTypeID and IMAGE_TYPE_NO=:ImageTypeID";
	      String deleteImagesSQL = "delete from "+tableName+" where PRODUCT_TYPE_ID=:ProductTypeID and IMAGE_TYPE_NO=:ImageTypeID";

	      HashSet oldImageIDs = new HashSet();
	      HashSet deleteImageIDs = new HashSet();
	      String[] deleteImages = null;
	      try
	      {
	        if ("UPDATE".equalsIgnoreCase(action))
	        {
	          asql = new SqlObject("select IMAGE_TYPE_NO from "+tableName+" where PRODUCT_TYPE_ID=:ProductTypeID").setParameter("ProductTypeID", productTypeID);
	          rs = sqlca.getASResultSet(asql);
	          while (rs.next()) {
	        	  oldImageIDs.add(rs.getString(1));
	          }
	          rs.getStatement().close();

	          deleteImageIDs = (HashSet)oldImageIDs.clone();
	          for (int i = 0; i < iamgeIDs.length; i++) {
	            if (deleteImageIDs.contains(iamgeIDs[i])) {
	            	deleteImageIDs.remove(iamgeIDs[i]);
	            }
	          }
	          deleteImages = new String[deleteImageIDs.size()];
	          Iterator iter = deleteImageIDs.iterator();
	          int mm = 0;
	          while (iter.hasNext()) {
	        	  deleteImages[mm] = ((String)iter.next());
	            mm++;
	          }

	          for (int i = 0; i < deleteImages.length; i++) {
	            sqlca.executeSQL(new SqlObject(deleteImagesSQL).setParameter("ProductTypeID", productTypeID).setParameter("ImageTypeID", deleteImages[i]));
	          }

	          for (int i = 0; i < iamgeIDs.length; i++)
	          {
	            if (oldImageIDs.contains(iamgeIDs[i]))
	            {
	              asql = new SqlObject(updateImagesSQL);
	              asql.setParameter("InputUser", userID);
	              asql.setParameter("InputTime", getCurrentTime());
	              asql.setParameter("ProductTypeID", productTypeID);
	              asql.setParameter("ImageTypeID", iamgeIDs[i]);
	              sqlca.executeSQL(asql);
	            } else if (iamgeIDs[i].length() > 0)
	            {
	              rs = sqlca.getASResultSet(new SqlObject("select PRODUCT_TYPE_NAME from PRODUCT_TYPE WHERE PRODUCT_TYPE_ID = :ProductTypeID").setParameter("ProductTypeID", productTypeID));
	              String productTypeName = "";
	              String imageTypeName = "";
	              if(rs.next()){
	            	  productTypeName = rs.getString(1);
	              }
	              rs = sqlca.getASResultSet(new SqlObject("select TYPENAME from ECM_IMAGE_TYPE WHERE TYPENO = :TypeNo").setParameter("TypeNo", iamgeIDs[i]));
	              if(rs.next()){
	            	  imageTypeName = rs.getString(1);
	              }
	              rs.getStatement().close();
	              asql = new SqlObject(addImagesSQL); 
	              asql.setParameter("ProductTypeID", productTypeID);
	              asql.setParameter("ProductTypeName", productTypeName);
	              asql.setParameter("ImageTypeNo", iamgeIDs[i]);
	              asql.setParameter("ImageTypeName", imageTypeName);
	              asql.setParameter("IsInUse", "1");
	              asql.setParameter("InputUser", userID);
	              asql.setParameter("InputTime", getCurrentTime());
	              asql.setParameter("InputOrg", "");
	              sqlca.executeSQL(asql);
	            }
	          }

	        }

	        if ("DEL".equalsIgnoreCase(action)) {
	          for (int i = 0; i < iamgeIDs.length; i++) {
	            for (int j = 0; j < iamgeIDs.length; j++) {
	              asql = new SqlObject(selectImagesSQL).setParameter("ProductTypeID", productTypeID).setParameter("ImageTypeID", deleteImages[i]);
	              rs = sqlca.getASResultSet(asql);
	              if (rs.next()){
	                sqlca.executeSQL(new SqlObject(deleteImagesSQL).setParameter("ProductTypeID", productTypeID).setParameter("ImageTypeID", deleteImages[i]));
	              }
	              rs.getStatement().close();
	            }
	          }

	        }

	        optionMessage = " 影像文件操作成功";
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

