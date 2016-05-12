package demo;

import java.io.UnsupportedEncodingException;
import java.text.DecimalFormat;

import com.amarsoft.oti.OTITransaction;
import com.amarsoft.oti.TXException;
import com.amarsoft.oti.TXMessageBody;
import com.amarsoft.oti.packer.XMLDocumentPacker;

/**
 * <p>广州农联基于Socket通讯的XML报文生成器
 * <p>广州农联XML报文结构对比父类AbstractXMLConnection定义的报文结构不同点在于：
 * 	  <li>XML文件头多了一段用于描述报文本身的信息如：报文长度、交易码等 重写父类getXMLHeader()方法
 * 	  <li>报文体：如果记录大于1条时，报文体的层次结构有变：如添加了用于描述结果集信息标签<list_01>、记录条数信息<row_qt>
 * 
 * <p>注：不支持<begin_row>4</begin_row>从第n>1条记录开始<hr>
 * @author hqYu
 *
 */
public class GZXMLPacker extends XMLDocumentPacker{
	
	public void unpack(OTITransaction transaction, Object message) {
		// TODO Auto-generated method stub
		
	}

	
	/**
	 * 实现广州农联客户化的XML报文需求:
	 * 报文体记录条数>1
	 * 		<main_data>
	 * 			<list_01>              (如果有多个列表就分别是list_02,list_03…)
	 *				<row_qt>100</row_qt>（查出100条记录）
	 *				<begin_row>4</begin_row>(从第四条记录开始)
	 *					<row>
	 *						<field>
	 *
	 * 报文体记录条数=1
	 * 	<main_data>
	 * 		<row>
	 *			<field>
     *
	 */
	public String getStartBodyNode(OTITransaction transaction) {
		TXMessageBody body = transaction.getRequestBody();
		StringBuffer sb = new StringBuffer();
		
		//如果记录条数>1 则有标签<list_01>等
		if(body.size()>1){
			sb.append("<main_data>").append("<list_01>")
			  .append("<row_qt>").append(body.size()).append("</row_qt>")
			  .append("<begin_row>1</begin_row>")
			  ;
		}//记录条数=1
		else if(body.size()==1){
			sb.append("<main_data>");
		}
		
		return sb.toString();
	}
	
	/**
	 * 实现广州农联客户化的XML报文需求:
	 * 		报文体记录条数>1:
	 * 				</list_01>		
	 * 			</main_data>
	 *
	 * 		报文体记录条数=1:
	 * 			</main_data>
     *
	 */
	public String getEndBodyNode(OTITransaction transaction) {
		TXMessageBody body = transaction.getRequestBody();
		StringBuffer sb = new StringBuffer();
		
		//如果记录条数>1 则有标签<list_01>等
		if(body.size()>1){
			sb.append("</list_01>").append("</main_data>");
		}//记录条数=1
		else if(body.size()==1){
			sb.append("</main_data>");
		}
		
		return sb.toString();
	}

	/**
	 * 重写XML文件头的方法，实现广州农联报文的报文和公共头
	 * 格式如：
	 * 		0001676G0112345678901234568888#
	 *		<?xml version="1.0" encoding="gb18030" ?>
     * 相对位移	长度	属性	名称		 值域
	 *		0	6	n	报文长度	
	 *		6	4	n	交易码	
	 *		10	16	x	报文MAC	
	 *		26	4	x	MAC机器号	
	 *		30	1	x	结束标识	 #
	 *
     * @return XML报文文件头
	 * @throws TXException 
	 */
	protected String getXMLHeader(OTITransaction transaction){
		StringBuffer sb = new StringBuffer();
		String xmlStandardHeader = "<?xml version=\"1.0\" encoding=\"gb18030\" ?>";
		//用于计算报文体长度
		String xmlMsg;
		try {
			xmlMsg = (String)pack(transaction);
			//报文长度
			String xmlLength  =null;
			try {
				//TODO 待确认GZNL是以字节OR字符来计算长度
				xmlLength = new DecimalFormat("000000").format(xmlMsg.getBytes(getSendMsgEncoding()).length);
			} catch (UnsupportedEncodingException e) {
				xmlLength = new DecimalFormat("000000").format(xmlMsg.getBytes().length);
				log.debug("平台不支持"+getSendMsgEncoding()+",采用平台默认编码,报文长度计算可能出错",e);
			}
			sb.append(xmlLength);
			
			//交易码
			String transCode = transaction.getCode();
			sb.append(transCode);
			
			//报文MAC
			String strMACMsg = "1234567890123456";
			sb.append(strMACMsg);
			
			//MAC机器号
			String strMACComputer = "8888";
			sb.append(strMACComputer);
			
			//结束符"#"
			sb.append("#");
			
			//XML标准文件头
			sb.append(xmlStandardHeader);
			
			return sb.toString();
		} catch (TXException e1) {
			log.debug(e1);
		} 
			
		return null;
	}
	
	/**
	 * gets 方法 用于更新body的标签名
	 */
	public String getBodyNode() {
		return "main_data";
	}
	/**
	 * gets 方法 用于更新header的标签名
	 */
	public String getHeaderNode() {
		return "comm_head";
	}
	/**
	 * gets 方法 用于更新row的标签名
	 */
	public String getRowNode() {
		return "row";
	}
}
