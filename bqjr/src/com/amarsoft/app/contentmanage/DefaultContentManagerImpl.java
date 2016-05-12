package com.amarsoft.app.contentmanage;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Properties;

import com.amarsoft.are.ARE;
import com.amarsoft.are.lang.DateX;
import com.amarsoft.are.lang.StringX;
import com.amarsoft.awe.Configure;

/**
 * 缺省的内容管理实现类: 实现上传文档、下载文档、删除文档; 
 */
public class DefaultContentManagerImpl  implements ContentManager{
	private static String dbName = "als";
	//用于格式化日期
	private SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
	/*mimeTypes配置文件*/
	private static Properties mimeTypes= null;
	/*加载mimeTypes配置文件*/
	static{
		String filepath = ARE.getProperty("APP_HOME")+"/etc/MimeTypes.properties";
		mimeTypes =  new Properties();
		try {
			dbName = Configure.getInstance().getConfigure("DataSource");
			mimeTypes.load(new FileInputStream(filepath));
		} catch (IOException e) {
			ARE.getLog().error("load附件的MimeTypes配置出错", e);
		} catch (Exception e) {
			ARE.getLog().error("获取awe配置的dbName出错", e);
		}
	}
	@Override
	public Content get(String path) {
		if(StringX.isEmpty(path)) return null;
		Content content = null;
		File f = new File(path);
		if(f.exists() && f.isFile()){
			content = new Content();
			content.setId(path);
			content.setName(f.getName());
			content.setSize(f.length());
			content.setVersion("1");
			content.setCreateDate(sdf.format(new Date(f.lastModified())));
			content.setContentType(mimeTypes.getProperty(f.getName().substring(f.getName().lastIndexOf(".")+1)));
			//String desc = null;
			//Connection conn = null;
			//Query query = null;
			//ResultSet rs = null;
			//try {
				//conn = ARE.getDBConnection(dbName);
				//query = conn.createQuery("select remark from ECM_PAGE where documentId=:path").setParameter("path", path);
				//rs = query.getResultSet();
				//if(rs.next()){
					//desc = rs.getString("remark");
				//}
			//} catch (SQLException e1) {
				//e1.printStackTrace();
			//}finally{
				//try{
					//if(rs!=null) rs.close();
					//if(query!=null) query.close();
					//if(conn!=null) conn.close();
				//}catch(Exception e){ARE.getLog().trace("释放数据连接出错");}
			//}
			//content.setDesc(desc==null?"":desc);
			content.setDesc("");
			try {
				content.setInputStream(new FileInputStream(f));
			} catch (FileNotFoundException e) {
				e.printStackTrace();
			}
		}
		return content;
	}
	@Override
	public String save(Content content, int folderType) {
		if(content==null || 
				StringX.isEmpty(content.getId()) && content.getInputStream()==null ){return null;}
		String folderStr = null;
		String filePath = null;
		String today = DateX.format(new Date(), "yyyy/MM/dd");
		try {
			folderStr = Configure.getInstance().getConfigure("ImageFolder");
			if(StringX.isEmpty(folderStr)) {
				throw new Exception("当前使用缺省的内容管理实现类,但awe配置文件中未配置影像文件夹ImageFolder!");
			}
			folderStr = folderStr+"/"+today;
			File folder = new File(folderStr);
			if(! folder.exists()){
				folder.mkdirs();
			}
			filePath = folderStr+"/"+content.getName();
			File f = new File(filePath);
			FileOutputStream fos = new FileOutputStream(f);
			byte[] b = new byte[1024];
			int k = -1;
			while( (k=content.getInputStream().read(b)) >0){
				fos.write(b, 0, k);
			}
			content.getInputStream().close();
			fos.flush();
			fos.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return filePath;
	}
	
	@Override
	public boolean setDesc(String path, String desc ){
		return true;
	}
	@Override
	public boolean delete(String path) {
		File f = new File(path);
		if(f.exists()){
			f.delete();
		}
		return true;
	}
	@Override
	public String newVersion(String path, Content content) {
		return null;
	}
	@Override
	public List<Content> getAllVersions(String id) {
		return null;
	}
	
	@Override
	public boolean delAllVersion(String id) {
		return true;
	}
	

}
