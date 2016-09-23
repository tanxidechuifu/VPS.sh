#!/bin/bash
#----------------版权-----------------
#   名称：
#   版本号：
#   类型：
#   语言：Bash shell
#   日期：
#   作者：柳彦丞
#   网易云音乐：来自地板带着爱
#-------------------------------------

# 判断用户身份
	if [[ "$EUID" != 0 ]]; then
		echo "请以`cat /etc/passwd |cut -d: -f1|head -1`用户运行本脚本";exit;fi
# 脚本说明
cat << EOF 
	→_→自由 平等 公正 法治 爱国 敬业 诚信 友善←_←

本脚意为：

a.[自定义root用户、属组名及SSH端口号]
	可防止暴力撞库提高Linux稳定性
	自定义root用户、属组名默认值为admin
	如果选择改名，为了保证系统兼容性，原root家目录路径不变
	同时将生成一个无家目录的root普通用户及属主以掩人耳目，sudo命令将失效，请妥善保管好管理员帐号密码

	自定义SSH端口默认值为22233，推荐使用大端口号，可减小盲扫概率
b.[中文化Linux]
	语言地区配置（zh_CN.UTF-8）、校准时间（CST-8）
c.[快速搭建shadowsocksR及FinalSpeed翻墙梯]
	如果选择搭建梯子，则每日梯子定时重启时间默认值均为04:00

中括号标识均为可选项
推荐使用CentOS系统
键入回车则使用默认值
EOF

# 自定义"$USER"用户名
	read -p "是否需要修改"$USER"用户名（y/n）：" chid
	until [[ $chid =~ ^([y]|[n])$ ]]; do
		read -p "请重新键入是否需要修改"$USER"用户名（y/n）：" chid
	done
	if [[ $chid == y ]]; then
		read -p "请指定自定义""$USER""用户名：" username;username=${username:-admin}
	fi
# 更改用户"$USER"密码
	read -p "是否需要修改"$USER"密码（y/n）：" chmi
	until [[ $chmi =~ ^([y]|[n])$ ]]; do
		read -p "请重新键入是否需要修改"$USER"密码（y/n）：" chmi
	done
	if [[ $chmi == y ]]; then
		echo 更改用户"$USER"密码
			passwd
		until [[ `echo $?` == "0" ]]; do
			passwd
		done
	fi
# 自定义SSH端口号
	read -p "是否需要修改SSH端口号（y/n）：" chpo
	until [[ $chpo =~ ^([y]|[n])$ ]]; do
		read -p "请重新键入是否需要修改SSH端口号（y/n）：" chpo;
	done
	if [[ $chpo == y ]]; then
	read -p "请指定自定义SSH端口号（可用范围为0-65535 推荐使用大端口号）：" Port;Port=${Port:-22233}
		until  [[ $Port =~ ^([0-9]{1,4}|[1-5][0-9]{4}|6[0-5]{2}[0-3][0-5])$ ]];do
			read -p "请重新键入SSH自定义端口号：" Port;Port=${Port:-22233};

		done
	fi	
# 中文化Linux
	read -p "是否需要中文化Linux（y/n）：" chcn
	until [[ $chcn =~ ^([y]|[n])$ ]]; do
		read -p "请重新键入是否需要中文化Linux（y/n）：" chcn;
	done
# 是否需要安装shadowsocksR
	read -p "是否需要安装shadowsocksR（y/n）：" shadowsocks
	until [[ $shadowsocks =~ ^([y]|[n])$ ]]; do
		read -p "请重新键入需要安装shadowsocksR：（y/n）：" shadowsocks;
	done
	if [[ $shadowsocks == y ]]; then
		#是否需要安装FinalSpeed
			read -p "是否需要安装FinalSpeed（y/n）：" FinalSpeed;
			until [[ $FinalSpeed =~ ^([y]|[n])$ ]]; do
				read -p "请重新键入需要安装FinalSpeed：（y/n）：" FinalSpeed;
			done
		# 自定义梯子每日定时重启时间
		echo 请指定每日定时梯子重启时间（UTC/GMT+08:00）
			read -p "时（0-23）：" shi;shi=${shi:-04}
			read -p "分（0-59）：" fen;fen=${fen:-00}
			until [[ ($shi =~ ^[0-9]{1}|0[0-9]{1}|1[0-9]{1}|2[0,3]{1}$) && ($fen =~ ^[0-5]{0,1}[0-9]{1}$) ]]; do
				echo 请重新键入自定义重启时间
				read -p "时（0-23）：" shi;shi=${shi:-04}
				read -p "分（0-59）：" fen;fen=${fen:-00};
			done
	fi

#确认信息
if [[ !($chid$chmi$chpo$chcn$shadowsocks =~ y) ]]; then
	echo 选的全是否？
	sleep 3
	echo '	( •̀⊿•́)ง妖妖灵吗？我要报警了！'
	exit
fi
echo '	请确认以下信息：'
	if [[ $chid == y ]]; then
		echo 更改"$USER"用户名为$username（家文件目录不变 保证兼容性）
	fi
	if [[ $chpo == y ]]; then
		echo 自定义的端口号为$Port
	fi
	if [[ $chcn == y ]]; then
		echo 中文化Linux
	fi
	if [[ ($shadowsocks == y) ]]; then
		echo 需要安装shadowsocksR
	fi
	if [[ ($FinalSpeed == y) ]]; then
		echo 需要安装FinalSpeed
	fi
	if [[ $shadowsocks$FinalSpeed =~ y ]]; then
		echo 设置梯子于每日$shi:$fen定时重启
	fi
read -p "确认以上信息（yes/no）：" quren;
until [[ $quren == yes ]]; do
	echo '	๑乛◡乛๑卡在了奇怪的地方'
	exit
done
# 自动执行
echo '	(ノ°ο°)ノ非战斗人员请撤离！！'
# 更改"$USER"用户名
	if [[ $chid == y ]]; then
		echo 更改"$USER"用户名为$username（家文件目录不变）
			sed -i "s/"$USER":x/$username:x/" /etc/passwd
			sed -i "s/"$USER":/$username:/" /etc/shadow
			sed -i "s/"$USER":/$username:/" /etc/group
			if [[ $USER == root ]]; then
				useradd "$USER" -M -s /sbin/nologin
			fi
	fi
	if [[ $chpo == y ]]; then
		echo 更改SSH端口号为$Port
			sed -i "s/Port .*/Port $Port/" /etc/ssh/sshd_config
	fi
# 中文化Linux
	if [[ $chcn == y ]]; then
		echo 正在更改地区、语言配置
	#系统版本判断
			osv=`grep -oE  "[0-9]" /etc/redhat-release|head -1`
	#CentOS6	
			if [[ $osv == 6 ]]; then
				if [[ -s /etc/sysconfig/i18n ]]; then
					echo 正在安装EPEL源
						yum -y install epel-release >/dev/null
					echo 更新yum缓存
						yum makecache >/dev/null
					echo 正在安装中文语言包
						yum -y groupinstall chinese-support >/dev/null
					sed -i 's/LANG=.*/LANG="zh_CN.UTF-8"/' /etc/sysconfig/i18n
					sed -i 's/SYSFONT=.*/SYSFONT="latarcyrheb-sun16"/' /etc/sysconfig/i18n
				else
					echo -e 'LANG="zh_CN.UTF-8"\nSYSFONT="latarcyrheb-sun16"' >> /etc/sysconfig/i18n
				fi
			fi
	#CentOS7
			if [[ $osv == 7 ]]; then
				if [[ -s /etc/locale.conf ]]; then
					sed -i 's/LANG=.*/LANG="zh_CN.UTF-8"/' /etc/locale.conf
					sed -i 's/SYSFONT=.*/SYSFONT="latarcyrheb-sun16"/' /etc/locale.conf
				else
					echo -e 'LANG="zh_CN.UTF-8"\nSYSFONT="latarcyrheb-sun16"' >> /etc/locale.conf
				fi
			fi
		echo -e "更改时区为CST-8\n正在校准时间"
			echo 正在安装ntpdate
				yum -y install ntpdate>/dev/null
			(cat /etc/localtime|grep CST-8) || (rm -rf /etc/localtime;ln -s /usr/share/zoneinfo/Asia/Shanghai /etc/localtime)
			ntpdate 1.cn.pool.ntp.org|grep 
	fi
# 梯子
	if [[ $shadowsocks == y ]]; then
		echo 正在安装 wget crontab crontabs
		yum -y install wget crontab crontabs>/dev/null
		jihua=/var/spool/cron/`cat /etc/passwd |cut -d: -f1|head -1`
		echo 架设shadowsocksR服务端
			wget -N -c --no-check-certificate https://raw.githubusercontent.com/91yun/shadowsocks_install/master/shadowsocksR.sh && sh shadowsocksR.sh
			mkdir -p  /var/spool/cron/
			(grep "/etc/init.d/shadowsocks restart" $jihua > /dev/null && sed -i "s@.*/etc/init.d/shadowsocks restart.*@$fen $shi * * * /etc/init.d/shadowsocks restart@" $jihua) || echo "$fen $shi * * * /etc/init.d/shadowsocks restart" >> $jihua
				if [[ $FinalSpeed == y ]]; then
					echo 架设FinalSpeed服务端
					wget -N -c --no-check-certificate https://raw.githubusercontent.com/91yun/finalspeed/master/install_fs.sh && sh install_fs.sh
					(grep "sh /fs/restart.sh" $jihua > /dev/null && sed -i "s@.*sh /fs/restart.sh.*@$fen $shi * * * sh /fs/restart.sh@" $jihua) || echo "$fen $shi * * * sh /fs/restart.sh" >>$jihua
				fi
			echo 设定梯子于每日$shi:$fen定时重启
				chkconfig crond on
				service crond reload
				service crond restart
	fi
if [[ $chpo == y ]]; then
	echo 重启SSH服务
		service sshd restart
fi
echo '	╮(￣▽￣")╭ 进度条君已阵亡'
if [[ $chid$chpo$chcn =~ y ]]; then
	echo 准备重启
	reboot
fi
