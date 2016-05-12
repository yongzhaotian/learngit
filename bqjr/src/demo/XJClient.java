package demo;

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

//���Կͻ��ˡ����Դ���֤���˺����
public class XJClient {
	private static String orgId = "9504";
	private static OTITransaction trans = null;

	public static void main(String[] args) {
		// ��ʼARE����
		if (!ARE.isInitOk())
			ARE.init();
		String paraWhere = " Serialno = '0334902200900038001' ";
		// String paraWhere = " CustomerId = '20061031000008' ";

		OTIManager manager = OTIManager.getManager();
		System.out.println(manager == null);
		try {
			// ��ȡ����
			OTIConnection conn = manager.getConnectionInstance("GZNXconn");
			conn.open();
			// ��ȡ����IDΪ88017�Ľ���
			trans = manager.getTransactionInstance("s054");
			trans.initRequestBody(paraWhere);
			// ��ʼ������ͷ
			// initRequestHeader();
			// ���ͽ���
			TXResult result = conn.executeTransaction(trans);
			System.out.println(result.toString());
			BizObject bore = trans.getResponseHeader();
			int length = 0;

			for (int j = 0; j < bore.getAttributeNumber(); j++) {
				length += bore.getAttribute(j).getLength();
				System.out.println("�����ֶ�����" + bore.getAttribute(j).getName()
						+ "  �ֶ�ֵ:" + bore.getAttribute(j).getString());
			}

			BizObject bo = trans.getRequestHeader();
			TXMessageBody responsBody = trans.getResponseBody();
			if (responsBody != null) {
				System.out.println("���������峤�ȣ�" + responsBody.size());
				for (int i = 0; i < responsBody.size(); i++) {
					bo = responsBody.getObject(i);
					for (int j = 0; j < bo.getAttributeNumber(); j++) {
						length += bo.getAttribute(j).getLength();
						System.out.println("�ֶ�����"
								+ bo.getAttribute(j).getName() + "  �ֶ�ֵ:"
								+ bo.getAttribute(j).getString());
					}
				}
			} else {
				System.out.println("����������Ϊ��");
			}
		} catch (TXException e) {
			e.printStackTrace();
		} catch (JBOException e) {
			e.printStackTrace();
		}
	}

	public static void initRequestHeader() {
		DataElement de = null;
		BizObject bo = trans.getRequestHeader();

		SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
		Date date = new Date();

		try {
			de = bo.getAttribute("TermDate");
			de.setValue(df.format(date));
			System.out.println(df.format(date));

			df.applyPattern("HHmmss");
			de = bo.getAttribute("TermTime");
			de.setValue(df.format(date));
			System.out.println(df.format(date));

			de = bo.getAttribute("Brc");
			de.setValue(orgId);

			de = bo.getAttribute("Teller");
			de.setValue(orgId);

			de = bo.getAttribute("SeqNo1");
			de.setValue("UP01");
		} catch (JBOException e) {
			e.printStackTrace();
		}
	}
}