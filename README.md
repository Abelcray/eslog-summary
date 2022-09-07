# 项目日志索引管理
- config 项目es配置文件(岛端名称、es链接、用户名（无认证设为1）、密码（无认证设为1）、文件夹、日志留存时间)
- get_info.sh 获取项目索引现状
- clear_log.sh 按照配置文件配置的保留时长删除索引
- 先执行get_info.sh后才可执行clear_log.sh
- 本脚本只适用于mac

# 用法
```shell
git clone git@github.com:Abelcray/eslog-summary.git

# 下载安装工具
pip3 install elasticsearch-curator -i https://pypi.tuna.tsinghua.edu.cn/simple

cd eslog-summary

# 从缓存中获取项目日志索引信息
sh get_info.sh

# 从实际项目环境中获取日志索引信息
sh get_info.sh getdata

# 脚本默认为测试模式不实际生效如要实际删除索引需要将16行中的--dry-run参数去掉，日志输出在/tmp/curator.log
sh clear_log.sh

```
