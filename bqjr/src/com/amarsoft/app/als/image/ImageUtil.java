package com.amarsoft.app.als.image;

import java.awt.AlphaComposite;
import java.awt.Graphics2D;
import java.awt.Image;
import java.awt.RenderingHints;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.FileOutputStream;
import java.io.OutputStream;
import java.sql.SQLException;

import javax.imageio.ImageIO;
import javax.swing.ImageIcon;

import com.amarsoft.are.ARE;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.drew.imaging.ImageMetadataReader;
import com.drew.metadata.Directory;
import com.drew.metadata.Metadata;
import com.drew.metadata.exif.ExifIFD0Directory;

public class ImageUtil {
	private String startWithId ;
	//path of bqjr logo
	private static final String LOGO_PATH = ImageUtil.class.getResource("/").getPath()+"/bqjr_logo.png";
	public String GetNewTypeNo( Transaction sqlca ) throws SQLException{
		String sRes = "", sFilter = "";
//		sFilter = "'"+ startWithId + "%'";
		String sMax = sqlca.getString( new SqlObject( "Select Max(TypeNo) From ECM_IMAGE_TYPE " ) );
		if( sMax != null && sMax.length() != 0 ){
			sRes = String.valueOf( Integer.parseInt( sMax ) + 1 );
		}
		return sRes;
	}

	public String getStartWithId() {
		return startWithId;
	}
	public void setStartWithId(String startWithId) {
		this.startWithId = startWithId;
	}
	
	public static void addWaterMarkWithBQLogo(String imgPath){
		 OutputStream os = null;   
	        try {   
	            Image srcImg = ImageIO.read(new File(imgPath));   
	  
	            BufferedImage buffImg = new BufferedImage(srcImg.getWidth(null),   
	                    srcImg.getHeight(null), BufferedImage.TYPE_INT_RGB);   
	  
	            Graphics2D g = buffImg.createGraphics();   
	  
	            g.setRenderingHint(RenderingHints.KEY_INTERPOLATION,   
	                    RenderingHints.VALUE_INTERPOLATION_BILINEAR);   
	  
	            g.drawImage(srcImg.getScaledInstance(srcImg.getWidth(null), srcImg   
	                    .getHeight(null), Image.SCALE_SMOOTH), 0, 0, null);   
	            
	            g.rotate(Math.toRadians(Math.random()*40),     
	                    (double) buffImg.getWidth() / 2, (double) buffImg     
	                            .getHeight() / 2);
	            
	            ImageIcon imgIcon = new ImageIcon(LOGO_PATH);   
	            Image img = imgIcon.getImage();  
	  
	            float alpha = 0.15f; // 透明度   
	            g.setComposite(AlphaComposite.getInstance(AlphaComposite.SRC_ATOP,   
	                    alpha));   
	  
	            // 表示水印图片的位置   
	            g.drawImage(img, (buffImg.getWidth()-img.getWidth(null)) / 2, (buffImg.getHeight()-img.getHeight(null)) / 2, null);   
	  
	            int imgWidth = buffImg.getWidth();
	            int imgHeight = buffImg.getHeight();
	            int logoWidth = img.getWidth(null);
	            int logoHeight = img.getHeight(null);
	            int xPosition = (int)(Math.random()*30+20);
	            int yPosition = (int)(Math.random()*30+20);
	            while(true){
	            	 g.drawImage(img, xPosition, yPosition, null);
	            	 if(xPosition+20>imgWidth){
	            		 xPosition=0;
	            		 yPosition =yPosition+ logoHeight+30;
	            	 }else{
	            		 xPosition =xPosition+ logoWidth+30;
	            	 }
	            	 if(xPosition>imgWidth && yPosition>imgHeight)break;
	            }  
	      	  
	            g.setComposite(AlphaComposite.getInstance(AlphaComposite.SRC_OVER));
	            g.dispose();
	            
	  
	            os = new FileOutputStream(imgPath);   
	  
	            ImageIO.write(buffImg, "JPG", os);   
	  
	        } catch (Exception e) {   
	            e.printStackTrace();   
	        } finally {   
	            try {   
	                if (null != os)   
	                    os.close();   
	            } catch (Exception e) {   
	                e.printStackTrace();   
	            }   
	        }   
	}
		/**
	 * 简单校验图片是否经过PS
	 * @param  sfileName,
	 * @return
	 */
	public static String isPhotoProcessing(String sfileName,Transaction Sqlca,String objectNo){
		
		String prefix = getFileNamePrefix(sfileName);
		String flag = "";
		String sql = "select software_name as softwareName from Image_processing_software t where t.is_inuse = 1";
		String sql2 = "insert into business_contract_ps (serialno,is_image_processed)values (:serialno, :isImageProcessed)";
		try {
			if(!"jpg".equalsIgnoreCase(prefix) && !"jpeg".equalsIgnoreCase(prefix)){
				flag = "3";
			}else{
				int indexValue = -1;
				String softName = "";
				String tempName = "";
				File tempFile = new File(sfileName);
				ASResultSet rs;
				Metadata metadata = ImageMetadataReader.readMetadata(tempFile); 
				for (Directory directory : metadata.getDirectories()) { 
					if(directory.containsTag(ExifIFD0Directory.TAG_SOFTWARE)){
						softName = directory.getDescription(ExifIFD0Directory.TAG_SOFTWARE);
						ARE.getLog().info("softName============"+softName);
					}
				}
				if(softName == null || "".equals(softName.trim())){
					flag = "2";
				}else{
					softName = softName.toLowerCase();
					rs = Sqlca.getASResultSet(new SqlObject(sql));
					while(rs.next()){
						tempName = rs.getString("softwareName");
						if(tempName != null && !"".equals(tempName.trim())){
							tempName = tempName.toLowerCase();
						}
						indexValue = softName.indexOf(tempName);
						if(indexValue != -1){
							flag = "1";
							break;
						}
					}
					if(indexValue == -1){
						flag = "2";
					}
				}
			}
			
			Sqlca.executeSQL(new SqlObject(sql2).setParameter("serialno", objectNo).setParameter("isImageProcessed", flag));
		} catch (Exception e) {
			ARE.getLog().error("校验客户现场照片失败", e);
		}
		return flag;
	}
	
	public static String getFileNamePrefix(String sFileName){
		File tempFile = new File(sFileName);
		String fileName = tempFile.getName();
	    String prefix=fileName.substring(fileName.lastIndexOf(".")+1);
		return prefix;
	}
	
}
