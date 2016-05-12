package demo;

import java.text.SimpleDateFormat;
import java.util.Date;

import com.amarsoft.are.ARE;
import com.amarsoft.are.AREException;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.lang.DataElement;
import com.amarsoft.oti.OTIConnection;
import com.amarsoft.oti.OTIManager;
import com.amarsoft.oti.OTITransaction;
import com.amarsoft.oti.TXException;
import com.amarsoft.oti.TXMessageBody;
import com.amarsoft.oti.TXResult;

//���Կͻ��ˡ����Դ���֤���˺����
public class DZTestClient {
	public static void main(String[] args){
		//��ʼARE����
		if(!ARE.isInitOk()) ARE.init();
		
		OTIManager manager = OTIManager.getManager();
		System.out.println(manager==null);

		try {
			//��ȡ����
			OTIConnection conn = manager.getConnectionInstance("DZconn");
			//OTIConnection conn = OTIManager.getConnection("DZconn");
			conn.open();
			//��ȡ����IDΪ88017�Ľ���
			OTITransaction trans = manager.getTransactionInstance("88017");
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
			
			//��ʼ�������� ʹ��Ĭ��ֵ����accountno��ֵ���Դ�ҳ�洫��������
			trans.initRequestBody("accountno in ('6229370101000008026' ,'6229370101000030368') and orgid='1000'");
			TXMessageBody requestBody = trans.getRequestBody();
			System.out.println("������ĳ���"+requestBody.size());			
					
			//ִ�н���
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
			}else{
				System.out.println("����������Ϊ��");
			}
			
			conn.close();
		} catch (TXException e) {
			e.printStackTrace();
		} catch (JBOException e) {
			e.printStackTrace();
		}
	}
}
