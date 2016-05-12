package demo;

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

public class SZSTestClient {
	public static void main(String[] args){
		if(!ARE.isInitOk()){
			ARE.init();
		}
		try{
			//��ȡʵʱ�ӿڹ�����
			OTIManager manager = OTIManager.getManager();
			//ͨ�������ȡһ������:connName�Ľ�������
			OTIConnection conn = manager.getConnectionInstance("SZSconn");
			conn.open();
			//ͨ�������ȡһ�����У�transID�Ľ��׶���
			OTITransaction trans = manager.getTransactionInstance("9613");
			//ͨ��JBO�Զ������׶���ֵ
			trans.initRequestBody(" serialno='BP20090106000010'");
			
			DataElement de	= null;
			//���ð��塢���峤��
			BizObject bor = trans.getRequestHeader();
			de = bor.getAttribute("SIA-TR-BAG");
			//������峤,ָ�����ֽڳ���
			int len = 0;
			for(int i=0;i<bor.getAttributeNumber();i++){
				len += bor.getAttribute(i).getLength();
				System.out.println("�ֶ�����"+bor.getAttribute(i).getName()+"  �ֶ�ֵ:"+bor.getAttribute(i).getString()+"�ֶγ��ȣ�"+bor.getAttribute(i).getLength());
			}
			//����ͷ�ĳ���
			len = len -18+16;//18�ǻ�������Ͱ��峤��16��16���ֽڵ�bitmap
			System.out.println("����ͷ�ĳ���Ϊ��"+len);
			TXMessageBody requestBody = trans.getRequestBody();
			int iBody = 0 ,count = 0;
			System.out.println("������ļ�¼��Ϊ��"+requestBody.size());
			if(requestBody.size()>0){
				BizObject bz = requestBody.getObject(0);
				
				for(int j=0; j<bz.getAttributeNumber(); j++){
					iBody += bz.getAttribute(j).getLength();
					String bitMap = bz.getAttribute(0).getProperty("bitMap");
					if(bitMap!=null&&bitMap.startsWith("PP")&&(count = bitMap.indexOf(","))>=0){
						iBody = iBody + bitMap.substring(count+1).length();
					}
					System.out.println("�ֶ�����"+bz.getAttribute(j).getName()+"  �ֶ�ֵ:"+bz.getAttribute(j).getString()+"�ֶγ��ȣ�"+bz.getAttribute(j).getLength());
				}
			}	
			System.out.println("������ĳ���Ϊ��"+iBody*requestBody.size());
			if(requestBody.size()>0){
				len = len + iBody * requestBody.size();
			}
			de.setValue(lengthbag(len));
			
			
			//ʵ�ʱ���ת�������ͣ����׽��TXResult����������ͨ��
			//trans.getResponseXXX��ȡ
			TXResult result = conn.executeTransaction(trans);
			int length = 0;
			BizObject bh = trans.getResponseHeader();
			for(int i=0;i<bh.getAttributeNumber();i++){
				System.out.println("�ֶ�����"+bh.getAttribute(i).getName()+"  �ֶ�ֵ:"+bh.getAttribute(i).getString());
			}
			
			TXMessageBody responsBody = trans.getResponseBody();
			
			if(responsBody!=null){
				if(responsBody.size()==0)
					System.out.println("���ر����ޱ����壡������");
				
				for(int i=0; i<responsBody.size();i++){
					BizObject bo = responsBody.getObject(i);
					for(int j=0; j<bo.getAttributeNumber(); j++){
						length += bo.getAttribute(j).getLength();
						System.out.println("�ֶ�����"+bo.getAttribute(j).getName()+"  �ֶ�ֵ:"+bo.getAttribute(j).getString());
					}
				}
				System.out.println("�������ݵ��ܳ���Ϊ��"+length);
			}
			//�رս�������
			conn.close();
			
		}catch(TXException e){
			System.out.println(e.getMessage());
		} catch (JBOException e) {
			e.printStackTrace();
		}
	}
	
	 //����洢���峤ֵ�İ�λ�ַ�
    public static String lengthbag(int length)
    {
    	String lengthall = "";
    	if (length<10)
    	{
    		lengthall="0000000"+length;
    	}
    	else if (length<100)
    	{
    		lengthall="000000"+length;
    	}
    	else if (length<1000)
    	{
    		lengthall="00000"+length;
    	}
    	else if (length<10000)
    	{
    		lengthall="0000"+length;
    	}
    	else if (length<100000)
    	{
    		lengthall="000"+length;
    	}
    	else if (length<1000000)
    	{
    		lengthall="00"+length;
    	}
    	else if (length<10000000)
    	{
    		lengthall="0"+length;
    	}
    	else
    	{
    		lengthall=String.valueOf(length);
    	}
    	return lengthall;
    }
}
