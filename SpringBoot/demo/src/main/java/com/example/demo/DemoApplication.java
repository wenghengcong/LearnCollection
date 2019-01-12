package com.example.demo;

import org.mybatis.spring.annotation.MapperScan;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

//		src/main/java下的程序入口：Chapter1Application
//		src/main/resources下的配置文件：application.properties
//		src/test/下的测试入口：Chapter1ApplicationTests

@SpringBootApplication(scanBasePackages = "com.example.*")
@MapperScan(basePackages = { "com.example.mapper" }, sqlSessionFactoryRef = "sqlSessionFactory")
public class DemoApplication {

	public static void main(String[] args) {
		SpringApplication.run(DemoApplication.class, args);
	}

}
