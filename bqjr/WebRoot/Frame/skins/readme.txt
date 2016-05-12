file pattern is UTF-8
1. 准备工作，底层修改
   1.0 SkinItem定义皮肤对象
   1.1 在AWE服务中增加定制皮肤初始化
       1.1.1 Web.xml文件中AWE初始化服务内增加定制皮肤包路径参数FixSkinFolder
       1.1.2 修改com.amarsoft.awe.control.InitAWEServlet
   1.2 在用户数据表USER_INFO中增加字段SkinPath
       ALTER TABLE USER_INFO ADD SkinPath VARCHAR(200);
       COMMENT ON COLUMN USER_INFO.SkinPath IS '皮肤路径';
   1.3 在用户对象com.amarsoft.context.ASUser中增加非空SkinItem skin属性
       1.3.1 在用户初始化数据查询中查询出SkinPath字段值赋予skin属性path值
       1.3.2 只提供getSkin方法，不提供setSkin方法，保证skin非空
   1.4 在用户登录信息初始化页面Logon.jsp增加用户当前皮肤初始化(根据皮肤地址重载皮肤对象)
   1.5 在菜单右侧按钮增加皮肤切换功能
       1.5.1 在SystemArea.jsp页面增加切换按钮
       1.5.2 增加修改用户皮肤AJax页面ReloadSkin.jsp
   1.6 在运行时环境初始化页面片段中，从用户信息CurUser中获取皮肤地址并定义皮肤地址变量sSkinPath
   1.6 在include文件中增加引入需要修改的样式文件，以sSkinPath为目录
2. 皮肤包增减
   2.1 在WebContent下增加皮肤包(有定制皮肤默认包，在web中配置FixSkinFolder中对应的地址)
   2.2 在皮肤包下存在三种文件
       2.2.1 皮肤包说明文件readme.properties,定义皮肤对象的一些属性，如名称 备注说明等
       2.2.2 皮肤对应图标icon.gif，便于展示在皮肤切换预览上
       2.2.3 具体皮肤样式文件，包含css images等

