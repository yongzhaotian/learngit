package com.amarsoft.oti.client.hhcf.id5;

import java.util.HashMap;
import java.util.Map;

public class ID5Constants {

	// �����ܳ�
	public static String SKEY = "12345678";
	// ID5�û���
	public final static String ID5_USERNAME = "baiqian2014jiekou";
	// ID5����
	public final static String ID5_PASSWORD = "baiqian2014jiekou_H=eqdZ6A";
	// �ӿ�url
	public final static String WSDL_URL = "http://gbossapp.id5.cn/services/QueryValidatorServices?wsdl";
	// �ӿ�url2
		public final static String WSDL_URL_PHONE = "http://gboss.id5.cn/services/QueryValidatorServices?wsdl ";
	// �绰��ѯ����
	public static final Map<String, String> TEL_QUERY_TYPE_MAP = new HashMap<String, String>();
	// �Ա���ֵ
	public static final Map<String, String> SEX_MAP = new HashMap<String, String>();
	// ����״̬��ֵ
	public static final Map<String, String> MESSAGE_STATUS_MAP = new HashMap<String, String>();
	// ������ֵ
	public static final Map<String, String> CAR_TYPE_MAP = new HashMap<String, String>();
	// ������ɫ��ֵ
	public static final Map<String, String> CAR_TYPE_COLOR_MAP = new HashMap<String, String>();
	// ʡ�ݼ����ֵ
	public static final Map<String, String> PROVINCE_CALL_MAP = new HashMap<String, String>();
	// ����������ֵ
	public static final Map<String, String> DISTRICTNO_MAP = new HashMap<String, String>();
	// ��Ф��ֵ
	public static final Map<String, String> ZODIAC_MAP = new HashMap<String, String>();
	// ������ֵ
	public static final Map<String, String> CONSTELLATION_MAP = new HashMap<String, String>();
		
		
	static {
		SEX_MAP.put("1", "��");
		SEX_MAP.put("2", "Ů");
	};
	
	static {
		MESSAGE_STATUS_MAP.put("0","����ɹ�");
		MESSAGE_STATUS_MAP.put("1","δ�鵽����");
		MESSAGE_STATUS_MAP.put("2","��ѯʧ��");
		MESSAGE_STATUS_MAP.put("-9999","�������ݲ���ȷ(���ֲ���Ϊ��)");
		MESSAGE_STATUS_MAP.put("-9998","�����û���Ϣ����(�û���������)");
		MESSAGE_STATUS_MAP.put("-9997","����Ȩ��ѯ����");
		MESSAGE_STATUS_MAP.put("-9996","�����������ݹ���");
		MESSAGE_STATUS_MAP.put("-9995","�ò�Ʒ����ͣʹ��");
		MESSAGE_STATUS_MAP.put("-9994","�������ݼ��ܴ���");
		MESSAGE_STATUS_MAP.put("-990","ϵͳ�쳣");
		MESSAGE_STATUS_MAP.put("9999","δ�鵽����");
		MESSAGE_STATUS_MAP.put("-9919","�������ݲ���ȷ(������ʽ����ȷ)");
		MESSAGE_STATUS_MAP.put("-9929","�������ݲ���ȷ(������������ȷ)");
		MESSAGE_STATUS_MAP.put("-9917","����Ȩ��ѯ����(ip ��Ȩ��)");
		MESSAGE_STATUS_MAP.put("-9927","����Ȩ��ѯ����(û�ж����ò�Ʒ)");
	};
	
	static {
		CAR_TYPE_MAP.put("01","��������");
		CAR_TYPE_MAP.put("02","С������");
		CAR_TYPE_MAP.put("03","ʹ������");
		CAR_TYPE_MAP.put("04","�������");
		CAR_TYPE_MAP.put("05","�������� ");
		CAR_TYPE_MAP.put("06","�⼮����");
		CAR_TYPE_MAP.put("07","��������Ħ�г�");
		CAR_TYPE_MAP.put("08","���Ħ�г�");
		CAR_TYPE_MAP.put("09","ʹ��Ħ�г�");
		CAR_TYPE_MAP.put("10","���Ħ�г�");
		CAR_TYPE_MAP.put("11","����Ħ�г�");
		CAR_TYPE_MAP.put("12","�⼮Ħ�г�");
		CAR_TYPE_MAP.put("13","ũ�����䳵");
		CAR_TYPE_MAP.put("14","������");
		CAR_TYPE_MAP.put("15","�ҳ�");
		CAR_TYPE_MAP.put("16","��������");
		CAR_TYPE_MAP.put("17","����Ħ�г�");
		CAR_TYPE_MAP.put("18","��������");
		CAR_TYPE_MAP.put("19","����Ħ�г�");
		CAR_TYPE_MAP.put("20","��ʱ�뾳����");
		CAR_TYPE_MAP.put("21","��ʱ�뾳Ħ�г�");
		CAR_TYPE_MAP.put("22","��ʱ��ʻ��");
	};
	
	static {
		CAR_TYPE_COLOR_MAP.put("A","��");
		CAR_TYPE_COLOR_MAP.put("B","��");
		CAR_TYPE_COLOR_MAP.put("C","��");
		CAR_TYPE_COLOR_MAP.put("D","��");
		CAR_TYPE_COLOR_MAP.put("E","��");
		CAR_TYPE_COLOR_MAP.put("F","��");
		CAR_TYPE_COLOR_MAP.put("G","��");
		CAR_TYPE_COLOR_MAP.put("H","��");
		CAR_TYPE_COLOR_MAP.put("I","��");
		CAR_TYPE_COLOR_MAP.put("J","��");
	};
	
	static {
		PROVINCE_CALL_MAP.put("HX","����ʡ ��");
		PROVINCE_CALL_MAP.put("BJ","������ ��");
		PROVINCE_CALL_MAP.put("TJ","����� ��");
		PROVINCE_CALL_MAP.put("HB","�ӱ�ʡ ��");
		PROVINCE_CALL_MAP.put("SX","ɽ��ʡ ��");
		PROVINCE_CALL_MAP.put("NM","���ɹ� ��");
		PROVINCE_CALL_MAP.put("LN","����ʡ ��");
		PROVINCE_CALL_MAP.put("JL","����ʡ ��");
		PROVINCE_CALL_MAP.put("HJ","������ �� ");
		PROVINCE_CALL_MAP.put("SH","�Ϻ��� ��");
		PROVINCE_CALL_MAP.put("JS","����ʡ ��");
		PROVINCE_CALL_MAP.put("ZJ","�㽭ʡ ��");
		PROVINCE_CALL_MAP.put("AH","��΢ʡ ��");
		PROVINCE_CALL_MAP.put("FJ","����ʡ ��");
		PROVINCE_CALL_MAP.put("JX","����ʡ ��");
		PROVINCE_CALL_MAP.put("SD","ɽ��ʡ ³");
		PROVINCE_CALL_MAP.put("HY","����ʡ ԥ");
		PROVINCE_CALL_MAP.put("HE","����ʡ ��");
		PROVINCE_CALL_MAP.put("GD","�㶫ʡ ��");
		PROVINCE_CALL_MAP.put("GX","�� �� ��");
		PROVINCE_CALL_MAP.put("HQ","����ʡ ��");
		PROVINCE_CALL_MAP.put("CQ","������ ��");
		PROVINCE_CALL_MAP.put("SC","�Ĵ�ʡ ��");
		PROVINCE_CALL_MAP.put("GZ","����ʡ ��");
		PROVINCE_CALL_MAP.put("YN","����ʡ ��");
		PROVINCE_CALL_MAP.put("XZ","���� ��");
		PROVINCE_CALL_MAP.put("SS","����ʡ ��");
		PROVINCE_CALL_MAP.put("GS","����ʡ ��");
		PROVINCE_CALL_MAP.put("QH","�ຣʡ ��");
		PROVINCE_CALL_MAP.put("NX","���� ��");
		PROVINCE_CALL_MAP.put("XJ","�½� ��");
	};
	
	static {
		DISTRICTNO_MAP.put("110000","������");
		DISTRICTNO_MAP.put("340000","����ʡ");
		DISTRICTNO_MAP.put("510000","�Ĵ�ʡ");
		DISTRICTNO_MAP.put("120000","�����");
		DISTRICTNO_MAP.put("350000","����ʡ");
		DISTRICTNO_MAP.put("520000","����ʡ");
		DISTRICTNO_MAP.put("130000","�ӱ�ʡ");
		DISTRICTNO_MAP.put("360000","����ʡ");
		DISTRICTNO_MAP.put("530000","����ʡ");
		DISTRICTNO_MAP.put("140000","ɽ��ʡ");
		DISTRICTNO_MAP.put("370000","ɽ��ʡ");
		DISTRICTNO_MAP.put("540000","����������");
		DISTRICTNO_MAP.put("150000","���ɹ�������");
		DISTRICTNO_MAP.put("410000","����ʡ");
		DISTRICTNO_MAP.put("610000","����ʡ");
		DISTRICTNO_MAP.put("210000","����ʡ");
		DISTRICTNO_MAP.put("420000","����ʡ");
		DISTRICTNO_MAP.put("620000","����ʡ");
		DISTRICTNO_MAP.put("220000","����ʡ");
		DISTRICTNO_MAP.put("430000","����ʡ");
		DISTRICTNO_MAP.put("630000","�ຣʡ");
		DISTRICTNO_MAP.put("230000","������ʡ");
		DISTRICTNO_MAP.put("440000","�㶫ʡ");
		DISTRICTNO_MAP.put("640000","���Ļ���������");
		DISTRICTNO_MAP.put("310000","�Ϻ���");
		DISTRICTNO_MAP.put("450000","����׳��������");
		DISTRICTNO_MAP.put("650000","�½�ά���������");
		DISTRICTNO_MAP.put("320000","����ʡ");
		DISTRICTNO_MAP.put("460000","����ʡ");
		DISTRICTNO_MAP.put("710000","̨��ʡ");
		DISTRICTNO_MAP.put("330000","�㽭ʡ");
		DISTRICTNO_MAP.put("500000","������");
		DISTRICTNO_MAP.put("810000","����ر�������");
		DISTRICTNO_MAP.put("820000","�����ر�������");
	};
	
	static {
		ZODIAC_MAP.put("0","ţ");
		ZODIAC_MAP.put("1","��");
		ZODIAC_MAP.put("2","��");
		ZODIAC_MAP.put("3","��");
		ZODIAC_MAP.put("4","��");
		ZODIAC_MAP.put("5","��");
		ZODIAC_MAP.put("6","��");
		ZODIAC_MAP.put("7","��");
		ZODIAC_MAP.put("8","��");
		ZODIAC_MAP.put("9","��");
		ZODIAC_MAP.put("10","��");
		ZODIAC_MAP.put("11","��(����)");
	};
	
	static {
		CONSTELLATION_MAP.put("0","Ħ����");
		CONSTELLATION_MAP.put("1","ˮƿ��");
		CONSTELLATION_MAP.put("2","˫����");
		CONSTELLATION_MAP.put("3","������");
		CONSTELLATION_MAP.put("4","��ţ��");
		CONSTELLATION_MAP.put("5","˫����");
		CONSTELLATION_MAP.put("6","��з��");
		CONSTELLATION_MAP.put("7","ʨ����");
		CONSTELLATION_MAP.put("8","��Ů��");
		CONSTELLATION_MAP.put("9","������");
		CONSTELLATION_MAP.put("10","��Ы��");
		CONSTELLATION_MAP.put("11","������");
	};

static {
	TEL_QUERY_TYPE_MAP.put("0001","�绰����(������ҵ)");
	TEL_QUERY_TYPE_MAP.put("0003","���Ʒ���(������ҵ)");
	TEL_QUERY_TYPE_MAP.put("0004","��ַ����(������ҵ)");
	TEL_QUERY_TYPE_MAP.put("0101","�绰����(���Ű�ҳ)");
	TEL_QUERY_TYPE_MAP.put("0104","��ͥ��ַ����(���Ű�ҳ)");
	TEL_QUERY_TYPE_MAP.put("1101","�绰����(��ͨ�̻�)");
	TEL_QUERY_TYPE_MAP.put("1102","���ƺ͵�ַ����(��ͨ�̻�)");
	TEL_QUERY_TYPE_MAP.put("1103","���Ʒ���(��ͨ�̻�)");
	TEL_QUERY_TYPE_MAP.put("1104","��ַ����(��ͨ�̻�)");
	TEL_QUERY_TYPE_MAP.put("0000","��ѯ�ɹ�_������(��������Դ)");
	TEL_QUERY_TYPE_MAP.put("1111","��ѯ�ɹ�_������(��ͨ����Դ)");
}
}
