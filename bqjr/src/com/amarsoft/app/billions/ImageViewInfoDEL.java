package com.amarsoft.app.billions;

import java.io.File;

import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;

/**
 * /ImageManage/ImageViewInfo.jsp Ò³ÃæÍ¼Æ¬É¾³ý¹¦ÄÜ
 * 
 * @author Administrator
 * 
 */
public class ImageViewInfoDEL {
	
	private String objectno;
	private String docId;
	
	public String getObjectno() {
		return objectno;
	}
	public void setObjectno(String objectno) {
		this.objectno = objectno;
	}

	public String getDocId() {
		return docId;
	}
	public void setDocId(String docId) {
		this.docId = docId;
	}
	
	// /ImageManage/ImageViewInfo.jsp Ò³ÃæÍ¼Æ¬É¾³ý¹¦ÄÜ
	public String imageViewInfoDel(Transaction Sqlca) {
		try {
			
			String sql = "delete ecm_page where objectno=:objectno and documentid=:documentid";
			
			Sqlca.executeSQL(new SqlObject(sql).setParameter("objectno", this.objectno).setParameter("documentid", this.docId));
			
			File file = new File(docId);
			
			if (file != null && file.isFile()) {
				file.delete();
			}
			
		} catch (Exception e) {
			e.printStackTrace();
			return "Failure";
		}

		return "Success";
	}
}