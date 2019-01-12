package com.example.demo;

import org.junit.Assert;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.junit4.SpringRunner;

/**
 * @App: demo
 * @Description: ${DESCRIPTION}
 * @Author: wenghengcong Created by IntelliJ IDEA
 * @Create: 2018-03-26 22:18
 * @Version: 1.0.0
 **/
@RunWith(SpringRunner.class)
@SpringBootTest
public class ApplicationTests {
    @Autowired
    private BeeFunAppProperties appProperties;

    @Test
    public void getPro() throws Exception {
        Assert.assertEquals(appProperties.getVersion(), "1.0.0");
        Assert.assertEquals(appProperties.getTitle(), "Spring Boot");
    }
}
