public with sharing class WellnessInsightService {
    @AuraEnabled
    public static List<WellnessInsightDTO> analyzeTrends() {
        List<WellnessTrendDTO> data = WellnessTrendService.getLast7DaysTrends();

        if(data.size() < 4) {
            return new List<WellnessInsightDTO>();
        }

        Integer mid = data.size() / 2;

        //Totals
        Decimal earlySleep = 0, lateSleep = 0;
        Decimal earlyWater = 0, lateWater = 0;
        Decimal earlyWorkout = 0, lateWorkout = 0;

        for(Integer i = 0; i < data.size(); i++){
            WellnessTrendDTO d = data[i];

            if(i < mid) {
                earlySleep += d.sleep != null ? d.sleep : 0;
                earlyWater += d.water != null ? d.water : 0;
                earlyWorkout += d.workoutMinutes != null ? d.workoutMinutes : 0;
            } else {
                lateSleep += d.sleep != null ? d.sleep : 0;
                lateWater += d.water != null ? d.water : 0;
                lateWorkout += d.workoutMinutes != null ? d.workoutMinutes : 0;
            }
        }

        List<WellnessInsightDTO> insights = new List<WellnessInsightDTO>();

        //Sleep Insight
        insights.add(
            buildInsight(
                'Sleep',
                lateSleep > earlySleep,
                'Your sleep duration has imporved over the past few days. Great consistency!',
                'Your sleep has dropped recently. Try prioritizing rest and winding down earlier.'
            ));

        //Hydration Insight
        insights.add(buildInsight(
            'Hydration',
            lateWater > earlyWater,
            'You are drinking more water consistently. Hydration habits are improving!',
            'Your water intake has decreased. Aim for steady hydration throughout the day.'
        ));

        //Workout Insight
        insights.add(buildInsight(
            'Workout',
            lateWorkout > earlyWorkout,
            'Your activity levels are increasing. Keep up the momentum!',
            'Workout time has dipped recently. Try adding short, consistent sessions.'
        ));

        return insights;
    }

    private static WellnessInsightDTO buildInsight(String metric, Boolean isImproving, String positiveMsg, String negativeMsg) {
        WellnessInsightDTO dto = new WellnessInsightDTO();
        dto.metric = metric;
        dto.trend = isImproving ? 'Improving' : 'Declining';
        dto.message = isImproving ? positiveMsg : negativeMsg;
        return dto;
    }
}