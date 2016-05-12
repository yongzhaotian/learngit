package com.amarsoft.app.als.product;

import com.amarsoft.awe.util.Transaction;

/**
 * @author yzheng
 * @date 2013/05/20
 */
public class CVNodeHTMLView {
	private CVNodeDrawController CVnc;  //draw controller  object
	private String[] nodeIDArray;     //�ڵ�ID
	private String[] nodeNames;                 //�ڵ�����
	private String[] sortNos;              //�ڵ������
	private String[] factors;                //������, <����/����/��ͬ/�����ͬ>
	private int[][] map;
	private final int facNums;  //���������׶�����
	private String[] nodeObjInfoArray;  //���ڵ���Ϣ������Object����ʽ����,ʵ��ѡ������ȷ��ֵ(Ԥ��,��ʱ����)

	public String[] getNodeIDArray() {
		return nodeIDArray;
	}

//	public String[] getSortNos() {
//		return sortNos;
//	}

	public int[][] getMap(){
		return map;
	}
	
	public int getFacNums(){
		return facNums;
	}
	
	public String[] getFactors(){
		return factors;
	}
	
	public String[] getNodeNames(){
		return nodeNames;
	}
	
	public String[] getNodeObjInfoArray() {
		return nodeObjInfoArray;
	}
	
	/**
	 * ���캯��
	 * 
	 * @param productID  ��ƷID
	 * @param nodeIDArr �ڵ�ID����
	 * @param seperator �ָ�����
	 */
	public CVNodeHTMLView(Transaction Sqlca, String productID, String nodeIDArr, String seperator) throws Exception{
		 CVnc = new CVNodeDrawController(Sqlca, productID, nodeIDArr, seperator);
		 nodeIDArray = CVnc. getNodeIDArray();
		 nodeNames = CVnc. getNodeNames();
		 sortNos = CVnc. getSortNos();
		 factors = CVnc. getFactors();
		 map = CVnc.getMap();
		 facNums = CVnc. getFacNums();
		 nodeObjInfoArray =  CVnc.getNodeObjInfoArray();
	}
	
	/**
	 * @important   !!  ��ʱ���ø÷���, html�����Ѿ��Żص�jspҳ��
	 * 
	 * @purpose ��ȡCVNodeDrawController�෵�صĲ���������HTML���
	 * @return sPRDNodeInfo   ��String��ʽ�洢��HTML����
	 */
	public String generateHTMLGrid(){
		StringBuffer sTemp=new StringBuffer();
		String sPRDNodeInfo = "";
		String tmpStr= "";
		//String[] factors = CVnc.getFactors();
		//String[] nodeNames =CVnc.getNodeNames() ;
		
		sTemp.append("<form action=''>");	
		sTemp.append("  <input type='button' onclick='saveRecord()' value='����'><br/>");	
		sTemp.append("  <br/>");
		sTemp.append("  <input type='button' onclick='selectNodes()' value='���û����ڵ�'><br/>");	
		sTemp.append("  <br/>");
		sTemp.append("  <input type='text' id='content' size='100'></input><br/>");
		sTemp.append("  <br/>");
		sTemp.append("  <table border='1'  cellpadding='0'  cellspacing='0'  width='100%'  align='center'  id='NodeConfigTable'>");
		sTemp.append("    <tr>");
		sTemp.append("      <td class='title1'  align='center' colspan='6'  style='background: #DDD;'>�ڵ���Ϣ����ͼ</td>");
		sTemp.append("    </tr>");
		sTemp.append("    <tr>");
		sTemp.append("      <td class='title2'>��� \\ �׶�</td>");
		//����������(��TITLE�� ���һ��)
		for (int i = 0; i < facNums; i++){
			tmpStr = "      <td class='title2'>";      
			tmpStr += factors[i];
			tmpStr += "<input type='button' id=";
			tmpStr += i;
			tmpStr += " onclick='selColumns(this.id)' value='��ѡ��'><br/></td>";
			sTemp.append(tmpStr);
		}
		sTemp.append("    </tr>");
		//���ɽڵ�(��)
		for (int i = 0; i < nodeIDArray.length; i++){
			sTemp.append("    <tr>");
			
			tmpStr =            "      <td class='title2'>";
			if (nodeIDArray[i].length() > 3){
				tmpStr += "&nbsp;&nbsp;&nbsp;&nbsp;";  //�ӽڵ�����
			}
			tmpStr += nodeNames[i];  //�ڵ�����
			tmpStr += "</td>";
			sTemp.append(tmpStr);
			//��ÿ���ڵ�����check box(��)
			for (int j = 0; j < facNums; j++){
				sTemp.append("      <td class='title2'>");
				tmpStr =            "         <input type='checkbox' name='cell' value='(";
				tmpStr = tmpStr + i + "|" + j;
				tmpStr += ")' onclick='checkStatus(this.id)'><br/>";
				sTemp.append(tmpStr);
				sTemp.append("      </td>");
			}
			
			sTemp.append("    </tr>");
		}
		
		sTemp.append("  </table>");
		sTemp.append("</form>");	
		
		sPRDNodeInfo = sTemp.toString();
		
		return sPRDNodeInfo;
	}
}