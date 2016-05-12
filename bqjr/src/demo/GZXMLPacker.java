package demo;

import java.io.UnsupportedEncodingException;
import java.text.DecimalFormat;

import com.amarsoft.oti.OTITransaction;
import com.amarsoft.oti.TXException;
import com.amarsoft.oti.TXMessageBody;
import com.amarsoft.oti.packer.XMLDocumentPacker;

/**
 * <p>����ũ������SocketͨѶ��XML����������
 * <p>����ũ��XML���Ľṹ�Աȸ���AbstractXMLConnection����ı��Ľṹ��ͬ�����ڣ�
 * 	  <li>XML�ļ�ͷ����һ�������������ı������Ϣ�磺���ĳ��ȡ�������� ��д����getXMLHeader()����
 * 	  <li>�����壺�����¼����1��ʱ��������Ĳ�νṹ�б䣺����������������������Ϣ��ǩ<list_01>����¼������Ϣ<row_qt>
 * 
 * <p>ע����֧��<begin_row>4</begin_row>�ӵ�n>1����¼��ʼ<hr>
 * @author hqYu
 *
 */
public class GZXMLPacker extends XMLDocumentPacker{
	
	public void unpack(OTITransaction transaction, Object message) {
		// TODO Auto-generated method stub
		
	}

	
	/**
	 * ʵ�ֹ���ũ���ͻ�����XML��������:
	 * �������¼����>1
	 * 		<main_data>
	 * 			<list_01>              (����ж���б�ͷֱ���list_02,list_03��)
	 *				<row_qt>100</row_qt>�����100����¼��
	 *				<begin_row>4</begin_row>(�ӵ�������¼��ʼ)
	 *					<row>
	 *						<field>
	 *
	 * �������¼����=1
	 * 	<main_data>
	 * 		<row>
	 *			<field>
     *
	 */
	public String getStartBodyNode(OTITransaction transaction) {
		TXMessageBody body = transaction.getRequestBody();
		StringBuffer sb = new StringBuffer();
		
		//�����¼����>1 ���б�ǩ<list_01>��
		if(body.size()>1){
			sb.append("<main_data>").append("<list_01>")
			  .append("<row_qt>").append(body.size()).append("</row_qt>")
			  .append("<begin_row>1</begin_row>")
			  ;
		}//��¼����=1
		else if(body.size()==1){
			sb.append("<main_data>");
		}
		
		return sb.toString();
	}
	
	/**
	 * ʵ�ֹ���ũ���ͻ�����XML��������:
	 * 		�������¼����>1:
	 * 				</list_01>		
	 * 			</main_data>
	 *
	 * 		�������¼����=1:
	 * 			</main_data>
     *
	 */
	public String getEndBodyNode(OTITransaction transaction) {
		TXMessageBody body = transaction.getRequestBody();
		StringBuffer sb = new StringBuffer();
		
		//�����¼����>1 ���б�ǩ<list_01>��
		if(body.size()>1){
			sb.append("</list_01>").append("</main_data>");
		}//��¼����=1
		else if(body.size()==1){
			sb.append("</main_data>");
		}
		
		return sb.toString();
	}

	/**
	 * ��дXML�ļ�ͷ�ķ�����ʵ�ֹ���ũ�����ĵı��ĺ͹���ͷ
	 * ��ʽ�磺
	 * 		0001676G0112345678901234568888#
	 *		<?xml version="1.0" encoding="gb18030" ?>
     * ���λ��	����	����	����		 ֵ��
	 *		0	6	n	���ĳ���	
	 *		6	4	n	������	
	 *		10	16	x	����MAC	
	 *		26	4	x	MAC������	
	 *		30	1	x	������ʶ	 #
	 *
     * @return XML�����ļ�ͷ
	 * @throws TXException 
	 */
	protected String getXMLHeader(OTITransaction transaction){
		StringBuffer sb = new StringBuffer();
		String xmlStandardHeader = "<?xml version=\"1.0\" encoding=\"gb18030\" ?>";
		//���ڼ��㱨���峤��
		String xmlMsg;
		try {
			xmlMsg = (String)pack(transaction);
			//���ĳ���
			String xmlLength  =null;
			try {
				//TODO ��ȷ��GZNL�����ֽ�OR�ַ������㳤��
				xmlLength = new DecimalFormat("000000").format(xmlMsg.getBytes(getSendMsgEncoding()).length);
			} catch (UnsupportedEncodingException e) {
				xmlLength = new DecimalFormat("000000").format(xmlMsg.getBytes().length);
				log.debug("ƽ̨��֧��"+getSendMsgEncoding()+",����ƽ̨Ĭ�ϱ���,���ĳ��ȼ�����ܳ���",e);
			}
			sb.append(xmlLength);
			
			//������
			String transCode = transaction.getCode();
			sb.append(transCode);
			
			//����MAC
			String strMACMsg = "1234567890123456";
			sb.append(strMACMsg);
			
			//MAC������
			String strMACComputer = "8888";
			sb.append(strMACComputer);
			
			//������"#"
			sb.append("#");
			
			//XML��׼�ļ�ͷ
			sb.append(xmlStandardHeader);
			
			return sb.toString();
		} catch (TXException e1) {
			log.debug(e1);
		} 
			
		return null;
	}
	
	/**
	 * gets ���� ���ڸ���body�ı�ǩ��
	 */
	public String getBodyNode() {
		return "main_data";
	}
	/**
	 * gets ���� ���ڸ���header�ı�ǩ��
	 */
	public String getHeaderNode() {
		return "comm_head";
	}
	/**
	 * gets ���� ���ڸ���row�ı�ǩ��
	 */
	public String getRowNode() {
		return "row";
	}
}
