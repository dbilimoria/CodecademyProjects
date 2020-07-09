import codecademylib
import pandas as pd

ad_clicks = pd.read_csv('ad_clicks.csv')

print(ad_clicks.head())

views = ad_clicks.groupby('utm_source').user_id.count().reset_index()

ad_clicks['is_click'] = ~ad_clicks\
   .ad_click_timestamp.isnull()

print(ad_clicks)

clicks_by_source = ad_clicks.groupby(['utm_source', 'is_click']).user_id.count().reset_index()

print(clicks_by_source)

clicks_pivot = clicks_by_source.pivot( columns = 'is_click',
index = 'utm_source', values = 'user_id').reset_index()


clicks_pivot['percent_clicked'] = 100.0 * ((clicks_pivot[True])/(clicks_pivot[True]+ clicks_pivot[False]))


print(clicks_pivot) 

count_experimental = ad_clicks.groupby('experimental_group').user_id.count().reset_index

print(count_experimental)

clicks_by_count_experimental = ad_clicks.groupby(['experimental_group', 'is_click']).user_id.count().reset_index()

print(clicks_by_count_experimental)

clicks_by_count_experimental_pivot = clicks_by_count_experimental.pivot (columns = 'is_click',
index = 'experimental_group', values = 'user_id').reset_index()

clicks_by_count_experimental_pivot['percent_clicked'] = 100.0 * ((clicks_by_count_experimental_pivot[True])/(clicks_by_count_experimental_pivot[True]+ clicks_by_count_experimental_pivot[False]))

print(clicks_by_count_experimental_pivot)

a_clicks = ad_clicks[ad_clicks.experimental_group == 'A']

b_clicks = ad_clicks[ad_clicks.experimental_group == 'B']

a_clicks_count = a_clicks.groupby(['day','is_click']).user_id.count().reset_index()

a_clicks_pivot = a_clicks_count.pivot (columns = 'is_click' , index = 'day', values = 'user_id').reset_index()

a_clicks_pivot['percent clicked'] = 100.0 * ((a_clicks_pivot[True])/(a_clicks_pivot[True]+ a_clicks_pivot[False]))

b_clicks_count = b_clicks.groupby(['day','is_click']).user_id.count().reset_index()

b_clicks_pivot = b_clicks_count.pivot (columns = 'is_click' , index = 'day', values = 'user_id').reset_index()

b_clicks_pivot['percent clicked'] = 100.0 * ((b_clicks_pivot[True])/(b_clicks_pivot[True]+ b_clicks_pivot[False]))

print(a_clicks_pivot)
print(b_clicks_pivot)

#I recomment that the company use Ad A
