import argparse
import os
import sys
import oracledb

def main():
    parser = argparse.ArgumentParser(description="Run SQL against Oracle database")
    parser.add_argument("sql_file", help="SQL file to execute")
    parser.add_argument("--out", help="Output file for results")
    parser.add_argument("--format", choices=["csv", "json", "table"], default="table", help="Output format")
    args = parser.parse_args()

    # Set environment variables for Oracle client
    os.environ["ORACLE_HOME"] = "C:\\Oracle\\instantclient_19_3"
    os.environ["TNS_ADMIN"] = os.path.join(os.path.dirname(os.path.abspath(__file__)), ".dbt")
    os.environ["PATH"] = "C:\\Oracle\\instantclient_19_3;" + os.environ.get("PATH", "")

    # Get password from environment variable
    password = os.environ.get("DBT_ORACLE_PASSWORD")
    if not password:
        print("Error: Environment variable DBT_ORACLE_PASSWORD not set.")
        sys.exit(1)

    try:
        # Initialize thick mode
        oracledb.init_oracle_client(lib_dir="C:\\Oracle\\instantclient_19_3")
        print("Oracle client initialized in thick mode")

        # Read the profiles.yml to get connection info
        profile_path = os.path.join(os.path.dirname(os.path.abspath(__file__)), ".dbt", "profiles.yml")
        if not os.path.exists(profile_path):
            print(f"Error: Profile file not found at {profile_path}")
            sys.exit(1)

        # Connect using the connection parameters
        connection = oracledb.connect(
            user="vmanchik",
            password=password,
            dsn="10.232.113.104:1521/DWHDB.nocccd.edu"
        )

        print(f"Connected to Oracle Database {connection.version}")

        # Read SQL file
        if not os.path.exists(args.sql_file):
            print(f"Error: SQL file not found: {args.sql_file}")
            sys.exit(1)

        with open(args.sql_file, 'r') as file:
            sql = file.read()

        # Execute SQL
        cursor = connection.cursor()
        cursor.execute(sql)

        # Fetch results
        if cursor.description:
            columns = [desc[0] for desc in cursor.description]
            rows = cursor.fetchall()

            # Format output
            if args.format == "table":
                # Print as formatted table
                col_width = [max(len(str(x)) for x in col) for col in zip(columns, *([str(cell) for cell in row] for row in rows))]
                format_str = " | ".join(["{:<" + str(width) + "}" for width in col_width])

                print(format_str.format(*columns))
                print("-" * (sum(col_width) + len(col_width) * 3))

                for row in rows:
                    print(format_str.format(*[str(cell) for cell in row]))

            elif args.format == "csv":
                import csv
                output_file = args.out if args.out else args.sql_file + ".csv"

                with open(output_file, 'w', newline='') as csvfile:
                    writer = csv.writer(csvfile)
                    writer.writerow(columns)
                    writer.writerows(rows)
                print(f"Results written to {output_file}")

            elif args.format == "json":
                import json
                output_file = args.out if args.out else args.sql_file + ".json"

                results = []
                for row in rows:
                    result = {}
                    for i, col in enumerate(columns):
                        result[col] = row[i]
                    results.append(result)

                with open(output_file, 'w') as jsonfile:
                    json.dump(results, jsonfile, indent=2)
                print(f"Results written to {output_file}")

        print(f"SQL executed successfully: {cursor.rowcount if cursor.rowcount > 0 else 0} rows affected")
        cursor.close()
        connection.close()

    except Exception as e:
        print(f"Error: {e}")
        sys.exit(1)

if __name__ == "__main__":
    main()
