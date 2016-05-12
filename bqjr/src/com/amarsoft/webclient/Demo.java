package com.amarsoft.webclient;

import java.io.InputStream;
import java.sql.Connection;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Properties;

import com.amarsoft.are.ARE;
import com.amarsoft.are.lang.DateX;
import com.amarsoft.are.lang.StringX;
import com.amarsoft.are.security.MessageDigest;
import com.amarsoft.are.util.StringFunction;
import com.amarsoft.awe.Configure;
import com.amarsoft.oti.client.hhcf.id5.DESBASE64;

public class Demo {

	public static void main(String[] args) throws Exception{
		
		Connection conn = ID5Util.getConnection();
        
		try {
			//CurConfig.getConfigure("ImageFolder");
			//String sRet = ID5Util.parseID5Info("1G010101", "01062621616@国政通21@");
			
			//System.out.println("Return Value: " + sRet);
			/*Properties props = new Properties();
			InputStream is = ClassLoader.getSystemResourceAsStream("WebRoot/WEB-INF/etc/als7c.xml");
			System.out.println(is);*/
			//props.loadFromXML();
			
			String xxoo = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>"+
"<data>" +
"  <message>"+
"    <status>0</status>" +
"    <value>处理成功</value>" +
"  </message>" +
"  <policeCheckInfos>" +
"    <policeCheckInfo name=\"肖于\" id=\"371424198501021517\">"+
"      <message>" +
"        <status>1</status>" +
"        <value>未查到数据</value>"+
"      </message>"+
"      <name desc=\"姓名\">肖于</name>" +
"      <identitycard desc=\"身份证号\">371424198501021517</identitycard>" +
"      <compStatus desc=\"比对状态\">07</compStatus>" +
"      <compResult desc=\"比对结果\">条件不符合要求</compResult>" +
"    </policeCheckInfo>" +
"  </policeCheckInfos>" +
"</data>";
			
			
			System.out.println("000000als74: "+MessageDigest.getDigestAsUpperHexString("MD5", "000000als74"));
			System.out.println("000000als: "+MessageDigest.getDigestAsUpperHexString("MD5", "000000als"));
			System.out.println("000000als: "+MessageDigest.getDigestAsUpperHexString("MD5", "amarsoft"));
			System.out.println("2: "+MessageDigest.getDigestAsUpperHexString("MD5", "2"));
			System.out.println("000000: "+MessageDigest.getDigestAsUpperHexString("MD5", "000000"));
			System.out.println("123456: "+MessageDigest.getDigestAsUpperHexString("MD5", "123456"));
			System.out.println("---------------------------------------------------------------------------------");
			System.out.println(StringFunction.getToday());
			
			for (String x: "xx,aa".split(",")) {
				System.out.println("split :: " + x);
			}
			
			String checkPhoto = "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";
			String xx = "S078JKKtSvAMWap/sIGpd4eiphXoB0MB8EfFuFogsz8RLhrqnYxuAI8jchhX2zrYlCcVJcbeIfkwP7h6A+13QRIPDjUZPyuG6UtnbQ6iIeZ3kbVstT9zQlcDUPMVjAD4JHVZ2lWCPqykPdm+SBwc7OSYGsS5Q8mEyAjGgMXHAVxlQeLauYa356CSOcsB/pjUMYnx0gIkq6UbBaww+hoQmEhAruzflpFx55lURPRvl3MeXwn65k5UsTrfxcrUBm1XZHxepodfBhWo+734IRhrfc11wQ8ugFda0cteu7IccmbYS1dqFsTWPBxfmb/n5yRWGRX+GUWoiwWHlT3n6K0khGz0GTPkzw/MVLdgif2pBiQR7/ihp5R72gQqUEdHF2OC9ODN8c7OQgMIguDUI5aBJWkstgVL0IueRvbgNGsdW7gBm70neClYom+YTibALZBPaLjRZKFo1Ak3N/Q43FvLZtB5lTahhilkH38i/bZXePcigaj5Ec553MF2AjQmLuLtxlMk+URH0K9UuNqZZVT7zScLE266GTIKYP2gaFZmJkySq4pwAyADSzjXSQiFrDxro7YNyuKo7JihohTeMwagZNCjzOkmZngOzHgDz/2IcfxrwVGXuPUkbQV5ezu2nr0lKo8pNZq6owjk3p/qxhuDEYXi+Uyk3w2tN8/4Crxdmg4C8UptCHWtcMKXB81Vj8sx/MAwCfWkf3X+azwxeEdlNMjhwOhZCG7VMsC7pKiqnpZcCGvPMkHfk4/oNil7BfW4XRFBrp6IN8GA8PFx60TDir/3E40wipUb";
			//CurConfig.getConfigure("ImageFolder");
			String sd  = new SimpleDateFormat("MM/dd/HH").format(new Date());
			System.out.println(sd);
			
			System.out.println("15274579698".replace("@", ""));
			System.out.println("123".split("@").length);
			String  aa = DESBASE64.encode("12345678", " xml");
			System.out.println(aa);
			String baa = DESBASE64.decodeValue("12345678", aa);
			System.out.println("xxx: " + baa);
			String s = "S078JKKtSvAMWap/sIGpd4eiphXoB0MB8EfFuFogsz8RLhrqnYxuAI8jchhX2zrYlCcVJcbeIfkwP7h6A+13QRIPDjUZPyuG6UtnbQ6iIeZ3kbVstT9zQlcDUPMVjAD4JHVZ2lWCPqykPdm+SBwc7OSYGsS5Q8mEyAjGgMXHAVxlQeLauYa356CSOcsB/pjUMYnx0gIkq6UbBaww+hoQmEhAruzflpFx55lURPRvl3MeXwn65k5UsTrfxcrUBm1XZHxepodfBhWo+734IRhrfc11wQ8ugFda0cteu7IccmbYS1dqFsTWPBxfmb/n5yRWGRX+GUWoiwWHlT3n6K0khGz0GTPkzw/MVLdgif2pBiQR7/ihp5R72gQqUEdHF2OC9ODN8c7OQgMIguDUI5aBJWkstgVL0IueRvbgNGsdW7gBm70neClYom+YTibALZBPaLjRZKFo1Ak3N/Q43FvLZtB5lTahhilkH38i/bZXePcigaj5Ec553MF2AjQmLuLtxlMk+URH0K9UuNqZZVT7zScLE266GTIKYP2gaFZmJkySq4pwAyADSzjXSQiFrDxro7YNyuKo7JihohTeMwagZNCjzOkmZngOzHgDz/2IcfxrwVGXuPUkbQV5ezu2nr0lKo8pNZq6owjk3p/qxhuDEYXi+Uyk3w2tN8/4Crxdmg4C8UptCHWtcMKXB81Vj8sx/MAwCfWkf3X+azwxeEdlNMjhwOhZCG7VMsC7pKiqnpZcCGvPMkHfk4/oNil7BfW4XRFBrp6IN8GA8PFx60TDir/3E40wipUb";
			String xxx = DESBASE64.decodeValue("12345678", s);
			//System.out.println(xxx);
			
			String  ss = "S078JKKtSvAMWap/sIGpd4eiphXoB0MB8EfFuFogsz8RLhrqnYxuAI8jchhX2zrYlCcVJcbeIfkwP7h6A+13QRIPDjUZPyuG6UtnbQ6iIeZ3kbVstT9zQlcDUPMVjAD4JHVZ2lWCPqykPdm+SBwc7OSYGsS5Q8mEyAjGgMXHAVxlQeLauYa356CSOcsB/pjUMYnx0gIkq6UbBaww+hoQmEhAruzflpFx55lURPRvl3NdXt1SKADgp0nxjUHmGpuo5Bye5R/JEpSTKU2VxHu6TvG9AhjjcAlvz+dnDaaG8AJmNMV0Wg2jAJ00OluDEcSE7x8YjasFacMXc/XJrnLELVp2a483nL/hWNZ7j9cl5f1ou9tdZK/P8lxRgKllLPuxlr+SZL9oxfJsZfQzEdwEtM4Iy7WJbWUVqDGZHAeGyzk2C5R4IH15DybDmJgreohoxMSJDTwz0HOPn6IebNrPkhcazQva/ZyDKco2I+b0XPqUa20Q5CeyetLMsvHa7BPm5QxlvYV4O+ODgQ1q1KrSNoJVC8n4gW/qvQpqpIfEPnlGpAfS0WTjtUBxs5nVAqe2y4ONPyfmdLNl/5vIr2WC7iZIUYZMffwTxgaWtFTl5Mx5l7LftvgsX+JI7Oy8b0ejpzYyMcKL0O7bbXzaF9/D11dM/Jdil1i48pVchBM7Eb63/mZTSVp87D5V6ucyqwrtLjegY5f0JFe/DvGtYY+6oE6mOt90aEIhIOXEKUpCeDJsZMVitS/G6QHnh10oKjpI8hMmheEY1Kk=";
						//ss = "S078JKKtSvAMWap/sIGpd4eiphXoB0MB8EfFuFogsz8RLhrqnYxuAI8jchhX2zrYlCcVJcbeIfkwP7h6A+13QRIPDjUZPyuG6UtnbQ6iIeZ3kbVstT9zQlcDUPMVjAD4JHVZ2lWCPqykPdm+SBwc7OSYGsS5Q8mEyAjGgMXHAVxlQeLauYa356CSOcsB/pjUMYnx0gIkq6UbBaww+hoQmEhAruzflpFx55lURPRvl3NdXt1SKADgp0nxjUHmGpuo5Bye5R/JEpSTKU2VxHu6TvG9AhjjcAlvz+dnDaaG8AJmNMV0Wg2jAJ00OluDEcSE7x8YjasFacMXc/XJrnLELVp2a483nL/hWNZ7j9cl5f1ou9tdZK/P8lxRgKllLPuxlr+SZL9oxfJsZfQzEdwEtM4Iy7WJbWUVqDGZHAeGyzk2C5R4IH15DybDmJgreohoxMSJDTwz0HOPn6IebNrPkhcazQva/ZyDKco2I+b0XPqUa20Q5CeyetLMsvHa7BPm5QxlvYV4O+ODgQ1q1KrSNoJVC8n4gW/qvQpqpIfEPnlGpAfS0WTjtUBxs5nVAqe2y4ONPyfmdLNl/5vIr2WC7iZIUYZMffwTxgaWtFTl5Mx5l7LftvgsX+JI7Oy8b0ejpzYyMcKL0O7bbXzaF9/D11dM/Jdil1i48pVchBM7Eb63/mZTSVp87D5V6ucyqwrtLjegY5f0JFe/DvGtYY+6oE6mOt90aEIhIOXEKUpCeDJsZMVitS/G6QHnh10oKjpI8hMmheEY1Kk=";
						//ss = "S078JKKtSvAMWap/sIGpd4eiphXoB0MB8EfFuFogsz8RLhrqnYxuAI8jchhX2zrYlCcVJcbeIfkwP7h6A+13QRIPDjUZPyuG6UtnbQ6iIeZ3kbVstT9zQlcDUPMVjAD4JHVZ2lWCPqykPdm+SBwc7OSYGsS5Q8mEyAjGgMXHAVxlQeLauYa356CSOcsB/pjUMYnx0gIkq6UbBaww+hoQmEhAruzflpFx55lURPRvl3NHPx2o9mwzmaThkuzc1hhYdpp5BZPYNXXqzmhY0739zY59WZZx1XhkVqhUYNj28y27/W6vwEAxn8ZPY7Pn0CHRHY+Cfb+c9ovD2hShVhI0yS2MtyXn3jjhmFL6+ODY0/fgA3FlUwcOK0V+ICbAnj7VMY+tjgA0aAWCk/5rcxz8t3JTnsawT7NaHx1G7ChFPQVfPL9kIALk7WxuOuvKJ/xYRAiWLyncQ4t6nfSNeAVB0ji8/2Qy6rvKsPNDXmD3MEufcBfZHnDl1l1EyeJBp8lgfzoLpSdV8MI+eIlSZedr/wzX5pkul9QX9c/0MseFG2zOTfJCoiUWrYLcquSG39CEPIutF4+t5fI1TCpExmcQpXhDF5Ea5/gI5U5Bf/1xzYldDZWT2xWyq20a5rOmkFg0JhtHUHl7SmsHSlabf4M9jPvEupvYQq88FU+KPIbOrLWusa0/eCAtei6V3/AMcsg3bPlcq9l31J0Mv0TM5HUYiDZvTAXGc7bhblnVP4WsPbwB0ahKHaP0KsTB6eysYwstEXvYz9pgQBY=";
						//ss = "S078JKKtSvAMWap/sIGpd4eiphXoB0MB8EfFuFogsz8RLhrqnYxuAI8jchhX2zrYlCcVJcbeIfkwP7h6A+13QRIPDjUZPyuG6UtnbQ6iIeZ3kbVstT9zQlcDUPMVjAD4JHVZ2lWCPqykPdm+SBwc7OSYGsS5Q8mEyAjGgMXHAVxlQeLauYa356CSOcsB/pjUMYnx0gIkq6UbBaww+hoQmEhAruzflpFx55lURPRvl3MN9LEHm6AhmMHnLQeFv7EtpDnhn6e5RI0V//tTR+gnXxHvd38wDcZqazJzEIuwlFz5uTHvXqQyVhlUZ/KFndDCxLAriyVYNS0blll0g0zwDLYgjGiQ3k1jzd+Anm6ezt8Zx+AD+Hu4dHnYH97HGkOWXLIteQ4GC8skTCOQNh+YniVKAtoaulzZm1/c47/d4N/2bLmMUphfyCs1ZFyhhYVK9gU5jd1S9HNmiUEJ8VGw8anq/Ul8xwhmAMD2dbDxzal6OWGW7x/IABqqgeaBSe/aJpLxoAM1DX6Ot1Bsj1QQdIEr6qBddjXeuPNVpT5HMf7xlog1T0+3hZWycjAPVQYn6YwvWW71Xpkixiu+yph7e6BMfqzHVTddpXMy2OsODcO62AzviNnsVbgOXMKQF1URtbCgZW35/nHbVMvSsR9RuN0vSf9h52Sn+qOEg0uzD8XAZO+BPyYj1Z8kNTw6I8//15D1lrnxTu8b50YcV1sBP0eZpW+ko5tiKeBHSKTATIIm0YIQw+3q2+MX6qPKD+y5p0Y0VIegt56LP6CmauMmfl4XLm6qSzBn";
						//ss = "S078JKKtSvAMWap/sIGpd4eiphXoB0MB8EfFuFogsz8RLhrqnYxuAI8jchhX2zrYlCcVJcbeIfkwP7h6A+13QRIPDjUZPyuG6UtnbQ6iIeZ3kbVstT9zQlcDUPMVjAD4JHVZ2lWCPqykPdm+SBwc7OSYGsS5Q8mEyAjGgMXHAVxlQeLauYa356CSOcsB/pjUMYnx0gIkq6UbBaww+hoQmEhAruzflpFx55lURPRvl3NdXt1SKADgp0nxjUHmGpuo5Bye5R/JEpSTKU2VxHu6TvG9AhjjcAlvz+dnDaaG8AJmNMV0Wg2jAJ00OluDEcSE7x8YjasFacMXc/XJrnLELVp2a483nL/hWNZ7j9cl5f1ou9tdZK/P8lxRgKllLPuxlr+SZL9oxfJsZfQzEdwEtM4Iy7WJbWUVqDGZHAeGyzk2C5R4IH15DybDmJgreohoxMSJDTwz0HOPn6IebNrPkhcazQva/ZyDKco2I+b0XPqUa20Q5CeyetLMsvHa7BPm5QxlvYV4O+ODgQ1q1KrSNoJVC8n4gW/qvQpqpIfEPnlGpAfS0WTjtUBxs5nVAqe2y4ONPyfmdLNl/5vIr2WC7iZIUYZMffwTxgaWtFTl5Mx5l7LftvgsX+JI7Oy8b0ejpzYyMcKL0O7bbXzaF9/D11dM/Jdil1i48pVchBM7Eb63/mZTSVp87D5V6ucyqwrtLjegY5f0JFe/DvGtYY+6oE6mOt90aEIhIOXEKUpCeDJsZMVitS/G6QHnh10oKjpI8hMmheEY1Kk=";
						ss = "S078JKKtSvAMWap/sIGpd4eiphXoB0MB8EfFuFogsz8RLhrqnYxuAI8jchhX2zrYlCcVJcbeIfkwP7h6A+13QRIPDjUZPyuG6UtnbQ6iIeZ3kbVstT9zQlcDUPMVjAD4JHVZ2lWCPqykPdm+SBwc7OSYGsS5Q8mEyAjGgMXHAVxlQeLauYa356CSOcsB/pjUMYnx0gIkq6UbBaww+hoQmEhAruzflpFx55lURPRvl3MPnkNlFNe8yV/bB4AwUJDeySA9NnB2/fktOodpJn5eHy46WC/NTu9BT0P16hc3HXSzgqsPEq8AfHaSpYHrSlRdBjXVf+0swFQZsMnqOHX+8XNKXFTFysXWjqFcULR96ib44gmGEwIjXpyy00Q6Sv0wS974OOTlMpA82AOW0ZZfZMOkKwzdZlJPKnrZq4Xl5dPcGXF827yGb4mZOT4w/KCFH5Rny1J4pTZhq3jICtcr76J80nmwyqPOS3PXjitz+UFWpvcLRBdebm0EWl8fU+glCq902sAWwVTOZEALvp3QDOtb0NYlJZscaXzXKy3WDqq8xFG8OCEIyln/dyF+Gw4ychH/3tfhpACk/Yx02Q4R8zxmCQfdW1T0e2Z61uHD08c7TMC6UDJAuNt+i4mv52V3hU5/gDiHxDuu/owDs7Hrv3xF+uxaX+z3XtGlnz5XBMV4V2a32infICSn7brIn7JaXUgyB+bfOTJRxJI7FKwl/pGFUHDr975lGJq96h6vjq3fTikbPn5GHbVxl/zndFftu7iVuXeK030=";
						ss = "S078JKKtSvAMWap/sIGpd4eiphXoB0MB8EfFuFogsz8RLhrqnYxuAI8jchhX2zrYlCcVJcbeIfkwP7h6A+13QRIPDjUZPyuG6UtnbQ6iIeZ3kbVstT9zQlcDUPMVjAD4JHVZ2lWCPqykPdm+SBwc7OSYGsS5Q8mEyAjGgMXHAVxlQeLauYa356CSOcsB/pjUMYnx0gIkq6UbBaww+hoQmEhAruzflpFx55lURPRvl3MPnkNlFNe8yV/bB4AwUJDeySA9NnB2/fktOodpJn5eHy46WC/NTu9BT0P16hc3HXSzgqsPEq8AfHaSpYHrSlRdBjXVf+0swFQZsMnqOHX+8XNKXFTFysXWjqFcULR96ib44gmGEwIjXpyy00Q6Sv0wS974OOTlMpA82AOW0ZZfZMOkKwzdZlJPKnrZq4Xl5dPcGXF827yGb4mZOT4w/KCFH5Rny1J4pTZhq3jICtcr76J80nmwyqPOS3PXjitz+UFWpvcLRBdebm0EWl8fU+glCq902sAWwVTOZEALvp3QDOtb0NYlJZscaXzXKy3WDqq8xFG8OCEIyln/dyF+Gw4ychH/3tfhpACk/Yx02Q4R8zxmCQfdW1T0e2Z61uHD08c7TMC6UDJAuNt+i4mv52V3hU5/gDiHxDuu/owDs7Hrv3xF+uxaX+z3XtGlnz5XBMV4V2a32infICSn7brIn7JaXUgyB+bfOTJRxJI7FKwl/pGFUHDr975lGJq96h6vjq3fTikbPn5GHbVxl/zndFftu7iVuXeK030=";
						ss = "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";
			System.out.println(DESBASE64.decodeValue("12345678", ss));
			System.out.println(DESBASE64.encode("12345678", xxoo));
			
			String dateStr = DateX.format(new Date(), "yyyy/MM/dd HH:mm:ss");
			String dateStr2 = "2014/07/31";
			System.out.println(dateStr+"-" + dateStr2 + " Result: " + dateStr.compareTo(dateStr2));
			System.out.println(new SimpleDateFormat("yyyy/MM/dd/HH").format(new Date()));
		} finally {
			conn.close();
		}
		
	}
}
