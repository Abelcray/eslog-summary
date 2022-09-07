cat config | while read env url user pw dir days
do
   rm -rf $dir/curator*
   rm -rf $dir/action*
   cp -f template/curator.yml $dir/
   cp -f template/actions.yml $dir/
   sed -i '' -e  "s#description:#description: "$env"#" $dir/actions.yml
   sed -i '' -e  "s/1.1.1.1:9200/$url/" $dir/curator.yml 
   if [[ $pw != "1"  ]];then
   sed -i '' -e  "s#username:#username: $user#" $dir/curator.yml
   sed -i '' -e  "s#password:#password: $pw#" $dir/curator.yml
   fi
   sed -i '' -e  "s#unit\_count: 180#unit\_count: $days#" $dir/actions.yml
   sed -i '' -e  "s#logfile: curator.log#logfile: /tmp/curator.log#" $dir/curator.yml
   #实际清理需要清理的话去掉--dry-run，日志在/tmp/curator.log
   curator --config $dir/curator.yml $dir/actions.yml --dry-run
done
