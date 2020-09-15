#!/bin/bash
#�����е� #! ��һ��Լ�����, �����Ը���ϵͳ����ű���Ҫʲô���Ľ�������ִ��;

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

#�ύ��github
git push github master
#�ύ������
#git push gitee master

echo "GitAutoPush Ending..."