#!/usr/bin/env bash
script_mode="default_mode"
default_mode(){
if [[ ! -f ${WORKSPACE}/tools/FindLib.sh  ]];then
	echo "可能没有把脚本所在目录\"tools\"放在EDK2工作目录下，也有可能没有指定\"WORKSPACE\"，可以使用\"source edksetup.sh\"解决问题。"
	exit 1
fi
	read -p "Enter|q --> quit|" enter_a
if [[ $enter_a = "q" ]];then
	exit
elif [[ $enter_a = "" ]];then
	bash ${WORKSPACE}/tools/FindLib.sh
else
	clear
	tree_finally=`tree $find_dir |grep $enter_a |grep "inf"|awk -F ' ' ' { print $NF } '|cat|awk -F ' ' ' { print $0 } ' |sort|uniq`
	echo $tree_finally > ${WORKSPACE}/tools/logs
	tree_finally=`cat ${WORKSPACE}/tools/logs`
	if [[ `echo $tree_finally|awk ' {print NF} '` -gt 1 ]];then
		cd ${WORKSPACE}
		tree_finally_lines=`echo $tree_finally|awk ' {print NF} '`
		tree_finally_lines_print=0
		for ((;;))
		do
			if [[ $while_condition -ge $tree_finally_lines ]];then
				break
			else
				while_condition=`expr $while_condition + 1`
				tree_finally_lines_print=`expr $tree_finally_lines_print + 1`
				tree_finally_2=`echo $tree_finally|awk -v tree_finally_lines_print="$tree_finally_lines_print" -F ' ' ' {print $tree_finally_lines_print } '`
				echo "╭─$tree_finally_2"
				find_finally=`find . -name $tree_finally_2|sed 's/..//' >  $WORKSPACE/tools/log3`
				cat $WORKSPACE/tools/log3 |awk -v enter_a="$enter_a" ' { print  "+──>"enter_a"|" $0 } '
#				find_finally_2=`echo $find_finally|awk -v enter_a="$enter_a" ' { print  "╰─enter_a|" $0 } '`
#				echo "╰─$enter_a|$find_finally"
				echo $find_finally_2
				echo "------------------------------------------"
			fi
		done
		bash ${WORKSPACE}/tools/FindLib.sh
	elif [[ `echo $tree_finally|awk ' {print NF} '` -eq 1 ]];then
		cd ${WORKSPACE}
		echo "╭--<$tree_finally"
		find_finally=`find . -name $tree_finally`
		echo "╰-->$enter_a|$find_finally"
		echo "------------------------------------------"
		bash ${WORKSPACE}/tools/FindLib.sh
	else
		echo "╭─$enter_a"
		echo "╰─Not Found"
		bash ${WORKSPACE}/tools/FindLib.sh
	fi
fi
}

another_mode(){
	#不建议使用
	if [[ ! -f ${WORKSPACE}/tools/FindLib.sh  ]];then
		echo "可能没有把脚本所在目录\"tools\"放在EDK2工作目录下，也有可能没有指定\"WORKSPACE\"，可以使用\"source edksetup.sh\"解决问题。"
		exit 1
	fi
		read -p "Enter|q --> quit|" enter_a
	if [[ $enter_a = "q" ]];then
		exit
	elif [[ $enter_a = "" ]];then
		bash ${WORKSPACE}/tools/FindLib.sh
	else
		cd $WORKSPACE
		tree -f |grep $enter_a |grep -F ".inf" |awk -F ' ' ' { print $NF } '|cat|awk -F ' ' ' { print $0 } ' |sort|uniq > $WORKSPACE/tmp_default
		echo "╭--<$enter_a"
		cat $WORKSPACE/tmp_default |awk -v enter_a="$enter_a" ' { print  "+──>"enter_a"|" $0 } '
		bash ${WORKSPACE}/tools/FindLib.sh
	fi
}

$script_mode
