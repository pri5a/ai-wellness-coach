public with sharing class WellnessTrendService {
    @AuraEnabled(cacheable=true)
    public static List<WellnessTrendDTO> getLast7DaysTrends(){
        Date startDate = Date.today().addDays(-6);

        List<Daily_Log__c> logs = [
            SELECT Date__c, Sleep_Hours__c, Water_Intake__c, Workout_Minutes__c
            FROM Daily_Log__c
            WHERE Date__c >= :startDate
            ORDER BY Date__c ASC
        ];

        List<WellnessTrendDTO> results = new List<WellnessTrendDTO>();

        for(Daily_Log__c log : logs){
            WellnessTrendDTO dto = new WellnessTrendDTO();
            dto.logDate = log.Date__c;
            dto.sleep = log.Sleep_Hours__c;
            dto.water = log.Water_Intake__c;
            dto.workoutMinutes = log.Workout_Minutes__c;
            results.add(dto);
        }
        return results;
    }
}