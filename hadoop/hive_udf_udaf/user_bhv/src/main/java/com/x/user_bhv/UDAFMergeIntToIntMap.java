package com.x.user_bhv;

import com.google.common.collect.Maps;
import org.apache.hadoop.hive.ql.exec.UDAF;
import org.apache.hadoop.hive.ql.exec.UDAFEvaluator;

import java.util.HashMap;
import java.util.Map;

public class UDAFMergeIntToIntMap extends UDAF {

    public static class PartialResult {
        Map<Integer, Integer> attributes;

        PartialResult() {
            attributes = Maps.newHashMap();
        }
    }

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

        public boolean iterate(Map<Integer, Integer> attributes_args) {

            if (attributes_args == null || attributes_args.isEmpty()) {
                return true;
            }

            for (Map.Entry<Integer, Integer> entry : attributes_args.entrySet()) {
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

            for (Map.Entry<Integer, Integer> entry : other.attributes.entrySet()) {
                this.partialResult.attributes.put(entry.getKey(), entry.getValue());
            }

            return true;
        }

        public Map<Integer, Integer> terminate() {
            if (partialResult == null) {
                return new HashMap<Integer, Integer>();
            } else {
                return this.partialResult.attributes;
            }
        }
    }

    public static void main(String[] args) {
        // TODO Auto-generated method stub
        UnitIdUDAFEvaluator evaluator_1 = new UnitIdUDAFEvaluator();
        UnitIdUDAFEvaluator evaluator_2 = new UnitIdUDAFEvaluator();

        HashMap<Integer, Integer> map1 = Maps.newHashMap();
        HashMap<Integer, Integer> map2 = Maps.newHashMap();
        HashMap<Integer, Integer> map3 = Maps.newHashMap();

        map1.put(121212, 12);
        map1.put(1212, 2);

        map2.put(1212, 3);
        map2.put(12, 13);

        evaluator_1.iterate(map1);
        System.out.println(evaluator_1.terminate());
        map1.put(12, 112);
        System.out.println(evaluator_1.terminate());

        System.out.println("--+++++----");
        System.out.println(evaluator_1.partialResult);
        evaluator_2.iterate(map2);
        evaluator_2.merge(evaluator_1.partialResult);

        System.out.println("evaluator_2 after merge:");
        System.out.println(evaluator_2.terminate());
    }

}
