/*
 * This software is the confidential and proprietary information
 * of Amarsoft, Inc. You shall not disclose such Confidential
 * Information and shall use it only in accordance with the terms
 * of the license agreement you entered into with Amarsoft.
 * 
 * Copyright (c) 1999-2011 Amarsoft, Inc.
 * 23F Building A Fudan University Technology Center,
 * No.11 Guotai Road YangPu District, Shanghai,P.R. China 200433
 * All Rights Reserved.
 * 
 */
package com.amarsoft.sadre.lic;

import java.io.FileOutputStream;
import java.io.IOException;
import java.io.ObjectOutputStream;

 /**
 * <p>Title: BuildLicense.java </p>
 * <p>Description:  </p>
 * <p>Copyright: Copyright (C) 2006-2011 Amarsoft Ltd. Co.</p> 
 *     
 * @author zllin@amarsoft.com
 * @version 
 * @date 2011-10-9 上午10:22:36
 *
 * logs: 1. 
 */
public class BuildLicense {

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		if(args.length==0){
			System.out.println("======BuildLicense 生成SADRE授权文件=======");
			System.out.println("用法: BuildLicense 授权客户名称");
			return;
		}
		
		String clientName = args[0];
		DefaultLicense lic = new DefaultLicense(clientName);
		
		ObjectOutputStream objOut = null;// 申明对象写入流对象
		try {
			objOut = new ObjectOutputStream(new FileOutputStream("sadre.lic"));// 创建对象写入流对象
			objOut.writeObject(lic);// 将对象写入文件

		} catch (IOException e) {
			e.printStackTrace();
		} finally {
			try {
				objOut.close();
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
		
		System.out.println("成功："+clientName+" 授权文件 sadre.lic 生成.");
	}

}
