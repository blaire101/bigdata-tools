package com.x.service;


import com.x.util.EsHandler;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;


/**
 * Date : 2016-08-23
 */
public class HelloService {

    public static HelloService instance = new HelloService();

    public static HelloService getInstance() {
        return instance;
    }

    private static Logger logger = LoggerFactory.getLogger(HelloService.class);

    private HelloService() {
    }

    public void run() {

        System.out.println("start...");

        String typeUrl = "http://username:passwd@192.168.181.196:9200/test/libin7/_mapping";
        String typeDDL= "{\"libin7\":{\"properties\":{\"created\":{\"type\":\"multi_field\",\"fields\":{\"created\":{\"type\":\"string\"},\"date\":{\"type\":\"date\"}, \"shop_full_name\":{\"type\":\"string\", \"index\":\"not_analyzed\"}}}}}}";


        try {
            EsHandler.getInstance().getElasticSearchHandler().createType(typeUrl, typeDDL);
//            EsHandler.getInstance().getElasticSearchHandler().createIndexTest();

        } catch (IOException e) {
            logger.error("IOException : {}", e.getMessage());
        }

        System.out.println("end...");

        return;
    }


}
