import os
import pandas as pd
import mysql.connector
from dotenv import load_dotenv

load_dotenv()

MYSQL_HOST = os.getenv("MYSQL_HOST")
MYSQL_USER = os.getenv("MYSQL_USER")
MYSQL_PASSWORD = os.getenv("MYSQL_PASSWORD")
MYSQL_DATABASE = os.getenv("MYSQL_DATABASE")

conn = mysql.connector.connect(
    host=MYSQL_HOST,
    user=MYSQL_USER,
    password=MYSQL_PASSWORD,
    database=MYSQL_DATABASE
)
cursor = conn.cursor()

match_types = {
    "ipl": "ipl_matches",
    "odi": "odi_matches",
    "t20": "t20_matches",
    "test": "test_matches"
}

base_dir = os.path.abspath(os.path.join(os.path.dirname(__file__), '..'))
data_dir = os.path.join(base_dir, 'data')

def insert_csv_to_table(csv_path, table_name):
    df = pd.read_csv(csv_path)

    for _, row in df.iterrows():
        values = tuple(
            None if pd.isna(x) else str(x)
            for x in [
                row['match_id'], row['date'], row['match_type'],
                row['team1'], row['team2'], row['venue'],
                row['city'], row['toss_winner'], row['winner']
            ]
        )

        sql = f"""
        INSERT IGNORE INTO {table_name} (
            match_id, date, match_type, team1, team2, venue,
            city, toss_winner, winner
        ) VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s)
        """

        cursor.execute(sql, values)

    conn.commit()
    print(f"Inserted data into `{table_name}`")

for match_key, table in match_types.items():
    file_path = os.path.join(data_dir, f"{match_key}_matches.csv")
    if os.path.exists(file_path):
        insert_csv_to_table(file_path, table)
    else:
        print(f"CSV not found: {file_path}")

cursor.close()
conn.close()
print("All done.")
