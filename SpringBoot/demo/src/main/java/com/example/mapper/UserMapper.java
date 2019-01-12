package com.example.mapper;

import com.example.dao.User;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

/**
 * @App: demo
 * @Description: ${DESCRIPTION}
 * @Author: wenghengcong Created by IntelliJ IDEA
 * @Create: 2018-03-27 18:28
 * @Version: 1.0.0
 **/
@Mapper
public interface UserMapper {

    @Select("SELECT * FROM USER WHERE NAME = #{name}")
    User findByName(@Param("name") String name);

    @Insert("INSERT INTO USER(NAME, AGE) VALUES(#{name}, #{age})")
    int insert(@Param("name") String name, @Param("age") Integer age);

}
