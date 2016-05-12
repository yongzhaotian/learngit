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
 * ���Լ��ܵ��뵼��
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
	 * ��������
	 * @param queryObjects ��ѯ��������
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
					String sJbo = ObjectConverts.getString(obj);//���ɼ��ܺ��jbo�ַ���
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
	 * ��������
	 * @param data
	 * @param countsҪ��ȡ�ļ�¼����,��ʽΪ<jbo��,[��ʼ��¼��,��¼��]>�����[��ʼ��¼��,��¼��]Ϊnull��ʾȫ��¼
	 * @return HashMap<jbo��,jbo������>����
	 * @throws Exception
	 */
	public HashMap<String,List<BizObject>> importData(InputStream data,HashMap<String,int[]> counts)throws Exception{
		HashMap<String,List<BizObject>> result = new HashMap<String,List<BizObject>>();
		java.util.zip.ZipInputStream zis = new ZipInputStream(data);
		ZipEntry z = zis.getNextEntry();
		while(z!=null){
			String sTempName = z.getName();
			int iDot = sTempName.indexOf(".");
			//��ü�¼����
			int iRowCount = 0;
			try{
				iRowCount = Integer.parseInt(sTempName.substring(0, iDot));
			}
			catch(Exception e){throw new Exception("��Ч���ļ���ʽ");}
			String sJboName = sTempName.substring(iDot+1);//����ļ�������jboȫ��
			//���ü�¼��
			getRowCounts().put(sJboName,iRowCount);
			//byte[] extradata = z.getExtra();//��ý�ѹ������
			BufferedReader reader = new BufferedReader (new InputStreamReader(zis));
			List<BizObject> list = new ArrayList<BizObject>();
			//һ��һ�ж�����
			String str =reader.readLine();
			long iCurrentLine = 0;
			long iFirstLine = 0;
			long iLastLine = Long.MAX_VALUE;
			//����counts�����ȡ����
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
