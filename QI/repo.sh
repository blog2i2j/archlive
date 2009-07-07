#!/bin/bash
# $1  路径
# $2  自定义repo名
for pkgfile in $(ls $1/*.pkg.tar.gz); do
	repo-add $1/$2.db.tar.gz $pkgfile
done