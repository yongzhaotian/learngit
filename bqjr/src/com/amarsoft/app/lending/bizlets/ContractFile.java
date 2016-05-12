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

	String SerialNo;//�����ӵı��
    int boxNum=0,shelfNum=0,lineNum=0,roomNum=0; //�µĵڼ� ���ӡ����ӡ��С�������
    String boxName="",shelfName="",lineName="",roomName=""; //�����ӡ����ӡ��С�����������
	String shelfCode="",lineCode="",roomCode="";//�¼��ӡ��С������ұ��
	String CabinetID1;//ԭ���ӱ��
    String CabinetID2;//�����ӱ��
    
    //�����ҡ��С����ӡ����ӱ��
	String  recordRoomCode= "";
	String lineNumberCode = "";
	String shelfNumberCode = "";
	String boxNumberCode = "";
	

	//��ʼ���С����ӡ����ӵ�������ÿһ�λ��С����ӡ����Ӷ�Ҫ��1��ʼ��
	int sContractStartno = 0;
	int lineNumSum = 0;
	int shelfNumSum = 0;
	int BOXNUMSUM = 0;
	
	
	//��ʼ�����ݿ�����
	int contractNum1=0;
	int boxNum1=0;
	int shelfNum1=0;
	int lineNum1=0;
	int roomNum1=0;
    
	//��¼��ַ
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
		//��ú�ͬ��ˮ��
		String sObjectNo = (String)this.getAttribute("ObjectNo");
		//���������ִ��SQL����ʼ·��

		//��¼��ַ
		String roomAddress="";
		String lineAddress="";
		String shelfAddress="";
		String boxAddress="";
		String contractCount="";
		//��¼�С����ӡ�����,��ͬ�Ĵ����������
		int sRoom=0;//����������
		int lineSum=0;
		int shelfSum=0;
		int boxSum=0;
		int contractSum=0;
		//���ص�ҳ�����Ϣ
		String returnValue="";
		SimpleDateFormat forMat=new SimpleDateFormat("yyyy/MM/dd");
		String nowDate=forMat.format(new Date());
		System.out.println(nowDate+"----------------");
    	 //��ȡ��ʼ�鵵·��
		sSql = "select CONTRACTSTARTNO,RECORDROOMCODE,LINENUMBERCODE,SHELFNUMBERCODE,BOXNUMBERCODE,LINENUMSUM,SHELFNUMSUM,BOXNUMSUM,ROOM,lineSum,shelfSum,boxSum,contractSum from Contract_Starting";
		rs = Sqlca.getASResultSet(sSql);
		if(rs.next()){
			recordRoomCode = rs.getString("RECORDROOMCODE");
			lineNumberCode = rs.getString("LINENUMBERCODE");
			shelfNumberCode = rs.getString("SHELFNUMBERCODE");
			boxNumberCode = rs.getString("BOXNUMBERCODE");
			sContractStartno = rs.getInt("CONTRACTSTARTNO");//��ǰ��������ʹ�õ�����
			lineNumSum = rs.getInt("LINENUMSUM");//��ǰ����ʹ�õ�����
			shelfNumSum = rs.getInt("SHELFNUMSUM");//��ǰ������ʹ�õ�����
			BOXNUMSUM = rs.getInt("BOXNUMSUM");//��ǰ������ʹ�õ�����
			sRoom = rs.getInt("ROOM");//����������
			lineSum = rs.getInt("lineSum");//�е�����
			shelfSum = rs.getInt("shelfSum");//���ӵ�����
			boxSum = rs.getInt("boxSum");//���ӵ�����
			contractSum = rs.getInt("contractSum");//��ͬ������
			
		}
		rs.close();
		
		if(sContractStartno == 0 || "".equals(sContractStartno)){
			recordRoomCode = Sqlca.getString("select cabinetid from archives_Warehouse where CreditAttribute='0002' and CodeAttribute='RecordRoomCode' order by cabinetid");
			lineNumberCode = Sqlca.getString("select cabinetid from archives_warehouse where CreditAttribute='0002' and CodeAttribute='LineNumberCode' and sno = '"+recordRoomCode+"' order by cabinetid");
			shelfNumberCode = Sqlca.getString("select cabinetid from archives_warehouse where CreditAttribute='0002' and CodeAttribute='ShelfNumberCode' and sno = '"+lineNumberCode+"' order by cabinetid");
			boxNumberCode = Sqlca.getString("select cabinetid from archives_warehouse where CreditAttribute='0002' and CodeAttribute='BoxNumberCode' and sno = '"+shelfNumberCode+"' order by cabinetid");
			
			if(recordRoomCode == null) returnValue= "�����Ҳ���Ϊ�գ�";
			if(lineNumberCode == null) returnValue= "�����ҵ��в���Ϊ�գ�";
			if(shelfNumberCode == null) returnValue= "���Ӳ���Ϊ�գ�";
			if(boxNumberCode == null) returnValue= "���Ӳ���Ϊ�գ�";
			
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
			
			//���±��е�ǰ������ʹ���ݻ�����ʼ��
			Sqlca.executeSQL(new SqlObject("update archives_Warehouse set boxNumSum =:boxNumSum where cabinetID=:cabinetID").setParameter("boxNumSum",BOXNUMSUM).setParameter("cabinetID",boxNumberCode));
			//���±��е�ǰ������ʹ���ݻ�
			Sqlca.executeSQL(new SqlObject("update archives_Warehouse set shelfNumSum =:shelfNumSum where cabinetID=:cabinetID").setParameter("shelfNumSum",shelfNumSum).setParameter("cabinetID",shelfNumberCode));
			//���±��е�ǰ����ʹ���ݻ�
			Sqlca.executeSQL(new SqlObject("update archives_Warehouse set lineNumSum =:lineNumSum where cabinetID=:cabinetID").setParameter("lineNumSum",lineNumSum).setParameter("cabinetID",lineNumberCode));
			//���±��е�ǰ��������ʹ���ݻ�
			Sqlca.executeSQL(new SqlObject("update archives_Warehouse set roomNumSum =:roomNumSum where cabinetID=:cabinetID").setParameter("roomNumSum",sContractStartno).setParameter("cabinetID",recordRoomCode));
			
			sSql = "select BOXNUMSUM from Contract_Starting  ";
			contractCount=Sqlca.getString(new SqlObject(sSql));//��¼��ͬ��
			
			sSql = "select CabinetName from archives_Warehouse where CabinetID=:CabinetID ";
			boxAddress=Sqlca.getString(new SqlObject(sSql).setParameter("cabinetid", boxNumberCode));//��¼���ӵĵ�ַ
			
			sSql = "select CabinetName from archives_Warehouse where CabinetID=:CabinetID ";
			shelfAddress=Sqlca.getString(new SqlObject(sSql).setParameter("cabinetid", shelfNumberCode));//��¼���ӵĵ�ַ
			
			sSql = "select CabinetName from archives_Warehouse where CabinetID=:CabinetID ";
			lineAddress=Sqlca.getString(new SqlObject(sSql).setParameter("cabinetid", lineNumberCode));//��¼�еĵ�ַ
			
			sSql = "select CabinetName from archives_Warehouse where CabinetID=:CabinetID ";
			roomAddress=Sqlca.getString(new SqlObject(sSql).setParameter("cabinetid", recordRoomCode));//��¼�����ҵĵ�ַ
			
			StringBuffer sb=new StringBuffer();
			sb.append("��\""+sRoom+"\"��"+roomAddress+"�������µ�");
			sb.append("��\""+sContractStartno+"\""+lineAddress+"���µ�");
			sb.append("��\""+lineNumSum+"\"��"+shelfAddress+"�����µ�");
			sb.append("��\""+shelfNumSum+"\"��"+boxAddress+"�����µĵ�"+BOXNUMSUM+"λ��");
			
			
			//���º�ͬ��ַ����ͬ�鵵
			Sqlca.executeSQL(new SqlObject("update Business_Contract set BoxNo = '"+boxNumberCode+"' where SerialNo = '"+sObjectNo+"'"));//�������ӱ��
			Sqlca.executeSQL(new SqlObject("update Business_Contract set ShelfNo = '"+shelfNumberCode+"' where SerialNo = '"+sObjectNo+"'"));//���¼��ӱ��
			Sqlca.executeSQL(new SqlObject("update Business_Contract set LineNo = '"+lineNumberCode+"' where SerialNo = '"+sObjectNo+"'"));//�����б��
			Sqlca.executeSQL(new SqlObject("update Business_Contract set RoomNo = '"+recordRoomCode+"' where SerialNo = '"+sObjectNo+"'"));//���µ����ұ��
			
			Sqlca.executeSQL(new SqlObject("update Business_Contract set ISARCHIVE = '01',archiveAddress='"+sb.toString()+"',ARCHIVEDATE='"+nowDate+"' where SerialNo ='"+sObjectNo+"'"));
			returnValue = "�鵵�ɹ�";
		}else{
			//��ͬ����һ
			BOXNUMSUM = BOXNUMSUM + 1;
			contractSum+=1;
			//��ȡ��������ݻ�
			sSql = "select BOXNUMBER from archives_warehouse where cabinetid =:cabinetid ";
			Double dBoxSum = Sqlca.getDouble(new SqlObject(sSql).setParameter("cabinetid",boxNumberCode));
			int iBoxSum=0 ;
			if (dBoxSum!=null){
			   iBoxSum = dBoxSum.intValue();
			}
			if(BOXNUMSUM > iBoxSum){
				boxSum+=1;
				//��ȡ��һ�����ӱ��
//					sSql = "select cabinetid from archives_Warehouse where CreditAttribute='0002' and CodeAttribute='BoxNumberCode' and rownum = '1' and cabinetid <>:cabinetid  order by cabinetid";
				sSql="select t1.cabinetid from archives_Warehouse t1,"
				      +"(SELECT cabinetid, ROW_NUMBER() OVER(ORDER BY cabinetid ) AS RK "
				      +" FROM archives_Warehouse where CreditAttribute = '0002'and CodeAttribute = 'BoxNumberCode') t"
				      +" WHERE t.cabinetid = t1.cabinetid  AND t.rk ='"+boxSum+"'";
				boxNumberCode = Sqlca.getString(new SqlObject(sSql));
				if(boxNumberCode==null) return "���������Ѵ��꣡�����´���һ������";
				if(boxNumberCode!=null &&boxNumberCode.equals("")) return "���������Ѵ��꣡�����´���һ�����ӣ���";
				//��������+1
				shelfNumSum = shelfNumSum + 1;
				//��ʼ����������
				BOXNUMSUM = 1;
				//�������ӱ��
				Sqlca.executeSQL(new SqlObject("update Contract_Starting set BOXNUMBERCODE ='"+boxNumberCode+"'"));

				//��ȡ��������ݻ�
				sSql = "select SHELFNUMBER from archives_warehouse where cabinetid =:cabinetid ";
				int iShelfSum = Sqlca.getDouble(new SqlObject(sSql).setParameter("cabinetid",shelfNumberCode)).intValue();
				if(shelfNumSum > iShelfSum){
					shelfSum+=1;
					//��ȡ��һ�����ӱ��
//						sSql = "select cabinetid from archives_Warehouse where CreditAttribute='0002' and CodeAttribute='ShelfNumberCode' and rownum = '1' and cabinetid <>:cabinetid  order by cabinetid";
					sSql="select t1.cabinetid from archives_Warehouse t1,"
						      +"(SELECT cabinetid, ROW_NUMBER() OVER(ORDER BY cabinetid ) AS RK "
						      +" FROM archives_Warehouse where CreditAttribute = '0002'and CodeAttribute = 'ShelfNumberCode') t"
						      +" WHERE t.cabinetid = t1.cabinetid  AND t.rk ='"+shelfSum+"'";
					shelfNumberCode = Sqlca.getString(new SqlObject(sSql));
					if(shelfNumberCode==null) return "���������Ѵ��꣡�����´���һ������";
					if(shelfNumberCode!=null&&shelfNumberCode.equals("")) return "���������Ѵ��꣡�����´���һ�����ӣ���";
					//������+1
					lineNumSum = lineNumSum + 1;
					//��ʼ����������
					shelfNumSum=1;
					//���¼��ӱ��
					Sqlca.executeSQL(new SqlObject("update Contract_Starting set SHELFNUMBERCODE ='"+shelfNumberCode+"'"));
					
				}
			
				//��ȡ������ݻ�
				sSql = "select LINENUMBER from archives_warehouse where cabinetid =:cabinetid ";
				int iLineSum = Sqlca.getDouble(new SqlObject(sSql).setParameter("cabinetid",lineNumberCode)).intValue();
				if(lineNumSum > iLineSum){
					lineSum+=1;
					//��ȡ��һ���еı��
//						sSql = "select cabinetid from archives_Warehouse where CreditAttribute='0002' and CodeAttribute='LineNumberCode' and rownum = '1' and cabinetid <>:cabinetid  order by cabinetid";
					sSql="select t1.cabinetid from archives_Warehouse t1,"
						      +"(SELECT cabinetid, ROW_NUMBER() OVER(ORDER BY cabinetid ) AS RK "
						      +" FROM archives_Warehouse where CreditAttribute = '0002'and CodeAttribute = 'LineNumberCode') t"
						      +" WHERE t.cabinetid = t1.cabinetid  AND t.rk ='"+lineSum+"'";
					lineNumberCode = Sqlca.getString(new SqlObject(sSql));
					if(lineNumberCode==null) return "�е������Ѵ��꣡�����´���һ���µ���";
					if(lineNumberCode!=null&&lineNumberCode.equals("")) return "�е������Ѵ��꣡�����´���һ���µ��У���";
					//����������+1
					sContractStartno = sContractStartno + 1;
					//��ʼ����
					lineNumSum=1;
					//�����б��
					Sqlca.executeSQL(new SqlObject("update Contract_Starting set LINENUMBERCODE ='"+lineNumberCode+"'"));
				}
			
				//��ȡ�����ҵ�����ݻ�
				sSql = "select RECORDROOM from archives_warehouse where cabinetid =:cabinetid ";
				int iRoomSum = Sqlca.getDouble(new SqlObject(sSql).setParameter("cabinetid",recordRoomCode)).intValue();
			
				if(sContractStartno > iRoomSum){
					sRoom=sRoom+1;
					//��ȡ��һ�������ҵı��
//					sSql = "select cabinetid from archives_Warehouse where CreditAttribute='0002' and CodeAttribute='RecordRoomCode' and rownum = '1' and cabinetid <>:cabinetid  order by cabinetid";
					sSql="select t1.cabinetid from archives_Warehouse t1,"
						      +"(SELECT cabinetid, ROW_NUMBER() OVER(ORDER BY cabinetid ) AS RK "
						      +" FROM archives_Warehouse where CreditAttribute = '0002'and CodeAttribute = 'RecordRoomCode') t"
						      +" WHERE t.cabinetid = t1.cabinetid  AND t.rk ='"+sRoom+"'";
//					recordRoomCode = Sqlca.getString(new SqlObject(sSql).setParameter("cabinetid",  recordRoomCode));
					recordRoomCode = Sqlca.getString(new SqlObject(sSql));
					if(recordRoomCode==null) return "�����������꣡";
					if(recordRoomCode!=null&&recordRoomCode.equals("")){
						return "�����������꣡��";
					}
					//���µ����ұ��
					Sqlca.executeSQL(new SqlObject("update Contract_Starting set CONTRACTSTARTNO ='"+recordRoomCode+"'"));
				}
			}
			
			//�����ֱ������� ��������
			//���±��е�ǰ������ʹ���ݻ�
			Sqlca.executeSQL(new SqlObject("update Contract_Starting set BOXNUMSUM =:BOXNUMSUM").setParameter("BOXNUMSUM",BOXNUMSUM));
			Sqlca.executeSQL(new SqlObject("update archives_Warehouse set boxNumSum =:boxNumSum where cabinetID=:cabinetID").setParameter("boxNumSum",BOXNUMSUM).setParameter("cabinetID",boxNumberCode));
			//���±��е�ǰ������ʹ���ݻ�
			Sqlca.executeSQL(new SqlObject("update Contract_Starting set SHELFNUMSUM =:SHELFNUMSUM").setParameter("SHELFNUMSUM",shelfNumSum));
			Sqlca.executeSQL(new SqlObject("update archives_Warehouse set shelfNumSum =:shelfNumSum where cabinetID=:cabinetID").setParameter("shelfNumSum",shelfNumSum).setParameter("cabinetID",shelfNumberCode));
			//���±��е�ǰ����ʹ���ݻ�
			Sqlca.executeSQL(new SqlObject("update Contract_Starting set LINENUMSUM =:LINENUMSUM").setParameter("LINENUMSUM",lineNumSum));
			Sqlca.executeSQL(new SqlObject("update archives_Warehouse set lineNumSum =:lineNumSum where cabinetID=:cabinetID").setParameter("lineNumSum",lineNumSum).setParameter("cabinetID",lineNumberCode));
			//���±��е�ǰ��������ʹ���ݻ�
			Sqlca.executeSQL(new SqlObject("update Contract_Starting set CONTRACTSTARTNO =:CONTRACTSTARTNO").setParameter("CONTRACTSTARTNO",sContractStartno));
			Sqlca.executeSQL(new SqlObject("update archives_Warehouse set roomNumSum =:roomNumSum where cabinetID=:cabinetID").setParameter("roomNumSum",sContractStartno).setParameter("cabinetID",recordRoomCode));

			//�������е����ҵ�����
			Sqlca.executeSQL(new SqlObject("update Contract_Starting set ROOM =:ROOM").setParameter("ROOM",sRoom));
			//�����ִ��е�����
			Sqlca.executeSQL(new SqlObject("update Contract_Starting set lineSum =:lineSum").setParameter("lineSum",lineSum));
			//�����ִ���ӵ�����
			Sqlca.executeSQL(new SqlObject("update Contract_Starting set shelfSum =:shelfSum").setParameter("shelfSum",shelfSum));
			//�����ִ����ӵ�����
			Sqlca.executeSQL(new SqlObject("update Contract_Starting set boxSum =:boxSum").setParameter("boxSum",boxSum));
			//�����ִ��ͬ������
			Sqlca.executeSQL(new SqlObject("update Contract_Starting set contractSum =:contractSum").setParameter("contractSum",contractSum));
			
			//��ѯ���µ����ҡ��С����ӡ�������ʹ�õ�����
			sSql = "select CONTRACTSTARTNO,LINENUMSUM,SHELFNUMSUM,BOXNUMSUM,ROOM from Contract_Starting";
			rs = Sqlca.getASResultSet(sSql);
			if(rs.next()){
				sContractStartno = rs.getInt("CONTRACTSTARTNO");//��������ʹ�õ�����
				lineNumSum = rs.getInt("LINENUMSUM");//����ʹ�õ�����
				shelfNumSum = rs.getInt("SHELFNUMSUM");//������ʹ�õ�����
				BOXNUMSUM = rs.getInt("BOXNUMSUM");//������ʹ�õ�����
				sRoom = rs.getInt("ROOM");//���ŵ�����
			}
			rs.close();
			
			//��ѯ��ַ������ƴ��
			sSql = "select CabinetName from archives_Warehouse where CabinetID=:CabinetID ";
			boxAddress=Sqlca.getString(new SqlObject(sSql).setParameter("cabinetid", boxNumberCode));//��¼���ӵĵ�ַ
			
			sSql = "select CabinetName from archives_Warehouse where CabinetID=:CabinetID ";
			shelfAddress=Sqlca.getString(new SqlObject(sSql).setParameter("cabinetid", shelfNumberCode));//��¼���ӵĵ�ַ
			
			sSql = "select CabinetName from archives_Warehouse where CabinetID=:CabinetID ";
			lineAddress=Sqlca.getString(new SqlObject(sSql).setParameter("cabinetid", lineNumberCode));//��¼�еĵ�ַ
			
			sSql = "select CabinetName from archives_Warehouse where CabinetID=:CabinetID ";
			roomAddress=Sqlca.getString(new SqlObject(sSql).setParameter("cabinetid", recordRoomCode));//��¼�����ҵĵ�ַ
			StringBuffer sb=new StringBuffer();
			sb.append("��\""+sRoom+"\"��"+roomAddress+"�������µ�");
			sb.append("��\""+sContractStartno+"\""+lineAddress+"���µ�");
			sb.append("��\""+lineNumSum+"\"��"+shelfAddress+"�����µ�");
			sb.append("��\""+shelfNumSum+"\"��"+boxAddress+"�����µĵ�"+BOXNUMSUM+"λ��");
			
			
			//���º�ͬ��ַ����ͬ�鵵
			Sqlca.executeSQL(new SqlObject("update Business_Contract set BoxNo = '"+boxNumberCode+"' where SerialNo = '"+sObjectNo+"'"));//�������ӱ��
			Sqlca.executeSQL(new SqlObject("update Business_Contract set ShelfNo = '"+shelfNumberCode+"' where SerialNo = '"+sObjectNo+"'"));//���¼��ӱ��
			Sqlca.executeSQL(new SqlObject("update Business_Contract set LineNo = '"+lineNumberCode+"' where SerialNo = '"+sObjectNo+"'"));//�����б��
			Sqlca.executeSQL(new SqlObject("update Business_Contract set RoomNo = '"+recordRoomCode+"' where SerialNo = '"+sObjectNo+"'"));//���µ����ұ��
			
			Sqlca.executeSQL(new SqlObject("update Business_Contract set ISARCHIVE = '01',archiveAddress='"+sb.toString()+"',ARCHIVEDATE='"+nowDate+"' where SerialNo = '"+sObjectNo+"'"));
			returnValue = "�鵵�ɹ�";
			
		}
	   
		return returnValue;
	}
	
	
	//�õ������ӵı�š����ơ���ַ
	public void goAddress(Transaction Sqlca) throws Exception{
		
		//�õ��ü��ӱ��,���ӵ�����
		sSql="select sno,cabinetname from archives_warehouse where CreditAttribute='0002' and CodeAttribute='BoxNumberCode' and cabinetid=:cabinetid";
		rs=Sqlca.getASResultSet(new SqlObject(sSql).setParameter("cabinetid", CabinetID2));
		if(rs.next()){
			shelfCode=rs.getString("sno");
			boxName=rs.getString("cabinetname");
		}
		rs.close();
		
		//�õ����еı�š����ӵ�����
		sSql="select sno,cabinetname from archives_warehouse where CreditAttribute='0002' and CodeAttribute='ShelfNumberCode' and cabinetid=:cabinetid";
		rs=Sqlca.getASResultSet(new SqlObject(sSql).setParameter("cabinetid", shelfCode));
		if(rs.next()){
			lineCode=rs.getString("sno");
			shelfName=rs.getString("cabinetname");
		}
		rs.close();
		
		//�õ��õ����ҵı�š��е�����
		sSql="select sno,cabinetname from archives_warehouse where CreditAttribute='0002' and CodeAttribute='LineNumberCode' and cabinetid=:cabinetid";
		rs=Sqlca.getASResultSet(new SqlObject(sSql).setParameter("cabinetid", lineCode));
		if(rs.next()){
			roomCode=rs.getString("sno");
			lineName=rs.getString("cabinetname");
		}
		rs.close();
		
		//�õ��õ����ҵ�����
		sSql="select cabinetname from archives_warehouse where CreditAttribute='0002' and CodeAttribute='RecordRoomCode'  and cabinetid=:cabinetid ";
		roomName=Sqlca.getString(new SqlObject(sSql).setParameter("sno",shelfCode ).setParameter("cabinetid", roomCode));
		
		//�õ��õ����ҡ����С��ü����µڼ�������
		sSql="select count(1) from archives_warehouse where CreditAttribute='0002' and CodeAttribute='BoxNumberCode' and sno=:sno and cabinetid<=:cabinetid order by cabinetid";
		boxNum=Integer.parseInt(Sqlca.getString(new SqlObject(sSql).setParameter("sno",shelfCode ).setParameter("cabinetid", CabinetID2)));
		//�õ��õ����ҡ����еĵڼ�������
		sSql="select count(1) from archives_warehouse where CreditAttribute='0002' and CodeAttribute='ShelfNumberCode' and sno=:sno and cabinetid<=:cabinetid order by cabinetid";
		shelfNum=Integer.parseInt(Sqlca.getString(new SqlObject(sSql).setParameter("sno",lineCode ).setParameter("cabinetid", shelfCode)));
		//�õ��õ����ҵڼ���
		sSql="select count(1) from archives_warehouse where CreditAttribute='0002' and CodeAttribute='LineNumberCode' and sno=:sno and cabinetid<=:cabinetid order by cabinetid";
		lineNum=Integer.parseInt(Sqlca.getString(new SqlObject(sSql).setParameter("sno",roomCode ).setParameter("cabinetid", lineCode)));
		//�õ��ڼ���������
		sSql="select count(1) from archives_warehouse where CreditAttribute='0002' and CodeAttribute='RecordRoomCode' and cabinetid<=:cabinetid order by cabinetid";
		roomNum=Integer.parseInt(Sqlca.getString(new SqlObject(sSql).setParameter("cabinetid", roomCode)));
	}
	
	//��ͬ�浵��ַ���
	public String updateAdderss(Transaction Sqlca) throws Exception{
		int i=0;
		String contractNum="";//�ú�ͬ�������е�λ��
		String sSerialNo="";
		goAddress(Sqlca);
		sSql ="select serialno, archiveAddress from business_contract where boxNo=:boxNo";
		rs=Sqlca.getASResultSet(new SqlObject(sSql).setParameter("boxNo", CabinetID1));
		while(rs.next()){
			//��ȡԭ����ͬ�������е�λ��
			sSerialNo=rs.getString("serialno");
			contractNum=rs.getString("archiveAddress");
			contractNum=contractNum.substring(contractNum.lastIndexOf("-")+1, contractNum.length());
			
			//����ԭ����ͬ��ַ
			sSql="update business_contract set archiveAddress='A0"+roomNum+"0"+lineNum+shelfName+boxNum+"-"+contractNum+"',boxNo='"+CabinetID2
			    		+ "',shelfNo='"+shelfCode+"',lineNo='"+lineCode+"',roomNo='"+roomCode+"' where serialno=:serialno";
			
//			//����ԭ����ͬ��ַ
//			sSql="update business_contract set archiveAddress='��\""+roomNum+"\"��"+roomName+"�������µĵ�\""+lineNum+"\""+lineName+"���µ�"
//			    +"��\""+shelfNum+"\"��"+shelfName+"�����µĵ�\""+boxNum+"\"��"+boxName+"�����µĵ�"+contractNum+"λ��',boxNo='"+CabinetID2
//			    		+ "',shelfNo='"+shelfCode+"',lineNo='"+lineCode+"',roomNo='"+roomCode+"' where serialno=:serialno";
			Sqlca.executeSQL(new SqlObject(sSql).setParameter("serialno", sSerialNo));
			
			Sqlca.executeSQL(new SqlObject("update Business_Contract set BoxNo = '"+CabinetID2+"' where SerialNo = '"+sSerialNo+"'"));//��ԭ��ͬ���ӱ��
			Sqlca.executeSQL(new SqlObject("update Business_Contract set ShelfNo = '"+shelfCode+"' where SerialNo = '"+sSerialNo+"'"));//����ԭ��ͬ���ӱ��
			Sqlca.executeSQL(new SqlObject("update Business_Contract set LineNo = '"+lineCode+"' where SerialNo = '"+sSerialNo+"'"));//����ԭ��ͬ�б��
			Sqlca.executeSQL(new SqlObject("update Business_Contract set RoomNo = '"+roomCode+"' where SerialNo = '"+sSerialNo+"'"));//����ԭ��ͬ�����ұ��
			i++;
		}
		rs.close();
		
		//ԭ�����������
		sSql="update archives_warehouse set boxNumSum='' where CabinetID=:CabinetID";
		Sqlca.executeSQL(new SqlObject(sSql).setParameter("CabinetID", CabinetID1));
		//��������������
		sSql="update archives_warehouse set boxNumSum=:boxNumSum where CabinetID=:CabinetID";
		Sqlca.executeSQL(new SqlObject(sSql).setParameter("boxNumSum", i).setParameter("CabinetID", CabinetID2));
		
		return "����ɹ���";
	}
	
	
	public String updateFile(Transaction Sqlca) throws Exception{
		ASResultSet rs = null;
		ASResultSet rs1 = null;
		ASResultSet rs2 = null;
		ASResultSet rs3 = null;
		int boxNumber=0;//���ӵ�����
		int shelfNumber=0;//���ӵ�����
		int lineNumber=0;//�е�����
		int roomNumber=0;//����������
		String flag="";
		
		SimpleDateFormat forMat=new SimpleDateFormat("yyyy/MM/dd");
		String nowDate=forMat.format(new Date());
		
		//��һ���жϵ����ҡ��С����ӡ����Ӳ���Ϊ��
		String[] returnValue=init(Sqlca).split("@");
		if(returnValue[1].equals("true")){
			//�õ������ұ��
			sSql="select cabinetid,RecordRoom,cabinetName from archives_Warehouse where CreditAttribute='0002' and CodeAttribute='RecordRoomCode' order by cabinetid";
			rs3=Sqlca.getASResultSet(new SqlObject(sSql));
			while(rs3.next()){
				recordRoomCode=rs3.getString("cabinetid");
				roomNumber=Integer.parseInt(rs3.getString("RecordRoom"));
				roomAddress=rs3.getString("cabinetName");
				//�õ��ڼ���������
				sSql="select count(1) from archives_warehouse where CreditAttribute='0002' and CodeAttribute='RecordRoomCode' and cabinetid<=:cabinetid order by cabinetid";
				sContractStartno=Integer.parseInt(Sqlca.getString(new SqlObject(sSql).setParameter("cabinetid", recordRoomCode)));
				
				
				//�õ��б��
				sSql="select cabinetid,lineNumber,cabinetName from archives_warehouse where CreditAttribute='0002' and CodeAttribute='LineNumberCode' and sno = '"+recordRoomCode+"' order by cabinetid";
				rs2=Sqlca.getASResultSet(new SqlObject(sSql));
				while(rs2.next()){
					lineNumberCode=rs2.getString("cabinetid");
					lineNumber=Integer.parseInt(rs2.getString("lineNumber"));
					lineAddress=rs2.getString("cabinetName");
					//�õ��ڼ���
					sSql="select count(1) from archives_warehouse where CreditAttribute='0002' and CodeAttribute='LineNumberCode' and sno=:sno and cabinetid<=:cabinetid order by cabinetid";
					lineNumSum=Integer.parseInt(Sqlca.getString(new SqlObject(sSql).setParameter("sno", recordRoomCode).setParameter("cabinetid", lineNumberCode)));
					
					//�õ����ӱ��
					sSql="select cabinetid,shelfNumber,cabinetName from archives_warehouse where CreditAttribute='0002' and CodeAttribute='ShelfNumberCode' and sno = '"+lineNumberCode+"' order by cabinetid";
					rs1=Sqlca.getASResultSet(new SqlObject(sSql));
					while(rs1.next()){
						shelfNumberCode=rs1.getString("cabinetid");
						shelfNumber=Integer.parseInt(rs1.getString("shelfNumber"));
						shelfAddress=rs1.getString("cabinetName");
						//�õ��ڼ�����
						sSql="select count(1) from archives_warehouse where CreditAttribute='0002' and CodeAttribute='ShelfNumberCode' and sno=:sno and cabinetid<=:cabinetid order by cabinetid";
						shelfNumSum=Integer.parseInt(Sqlca.getString(new SqlObject(sSql).setParameter("sno",lineNumberCode).setParameter("cabinetid", shelfNumberCode)));
						
						
						//�õ����ӱ��
						sSql="select cabinetid,boxNumber,cabinetName from archives_warehouse where CreditAttribute='0002' and CodeAttribute='BoxNumberCode' and sno = '"+shelfNumberCode+"' order by cabinetid";
						rs=Sqlca.getASResultSet(new SqlObject(sSql));
						while(rs.next()){
							boxNumberCode=rs.getString("cabinetid");//���ӵı��
							boxNumber=Integer.parseInt(rs.getString("boxNumber"));//���ӵ�����
							boxAddress=rs.getString("cabinetName");
							//�õ��ڼ�������
							sSql="select count(1) from archives_warehouse where CreditAttribute='0002' and CodeAttribute='BoxNumberCode' and sno=:sno and cabinetid<=:cabinetid order by cabinetid";
							BOXNUMSUM=Integer.parseInt(Sqlca.getString(new SqlObject(sSql).setParameter("sno", shelfNumberCode).setParameter("cabinetid", boxNumberCode)));
							
							//���µ�ǰ�����Ѿ������ӵ�����
							sSql="update archives_warehouse set shelfNumSum='"+BOXNUMSUM+"' where cabinetid='"+shelfNumberCode+"'";
							Sqlca.executeSQL(new SqlObject(sSql));
							//���µ�ǰ���Ѵ�ļ��ӵ�����
							sSql="update archives_warehouse set lineNumSum='"+shelfNumSum+"' where cabinetid='"+lineNumberCode+"'";
							Sqlca.executeSQL(new SqlObject(sSql));
							//���µ�ǰ�������Ѵ��е�����
							sSql="update archives_warehouse set roomNumSum='"+lineNumSum+"' where cabinetid='"+recordRoomCode+"'";
							Sqlca.executeSQL(new SqlObject(sSql));
							
							
							//��ѯ��ǰ��ʼ�����Ѿ����������i
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
								
								//���µ�ǰ�����Ѵ����ͬ������
								sSql="update archives_warehouse set boxNumSum='"+i+"' where cabinetid='"+boxNumberCode+"'";
								Sqlca.executeSQL(new SqlObject(sSql));
								StringBuffer sb=new StringBuffer();
								sb.append("A0"+sContractStartno);
								sb.append("0"+lineNumSum);
								sb.append(shelfAddress);
								sb.append(BOXNUMSUM+"-"+sContractNumber);
//								sb.append("��\""+sContractStartno+"\"��"+roomAddress+"�������µ�");
//								sb.append("��\""+lineNumSum+"\""+lineAddress+"���µ�");
//								sb.append("��\""+shelfNumSum+"\"��"+shelfAddress+"�����µ�");
//								sb.append("��\""+BOXNUMSUM+"\"��"+boxAddress+"�����µĵ�"+i+"λ��");
								
								//����bc���ͬ�еĵ����ҡ��С����ӡ����ӵı�š���ͬ�鵵
								Sqlca.executeSQL(new SqlObject("update Business_Contract set BoxNo = '"+boxNumberCode+"' where SerialNo = '"+SerialNo+"'"));//�������ӱ��
								Sqlca.executeSQL(new SqlObject("update Business_Contract set ShelfNo = '"+shelfNumberCode+"' where SerialNo = '"+SerialNo+"'"));//���¼��ӱ��
								Sqlca.executeSQL(new SqlObject("update Business_Contract set LineNo = '"+lineNumberCode+"' where SerialNo = '"+SerialNo+"'"));//�����б��
								Sqlca.executeSQL(new SqlObject("update Business_Contract set RoomNo = '"+recordRoomCode+"' where SerialNo = '"+SerialNo+"'"));//���µ����ұ��

								Sqlca.executeSQL(new SqlObject("update Business_Contract set ISARCHIVE = '01',archiveAddress='"+sb.toString()+"',ARCHIVEDATE='"+nowDate+"' where SerialNo = '"+SerialNo+"'"));
								return "�鵵�ɹ���";
							}
						}
						rs.close();
					}
					rs1.close();
				}
				rs2.close();
			}
			rs3.close();
			flag="���������꣡";
		}else{
			flag=returnValue[0];
		}
		
		return flag;
	}
	
	public String init(Transaction Sqlca) throws Exception{
		String returnValue="����@true";
		recordRoomCode=Sqlca.getString(new SqlObject("select cabinetid from archives_Warehouse where CreditAttribute='0002' and CodeAttribute='RecordRoomCode' order by cabinetid"));
		lineNumberCode = Sqlca.getString("select cabinetid from archives_warehouse where CreditAttribute='0002' and CodeAttribute='LineNumberCode' and sno = '"+recordRoomCode+"' order by cabinetid");
		shelfNumberCode = Sqlca.getString("select cabinetid from archives_warehouse where CreditAttribute='0002' and CodeAttribute='ShelfNumberCode' and sno = '"+lineNumberCode+"' order by cabinetid");
		boxNumberCode = Sqlca.getString("select cabinetid from archives_warehouse where CreditAttribute='0002' and CodeAttribute='BoxNumberCode' and sno = '"+shelfNumberCode+"' order by cabinetid");
		if(boxNumberCode==null) returnValue= "���Ӳ���Ϊ��!@false";
		if(shelfNumberCode==null) returnValue= "���Ӳ���Ϊ��!@false";
		if(lineNumberCode==null) returnValue= "�в���Ϊ��!@false";
		if(recordRoomCode==null) returnValue= "�����Ҳ���Ϊ��!@false";
		return returnValue;
	}
}
