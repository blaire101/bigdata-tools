package com.x.user_bhv;

import com.google.common.collect.Maps;
import org.apache.hadoop.hive.ql.exec.UDAF;
import org.apache.hadoop.hive.ql.exec.UDAFEvaluator;

import java.util.HashMap;
import java.util.Map;

public class UDAFMergeIntToDoubleMap extends UDAF {

    public static class PartialResult {
        Map<Integer, Double> attributes;

        PartialResult() {
            attributes = Maps.newHashMap();
        }
    }
//    private static final String[] attribute_item_key = {"ages", "gender", "com_its", "crowds", "attachments", "zones"};

    public static class UnitIdUDAFEvaluator implements UDAFEvaluator {
        private PartialResult partialResult;

        public UnitIdUDAFEvaluator() {
            super();
            init();
        }

        public void init() {
            System.out.println("map init");
            partialResult = new PartialResult();
        }

        public boolean iterate(Map<Integer, Double> attributes_args) {
            if (attributes_args == null || attributes_args.isEmpty()) {
                return true;
            }

            for (Map.Entry<Integer, Double> entry : attributes_args.entrySet()) {
                this.partialResult.attributes.put(entry.getKey(), entry.getValue());
            }
            return true;
        }

        public PartialResult terminatePartial() {
            return this.partialResult;
        }

        /**
         * reduce road
         *
         * @param other
         * @return
         */

        public boolean merge(PartialResult other) { // 参数不可能为 null

            for (Map.Entry<Integer, Double> entry : other.attributes.entrySet()) {
                this.partialResult.attributes.put(entry.getKey(), entry.getValue());
            }

            return true;
        }

        public Map<Integer, Double> terminate() {
            if (partialResult == null) {
                return new HashMap<Integer, Double>();
            } else {
                return this.partialResult.attributes;
            }
        }
    }

    public static void main(String[] args) {
//        // TODO Auto-generated method stub
//        UnitIdUDAFEvaluator evaluator_1 = new UnitIdUDAFEvaluator();
//        UnitIdUDAFEvaluator evaluator_2 = new UnitIdUDAFEvaluator();
//
//        HashMap<BigInteger, Decimal> map1 = Maps.newHashMap();
//        HashMap<BigInteger, Decimal> map2 = Maps.newHashMap();
//        HashMap<BigInteger, Decimal> map3 = Maps.newHashMap();
//
//
//        BigInteger bi1 = new BigInteger("121212");
//        Decimal di1 = new Decimal('12.0');
//
//        map1.put(new BigInteger("121212"), new Decimal(12.0));
//        map1.put(new BigInteger("121212"), 2.0);
//
//        map2.put(1212, 3.0);
//        map2.put(12, 13.0);
//
//        evaluator_1.iterate(map1);
//        System.out.println(evaluator_1.terminate());
//        map1.put(12, 112.0);
//        System.out.println(evaluator_1.terminate());
//
//        System.out.println("--+++++----");
//        System.out.println(evaluator_1.partialResult);
//        evaluator_2.iterate(map2);
//        evaluator_2.merge(evaluator_1.partialResult);
//
//        System.out.println("evaluator_2 after merge:");
//        System.out.println(evaluator_2.terminate());
    }

}
