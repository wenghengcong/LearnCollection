package com.example.demo;

import com.example.dao.User;
import com.example.mapper.UserMapper;
import org.junit.Assert;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.annotation.Rollback;
import org.springframework.test.context.junit4.SpringRunner;
import org.springframework.test.context.web.WebAppConfiguration;

/**
 * @App: demo
 * @Description: ${DESCRIPTION}
 * @Author: wenghengcong Created by IntelliJ IDEA
 * @Create: 2018-03-27 18:30
 * @Version: 1.0.0
 **/
@RunWith(SpringRunner.class)
// 新版的Spring Boot取消了@SpringApplicationConfiguration这个注解，用@SpringBootTest就可以了
@SpringBootTest
//  SpringJunit支持,需要引入Spring-Test框架
//  Web项目,Junit需要模拟ServletContext,因此需要给测试类上加上@WebAppConfiguration
@WebAppConfiguration
public class UserMapperTest {
    @Autowired
    private UserMapper userMapper;

    @Test
    @Rollback
    public void findByName() throws Exception {
        userMapper.insert("AAA", 20);
        User u = userMapper.findByName("AAA");
        Assert.assertEquals(20, u.getAge().intValue());
    }
}
