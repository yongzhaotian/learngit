/**
 * sql 转换SqlObject工具
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
	private static String dirString = "/media/templet/jbliu1/temp/test";// 文件的路径
	private static final String READ_CHARSET="GBK",WRITE_CHARSET="GBK";//读写文件编码
	private static OutputStreamWriter writer = null;//日志记录
	private static BufferedWriter write = null;//日志记录
	private static OutputStream os = null;
	private boolean hassSql = false;// 是否存在需要更改的sql
	private boolean isDebug = false;//是否debug模式
	private static File logfile = null;//日志文件
	private static java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyy/MM/dd HH:mm:ss:SSSS");
	//sql 中 =XX 或 ='XX' 匹配
	private static Pattern fsqlPattern  = Pattern.compile("=\\s*'?\"\\s*\\+\\s*((\\w|\\.|\\(|\\)|\\*|/)*)\\s*\\+\\s*\"'?");
	//sql 中 in XX 或 in 'XX' 匹配
	private static Pattern sqlPatternse = Pattern.compile("(,|\\()\\s*'?\"\\s*\\+\\s*((?:\\w|\\.|\\(|\\)|\\*|/)*)\\s*\\+\\s*\"'?(,|\\))");
	//获取结果集 sql 变量 执行匹配
	private static Pattern fsqlPattern1 = Pattern.compile("get(?:AS)?ResultSet\\s?\\((\\s?(\\w)*)\\s?\\)");
	//插入或更新 sql 变量 执行匹配
	private static Pattern fsqlPattern2 = Pattern.compile("executeSQL\\s?\\((\\s?(\\w)*)\\s?\\)");
	//直接获取值 sql 变量 执行匹配
	private static Pattern fsqlPattern3 = Pattern.compile("Sqlca\\.get(?:String|Double|Int)\\s?\\((\\s?(\\w)*)\\s?\\)");
	private Matcher m = null ;//公用匹配器
	
	private final String fsql1 = ".*get(?:AS)?ResultSet.*";//获取结果集 sql 执行匹配
	private final String fsql2 = ".*\\.executeSQL\\s?\\(.*";//插入或更新sql执行匹配
	private final String fsql3 = ".*Sqlca\\.get(String|Double|Int).*";//直接获取值sql执行匹配
	
	private String sFilename = "",sTempSql="";//文件名，替换前sql
	private Vector<String> vPara = null;//sql 中所替换变量集
	private Vector<String> vSql = null;//该页面中到sql
	private Vector<String> vTempPage = null,vnTempPage = null;//临时页面字符
	private static TranSqlObject ts = new TranSqlObject();//
	
	private int iRow = 0,iTemp = 0,istart=0,iend=0;
	
	public static void main(String[] args) {
		
		File files = new File(dirString);
		// 创建日志输出文件
		logfile = new File(files.getParentFile().getPath(), "transsqllog.txt");
		try {
			os = new FileOutputStream(logfile, false);
			writer = new OutputStreamWriter(os,WRITE_CHARSET);
			write = new BufferedWriter(writer);
			Calendar c = Calendar.getInstance();
			System.out.println(sdf.format(c.getTime())	+ "-----------------工程读取开始-----------------");
			Long ltime = System.nanoTime();
			c = Calendar.getInstance();
			// 读取文件
			ts.readfilePath(files);
			System.out.println(sdf.format(c.getTime()) + "-----------------工程读取结束-----------------"	+ (System.nanoTime() - ltime) / 1000000000.0D + "s");
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
	 * 循环读取文件
	 * 
	 * @param files
	 */
	public void readfilePath(File files) {
		if (files.isFile()) {
			// 读取文件,只读取jsp文件和java文件，如果还有其他，可以再加上即可
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
	 * 记录日志
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
	 * 替换直接获取值的sql
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
			if(stemp.indexOf("%>") == -1){//JSP中的情况
				while (!stemp.endsWith(";")) {
					if (stemp.trim().equals("") || stemp.trim().startsWith("//")) {// 注释和空行不需要统计
						vTempPage.add(stemp);
						stemp = read.readLine();
						iRow++;
						continue;
					}
					if (stemp.trim().indexOf("/*") != -1) {// 注释不需要统计
						while (stemp.trim().indexOf("*/") == -1) {
							vTempPage.add(stemp);
							stemp = read.readLine();
							if (stemp == null) {
								ts.writelog("-------文件：" + sFilename	+ "--------------------注释不完整--------");
								break;
							}
							iRow++;
						}
						vTempPage.add(stemp);
						stemp = read.readLine();
						iRow++;
						continue;
					}
					iTemp = stemp.indexOf("//");// 注释不需要统计
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
//					ts.writelog("[error]需要改变参数名称："+sTpara.replaceAll("\\W", ""));
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
//					ts.writelog("[error]需要改变参数名称："+sTpara.replaceAll("\\W", ""));
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
//					ts.writelog("[error]需要改变参数名称："+sTpara.replaceAll("\\W", ""));
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
	 * 替换 变量赋值到sql
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
				if (stemp.trim().equals("") || stemp.trim().startsWith("//")) {// 注释和空行不需要统计
					vTempPage.add(stemp);
					stemp = vnTempPage.get(++j);
					continue;
				}
				if (stemp.trim().indexOf("/*") != -1) {// 注释不需要统计
					while (stemp.trim().indexOf("*/") == -1) {
						vTempPage.add(stemp);
						stemp = vnTempPage.get(++j);
						if (stemp == null) {
							ts.writelog("-------文件：" + sFilename	+ "--------------------注释不完整--------");
							break;
						}
					}
					vTempPage.add(stemp);
					stemp = vnTempPage.get(++j);
					continue;
				}
				iTemp = stemp.indexOf("//");// 注释不需要统计
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
//				ts.writelog("[error]需要改变参数名称："+sTpara.replaceAll("\\W", ""));
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
//				ts.writelog("[error]需要改变参数名称："+sTpara.replaceAll("\\W", ""));
//			}
			vPara.add(sTpara);
			m.appendReplacement(sb, m.group(1)+":"+sTpara.replaceAll("\\W", "")+icount+++m.group(3));
		}
		m.appendTail(sb);

		//由于匹配器包含了边界，所以需要第二次匹配
		m = sqlPatternse.matcher(sb.toString());
		sb = new StringBuffer();
		while(m.find()){
			sTpara = m.group(2);
//			if(vPara.contains(sTpara)){
//				ts.writelog("[error]需要改变参数名称："+sTpara.replaceAll("\\W", ""));
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
	 * 回写文件
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
		      System.out.println("文件[" + file.getAbsolutePath() + "] 不存在!");
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
	 * 读取分析文件
	 * 
	 * @param file
	 *            文件名称
	 */
	private void readfile(File file) {

		//初始化
		iRow = 0;
		vSql = new Vector<String>();
		vPara = new Vector<String>() ;
		vTempPage = new Vector<String>();
		vnTempPage = new Vector<String>();
		String  sTemp="",str="";
		
		BufferedReader read = null;
		//===============================首先读取文件并处理直接执行sql====================
		try {
			// 只需相对路径即可
			sFilename = file.getPath();
			ts.writelog("========文件名======"+sFilename);
			read = new BufferedReader(new InputStreamReader(new FileInputStream(file),WRITE_CHARSET));
			str = read.readLine();
			iRow++;

			while (str != null) {
				if (str.trim().equals("") || str.trim().startsWith("//")) {// 注释和空行不需要统计
					vTempPage.add(str);
					str = read.readLine();
					iRow++;
					continue;
				}
				if (str.trim().indexOf("/*") != -1) {// 注释不需要统计
					while (str.trim().indexOf("*/") == -1) {
						vTempPage.add(str);
						str = read.readLine();
						if (str == null) {
							ts.writelog("-------文件：" + sFilename+ "--------------------注释不完整--------");
							break;
						}
						iRow++;
					}
					vTempPage.add(str);
					str = read.readLine();
					iRow++;
					continue;
				}

				iTemp = str.indexOf("//");// 注释不需要统计
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
			ts.writelog("文件[" + file.getAbsolutePath() + "] 不存在!");
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		} catch (Exception e) {
			hassSql = false;//出错则不覆盖原来到程序
			e.printStackTrace();
			ts.writelog("[error] == [" +sFilename + "] 直接sql替换变量出错，请手工替换!");
		}finally {
			try {
				read.close();
			} catch (Exception e) {
				e.printStackTrace();
			}
		}

		//===============================再次处理用变量赋值的sql====================
		
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
					if (str.trim().equals("") || str.trim().startsWith("//")) {// 注释和空行不需要统计
						vTempPage.add(str);
						continue;
					}
					if (str.trim().indexOf("/*") != -1) {// 注释不需要统计
						while (str.trim().indexOf("*/") == -1) {
							vTempPage.add(str);
							str = vnTempPage.get(++j);
							if (str == null) {
								ts.writelog("-------文件：" + sFilename+ "--------------------注释不完整--------");
								break;
							}
						}
						vTempPage.add(str);
						continue;
					}
					iTemp = str.indexOf("//");// 注释不需要统计
					sTemp = str;
					if (iTemp != -1)
						sTemp = sTemp.substring(0, iTemp).replaceAll("\\s*$", "");
					if(sTemp.matches(smakeSql) && !sTemp.matches(sNotmake)){
						if(vPara.size()>0){
							ts.writelog("[error] 以下语句"+vSql.get(i)+"多次赋值，需要注意更改");
						}
						if(sTemp.indexOf("=:")!=-1){//已经参数化
							vTempPage.add(str);	
						}else{
							bhas = true;
							j=getsSql(sTemp,j);
						}
					}else if(sTemp.matches(squitsql1)||sTemp.matches(squitsql2)){
						vTempPage.add(str);
						ts.writelog("[error] 语句【"+str+"】存在值更改，需要注意更改");

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
			hassSql = false;//出错则不覆盖原来到程序
			ts.writelog("[error] == [" +sFilename + "] 变量sql 替换变量出错，请手工替换!");
		}
		

		//===============================输出结果====================
		
		if(hassSql){//如果替换了sql则需要重新输出文件
			writeOut(file);
		}

	}
}
