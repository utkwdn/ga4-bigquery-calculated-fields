-- ================================== DIMENSIONS ==============================================

-- Dimension: Campaign

CASE  
WHEN session_campaign IS NOT NULL AND session_campaign != '(not set)' THEN session_campaign  
WHEN session_medium = 'organic' THEN '(organic)'  
WHEN session_source = 'direct' AND session_medium = '(none)' THEN '(direct)' WHEN session_medium = 'referral' THEN '(referral)'  
WHEN session_medium = 'cpc' OR session_medium = 'ppc' THEN '(cpc)'  
WHEN session_medium = 'email' THEN '(email)'  
WHEN session_medium = 'social' THEN '(social)'  
ELSE 'null'  
END 

-- Dimension: Hostname

CASE  
WHEN Device Category = 'desktop' or Device Category = 'mobile' or Device Category = 'tablet'  
THEN device.web_info.hostname  
END  

-- Dimension: Landing Page

CASE  
WHEN Event Name = 'session_start' AND REGEXP_CONTAINS(Page Location, 'https?://[^/]+(/[^?]*)')  
THEN IFNULL(REGEXP_EXTRACT(Page Location, 'https?://[^/]+(/[^?]*)'), '/') 
ELSE '(not set)'  
END 

-- ==== Note: Make sure to filter out landing pages that return “(not set)” in tables. ====

-- Dimension: Page Location

CASE 
WHEN Event Param Name = 'page_location' THEN Event Param Value (String) 
END

-- Dimension: Page Path

IFNULL(REGEXP_EXTRACT(Page Location, 'https://[^/]+(/[^?]*)'), '(not set)') 

-- Dimension: Session Campaign

CASE  
WHEN traffic_source.name IS NOT NULL  
THEN traffic_source.name  
ELSE '(not set)'  
END 

-- Dimension: Session Default Channel Group

CASE  
WHEN REGEXP_CONTAINS(Session Source,'360|aol|baidu|biglobe|bing|chatgpt|daum|dogpile|duckduckgo|ecosia|google|msn|naver|postcard|qwant|so|sogou|terra|yahoo|yandex') and Session Medium in ('organic', 'referral') then 'Organic Search' 
WHEN Session Source = '(direct)' AND Session Medium = '(none)' THEN 'Direct' 
WHEN REGEXP_CONTAINS(Session Source, 'blogspot|buzzfeed|co|facebook|fb|getpocket|glassdoor|google|hootsuite|ig|instagram|linkedin|lnkd|medium|messenger|meta|naver|pinterest|quora|reddit|researchgate|scribd|skype|sm|snapchat|social|tiktok|twitter|typepad|weebly|wordpress|yelp|zalo') and Session Medium in ('Facebook_Desktop_Feed', 'Facebook_Mobile_Feed', 'Facebook_Right_Column', 'Instagram_Feed', 'Instagram_Stories', 'meta', 'referral', 'social', 'zalo') then 'Organic Social' 
WHEN REGEXP_CONTAINS(Session Source, 'bing|google|niche|searchall') and Session Medium in ('cpc', 'paid_ad', 'paidsearch') then 'Paid Search' 
WHEN REGEXP_CONTAINS(Session Source, 'Facebook|facebook|fb|Instagram|instagram|ig|LinkedIn|linkedin|Meta|meta|paid|prospect|Reddit|reddit|Snapchat|snapchat|Tiktok|tiktok') and Session Medium in ('awareness', 'fb', 'ig', 'paid', 'paid_ad', 'paid_social', 'paidsocial', 'ppc') then 'Paid Social' 
WHEN REGEXP_CONTAINS(Session Source, 'tradedesk|usat|youtube') and Session Medium in ('ottctv', 'paidvideo') then 'Paid Video' 
WHEN REGEXP_CONTAINS(Session Source, 'prospect') and REGEXP_CONTAINS(Session Medium, 'affiliate') then 'Affiliate' 
WHEN Session Medium = 'display' then 'Display' 
WHEN Session Medium = 'referral' then 'Referral' 
WHEN Session Medium in ('crm_email', 'direct-mail', 'email', 'newsletter', 'slate_email') then 'Email' 
WHEN Session Medium in ('print', 'Print', 'Print Ad', 'Print Advertisement', 'print-mailer') then 'Print' 
WHEN REGEXP_CONTAINS(Session Source, 'youtube') and Session Medium = 'referral' then 'Organic Video' 
ELSE 'Unassigned' 
END 

-- ==== Note: It's recommended that you modify this query depending on your specific GA4 property data. ====

-- Dimension: Session Medium

CASE  
WHEN traffic_source.medium IS NOT NULL  
THEN traffic_source.medium  
ELSE '(none)'  
END 

-- Dimension: Session Source

CASE  
WHEN traffic_source.source IS NOT NULL  
THEN traffic_source.source  
ELSE '(direct)'  
END 

-- Dimension: Session Source Medium

CASE  
WHEN traffic_source.name IS NOT NULL  
THEN CONCAT(traffic_source.source, ' / ', traffic_source.medium)  
END 

-- ================================== METRICS ==============================================

-- Metric: Clicks to Applications

CASE  
WHEN Event Name = 'click_application_undergrad' or Event Name = 'click_application_grad' THEN User Pseudo ID 
END

-- Metric: Engaged Sessions

CASE 
WHEN Event Param Name = 'session_engaged'  
THEN Event Param Value 
END 

-- Metric: Form Submissions 

CASE 
WHEN Event Name = 'form_submit_undergrad_rfi' or Event Name = 'form_submit_grad_rfi' THEN User Pseudo ID 
END 

-- Metric: Form Submission Rate

COUNT(DISTINCT Sessions with Form Submissions) / COUNT(DISTINCT Session(CONCAT)) 

-- Metric: Sessions (Integer Values)

CONCAT(CASE WHEN Event Param Name = 'ga_session_id' THEN Event Param Value END, User Pseudo ID) 

-- Metric: Session ID

CONCAT(User Pseudo ID, "-", CAST(FLOOR((UNIX_DATE(Event Time) / 1000)) AS STRING)) 

-- Metric: Sessions with Form Submissions

CASE  
WHEN Event Name IN ('form_submit_undergrad_rfi', 'form_submit_grad_rfi')  
THEN Session ID  
END 

-- Metric: Total Users

COUNT_DISTINCT(User Pseudo ID) 

-- Metric: Total Users (String Values)

CASE 
WHEN Event Name = 'page_view' AND Event Param Name = 'page_location' 
THEN User Pseudo ID 
END 

-- ==== Note: Use this metric when Page Path or Page Path + Query String is a dimension. ====

-- Metric: Views (Integer Values)

CASE  
WHEN Event Name = 'page_view' AND Event Param Name = 'ga_session_id'   
THEN Event Param Value  
END 

-- Metric: Views (String Values)

CASE  
WHEN Event Name = 'page_view' AND Event Param Name = 'page_location'   
THEN Event Param (String)  
END 

-- ==== Note: Use this metric when Page Path or Page Path + Query String is a dimension. ==== 