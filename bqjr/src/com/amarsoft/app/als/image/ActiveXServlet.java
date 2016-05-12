package com.amarsoft.app.als.image;


import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.Date;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import sun.misc.BASE64Decoder;
import sun.misc.BASE64Encoder;

import com.amarsoft.app.contentmanage.Content;
import com.amarsoft.app.contentmanage.ContentManager;
import com.amarsoft.app.contentmanage.DefaultContentManagerImpl;
import com.amarsoft.app.contentmanage.action.ContentManagerAction;
import com.amarsoft.are.ARE;
import com.amarsoft.are.lang.StringX;
import com.amarsoft.are.sql.Connection;
import com.amarsoft.awe.Configure;
import com.amarsoft.webservice.util.CodeTrans;


public class ActiveXServlet  extends HttpServlet{
	
	
		//用于生成图片文件名中的日期格式
		private SimpleDateFormat fileNameDateFormat = new SimpleDateFormat("yyyyMMddHHmmss");
		//插入图片的日期格式
		private SimpleDateFormat insertPicDateFormat = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
		

		private static final long serialVersionUID = 332233L;

		protected void doGet(HttpServletRequest req, HttpServletResponse resp)
				throws ServletException, IOException {
			doPost(req, resp);
		}
		
		protected void doPost(HttpServletRequest req, HttpServletResponse resp)
				throws ServletException, IOException {
			
			//String objType, String objNo, String typeNo, String ids
			String ids =  req.getParameter("Ids");
			String objectType =  req.getParameter("ObjectType");
			String objectNo =  req.getParameter("ObjectNo");
			String typeNo =  req.getParameter("TypeNo");
			
			String images =  req.getParameter("Images");
			String userId =  req.getParameter("UserId");
			String orgId =  req.getParameter("OrgId");
			
			String str = null;
			if(ids != null ){ //是获取图片
				str = getImage( ids);
				//resp.setContentType("text/plain");
			}else if(images != null){ //是上传图片
				str = saveImage(objectType, objectNo, typeNo, images, userId, orgId);
			}
			resp.getWriter().write(str!=null?str:"");
			resp.getWriter().flush();
			resp.getWriter().close();
			
			
		}
		
		
		public String getImage( String ids) {
			ARE.getLog().debug(ids);
			if(StringX.isEmpty(ids) ||
					!(ContentManagerAction.IsUseContentManager && ContentManagerAction.isConfCorrect ) ) return "";
			String[] idArr = ids.split("\\|");
			StringBuffer imageBuf = new StringBuffer();
			for (int i = 0; i < idArr.length; i++) {
				String singleImage = getSingleImage( idArr[i]);
				if(! StringX.isEmpty(singleImage)){
					imageBuf.append(singleImage);
					if( i!=idArr.length-1 ) imageBuf.append("|");
				}
			}
			return imageBuf.toString();
		}
		
		public String getSingleImage( String id){
			String singleImageStr="";
			if(StringX.isEmpty(id) ||
					!(ContentManagerAction.IsUseContentManager && ContentManagerAction.isConfCorrect ) ) return "";
			ContentManager contentManager = ContentManagerAction.getContentManager();
			if(contentManager==null) return "";
			
			ByteArrayOutputStream bos = new ByteArrayOutputStream();
			byte[] bytes = new byte[10240];
			
			Content content = contentManager.get(id);
			if(content==null) return "";
			
			InputStream is = content.getInputStream();
			String desc = content.getDesc();
			// 读取图片字节数组
			try {
				int k = -1;
				while((k=is.read(bytes))>0){
					bos.write(bytes, 0, k);
				}
			} catch (IOException e) {
				e.printStackTrace();
			}finally{
				try {
					is.close();
				} catch (IOException e) { e.printStackTrace(); }
			}
			// 对字节数组Base64编码
			BASE64Encoder encoder = new BASE64Encoder();
			if(bos.size()>0) {
				singleImageStr = encoder.encode(bos.toByteArray());
				bos.reset();
			}
			String tempStr = encoder.encode(desc.getBytes());
			//ARE.getLog().trace("*******encoder之前:"+desc+"\n之后:"+tempStr);
			return singleImageStr+"^"+tempStr;
		}

		public String saveImage(String ObjectType, String ObjectNo, String TypeNo, 
				String imageAndActiveXids, String userId, String orgId) {
			if( 	!(ContentManagerAction.IsUseContentManager && ContentManagerAction.isConfCorrect ) ) return "";
			ContentManager contentManager = ContentManagerAction.getContentManager();
			if(contentManager==null) return "";
			String retStr = "";
			//图片信息、IDs顺序字符串、需要删除的IDs、备注信息,这四项之间的分割符
			String S1 = "\\|!";
	        //多个图片或多个id的分割符
	        String S2 = "\\|";
	        //infos中的每个id与info的分割符
	        String S3 = "\\^";
			String[] imageStrArr = null;
			String[] activeX_Ids = null, needDelIds=null, infos=null;
			if(! StringX.isEmpty(imageAndActiveXids) ) {
				String[] tempArr = imageAndActiveXids.split(S1, -1);
				ARE.getLog().trace("要上传的图片(base64编码)*******"+ tempArr[0]);
				ARE.getLog().trace("插件中各个图片的ID(或路径)的顺序*******"+ tempArr[1]);
				ARE.getLog().trace("要删除的图片ID(或路径)*******"+ tempArr[2]);
				ARE.getLog().trace("要设置的备注*******"+ tempArr[3]);
				imageStrArr=tempArr[0].length()>0?tempArr[0].split(S2):null;
				activeX_Ids = tempArr[1].split(S2, -1);
				needDelIds = tempArr[2].length()>0?tempArr[2].split(S2):null;
				infos = tempArr[3].length()>0?tempArr[3].split(S2):null;
			}
			Content tempContent = null;
			
			Connection conn = null;
			PreparedStatement  updateRemarkPs=null, updatePageNumPs=null, deleteOldDocPs=null, insertDocPs = null, queryTypePs = null;
			ResultSet rs = null, typeRs = null;
			String dataSource = null;
			try {
				dataSource = Configure.getInstance().getDataSource();
				conn = ARE.getDBConnection(dataSource==null?"als":dataSource);
				conn.setAutoCommit(false);
			} catch (Exception e) {
				ARE.getLog().error("获得awe config中的datasource配置出错", e);
			}
			try{
				insertDocPs =conn.prepareStatement("insert into ECM_PAGE( objectType, objectNo, typeNo, documentId, pageNum, modifyTime, imageInfo, operateUser, operateOrg, remark ) "+
						" values (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)");
				
				/*queryTypePs = conn.prepareStatement("select " +
						("10".equals(TypeNo.substring(0, 2))?
								"(select '客户名:'||customerName from customer_info where customerId=?)":
								"( select '业务类型:'||t.typename from business_type t, business_apply ba  where ba.businesstype=t.typeno and ba.serialNo=? )" )+
						"||'--影像类型:'||typename as name from ecm_image_type where typeno=?");*/
				updateRemarkPs = conn.prepareStatement("update ECM_PAGE set remark=? where documentId=? and objectNo=? ");
				updatePageNumPs = conn.prepareStatement("update ECM_PAGE set pageNum=? where documentId=? and objectNo=? ");
			}catch(Exception e){
				ARE.getLog().fatal("创建statment出错",e);
			}
			BASE64Decoder decoder = new BASE64Decoder();
			//----新上传的图片信息及其备注
			for (int i = 0, j=0; imageStrArr!=null && activeX_Ids!=null && i<imageStrArr.length; i++) {
				String[] arr = imageStrArr[i].split(S3, -1);
				byte[] b = CodeTrans.String2Byte(arr[0].replace(" ", "+"));
				InputStream is = new ByteArrayInputStream(b);
				tempContent = new Content();
				tempContent.setInputStream(is);
				String tempImageInfo = "", tempImageFileType = "", tempLocalOrScan = "" ;
				if(arr.length>=3){
					try {
						//备注
						tempImageInfo = new String(decoder.decodeBuffer(arr[1].replace(" ", "+")));
						//ARE.getLog().trace("************decoder之前:"+arr[1]+"\n之后:"+tempStr);
					} catch (Exception e1) {
						ARE.getLog().error("解码备注信息时，出错",e1);
						tempImageInfo = arr[1];
					}
					try{
						String[] strs = arr[2].split("@");
						tempLocalOrScan = strs[0];
						tempImageFileType = strs[1];
					}catch(Exception e){
						ARE.getLog().error("获取图片文件类型及图片是本地上传或从设备采集时，出错",e);
						tempLocalOrScan = "scan";
						tempImageFileType = "jpeg";
					}
				}
				tempContent.setDesc(tempImageInfo);
				String randomStr = String.valueOf(Math.random()).substring(2);
				if(randomStr.length()<8){randomStr += "0000000"; }
				tempContent.setName(fileNameDateFormat.format(new Date())+"_"+(randomStr.substring(0,8))+"."+tempImageFileType);
				String uploadDocId = contentManager.save(tempContent, ContentManager.FOLDER_IMAGE );
				//把新增的图片id更新回id顺序数组activeX_Ids中
				for(int j2=j; j2<activeX_Ids.length; j2++){
					if(StringX.isEmpty(activeX_Ids[j2])) {
						activeX_Ids[j2] = uploadDocId;
						j=j2+1;
						break;
					}
				}
				//---插入数据到ECM_PAGE中
				try{
					insertDocPs.setString(1, ObjectType);
					insertDocPs.setString(2, ObjectNo);
					insertDocPs.setString(3, TypeNo);
					insertDocPs.setString(4, uploadDocId);
					insertDocPs.setString(5, (i+1)+"");
					insertDocPs.setString(6, insertPicDateFormat.format(new Date()));
					//查影像类型
					/*queryTypePs.setString(1, ObjectNo);
					queryTypePs.setString(2, TypeNo);
					typeRs = queryTypePs.executeQuery();
					String type = "";
					if(typeRs.next()){
						type= typeRs.getString(1);
					}
					if(typeRs!=null) typeRs.close();
					insertDocPs.setString(7, type);*/
					//TODO 暂时用来存 localOrScan
					insertDocPs.setString(7, tempLocalOrScan);
					insertDocPs.setString(8, userId);
					insertDocPs.setString(9, orgId);
					insertDocPs.setString(10, tempImageInfo);
					insertDocPs.addBatch();
					ARE.getLog().trace("插入一条记录: "+uploadDocId);
				}catch(Exception e){
					ARE.getLog().trace("插入影像数据记录出错!");
				}
			}
			//----对原有图片的备注的修改,设置内容管理平台的备注
			for(int info_i=0; infos!=null && info_i<infos.length; info_i++){
				String[] info_arr = infos[info_i].split(S3);
				String temp = null;
				if(info_arr.length>=2){
					try {
						temp = new String(decoder.decodeBuffer(info_arr[1]));
					} catch (Exception e1) {
						temp = info_arr[1];
					}
				}
				ARE.getLog().trace("设置文档对象(id:"+info_arr[0]+")的desc: "+ temp);
				contentManager.setDesc(info_arr[0], info_arr.length>=2?temp:"");
				//若未使用内容管理平台，则保存信息到ECM_PAGE表中的备注字段
				if( contentManager instanceof DefaultContentManagerImpl){
					try {
						updateRemarkPs.setString(1, info_arr.length>=2?temp:"");
						updateRemarkPs.setString(2, info_arr[0]);
						updateRemarkPs.setString(3, ObjectNo);
						updateRemarkPs.addBatch();
						ARE.getLog().trace("更新一条记录:"+info_arr[0]+ "的备注信息："+(info_arr.length>=2?temp:"") );
					} catch (SQLException e) {
						e.printStackTrace();
					}
				}
			}

			try {
				for(int j=0; needDelIds!=null && j<needDelIds.length; j++){
					contentManager.delete(needDelIds[j]);
				}
				String allIdStr = "";
				for(int i =0; i<activeX_Ids.length; i++){
					allIdStr = allIdStr +",'"+activeX_Ids[i]+"'";
				}
				//ARE.getLog().info("allIDstr:"+allIdStr);
				insertDocPs.executeBatch();
				updateRemarkPs.executeBatch();
				
				if(needDelIds!=null && needDelIds.length>0){
					String tempDelIds = "'";
					for(String id : needDelIds){
						tempDelIds = tempDelIds + id +"','";
					}
					tempDelIds = tempDelIds.substring(0, tempDelIds.length()-2);
					//deleteOldDocPs =conn.prepareStatement("delete from  ECM_PAGE where objectType=? and objectNo=? and typeNo=? and documentId not in("+ (allIdStr.length()>0?allIdStr.substring(1):"''") +") ");
					String delSql = "delete from  ECM_PAGE where objectType=? and objectNo=? and typeNo=? and documentId  in("+ tempDelIds +") ";
					ARE.getLog().info(delSql);
					deleteOldDocPs =conn.prepareStatement(delSql);
					deleteOldDocPs.setString(1, ObjectType);
					deleteOldDocPs.setString(2, ObjectNo);
					deleteOldDocPs.setString(3, TypeNo);
					deleteOldDocPs.executeUpdate();
				}
				
				if(activeX_Ids!=null && activeX_Ids.length>0){
					for(int i =0; activeX_Ids!=null && i<activeX_Ids.length; i++){
						if(StringX.isEmpty(activeX_Ids[i])){
							continue;
						}
						updatePageNumPs.setString(1, i+1+"");
						updatePageNumPs.setString(2, activeX_Ids[i]);
						updatePageNumPs.setString(3, ObjectNo);
						updatePageNumPs.addBatch();
						ARE.getLog().trace("更新"+activeX_Ids[i]+ "的编号为"+(i+1));
						retStr = retStr+"|"+activeX_Ids[i];
					}
					updatePageNumPs.executeBatch();
				}
				conn.commit();
			} catch (SQLException e) {
				ARE.getLog().error("更新DocId出错",e);
				return "";
			}finally{
				try {
					if(rs!=null) rs.close();
					//if(queryTypePs!=null) queryTypePs.close();
					if(updateRemarkPs!=null) updateRemarkPs.close();
					if(updatePageNumPs!=null) updatePageNumPs.close();
					if(deleteOldDocPs!=null) deleteOldDocPs.close();
					if(insertDocPs!=null) insertDocPs.close();
					if(conn!=null) conn.close();
				} catch (SQLException e) { ARE.getLog().error("关闭数据库连接出错",e); }
			}
			retStr = retStr.length()>0?retStr.substring(1):"";
			ARE.getLog().trace(retStr);
			return retStr;
		}
	}

