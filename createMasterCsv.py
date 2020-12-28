#!/usr/bin/env python3
# channelsとusersのCSVを作成する
import pandas as pd
import json
import os

files = ['channels','users']

if not (os.path.isdir("output")): 
    os.mkdir("output")

for filename in files:
    with open('data/' + filename +'.json', 'r', encoding='utf-8') as f:
        d = json.loads(f.read())

    df = pd.io.json.json_normalize(d, sep='_')
    new_id = "id"
    new_name = "name"
    if filename == "users":
        new_id = "users_id"
        new_name = "users_name"
    elif filename == "channels":
        new_id = "channels_id"
        new_name = "channels_name"
    df = df.rename(columns={"id": new_id, "name": new_name})
    if filename == 'users':
        df['display_name_custom'] = ""
    
        for index, row in df.iterrows():
            display_name_custom = row['name'] if row['profile_display_name_normalized'] == "" else row['profile_display_name_normalized']
            print(display_name_custom)
            df.at[index, 'display_name_custom'] = display_name_custom
    df.to_csv('output/' + filename +'.csv', encoding='utf_8_sig')
