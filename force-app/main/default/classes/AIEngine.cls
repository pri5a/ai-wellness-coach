public with sharing class AIEngine {

    @AuraEnabled(cacheable=true)
    public static String generateDailyFeedback(Id dailyLogId) {
        if(dailyLogId == null) {
            throw new AuraHandledException('dailyLogId is required.');
        }

        try {
            Daily_Log__c log = [
            SELECT Date__c, Meals__c, Sleep_Hours__c, Calories_Burned__c,
                    Workout__c, Water_Intake__c, HRV__c, RHR__c,
                    Mood__c, Notes__c
            FROM Daily_Log__c
            WHERE Id = :dailyLogId
            LIMIT 1
            ];

            // Future: user profile driven
            String userGoal = 'Fat Loss';

            List<String> feedback = new List<String>();
            feedback.add('Your AI Wellness Check-In (' + log.Date__c +')');
            feedback.add('');

            addHighlights(log, feedback);
            addGoalBasedInsights(log, userGoal, feedback);
            addRecoveryInsights(log, feedback);
            addNextDayActions(log, feedback);

            feedback.add('');
            feedback.add('Remember: consistency beats perfection.');

            return String.join(feedback, '\n');
        } catch(Exception e) {
            throw new AuraHandledException('Unable to generate feedback. Please try again.');
        }
    }

    /* Helper Methods */

    private static void addHighlights(Daily_Log__c log, List<String> fb) {
        fb.add('What you did well:');

        if(log.Sleep_Hours__c != null && log.Sleep_Hours__c >= 7)
            fb.add('- Solid sleep duration ');

        if(log.Water_Intake__c != null && log.Water_Intake__c >= 2000)
            fb.add('- Good hydration levels');
        
        if(log.Calories_Burned__c != null && log.Calories_Burned__c >= 300)
            fb.add('- Active day with decent calorie burn');

        if(fb.size() == 2)
            fb.add('- You showed up - that matters');

        fb.add('');
    }

    private static void addGoalBasedInsights(Daily_Log__c log, String goal, List<String> fb) {
        fb.add('Goal Focus: ' + goal);

        if(goal == 'Fat Loss' && log.Calories_Burned__c != null){
            if(log.Calories_Burned__c < 250)
                fb.add('- Slightly low activity today. Add a walk tomorrow.');
            else
                fb.add('- Activity supports fat loss. Keep momentum.');
        }
        fb.add('');
    }

    private static void addRecoveryInsights(Daily_Log__c log, List<String> fb){
        fb.add('Recovery and Readiness:');

        if(log.HRV__c != null && log.HRV__c < 40)
            fb.add('- HRV is low. Prioritize recovery.');
        
        if(log.RHR__c != null && log.RHR__c > 80)
            fb.add('- Elevated resting HR detected.');

        if(log.Sleep_Hours__c != null && log.Sleep_Hours__c < 6)
            fb.add('- Sleep debt detected. Aim earlier bedtime.');

        fb.add('');
    }

    private static void addNextDayActions(Daily_Log__c log, List<String> fb) {
        fb.add('Tomorrow\'s Action Plan:');
        fb.add('- Drink 2-2.5L water');
        fb.add('- 20-30 minutes light activity');
        fb.add('- Screen-free wind-down before sleep');

        if(String.isNotBlank(log.Mood__c) && log.Mood__c == 'low')
            fb.add('- Add one small win early in the day');
        
        fb.add('');
    }
}