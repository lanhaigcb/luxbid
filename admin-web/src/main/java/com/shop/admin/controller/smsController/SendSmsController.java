package com.shop.admin.controller.smsController;

import com.google.common.base.Strings;
import com.shop.admin.controller.BaseController;
import com.shop.admin.model.staff.Staff;
import com.shop.admin.service.staff.StaffService;
import com.shop.admin.util.RedisUtil;
import com.shop.admin.util.SendSmsUtil;
import com.mine.util.generate.GenerateUtil;
import org.hibernate.envers.Audited;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.Map;

/**
 */
@Controller
@Scope(BaseController.REQUEST_SCOPE)
public class SendSmsController extends BaseController {


    @Autowired
    private RedisUtil redisUtil;

    @Autowired
    private StaffService staffService;

    @RequestMapping("sms/loginSend")
    @ResponseBody
    public Map<String, Object> sendBackLoginSMS(String loginName) {

        if (Strings.isNullOrEmpty(loginName)) {
            result = false;
            message = "账号不能为空";
            return getResultMap();
        }
        Staff staff = staffService.getByName(loginName);
        if (null != staff) {
            String random = GenerateUtil.generateNumber(6);
            String key = buildBackLoginKey(loginName);
            redisUtil.set(key, random, 600);
            SendSmsUtil.sendNotify(staff.getMobile(), "您的登录验证码为：" + random + "，非本人操作，请及时联系管理员。");
            result =true;
            message="发送成功";
            return getResultMap();
        }
        result = false;
        message="请勿非法操作!";
        return getResultMap();
    }


    public static String buildBackLoginKey(String name) {
        return "back:login:" + name;
    }

}
