//
//  Interface.h
//  TypeMovementSport
//
//  Created by XDH on 2018/8/22.
//  Copyright © 2018年 XDH. All rights reserved.
//

#ifndef Interface_h
#define Interface_h

//测试
//#define kBaseUrl @"http://gotest.51gosports.com/SportsServicePlatform/API/"

/*
 public前缀的接口不需要登录验证
 api前缀的接口有登录验证
 
 使用api接口时,请在请求头添加参数:
 Accept: application/json
 Authorization: 返回的token_type + " " + 返回的access_token (注意两个参数中间有一个空格)
 
 如无权限访问接口,会返回code: 401
 当code >= 400 && code < 500 为客户端错误,请根据返回的提示信息查找错误
 当code >= 500 && code < 600 为服务器端错误,请联系后台开发人员
 */
#define kBaseUrl [DeveloperConfig getCurrentUrl]


# pragma mark ----------------------------- 开发 --------------------------------------

#pragma mark --公共接口
#define kVersionUpdate @"public/appVersion/isUpgrade"//版本验证
#define kgetCityList @"public/city/findAllByParentId"//获取城市
#define kOutsideConnectNationalResultImg @"public/outsideConnect/nationnalResultImg"//生成成绩分享图片
#define kOutsideConnectShareCerImg @"public/outsideConnect/shareCertImg"//生成证书分享图片
#define kOutsideConnectQuery @"public/outsideConnect/query"//证书查询,成绩查询
#define kLaunchImage @"public/index/startImg"//启动页图片
#define kVideoShare @"api/video/share"//分享接口:参数:id:视频的id 是否分享,video的详情中添加字段:isShare
#define kUserAgreement @"http://test.xingdongsport.com/page/agreement.html"//用户协议URL
#define kWebTrainDetail @"https://test.xingdongsport.com/web/t/"//增值培训详情URL
#define kWebTrainShare @"https://test.xingdongsport.com/web/train/"//分享增值培训URL
#define kWebArticle @"https://test.xingdongsport.com/web/article/"//分享文章URL
#define kWebVideo @"https://test.xingdongsport.com/web/video/"//分享课程URL
#define kMessageFindAllBySystem @"public/message/findAllBySystem"//获取系统消息列表
#define kUserCouponBagReceive @"api/userCouponBag/receive"//扫码领取优惠券

#pragma mark -- 首页接口
#define kHomePage @"public/index/index1"//首页接口

#pragma mark --登录注册
#define kSendCode @"public/sms/sendCode"//获取短信验证码(开发环境发送成功后,验证码为0000)
#define kRegisterByPhone @"public/user/registerByPhone"//手机号注册
#define kLoginByPhone @"public/user/loginByPhone"//根据手机号登录
#define kUserList @"api/user/list"//获取用户列表
#define kUserGet @"api/user/get"//获取用户详情
#define kUserUpdate @"api/user/update"//修改用户详情
#define kUserForgetPwd @"public/user/forgetPwd"//忘记密码

#pragma mark --文章
#define kArticleChannel @"public/articleChannel/findAll"//获取文章频道
#define kPublicArticleList @"public/article/list"//获取文章列表 未登陆
#define kPublicArticleGet @"public/article/get"//获取文章详情 未登陆
#define kApiArticleGet @"api/article/get"//获取文章详情
#define kApiArticleList @"api/article/list"////获取文章列表
#define kArticleComment @"api/articleComment/save"//文章评论
#define kArticleCommentGetDatail @"api/articleComment/get"//获取评论详情
#define kArticleCommentList @"api/articleComment/list"//获取评论列表
#define kArticleCommentDel @"api/articleComment/del"//删除评论
#define kArticleCollectionToggle @"api/articleCollection/toggle"//关注文章 | 取消关注文章
#define kArticleCollectionList @"api/articleCollection/list"//获取关注列表

#pragma mark --简历
#define kResumeFind @"api/resume/find"//用户获取自己的简历
#define kResumeCreateOrUpdate @"api/resume/createOrUpdate"//用户创建或修改自己的简历
#define kResumeGet @"api/resume/get"//根据id获取简历
#define kResumeOpenOrClose @"api/resume/openOrClose"//公开或关闭自己的简历
#define kMatchExpCreate @"api/matchExp/create"//创建比赛经历
#define kMatchExpUpdate @"api/matchExp/update"//修改比赛经历
#define kMatchExpDel @"api/matchExp/del"//删除比赛经历
#define kMatchExpFindAll @"api/matchExp/findAll"//获取所有的比赛经历
#define kMatchExpGet @"api/matchExp/get"//根据id获取比赛经历
#define kTrainExpCreate @"api/trainExp/create"//创建培训经历
#define kTrainExpDel @"api/trainExp/del"//删除培训经历
#define kTrainExpUpdate @"api/trainExp/update"//修改培训经历
#define kTrainExpFindAll @"api/trainExp/findAll"//获取所有的培训经历
#define kTrainExpGet @"api/trainExp/get"//根据id获取培训经历
#define kWorkExpCreate @"api/workExp/create"//创建工作经历
#define kWorkExpUpdate @"api/workExp/update"//修改工作经历
#define kWorkExpDel @"api/workExp/del"//删除工作经历
#define kWorkExpFindAll @"api/workExp/findAll"//获取所有的培训经历
#define kWorkExpGet @"api/workExp/get"//根据id获取工作经历
#define kCompanyIsExist @"api/company/isExist"//用户获取自己是否注册企业
#define kUserResumeList @"api/userResume/list"//收藏简历列表
#define kCollectionPositionList @"api/collectionPosition/list"//收藏职位列表
#define kUserResumeToggle @"api/userResume/toggle"//收藏或取消收藏简历
#define kCollectionPositionToggle @"api/collectionPosition/toggle"//收藏或取消收藏职位
#define kDeliveryPositionList @"api/deliveryPosition/list"//获取投递的简历 | 获取投递过的公司
#define kDeliveryPositionCreate @"api/deliveryPosition/create"//投递简历
#define kPositionGet @"api/position/get"//根据id获得发布的职位信息
#define kCompanyFind @"api/company/find"//用户获取自己注册的企业信息
#define kCompanyCreate @"api/company/create"//用户注册企业
#define kPositionList @"api/position/list"//获取职位列表(根据各种条件)
#define kPublicCompanyGet @"public/company/get"//根据id获取注册的企业信息
#define kResumeList @"api/resume/list"//获取简历列表
#define kPositionCreate @"api/position/create"//创建职位信息
#define kPositionUpdate @"api/position/update"//修改职位信息
#define kCompanyUpdate @"api/company/update"//用户修改注册的企业信息


#pragma mark --增值培训
#define kUserTrainList @"api/userTrain/list"//获取我的增值培训列表
#define kPublicTrainList @"public/train/list"//获取增值培训列表
#define kApiTrainGet @"api/train/get"//获取增值培训详情



#pragma mark --题库
#define kApiClassFindAllByParent @"api/classes/findAllByParent"//根据分类获取分类(存在过期时间效验)
#define kQuestionFindAllByClass @"api/questions/findAllByClasses"//根据类别获取试题
#define kUserExamRecordsCreate @"api/userExamRecords/create"//创建考试记录
#define kUserExamRecordsList @"api/userExamRecords/list"//获取考试记录
#define kUserExamRecordsGet @"api/userExamRecords/get"//获取考试记录详情和对应的试题
#define kClassesFindAllByRoot @"public/classes/findAllByRoot"//根据分类获取根所有的类别(初中高级别题库)
#define kUserQuestionFeedback @"api/userQuestionFeedback/create"//试题反馈
#define kUserQuestionsRestore @"api/userQuestions/restore"//一键还原
#define kUserQuestionsIgnore @"api/userQuestions/ignore"//试题忽略
#define kUserQuestionsMark @"api/userQuestions/mark"//试题 标记 (如果没有标记过,返回true,如果已经标记,返回false)


#pragma mark --订单
#define kApiOrderCreate @"api/order/create"//创建订单
#define kUserCouponFindAll @"api/userCoupon/findAll"//获取我的优惠券
#define kUserCouponFindAllByOrder @"api/userCoupon/findAllByOrder"//根据订单获取可用和不可有优惠券列表
#define kOrderPay @"api/order/pay"//支付订单

#pragma mark --我的
#define kApiSignInSignIn @"api/signIn/signIn"//签到
#define kApiSignInFindAllByMonth @"api/signIn/findAllByMonth"//获取当月签到记录
#define kProposalCreate @"public/proposal/create"//留言


#pragma mark -- 课程
#define kVideoFindAllByClasses @"api/video/findAllByClasses"//根据视频分类获取根所有的类别

#pragma mark -- 电子名片
#define kMyCardFind @"api/myCard/find"//获取我的电子名片
#define kMyCardSave @"api/myCard/save"//保存名片
#define kBackgroundTemplateFindAll @"api/backgroundTemplate/findAll"//获取所有的背景模板
#define kInfoItemTemplateFindAll @"api/infoItemTemplate/findAll"//获取模板下的所有item(不包含必填项,必填项请手动加入)
#define kMyCardInfoItemCreateAll @"api/myCardInfoItem/createAll"//创建属性
#define kMyCardGenerate @"api/myCard/generate"//
#define k @""//
#define k @""//
#define k @""//
#define k @""//
#define k @""//
#define k @""//
#define k @""//
#define k @""//
#define k @""//
#define k @""//
#define k @""//
#endif /* Interface_h */
