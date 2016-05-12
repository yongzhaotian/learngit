package com.amarsoft.app.lending.bizlets;

import java.util.Hashtable;

import com.amarsoft.are.ARE;
import com.amarsoft.are.util.StringFunction;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.DBKeyHelp;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;
import com.amarsoft.context.ASUser;

/**  
 *    Describe: --���Ź�������.
 *			      ��ϵ����:  <li>���Լ��Ĺ�ϵΪ      0000</li>
 *      				  	<li>��ͬ���˴���Ϊ      0100</li> 
 *				  	        <li>����ع�Ϊ          0200</li> 
 *					     	<li>���ع�Ϊ            5200</li> 
 *					  		<li>��ͬ���������ع�Ϊ   0250</li> 
 *					  		<li>�����߹ܹ�����˾Ϊ   0300</li><p>
 *   HistoryLog:
 * @Author  pwang 2009-10-20
*/
public class SaveRelaResult  extends Bizlet {
	/** 
	 * @param  		   <li>CustomerID��	Դ�ͻ�ID</li>
	 *			<li>GroupRelaCustStr1��������˾ID</li>
	 *			<li>GroupRelaCustStr2��������ϵ����</li>
	 *		 		  <li>CustomerStr��	�����õ���ƴ���ַ���</li>
	 * @return    SerialNo  ��ˮ��
	 */
	public Object  run(Transaction Sqlca) throws Exception{
		//���崫���������
		/**¼���û�ID*/
		String sInputUser         = (String)this.getAttribute("InputUser");
		/**Դ�ͻ�ID */
		String sCustomerID   	  = (String)this.getAttribute("CustomerID");
		/**������˾ID*/
		String sGroupRelaCustStr1 = (String)this.getAttribute("GroupRelaCustStr1");
		/**������ϵ����*/
		String sGroupRelaCustStr2 = (String)this.getAttribute("GroupRelaCustStr2");
		/**�����ÿͻ�ID��*/
		String sCustomerStr 	  = (String)this.getAttribute("CustomerStr");
		
		if(sInputUser == null) sInputUser = "";
		if(sGroupRelaCustStr1 == null) sGroupRelaCustStr1 = "";
		if(sGroupRelaCustStr2 == null) sGroupRelaCustStr2 = "";
				
		/**
		 * �������:
		 *       <li>user :��ǰ�û�.</li>
		 *       <li>sSql </li>
		 *       <li>rs :��ǰ�û�.</li>
		 *       <li>sSerialNo :����������GROUP_RESULT��ˮ��.</li>
		 *       <li>sCurDate :��ǰ����.</li>
		 *       <li>RelaSearchht :����ԭ�й�����¼�Ĺ����ͻ�.</li>
		 *       <li>RelaSearchht2 :����ԭ�й�����¼����Ĺ����ͻ�.</li>
		 *       <li>ResultCust1 :ѭ���������ݴ�CustomerID.</li>
		 *       <li>ResultCust2 :ѭ���������ݴ������ϵ����.</li>
		 *       <li>CustomerIDbuffer :�ݴ�CustomerID.</li>		
		 */
		ASUser user = ASUser.getUser(sInputUser,Sqlca);	
		String sSql ="";	
		ASResultSet rs =null;	
		String sSerialNo ="";
		String sCurDate = "";
		Hashtable RelaSearchht = new Hashtable(); 
		Hashtable RelaSearchht2 = new Hashtable(); 
		String[] ResultCust1 ;
		String[] ResultCust2 ;
		String CustomerIDbuffer ="";
		SqlObject so;
				
		try{
			/**�����õ�ԭ�й�����˾���Ա���������»����²�����жϡ�*/
			sSql ="select RelativeID from GROUP_SEARCH where CustomerID =:CustomerID "; 
			so = new SqlObject(sSql).setParameter("CustomerID", sCustomerID);
			rs = Sqlca.getASResultSet(so);	
			while (rs.next()){
				CustomerIDbuffer =rs.getString("RelativeID");
				if(!RelaSearchht.containsKey(CustomerIDbuffer))
					RelaSearchht.put(CustomerIDbuffer,"");//����ԭ�й�����˾��
			}		
		}catch(Exception e){
			ARE.getLog().error(e.getMessage());
		}finally{
			rs.getStatement().close(); 
			rs=null;
		}
		CustomerIDbuffer="";
		try{
			//�����õ�ԭ�з��������˾���Ա���������»����²�����жϡ�
			sSql ="select CustomerID from GROUP_SEARCH where RelativeID =:RelativeID ";
			so = new SqlObject(sSql).setParameter("RelativeID", sCustomerID);
			rs = Sqlca.getASResultSet(so);
			while (rs.next()){
				CustomerIDbuffer =rs.getString("CustomerID");
				if(!RelaSearchht2.containsKey(CustomerIDbuffer))
					RelaSearchht2.put(CustomerIDbuffer,"");//����ԭ�й�����˾��
			}			

		}catch(Exception e){
			ARE.getLog().error(e.getMessage());
		}finally{
			rs.getStatement().close(); 
			rs=null;
		}

		sCurDate = StringFunction.getToday();
		//���»���뱾�������Ĺ�����ϵ��
		ResultCust1 =sGroupRelaCustStr1.split("@");
		ResultCust2 =sGroupRelaCustStr2.split("@");
		for(int i=0;i<ResultCust1.length;i++){
			if(ResultCust1[i]!=""&&!ResultCust2[i].equals("0000")){
				//�������.
				if(RelaSearchht.containsKey(ResultCust1[i])){
					try{//���еļ�¼�����¡�
						sSql ="update GROUP_SEARCH SET Relativetype =:Relativetype ,updatedate =:updatedate ," +
						"updateorgid =:updateorgid ,updateuserid =:updateuserid where CustomerID =:CustomerID and RelativeID =:RelativeID " ;
						so = new SqlObject(sSql);
						so.setParameter("Relativetype", ResultCust2[i]).setParameter("updatedate", sCurDate).setParameter("updateorgid", user.getOrgID())
						.setParameter("updateuserid", sInputUser).setParameter("CustomerID", sCustomerID).setParameter("RelativeID", ResultCust1[i]);
						Sqlca.executeSQL(so);
					}
					catch(Exception e){
						ARE.getLog().error(e.getMessage());
						throw new Exception(e);
					}						
				}else{
					try{//δ�еļ�¼�����롣
						sSql ="INSERT INTO GROUP_SEARCH VALUES (:CustomerID,:R1,:R2,'1',:OrgID,:UserID,:Date,'','','')";
						so =  new SqlObject(sSql).setParameter("CustomerID", sCustomerID).setParameter("R1", ResultCust1[i]).setParameter("R2", ResultCust2[i])
						.setParameter("OrgID", user.getOrgID()).setParameter("UserID", sInputUser).setParameter("Date", sCurDate);
						Sqlca.executeSQL(so);
					}
					catch(Exception e){
						ARE.getLog().error(e.getMessage());
						throw new Exception(e);
					}	
				}
				
				//�������.
				//�����عɹ�ϵֵ.
				if(ResultCust2[i].equals("0200"))
					ResultCust2[i]="5200";
				else{
					if(ResultCust2[i].equals("5200"))
						ResultCust2[i]="0200";
				}				
				if(RelaSearchht2.containsKey(ResultCust1[i])){
					try{//���еļ�¼�����¡�
						sSql ="update GROUP_SEARCH SET Relativetype =:Relativetype,updatedate =:updatedate ," +
						"updateorgid =:updateorgid ,updateuserid =:updateuserid where CustomerID =:CustomerID and RelativeID =:RelativeID " ;
						so = new SqlObject(sSql);
						so.setParameter("Relativetype", ResultCust2[i]).setParameter("updatedate", sCurDate).setParameter("updateorgid", user.getOrgID())
						.setParameter("updateuserid", sInputUser).setParameter("CustomerID", ResultCust1[i]).setParameter("RelativeID", sCustomerID);
						Sqlca.executeSQL(so);
					}
					catch(Exception e){
						ARE.getLog().error(e.getMessage());
						throw new Exception(e);
					}		
				}else{
					try{//δ�еļ�¼�����롣
						sSql ="INSERT INTO GROUP_SEARCH VALUES (:R1,:CustomerID,:R2,'1',:OrgID,:UserID,:Date,'','','')";
						so = new SqlObject(sSql);
						so.setParameter("R1", ResultCust1[i]).setParameter("CustomerID", sCustomerID).setParameter("R2", ResultCust2[i])
						.setParameter("OrgID", user.getOrgID()).setParameter("UserID", sInputUser).setParameter("Date", sCurDate);
						Sqlca.executeSQL(so);
					}
					catch(Exception e){
						ARE.getLog().error(e.getMessage());
						throw new Exception(e);
					}	
				}
			}
		}		

		String[] terms = sCustomerStr.split("\\$");//����ַ���Ϊ�����������������
		String NullStrLength ="";
		String termString ="";

		sSerialNo = DBKeyHelp.getSerialNo("GROUP_RESULT","SerialNo",Sqlca);//������ˮ��		
		if(sSerialNo != "" && sSerialNo != null){
			if(terms.length>=5){
				try{
					sSql ="INSERT INTO GROUP_RESULT VALUES (:SerialNo,:CustomerID,:T0,:T1,:T2,:T3,:T4,'','',:Date,:UserID)";//һ��insert�����С�
					so = new SqlObject(sSql).setParameter("SerialNo", sSerialNo).setParameter("CustomerID", sCustomerID).setParameter("T0", terms[0])
					.setParameter("T1", terms[1]).setParameter("T2", terms[2]).setParameter("T3", terms[3]).setParameter("T4", terms[4])
					.setParameter("Date", StringFunction.getToday()).setParameter("UserID", sInputUser);
					Sqlca.executeSQL(so);
				}
				catch(Exception e){
					ARE.getLog().error(e.getMessage());
					throw new Exception(e);
				}
			}else{
				//��SQL���Ŀ�ֵ�ַ���ƴ��.
				for(int j=4;j>=terms.length;j--)
					NullStrLength+="'',";
				for(int j = 0;j<terms.length;j++){
					termString+="'"+terms[j]+"',";
				}
				try{
					sSql ="INSERT INTO GROUP_RESULT VALUES (:SerialNo,:CustomerID," + termString+NullStrLength + "'','',:Date,:UserID)";//һ��insert�����С�
					so = new SqlObject(sSql).setParameter("SerialNo", sSerialNo).setParameter("CustomerID", sCustomerID)
					.setParameter("Date", StringFunction.getToday()).setParameter("UserID", sInputUser);
					 Sqlca.executeSQL(so);
				}
				catch(Exception e){
					ARE.getLog().error(e.getMessage());
					throw new Exception(e);
				}
				ARE.getLog().info("-------------terms.length:"+terms.length+"-----------------");
			}
		}	
		return sSerialNo;
		
	}

}
