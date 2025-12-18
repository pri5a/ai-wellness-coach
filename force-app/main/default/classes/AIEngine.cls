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

    // This code make an API call to OpenAI API to generate feedback.
    // Commenting this code because of OpenAI API payment issues.
    // @AuraEnabled
    // public static String generateDailyFeedback(Id dailyLogId) {

    //     if (dailyLogId == null) {
    //         throw new AuraHandledException('Daily Log Id is required');
    //     }

    //     Daily_Log__c log = [
    //         SELECT Sleep_Hours__c, Water_Intake__c, HRV__c, RHR__c,
    //                Calories_Burned__c, Mood__c, Workout__c
    //         FROM Daily_Log__c
    //         WHERE Id = :dailyLogId
    //         LIMIT 1
    //     ];

    //     HttpRequest req = new HttpRequest();
    //     req.setMethod('POST');

    //     // IMPORTANT: Named Credential ONLY (no full URL)
    //     req.setEndpoint('callout:OpenAI/v1/chat/completions');

    //     req.setHeader('Content-Type', 'application/json');

    //     Map<String, Object> body = new Map<String, Object>();
    //     body.put('model', 'gpt-3.5-turbo');

    //     List<Object> messages = new List<Object>();

    //     messages.add(new Map<String, Object>{
    //         'role' => 'system',
    //         'content' => 'You are a wellness coach providing concise feedback.'
    //     });

    //     messages.add(new Map<String, Object>{
    //         'role' => 'user',
    //         'content' =>
    //             'Sleep: ' + log.Sleep_Hours__c +
    //             ', Water: ' + log.Water_Intake__c +
    //             ', HRV: ' + log.HRV__c +
    //             ', RHR: ' + log.RHR__c +
    //             ', Calories: ' + log.Calories_Burned__c +
    //             ', Mood: ' + log.Mood__c +
    //             ', Workout: ' + log.Workout__c
    //     });

    //     body.put('messages', messages);
    //     body.put('temperature', 0.7);

    //     req.setBody(JSON.serialize(body));

    //     Http http = new Http();
    //     HttpResponse res;

    //     try {
    //         res = http.send(req);
    //     } catch (Exception e) {
    //         System.debug('HTTP CALL FAILED: ' + e.getMessage());
    //         throw new AuraHandledException('HTTP callout failed: ' + e.getMessage());
    //     }

    //     System.debug('STATUS CODE: ' + res.getStatusCode());
    //     System.debug('RESPONSE BODY: ' + res.getBody());

    //     if (res.getStatusCode() != 200) {
    //         throw new AuraHandledException(
    //             'OpenAI Error ' + res.getStatusCode() + ': ' + res.getBody()
    //         );
    //     }

    //     Map<String, Object> responseMap =
    //         (Map<String, Object>) JSON.deserializeUntyped(res.getBody());

    //     List<Object> choices = (List<Object>) responseMap.get('choices');
    //     Map<String, Object> message =
    //         (Map<String, Object>) ((Map<String, Object>) choices[0]).get('message');

    //     return (String) message.get('content');
    // }
}

