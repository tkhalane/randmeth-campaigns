package com.tdk.randmeth.campaigns

import org.springframework.boot.autoconfigure.SpringBootApplication
import org.springframework.boot.runApplication
import org.springframework.context.annotation.Bean
import springfox.documentation.builders.ApiInfoBuilder
import springfox.documentation.builders.PathSelectors
import springfox.documentation.builders.RequestHandlerSelectors
import springfox.documentation.spi.DocumentationType
import springfox.documentation.spring.web.plugins.Docket
import springfox.documentation.swagger2.annotations.EnableSwagger2

@SpringBootApplication
//@EnableEurekaClient
@EnableSwagger2
class CampaignsApplication

fun main(args: Array<String>) {
    runApplication<CampaignsApplication>(*args)
}

@Bean
fun swaggerApi(): Docket {
    return  Docket(DocumentationType.SWAGGER_2)
            .select()
            .apis(RequestHandlerSelectors.basePackage("com.tdk.randmeth.campaigns.rest"))
            .paths(PathSelectors.any())
            .build()
            .apiInfo(ApiInfoBuilder()
                    .version("1.0")
                    .title("Campaigns services")
                    .description("Documentation Campaigns API v1.0").build()
            )
}