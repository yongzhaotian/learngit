package com.amarsoft.oti.client.hhcf.id5;

import java.util.HashMap;
import java.util.Map;

public class ID5Constants {

	// 加密密匙
	public static String SKEY = "12345678";
	// ID5用户名
	public final static String ID5_USERNAME = "baiqian2014jiekou";
	// ID5密码
	public final static String ID5_PASSWORD = "baiqian2014jiekou_H=eqdZ6A";
	// 接口url
	public final static String WSDL_URL = "http://gbossapp.id5.cn/services/QueryValidatorServices?wsdl";
	// 接口url2
		public final static String WSDL_URL_PHONE = "http://gboss.id5.cn/services/QueryValidatorServices?wsdl ";
	// 电话查询类型
	public static final Map<String, String> TEL_QUERY_TYPE_MAP = new HashMap<String, String>();
	// 性别码值
	public static final Map<String, String> SEX_MAP = new HashMap<String, String>();
	// 返回状态码值
	public static final Map<String, String> MESSAGE_STATUS_MAP = new HashMap<String, String>();
	// 车型码值
	public static final Map<String, String> CAR_TYPE_MAP = new HashMap<String, String>();
	// 车辆颜色码值
	public static final Map<String, String> CAR_TYPE_COLOR_MAP = new HashMap<String, String>();
	// 省份简称码值
	public static final Map<String, String> PROVINCE_CALL_MAP = new HashMap<String, String>();
	// 行政区号码值
	public static final Map<String, String> DISTRICTNO_MAP = new HashMap<String, String>();
	// 生肖码值
	public static final Map<String, String> ZODIAC_MAP = new HashMap<String, String>();
	// 星座码值
	public static final Map<String, String> CONSTELLATION_MAP = new HashMap<String, String>();
		
		
	static {
		SEX_MAP.put("1", "男");
		SEX_MAP.put("2", "女");
	};
	
	static {
		MESSAGE_STATUS_MAP.put("0","处理成功");
		MESSAGE_STATUS_MAP.put("1","未查到数据");
		MESSAGE_STATUS_MAP.put("2","查询失败");
		MESSAGE_STATUS_MAP.put("-9999","参数数据不正确(部分参数为空)");
		MESSAGE_STATUS_MAP.put("-9998","您的用户信息错误(用户名不存在)");
		MESSAGE_STATUS_MAP.put("-9997","您无权查询数据");
		MESSAGE_STATUS_MAP.put("-9996","参数请求数据过长");
		MESSAGE_STATUS_MAP.put("-9995","该产品已暂停使用");
		MESSAGE_STATUS_MAP.put("-9994","参数数据加密错误");
		MESSAGE_STATUS_MAP.put("-990","系统异常");
		MESSAGE_STATUS_MAP.put("9999","未查到数据");
		MESSAGE_STATUS_MAP.put("-9919","参数数据不正确(参数格式不正确)");
		MESSAGE_STATUS_MAP.put("-9929","参数数据不正确(参数个数不正确)");
		MESSAGE_STATUS_MAP.put("-9917","您无权查询数据(ip 无权限)");
		MESSAGE_STATUS_MAP.put("-9927","您无权查询数据(没有订购该产品)");
	};
	
	static {
		CAR_TYPE_MAP.put("01","大型汽车");
		CAR_TYPE_MAP.put("02","小型汽车");
		CAR_TYPE_MAP.put("03","使馆汽车");
		CAR_TYPE_MAP.put("04","领馆汽车");
		CAR_TYPE_MAP.put("05","境外汽车 ");
		CAR_TYPE_MAP.put("06","外籍汽车");
		CAR_TYPE_MAP.put("07","两、三轮摩托车");
		CAR_TYPE_MAP.put("08","轻便摩托车");
		CAR_TYPE_MAP.put("09","使馆摩托车");
		CAR_TYPE_MAP.put("10","领馆摩托车");
		CAR_TYPE_MAP.put("11","境外摩托车");
		CAR_TYPE_MAP.put("12","外籍摩托车");
		CAR_TYPE_MAP.put("13","农用运输车");
		CAR_TYPE_MAP.put("14","拖拉机");
		CAR_TYPE_MAP.put("15","挂车");
		CAR_TYPE_MAP.put("16","教练汽车");
		CAR_TYPE_MAP.put("17","教练摩托车");
		CAR_TYPE_MAP.put("18","试验汽车");
		CAR_TYPE_MAP.put("19","试验摩托车");
		CAR_TYPE_MAP.put("20","临时入境汽车");
		CAR_TYPE_MAP.put("21","临时入境摩托车");
		CAR_TYPE_MAP.put("22","临时行驶车");
	};
	
	static {
		CAR_TYPE_COLOR_MAP.put("A","白");
		CAR_TYPE_COLOR_MAP.put("B","灰");
		CAR_TYPE_COLOR_MAP.put("C","黄");
		CAR_TYPE_COLOR_MAP.put("D","粉");
		CAR_TYPE_COLOR_MAP.put("E","红");
		CAR_TYPE_COLOR_MAP.put("F","紫");
		CAR_TYPE_COLOR_MAP.put("G","绿");
		CAR_TYPE_COLOR_MAP.put("H","蓝");
		CAR_TYPE_COLOR_MAP.put("I","棕");
		CAR_TYPE_COLOR_MAP.put("J","黑");
	};
	
	static {
		PROVINCE_CALL_MAP.put("HX","湖南省 湘");
		PROVINCE_CALL_MAP.put("BJ","北京市 京");
		PROVINCE_CALL_MAP.put("TJ","天津市 津");
		PROVINCE_CALL_MAP.put("HB","河北省 冀");
		PROVINCE_CALL_MAP.put("SX","山西省 晋");
		PROVINCE_CALL_MAP.put("NM","内蒙古 蒙");
		PROVINCE_CALL_MAP.put("LN","辽宁省 辽");
		PROVINCE_CALL_MAP.put("JL","吉林省 吉");
		PROVINCE_CALL_MAP.put("HJ","黑龙江 黑 ");
		PROVINCE_CALL_MAP.put("SH","上海市 沪");
		PROVINCE_CALL_MAP.put("JS","江苏省 苏");
		PROVINCE_CALL_MAP.put("ZJ","浙江省 浙");
		PROVINCE_CALL_MAP.put("AH","安微省 皖");
		PROVINCE_CALL_MAP.put("FJ","福建省 闽");
		PROVINCE_CALL_MAP.put("JX","江西省 赣");
		PROVINCE_CALL_MAP.put("SD","山东省 鲁");
		PROVINCE_CALL_MAP.put("HY","河南省 豫");
		PROVINCE_CALL_MAP.put("HE","湖北省 鄂");
		PROVINCE_CALL_MAP.put("GD","广东省 粤");
		PROVINCE_CALL_MAP.put("GX","广 西 桂");
		PROVINCE_CALL_MAP.put("HQ","海南省 琼");
		PROVINCE_CALL_MAP.put("CQ","重庆市 渝");
		PROVINCE_CALL_MAP.put("SC","四川省 川");
		PROVINCE_CALL_MAP.put("GZ","贵州省 贵");
		PROVINCE_CALL_MAP.put("YN","云南省 云");
		PROVINCE_CALL_MAP.put("XZ","西藏 藏");
		PROVINCE_CALL_MAP.put("SS","陕西省 陕");
		PROVINCE_CALL_MAP.put("GS","甘肃省 甘");
		PROVINCE_CALL_MAP.put("QH","青海省 青");
		PROVINCE_CALL_MAP.put("NX","宁夏 宁");
		PROVINCE_CALL_MAP.put("XJ","新疆 新");
	};
	
	static {
		DISTRICTNO_MAP.put("110000","北京市");
		DISTRICTNO_MAP.put("340000","安徽省");
		DISTRICTNO_MAP.put("510000","四川省");
		DISTRICTNO_MAP.put("120000","天津市");
		DISTRICTNO_MAP.put("350000","福建省");
		DISTRICTNO_MAP.put("520000","贵州省");
		DISTRICTNO_MAP.put("130000","河北省");
		DISTRICTNO_MAP.put("360000","江西省");
		DISTRICTNO_MAP.put("530000","云南省");
		DISTRICTNO_MAP.put("140000","山西省");
		DISTRICTNO_MAP.put("370000","山东省");
		DISTRICTNO_MAP.put("540000","西藏自治区");
		DISTRICTNO_MAP.put("150000","内蒙古自治区");
		DISTRICTNO_MAP.put("410000","河南省");
		DISTRICTNO_MAP.put("610000","陕西省");
		DISTRICTNO_MAP.put("210000","辽宁省");
		DISTRICTNO_MAP.put("420000","湖北省");
		DISTRICTNO_MAP.put("620000","甘肃省");
		DISTRICTNO_MAP.put("220000","吉林省");
		DISTRICTNO_MAP.put("430000","湖南省");
		DISTRICTNO_MAP.put("630000","青海省");
		DISTRICTNO_MAP.put("230000","黑龙江省");
		DISTRICTNO_MAP.put("440000","广东省");
		DISTRICTNO_MAP.put("640000","宁夏回族自治区");
		DISTRICTNO_MAP.put("310000","上海市");
		DISTRICTNO_MAP.put("450000","广西壮族自治区");
		DISTRICTNO_MAP.put("650000","新疆维吾尔自治区");
		DISTRICTNO_MAP.put("320000","江苏省");
		DISTRICTNO_MAP.put("460000","海南省");
		DISTRICTNO_MAP.put("710000","台湾省");
		DISTRICTNO_MAP.put("330000","浙江省");
		DISTRICTNO_MAP.put("500000","重庆市");
		DISTRICTNO_MAP.put("810000","香港特别行政区");
		DISTRICTNO_MAP.put("820000","澳门特别行政区");
	};
	
	static {
		ZODIAC_MAP.put("0","牛");
		ZODIAC_MAP.put("1","虎");
		ZODIAC_MAP.put("2","兔");
		ZODIAC_MAP.put("3","龙");
		ZODIAC_MAP.put("4","蛇");
		ZODIAC_MAP.put("5","马");
		ZODIAC_MAP.put("6","羊");
		ZODIAC_MAP.put("7","猴");
		ZODIAC_MAP.put("8","鸡");
		ZODIAC_MAP.put("9","狗");
		ZODIAC_MAP.put("10","猪");
		ZODIAC_MAP.put("11","鼠(阳历)");
	};
	
	static {
		CONSTELLATION_MAP.put("0","摩羯座");
		CONSTELLATION_MAP.put("1","水瓶座");
		CONSTELLATION_MAP.put("2","双鱼座");
		CONSTELLATION_MAP.put("3","白羊座");
		CONSTELLATION_MAP.put("4","金牛座");
		CONSTELLATION_MAP.put("5","双子座");
		CONSTELLATION_MAP.put("6","巨蟹座");
		CONSTELLATION_MAP.put("7","狮子座");
		CONSTELLATION_MAP.put("8","处女座");
		CONSTELLATION_MAP.put("9","天枰座");
		CONSTELLATION_MAP.put("10","天蝎座");
		CONSTELLATION_MAP.put("11","射手座");
	};

static {
	TEL_QUERY_TYPE_MAP.put("0001","电话正查(电信企业)");
	TEL_QUERY_TYPE_MAP.put("0003","名称反查(电信企业)");
	TEL_QUERY_TYPE_MAP.put("0004","地址反查(电信企业)");
	TEL_QUERY_TYPE_MAP.put("0101","电话正查(电信白页)");
	TEL_QUERY_TYPE_MAP.put("0104","家庭地址反查(电信白页)");
	TEL_QUERY_TYPE_MAP.put("1101","电话正查(联通固话)");
	TEL_QUERY_TYPE_MAP.put("1102","名称和地址反查(联通固话)");
	TEL_QUERY_TYPE_MAP.put("1103","名称反查(联通固话)");
	TEL_QUERY_TYPE_MAP.put("1104","地址反查(联通固话)");
	TEL_QUERY_TYPE_MAP.put("0000","查询成功_无数据(电信数据源)");
	TEL_QUERY_TYPE_MAP.put("1111","查询成功_无数据(联通数据源)");
}
}
