package com.scoreport.service.idcheck;
/**
 * ��ȡ�������Ӧ�ı����־ 0 ���Ա��� 1 �����Ա��� 2 �����벻���� 
 * @author lennovo
 *
 */
public enum BankCardCheckResult {
	
	comn_04_0001("0"),//��֤�ɹ�
	
	comn_00_0000("0"),//���ݿ��쳣

	S037_02_1000 ("1"),//��֤ʧ��

	S037_02_1001 ("0"),//��֤ʧ��,�����ṩ��ά����

	S037_02_1002 ("1"),//��֤ʧ��,��֧�ֵ�֤������

	S037_02_1003 ("1"),//��֤ʧ��,���ȿ�ͨ��֤֧��

	S030_00_0000("0"),//��֤�ɹ�

	S030_00_0003("1"),//��֤ʧ��

	S030_00_0013("0"),//�ύ���г��ִ������鷢�Ͳ�����

	S030_00_6666("0"),//������

	S024_01_0002 ("1"),//·�ɽ������,��������Ϊ����
	//S024_02_0301 ("0"),
	S024_05_0108 ("1"),//δ�鵽�����п�����Ϣ

	S052_03_0018 ("1"),//���п�������ѡ���в�ƥ��

	S052_03_0019 ("1"),//���п����뿨���Ͳ�ƥ��

	S024_01_0003("1"),//�ֻ������ʽ����

	S024_01_0004("0"),//���֤�����ʽ����

	S024_05_0101("1"),//�˺Ÿ�ʽ����

	S024_05_0104("1"),//�˻�������Ͳ�ƥ��

	S024_04_0104("0"),//û��֧�ֵ���֤����

	S024_02_0301("0"),//û��֧�ֵ���֤����

	U000_07_1005("0"),//�鿨�����ѯ��ʱ

	U000_01_4005("0"),//�ݲ�֧������

	S052_06_0003("0"),//�ݲ�֧������

	comn_04_0003("1"),//��������Ƿ�

	PARAMETER_ERROR("1"),//�����������

	S024_01_0006("1"),//У��ʧ��

	S052_06_0002("1"),//����У��ʧ��

	S052_03_0011("1"),//���п�������ѡ���в�ƥ��
	
	NULL_CODE("0"),//������Ϊ��
	
	NOT_EXSIT_CODE("0");//�����벻����



	
	// ��Ա����
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
	
	// ��ͨ����
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
