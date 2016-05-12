package com.amarsoft.hhcf.app;

import java.io.IOException;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import com.amarsoft.are.ARE;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.webservice.YXWebService;
import com.amarsoft.webservice.impl.YXWebServiceImpl;
import com.amarsoft.webservice.util.ClientFactory;
import com.amarsoft.webservice.util.CodeTrans;
/**
 * Author 		：liuh
 * Date	   		：2014/12/16 
 * Update by	：
 * 上传图片附件
 * 
 */
public class UploadAppendFile extends HttpServlet{
    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private static String OUT_PUT_LOG = "[APP INTERFACE==========][=======METHOD:UploadAppendFile=========]:";

	public UploadAppendFile(){
    	
    }
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		this.doPost(request, response);
    }
   
   /* protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    	ARE.getLog().debug(OUT_PUT_LOG+"doPost begin ");
    	
		String image =request.getParameter("image");
		String objType =request.getParameter("objType");
		String objNo =request.getParameter("objNo");
		String typeNo =request.getParameter("typeNo");
		String userId =request.getParameter("userId");
		String orgId =request.getParameter("orgId");
		image = image + "^|!|!|!";
		
	
		
		// * 如果image为空, 或者未使用内容管理, 或者内容管理类配置出错, 则返回""
		// * @param objType 对象类型
		// * @param objNo 对象编号
		// * @param typeNo 影像类型
		// * @param image 影像内容的base64编码字符串
		// * @param userId 信贷系统用户id
		// * @param orgId 信贷系统机构id
		// * @return 影像文档对象的id(多个影像时, 用','连接)
		 
		ARE.getLog().debug(OUT_PUT_LOG+"doPost end ");
	}
}

class UploadAppendFileRunnable implements Runnable {
	private String image;
	private String objType;
	private String objNo;
	private String typeNo;
	private String userId;
	private String orgId;
	
	
	
	  public UploadAppendFileRunnable(String image,String objType, String objNo,String typeNo,String userId,String orgId){
		  this.image=image;
		  this.objType=objType;
		  this.typeNo=typeNo;
		  this.objNo=objNo;
		  this.userId=userId;
		  this.orgId=orgId;
		  
	  }
	  
	  public void run() {
		  YXWebServiceImpl webService = new YXWebServiceImpl();
		  webService.saveImage(objType, objNo,typeNo, image,userId, orgId);
	  }
	 */
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    	YXWebServiceImpl webService = new YXWebServiceImpl();
		String image =request.getParameter("image");
		String objType =request.getParameter("objType");
		String objNo =request.getParameter("objNo");
		String typeNo =request.getParameter("typeNo");
		String userId =request.getParameter("userId");
		String orgId =request.getParameter("orgId");
		image = image + "^|!|!|!";
      
		webService.saveImage(objType, objNo,typeNo, image,userId, orgId);
	
		/**
		 * 如果image为空, 或者未使用内容管理, 或者内容管理类配置出错, 则返回""
		 * @param objType 对象类型
		 * @param objNo 对象编号
		 * @param typeNo 影像类型
		 * @param image 影像内容的base64编码字符串
		 * @param userId 信贷系统用户id
		 * @param orgId 信贷系统机构id
		 * @return 影像文档对象的id(多个影像时, 用','连接)
		 */
	
	}
}