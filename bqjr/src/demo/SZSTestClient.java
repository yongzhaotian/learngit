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
			//获取实时接口管理器
			OTIManager manager = OTIManager.getManager();
			//通过管理获取一个名叫:connName的交易连接
			OTIConnection conn = manager.getConnectionInstance("SZSconn");
			conn.open();
			//通过管理获取一个名叫：transID的交易对象
			OTITransaction trans = manager.getTransactionInstance("9613");
			//通过JBO自动给交易对象赋值
			trans.initRequestBody(" serialno='BP20090106000010'");
			
			DataElement de	= null;
			//设置包体、报体长度
			BizObject bor = trans.getRequestHeader();
			de = bor.getAttribute("SIA-TR-BAG");
			//计算包体长,指的是字节长度
			int len = 0;
			for(int i=0;i<bor.getAttributeNumber();i++){
				len += bor.getAttribute(i).getLength();
				System.out.println("字段名："+bor.getAttribute(i).getName()+"  字段值:"+bor.getAttribute(i).getString()+"字段长度："+bor.getAttribute(i).getLength());
			}
			//报文头的长度
			len = len -18+16;//18是机构编码和包体长；16是16个字节的bitmap
			System.out.println("报文头的长度为："+len);
			TXMessageBody requestBody = trans.getRequestBody();
			int iBody = 0 ,count = 0;
			System.out.println("报文体的记录数为："+requestBody.size());
			if(requestBody.size()>0){
				BizObject bz = requestBody.getObject(0);
				
				for(int j=0; j<bz.getAttributeNumber(); j++){
					iBody += bz.getAttribute(j).getLength();
					String bitMap = bz.getAttribute(0).getProperty("bitMap");
					if(bitMap!=null&&bitMap.startsWith("PP")&&(count = bitMap.indexOf(","))>=0){
						iBody = iBody + bitMap.substring(count+1).length();
					}
					System.out.println("字段名："+bz.getAttribute(j).getName()+"  字段值:"+bz.getAttribute(j).getString()+"字段长度："+bz.getAttribute(j).getLength());
				}
			}	
			System.out.println("报文体的长度为："+iBody*requestBody.size());
			if(requestBody.size()>0){
				len = len + iBody * requestBody.size();
			}
			de.setValue(lengthbag(len));
			
			
			//实际报文转换、发送；交易结果TXResult、反馈报文通过
			//trans.getResponseXXX获取
			TXResult result = conn.executeTransaction(trans);
			int length = 0;
			BizObject bh = trans.getResponseHeader();
			for(int i=0;i<bh.getAttributeNumber();i++){
				System.out.println("字段名："+bh.getAttribute(i).getName()+"  字段值:"+bh.getAttribute(i).getString());
			}
			
			TXMessageBody responsBody = trans.getResponseBody();
			
			if(responsBody!=null){
				if(responsBody.size()==0)
					System.out.println("返回报文无报文体！！！！");
				
				for(int i=0; i<responsBody.size();i++){
					BizObject bo = responsBody.getObject(i);
					for(int j=0; j<bo.getAttributeNumber(); j++){
						length += bo.getAttribute(j).getLength();
						System.out.println("字段名："+bo.getAttribute(j).getName()+"  字段值:"+bo.getAttribute(j).getString());
					}
				}
				System.out.println("返回数据的总长度为："+length);
			}
			//关闭交易连接
			conn.close();
			
		}catch(TXException e){
			System.out.println(e.getMessage());
		} catch (JBOException e) {
			e.printStackTrace();
		}
	}
	
	 //计算存储包体长值的八位字符
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
