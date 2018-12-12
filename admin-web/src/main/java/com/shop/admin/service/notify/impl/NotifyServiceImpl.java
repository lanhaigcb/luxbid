package com.shop.admin.service.notify.impl;

import com.mine.common.enums.IdInfoStatus;
import com.mine.common.vo.CustomerVo;
import com.mine.common.vo.IdInfoVo;
import com.shop.admin.service.notify.NotifyService;
import com.mine.ex.message.rabbitmq.SenderService;
import com.mine.userservice.IdInfoService;
import com.mine.userservice.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

/**
 */
@Service
public class NotifyServiceImpl implements NotifyService {

    private static final String ID_PASS_NOTIFY= "恭喜您认证成功BihuEx,如有问题请添加客服咨询，享受更多优质服务。";

    @Autowired
    private UserService userService;

    @Autowired
    private SenderService senderService;

    @Autowired
    private IdInfoService infoService;

    public void sendIdCardPassNotifyWithAuditInfoId(Integer infoId){
        IdInfoVo idInfoVo = infoService.findById(infoId);
        if(null != idInfoVo && idInfoVo.getIdInfoStatus().equals(IdInfoStatus.PASS)){
            CustomerVo customerVo = userService.getCustomerById(idInfoVo.getCustomerId());
            if(null != customerVo){
                if(null != customerVo.getMobile()){
                    senderService.sendIdCardPassNotify(customerVo.getMobile(),ID_PASS_NOTIFY);
                }
            }
        }
    }
}
