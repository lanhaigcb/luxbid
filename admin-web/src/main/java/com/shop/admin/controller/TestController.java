package com.shop.admin.controller;

import com.mine.supportservice.service.BannerService;
import com.mine.userservice.UserService;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

/**
 * TestController
 */
@Controller
@Scope(BaseController.REQUEST_SCOPE)
public class TestController extends BaseController {

    private static org.slf4j.Logger logger = LoggerFactory.getLogger(TestController.class);

    @Autowired
    private BannerService bannerService;

    @RequestMapping("test")
    @ResponseBody
    public String test(String phase) {
        logger.info("------------------info------------");
//        userService.getCustomerById(1);
        return "success";
    }

//    @RequestMapping("ex")
//    @ResponseBody
//    public Response exception() {
//        logger.error("-----------------error------------");
//
//        PlatformPreconditions.checkArgument(false, CommonResponseCode.COMMON_ILLEGAL_PARAM, "异常测试");
//        return Response.simpleSuccess();
//    }


}
