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
     * ѹ���ļ�(������Ŀ¼)  
     *   
     * @param baseDir  
     *            Ҫѹ�����ļ���(����·��)  
     * @param url  
     *           zip�ļ�����Ҫȥ���ľ���·��(����·��)  
     * @param fileName  
     *            ������ļ�����(�����ļ�·��)  
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
     * ָ�������ļ�ʱ ����·����ӵ�zipѹ������
     *	add by jli5 at 2014��9��16�� ����10:48:38
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
     * �������е��ļ����� zip ѹ��.
     *	add by jli5 at 2014��9��16�� ����10:38:46
     *	@param fileName
     *	@param url
     *	@param fileList
     * @throws FileNotFoundException 
     */
    public static void toZipFile(String fileName,List<File> fileList) throws Exception{
    	 ZipOutputStream zos = new ZipOutputStream(new FileOutputStream(fileName));   
         zos.setEncoding("gbk");//���ñ���,����������������   
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
        zos.setEncoding("gbk");//���ñ���,����������������   
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
        zos.setEncoding("gbk");//���ñ���,����������������   
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
     * ������Ŀ¼��������һ���ļ��������·��������zip�ļ��е�·��.  
     *   
     * @param baseDir  
     *            java.lang.String ��Ŀ¼  
     * @param realFileName  
     *            java.io.File ʵ�ʵ��ļ���  
     * @return ����ļ���  
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
     * ȡ��ָ��Ŀ¼�µ������ļ��б�������Ŀ¼.  
     *   
     * @param baseDir  
     *            File ָ����Ŀ¼  
     * @return ����java.io.File��List  
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
     * ��ѹ������. ��ZIP_FILENAME�ļ���ѹ��ZIP_DIRĿ¼��.  
     * @param zipFileName ZIP�ļ�����·��  
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
//        	fileMap.put(new File("F:\\�½��ļ���\\�½��ı��ĵ�.txt"), "������1.txt");
//        	fileMap.put(new File("F:\\�½��ļ���\\�½��ļ���\\rename.txt"), "������2.txt");
//        	
//        	
//        	 String url ="F:\\";
//        	 String fileName = "C:\\Users\\jli5\\test.zip";
//        	 toZipFile(fileName, fileMap);
//        	 System.out.println("ѹ�����");
        	 
        	 File f = new File("F:\\�½��ļ���\\�½��ı��ĵ�.txt");
        	 String name = f.getName();
        	 int a = name.lastIndexOf("/");
        			 int b =name.lastIndexOf(".");
        			 //��ȡ��׺����·��
        	 System.out.println(name.substring(name.lastIndexOf("."),name.length()));
        	
        } catch (Exception e) {   
            e.printStackTrace();   
        }   
    }   
  
}
