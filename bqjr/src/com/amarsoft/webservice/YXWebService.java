package com.amarsoft.webservice;

import javax.jws.WebService;
import javax.jws.soap.SOAPBinding;

@WebService
@SOAPBinding(style = SOAPBinding.Style.RPC, use = SOAPBinding.Use.LITERAL, parameterStyle = SOAPBinding.ParameterStyle.WRAPPED)
public interface YXWebService {

	/**
	 * ���idsΪ��, ����δʹ�����ݹ���, �������ݹ��������ó���, �򷵻�""
	 * @param objType ��������
	 * @param objNo ������
	 * @param typeNo Ӱ������
	 * @param UUID �ĵ�����id(���Ӱ��ʱ,id��','����)
	 * @return �ĵ�����ת���ɵ�base64�����ַ���(���Ӱ��ʱ,��'|'����)
	 */
	public String getImage(String objType, String objNo, String typeNo,
			String UUID);

	/**
	 * ���imageΪ��, ����δʹ�����ݹ���, �������ݹ��������ó���, �򷵻�""
	 * @param objType ��������
	 * @param objNo ������
	 * @param typeNo Ӱ������
	 * @param image Ӱ�����ݵ�base64�����ַ���
	 * @param userId �Ŵ�ϵͳ�û�id
	 * @param orgId �Ŵ�ϵͳ����id
	 * @return Ӱ���ĵ������id(���Ӱ��ʱ, ��','����)
	 */
	public String saveImage(String objType, String objNo, String typeNo,
			String image, String userId, String orgId);

}