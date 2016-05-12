package com.amarsoft.webservice;

import javax.jws.WebService;
import javax.jws.soap.SOAPBinding;

@WebService
@SOAPBinding(style = SOAPBinding.Style.RPC, use = SOAPBinding.Use.LITERAL, parameterStyle = SOAPBinding.ParameterStyle.WRAPPED)
public interface YXWebService {

	/**
	 * 如果ids为空, 或者未使用内容管理, 或者内容管理类配置出错, 则返回""
	 * @param objType 对象类型
	 * @param objNo 对象编号
	 * @param typeNo 影像类型
	 * @param UUID 文档对象id(多个影像时,id用','连接)
	 * @return 文档内容转换成的base64编码字符串(多个影像时,用'|'连接)
	 */
	public String getImage(String objType, String objNo, String typeNo,
			String UUID);

	/**
	 * 如果image为空, 或者未使用内容管理, 或者内容管理类配置出错, 则返回""
	 * @param objType 对象类型
	 * @param objNo 对象编号
	 * @param typeNo 影像类型
	 * @param image 影像内容的base64编码字符串
	 * @param userId 信贷系统用户id
	 * @param orgId 信贷系统机构id
	 * @return 影像文档对象的id(多个影像时, 用','连接)
	 */
	public String saveImage(String objType, String objNo, String typeNo,
			String image, String userId, String orgId);

}