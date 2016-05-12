package com.amarsoft.app.lending.bizlets;

import com.amarsoft.are.ARE;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

/**
 *  Description:   ����ʱ���²�������������ѡ����ͬ�����ĵ���ݵ�ԭ��ݺ��ֶΣ�����������±�־. 
 *         Time:   2009/10/26    
 *       @author   PWang 
 *        @param   BCSerialNo,OriBDSerialNo            
 */
public class DataInputLater extends Bizlet {

	public Object run(Transaction Sqlca) throws Exception{
		
		//��ȡ��������ͬ��ˮ�ţ�ԭ�����ˮ�š�
		String sBCSerialNo = (String)this.getAttribute("BCSerialNo");	
		String sOriBDSerialNo = (String)this.getAttribute("OriBDSerialNo");	
		String sBDSerialNo = "";
		String sSql ="";
		ASResultSet rs = null;
		SqlObject so ;//��������
		
		try{
			//��������������ͬ,һ�ʵ���ݶ�Ӧһ�ʵ���ͬ
			//��ȡ�õ���ͬ�����ĵ������ˮ��
				sSql = "select SerialNo from Business_Duebill where RelativeSerialNo2 =:RelativeSerialNo2 ";
				so = new SqlObject(sSql).setParameter("RelativeSerialNo2", sBCSerialNo);
				rs = Sqlca.getASResultSet(so);
	
				if(rs.next()){
					sBDSerialNo = rs.getString("SerialNo");
				}else{
					//û�й�����ͬ�Ľ����ˮ�ţ�����ִ����Ϣ��־��2����
					return "2";
				}
			}
			catch(Exception e){
				ARE.getLog().error(e.getMessage(),e);
				throw e;
			}
			finally{
				rs.getStatement().close();
				rs = null;
			}

		try{
			//���µ�����е�ԭ�����ˮ���ֶΡ�
				sSql="Update Business_Duebill set RelativeDuebillNo =:RelativeDuebillNo where SerialNo =:SerialNo";	
				so = new SqlObject(sSql).setParameter("RelativeDuebillNo", sOriBDSerialNo).setParameter("SerialNo", sBDSerialNo);
				Sqlca.executeSQL(so);
			//�������ݵĸ��±�־��
				sSql="Update Business_Contract set ReinforceFlag = '020' where SerialNo =:SerialNo ";
				so = new SqlObject(sSql).setParameter("SerialNo", sBCSerialNo);
				Sqlca.executeSQL(so);
			//����ִ�гɹ���Ϣ��־��1����
				return "1";				
			}
			catch(Exception e){
				throw new Exception(e);
			}
	
	}

}
