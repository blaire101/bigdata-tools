# -*- coding: utf-8 -*-
import pandas as pd

s = pd.Series([1, 2, 3], index=['a', 'b', 'c']) # 创建一个序列 s

d = pd.DataFrame([[1, 2, 3], [4, 5, 6]], columns=['a', 'b', 'c']) # 创建一个 table

d2 = pd.DataFrame(s)

d.head(2) # 默认预览前 5 行

d.describe() # 数据基本统计量

# 读取文件
pd.read_excel('data.xls') # 读取 Excel 文件, 创建 DataFrame.
# pd.read_csv('data.csv', encoding='utf-8') # 读取文本, 一般指定 encoding