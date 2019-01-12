package com.example.demo;

import com.example.controller.HelloController;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.http.MediaType;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.request.MockMvcRequestBuilders;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;
import org.springframework.test.context.junit4.SpringRunner;
import org.springframework.test.context.web.WebAppConfiguration;

import static org.hamcrest.Matchers.equalTo;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.content;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@RunWith(SpringRunner.class)
@SpringBootTest
@WebAppConfiguration
public class DemoApplicationTests {

	private MockMvc mvc;

	@Before
	public void  setUp() throws  Exception {
		mvc = MockMvcBuilders.standaloneSetup(new HelloController()).build();
	}

//	注意引入下面内容，让status、content、equalTo函数可用
//	import static org.hamcrest.Matchers.equalTo;
//  import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.content;
//  import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;
	@Test
	public void getHello() throws Exception {
		mvc.perform(MockMvcRequestBuilders.get("/hello").accept(MediaType.APPLICATION_JSON))
				.andExpect(status().isOk())
				.andExpect(content().string(equalTo("Hello Spring Boot!")));
	}

}
