#!/bin/bash
#上面中的 #! 是一种约定标记, 它可以告诉系统这个脚本需要什么样的解释器来执行;

echo "GitAutoPush Starting..."
time=$(date "+%Y-%m-%d %H:%M:%S")
git add .

read -t 30 -p "Reason for modification:" msg

if  [ ! "$msg" ] ;then
    echo "[commit message] Modified by: xiaz4, Submission time: ${time}"
	git commit -m "Modified by: xiaz4, Submission time: ${time}"
else
    echo "[commit message] $msg, Modified by: xiaz4, Submission time: ${time}"
	git commit -m "$msg, Modified by: xiaz4, Submission time: ${time}"
fi

#git push origin master

#提交到github
git push github master
#提交到码云
#git push gitee master

echo "GitAutoPush Ending..."