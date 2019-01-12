package com.example.demo;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

/**
 * The type Bee fun app properties.
 *
 * @App: demo
 * @Description: $ {DESCRIPTION}
 * @Author: wenghengcong Created by IntelliJ IDEA
 * @Create: 2018 -03-26 22:13
 * @Version: 1.0.0
 */
@Component
public class BeeFunAppProperties {

    //@Value("${属性名}")注解来加载对应的配置属性
    @Value("${com.beefun.server.version}")
    private String version;

    @Value("${com.beefun.server.title}")
    private String title;

    /**
     * Gets version.
     *
     * @return the version
     */
    public String getVersion() {
        return version;
    }

    /**
     * Gets title.
     *
     * @return the title
     */
    public String getTitle() {
        return title;
    }

    /**
     * Sets version.
     *
     * @param version the version
     */
    public void setVersion(String version) {
        this.version = version;
    }

    /**
     * Sets title.
     *
     * @param title the title
     */
    public void setTitle(String title) {
        this.title = title;
    }

}
