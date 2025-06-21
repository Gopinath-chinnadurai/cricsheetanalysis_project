import os
import json
import pandas as pd

BASE_DIR = os.path.abspath(os.path.join(os.path.dirname(__file__), '..'))
MATCHES_DIR = os.path.join(BASE_DIR, 'matches')
DATA_DIR = os.path.join(BASE_DIR, 'data')

os.makedirs(DATA_DIR, exist_ok=True)

match_types = {
    "ipl": "ipl_json",
    "odi": "odis_json",
    "t20": "t20s_json",
    "test": "tests_json"
}

def extract_match_data(json_file):
    with open(json_file, 'r', encoding='utf-8') as f:
        data = json.load(f)

    info = data.get('info', {})
    match_id = os.path.basename(json_file).replace('.json', '')
    match_type = info.get('match_type', '')
    city = info.get('city', '')
    venue = info.get('venue', '')
    teams = info.get('teams', [])
    toss = info.get('toss', {}).get('winner', '')
    winner = info.get('outcome', {}).get('winner', '')
    date = info.get('dates', [''])[0]

    return {
        'match_id': match_id,
        'date': date,
        'match_type': match_type,
        'team1': teams[0] if len(teams) > 0 else '',
        'team2': teams[1] if len(teams) > 1 else '',
        'venue': venue,
        'city': city,
        'toss_winner': toss,
        'winner': winner
    }

for match_type, folder_name in match_types.items():
    folder_path = os.path.join(MATCHES_DIR, folder_name)
    all_matches = []

    for file_name in os.listdir(folder_path):
        if file_name.endswith('.json'):
            json_path = os.path.join(folder_path, file_name)
            try:
                match_data = extract_match_data(json_path)
                all_matches.append(match_data)
            except Exception as e:
                print(f"Error reading {file_name}: {e}")

    df = pd.DataFrame(all_matches)
    output_path = os.path.join(DATA_DIR, f"{match_type}_matches.csv")
    df.to_csv(output_path, index=False)
    print(f"Saved: {output_path}")
