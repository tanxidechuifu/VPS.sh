#	→_→自由 平等 公正 法治 爱国 敬业 诚信 友善←_←

本脚意为：

###a.[自定义root用户、属组名、及SSH端口号]
	可防止暴力撞库提高Linux稳定性
	自定义root用户、属组名默认值为admin
	如果选择改名，为了保证系统兼容性，原root家目录路径不变
	同时将生成一个无家目录的root普通用户及属主以掩人耳目，sudo命令将失效，请妥善保管好管理员帐号密码

	自定义SSH端口默认值为22233，推荐使用大端口号，可减小盲扫概率
###b.[中文化Linux]
	语言地区配置（zh_CN.UTF-8）、校准时间（CST-8）
###c.[快速搭建shadowsocksR及FinalSpeed翻墙梯]
	如果选择搭建梯子，则每日梯子定时重启时间默认值均为04:00

中括号标识均为可选项<br>
推荐使用CentOS系统<br>
键入回车则使用默认值<br>
##使用说明：
>	 yum -y wget;wget https://raw.githubusercontent.com/tanxidechuifu/One-button.sh/blob/master/vps.sh;sh vps.sh

##日志：

1.0 发布
预计下一个版本将加入FS及锐速安装选项的自动判断

=
感谢[91yun](https://github.com/91yun)提供的脚本支持<br>
