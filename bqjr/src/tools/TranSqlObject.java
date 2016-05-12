/**
 * sql ת��SqlObject����
 * @author jbliu1
 * @date 20121126
 */
package tools;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.io.OutputStreamWriter;
import java.io.UnsupportedEncodingException;
import java.util.Calendar;
import java.util.Vector;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class TranSqlObject {
	private static String dirString = "/media/templet/jbliu1/temp/test";// �ļ���·��
	private static final String READ_CHARSET="GBK",WRITE_CHARSET="GBK";//��д�ļ�����
	private static OutputStreamWriter writer = null;//��־��¼
	private static BufferedWriter write = null;//��־��¼
	private static OutputStream os = null;
	private boolean hassSql = false;// �Ƿ������Ҫ���ĵ�sql
	private boolean isDebug = false;//�Ƿ�debugģʽ
	private static File logfile = null;//��־�ļ�
	private static java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyy/MM/dd HH:mm:ss:SSSS");
	//sql �� =XX �� ='XX' ƥ��
	private static Pattern fsqlPattern  = Pattern.compile("=\\s*'?\"\\s*\\+\\s*((\\w|\\.|\\(|\\)|\\*|/)*)\\s*\\+\\s*\"'?");
	//sql �� in XX �� in 'XX' ƥ��
	private static Pattern sqlPatternse = Pattern.compile("(,|\\()\\s*'?\"\\s*\\+\\s*((?:\\w|\\.|\\(|\\)|\\*|/)*)\\s*\\+\\s*\"'?(,|\\))");
	//��ȡ����� sql ���� ִ��ƥ��
	private static Pattern fsqlPattern1 = Pattern.compile("get(?:AS)?ResultSet\\s?\\((\\s?(\\w)*)\\s?\\)");
	//�������� sql ���� ִ��ƥ��
	private static Pattern fsqlPattern2 = Pattern.compile("executeSQL\\s?\\((\\s?(\\w)*)\\s?\\)");
	//ֱ�ӻ�ȡֵ sql ���� ִ��ƥ��
	private static Pattern fsqlPattern3 = Pattern.compile("Sqlca\\.get(?:String|Double|Int)\\s?\\((\\s?(\\w)*)\\s?\\)");
	private Matcher m = null ;//����ƥ����
	
	private final String fsql1 = ".*get(?:AS)?ResultSet.*";//��ȡ����� sql ִ��ƥ��
	private final String fsql2 = ".*\\.executeSQL\\s?\\(.*";//��������sqlִ��ƥ��
	private final String fsql3 = ".*Sqlca\\.get(String|Double|Int).*";//ֱ�ӻ�ȡֵsqlִ��ƥ��
	
	private String sFilename = "",sTempSql="";//�ļ������滻ǰsql
	private Vector<String> vPara = null;//sql �����滻������
	private Vector<String> vSql = null;//��ҳ���е�sql
	private Vector<String> vTempPage = null,vnTempPage = null;//��ʱҳ���ַ�
	private static TranSqlObject ts = new TranSqlObject();//
	
	private int iRow = 0,iTemp = 0,istart=0,iend=0;
	
	public static void main(String[] args) {
		
		File files = new File(dirString);
		// ������־����ļ�
		logfile = new File(files.getParentFile().getPath(), "transsqllog.txt");
		try {
			os = new FileOutputStream(logfile, false);
			writer = new OutputStreamWriter(os,WRITE_CHARSET);
			write = new BufferedWriter(writer);
			Calendar c = Calendar.getInstance();
			System.out.println(sdf.format(c.getTime())	+ "-----------------���̶�ȡ��ʼ-----------------");
			Long ltime = System.nanoTime();
			c = Calendar.getInstance();
			// ��ȡ�ļ�
			ts.readfilePath(files);
			System.out.println(sdf.format(c.getTime()) + "-----------------���̶�ȡ����-----------------"	+ (System.nanoTime() - ltime) / 1000000000.0D + "s");
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		}finally{
	    	try {
				write.close();
				writer.close();
				os.close();
			} catch (IOException e) {
				e.printStackTrace();
			}			
		}
		
	}

	/**
	 * ѭ����ȡ�ļ�
	 * 
	 * @param files
	 */
	public void readfilePath(File files) {
		if (files.isFile()) {
			// ��ȡ�ļ�,ֻ��ȡjsp�ļ���java�ļ���������������������ټ��ϼ���
			if (files.getName().endsWith("jsp")||files.getName().endsWith("java"))
				readfile(files);
		} else {
			File file[] = files.listFiles();
			for (File f : file) {
				readfilePath(f);
			}
		}
	}

	/**
	 * ��¼��־
	 * @throws IOException 
	 */
	public void writelog(String slog){
		try {
			slog = new String(slog.getBytes(READ_CHARSET),WRITE_CHARSET);
//			System.out.println(slog);
			write.append(slog);
			write.newLine();	
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
	
	/**
	 * �滻ֱ�ӻ�ȡֵ��sql
	 * @param read
	 * @param stemp
	 * @return
	 * @throws IOException
	 */
	private boolean getdSql(BufferedReader read,String stemp) throws IOException{
		int icount=0;
		boolean breturn = false;
		String sOut = "", sVars= "",sTpara = "";
		if(m.find()){
			sVars = m.group(1);
			if(!vSql.contains(sVars)) vSql.add(sVars);
			vTempPage.add(stemp);
			breturn = true;
		} else if(stemp.indexOf("\"")!=-1){
			if(stemp.indexOf("%>") == -1){//JSP�е����
				while (!stemp.endsWith(";")) {
					if (stemp.trim().equals("") || stemp.trim().startsWith("//")) {// ע�ͺͿ��в���Ҫͳ��
						vTempPage.add(stemp);
						stemp = read.readLine();
						iRow++;
						continue;
					}
					if (stemp.trim().indexOf("/*") != -1) {// ע�Ͳ���Ҫͳ��
						while (stemp.trim().indexOf("*/") == -1) {
							vTempPage.add(stemp);
							stemp = read.readLine();
							if (stemp == null) {
								ts.writelog("-------�ļ���" + sFilename	+ "--------------------ע�Ͳ�����--------");
								break;
							}
							iRow++;
						}
						vTempPage.add(stemp);
						stemp = read.readLine();
						iRow++;
						continue;
					}
					iTemp = stemp.indexOf("//");// ע�Ͳ���Ҫͳ��
					if (iTemp != -1)
						stemp = stemp.substring(0, iTemp).trim();
		
					sOut += stemp;
					if(isDebug){
						ts.writelog(iRow+" : getdSql()=="+stemp);
					}
					stemp = read.readLine().trim();
				}
			}
			if(isDebug){
				ts.writelog(iRow+" : getdSql()=="+stemp);
			}
			sOut += stemp;
			sTempSql = "//old=getdSql=="+sOut;
			
			istart = sOut.indexOf("(")+1;
			iend = sOut.lastIndexOf(")");
			stemp = sOut.substring(0,istart);
			sOut = sOut.substring(istart,iend);
			StringBuffer sb = new StringBuffer(),sbtemp = new StringBuffer();
			m = fsqlPattern.matcher(sOut);//"=\\s*'?\"\\s*\\+\\s*((\\w|\\.|\\(|\\))*)\\s*\\+\\s*\"'?"
			while(m.find()){
				sTpara = m.group(1);
//				if(vPara.contains(sTpara)){
//					ts.writelog("[error]��Ҫ�ı�������ƣ�"+sTpara.replaceAll("\\W", ""));
//				}
				vPara.add(sTpara);
				m.appendReplacement(sb, "=:"+sTpara.replaceAll("\\W", "")+icount++);
			}
			m.appendTail(sb);
			m = sqlPatternse.matcher(sb.toString());
			sb = new StringBuffer();
			while(m.find()){
				sTpara = m.group(2);
//				if(vPara.contains(sTpara)){
//					ts.writelog("[error]��Ҫ�ı�������ƣ�"+sTpara.replaceAll("\\W", ""));
//				}
				vPara.add(sTpara);
				m.appendReplacement(sb, m.group(1)+":"+sTpara.replaceAll("\\W", "")+icount+++m.group(3));
			}
			m.appendTail(sb);
	
			m = sqlPatternse.matcher(sb.toString());
			sb = new StringBuffer();
			while(m.find()){
				sTpara = m.group(2);
//				if(vPara.contains(sTpara)){
//					ts.writelog("[error]��Ҫ�ı�������ƣ�"+sTpara.replaceAll("\\W", ""));
//				}
				vPara.add(sTpara);
				m.appendReplacement(sb, m.group(1)+":"+sTpara.replaceAll("\\W", "")+icount+++m.group(3));
			}
			m.appendTail(sb);
			
			sbtemp.append(stemp).append("new SqlObject(").append(sb.toString()).append(")");
			for(int i=0;i<vPara.size();i++){
				stemp = vPara.get(i);
				sbtemp.append(".setParameter(\"").append(stemp.replaceAll("\\W", "")).append(i).append("\",").append(stemp).append(")");
			}
			vPara.removeAllElements();
			sOut = sbtemp.append(");").toString();
	
			ts.writelog(sTempSql);
			ts.writelog("changesql=="+sOut);
			
			String sOutT[] = sOut.split("\\+");
			for(int i = 0;i<sOutT.length;i++){
				if(i==sOutT.length-1)vTempPage.add(sOutT[i]);	
				else vTempPage.add(sOutT[i]+" +");
			}
			breturn = true;
		}else{
			breturn = false;
		}
		return breturn;
	}
	
	/**
	 * �滻 ������ֵ��sql
	 * @param stemp
	 * @param j
	 * @return
	 * @throws UnsupportedEncodingException 
	 */
	private int getsSql(String stemp,int j){
		int icount = 0;
		String sOut = "",sTpara="";
		vPara.removeAllElements();
			while (!stemp.endsWith(";")) {
				if (stemp.trim().equals("") || stemp.trim().startsWith("//")) {// ע�ͺͿ��в���Ҫͳ��
					vTempPage.add(stemp);
					stemp = vnTempPage.get(++j);
					continue;
				}
				if (stemp.trim().indexOf("/*") != -1) {// ע�Ͳ���Ҫͳ��
					while (stemp.trim().indexOf("*/") == -1) {
						vTempPage.add(stemp);
						stemp = vnTempPage.get(++j);
						if (stemp == null) {
							ts.writelog("-------�ļ���" + sFilename	+ "--------------------ע�Ͳ�����--------");
							break;
						}
					}
					vTempPage.add(stemp);
					stemp = vnTempPage.get(++j);
					continue;
				}
				iTemp = stemp.indexOf("//");// ע�Ͳ���Ҫͳ��
				if (iTemp != -1)
					stemp = stemp.substring(0, iTemp).trim();

				sOut += stemp;
				if(isDebug){
					ts.writelog(iRow+" : getdSql()=="+stemp);
				}
				stemp = vnTempPage.get(++j);
			}

			if(isDebug){
				ts.writelog(iRow+" : getdSql()=="+stemp);
			}
		sOut += stemp;
		sTempSql = "//old=getsSql=="+sOut;
		if(sOut.toUpperCase().indexOf("SELECT ")!=-1){
			istart = sOut.toUpperCase().indexOf(" FROM ")+6;
		}else if(sOut.toUpperCase().indexOf("INSERT ")!=-1){
			istart = sOut.toUpperCase().indexOf("(",sOut.toUpperCase().indexOf("(")+1)+1;
		}else{
			istart = sOut.indexOf("(")+1;
		}
		iend = sOut.length()-1;
		stemp = sOut.substring(0,istart);
		sOut = sOut.substring(istart,iend);
		StringBuffer sb = new StringBuffer();
		m = fsqlPattern.matcher(sOut);//"=\\s*'?\"\\s*\\+\\s*((\\w|\\.|\\(|\\))*)\\s*\\+\\s*\"'?"
		while(m.find()){
			sTpara = m.group(1);
//			if(vPara.contains(sTpara)){
//				ts.writelog("[error]��Ҫ�ı�������ƣ�"+sTpara.replaceAll("\\W", ""));
//			}
			vPara.add(sTpara);
			m.appendReplacement(sb, "=:"+sTpara.replaceAll("\\W", "")+icount++);
		}
		m.appendTail(sb);

		m = sqlPatternse.matcher(sb.toString());
		sb = new StringBuffer();
		while(m.find()){
			sTpara = m.group(2);
//			if(vPara.contains(sTpara)){
//				ts.writelog("[error]��Ҫ�ı�������ƣ�"+sTpara.replaceAll("\\W", ""));
//			}
			vPara.add(sTpara);
			m.appendReplacement(sb, m.group(1)+":"+sTpara.replaceAll("\\W", "")+icount+++m.group(3));
		}
		m.appendTail(sb);

		//����ƥ���������˱߽磬������Ҫ�ڶ���ƥ��
		m = sqlPatternse.matcher(sb.toString());
		sb = new StringBuffer();
		while(m.find()){
			sTpara = m.group(2);
//			if(vPara.contains(sTpara)){
//				ts.writelog("[error]��Ҫ�ı�������ƣ�"+sTpara.replaceAll("\\W", ""));
//			}
			vPara.add(sTpara);
			m.appendReplacement(sb, m.group(1)+":"+sTpara.replaceAll("\\W", "")+icount+++m.group(3));
		}
		m.appendTail(sb);
		
		sOut = stemp +sb.append(";").toString();

		ts.writelog(sTempSql);
		ts.writelog("changesql=="+sOut);
		
		String sOutT[] = sOut.split("\\+");
		for(int i = 0;i<sOutT.length;i++){
			if(i==sOutT.length-1)vTempPage.add(sOutT[i]);	
			else vTempPage.add(sOutT[i]+" +");
		}	
		
		return j;
	}
	
	/**
	 * ��д�ļ�
	 * @param file
	 */
	private void writeOut(File file){
		 OutputStreamWriter awriter = null;
		 BufferedWriter awrite = null;
		 OutputStream aos = null;

		 try {
			aos = new FileOutputStream(file,false);
			 awriter = new  OutputStreamWriter(aos,WRITE_CHARSET);
			 awrite =new BufferedWriter(awriter);
				for(int i=0;i<vTempPage.size();i++){
					awrite.append(new String(vTempPage.get(i).getBytes(READ_CHARSET),WRITE_CHARSET));
					awrite.newLine();
				}
			  awrite.flush();
		} catch (FileNotFoundException e) {
		      System.out.println("�ļ�[" + file.getAbsolutePath() + "] ������!");
		      e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}finally{
	    	try {
				awrite.close();
				awriter.close();
				aos.close();
			} catch (IOException e) {
				e.printStackTrace();
			}
	    }
	}
	
	
	/**
	 * ��ȡ�����ļ�
	 * 
	 * @param file
	 *            �ļ�����
	 */
	private void readfile(File file) {

		//��ʼ��
		iRow = 0;
		vSql = new Vector<String>();
		vPara = new Vector<String>() ;
		vTempPage = new Vector<String>();
		vnTempPage = new Vector<String>();
		String  sTemp="",str="";
		
		BufferedReader read = null;
		//===============================���ȶ�ȡ�ļ�������ֱ��ִ��sql====================
		try {
			// ֻ�����·������
			sFilename = file.getPath();
			ts.writelog("========�ļ���======"+sFilename);
			read = new BufferedReader(new InputStreamReader(new FileInputStream(file),WRITE_CHARSET));
			str = read.readLine();
			iRow++;

			while (str != null) {
				if (str.trim().equals("") || str.trim().startsWith("//")) {// ע�ͺͿ��в���Ҫͳ��
					vTempPage.add(str);
					str = read.readLine();
					iRow++;
					continue;
				}
				if (str.trim().indexOf("/*") != -1) {// ע�Ͳ���Ҫͳ��
					while (str.trim().indexOf("*/") == -1) {
						vTempPage.add(str);
						str = read.readLine();
						if (str == null) {
							ts.writelog("-------�ļ���" + sFilename+ "--------------------ע�Ͳ�����--------");
							break;
						}
						iRow++;
					}
					vTempPage.add(str);
					str = read.readLine();
					iRow++;
					continue;
				}

				iTemp = str.indexOf("//");// ע�Ͳ���Ҫͳ��
				sTemp = str;
				if (iTemp != -1)
					sTemp = sTemp.substring(0, iTemp).replaceAll("\\s*$", "");
				if(sTemp.matches(fsql1)){//.*get(?:AS?)ResultSet.*
					hassSql = true;
					m = fsqlPattern1.matcher(sTemp);
					if(!getdSql(read,sTemp)) vTempPage.add(str);
				}else if(sTemp.matches(fsql3)){//.*Sqlca\\.get(String|Double|Int).*
					hassSql = true;
					m = fsqlPattern3.matcher(sTemp);
					if(!getdSql(read,sTemp)) vTempPage.add(str);			
				}else if(sTemp.matches(fsql2)){//.*\\.executeSQL\\s?\\(.*
					hassSql = true;
					m = fsqlPattern2.matcher(sTemp);
					if(!getdSql(read,sTemp)) vTempPage.add(str);			
				}else{
					vTempPage.add(str);
				}				
				str = read.readLine();
				iRow++;
			}


		} catch (FileNotFoundException e) {
			ts.writelog("�ļ�[" + file.getAbsolutePath() + "] ������!");
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		} catch (Exception e) {
			hassSql = false;//�����򲻸���ԭ��������
			e.printStackTrace();
			ts.writelog("[error] == [" +sFilename + "] ֱ��sql�滻�����������ֹ��滻!");
		}finally {
			try {
				read.close();
			} catch (Exception e) {
				e.printStackTrace();
			}
		}

		//===============================�ٴδ����ñ�����ֵ��sql====================
		
		try {
			for(int i=0;i<vSql.size();i++){
				boolean bhas = false;
				vPara.removeAllElements();
				vnTempPage = (Vector<String>) vTempPage.clone();
				vTempPage.removeAllElements();
				String svarsql=vSql.get(i);
				String smakeSql = "\\s*"+svarsql+"\\s*=\\s*\".*";
				String sNotmake = ".*\\s*"+svarsql+"\\s*=\\s*(\"{2})\\s*;.*";
				String squitsql1 = "\\s*"+svarsql+"\\s*\\+=.*";
				String squitsql2 = "\\s*"+svarsql+"\\s*\\=\\s*"+svarsql+"\\s*\\+.*";
				for(int j=0;j<vnTempPage.size();j++){
					str = vnTempPage.get(j);
					if (str.trim().equals("") || str.trim().startsWith("//")) {// ע�ͺͿ��в���Ҫͳ��
						vTempPage.add(str);
						continue;
					}
					if (str.trim().indexOf("/*") != -1) {// ע�Ͳ���Ҫͳ��
						while (str.trim().indexOf("*/") == -1) {
							vTempPage.add(str);
							str = vnTempPage.get(++j);
							if (str == null) {
								ts.writelog("-------�ļ���" + sFilename+ "--------------------ע�Ͳ�����--------");
								break;
							}
						}
						vTempPage.add(str);
						continue;
					}
					iTemp = str.indexOf("//");// ע�Ͳ���Ҫͳ��
					sTemp = str;
					if (iTemp != -1)
						sTemp = sTemp.substring(0, iTemp).replaceAll("\\s*$", "");
					if(sTemp.matches(smakeSql) && !sTemp.matches(sNotmake)){
						if(vPara.size()>0){
							ts.writelog("[error] �������"+vSql.get(i)+"��θ�ֵ����Ҫע�����");
						}
						if(sTemp.indexOf("=:")!=-1){//�Ѿ�������
							vTempPage.add(str);	
						}else{
							bhas = true;
							j=getsSql(sTemp,j);
						}
					}else if(sTemp.matches(squitsql1)||sTemp.matches(squitsql2)){
						vTempPage.add(str);
						ts.writelog("[error] ��䡾"+str+"������ֵ���ģ���Ҫע�����");

					}else if(bhas && sTemp.matches(".*\\.(\\w)*\\(\\s*"+svarsql+"\\s*\\).*")){
						String sOut="",stemp="";
						istart = sTemp.indexOf("(")+1;
						iend = sTemp.lastIndexOf(")");
						stemp = sTemp.substring(0,istart);
						sOut = sTemp.substring(iend); 
						StringBuffer sbtemp = new StringBuffer();
						sbtemp.append(stemp).append("new SqlObject(").append(svarsql).append(")");
						for(int k=0;k<vPara.size();k++){
							stemp = vPara.get(k);
							sbtemp.append(".setParameter(\"").append(stemp.replaceAll("\\W", "")).append(k).append("\",").append(stemp).append(")");
						}
						sbtemp.append(sOut);
						vPara.removeAllElements();
						sOut = sbtemp.toString();
						ts.writelog("ssql out ==="+sOut);
						vTempPage.add(sOut);							
					}else{
						vTempPage.add(str);						
					}					
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
			hassSql = false;//�����򲻸���ԭ��������
			ts.writelog("[error] == [" +sFilename + "] ����sql �滻�����������ֹ��滻!");
		}
		

		//===============================������====================
		
		if(hassSql){//����滻��sql����Ҫ��������ļ�
			writeOut(file);
		}

	}
}
