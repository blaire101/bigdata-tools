package com.x.HiveJdbc;

/**
 * Date : 2016-10-20
 * Author : clb
 */

import java.sql.Connection;


import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

public class HiveJdbcClient {

    private static String driverName = "org.apache.hive.jdbc.HiveDriver";

    public boolean run() { // startup HiveServer2 / client beeline

        try {
            Class.forName(driverName);
            Connection con = null;
            con = DriverManager.getConnection(
                    "jdbc:hive2://192.168.181.190:10000/default", "hdfs", "");
            System.out.println("con : " + con);
            Statement stmt = con.createStatement();
            ResultSet res = null;

            String sql = "select count(*) from ods_dm_shopinfo";

            System.out.println("Running: " + sql);
            res = stmt.executeQuery(sql);
            System.out.println("ok");
            while (res.next()) {
                System.out.println(res.getString(1));

            }
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("error");
            return false;
        }

    }

    public static void main(String[] args) throws SQLException {
        HiveJdbcClient hiveJdbcClient = new HiveJdbcClient();
        hiveJdbcClient.run();
    }

}
