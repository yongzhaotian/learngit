package com.amarsoft.app.billions;
import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.apache.tools.zip.ZipEntry;
import org.apache.tools.zip.ZipFile;
import org.apache.tools.zip.ZipOutputStream;
public class ZipUtil {
	 /**  
     * 压缩文件(包括子目录)  
     *   
     * @param baseDir  
     *            要压缩的文件夹(物理路径)  
     * @param url  
     *           zip文件中需要去掉的绝对路径(物理路径)  
     * @param fileName  
     *            保存的文件名称(物理文件路径)  
     * @throws Exception  
     */  
    public static void zipFile(String baseDir,String url, String fileName)throws Exception {   
    	File file = new File(baseDir);
    	List<File> fileList = new ArrayList<File>();
    	if(file.isFile()){
    		fileList.add(file);
    	}else{
    		fileList = getSubFiles(file);
    	}
    	toZipFile(fileName, url, fileList);
    }   
  
    /**
     * 指定单个文件时 不把路径添加到zip压缩包中
     *	add by jli5 at 2014年9月16日 上午10:48:38
     *	@param baseDir
     *	@param fileName
     *	@throws Exception
     */
    public static void zipFile(String baseDir, String fileName)throws Exception {   
    	File file = new File(baseDir);
    	List<File> fileList = new ArrayList<File>();
    	String url = "";
    	if(file.isFile()){
    		fileList.add(file);
    		url = file.getParent();
    	}else{
    		fileList = getSubFiles(file);
    		url = baseDir;
    	}
    	toZipFile(fileName, url, fileList);
    }   
    
    /**
     * 将集合中的文件进行 zip 压缩.
     *	add by jli5 at 2014年9月16日 上午10:38:46
     *	@param fileName
     *	@param url
     *	@param fileList
     * @throws FileNotFoundException 
     */
    public static void toZipFile(String fileName,List<File> fileList) throws Exception{
    	 ZipOutputStream zos = new ZipOutputStream(new FileOutputStream(fileName));   
         zos.setEncoding("gbk");//设置编码,解决中文乱码的问题   
         ZipEntry ze = null;   
         byte[] buf = new byte[1024];   
         int readLen = 0;   
         for (int i = 0; i < fileList.size(); i++) {   
             File f = (File) fileList.get(i);   
             ze = new ZipEntry(getAbsFileName(f.getParent(), f));   
             ze.setSize(f.length());   
             ze.setTime(f.lastModified());   
             zos.putNextEntry(ze);   
             InputStream is = new BufferedInputStream(new FileInputStream(f));   
             while ((readLen = is.read(buf, 0, 1024)) != -1) {   
                 zos.write(buf, 0, readLen);   
             }   
             is.close();   
         }   
         zos.closeEntry();   
         zos.close();   
    }
    
    public static void toZipFile(String fileName,Map<File,String> fileMap) throws Exception{
   	 ZipOutputStream zos = new ZipOutputStream(new FileOutputStream(fileName));   
        zos.setEncoding("gbk");//设置编码,解决中文乱码的问题   
        ZipEntry ze = null;   
        byte[] buf = new byte[1024];   
        int readLen = 0;   
        Set<File> fileSet = fileMap.keySet();
        for (File f : fileSet) {
            ze = new ZipEntry(fileMap.get(f));   
            ze.setSize(f.length());   
            ze.setTime(f.lastModified());   
            zos.putNextEntry(ze);   
            InputStream is = new BufferedInputStream(new FileInputStream(f));   
            while ((readLen = is.read(buf, 0, 1024)) != -1) {   
                zos.write(buf, 0, readLen);   
            }   
            is.close();   
		}
        zos.closeEntry();   
        zos.close();   
   }
    
    
    private static void toZipFile(String fileName,String url,List<File> fileList) throws Exception{
   	 ZipOutputStream zos = new ZipOutputStream(new FileOutputStream(fileName));   
        zos.setEncoding("gbk");//设置编码,解决中文乱码的问题   
        ZipEntry ze = null;   
        byte[] buf = new byte[1024];   
        int readLen = 0;   
        for (int i = 0; i < fileList.size(); i++) {   
            File f = (File) fileList.get(i);   
            ze = new ZipEntry(getAbsFileName(url, f));   
            ze.setSize(f.length());   
            ze.setTime(f.lastModified());   
            zos.putNextEntry(ze);   
            InputStream is = new BufferedInputStream(new FileInputStream(f));   
            while ((readLen = is.read(buf, 0, 1024)) != -1) {   
                zos.write(buf, 0, readLen);   
            }   
            is.close();   
        }   
        zos.closeEntry();   
        zos.close();   
   }
    
    /**  
     * 给定根目录，返回另一个文件名的相对路径，用于zip文件中的路径.  
     *   
     * @param baseDir  
     *            java.lang.String 根目录  
     * @param realFileName  
     *            java.io.File 实际的文件名  
     * @return 相对文件名  
     */  
    private static String getAbsFileName(String baseDir, File realFileName) {   
        File real = realFileName;   
        File base = new File(baseDir);   
        String ret = real.getName();   
        while (true) {   
            real = real.getParentFile();   
            if (real == null)   
                break;   
            if (real.equals(base))   
                break;   
            else  
                ret = real.getName() + "/" + ret;   
        }   
        return ret;   
    }   
  
    /**  
     * 取得指定目录下的所有文件列表，包括子目录.  
     *   
     * @param baseDir  
     *            File 指定的目录  
     * @return 包含java.io.File的List  
     */  
    private static List<File> getSubFiles(File baseDir) {   
        List<File> ret = new ArrayList<File>();   
        if(baseDir.isFile()){//
        	ret.add(baseDir);
        } else{
            File[] tmp = baseDir.listFiles();   
            for (int i = 0; i < tmp.length; i++) {   
                if (tmp[i].isFile()){   
                    ret.add(tmp[i]);   
                }   
                if (tmp[i].isDirectory()){   
                    ret.addAll(getSubFiles(tmp[i]));   
                }   
            }  
        }
        return ret;   
    }   
  
    /**  
     * 解压缩功能. 将ZIP_FILENAME文件解压到ZIP_DIR目录下.  
     * @param zipFileName ZIP文件物理路径  
     * @param zipDir  
     * @throws Exception  
     */  
    @SuppressWarnings("unchecked")   
    public static void unZipFile(String zipFileName, String zipDir)throws Exception {   
        ZipFile zip = new ZipFile(zipFileName);   
        Enumeration<ZipEntry> en = zip.getEntries();   
        ZipEntry entry = null;   
        byte[] buffer = new byte[1024];   
        int length = -1;   
        InputStream input = null;   
        BufferedOutputStream bos = null;   
        File file = null;   
  
        while (en.hasMoreElements()) {   
            entry = (ZipEntry) en.nextElement();   
            if (entry.isDirectory()) {   
                file = new File(zipDir, entry.getName());   
                if (!file.exists()) {   
                    file.mkdir();   
                }   
                continue;   
            }   
  
            input = zip.getInputStream(entry);   
            file = new File(zipDir, entry.getName());   
            if (!file.getParentFile().exists()) {   
                file.getParentFile().mkdirs();   
            }   
            bos = new BufferedOutputStream(new FileOutputStream(file));   
  
            while (true) {   
                length = input.read(buffer);   
                if (length == -1){   
                    break;   
                }   
                bos.write(buffer, 0, length);   
            }   
            bos.close();   
            input.close();   
        }   
        zip.close();   
    }   
  
    public static void main(String[] args) {   
        try {   
//        	Map<File,String> fileMap = new HashMap<File, String>();
//        	fileMap.put(new File("F:\\新建文件夹\\新建文本文档.txt"), "重名名1.txt");
//        	fileMap.put(new File("F:\\新建文件夹\\新建文件夹\\rename.txt"), "重名名2.txt");
//        	
//        	
//        	 String url ="F:\\";
//        	 String fileName = "C:\\Users\\jli5\\test.zip";
//        	 toZipFile(fileName, fileMap);
//        	 System.out.println("压缩完成");
        	 
        	 File f = new File("F:\\新建文件夹\\新建文本文档.txt");
        	 String name = f.getName();
        	 int a = name.lastIndexOf("/");
        			 int b =name.lastIndexOf(".");
        			 //截取后缀名和路径
        	 System.out.println(name.substring(name.lastIndexOf("."),name.length()));
        	
        } catch (Exception e) {   
            e.printStackTrace();   
        }   
    }   
  
}
