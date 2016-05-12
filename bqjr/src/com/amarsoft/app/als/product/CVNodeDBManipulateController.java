/**
 * 
 */
package com.amarsoft.app.als.product;

import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;

/**
 * @author yzheng
 * @date 2013/05/20
 */
public class CVNodeDBManipulateController {
	private String  records;           //ѡ�е�check box
	private String  seperator;       //�ָ���
	private String[] nodeIDArray;     //�ڵ�ID
	private String[] nodes ;                 //�ڵ�����
	private String[] sortNos;              //�ڵ������
	private String productID;             //��ƷID
	private String nodeIDArr;           //δ�������ID�ַ���
	private String nodeNames;           //δ������������ַ���
	private final int facNums = 4;  //���������׶���)
	
	public String getNodeNames() {
		return nodeNames;
	}

	public void setNodeNames(String nodeNames) {
		this.nodeNames = nodeNames;
	}

	public String getRecords() {
		return records;
	}

	public void setRecords(String records) {
		this.records = records;
	}

	public String getSeperator() {
		return seperator;
	}

	public void setSeperator(String seperator) {
		this.seperator = seperator;
	}

	public String getProductID() {
		return productID;
	}

	public void setProductID(String productID) {
		this.productID = productID;
	}

	public String getNodeIDArr() {
		return nodeIDArr;
	}

	public void setNodeIDArr(String nodeIDArr) {
		this.nodeIDArr = nodeIDArr;
	}

	/**
	 *   
	 */
	public CVNodeDBManipulateController() {
		// TODO Auto-generated constructor stub
	}
	
	/**
	 * @return prdIDArr ������ĳ���ڵ�ID�Ĳ�ƷIDs���ɰ��������ƷID���ԡ�@���ָ�
	 * */
	public String check4Delete(Transaction Sqlca) throws Exception{
		SqlObject  osql = null;
		ASResultSet rs = null;
		String prdIDArr = "";
		String prdNameArr = "";
		String sSql = "";
		
		osql = new SqlObject("select distinct PrdID from PRD_NODECONFIG where NodeID = :nodeID");
		osql.setParameter("nodeID", nodeIDArr);
		rs = Sqlca.getASResultSet(osql);
		
		while(rs.next()){
			prdIDArr = prdIDArr + rs.getString("PrdID") + "@";
		}
		
		if (prdIDArr.length() > 0){
			prdIDArr = prdIDArr.substring(0, prdIDArr.length()-1);
			prdIDArr = prdIDArr.replaceAll("@", "','");
			
			sSql = "SELECT TypeName  FROM BUSINESS_TYPE where TypeNo in ('" + prdIDArr + "' )";
			rs = Sqlca.getASResultSet(sSql);
			while(rs.next()){
				prdNameArr = prdNameArr + rs.getString("TypeName") + "@";
			}
		}
		rs.getStatement().close();
		
		return (prdIDArr.length() > 0) ? prdNameArr : "NOT EXISTS";
	}
	
	/**
	 * @return prdIDArr   ĳ����Ʒ��Ӧ�Ľڵ�ID����, ��"@"���ŷָ�
	 */
	public String checkPRDNode(Transaction Sqlca) throws Exception{
		SqlObject  osql = null;
		ASResultSet rs = null;
		String prdIDArr = "";
		
		osql = new SqlObject("select NodeID from PRD_NODECONFIG where PrdID = :PrdID");
		osql.setParameter("PrdID", productID);
		rs = Sqlca.getASResultSet(osql);
		while(rs.next()){
			prdIDArr = prdIDArr + rs.getString("NodeID") + "@";
		}
		
		rs.getStatement().close();
		
		return prdIDArr;
	}
	
	/**
	 * @return result �������ݿ���: "SUCCESS" / "FAIL"
	 * */
	public String select2Update(Transaction Sqlca) throws Exception{		
		initRelatedNodeInfo(Sqlca);
		
	    SqlObject  osql = null;
		String resultUpdate = "";  //���»�������ݿ�����"SUCCESS" / "FAIL"
		String resultDel = "";  //ɾ������Ҫ�ļ�¼��"SUCCESS" / "FAIL"
		int count = 0;
		
		String rec = records.substring(0, records.length()-1);  //ȥ�����һ��@����
		String[] selected = rec.split(seperator);
		int[][] map = new int[nodeIDArray.length][facNums];      // array = �ڵ���� * ������   
		
		//ƥ��һάrecords����άmap��ʵ��������¼�ĸ��»����
		for (int i = 0; i < selected.length; i++){
			//System.out.println("selected[i]@@:" + selected[i]);
			
			int idx = selected[i].indexOf("|");  //checkbox�ָ�������
			int nodeId = Integer.parseInt(selected[i].substring(1, idx)); 
			int facInx = Integer.parseInt(selected[i].substring(idx+1, selected[i].length()-1)); 
			
			map[nodeId][facInx] = 1;
			//System.out.println("@@(" + nodeId + "," + facInx + ")  =" + map[nodeId][facInx]);
		}	
		
//		for (int i = 0; i < nodeIDArray.length; i++){
//			for (int j = 0; j < facNums; j++){
//				System.out.println("(" + i + "," + j + ")  =" + map[i][j]);
//			}
//		}
		
		//�������ݿ�, ѭ������=�ڵ����
		for (int i = 0; i < nodeIDArray.length; i++){
			osql = new SqlObject("select count(*) from PRD_NODECONFIG where PrdID = :productID and NodeID = :nodeID");
			osql.setParameter("productID", productID);
			osql.setParameter("nodeID", nodeIDArray[i]);
			
			String num = Sqlca.getString(osql);  //��ѯ�Ƿ��м�¼
			//int emptyFacs = 0;
			
			if(num.equals("0")) {
				osql = new SqlObject("insert into PRD_NODECONFIG (PrdID, NodeID, NodeName, SortNo, Fac1, Fac2, Fac3, Fac4)"
						+ "values (:PrdID, :NodeID, :NodeName, :SortNo, :Fac1, :Fac2, :Fac3, :Fac4)");
			}
			else{
				osql = new SqlObject("update PRD_NODECONFIG set NodeName=:NodeName, SortNo=:SortNo, Fac1=:Fac1, Fac2=:Fac2, Fac3=:Fac3, Fac4=:Fac4"
						+ " where PrdID = :PrdID and NodeID = :NodeID");
			}
			osql.setParameter("PrdID", productID);
			osql.setParameter("NodeID", nodeIDArray[i]);
			osql.setParameter("NodeName", nodes[i]);
			osql.setParameter("SortNo", sortNos[i]);
			for (int j = 0; j < facNums; j++)  {
				osql.setParameter("Fac" + (j+1), map[i][j]);
				//if( map[i][j] == 0) emptyFacs++;
			}
			
//			if(emptyFacs == facNums){
//				count++;
//				continue;    //�ڵ㱻ѡ�����һ�ж�û��ѡ�У��򲻴洢�ýڵ���Ϣ
//			}
			
			if(Sqlca.executeSQL(osql) == 1) count++;
		}
		
		String sSql;		 
		String nodeIDs = nodeIDArr.replaceAll(seperator, "','");  //Ԥ����nodeIDArr
		osql = new SqlObject("select count(*) from PRD_NODECONFIG where PrdID = :productID");  //��ѯ�ò�Ʒ�����Ľڵ����
		osql.setParameter("productID", productID);
		
		int rowNums = Integer.parseInt(Sqlca.getString(osql));
		
		if(rowNums > count){
			sSql = "delete from PRD_NODECONFIG where PrdID = '" + productID + "' and NodeID not in  ('" + nodeIDs + "') ";  //ɾ��֮ǰ�洢������δѡ�еĽڵ��¼
			resultDel  = (Sqlca.executeSQL(sSql) == (rowNums - count))  ? "SUCCESS" : "FAIL";
		}
		else{
			resultDel = "SUCCESS";
		}
		
		resultUpdate = (count == nodeIDArray.length) ? "SUCCESS" : "FAIL";
		
		return (resultDel.equals("SUCCESS") && resultUpdate.equals("SUCCESS") ) ? "SUCCESS" : "FAIL";
	}
	
	/**
	 * @purpose ˽�к�������ʼ�����ݣ�Ϊ���ݿ�����ݸ��²�����׼��
	 */
	private void initRelatedNodeInfo(Transaction Sqlca) throws Exception{
		 String sSql;		 
		 ASResultSet rsTemp = null;	
		 int count = 0;
		 int len = nodeIDArr.split(seperator).length;  //�ڵ�����
		 
		 String nodeIDs = nodeIDArr.replaceAll(seperator, "','");  //Ԥ����nodeIDArr
		 //��ʼ��˽�б���
		 nodeIDArray = new String[len];     //�ڵ�ID
	     nodes = new String[len];                //�ڵ�����
		 sortNos = new String[len];            //�ڵ������
		 
		 nodes = nodeNames.substring(0, nodeNames.length()-1).split("@");  //����ǰȥ�����һ��@����
		 
		 sSql = "select NodeName, SortNo, NodeID from PRD_NODEINFO where NodeID in  ('" + nodeIDs + "') order by SortNo ASC";
		 rsTemp = Sqlca.getASResultSet(sSql);
	 	 while(rsTemp.next()){
	 		 //nodes[count] = rsTemp.getString("NodeName");
	 		 sortNos[count] = rsTemp.getString("SortNo");
	 		 nodeIDArray[count] = rsTemp.getString("NodeID");  
	 		 count++;
	 	 }
	 	 rsTemp.getStatement().close();
	}
}