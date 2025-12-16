public with sharing class DailyLogController {
    public class SaveResult {
        @AuraEnabled public Boolean success;
        @AuraEnabled public Id recordId;
        @AuraEnabled public String error;
    }

    @AuraEnabled
    public static SaveResult saveDailyLog(String jsonData) {
        
        SaveResult result = new SaveResult();
        try {
            if(jsonData == null) {
                result.error = 'Missing input data';
                return result;
            }

            Map<String, Object> data = (Map<String,Object>) JSON.deserializeUntyped(jsonData);
            
            //Required field check
            String dateStr = (String) data.get('Date__c');
            if(String.isBlank(dateStr)) {
                result.error = 'Date is required.';
                return result;
            }

            Daily_Log__c rec = new Daily_Log__c();
            rec.Date__c = Date.valueOf(dateStr);

            if(data.containsKey('Sleep_Hours__c'))
                rec.Sleep_Hours__c = toDecimal(data.get('Sleep_Hours__c'));

            if(data.containsKey('Calories_Burned__c'))
                rec.Calories_Burned__c = toDecimal(data.get('Calories_Burned__c'));

            if(data.containsKey('Meals__c'))
                rec.Meals__c = String.valueOf(data.get('Meals__c'));

            if(data.containsKey('Workout__c'))
                rec.Workout__c = String.valueOf(data.get('Workout__c'));

            if(data.containsKey('Workout_Minutes__c'))
                rec.Workout_Minutes__c = toDecimal(data.get('Workout_Minutes__c'));

            if(data.containsKey('Water_Intake__c'))
                rec.Water_Intake__c = toDecimal(data.get('Water_Intake__c'));

            if(data.containsKey('HRV__c'))
                rec.HRV__c = toDecimal(data.get('HRV__c'));

            if(data.containsKey('RHR__c'))
                rec.RHR__c = toDecimal(data.get('RHR__c'));

            if(data.containsKey('Mood__c'))
                rec.Mood__c = String.valueOf(data.get('Mood__c'));

            if(data.containsKey('Notes__c'))
                rec.Notes__c = String.valueOf(data.get('Notes__c'));

            insert rec;

            result.success = true;
            result.recordId = rec.Id;
        } catch (Exception ex) {
            result.error = ex.getMessage();
        }
        return result;
    }

    @AuraEnabled(cacheable=true)
    public static List<Daily_Log__c> getDailyLogs() {
        return [
            SELECT Id, Date__c, Sleep_Hours__c, Calories_Burned__c, Workout__c,
                    Water_Intake__c, HRV__c, RHR__c, Mood__c, Notes__c,
                    Meals__c, Workout_Minutes__c
            FROM Daily_Log__c
            ORDER BY Date__c DESC
        ];
    }

    private static Decimal toDecimal(Object val) {
        return val == null ? null : Decimal.valueOf(String.valueOf(val));
    }
}