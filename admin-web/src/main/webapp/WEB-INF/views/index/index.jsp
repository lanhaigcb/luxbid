<%@ taglib prefix="fn" uri="/func" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="renderer" content="webkit">
    <meta http-equiv="Cache-Control" content="no-siteapp"/>
    <title>后台管理</title>
    <!--[if lt IE 9]>
    <meta http-equiv="refresh" content="0;ie.html"/>
    <![endif]-->

    <link rel="shortcut icon" href="favicon.ico">
    <link href="theme/css/bootstrap.min14ed.css?v=3.3.6" rel="stylesheet">
    <link href="theme/css/font-awesome.min93e3.css?v=4.4.0" rel="stylesheet">
    <link href="theme/css/animate.min.css" rel="stylesheet">
    <link href="theme/css/style.min862f.css?v=4.1.0" rel="stylesheet">
</head>

<body class="fixed-sidebar full-height-layout gray-bg" style="overflow:hidden">
<div id="wrapper">
    <!--左侧导航开始-->
    <nav class="navbar-default navbar-static-side" role="navigation">
        <div class="nav-close"><i class="fa fa-times-circle"></i>
        </div>
        <div class="sidebar-collapse">
            <ul class="nav" id="side-menu">
                <li class="nav-header">
                    <div class="dropdown profile-element">
                        <a data-toggle="dropdown" class="dropdown-toggle" href="#">
                               <span class="clear">
                                   <span class="block m-t-xs"><strong
                                           class="font-bold">${ sessionScope.staffName}</strong></span>
                                   <span class="text-muted text-xs block">${ sessionScope.roleName}<b class="caret"></b></span>
                               </span>
                        </a>
                        <ul class="dropdown-menu animated fadeInRight m-t-xs">
                            <li class="divider"></li>
                            <li><a href="logout">安全退出</a></li>
                            <li><a href="staff/update/password">修改密码</a>
                            <li><a href="sec/toBindGoogle">绑定谷歌验证</a>
                            </li>
                        </ul>
                    </div>
                    <div class="logo-element">后台管理
                    </div>
                </li>
                <fn:func url="c2c/">
                <li>
                    <a href="#"><i class="fa fa-user-secret"></i><span class="nav-label">法币交易</span><span
                            class="fa arrow"></span></a>
                    <ul class="nav nav-second-level">
                        <fn:func url="/c2cCustomer">
                        <li>
                            <a class="J_menuItem" href="c2cCustomer/index">用户管理</a>
                        </li>
                        </fn:func>
                        <fn:func url="/c2cCurrency">
                        <li>
                            <a class="J_menuItem" href="c2cCurrency/index">币种管理</a>
                        </li>
                        </fn:func>
                        <fn:func url="/c2cOrder">
                        <li>
                            <a class="J_menuItem" href="c2cOrder/index">订单管理</a>
                        </li>
                        </fn:func>
                        <fn:func url="/c2cBuyOrder">
                            <li>
                                <a class="J_menuItem" href="c2cBuyOrder/index">买入订单审核</a>
                            </li>
                        </fn:func>
                        <fn:func url="/c2cSellOrder">
                            <li>
                                <a class="J_menuItem" href="c2cSellOrder/index">卖出订单审核</a>
                            </li>
                        </fn:func>
                        <fn:func url="/c2cPrice">
                        <li>
                            <a class="J_menuItem" href="c2cPrice/index">单价管理</a>
                        </li>
                        </fn:func>
                       <%-- <fn:func url="/c2cLimit">
                        <li>
                            <a class="J_menuItem" href="c2cLimit/index">限额管理</a>
                        </li>
                        </fn:func>--%>
                        <fn:func url="/c2cBankcard">
                        <li>
                            <a class="J_menuItem" href="c2cBankcard/index">银行账号管理</a>
                        </li>
                        </fn:func>
                        <fn:func url="/c2cStatistic">
                        <li>
                            <a class="J_menuItem" href="c2cStatistic/index">数据统计</a>
                        </li>
                        </fn:func>
                    </ul>
                </li>
                </fn:func>
                <fn:func url="customer/">
                    <li>
                        <a href="#"><i class="fa fa-user"></i><span class="nav-label">用户管理</span><span
                                class="fa arrow"></span></a>
                        <ul class="nav nav-second-level">
                            <fn:func url="customer/index">
                                <li>
                                    <a class="J_menuItem" href="customer/index">用户管理</a>
                                </li>
                            </fn:func>

                            <fn:func url="idAudit/index">
                                <li>
                                    <a class="J_menuItem" href="idAudit/index">用户实名审核</a>
                                </li>
                            </fn:func>
                            <fn:func url="whitelist/index">
                                <li>
                                    <a class="J_menuItem" href="whitelist/index">用户白名单审核</a>
                                </li>
                            </fn:func>
                            <fn:func url="exchangeOrder/index">
                                <li>
                                    <a class="J_menuItem" href="exchangeOrder/index">客户订单</a>
                                </li>
                            </fn:func>
                            <fn:func url="exchangeOrderDetail/index">
                                <li>
                                    <a class="J_menuItem" href="exchangeOrderDetail/index">订单成交记录</a>
                                </li>
                            </fn:func>
                        </ul>
                    </li>
                </fn:func>

                <fn:func url="application/">
                    <li>
                        <a href="#"><i class="fa fa-envelope"></i><span class="nav-label">应用管理</span><span
                                class="fa arrow"></span></a>
                        <ul class="nav nav-second-level">

                            <fn:func url="banner/index">
                                <li>
                                    <a class="J_menuItem" href="banner/index">banner管理</a>
                                </li>
                            </fn:func>
                            <fn:func url="exchangeView/index">
                                <li>
                                    <a class="J_menuItem" href="exchangeView/index">首页行情配置</a>
                                </li>
                            </fn:func>
                            <fn:func url="affiche/index">
                                <li>
                                    <a class="J_menuItem" href="affiche/index">公告管理</a>
                                </li>
                            </fn:func>
                            <fn:func url="help/index">
                                <li>
                                    <a class="J_menuItem" href="help/index">帮助中心分类</a>
                                </li>
                            </fn:func>
                            <fn:func url="helpDetail/index">
                                <li>
                                    <a class="J_menuItem" href="helpDetail/index">帮助中心明细</a>
                                </li>
                            </fn:func>
                        <%--</ul>
                    </li>
                </fn:func>

                <fn:func url="mobile/">
                    <li>
                        <a href="#"><i class="fa fa-mobile"></i><span class="nav-label">移动端管理</span><span
                                class="fa arrow"></span></a>
                        <ul class="nav nav-second-level">--%>
                            <fn:func url="mobileUpdateLog/index">
                                <li>
                                    <a class="J_menuItem" href="mobileUpdateLog/index">手机日志更新管理</a>
                                </li>
                            </fn:func>
                            <fn:func url="versionUpdate/index">
                                <li>
                                    <a class="J_menuItem" href="versionUpdate/index">手机版本更新管理</a>
                                </li>
                            </fn:func>
                        </ul>
                    </li>
                </fn:func>

                <fn:func url="currency/">
                    <li>
                        <a href="#"><i class="fa fa-bitcoin"></i><span class="nav-label">币种管理</span><span
                                class="fa arrow"></span></a>
                        <ul class="nav nav-second-level">
                            <fn:func url="currency/index">
                                <li>
                                    <a class="J_menuItem" href="currency/index">币种管理</a>
                                </li>
                            </fn:func>
                            <fn:func url="exchange/index">
                                <li>
                                    <a class="J_menuItem" href="exchange/index">交易对管理</a>
                                </li>
                            </fn:func>
                            <fn:func url="currencyIntroduct/index">
                                <li>
                                    <a class="J_menuItem" href="currencyIntroduct/index">币种介绍</a>
                                </li>
                            </fn:func>
                            <fn:func url="currencyApply/index">
                                <li>
                                    <a class="J_menuItem" href="currencyApply/index">查看上币申请</a>
                                </li>
                            </fn:func>
                            <fn:func url="exchangePartition/index">
                                <li>
                                    <a class="J_menuItem" href="exchangePartition/index">币种分区管理</a>
                                </li>
                            </fn:func>
                            <fn:func url="mytokenCurrency/index">
                                <li>
                                    <a class="J_menuItem" href="mytokenCurrency/index">mytoken币种注册</a>
                                </li>
                            </fn:func>
                            <fn:func url="mytokenExchange/index">
                                <li>
                                    <a class="J_menuItem" href="mytokenExchange/index">mytoken交易对注册</a>
                                </li>
                            </fn:func>
                        </ul>
                    </li>
                </fn:func>

                <fn:func url="payment/">
                    <li>
                        <a href="#"><i class="fa fa-exchange"></i><span class="nav-label">充提记录</span><span
                                class="fa arrow"></span></a>
                        <ul class="nav nav-second-level">
                            <fn:func url="recharge/index">
                                <li>
                                    <a class="J_menuItem" href="recharge/index">充币记录</a>
                                </li>
                            </fn:func>
                            <fn:func url="withdrawRecord/index">
                                <li>
                                    <a class="J_menuItem" href="withdrawRecord/index">提币记录</a>
                                </li>
                            </fn:func>
                        </ul>
                    </li>
                </fn:func>
                <%--<fn:func url="order/">
                    <li>
                        <a href="#"><i class="fa fa-reorder"></i><span class="nav-label">订单管理</span><span
                                class="fa arrow"></span></a>
                        <ul class="nav nav-second-level">
                            <fn:func url="exchangeOrder/index">
                                <li>
                                    <a class="J_menuItem" href="exchangeOrder/index">客户订单</a>
                                </li>
                            </fn:func>
                            <fn:func url="exchangeOrderDetail/index">
                                <li>
                                    <a class="J_menuItem" href="exchangeOrderDetail/index">订单成交记录</a>
                                </li>
                            </fn:func>
                        </ul>
                    </li>
                </fn:func>--%>
                <fn:func url="systemManage/">
                    <li>
                        <a href="#"><i class="fa fa-lock"></i><span class="nav-label">系统用户管理</span><span
                                class="fa arrow"></span></a>
                        <ul class="nav nav-second-level">
                            <fn:func url="staff/index">
                                <li>
                                    <a class="J_menuItem" href="staff/index">用户管理</a>
                                </li>
                            </fn:func>
                            <fn:func url="staffRole/index">
                                <li>
                                    <a class="J_menuItem" href="staffRole/index">角色管理</a>
                                </li>
                            </fn:func>
                            <fn:func url="functionInfo/index">
                                <li>
                                    <a class="J_menuItem" href="functionInfo/index">菜单管理</a>
                                </li>
                            </fn:func>
                                <fn:func url="staff/staffOperationLogIndex">
                                <li>
                                    <a class="J_menuItem" href="staff/staffOperationLogIndex">用户操作日志</a>
                                </li>
                            </fn:func>
                        </ul>
                    </li>
                </fn:func>
                <%--<fn:func url="systemConf/">
                    <li>
                        <a href="#"><i class="fa fa-cog"></i><span class="nav-label">系统参数配置</span><span
                                class="fa arrow"></span></a>
                        <ul class="nav nav-second-level">
                            <fn:func url="systemSetting/index">
                                <li>
                                    <a class="J_menuItem" href="systemSetting/index">系统参数配置</a>
                                </li>
                            </fn:func>
                        </ul>
                    </li>
                </fn:func>--%>
                <fn:func url="systemConvert/">
                    <li>
                        <a href="#"><i class="fa fa-arrows-h"></i><span class="nav-label">兑换邀请管理</span><span
                                class="fa arrow"></span></a>
                        <ul class="nav nav-second-level">
                            <fn:func url="convert/index">
                                <li>
                                    <a class="J_menuItem" href="convert/index">兑换规则管理</a>
                                </li>
                            </fn:func>
                            <fn:func url="convertRecord/index">
                                <li>
                                    <a class="J_menuItem" href="convertRecord/index">兑换记录</a>
                                </li>
                            </fn:func>
                                <%--<fn:func url="convertInfo/index">
                                    <li>
                                        <a class="J_menuItem" href="convertInfo/index">兑换统计</a>
                                    </li>
                                </fn:func>--%>
                       <%-- </ul>
                    </li>
                </fn:func>
                <fn:func url="systemInvite/">
                    <li>
                        <a href="#"><i class="fa fa-share-alt"></i><span class="nav-label">邀请信息管理</span><span
                                class="fa arrow"></span></a>
                        <ul class="nav nav-second-level">--%>
                            <fn:func url="invite/index">
                                <li>
                                    <a class="J_menuItem" href="invite/index">邀请信息管理</a>
                                </li>
                            </fn:func>
                            <fn:func url="inviteRecord/index">
                                <li>
                                    <a class="J_menuItem" href="inviteRecord/index">邀请记录</a>
                                </li>
                            </fn:func>
                                <%--<fn:func url="convertInfo/index">
                                    <li>
                                        <a class="J_menuItem" href="convertInfo/index">邀请统计</a>
                                    </li>
                                </fn:func>--%>
                        </ul>
                    </li>
                </fn:func>
                <fn:func url="robot/">
                    <li>
                        <a href="#"><i class="fa fa-share-alt"></i><span class="nav-label">机器人信息</span><span
                                class="fa arrow"></span></a>
                        <ul class="nav nav-second-level">
                            <fn:func url="robot/robotConfig">
                                <li>
                                    <a class="J_menuItem" href="robotConfig/index">机器人价格配置</a>
                                </li>
                            </fn:func>
                            <fn:func url="robot/robotProfitTotal">
                                <li>
                                    <a class="J_menuItem" href="robotConfig/robotProfitTotalIndex">机器人盈亏统计</a>
                                </li>
                            </fn:func>
                            <fn:func url="robot/robotVolumeTotal">
                                <li>
                                    <a class="J_menuItem" href="robotConfig/robotVolumeTotalIndex">机器人交易量统计</a>
                                </li>
                            </fn:func>
                        </ul>
                    </li>
                </fn:func>
                <fn:func url="audit/">
                    <li>
                        <a href="#"><i class="fa fa-bank"></i><span class="nav-label">财务审核</span><span
                                class="fa arrow"></span></a>
                        <ul class="nav nav-second-level">
                            <fn:func url="withdraw/index">
                                <li>
                                    <a class="J_menuItem" href="withdraw/index">提币一次审核</a>
                                </li>
                            </fn:func>
                            <fn:func url="withdraw/auditTwo/index">
                                <li>
                                    <a class="J_menuItem" href="withdraw/auditTwo/index">提币二次审核</a>
                                </li>
                            </fn:func>
                        </ul>
                    </li>
                </fn:func>
                <fn:func url="systemAward/">
                    <li>
                        <a href="#"><i class="fa fa-user-secret"></i><span class="nav-label">活动奖励</span><span
                                class="fa arrow"></span></a>
                        <ul class="nav nav-second-level">
                            <fn:func url="awardConfig/index">
                                <li>
                                    <a class="J_menuItem" href="awardConfig/index">预算管理</a>
                                </li>
                            </fn:func>
                            <fn:func url="award/index">
                                <li>
                                    <a class="J_menuItem" href="award/index">奖励发放</a>
                                </li>
                            </fn:func>
                            <fn:func url="awardRecord/index">
                                <li>
                                    <a class="J_menuItem" href="awardRecord/index">奖励记录</a>
                                </li>
                            </fn:func>
                            <fn:func url="awardCheck/index">
                                <li>
                                    <a class="J_menuItem" href="awardCheck/index">奖励审核</a>
                                </li>
                            </fn:func>
                        </ul>
                    </li>
                </fn:func>
                <fn:func url="systemStatistical/">
                    <li>
                        <a href="#"><i class="fa fa-user-secret"></i><span class="nav-label">统计管理</span><span
                                class="fa arrow"></span></a>
                        <ul class="nav nav-second-level">
                            <fn:func url="customer/statisticalInfo">
                                <li>
                                    <a class="J_menuItem" href="customer/statisticalInfo">用户统计</a>
                                </li>
                            </fn:func>
                            <fn:func url="statistics/earningsLog">
                                <li>
                                    <a class="J_menuItem" href="subAccountLog/index">收益日志</a>
                                </li>
                            </fn:func>
                            <fn:func url="statistics/asset">
                                <li>
                                    <a class="J_menuItem" href="systemAccount/index">资产统计</a>
                                </li>
                            </fn:func>
                            <fn:func url="statistics/makebargain">
                                <li>
                                    <a class="J_menuItem" href="systemAccount/makebargain">用户成交统计</a>
                                </li>
                            </fn:func>
                            <fn:func url="statistics/tradeFee">
                                <li>
                                    <a class="J_menuItem" href="systemAccount/tradeFee">交易收益统计</a>
                                </li>
                            </fn:func>
                            <fn:func url="statistics/haveAsset">
                                <li>
                                    <a class="J_menuItem" href="systemAccount/haveAsset">持币统计</a>
                                </li>
                            </fn:func>
                        </ul>
                    </li>
                </fn:func>
                <fn:func url="act/">
                    <li>
                        <a href="#"><i class="fa fa-cog"></i><span class="nav-label">福利活动</span><span
                                class="fa arrow"></span></a>
                        <ul class="nav nav-second-level">
                            <fn:func url="act/index">
                                <li>
                                    <a class="J_menuItem" href="act/index">福利活动</a>
                                </li>
                            </fn:func>
                        </ul>
                    </li>
                </fn:func>
                <fn:func url="luckyWheel/">
                    <li>
                        <a href="#"><i class="fa fa-user-secret"></i><span class="nav-label">幸运转盘</span><span
                                class="fa arrow"></span></a>
                        <ul class="nav nav-second-level">
                            <fn:func url="activity/index">
                                <li>
                                    <a class="J_menuItem" href="activity/index">活动方案</a>
                                </li>
                            </fn:func>
                            <fn:func url="activityConfig/index">
                                <li>
                                    <a class="J_menuItem" href="activityConfig/index">方案配置</a>
                                </li>
                            </fn:func>
                            <fn:func url="luckyDrawRecord/index">
                                <li>
                                    <a class="J_menuItem" href="luckyDrawRecord/index">奖励记录</a>
                                </li>
                            </fn:func>
                        </ul>
                    </li>
                </fn:func>
                <fn:func url="loan/">
                    <li>
                        <a href="#"><i class="fa fa-user-secret"></i><span class="nav-label">抵押管理</span><span
                                class="fa arrow"></span></a>
                        <ul class="nav nav-second-level">
                            <fn:func url="list/apply">
                            <li>
                                <a class="J_menuItem" href="loan/apply">申请订单管理</a>
                            </li>
                            </fn:func>
                            <fn:func url="list/leading">
                            <li>
                                <a class="J_menuItem" href="loan/leading">质押中订单管理</a>
                            </li>
                            </fn:func>
                            <fn:func url="list/unwind">
                            <li>
                                <a class="J_menuItem" href="loan/unwind">已平仓订单</a>
                            </li>
                            </fn:func>
                            <fn:func url="loanCurrencyProduct/index">
                                <li>
                                    <a class="J_menuItem" href="loanCurrencyProduct/index">产品管理</a>
                                </li>
                            </fn:func>
                            <fn:func url="loanAmountRate/index">
                                <li>
                                    <a class="J_menuItem" href="loanAmountRate/index">利率管理</a>
                                </li>
                            </fn:func>
                        </ul>
                    </li>
                </fn:func>


                <fn:func url="cfd/">
                    <li>
                        <a href="#"><i class="fa fa-user-secret"></i><span class="nav-label">合约交易</span><span
                                class="fa arrow"></span></a>
                        <ul class="nav nav-second-level">
                            <fn:func url="statistics/index">
                                <li>
                                    <a class="J_menuItem" href="cfd/statistics">持仓监控</a>
                                </li>
                            </fn:func>
                            <fn:func url="cfdCurrency/index">
                                <li>
                                    <a class="J_menuItem" href="cfdCurrency/index">产品管理</a>
                                </li>
                            </fn:func>
                            <fn:func url="cfdCustomer/index">
                                <li>
                                    <a class="J_menuItem" href="cfdCustomer/index">用户管理</a>
                                </li>
                            </fn:func>
                            <fn:func url="cfdNode/index">
                                <li>
                                    <a class="J_menuItem" href="cfdNode/index">节点管理</a>
                                </li>
                            </fn:func>
                            <fn:func url="cfdNode/nodes">
                                <li>
                                    <a class="J_menuItem" href="cfdNode/nodes">节点监控</a>
                                </li>
                            </fn:func>
                            <fn:func url="cfd/capitalFlow">
                                <li>
                                    <a class="J_menuItem" href="cfd/capitalFlow">资金流水</a>
                                </li>
                            </fn:func>
                            <fn:func url="cfd/position">
                                <li>
                                    <a class="J_menuItem" href="cfd/position">客户持仓单</a>
                                </li>
                            </fn:func>
                            <fn:func url="cfd/customerUnwind">
                                <li>
                                    <a class="J_menuItem" href="cfd/customerUnwind">客户平仓单</a>
                                </li>
                            </fn:func>
                            <fn:func url="cfd/nodeUnwind">
                                <li>
                                    <a class="J_menuItem" href="cfd/nodeUnwind">节点平仓单查询</a>
                                </li>
                            </fn:func>
                            <fn:func url="cfd/nodePosition">
                                <li>
                                    <a class="J_menuItem" href="cfd/nodePosition">节点持仓单查询</a>
                                </li>
                            </fn:func>

                            <fn:func url="cfdFlowAsset/nodeFlowAsset">
                                <li>
                                    <a class="J_menuItem" href="cfdFlowAsset/nodeFlowAsset">节点出入金报表</a>
                                </li>
                            </fn:func>
                            <fn:func url="cfdFlowAsset/customerFlowAsset">
                                <li>
                                    <a class="J_menuItem" href="cfdFlowAsset/customerFlowAsset">客户出入金报表</a>
                                </li>
                            </fn:func>
                            <fn:func url="cfdFlowAsset/customerFlowAsset">
                                <li>
                                    <a class="J_menuItem" href="cfdFlowAsset/customerAsset">客户资金查询</a>
                                </li>
                            </fn:func>
                            <fn:func url="cfdTransferRewardRecord/index">
                                <li>
                                    <a class="J_menuItem" href="cfdTransferRewardRecord/index">合约参与列表活动管理</a>
                                </li>
                            </fn:func>
                            <fn:func url="cfdTransferRewardApply/index">
                                <li>
                                    <a class="J_menuItem" href="cfdTransferRewardApply/index">合约满足条件活动管理</a>
                                </li>
                            </fn:func>
                        </ul>
                    </li>
                    </fn:func>
            </ul>
        </div>
    </nav>
    <!--左侧导航结束-->
    <!--右侧部分开始-->
    <div id="page-wrapper" class="gray-bg dashbard-1">
        <div class="row border-bottom">
            <nav class="navbar navbar-static-top" role="navigation" style="margin-bottom: 0">
                <div class="navbar-header"><a class="navbar-minimalize minimalize-styl-2 btn btn-primary " href="#"><i
                        class="fa fa-bars"></i> </a>
                    <form role="search" class="navbar-form-custom" method="post"
                          action="http://www.suhai.com/theme/hplus/search_results.html">
                        <div class="form-group">
                            <input type="text" placeholder="请输入您需要查找的内容 …" class="form-control" name="top-search"
                                   id="top-search">
                        </div>
                    </form>
                </div>
                <ul class="nav navbar-top-links navbar-right">
                    <li class="dropdown"></li>
                    <li class="dropdown"></li>
                </ul>
            </nav>
        </div>
        <div class="row content-tabs">
            <button class="roll-nav roll-left J_tabLeft"><i class="fa fa-backward"></i>
            </button>
            <nav class="page-tabs J_menuTabs">
                <div class="page-tabs-content">
                    <a href="javascript:;" class="active J_menuTab" data-id="index_v1.html">首页</a>
                </div>
            </nav>
            <button class="roll-nav roll-right J_tabRight"><i class="fa fa-forward"></i>
            </button>
            <div class="btn-group roll-nav roll-right">
                <button class="dropdown J_tabClose" data-toggle="dropdown">关闭操作<span class="caret"></span>

                </button>
                <ul role="menu" class="dropdown-menu dropdown-menu-right">
                    <li class="J_tabShowActive"><a>定位当前选项卡</a>
                    </li>
                    <li class="divider"></li>
                    <li class="J_tabCloseAll"><a>关闭全部选项卡</a>
                    </li>
                    <li class="J_tabCloseOther"><a>关闭其他选项卡</a>
                    </li>
                </ul>
            </div>
            <a href="logout" class="roll-nav roll-right J_tabExit"><i class="fa fa fa-sign-out"></i> 退出</a>
        </div>

        <div class="row J_mainContent" id="content-main">
            <iframe class="J_iframe" name="iframe0" width="100%" height="100%" src="welcome" frameborder="0"
                    data-id="index_v1.html" seamless></iframe>
        </div>
        <div class="footer">
        </div>
    </div>

</div>
<script src="theme/js/jquery.min.js?v=2.1.4"></script>
<script src="theme/js/bootstrap.min.js?v=3.3.6"></script>
<script src="theme/js/plugins/metisMenu/jquery.metisMenu.js"></script>
<script src="theme/js/plugins/slimscroll/jquery.slimscroll.min.js"></script>
<script src="theme/js/plugins/layer/layer.min.js"></script>
<script src="theme/js/hplus.min.js?v=4.1.0"></script>
<script type="text/javascript" src="theme/js/contabs.min.js"></script>
<script src="theme/js/plugins/pace/pace.min.js"></script>
<%--
<script src="theme/js/common/handlebars.min.js"></script>--%>
<script>

    $(document).ready(function () {
//        return $("body").removeClass("skin-1"), $("body").removeClass("skin-2"), $("body").removeClass("skin-3");
        return $("body").removeClass("skin-2"), $("body").removeClass("skin-3"), $("body").addClass("skin-1");
//        return $("body").removeClass("skin-1"), $("body").removeClass("skin-2"), $("body").addClass("skin-3");
    });

</script>
</body>
</html>
