package com.amarsoft.webservice.impl;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.Date;

import javax.jws.WebMethod;
import javax.jws.WebService;
import javax.jws.soap.SOAPBinding;

import sun.misc.BASE64Encoder;

import com.amarsoft.app.contentmanage.Content;
import com.amarsoft.app.contentmanage.ContentManager;
import com.amarsoft.app.contentmanage.DefaultContentManagerImpl;
import com.amarsoft.app.contentmanage.action.ContentManagerAction;
import com.amarsoft.are.ARE;
import com.amarsoft.are.lang.StringX;
import com.amarsoft.are.sql.Connection;
import com.amarsoft.awe.Configure;
import com.amarsoft.webservice.YXWebService;
import com.amarsoft.webservice.util.CodeTrans;

@WebService
@SOAPBinding(style = SOAPBinding.Style.RPC)
public class YXWebServiceImpl implements YXWebService {
	//��������ͼƬ�ļ����е����ڸ�ʽ
	private SimpleDateFormat fileNameDateFormat = new SimpleDateFormat("yyyyMMddHHmmss");
	//����ͼƬ�����ڸ�ʽ
	private SimpleDateFormat insertPicDateFormat = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
	@WebMethod
	@Override
	public String getImage(String objType, String objNo, String typeNo, String ids) {
		ARE.getLog().debug(objType+"---"+objNo+"---"+typeNo+"---"+ids);
		if(StringX.isEmpty(ids) ||
				!(ContentManagerAction.IsUseContentManager && ContentManagerAction.isConfCorrect ) ) return "";
		String[] idArr = ids.split("\\|");
		StringBuffer imageBuf = new StringBuffer();
		for (int i = 0; i < idArr.length; i++) {
			String singleImage = getSingleImage(objType, objNo, typeNo, idArr[i]);
			if(! StringX.isEmpty(singleImage)){
				imageBuf.append(singleImage);
				if( i!=idArr.length-1 ) imageBuf.append("|");
			}
		}
		return imageBuf.toString();
	}
	
	public String getSingleImage(String objType, String objNo, String typeNo, String id){
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
		// ��ȡͼƬ�ֽ�����
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
		// ���ֽ�����Base64����
		if(bos.size()>0) {
			BASE64Encoder encoder = new BASE64Encoder();
			singleImageStr = encoder.encode(bos.toByteArray());
			bos.reset();
		}
		return singleImageStr+"^"+desc;
	}

	@WebMethod
	@Override
	public String saveImage(String ObjectType, String ObjectNo, String TypeNo, 
			String imageAndActiveXids, String userId, String orgId) {
		if( 	!(ContentManagerAction.IsUseContentManager && ContentManagerAction.isConfCorrect ) ) return "";
		ContentManager contentManager = ContentManagerAction.getContentManager();
		if(contentManager==null) return "";
		String retStr = "";
		//ͼƬ��Ϣ��IDs˳���ַ�������Ҫɾ����IDs����ע��Ϣ,������֮��ķָ��
		String S1 = "\\|!";
        //���ͼƬ����id�ķָ��
        String S2 = "\\|";
        //infos�е�ÿ��id��info�ķָ��
        String S3 = "\\^";
		String[] imageStrArr = null;
		String[] activeX_Ids = null, needDelIds=null, infos=null;
		if(! StringX.isEmpty(imageAndActiveXids) ) {
			String[] tempArr = imageAndActiveXids.split(S1, -1);
			ARE.getLog().trace("Ҫ�ϴ���ͼƬ(base64����)*******"+ tempArr[0]);
			ARE.getLog().trace("�����ͼƬ��filenetId����*******"+ tempArr[1]);
			ARE.getLog().trace("Ҫɾ����ͼƬ��filenetId*******"+ tempArr[2]);
			ARE.getLog().trace("Ҫ���õ��ĵ���ע*******"+ tempArr[3]);
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
			ARE.getLog().error("���awe config�е�datasource���ó���", e);
		}
		try{
			insertDocPs =conn.prepareStatement("insert into ECM_PAGE( objectType, objectNo, typeNo, documentId, pageNum, modifyTime, imageInfo, operateUser, operateOrg, remark ) "+
					" values (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)");
			
			queryTypePs = conn.prepareStatement("select " +
					("10".equals(TypeNo.substring(0, 2))?
							"(select '�ͻ���:'||customerName from customer_info where customerId=?)":
							"( select 'ҵ������:'||t.typename from business_type t, business_apply ba  where ba.businesstype=t.typeno and ba.serialNo=? )" )+
					"||'--Ӱ������:'||typename as name from ecm_image_type where typeno=?");
			updateRemarkPs = conn.prepareStatement("update ECM_PAGE set remark=? where documentId=? and objectNo=? ");
			updatePageNumPs = conn.prepareStatement("update ECM_PAGE set pageNum=? where documentId=? and objectNo=? ");
		}catch(Exception e){
			ARE.getLog().fatal("����statment����");
		}
		//----���ϴ���ͼƬ��Ϣ���䱸ע
		for (int i = 0, j=0; imageStrArr!=null && activeX_Ids!=null && i<imageStrArr.length; i++) {
			String[] arr = imageStrArr[i].split(S3, -1);
			byte[] b = CodeTrans.String2Byte(arr[0]);
			InputStream is = new ByteArrayInputStream(b);
			tempContent = new Content();
			tempContent.setInputStream(is);
			tempContent.setDesc(arr[1]);
			String randomStr = String.valueOf(Math.random()).substring(2);
			if(randomStr.length()<8){randomStr += "0000000"; }
			tempContent.setName(fileNameDateFormat.format(new Date())+"_"+(randomStr.substring(0,8))+".jpg");
			String uploadDocId = contentManager.save(tempContent, ContentManager.FOLDER_IMAGE );
			//��������ͼƬid���»�id˳������activeX_Ids��
			for(int j2=j; j2<activeX_Ids.length; j2++){
				if(StringX.isEmpty(activeX_Ids[j2])) {
					activeX_Ids[j2] = uploadDocId;
					j=j2+1;
					break;
				}
			}
			//---�������ݵ�ECM_PAGE��
			try{
				insertDocPs.setString(1, ObjectType);
				insertDocPs.setString(2, ObjectNo);
				insertDocPs.setString(3, TypeNo);
				insertDocPs.setString(4, uploadDocId);
				insertDocPs.setString(5, (i+1)+"");
				insertDocPs.setString(6, insertPicDateFormat.format(new Date()));
				//��Ӱ������
				queryTypePs.setString(1, ObjectNo);
				queryTypePs.setString(2, TypeNo);
				typeRs = queryTypePs.executeQuery();
				String type = "";
				if(typeRs.next()){
					type= typeRs.getString(1);
				}
				if(typeRs!=null) typeRs.close();
				insertDocPs.setString(7, type);
				insertDocPs.setString(8, userId);
				insertDocPs.setString(9, orgId);
				insertDocPs.setString(10, arr[1]);
				insertDocPs.addBatch();
				ARE.getLog().trace("����һ����¼: "+uploadDocId);
			}catch(Exception e){
				
			}
		}
		//----��ԭ��ͼƬ�ı�ע���޸�,�������ݹ���ƽ̨�ı�ע
		for(int info_i=0; infos!=null && info_i<infos.length; info_i++){
			String[] info_arr = infos[info_i].split(S3);
			ARE.getLog().trace("�����ĵ�����(id:"+info_arr[0]+")��desc: "+ info_arr[1]);
			contentManager.setDesc(info_arr[0], info_arr.length>=2?info_arr[1]:"");
			//��δʹ�����ݹ���ƽ̨���򱣴���Ϣ��ECM_PAGE���еı�ע�ֶ�
			if( contentManager instanceof DefaultContentManagerImpl){
				try {
					updateRemarkPs.setString(1, info_arr.length>=2?info_arr[1]:"");
					updateRemarkPs.setString(2, info_arr[0]);
					updateRemarkPs.setString(3, ObjectNo);
					updateRemarkPs.addBatch();
					ARE.getLog().trace("����һ����¼:"+info_arr[0]+ "�ı�ע��Ϣ��"+(info_arr.length>=2?info_arr[1]:"") );
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
			insertDocPs.executeBatch();
			updateRemarkPs.executeBatch();
			
			if(needDelIds!=null && needDelIds.length>0){
				String tempDelIds = "'";
				for(String id : needDelIds){
					tempDelIds = tempDelIds + id +"',";
				}
				tempDelIds = tempDelIds.substring(0, tempDelIds.length()-1);
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
					ARE.getLog().trace("����"+activeX_Ids[i]+ "�ı��Ϊ"+(i+1));
					retStr = retStr+"|"+activeX_Ids[i];
				}
				updatePageNumPs.executeBatch();
			}
			conn.commit();
		} catch (SQLException e) {
			ARE.getLog().error("����fileNetDocId����",e);
			return "";
		}finally{
			try {
				if(rs!=null) rs.close();
				if(queryTypePs!=null) queryTypePs.close();
				if(updateRemarkPs!=null) updateRemarkPs.close();
				if(updatePageNumPs!=null) updatePageNumPs.close();
				if(deleteOldDocPs!=null) deleteOldDocPs.close();
				if(insertDocPs!=null) insertDocPs.close();
				if(conn!=null) conn.close();
			} catch (SQLException e) { ARE.getLog().error("�ر����ݿ����ӳ���",e); }
		}
		retStr = retStr.length()>0?retStr.substring(1):"";
		ARE.getLog().trace(retStr);
		return retStr;
	}

}
