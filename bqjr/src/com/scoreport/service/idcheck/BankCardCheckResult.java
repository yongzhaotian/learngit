package com.scoreport.service.idcheck;
/**
 * 获取返回码对应的保存标志 0 可以保存 1 不可以保存 2 返回码不存在 
 * @author lennovo
 *
 */
public enum BankCardCheckResult {
	
	comn_04_0001("0"),//验证成功
	
	comn_00_0000("0"),//数据库异常

	S037_02_1000 ("1"),//验证失败

	S037_02_1001 ("0"),//验证失败,渠道提供方维护中

	S037_02_1002 ("1"),//验证失败,不支持的证件类型

	S037_02_1003 ("1"),//验证失败,请先开通认证支付

	S030_00_0000("0"),//验证成功

	S030_00_0003("1"),//验证失败

	S030_00_0013("0"),//提交银行出现错误，请检查发送参数！

	S030_00_6666("0"),//处理中

	S024_01_0002 ("1"),//路由结果错误,姓名必须为汉字
	//S024_02_0301 ("0"),
	S024_05_0108 ("1"),//未查到该银行卡的信息

	S052_03_0018 ("1"),//银行卡号与所选银行不匹配

	S052_03_0019 ("1"),//银行卡号与卡类型不匹配

	S024_01_0003("1"),//手机号码格式错误

	S024_01_0004("0"),//身份证号码格式错误

	S024_05_0101("1"),//账号格式错误

	S024_05_0104("1"),//账户借贷类型不匹配

	S024_04_0104("0"),//没有支持的验证渠道

	S024_02_0301("0"),//没有支持的验证渠道

	U000_07_1005("0"),//验卡结果查询超时

	U000_01_4005("0"),//暂不支持银行

	S052_06_0003("0"),//暂不支持银行

	comn_04_0003("1"),//请求参数非法

	PARAMETER_ERROR("1"),//请求参数错误

	S024_01_0006("1"),//校验失败

	S052_06_0002("1"),//参数校验失败

	S052_03_0011("1"),//银行卡号与所选银行不匹配
	
	NULL_CODE("0"),//返回码为空
	
	NOT_EXSIT_CODE("0");//返回码不存在



	
	// 成员变量
    private String flag;
	private BankCardCheckResult(String flag) {
		this.flag = flag;
	}
	public String getFlag() {
		return flag;
	}
	public void setFlag(String flag) {
		this.flag = flag;
	}
	
	// 普通方法
    public static String getFlagByCode(String resultcode) {
    	if(null == resultcode || "".equals(resultcode)){
    		return NULL_CODE.getFlag();
    	}
        for (BankCardCheckResult c : BankCardCheckResult.values()) {
            if (resultcode.equals(c.toString())) {
                return c.getFlag();
            }
        }
        return NOT_EXSIT_CODE.getFlag();
    }
	
}
