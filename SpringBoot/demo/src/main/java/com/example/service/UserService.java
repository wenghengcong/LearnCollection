package com.example.service;

/**
 * @App: demo
 * @Description: ${DESCRIPTION}
 * @Author: wenghengcong Created by IntelliJ IDEA
 * @Create: 2018-03-27 15:49
 * @Version: 1.0.0
 **/
public interface UserService {
    /**
     * 新增一个用户
     * @param name
     * @param age
     */
    void create(String name, Integer age);

    /**
     * 根据name删除一个用户高
     * @param name
     */
    void deleteByName(String name);

    /**
     * 获取用户总量
     */
    Integer getAllUsers();

    /**
     * 删除所有用户
     */
    void deleteAllUsers();
}
