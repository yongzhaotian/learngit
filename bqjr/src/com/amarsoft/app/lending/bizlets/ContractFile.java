package com.amarsoft.app.lending.bizlets;

import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.Date;

import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

public class ContractFile extends Bizlet{
	String sSql="";
	ASResultSet rs = null;

	String SerialNo;//该箱子的编号
    int boxNum=0,shelfNum=0,lineNum=0,roomNum=0; //新的第几 箱子、架子、行、档案室
    String boxName="",shelfName="",lineName="",roomName=""; //新箱子、架子、行、档案室名称
	String shelfCode="",lineCode="",roomCode="";//新架子、行、档案室编号
	String CabinetID1;//原箱子编号
    String CabinetID2;//新箱子编号
    
    //档案室、行、架子、箱子编号
	String  recordRoomCode= "";
	String lineNumberCode = "";
	String shelfNumberCode = "";
	String boxNumberCode = "";
	

	//初始化行、架子、箱子的数量，每一次换行、架子、箱子都要从1开始。
	int sContractStartno = 0;
	int lineNumSum = 0;
	int shelfNumSum = 0;
	int BOXNUMSUM = 0;
	
	
	//初始化数据库数据
	int contractNum1=0;
	int boxNum1=0;
	int shelfNum1=0;
	int lineNum1=0;
	int roomNum1=0;
    
	//记录地址
	String roomAddress="";
	String lineAddress="";
	String shelfAddress="";
	String boxAddress="";
	
	String sContractNumber="";
	
    public String getCabinetID1() {
		return CabinetID1;
	}

	public void setCabinetID1(String cabinetID1) {
		CabinetID1 = cabinetID1;
	}

	public String getCabinetID2() {
		return CabinetID2;
	}

	public void setCabinetID2(String cabinetID2) {
		CabinetID2 = cabinetID2;
	}

    public String getSerialNo() {
		return SerialNo;
	}

	public void setSerialNo(String serialNo) {
		SerialNo = serialNo;
	}
	
	@Override
	public Object run(Transaction Sqlca) throws Exception {
		String sReturn = "";
		//获得合同流水号
		String sObjectNo = (String)this.getAttribute("ObjectNo");
		//定义变量：执行SQL，起始路径

		//记录地址
		String roomAddress="";
		String lineAddress="";
		String shelfAddress="";
		String boxAddress="";
		String contractCount="";
		//记录行、架子、箱子,合同的存入的总数量
		int sRoom=0;//档案室总数
		int lineSum=0;
		int shelfSum=0;
		int boxSum=0;
		int contractSum=0;
		//返回到页面的信息
		String returnValue="";
		SimpleDateFormat forMat=new SimpleDateFormat("yyyy/MM/dd");
		String nowDate=forMat.format(new Date());
		System.out.println(nowDate+"----------------");
    	 //获取起始归档路径
		sSql = "select CONTRACTSTARTNO,RECORDROOMCODE,LINENUMBERCODE,SHELFNUMBERCODE,BOXNUMBERCODE,LINENUMSUM,SHELFNUMSUM,BOXNUMSUM,ROOM,lineSum,shelfSum,boxSum,contractSum from Contract_Starting";
		rs = Sqlca.getASResultSet(sSql);
		if(rs.next()){
			recordRoomCode = rs.getString("RECORDROOMCODE");
			lineNumberCode = rs.getString("LINENUMBERCODE");
			shelfNumberCode = rs.getString("SHELFNUMBERCODE");
			boxNumberCode = rs.getString("BOXNUMBERCODE");
			sContractStartno = rs.getInt("CONTRACTSTARTNO");//当前档案室已使用的数量
			lineNumSum = rs.getInt("LINENUMSUM");//当前行已使用的数量
			shelfNumSum = rs.getInt("SHELFNUMSUM");//当前架子已使用的数量
			BOXNUMSUM = rs.getInt("BOXNUMSUM");//当前箱子已使用的数量
			sRoom = rs.getInt("ROOM");//档案室总数
			lineSum = rs.getInt("lineSum");//行的总数
			shelfSum = rs.getInt("shelfSum");//架子的总数
			boxSum = rs.getInt("boxSum");//箱子的总数
			contractSum = rs.getInt("contractSum");//合同的总数
			
		}
		rs.close();
		
		if(sContractStartno == 0 || "".equals(sContractStartno)){
			recordRoomCode = Sqlca.getString("select cabinetid from archives_Warehouse where CreditAttribute='0002' and CodeAttribute='RecordRoomCode' order by cabinetid");
			lineNumberCode = Sqlca.getString("select cabinetid from archives_warehouse where CreditAttribute='0002' and CodeAttribute='LineNumberCode' and sno = '"+recordRoomCode+"' order by cabinetid");
			shelfNumberCode = Sqlca.getString("select cabinetid from archives_warehouse where CreditAttribute='0002' and CodeAttribute='ShelfNumberCode' and sno = '"+lineNumberCode+"' order by cabinetid");
			boxNumberCode = Sqlca.getString("select cabinetid from archives_warehouse where CreditAttribute='0002' and CodeAttribute='BoxNumberCode' and sno = '"+shelfNumberCode+"' order by cabinetid");
			
			if(recordRoomCode == null) returnValue= "档案室不能为空！";
			if(lineNumberCode == null) returnValue= "档案室的行不能为空！";
			if(shelfNumberCode == null) returnValue= "架子不能为空！";
			if(boxNumberCode == null) returnValue= "箱子不能为空！";
			
			sContractStartno = 1;
			lineNumSum = 1;
			shelfNumSum = 1;
			BOXNUMSUM = 1;
			sRoom=1;
			lineSum=1;
			shelfSum=1;
			boxSum=1;
			contractSum=1;
			sSql = "insert into Contract_Starting "
					+ " values('"+sContractStartno+"','"+recordRoomCode+"','"+lineNumberCode+"','"+
					shelfNumberCode+"','"+boxNumberCode+"','"+lineNumSum+"','"+shelfNumSum+"','"+BOXNUMSUM+"','"+sRoom+"','"
				    + contractSum+"','"+boxSum+"','"+shelfSum+"','"+lineSum+"')";
			Sqlca.executeSQL(new SqlObject(sSql));
			
			//更新表中当前箱子已使用容积、初始化
			Sqlca.executeSQL(new SqlObject("update archives_Warehouse set boxNumSum =:boxNumSum where cabinetID=:cabinetID").setParameter("boxNumSum",BOXNUMSUM).setParameter("cabinetID",boxNumberCode));
			//更新表中当前架子已使用容积
			Sqlca.executeSQL(new SqlObject("update archives_Warehouse set shelfNumSum =:shelfNumSum where cabinetID=:cabinetID").setParameter("shelfNumSum",shelfNumSum).setParameter("cabinetID",shelfNumberCode));
			//更新表中当前行已使用容积
			Sqlca.executeSQL(new SqlObject("update archives_Warehouse set lineNumSum =:lineNumSum where cabinetID=:cabinetID").setParameter("lineNumSum",lineNumSum).setParameter("cabinetID",lineNumberCode));
			//更新表中当前档案室已使用容积
			Sqlca.executeSQL(new SqlObject("update archives_Warehouse set roomNumSum =:roomNumSum where cabinetID=:cabinetID").setParameter("roomNumSum",sContractStartno).setParameter("cabinetID",recordRoomCode));
			
			sSql = "select BOXNUMSUM from Contract_Starting  ";
			contractCount=Sqlca.getString(new SqlObject(sSql));//记录合同数
			
			sSql = "select CabinetName from archives_Warehouse where CabinetID=:CabinetID ";
			boxAddress=Sqlca.getString(new SqlObject(sSql).setParameter("cabinetid", boxNumberCode));//记录箱子的地址
			
			sSql = "select CabinetName from archives_Warehouse where CabinetID=:CabinetID ";
			shelfAddress=Sqlca.getString(new SqlObject(sSql).setParameter("cabinetid", shelfNumberCode));//记录架子的地址
			
			sSql = "select CabinetName from archives_Warehouse where CabinetID=:CabinetID ";
			lineAddress=Sqlca.getString(new SqlObject(sSql).setParameter("cabinetid", lineNumberCode));//记录行的地址
			
			sSql = "select CabinetName from archives_Warehouse where CabinetID=:CabinetID ";
			roomAddress=Sqlca.getString(new SqlObject(sSql).setParameter("cabinetid", recordRoomCode));//记录档案室的地址
			
			StringBuffer sb=new StringBuffer();
			sb.append("第\""+sRoom+"\"个"+roomAddress+"档案室下的");
			sb.append("第\""+sContractStartno+"\""+lineAddress+"行下的");
			sb.append("第\""+lineNumSum+"\"个"+shelfAddress+"架子下的");
			sb.append("第\""+shelfNumSum+"\"个"+boxAddress+"箱子下的第"+BOXNUMSUM+"位置");
			
			
			//更新合同地址、合同归档
			Sqlca.executeSQL(new SqlObject("update Business_Contract set BoxNo = '"+boxNumberCode+"' where SerialNo = '"+sObjectNo+"'"));//更新箱子编号
			Sqlca.executeSQL(new SqlObject("update Business_Contract set ShelfNo = '"+shelfNumberCode+"' where SerialNo = '"+sObjectNo+"'"));//更新架子编号
			Sqlca.executeSQL(new SqlObject("update Business_Contract set LineNo = '"+lineNumberCode+"' where SerialNo = '"+sObjectNo+"'"));//更新行编号
			Sqlca.executeSQL(new SqlObject("update Business_Contract set RoomNo = '"+recordRoomCode+"' where SerialNo = '"+sObjectNo+"'"));//更新档案室编号
			
			Sqlca.executeSQL(new SqlObject("update Business_Contract set ISARCHIVE = '01',archiveAddress='"+sb.toString()+"',ARCHIVEDATE='"+nowDate+"' where SerialNo ='"+sObjectNo+"'"));
			returnValue = "归档成功";
		}else{
			//合同数加一
			BOXNUMSUM = BOXNUMSUM + 1;
			contractSum+=1;
			//获取盒子最大容积
			sSql = "select BOXNUMBER from archives_warehouse where cabinetid =:cabinetid ";
			Double dBoxSum = Sqlca.getDouble(new SqlObject(sSql).setParameter("cabinetid",boxNumberCode));
			int iBoxSum=0 ;
			if (dBoxSum!=null){
			   iBoxSum = dBoxSum.intValue();
			}
			if(BOXNUMSUM > iBoxSum){
				boxSum+=1;
				//获取下一个箱子编号
//					sSql = "select cabinetid from archives_Warehouse where CreditAttribute='0002' and CodeAttribute='BoxNumberCode' and rownum = '1' and cabinetid <>:cabinetid  order by cabinetid";
				sSql="select t1.cabinetid from archives_Warehouse t1,"
				      +"(SELECT cabinetid, ROW_NUMBER() OVER(ORDER BY cabinetid ) AS RK "
				      +" FROM archives_Warehouse where CreditAttribute = '0002'and CodeAttribute = 'BoxNumberCode') t"
				      +" WHERE t.cabinetid = t1.cabinetid  AND t.rk ='"+boxSum+"'";
				boxNumberCode = Sqlca.getString(new SqlObject(sSql));
				if(boxNumberCode==null) return "箱子数量已存完！请重新创建一个箱子";
				if(boxNumberCode!=null &&boxNumberCode.equals("")) return "箱子数量已存完！请重新创建一个箱子！！";
				//架子容量+1
				shelfNumSum = shelfNumSum + 1;
				//初始化箱子容量
				BOXNUMSUM = 1;
				//更新箱子编号
				Sqlca.executeSQL(new SqlObject("update Contract_Starting set BOXNUMBERCODE ='"+boxNumberCode+"'"));

				//获取架子最大容积
				sSql = "select SHELFNUMBER from archives_warehouse where cabinetid =:cabinetid ";
				int iShelfSum = Sqlca.getDouble(new SqlObject(sSql).setParameter("cabinetid",shelfNumberCode)).intValue();
				if(shelfNumSum > iShelfSum){
					shelfSum+=1;
					//获取下一个架子编号
//						sSql = "select cabinetid from archives_Warehouse where CreditAttribute='0002' and CodeAttribute='ShelfNumberCode' and rownum = '1' and cabinetid <>:cabinetid  order by cabinetid";
					sSql="select t1.cabinetid from archives_Warehouse t1,"
						      +"(SELECT cabinetid, ROW_NUMBER() OVER(ORDER BY cabinetid ) AS RK "
						      +" FROM archives_Warehouse where CreditAttribute = '0002'and CodeAttribute = 'ShelfNumberCode') t"
						      +" WHERE t.cabinetid = t1.cabinetid  AND t.rk ='"+shelfSum+"'";
					shelfNumberCode = Sqlca.getString(new SqlObject(sSql));
					if(shelfNumberCode==null) return "架子数量已存完！请重新创建一个架子";
					if(shelfNumberCode!=null&&shelfNumberCode.equals("")) return "架子数量已存完！请重新创建一个架子！！";
					//行容量+1
					lineNumSum = lineNumSum + 1;
					//初始化架子容量
					shelfNumSum=1;
					//更新架子编号
					Sqlca.executeSQL(new SqlObject("update Contract_Starting set SHELFNUMBERCODE ='"+shelfNumberCode+"'"));
					
				}
			
				//获取行最大容积
				sSql = "select LINENUMBER from archives_warehouse where cabinetid =:cabinetid ";
				int iLineSum = Sqlca.getDouble(new SqlObject(sSql).setParameter("cabinetid",lineNumberCode)).intValue();
				if(lineNumSum > iLineSum){
					lineSum+=1;
					//获取下一个行的编号
//						sSql = "select cabinetid from archives_Warehouse where CreditAttribute='0002' and CodeAttribute='LineNumberCode' and rownum = '1' and cabinetid <>:cabinetid  order by cabinetid";
					sSql="select t1.cabinetid from archives_Warehouse t1,"
						      +"(SELECT cabinetid, ROW_NUMBER() OVER(ORDER BY cabinetid ) AS RK "
						      +" FROM archives_Warehouse where CreditAttribute = '0002'and CodeAttribute = 'LineNumberCode') t"
						      +" WHERE t.cabinetid = t1.cabinetid  AND t.rk ='"+lineSum+"'";
					lineNumberCode = Sqlca.getString(new SqlObject(sSql));
					if(lineNumberCode==null) return "行的数量已存完！请重新创建一个新的行";
					if(lineNumberCode!=null&&lineNumberCode.equals("")) return "行的数量已存完！请重新创建一个新的行！！";
					//档案室容量+1
					sContractStartno = sContractStartno + 1;
					//初始化行
					lineNumSum=1;
					//更新行编号
					Sqlca.executeSQL(new SqlObject("update Contract_Starting set LINENUMBERCODE ='"+lineNumberCode+"'"));
				}
			
				//获取档案室的最大容积
				sSql = "select RECORDROOM from archives_warehouse where cabinetid =:cabinetid ";
				int iRoomSum = Sqlca.getDouble(new SqlObject(sSql).setParameter("cabinetid",recordRoomCode)).intValue();
			
				if(sContractStartno > iRoomSum){
					sRoom=sRoom+1;
					//获取下一个档案室的编号
//					sSql = "select cabinetid from archives_Warehouse where CreditAttribute='0002' and CodeAttribute='RecordRoomCode' and rownum = '1' and cabinetid <>:cabinetid  order by cabinetid";
					sSql="select t1.cabinetid from archives_Warehouse t1,"
						      +"(SELECT cabinetid, ROW_NUMBER() OVER(ORDER BY cabinetid ) AS RK "
						      +" FROM archives_Warehouse where CreditAttribute = '0002'and CodeAttribute = 'RecordRoomCode') t"
						      +" WHERE t.cabinetid = t1.cabinetid  AND t.rk ='"+sRoom+"'";
//					recordRoomCode = Sqlca.getString(new SqlObject(sSql).setParameter("cabinetid",  recordRoomCode));
					recordRoomCode = Sqlca.getString(new SqlObject(sSql));
					if(recordRoomCode==null) return "档案室已用完！";
					if(recordRoomCode!=null&&recordRoomCode.equals("")){
						return "档案室已用完！！";
					}
					//更新档案室编号
					Sqlca.executeSQL(new SqlObject("update Contract_Starting set CONTRACTSTARTNO ='"+recordRoomCode+"'"));
				}
			}
			
			//更新现表中容量 。。。。
			//更新表中当前箱子已使用容积
			Sqlca.executeSQL(new SqlObject("update Contract_Starting set BOXNUMSUM =:BOXNUMSUM").setParameter("BOXNUMSUM",BOXNUMSUM));
			Sqlca.executeSQL(new SqlObject("update archives_Warehouse set boxNumSum =:boxNumSum where cabinetID=:cabinetID").setParameter("boxNumSum",BOXNUMSUM).setParameter("cabinetID",boxNumberCode));
			//更新表中当前架子已使用容积
			Sqlca.executeSQL(new SqlObject("update Contract_Starting set SHELFNUMSUM =:SHELFNUMSUM").setParameter("SHELFNUMSUM",shelfNumSum));
			Sqlca.executeSQL(new SqlObject("update archives_Warehouse set shelfNumSum =:shelfNumSum where cabinetID=:cabinetID").setParameter("shelfNumSum",shelfNumSum).setParameter("cabinetID",shelfNumberCode));
			//更新表中当前行已使用容积
			Sqlca.executeSQL(new SqlObject("update Contract_Starting set LINENUMSUM =:LINENUMSUM").setParameter("LINENUMSUM",lineNumSum));
			Sqlca.executeSQL(new SqlObject("update archives_Warehouse set lineNumSum =:lineNumSum where cabinetID=:cabinetID").setParameter("lineNumSum",lineNumSum).setParameter("cabinetID",lineNumberCode));
			//更新表中当前档案室已使用容积
			Sqlca.executeSQL(new SqlObject("update Contract_Starting set CONTRACTSTARTNO =:CONTRACTSTARTNO").setParameter("CONTRACTSTARTNO",sContractStartno));
			Sqlca.executeSQL(new SqlObject("update archives_Warehouse set roomNumSum =:roomNumSum where cabinetID=:cabinetID").setParameter("roomNumSum",sContractStartno).setParameter("cabinetID",recordRoomCode));

			//更新现有档案室的总数
			Sqlca.executeSQL(new SqlObject("update Contract_Starting set ROOM =:ROOM").setParameter("ROOM",sRoom));
			//更新现存行的总数
			Sqlca.executeSQL(new SqlObject("update Contract_Starting set lineSum =:lineSum").setParameter("lineSum",lineSum));
			//更新现存架子的总数
			Sqlca.executeSQL(new SqlObject("update Contract_Starting set shelfSum =:shelfSum").setParameter("shelfSum",shelfSum));
			//更新现存箱子的总数
			Sqlca.executeSQL(new SqlObject("update Contract_Starting set boxSum =:boxSum").setParameter("boxSum",boxSum));
			//更新现存合同的总数
			Sqlca.executeSQL(new SqlObject("update Contract_Starting set contractSum =:contractSum").setParameter("contractSum",contractSum));
			
			//查询最新档案室、行、架子、箱子现使用的容量
			sSql = "select CONTRACTSTARTNO,LINENUMSUM,SHELFNUMSUM,BOXNUMSUM,ROOM from Contract_Starting";
			rs = Sqlca.getASResultSet(sSql);
			if(rs.next()){
				sContractStartno = rs.getInt("CONTRACTSTARTNO");//档案室已使用的数量
				lineNumSum = rs.getInt("LINENUMSUM");//行已使用的数量
				shelfNumSum = rs.getInt("SHELFNUMSUM");//架子已使用的数量
				BOXNUMSUM = rs.getInt("BOXNUMSUM");//箱子已使用的数量
				sRoom = rs.getInt("ROOM");//几号档案室
			}
			rs.close();
			
			//查询地址、进行拼接
			sSql = "select CabinetName from archives_Warehouse where CabinetID=:CabinetID ";
			boxAddress=Sqlca.getString(new SqlObject(sSql).setParameter("cabinetid", boxNumberCode));//记录箱子的地址
			
			sSql = "select CabinetName from archives_Warehouse where CabinetID=:CabinetID ";
			shelfAddress=Sqlca.getString(new SqlObject(sSql).setParameter("cabinetid", shelfNumberCode));//记录架子的地址
			
			sSql = "select CabinetName from archives_Warehouse where CabinetID=:CabinetID ";
			lineAddress=Sqlca.getString(new SqlObject(sSql).setParameter("cabinetid", lineNumberCode));//记录行的地址
			
			sSql = "select CabinetName from archives_Warehouse where CabinetID=:CabinetID ";
			roomAddress=Sqlca.getString(new SqlObject(sSql).setParameter("cabinetid", recordRoomCode));//记录档案室的地址
			StringBuffer sb=new StringBuffer();
			sb.append("第\""+sRoom+"\"个"+roomAddress+"档案室下的");
			sb.append("第\""+sContractStartno+"\""+lineAddress+"行下的");
			sb.append("第\""+lineNumSum+"\"个"+shelfAddress+"架子下的");
			sb.append("第\""+shelfNumSum+"\"个"+boxAddress+"箱子下的第"+BOXNUMSUM+"位置");
			
			
			//更新合同地址、合同归档
			Sqlca.executeSQL(new SqlObject("update Business_Contract set BoxNo = '"+boxNumberCode+"' where SerialNo = '"+sObjectNo+"'"));//更新箱子编号
			Sqlca.executeSQL(new SqlObject("update Business_Contract set ShelfNo = '"+shelfNumberCode+"' where SerialNo = '"+sObjectNo+"'"));//更新架子编号
			Sqlca.executeSQL(new SqlObject("update Business_Contract set LineNo = '"+lineNumberCode+"' where SerialNo = '"+sObjectNo+"'"));//更新行编号
			Sqlca.executeSQL(new SqlObject("update Business_Contract set RoomNo = '"+recordRoomCode+"' where SerialNo = '"+sObjectNo+"'"));//更新档案室编号
			
			Sqlca.executeSQL(new SqlObject("update Business_Contract set ISARCHIVE = '01',archiveAddress='"+sb.toString()+"',ARCHIVEDATE='"+nowDate+"' where SerialNo = '"+sObjectNo+"'"));
			returnValue = "归档成功";
			
		}
	   
		return returnValue;
	}
	
	
	//得到新箱子的编号、名称、地址
	public void goAddress(Transaction Sqlca) throws Exception{
		
		//得到该架子编号,箱子的名称
		sSql="select sno,cabinetname from archives_warehouse where CreditAttribute='0002' and CodeAttribute='BoxNumberCode' and cabinetid=:cabinetid";
		rs=Sqlca.getASResultSet(new SqlObject(sSql).setParameter("cabinetid", CabinetID2));
		if(rs.next()){
			shelfCode=rs.getString("sno");
			boxName=rs.getString("cabinetname");
		}
		rs.close();
		
		//得到该行的编号、架子的名称
		sSql="select sno,cabinetname from archives_warehouse where CreditAttribute='0002' and CodeAttribute='ShelfNumberCode' and cabinetid=:cabinetid";
		rs=Sqlca.getASResultSet(new SqlObject(sSql).setParameter("cabinetid", shelfCode));
		if(rs.next()){
			lineCode=rs.getString("sno");
			shelfName=rs.getString("cabinetname");
		}
		rs.close();
		
		//得到该档案室的编号、行的名称
		sSql="select sno,cabinetname from archives_warehouse where CreditAttribute='0002' and CodeAttribute='LineNumberCode' and cabinetid=:cabinetid";
		rs=Sqlca.getASResultSet(new SqlObject(sSql).setParameter("cabinetid", lineCode));
		if(rs.next()){
			roomCode=rs.getString("sno");
			lineName=rs.getString("cabinetname");
		}
		rs.close();
		
		//得到该档案室的名称
		sSql="select cabinetname from archives_warehouse where CreditAttribute='0002' and CodeAttribute='RecordRoomCode'  and cabinetid=:cabinetid ";
		roomName=Sqlca.getString(new SqlObject(sSql).setParameter("sno",shelfCode ).setParameter("cabinetid", roomCode));
		
		//得到该档案室、该行、该架子下第几个箱子
		sSql="select count(1) from archives_warehouse where CreditAttribute='0002' and CodeAttribute='BoxNumberCode' and sno=:sno and cabinetid<=:cabinetid order by cabinetid";
		boxNum=Integer.parseInt(Sqlca.getString(new SqlObject(sSql).setParameter("sno",shelfCode ).setParameter("cabinetid", CabinetID2)));
		//得到该档案室、该行的第几个架子
		sSql="select count(1) from archives_warehouse where CreditAttribute='0002' and CodeAttribute='ShelfNumberCode' and sno=:sno and cabinetid<=:cabinetid order by cabinetid";
		shelfNum=Integer.parseInt(Sqlca.getString(new SqlObject(sSql).setParameter("sno",lineCode ).setParameter("cabinetid", shelfCode)));
		//得到该档案室第几行
		sSql="select count(1) from archives_warehouse where CreditAttribute='0002' and CodeAttribute='LineNumberCode' and sno=:sno and cabinetid<=:cabinetid order by cabinetid";
		lineNum=Integer.parseInt(Sqlca.getString(new SqlObject(sSql).setParameter("sno",roomCode ).setParameter("cabinetid", lineCode)));
		//得到第几个档案室
		sSql="select count(1) from archives_warehouse where CreditAttribute='0002' and CodeAttribute='RecordRoomCode' and cabinetid<=:cabinetid order by cabinetid";
		roomNum=Integer.parseInt(Sqlca.getString(new SqlObject(sSql).setParameter("cabinetid", roomCode)));
	}
	
	//合同存档地址变更
	public String updateAdderss(Transaction Sqlca) throws Exception{
		int i=0;
		String contractNum="";//该合同在箱子中的位置
		String sSerialNo="";
		goAddress(Sqlca);
		sSql ="select serialno, archiveAddress from business_contract where boxNo=:boxNo";
		rs=Sqlca.getASResultSet(new SqlObject(sSql).setParameter("boxNo", CabinetID1));
		while(rs.next()){
			//截取原来合同在箱子中的位置
			sSerialNo=rs.getString("serialno");
			contractNum=rs.getString("archiveAddress");
			contractNum=contractNum.substring(contractNum.lastIndexOf("-")+1, contractNum.length());
			
			//更新原来合同地址
			sSql="update business_contract set archiveAddress='A0"+roomNum+"0"+lineNum+shelfName+boxNum+"-"+contractNum+"',boxNo='"+CabinetID2
			    		+ "',shelfNo='"+shelfCode+"',lineNo='"+lineCode+"',roomNo='"+roomCode+"' where serialno=:serialno";
			
//			//更新原来合同地址
//			sSql="update business_contract set archiveAddress='第\""+roomNum+"\"个"+roomName+"档案室下的第\""+lineNum+"\""+lineName+"行下的"
//			    +"第\""+shelfNum+"\"个"+shelfName+"架子下的第\""+boxNum+"\"个"+boxName+"箱子下的第"+contractNum+"位置',boxNo='"+CabinetID2
//			    		+ "',shelfNo='"+shelfCode+"',lineNo='"+lineCode+"',roomNo='"+roomCode+"' where serialno=:serialno";
			Sqlca.executeSQL(new SqlObject(sSql).setParameter("serialno", sSerialNo));
			
			Sqlca.executeSQL(new SqlObject("update Business_Contract set BoxNo = '"+CabinetID2+"' where SerialNo = '"+sSerialNo+"'"));//更原合同箱子编号
			Sqlca.executeSQL(new SqlObject("update Business_Contract set ShelfNo = '"+shelfCode+"' where SerialNo = '"+sSerialNo+"'"));//更新原合同架子编号
			Sqlca.executeSQL(new SqlObject("update Business_Contract set LineNo = '"+lineCode+"' where SerialNo = '"+sSerialNo+"'"));//更新原合同行编号
			Sqlca.executeSQL(new SqlObject("update Business_Contract set RoomNo = '"+roomCode+"' where SerialNo = '"+sSerialNo+"'"));//更新原合同档案室编号
			i++;
		}
		rs.close();
		
		//原箱子容量清空
		sSql="update archives_warehouse set boxNumSum='' where CabinetID=:CabinetID";
		Sqlca.executeSQL(new SqlObject(sSql).setParameter("CabinetID", CabinetID1));
		//更新新箱子容量
		sSql="update archives_warehouse set boxNumSum=:boxNumSum where CabinetID=:CabinetID";
		Sqlca.executeSQL(new SqlObject(sSql).setParameter("boxNumSum", i).setParameter("CabinetID", CabinetID2));
		
		return "变更成功！";
	}
	
	
	public String updateFile(Transaction Sqlca) throws Exception{
		ASResultSet rs = null;
		ASResultSet rs1 = null;
		ASResultSet rs2 = null;
		ASResultSet rs3 = null;
		int boxNumber=0;//箱子的容量
		int shelfNumber=0;//架子的容量
		int lineNumber=0;//行的容量
		int roomNumber=0;//档案室容量
		String flag="";
		
		SimpleDateFormat forMat=new SimpleDateFormat("yyyy/MM/dd");
		String nowDate=forMat.format(new Date());
		
		//第一次判断档案室、行、架子、箱子不能为空
		String[] returnValue=init(Sqlca).split("@");
		if(returnValue[1].equals("true")){
			//得到档案室编号
			sSql="select cabinetid,RecordRoom,cabinetName from archives_Warehouse where CreditAttribute='0002' and CodeAttribute='RecordRoomCode' order by cabinetid";
			rs3=Sqlca.getASResultSet(new SqlObject(sSql));
			while(rs3.next()){
				recordRoomCode=rs3.getString("cabinetid");
				roomNumber=Integer.parseInt(rs3.getString("RecordRoom"));
				roomAddress=rs3.getString("cabinetName");
				//得到第几个档案室
				sSql="select count(1) from archives_warehouse where CreditAttribute='0002' and CodeAttribute='RecordRoomCode' and cabinetid<=:cabinetid order by cabinetid";
				sContractStartno=Integer.parseInt(Sqlca.getString(new SqlObject(sSql).setParameter("cabinetid", recordRoomCode)));
				
				
				//得到行编号
				sSql="select cabinetid,lineNumber,cabinetName from archives_warehouse where CreditAttribute='0002' and CodeAttribute='LineNumberCode' and sno = '"+recordRoomCode+"' order by cabinetid";
				rs2=Sqlca.getASResultSet(new SqlObject(sSql));
				while(rs2.next()){
					lineNumberCode=rs2.getString("cabinetid");
					lineNumber=Integer.parseInt(rs2.getString("lineNumber"));
					lineAddress=rs2.getString("cabinetName");
					//得到第几行
					sSql="select count(1) from archives_warehouse where CreditAttribute='0002' and CodeAttribute='LineNumberCode' and sno=:sno and cabinetid<=:cabinetid order by cabinetid";
					lineNumSum=Integer.parseInt(Sqlca.getString(new SqlObject(sSql).setParameter("sno", recordRoomCode).setParameter("cabinetid", lineNumberCode)));
					
					//得到架子编号
					sSql="select cabinetid,shelfNumber,cabinetName from archives_warehouse where CreditAttribute='0002' and CodeAttribute='ShelfNumberCode' and sno = '"+lineNumberCode+"' order by cabinetid";
					rs1=Sqlca.getASResultSet(new SqlObject(sSql));
					while(rs1.next()){
						shelfNumberCode=rs1.getString("cabinetid");
						shelfNumber=Integer.parseInt(rs1.getString("shelfNumber"));
						shelfAddress=rs1.getString("cabinetName");
						//得到第几架子
						sSql="select count(1) from archives_warehouse where CreditAttribute='0002' and CodeAttribute='ShelfNumberCode' and sno=:sno and cabinetid<=:cabinetid order by cabinetid";
						shelfNumSum=Integer.parseInt(Sqlca.getString(new SqlObject(sSql).setParameter("sno",lineNumberCode).setParameter("cabinetid", shelfNumberCode)));
						
						
						//得到箱子编号
						sSql="select cabinetid,boxNumber,cabinetName from archives_warehouse where CreditAttribute='0002' and CodeAttribute='BoxNumberCode' and sno = '"+shelfNumberCode+"' order by cabinetid";
						rs=Sqlca.getASResultSet(new SqlObject(sSql));
						while(rs.next()){
							boxNumberCode=rs.getString("cabinetid");//箱子的编号
							boxNumber=Integer.parseInt(rs.getString("boxNumber"));//箱子的容量
							boxAddress=rs.getString("cabinetName");
							//得到第几个箱子
							sSql="select count(1) from archives_warehouse where CreditAttribute='0002' and CodeAttribute='BoxNumberCode' and sno=:sno and cabinetid<=:cabinetid order by cabinetid";
							BOXNUMSUM=Integer.parseInt(Sqlca.getString(new SqlObject(sSql).setParameter("sno", shelfNumberCode).setParameter("cabinetid", boxNumberCode)));
							
							//更新当前架子已经存箱子的数量
							sSql="update archives_warehouse set shelfNumSum='"+BOXNUMSUM+"' where cabinetid='"+shelfNumberCode+"'";
							Sqlca.executeSQL(new SqlObject(sSql));
							//更新当前行已存的架子的数量
							sSql="update archives_warehouse set lineNumSum='"+shelfNumSum+"' where cabinetid='"+lineNumberCode+"'";
							Sqlca.executeSQL(new SqlObject(sSql));
							//更新当前档案室已存行的数量
							sSql="update archives_warehouse set roomNumSum='"+lineNumSum+"' where cabinetid='"+recordRoomCode+"'";
							Sqlca.executeSQL(new SqlObject(sSql));
							
							
							//查询当前初始箱子已经存入的数量i
							sSql="select boxNumSum from archives_warehouse where cabinetid='"+boxNumberCode+"'";
							String is=Sqlca.getString(new SqlObject(sSql));
							if(is==null) is="0";
							int i=Integer.parseInt(is);
		                    if(i>boxNumber-1){
								continue;
							}else{
								i++;
								if(i>0 && i<10){
									sContractNumber="00"+i;
								}else if(i>=10 && i<100) {
									sContractNumber="0"+i;
								}else{
									sContractNumber=i+"";
								}
								
								//更新当前箱子已存入合同的数量
								sSql="update archives_warehouse set boxNumSum='"+i+"' where cabinetid='"+boxNumberCode+"'";
								Sqlca.executeSQL(new SqlObject(sSql));
								StringBuffer sb=new StringBuffer();
								sb.append("A0"+sContractStartno);
								sb.append("0"+lineNumSum);
								sb.append(shelfAddress);
								sb.append(BOXNUMSUM+"-"+sContractNumber);
//								sb.append("第\""+sContractStartno+"\"个"+roomAddress+"档案室下的");
//								sb.append("第\""+lineNumSum+"\""+lineAddress+"行下的");
//								sb.append("第\""+shelfNumSum+"\"个"+shelfAddress+"架子下的");
//								sb.append("第\""+BOXNUMSUM+"\"个"+boxAddress+"箱子下的第"+i+"位置");
								
								//更新bc表合同中的档案室、行、架子、箱子的编号、合同归档
								Sqlca.executeSQL(new SqlObject("update Business_Contract set BoxNo = '"+boxNumberCode+"' where SerialNo = '"+SerialNo+"'"));//更新箱子编号
								Sqlca.executeSQL(new SqlObject("update Business_Contract set ShelfNo = '"+shelfNumberCode+"' where SerialNo = '"+SerialNo+"'"));//更新架子编号
								Sqlca.executeSQL(new SqlObject("update Business_Contract set LineNo = '"+lineNumberCode+"' where SerialNo = '"+SerialNo+"'"));//更新行编号
								Sqlca.executeSQL(new SqlObject("update Business_Contract set RoomNo = '"+recordRoomCode+"' where SerialNo = '"+SerialNo+"'"));//更新档案室编号

								Sqlca.executeSQL(new SqlObject("update Business_Contract set ISARCHIVE = '01',archiveAddress='"+sb.toString()+"',ARCHIVEDATE='"+nowDate+"' where SerialNo = '"+SerialNo+"'"));
								return "归档成功！";
							}
						}
						rs.close();
					}
					rs1.close();
				}
				rs2.close();
			}
			rs3.close();
			flag="箱子已用完！";
		}else{
			flag=returnValue[0];
		}
		
		return flag;
	}
	
	public String init(Transaction Sqlca) throws Exception{
		String returnValue="正常@true";
		recordRoomCode=Sqlca.getString(new SqlObject("select cabinetid from archives_Warehouse where CreditAttribute='0002' and CodeAttribute='RecordRoomCode' order by cabinetid"));
		lineNumberCode = Sqlca.getString("select cabinetid from archives_warehouse where CreditAttribute='0002' and CodeAttribute='LineNumberCode' and sno = '"+recordRoomCode+"' order by cabinetid");
		shelfNumberCode = Sqlca.getString("select cabinetid from archives_warehouse where CreditAttribute='0002' and CodeAttribute='ShelfNumberCode' and sno = '"+lineNumberCode+"' order by cabinetid");
		boxNumberCode = Sqlca.getString("select cabinetid from archives_warehouse where CreditAttribute='0002' and CodeAttribute='BoxNumberCode' and sno = '"+shelfNumberCode+"' order by cabinetid");
		if(boxNumberCode==null) returnValue= "箱子不能为空!@false";
		if(shelfNumberCode==null) returnValue= "架子不能为空!@false";
		if(lineNumberCode==null) returnValue= "行不能为空!@false";
		if(recordRoomCode==null) returnValue= "档案室不能为空!@false";
		return returnValue;
	}
}
