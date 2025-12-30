package com.spring.config;

import javax.sql.DataSource;

import org.apache.ibatis.session.SqlSessionFactory;
import org.mybatis.spring.SqlSessionFactoryBean;
import org.mybatis.spring.annotation.MapperScan;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.io.support.PathMatchingResourcePatternResolver;
import org.springframework.jdbc.datasource.DataSourceTransactionManager;
import org.springframework.transaction.annotation.EnableTransactionManagement;

import com.zaxxer.hikari.HikariConfig;
import com.zaxxer.hikari.HikariDataSource;

@Configuration
@ComponentScan(basePackages = "com.spring")
@MapperScan(basePackages = "com.spring.mapper")
@EnableTransactionManagement
public class RootConfig {

	@Bean
	public DataSource dataSource() {
		HikariConfig cfg = new HikariConfig();
		cfg.setDriverClassName("com.mysql.cj.jdbc.Driver");
		cfg.setJdbcUrl("jdbc:mysql://localhost:3306/movie?serverTimezone=Asia/Seoul&characterEncoding=UTF-8");
		cfg.setUsername("root");
		cfg.setPassword("1234"); // 환경에 맞게 수정
		return new HikariDataSource(cfg);
	}

	@Bean
	public SqlSessionFactory sqlSessionFactory(DataSource dataSource) throws Exception {
		SqlSessionFactoryBean factory = new SqlSessionFactoryBean();
		factory.setDataSource(dataSource);
		factory.setMapperLocations(
				new PathMatchingResourcePatternResolver().getResources("classpath:/com/spring/mapper/*.xml"));
		return factory.getObject();
	}

	@Bean
	public DataSourceTransactionManager txManager(DataSource dataSource) {
		return new DataSourceTransactionManager(dataSource);
	}
}
