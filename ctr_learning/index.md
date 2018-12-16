
## CTR

### Online advertising on search engines

1. show ad
2. search ad

> google,fb 大部分营收都来自于 ad
> 
> ad 其实也是你需要结果中的一部分
> 
> 行为定向，上下文定向
> 
> 广告 与 推荐，还是不一样的，广告是一个三方的东西

CTR预估，其实是可以在权衡三方之间的利益

## 广告收费形态

1. CPM (Cost Per Mile)
2. CPC (Cost Per Click)
3. CPA (Cost Per Action)

> CPM (Cost-Per-Mille): is an inventory based pricing model. Is when the price is based on 1,000 impressions.
>
> CPC (Cost-Per-Click): Is a performance-based metric. This means the Publisher only gets paid when (and if) a user clicks on an ad
>
>
> CPA (Cost Per Action): Best deal of all for Advertisers in terms of risk because they only pay for media when it results in a sale
>
>
> 曝光给用户了，用户点击的次数, 与用户点击来收费
>
> 用户是否点击，对 google、baidu 至关重要
>
> CTR 这个东西，是每曝光1000次，被用户点击了 100次， CTR 就是 0.1
>
> 这个比赛是 展示广告 的，不管是否有 query

## Click-through rate (CTR)

本身来看，一条广告，是否点击，是一个二分类问题，我们希望拿到一个概率值

大家印象中哪些模型比较擅长在分类的场景下输出 概率，我们有各种各样的模型，我们需要一个模型给我一个概率值。哪些模型比较擅长在分类的情况下输出概率值。LR 合适

CTR 的情况下，很少用 SVM，样本点到超平面距离归一化，那么可以输出也，但是非常少。

DNN 也是可以做的，用的最多最多的是 LR.

腾讯很多的广告的业务形态是不一样的，更多的是展示广告的场景，可靠度最高。

百度的例子，我用 LR ，可解释性非常强，你用 DNN 你要查问题，不知道为什么结果偏高

我已经帮大家给大家下载好了，这个数据，5G 多，在百度云上。

## Reference

- [CTR预估资料汇总][1]

## next..

[1]: https://www.zybuluo.com/hanxiaoyang/note/475105

