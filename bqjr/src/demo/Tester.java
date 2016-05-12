package demo;

import java.sql.Connection;
import java.text.SimpleDateFormat;
import java.util.Date;

import com.amarsoft.are.ARE;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.lang.DataElement;
import com.amarsoft.oti.OTIConnection;
import com.amarsoft.oti.OTIManager;
import com.amarsoft.oti.OTITransaction;
import com.amarsoft.oti.TXException;
import com.amarsoft.oti.TXMessageBody;
import com.amarsoft.oti.TXResult;

//���Ը��˴���ſ�ҵ�� 
public class Tester {
	public static void main(String[] args){
		//��ʼARE����
		if(!ARE.isInitOk()) ARE.init();
		
		OTIManager manager = OTIManager.getManager();
		System.out.println(manager==null);
		try {
			//��ȡ����
			Connection conn =  ARE.getDBConnection("als");
			System.out.println(conn);
			/*OTIConnection conn = manager.getConnectionInstance("als");
			conn.open();
			//��ȡ����
			OTITransaction trans = manager.getTransactionInstance("88011");
			DataElement de	= null;
			//��ʼ������ͷ
			BizObject bo = trans.getRequestHeader();
			
			SimpleDateFormat df = new SimpleDateFormat("yyyy-mm-dd");
			Date date = new Date();
			
			de = bo.getAttribute("INPUTDATE");
			de.setValue(df.format(date));
			df.applyPattern("h:mm");
			de = bo.getAttribute("INPUTTIME");
			de.setValue(df.format(date));
						
			//��ʼ��������
			trans.initRequestBody(" bp.SerialNO='BP20090106000010' and bp.ContractSerialNo=bc.SerialNO");
			
			
			//��ʼ�������� ʹ��Ĭ��ֵ
			TXMessageBody requestBody = trans.getRequestBody();
			BizObject biz = bo = requestBody.getObject(0);
			//�ſ�����[0��ͨ�ſ�1���ҷſ�]
			de = biz.getAttribute("CREDITTYPE");
			de.setValue("0");
					
			//ִ�н���s
			TXResult result = conn.executeTransaction(trans);
			System.out.println(result.toString());
			BizObject bore = trans.getResponseHeader();
			
			int length = 0;
			
			for(int j=0; j<bore.getAttributeNumber(); j++){
				length += bore.getAttribute(j).getLength();
				System.out.println("�����ֶ�����"+bore.getAttribute(j).getName()+"  �ֶ�ֵ:"+bore.getAttribute(j).getString());
			}
			
			TXMessageBody responsBody = trans.getResponseBody();
			if(responsBody != null){
			System.out.println("���������峤�ȣ�"+responsBody.size());
			for(int i=0; i<responsBody.size();i++){
				bo = responsBody.getObject(i);
				for(int j=0; j<bo.getAttributeNumber(); j++){
					length += bo.getAttribute(j).getLength();
					System.out.println("�ֶ�����"+bo.getAttribute(j).getName()+"  �ֶ�ֵ:"+bo.getAttribute(j).getString());
				}
			}
			}*/
			
			conn.close();
		}  catch (Exception e) {
			// TODO: handle exception
		}
	}
}
