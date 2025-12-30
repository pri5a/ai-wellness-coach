public with sharing class WellnessAISummaryService {
    @AuraEnabled(cacheable=true)
    public static String generateWeeklySummary(){
        List<WellnessInsightDTO> insights = WellnessInsightService.analyzeTrends();

        if(insights == null || insights.isEmpty()){
            return 'Not enough data yet. Log at least 4-5 days to receive AI insights.';
        }

        List<String> strengths = new List<String>();
        List<String> risks = new List<String>();

        for(WellnessInsightDTO i : insights){
            if(i.trend == 'Improving'){
                strengths.add(i.metric);
            } else if(i.trend == 'Declining'){
                risks.add(i.metric);
            }
        }

        List<String> summary = new List<String>();
        summary.add('Weekly AI Wellness Summary');
        summary.add('');

        if(!strengths.isEmpty()){
            summary.add('What\'s going well:');
            for(String s : strengths){
                summary.add('- ' + s + ' is improving');
            }
            summary.add('');
        }

        if(!risks.isEmpty()){
            summary.add('Needs Attention:');
            for(String r : risks){
                summary.add('- ' + r + ' is trending down');
            }
            summary.add('');
        }

        summary.add('Coach Advice: ');

        if(risks.contains('Sleep')){
            summary.add('- Prioritize sleep consistency and evening wind-down.');
        }
        if(risks.contains('Hydration')){
            summary.add('- Increase water intake, especially earlier in the day.');
        }
        if(risks.contains('Workout')){
            summary.add('- Balance activity and recovery to avoid burnout.');
        }

        if(risks.isEmpty()){
            summary.add('- You are in a great rythm. keep doing what works!');
        }

        summary.add('');
        summary.add('Small daily habits compound into long-term results.');

        return String.join(summary, '\n');
    }
}