import psycopg2
import subprocess

def main():
    # Upload the file to the server and store at /temp
    subprocess.run(["scp", "complaints.csv", "scadl:/tmp/"])

    # Rename the file to be somethinig with date

    connection = psycopg2.connect(
        host="localhost",
        database="scadl",
        user="postgres",
        password="password"
    )

    cur = connection.cursor()

    # Take a backup of the db

    # Change previous week label to empty
    cur.execute("UPDATE complaints set week_label = '' where week_label = 'previous'")

    # Change current week label to previous
    cur.execute("UPDATE complaints set week_label = 'previous' where week_label = 'current'")

    # Insert this week's data from the file uploaded

    # Change week label to current 


    # cur.execute('SELECT * from complaints')
    # db_version = cur.fetchall()
    # print(db_version)
    
    cur.close()

    return

if __name__ == "__main__":
    main()