#!/usr/bin/env python
# _*_ coding: utf-8 _*_

## date: 20150929

## 邮件相关配置变量
mail_to_list = ["yourname@your_company.com"]
#mail_host = "smtp.exmail.qq.com:465"
mail_host = "smtp.exmail.qq.com:25"
mail_user = "clb"
mail_password = "your_passwd"
mail_postfix = "your_company.com"
mail_from = mail_user + " <" +  mail_user + "@" + mail_postfix + ">"
mail_user_address = "your_name@your_company.com"

# 发送内容相关配置
subject = "default-email-subject"
mail_type = "plain"

