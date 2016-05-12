package com.amarsoft.app.awe.framecase.dw;
import java.io.BufferedReader;
import java.io.ByteArrayOutputStream;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.zip.ZipEntry;
import java.util.zip.ZipOutputStream;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.awe.util.ObjectConverts;
import java.util.zip.*;
/**
 * 测试加密导入导出
 * */
public class DemoImpExpEncryption {
	
	private HashMap<String,Integer> rowCounts = new HashMap<String,Integer>();
	
	public HashMap<String,Integer> getRowCounts(){
		return rowCounts;
	}
	
	public int getRowCount(String jboName){
		if(rowCounts.containsKey(jboName)){
			return rowCounts.get(jboName);
		}
		else
			return 0;
	}
	
	/**
	 * 导出数据
	 * @param queryObjects 查询对象数组
	 * @return
	 */
	public byte[] exportData(BizObjectQuery[] queryObjects)throws Exception{
		ByteArrayOutputStream baOuputStrema = new ByteArrayOutputStream();
		ZipOutputStream zipOutStream = new ZipOutputStream( baOuputStrema);
		for(int i=0;i<queryObjects.length;i++){
			int iRowCount = queryObjects[i].getTotalCount();
			List<BizObject> searchResults = queryObjects[i].getResultList(true);
			String sFileName =iRowCount+"."+ queryObjects[i].getBizObjectClass().getAbsoluteName();
			StringBuffer sbTemp = new StringBuffer();
			if(searchResults!=null){
				for(BizObject obj : searchResults){	
					String sJbo = ObjectConverts.getString(obj);//生成加密后的jbo字符串
					if(sbTemp.length()==0)
						sbTemp.append(sJbo);
					else
						sbTemp.append("\r\n"+sJbo);
				}
			}
			zipOutStream.putNextEntry(new ZipEntry(sFileName));
			zipOutStream.write(sbTemp.toString().getBytes("GBK"));	
		}
		zipOutStream.close();
		byte[] result = baOuputStrema.toByteArray();
		baOuputStrema.close();
		return result;
	}
	/**
	 * 导入数据
	 * @param data
	 * @param counts要获取的记录参数,格式为<jbo名,[起始记录号,记录数]>，如果[起始记录号,记录数]为null表示全记录
	 * @return HashMap<jbo名,jbo数据数>队列
	 * @throws Exception
	 */
	public HashMap<String,List<BizObject>> importData(InputStream data,HashMap<String,int[]> counts)throws Exception{
		HashMap<String,List<BizObject>> result = new HashMap<String,List<BizObject>>();
		java.util.zip.ZipInputStream zis = new ZipInputStream(data);
		ZipEntry z = zis.getNextEntry();
		while(z!=null){
			String sTempName = z.getName();
			int iDot = sTempName.indexOf(".");
			//获得记录条数
			int iRowCount = 0;
			try{
				iRowCount = Integer.parseInt(sTempName.substring(0, iDot));
			}
			catch(Exception e){throw new Exception("无效的文件格式");}
			String sJboName = sTempName.substring(iDot+1);//获得文件名，即jbo全名
			//设置记录数
			getRowCounts().put(sJboName,iRowCount);
			//byte[] extradata = z.getExtra();//获得解压缩数据
			BufferedReader reader = new BufferedReader (new InputStreamReader(zis));
			List<BizObject> list = new ArrayList<BizObject>();
			//一行一行读数据
			String str =reader.readLine();
			long iCurrentLine = 0;
			long iFirstLine = 0;
			long iLastLine = Long.MAX_VALUE;
			//根据counts计算获取条数
			if(counts!=null && counts.containsKey(sJboName)){
				int[] counsValue = counts.get(sJboName);
				iFirstLine = counsValue[0];
				iLastLine = iFirstLine + counsValue[1] - 1;
			}
			while(str != null){
				if(iCurrentLine>=iFirstLine &&  iCurrentLine<=iLastLine){
					BizObject obj = (BizObject)ObjectConverts.getObject(str);
					list.add(obj);
				}
				str = reader.readLine();
				iCurrentLine++;
			}
			result.put(sJboName,list);
			zis.closeEntry();
			z = zis.getNextEntry();
		}
		zis.close();
		return result;
	}
}
